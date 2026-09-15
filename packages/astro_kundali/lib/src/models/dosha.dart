import 'package:freezed_annotation/freezed_annotation.dart';

part 'dosha.freezed.dart';

/// One structural reason a dosha was flagged. `key` is stable (for localisation);
/// `text` is the engine's English fallback.
@freezed
abstract class DoshaReason with _$DoshaReason {
  const factory DoshaReason({
    @Default('') String key,
    @Default('') String text,
  }) = _DoshaReason;

  factory DoshaReason.fromMap(Map<String, dynamic> j) => DoshaReason(
    key: j['key'] as String? ?? '',
    text: j['text'] as String? ?? '',
  );
}

/// A classical cancellation / mitigation rule. `applies` says whether this chart
/// meets it.
@freezed
abstract class DoshaCancellation with _$DoshaCancellation {
  const factory DoshaCancellation({
    @Default('') String key,
    @Default('') String text,
    @Default(false) bool applies,
  }) = _DoshaCancellation;

  factory DoshaCancellation.fromMap(Map<String, dynamic> j) =>
      DoshaCancellation(
        key: j['key'] as String? ?? '',
        text: j['text'] as String? ?? '',
        applies: j['applies'] as bool? ?? false,
      );
}

/// One named dosha from `/app/birth-profiles/{id}/doshas`.
@freezed
abstract class Dosha with _$Dosha {
  const Dosha._();

  const factory Dosha({
    required String key,
    @Default('') String name,
    @Default(false) bool present,
    @Default(0) int severity,
    @Default(0) int netSeverity,
    @Default('none') String severityLabel,
    @Default('none') String netSeverityLabel,
    @Default(false) bool isCancelled,
    @Default(<String>[]) List<String> planets,
    @Default(<int>[]) List<int> houses,
    @Default(<String>[]) List<String> references,
    @Default(<DoshaReason>[]) List<DoshaReason> reasons,
    @Default(<DoshaCancellation>[]) List<DoshaCancellation> cancellations,
    @Default('') String summary,
    // dosha-specific extras
    @Default('') String kaalSarpaType,
    @Default(false) bool partial,
    @Default('') String nakshatra,
    @Default(0) int pada,
  }) = _Dosha;

  factory Dosha.fromMap(Map<String, dynamic> j) => Dosha(
    key: j['key'] as String? ?? '',
    name: j['name'] as String? ?? '',
    present: j['present'] as bool? ?? false,
    severity: (j['severity'] as num?)?.toInt() ?? 0,
    netSeverity: (j['net_severity'] as num?)?.toInt() ?? 0,
    severityLabel: j['severity_label'] as String? ?? 'none',
    netSeverityLabel: j['net_severity_label'] as String? ?? 'none',
    isCancelled: j['is_cancelled'] as bool? ?? false,
    planets: (j['planets'] as List<dynamic>? ?? const [])
        .map((e) => e.toString())
        .toList(),
    houses: (j['houses'] as List<dynamic>? ?? const [])
        .map((e) => (e as num).toInt())
        .toList(),
    references: (j['references'] as List<dynamic>? ?? const [])
        .map((e) => e.toString())
        .toList(),
    reasons: (j['reasons'] as List<dynamic>? ?? const [])
        .map((e) => DoshaReason.fromMap((e as Map).cast<String, dynamic>()))
        .toList(),
    cancellations: (j['cancellations'] as List<dynamic>? ?? const [])
        .map(
          (e) => DoshaCancellation.fromMap((e as Map).cast<String, dynamic>()),
        )
        .toList(),
    summary: j['summary'] as String? ?? '',
    kaalSarpaType: j['kaal_sarpa_type'] as String? ?? '',
    partial: j['partial'] as bool? ?? false,
    nakshatra: j['nakshatra'] as String? ?? '',
    pada: (j['pada'] as num?)?.toInt() ?? 0,
  );

  List<DoshaCancellation> get activeCancellations =>
      cancellations.where((c) => c.applies).toList();

  /// 0 clear · 1 mild · 2 moderate · 3 strong — after cancellations.
  int get displaySeverity => present ? netSeverity : 0;
}

/// The whole `/doshas` payload.
@freezed
abstract class DoshaReport with _$DoshaReport {
  const DoshaReport._();

  const factory DoshaReport({
    @Default(0) int count,
    @Default(<String>[]) List<String> presentKeys,
    @Default(<Dosha>[]) List<Dosha> doshas,
    @Default('') String disclaimer,
  }) = _DoshaReport;

  factory DoshaReport.fromMap(Map<String, dynamic> p) => DoshaReport(
    count: (p['count'] as num?)?.toInt() ?? 0,
    presentKeys: (p['present_keys'] as List<dynamic>? ?? const [])
        .map((e) => e.toString())
        .toList(),
    doshas: (p['doshas'] as List<dynamic>? ?? const [])
        .map((e) => Dosha.fromMap((e as Map).cast<String, dynamic>()))
        .toList(),
    disclaimer: p['disclaimer'] as String? ?? '',
  );

  factory DoshaReport.fromArtifact(Map<String, dynamic> envelope) {
    final p =
        (envelope['payload'] as Map?)?.cast<String, dynamic>() ?? envelope;
    return DoshaReport.fromMap(p);
  }

  /// Present ones first, most severe first.
  List<Dosha> get present {
    final list = doshas.where((d) => d.present).toList();
    list.sort((a, b) => b.displaySeverity.compareTo(a.displaySeverity));
    return list;
  }

  List<Dosha> get clear => doshas.where((d) => !d.present).toList();
}
