import 'package:freezed_annotation/freezed_annotation.dart';

import 'kundali.dart';

part 'varga_chart.freezed.dart';

/// One placed graha in a divisional / bhava-chalit / transit chart. A superset
/// of the three payload shapes — fields that don't apply stay at their default.
@freezed
abstract class ChartPlacement with _$ChartPlacement {
  const factory ChartPlacement({
    required String name,
    required String sign,
    @Default(0) double degree,
    @Default('') String dms,
    @Default(1) int house,
    @Default(false) bool retrograde,
    @Default(false) bool vargottama,
    // bhava chalit
    @Default(false) bool shifted,
    @Default(0) int rasiHouse,
    // transit
    @Default(0) int houseFromMoon,
    @Default(<String>[]) List<String> conjunctNatal,
  }) = _ChartPlacement;

  factory ChartPlacement.fromMap(Map<String, dynamic> j) => ChartPlacement(
    name: j['name'] as String? ?? '',
    sign: j['sign'] as String? ?? '',
    degree: (j['degree'] as num?)?.toDouble() ?? 0,
    dms: j['dms'] as String? ?? '',
    house:
        (j['house'] as num?)?.toInt() ??
        (j['bhava'] as num?)?.toInt() ??
        (j['house_from_lagna'] as num?)?.toInt() ??
        1,
    retrograde: (j['retrograde'] ?? false) as bool,
    vargottama: (j['vargottama'] ?? false) as bool,
    shifted: (j['shifted'] ?? false) as bool,
    rasiHouse: (j['rasi_house'] as num?)?.toInt() ?? 0,
    houseFromMoon: (j['house_from_moon'] as num?)?.toInt() ?? 0,
    conjunctNatal: (j['conjunct_natal'] as List<dynamic>? ?? const [])
        .map((e) => e.toString())
        .toList(),
  );
}

/// A divisional chart (D1..D60), `bhava_chalit`, or `transit`. All three carry
/// a `houses` list (`{house, sign, planets}`) the [NatalChart] widget can draw.
@freezed
abstract class VargaChart with _$VargaChart {
  const factory VargaChart({
    required String chartType,
    @Default('') String name,
    @Default('') String signifies,
    @Default(true) bool verified,
    @Default('') String ascendantSign,
    @Default(0) double ascendantDegree,
    @Default(false) bool ascendantVargottama,
    @Default(<ChartHouse>[]) List<ChartHouse> houses,
    @Default(<ChartPlacement>[]) List<ChartPlacement> planets,
    String? asOf,
  }) = _VargaChart;

  const VargaChart._();

  bool get isTransit => chartType == 'transit';
  bool get isBhavaChalit => chartType == 'bhava_chalit';

  /// Planets that landed in a different house than their whole-sign one
  /// (bhava chalit only).
  List<ChartPlacement> get shiftedPlanets =>
      planets.where((p) => p.shifted).toList();

  /// The transit chart draws the moving grahas; other charts use `planets`.
  static ChartHouse _house(Map<String, dynamic> j) => ChartHouse(
    house: (j['house'] as num).toInt(),
    sign: j['sign'] as String? ?? '',
    planets: ((j['planets'] ?? j['transit_planets']) as List<dynamic>? ?? const [])
        .map((e) => e.toString())
        .toList(),
  );

  factory VargaChart.fromArtifact(Map<String, dynamic> envelope) {
    final p = (envelope['payload'] as Map?)?.cast<String, dynamic>() ?? envelope;
    final ascRaw = p['ascendant'];
    final asc = ascRaw is Map ? ascRaw.cast<String, dynamic>() : null;
    return VargaChart(
      chartType: p['chart_type'] as String? ?? 'd1',
      name: p['name'] as String? ?? '',
      signifies: p['signifies'] as String? ?? '',
      verified: (p['verified'] ?? true) as bool,
      ascendantSign:
          asc?['sign'] as String? ?? (ascRaw is String ? ascRaw : ''),
      ascendantDegree: (asc?['degree'] as num?)?.toDouble() ?? 0,
      ascendantVargottama: (asc?['vargottama'] ?? false) as bool,
      asOf: p['as_of'] as String?,
      houses: (p['houses'] as List<dynamic>? ?? const [])
          .map((e) => _house((e as Map).cast<String, dynamic>()))
          .toList(),
      planets: (p['planets'] as List<dynamic>? ?? const [])
          .map((e) => ChartPlacement.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

/// A row in the chart picker — `GET /app/astrology/chart-types`.
@freezed
abstract class ChartTypeInfo with _$ChartTypeInfo {
  const factory ChartTypeInfo({
    required String type,
    required String name,
    @Default('') String signifies,
    @Default(true) bool verified,
    int? varga,
  }) = _ChartTypeInfo;

  factory ChartTypeInfo.fromMap(Map<String, dynamic> j) => ChartTypeInfo(
    type: j['type'] as String,
    name: j['name'] as String? ?? '',
    signifies: j['signifies'] as String? ?? '',
    verified: (j['verified'] ?? true) as bool,
    varga: (j['varga'] as num?)?.toInt(),
  );
}
