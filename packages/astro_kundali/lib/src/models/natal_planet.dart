import 'package:freezed_annotation/freezed_annotation.dart';

part 'natal_planet.freezed.dart';

/// One row of the `planet_position` list from `/app/birth-profiles/{id}/kundli`.
@freezed
abstract class NatalPlanet with _$NatalPlanet {
  const factory NatalPlanet({
    required String name,
    required String sign,
    required int signId,
    required double degree,
    required int house,
    required bool retrograde,
    @Default('') String nakshatra,
    @Default(0) int nakshatraPada,
    @Default('neutral') String dignity,
    @Default(false) bool combust,
  }) = _NatalPlanet;

  const NatalPlanet._();

  /// The engine nests fields differently between `planet_position` (kundli) and
  /// `_graha_rows` (advanced); this reads the `planet_position` shape.
  factory NatalPlanet.fromMap(Map<String, dynamic> j) {
    final rasi = (j['rasi'] as Map?)?.cast<String, dynamic>() ?? const {};
    final nak = (j['nakshatra'] as Map?)?.cast<String, dynamic>() ?? const {};
    return NatalPlanet(
      name: j['name'] as String? ?? '',
      sign: rasi['name'] as String? ?? j['sign'] as String? ?? '',
      signId: (rasi['id'] as num?)?.toInt() ?? 0,
      degree: (j['degree'] as num?)?.toDouble() ?? 0,
      house: (j['house'] as num?)?.toInt() ?? 0,
      retrograde: (j['is_retrograde'] ?? j['retrograde'] ?? false) as bool,
      nakshatra: nak['name'] as String? ?? '',
      nakshatraPada: (nak['pada'] as num?)?.toInt() ?? 0,
      dignity: j['dignity'] as String? ?? 'neutral',
      combust: (j['combust'] ?? false) as bool,
    );
  }

  /// Two-letter token used on the chart and in legends.
  String get token => switch (name) {
    'Sun' => 'Su',
    'Moon' => 'Mo',
    'Mars' => 'Ma',
    'Mercury' => 'Me',
    'Jupiter' => 'Ju',
    'Venus' => 'Ve',
    'Saturn' => 'Sa',
    'Rahu' => 'Ra',
    'Ketu' => 'Ke',
    _ => name.length >= 2 ? name.substring(0, 2) : name,
  };
}
