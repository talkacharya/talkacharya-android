part of 'home_cubit.dart';

/// One composite state; every section is an independent [AsyncValue] slice so
/// the feed renders and retries section-by-section.
class HomeState extends Equatable {
  const HomeState({
    this.wallet = const AsyncValue.idle(),
    this.promos = const AsyncValue.idle(),
    this.resume = const AsyncValue.idle(),
    this.live = const AsyncValue.idle(),
    this.online = const AsyncValue.idle(),
    this.horoscope = const AsyncValue.idle(),
    this.panchang = const AsyncValue.idle(),
    this.talkAgain = const AsyncValue.idle(),
    this.packs = const AsyncValue.idle(),
    this.referral = const AsyncValue.idle(),
    this.articles = const AsyncValue.idle(),
    this.sign = ZodiacSign.aries,
    this.onlineChannel = '',
    this.hasActiveProfile = false,
  });

  final AsyncValue<List<WalletBalance>> wallet;
  final AsyncValue<List<PromoSlide>> promos;
  final AsyncValue<HomeConsultation?> resume;
  final AsyncValue<List<LiveStreamCard>> live;
  final AsyncValue<List<Astrologer>> online;
  final AsyncValue<Horoscope> horoscope;
  final AsyncValue<Panchang> panchang;
  final AsyncValue<List<HomeConsultation>> talkAgain;
  final AsyncValue<List<RechargePack>> packs;
  final AsyncValue<ReferralOverview> referral;
  final AsyncValue<List<ArticleSummary>> articles;

  /// Sign the horoscope card is currently showing.
  final ZodiacSign sign;

  /// '' | 'chat' | 'voice' | 'video' — the online-astrologers rail filter.
  final String onlineChannel;

  final bool hasActiveProfile;

  HomeState copyWith({
    AsyncValue<List<WalletBalance>>? wallet,
    AsyncValue<List<PromoSlide>>? promos,
    AsyncValue<HomeConsultation?>? resume,
    AsyncValue<List<LiveStreamCard>>? live,
    AsyncValue<List<Astrologer>>? online,
    AsyncValue<Horoscope>? horoscope,
    AsyncValue<Panchang>? panchang,
    AsyncValue<List<HomeConsultation>>? talkAgain,
    AsyncValue<List<RechargePack>>? packs,
    AsyncValue<ReferralOverview>? referral,
    AsyncValue<List<ArticleSummary>>? articles,
    ZodiacSign? sign,
    String? onlineChannel,
    bool? hasActiveProfile,
  }) {
    return HomeState(
      wallet: wallet ?? this.wallet,
      promos: promos ?? this.promos,
      resume: resume ?? this.resume,
      live: live ?? this.live,
      online: online ?? this.online,
      horoscope: horoscope ?? this.horoscope,
      panchang: panchang ?? this.panchang,
      talkAgain: talkAgain ?? this.talkAgain,
      packs: packs ?? this.packs,
      referral: referral ?? this.referral,
      articles: articles ?? this.articles,
      sign: sign ?? this.sign,
      onlineChannel: onlineChannel ?? this.onlineChannel,
      hasActiveProfile: hasActiveProfile ?? this.hasActiveProfile,
    );
  }

  @override
  List<Object?> get props => [
    wallet,
    promos,
    resume,
    live,
    online,
    horoscope,
    panchang,
    talkAgain,
    packs,
    referral,
    articles,
    sign,
    onlineChannel,
    hasActiveProfile,
  ];
}
