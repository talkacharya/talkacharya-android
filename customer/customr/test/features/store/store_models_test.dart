import 'package:customr/src/features/store/data/models/cart.dart';
import 'package:customr/src/features/store/data/models/catalog.dart';
import 'package:customr/src/features/store/data/models/checkout.dart';
import 'package:customr/src/features/store/data/models/order.dart';
import 'package:customr/src/features/store/data/models/product.dart';
import 'package:customr/src/features/store/data/store_repository.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> _product(
  String id,
  String seller, {
  String fulfilment = 'physical',
}) => {
  'id': id,
  'slug': 'p-$id',
  'title': 'Product $id',
  'type': 'rudraksha',
  'fulfilment': fulfilment,
  'price_from': '500.00',
  'seller': {'code': seller, 'name': 'Seller $seller', 'kind': 'vendor'},
};

void main() {
  group('Cart', () {
    final cart = Cart.fromJson({
      'id': 'c1',
      'currency': 'INR',
      'count': 3,
      'items': [
        {
          'id': 'i1',
          'product': _product('1', 'a'),
          'variant': {'id': 'v1', 'name': '5 Mukhi'},
          'quantity': 2,
          'unit_price': '500.00',
        },
        {
          'id': 'i2',
          'product': _product('2', 'b', fulfilment: 'service'),
          'variant': {'id': 'v2', 'participants': 2},
          'quantity': 1,
          'unit_price': '1100.00',
        },
        {
          'id': 'i3',
          'product': _product('3', 'a', fulfilment: 'digital'),
          'variant': {'id': 'v3'},
          'quantity': 1,
          'unit_price': '99',
        },
      ],
    });

    test('totals and grouping by seller keep first-seen order', () {
      expect(cart.subtotal, 500 * 2 + 1100 + 99);
      expect(cart.bySeller.keys.map((s) => s.code), ['a', 'b']);
      expect(cart.bySeller.values.first.map((i) => i.id), ['i1', 'i3']);
      expect(cart.items[1].participants, 2);
    });

    test('needs an address only when something ships', () {
      expect(cart.needsAddress, isTrue);
      final noShip = Cart(
        items: cart.items.where((i) => i.id != 'i1').toList(),
      );
      expect(noShip.needsAddress, isFalse);
    });
  });

  group('CheckoutQuote', () {
    test('parses sellers, wallet split and order-level problems', () {
      final q = CheckoutQuote.fromJson({
        'currency': 'INR',
        'ok': false,
        'needs_address': true,
        'problems': [
          {'scope': 'order', 'message': 'Add a delivery address'},
          {'scope': 'item', 'item': 'i1', 'message': 'Out of stock'},
        ],
        'sellers': [
          {
            'seller': {'code': 'a', 'name': 'A'},
            'fulfilment': 'physical',
            'items': [
              {
                'item_id': 'i1',
                'title': 'Rudraksha',
                'quantity': 2,
                'unit_price': '500',
                'total': '1000',
              },
            ],
            'subtotal': '1000',
            'shipping': '60',
            'total': '1060',
            'delivery_days': {'min': 3, 'max': 5},
          },
        ],
        'subtotal': '1000',
        'shipping': '60',
        'tax_included': '152.54',
        'grand_total': '1060',
        'wallet_available': '300',
        'wallet_amount': '300',
        'gateway_amount': '760',
      });
      expect(q.orderProblems, hasLength(1));
      expect(q.orderProblems.single.needsAddress, isTrue);
      expect(q.sellers.single.deliveryMaxDays, 5);
      expect(q.walletAmount + q.gatewayAmount, q.grandTotal);
      expect(q.payableByWalletOnly, isFalse);
    });
  });

  group('StoreOrder', () {
    final order = StoreOrder.fromJson({
      'id': 'o1',
      'number': 'TA-1001',
      'status': 'pending_payment',
      'grand_total': '1060',
      'gateway_amount': '760',
      'shipping_address': {
        'name': 'Asha',
        'line1': '12 MG Road',
        'city': 'Pune',
        'state': 'Maharashtra',
        'postal_code': '411001',
      },
      'expires_at': '2026-09-15T10:15:00Z',
      'payment': {
        'payment_id': 'pay1',
        'gateway_order_id': 'order_1',
        'amount': '760',
        'key_id': 'rzp',
      },
      'sub_orders': [
        {
          'id': 's1',
          'number': 'TA-1001-1',
          'status': 'pending',
          'seller': {'code': 'mandir', 'name': 'Mandir'},
          'can_cancel': true,
          'lines': [
            {
              'id': 'l1',
              'product_title': 'Rudrabhishek',
              'fulfilment': 'service',
              'booking': {'id': 'b1', 'status': 'confirmed', 'proofs': []},
            },
          ],
        },
      ],
    });

    test('exposes payment, bookings and address line', () {
      expect(order.awaitingPayment, isTrue);
      expect(order.canCancel, isTrue);
      expect(order.payment!.toGatewayOrder().gatewayOrderId, 'order_1');
      expect(order.bookings.single.id, 'b1');
      expect(order.addressLine, '12 MG Road, Pune, Maharashtra, 411001');
      expect(order.lines.single.fulfilment, Fulfilment.service);
    });

    test('unknown statuses degrade gracefully', () {
      expect(OrderStatus.parse('weird'), OrderStatus.pendingPayment);
      expect(SubOrderStage.isClosed('returned'), isTrue);
    });
  });

  group('ProductQuery', () {
    test('round-trips deep-link params including attributes', () {
      final params = {
        'q': 'rudraksha',
        'category': 'rudraksha',
        'fulfilment': 'physical',
        'sort': 'price_asc',
        'attr.mukhi': '5',
      };
      final q = ProductQuery.fromParams(params);
      expect(q.toParams(), params);
    });
  });

  test('checkout keys are unique and prefixed', () {
    final a = StoreRepository.newCheckoutKey();
    final b = StoreRepository.newCheckoutKey();
    expect(a, startsWith('co_'));
    expect(a.length, 3 + 32);
    expect(a, isNot(b));
  });
}
