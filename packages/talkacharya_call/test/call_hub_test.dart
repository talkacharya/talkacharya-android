/// The hub is what lets a call outlive the screen that started it.
///
/// Before it was wired up, walking out of the consultation room disposed the
/// controller and hung up on a paid session — so these are the guarantees the
/// apps now lean on.
library;

import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:talkacharya_call/talkacharya_call.dart';

class _Signaling implements CallSignaling {
  final _controllers = <String, StreamController<Map<String, dynamic>>>{};

  @override
  Stream<Map<String, dynamic>> frames(String channel) => _controllers
      .putIfAbsent(channel, StreamController<Map<String, dynamic>>.broadcast)
      .stream;

  @override
  Future<void> publish(String channel, Map<String, dynamic> data) async {}
}

class _Backend implements CallBackend {
  var ended = 0;

  @override
  Future<CallJoin> join() async => const CallJoin(
    room: 'r',
    signalingChannel: 'call:c1',
    role: 'customer',
    initiator: true,
    iceServers: [],
  );

  @override
  Future<void> reportState(
    CallNetState state, {
    bool? relayed,
    int? quality,
    int? rttMs,
    int? lossPct,
  }) async {}

  @override
  Future<void> endConsultation() async => ended++;
}

class _Engine implements RtcEngine {
  var released = false;

  @override
  Stream<RtcVideoStream?> get localVideo => const Stream.empty();

  @override
  Future<void> openMedia({bool video = false}) async {}

  @override
  Future<RtcPeer> createPeer(
    List<Map<String, dynamic>> iceServers, {
    bool video = false,
  }) async => throw UnimplementedError();

  @override
  Future<void> setMicrophoneEnabled(bool enabled) async {}

  @override
  Future<void> setSpeakerphone(bool on) async {}

  @override
  Future<void> setCameraEnabled(bool enabled) async {}

  @override
  Future<bool> switchCamera() async => true;

  @override
  Future<void> release() async => released = true;
}

CallController _controller() => CallController(
  backend: _Backend(),
  signaling: _Signaling(),
  engine: _Engine(),
  permissions: const _Perms(),
  sessionId: 'sid',
);

class _Perms implements CallPermissions {
  const _Perms();
  @override
  Future<MediaPermission> requestMicrophone() async => MediaPermission.granted;
  @override
  Future<MediaPermission> requestCamera() async => MediaPermission.granted;
  @override
  Future<void> openSettings() async {}
}

const _info = CallInfo(consultationId: 'c1', peerName: 'Acharya');

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('a call handed to the hub is not closed when its room goes away', () {
    final hub = CallHub();
    final call = _controller();

    hub.attach(call, _info);
    hub.roomOpened('c1');
    hub.roomClosed('c1'); // the screen is disposed; the call is not

    expect(hub.hasCall, isTrue);
    expect(hub.isFor('c1'), isTrue);
    expect(call.isClosed, isFalse);
  });

  test('minimize and expand move the call between bar and screen', () {
    final hub = CallHub()..attach(_controller(), _info);
    expect(hub.expanded, isTrue);

    hub.minimize();
    expect(hub.expanded, isFalse);

    hub.expand();
    expect(hub.expanded, isTrue);
  });

  test('release closes the call and forgets it', () async {
    final hub = CallHub();
    final call = _controller();
    hub.attach(call, _info);

    await hub.release();

    expect(hub.hasCall, isFalse);
    expect(hub.isFor('c1'), isFalse);
    expect(call.isClosed, isTrue);
  });

  test('attaching a second call closes the first — never two live calls', () {
    final hub = CallHub();
    final first = _controller();
    hub.attach(first, _info);

    hub.attach(
      _controller(),
      const CallInfo(consultationId: 'c2', peerName: 'Other'),
    );

    expect(hub.isFor('c2'), isTrue);
    expect(hub.isFor('c1'), isFalse);
  });

  test('the hub knows whether a room for the call is already on the stack', () {
    // The minimized bar uses this to return to the open room instead of
    // pushing a second copy of the same conversation.
    final hub = CallHub()..attach(_controller(), _info);

    expect(hub.isRoomOpen('c1'), isFalse);
    hub.roomOpened('c1');
    expect(hub.isRoomOpen('c1'), isTrue);
    hub.roomOpened('c1'); // pushed twice (deep link on top of the room)
    hub.roomClosed('c1');
    expect(hub.isRoomOpen('c1'), isTrue, reason: 'one copy is still open');
    hub.roomClosed('c1');
    expect(hub.isRoomOpen('c1'), isFalse);
  });

  test('a call that ends while minimized lets itself go', () async {
    // Nothing is on screen to clean it up, and a finished call left in the hub
    // would keep claiming the consultation is still in progress.
    final hub = CallHub();
    final call = _controller();
    hub
      ..attach(call, _info)
      ..minimize();

    await call.hangUp();
    await Future<void>.delayed(Duration.zero);

    expect(hub.hasCall, isFalse);
  });

  test('a call that ends with the room open is left for the screen', () async {
    final hub = CallHub();
    final call = _controller();
    hub.attach(call, _info); // expanded

    await call.hangUp();
    await Future<void>.delayed(Duration.zero);

    expect(hub.hasCall, isTrue, reason: 'the room releases it on dispose');
  });

  test('listeners hear every change, so the overlay repaints', () {
    final hub = CallHub();
    var notifications = 0;
    hub.addListener(() => notifications++);

    hub
      ..attach(_controller(), _info)
      ..minimize()
      ..expand();

    expect(notifications, 3);
  });
}
