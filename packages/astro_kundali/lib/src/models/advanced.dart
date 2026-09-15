import 'package:freezed_annotation/freezed_annotation.dart';

part 'advanced.freezed.dart';

/// `/app/birth-profiles/{id}/ashtakavarga`.
@freezed
abstract class Ashtakavarga with _$Ashtakavarga {
  const factory Ashtakavarga({
    @Default(<String, int>{}) Map<String, int> sarvaByHouse,
    @Default(<String, int>{}) Map<String, int> sarvaBySign,
    @Default(0) int sarvaTotal,
    @Default(<String, int>{}) Map<String, int> bhinnaTotals,
  }) = _Ashtakavarga;

  factory Ashtakavarga.fromArtifact(Map<String, dynamic> envelope) {
    final p = (envelope['payload'] as Map?)?.cast<String, dynamic>() ?? envelope;
    final sarva = (p['sarva'] as Map?)?.cast<String, dynamic>() ?? const {};
    final bhinna = (p['bhinna'] as Map?)?.cast<String, dynamic>() ?? const {};
    Map<String, int> ints(Object? m) => ((m as Map?) ?? const {}).map(
      (k, v) => MapEntry('$k', (v as num?)?.toInt() ?? 0),
    );
    return Ashtakavarga(
      sarvaByHouse: ints(sarva['by_house']),
      sarvaBySign: ints(sarva['by_sign']),
      sarvaTotal: (sarva['total'] as num?)?.toInt() ?? 0,
      bhinnaTotals: bhinna.map(
        (k, v) => MapEntry(k, ((v as Map?)?['total'] as num?)?.toInt() ?? 0),
      ),
    );
  }
}

@freezed
abstract class PlanetStrength with _$PlanetStrength {
  const factory PlanetStrength({
    required String name,
    @Default(0) double totalRupa,
    @Default(0) double requiredRupa,
    @Default(0) double ratio,
    @Default(false) bool isStrong,
  }) = _PlanetStrength;
}

/// `/app/birth-profiles/{id}/shadbala`.
@freezed
abstract class Shadbala with _$Shadbala {
  const factory Shadbala({
    @Default(<PlanetStrength>[]) List<PlanetStrength> planets,
    @Default('') String strongest,
    @Default('') String weakest,
  }) = _Shadbala;

  factory Shadbala.fromArtifact(Map<String, dynamic> envelope) {
    final p = (envelope['payload'] as Map?)?.cast<String, dynamic>() ?? envelope;
    final planetsMap = (p['planets'] as Map?)?.cast<String, dynamic>() ?? const {};
    final ranking = (p['ranking'] as List<dynamic>? ?? planetsMap.keys.toList())
        .map((e) => e.toString());
    return Shadbala(
      strongest: p['strongest'] as String? ?? '',
      weakest: p['weakest'] as String? ?? '',
      planets: [
        for (final name in ranking)
          if (planetsMap[name] case final Map<dynamic, dynamic> row)
            PlanetStrength(
              name: name,
              totalRupa: (row['total_rupa'] as num?)?.toDouble() ?? 0,
              requiredRupa: (row['required_rupa'] as num?)?.toDouble() ?? 0,
              ratio: (row['ratio'] as num?)?.toDouble() ?? 0,
              isStrong: (row['is_strong'] ?? false) as bool,
            ),
      ],
    );
  }
}
