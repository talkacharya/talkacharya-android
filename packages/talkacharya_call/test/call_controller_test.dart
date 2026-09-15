import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:talkacharya_call/talkacharya_call.dart';

// --- fakes ---------------------------------------------------------------------------

/// In-memory Centrifugo: every publication is delivered to every subscriber
/// (including the publisher — the controller must ignore its own echo).
class _Hub implements CallSignaling {
  final _controllers = <String, StreamController<Map<String, dynamic>>>{};
  final published = <Map<String, dynamic>>[];

  StreamController<Map<String, dynamic>> _c(String ch) =>
      _controllers.putIfAbsent(ch, StreamController.broadcast);

  @override
  Stream<Map<String, dynamic>> frames(String channel) => _c(channel).stream;

  @override
  Future<void> publish(String channel, Map<String, dynamic> data) async {
    published.add(data);
    scheduleMicrotask(() => _c(channel).add(Map.of(data)));
  }

  List<String> typesFrom(String role) => [
    for (final m in published)
      if (m['from'] == role) '${m['t']}',
  ];
}

class _Backend implements CallBackend {
  _Backend(this.role);
  final String role;
  final reports = <CallNetState>[];
  var ended = 0;

  @override
  Future<CallJoin> join() async => CallJoin(
    room: 'r1',
    signalingChannel: 'call:r1',
    role: role,
    initiator: role == 'customer',
    iceServers: const [],
    peerName: role == 'customer' ? 'Acharya' : 'Priya',
    heartbeatSeconds: 3,
  );

  @override
  Future<void> reportState(CallNetState state, {bool? relayed}) async =>
      reports.add(state);

  @override
  Future<void> endConsultation() async => ended++;
}

class _Perms implements CallPermissions {
  _Perms([this.result = MicPermission.granted]);
  final MicPermission result;
  @override
  Future<MicPermission> requestMicrophone() async => result;
  @override
  Future<void> openSettings() async {}
}

class _Peer implements RtcPeer {
  final candidates = StreamController<Map<String, dynamic>>.broadcast();
  final ice = StreamController<RtcIceState>.broadcast();
  final offers = <bool>[]; // iceRestart flags
  final remote = <String>[];
  bool closed = false;
  bool _remoteSet = false;

  @override
  Stream<Map<String, dynamic>> get localCandidates => candidates.stream;
  @override
  Stream<RtcIceState> get iceStates => ice.stream;
  @override
  bool get hasRemoteDescription => _remoteSet;

  @override
  Future<String> createOffer({bool iceRestart = false}) async {
    offers.add(iceRestart);
    return 'offer-${offers.length}';
  }

  @override
  Future<String> acceptOffer(String sdp) async {
    _remoteSet = true;
    remote.add('offer:$sdp');
    return 'answer-for-$sdp';
  }

  @override
  Future<void> acceptAnswer(String sdp) async {
    _remoteSet = true;
    remote.add('answer:$sdp');
  }

  @override
  Future<void> addRemoteCandidate(Map<String, dynamic> c) async =>
      remote.add('ice:${c['candidate']}');

  @override
  Future<RtcStats> stats() async =>
      const RtcStats(roundTripSeconds: 0.05, lossRatio: 0, relayed: false);

  @override
  Future<void> close() async => closed = true;
}

class _Engine implements RtcEngine {
  final peers = <_Peer>[];
  var micOpen = false;
  var released = false;
  bool? micEnabled;
  bool? speaker;

  _Peer get last => peers.last;

  @override
  Future<void> openMicrophone() async => micOpen = true;
  @override
  Future<RtcPeer> createPeer(List<Map<String, dynamic>> iceServers) async {
    final p = _Peer();
    peers.add(p);
    return p;
  }

  @override
  Future<void> setMicrophoneEnabled(bool enabled) async => micEnabled = enabled;
  @override
  Future<void> setSpeakerphone(bool on) async => speaker = on;
  @override
  Future<void> release() async => released = true;
}

const _fast = CallTimings(
  hello: Duration(milliseconds: 40),
  reconnectAfter: Duration(milliseconds: 30),
  reofferCooldown: Duration(milliseconds: 10),
  stats: Duration(milliseconds: 50),
);

Future<void> _settle([int ms = 120]) =>
    Future<void>.delayed(Duration(milliseconds: ms));

typedef _Side = ({CallController c, _Backend backend, _Engine engine});

_Side _side(String role, _Hub hub, {MicPermission perm = MicPermission.granted}) {
  final backend = _Backend(role);
  final engine = _Engine();
  final c = CallController(
    backend: backend,
    signaling: hub,
    engine: engine,
    permissions: _Perms(perm),
    timings: _fast,
    sessionId: '$role-sid',
  );
  return (c: c, backend: backend, engine: engine);
}

