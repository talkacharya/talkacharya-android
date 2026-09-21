import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:talkacharya_live/talkacharya_live.dart';

// --- fakes -----------------------------------------------------------------

/// In-memory Centrifugo: the app pushes frames, the cubit reacts.
class _Hub implements LiveSignaling {
  final _controllers = <String, StreamController<Map<String, dynamic>>>{};

  StreamController<Map<String, dynamic>> _c(String ch) =>
      _controllers.putIfAbsent(ch, StreamController.broadcast);

  @override
  Stream<Map<String, dynamic>> frames(String channel) => _c(channel).stream;

  void push(String channel, String type, Map<String, dynamic> data) =>
      _c(channel).add({'type': type, 'data': data});
}

class _Engine implements LiveRoomEngine {
  final remote = StreamController<LiveVideoTrack?>.broadcast();
  final local = StreamController<LiveVideoTrack?>.broadcast();
  final connections = StreamController<LiveConnection>.broadcast();
  final enabled = StreamController<bool>.broadcast();

  String? connectedTo;
  bool published = false;
  bool disconnected = false;
  bool? camera;
  bool? mic;
  int flips = 0;
  bool _front = true;

  /// Set to make connecting blow up (no media server, bad token…).
  Object? failWith;

  @override
  Stream<LiveVideoTrack?> get remoteVideo => remote.stream;
  @override
  Stream<LiveVideoTrack?> get localVideo => local.stream;
  @override
  Stream<LiveConnection> get connectionStates => connections.stream;
  @override
  Stream<bool> get remoteVideoEnabled => enabled.stream;

  @override
  Future<void> connect({
    required String url,
    required String token,
    bool publish = false,
  }) async {
    if (failWith != null) throw failWith!;
    connectedTo = url;
    published = publish;
  }

  @override
  Future<void> setCameraEnabled(bool enabled) async => camera = enabled;
  @override
  Future<void> setMicrophoneEnabled(bool enabled) async => mic = enabled;
  @override
  Future<bool> switchCamera() async {
    flips++;
    return _front = !_front;
  }

  @override
  Future<void> disconnect() async => disconnected = true;
}

const _join = LiveJoin(
  url: 'wss://media.test',
  room: 'live_1',
  token: 'tok',
  identity: 'me',
  role: 'viewer',
  canPublish: false,
  chatChannel: 'live:1',
  viewerCount: 7,
);

class _ViewerBackend implements LiveViewerBackend {
  final images = <String?>[];
  _ViewerBackend({this.history = const []});
  final List<LiveChatMessage> history;
  final sent = <String>[];
  int heartbeats = 0;
  int left = 0;
  Object? joinFails;

  @override
  Future<LiveJoin> join() async {
    if (joinFails != null) throw joinFails!;
    return _join;
  }

  @override
  Future<int> heartbeat() async => ++heartbeats + 10;
  @override
  Future<void> leave() async => left++;
  @override
  Future<List<LiveChatMessage>> chatHistory() async => history;
  @override
  Future<void> sendChat(String text, {String? imagePath}) async {
    sent.add(text);
    images.add(imagePath);
  }
}

class _HostBackend implements LiveHostBackend {
  final images = <String?>[];
  final sent = <String>[];
  final removed = <String>[];
  int started = 0;
  int ended = 0;
  int? slowMode;
  Object? startFails;

  @override
  Future<LiveJoin> start() async {
    if (startFails != null) throw startFails!;
    started++;
    return const LiveJoin(
      url: 'wss://media.test',
      room: 'live_1',
      token: 'host-tok',
      identity: 'astro',
      role: 'host',
      canPublish: true,
      chatChannel: 'live:1',
    );
  }

  @override
  Future<void> end() async => ended++;
  @override
  Future<List<LiveChatMessage>> chatHistory() async => const [];
  @override
  Future<void> sendChat(String text, {String? imagePath}) async {
    sent.add(text);
    images.add(imagePath);
  }

  @override
  Future<void> removeViewer(String userId, {String reason = ''}) async =>
      removed.add(userId);
  @override
  Future<void> setSlowMode(int seconds) async => slowMode = seconds;
  @override
  Future<void> pinMessage(
    String messageId, {
    bool pin = true,
    bool hide = false,
  }) async {}
}

class _Perms implements LivePermissions {
  _Perms([this.result = LiveMediaPermission.granted]);
  final LiveMediaPermission result;
  @override
  Future<LiveMediaPermission> requestCameraAndMicrophone() async => result;
  @override
  Future<void> openSettings() async {}
}

Future<void> _settle([int ms = 30]) =>
    Future<void>.delayed(Duration(milliseconds: ms));

