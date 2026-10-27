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

  /// What `GET .../calls` answers next (and `POST .../calls`).
  LiveViewerCalls callsReply = const LiveViewerCalls();
  final requested = <LiveCallMode>[];
  final connected = <String>[];
  final endedCalls = <String>[];

  @override
  Future<LiveViewerCalls> calls() async => callsReply;
  @override
  Future<LiveViewerCalls> requestCall(LiveCallMode mode) async {
    requested.add(mode);
    return callsReply;
  }

  @override
  Future<void> callConnected(String requestId) async =>
      connected.add(requestId);
  @override
  Future<void> endCall(String requestId) async => endedCalls.add(requestId);
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
      viewerCount: 4,
      waitingCount: 2,
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

  LiveHostCalls callsReply = const LiveHostCalls();
  final endedCalls = <String>[];
  final mutes = <String, bool>{};

  @override
  Future<LiveHostCalls> calls() async => callsReply;
  @override
  Future<void> endCall(String requestId) async => endedCalls.add(requestId);
  @override
  Future<void> muteCall(String requestId, {required bool muted}) async =>
      mutes[requestId] = muted;
}

class _Audio implements LiveCallAudio {
  String? token;
  bool? mic;
  bool disconnected = false;

  @override
  Future<void> connect({required String url, required String token}) async {
    this.token = token;
    mic = true;
  }

  @override
  Future<void> setMicrophoneEnabled(bool enabled) async => mic = enabled;
  @override
  Future<void> disconnect() async => disconnected = true;
}

class _Perms implements LivePermissions {
  _Perms([this.result = LiveMediaPermission.granted]);
  final LiveMediaPermission result;
  @override
  Future<LiveMediaPermission> requestCameraAndMicrophone() async => result;
  @override
  Future<LiveMediaPermission> requestMicrophone() async => result;
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

  group('private-reading queue', () {
    test('going live seeds both counts from the token response', () async {
      // A host reopening the app mid-stream must not see zero viewers and an
      // empty queue when neither is true.
      final backend = _HostBackend();
      final cubit = LiveHostCubit(
        backend: backend,
        permissions: _Perms(),
        engine: _Engine(),
        signaling: _Hub(),
        userId: 'astro',
      );
      await cubit.goLive();

      expect(cubit.state.viewerCount, 4);
      expect(cubit.state.waitingCount, 2);
      await cubit.close();
    });

    test('a private request while live updates the count', () async {
      final hub = _Hub();
      final cubit = LiveHostCubit(
        backend: _HostBackend(),
        permissions: _Perms(),
        engine: _Engine(),
        signaling: hub,
        userId: 'astro',
      );
      await cubit.goLive();

      hub.push('live:1', 'live.private_request', {
        'viewer_name': 'Asha',
        'channel': 'voice',
        'waiting': 3,
      });
      await Future<void>.delayed(Duration.zero);
      expect(cubit.state.waitingCount, 3);

      // A frame without the total still moves the number, rather than leaving
      // the host looking at a stale one.
      hub.push('live:1', 'live.private_request', {
        'viewer_name': 'Ravi',
        'channel': 'chat',
      });
      await Future<void>.delayed(Duration.zero);
      expect(cubit.state.waitingCount, 4);
      await cubit.close();
    });
  });

  // --- calls during the stream ---------------------------------------------

