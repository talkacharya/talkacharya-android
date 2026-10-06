import 'package:customr/src/features/consultations/data/models/conversation.dart';
import 'package:customr/src/features/consultations/presentation/cubit/chats_list_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

Conversation _c(String id, {bool archived = false, String reason = 'closed'}) =>
    Conversation(
      id: id,
      astrologerId: 'a$id',
      archived: archived,
      window: SendingWindow(reason: reason, canSend: reason != 'closed'),
    );

void main() {
  test('the server settings are read off the thread', () {
    final c = Conversation.fromMap({
      'id': 't1',
      'astrologer_id': 'a1',
      'muted': true,
      'archived': true,
      'blocked_by_me': true,
      'blocked_by_them': false,
      'window': {'can_send': false, 'reason': 'blocked'},
    });
    expect(c.muted, isTrue);
    expect(c.archived, isTrue);
    expect(c.blockedByMe, isTrue);
    expect(c.blocked, isTrue);
    expect(c.window.isBlocked, isTrue);
    expect(c.window.canSend, isFalse);
  });

  test('archived threads leave Recent but never hide a live one', () {
    final s = ChatsListState(
      conversations: [
        _c('1'),
        _c('2', archived: true),
        // archived, but a paid session is running in it right now
        _c('3', archived: true, reason: 'consultation'),
      ],
    );
    expect(s.past.map((c) => c.id), ['1']);
    expect(s.archived.map((c) => c.id), ['2']);
    expect(s.live.map((c) => c.id), ['3']);
  });
}
