import 'package:equatable/equatable.dart';

import 'store_json.dart';

/// Something the customer must fix before paying (`scope`: order / seller / item).
class QuoteProblem extends Equatable {
  const QuoteProblem({
    required this.scope,
    required this.message,
    this.itemId,
    this.seller,
  });

  final String scope;
  final String message;
  final String? itemId;
  final String? seller;

  bool get needsAddress => message.contains('address');

  factory QuoteProblem.fromJson(Json j) => QuoteProblem(
    scope: jStr(j['scope'], 'order'),
    message: jStr(j['message']),
    itemId: jStrOrNull(j['item']),
    seller: jStrOrNull(j['seller']),
  );

  @override
  List<Object?> get props => [scope, message, itemId, seller];
}

class QuoteItem extends Equatable {
  const QuoteItem({
    required this.itemId,
    required this.title,
    this.quantity = 1,
    this.unitPrice = 0,
    this.total,
    this.tax,
    this.problems = const [],
  });

  final String itemId;
  final String title;
  final int quantity;
  final double unitPrice;
  final double? total;
  final double? tax;
  final List<String> problems;

  factory QuoteItem.fromJson(Json j) => QuoteItem(
    itemId: jStr(j['item_id']),
    title: jStr(j['title']),
    quantity: jInt(j['quantity'], 1),
    unitPrice: jNum(j['unit_price']),
    total: jNumOrNull(j['total']),
    tax: jNumOrNull(j['tax']),
    problems: jStrings(j['problems']),
  );

  @override
  List<Object?> get props => [itemId, quantity, total, problems];
}

class QuoteSeller extends Equatable {
  const QuoteSeller({
    required this.code,
    required this.name,
    this.fulfilment = 'physical',
    this.items = const [],
    this.subtotal = 0,
    this.shipping = 0,
    this.tax = 0,
    this.total = 0,
    this.deliveryMinDays,
    this.deliveryMaxDays,
  });

  final String code;
  final String name;
  final String fulfilment;
  final List<QuoteItem> items;
  final double subtotal;
  final double shipping;
  final double tax;
  final double total;
  final int? deliveryMinDays;
  final int? deliveryMaxDays;

  factory QuoteSeller.fromJson(Json j) {
    final seller = jMap(j['seller']);
    final days = jMapOrNull(j['delivery_days']);
    return QuoteSeller(
      code: jStr(seller['code']),
      name: jStr(seller['name']),
      fulfilment: jStr(j['fulfilment'], 'physical'),
      items: jList(j['items'], QuoteItem.fromJson),
      subtotal: jNum(j['subtotal']),
      shipping: jNum(j['shipping']),
      tax: jNum(j['tax']),
      total: jNum(j['total']),
      deliveryMinDays: jIntOrNull(days?['min']),
      deliveryMaxDays: jIntOrNull(days?['max']),
    );
  }

  @override
  List<Object?> get props => [code, items, total, shipping];
}

/// `POST /store/checkout/quote`.
class CheckoutQuote extends Equatable {
  const CheckoutQuote({
    this.currency = 'INR',
    this.ok = false,
    this.problems = const [],
    this.needsAddress = false,
    this.sellers = const [],
    this.subtotal = 0,
    this.shipping = 0,
    this.taxIncluded = 0,
    this.grandTotal = 0,
    this.walletAvailable = 0,
    this.walletAmount = 0,
    this.gatewayAmount = 0,
  });

  final String currency;
  final bool ok;
  final List<QuoteProblem> problems;
  final bool needsAddress;
  final List<QuoteSeller> sellers;
  final double subtotal;
  final double shipping;
  final double taxIncluded;
  final double grandTotal;
  final double walletAvailable;
  final double walletAmount;
  final double gatewayAmount;

  bool get payableByWalletOnly => gatewayAmount <= 0;

  /// Problems that aren't tied to a single line (shown as a banner).
  List<QuoteProblem> get orderProblems =>
      problems.where((p) => p.scope != 'item').toList();

  factory CheckoutQuote.fromJson(Json j) => CheckoutQuote(
    currency: jStr(j['currency'], 'INR'),
    ok: jBool(j['ok']),
    problems: jList(j['problems'], QuoteProblem.fromJson),
    needsAddress: jBool(j['needs_address']),
    sellers: jList(j['sellers'], QuoteSeller.fromJson),
    subtotal: jNum(j['subtotal']),
    shipping: jNum(j['shipping']),
    taxIncluded: jNum(j['tax_included']),
    grandTotal: jNum(j['grand_total']),
    walletAvailable: jNum(j['wallet_available']),
    walletAmount: jNum(j['wallet_amount']),
    gatewayAmount: jNum(j['gateway_amount']),
  );

  @override
  List<Object?> get props => [ok, problems, sellers, grandTotal, walletAmount];
}
