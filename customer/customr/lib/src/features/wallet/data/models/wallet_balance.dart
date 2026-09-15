import 'package:equatable/equatable.dart';

/// One currency wallet from `GET /app/wallet`.
class WalletBalance extends Equatable {
  const WalletBalance({
    required this.currency,
    required this.available,
    this.cached = 0,
    this.held = 0,
    this.frozen = false,
  });

  final String currency;

  /// Spendable right now (cached balance minus active holds).
  final double available;
  final double cached;

  /// Reserved by a running consultation.
  final double held;
  final bool frozen;

  bool get hasHold => held > 0.005;

  factory WalletBalance.fromJson(Map<String, dynamic> json) {
    double d(dynamic v) => v == null ? 0 : double.tryParse('$v') ?? 0;
    return WalletBalance(
      currency: '${json['currency'] ?? 'INR'}',
      available: d(json['available_balance'] ?? json['cached_balance']),
      cached: d(json['cached_balance']),
      held: d(json['held_amount']),
      frozen: json['status'] == 'frozen',
    );
  }

  @override
  List<Object?> get props => [currency, available, cached, held, frozen];
}

extension WalletBalanceList on List<WalletBalance> {
  /// The wallet to show — the preferred currency if the user has one, else the
  /// first, else a zero wallet in the preferred currency.
  WalletBalance primary(String preferredCurrency) {
    for (final w in this) {
      if (w.currency == preferredCurrency) return w;
    }
    return isNotEmpty
        ? first
        : WalletBalance(currency: preferredCurrency, available: 0);
  }
}
