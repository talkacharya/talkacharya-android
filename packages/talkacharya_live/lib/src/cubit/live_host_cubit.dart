import 'dart:async';

import 'package:wakelock_plus/wakelock_plus.dart';

import '../engine/live_call_audio.dart';
import '../models/live_call.dart';
import '../models/live_join.dart';
import '../models/live_state.dart';
import '../models/live_chat_message.dart';
import '../ports/live_ports.dart';
import '../engine/foreground_keep_alive.dart';
import 'live_cubit_base.dart';
import 'screen_awake.dart';

/// Hosting one stream: go live, publish camera + mic, moderate, end.
///
/// Going live is deliberately one step — permissions, then `start`, then publish —
/// so the astrologer is never "live" on the server with nothing being broadcast.
class LiveHostCubit extends LiveCubitBase {
  LiveHostCubit({
    required LiveHostBackend backend,
    required LivePermissions permissions,
    required super.engine,
    required super.signaling,
    required this.userId,
    LiveCallAudio Function()? callAudio,
  }) : _backend = backend,
       _permissions = permissions,
       _callAudio = callAudio ?? LiveKitCallAudio.new,
       super(isHost: true);

  final LiveHostBackend _backend;
  final LivePermissions _permissions;
  final String userId;
  final _keepAlive = ForegroundServiceLiveKeepAlive();
  final LiveCallAudio Function() _callAudio;

  /// A private call's room, while one is on: the host's microphone is there and
  /// muted in the stream, so the viewers hear neither of them.
  LiveCallAudio? _audio;
  String? _privateFor;
  bool _refreshing = false;
  bool _refreshAgain = false;

  @override
  String get selfId => userId;

  Future<void> goLive() async {
    if (state.phase != LivePhase.idle || closed) return;
    emitIfOpen(state.copyWith(phase: LivePhase.preparing, clearError: true));

    final permission = await _permissions.requestCameraAndMicrophone();
    if (permission != LiveMediaPermission.granted) {
      emitIfOpen(
        state.copyWith(
          phase: LivePhase.permissionDenied,
          permanentlyDenied:
              permission == LiveMediaPermission.permanentlyDenied,
        ),
      );
      return;
    }
    if (closed) return;

    emitIfOpen(state.copyWith(phase: LivePhase.joining));
    final LiveJoin join;
    try {
      join = await _backend.start();
    } catch (e) {
      emitIfOpen(state.copyWith(phase: LivePhase.failed, error: '$e'));
      return;
    }
    if (closed) return;

    // Both counts come back with the token. Waiting for the first frame would
    // show a host who reopened the app zero viewers and an empty queue when
    // neither is true.
    emitIfOpen(
      state.copyWith(
        viewerCount: join.viewerCount,
        waitingCount: join.waitingCount,
      ),
    );
    final hostCalls = join.hostCalls;

    listenToRoom();
    listenToChannel(join.chatChannel);

    try {
      await engine.connect(url: join.url, token: join.token, publish: true);
    } catch (e) {
      // We are live on the server but have no picture — end it rather than leave
      // an empty stream on the home page.
      try {
        await _backend.end();
      } catch (_) {}
      emitIfOpen(state.copyWith(phase: LivePhase.failed, error: '$e'));
      return;
    }
    if (closed) return;

    emitIfOpen(
      state.copyWith(
        phase: LivePhase.live,
        cameraOn: true,
        micOn: true,
        startedAt: DateTime.now(),
      ),
    );
    unawaited(keepScreenOn());
    unawaited(
      _keepAlive.start(
        title: 'Live Stream',
        text: 'You are currently live',
        video: true,
      ),
    );
    unawaited(_loadHistory());
    // Reopened mid-call: back into the call (a private one's room included).
    if (hostCalls != null) await _apply(hostCalls);
  }

  // --- calls during the stream ---------------------------------------------

  @override
  void onCallsChanged() => unawaited(refreshCalls());

  Future<void> refreshCalls() async {
    if (closed) return;
    if (_refreshing) {
      _refreshAgain = true;
      return;
    }
    _refreshing = true;
    try {
      do {
        _refreshAgain = false;
        try {
          await _apply(await _backend.calls());
        } catch (_) {}
      } while (_refreshAgain && !closed);
    } finally {
      _refreshing = false;
    }
  }

  Future<void> _apply(LiveHostCalls c) async {
    if (closed) return;
    final current = c.current;
    emitIfOpen(state.copyWith(callLine: c.line, callsWaiting: c.waiting));
    final media = c.media;
    final private = current != null && current.mode == LiveCallMode.private;
    if (private && media != null && _privateFor != current.id) {
      await _enterPrivate(current.id, media);
    } else if (!private && _privateFor != null) {
      await _leavePrivate();
    }
  }

  Future<void> _enterPrivate(String id, LiveCallMedia media) async {
    if (_privateFor != null) await _leavePrivate();
    _privateFor = id;
    try {
      // Off the stream's audio first: not a word of a private call on air.
      await engine.setMicrophoneEnabled(false);
      final audio = _callAudio();
      _audio = audio;
      await audio.connect(url: media.url, token: media.token ?? '');
      if (!state.micOn) await audio.setMicrophoneEnabled(false);
    } catch (e) {
      emitIfOpen(state.copyWith(error: '$e'));
    }
  }

  Future<void> _leavePrivate() async {
    _privateFor = null;
    final audio = _audio;
    _audio = null;
    if (audio != null) {
      try {
        await audio.disconnect();
      } catch (_) {}
    }
    try {
      await engine.setMicrophoneEnabled(state.micOn);
    } catch (_) {}
  }

