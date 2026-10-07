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

    /// Photos the astrologer put on their profile (approved ones only).
    @Default(<AstrologerPhoto>[]) List<AstrologerPhoto> gallery,

    /// A discount the astrologer is running on their own rates right now,
    /// when it applies to this viewer.
    AstrologerOffer? offer,

    /// The latest well-rated, written reviews (detail only).
    @JsonKey(name: 'top_reviews')
    @Default(<AstrologerReview>[])
    List<AstrologerReview> topReviews,
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

  /// Percent off [channel] under the running offer; 0 when there is none or
  /// it does not cover that channel.
  int offerPercentFor(String channel) {
    final o = offer;
    if (o == null) return 0;
    if (o.channels.isNotEmpty && !o.channels.contains(channel)) return 0;
    return o.percentOff;
  }

  /// What [rate] costs per minute right now, offer included.
  double priceFor(AstrologerRate rate) {
    final percent = offerPercentFor(rate.channel);
    if (percent == 0) return rate.perMinute;
    return (rate.perMinute * (100 - percent)).round() / 100;
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
abstract class AstrologerReview with _$AstrologerReview {
  const factory AstrologerReview({
    @Default('') String id,
    @Default(0) int rating,
    @Default('') String text,

    /// First name and initial — the server never sends more to strangers.
    @JsonKey(name: 'customer_name') @Default('') String customerName,
    @JsonKey(name: 'astrologer_reply') @Default('') String astrologerReply,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _AstrologerReview;

  factory AstrologerReview.fromJson(Map<String, dynamic> json) =>
      _$AstrologerReviewFromJson(json);
}

@freezed
abstract class AstrologerOffer with _$AstrologerOffer {
  const factory AstrologerOffer({
    @JsonKey(name: 'percent_off') @Default(0) int percentOff,

    /// chat / voice / video it covers; empty means all of them.
    @Default(<String>[]) List<String> channels,
    @Default('everyone') String audience,
    @JsonKey(name: 'ends_at') DateTime? endsAt,
  }) = _AstrologerOffer;

  factory AstrologerOffer.fromJson(Map<String, dynamic> json) =>
      _$AstrologerOfferFromJson(json);
}

@freezed
abstract class AstrologerPhoto with _$AstrologerPhoto {
  const factory AstrologerPhoto({
    @Default('') String image,
    @Default('') String caption,
  }) = _AstrologerPhoto;

  factory AstrologerPhoto.fromJson(Map<String, dynamic> json) =>
      _$AstrologerPhotoFromJson(json);
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
