import 'package:astro/src/core/utils/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Validators.toE164India', () {
    test('normalises a plain 10-digit number', () {
      expect(Validators.toE164India('9565901765'), '+919565901765');
    });

    test('strips +91 / 0 / spaces / dashes', () {
      expect(Validators.toE164India('+91 95659-01765'), '+919565901765');
      expect(Validators.toE164India('095659 01765'), '+919565901765');
    });

    test('rejects wrong length or leading digit', () {
      expect(Validators.toE164India('12345'), isNull);
      expect(Validators.toE164India('1234567890'), isNull);
    });
  });

  test('isValidOtp', () {
    expect(Validators.isValidOtp('112233'), isTrue);
    expect(Validators.isValidOtp('12ab56'), isFalse);
    expect(Validators.isValidOtp('12345'), isFalse);
  });
}
