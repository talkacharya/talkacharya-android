import 'package:customr/src/core/deeplink/deep_link_parser.dart';
import 'package:customr/src/core/deeplink/pending_referral.dart';
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

  test('an invite link carries its code and lands on referrals', () {
    final link = Uri.parse('https://talkacharya.com/r/ABC123');
    expect(referralCodeFromUri(link), 'ABC123');
    expect(locationForUri(link), '/profile/referrals');
    expect(referralCodeFromUri(Uri.parse('talkacharya://r/XY9')), 'XY9');
    expect(referralCodeFromUri(Uri.parse('https://talkacharya.com/r/')), isNull);
    expect(
      referralCodeFromUri(Uri.parse('https://talkacharya.com/wallet')),
      isNull,
    );
  });

  test('the astrologer app\'s web paths are not this app\'s', () {
    expect(
      locationForRaw('https://talkacharya.com/astrologer/requests'),
      isNull,
    );
    // the custom scheme in older pushes still opens a profile
    expect(locationForRaw('talkacharya://astrologer/a1'), '/astrologers/a1');
  });

  test('an install from the invite page carries the code', () {
    expect(referralCodeFromInstallReferrer('referral_code=ABC123'), 'ABC123');
    expect(
      referralCodeFromInstallReferrer(
        'utm_source=invite&referral_code=XY-9_z&utm_medium=web',
      ),
      'XY-9_z',
    );
    // an ordinary install, or a code that is not one
    expect(
      referralCodeFromInstallReferrer(
        'utm_source=google-play&utm_medium=organic',
      ),
      isNull,
    );
    expect(referralCodeFromInstallReferrer('referral_code=a b<c>'), isNull);
    expect(referralCodeFromInstallReferrer(null), isNull);
    expect(referralCodeFromInstallReferrer(''), isNull);
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

  group('store deep links', () {
    const cases = {
      'talkacharya://store': '/store',
      'talkacharya://shop': '/store',
      'talkacharya://store/products/pukhraj-525': '/store/products/pukhraj-525',
      'talkacharya://store/products/pukhraj-525?rec=r-1':
          '/store/products/pukhraj-525?rec=r-1',
      'talkacharya://product/five-mukhi': '/store/products/five-mukhi',
      'talkacharya://store/products?type=rudraksha&attr.mukhi=5':
          '/store/products?type=rudraksha&attr.mukhi=5',
      'talkacharya://store/categories/gemstones':
          '/store/products?category=gemstones',
      'talkacharya://store/collections/shani-remedies':
          '/store/collections/shani-remedies',
      'talkacharya://store/remedy/saturn': '/store/products?remedy=saturn',
      'talkacharya://store/cart': '/store/cart',
      'talkacharya://store/checkout': '/store/cart',
      'talkacharya://store/orders': '/store/orders',
      'talkacharya://store/orders/o-42': '/store/orders/o-42',
      'talkacharya://store/bookings': '/store/orders?tab=poojas',
      'talkacharya://store/consults': '/store/consults',
      'talkacharya://store/consults/c-7': '/store/consults/c-7',
      'talkacharya://store/recommendations': '/store/consults',
      'talkacharya://store/something-new': '/store',
      'https://talkacharya.com/store/products/rudrabhishek':
          '/store/products/rudrabhishek',
    };
    cases.forEach((input, expected) {
      test('$input -> $expected', () {
        expect(locationForRaw(input), expected);
      });
    });
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
