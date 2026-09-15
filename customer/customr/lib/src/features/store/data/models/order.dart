import 'package:equatable/equatable.dart';

import '../../../wallet/data/models/recharge_order.dart';
import 'product.dart';
import 'store_json.dart';

/// Backend `OrderStatus`.
enum OrderStatus {
  pendingPayment,
  paid,
  completed,
  cancelled,
  expired,
  refunded;

  static OrderStatus parse(String? s) => switch (s) {
    'paid' => paid,
    'completed' => completed,
    'cancelled' => cancelled,
    'expired' => expired,
    'refunded' => refunded,
    _ => pendingPayment,
  };

  bool get isClosed => this == cancelled || this == expired || this == refunded;
}

/// A sub-order's lifecycle stage — backend `SubOrderStatus`, kept as the wire string
/// so new stages degrade gracefully.
class SubOrderStage {
  const SubOrderStage._();
  static const pending = 'pending';
  static const awaitingApproval = 'awaiting_approval';
  static const confirmed = 'confirmed';
  static const processing = 'processing';
  static const shipped = 'shipped';
  static const delivered = 'delivered';
  static const completed = 'completed';
  static const cancelled = 'cancelled';
  static const returned = 'returned';

  /// The happy-path steps shown on the tracking stepper for goods.
  static const goodsSteps = [confirmed, processing, shipped, delivered];

  static bool isClosed(String s) =>
      s == completed || s == cancelled || s == returned;
}

class OrderSummary extends Equatable {
  const OrderSummary({
    required this.id,
    required this.number,
    required this.status,
    this.currency = 'INR',
    this.grandTotal = 0,
    this.createdAt,
    this.paidAt,
    this.items = const [],
  });

  final String id;
  final String number;
  final OrderStatus status;
  final String currency;
  final double grandTotal;
  final DateTime? createdAt;
  final DateTime? paidAt;

  /// Up to five `(title, quantity, fulfilment)` previews.
  final List<({String title, int quantity, Fulfilment fulfilment})> items;

  bool get hasService => items.any((i) => i.fulfilment == Fulfilment.service);

  factory OrderSummary.fromJson(Json j) => OrderSummary(
    id: jStr(j['id']),
    number: jStr(j['number']),
    status: OrderStatus.parse(jStrOrNull(j['status'])),
    currency: jStr(j['currency'], 'INR'),
    grandTotal: jNum(j['grand_total']),
    createdAt: jDate(j['created_at']),
    paidAt: jDate(j['paid_at']),
    items: j['items'] is List
        ? [
            for (final e in j['items'] as List)
              if (e is Map)
                (
                  title: jStr(e['title']),
                  quantity: jInt(e['quantity'], 1),
                  fulfilment: Fulfilment.parse(jStrOrNull(e['fulfilment'])),
                ),
          ]
        : const [],
  );

  @override
  List<Object?> get props => [id, status, grandTotal];
}

class ServiceProof extends Equatable {
  const ServiceProof({
    required this.id,
    required this.url,
    this.kind = 'video',
    this.caption = '',
    this.createdAt,
  });

  final String id;
  final String url;
  final String kind;
  final String caption;
  final DateTime? createdAt;

  bool get isVideo => kind == 'video';

  factory ServiceProof.fromJson(Json j) => ServiceProof(
    id: jStr(j['id']),
    url: jStr(j['url']),
    kind: jStr(j['kind'], 'video'),
    caption: jStr(j['caption']),
    createdAt: jDate(j['created_at']),
  );

  @override
  List<Object?> get props => [id, url];
}

/// A pooja booking attached to a service line.
class ServiceBooking extends Equatable {
  const ServiceBooking({
    required this.id,
    this.orderId = '',
    this.productTitle = '',
    this.status = 'confirmed',
    this.sankalp = const {},
    this.event,
    this.scheduledFor,
    this.performedAt,
    this.proofUploadedAt,
    this.proofs = const [],
  });

  final String id;
  final String orderId;
  final String productTitle;

  /// pending | confirmed | performed | proof_uploaded | completed | cancelled
  final String status;
  final Json sankalp;
  final ServiceEvent? event;
  final DateTime? scheduledFor;
  final DateTime? performedAt;
  final DateTime? proofUploadedAt;
  final List<ServiceProof> proofs;

  bool get hasProof => proofs.isNotEmpty;
  DateTime? get when => event?.startsAt ?? scheduledFor;

