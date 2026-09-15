import 'package:freezed_annotation/freezed_annotation.dart';

part 'numerology.freezed.dart';

/// One numerology number (Moolank / Bhagyank / Naamank) from
/// `/app/birth-profiles/{id}/numerology`.
@freezed
abstract class NumerologyNumber with _$NumerologyNumber {
  const factory NumerologyNumber({
    @Default('') String key,
    @Default('') String kind,
    @Default(0) int value,
    @Default('') String planet,
    @Default('') String summary,
    @Default(<int>[]) List<int> friendly,
    @Default(<int>[]) List<int> neutral,
    @Default(<int>[]) List<int> unfriendly,
    @Default(<String>[]) List<String> days,
    @Default(<String>[]) List<String> colours,
    @Default('') String direction,
    @Default('') String deity,
    @Default('') String gemstone,
    @Default('') String gemstoneNote,
  }) = _NumerologyNumber;

  factory NumerologyNumber.fromMap(Map<String, dynamic> j) {
    final gem = (j['gemstone'] as Map?)?.cast<String, dynamic>() ?? const {};
    List<int> ints(String k) => (j[k] as List<dynamic>? ?? const [])
        .map((e) => (e as num).toInt())
        .toList();
    List<String> strs(String k) => (j[k] as List<dynamic>? ?? const [])
        .map((e) => e.toString())
        .toList();
    return NumerologyNumber(
      key: j['key'] as String? ?? '',
      kind: j['kind'] as String? ?? '',
      value: (j['value'] as num?)?.toInt() ?? 0,
      planet: j['planet'] as String? ?? '',
      summary: j['summary'] as String? ?? '',
      friendly: ints('friendly'),
      neutral: ints('neutral'),
      unfriendly: ints('unfriendly'),
      days: strs('days'),
      colours: strs('colours'),
      direction: j['direction'] as String? ?? '',
      deity: j['deity'] as String? ?? '',
      gemstone: gem['stone'] as String? ?? '',
      gemstoneNote: gem['note'] as String? ?? '',
    );
  }
}

/// One "arrow" line through the Lo Shu grid.
@freezed
abstract class LoShuLine with _$LoShuLine {
  const factory LoShuLine({
    @Default('') String key,
    @Default('') String name,
    @Default(<int>[]) List<int> numbers,
    @Default(<int>[]) List<int> present,
    @Default('partial') String status, // strength | partial | weakness
    @Default('') String gloss,
  }) = _LoShuLine;

  factory LoShuLine.fromMap(Map<String, dynamic> j) => LoShuLine(
    key: j['key'] as String? ?? '',
    name: j['name'] as String? ?? '',
    numbers: (j['numbers'] as List<dynamic>? ?? const [])
        .map((e) => (e as num).toInt())
        .toList(),
    present: (j['present'] as List<dynamic>? ?? const [])
        .map((e) => (e as num).toInt())
        .toList(),
    status: j['status'] as String? ?? 'partial',
    gloss: j['gloss'] as String? ?? '',
  );
}

@freezed
abstract class LoShuGrid with _$LoShuGrid {
  const LoShuGrid._();

  const factory LoShuGrid({
    @Default(<int>[4, 9, 2, 3, 5, 7, 8, 1, 6]) List<int> layout,
    @Default(<int, int>{}) Map<int, int> counts,
    @Default(<int>[]) List<int> missing,
    @Default(<int>[]) List<int> repeated,
    @Default(<LoShuLine>[]) List<LoShuLine> lines,
    @Default('') String summary,
  }) = _LoShuGrid;

  factory LoShuGrid.fromMap(Map<String, dynamic> j) {
    final rawCounts = (j['counts'] as Map?)?.cast<String, dynamic>() ?? const {};
    return LoShuGrid(
      layout: (j['layout'] as List<dynamic>? ?? const [4, 9, 2, 3, 5, 7, 8, 1, 6])
          .map((e) => (e as num).toInt())
          .toList(),
      counts: {
        for (final e in rawCounts.entries)
          int.parse(e.key): (e.value as num).toInt(),
      },
      missing: (j['missing'] as List<dynamic>? ?? const [])
          .map((e) => (e as num).toInt())
          .toList(),
      repeated: (j['repeated'] as List<dynamic>? ?? const [])
          .map((e) => (e as num).toInt())
          .toList(),
      lines: (j['lines'] as List<dynamic>? ?? const [])
          .map((e) => LoShuLine.fromMap((e as Map).cast<String, dynamic>()))
          .toList(),
      summary: j['summary'] as String? ?? '',
    );
  }

  int countOf(int n) => counts[n] ?? 0;
}

@freezed
abstract class NumerologyReport with _$NumerologyReport {
  const NumerologyReport._();

  const factory NumerologyReport({
    @Default('') String birthDate,
    @Default('') String nameUsed,
    @Default(0) int moolank,
    @Default(0) int bhagyank,
    int? naamank,
    @Default(<NumerologyNumber>[]) List<NumerologyNumber> numbers,
    @Default('') String combination,
    @Default(LoShuGrid()) LoShuGrid loShu,
    @Default('') String disclaimer,
  }) = _NumerologyReport;

  factory NumerologyReport.fromMap(Map<String, dynamic> p) {
    final combo = (p['combination'] as Map?)?.cast<String, dynamic>() ?? const {};
    return NumerologyReport(
      birthDate: p['birth_date'] as String? ?? '',
      nameUsed: p['name_used'] as String? ?? '',
      moolank: (p['moolank'] as num?)?.toInt() ?? 0,
      bhagyank: (p['bhagyank'] as num?)?.toInt() ?? 0,
      naamank: (p['naamank'] as num?)?.toInt(),
      numbers: (p['numbers'] as List<dynamic>? ?? const [])
          .map((e) => NumerologyNumber.fromMap((e as Map).cast<String, dynamic>()))
          .toList(),
      combination: combo['summary'] as String? ?? '',
      loShu: LoShuGrid.fromMap(
        (p['lo_shu'] as Map?)?.cast<String, dynamic>() ?? const {},
      ),
      disclaimer: p['disclaimer'] as String? ?? '',
    );
  }

  factory NumerologyReport.fromArtifact(Map<String, dynamic> envelope) {
    final p =
        (envelope['payload'] as Map?)?.cast<String, dynamic>() ?? envelope;
    return NumerologyReport.fromMap(p);
  }

  NumerologyNumber? numberFor(String kind) {
    for (final n in numbers) {
      if (n.kind == kind) return n;
    }
    return null;
  }
}
