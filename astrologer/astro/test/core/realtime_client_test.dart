import 'dart:async';
import 'dart:convert';

import 'package:centrifuge/centrifuge.dart' as centrifuge;
import 'package:astro/src/core/realtime/realtime_client.dart';
import 'package:dio/dio.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// --- fakes: just enough of centrifuge-dart ------------------------------------

class _Pub extends Fake implements centrifuge.PublicationEvent {
  _Pub(this.data);
  @override
  final List<int> data;
}

class _Sub extends Fake implements centrifuge.Subscription {
  _Sub(this.channel);
  @override
  final String channel;
  final pubs = StreamController<centrifuge.PublicationEvent>.broadcast();
  final unsubs = StreamController<centrifuge.UnsubscribedEvent>.broadcast();
  var subscribeCalls = 0;
  var unsubscribeCalls = 0;

  @override
  Stream<centrifuge.PublicationEvent> get publication => pubs.stream;
  @override
  Stream<centrifuge.JoinEvent> get join => const Stream.empty();
  @override
  Stream<centrifuge.LeaveEvent> get leave => const Stream.empty();
  @override
  Stream<centrifuge.SubscribedEvent> get subscribed => const Stream.empty();
  @override
  Stream<centrifuge.UnsubscribedEvent> get unsubscribed => unsubs.stream;
  @override
  Future<void> subscribe() async => subscribeCalls++;
  @override
  Future<void> unsubscribe() async => unsubscribeCalls++;

  void push(Map<String, dynamic> frame) =>
      pubs.add(_Pub(utf8.encode(jsonEncode(frame))));
}

class _Client extends Fake implements centrifuge.Client {
  _Client(this.config);
  final centrifuge.ClientConfig config;
  final registry = <String, _Sub>{};
  final disconnects =
      StreamController<centrifuge.DisconnectedEvent>.broadcast();
  @override
  centrifuge.State state = centrifuge.State.connected;

  @override
  Stream<centrifuge.ConnectedEvent> get connected => const Stream.empty();
  @override
  Stream<centrifuge.ConnectingEvent> get connecting => const Stream.empty();
  @override
  Stream<centrifuge.DisconnectedEvent> get disconnected => disconnects.stream;
  @override
  Stream<centrifuge.ErrorEvent> get error => const Stream.empty();

  @override
  centrifuge.Subscription? getSubscription(String channel) => registry[channel];

  @override
  centrifuge.Subscription newSubscription(
    String channel, [
    centrifuge.SubscriptionConfig? config,
  ]) {
    // same contract as the real client
    if (registry.containsKey(channel)) throw Exception('already exists');
    return registry[channel] = _Sub(channel);
  }

  @override
  Future<void> connect() async {}
  @override
  Future<void> disconnect() async => state = centrifuge.State.disconnected;

  /// The server/library gave up on this client for good.
  void giveUp() {
    state = centrifuge.State.disconnected;
    disconnects.add(centrifuge.DisconnectedEvent(3500, 'invalid token'));
  }
}

class _MockDio extends Mock implements Dio {}

Response<Map<String, dynamic>> _res(int status, [Map<String, dynamic>? data]) =>
    Response(requestOptions: RequestOptions(), statusCode: status, data: data);

