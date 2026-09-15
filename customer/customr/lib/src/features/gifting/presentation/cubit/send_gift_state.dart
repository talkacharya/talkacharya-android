part of 'send_gift_cubit.dart';

enum SendGiftStatus { loading, ready, sending, sent, failed }

class SendGiftState extends Equatable {
  const SendGiftState({
    required this.target,
    this.status = SendGiftStatus.loading,
    this.gifts = const [],
    this.selected,
    this.quantity = 1,
    this.lowBalance = false,
    this.sent,
    this.error,
  });

  static const maxQuantity = 99;

  final GiftTarget target;
  final SendGiftStatus status;
  final List<Gift> gifts;
  final Gift? selected;
  final int quantity;

  /// The last attempt bounced on a `402` — show the top-up prompt.
  final bool lowBalance;
  final GiftTransaction? sent;

  /// The last non-balance failure (raw; the view localizes it).
  final Object? error;

  bool get isSending => status == SendGiftStatus.sending;

  /// Total for the current selection in the target's wallet currency, or the
  /// INR estimate when the catalog has no price in that currency.
  ({double amount, String currency, bool estimate})? get total {
    final g = selected;
    if (g == null) return null;
    final p = g.displayPrice(target.currency);
    return (
      amount: p.amount * quantity,
      currency: p.currency,
      estimate: p.estimate,
    );
  }

  SendGiftState copyWith({
    SendGiftStatus? status,
    List<Gift>? gifts,
    Gift? selected,
    int? quantity,
    bool? lowBalance,
    GiftTransaction? sent,
    Object? error,
    bool clearSent = false,
    bool clearError = false,
  }) {
    return SendGiftState(
      target: target,
      status: status ?? this.status,
      gifts: gifts ?? this.gifts,
      selected: selected ?? this.selected,
      quantity: quantity ?? this.quantity,
      lowBalance: lowBalance ?? this.lowBalance,
      sent: clearSent ? null : (sent ?? this.sent),
      error: clearError ? null : (error ?? this.error),
    );
  }

  @override
  List<Object?> get props => [
    target,
    status,
    gifts,
    selected,
    quantity,
    lowBalance,
    sent,
    error,
  ];
}
