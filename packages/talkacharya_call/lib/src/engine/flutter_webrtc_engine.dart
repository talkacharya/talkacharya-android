import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import 'rtc_engine.dart';

/// [RtcEngine] on `flutter_webrtc` — Google's open-source WebRTC stack, running on
/// the phone. Opus audio with echo cancellation / noise suppression / AGC, DTLS-SRTP
/// encryption end to end (a TURN relay forwards encrypted packets it cannot read).
class FlutterWebRtcEngine implements RtcEngine {
  MediaStream? _local;

  @override
  Future<void> openMicrophone() async {
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
      'video': false,
    });
  }

  @override
  Future<RtcPeer> createPeer(List<Map<String, dynamic>> iceServers) async {
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
      for (final track in local.getAudioTracks()) {
        await pc.addTrack(track, local);
      }
    }
    return _WebRtcPeer(pc);
  }

  @override
  Future<void> setMicrophoneEnabled(bool enabled) async {
    for (final t in _local?.getAudioTracks() ?? const <MediaStreamTrack>[]) {
      t.enabled = enabled;
    }
  }

  @override
  Future<void> setSpeakerphone(bool on) => Helper.setSpeakerphoneOn(on);

  @override
  Future<void> release() async {
    final local = _local;
    _local = null;
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
  _WebRtcPeer(this._pc) {
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
  }

  final RTCPeerConnection _pc;
  final _candidates = StreamController<Map<String, dynamic>>.broadcast();
  final _states = StreamController<RtcIceState>.broadcast();
  bool _remoteSet = false;
  int _lastLost = 0;
  int _lastReceived = 0;

  static const _audioOnly = {
    'mandatory': {'OfferToReceiveAudio': true, 'OfferToReceiveVideo': false},
    'optional': <dynamic>[],
  };

  @override
  Stream<Map<String, dynamic>> get localCandidates => _candidates.stream;

  @override
  Stream<RtcIceState> get iceStates => _states.stream;

  @override
  bool get hasRemoteDescription => _remoteSet;

  @override
  Future<String> createOffer({bool iceRestart = false}) async {
    final constraints = <String, dynamic>{
      ..._audioOnly,
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
    final answer = await _pc.createAnswer(_audioOnly);
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
    try {
      await _pc.close();
    } catch (_) {}
    await _candidates.close();
    await _states.close();
  }
}
