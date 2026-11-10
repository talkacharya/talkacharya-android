import 'package:astro/src/features/my_store/data/my_store_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'a copy made for one client knows whose it is and where it came from',
    () {
      final copy = MyListing.fromJson({
        'id': 'c1',
        'status': 'draft',
        'product_type': {
          'slug': 'pooja',
          'name': 'Pooja',
          'fulfilment': 'service',
        },
        'category': {'slug': 'poojas', 'name': 'Poojas'},
        'title': 'Rudrabhishek',
        'private_for': {'id': 'u1', 'name': 'Riya'},
        'copied_from': 'p1',
      });
      expect(copy.privateForName, 'Riya');
      expect(copy.copiedFrom, 'p1');

      final shared = MyListing.fromJson({
        'id': 'p1',
        'status': 'published',
        'product_type': {
          'slug': 'pooja',
          'name': 'Pooja',
          'fulfilment': 'service',
        },
        'category': {'slug': 'poojas', 'name': 'Poojas'},
        'title': 'Rudrabhishek',
        'private_for': null,
        'copied_from': null,
      });
      expect(shared.privateForName, isEmpty);
      expect(shared.copiedFrom, isNull);
    },
  );
}
