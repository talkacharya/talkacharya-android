import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';

import '../models/call_join.dart';
import '../models/call_state.dart';
import '../ports/call_ports.dart';
import 'rtc_engine.dart';

/// Timings, overridable in tests.
class CallTimings {
  const CallTimings({
    this.hello = const Duration(seconds: 3),
    this.reconnectAfter = const Duration(seconds: 4),
    this.reofferCooldown = const Duration(seconds: 5),
    this.stats = const Duration(seconds: 2),
  });

  /// Re-announce presence while not connected.
  final Duration hello;

  /// How long a `disconnected` ICE state may last before an ICE restart.
  final Duration reconnectAfter;

  /// Minimum gap between offers to the same peer (no offer storms).
  final Duration reofferCooldown;
  final Duration stats;
}

/// Runs one 1:1 voice call over self-hosted WebRTC.
///
/// **Signaling** (JSON on the participant-only `call:{id}` Centrifugo channel; every
/// message carries `from` = role and `sid` = a random id per call-screen instance, and
/// optionally `to` = the target sid):
///
/// * `hello` — "I'm here". Both sides broadcast it every [CallTimings.hello] until
///   connected; the non-initiator (astrologer) also answers a broadcast hello directly.
/// * `offer` — sent **only by the initiator** (customer) when it learns the peer's sid,
///   or as an ICE restart when a connected call drops.
/// * `answer`, `ice` — the usual WebRTC exchange (candidates are queued until the
///   remote description is set).
/// * `media` — "my camera just went on/off", so the peer can swap the frozen last
///   frame for an avatar. Video itself never renegotiates: both sides publish their
///   camera from the start of a video call and toggling only enables/disables the
///   track, which keeps a flaky mobile connection from having to redo SDP mid-call.
/// * `bye` — deliberate hang-up.
///
/// A new `sid` from the peer (their app restarted / screen re-opened) replaces the old
/// peer connection, so either side can drop and rejoin mid-call.
///
/// **Backend**: `reportState(connected | reconnecting | disconnected)` on every change
/// after the first connection and every `heartbeat_seconds` — the server starts
/// billing when both are connected and pauses it when a side drops or goes silent.
class CallController extends Cubit<CallState> {
  CallController({
    required CallBackend backend,
    required CallSignaling signaling,
    required RtcEngine engine,
    required CallPermissions permissions,
    CallKeepAlive keepAlive = const NoopCallKeepAlive(),
    this.keepAliveTitle = 'Call in progress',
    this.timings = const CallTimings(),
    CallSounds sounds = const NoopCallSounds(),
    bool ringback = false,
    String? sessionId,
  }) : _backend = backend,
       _sounds = sounds,
       _wantsRingback = ringback,
       _signaling = signaling,
       _engine = engine,
       _permissions = permissions,
       _keepAlive = keepAlive,
       sid = sessionId ?? _randomSid(),
       super(const CallState()) {
    _syncRingback(state.phase);
  }

  final CallBackend _backend;
  final CallSignaling _signaling;
  final RtcEngine _engine;
  final CallPermissions _permissions;
  final CallKeepAlive _keepAlive;
  final CallSounds _sounds;

  /// This side placed the call: play ringback from creation (e.g. while the
  /// consultation still waits to be accepted) until audio first flows.
  final bool _wantsRingback;
  bool _ringing = false;
  bool _connectedOnce = false;
  final String keepAliveTitle;
  final CallTimings timings;

  /// This call-screen instance's signaling id.
  final String sid;

  CallJoin? _join;
  RtcPeer? _peer;
  String? _remoteSid;
  DateTime? _lastOfferAt;
  bool _everConnected = false;
  bool _closed = false;
  final List<Map<String, dynamic>> _pendingCandidates = [];

  StreamSubscription<Map<String, dynamic>>? _signalSub;
  StreamSubscription<Map<String, dynamic>>? _candidateSub;
  StreamSubscription<RtcIceState>? _iceSub;
  StreamSubscription<RtcVideoStream?>? _localVideoSub;
  StreamSubscription<RtcVideoStream?>? _remoteVideoSub;
  Timer? _helloTimer;
  Timer? _heartbeatTimer;
  Timer? _reconnectTimer;
  Timer? _statsTimer;

