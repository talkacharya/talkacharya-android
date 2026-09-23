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
  _Backend(this.role, {this.video = false});
  final String role;
  final bool video;
  final reports = <CallNetState>[];
  final qualityReports = <Map<String, int?>>[];
  var ended = 0;

  @override
  Future<CallJoin> join() async => CallJoin(
    room: 'r1',
    signalingChannel: 'call:r1',
    role: role,
    initiator: role == 'customer',
    iceServers: const [],
    video: video,
    peerName: role == 'customer' ? 'Acharya' : 'Priya',
    heartbeatSeconds: 3,
  );

  @override
  Future<void> reportState(
    CallNetState state, {
    bool? relayed,
    int? quality,
    int? rttMs,
    int? lossPct,
  }) async {
    reports.add(state);
    qualityReports.add({'quality': quality, 'rtt': rttMs, 'loss': lossPct});
  }

  @override
  Future<void> endConsultation() async => ended++;
}

class _Perms implements CallPermissions {
  _Perms([this.result = MediaPermission.granted, MediaPermission? camera])
    : camera = camera ?? result;
  final MediaPermission result;
  final MediaPermission camera;
  var cameraAsked = 0;

  @override
  Future<MediaPermission> requestMicrophone() async => result;
  @override
  Future<MediaPermission> requestCamera() async {
    cameraAsked++;
    return camera;
  }

  @override
  Future<void> openSettings() async {}
}

class _Peer implements RtcPeer {
  _Peer({this.video = false});
  final bool video;
  final candidates = StreamController<Map<String, dynamic>>.broadcast();
  final ice = StreamController<RtcIceState>.broadcast();
  final remoteVideoStreams = StreamController<RtcVideoStream?>.broadcast();
  final offers = <bool>[]; // iceRestart flags
  final remote = <String>[];
  bool closed = false;
  bool _remoteSet = false;

  @override
  Stream<Map<String, dynamic>> get localCandidates => candidates.stream;
  @override
  Stream<RtcIceState> get iceStates => ice.stream;
  @override
  Stream<RtcVideoStream?> get remoteVideo => remoteVideoStreams.stream;
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
  final localVideoStreams = StreamController<RtcVideoStream?>.broadcast();
  var micOpen = false;
  var cameraOpen = false;
  var released = false;
  var flips = 0;
  bool? micEnabled;
  bool? cameraEnabled;
  bool? speaker;
  bool _front = true;

  _Peer get last => peers.last;

  @override
  Stream<RtcVideoStream?> get localVideo => localVideoStreams.stream;

  @override
  Future<void> openMedia({bool video = false}) async {
    micOpen = true;
    cameraOpen = video;
    // Matches the real engine: the camera's first frame is pushed as the very
    // last step inside openMedia(), before it returns — see the regression
    // test below for why that ordering matters.
    if (video) localVideoStreams.add(Object());
  }

  @override
  Future<RtcPeer> createPeer(
    List<Map<String, dynamic>> iceServers, {
    bool video = false,
  }) async {
    final p = _Peer(video: video);
    peers.add(p);
    return p;
  }

  /// A disposed/invalid native audio track throws instead of just failing
  /// quietly — see the regression test below for why `toggleMute` must not
  /// let that propagate.
  bool micThrows = false;

  @override
  Future<void> setMicrophoneEnabled(bool enabled) async {
    if (micThrows) throw StateError('native track disposed');
    micEnabled = enabled;
  }
  @override
  Future<void> setCameraEnabled(bool enabled) async => cameraEnabled = enabled;
  @override
  Future<bool> switchCamera() async {
    flips++;
    return _front = !_front;
  }

  @override
  Future<void> setSpeakerphone(bool on) async => speaker = on;
  @override
  Future<void> release() async => released = true;
}

/// A network the test can move the phone between.
class _Network implements CallConnectivity {
  final _controller = StreamController<void>.broadcast();

  /// The phone switched Wi-Fi <-> mobile (or came back from a dead spot).
  void change() => _controller.add(null);

  @override
  Stream<void> get changes => _controller.stream;

