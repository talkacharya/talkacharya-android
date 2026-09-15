/// Mirrors `apps/astrologers/serializers.py::MyProfileSerializer` — the payload of
/// `GET /astro/onboarding` and `/astro/profile`.
enum OnboardingStatus {
  draft,
  submitted,
  underReview,
  approved,
  rejected,
  suspended,
  unknown;

  static OnboardingStatus parse(String? raw) => switch (raw) {
    'draft' => OnboardingStatus.draft,
    'submitted' => OnboardingStatus.submitted,
    'under_review' => OnboardingStatus.underReview,
    'approved' => OnboardingStatus.approved,
    'rejected' => OnboardingStatus.rejected,
    'suspended' => OnboardingStatus.suspended,
    _ => OnboardingStatus.unknown,
  };
}

class AstroRate {
  const AstroRate({
    required this.channel,
    required this.currency,
    required this.perMinute,
  });
  final String channel;
  final String currency;
  final String perMinute;

  factory AstroRate.fromJson(Map<String, dynamic> j) => AstroRate(
    channel: j['channel'] as String? ?? '',
    currency: j['currency'] as String? ?? 'INR',
    perMinute: '${j['per_minute_amount'] ?? '0'}',
  );
}

class AstroSkill {
  const AstroSkill({required this.slug, required this.isPrimary});
  final String slug;
  final bool isPrimary;

  factory AstroSkill.fromJson(Map<String, dynamic> j) => AstroSkill(
    slug: j['slug'] as String? ?? '',
    isPrimary: j['is_primary'] as bool? ?? false,
  );
}

class AstroCommission {
  const AstroCommission({
    required this.name,
    required this.platformPercentage,
    required this.payoutCycleDays,
  });
  final String name;
  final String platformPercentage;
  final int payoutCycleDays;

  factory AstroCommission.fromJson(Map<String, dynamic> j) => AstroCommission(
    name: j['name'] as String? ?? '',
    platformPercentage: '${j['platform_percentage'] ?? ''}',
    payoutCycleDays: (j['payout_cycle_days'] as num?)?.toInt() ?? 7,
  );
}

class AstroProfile {
  AstroProfile({
    required this.id,
    this.banner,
    required this.headline,
    required this.bio,
    required this.sourceLanguage,
    required this.yearsExperience,
    required this.status,
    required this.verificationLevel,
    required this.rejectionReason,
    required this.isAvailable,
    required this.ratingAvg,
    required this.ratingCount,
    required this.consultationsCount,
    this.followersCount = 0,
    required this.skills,
    required this.languages,
    required this.rates,
    required this.commission,
    required this.gaps,
  });

  final String id;

  /// Absolute URL of the cover image shown behind the public profile header.
  final String? banner;
  final String headline;
  final String bio;
  final String sourceLanguage;
  final int yearsExperience;
  final OnboardingStatus status;
  final String verificationLevel;
  final String rejectionReason;
  final bool isAvailable;
  final double ratingAvg;
  final int ratingCount;
  final int consultationsCount;

  /// Customers following this astrologer — they get a push when you come
  /// online or go live.
  final int followersCount;
  final List<AstroSkill> skills;
  final List<String> languages;
  final List<AstroRate> rates;
  final AstroCommission? commission;
  final List<String> gaps;

  bool get hasProfile => id.isNotEmpty;

  factory AstroProfile.fromJson(Map<String, dynamic> j) => AstroProfile(
    id: j['id']?.toString() ?? '',
    banner: (j['banner'] as String?)?.isNotEmpty == true
        ? j['banner'] as String
        : null,
    headline: j['headline'] as String? ?? '',
    bio: j['bio'] as String? ?? '',
    sourceLanguage: j['source_language'] as String? ?? 'en',
    yearsExperience: (j['years_experience'] as num?)?.toInt() ?? 0,
    status: OnboardingStatus.parse(j['onboarding_status'] as String?),
    verificationLevel: j['verification_level'] as String? ?? '',
    rejectionReason: j['rejection_reason'] as String? ?? '',
    isAvailable: j['is_available_flag'] as bool? ?? false,
    ratingAvg: (j['rating_avg'] as num?)?.toDouble() ?? 0,
    ratingCount: (j['rating_count'] as num?)?.toInt() ?? 0,
    consultationsCount: (j['consultations_count'] as num?)?.toInt() ?? 0,
    followersCount: (j['followers_count'] as num?)?.toInt() ?? 0,
    skills: (j['skills'] as List? ?? const [])
        .map((e) => AstroSkill.fromJson((e as Map).cast<String, dynamic>()))
        .toList(),
    languages: (j['languages'] as List? ?? const [])
        .map((e) => e.toString())
        .toList(),
    rates: (j['rates'] as List? ?? const [])
        .map((e) => AstroRate.fromJson((e as Map).cast<String, dynamic>()))
        .toList(),
    commission: j['commission'] is Map
        ? AstroCommission.fromJson(
            (j['commission'] as Map).cast<String, dynamic>(),
          )
        : null,
    gaps: (j['onboarding_gaps'] as List? ?? const [])
        .map((e) => e.toString())
        .toList(),
  );
}
