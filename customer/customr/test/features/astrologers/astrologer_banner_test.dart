import 'package:customr/src/features/astrologers/data/models/astrologer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Astrologer reads the optional banner URL', () {
    final withBanner = Astrologer.fromJson({
      'id': 'a1',
      'banner': 'https://cdn.example.com/astrologers/banners/a1.jpg',
    });
    expect(withBanner.banner, endsWith('a1.jpg'));

    final without = Astrologer.fromJson({'id': 'a2', 'banner': null});
    expect(without.banner, isNull);
  });
}
