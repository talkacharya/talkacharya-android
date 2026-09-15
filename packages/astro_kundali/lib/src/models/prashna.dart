import 'package:flutter/material.dart' show Color, IconData, Icons;
import 'package:freezed_annotation/freezed_annotation.dart';

part 'prashna.freezed.dart';

/// One horary (KP Prashna) answer from `/app/prashna`. Auto-generated — a
/// verdict on the moment the question was asked. Not a promise.
@freezed
abstract class Prashna with _$Prashna {
  const Prashna._();

  const factory Prashna({
    @Default('') String id,
    @Default('') String question,
    @Default('') String category,
    @Default(0) int number,
    @Default('') String placeLabel,
    @Default('unclear') String verdict,
    @Default(0) int strength,
    @Default('') String answer,
    @Default('') String pricePaid,
    @Default('INR') String currency,
    DateTime? createdAt,
    Map<String, dynamic>? judgment,
    Map<String, dynamic>? chart,
  }) = _Prashna;

  factory Prashna.fromMap(Map<String, dynamic> j) => Prashna(
    id: j['id']?.toString() ?? '',
    question: j['question'] as String? ?? '',
    category: j['category'] as String? ?? '',
    number: (j['number'] as num?)?.toInt() ?? 0,
    placeLabel: j['place_label'] as String? ?? '',
    verdict: j['verdict'] as String? ?? 'unclear',
    strength: (j['strength'] as num?)?.toInt() ?? 0,
    answer: j['answer'] as String? ?? '',
    pricePaid: j['price_paid']?.toString() ?? '',
    currency: j['currency'] as String? ?? 'INR',
    createdAt: j['created_at'] is String
        ? DateTime.tryParse(j['created_at'] as String)
        : null,
    judgment: (j['judgment'] as Map?)?.cast<String, dynamic>(),
    chart: (j['chart'] as Map?)?.cast<String, dynamic>(),
  );

  List<PrashnaReason> get reasons {
    final raw = (judgment?['reasons'] as List?) ?? const [];
    return raw
        .map((e) => PrashnaReason.fromMap((e as Map).cast<String, dynamic>()))
        .toList();
  }

  Map<String, dynamic> get rulingPlanets =>
      (chart?['ruling_planets'] as Map?)?.cast<String, dynamic>() ?? const {};
}

@freezed
abstract class PrashnaReason with _$PrashnaReason {
  const factory PrashnaReason({
    @Default('') String key,
    @Default('') String text,
  }) = _PrashnaReason;

  factory PrashnaReason.fromMap(Map<String, dynamic> j) => PrashnaReason(
    key: j['key'] as String? ?? '',
    text: j['text'] as String? ?? '',
  );
}

@freezed
abstract class PrashnaCategoryOption with _$PrashnaCategoryOption {
  const factory PrashnaCategoryOption({
    required String value,
    required String label,
  }) = _PrashnaCategoryOption;

  factory PrashnaCategoryOption.fromMap(Map<String, dynamic> j) =>
      PrashnaCategoryOption(
        value: j['value'] as String? ?? '',
        label: j['label'] as String? ?? '',
      );
}

@freezed
abstract class PrashnaCatalog with _$PrashnaCatalog {
  const PrashnaCatalog._();

  const factory PrashnaCatalog({
    @Default('INR') String currency,
    @Default('0') String price,
    @Default('0') String walletBalance,
    @Default('') String disclaimer,
    @Default(<PrashnaCategoryOption>[]) List<PrashnaCategoryOption> categories,
  }) = _PrashnaCatalog;

  factory PrashnaCatalog.fromMap(Map<String, dynamic> p) => PrashnaCatalog(
    currency: p['currency'] as String? ?? 'INR',
    price: p['price']?.toString() ?? '0',
    walletBalance: p['wallet_balance']?.toString() ?? '0',
    disclaimer: p['disclaimer'] as String? ?? '',
    categories: (p['categories'] as List<dynamic>? ?? const [])
        .map((e) =>
            PrashnaCategoryOption.fromMap((e as Map).cast<String, dynamic>()))
        .toList(),
  );

  double get priceValue => double.tryParse(price) ?? 0;
  double get balanceValue => double.tryParse(walletBalance) ?? 0;
  bool get canAfford => balanceValue >= priceValue;
}

/// English fallback for a Prashna verdict / category — the client localises.
class PrashnaInfo {
  const PrashnaInfo._();

  static String verdictLabel(String verdict) => switch (verdict) {
    'yes' => 'Leaning yes',
    'no' => 'Leaning no',
    'mixed' => 'Mixed signals',
    _ => 'Not decisive',
  };

  static Color verdictColor(String verdict) => switch (verdict) {
    'yes' => const Color(0xFF2C6B45),
    'no' => const Color(0xFFB23A28),
    'mixed' => const Color(0xFF3F4E86),
    _ => const Color(0xFF5B5B62),
  };

  static IconData verdictIcon(String verdict) => switch (verdict) {
    'yes' => Icons.check_circle_outline_rounded,
    'no' => Icons.cancel_outlined,
    'mixed' => Icons.compare_arrows_rounded,
    _ => Icons.help_outline_rounded,
  };

  static IconData categoryIcon(String category) => switch (category) {
    'marriage' || 'reunion' => Icons.favorite_outline_rounded,
    'job' || 'promotion' || 'business' => Icons.work_outline_rounded,
    'property' => Icons.home_outlined,
    'loan_money' => Icons.savings_outlined,
    'childbirth' => Icons.child_friendly_outlined,
    'foreign_travel' => Icons.flight_takeoff_rounded,
    'litigation' => Icons.gavel_rounded,
    'health' => Icons.monitor_heart_outlined,
    'lost_item' => Icons.search_rounded,
    _ => Icons.help_outline_rounded,
  };
}
