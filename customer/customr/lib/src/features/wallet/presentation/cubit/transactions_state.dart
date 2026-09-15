part of 'transactions_cubit.dart';

enum TxnStatus { initial, loading, loadingMore, ready, error }

enum TxnFilter {
  all,
  added,
  consultation,
  refund,
  bonus;

  bool matches(WalletTransaction t) {
    switch (this) {
      case TxnFilter.all:
        return true;
      case TxnFilter.added:
        return t.kind == 'recharge';
      case TxnFilter.consultation:
        return t.kind == 'consultation_charge' ||
            t.kind == 'hold_capture' ||
            t.kind == 'gift_spend';
      case TxnFilter.refund:
        return t.kind == 'consultation_refund' ||
            t.kind == 'hold_release' ||
            t.kind == 'chargeback';
      case TxnFilter.bonus:
        return t.kind == 'promo_credit' ||
            t.kind == 'coupon_discount' ||
            t.kind == 'signup_bonus' ||
            t.kind == 'referral_bonus';
    }
  }
}

class TransactionsState extends Equatable {
  const TransactionsState({
    this.status = TxnStatus.initial,
    this.items = const [],
    this.nextCursor,
    this.hasMore = false,
    this.error,
    this.filter = TxnFilter.all,
  });

  final TxnStatus status;
  final List<WalletTransaction> items;
  final String? nextCursor;
  final bool hasMore;
  final String? error;
  final TxnFilter filter;

  List<WalletTransaction> get visible =>
      filter == TxnFilter.all ? items : items.where(filter.matches).toList();

  bool get isEmpty => status == TxnStatus.ready && items.isEmpty;

  TransactionsState copyWith({
    TxnStatus? status,
    List<WalletTransaction>? items,
    String? Function()? nextCursor,
    bool? hasMore,
    String? error,
    bool clearError = false,
    TxnFilter? filter,
  }) {
    return TransactionsState(
      status: status ?? this.status,
      items: items ?? this.items,
      nextCursor: nextCursor != null ? nextCursor() : this.nextCursor,
      hasMore: hasMore ?? this.hasMore,
      error: clearError ? null : (error ?? this.error),
      filter: filter ?? this.filter,
    );
  }

  @override
  List<Object?> get props => [
    status,
    items,
    nextCursor,
    hasMore,
    error,
    filter,
  ];
}
