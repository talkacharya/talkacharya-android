import 'dart:async';

/// ICE connection progress, reduced to what the call logic needs.
enum RtcIceState { checking, connected, disconnected, failed, closed }

/// A renderable video stream. Opaque on purpose: the real engine hands back a
/// `flutter_webrtc` `MediaStream`, tests hand back anything, and only
/// [CallVideoView] ever looks inside.
typedef RtcVideoStream = Object;

/// A snapshot of transport health (from `getStats`).
class RtcStats {
  const RtcStats({this.roundTripSeconds, this.lossRatio, this.relayed});

  /// Current round-trip time of the selected candidate pair.
  final double? roundTripSeconds;

  /// Inbound audio packet loss since the previous sample (0..1).
  final double? lossRatio;

  /// The selected path goes through a TURN relay.
  final bool? relayed;
}

/// One peer connection. Abstracted so the call controller is unit-testable without
/// a device; [FlutterWebRtcEngine] is the real implementation.
abstract class RtcPeer {
  /// Local ICE candidates as `{candidate, sdpMid, sdpMLineIndex}`.
  Stream<Map<String, dynamic>> get localCandidates;
  Stream<RtcIceState> get iceStates;

  /// The peer's video, once their track arrives (null again when it goes away).
  Stream<RtcVideoStream?> get remoteVideo;

  /// Creates + applies a local offer; returns its SDP.
  Future<String> createOffer({bool iceRestart = false});

  /// Applies a remote offer, creates + applies the answer; returns its SDP.
  Future<String> acceptOffer(String sdp);
  Future<void> acceptAnswer(String sdp);
  Future<void> addRemoteCandidate(Map<String, dynamic> candidate);
  bool get hasRemoteDescription;
  Future<RtcStats> stats();
  Future<void> close();
}

abstract class RtcEngine {
  /// Opens the microphone, and the camera too when [video] is on (call once per
  /// call). The audio profile is the same either way: voice communication.
  Future<void> openMedia({bool video = false});

  /// Creates the peer connection. [video] must match what [openMedia] opened, so
  /// the SDP offers a video line.
  Future<RtcPeer> createPeer(
    List<Map<String, dynamic>> iceServers, {
    bool video = false,
  });

  Future<void> setMicrophoneEnabled(bool enabled);

  /// Stops sending our own picture without renegotiating — the far side sees the
  /// last frame freeze, so the UI also announces it over signaling.
  Future<void> setCameraEnabled(bool enabled);

  /// Front <-> back. Returns true when the front camera is now active.
  Future<bool> switchCamera();
  Future<void> setSpeakerphone(bool on);

  /// Our own camera preview, or null on a voice call.
  Stream<RtcVideoStream?> get localVideo;

  /// Releases the microphone, camera and audio session.
  Future<void> release();
}
