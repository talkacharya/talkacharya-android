import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import 'rtc_engine.dart';

/// [RtcEngine] on `flutter_webrtc` — Google's open-source WebRTC stack, running on
/// the phone. Opus audio with echo cancellation / noise suppression / AGC, VP8/H.264
/// video, DTLS-SRTP encryption end to end (a TURN relay forwards encrypted packets it
/// cannot read).
class FlutterWebRtcEngine implements RtcEngine {
  MediaStream? _local;
  bool _front = true;
  final _localVideo = StreamController<RtcVideoStream?>.broadcast();

  /// 480p at 24fps: good enough to read a face, ~1/4 the bandwidth of 720p — and on a
  /// relayed call every bit crosses our own server. The camera negotiates the nearest
  /// size it actually supports.
  static const _videoConstraints = <String, dynamic>{
    'facingMode': 'user',
    'width': {'ideal': 640},
    'height': {'ideal': 480},
    'frameRate': {'ideal': 24, 'max': 30},
  };

  @override
  Stream<RtcVideoStream?> get localVideo => _localVideo.stream;

  @override
  Future<void> openMedia({bool video = false}) async {
    if (_local != null) return;
    if (defaultTargetPlatform == TargetPlatform.android) {
      // voice-communication mode: earpiece routing + hardware echo cancellation
      await Helper.setAndroidAudioConfiguration(
        AndroidAudioConfiguration.communication,
      );
    }
    _local = await navigator.mediaDevices.getUserMedia({
      'audio': {
        'echoCancellation': true,
        'noiseSuppression': true,
        'autoGainControl': true,
      },
      'video': video ? _videoConstraints : false,
    });
    if (video) {
      // a video call starts on the loudspeaker — nobody holds a video call to their ear
      try {
        await Helper.setSpeakerphoneOn(true);
      } catch (_) {}
      _localVideo.add(_local);
    }
  }

  @override
  Future<RtcPeer> createPeer(
    List<Map<String, dynamic>> iceServers, {
    bool video = false,
  }) async {
    final pc = await createPeerConnection({
      'iceServers': iceServers,
      'sdpSemantics': 'unified-plan',
      'bundlePolicy': 'max-bundle',
      'rtcpMuxPolicy': 'require',
      // gather a few candidates up front so the first answer connects faster
      'iceCandidatePoolSize': 2,
    });
    final local = _local;
    if (local != null) {
      for (final track in local.getTracks()) {
        if (track.kind == 'video' && !video) continue;
        await pc.addTrack(track, local);
      }
    }
    return _WebRtcPeer(pc, video: video);
  }

  @override
  Future<void> setMicrophoneEnabled(bool enabled) async {
    for (final t in _local?.getAudioTracks() ?? const <MediaStreamTrack>[]) {
      t.enabled = enabled;
    }
  }

  @override
  Future<void> setCameraEnabled(bool enabled) async {
    for (final t in _local?.getVideoTracks() ?? const <MediaStreamTrack>[]) {
      t.enabled = enabled;
    }
    _localVideo.add(enabled ? _local : null);
  }

  @override
  Future<bool> switchCamera() async {
    final tracks = _local?.getVideoTracks() ?? const <MediaStreamTrack>[];
    if (tracks.isEmpty) return _front;
    try {
      await Helper.switchCamera(tracks.first);
      _front = !_front;
    } catch (_) {}
    return _front;
  }

  @override
  Future<void> setSpeakerphone(bool on) => Helper.setSpeakerphoneOn(on);

  @override
  Future<void> release() async {
    final local = _local;
    _local = null;
    _localVideo.add(null);
    unawaited(_localVideo.close());
    if (local == null) return;
    for (final t in local.getTracks()) {
      await t.stop();
    }
    await local.dispose();
    if (defaultTargetPlatform == TargetPlatform.android) {
      try {
        await Helper.clearAndroidCommunicationDevice();
      } catch (_) {}
    }
  }
}

