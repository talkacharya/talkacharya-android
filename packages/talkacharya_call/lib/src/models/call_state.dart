import 'package:equatable/equatable.dart';

import '../engine/call_telecom.dart';
import '../engine/rtc_engine.dart';

enum CallPhase {
  /// Not started yet.
  idle,

  /// Asking for the microphone (and the camera on a video call).
  preparing,

  /// Microphone or camera permission refused — the screen offers settings / retry.
  permissionDenied,

  /// Fetching join info + opening signaling.
  joining,

  /// Waiting for the other phone to show up on the call.
  waitingPeer,

  /// Both sides present; ICE / DTLS handshake in progress.
  connecting,

  /// Audio (and video) flowing.
  connected,

  /// Was connected, lost the path — trying to recover (ICE restart).
  reconnecting,

  /// Finished (see [CallEndReason]).
  ended,

  /// Could not start (see [CallState.error]).
  failed;

  bool get isLive =>
      this == waitingPeer ||
      this == connecting ||
      this == connected ||
      this == reconnecting;
}

enum CallEndReason { none, localHangUp, remoteHangUp, consultationEnded, error }

/// What the network side reports to the backend (drives billing).
enum CallNetState { connected, reconnecting, disconnected }

class CallState extends Equatable {
  const CallState({
    this.phase = CallPhase.idle,
    this.muted = false,
    this.speakerOn = false,
    this.bluetooth = false,
    this.audioRoutes = const {},
    this.videoPausedForNetwork = false,
    this.quality = 0,
    this.peerQuality = 0,
    this.relayed = false,
    this.connectedAt,
    this.endReason = CallEndReason.none,
    this.error,
    this.peerName = '',
    this.permanentlyDenied = false,
    this.video = false,
    this.cameraOn = false,
    this.frontCamera = true,
    this.peerCameraOn = true,
    this.localVideo,
    this.remoteVideo,
  });

  final CallPhase phase;
  final bool muted;
  final bool speakerOn;

  /// Audio is on a Bluetooth headset. Reported by Telecom, which owns the
  /// route — the UI shows a headset rather than claiming "speaker".
  final bool bluetooth;

  /// Where the audio could go, as Telecom reports it. Empty when Telecom is not
  /// managing the call — then the screen offers only the speaker toggle.
  final Set<CallAudioOutput> audioRoutes;

  /// Where the audio is.
  CallAudioOutput get audioRoute => bluetooth
      ? CallAudioOutput.bluetooth
      : (speakerOn ? CallAudioOutput.speaker : CallAudioOutput.earpiece);

  /// More places to send the audio than a speaker toggle can express — a
  /// headset is connected — so the screen offers a picker instead.
  bool get canPickAudioRoute =>
      audioRoutes.contains(CallAudioOutput.bluetooth) ||
      audioRoutes.contains(CallAudioOutput.wired);

  /// The camera was turned off because the connection couldn't carry it, not
  /// because the user turned it off — so the UI can say so, and say it will
  /// come back, instead of looking like the camera button broke.
  final bool videoPausedForNetwork;

  /// 0 = unknown, 1 = poor, 2 = fair, 3 = good.
  final int quality;

  /// The same, as the *other* side measured it and told us. 0 until they say.
  ///
  /// Worth the extra round of signalling: without it a rough call looks
  /// identical from both ends, and whoever's line is fine spends it
  /// apologising and restarting things.
  final int peerQuality;

  /// Media goes through our TURN relay (vs. phone-to-phone).
  final bool relayed;

  /// First time the call connected (drives the on-screen timer).
  final DateTime? connectedAt;
  final CallEndReason endReason;
  final String? error;
  final String peerName;

  /// Microphone or camera permission is blocked in system settings.
  final bool permanentlyDenied;

  /// This consultation is a video call (fixed for the whole call).
  final bool video;

  /// Our camera is on. A video call can continue with it off — that is how
  /// someone "drops to voice" without ending the session.
  final bool cameraOn;
  final bool frontCamera;

  /// The other side says their camera is on. Their tile shows an avatar when not.
  final bool peerCameraOn;

  /// Renderable streams, null until the track arrives (or when a camera is off).
  final RtcVideoStream? localVideo;
  final RtcVideoStream? remoteVideo;

  /// Show the peer's video: a video call, connected, their camera on, track here.
  bool get showRemoteVideo =>
      video && peerCameraOn && remoteVideo != null && phase.isLive;

  bool get showLocalVideo => video && cameraOn && localVideo != null;

  CallState copyWith({
    CallPhase? phase,
    bool? muted,
    bool? speakerOn,
    bool? bluetooth,
    Set<CallAudioOutput>? audioRoutes,
    bool? videoPausedForNetwork,
    int? quality,
    int? peerQuality,
    bool? relayed,
    DateTime? connectedAt,
    CallEndReason? endReason,
    String? error,
    bool clearError = false,
    String? peerName,
    bool? permanentlyDenied,
    bool? video,
    bool? cameraOn,
    bool? frontCamera,
    bool? peerCameraOn,
    RtcVideoStream? localVideo,
    bool clearLocalVideo = false,
    RtcVideoStream? remoteVideo,
    bool clearRemoteVideo = false,
  }) => CallState(
    phase: phase ?? this.phase,
    muted: muted ?? this.muted,
    speakerOn: speakerOn ?? this.speakerOn,
    bluetooth: bluetooth ?? this.bluetooth,
    audioRoutes: audioRoutes ?? this.audioRoutes,
    videoPausedForNetwork: videoPausedForNetwork ?? this.videoPausedForNetwork,
    quality: quality ?? this.quality,
      peerQuality: peerQuality ?? this.peerQuality,
    relayed: relayed ?? this.relayed,
    connectedAt: connectedAt ?? this.connectedAt,
    endReason: endReason ?? this.endReason,
    error: clearError ? null : (error ?? this.error),
    peerName: peerName ?? this.peerName,
    permanentlyDenied: permanentlyDenied ?? this.permanentlyDenied,
    video: video ?? this.video,
    cameraOn: cameraOn ?? this.cameraOn,
    frontCamera: frontCamera ?? this.frontCamera,
    peerCameraOn: peerCameraOn ?? this.peerCameraOn,
    localVideo: clearLocalVideo ? null : (localVideo ?? this.localVideo),
    remoteVideo: clearRemoteVideo ? null : (remoteVideo ?? this.remoteVideo),
  );

  @override
  List<Object?> get props => [
    phase,
    muted,
    speakerOn,
    bluetooth,
    audioRoutes,
    videoPausedForNetwork,
    quality,
    peerQuality,
    relayed,
    connectedAt,
    endReason,
    error,
    peerName,
    permanentlyDenied,
    video,
    cameraOn,
    frontCamera,
    peerCameraOn,
    localVideo,
    remoteVideo,
  ];
}

/// Whose line is the problem, when there is one.
enum CallWeakSide { none, mine, theirs, both }

extension CallQualityView on CallState {
  /// Only meaningful once both sides have reported; an unknown peer quality
  /// must not be read as a good one.
  CallWeakSide get weakSide {
    final mine = quality > 0 && quality == 1;
    final theirs = peerQuality > 0 && peerQuality == 1;
    if (mine && theirs) return CallWeakSide.both;
    if (mine) return CallWeakSide.mine;
    if (theirs) return CallWeakSide.theirs;
    return CallWeakSide.none;
  }
}