  factory ServiceBooking.fromJson(Json j) => ServiceBooking(
    id: jStr(j['id']),
    orderId: jStr(j['order_id']),
    productTitle: jStr(j['product_title']),
    status: jStr(j['status'], 'confirmed'),
    sankalp: jMap(j['sankalp']),
    event: jMapOrNull(j['event']) == null
        ? null
        : ServiceEvent.fromJson(jMap(j['event'])),
    scheduledFor: jDate(j['scheduled_for']),
    performedAt: jDate(j['performed_at']),
    proofUploadedAt: jDate(j['proof_uploaded_at']),
    proofs: jList(j['proofs'], ServiceProof.fromJson),
  );

  @override
  List<Object?> get props => [id, status, proofs];
}

class OrderLine extends Equatable {
  const OrderLine({
    required this.id,
    required this.productTitle,
    this.variantId = '',
    this.productSlug = '',
    this.variantName = '',
    this.sku = '',
    this.fulfilment = Fulfilment.physical,
    this.quantity = 1,
    this.unitPrice = 0,
    this.unitCompareAt,
    this.lineTotal = 0,
    this.taxAmount = 0,
    this.taxRate = 0,
    this.inputs = const {},
    this.status = 'active',
    this.refundedAmount = 0,
    this.returnableUntil,
    this.canReturn = false,
    this.booking,
    this.downloads = const [],
  });

  final String id;
  final String productTitle;
  final String variantId;
  final String productSlug;
  final String variantName;
  final String sku;
  final Fulfilment fulfilment;
  final int quantity;
  final double unitPrice;
  final double? unitCompareAt;
  final double lineTotal;
  final double taxAmount;
  final double taxRate;
  final Json inputs;

  /// active | cancelled | returned
  final String status;
  final double refundedAmount;
  final DateTime? returnableUntil;
  final bool canReturn;
  final ServiceBooking? booking;
  final List<({String id, String title})> downloads;

  bool get isActive => status == 'active';

  factory OrderLine.fromJson(Json j) => OrderLine(
    id: jStr(j['id']),
    productTitle: jStr(j['product_title']),
    variantId: jStr(j['variant_id']),
    productSlug: jStr(j['product_slug']),
    variantName: jStr(j['variant_name']),
    sku: jStr(j['sku']),
    fulfilment: Fulfilment.parse(jStrOrNull(j['fulfilment'])),
    quantity: jInt(j['quantity'], 1),
    unitPrice: jNum(j['unit_price']),
    unitCompareAt: jNumOrNull(j['unit_compare_at']),
    lineTotal: jNum(j['line_total']),
    taxAmount: jNum(j['tax_amount']),
    taxRate: jNum(j['tax_rate']),
    inputs: jMap(j['inputs']),
    status: jStr(j['status'], 'active'),
    refundedAmount: jNum(j['refunded_amount']),
    returnableUntil: jDate(j['returnable_until']),
    canReturn: jBool(j['can_return']),
    booking: jMapOrNull(j['booking']) == null
        ? null
        : ServiceBooking.fromJson(jMap(j['booking'])),
    downloads: j['downloads'] is List
        ? [
            for (final d in j['downloads'] as List)
              if (d is Map) (id: jStr(d['id']), title: jStr(d['title'])),
          ]
        : const [],
  );

  @override
  List<Object?> get props => [id, status, refundedAmount, canReturn, booking];
}

class ShipmentEvent extends Equatable {
  const ShipmentEvent({this.status = '', this.at, this.location = ''});

  final String status;
  final DateTime? at;
  final String location;

  factory ShipmentEvent.fromJson(Json j) => ShipmentEvent(
    status: jStr(j['status'] ?? j['raw']),
    at: jDate(j['at']),
    location: jStr(j['location']),
  );

  @override
  List<Object?> get props => [status, at];
}

class Shipment extends Equatable {
  const Shipment({
    required this.id,
    this.carrier = '',
    this.courierName = '',
    this.awb = '',
    this.trackingUrl,
    this.status = 'created',
    this.shippedAt,
    this.deliveredAt,
    this.events = const [],
  });

  final String id;
  final String carrier;
  final String courierName;
  final String awb;
  final String? trackingUrl;

  /// created | picked_up | in_transit | out_for_delivery | delivered | ndr | rto …
  final String status;
  final DateTime? shippedAt;
  final DateTime? deliveredAt;
  final List<ShipmentEvent> events;

  bool get hasIssue => status == 'ndr' || status == 'rto' || status == 'lost';