  CallJoin? get joinInfo => _join;
  bool get _initiator => _join?.initiator ?? false;
  String get _role => _join?.role ?? '';

  static String _randomSid() {
    final r = Random.secure();
    return List.generate(12, (_) => r.nextInt(36).toRadixString(36)).join();
  }

  // --- sounds ------------------------------------------------------------------

  static const _ringbackPhases = {
    CallPhase.idle,
    CallPhase.preparing,
    CallPhase.joining,
    CallPhase.waitingPeer,
    CallPhase.connecting,
  };

  void _syncRingback(CallPhase phase) {
    final want =
        _wantsRingback && !_connectedOnce && _ringbackPhases.contains(phase);
    if (want == _ringing) return;
    _ringing = want;
    want ? _sounds.startRingback() : _sounds.stopRingback();
  }

  @override
  void onChange(Change<CallState> change) {
    super.onChange(change);
    final from = change.currentState.phase;
    final to = change.nextState.phase;
    if (from == to) return;
    final wasRinging = _ringing;
    if (to == CallPhase.connected && !_connectedOnce) {
      _connectedOnce = true;
      _syncRingback(to);
      _sounds.connected();
      return;
    }
    _syncRingback(to);
    if (to == CallPhase.ended && (wasRinging || from != CallPhase.idle)) {
      _sounds.ended();
    }
  }

  // --- lifecycle ---------------------------------------------------------------

  /// Ask for the mic, fetch join info, open signaling and start announcing.
  Future<void> start() async {
    if (state.phase.isLive || _closed) return;
    emit(state.copyWith(phase: CallPhase.preparing, clearError: true));

    final mic = await _permissions.requestMicrophone();
    if (mic != MediaPermission.granted) {
      emit(
        state.copyWith(
          phase: CallPhase.permissionDenied,
          permanentlyDenied: mic == MediaPermission.permanentlyDenied,
        ),
      );
      return;
    }

    emit(state.copyWith(phase: CallPhase.joining));
    final CallJoin join;
    try {
      join = await _joinWithRetry();
    } catch (e) {
      if (_closed) return;
      emit(state.copyWith(phase: CallPhase.failed, error: '$e'));
      return;
    }
    if (_closed) return;
    _join = join;

    // Only a video consultation asks for the camera, and only once we know that is
    // what this call is — a voice call never triggers the camera prompt.
    var video = join.video;
    if (video) {
      final camera = await _permissions.requestCamera();
      if (camera != MediaPermission.granted) {
        // Carry on with audio: losing the picture is better than losing a paid
        // session the customer is already being charged for.
        video = false;
      }
      if (_closed) return;
    }
    emit(state.copyWith(video: join.video, cameraOn: video));

    // Subscribed *before* opening the camera: `localVideo` is a broadcast stream,
    // which never replays a missed event to a late listener. `openMedia()` pushes
    // the camera's first frame stream as its very last step, so listening only
    // after it returns misses that one event forever — the self-view tile then
    // stays blank until something else (toggling the camera) pushes a second one.
    // That was a real bug, not a hypothetical: the self-view only ever appeared
    // after switching the camera off and back on.
    _localVideoSub = _engine.localVideo.listen(
      (stream) => _emitIfOpen(
        stream == null
            ? state.copyWith(clearLocalVideo: true)
            : state.copyWith(localVideo: stream),
      ),
    );

    try {
      await _engine.openMedia(video: video);
    } catch (e) {
      emit(state.copyWith(phase: CallPhase.failed, error: 'microphone: $e'));
      return;
    }
    if (video) emit(state.copyWith(speakerOn: true));

    _signalSub = _signaling
        .frames(join.signalingChannel)
        .listen(_onSignal, onError: (_) {});
    unawaited(_keepAlive.start(title: keepAliveTitle, text: join.peerName));

    emit(state.copyWith(phase: CallPhase.waitingPeer, peerName: join.peerName));
    _sendHello();
    _helloTimer = Timer.periodic(timings.hello, (_) {
      if (state.phase != CallPhase.connected) _sendHello();
    });
    _heartbeatTimer = Timer.periodic(
      Duration(seconds: max(3, join.heartbeatSeconds)),
      (_) => _heartbeat(),
    );
  }

