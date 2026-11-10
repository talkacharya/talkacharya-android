import 'package:customr/src/features/store/data/models/catalog.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('a collection carries why it is shown and how much is in it', () {
    final c = StoreCollection.fromJson({
      'slug': 'shani',
      'title': 'Shani remedies',
      'image': 'https://x/banner.jpg',
      'images': {'card': 'https://x/card.jpg'},
      'items': 7,
      'reason': "Saturn's Sade Sati is running for you",
      'personal': true,
    });
    expect(c.card, 'https://x/card.jpg');
    expect(c.items, 7);
    expect(c.reason, startsWith('Saturn'));
    expect(c.personal, isTrue);
  });

  test('older payloads still parse', () {
    final c = StoreCollection.fromJson({
      'slug': 'navratri',
      'title': 'Navratri',
      'image': 'https://x/banner.jpg',
    });
    expect(c.card, 'https://x/banner.jpg');
    expect(c.items, isNull);
    expect(c.reason, isEmpty);
    expect(c.personal, isFalse);
  });

  test('a kundali link names the collection', () {
    final l = CollectionLink.fromJson({
      'slug': 'shani',
      'title': 'Shani remedies',
      'items': 3,
    });
    expect(
      l,
      const CollectionLink(slug: 'shani', title: 'Shani remedies', items: 3),
    );
  });
}
