import 'package:customr/src/core/utils/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Validators.toE164', () {
    test('normalises a plain 10-digit number to India', () {
      expect(Validators.toE164('9565901765'), '+919565901765');
    });

    test('strips +91 / 0 / spaces / dashes', () {
      expect(Validators.toE164('+91 95659-01765'), '+919565901765');
      expect(Validators.toE164('095659 01765'), '+919565901765');
    });

    test('handles international numbers with +', () {
      expect(Validators.toE164('+1 555 010 999'), '+1555010999');
      expect(Validators.toE164('+44-7911-123456'), '+447911123456');
    });

    test('rejects wrong length or leading digit for default India', () {
      expect(Validators.toE164('12345'), isNull);
      expect(Validators.toE164('1234567890'), isNull);
    });

    test('rejects too short international numbers', () {
      expect(Validators.toE164('+123'), isNull);
    });
  });

  test('isValidOtp', () {
    expect(Validators.isValidOtp('112233'), isTrue);
    expect(Validators.isValidOtp('12ab56'), isFalse);
    expect(Validators.isValidOtp('12345'), isFalse);
  });
}
