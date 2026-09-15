import 'package:freezed_annotation/freezed_annotation.dart';

part 'transits.freezed.dart';

@freezed
abstract class TransitPlanet with _$TransitPlanet {
  const factory TransitPlanet({
    required String name,
    required String sign,
    @Default(0) double degree,
    @Default('') String nakshatra,
    @Default(0) int houseFromMoon,
    @Default(0) int houseFromLagna,
    @Default(<String>[]) List<String> overNatal,
  }) = _TransitPlanet;

  factory TransitPlanet.fromMap(Map<String, dynamic> j) => TransitPlanet(
    name: j['name'] as String? ?? '',
    sign: j['sign'] as String? ?? '',
    degree: (j['degree'] as num?)?.toDouble() ?? 0,
    nakshatra: j['nakshatra'] as String? ?? '',
    houseFromMoon: (j['house_from_moon'] as num?)?.toInt() ?? 0,
    houseFromLagna: (j['house_from_lagna'] as num?)?.toInt() ?? 0,
    overNatal: (j['over_natal'] as List<dynamic>? ?? const [])
        .map((e) => e.toString())
        .toList(),
  );
}

/// `/app/birth-profiles/{id}/transits` — gochar + Sade Sati / panoti flags.
@freezed
abstract class Transits with _$Transits {
  const factory Transits({
    @Default('') String natalMoonSign,
    @Default(<TransitPlanet>[]) List<TransitPlanet> positions,
    @Default(false) bool sadeSatiActive,
    @Default('') String sadeSatiPhase, // rising | peak | setting
    @Default(0) int saturnHouseFromMoon,
    @Default(false) bool smallPanotiActive,
    @Default('') String smallPanotiType,
    @Default(0) int jupiterHouseFromMoon,
    @Default(false) bool jupiterFavourable,
    @Default(0) int rahuHouseFromMoon,
  }) = _Transits;

  const Transits._();

  factory Transits.fromArtifact(Map<String, dynamic> envelope) {
    final p = (envelope['payload'] as Map?)?.cast<String, dynamic>() ?? envelope;
    final ss = (p['sade_sati'] as Map?)?.cast<String, dynamic>() ?? const {};
    final sp = (p['small_panoti'] as Map?)?.cast<String, dynamic>() ?? const {};
    final jt = (p['jupiter_transit'] as Map?)?.cast<String, dynamic>() ?? const {};
    final rt = (p['rahu_transit'] as Map?)?.cast<String, dynamic>() ?? const {};
    return Transits(
      natalMoonSign: p['natal_moon_sign'] as String? ?? '',
      positions: (p['positions'] as List<dynamic>? ?? const [])
          .map((e) => TransitPlanet.fromMap(e as Map<String, dynamic>))
          .toList(),
      sadeSatiActive: (ss['active'] ?? false) as bool,
      sadeSatiPhase: ss['phase'] as String? ?? '',
      saturnHouseFromMoon: (ss['saturn_house_from_moon'] as num?)?.toInt() ?? 0,
      smallPanotiActive: (sp['active'] ?? false) as bool,
      smallPanotiType: sp['type'] as String? ?? '',
      jupiterHouseFromMoon: (jt['house_from_moon'] as num?)?.toInt() ?? 0,
      jupiterFavourable: (jt['favourable'] ?? false) as bool,
      rahuHouseFromMoon: (rt['house_from_moon'] as num?)?.toInt() ?? 0,
    );
  }

  TransitPlanet? planet(String name) {
    for (final p in positions) {
      if (p.name == name) return p;
    }
    return null;
  }
}
