import 'package:equatable/equatable.dart';

import 'product.dart';
import 'store_json.dart';

class CartItem extends Equatable {
  const CartItem({
    required this.id,
    required this.product,
    required this.variantId,
    this.variantName = '',
    this.participants = 1,
    this.quantity = 1,
    this.unitPrice,
    this.inputs = const {},
    this.event,
    this.recommendationId,
  });

  final String id;
  final ProductCard product;
  final String variantId;
  final String variantName;
  final int participants;
  final int quantity;
  final double? unitPrice;
  final Json inputs;
  final ServiceEvent? event;
  final String? recommendationId;

  double get lineTotal => (unitPrice ?? 0) * quantity;

  factory CartItem.fromJson(Json j) {
    final v = jMap(j['variant']);
    return CartItem(
      id: jStr(j['id']),
      product: ProductCard.fromJson(jMap(j['product'])),
      variantId: jStr(v['id']),
      variantName: jStr(v['name']),
      participants: jInt(v['participants'], 1),
      quantity: jInt(j['quantity'], 1),
      unitPrice: jNumOrNull(j['unit_price']),
      inputs: jMap(j['inputs']),
      event: jMapOrNull(j['event']) == null
          ? null
          : ServiceEvent.fromJson(jMap(j['event'])),
      recommendationId: jStrOrNull(j['recommendation_id']),
    );
  }

  @override
  List<Object?> get props => [id, quantity, unitPrice, inputs, event];
}

class Cart extends Equatable {
  const Cart({
    this.id = '',
    this.currency = 'INR',
    this.count = 0,
    this.items = const [],
  });

  final String id;
  final String currency;

  /// Total units, for the badge.
  final int count;
  final List<CartItem> items;

  bool get isEmpty => items.isEmpty;

  double get subtotal => items.fold(0, (sum, i) => sum + i.lineTotal);

  bool get needsAddress =>
      items.any((i) => i.product.fulfilment == Fulfilment.physical);

  /// Items grouped by seller, preserving first-seen order.
  Map<SellerRef, List<CartItem>> get bySeller {
    final out = <SellerRef, List<CartItem>>{};
    for (final i in items) {
      out.putIfAbsent(i.product.seller, () => []).add(i);
    }
    return out;
  }

  factory Cart.fromJson(Json j) => Cart(
    id: jStr(j['id']),
    currency: jStr(j['currency'], 'INR'),
    count: jInt(j['count']),
    items: jList(j['items'], CartItem.fromJson),
  );

  @override
  List<Object?> get props => [id, currency, count, items];
}
