import 'dart:async';

import 'package:wakelock_plus/wakelock_plus.dart';

import '../engine/live_call_audio.dart';
import '../models/live_call.dart';
import '../models/live_join.dart';
import '../models/live_state.dart';
import '../ports/live_ports.dart';
import 'live_cubit_base.dart';
import 'screen_awake.dart';

/// Watching one stream: join, play, chat, heartbeat, leave — and calling in.
///
/// A viewer's token is subscribe-only. Calling in, the server lets this viewer's
/// microphone into the stream's room (a public call) or hands them a token for a
/// two-person room (a private one); never a camera.
class LiveViewerCubit extends LiveCubitBase {
  LiveViewerCubit({
    required LiveViewerBackend backend,
    required super.engine,
    required super.signaling,
    required this.userId,
    this.heartbeatEvery = const Duration(seconds: 25),
    LivePermissions? permissions,
    LiveCallAudio Function()? callAudio,
    this.micRetryEvery = const Duration(milliseconds: 500),
  }) : _backend = backend,
       _permissions = permissions,
       _callAudio = callAudio ?? LiveKitCallAudio.new,
       super(isHost: false);

  final LiveViewerBackend _backend;
  final LivePermissions? _permissions;
  final LiveCallAudio Function() _callAudio;

  /// The server's "may speak" reaches the room a moment after it says so: the
  /// microphone is tried again this often, a few times, before giving up.
  final Duration micRetryEvery;

  /// The private call's room, while in one.
  LiveCallAudio? _audio;

  /// The request this viewer has brought on air (their microphone is live).
  LiveCallRequest? _onAir;
  bool _refreshing = false;
  bool _refreshAgain = false;

  /// This viewer's public id, to recognise a "you were removed" frame.
  final String userId;

  /// The backend drops a viewer from the live count after
  /// `LIVESTREAM.VIEWER_STALE_SECONDS` (90 s), so this has to be well under it.
  final Duration heartbeatEvery;

  Timer? _heartbeat;

  @override
  String get selfId => userId;

  Future<void> start() async {
    if (state.phase != LivePhase.idle || closed) return;
    emitIfOpen(state.copyWith(phase: LivePhase.joining, clearError: true));

    final LiveJoin join;
    try {
      join = await _backend.join();
    } catch (e) {
      emitIfOpen(state.copyWith(phase: LivePhase.failed, error: '$e'));
      return;
    }
    if (closed) return;

    listenToRoom();
    listenToChannel(join.chatChannel);
    emitIfOpen(state.copyWith(viewerCount: join.viewerCount));
    final calls = join.calls;
    if (calls != null) _show(calls);

    try {
      await engine.connect(url: join.url, token: join.token);
    } catch (e) {
      emitIfOpen(state.copyWith(phase: LivePhase.failed, error: '$e'));
      return;
    }
    if (closed) return;
    emitIfOpen(state.copyWith(phase: LivePhase.live));

    unawaited(keepScreenOn());

    _heartbeat = Timer.periodic(heartbeatEvery, (_) => _beat());
    unawaited(_loadHistory());
    // Back in a stream where they were already in line (or on air): carry on.
    if (calls?.mine != null) await _apply(calls!);
  }

  // --- calling in -------------------------------------------------------------

  /// Joins the line for a [mode] call. Asks for the microphone first: there is
  /// no point waiting for a turn that cannot be taken.
  Future<void> requestCall(LiveCallMode mode) async {
    if (state.callBusy || state.myCall != null || !state.phase.isOn) return;
    final permissions = _permissions;
    if (permissions != null) {
      final mic = await permissions.requestMicrophone();
      if (mic != LiveMediaPermission.granted) {
        emitIfOpen(state.copyWith(error: 'microphone'));
        return;
      }
    }
    emitIfOpen(state.copyWith(callBusy: true, clearError: true));
    try {
      await _apply(await _backend.requestCall(mode));
    } catch (e) {
      emitIfOpen(state.copyWith(error: '$e'));
    } finally {
      emitIfOpen(state.copyWith(callBusy: false));
    }
  }

  /// Leaves the line, or hangs up.
  Future<void> endMyCall() async {
    final mine = state.myCall;
    if (mine == null || state.callBusy) return;
    emitIfOpen(state.copyWith(callBusy: true));
    try {
      await _backend.endCall(mine.id);
    } catch (_) {}
    emitIfOpen(state.copyWith(callBusy: false));
    await refreshCalls();
  }