  group('live calls', () {
    const turn = LiveCallRequest(
      id: 'r1',
      mode: LiveCallMode.public,
      status: LiveCallStatus.connecting,
      consultationId: 'c1',
    );

    LiveViewerCubit viewer(
      _ViewerBackend backend,
      _Engine engine,
      _Hub hub, {
      _Audio? audio,
      LiveMediaPermission mic = LiveMediaPermission.granted,
    }) => LiveViewerCubit(
      backend: backend,
      engine: engine,
      signaling: hub,
      userId: 'me',
      permissions: _Perms(mic),
      callAudio: () => audio ?? _Audio(),
      micRetryEvery: const Duration(milliseconds: 1),
    );

    test('a public caller speaks in the stream and goes on air', () async {
      final hub = _Hub();
      final engine = _Engine();
      final backend = _ViewerBackend();
      final cubit = viewer(backend, engine, hub);
      await cubit.start();
      backend.callsReply = const LiveViewerCalls(
        mine: turn,
        media: LiveCallMedia(
          mode: LiveCallMode.public,
          url: 'wss://media.test',
          room: 'live_1',
        ),
      );

      await cubit.requestCall(LiveCallMode.public);

      expect(backend.requested, [LiveCallMode.public]);
      expect(engine.mic, isTrue, reason: 'their microphone, in the stream');
      expect(backend.connected, ['r1']);
      await cubit.close();
    });

    test('a private caller speaks only in the two-person room', () async {
      final hub = _Hub();
      final engine = _Engine();
      final backend = _ViewerBackend();
      final audio = _Audio();
      final cubit = viewer(backend, engine, hub, audio: audio);
      await cubit.start();
      backend.callsReply = const LiveViewerCalls(
        mine: LiveCallRequest(
          id: 'r1',
          mode: LiveCallMode.private,
          status: LiveCallStatus.connecting,
          consultationId: 'c1',
        ),
        media: LiveCallMedia(
          mode: LiveCallMode.private,
          url: 'wss://media.test',
          room: 'livecall_x',
          token: 'private-tok',
        ),
      );

      await cubit.requestCall(LiveCallMode.private);

      expect(audio.token, 'private-tok');
      expect(engine.mic, isNull, reason: 'nothing goes into the stream');
      expect(backend.connected, ['r1']);

      // The call ends: off air, and the screen is asked for a rating.
      backend.callsReply = const LiveViewerCalls();
      hub.push('live:1', 'live.call', {'on_air': null, 'waiting': 0});
      await _settle();
      expect(audio.disconnected, isTrue);
      expect(cubit.state.myCall, isNull);
      expect(cubit.state.endedCall?.consultationId, 'c1');
      await cubit.close();
    });

    test('no microphone, no place in the line', () async {
      final backend = _ViewerBackend();
      final cubit = viewer(
        backend,
        _Engine(),
        _Hub(),
        mic: LiveMediaPermission.denied,
      );
      await cubit.start();

      await cubit.requestCall(LiveCallMode.public);

      expect(backend.requested, isEmpty);
      expect(cubit.state.error, 'microphone');
      await cubit.close();
    });

    test('a viewer not in the line does not look anything up', () async {
      final hub = _Hub();
      final backend = _ViewerBackend();
      final cubit = viewer(backend, _Engine(), hub);
      await cubit.start();
      backend.callsReply = const LiveViewerCalls(mine: turn);

      hub.push('live:1', 'live.call', {
        'on_air': {
          'id': 'r9',
          'mode': 'public',
          'caller': {'id': 'u9', 'name': 'Rahul'},
        },
        'waiting': 2,
      });
      await _settle();

      expect(cubit.state.onAir?.callerName, 'Rahul');
      expect(cubit.state.callsWaiting, 2);
      expect(cubit.state.myCall, isNull);
      await cubit.close();
    });

    test('in a private call the host is heard only in its room', () async {
      final hub = _Hub();
      final engine = _Engine();
      final backend = _HostBackend();
      final audio = _Audio();
      final cubit = LiveHostCubit(
        backend: backend,
        permissions: _Perms(),
        engine: engine,
        signaling: hub,
        userId: 'astro',
        callAudio: () => audio,
      );
      await cubit.goLive();
      backend.callsReply = const LiveHostCalls(
        line: [
          LiveCallRequest(
            id: 'r1',
            mode: LiveCallMode.private,
            status: LiveCallStatus.active,
          ),
        ],
        media: LiveCallMedia(
          mode: LiveCallMode.private,
          url: 'wss://media.test',
          room: 'livecall_x',
          token: 'host-private',
        ),
      );

      hub.push('live:1', 'live.call', {
        'on_air': {'id': 'r1', 'mode': 'private'},
        'waiting': 0,
      });
      await _settle();
      expect(engine.mic, isFalse, reason: 'off the stream');
      expect(audio.token, 'host-private');
      expect(cubit.state.onAir?.mode, LiveCallMode.private);

      backend.callsReply = const LiveHostCalls();
      hub.push('live:1', 'live.call', {'on_air': null, 'waiting': 0});
      await _settle();
      expect(audio.disconnected, isTrue);
      expect(engine.mic, isTrue, reason: 'back on the stream');
      await cubit.close();
    });

    test('the host ends and mutes calls', () async {
      final backend = _HostBackend();
      final cubit = LiveHostCubit(
        backend: backend,
        permissions: _Perms(),
        engine: _Engine(),
        signaling: _Hub(),
        userId: 'astro',
        callAudio: _Audio.new,
      );
      await cubit.goLive();

      await cubit.muteCaller('r1', muted: true);
      await cubit.endCall('r1');

      expect(backend.mutes, {'r1': true});
      expect(backend.endedCalls, ['r1']);
      await cubit.close();
    });
  });
}
