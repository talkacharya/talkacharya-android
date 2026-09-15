import 'package:freezed_annotation/freezed_annotation.dart';

part 'av_transit.freezed.dart';

/// One live transit scored against the natal ashtakavarga, from
/// `/app/birth-profiles/{id}/av-transit`.
@freezed
abstract class AvTransitRow with _$AvTransitRow {
  const AvTransitRow._();

  const factory AvTransitRow({
    @Default('') String key,
    @Default('') String planet,
    @Default('') String sign,
    @Default(0) int houseFromLagna,
    @Default(0) int houseFromMoon,
    @Default(0) int bindus,
    @Default(0) int sarvaBindus,
    @Default(false) bool retrograde,
    @Default('mixed') String tone, // supportive | mixed | challenging
    @Default('') String date, // upcoming ingress only
    @Default('') String summary,
  }) = _AvTransitRow;

  factory AvTransitRow.fromMap(Map<String, dynamic> j) => AvTransitRow(
    key: j['key'] as String? ?? '',
    planet: j['planet'] as String? ?? '',
    sign: j['sign'] as String? ?? '',
    houseFromLagna: (j['house_from_lagna'] as num?)?.toInt() ?? 0,
    houseFromMoon: (j['house_from_moon'] as num?)?.toInt() ?? 0,
    bindus: (j['bindus'] as num?)?.toInt() ?? 0,
    sarvaBindus: (j['sarva_bindus'] as num?)?.toInt() ?? 0,
    retrograde: j['retrograde'] as bool? ?? false,
    tone: j['tone'] as String? ?? 'mixed',
    date: j['date'] as String? ?? '',
    summary: j['summary'] as String? ?? '',
  );
}

@freezed
abstract class AvTransitReading with _$AvTransitReading {
  const AvTransitReading._();

  const factory AvTransitReading({
    @Default('') String lagnaSign,
    @Default('') String natalMoonSign,
    @Default(<AvTransitRow>[]) List<AvTransitRow> transits,
    @Default(<AvTransitRow>[]) List<AvTransitRow> upcomingIngresses,
    @Default('') String summary,
    @Default('') String disclaimer,
  }) = _AvTransitReading;

  factory AvTransitReading.fromMap(Map<String, dynamic> p) => AvTransitReading(
    lagnaSign: p['lagna_sign'] as String? ?? '',
    natalMoonSign: p['natal_moon_sign'] as String? ?? '',
    transits: (p['transits'] as List<dynamic>? ?? const [])
        .map((e) => AvTransitRow.fromMap((e as Map).cast<String, dynamic>()))
        .toList(),
    upcomingIngresses: (p['upcoming_ingresses'] as List<dynamic>? ?? const [])
        .map((e) => AvTransitRow.fromMap((e as Map).cast<String, dynamic>()))
        .toList(),
    summary: p['summary'] as String? ?? '',
    disclaimer: p['disclaimer'] as String? ?? '',
  );

  factory AvTransitReading.fromArtifact(Map<String, dynamic> envelope) {
    final p =
        (envelope['payload'] as Map?)?.cast<String, dynamic>() ?? envelope;
    return AvTransitReading.fromMap(p);
  }
}