  Future<CallJoin> _joinWithRetry() async {
    Object? last;
    for (var attempt = 0; attempt < 3; attempt++) {
      try {
        return await _backend.join();
      } catch (e) {
        last = e;
        await Future<void>.delayed(Duration(milliseconds: 600 * (attempt + 1)));
        if (_closed) break;
      }
    }
    throw last ?? StateError('join failed');
  }

  /// Retry after the user granted the microphone in settings.
  Future<void> retry() async {
    if (state.phase == CallPhase.permissionDenied ||
        state.phase == CallPhase.failed) {
      emit(state.copyWith(phase: CallPhase.idle));
      await start();
    }
  }

  Future<void> openSettings() => _permissions.openSettings();

  /// The user ends the call: tell the peer, the backend, then tear down.
  Future<void> hangUp() async {
    if (state.phase == CallPhase.ended) return;
    await _publish({'t': 'bye'});
    unawaited(_report(CallNetState.disconnected));
    try {
      await _backend.endConsultation();
    } catch (_) {}
    await _teardown(CallEndReason.localHangUp);
  }

  /// The consultation ended server-side (balance ran out, peer ended, ops…).
  Future<void> onConsultationEnded() async {
    if (state.phase == CallPhase.ended) return;
    await _publish({'t': 'bye'});
    await _teardown(CallEndReason.consultationEnded);
  }

  Future<void> toggleMute() async {
    final muted = !state.muted;
    try {
      await _engine.setMicrophoneEnabled(!muted);
    } catch (_) {}
    emit(state.copyWith(muted: muted));
  }

  Future<void> toggleSpeaker() async {
    final on = !state.speakerOn;
    try {
      await _engine.setSpeakerphone(on);
    } catch (_) {}
    emit(state.copyWith(speakerOn: on));
  }

  /// Camera on/off during a video call. The track stays in place (no renegotiation);
  /// the peer is told so their tile can fall back to an avatar.
  Future<void> toggleCamera() async {
    if (!state.video) return;
    final on = !state.cameraOn;
    try {
      await _engine.setCameraEnabled(on);
    } catch (_) {}
    emit(state.copyWith(cameraOn: on));
    await _publish({'t': 'media', 'video': on});
  }

  /// Front <-> back camera.
  Future<void> switchCamera() async {
    if (!state.video || !state.cameraOn) return;
    try {
      final front = await _engine.switchCamera();
      emit(state.copyWith(frontCamera: front));
    } catch (_) {}
  }

  // --- signaling -------------------------------------------------------------------

  Future<void> _publish(Map<String, dynamic> body) async {
    final join = _join;
    if (join == null) return;
    try {
      await _signaling.publish(join.signalingChannel, {
        ...body,
        'from': _role,
        'sid': sid,
        'v': 1,
      });
    } catch (_) {}
  }

  void _sendHello({String? to}) =>
      unawaited(_publish({'t': 'hello', 'to': ?to}));

  Future<void> _onSignal(Map<String, dynamic> msg) async {
    if (_closed) return;
    final from = msg['from'];
    final remoteSid = msg['sid'] as String?;
    if (from == null || from == _role || remoteSid == null) return; // own echo
    final to = msg['to'] as String?;
    if (to != null && to != sid) return;

    switch (msg['t']) {
      case 'hello':
        await _onHello(remoteSid, broadcast: to == null);
      case 'offer':
        if (!_initiator) await _onOffer(remoteSid, '${msg['sdp']}');
      case 'answer':
        if (_initiator && remoteSid == _remoteSid) {
          await _onAnswer('${msg['sdp']}');
        }
      case 'ice':
        await _onRemoteCandidate(
          remoteSid,
          (msg['c'] as Map?)?.cast<String, dynamic>(),
        );
      case 'media':
        emit(state.copyWith(peerCameraOn: msg['video'] == true));
      case 'bye':
        if (remoteSid == _remoteSid || _remoteSid == null) {
          await _teardown(CallEndReason.remoteHangUp);
        }
    }
  }