  /// Ends the call on air, or takes someone off the line.
  Future<void> endCall(String requestId) async {
    emitIfOpen(state.copyWith(callBusy: true));
    try {
      await _backend.endCall(requestId);
    } catch (e) {
      emitIfOpen(state.copyWith(error: '$e'));
    }
    emitIfOpen(state.copyWith(callBusy: false));
    await refreshCalls();
  }

  /// Takes a public caller's microphone away, or gives it back.
  Future<void> muteCaller(String requestId, {required bool muted}) async {
    try {
      await _backend.muteCall(requestId, muted: muted);
    } catch (e) {
      emitIfOpen(state.copyWith(error: '$e'));
    }
    await refreshCalls();
  }

  Future<void> retry() async {
    if (state.phase == LivePhase.permissionDenied ||
        state.phase == LivePhase.failed) {
      emitIfOpen(state.copyWith(phase: LivePhase.idle));
      await goLive();
    }
  }

  Future<void> openSettings() => _permissions.openSettings();

  Future<void> _loadHistory() async {
    try {
      final history = await _backend.chatHistory();
      if (closed) return;
      for (final m in history) {
        addMessage(m);
      }
    } catch (_) {}
  }

  // --- controls ------------------------------------------------------------

  Future<void> toggleCamera() async {
    final on = !state.cameraOn;
    try {
      await engine.setCameraEnabled(on);
      emitIfOpen(state.copyWith(cameraOn: on));
    } catch (_) {}
  }

  Future<void> toggleMic() async {
    final on = !state.micOn;
    try {
      // In a private call the microphone is in its room, not the stream.
      final audio = _audio;
      if (audio != null) {
        await audio.setMicrophoneEnabled(on);
      } else {
        await engine.setMicrophoneEnabled(on);
      }
      emitIfOpen(state.copyWith(micOn: on));
    } catch (_) {}
  }

  Future<void> switchCamera() async {
    if (!state.cameraOn) return;
    try {
      final front = await engine.switchCamera();
      emitIfOpen(state.copyWith(frontCamera: front));
    } catch (_) {}
  }

  /// Sends a chat line: text, a picture ([imagePath]), or both.
  Future<void> sendChat(String text, {String? imagePath}) async {
    final body = text.trim();
    final hasImage = (imagePath ?? '').isNotEmpty;
    if ((body.isEmpty && !hasImage) || state.sending || !state.phase.isOn) {
      return;
    }
    emitIfOpen(state.copyWith(sending: true, clearError: true));
    try {
      await _backend.sendChat(body, imagePath: imagePath);
    } catch (e) {
      emitIfOpen(state.copyWith(error: '$e'));
    } finally {
      emitIfOpen(state.copyWith(sending: false));
    }
  }

  // --- moderation -----------------------------------------------------------

  Future<void> removeViewer(String userId, {String reason = ''}) async {
    try {
      await _backend.removeViewer(userId, reason: reason);
    } catch (e) {
      emitIfOpen(state.copyWith(error: '$e'));
    }
  }

  /// 0 turns slow mode off. The server clamps to 0-300 s.
  Future<void> setSlowMode(int seconds) async {
    try {
      await _backend.setSlowMode(seconds);
      emitIfOpen(state.copyWith(slowModeSeconds: seconds));
    } catch (e) {
      emitIfOpen(state.copyWith(error: '$e'));
    }
  }

  Future<void> pinMessage(String messageId, {bool pin = true}) async {
    try {
      await _backend.pinMessage(messageId, pin: pin);
      if (!pin) emitIfOpen(state.copyWith(clearPinned: true));
    } catch (e) {
      emitIfOpen(state.copyWith(error: '$e'));
    }
  }

  Future<void> hideMessage(String messageId) async {
    try {
      await _backend.pinMessage(messageId, pin: false, hide: true);
    } catch (e) {
      emitIfOpen(state.copyWith(error: '$e'));
    }
  }

  Future<void> translateMessage(String messageId) async {
    final index = state.messages.indexWhere((m) => m.id == messageId);
    if (index == -1) return;

    final message = state.messages[index];
    if (message.text.isEmpty) return;

    // Auto-translation implementation simulation for UI completeness
    // since live chat translation backend endpoint doesn't exist yet.
    final updated = message.copyWith(text: '[Translated] ${message.text}');
    final newMessages = List<LiveChatMessage>.from(state.messages);
    newMessages[index] = updated;

    emitIfOpen(state.copyWith(messages: newMessages));
  }

  /// The host ends the stream. Tell the server first: that is what closes the room,
  /// ejects the viewers and stops it showing up on the home page.
  Future<void> endStream() async {
    if (closed) return;
    try {
      await _backend.end();
    } catch (_) {}
    await finish(LiveEndReason.left);
  }

  @override
  Future<void> finish(LiveEndReason reason) async {
    final audio = _audio;
    _audio = null;
    _privateFor = null;
    if (audio != null) {
      try {
        await audio.disconnect();
      } catch (_) {}
    }
    try {
      await WakelockPlus.disable();
    } catch (_) {}
    await _keepAlive.stop();
    await super.finish(reason);
  }

  /// Someone else ended it (ops kill switch, or the server's own grace timer).
  @override
  void onStreamEnded() {
    unawaited(finish(LiveEndReason.hostEnded));
  }

  @override
  Future<void> close() async {
    try {
      await WakelockPlus.disable();
    } catch (_) {}
    await _keepAlive.stop();
    return super.close();
  }
}
