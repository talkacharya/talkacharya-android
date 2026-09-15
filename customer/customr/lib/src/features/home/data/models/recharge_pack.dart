import 'package:equatable/equatable.dart';

/// A recharge suggestion for the "Add money, get bonus" strip.
///
/// There is no `/app/wallet/packs` endpoint yet, so these are derived on the
/// client from `config.minRecharge` with a simple bonus ladder. When the
/// endpoint ships, swap [suggestionsFor] for a repository call — the widget
/// contract stays the same.
class RechargePack extends Equatable {
  const RechargePack({
    required this.amount,
    required this.currency,
    this.bonus = 0,
    this.badge,
  });

  final int amount;
  final String currency;
  final int bonus;
  final String? badge;

  int get total => amount + bonus;
  bool get hasBonus => bonus > 0;

  /// From `GET /app/wallet/packs` → `packs[]`
  /// (`{amount, bonus, total, currency, offer_code, starter}`, all strings).
  factory RechargePack.fromJson(Map<String, dynamic> json, {String? badge}) {
    int n(dynamic v) => (double.tryParse('${v ?? 0}') ?? 0).round();
    return RechargePack(
      amount: n(json['amount']),
      currency: '${json['currency'] ?? 'INR'}',
      bonus: n(json['bonus']),
      badge: badge,
    );
  }

  static List<RechargePack> suggestionsFor({
    required int minRecharge,
    required String currency,
  }) {
    final base = minRecharge < 100 ? 100 : minRecharge;
    return [
      RechargePack(amount: base, currency: currency),
      RechargePack(
        amount: base * 5,
        currency: currency,
        bonus: (base * 5 * 0.05).round(),
      ),
      RechargePack(
        amount: base * 10,
        currency: currency,
        bonus: (base * 10 * 0.12).round(),
        badge: 'Popular',
      ),
      RechargePack(
        amount: base * 20,
        currency: currency,
        bonus: (base * 20 * 0.2).round(),
        badge: 'Best value',
      ),
    ];
  }

  @override
  List<Object?> get props => [amount, currency, bonus];
}