  Future<void> _onHello(String remoteSid, {required bool broadcast}) async {
    if (_initiator) {
      final newPeer = _peer == null || _remoteSid != remoteSid;
      if (newPeer) {
        await _newPeer(remoteSid);
        await _offer();
      } else if (state.phase != CallPhase.connected && _offerCooledDown) {
        await _offer(iceRestart: _everConnected);
      }
    } else {
      if (_remoteSid != null && _remoteSid != remoteSid) {
        await _dropPeer(); // their app restarted — expect a fresh offer
      }
      _remoteSid = remoteSid;
      if (broadcast) _sendHello(to: remoteSid);
    }
    if (state.phase == CallPhase.waitingPeer) {
      emit(state.copyWith(phase: CallPhase.connecting));
    }
    if (state.video) await _publish({'t': 'media', 'video': state.cameraOn});
  }

  bool get _offerCooledDown =>
      _lastOfferAt == null ||
      DateTime.now().difference(_lastOfferAt!) >= timings.reofferCooldown;

  Future<void> _offer({bool iceRestart = false}) async {
    final peer = _peer;
    final to = _remoteSid;
    if (peer == null || to == null) return;
    _lastOfferAt = DateTime.now();
    try {
      final sdp = await peer.createOffer(iceRestart: iceRestart);
      await _publish({'t': 'offer', 'to': to, 'sdp': sdp});
    } catch (_) {}
  }

  Future<void> _onOffer(String remoteSid, String sdp) async {
    if (_peer == null || _remoteSid != remoteSid) {
      await _newPeer(remoteSid);
    }
    try {
      final answer = await _peer!.acceptOffer(sdp);
      await _flushCandidates();
      await _publish({'t': 'answer', 'to': remoteSid, 'sdp': answer});
      if (state.phase == CallPhase.waitingPeer) {
        emit(state.copyWith(phase: CallPhase.connecting));
      }
    } catch (_) {}
  }

  Future<void> _onAnswer(String sdp) async {
    try {
      await _peer?.acceptAnswer(sdp);
      await _flushCandidates();
    } catch (_) {}
  }

  Future<void> _onRemoteCandidate(
    String remoteSid,
    Map<String, dynamic>? c,
  ) async {
    if (c == null || remoteSid != _remoteSid) return;
    final peer = _peer;
    if (peer == null || !peer.hasRemoteDescription) {
      _pendingCandidates.add(c);
      return;
    }
    try {
      await peer.addRemoteCandidate(c);
    } catch (_) {}
  }

  Future<void> _flushCandidates() async {
    final peer = _peer;
    if (peer == null) return;
    final queued = List.of(_pendingCandidates);
    _pendingCandidates.clear();
    for (final c in queued) {
      try {
        await peer.addRemoteCandidate(c);
      } catch (_) {}
    }
  }

  // --- peer connection --------------------------------------------------------------

  Future<void> _newPeer(String remoteSid) async {
    await _dropPeer();
    _remoteSid = remoteSid;
    final peer = await _engine.createPeer(
      _join?.iceServers ?? const [],
      video: state.video,
    );
    if (_closed) {
      await peer.close();
      return;
    }
    _peer = peer;
    _candidateSub = peer.localCandidates.listen(
      (c) => unawaited(_publish({'t': 'ice', 'to': _remoteSid, 'c': c})),
    );
    _iceSub = peer.iceStates.listen(_onIceState);
    _remoteVideoSub = peer.remoteVideo.listen(
      (stream) => _emitIfOpen(
        stream == null
            ? state.copyWith(clearRemoteVideo: true)
            : state.copyWith(remoteVideo: stream),
      ),
    );
  }