  Future<void> dispose() => _controller.close();
}

class _KeepAlive implements CallKeepAlive {
  var started = 0;
  var stopped = 0;
  bool? startedWithVideo;

  @override
  Future<void> start({
    required String title,
    required String text,
    bool video = false,
  }) async {
    started++;
    startedWithVideo = video;
  }

  @override
  Future<void> stop() async => stopped++;
}

const _fast = CallTimings(
  hello: Duration(milliseconds: 40),
  reconnectAfter: Duration(milliseconds: 30),
  reofferCooldown: Duration(milliseconds: 10),
  stats: Duration(milliseconds: 50),
  networkSettle: Duration(milliseconds: 10),
);

/// Long enough that nothing in a test reaches it by waiting — so a recovery
/// that happens must have come from the network change, not the timeout.
const _slowReconnect = CallTimings(
  hello: Duration(milliseconds: 40),
  reconnectAfter: Duration(seconds: 30),
  reofferCooldown: Duration(seconds: 30),
  stats: Duration(milliseconds: 50),
  networkSettle: Duration(milliseconds: 10),
);

Future<void> _settle([int ms = 120]) =>
    Future<void>.delayed(Duration(milliseconds: ms));

typedef _Side = ({CallController c, _Backend backend, _Engine engine});

_Side _side(
  String role,
  _Hub hub, {
  MediaPermission perm = MediaPermission.granted,
  MediaPermission? cameraPerm,
  bool video = false,
  CallSounds sounds = const NoopCallSounds(),
  bool ringback = false,
  CallConnectivity connectivity = const NoopCallConnectivity(),
  CallKeepAlive keepAlive = const NoopCallKeepAlive(),
  CallTimings timings = _fast,
  Stream<CallTelecomEvent>? telecomEvents,
}) {
  final backend = _Backend(role, video: video);
  final engine = _Engine();
  final c = CallController(
    backend: backend,
    signaling: hub,
    engine: engine,
    permissions: _Perms(perm, cameraPerm),
    keepAlive: keepAlive,
    connectivity: connectivity,
    timings: timings,
    sessionId: '$role-sid',
    sounds: sounds,
    ringback: ringback,
    telecomEvents: telecomEvents,
  );
  return (c: c, backend: backend, engine: engine);
}

class _Sounds implements CallSounds {
  final played = <String>[];
  @override
  void startRingback() => played.add('ring');
  @override
  void stopRingback() => played.add('stop');
  @override
  void connected() => played.add('connected');
  @override
  void ended() => played.add('ended');
}

