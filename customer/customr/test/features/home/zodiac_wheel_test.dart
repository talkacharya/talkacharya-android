import 'dart:math' as math;

import 'package:customr/src/features/home/presentation/view/widgets/zodiac_wheel.dart';
import 'package:flutter_test/flutter_test.dart';

const _step = (2 * math.pi) / 12;

void main() {
  group('zodiacIndexForRotation', () {
    test('rotation 0 → Aries (0)', () {
      expect(zodiacIndexForRotation(0), 0);
    });

    test('each -30° advances one sign clockwise, wrapping', () {
      for (var k = 0; k < 24; k++) {
        expect(zodiacIndexForRotation(-k * _step), k % 12);
      }
    });

    test('positive rotation counts the other way', () {
      expect(zodiacIndexForRotation(_step), 11); // Pisces
      expect(zodiacIndexForRotation(2 * _step), 10);
    });

    test('half-step is rounded to the nearer sign', () {
      expect(zodiacIndexForRotation(-0.49 * _step), 0);
      expect(zodiacIndexForRotation(-0.51 * _step), 1);
    });
  });

  group('snapZodiacRotation', () {
    test('lands on a multiple of the step and never unwinds far', () {
      final snapped = snapZodiacRotation(-3.4 * _step);
      expect(snapped, closeTo(-3 * _step, 1e-9));
      expect(
        (snapped % _step).abs() < 1e-9 ||
            (snapped % _step - _step).abs() < 1e-9,
        isTrue,
      );
    });
  });

  group('zodiacDeltaToIndex', () {
    test('takes the short way around the ring', () {
      // sitting on Aries(0), asked for Pisces(11): one step *back*, not eleven forward
      final d = zodiacDeltaToIndex(0, 11);
      expect(d, closeTo(_step, 1e-9));
      expect(zodiacIndexForRotation(0 + d), 11);
    });

    test('reaches any target index', () {
      for (var from = 0; from < 12; from++) {
        for (var to = 0; to < 12; to++) {
          final rot = -from * _step;
          final landed = zodiacIndexForRotation(
            rot + zodiacDeltaToIndex(rot, to),
          );
          expect(landed, to, reason: 'from $from to $to');
        }
      }
    });
  });
}