class _WebRtcPeer implements RtcPeer {
  _WebRtcPeer(this._pc, {required bool video}) : _video = video {
    _pc.onIceCandidate = (c) {
      if (c.candidate == null) return;
      _candidates.add({
        'candidate': c.candidate,
        'sdpMid': c.sdpMid,
        'sdpMLineIndex': c.sdpMLineIndex,
      });
    };
    _pc.onIceConnectionState = (s) {
      final mapped = switch (s) {
        RTCIceConnectionState.RTCIceConnectionStateConnected ||
        RTCIceConnectionState.RTCIceConnectionStateCompleted =>
          RtcIceState.connected,
        RTCIceConnectionState.RTCIceConnectionStateDisconnected =>
          RtcIceState.disconnected,
        RTCIceConnectionState.RTCIceConnectionStateFailed => RtcIceState.failed,
        RTCIceConnectionState.RTCIceConnectionStateClosed => RtcIceState.closed,
        _ => RtcIceState.checking,
      };
      _states.add(mapped);
    };
    _pc.onTrack = (event) {
      if (event.track.kind != 'video' || event.streams.isEmpty) return;
      _remoteVideo.add(event.streams.first);
    };
  }

  final RTCPeerConnection _pc;
  final bool _video;
  final _candidates = StreamController<Map<String, dynamic>>.broadcast();
  final _states = StreamController<RtcIceState>.broadcast();
  final _remoteVideo = StreamController<RtcVideoStream?>.broadcast();
  bool _remoteSet = false;
  int _lastLost = 0;
  int _lastReceived = 0;

  Map<String, dynamic> get _mediaConstraints => {
    'mandatory': {'OfferToReceiveAudio': true, 'OfferToReceiveVideo': _video},
    'optional': <dynamic>[],
  };

  @override
  Stream<Map<String, dynamic>> get localCandidates => _candidates.stream;

  @override
  Stream<RtcIceState> get iceStates => _states.stream;

  @override
  Stream<RtcVideoStream?> get remoteVideo => _remoteVideo.stream;

  @override
  bool get hasRemoteDescription => _remoteSet;

  @override
  Future<String> createOffer({bool iceRestart = false}) async {
    final constraints = <String, dynamic>{
      ..._mediaConstraints,
      if (iceRestart) 'iceRestart': true,
    };
    if (iceRestart) {
      try {
        await _pc.restartIce();
      } catch (_) {}
    }
    final offer = await _pc.createOffer(constraints);
    await _pc.setLocalDescription(offer);
    return offer.sdp ?? '';
  }

  @override
  Future<String> acceptOffer(String sdp) async {
    await _pc.setRemoteDescription(RTCSessionDescription(sdp, 'offer'));
    _remoteSet = true;
    final answer = await _pc.createAnswer(_mediaConstraints);
    await _pc.setLocalDescription(answer);
    return answer.sdp ?? '';
  }

  @override
  Future<void> acceptAnswer(String sdp) async {
    await _pc.setRemoteDescription(RTCSessionDescription(sdp, 'answer'));
    _remoteSet = true;
  }

  @override
  Future<void> addRemoteCandidate(Map<String, dynamic> c) => _pc.addCandidate(
    RTCIceCandidate(
      c['candidate'] as String?,
      c['sdpMid'] as String?,
      (c['sdpMLineIndex'] as num?)?.toInt(),
    ),
  );

  @override
  Future<RtcStats> stats() async {
    final reports = await _pc.getStats();
    double? rtt;
    bool? relayed;
    double? loss;
    String? localCandidateId;
    final byId = {for (final r in reports) r.id: r};
    for (final r in reports) {
      final v = r.values;
      if (r.type == 'candidate-pair' &&
          (v['state'] == 'succeeded') &&
          (v['nominated'] == true || v['selected'] == true)) {
        rtt = (v['currentRoundTripTime'] as num?)?.toDouble() ?? rtt;
        localCandidateId = v['localCandidateId'] as String?;
      }
      if (r.type == 'inbound-rtp' && (v['kind'] ?? v['mediaType']) == 'audio') {
        final lost = (v['packetsLost'] as num?)?.toInt() ?? 0;
        final received = (v['packetsReceived'] as num?)?.toInt() ?? 0;
        final dLost = lost - _lastLost;
        final dRecv = received - _lastReceived;
        if (dLost + dRecv > 0) loss = dLost / (dLost + dRecv);
        _lastLost = lost;
        _lastReceived = received;
      }
    }
    final local = localCandidateId == null ? null : byId[localCandidateId];
    if (local != null) relayed = local.values['candidateType'] == 'relay';
    return RtcStats(roundTripSeconds: rtt, lossRatio: loss, relayed: relayed);
  }

  @override
  Future<void> close() async {
    _pc.onIceCandidate = null;
    _pc.onIceConnectionState = null;
    _pc.onTrack = null;
    try {
      await _pc.close();
    } catch (_) {}
    await _candidates.close();
    await _states.close();
    await _remoteVideo.close();
  }
}
