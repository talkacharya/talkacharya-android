import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:talkacharya_assistant/talkacharya_assistant.dart';

AssistantMessage _m(String id, int minute, {String role = 'customer'}) =>
    AssistantMessage(
      id: id,
      senderRole: role,
      body: 'm$id',
      createdAt: DateTime(2026, 10, 15, 10, minute),
    );

AssistantDetail _detail(List<AssistantMessage> serverHas) =>
    AssistantDetail.fromJson({
      'id': 't1',
      'other': {'id': 'a1', 'name': 'Guruji'},
      'composer': {'can_send': true, 'reason': ''},
      'messages': [
        for (final m in serverHas)
          {
            'id': m.id,
            'sender_role': m.senderRole,
            'body': m.body,
            'created_at': m.createdAt.toUtc().toIso8601String(),
          },
      ],
    });

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  late Directory dir;

  setUp(() async {
    dir = await Directory.systemTemp.createTemp('assistant_store');
    SqliteAssistantStore.reset();
  });
  tearDown(() async {
    SqliteAssistantStore.reset();
    try {
      await dir.delete(recursive: true);
    } catch (_) {}
  });

  Future<SqliteAssistantStore> open(String user) =>
      SqliteAssistantStore.forUser(
        user,
        factory: databaseFactoryFfi,
        directory: dir.path,
      );

  test(
    'pages newest-first windows, oldest first, and keeps one row per id',
    () async {
      final store = await open('u1');
      await store.save('t1', [for (var i = 0; i < 5; i++) _m('$i', i)]);
      await store.save('t1', [_m('4', 4)]);
      await store.save('t2', [_m('x', 9)]);

      expect((await store.latest('t1', limit: 2)).map((m) => m.id), ['3', '4']);
      final older = await store.before('t1', DateTime(2026, 10, 15, 10, 3));
      expect(older.map((m) => m.id), ['0', '1', '2']);
      expect((await store.latest('t2')).single.id, 'x');
    },
  );

  test('two accounts on one phone keep separate chats', () async {
    await (await open('u1')).save('t1', [_m('a', 1)]);
    expect(await (await open('u2')).latest('t1'), isEmpty);
  });

  test('the room keeps what the server has already let go of', () async {
    final store = await open('u1');
    // Delivered last week: on the phone, gone from the server.
    await store.save('t1', [_m('old', 1), _m('older', 0)]);

    final c = AssistantRoomController(
      myRole: 'customer',
      threadId: 't1',
      store: store,
      load: () async => _detail([_m('new', 5, role: 'astrologer')]),
      loadAfter: (_) async => const [],
      loadBefore: (_) async => const [],
      send: (body) async => _m('sent', 6),
    );
    await c.start();
    expect(c.messages.map((m) => m.id), ['older', 'old', 'new']);

    await c.sendText('hello');
    expect((await store.latest('t1')).map((m) => m.id), [
      'older',
      'old',
      'new',
      'sent',
    ]);
    c.dispose();
  });
}
