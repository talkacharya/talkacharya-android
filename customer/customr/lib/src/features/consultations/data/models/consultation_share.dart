/// What the customer shared with the astrologer for a consultation: a birth
/// profile (at booking or mid-session) or a Guna Milan match.
///
/// Mirrors backend `ConsultationShareSerializer`. Summaries deliberately carry
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

  /// ISO date (`1994-05-12`), or empty when unknown.
  final String birthDate;

  /// `HH:mm`, or null when the birth time wasn't known.
  final String? birthTime;
  final bool timeKnown;
  final String birthPlace;

  /// Best display name.
  String get name => fullName.isNotEmpty ? fullName : label;

  static SharedPerson? fromMap(Map<String, dynamic>? j) {
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

  static SharedMatch? fromMap(Map<String, dynamic>? j) {
    if (j == null || j.isEmpty) return null;
    return SharedMatch(
      id: '${j['id'] ?? ''}',
      totalPoints: double.tryParse('${j['total_points']}') ?? 0,
      maxPoints: double.tryParse('${j['max_points']}') ?? 36,
      verdict: j['verdict'] as String? ?? '',
      boy: SharedPerson.fromMap((j['boy'] as Map?)?.cast<String, dynamic>()),
      girl: SharedPerson.fromMap((j['girl'] as Map?)?.cast<String, dynamic>()),
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

  factory ConsultationShare.fromMap(Map<String, dynamic> j) =>
      ConsultationShare(
        id: '${j['id'] ?? ''}',
        kind: j['kind'] as String? ?? 'birth_profile',
        sharedAt: DateTime.tryParse('${j['shared_at']}'),
        person: SharedPerson.fromMap(
          (j['birth_profile'] as Map?)?.cast<String, dynamic>(),
        ),
        match: SharedMatch.fromMap(
          (j['match'] as Map?)?.cast<String, dynamic>(),
        ),
      );

  static List<ConsultationShare> listFrom(Object? raw) =>
      (raw as List? ?? const [])
          .map(
            (e) =>
                ConsultationShare.fromMap((e as Map).cast<String, dynamic>()),
          )
          .toList();
}
