/// Today's mood for a birth profile — `GET /app/birth-profiles/{id}/mood`.
///
/// Read from the birth Moon (Chandra gochar + tara). Prose arrives in the
/// request language; `mood` / `tone` are canonical keys the UI switches on.
class DailyMood {
  const DailyMood({
    required this.date,
    required this.mood,
    required this.tone,
    required this.level,
    required this.houseFromMoon,
    required this.chandrashtama,
    required this.headline,
    required this.why,
    required this.tip,
    required this.locked,
    required this.moonSignLabel,
    required this.moonHouseLabel,
    required this.disclaimer,
    this.nextChangeAt,
  });

  factory DailyMood.fromJson(Map<String, dynamic> j) {
    final moon = (j['moon'] as Map?)?.cast<String, dynamic>() ?? const {};
    return DailyMood(
      date: j['date'] as String? ?? '',
      mood: j['mood'] as String? ?? '',
      tone: j['tone'] as String? ?? 'steady',
      level: (j['level'] as num?)?.toInt() ?? 3,
      houseFromMoon: (moon['house_from_moon'] as num?)?.toInt() ?? 0,
      chandrashtama: moon['chandrashtama'] as bool? ?? false,
      headline: j['headline'] as String? ?? '',
      why: j['why'] as String? ?? '',
      tip: j['tip'] as String? ?? '',
      locked: [for (final x in (j['locked'] as List?) ?? const []) '$x'],
      moonSignLabel: j['moon_sign_label'] as String? ?? '',
      moonHouseLabel: j['moon_house_label'] as String? ?? '',
      disclaimer: j['disclaimer'] as String? ?? '',
      nextChangeAt: DateTime.tryParse(j['next_change_at'] as String? ?? ''),
    );
  }

  final String date;
  final String mood;

  /// `bright` | `steady` | `tender`
  final String tone;

  /// 1 (heavy) … 5 (uplifted)
  final int level;
  final int houseFromMoon;
  final bool chandrashtama;
  final String headline;
  final String why;
  final String tip;

  /// What a consultation adds — shown as locked teasers.
  final List<String> locked;
  final String moonSignLabel;
  final String moonHouseLabel;
  final String disclaimer;
  final DateTime? nextChangeAt;

  String get emoji => switch (mood) {
    'fresh' => '✨',
    'careful' => '💬',
    'confident' => '🔥',
    'restless' => '🌙',
    'thoughtful' => '💭',
    'strong' => '💪',
    'warm' => '💞',
    'heavy' => '☁️',
    'reflective' => '🙏',
    'focused' => '⭐',
    'joyful' => '😊',
    'withdrawn' => '🌙',
    _ => '🌙',
  };
}
