import 'package:astro/src/features/my_store/data/my_store_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('a listing the team sent back reads as "changes needed"', () {
    final l = MyListing.fromJson({
      'id': 'p1',
      'status': 'draft',
      'review_note': 'Remove the cure claim.',
      'product_type': {
        'slug': 'rudraksha',
        'name': 'Rudraksha',
        'fulfilment': 'physical',
      },
      'category': {'slug': 'rudraksha', 'name': 'Rudraksha'},
      'title': 'Bead',
      'price': '799.00',
      'compare_at': '999.00',
      'tracks_stock': true,
      'stock': 0,
      'media': [
        {'id': 3, 'url': 'https://x/c.webp', 'thumb': 'https://x/t.webp'},
      ],
      'checklist': [
        {'code': 'no_weight', 'message': 'Enter the packed weight.'},
      ],
    });
    expect(l.hasChangesRequested, isTrue);
    expect(l.price, 799);
    expect(l.outOfStock, isTrue);
    expect(l.cover, 'https://x/c.webp');
    expect(l.checklist.single.code, 'no_weight');
  });

  test('an order says what can be done with it next', () {
    final o = SellerOrder.fromJson({
      'id': 's1',
      'number': 'TA-1-1',
      'status': 'processing',
      'fulfilment': 'physical',
      'total': '858.00',
      'lines': [
        {
          'product_title': 'Bead',
          'quantity': 2,
          'inputs': {'ring_size': '12'},
        },
      ],
      'shipping_address': {
        'name': 'Asha',
        'line1': '4 MG Road',
        'city': 'Pune',
        'state': 'Maharashtra',
        'postal_code': '411001',
      },
      'contact': {'name': 'Asha', 'phone': '9000000000'},
    });
    expect(o.canShip, isTrue);
    expect(o.canStart, isFalse);
    expect(o.addressText, contains('Pune, Maharashtra, 411001'));
    expect(o.lines.single.inputs['ring_size'], '12');
  });

  test('a store not set up yet', () {
    expect(StoreSetup.fromJson({'status': 'none'}).exists, isFalse);
    expect(StoreSetup.fromJson({'status': 'pending'}).isPending, isTrue);
  });
}