void main() {
  test(
    'sounds: caller rings back until connected, then connect + end tones',
    () async {
      final hub = _Hub();
      final custSounds = _Sounds();
      final astroSounds = _Sounds();
      final cust = _side('customer', hub, sounds: custSounds, ringback: true);
      final astro = _side('astrologer', hub, sounds: astroSounds);

      // ringback starts as soon as the room exists (still waiting for accept)
      expect(custSounds.played, ['ring']);
      await cust.c.start();
      await astro.c.start();
      await _settle();
      expect(custSounds.played, ['ring']); // no gap through joining/connecting

      cust.engine.last.ice.add(RtcIceState.connected);
      astro.engine.last.ice.add(RtcIceState.connected);
      await _settle(40);
      expect(custSounds.played, ['ring', 'stop', 'connected']);
      expect(astroSounds.played, ['connected']);

      // a drop and recovery does not ring again or replay the connect tone
      cust.engine.last.ice.add(RtcIceState.disconnected);
      await _settle(20);
      cust.engine.last.ice.add(RtcIceState.connected);
      await _settle(20);
      expect(custSounds.played, ['ring', 'stop', 'connected']);

      await cust.c.hangUp();
      await _settle();
      expect(custSounds.played.last, 'ended');
      await cust.c.close();
      await astro.c.close();
      expect(custSounds.played.where((x) => x == 'ended'), hasLength(1));
    },
  );

  test('sounds: a declined request stops ringback with the end tone', () async {
    final sounds = _Sounds();
    final cust = _side('customer', _Hub(), sounds: sounds, ringback: true);
    await cust.c.close(); // room closed while never started
    expect(sounds.played, ['ring', 'stop', 'ended']);
  });

  test('sounds: a room that never rang stays silent when closed', () async {
    final sounds = _Sounds();
    final astro = _side('astrologer', _Hub(), sounds: sounds);
    await astro.c.close();
    expect(sounds.played, isEmpty);
  });

  test('microphone refusal stops before joining', () async {
    final hub = _Hub();
    final s = _side('customer', hub, perm: MediaPermission.permanentlyDenied);
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
    expect(
      cust.engine.last.offers,
      contains(true),
    ); // an ICE-restart offer went out

    cust.engine.last.ice.add(RtcIceState.connected);
    await _settle(20);
    expect(cust.c.state.phase, CallPhase.connected);
    expect(cust.backend.reports.last, CallNetState.connected);

    await cust.c.close();
    await astro.c.close();
  });

  test('a network switch restarts ICE without waiting for the timeout', () async {
    final hub = _Hub();
    final net = _Network();
    // Both the reconnect timeout and the re-offer cooldown are 30s here, so an
    // ICE restart inside a few ms can only have come from the network change.
    final cust = _side(
      'customer',
      hub,
      connectivity: net,
      timings: _slowReconnect,
    );
    final astro = _side('astrologer', hub, timings: _slowReconnect);
    await cust.c.start();
    await astro.c.start();
    await _settle();
    cust.engine.last.ice.add(RtcIceState.connected);
    await _settle(20);
    expect(cust.c.state.phase, CallPhase.connected);
    final offersBefore = cust.engine.last.offers.length;

    net.change(); // walked out of Wi-Fi onto mobile data
    await _settle(40);

    expect(cust.c.state.phase, CallPhase.reconnecting);
    expect(cust.backend.reports.last, CallNetState.reconnecting);
    expect(cust.engine.last.offers.length, greaterThan(offersBefore));
    expect(cust.engine.last.offers.last, isTrue); // an ICE-restart offer

    cust.engine.last.ice.add(RtcIceState.connected);
    await _settle(20);
    expect(cust.c.state.phase, CallPhase.connected);

    await cust.c.close();
    await astro.c.close();
    await net.dispose();
  });

  test('a network blip before the call connects is ignored', () async {
    final hub = _Hub();
    final net = _Network();
    final cust = _side('customer', hub, connectivity: net);
    await cust.c.start();
    await _settle();

    net.change();
    await _settle(40);

    // Nothing has connected yet — the hellos are still doing their job and a
    // "reconnecting" here would be a lie to the user.
    expect(cust.c.state.phase, isNot(CallPhase.reconnecting));

    await cust.c.close();
    await net.dispose();
  });

  test('a cellular call holds the consultation, and releasing it resumes', () async {
    final hub = _Hub();
    final telecom = StreamController<CallTelecomEvent>.broadcast();
    final cust = _side('customer', hub, telecomEvents: telecom.stream);
    final astro = _side('astrologer', hub);
    await cust.c.start();
    await astro.c.start();
    await _settle();
    cust.engine.last.ice.add(RtcIceState.connected);
    await _settle(20);
    expect(cust.c.state.muted, isFalse);

    // Someone rings the phone: Telecom takes the line for the cellular call.
    telecom.add(const TelecomHold());
    await _settle(20);
    expect(cust.c.state.muted, isTrue);
    expect(cust.engine.micEnabled, isFalse);
    // Held, not ended — the consultation is still up and still billed.
    expect(cust.c.state.phase, CallPhase.connected);

    telecom.add(const TelecomUnhold());
    await _settle(20);
    expect(cust.c.state.muted, isFalse);
    expect(cust.engine.micEnabled, isTrue);

    await cust.c.close();
    await astro.c.close();
    await telecom.close();
  });

  test('a telecom disconnect ends the consultation', () async {
    final hub = _Hub();
    final telecom = StreamController<CallTelecomEvent>.broadcast();
    final cust = _side('customer', hub, telecomEvents: telecom.stream);
    final astro = _side('astrologer', hub);
    await cust.c.start();
    await astro.c.start();
    await _settle();
    cust.engine.last.ice.add(RtcIceState.connected);
    await _settle(20);

    // The headset's hang-up button, or the system making room for a call.
    telecom.add(const TelecomDisconnect());
    await _settle(30);

    expect(cust.c.state.phase, CallPhase.ended);
    expect(cust.backend.ended, 1); // the consultation really was ended
    await cust.c.close();
    await astro.c.close();
    await telecom.close();
  });

  test('a state report carries transport health to the server', () async {
    final hub = _Hub();
    final cust = _side('customer', hub);
    final astro = _side('astrologer', hub);
    await cust.c.start();
    await astro.c.start();
    await _settle();
    cust.engine.last.ice.add(RtcIceState.connected);
    // Long enough for a stats sample (50ms) to land.
    await _settle(120);

    // The heartbeat itself is floored at 3s, so drive a report the way a real
    // problem would: the call drops, and the report that goes out about it is
    // the one worth having the numbers on.
    cust.engine.last.ice.add(RtcIceState.disconnected);
    await _settle(30);

    final sampled = cust.backend.qualityReports.where(
      (r) => r['quality'] != null,
    );
    expect(sampled, isNotEmpty, reason: 'quality never reached the server');
    // The fake peer reports 50ms RTT and no loss — good, and carried as such.
    expect(sampled.last['quality'], 3);
    expect(sampled.last['rtt'], 50);
    expect(sampled.last['loss'], 0);

    await cust.c.close();
    await astro.c.close();
  });

  test('a telecom audio route correction reaches the state', () async {
    final hub = _Hub();
    final telecom = StreamController<CallTelecomEvent>.broadcast();
    final cust = _side('customer', hub, telecomEvents: telecom.stream);
    await cust.c.start();
    await _settle();
    expect(cust.c.state.speakerOn, isFalse);

    // A headset connects: Telecom owns the route, so our idea of it follows.
    telecom.add(const TelecomAudioRoute(speaker: false, bluetooth: true));
    await _settle(20);
    expect(cust.c.state.bluetooth, isTrue);
    expect(cust.c.state.speakerOn, isFalse);

    telecom.add(const TelecomAudioRoute(speaker: true, bluetooth: false));
    await _settle(20);
    expect(cust.c.state.speakerOn, isTrue);
    expect(cust.c.state.bluetooth, isFalse);

    await cust.c.close();
    await telecom.close();
  });

  test('hellos start fast and then back off', () async {
    final hub = _Hub();
    // No peer answers, so the hellos just keep going.
    final cust = _side('customer', hub);
    await cust.c.start();
    // Within one steady interval (40ms) the old flat timer would have sent
    // one hello; the backoff gets several out while nobody has answered.
    await _settle(45);
    final early = hub.typesFrom('customer').where((t) => t == 'hello').length;
    expect(early, greaterThan(2));

    await cust.c.close();
  });

  test('the keep-alive service claims the camera on a video call', () async {
    final hub = _Hub();
    final voiceKeepAlive = _KeepAlive();
    final videoKeepAlive = _KeepAlive();

    final voice = _side('customer', hub, keepAlive: voiceKeepAlive);
    await voice.c.start();
    await _settle(20);
    expect(voiceKeepAlive.startedWithVideo, isFalse);
    await voice.c.close();

    final video = _side(
      'astrologer',
      _Hub(),
      video: true,
      keepAlive: videoKeepAlive,
    );
    await video.c.start();
    await _settle(20);
    // Android 14+ cuts the camera off in the background otherwise.
    expect(videoKeepAlive.startedWithVideo, isTrue);
    await video.c.close();
    expect(videoKeepAlive.stopped, 1);
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

  test('a mute tap that hits a disposed track does not crash', () async {
    final hub = _Hub();
    final s = _side('customer', hub);
    await s.c.start();
    s.engine.micThrows = true;
    // Must not throw out of the tap handler — the call's own state still
    // flips so the UI reflects what the user asked for.
    await s.c.toggleMute();
    expect(s.c.state.muted, isTrue);
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

  // --- video ---------------------------------------------------------------

  test('a voice call never asks for the camera', () async {
    final hub = _Hub();
    final s = _side('customer', hub);
    await s.c.start();
    expect(s.c.state.video, isFalse);
    expect(s.engine.cameraOpen, isFalse);
    await s.c.close();
  });

  test('a video call opens the camera and starts on speaker', () async {
    final hub = _Hub();
    final s = _side('customer', hub, video: true);
    await s.c.start();
    expect(s.c.state.video, isTrue);
    expect(s.c.state.cameraOn, isTrue);
    expect(s.c.state.speakerOn, isTrue);
    expect(s.engine.cameraOpen, isTrue);
    await s.c.close();
  });

  test('a refused camera keeps the call, without video', () async {
    final hub = _Hub();
    final s = _side(
      'customer',
      hub,
      video: true,
      cameraPerm: MediaPermission.denied,
    );
    await s.c.start();
    // the session still starts — losing the picture beats losing a paid call
    expect(s.c.state.phase, CallPhase.waitingPeer);
    expect(s.c.state.video, isTrue);
    expect(s.c.state.cameraOn, isFalse);
    expect(s.engine.cameraOpen, isFalse);
    await s.c.close();
  });

  test('turning the camera off tells the other side', () async {
    final hub = _Hub();
    final cust = _side('customer', hub, video: true);
    final astro = _side('astrologer', hub, video: true);
    await cust.c.start();
    await astro.c.start();
    await _settle();

    await cust.c.toggleCamera();
    await _settle(40);

    expect(cust.c.state.cameraOn, isFalse);
    expect(cust.engine.cameraEnabled, isFalse);
    expect(astro.c.state.peerCameraOn, isFalse);

    await cust.c.toggleCamera();
    await _settle(40);
    expect(astro.c.state.peerCameraOn, isTrue);

    await cust.c.close();
    await astro.c.close();
  });

  test('the local camera preview appears without needing a toggle', () async {
    // Regression test: `localVideo` is a broadcast stream, and the engine's
    // first frame used to be pushed *before* the controller ever subscribed
    // to it (subscribing happened after `openMedia()` returned) — a broadcast
    // stream never replays a missed event, so the self-view tile stayed blank
    // until something else (toggling the camera) pushed a second frame.
    final hub = _Hub();
    final s = _side('customer', hub, video: true);

    await s.c.start();
    await _settle();

    expect(s.c.state.localVideo, isNotNull);
    expect(s.c.state.showLocalVideo, isTrue);

    await s.c.close();
  });

  test('the peer video track reaches the state', () async {
    final hub = _Hub();
    final cust = _side('customer', hub, video: true);
    final astro = _side('astrologer', hub, video: true);
    await cust.c.start();
    await astro.c.start();
    await _settle();

    final stream = Object();
    cust.engine.last.remoteVideoStreams.add(stream);
    await _settle(40);
    expect(cust.c.state.remoteVideo, same(stream));
    expect(cust.c.state.showRemoteVideo, isTrue);

    await cust.c.close();
    await astro.c.close();
  });

  test('flip only works while the camera is on', () async {
    final hub = _Hub();
    final s = _side('customer', hub, video: true);
    await s.c.start();

    await s.c.switchCamera();
    expect(s.engine.flips, 1);
    expect(s.c.state.frontCamera, isFalse);

    await s.c.toggleCamera(); // camera off
    await s.c.switchCamera();
    expect(s.engine.flips, 1, reason: 'no flip while the camera is off');

    await s.c.close();
  });

  test('a voice call ignores the camera controls', () async {
    final hub = _Hub();
    final s = _side('customer', hub);
    await s.c.start();
    await s.c.toggleCamera();
    expect(s.c.state.cameraOn, isFalse);
    expect(s.engine.cameraEnabled, isNull);
    await s.c.close();
  });
}
