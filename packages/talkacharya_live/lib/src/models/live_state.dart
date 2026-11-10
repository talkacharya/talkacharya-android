import 'package:equatable/equatable.dart';

import '../engine/live_room.dart';
import 'live_call.dart';
import 'live_call_photo.dart';
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
    this.waitingCount = 0,
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
    this.callQuote = const LiveCallQuote(),
    this.onAir,
    this.callsWaiting = 0,
    this.myCall,
    this.callsAhead = 0,
    this.callLine = const [],
    this.callMicOn = true,
    this.callBusy = false,
    this.endedCall,
    this.callPhotos = const [],
    this.sendingPhoto = false,
  });

  final LivePhase phase;
  final bool isHost;
  final int viewerCount;

  /// Viewers who have asked this host for a private reading. Host-side only:
  /// it is the number that decides whether wrapping the stream up is worth
  /// more than carrying on.
  final int waitingCount;

  /// Oldest first — the list a chat panel renders bottom-anchored.
  final List<LiveChatMessage> messages;

  /// The gift banners on screen, oldest first. Each leaves after a couple of
  /// seconds, one at a time, the next waiting gift taking its place.
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

  // --- voice calls during the stream (both sides) ---------------------------

  /// What a public / private call costs a minute here.
  final LiveCallQuote callQuote;

  /// The call on air, as every viewer sees it.
  final LiveOnAir? onAir;

  /// How many wait in the stream's call line.
  final int callsWaiting;

  /// Viewer: their own place in the line, or their call.
  final LiveCallRequest? myCall;

  /// Viewer: how many wait ahead of them.
  final int callsAhead;

  /// Host: the whole line, the call on air first.
  final List<LiveCallRequest> callLine;

  /// The caller's own microphone in their call (they can mute themselves).
  final bool callMicOn;

  /// A call action is on its way to the server.
  final bool callBusy;

  /// Viewer: their call that has just ended after being on air — the screen
  /// asks for a rating, then clears it.
  final LiveCallRequest? endedCall;

  /// Photos shared on the call on air — only the caller and the host have
  /// them. Oldest first; emptied when the call ends.
  final List<LiveCallPhoto> callPhotos;

  /// A photo is on its way to the call.
  final bool sendingPhoto;

  /// Viewer: on air right now.
  bool get onAirMyself => myCall?.status == LiveCallStatus.active;

  /// The picture a viewer should see, when there is one.
  bool get showRemoteVideo => remoteVideo != null && hostVideoOn && phase.isOn;
  bool get showLocalVideo => localVideo != null && cameraOn && phase.isOn;

  LiveState copyWith({
    LivePhase? phase,
    bool? isHost,
    int? viewerCount,
    int? waitingCount,
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
    LiveCallQuote? callQuote,
    LiveOnAir? onAir,
    bool clearOnAir = false,
    int? callsWaiting,
    LiveCallRequest? myCall,
    bool clearMyCall = false,
    int? callsAhead,
    List<LiveCallRequest>? callLine,
    bool? callMicOn,
    bool? callBusy,
    LiveCallRequest? endedCall,
    bool clearEndedCall = false,
    List<LiveCallPhoto>? callPhotos,
    bool? sendingPhoto,
  }) => LiveState(
    phase: phase ?? this.phase,
    isHost: isHost ?? this.isHost,
    viewerCount: viewerCount ?? this.viewerCount,
    waitingCount: waitingCount ?? this.waitingCount,
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
    callQuote: callQuote ?? this.callQuote,
    onAir: clearOnAir ? null : (onAir ?? this.onAir),
    callsWaiting: callsWaiting ?? this.callsWaiting,
    myCall: clearMyCall ? null : (myCall ?? this.myCall),
    callsAhead: callsAhead ?? this.callsAhead,
    callLine: callLine ?? this.callLine,
    callMicOn: callMicOn ?? this.callMicOn,
    callBusy: callBusy ?? this.callBusy,
    endedCall: clearEndedCall ? null : (endedCall ?? this.endedCall),
    callPhotos: callPhotos ?? this.callPhotos,
    sendingPhoto: sendingPhoto ?? this.sendingPhoto,
  );

  @override
  List<Object?> get props => [
    phase,
    isHost,
    viewerCount,
    waitingCount,
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
    callQuote,
    onAir,
    callsWaiting,
    myCall,
    callsAhead,
    callLine,
    callMicOn,
    callBusy,
    endedCall,
    callPhotos,
    sendingPhoto,
  ];
}
