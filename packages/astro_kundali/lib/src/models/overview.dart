import 'package:freezed_annotation/freezed_annotation.dart';

part 'overview.freezed.dart';

/// One governing factor behind an overview section. [key] is stable and
/// namespaced (`overview.factor.*`) so the client can localise the copy; the
/// rest are typed params the engine filled in. Structural only — no prediction.
@freezed
abstract class OverviewFactor with _$OverviewFactor {
  const factory OverviewFactor({
    @Default('') String key,
    @Default('') String planet,
    @Default('') String sign,
    @Default('') String nakshatra,
    @Default('') String dignity,
    @Default('') String role,
    @Default('') String scope,
    @Default('') String name,

    /// For the `overview.factor.yoga` / `overview.factor.dosha` factors — the
    /// stable `yoga.*` / dosha key so the client can localise the name.
    @Default('') String refKey,
    @Default(0) int house,
    @Default(0) int inHouse,
    @Default(0) int pada,

    /// 0–3 where the engine graded it, else -1 (not a strength factor).
    @Default(-1) int strength,
    @Default(0) int netSeverity,
    @Default(false) bool occupant,
  }) = _OverviewFactor;

  factory OverviewFactor.fromMap(Map<String, dynamic> j) => OverviewFactor(
    key: j['key'] as String? ?? '',
    planet: j['planet'] as String? ?? '',
    sign: j['sign'] as String? ?? '',
    nakshatra: j['nakshatra'] as String? ?? '',
    dignity: j['dignity'] as String? ?? '',
    role: j['role'] as String? ?? '',
    scope: j['scope'] as String? ?? '',
    name: j['name'] as String? ?? '',
    refKey: (j['yoga_key'] ?? j['dosha_key']) as String? ?? '',
    house: (j['house'] as num?)?.toInt() ?? 0,
    inHouse: (j['in_house'] as num?)?.toInt() ?? 0,
    pada: (j['pada'] as num?)?.toInt() ?? 0,
    strength: (j['strength'] as num?)?.toInt() ?? -1,
    netSeverity: (j['net_severity'] as num?)?.toInt() ?? 0,
    occupant: j['occupant'] as bool? ?? false,
  );
}

/// One life-area section from `/app/birth-profiles/{id}/overview`.
@freezed
abstract class OverviewSection with _$OverviewSection {
  const OverviewSection._();

  const factory OverviewSection({
    @Default('') String area,
    @Default('') String key,
    @Default('') String title,

    /// 0 challenging · 1 challenging · 2 balanced · 3 supportive.
    @Default(0) int strength,

    /// `supportive` | `balanced` | `challenging` | `mixed`.
    @Default('balanced') String tone,

    /// The engine's English fallback prose (already scrubbed of anything that
    /// reads as a dated event prediction).
    @Default('') String summary,
    @Default(<OverviewFactor>[]) List<OverviewFactor> factors,
  }) = _OverviewSection;

  factory OverviewSection.fromMap(Map<String, dynamic> j) => OverviewSection(
    area: j['area'] as String? ?? '',
    key: j['key'] as String? ?? '',
    title: j['title'] as String? ?? '',
    strength: (j['strength'] as num?)?.toInt() ?? 0,
    tone: j['tone'] as String? ?? 'balanced',
    summary: j['summary'] as String? ?? '',
    factors: (j['factors'] as List<dynamic>? ?? const [])
        .map((e) => OverviewFactor.fromMap((e as Map).cast<String, dynamic>()))
        .toList(),
  );

  bool get isMixed => tone == 'mixed';

  /// Factors that render as a "what this reads from" line (drops the marker
  /// `disclaimer` factor and anything with no displayable params).
  List<OverviewFactor> get readingFactors =>
      factors.where((f) => f.key != 'overview.factor.disclaimer').toList();
}

/// The whole `/overview` payload — a free, descriptive D1 character & life
/// sketch. Never a forecast.
@freezed
abstract class OverviewReport with _$OverviewReport {
  const OverviewReport._();

  const factory OverviewReport({
    @Default(<OverviewSection>[]) List<OverviewSection> sections,
    @Default('') String disclaimer,
  }) = _OverviewReport;

  factory OverviewReport.fromMap(Map<String, dynamic> p) => OverviewReport(
    sections: (p['sections'] as List<dynamic>? ?? const [])
        .map((e) => OverviewSection.fromMap((e as Map).cast<String, dynamic>()))
        .toList(),
    disclaimer: p['disclaimer'] as String? ?? '',
  );

  factory OverviewReport.fromArtifact(Map<String, dynamic> envelope) {
    final p =
        (envelope['payload'] as Map?)?.cast<String, dynamic>() ?? envelope;
    return OverviewReport.fromMap(p);
  }

  OverviewSection? byArea(String area) {
    for (final s in sections) {
      if (s.area == area) return s;
    }
    return null;
  }
}
