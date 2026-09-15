import 'package:freezed_annotation/freezed_annotation.dart';

import 'prediction_enums.dart';

part 'prediction_catalog.freezed.dart';

@freezed
abstract class PredictionPack with _$PredictionPack {
  const factory PredictionPack({
    required int pack,
    required int credits,
    required String price,
  }) = _PredictionPack;

  factory PredictionPack.fromMap(Map<String, dynamic> j) => PredictionPack(
    pack: (j['pack'] as num?)?.toInt() ?? 1,
    credits: (j['credits'] as num?)?.toInt() ?? 1,
    price: j['price']?.toString() ?? '0',
  );
}

@freezed
abstract class PredictionOption with _$PredictionOption {
  const factory PredictionOption({required String value, required String label}) =
      _PredictionOption;

  factory PredictionOption.fromMap(Map<String, dynamic> j) => PredictionOption(
    value: j['value'] as String? ?? '',
    label: j['label'] as String? ?? '',
  );
}

/// The whole `/app/predictions/catalog` payload.
@freezed
abstract class PredictionCatalog with _$PredictionCatalog {
  const PredictionCatalog._();

  const factory PredictionCatalog({
    @Default('INR') String currency,
    @Default(0) int creditBalance,
    @Default(<PredictionPack>[]) List<PredictionPack> packs,
    @Default('0') String subscriptionPrice,
    @Default(PredictionArea.general) PredictionArea subscriptionArea,
    @Default(PredictionPeriod.year) PredictionPeriod subscriptionPeriod,
    @Default(SubscriptionStatus.none) SubscriptionStatus subscriptionStatus,
    String? subscriptionRenewsOn,
    @Default(120) int minWords,
    @Default(72) int slaHours,
    @Default(<PredictionOption>[]) List<PredictionOption> areas,
    @Default(<PredictionOption>[]) List<PredictionOption> periods,
  }) = _PredictionCatalog;

  factory PredictionCatalog.fromMap(Map<String, dynamic> j) {
    final sub = (j['subscription'] as Map?)?.cast<String, dynamic>() ?? const {};
    return PredictionCatalog(
      currency: j['currency'] as String? ?? 'INR',
      creditBalance: (j['credit_balance'] as num?)?.toInt() ?? 0,
      packs: (j['packs'] as List<dynamic>? ?? const [])
          .map((e) => PredictionPack.fromMap((e as Map).cast<String, dynamic>()))
          .toList(),
      subscriptionPrice: sub['price']?.toString() ?? '0',
      subscriptionArea: PredictionArea.fromWire(sub['area'] as String? ?? 'general'),
      subscriptionPeriod: PredictionPeriod.fromWire(sub['period'] as String? ?? 'year'),
      subscriptionStatus: SubscriptionStatus.fromWire(sub['status'] as String?),
      subscriptionRenewsOn: sub['renews_on'] as String?,
      minWords: (j['min_words'] as num?)?.toInt() ?? 120,
      slaHours: (j['sla_hours'] as num?)?.toInt() ?? 72,
      areas: (j['areas'] as List<dynamic>? ?? const [])
          .map((e) => PredictionOption.fromMap((e as Map).cast<String, dynamic>()))
          .toList(),
      periods: (j['periods'] as List<dynamic>? ?? const [])
          .map((e) => PredictionOption.fromMap((e as Map).cast<String, dynamic>()))
          .toList(),
    );
  }

  bool get hasCredits => creditBalance > 0;
  bool get subscribed => subscriptionStatus == SubscriptionStatus.active;
}

@freezed
abstract class PredictionOrder with _$PredictionOrder {
  const factory PredictionOrder({
    required String id,
    required int pack,
    required int creditsGranted,
    required String amount,
    @Default('INR') String currency,
    @Default('paid') String status,
    DateTime? createdAt,
  }) = _PredictionOrder;

  factory PredictionOrder.fromMap(Map<String, dynamic> j) => PredictionOrder(
    id: j['id']?.toString() ?? '',
    pack: (j['pack'] as num?)?.toInt() ?? 1,
    creditsGranted: (j['credits_granted'] as num?)?.toInt() ?? 0,
    amount: j['amount']?.toString() ?? '0',
    currency: j['currency'] as String? ?? 'INR',
    status: j['status'] as String? ?? 'paid',
    createdAt: j['created_at'] is String
        ? DateTime.tryParse(j['created_at'] as String)
        : null,
  );
}