  Future<void> _dropPeer() async {
    await _candidateSub?.cancel();
    await _iceSub?.cancel();
    await _remoteVideoSub?.cancel();
    _candidateSub = null;
    _iceSub = null;
    _remoteVideoSub = null;
    if (state.remoteVideo != null)
      _emitIfOpen(state.copyWith(clearRemoteVideo: true));
    _pendingCandidates.clear();
    final peer = _peer;
    _peer = null;
    await peer?.close();
  }

  void _onIceState(RtcIceState ice) {
    if (_closed) return;
    switch (ice) {
      case RtcIceState.connected:
        _reconnectTimer?.cancel();
        _everConnected = true;
        emit(
          state.copyWith(
            phase: CallPhase.connected,
            connectedAt: state.connectedAt ?? DateTime.now(),
          ),
        );
        _startStats();
        unawaited(_report(CallNetState.connected));
      case RtcIceState.disconnected:
      case RtcIceState.failed:
        if (!_everConnected) return; // still negotiating — hellos keep retrying
        if (state.phase != CallPhase.reconnecting) {
          emit(state.copyWith(phase: CallPhase.reconnecting));
          unawaited(_report(CallNetState.reconnecting));
        }
        _reconnectTimer?.cancel();
        _reconnectTimer = Timer(
          ice == RtcIceState.failed ? Duration.zero : timings.reconnectAfter,
          _recover,
        );
      case RtcIceState.checking:
      case RtcIceState.closed:
        break;
    }
  }

  /// ICE restart from the initiator; the other side asks for one with a hello.
  Future<void> _recover() async {
    if (_closed || state.phase == CallPhase.connected) return;
    if (_initiator) {
      if (_offerCooledDown) await _offer(iceRestart: true);
    } else {
      _sendHello();
    }
  }

  // --- backend + stats ----------------------------------------------------------------

  Future<void> _report(CallNetState s) async {
    if (!_everConnected && s != CallNetState.disconnected) return;
    try {
      await _backend.reportState(s, relayed: state.relayed ? true : null);
    } catch (_) {}
  }

  void _heartbeat() {
    if (!_everConnected || _closed) return;
    unawaited(
      _report(
        state.phase == CallPhase.connected
            ? CallNetState.connected
            : CallNetState.reconnecting,
      ),
    );
  }

  void _startStats() {
    _statsTimer ??= Timer.periodic(timings.stats, (_) => _sampleStats());
    unawaited(_sampleStats());
  }

  Future<void> _sampleStats() async {
    final peer = _peer;
    if (peer == null || _closed) return;
    try {
      final s = await peer.stats();
      final rtt = s.roundTripSeconds;
      final loss = s.lossRatio;
      var quality = state.quality;
      if (rtt != null || loss != null) {
        final r = rtt ?? 0;
        final l = loss ?? 0;
        quality = (r < 0.3 && l < 0.02)
            ? 3
            : (r < 0.6 && l < 0.06)
            ? 2
            : 1;
      }
      if (!isClosed) {
        emit(
          state.copyWith(quality: quality, relayed: s.relayed ?? state.relayed),
        );
      }
    } catch (_) {}
  }

  void _emitIfOpen(CallState next) {
    if (!isClosed && !_closed) emit(next);
  }

  // --- teardown ------------------------------------------------------------------------

  Future<void> _teardown(CallEndReason reason) async {
    if (_closed) return;
    _closed = true;
    _helloTimer?.cancel();
    _heartbeatTimer?.cancel();
    _reconnectTimer?.cancel();
    _statsTimer?.cancel();
    await _signalSub?.cancel();
    await _localVideoSub?.cancel();
    await _dropPeer();
    try {
      await _engine.release();
    } catch (_) {}
    unawaited(_keepAlive.stop());
    if (!isClosed) {
      emit(
        state.copyWith(
          phase: CallPhase.ended,
          endReason: reason,
          clearLocalVideo: true,
          clearRemoteVideo: true,
        ),
      );
    }
  }

  @override
  Future<void> close() async {
    if (!_closed) {
      // screen closed without an explicit hang-up (e.g. app killed the route)
      if (_everConnected) unawaited(_report(CallNetState.disconnected));
      await _teardown(CallEndReason.none);
    }
    return super.close();
  }
}
