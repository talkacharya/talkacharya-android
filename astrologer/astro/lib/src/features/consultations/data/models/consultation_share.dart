/// What the customer shared for this consultation: a birth profile or a Guna
/// Milan match. Mirrors backend `ConsultationShareSerializer` — summaries carry
/// no coordinates.
library;

class SharedPerson {
  const SharedPerson({
    required this.id,
    required this.label,
    required this.fullName,
    required this.relation,
    required this.gender,
    required this.birthDate,
    required this.birthTime,
    required this.timeKnown,
    required this.birthPlace,
  });

  final String id;
  final String label;
  final String fullName;
  final String relation;
  final String gender;

  /// ISO date, or empty when unknown.
  final String birthDate;

  /// `HH:mm`, null when the birth time wasn't known.
  final String? birthTime;
  final bool timeKnown;
  final String birthPlace;

  String get name => fullName.isNotEmpty ? fullName : label;

  static SharedPerson? fromJson(Map<String, dynamic>? j) {
    if (j == null || j.isEmpty) return null;
    final time = j['birth_time'] as String?;
    return SharedPerson(
      id: '${j['id'] ?? ''}',
      label: j['label'] as String? ?? '',
      fullName: j['full_name'] as String? ?? '',
      relation: j['relation'] as String? ?? '',
      gender: j['gender'] as String? ?? '',
      birthDate: '${j['birth_date'] ?? ''}',
      birthTime: time,
      timeKnown: j['time_known'] as bool? ?? time != null,
      birthPlace: j['birth_place'] as String? ?? '',
    );
  }
}

class SharedMatch {
  const SharedMatch({
    required this.id,
    required this.totalPoints,
    required this.maxPoints,
    required this.verdict,
    required this.boy,
    required this.girl,
  });

  final String id;
  final double totalPoints;
  final double maxPoints;
  final String verdict;
  final SharedPerson? boy;
  final SharedPerson? girl;

  double get ratio => maxPoints == 0 ? 0 : totalPoints / maxPoints;

  /// "26.5" (no trailing ".0").
  String get pointsLabel => totalPoints == totalPoints.roundToDouble()
      ? totalPoints.toStringAsFixed(0)
      : totalPoints.toStringAsFixed(1);

  String get maxLabel => maxPoints.toStringAsFixed(0);

  static SharedMatch? fromJson(Map<String, dynamic>? j) {
    if (j == null || j.isEmpty) return null;
    return SharedMatch(
      id: '${j['id'] ?? ''}',
      totalPoints: double.tryParse('${j['total_points']}') ?? 0,
      maxPoints: double.tryParse('${j['max_points']}') ?? 36,
      verdict: j['verdict'] as String? ?? '',
      boy: SharedPerson.fromJson((j['boy'] as Map?)?.cast<String, dynamic>()),
      girl: SharedPerson.fromJson((j['girl'] as Map?)?.cast<String, dynamic>()),
    );
  }
}

class ConsultationShare {
  const ConsultationShare({
    required this.id,
    required this.kind,
    required this.sharedAt,
    this.person,
    this.match,
  });

  final String id;

  /// `birth_profile` | `match`
  final String kind;
  final DateTime? sharedAt;
  final SharedPerson? person;
  final SharedMatch? match;

  bool get isMatch => kind == 'match';

  factory ConsultationShare.fromJson(Map<String, dynamic> j) =>
      ConsultationShare(
        id: '${j['id'] ?? ''}',
        kind: j['kind'] as String? ?? 'birth_profile',
        sharedAt: DateTime.tryParse('${j['shared_at']}'),
        person: SharedPerson.fromJson(
          (j['birth_profile'] as Map?)?.cast<String, dynamic>(),
        ),
        match: SharedMatch.fromJson(
          (j['match'] as Map?)?.cast<String, dynamic>(),
        ),
      );

  static List<ConsultationShare> listFrom(Object? raw) =>
      (raw as List? ?? const [])
          .map(
            (e) =>
                ConsultationShare.fromJson((e as Map).cast<String, dynamic>()),
          )
          .toList();
}

/// One koota row of a Guna Milan report (`payload.koota`).
class MatchKoota {
  const MatchKoota({
    required this.name,
    required this.points,
    required this.maxPoints,
  });

  final String name;
  final double points;
  final double maxPoints;

  bool get isZero => points == 0;
  double get ratio => maxPoints == 0 ? 0 : points / maxPoints;

  factory MatchKoota.fromJson(Map<String, dynamic> j) => MatchKoota(
    name: j['name'] as String? ?? j['key'] as String? ?? '',
    points: double.tryParse('${j['obtained_points']}') ?? 0,
    maxPoints: double.tryParse('${j['maximum_points']}') ?? 0,
  );
}

/// Full report from `GET /astro/consultations/{id}/matches/{matchId}`.
class MatchReport {
  const MatchReport({
    required this.summary,
    required this.kootas,
    required this.doshas,
    required this.description,
  });

  final SharedMatch summary;
  final List<MatchKoota> kootas;

  /// `nadi` / `bhakoot` / `gana` → true when that koota scored nothing.
  final Map<String, bool> doshas;
  final String description;

  factory MatchReport.fromJson(Map<String, dynamic> j) {
    final payload = (j['payload'] as Map?)?.cast<String, dynamic>() ?? const {};
    final message = (payload['message'] as Map?)?.cast<String, dynamic>();
    return MatchReport(
      summary: SharedMatch.fromJson(j)!,
      kootas: (payload['koota'] as List? ?? const [])
          .map((e) => MatchKoota.fromJson((e as Map).cast<String, dynamic>()))
          .toList(),
      doshas: {
        for (final e in ((payload['doshas'] as Map?) ?? const {}).entries)
          '${e.key}': e.value == true,
      },
      description: message?['description'] as String? ?? '',
    );
  }
}
