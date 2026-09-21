import 'dart:async';

import '../models/live_join.dart';
import '../models/live_state.dart';
import '../ports/live_ports.dart';
import 'live_cubit_base.dart';

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
  }) : _backend = backend,
       _permissions = permissions,
       super(isHost: true);

  final LiveHostBackend _backend;
  final LivePermissions _permissions;
  final String userId;

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
    unawaited(_loadHistory());
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
      await engine.setMicrophoneEnabled(on);
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

  /// The host ends the stream. Tell the server first: that is what closes the room,
  /// ejects the viewers and stops it showing up on the home page.
  Future<void> endStream() async {
    if (closed) return;
    try {
      await _backend.end();
    } catch (_) {}
    await finish(LiveEndReason.left);
  }

  /// Someone else ended it (ops kill switch, or the server's own grace timer).
  @override
  void onStreamEnded() {
    unawaited(finish(LiveEndReason.hostEnded));
  }
}
