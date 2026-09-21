import 'package:equatable/equatable.dart';

import '../engine/live_room.dart';
import 'live_chat_message.dart';

enum LivePhase {
  idle,

  /// Asking for the camera + microphone (host only).
  preparing,

  /// Permission refused — the screen offers settings / retry.
  permissionDenied,

  /// Getting the token and connecting to the media server.
  joining,

  /// On air.
  live,

  /// Lost the media server, trying to get back.
  reconnecting,

  /// The stream is over (host ended it, or we left).
  ended,

  /// Could not start / join (see [LiveState.error]).
  failed;

  bool get isOn => this == live || this == reconnecting;
}

/// Why a stream ended, so the screen can say something useful.
enum LiveEndReason { none, left, hostEnded, removed, error }

class LiveState extends Equatable {
  const LiveState({
    this.phase = LivePhase.idle,
    this.isHost = false,
    this.viewerCount = 0,
    this.messages = const [],
    this.gifts = const [],
    this.pinned,
    this.error,
    this.permanentlyDenied = false,
    this.endReason = LiveEndReason.none,
    this.cameraOn = true,
    this.micOn = true,
    this.frontCamera = true,
    this.hostVideoOn = true,
    this.localVideo,
    this.remoteVideo,
    this.slowModeSeconds = 0,
    this.sending = false,
    this.startedAt,
  });

  final LivePhase phase;
  final bool isHost;
  final int viewerCount;

  /// Oldest first — the list a chat panel renders bottom-anchored.
  final List<LiveChatMessage> messages;

  /// Recent gifts, for the floating banners. Trimmed by the cubit.
  final List<LiveGiftEvent> gifts;
  final LiveChatMessage? pinned;
  final String? error;
  final bool permanentlyDenied;
  final LiveEndReason endReason;

  // host controls
  final bool cameraOn;
  final bool micOn;
  final bool frontCamera;

  /// Viewer side: the host is publishing video right now (vs. camera muted).
  final bool hostVideoOn;

  final LiveVideoTrack? localVideo;
  final LiveVideoTrack? remoteVideo;
  final int slowModeSeconds;
  final bool sending;

  /// When we went on air (drives the host's "live for 12:04").
  final DateTime? startedAt;

  /// The picture a viewer should see, when there is one.
  bool get showRemoteVideo => remoteVideo != null && hostVideoOn && phase.isOn;
  bool get showLocalVideo => localVideo != null && cameraOn && phase.isOn;

  LiveState copyWith({
    LivePhase? phase,
    bool? isHost,
    int? viewerCount,
    List<LiveChatMessage>? messages,
    List<LiveGiftEvent>? gifts,
    LiveChatMessage? pinned,
    bool clearPinned = false,
    String? error,
    bool clearError = false,
    bool? permanentlyDenied,
    LiveEndReason? endReason,
    bool? cameraOn,
    bool? micOn,
    bool? frontCamera,
    bool? hostVideoOn,
    LiveVideoTrack? localVideo,
    bool clearLocalVideo = false,
    LiveVideoTrack? remoteVideo,
    bool clearRemoteVideo = false,
    int? slowModeSeconds,
    bool? sending,
    DateTime? startedAt,
  }) => LiveState(
    phase: phase ?? this.phase,
    isHost: isHost ?? this.isHost,
    viewerCount: viewerCount ?? this.viewerCount,
    messages: messages ?? this.messages,
    gifts: gifts ?? this.gifts,
    pinned: clearPinned ? null : (pinned ?? this.pinned),
    error: clearError ? null : (error ?? this.error),
    permanentlyDenied: permanentlyDenied ?? this.permanentlyDenied,
    endReason: endReason ?? this.endReason,
    cameraOn: cameraOn ?? this.cameraOn,
    micOn: micOn ?? this.micOn,
    frontCamera: frontCamera ?? this.frontCamera,
    hostVideoOn: hostVideoOn ?? this.hostVideoOn,
    localVideo: clearLocalVideo ? null : (localVideo ?? this.localVideo),
    remoteVideo: clearRemoteVideo ? null : (remoteVideo ?? this.remoteVideo),
    slowModeSeconds: slowModeSeconds ?? this.slowModeSeconds,
    sending: sending ?? this.sending,
    startedAt: startedAt ?? this.startedAt,
  );

  @override
  List<Object?> get props => [
    phase,
    isHost,
    viewerCount,
    messages,
    gifts,
    pinned,
    error,
    permanentlyDenied,
    endReason,
    cameraOn,
    micOn,
    frontCamera,
    hostVideoOn,
    localVideo,
    remoteVideo,
    slowModeSeconds,
    sending,
    startedAt,
  ];
}
