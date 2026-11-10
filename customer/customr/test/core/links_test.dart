import 'package:customr/src/core/deeplink/deep_link_parser.dart';
import 'package:customr/src/core/navigation/links.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'articles, the horoscope and a profile are public; the tabs are not',
    () {
      expect(isPublicLocation('/articles'), isTrue);
      expect(isPublicLocation('/articles/saturn-return'), isTrue);
      expect(isPublicLocation('/horoscope?sign=leo'), isTrue);
      expect(isPublicLocation('/astrologers/abc'), isTrue);
      expect(isPublicLocation('/astrologers/abc/reviews'), isTrue);

      expect(isPublicLocation('/astrologers'), isFalse, reason: 'the tab');
      expect(isPublicLocation('/home'), isFalse);
      expect(isPublicLocation('/wallet'), isFalse);
      expect(isPublicLocation('/consultations/1'), isFalse);
      expect(isPublicLocation(''), isFalse);
    },
  );

  test('links the backend sends now have a page', () {
    expect(locationForRaw('talkacharya://profile'), '/profile');
    expect(
      locationForRaw('talkacharya://profile/referrals'),
      '/profile/referrals',
    );
    expect(locationForRaw('talkacharya://remedies'), '/store');
    expect(locationForRaw('talkacharya://chats'), '/chats');
  });
}
