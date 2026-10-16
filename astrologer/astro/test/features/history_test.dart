import 'package:astro/src/features/history/data/history_api.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'a history card reads the session, the customer and the shared birth',
    () {
      final e = HistoryEntry.fromJson({
        'id': 'c-1',
        'short_id': 'AB12CD34',
        'channel': 'chat',
        'status': 'ended',
        'requested_at': '2026-10-16T05:59:00Z',
        'started_at': '2026-10-16T05:59:08Z',
        'billed_seconds': 300,
        'currency': 'INR',
        'astrologer_amount': '16.00',
        'rating': 5,
        'review': 'Very helpful',
        'customer': {
          'name': 'Yashwani',
          'session_number': 1,
          'sessions_total': 2,
        },
        'birth': {
          'id': 'bp-1',
          'full_name': 'Yashwani Gupta',
          'gender': 'female',
          'birth_date': '2009-07-15',
          'birth_time': '22:45:00',
          'birth_place': 'Panipat, Haryana, India',
        },
        'tags': ['first_session', 'picked_fast'],
        'conversation_id': 'conv-1',
        'favourite': true,
        'note': 'career question',
        'assistant_thread_id': null,
        'can_message': true,
      });
      expect(e.shortId, 'AB12CD34');
      expect(e.earned, 16);
      expect(e.sessionNumber, 1);
      expect(e.birth?.place, 'Panipat, Haryana, India');
      expect(e.tags, contains('picked_fast'));
      expect(e.canMessage, isTrue);
      expect(e.copyWith(favourite: false).favourite, isFalse);
    },
  );

  test('a session without a shared birth profile has no birth details', () {
    final e = HistoryEntry.fromJson({
      'id': 'c-2',
      'customer': {},
      'birth': null,
    });
    expect(e.birth, isNull);
    expect(e.customerName, '');
    expect(e.canMessage, isFalse);
  });
}