void main() {
  // --- viewer --------------------------------------------------------------

  test('joining plays the stream and shows the viewer count', () async {
    final hub = _Hub();
    final engine = _Engine();
    final backend = _ViewerBackend(
      history: const [LiveChatMessage(id: 'm0', name: 'Old', text: 'hello')],
    );
    final cubit = LiveViewerCubit(
      backend: backend,
      engine: engine,
      signaling: hub,
      userId: 'me',
    );

    await cubit.start();
    await _settle();

    expect(cubit.state.phase, LivePhase.live);
    expect(engine.connectedTo, 'wss://media.test');
    expect(engine.published, isFalse, reason: 'a viewer never publishes');
    expect(cubit.state.viewerCount, 7);
    expect(cubit.state.messages.single.text, 'hello');

    await cubit.close();
  });

  test('a failed join surfaces instead of hanging on a black screen', () async {
    final cubit = LiveViewerCubit(
      backend: _ViewerBackend()..joinFails = StateError('stream is over'),
      engine: _Engine(),
      signaling: _Hub(),
      userId: 'me',
    );
    await cubit.start();
    expect(cubit.state.phase, LivePhase.failed);
    expect(cubit.state.error, contains('stream is over'));
    await cubit.close();
  });

  test('chat, gifts and the count arrive over the channel', () async {
    final hub = _Hub();
    final cubit = LiveViewerCubit(
      backend: _ViewerBackend(),
      engine: _Engine(),
      signaling: hub,
      userId: 'me',
    );
    await cubit.start();

    hub.push('live:1', 'chat.message', {
      'id': 'm1',
      'name': 'Riya',
      'text': 'namaste',
    });
    hub.push('live:1', 'viewer.count', {'count': 42});
    hub.push('live:1', 'gift.received', {
      'id': 'g1',
      'sender_name': 'Riya',
      'gift': 'rose',
    });
    await _settle();

    expect(cubit.state.messages.single.name, 'Riya');
    expect(cubit.state.viewerCount, 42);
    expect(cubit.state.gifts.single.giftSlug, 'rose');

    // the same message twice (backfill + realtime) shows once
    hub.push('live:1', 'chat.message', {
      'id': 'm1',
      'name': 'Riya',
      'text': 'namaste',
    });
    await _settle();
    expect(cubit.state.messages, hasLength(1));

    await cubit.close();
  });

  test('the host ending the stream ends the viewer too', () async {
    final hub = _Hub();
    final engine = _Engine();
    final cubit = LiveViewerCubit(
      backend: _ViewerBackend(),
      engine: engine,
      signaling: hub,
      userId: 'me',
    );
    await cubit.start();

    hub.push('live:1', 'stream.ended', {'reason': 'done'});
    await _settle();

    expect(cubit.state.phase, LivePhase.ended);
    expect(cubit.state.endReason, LiveEndReason.hostEnded);
    expect(engine.disconnected, isTrue);
    await cubit.close();
  });

  test('being removed ends this viewer, not everyone', () async {
    final hub = _Hub();
    final mine = LiveViewerCubit(
      backend: _ViewerBackend(),
      engine: _Engine(),
      signaling: hub,
      userId: 'me',
    );
    final theirs = LiveViewerCubit(
      backend: _ViewerBackend(),
      engine: _Engine(),
      signaling: hub,
      userId: 'someone-else',
    );
    await mine.start();
    await theirs.start();

    hub.push('live:1', 'viewer.removed', {'user': 'me'});
    await _settle();

    expect(mine.state.endReason, LiveEndReason.removed);
    expect(theirs.state.phase, LivePhase.live);

    await mine.close();
    await theirs.close();
  });

  test('leaving tells the backend so the count drops', () async {
    final backend = _ViewerBackend();
    final cubit = LiveViewerCubit(
      backend: backend,
      engine: _Engine(),
      signaling: _Hub(),
      userId: 'me',
    );
    await cubit.start();
    await cubit.leave();
    expect(backend.left, 1);
    expect(cubit.state.phase, LivePhase.ended);
    await cubit.close();
  });

  test('the heartbeat keeps the viewer in the live count', () async {
    final backend = _ViewerBackend();
    final cubit = LiveViewerCubit(
      backend: backend,
      engine: _Engine(),
      signaling: _Hub(),
      userId: 'me',
      heartbeatEvery: const Duration(milliseconds: 20),
    );
    await cubit.start();
    await _settle(70);
    expect(backend.heartbeats, greaterThan(1));
    expect(cubit.state.viewerCount, greaterThan(10));
    await cubit.close();
  });

  test('losing the media server shows reconnecting, then recovers', () async {
    final engine = _Engine();
    final cubit = LiveViewerCubit(
      backend: _ViewerBackend(),
      engine: engine,
      signaling: _Hub(),
      userId: 'me',
    );
    await cubit.start();

    engine.connections.add(LiveConnection.reconnecting);
    await _settle();
    expect(cubit.state.phase, LivePhase.reconnecting);

    engine.connections.add(LiveConnection.connected);
    await _settle();
    expect(cubit.state.phase, LivePhase.live);
    await cubit.close();
  });

  // --- host ----------------------------------------------------------------

  test('going live publishes and starts the clock', () async {
    final backend = _HostBackend();
    final engine = _Engine();
    final cubit = LiveHostCubit(
      backend: backend,
      permissions: _Perms(),
      engine: engine,
      signaling: _Hub(),
      userId: 'astro',
    );

    await cubit.goLive();
    await _settle();

    expect(backend.started, 1);
    expect(engine.published, isTrue);
    expect(cubit.state.phase, LivePhase.live);
    expect(cubit.state.startedAt, isNotNull);
    await cubit.close();
  });

  test('refusing the camera never puts the astrologer on air', () async {
    final backend = _HostBackend();
    final cubit = LiveHostCubit(
      backend: backend,
      permissions: _Perms(LiveMediaPermission.permanentlyDenied),
      engine: _Engine(),
      signaling: _Hub(),
      userId: 'astro',
    );

    await cubit.goLive();

    expect(cubit.state.phase, LivePhase.permissionDenied);
    expect(cubit.state.permanentlyDenied, isTrue);
    expect(backend.started, 0, reason: 'no empty stream on the home page');
    await cubit.close();
  });

  test('a room that will not connect ends the stream server-side', () async {
    final backend = _HostBackend();
    final engine = _Engine()..failWith = StateError('no route to media');
    final cubit = LiveHostCubit(
      backend: backend,
      permissions: _Perms(),
      engine: engine,
      signaling: _Hub(),
      userId: 'astro',
    );

    await cubit.goLive();

    expect(cubit.state.phase, LivePhase.failed);
    expect(backend.started, 1);
    expect(backend.ended, 1, reason: 'no stream left live with no picture');
    await cubit.close();
  });

  test('host controls reach the engine', () async {
    final engine = _Engine();
    final cubit = LiveHostCubit(
      backend: _HostBackend(),
      permissions: _Perms(),
      engine: engine,
      signaling: _Hub(),
      userId: 'astro',
    );
    await cubit.goLive();

    await cubit.toggleCamera();
    expect(engine.camera, isFalse);
    expect(cubit.state.cameraOn, isFalse);

    await cubit.switchCamera();
    expect(engine.flips, 0, reason: 'nothing to flip with the camera off');

    await cubit.toggleCamera();
    await cubit.switchCamera();
    expect(engine.flips, 1);
    expect(cubit.state.frontCamera, isFalse);

    await cubit.toggleMic();
    expect(engine.mic, isFalse);
    await cubit.close();
  });

  test('moderation calls the backend', () async {
    final backend = _HostBackend();
    final cubit = LiveHostCubit(
      backend: backend,
      permissions: _Perms(),
      engine: _Engine(),
      signaling: _Hub(),
      userId: 'astro',
    );
    await cubit.goLive();

    await cubit.removeViewer('troll');
    await cubit.setSlowMode(30);

    expect(backend.removed, ['troll']);
    expect(backend.slowMode, 30);
    expect(cubit.state.slowModeSeconds, 30);
    await cubit.close();
  });

  test('ending the stream tells the server before tearing down', () async {
    final backend = _HostBackend();
    final engine = _Engine();
    final cubit = LiveHostCubit(
      backend: backend,
      permissions: _Perms(),
      engine: engine,
      signaling: _Hub(),
      userId: 'astro',
    );
    await cubit.goLive();
    await cubit.endStream();

    expect(backend.ended, 1);
    expect(engine.disconnected, isTrue);
    expect(cubit.state.phase, LivePhase.ended);
    await cubit.close();
  });

  // --- chat pictures -------------------------------------------------------

  test('a picture can be sent with or without text', () async {
    final backend = _ViewerBackend();
    final cubit = LiveViewerCubit(
      backend: backend,
      engine: _Engine(),
      signaling: _Hub(),
      userId: 'me',
    );
    await cubit.start();
    await _settle();

    await cubit.sendChat('', imagePath: '/tmp/chart.png');
    await cubit.sendChat('look', imagePath: '/tmp/chart.png');

    expect(backend.sent, ['', 'look']);
    expect(backend.images, ['/tmp/chart.png', '/tmp/chart.png']);
    await cubit.close();
  });

  test('an empty message with no picture is not sent', () async {
    final backend = _ViewerBackend();
    final cubit = LiveViewerCubit(
      backend: backend,
      engine: _Engine(),
      signaling: _Hub(),
      userId: 'me',
    );
    await cubit.start();
    await _settle();

    await cubit.sendChat('   ');

    expect(backend.sent, isEmpty);
    await cubit.close();
  });

  test('a chat frame carrying an image URL is parsed', () {
    final m = LiveChatMessage.fromJson({
      'id': 'm1',
      'name': 'Asha',
      'text': 'my chart',
      'image_url': 'https://cdn.test/a.png',
    });
    expect(m.hasImage, isTrue);
    expect(m.imageUrl, 'https://cdn.test/a.png');
    expect(LiveChatMessage.fromJson({'id': 'm2'}).hasImage, isFalse);
  });
}
