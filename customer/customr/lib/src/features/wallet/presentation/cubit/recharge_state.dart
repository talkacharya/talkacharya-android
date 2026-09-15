part of 'recharge_cubit.dart';

enum RechargeStatus {
  idle,
  creatingOrder,
  checkout,
  confirming,
  success,
  failed,
}

class RechargeState extends Equatable {
  const RechargeState({
    this.status = RechargeStatus.idle,
    this.amount,
    this.currency = 'INR',
    this.order,
    this.newBalance,
    this.pendingWebhook = false,
    this.cancelled = false,
    this.message,
    this.error,
  });

  final RechargeStatus status;
  final double? amount;
  final String currency;
  final RechargeOrder? order;

  /// Set once the balance is confirmed; null while the webhook is still pending.
  final double? newBalance;
  final bool pendingWebhook;

  /// The user closed Razorpay without paying.
  final bool cancelled;
  final String? message;
  final Object? error;

  bool get isBusy =>
      status == RechargeStatus.creatingOrder ||
      status == RechargeStatus.checkout ||
      status == RechargeStatus.confirming;

  RechargeState copyWith({
    RechargeStatus? status,
    double? amount,
    String? currency,
    RechargeOrder? order,
    double? Function()? newBalance,
    bool? pendingWebhook,
    bool? cancelled,
    String? message,
    Object? Function()? error,
  }) {
    return RechargeState(
      status: status ?? this.status,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      order: order ?? this.order,
      newBalance: newBalance != null ? newBalance() : this.newBalance,
      pendingWebhook: pendingWebhook ?? this.pendingWebhook,
      cancelled: cancelled ?? this.cancelled,
      message: message,
      error: error != null ? error() : this.error,
    );
  }

  @override
  List<Object?> get props => [
    status,
    amount,
    currency,
    order,
    newBalance,
    pendingWebhook,
    cancelled,
    message,
  ];
}
