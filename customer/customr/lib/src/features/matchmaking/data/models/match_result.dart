import 'package:equatable/equatable.dart';

/// One side of a match — a birth profile the user owns.
class MatchPerson extends Equatable {
  const MatchPerson({
    required this.id,
    required this.name,
    this.relation = '',
    this.gender = '',
    this.birthDate,
  });

  final String id;
  final String name;
  final String relation;
  final String gender;
  final DateTime? birthDate;

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
    final letters = parts
        .take(2)
        .map((p) => String.fromCharCode(p.runes.first).toUpperCase());
    return letters.isEmpty ? '?' : letters.join();
  }

  factory MatchPerson.fromJson(Map<String, dynamic>? j) => MatchPerson(
    id: '${j?['id'] ?? ''}',
    name: '${j?['name'] ?? ''}',
    relation: '${j?['relation'] ?? ''}',
    gender: '${j?['gender'] ?? ''}',
    birthDate: DateTime.tryParse('${j?['birth_date'] ?? ''}'),
  );

  @override
  List<Object?> get props => [id, name];
}

/// Moon-based attributes the kootas are computed from.
class MatchChartInfo extends Equatable {
  const MatchChartInfo({
    this.rasi = '',
    this.nakshatra = '',
    this.gana = '',
    this.yoni = '',
    this.lagna = '',
  });

  final String rasi;
  final String nakshatra;
  final String gana;
  final String yoni;
  final String lagna;

  factory MatchChartInfo.fromJson(Map<String, dynamic>? j) => MatchChartInfo(
    rasi: '${j?['rasi'] ?? ''}',
    nakshatra: '${j?['nakshatra'] ?? ''}',
    gana: '${j?['gana'] ?? ''}',
    yoni: '${j?['yoni'] ?? ''}',
    lagna: '${j?['lagna'] ?? ''}',
  );

  @override
  List<Object?> get props => [rasi, nakshatra, gana, yoni, lagna];
}

class Koota extends Equatable {
  const Koota({
    required this.key,
    required this.name,
    required this.obtained,
    required this.maximum,
  });

  final String key;
  final String name;
  final double obtained;
  final double maximum;

  double get ratio => maximum <= 0 ? 0 : (obtained / maximum).clamp(0, 1);
  bool get isZero => obtained <= 0;

  factory Koota.fromJson(Map<String, dynamic> j) {
    final name = '${j['name'] ?? ''}';
    return Koota(
      key: '${j['key'] ?? name.toLowerCase().replaceAll(' ', '_')}',
      name: name,
      obtained: _d(j['obtained_points']),
      maximum: _d(j['maximum_points']),
    );
  }

  @override
  List<Object?> get props => [key, obtained, maximum];
}

class ManglikSide extends Equatable {
  const ManglikSide({this.isManglik = false, this.isCancelled = false});
  final bool isManglik;
  final bool isCancelled;

  factory ManglikSide.fromJson(Map<String, dynamic>? j) => ManglikSide(
    isManglik: j?['is_manglik'] == true,
    isCancelled: j?['is_cancelled'] == true,
  );

  @override
  List<Object?> get props => [isManglik, isCancelled];
}

/// `none` | `both` | `cancelled` | `mismatch` (empty when the provider gave none).
class ManglikMatch extends Equatable {
  const ManglikMatch({
    required this.status,
    required this.boy,
    required this.girl,
  });

  final String status;
  final ManglikSide boy;
  final ManglikSide girl;

  bool get compatible => status != 'mismatch';

  factory ManglikMatch.fromJson(Map<String, dynamic> j) => ManglikMatch(
    status: '${j['status'] ?? ''}',
    boy: ManglikSide.fromJson((j['boy'] as Map?)?.cast<String, dynamic>()),
    girl: ManglikSide.fromJson((j['girl'] as Map?)?.cast<String, dynamic>()),
  );

  @override
  List<Object?> get props => [status, boy, girl];
}

/// A Guna Milan result. Summaries (history list) carry no kootas / chart info.
class MatchResult extends Equatable {
  const MatchResult({
    required this.id,
    required this.createdAt,
    required this.total,
    required this.maximum,
    required this.verdictKey,
    required this.boy,
    required this.girl,
    this.kootas = const [],
    this.boyInfo = const MatchChartInfo(),
    this.girlInfo = const MatchChartInfo(),
    this.manglik,
    this.doshas = const {},
  });

  final String id;
  final DateTime createdAt;
  final double total;
  final double maximum;

  /// `excellent` | `good` | `average` | `not_recommended`.
  final String verdictKey;
  final MatchPerson boy;
  final MatchPerson girl;
  final List<Koota> kootas;
  final MatchChartInfo boyInfo;
  final MatchChartInfo girlInfo;
  final ManglikMatch? manglik;

  /// `nadi` / `bhakoot` / `gana` → dosha present (that koota scored 0).
  final Map<String, bool> doshas;

  bool get hasDetail => kootas.isNotEmpty;
  double get ratio => maximum <= 0 ? 0 : (total / maximum).clamp(0, 1);

  String get pointsLabel {
    String f(double v) =>
        v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toStringAsFixed(1);
    return f(total);
  }

  static String _verdictFor(double total) => total >= 28
      ? 'excellent'
      : total >= 18
      ? 'good'
      : total >= 12
      ? 'average'
      : 'not_recommended';

  factory MatchResult.fromJson(Map<String, dynamic> j) {
    final payload = (j['payload'] as Map?)?.cast<String, dynamic>() ?? const {};
    final total = _d(j['total_points']);
    final verdict = '${j['verdict_key'] ?? payload['verdict_key'] ?? ''}';
    final doshas =
        (payload['doshas'] as Map?)?.cast<String, dynamic>() ?? const {};
    final kootas = [
      for (final k in (payload['koota'] as List? ?? const []))
        if (k is Map) Koota.fromJson(k.cast<String, dynamic>()),
    ];
    return MatchResult(
      id: '${j['id'] ?? ''}',
      createdAt:
          DateTime.tryParse('${j['created_at'] ?? ''}')?.toLocal() ??
          DateTime.now(),
      total: total,
      maximum: _d(j['max_points'], 36),
      verdictKey: verdict.isNotEmpty ? verdict : _verdictFor(total),
      boy: MatchPerson.fromJson((j['boy'] as Map?)?.cast<String, dynamic>()),
      girl: MatchPerson.fromJson((j['girl'] as Map?)?.cast<String, dynamic>()),
      kootas: kootas,
      boyInfo: MatchChartInfo.fromJson(
        (payload['boy_info'] as Map?)?.cast<String, dynamic>(),
      ),
      girlInfo: MatchChartInfo.fromJson(
        (payload['girl_info'] as Map?)?.cast<String, dynamic>(),
      ),
      manglik: payload['manglik'] is Map
          ? ManglikMatch.fromJson(
              (payload['manglik'] as Map).cast<String, dynamic>(),
            )
          : null,
      doshas: {
        for (final e in doshas.entries) e.key: e.value == true,
        // Older payloads: derive from the koota scores.
        if (doshas.isEmpty)
          for (final k in kootas)
            if (const {'nadi', 'bhakoot', 'gana'}.contains(k.key))
              k.key: k.isZero,
      },
    );
  }

  @override
  List<Object?> get props => [id, total, verdictKey, kootas, manglik];
}

double _d(dynamic v, [double fallback = 0]) =>
    v is num ? v.toDouble() : double.tryParse('$v') ?? fallback;
