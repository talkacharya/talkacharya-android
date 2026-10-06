import 'package:customr/src/core/realtime/realtime_event.dart';
import 'package:customr/src/features/consultations/data/models/queue_entry.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime.utc(2026, 10, 6, 12);

  QueueEntry entry(String status, {DateTime? expires}) => QueueEntry.fromMap({
    'id': 'q1',
    'astrologer_id': 'a1',
    'channel': 'voice',
    'status': status,
    'position': 2,
    'offer_expires_at': expires?.toIso8601String(),
  });

  test('a place in line is neither a turn nor lapsed', () {
    final e = entry('waiting');
    expect(e.position, 2);
    expect(e.channel, 'voice');
    expect(e.isTurnAt(now), isFalse);
    expect(e.isLapsedAt(now), isFalse);
  });

  test('an offer is a turn until it runs out', () {
    final e = entry('offered', expires: now.add(const Duration(minutes: 2)));
    expect(e.isTurnAt(now), isTrue);
    expect(e.isLapsedAt(now), isFalse);
    expect(e.isTurnAt(now.add(const Duration(minutes: 3))), isFalse);
    expect(e.isLapsedAt(now.add(const Duration(minutes: 3))), isTrue);
  });

  test('the offer frame carries which astrologer it is for', () {
    final event = RealtimeEvent.fromFrame({
      'type': 'queue.offer',
      'data': {
        'queue_entry': 'q1',
        'astrologer': {'id': 'a1', 'display_name': 'Acharya Dev'},
        'channel': 'chat',
        'offer_expires_at': '2026-10-06T12:02:00Z',
      },
    });
    expect(event, isA<QueueOffer>());
    expect((event! as QueueOffer).astrologerId, 'a1');
    expect((event as QueueOffer).astrologerName, 'Acharya Dev');
  });

  test('being taken off the list is its own event', () {
    final event = RealtimeEvent.fromFrame({
      'type': 'queue.removed',
      'data': {
        'astrologer': {'id': 'a1', 'display_name': 'Acharya Dev'},
      },
    });
    expect(event, isA<QueueRemoved>());
  });
}
