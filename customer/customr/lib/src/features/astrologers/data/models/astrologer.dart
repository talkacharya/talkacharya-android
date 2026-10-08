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

    /// Per channel, when the astrologer said they will take it again; it is
    /// off until then. Read through [nextOnlineFor].
    @JsonKey(name: 'next_online')
    @Default(<String, DateTime>{})
    Map<String, DateTime> nextOnline,

    /// Which of chat / voice / video the astrologer is taking right now. Null
    /// from a server that does not say: then nothing is known to be off.
    @JsonKey(name: 'channels_open') List<String>? channelsOpen,

    /// In a session and unable to take another: the waitlist is the way in.
    @JsonKey(name: 'is_busy') @Default(false) bool isBusy,

    /// How many people are already in their waitlist.
    @JsonKey(name: 'queue_waiting') @Default(0) int queueWaiting,
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

  /// When [channel] is back, in local time, while the astrologer has it
  /// switched off until a time still ahead; null when it is not waiting.
  DateTime? nextOnlineFor(String channel) {
    final at = nextOnline[channel]?.toLocal();
    return at != null && at.isAfter(DateTime.now()) ? at : null;
  }

  /// Where [channel] stands for a customer who wants it now.
  ChannelState stateOf(String channel) {
    if (rateFor(channel) == null) return ChannelState.noRate;
    if (nextOnlineFor(channel) != null) return ChannelState.backLater;
    final open = channelsOpen;
    if (open != null && !open.contains(channel)) return ChannelState.off;
    return ChannelState.open;
  }

  /// Whether [channel] is priced and being taken (says nothing of presence).
  bool takes(String channel) => stateOf(channel) == ChannelState.open;

  /// Chat, voice, video — those being taken, in that order.
  List<String> get openChannels => [
    for (final c in const ['chat', 'voice', 'video'])
      if (takes(c)) c,
  ];

  /// Online, free, and taking at least one kind of consultation: someone a
  /// customer can actually start with now.
  bool get isReachable => isAvailable && !isBusy && openChannels.isNotEmpty;

  /// Online and taking consultations, but with someone: join their waitlist.
  bool get isQueueable => isAvailable && isBusy && openChannels.isNotEmpty;

  /// The soonest any switched-off channel comes back, if one has a time.
  DateTime? get soonestBack {
    DateTime? first;
    for (final c in const ['chat', 'voice', 'video']) {
      final at = nextOnlineFor(c);
      if (at != null && (first == null || at.isBefore(first))) first = at;
    }
    return first;
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

/// Where one way of consulting stands with an astrologer.
enum ChannelState {
  /// Priced and being taken.
  open,

  /// Switched off until a time they gave.
  backLater,

  /// Switched off, with no time given.
  off,

  /// They have no price for it: not something they offer.
  noRate,
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
