import 'package:freezed_annotation/freezed_annotation.dart';

part 'lal_kitab.freezed.dart';

/// One Lal Kitab rin (inherited debt) from `/app/birth-profiles/{id}/lal-kitab`.
@freezed
abstract class LalKitabRin with _$LalKitabRin {
  const factory LalKitabRin({
    @Default('') String key,
    @Default('') String name,
    @Default('') String planet,
    @Default(false) bool present,
    @Default(<String>[]) List<String> reasons,
    @Default('') String remedy,
  }) = _LalKitabRin;

  factory LalKitabRin.fromMap(Map<String, dynamic> j) => LalKitabRin(
    key: j['key'] as String? ?? '',
    name: j['name'] as String? ?? '',
    planet: j['planet'] as String? ?? '',
    present: j['present'] as bool? ?? false,
    reasons: (j['reasons'] as List<dynamic>? ?? const [])
        .map((e) => e.toString())
        .toList(),
    remedy: j['remedy'] as String? ?? '',
  );
}

@freezed
abstract class LalKitabManda with _$LalKitabManda {
  const factory LalKitabManda({
    @Default('') String key,
    @Default('') String planet,
    @Default(0) int house,
    @Default(0) int pakkaGhar,
    @Default('') String summary,
    @Default('') String remedy,
  }) = _LalKitabManda;

  factory LalKitabManda.fromMap(Map<String, dynamic> j) => LalKitabManda(
    key: j['key'] as String? ?? '',
    planet: j['planet'] as String? ?? '',
    house: (j['house'] as num?)?.toInt() ?? 0,
    pakkaGhar: (j['pakka_ghar'] as num?)?.toInt() ?? 0,
    summary: j['summary'] as String? ?? '',
    remedy: j['remedy'] as String? ?? '',
  );
}

@freezed
abstract class LalKitabRemedy with _$LalKitabRemedy {
  const factory LalKitabRemedy({
    @Default('') String key,
    @Default('') String forWhat,
    @Default('') String text,
  }) = _LalKitabRemedy;

  factory LalKitabRemedy.fromMap(Map<String, dynamic> j) => LalKitabRemedy(
    key: j['key'] as String? ?? '',
    forWhat: j['for'] as String? ?? '',
    text: j['text'] as String? ?? '',
  );
}

@freezed
abstract class LalKitabReport with _$LalKitabReport {
  const LalKitabReport._();

  const factory LalKitabReport({
    @Default(<LalKitabRin>[]) List<LalKitabRin> rins,
    @Default(<LalKitabRin>[]) List<LalKitabRin> activeRins,
    @Default(<LalKitabManda>[]) List<LalKitabManda> mandaPlanets,
    @Default(<LalKitabRemedy>[]) List<LalKitabRemedy> remedies,
    @Default('') String summary,
    @Default('') String disclaimer,
  }) = _LalKitabReport;

  factory LalKitabReport.fromMap(Map<String, dynamic> p) => LalKitabReport(
    rins: (p['rins'] as List<dynamic>? ?? const [])
        .map((e) => LalKitabRin.fromMap((e as Map).cast<String, dynamic>()))
        .toList(),
    activeRins: (p['active_rins'] as List<dynamic>? ?? const [])
        .map((e) => LalKitabRin.fromMap((e as Map).cast<String, dynamic>()))
        .toList(),
    mandaPlanets: (p['manda_planets'] as List<dynamic>? ?? const [])
        .map((e) => LalKitabManda.fromMap((e as Map).cast<String, dynamic>()))
        .toList(),
    remedies: (p['remedies'] as List<dynamic>? ?? const [])
        .map((e) => LalKitabRemedy.fromMap((e as Map).cast<String, dynamic>()))
        .toList(),
    summary: p['summary'] as String? ?? '',
    disclaimer: p['disclaimer'] as String? ?? '',
  );

  factory LalKitabReport.fromArtifact(Map<String, dynamic> envelope) {
    final p =
        (envelope['payload'] as Map?)?.cast<String, dynamic>() ?? envelope;
    return LalKitabReport.fromMap(p);
  }
}
