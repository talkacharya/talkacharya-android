import 'package:freezed_annotation/freezed_annotation.dart';

part 'astrologer.freezed.dart';
part 'astrologer.g.dart';

/// One astrologer from `GET /api/v1/app/astrologers` (list) or `/{id}` (detail).
/// Mirrors `PublicAstrologerSerializer` / `AstrologerDetailSerializer`.
@freezed
abstract class Astrologer with _$Astrologer {
  const factory Astrologer({
    required String id,
    @Default('') String name,
    String? avatar,

    /// Cover image the astrologer uploaded (≈3:1); null → the colour gradient.
    String? banner,
    @Default('') String headline,
    @JsonKey(name: 'years_experience') @Default(0) int yearsExperience,
    @JsonKey(name: 'verification_level') @Default('') String verificationLevel,
    @JsonKey(name: 'rating_avg') @Default(0) double ratingAvg,
    @JsonKey(name: 'rating_count') @Default(0) int ratingCount,
    @JsonKey(name: 'consultations_count') @Default(0) int consultationsCount,
    @JsonKey(name: 'followers_count') @Default(0) int followersCount,

    /// Whether the signed-in viewer follows this astrologer (false for guests).
    @JsonKey(name: 'is_following') @Default(false) bool isFollowing,
    @JsonKey(name: 'is_available_flag') @Default(false) bool isAvailable,
    @Default(<AstrologerSkill>[]) List<AstrologerSkill> skills,
    @Default(<AstrologerLanguage>[]) List<AstrologerLanguage> languages,
    @Default(<AstrologerRate>[]) List<AstrologerRate> rates,
    // detail-only
    @Default('') String bio,
    @JsonKey(name: 'avg_response_seconds') int? avgResponseSeconds,
    @JsonKey(name: 'repeat_client_rate') double? repeatClientRate,
    @JsonKey(name: 'response_rate') double? responseRate,
  }) = _Astrologer;

  const Astrologer._();

  factory Astrologer.fromJson(Map<String, dynamic> json) =>
      _$AstrologerFromJson(json);

  bool get isVerified =>
      verificationLevel.isNotEmpty && verificationLevel != 'none';

  /// Lowest per-minute rate across channels, or null when none published.
  AstrologerRate? get cheapestRate {
    if (rates.isEmpty) return null;
    return rates.reduce((a, b) => a.perMinute <= b.perMinute ? a : b);
  }

  AstrologerRate? rateFor(String channel) {
    for (final r in rates) {
      if (r.channel == channel) return r;
    }
    return null;
  }

  /// Rate to lead the profile CTA with — chat when published, else the cheapest.
  AstrologerRate? get leadRate => rateFor('chat') ?? cheapestRate;

  /// Average first-reply time in whole minutes (rounded up); null when unknown.
  int? get responseMinutes {
    final s = avgResponseSeconds;
    if (s == null || s <= 0) return null;
    return (s / 60).ceil().clamp(1, 60);
  }

  String get skillsLabel => skills.take(3).map((s) => s.name).join(' · ');
}

@freezed
abstract class AstrologerSkill with _$AstrologerSkill {
  const factory AstrologerSkill({
    @Default('') String slug,
    @Default('') String name,
    @Default('') String category,
    @Default('') String icon,
  }) = _AstrologerSkill;

  factory AstrologerSkill.fromJson(Map<String, dynamic> json) =>
      _$AstrologerSkillFromJson(json);
}

@freezed
abstract class AstrologerLanguage with _$AstrologerLanguage {
  const factory AstrologerLanguage({
    @Default('') String code,
    @Default('') String name,
    @JsonKey(name: 'native_name') @Default('') String nativeName,
  }) = _AstrologerLanguage;

  factory AstrologerLanguage.fromJson(Map<String, dynamic> json) =>
      _$AstrologerLanguageFromJson(json);
}

@freezed
abstract class AstrologerRate with _$AstrologerRate {
  const factory AstrologerRate({
    @Default('') String channel,
    @Default('INR') String currency,
    @JsonKey(name: 'per_minute_amount') @Default('0') String perMinuteAmount,
  }) = _AstrologerRate;

  const AstrologerRate._();

  factory AstrologerRate.fromJson(Map<String, dynamic> json) =>
      _$AstrologerRateFromJson(json);

  double get perMinute => double.tryParse(perMinuteAmount) ?? 0;
}
