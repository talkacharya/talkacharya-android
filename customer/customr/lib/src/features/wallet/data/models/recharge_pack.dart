import 'package:equatable/equatable.dart';

/// `GET /app/wallet/packs` → the whole payload.
class WalletPacks extends Equatable {
  const WalletPacks({
    required this.currency,
    required this.minRecharge,
    this.packs = const [],
    this.offers = const [],
  });

  final String currency;
  final double minRecharge;
  final List<RechargePack> packs;
  final List<WalletOffer> offers;

  factory WalletPacks.fromJson(Map<String, dynamic> json) {
    return WalletPacks(
      currency: '${json['currency'] ?? 'INR'}',
      minRecharge: double.tryParse('${json['min_recharge'] ?? 100}') ?? 100,
      packs: (json['packs'] as List<dynamic>? ?? const [])
          .map((e) => RechargePack.fromJson(e as Map<String, dynamic>))
          .toList(),
      offers: (json['offers'] as List<dynamic>? ?? const [])
          .map((e) => WalletOffer.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  List<Object?> get props => [currency, minRecharge, packs, offers];
}

class RechargePack extends Equatable {
  const RechargePack({
    required this.amount,
    required this.currency,
    this.bonus = 0,
    this.starter = false,
    this.offerCode,
  });

  final int amount;
  final String currency;
  final int bonus;
  final bool starter;
  final String? offerCode;

  int get total => amount + bonus;
  bool get hasBonus => bonus > 0;

  factory RechargePack.fromJson(Map<String, dynamic> json) {
    int n(dynamic v) => (double.tryParse('${v ?? 0}') ?? 0).round();
    return RechargePack(
      amount: n(json['amount']),
      currency: '${json['currency'] ?? 'INR'}',
      bonus: n(json['bonus']),
      starter: json['starter'] == true,
      offerCode: json['offer_code'] as String?,
    );
  }

  /// Client fallback ladder if the packs endpoint is unavailable.
  static List<RechargePack> fallback({
    required int minRecharge,
    required String currency,
  }) {
    final base = minRecharge < 100 ? 100 : minRecharge;
    return [
      RechargePack(amount: base, currency: currency, starter: true),
      RechargePack(amount: base * 5, currency: currency),
      RechargePack(amount: base * 10, currency: currency),
      RechargePack(amount: base * 20, currency: currency),
    ];
  }

  @override
  List<Object?> get props => [amount, currency, bonus];
}

class WalletOffer extends Equatable {
  const WalletOffer({
    required this.code,
    required this.title,
    this.kind = 'offer',
    this.amount,
    this.percentage,
    this.minRecharge,
  });

  final String code;
  final String title;
  final String kind;
  final double? amount;
  final double? percentage;
  final double? minRecharge;

  factory WalletOffer.fromJson(Map<String, dynamic> json) {
    double? d(dynamic v) => v == null ? null : double.tryParse('$v');
    return WalletOffer(
      code: '${json['code'] ?? ''}',
      title: '${json['title'] ?? ''}',
      kind: '${json['kind'] ?? 'offer'}',
      amount: d(json['amount']),
      percentage: d(json['percentage']),
      minRecharge: d(json['min_recharge']),
    );
  }

  @override
  List<Object?> get props => [code, title, amount, percentage, minRecharge];
}