  /// The caller mutes / unmutes themselves.
  Future<void> toggleCallMic() async {
    if (_onAir == null) return;
    final on = !state.callMicOn;
    try {
      final audio = _audio;
      if (audio != null) {
        await audio.setMicrophoneEnabled(on);
      } else {
        await engine.setMicrophoneEnabled(on);
      }
      emitIfOpen(state.copyWith(callMicOn: on));
    } catch (_) {}
  }

  /// The screen has asked for the rating of the call that ended.
  void clearEndedCall() => emitIfOpen(state.copyWith(clearEndedCall: true));

  @override
  void onCallsChanged() {
    // Only someone in the line has anything to look up.
    if (state.myCall != null || _onAir != null) unawaited(refreshCalls());
  }

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

  void _show(LiveViewerCalls c) {
    final mine = c.mine;
    emitIfOpen(
      state.copyWith(
        callQuote: c.quote,
        onAir: c.onAir,
        clearOnAir: c.onAir == null,
        callsWaiting: c.waiting,
        myCall: mine,
        clearMyCall: mine == null || !mine.status.isOpen,
        callsAhead: c.ahead,
      ),
    );
  }

  /// What the line now says for this viewer: their turn — come on air; their
  /// call over — off air.
  Future<void> _apply(LiveViewerCalls c) async {
    if (closed) return;
    _show(c);
    final mine = c.mine;
    final media = c.media;
    final open = mine != null && mine.status.isOpen;
    if (open &&
        mine.status == LiveCallStatus.connecting &&
        media != null &&
        _onAir?.id != mine.id) {
      await _comeOnAir(mine, media);
    } else if (!open && _onAir != null) {
      await _goOffAir();
    } else if (open && mine.status == LiveCallStatus.active) {
      _onAir = mine;
    }
  }

  Future<void> _comeOnAir(LiveCallRequest mine, LiveCallMedia media) async {
    _onAir = mine;
    try {
      if (media.mode == LiveCallMode.private) {
        final audio = _callAudio();
        _audio = audio;
        await audio.connect(url: media.url, token: media.token ?? '');
      } else {
        await _micOnInStream();
      }
      if (closed) return;
      emitIfOpen(state.copyWith(callMicOn: true));
      await _backend.callConnected(mine.id);
      await refreshCalls();
    } catch (e) {
      // Could not get on air: give the turn back rather than hold the line.
      emitIfOpen(state.copyWith(error: '$e'));
      try {
        await _backend.endCall(mine.id);
      } catch (_) {}
      await _goOffAir(rate: false);
      await refreshCalls();
    }
  }

  Future<void> _micOnInStream() async {
    Object? last;
    for (var i = 0; i < 8; i++) {
      try {
        await engine.setMicrophoneEnabled(true);
        return;
      } catch (e) {
        last = e;
        await Future<void>.delayed(micRetryEvery);
      }
    }
    throw last ?? StateError('microphone');
  }

  Future<void> _goOffAir({bool rate = true}) async {
    final was = _onAir;
    _onAir = null;
    final audio = _audio;
    _audio = null;
    if (audio != null) {
      try {
        await audio.disconnect();
      } catch (_) {}
    } else {
      try {
        await engine.setMicrophoneEnabled(false);
      } catch (_) {}
    }
    emitIfOpen(
      state.copyWith(
        callMicOn: true,
        endedCall: rate && was?.consultationId != null ? was : null,
      ),
    );
  }

  Future<void> _loadHistory() async {
    try {
      final history = await _backend.chatHistory();
      if (closed) return;
      for (final m in history) {
        addMessage(m);
      }
    } catch (_) {}
  }

  Future<void> _beat() async {
    if (closed) return;
    try {
      final count = await _backend.heartbeat();
      emitIfOpen(state.copyWith(viewerCount: count));
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

  /// The viewer taps back / closes the sheet.
  Future<void> leave() async {
    _heartbeat?.cancel();
    if (!closed) {
      try {
        await _backend.leave();
      } catch (_) {}
    }
    await finish(LiveEndReason.left);
  }

  @override
  Future<void> finish(LiveEndReason reason) async {
    _heartbeat?.cancel();
    // Leaving (or swiping to another stream) with a place in the line or a call
    // on air: hang up on the server too, or the minutes would go on running.
    final mine = state.myCall;
    if (reason == LiveEndReason.left && mine != null && !closed) {
      try {
        await _backend.endCall(mine.id);
      } catch (_) {}
    }
    final audio = _audio;
    _audio = null;
    _onAir = null;
    if (audio != null) {
      try {
        await audio.disconnect();
      } catch (_) {}
    }
    try {
      await WakelockPlus.disable();
    } catch (_) {}
    await super.finish(reason);
  }

  @override
  Future<void> close() async {
    try {
      await WakelockPlus.disable();
    } catch (_) {}
    return super.close();
  }
}
