import 'package:astro/src/features/earnings/data/earnings_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('a statement reads the service lines and what came off', () {
    final s = EarningsStatement.fromJson({
      'id': null,
      'status': 'upcoming',
      'currency': 'INR',
      'period_start': '2026-10-20',
      'period_end': '2026-10-26',
      'pays_on': '2026-10-27',
      'cycle_days': 7,
      'services': [
        {
          'key': 'consultation',
          'count': 3,
          'earned': '2000.00',
          'share': '1252.00',
          'channels': {'chat': '1200.00', 'live_call': '800.00'},
        },
        {'key': 'gift', 'count': 1, 'earned': '100.00', 'share': '62.60'},
      ],
      'totals': {
        'earned': '2100.00',
        'platform_fee': '630.00',
        'platform_fee_percent': '30',
        'gst': '113.40',
        'gst_percent': '18',
        'gateway': '42.00',
        'gateway_percent': '2',
        'share': '1314.60',
        'tds': '131.46',
        'tds_percent': '10',
        'tds_section': '194J',
        'payout': '1183.14',
        'clearing': '0.00',
        'on_hold': '0.00',
      },
    });

    expect(s.isCurrent, isTrue);
    expect(s.paysOn, DateTime(2026, 10, 27));
    expect(s.services.first.channels['live_call'], 800);
    expect(s.totals.gstPercent, '18');
    expect(s.totals.payout, closeTo(1183.14, 0.001));
    expect(s.totals.tdsSection, '194J');
  });

  test('an item carries its own breakdown and status', () {
    final i = StatementItem.fromJson({
      'id': 'e1',
      'service': 'consultation',
      'title': 'Rahul · chat',
      'status': 'clearing',
      'minutes': 12,
      'earned': '1000.00',
      'platform_fee': '300.00',
      'platform_fee_percent': '30',
      'gst': '54.00',
      'gst_percent': '18',
      'gateway': '20.00',
      'gateway_percent': '2',
      'share': '626.00',
      'available_on': '2026-11-02',
    });
    expect(i.status, StatementStatuses.clearing);
    expect(i.share, 626);
    expect(i.availableOn, DateTime(2026, 11, 2));
  });
}
