import 'package:freezed_annotation/freezed_annotation.dart';

part 'jyotish_upaya.freezed.dart';

/// The per-planet remedy line from `/app/birth-profiles/{id}/jyotish-upaya`.
/// Colour / day / deity / mantra / charity are free to adopt; `gemstone` and
/// `rudraksha` are ALWAYS gated behind an astrologer.
@freezed
abstract class UpayaPlanet with _$UpayaPlanet {
  const UpayaPlanet._();

  const factory UpayaPlanet({
    @Default('') String key,
    @Default('') String planet,
    @Default('neutral') String role, // strengthen | pacify | mixed | neutral
    @Default('') String dignity,
    @Default(0) int house,
    @Default(<String>[]) List<String> colours,
    @Default('') String direction,
    @Default('') String deity,
    @Default('') String mantra,
    @Default('') String charity,
    @Default('') String gemstone,
    @Default('') String gemstoneSubstitute,
    @Default('') String gemstoneMetal,
    @Default('') String gemstoneFinger,
    @Default('') String gemstoneStartDay,
    @Default('') String rudrakshaMukhi,
    @Default(false) bool priority,
    @Default('') String summary,
  }) = _UpayaPlanet;

  factory UpayaPlanet.fromMap(Map<String, dynamic> j) {
    final gem = (j['gemstone'] as Map?)?.cast<String, dynamic>() ?? const {};
    final rud = (j['rudraksha'] as Map?)?.cast<String, dynamic>() ?? const {};
    return UpayaPlanet(
      key: j['key'] as String? ?? '',
      planet: j['planet'] as String? ?? '',
      role: j['role'] as String? ?? 'neutral',
      dignity: j['dignity'] as String? ?? '',
      house: (j['house'] as num?)?.toInt() ?? 0,
      colours: (j['colours'] as List<dynamic>? ?? const [])
          .map((e) => e.toString())
          .toList(),
      direction: j['direction'] as String? ?? '',
      deity: j['deity'] as String? ?? '',
      mantra: j['mantra'] as String? ?? '',
      charity: j['charity'] as String? ?? '',
      gemstone: gem['stone'] as String? ?? '',
      gemstoneSubstitute: gem['substitute'] as String? ?? '',
      gemstoneMetal: gem['metal'] as String? ?? '',
      gemstoneFinger: gem['finger'] as String? ?? '',
      gemstoneStartDay: gem['start_day'] as String? ?? '',
      rudrakshaMukhi: rud['mukhi'] as String? ?? '',
      priority: j['priority'] as bool? ?? false,
      summary: j['summary'] as String? ?? '',
    );
  }

  bool get isStrengthen => role == 'strengthen';
  bool get isPacify => role == 'pacify';
}

@freezed
abstract class JyotishUpayaReport with _$JyotishUpayaReport {
  const JyotishUpayaReport._();

  const factory JyotishUpayaReport({
    @Default('') String lagnaSign,
    @Default('') String lagnaLord,
    @Default(<String>[]) List<String> lagnaColours,
    @Default('') String lagnaDirection,
    @Default('') String lagnaDay,
    @Default('') String lagnaDeity,
    @Default(<String>[]) List<String> strengthen,
    @Default(<String>[]) List<String> pacify,
    @Default(<String>[]) List<String> priorityPlanets,
    @Default(<UpayaPlanet>[]) List<UpayaPlanet> planets,
    @Default('') String summary,
    @Default('') String gateNotice,
    @Default('') String disclaimer,
  }) = _JyotishUpayaReport;

  factory JyotishUpayaReport.fromMap(Map<String, dynamic> p) {
    final lf = (p['lagna_favourable'] as Map?)?.cast<String, dynamic>() ?? const {};
    List<String> strs(Object? v) =>
        (v as List<dynamic>? ?? const []).map((e) => e.toString()).toList();
    return JyotishUpayaReport(
      lagnaSign: p['lagna_sign'] as String? ?? '',
      lagnaLord: lf['lagna_lord'] as String? ?? '',
      lagnaColours: strs(lf['colours']),
      lagnaDirection: lf['direction'] as String? ?? '',
      lagnaDay: lf['auspicious_day'] as String? ?? '',
      lagnaDeity: lf['deity'] as String? ?? '',
      strengthen: strs(p['strengthen']),
      pacify: strs(p['pacify']),
      priorityPlanets: strs(p['priority_planets']),
      planets: (p['planets'] as List<dynamic>? ?? const [])
          .map((e) => UpayaPlanet.fromMap((e as Map).cast<String, dynamic>()))
          .toList(),
      summary: p['summary'] as String? ?? '',
      gateNotice: p['gate_notice'] as String? ?? '',
      disclaimer: p['disclaimer'] as String? ?? '',
    );
  }

  factory JyotishUpayaReport.fromArtifact(Map<String, dynamic> envelope) {
    final p =
        (envelope['payload'] as Map?)?.cast<String, dynamic>() ?? envelope;
    return JyotishUpayaReport.fromMap(p);
  }
}
