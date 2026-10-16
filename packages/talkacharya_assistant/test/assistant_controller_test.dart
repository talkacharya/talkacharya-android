import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:talkacharya_assistant/talkacharya_assistant.dart';

AssistantMessage _m(String id, String role, String body, int minute) =>
    AssistantMessage(
      id: id,
      senderRole: role,
      body: body,
      createdAt: DateTime(2026, 10, 15, 10, minute),
    );

AssistantDetail _detail(
  List<AssistantMessage> messages, {
  String reason = '',
}) => AssistantDetail.fromJson({
  'id': 't1',
  'other': {'id': 'a1', 'name': 'Guruji'},
  'composer': {'can_send': reason.isEmpty, 'reason': reason},
  'max_length': 1000,
  'messages': [
    for (final m in messages)
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

  test(
    'a sent message is placed once even when its echo arrives first',
    () async {
      final incoming = StreamController<AssistantIncoming>.broadcast();
      final sendGate = Completer<AssistantMessage>();
      final c = AssistantRoomController(
        myRole: 'customer',
        load: () async => _detail([_m('1', 'customer', 'hello', 0)]),
        loadAfter: (_) async => const [],
        loadBefore: (_) async => const [],
        send: (_) => sendGate.future,
        incoming: incoming.stream,
      );
      await c.start();
      final sending = c.sendText('are you there?');
      expect(c.messages.last.pending, isTrue);

      final real = _m('2', 'customer', 'are you there?', 1);
      incoming.add(AssistantIncoming(threadId: 't1', message: real));
      await Future<void>.delayed(Duration.zero);
      sendGate.complete(real);
      await sending;

      expect(c.messages.map((m) => m.id), ['1', '2']);
      c.dispose();
      await incoming.close();
    },
  );

  test('a reply from the other side opens a composer waiting on one', () async {
    final incoming = StreamController<AssistantIncoming>.broadcast();
    final c = AssistantRoomController(
      myRole: 'customer',
      load: () async =>
          _detail([_m('1', 'customer', 'q', 0)], reason: 'wait_for_reply'),
      loadAfter: (_) async => const [],
      loadBefore: (_) async => const [],
      send: (_) async => throw StateError('closed'),
      incoming: incoming.stream,
    );
    await c.start();
    expect(c.canSend, isFalse);

    incoming.add(
      AssistantIncoming(threadId: 't1', message: _m('2', 'astrologer', 'a', 1)),
    );
    // Another thread's message is not this room's business.
    incoming.add(
      AssistantIncoming(
        threadId: 'other',
        message: _m('3', 'astrologer', 'x', 2),
      ),
    );
    await Future<void>.delayed(Duration.zero);

    expect(c.canSend, isTrue);
    expect(c.messages.map((m) => m.id), ['1', '2']);
    c.dispose();
    await incoming.close();
  });

  test('a failed send stays, marked, and can be retried', () async {
    var attempts = 0;
    final c = AssistantRoomController(
      myRole: 'astrologer',
      load: () async => _detail(const []),
      loadAfter: (_) async => const [],
      loadBefore: (_) async => const [],
      send: (body) async {
        attempts++;
        if (attempts == 1) throw StateError('offline');
        return _m('9', 'astrologer', body, 5);
      },
    );
    await c.start();
    await c.sendText('Yes');
    expect(c.messages.single.failed, isTrue);

    await c.retry(c.messages.single);
    expect(c.messages.single.id, '9');
    expect(c.messages.single.failed, isFalse);
    c.dispose();
  });
}
