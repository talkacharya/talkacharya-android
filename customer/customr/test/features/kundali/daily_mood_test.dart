import 'package:customr/src/features/kundali/data/models/daily_mood.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('DailyMood parses the /mood payload', () {
    final m = DailyMood.fromJson({
      'date': '2026-09-13',
      'mood': 'heavy',
      'tone': 'tender',
      'level': 1,
      'moon': {'house_from_moon': 8, 'chandrashtama': true},
      'headline': 'Your mind may feel heavy today',
      'why': 'why',
      'tip': 'tip',
      'locked': ['a', 'b', 'c'],
      'moon_sign_label': 'Scorpio',
      'moon_house_label': '8th from your birth Moon',
      'disclaimer': 'd',
      'next_change_at': '2026-09-14T10:20:00+00:00',
    });
    expect(m.chandrashtama, isTrue);
    expect(m.houseFromMoon, 8);
    expect(m.locked, hasLength(3));
    expect(m.nextChangeAt, isNotNull);
    expect(m.emoji, '☁️');
  });

  test('DailyMood tolerates a sparse payload', () {
    final m = DailyMood.fromJson(const {});
    expect(m.level, 3);
    expect(m.locked, isEmpty);
    expect(m.nextChangeAt, isNull);
  });
}
