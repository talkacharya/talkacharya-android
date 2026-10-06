import 'package:flutter_test/flutter_test.dart';
import 'package:talkacharya_chat/talkacharya_chat.dart';

ChatMessage _card(Map<String, dynamic> meta) => ChatMessage(
  id: 'm1',
  senderRole: ParticipantRole.system,
  type: 'kundali_ref',
  meta: meta,
);

void main() {
  test('a shared birth profile opens that profile, in its session', () {
    final d = _card({
      'share_kind': 'birth_profile',
      'consultation_id': 'c1',
      'summary': {'id': 'p1', 'full_name': 'Divyanshu Kumar', 'label': 'Me'},
    }).shared!;

    expect(d.isMatch, isFalse);
    expect(d.id, 'p1');
    expect(d.consultationId, 'c1');
    expect(d.name, 'Divyanshu Kumar');
  });

  test('a shared match opens the match, named for both people', () {
    final d = _card({
      'share_kind': 'match',
      'consultation_id': 'c1',
      'summary': {
        'id': 'mt1',
        'boy': {'full_name': 'Ravi'},
        'girl': {'label': 'Asha'},
      },
    }).shared!;

    expect(d.isMatch, isTrue);
    expect(d.id, 'mt1');
    expect(d.name, 'Ravi & Asha');
  });

  test('a card that does not say who it is about opens nothing', () {
    expect(_card({'summary': <String, dynamic>{}}).shared, isNull);
    expect(
      const ChatMessage(id: 'm2', body: 'hello').shared,
      isNull,
      reason: 'an ordinary message is not a card',
    );
  });
}