void main() {
  late _MockDio dio;
  late List<_Client> clients;
  late RealtimeClient rt;

  setUp(() {
    dio = _MockDio();
    when(() => dio.post<Map<String, dynamic>>(any())).thenAnswer(
      (_) async => _res(200, {'token': 't', 'ws_url': 'wss://ws.test'}),
    );
    clients = [];
    rt = RealtimeClient(
      dio,
      clientFactory: (url, config) {
        final c = _Client(config);
        clients.add(c);
        return c;
      },
    );
  });

  tearDown(() => rt.dispose());

  test('re-opening a room re-subscribes instead of throwing', () async {
    await rt.connect(userId: 'u1');
    final got = <String>[];

    final first = rt
        .channelFrames('conv:1')
        .listen((f) => got.add('${f['n']}'));
    clients.single.registry['conv:1']!.push({'n': 1});
    await pumpEventQueue();
    await first.cancel(); // leave the room
    expect(clients.single.registry['conv:1']!.unsubscribeCalls, 1);
    expect(rt.hasLiveRoom, isFalse);

    // come back: used to throw "already exists" and leave the room deaf
    final again = rt
        .channelFrames('conv:1')
        .listen((f) => got.add('${f['n']}'));
    expect(rt.hasLiveRoom, isTrue);
    final sub = clients.single.registry['conv:1']!;
    expect(sub.subscribeCalls, 2);
    sub.push({'n': 2});
    await pumpEventQueue();
    expect(got, ['1', '2']);
    await again.cancel();
  });

  test('a client that gave up is rebuilt and the open room re-attached', () {
    fakeAsync((async) {
      rt.connect(userId: 'u1');
      async.flushMicrotasks();
      final got = <int>[];
      rt.channelFrames('conv:1').listen((f) => got.add(f['n'] as int));
      async.flushMicrotasks();

      clients.single.giveUp();
      async
        ..elapse(const Duration(seconds: 2)) // backoff
        ..flushMicrotasks();
      expect(clients, hasLength(2));

      clients.last.registry['conv:1']!.push({'n': 7});
      async.flushMicrotasks();
      expect(got, [7]);
      expect(clients.last.registry.keys, containsAll(['user:u1', 'conv:1']));
    });
  });

  test('ensureConnected revives a dead client at once (app resume)', () async {
    await rt.connect(userId: 'u1');
    clients.single.state = centrifuge.State.disconnected;
    rt.ensureConnected();
    await pumpEventQueue();
    expect(clients, hasLength(2));

    // a healthy client is left alone
    rt.ensureConnected();
    await pumpEventQueue();
    expect(clients, hasLength(2));
  });

  test(
    'a failed token refresh throws instead of returning an empty token',
    () async {
      await rt.connect(userId: 'u1');
      final getToken = clients.single.config.getToken!;

      when(
        () => dio.post<Map<String, dynamic>>(any()),
      ).thenAnswer((_) async => _res(503));
      await expectLater(
        getToken(centrifuge.ConnectionTokenEvent()),
        throwsA(isA<Exception>()),
      );

      when(() => dio.post<Map<String, dynamic>>(any())).thenThrow(
        DioException(requestOptions: RequestOptions(), response: _res(401)),
      );
      await expectLater(
        getToken(centrifuge.ConnectionTokenEvent()),
        throwsA(isA<centrifuge.UnauthorizedException>()),
      );
    },
  );

  test('a room channel the server dropped is retried while listened', () {
    fakeAsync((async) {
      rt.connect(userId: 'u1');
      async.flushMicrotasks();
      final l = rt.channelFrames('call:1').listen((_) {});
      async.flushMicrotasks();
      final sub = clients.single.registry['call:1']!;
      expect(sub.subscribeCalls, 1);

      sub.unsubs.add(centrifuge.UnsubscribedEvent(103, 'permission denied'));
      async.elapse(const Duration(seconds: 2));
      expect(sub.subscribeCalls, 2);

      l.cancel();
      async.flushMicrotasks();
      sub.unsubs.add(centrifuge.UnsubscribedEvent(0, 'unsubscribe called'));
      async.elapse(const Duration(seconds: 40));
      expect(sub.subscribeCalls, 2); // closed room: no retry
    });
  });

  test('disconnect stops revival', () {
    fakeAsync((async) {
      rt.connect(userId: 'u1');
      async.flushMicrotasks();
      final c = clients.single;
      rt.disconnect();
      async.flushMicrotasks();
      c.giveUp();
      async.elapse(const Duration(minutes: 1));
      expect(clients, hasLength(1));
    });
  });
  test('the astro request channel is subscribed and survives a rebuild', () {
    fakeAsync((async) {
      rt.connect(userId: 'u1', astroProfileId: 'p1');
      async.flushMicrotasks();
      expect(
        clients.single.registry.keys,
        containsAll(['user:u1', 'astro:p1']),
      );

      clients.single.giveUp();
      async
        ..elapse(const Duration(seconds: 2))
        ..flushMicrotasks();
      expect(clients, hasLength(2));
      expect(clients.last.registry.keys, containsAll(['user:u1', 'astro:p1']));
    });
  });
}