  factory Shipment.fromJson(Json j) => Shipment(
    id: jStr(j['id']),
    carrier: jStr(j['carrier']),
    courierName: jStr(j['courier_name']),
    awb: jStr(j['awb']),
    trackingUrl: jStrOrNull(j['tracking_url']),
    status: jStr(j['status'], 'created'),
    shippedAt: jDate(j['shipped_at']),
    deliveredAt: jDate(j['delivered_at']),
    events: jList(j['events'], ShipmentEvent.fromJson),
  );

  @override
  List<Object?> get props => [id, status, awb];
}

class SubOrder extends Equatable {
  const SubOrder({
    required this.id,
    required this.number,
    required this.status,
    this.fulfilment = 'physical',
    this.seller = const SellerRef(code: ''),
    this.subtotal = 0,
    this.shippingTotal = 0,
    this.taxTotal = 0,
    this.total = 0,
    this.refundedTotal = 0,
    this.lines = const [],
    this.shipments = const [],
    this.canCancel = false,
    this.invoiceNumber,
    this.deliveredAt,
  });

  final String id;
  final String number;
  final String status;

  /// physical | digital | service | mixed
  final String fulfilment;
  final SellerRef seller;
  final double subtotal;
  final double shippingTotal;
  final double taxTotal;
  final double total;
  final double refundedTotal;
  final List<OrderLine> lines;
  final List<Shipment> shipments;
  final bool canCancel;
  final String? invoiceNumber;
  final DateTime? deliveredAt;

  bool get hasGoods => lines.any((l) => l.fulfilment == Fulfilment.physical);
  Shipment? get shipment => shipments.isEmpty ? null : shipments.first;

  factory SubOrder.fromJson(Json j) => SubOrder(
    id: jStr(j['id']),
    number: jStr(j['number']),
    status: jStr(j['status'], SubOrderStage.pending),
    fulfilment: jStr(j['fulfilment'], 'physical'),
    seller: SellerRef.fromJson(jMap(j['seller'])),
    subtotal: jNum(j['subtotal']),
    shippingTotal: jNum(j['shipping_total']),
    taxTotal: jNum(j['tax_total']),
    total: jNum(j['total']),
    refundedTotal: jNum(j['refunded_total']),
    lines: jList(j['lines'], OrderLine.fromJson),
    shipments: jList(j['shipments'], Shipment.fromJson),
    canCancel: jBool(j['can_cancel']),
    invoiceNumber: jStrOrNull(j['invoice_number']),
    deliveredAt: jDate(j['delivered_at']),
  );

  @override
  List<Object?> get props => [id, status, lines, shipments, canCancel];
}

class StoreRefund extends Equatable {
  const StoreRefund({
    required this.id,
    required this.amount,
    this.currency = 'INR',
    this.destination = 'wallet',
    this.toSourceAmount = 0,
    this.reason = '',
    this.createdAt,
  });

  final String id;
  final double amount;
  final String currency;
  final String destination;
  final double toSourceAmount;
  final String reason;
  final DateTime? createdAt;

  factory StoreRefund.fromJson(Json j) => StoreRefund(
    id: jStr(j['id']),
    amount: jNum(j['amount']),
    currency: jStr(j['currency'], 'INR'),
    destination: jStr(j['destination'], 'wallet'),
    toSourceAmount: jNum(j['to_source_amount']),
    reason: jStr(j['reason']),
    createdAt: jDate(j['created_at']),
  );

  @override
  List<Object?> get props => [id, amount];
}

/// Razorpay order for the gateway share of a store order.
class StorePayment extends Equatable {
  const StorePayment({
    required this.paymentId,
    required this.gatewayOrderId,
    required this.amount,
    this.currency = 'INR',
    this.status = 'created',
    this.keyId = '',
  });

  final String paymentId;
  final String gatewayOrderId;
  final double amount;
  final String currency;
  final String status;
  final String keyId;

  /// Same shape the wallet recharge flow hands to `RazorpayService`.
  RechargeOrder toGatewayOrder() => RechargeOrder(
    paymentId: paymentId,
    gatewayOrderId: gatewayOrderId,
    amount: amount,
    currency: currency,
    keyId: keyId,
  );

  factory StorePayment.fromJson(Json j) => StorePayment(
    paymentId: jStr(j['payment_id']),
    gatewayOrderId: jStr(j['gateway_order_id']),
    amount: jNum(j['amount']),
    currency: jStr(j['currency'], 'INR'),
    status: jStr(j['status'], 'created'),
    keyId: jStr(j['key_id']),
  );

