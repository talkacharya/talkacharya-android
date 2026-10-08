import 'package:flutter_test/flutter_test.dart';
import 'package:astro/src/core/deeplink/deep_link_parser.dart';

void main() {
  group('locationForUri — custom scheme', () {
    final cases = <String, String?>{
      'talkacharya://home': '/home',
      'talkacharya://requests': '/requests',
      'talkacharya://earnings': '/earnings',
      'talkacharya://payouts': '/earnings',
      'talkacharya://chats': '/chats',
      'talkacharya://chats/abc-123': '/chats/abc-123',
      'talkacharya://requests/abc-123': '/requests/abc-123',
      // a consultation link (incoming-request push) → the request screen, which
      // accepts or bounces into the room by status
      'talkacharya://consultations/abc-123': '/requests/abc-123',
      'talkacharya://consultation/abc-123': '/requests/abc-123',
      'talkacharya://notifications': '/notifications',
      'talkacharya://onboarding': '/onboarding',
      'talkacharya://profile': '/profile',
      'talkacharya://profile/kyc': '/profile/kyc',
      'talkacharya://profile/reviews': '/profile/reviews',
      'talkacharya://reviews': '/profile/reviews',
      'talkacharya://live': '/profile/featured',
      'talkacharya://unknown-thing': null,
      'talkacharya://': null,
    };
    cases.forEach((raw, expected) {
      test(raw, () => expect(locationForUri(Uri.parse(raw)), expected));
    });
  });

  group('locationForUri — https App Links', () {
    final cases = <String, String?>{
      // On the web this app lives under /astrologer: the site and the customer
      // app share the domain.
      'https://talkacharya.com/astrologer/requests': '/requests',
      'https://dev.talkacharya.com/astrologer/earnings': '/earnings',
      'https://talkacharya.com/astrologer/chats/xyz': '/chats/xyz',
      'https://talkacharya.com/astrologer/profile/kyc': '/profile/kyc',
      'https://talkacharya.com/astrologer/profile/calls': '/profile/calls',
      'https://talkacharya.com/astrologer': '/home',
      'https://talkacharya.com/astrologer/': '/home',
      // not this app's: the site, and the customer app's paths
      'https://talkacharya.com/requests': null,
      'https://talkacharya.com/astrologers/abc': null,
      'https://talkacharya.com/r/ABC123': null,
      'https://talkacharya.com/': null,
      'https://talkacharya.com': null,
    };
    cases.forEach((raw, expected) {
      test(raw, () => expect(locationForUri(Uri.parse(raw)), expected));
    });
  });

  group('locationForRaw', () {
    test('null / empty / junk → null', () {
      expect(locationForRaw(null), isNull);
      expect(locationForRaw(''), isNull);
      expect(locationForRaw('   '), isNull);
    });
    test('valid string parses', () {
      expect(locationForRaw('talkacharya://requests'), '/requests');
    });
  });
}
