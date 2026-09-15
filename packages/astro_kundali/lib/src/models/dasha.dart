import 'package:freezed_annotation/freezed_annotation.dart';

part 'dasha.freezed.dart';

@freezed
abstract class DashaSpan with _$DashaSpan {
  const factory DashaSpan({
    required String lord,
    required DateTime start,
    required DateTime end,
    @Default(<DashaSpan>[]) List<DashaSpan> children,
  }) = _DashaSpan;

  const DashaSpan._();

  factory DashaSpan.fromMap(Map<String, dynamic> j, {String childKey = 'antardashas'}) {
    return DashaSpan(
      lord: j['name'] as String? ?? j['lord'] as String? ?? '',
      start: DateTime.tryParse('${j['start']}') ?? DateTime(1900),
      end: DateTime.tryParse('${j['end']}') ?? DateTime(2100),
      children: (j[childKey] as List<dynamic>? ?? const [])
          .map(
            (e) => DashaSpan.fromMap(
              e as Map<String, dynamic>,
              childKey: 'pratyantardashas',
            ),
          )
          .toList(),
    );
  }

  bool contains(DateTime t) => !t.isBefore(start) && t.isBefore(end);

  double progress(DateTime now) {
    final total = end.difference(start).inSeconds;
    if (total <= 0) return 0;
    return (now.difference(start).inSeconds / total).clamp(0.0, 1.0);
  }
}

/// `/app/birth-profiles/{id}/dasha` (Vimshottari). `/dashas` returns this plus
/// Yogini and Ashtottari under their own keys.
@freezed
abstract class DashaTimeline with _$DashaTimeline {
  const factory DashaTimeline({
    @Default('vimshottari') String system,
    @Default(<DashaSpan>[]) List<DashaSpan> periods,
    @Default('') String balanceLord,
    @Default(0) double balanceYears,
    @Default('') String currentMaha,
    @Default('') String currentAntar,
    @Default('') String currentPratyantar,
  }) = _DashaTimeline;

  const DashaTimeline._();

  factory DashaTimeline.fromArtifact(Map<String, dynamic> envelope) {
    final p = (envelope['payload'] as Map?)?.cast<String, dynamic>() ?? envelope;
    return DashaTimeline.fromPayload(p);
  }

  factory DashaTimeline.fromPayload(Map<String, dynamic> p, {String system = 'vimshottari'}) {
    final cur = (p['current'] as Map?)?.cast<String, dynamic>() ?? const {};
    final bal = (p['balance'] as Map?)?.cast<String, dynamic>() ?? const {};
    return DashaTimeline(
      system: system,
      periods: (p['dasha_periods'] as List<dynamic>? ?? const [])
          .map((e) => DashaSpan.fromMap(e as Map<String, dynamic>))
          .toList(),
      balanceLord: bal['lord'] as String? ?? '',
      balanceYears: (bal['years'] as num?)?.toDouble() ?? 0,
      currentMaha: cur['maha'] as String? ?? '',
      currentAntar: cur['antar'] as String? ?? '',
      currentPratyantar: cur['pratyantar'] as String? ?? '',
    );
  }

  DashaSpan? get currentSpan {
    final now = DateTime.now();
    for (final m in periods) {
      if (m.contains(now)) return m;
    }
    return null;
  }
}
