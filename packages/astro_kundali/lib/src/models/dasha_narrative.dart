import 'package:freezed_annotation/freezed_annotation.dart';

part 'dasha_narrative.freezed.dart';

/// Plain-language "what to expect" for one dasha period (maha or antar), from
/// `/app/birth-profiles/{id}/dasha-narrative`. Descriptive tendencies, not events.
@freezed
abstract class DashaPeriodNote with _$DashaPeriodNote {
  const factory DashaPeriodNote({
    @Default('') String key,
    @Default('maha') String level,
    @Default('') String lord,
    @Default('') String mahaLord,
    @Default('') String start,
    @Default('') String end,
    @Default('mixed') String tone,
    @Default(0) int strength,
    @Default(false) bool running,
    @Default('') String summary,
    @Default(<int>[]) List<int> rulesHouses,
    @Default(0) int lordHouse,
    @Default(<DashaPeriodNote>[]) List<DashaPeriodNote> antardashas,
  }) = _DashaPeriodNote;

  factory DashaPeriodNote.fromMap(Map<String, dynamic> j) => DashaPeriodNote(
    key: j['key'] as String? ?? '',
    level: j['level'] as String? ?? 'maha',
    lord: j['lord'] as String? ?? '',
    mahaLord: j['maha_lord'] as String? ?? '',
    start: j['start'] as String? ?? '',
    end: j['end'] as String? ?? '',
    tone: j['tone'] as String? ?? 'mixed',
    strength: (j['strength'] as num?)?.toInt() ?? 0,
    running: j['running'] as bool? ?? false,
    summary: j['summary'] as String? ?? '',
    rulesHouses: (j['rules_houses'] as List<dynamic>? ?? const [])
        .map((e) => (e as num).toInt())
        .toList(),
    lordHouse: (j['lord_house'] as num?)?.toInt() ?? 0,
    antardashas: (j['antardashas'] as List<dynamic>? ?? const [])
        .map((e) => DashaPeriodNote.fromMap((e as Map).cast<String, dynamic>()))
        .toList(),
  );
}

@freezed
abstract class DashaNarrative with _$DashaNarrative {
  const DashaNarrative._();

  const factory DashaNarrative({
    @Default(<DashaPeriodNote>[]) List<DashaPeriodNote> timeline,
    @Default('') String currentMaha,
    @Default('') String currentAntar,
    @Default('') String disclaimer,
  }) = _DashaNarrative;

  factory DashaNarrative.fromMap(Map<String, dynamic> p) {
    final current = (p['current'] as Map?)?.cast<String, dynamic>() ?? const {};
    return DashaNarrative(
      timeline: (p['timeline'] as List<dynamic>? ?? const [])
          .map((e) => DashaPeriodNote.fromMap((e as Map).cast<String, dynamic>()))
          .toList(),
      currentMaha: current['maha'] as String? ?? '',
      currentAntar: current['antar'] as String? ?? '',
      disclaimer: p['disclaimer'] as String? ?? '',
    );
  }

  factory DashaNarrative.fromArtifact(Map<String, dynamic> envelope) {
    final p =
        (envelope['payload'] as Map?)?.cast<String, dynamic>() ?? envelope;
    return DashaNarrative.fromMap(p);
  }

  /// The maha note for a lord (or null).
  DashaPeriodNote? mahaFor(String lord) {
    for (final m in timeline) {
      if (m.lord == lord) return m;
    }
    return null;
  }

  DashaPeriodNote? antarFor(String mahaLord, String antarLord) {
    for (final a in mahaFor(mahaLord)?.antardashas ?? const <DashaPeriodNote>[]) {
      if (a.lord == antarLord) return a;
    }
    return null;
  }
}
