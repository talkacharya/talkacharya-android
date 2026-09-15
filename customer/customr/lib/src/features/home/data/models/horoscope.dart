import 'package:equatable/equatable.dart';

import 'zodiac.dart';

/// Today's reading for one sign, flattened from the loose `payload` of
/// `GET /app/horoscope?sign=` (the artifact envelope + the engine's payload; the
/// parser stays lenient about missing sections).
class Horoscope extends Equatable {
  const Horoscope({
    required this.sign,
    required this.general,
    this.love,
    this.career,
    this.health,
    this.luck,
    this.generatedAt,
  });

  final ZodiacSign sign;
  final String general;
  final String? love;
  final String? career;
  final String? health;

  /// A qualitative word ("Excellent" / "Good" / …) when the provider gives one.
  final String? luck;
  final DateTime? generatedAt;

  factory Horoscope.fromArtifact(ZodiacSign sign, Map<String, dynamic> json) {
    final payload =
        (json['payload'] as Map?)?.cast<String, dynamic>() ?? const {};
    // `prediction` is a map in the fake; some providers nest a list.
    dynamic pred = payload['prediction'] ?? payload;
    if (pred is List && pred.isNotEmpty) pred = pred.first;
    final p = (pred as Map?)?.cast<String, dynamic>() ?? const {};

    String? s(dynamic v) {
      final str = v?.toString().trim();
      return (str == null || str.isEmpty) ? null : str;
    }

    return Horoscope(
      sign: sign,
      general:
          s(p['general'] ?? p['prediction'] ?? p['description'] ?? p['text']) ??
          'The stars are quiet today — check back in a little while.',
      love: s(p['love'] ?? p['love_life'] ?? p['relationship']),
      career: s(p['career'] ?? p['profession'] ?? p['work']),
      health: s(p['health'] ?? p['wellness']),
      luck: s(p['luck'] ?? p['lucky'] ?? p['status']),
      generatedAt: DateTime.tryParse('${json['generated_at'] ?? ''}'),
    );
  }

  @override
  List<Object?> get props => [sign, general, love, career, health, luck];
}