  @override
  List<Object?> get props => [paymentId, gatewayOrderId, amount, status];
}

class StoreOrder extends Equatable {
  const StoreOrder({
    required this.id,
    required this.number,
    required this.status,
    this.currency = 'INR',
    this.subtotal = 0,
    this.shippingTotal = 0,
    this.taxTotal = 0,
    this.grandTotal = 0,
    this.refundedTotal = 0,
    this.walletAmount = 0,
    this.gatewayAmount = 0,
    this.shippingAddress = const {},
    this.customerNote = '',
    this.createdAt,
    this.paidAt,
    this.expiresAt,
    this.cancelledAt,
    this.subOrders = const [],
    this.payment,
    this.refunds = const [],
  });

  final String id;
  final String number;
  final OrderStatus status;
  final String currency;
  final double subtotal;
  final double shippingTotal;
  final double taxTotal;
  final double grandTotal;
  final double refundedTotal;
  final double walletAmount;
  final double gatewayAmount;
  final Json shippingAddress;
  final String customerNote;
  final DateTime? createdAt;
  final DateTime? paidAt;
  final DateTime? expiresAt;
  final DateTime? cancelledAt;
  final List<SubOrder> subOrders;

  /// Present only while a gateway share is still unpaid.
  final StorePayment? payment;
  final List<StoreRefund> refunds;

  bool get awaitingPayment => status == OrderStatus.pendingPayment;
  bool get canCancel => awaitingPayment || subOrders.any((s) => s.canCancel);
  List<OrderLine> get lines => [for (final s in subOrders) ...s.lines];
  List<ServiceBooking> get bookings => [
    for (final l in lines)
      if (l.booking != null) l.booking!,
  ];

  String get addressLine => [
    for (final k in const ['line1', 'line2', 'landmark', 'city', 'state'])
      if (jStr(shippingAddress[k]).isNotEmpty) jStr(shippingAddress[k]),
    jStr(shippingAddress['postal_code']),
  ].where((s) => s.isNotEmpty).join(', ');

  factory StoreOrder.fromJson(Json j) => StoreOrder(
    id: jStr(j['id']),
    number: jStr(j['number']),
    status: OrderStatus.parse(jStrOrNull(j['status'])),
    currency: jStr(j['currency'], 'INR'),
    subtotal: jNum(j['subtotal']),
    shippingTotal: jNum(j['shipping_total']),
    taxTotal: jNum(j['tax_total']),
    grandTotal: jNum(j['grand_total']),
    refundedTotal: jNum(j['refunded_total']),
    walletAmount: jNum(j['wallet_amount']),
    gatewayAmount: jNum(j['gateway_amount']),
    shippingAddress: jMap(j['shipping_address']),
    customerNote: jStr(j['customer_note']),
    createdAt: jDate(j['created_at']),
    paidAt: jDate(j['paid_at']),
    expiresAt: jDate(j['expires_at']),
    cancelledAt: jDate(j['cancelled_at']),
    subOrders: jList(j['sub_orders'], SubOrder.fromJson),
    payment: jMapOrNull(j['payment']) == null
        ? null
        : StorePayment.fromJson(jMap(j['payment'])),
    refunds: jList(j['refunds'], StoreRefund.fromJson),
  );

  @override
  List<Object?> get props => [id, status, subOrders, payment, refunds];
}

class StoreInvoice extends Equatable {
  const StoreInvoice({
    required this.id,
    required this.number,
    this.kind = 'store_invoice',
    this.currency = 'INR',
    this.totalAmount = 0,
    this.taxAmount = 0,
    this.issuedAt,
  });

  final String id;
  final String number;
  final String kind;
  final String currency;
  final double totalAmount;
  final double taxAmount;
  final DateTime? issuedAt;

  bool get isCreditNote => kind == 'credit_note';

  factory StoreInvoice.fromJson(Json j) => StoreInvoice(
    id: jStr(j['id']),
    number: jStr(j['number']),
    kind: jStr(j['kind'], 'store_invoice'),
    currency: jStr(j['currency'], 'INR'),
    totalAmount: jNum(j['total_amount']),
    taxAmount: jNum(j['tax_amount']),
    issuedAt: jDate(j['issued_at']),
  );

  @override
  List<Object?> get props => [id, number];
}

/// Allowed return reasons (backend `RETURN_REASONS`).
const kReturnReasons = <String>[
  'damaged',
  'wrong_item',
  'not_as_described',
  'authenticity_concern',
  'size_issue',
  'changed_mind',
  'other',
];
