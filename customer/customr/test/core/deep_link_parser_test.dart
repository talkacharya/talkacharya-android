import 'package:customr/src/core/deeplink/deep_link_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('locationForRaw — custom scheme', () {
    const cases = {
      'talkacharya://wallet': '/wallet',
      'talkacharya://notifications': '/notifications',
      'talkacharya://referrals': '/profile/referrals',
      'talkacharya://help': '/profile/help',
      'talkacharya://panchang': '/panchang',
      'talkacharya://articles': '/articles',
      'talkacharya://articles/mercury-retrograde':
          '/articles/mercury-retrograde',
      'talkacharya://disputes/d-7': '/disputes/d-7',
      'talkacharya://disputes': '/profile/help',
      'talkacharya://astrologers/abc-123': '/astrologers/abc-123',
      'talkacharya://consultations/c-9': '/consultations/c-9',
      'talkacharya://predictions/p-2': '/predictions/p-2',
      'talkacharya://predictions': '/predictions',
      'talkacharya://livestreams/s-1': '/live/s-1',
      'talkacharya://home': '/home',
    };
    cases.forEach((input, expected) {
      test('$input -> $expected', () {
        expect(locationForRaw(input), expected);
      });
    });
  });

  test('https App Links map the same way', () {
    expect(locationForRaw('https://talkacharya.com/wallet'), '/wallet');
    expect(
      locationForRaw('https://dev.talkacharya.com/astrologers/x1'),
      '/astrologers/x1',
    );
  });

  test('kundali deep links map to the kundali section', () {
    expect(locationForRaw('talkacharya://kundali/p1'), '/kundali/p1');
    expect(
      locationForRaw('talkacharya://kundali/p1/transits'),
      '/kundali/p1/transits',
    );
    expect(
      locationForRaw('talkacharya://kundali/p1/sade-sati'),
      '/kundali/p1/sade-sati',
    );
    expect(locationForRaw('talkacharya://kundali'), isNull);
  });

  test('horoscope + matchmaking deep links', () {
    expect(locationForRaw('talkacharya://horoscope'), '/horoscope');
    expect(
      locationForRaw('talkacharya://horoscope/leo'),
      '/horoscope?sign=leo',
    );
    expect(
      locationForRaw('https://talkacharya.com/rashifal/virgo'),
      '/horoscope?sign=virgo',
    );
    expect(locationForRaw('talkacharya://matchmaking'), '/matchmaking');
    expect(locationForRaw('talkacharya://matchmaking/m-1'), '/matchmaking/m-1');
    expect(
      locationForRaw('https://talkacharya.com/kundli-milan'),
      '/matchmaking',
    );
  });

  test('unknown / malformed input yields null', () {
    expect(locationForRaw(null), isNull);
    expect(locationForRaw(''), isNull);
    expect(locationForRaw('talkacharya://unknownthing'), isNull);
    expect(
      locationForRaw('talkacharya://consultations'),
      isNull,
    ); // needs an id
    expect(locationForRaw('not a uri at all %%%'), isNull);
  });
}
