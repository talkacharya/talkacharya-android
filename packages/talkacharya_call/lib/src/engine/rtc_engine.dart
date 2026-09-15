import 'dart:async';

/// ICE connection progress, reduced to what the call logic needs.
enum RtcIceState { checking, connected, disconnected, failed, closed }

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
  /// Opens the microphone (voice-call audio profile). Call once per call.
  Future<void> openMicrophone();
  Future<RtcPeer> createPeer(List<Map<String, dynamic>> iceServers);
  Future<void> setMicrophoneEnabled(bool enabled);
  Future<void> setSpeakerphone(bool on);

  /// Releases the microphone + audio session.
  Future<void> release();
}
