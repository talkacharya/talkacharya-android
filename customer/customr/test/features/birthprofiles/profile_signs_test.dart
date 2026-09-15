import 'package:customr/src/features/birthprofiles/data/models/birth_profile.dart';
import 'package:customr/src/features/home/data/models/zodiac.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('BirthProfile reads the engine-computed signs', () {
    final p = BirthProfile.fromJson({
      'id': 'p1',
      'birth_date': '1994-08-14',
      'signs': {
        'moon_sign': 'Scorpio',
        'sun_sign': 'Cancer',
        'lagna': null,
        'nakshatra': 'Anuradha',
      },
    });
    expect(p.moonSign, 'Scorpio');
    expect(p.signs!.sunSign, 'Cancer');
    expect(p.signs!.lagna, isNull);
    // The rasi comes from the engine, not the Western date range (Leo here).
    expect(ZodiacSign.forProfileSign(p.moonSign), ZodiacSign.scorpio);
    expect(ZodiacSign.fromDate(DateTime(1994, 8, 14)), ZodiacSign.leo);
  });

  test('BirthProfile without signs has no rasi', () {
    final p = BirthProfile.fromJson({'id': 'p1', 'birth_date': '1994-08-14'});
    expect(p.moonSign, isNull);
    expect(ZodiacSign.forProfileSign(p.moonSign), isNull);
  });
}
