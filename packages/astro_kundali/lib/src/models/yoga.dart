import 'package:freezed_annotation/freezed_annotation.dart';

part 'yoga.freezed.dart';

/// One finding from `/app/birth-profiles/{id}/yogas` →
/// `{key, name, type, planets, description}`. `key` is the stable localisation
/// key (`yoga.*`); `name` / `description` are the engine's English fallback.
@freezed
abstract class Yoga with _$Yoga {
  const factory Yoga({
    required String name,
    @Default('') String key,
    @Default('') String type,
    @Default(<String>[]) List<String> planets,
    @Default('') String description,
  }) = _Yoga;

  factory Yoga.fromMap(Map<String, dynamic> j) => Yoga(
    name: j['name'] as String? ?? '',
    key: j['key'] as String? ?? '',
    type: j['type'] as String? ?? '',
    planets: (j['planets'] as List<dynamic>? ?? const [])
        .map((e) => e.toString())
        .toList(),
    description: j['description'] as String? ?? '',
  );

  static List<Yoga> listFromArtifact(Map<String, dynamic> envelope) {
    final p = (envelope['payload'] as Map?)?.cast<String, dynamic>() ?? envelope;
    return (p['yogas'] as List<dynamic>? ?? const [])
        .map((e) => Yoga.fromMap(e as Map<String, dynamic>))
        .toList();
  }
}
