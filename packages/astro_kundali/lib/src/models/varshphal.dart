import 'package:freezed_annotation/freezed_annotation.dart';

part 'varshphal.freezed.dart';

/// One planet in the Varshphal (solar-return) chart.
@freezed
abstract class VarshphalPlanet with _$VarshphalPlanet {
  const factory VarshphalPlanet({
    @Default('') String name,
    @Default('') String sign,
    @Default(0) int house,
    @Default('') String dignity,
    @Default(false) bool retrograde,
  }) = _VarshphalPlanet;

  factory VarshphalPlanet.fromMap(Map<String, dynamic> j) => VarshphalPlanet(
    name: j['name'] as String? ?? '',
    sign: j['sign'] as String? ?? '',
    house: (j['house'] as num?)?.toInt() ?? 0,
    dignity: j['dignity'] as String? ?? '',
    retrograde: j['retrograde'] as bool? ?? false,
  );
}

/// Varshphal (Tajika annual chart) for a solar-return year, from
/// `/app/birth-profiles/{id}/varshphal`.
@freezed
abstract class Varshphal with _$Varshphal {
  const Varshphal._();

  const factory Varshphal({
    @Default(0) int year,
    @Default(0) int age,
    @Default('') String starts,
    @Default('') String ends,
    @Default('') String varshaLagna,
    // muntha
    @Default('') String munthaSign,
    @Default(0) int munthaHouse,
    @Default('') String munthaLord,
    @Default('') String munthaTheme,
    // year lord
    @Default('') String yearLord,
    @Default(<String>[]) List<String> yearLordRoles,
    @Default(0) int yearLordHouse,
    @Default('') String yearLordDignity,
    // tajika
    @Default('none') String tajikaYoga, // ithasala | ishrafa | none
    @Default('') String tajikaSummary,
    @Default(<VarshphalPlanet>[]) List<VarshphalPlanet> planets,
    @Default('') String summary,
    @Default('') String disclaimer,
  }) = _Varshphal;

  factory Varshphal.fromMap(Map<String, dynamic> p) {
    final m = (p['muntha'] as Map?)?.cast<String, dynamic>() ?? const {};
    final yl = (p['year_lord'] as Map?)?.cast<String, dynamic>() ?? const {};
    final tj = (p['tajika'] as Map?)?.cast<String, dynamic>() ?? const {};
    return Varshphal(
      year: (p['year'] as num?)?.toInt() ?? 0,
      age: (p['age'] as num?)?.toInt() ?? 0,
      starts: p['starts'] as String? ?? '',
      ends: p['ends'] as String? ?? '',
      varshaLagna: p['varsha_lagna'] as String? ?? '',
      munthaSign: m['sign'] as String? ?? '',
      munthaHouse: (m['house'] as num?)?.toInt() ?? 0,
      munthaLord: m['lord'] as String? ?? '',
      munthaTheme: m['theme'] as String? ?? '',
      yearLord: yl['planet'] as String? ?? '',
      yearLordRoles: (yl['roles'] as List<dynamic>? ?? const [])
          .map((e) => e.toString())
          .toList(),
      yearLordHouse: (yl['house'] as num?)?.toInt() ?? 0,
      yearLordDignity: yl['dignity'] as String? ?? '',
      tajikaYoga: tj['yoga'] as String? ?? 'none',
      tajikaSummary: tj['summary'] as String? ?? '',
      planets: (p['planets'] as List<dynamic>? ?? const [])
          .map((e) => VarshphalPlanet.fromMap((e as Map).cast<String, dynamic>()))
          .toList(),
      summary: p['summary'] as String? ?? '',
      disclaimer: p['disclaimer'] as String? ?? '',
    );
  }

  factory Varshphal.fromArtifact(Map<String, dynamic> envelope) {
    final p =
        (envelope['payload'] as Map?)?.cast<String, dynamic>() ?? envelope;
    return Varshphal.fromMap(p);
  }
}