void main() {
  test('microphone refusal stops before joining', () async {
    final hub = _Hub();
    final s = _side('customer', hub, perm: MicPermission.permanentlyDenied);
    await s.c.start();
    expect(s.c.state.phase, CallPhase.permissionDenied);
    expect(s.c.state.permanentlyDenied, isTrue);
    expect(s.engine.micOpen, isFalse);
    await s.c.close();
  });

  test('customer offers, astrologer answers, both connect and report', () async {
    final hub = _Hub();
    final cust = _side('customer', hub);
    final astro = _side('astrologer', hub);

    await cust.c.start();
    expect(cust.c.state.phase, CallPhase.waitingPeer);
    await astro.c.start();
    await _settle();

    // only the initiator sends offers; the astrologer answers exactly the offer it got
    expect(hub.typesFrom('customer'), contains('offer'));
    expect(hub.typesFrom('astrologer'), isNot(contains('offer')));
    expect(hub.typesFrom('astrologer'), contains('answer'));
    expect(astro.engine.last.remote.first, startsWith('offer:offer-'));
    expect(cust.engine.last.remote, contains(startsWith('answer:answer-for-')));

    // trickle ICE both ways
    cust.engine.last.candidates.add({'candidate': 'c-cust'});
    astro.engine.last.candidates.add({'candidate': 'c-astro'});
    await _settle(40);
    expect(astro.engine.last.remote, contains('ice:c-cust'));
    expect(cust.engine.last.remote, contains('ice:c-astro'));

    // nothing reported to the backend before the first connection
    expect(cust.backend.reports, isEmpty);

    cust.engine.last.ice.add(RtcIceState.connected);
    astro.engine.last.ice.add(RtcIceState.connected);
    await _settle(40);
    expect(cust.c.state.phase, CallPhase.connected);
    expect(cust.c.state.connectedAt, isNotNull);
    expect(cust.c.state.quality, 3);
    expect(cust.backend.reports, contains(CallNetState.connected));
    expect(astro.backend.reports, contains(CallNetState.connected));

    await cust.c.close();
    await astro.c.close();
  });

  test('drop → reconnecting → initiator ICE-restarts → recovers', () async {
    final hub = _Hub();
    final cust = _side('customer', hub);
    final astro = _side('astrologer', hub);
    await cust.c.start();
    await astro.c.start();
    await _settle();
    cust.engine.last.ice.add(RtcIceState.connected);
    await _settle(20);

    cust.engine.last.ice.add(RtcIceState.disconnected);
    await _settle(20);
    expect(cust.c.state.phase, CallPhase.reconnecting);
    expect(cust.backend.reports.last, CallNetState.reconnecting);

    await _settle(80); // past reconnectAfter
    expect(cust.engine.last.offers, contains(true)); // an ICE-restart offer went out

    cust.engine.last.ice.add(RtcIceState.connected);
    await _settle(20);
    expect(cust.c.state.phase, CallPhase.connected);
    expect(cust.backend.reports.last, CallNetState.connected);

    await cust.c.close();
    await astro.c.close();
  });

  test('peer app restart (new sid) replaces the peer connection', () async {
    final hub = _Hub();
    final cust = _side('customer', hub);
    var astro = _side('astrologer', hub);
    await cust.c.start();
    await astro.c.start();
    await _settle();
    final firstPeer = cust.engine.last;

    // astrologer's screen is killed without a bye, then re-opened with a new sid
    await astro.c.close();
    final backend = _Backend('astrologer');
    final engine = _Engine();
    final again = CallController(
      backend: backend,
      signaling: hub,
      engine: engine,
      permissions: _Perms(),
      timings: _fast,
      sessionId: 'astrologer-sid-2',
    );
    astro = (c: again, backend: backend, engine: engine);
    await again.start();
    await _settle();

    expect(firstPeer.closed, isTrue);
    expect(cust.engine.peers.length, 2);
    expect(engine.last.remote.first, startsWith('offer:'));

    await cust.c.close();
    await again.close();
  });

  test('hang up ends the consultation, says bye, peer ends too', () async {
    final hub = _Hub();
    final cust = _side('customer', hub);
    final astro = _side('astrologer', hub);
    await cust.c.start();
    await astro.c.start();
    await _settle();

    await astro.c.hangUp();
    await _settle(40);

    expect(astro.c.state.phase, CallPhase.ended);
    expect(astro.c.state.endReason, CallEndReason.localHangUp);
    expect(astro.backend.ended, 1);
    expect(astro.backend.reports, contains(CallNetState.disconnected));
    expect(astro.engine.released, isTrue);

    expect(cust.c.state.phase, CallPhase.ended);
    expect(cust.c.state.endReason, CallEndReason.remoteHangUp);
    expect(cust.backend.ended, 0);

    await cust.c.close();
    await astro.c.close();
  });

  test('mute and speaker toggle the engine', () async {
    final hub = _Hub();
    final s = _side('customer', hub);
    await s.c.start();
    await s.c.toggleMute();
    expect(s.c.state.muted, isTrue);
    expect(s.engine.micEnabled, isFalse);
    await s.c.toggleSpeaker();
    expect(s.c.state.speakerOn, isTrue);
    expect(s.engine.speaker, isTrue);
    await s.c.close();
  });

  test('server-side end tears down without ending again', () async {
    final hub = _Hub();
    final s = _side('customer', hub);
    await s.c.start();
    await s.c.onConsultationEnded();
    expect(s.c.state.phase, CallPhase.ended);
    expect(s.c.state.endReason, CallEndReason.consultationEnded);
    expect(s.backend.ended, 0);
    await s.c.close();
  });
}
