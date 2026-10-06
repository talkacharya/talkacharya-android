import 'package:customr/src/features/astrologers/data/models/astrologer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Astrologer astrologer(Map<String, dynamic>? offer) => Astrologer.fromJson({
    'id': 'a1',
    'rates': [
      {'channel': 'chat', 'currency': 'INR', 'per_minute_amount': '20.00'},
      {'channel': 'voice', 'currency': 'INR', 'per_minute_amount': '35.00'},
    ],
    'offer': offer,
  });

  test('no offer leaves the list price', () {
    final a = astrologer(null);
    expect(a.offer, isNull);
    expect(a.offerPercentFor('chat'), 0);
    expect(a.priceFor(a.rateFor('chat')!), 20);
  });

  test('an offer for every channel reduces each rate', () {
    final a = astrologer({
      'percent_off': 25,
      'channels': <String>[],
      'audience': 'everyone',
      'ends_at': '2026-10-07T10:00:00Z',
    });
    expect(a.priceFor(a.rateFor('chat')!), 15);
    expect(a.priceFor(a.rateFor('voice')!), 26.25);
    expect(a.offer!.endsAt, DateTime.utc(2026, 10, 7, 10));
  });

  test('an offer covers only the channels it names', () {
    final a = astrologer({
      'percent_off': 50,
      'channels': ['voice'],
      'audience': 'new',
    });
    expect(a.offerPercentFor('chat'), 0);
    expect(a.priceFor(a.rateFor('chat')!), 20);
    expect(a.priceFor(a.rateFor('voice')!), 17.5);
  });
}
