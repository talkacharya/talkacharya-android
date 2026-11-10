import '../../../core/config/config_repository.dart';
import '../../articles/data/articles_repository.dart';
import '../../articles/data/models/article.dart';
import '../../astrologers/data/astrologers_api.dart';
import '../../astrologers/data/astrologers_repository.dart';
import '../../astrologers/data/models/astrologer.dart';
import 'home_api.dart';
import 'models/home_consultation.dart';
import 'models/home_feed.dart';
import 'models/horoscope.dart';
import 'models/live_stream_card.dart';
import 'models/panchang.dart';
import 'models/recharge_pack.dart';
import 'models/referral_overview.dart';
import 'models/wallet_balance.dart';
import 'models/zodiac.dart';

/// Everything the home feed pulls, in one place. Section boundaries here mirror
/// the widgets so the [HomeCubit] can fan out one call per section.
class HomeRepository {
  HomeRepository({
    required HomeApi api,
    required AstrologersRepository astrologers,
    required ConfigRepository config,
    required ArticlesRepository articles,
  }) : _api = api,
       _astrologers = astrologers,
       _config = config,
       _articles = articles;

  final HomeApi _api;
  final AstrologersRepository _astrologers;
  final ConfigRepository _config;
  final ArticlesRepository _articles;

  /// Newest editorial reads for the "Read & learn" rail.
  Future<List<ArticleSummary>> latestArticles() => _articles.latest();

  /// `GET /app/home` — one call for featured / online / live / resume / promos.
  Future<HomeFeed> homeFeed() => _api.feed();

  Future<List<Astrologer>> onlineAstrologers({String? channel}) async {
    final page = await _astrologers.list(
      query: AstrologerQuery(channel: channel, sort: 'recommended'),
    );
    // Prefer available ones; keep the rest so the rail is never empty.
    final online = page.items.where((a) => a.isAvailable).toList();
    final rest = page.items.where((a) => !a.isAvailable).toList();
    return [...online, ...rest].take(12).toList();
  }

  Future<List<LiveStreamCard>> liveNow() async {
    final streams = await _api.liveStreams();
    return streams.where((s) => s.isLive).take(12).toList();
  }

  // Request language is resolved server-side from the auth user / Accept-Language.
  Future<Horoscope> horoscope(ZodiacSign sign) => _api.horoscope(sign);

  Future<Panchang> panchang(String birthProfileId) =>
      _api.panchang(birthProfileId);

  Future<List<WalletBalance>> wallet() => _api.wallet();

  Future<ReferralOverview> referrals() => _api.referrals();

  /// Active / paused session, if any.
  Future<HomeConsultation?> resumable() async {
    final list = await _api.consultations();
    for (final c in list) {
      if (c.isResumable) return c;
    }
    return null;
  }

  /// Recently consulted astrologers, most-recent first, de-duped by astrologer.
  Future<List<HomeConsultation>> talkAgain() async {
    final list = await _api.consultations(status: 'ended');
    final seen = <String>{};
    final out = <HomeConsultation>[];
    for (final c in list) {
      if (c.astrologerId.isEmpty || !seen.add(c.astrologerId)) continue;
      out.add(c);
      if (out.length >= 10) break;
    }
    return out;
  }

  /// `GET /app/wallet/packs`; falls back to a config-derived ladder if the
  /// endpoint is unavailable.
  Future<List<RechargePack>> rechargePacks({String? currency}) async {
    try {
      final packs = await _api.walletPacks(currency: currency);
      if (packs.isNotEmpty) return packs;
    } catch (_) {
      /* fall through to the derived ladder */
    }
    final min =
        double.tryParse(_config.value.minRecharge.amount)?.round() ?? 100;
    return RechargePack.suggestionsFor(
      minRecharge: min,
      currency: currency ?? _config.value.minRecharge.currency,
    );
  }
}
