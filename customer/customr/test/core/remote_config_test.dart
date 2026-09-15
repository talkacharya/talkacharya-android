import 'package:customr/src/core/config/remote_config.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('fallback config is usable before the first fetch', () {
    final c = RemoteConfig.fallback();
    expect(c.currencies, contains('INR'));
    expect(c.languages.map((l) => l.code), containsAll(['en', 'hi']));
    expect(c.consultationChannels, ['chat', 'voice', 'video']);
    expect(c.minRecharge.currency, 'INR');
    expect(c.features.livestream, isTrue);
  });

  test('parses the backend payload', () {
    final c = RemoteConfig.fromJson({
      'min_app_version': {'android': '1.2.0', 'ios': '1.1.0'},
      'currencies': ['INR', 'USD'],
      'languages': [
        {'code': 'en', 'name': 'English'},
        {'code': 'hi', 'name': 'हिन्दी'},
      ],
      'consultation_channels': ['chat', 'voice'],
      'min_recharge': {'amount': '50.00', 'currency': 'USD'},
      'features': {'livestream': false, 'gifting': true, 'referrals': true},
      'support': {'email': 'help@x.com', 'terms_url': 'https://x.com/terms'},
    });

    expect(c.minAppVersion['android'], '1.2.0');
    expect(c.currencies, ['INR', 'USD']);
    expect(c.languages.first.name, 'English');
    expect(c.minRecharge.amount, '50.00');
    expect(c.features.livestream, isFalse);
    expect(c.support.email, 'help@x.com');
    expect(c.support.privacyUrl, ''); // missing key -> default
  });
}
