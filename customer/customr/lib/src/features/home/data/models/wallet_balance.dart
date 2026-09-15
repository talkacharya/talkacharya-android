import 'package:equatable/equatable.dart';

/// One currency wallet from `GET /app/wallet`.
class WalletBalance extends Equatable {
  const WalletBalance({
    required this.currency,
    required this.available,
    this.cached = 0,
    this.held = 0,
  });

  final String currency;
  final double available;
  final double cached;
  final double held;

  factory WalletBalance.fromJson(Map<String, dynamic> json) {
    double d(dynamic v) => v == null ? 0 : double.tryParse('$v') ?? 0;
    return WalletBalance(
      currency: '${json['currency'] ?? 'INR'}',
      available: d(json['available_balance'] ?? json['cached_balance']),
      cached: d(json['cached_balance']),
      held: d(json['held_amount']),
    );
  }

  @override
  List<Object?> get props => [currency, available, held];
}

extension WalletBalanceList on List<WalletBalance> {
  /// The wallet to show in the header — the preferred currency if present,
  /// else the first, else a zero INR wallet.
  WalletBalance primary(String preferredCurrency) {
    for (final w in this) {
      if (w.currency == preferredCurrency) return w;
    }
    return isNotEmpty
        ? first
        : WalletBalance(currency: preferredCurrency, available: 0);
  }
}
