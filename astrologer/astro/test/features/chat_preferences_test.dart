import 'package:astro/src/features/chats/presentation/cubit/chats_cubit.dart';
import 'package:astro/src/features/consultations/data/models/conversation.dart';
import 'package:flutter_test/flutter_test.dart';

Conversation _c(String id, {bool archived = false, String reason = 'closed'}) =>
    Conversation(
      id: id,
      customerName: 'Customer $id',
      archived: archived,
      window: SendingWindow(reason: reason, canSend: reason != 'closed'),
    );

void main() {
  test('the server settings are read off the thread', () {
    final c = Conversation.fromJson({
      'id': 't1',
      'muted': true,
      'archived': false,
      'blocked_by_me': false,
      'blocked_by_them': true,
      'window': {'can_send': false, 'reason': 'blocked'},
    });
    expect(c.muted, isTrue);
    expect(c.blockedByThem, isTrue);
    expect(c.blocked, isTrue);
    expect(c.window.isBlocked, isTrue);
  });

  test('new settings keep the row and its preview', () {
    final row = Conversation.fromJson({
      'id': 't1',
      'unread': 3,
      'peer': {'name': 'Asha'},
      'last_message': {'seq': 9, 'body': 'thank you', 'sender_role': 'customer'},
    });
    final updated = row.withSettings(const Conversation(id: 't1', archived: true));
    expect(updated.archived, isTrue);
    expect(updated.customerName, 'Asha');
    expect(updated.unread, 3);
    expect(updated.lastMessage?.body, 'thank you');
  });

  test('archived threads leave Recent but never hide a live one', () {
    final s = ChatsState(
      loading: false,
      all: [
        _c('1'),
        _c('2', archived: true),
        _c('3', archived: true, reason: 'consultation'),
      ],
    );
    expect(s.recent.map((c) => c.id), ['1']);
    expect(s.archived.map((c) => c.id), ['2']);
    expect(s.live.map((c) => c.id), ['3']);
  });
}
