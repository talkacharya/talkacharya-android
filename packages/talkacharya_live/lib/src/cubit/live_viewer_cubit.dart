import 'dart:async';

import '../models/live_join.dart';
import '../models/live_state.dart';
import '../ports/live_ports.dart';
import 'live_cubit_base.dart';

/// Watching one stream: join, play, chat, heartbeat, leave.
///
/// A viewer never publishes — the token the backend hands out is subscribe-only, so
/// nothing here can put a camera on air.
class LiveViewerCubit extends LiveCubitBase {
  LiveViewerCubit({
    required LiveViewerBackend backend,
    required super.engine,
    required super.signaling,
    required this.userId,
    this.heartbeatEvery = const Duration(seconds: 25),
  }) : _backend = backend,
       super(isHost: false);

  final LiveViewerBackend _backend;

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

    try {
      await engine.connect(url: join.url, token: join.token);
    } catch (e) {
      emitIfOpen(state.copyWith(phase: LivePhase.failed, error: '$e'));
      return;
    }
    if (closed) return;
    emitIfOpen(state.copyWith(phase: LivePhase.live));

    _heartbeat = Timer.periodic(heartbeatEvery, (_) => _beat());
    unawaited(_loadHistory());
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
    await super.finish(reason);
  }
}
