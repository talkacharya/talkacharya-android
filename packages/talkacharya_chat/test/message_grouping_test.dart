import 'package:flutter_test/flutter_test.dart';
import 'package:talkacharya_chat/talkacharya_chat.dart';

ChatMessage _m({
  int seq = 1,
  ParticipantRole role = ParticipantRole.customer,
  String type = 'text',
  DateTime? at,
}) => ChatMessage(
  id: 'm$seq',
  seq: seq,
  senderRole: role,
  type: type,
  body: 'x',
  createdAt: at ?? DateTime(2026, 9, 25, 10),
);

void main() {
  group('continuesTurn', () {
    test('same sender, moments apart, is one turn', () {
      final a = _m(seq: 1, at: DateTime(2026, 9, 25, 10, 0));
      final b = _m(seq: 2, at: DateTime(2026, 9, 25, 10, 1));
      expect(continuesTurn(a, b), isTrue);
    });

    test('the other side always starts a new turn', () {
      final a = _m(seq: 1, at: DateTime(2026, 9, 25, 10, 0));
      final b = _m(
        seq: 2,
        role: ParticipantRole.astrologer,
        at: DateTime(2026, 9, 25, 10, 0, 5),
      );
      expect(continuesTurn(a, b), isFalse);
    });

    test('a long gap starts a new turn', () {
      final a = _m(seq: 1, at: DateTime(2026, 9, 25, 10, 0));
      final b = _m(seq: 2, at: DateTime(2026, 9, 25, 10, 4));
      expect(continuesTurn(a, b), isFalse);
    });

    test('a turn never spans midnight, however close the clock', () {
      // A day separator goes between them, so grouping across it would tuck a
      // message up under a heading from the day before.
      final a = _m(seq: 1, at: DateTime(2026, 9, 25, 23, 59));
      final b = _m(seq: 2, at: DateTime(2026, 9, 26, 0, 0, 30));
      expect(continuesTurn(a, b), isFalse);
    });

    test('system lines and shared charts stand alone', () {
      final text = _m(seq: 1, at: DateTime(2026, 9, 25, 10, 0));
      final system = _m(
        seq: 2,
        type: 'system_event',
        at: DateTime(2026, 9, 25, 10, 0, 10),
      );
      final card = _m(
        seq: 3,
        type: 'kundali_ref',
        at: DateTime(2026, 9, 25, 10, 0, 20),
      );
      expect(continuesTurn(text, system), isFalse);
      expect(continuesTurn(system, text), isFalse);
      expect(continuesTurn(text, card), isFalse);
      expect(continuesTurn(card, text), isFalse);
    });

    test('a message still being sent has no timestamp yet', () {
      final a = _m(seq: 1, at: DateTime(2026, 9, 25, 10, 0));
      final pending = ChatMessage(id: 'p', seq: 0, body: 'x');
      expect(continuesTurn(a, pending), isFalse);
      expect(continuesTurn(null, a), isFalse);
    });
  });
}
