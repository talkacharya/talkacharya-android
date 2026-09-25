import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';

import '../models/call_join.dart';
import '../models/call_state.dart';
import '../ports/call_ports.dart';
import 'call_proximity.dart';
import 'call_telecom.dart';
import 'rtc_engine.dart';

/// Timings, overridable in tests.
class CallTimings {
  const CallTimings({
    this.hello = const Duration(seconds: 3),
    this.reconnectAfter = const Duration(seconds: 4),
    this.reofferCooldown = const Duration(seconds: 5),
    this.stats = const Duration(seconds: 2),
    this.networkSettle = const Duration(milliseconds: 400),
  });

  /// Re-announce presence while not connected.
  final Duration hello;

  /// How long a `disconnected` ICE state may last before an ICE restart.
  final Duration reconnectAfter;

  /// Minimum gap between offers to the same peer (no offer storms).
  final Duration reofferCooldown;
  final Duration stats;

  /// How long to let the network settle after a change before restarting ICE.
  /// Mobile hand-offs arrive as a burst of events; this collapses them into
  /// one restart on the network the phone actually ended up on.
  final Duration networkSettle;
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
    CallConnectivity connectivity = const NoopCallConnectivity(),
    CallDiagnostics diagnostics = const NoopCallDiagnostics(),
    this.keepAliveTitle = 'Call in progress',
    this.timings = const CallTimings(),
    CallSounds sounds = const NoopCallSounds(),
    bool ringback = false,
    String? sessionId,
    Stream<CallTelecomEvent>? telecomEvents,
  }) : _backend = backend,
       _telecomEvents = telecomEvents,
       _sounds = sounds,
       _wantsRingback = ringback,
       _signaling = signaling,
       _engine = engine,
       _permissions = permissions,
       _keepAlive = keepAlive,
       _connectivity = connectivity,
       _diagnostics = diagnostics,
       sid = sessionId ?? _randomSid(),
       super(const CallState()) {
    _syncRingback(state.phase);
  }

  final CallBackend _backend;
  final CallSignaling _signaling;
  final RtcEngine _engine;
  final CallPermissions _permissions;
  final CallKeepAlive _keepAlive;
  final CallConnectivity _connectivity;
  final CallDiagnostics _diagnostics;
  final CallSounds _sounds;

  /// Overridable so tests can drive Telecom without a platform channel.
  final Stream<CallTelecomEvent>? _telecomEvents;

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
  StreamSubscription<void>? _networkSub;
  StreamSubscription<CallTelecomEvent>? _telecomSub;
  Timer? _helloTimer;
  Timer? _heartbeatTimer;
  Timer? _reconnectTimer;
  Timer? _statsTimer;
  Timer? _networkDebounce;
  bool _proximityHeld = false;

  /// Latest transport sample, sent along with the next heartbeat.
  int? _lastRttMs;
  int? _lastLossPct;

  /// Hello is announced quickly at first and backs off: a peer that opens its
  /// screen a moment later shouldn't wait a full interval in silence.
  int _helloAttempt = 0;

  /// Consecutive stats samples at either end of the scale, for [_adaptVideo].
  int _poorSamples = 0;
  int _goodSamples = 0;

  /// The camera is off because the network couldn't carry it — as opposed to
  /// because the user turned it off, which we must never quietly undo.
  bool _cameraOffForNetwork = false;

  static const _poorSamplesBeforeVideoOff = 3;
  static const _goodSamplesBeforeVideoOn = 5;

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

  // --- proximity ---------------------------------------------------------------

  /// Screen off while the phone is at the ear — only on a voice call that is
  /// actually live and on the earpiece. On speaker, or on video, the phone is
  /// in front of the user's face and blanking it would be wrong.
  void _syncProximity(CallState s) {
    final want =
        !s.video && !s.speakerOn && s.phase == CallPhase.connected && !_closed;
    if (want == _proximityHeld) return;
    _proximityHeld = want;
    unawaited(CallProximity.setActive(active: want));
  }

  @override
  void onChange(Change<CallState> change) {
    super.onChange(change);
    _syncProximity(change.nextState);
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
    // A call that drops and returns gets its own pair of tones — the first
    // connect tone only ever plays once, so without these a recovery mid-call
    // is silent and indistinguishable from the call having died.
    if (to == CallPhase.reconnecting) {
      _sounds.reconnecting();
    } else if (to == CallPhase.connected &&
        from == CallPhase.reconnecting) {
      _sounds.reconnected();
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

    // The join is a network round-trip and the permission check is local, so
    // they overlap: on a mobile connection that is a few hundred milliseconds
    // off the front of every call. The future is started here and awaited
    // below; if the microphone is refused it is left to fail on its own.
    final joining = _joinWithRetry();
    // It is awaited below, but not on the path where the microphone is
    // refused — and a future that completes with an error and no listener at
    // all is an unhandled rejection, which the app reports as a crash.
    unawaited(joining.then((_) {}, onError: (_) {}));

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
      join = await joining;
    } catch (e) {
      if (_closed) return;
      _diagnostics.log('join failed: $e');
      emit(state.copyWith(phase: CallPhase.failed, error: '$e'));
      return;
    }
    if (_closed) return;
    _join = join;
    _diagnostics.log(
      'joined as ${join.role}${join.initiator ? ' (initiator)' : ''}, '
      '${join.iceServers.length} ice servers, video=${join.video}',
    );

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
    _networkSub = _connectivity.changes.listen(
      (_) => _onNetworkChanged(),
      onError: (_) {},
    );
    _telecomSub = (_telecomEvents ?? CallTelecom.events).listen(
      _onTelecom,
      onError: (_) {},
    );
    // Tell Android this phone is in a call. Best-effort: if Telecom declines,
    // the consultation runs exactly as it did before.
    unawaited(
      CallTelecom.start(callId: sid, peerName: join.peerName),
    );
    unawaited(
      _keepAlive.start(
        title: keepAliveTitle,
        text: join.peerName,
        video: video,
      ),
    );

    emit(state.copyWith(phase: CallPhase.waitingPeer, peerName: join.peerName));
    _sendHello();
    _scheduleHello();
    _heartbeatTimer = Timer.periodic(
      Duration(seconds: max(3, join.heartbeatSeconds)),
      (_) => _heartbeat(),
    );
  }

  /// Re-announce presence until the peer answers, quickly at first.
  ///
  /// A flat interval means the side that opens its call screen a moment later
  /// waits a whole one in silence before it hears from us. The first few
  /// retries are fractions of [CallTimings.hello] so the common case — both
  /// screens opening within a second or two of each other — connects almost at
  /// once, then it settles down to the steady interval.
  void _scheduleHello() {
    _helloTimer?.cancel();
    final base = timings.hello.inMilliseconds;
    final ms = switch (_helloAttempt) {
      0 => base ~/ 10,
      1 => base ~/ 4,
      2 => base ~/ 2,
      _ => base,
    };
    _helloAttempt++;
    _helloTimer = Timer(Duration(milliseconds: max(ms, 1)), () {
      if (_closed || state.phase == CallPhase.connected) return;
      _sendHello();
      _scheduleHello();
    });
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
    // Telecom owns the route when it is managing the call, and it is the only
    // one aware of a connected headset — going around it leaves the two
    // disagreeing about where the audio is. It answers false when it isn't
    // managing this call, and then the engine sets the route itself.
    if (!await CallTelecom.setSpeaker(on: on)) {
      try {
        await _engine.setSpeakerphone(on);
      } catch (_) {}
    }
    _emitIfOpen(state.copyWith(speakerOn: on, bluetooth: false));
  }

  /// Camera on/off during a video call. The track stays in place (no renegotiation);
  /// the peer is told so their tile can fall back to an avatar.
  ///
  /// Pressing this hands control back to the user: if the network had paused
  /// the picture ([_adaptVideo]), it stops trying to manage it from here on.
  Future<void> toggleCamera() async {
    if (!state.video) return;
    _cameraOffForNetwork = false;
    _poorSamples = 0;
    _goodSamples = 0;
    await _setCamera(!state.cameraOn, pausedForNetwork: false);
  }

  Future<void> _setCamera(bool on, {required bool pausedForNetwork}) async {
    if (!state.video) return;
    try {
      await _engine.setCameraEnabled(on);
    } catch (_) {}
    _emitIfOpen(
      state.copyWith(cameraOn: on, videoPausedForNetwork: pausedForNetwork),
    );
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
        _diagnostics.log(
          _everConnected ? 'ice: recovered' : 'ice: connected',
        );
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
        _diagnostics.log(
          'ice: ${ice.name}'
          '${state.relayed ? ' (relayed)' : ''} rtt=${_lastRttMs}ms '
          'loss=$_lastLossPct%',
        );
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
  ///
  /// [force] skips the re-offer cooldown, for a recovery we already know is
  /// needed (the network changed underneath us) rather than one ICE is merely
  /// suspicious about.
  Future<void> _recover({bool force = false}) async {
    if (_closed || state.phase == CallPhase.connected) return;
    if (_initiator) {
      if (force || _offerCooledDown) await _offer(iceRestart: true);
    } else {
      _sendHello();
    }
  }

  /// Android's telecom stack acted on the call it is managing for us.
  ///
  /// A hold is what happens when a cellular call takes the line: the
  /// consultation stays up and billed, but our microphone goes quiet so the
  /// astrologer isn't listening in on the other conversation. A disconnect is
  /// Telecom taking the call away — a headset hang-up button, or the system
  /// making room — and is as final as pressing End.
  Future<void> _onTelecom(CallTelecomEvent event) async {
    if (_closed) return;
    switch (event) {
      case TelecomHold():
        _diagnostics.log('telecom: held (cellular call)');
        if (!state.muted) await toggleMute();
      case TelecomUnhold():
        _diagnostics.log('telecom: released');
        if (state.muted) await toggleMute();
      case TelecomDisconnect():
        _diagnostics.log('telecom: disconnect');
        await hangUp();
      case TelecomAudioRoute(speaker: final speaker, bluetooth: final bluetooth):
        // Telecom owns the route, so this corrects our own idea of it — a
        // headset connecting mid-call used to leave the speaker button
        // claiming something that was no longer true.
        if (speaker != state.speakerOn || bluetooth != state.bluetooth) {
          _diagnostics.log(
            'audio route: ${bluetooth ? 'bluetooth' : (speaker ? 'speaker' : 'earpiece')}',
          );
          _emitIfOpen(
            state.copyWith(speakerOn: speaker, bluetooth: bluetooth),
          );
        }
    }
  }

  /// The phone moved to another network (Wi-Fi <-> mobile, or came back from a
  /// dead spot). Whatever path the call was on is gone, so restart ICE now:
  /// waiting for ICE to work that out itself costs seconds of silence, and on
  /// a paid call that silence is the customer's money.
  ///
  /// Debounced, because a hand-off arrives as a burst of events and only the
  /// network the phone settles on is worth renegotiating against.
  void _onNetworkChanged() {
    if (_closed || !_everConnected) return;
    _diagnostics.log('network changed');
    _networkDebounce?.cancel();
    _networkDebounce = Timer(timings.networkSettle, () {
      if (_closed || !_everConnected) return;
      if (state.phase != CallPhase.connected &&
          state.phase != CallPhase.reconnecting) {
        return; // ended, failed — nothing to recover
      }
      if (state.phase != CallPhase.reconnecting) {
        emit(state.copyWith(phase: CallPhase.reconnecting));
        unawaited(_report(CallNetState.reconnecting));
      }
      _reconnectTimer?.cancel();
      unawaited(_recover(force: true));
    });
  }

  // --- backend + stats ----------------------------------------------------------------

  Future<void> _report(CallNetState s) async {
    if (!_everConnected && s != CallNetState.disconnected) return;
    try {
      await _backend.reportState(
        s,
        relayed: state.relayed ? true : null,
        quality: state.quality > 0 ? state.quality : null,
        rttMs: _lastRttMs,
        lossPct: _lastLossPct,
      );
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
      if (rtt != null) _lastRttMs = (rtt * 1000).round().clamp(0, 60000);
      if (loss != null) _lastLossPct = (loss * 100).round().clamp(0, 100);
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
      await _adaptVideo(quality);
    } catch (_) {}
  }

  /// Drop the picture when the connection can't carry it, and bring it back
  /// when it can.
  ///
  /// Video is what saturates a weak link, and when it does the audio goes with
  /// it — which on a paid consultation is the part that actually matters.
  /// Rather than let both freeze, the camera goes off and the call carries on
  /// as voice.
  ///
  /// The thresholds are deliberately asymmetric: quick to give the picture up
  /// (~3 samples of poor), slow to take it back (~5 of good). A link that is
  /// borderline should settle on audio rather than flap between the two.
  Future<void> _adaptVideo(int quality) async {
    if (_closed || !state.video || state.phase != CallPhase.connected) return;

    if (quality == 1) {
      _goodSamples = 0;
      _poorSamples++;
      if (state.cameraOn && _poorSamples >= _poorSamplesBeforeVideoOff) {
        _poorSamples = 0;
        _cameraOffForNetwork = true;
        _diagnostics.log('video paused: weak connection');
        await _setCamera(false, pausedForNetwork: true);
      }
      return;
    }

    _poorSamples = 0;
    // Only ever undo our own doing — a camera the user turned off stays off.
    if (!_cameraOffForNetwork || quality < 3) return;
    _goodSamples++;
    if (_goodSamples < _goodSamplesBeforeVideoOn) return;
    _goodSamples = 0;
    _cameraOffForNetwork = false;
    _diagnostics.log('video resumed: connection recovered');
    await _setCamera(true, pausedForNetwork: false);
  }

  void _emitIfOpen(CallState next) {
    if (!isClosed && !_closed) emit(next);
  }

  // --- teardown ------------------------------------------------------------------------

  Future<void> _teardown(CallEndReason reason) async {
    if (_closed) return;
    _closed = true;
    // The last breadcrumb, and the one that says how the call actually went.
    _diagnostics.log(
      'call ended: ${reason.name}, connected=$_everConnected '
      'relayed=${state.relayed} quality=${state.quality} '
      'rtt=${_lastRttMs}ms loss=$_lastLossPct%',
    );
    _helloTimer?.cancel();
    _heartbeatTimer?.cancel();
    _reconnectTimer?.cancel();
    _statsTimer?.cancel();
    _networkDebounce?.cancel();
    await _signalSub?.cancel();
    await _localVideoSub?.cancel();
    await _networkSub?.cancel();
    await _telecomSub?.cancel();
    await _dropPeer();
    try {
      await _engine.release();
    } catch (_) {}
    unawaited(_keepAlive.stop());
    // Or the OS goes on believing this phone is in a call — blocking the next
    // one and holding the audio route.
    unawaited(CallTelecom.end());
    // Never leave the proximity lock behind: the screen would stay dark and
    // the phone would look broken long after the call is over.
    if (_proximityHeld) {
      _proximityHeld = false;
      unawaited(CallProximity.setActive(active: false));
    }
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
