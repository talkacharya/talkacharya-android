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

  /// What the app may show and the customer may spend.
  ///
  /// [available] is the server's arithmetic — balance minus what live sessions
  /// have reserved — and it can come back below zero if a reservation outlived
  /// the session that made it, or if a balance was corrected. "−₹1,472" tells a
  /// customer nothing except that something is wrong with our books, so the
  /// figure on screen is floored at zero and the reserved amount is shown
  /// beside it instead.
  double get spendable => available > 0 ? available : 0;

  /// True when holds reserve more than the balance covers — a state that should
  /// not last, since a hold is released the moment its session settles.
  bool get overReserved => available < -0.005;

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
