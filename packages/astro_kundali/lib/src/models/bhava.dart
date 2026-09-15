import 'package:freezed_annotation/freezed_annotation.dart';

part 'bhava.freezed.dart';

/// One house from `/app/birth-profiles/{id}/bhava`.
///
/// The backend sends `benefic_influences` / `malefic_influences` as **counts**
/// (integers), the planets sitting in the house as `occupants`, and the planets
/// aspecting it as `aspected_by`. Parsing here tolerates either an int or a
/// list for the two tallies so a backend shape change can't crash the screen.
@freezed
abstract class BhavaHouse with _$BhavaHouse {
  const factory BhavaHouse({
    required int house,
    @Default('') String sign,
    @Default('') String karaka,
    @Default('') String lord,
    @Default('') String lordSign,
    @Default(0) int lordHouse,
    @Default('') String lordDignity,
    @Default(false) bool lordRetrograde,
    @Default(<String>[]) List<String> occupants,
    @Default(<String>[]) List<String> aspectedBy,
    @Default(0) int beneficCount,
    @Default(0) int maleficCount,
    @Default(0) double netInfluence,
  }) = _BhavaHouse;

  const BhavaHouse._();

  /// Planets whose influence touches this house (occupants + aspecting).
  List<String> get influences => [...occupants, ...aspectedBy];

  /// benefic − malefic tally (positive = supported, negative = afflicted).
  int get influenceTally => beneficCount - maleficCount;

  factory BhavaHouse.fromMap(Map<String, dynamic> j) => BhavaHouse(
    house: (j['house'] as num).toInt(),
    sign: j['sign'] as String? ?? '',
    karaka: j['karaka'] as String? ?? '',
    lord: j['lord'] as String? ?? '',
    lordSign: j['lord_sign'] as String? ?? '',
    lordHouse: (j['lord_house'] as num?)?.toInt() ?? 0,
    lordDignity: j['lord_dignity'] as String? ?? '',
    lordRetrograde: (j['lord_retrograde'] ?? false) as bool,
    occupants: _strList(j['occupants']),
    aspectedBy: _strList(j['aspected_by']),
    beneficCount: _count(j['benefic_influences']),
    maleficCount: _count(j['malefic_influences']),
    netInfluence: (j['net_influence'] as num?)?.toDouble() ?? 0,
  );

  static List<String> _strList(Object? v) =>
      v is List ? v.map((e) => e.toString()).toList(growable: false) : const [];

  static int _count(Object? v) {
    if (v is num) return v.toInt();
    if (v is List) return v.length;
    return 0;
  }

  static List<BhavaHouse> listFromArtifact(Map<String, dynamic> envelope) {
    final p =
        (envelope['payload'] as Map?)?.cast<String, dynamic>() ?? envelope;
    return (p['houses'] as List<dynamic>? ?? const [])
        .map((e) => BhavaHouse.fromMap((e as Map).cast<String, dynamic>()))
        .toList();
  }
}
