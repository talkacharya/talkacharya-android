import 'dart:async';

import 'package:bloc/bloc.dart';

import '../engine/live_room.dart';
import '../models/live_chat_message.dart';
import '../models/live_state.dart';
import '../ports/live_ports.dart';

/// What the host and the viewer have in common: the room connection, the realtime
/// frames on `live:{id}` (chat, viewer count, gifts, moderation) and teardown.
///
/// Video comes from the media server; everything else on this screen comes through
/// Centrifugo, which is why both sides listen to the same channel.
abstract class LiveCubitBase extends Cubit<LiveState> {
  LiveCubitBase({
    required LiveRoomEngine engine,
    required LiveSignaling signaling,
    required bool isHost,
    this.giftsKept = 3,
    this.messagesKept = 200,
  }) : _engine = engine,
       _signaling = signaling,
       super(LiveState(isHost: isHost));

  final LiveRoomEngine _engine;
  final LiveSignaling _signaling;

  /// How many gift banners stay on screen.
  final int giftsKept;

  /// Chat is capped so a long stream cannot grow the list forever.
  final int messagesKept;

  LiveRoomEngine get engine => _engine;

  StreamSubscription<Map<String, dynamic>>? _frameSub;
  StreamSubscription<LiveVideoTrack?>? _remoteSub;
  StreamSubscription<LiveVideoTrack?>? _localSub;
  StreamSubscription<LiveConnection>? _connSub;
  StreamSubscription<bool>? _remoteEnabledSub;
  bool closed = false;

  /// This user's own id, so "you were removed" can be told apart from anyone else.
  String get selfId;

  // --- wiring -----------------------------------------------------------------

  void listenToRoom() {
    _remoteSub = _engine.remoteVideo.listen(
      (t) => emitIfOpen(
        t == null
            ? state.copyWith(clearRemoteVideo: true)
            : state.copyWith(remoteVideo: t),
      ),
    );
    _localSub = _engine.localVideo.listen(
      (t) => emitIfOpen(
        t == null
            ? state.copyWith(clearLocalVideo: true)
            : state.copyWith(localVideo: t),
      ),
    );
    _remoteEnabledSub = _engine.remoteVideoEnabled.listen(
      (on) => emitIfOpen(state.copyWith(hostVideoOn: on)),
    );
    _connSub = _engine.connectionStates.listen((c) {
      if (closed) return;
      switch (c) {
        case LiveConnection.reconnecting:
          emitIfOpen(state.copyWith(phase: LivePhase.reconnecting));
        case LiveConnection.connected:
          if (state.phase == LivePhase.reconnecting) {
            emitIfOpen(state.copyWith(phase: LivePhase.live));
          }
        case LiveConnection.disconnected:
        case LiveConnection.connecting:
          break;
      }
    });
  }

  void listenToChannel(String channel) {
    if (channel.isEmpty) return;
    _frameSub = _signaling.frames(channel).listen(onFrame, onError: (_) {});
  }

  /// Frames on `live:{public_id}` — see backend docs/livestream.md §6.
  void onFrame(Map<String, dynamic> frame) {
    if (closed) return;
    final data = (frame['data'] as Map?)?.cast<String, dynamic>() ?? frame;
    switch ('${frame['type'] ?? frame['t'] ?? ''}') {
      case 'chat.message':
        addMessage(LiveChatMessage.fromJson(data));
      case 'chat.hidden':
        final id = '${data['id'] ?? ''}';
        emitIfOpen(
          state.copyWith(
            messages: [
              for (final m in state.messages)
                if (m.id != id) m,
            ],
          ),
        );
      case 'chat.pinned':
        emitIfOpen(state.copyWith(pinned: LiveChatMessage.fromJson(data)));
      case 'chat.slow_mode':
        emitIfOpen(
          state.copyWith(
            slowModeSeconds: (data['seconds'] as num?)?.toInt() ?? 0,
          ),
        );
      case 'viewer.count':
        emitIfOpen(
          state.copyWith(viewerCount: (data['count'] as num?)?.toInt() ?? 0),
        );
      case 'viewer.removed':
        if ('${data['user'] ?? ''}' == selfId) {
          onRemoved();
        }
      case 'gift.received':
        final gift = LiveGiftEvent.fromJson(data);
        final gifts = [...state.gifts, gift];
        emitIfOpen(
          state.copyWith(
            gifts: gifts.length > giftsKept
                ? gifts.sublist(gifts.length - giftsKept)
                : gifts,
          ),
        );
      case 'stream.ended':
        onStreamEnded();
    }
  }

  void addMessage(LiveChatMessage message) {
    if (state.messages.any((m) => m.id == message.id)) return;
    final list = [...state.messages, message];
    emitIfOpen(
      state.copyWith(
        messages: list.length > messagesKept
            ? list.sublist(list.length - messagesKept)
            : list,
      ),
    );
  }

  /// The host ended the stream (or ops killed it).
  void onStreamEnded() {
    finish(LiveEndReason.hostEnded);
  }

  /// A moderator removed this viewer.
  void onRemoved() {
    finish(LiveEndReason.removed);
  }

  void dismissGift(String id) => emitIfOpen(
    state.copyWith(
      gifts: [
        for (final g in state.gifts)
          if (g.id != id) g,
      ],
    ),
  );

  // --- teardown ----------------------------------------------------------------

  /// Leaves the room and settles on [LivePhase.ended]. Safe to call twice.
  Future<void> finish(LiveEndReason reason) async {
    if (closed) return;
    closed = true;
    await _frameSub?.cancel();
    await _remoteSub?.cancel();
    await _localSub?.cancel();
    await _remoteEnabledSub?.cancel();
    await _connSub?.cancel();
    try {
      await _engine.disconnect();
    } catch (_) {}
    emitIfOpen(
      state.copyWith(
        phase: LivePhase.ended,
        endReason: reason,
        clearLocalVideo: true,
        clearRemoteVideo: true,
      ),
    );
  }

  void emitIfOpen(LiveState next) {
    if (!isClosed) emit(next);
  }

  @override
  Future<void> close() async {
    if (!closed) await finish(LiveEndReason.left);
    return super.close();
  }
}
