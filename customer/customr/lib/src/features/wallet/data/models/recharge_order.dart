import 'package:equatable/equatable.dart';

/// `POST /app/wallet/recharge` → the Razorpay order to open checkout with.
class RechargeOrder extends Equatable {
  const RechargeOrder({
    required this.paymentId,
    required this.gatewayOrderId,
    required this.amount,
    required this.currency,
    required this.keyId,
    this.gateway = 'razorpay',
  });

  final String paymentId;
  final String gatewayOrderId;
  final double amount;
  final String currency;
  final String keyId;
  final String gateway;

  /// Amount in the smallest currency unit (paise) — what Razorpay checkout wants.
  int get amountMinor => (amount * 100).round();

  factory RechargeOrder.fromJson(Map<String, dynamic> json) {
    return RechargeOrder(
      paymentId: '${json['payment_id'] ?? ''}',
      gatewayOrderId: '${json['gateway_order_id'] ?? ''}',
      amount: double.tryParse('${json['amount'] ?? 0}') ?? 0,
      currency: '${json['currency'] ?? 'INR'}',
      keyId: '${json['key_id'] ?? ''}',
      gateway: '${json['gateway'] ?? 'razorpay'}',
    );
  }

  @override
  List<Object?> get props => [paymentId, gatewayOrderId, amount, currency];
}

/// `GET/POST /app/wallet/recharge/{id}[/verify]` → capture status.
enum PaymentState { pending, captured, failed }

class PaymentStatus extends Equatable {
  const PaymentStatus({
    required this.paymentId,
    required this.state,
    required this.amount,
    required this.currency,
    this.method = '',
    this.capturedAt,
  });

  final String paymentId;
  final PaymentState state;
  final double amount;
  final String currency;
  final String method;
  final DateTime? capturedAt;

  factory PaymentStatus.fromJson(Map<String, dynamic> json) {
    final raw = '${json['status'] ?? 'created'}';
    final state = switch (raw) {
      'captured' => PaymentState.captured,
      'failed' || 'refunded' => PaymentState.failed,
      _ => PaymentState.pending,
    };
    return PaymentStatus(
      paymentId: '${json['payment_id'] ?? ''}',
      state: json['captured'] == true ? PaymentState.captured : state,
      amount: double.tryParse('${json['amount'] ?? 0}') ?? 0,
      currency: '${json['currency'] ?? 'INR'}',
      method: '${json['method'] ?? ''}',
      capturedAt: DateTime.tryParse('${json['captured_at'] ?? ''}')?.toLocal(),
    );
  }

  @override
  List<Object?> get props => [paymentId, state, amount];
}
