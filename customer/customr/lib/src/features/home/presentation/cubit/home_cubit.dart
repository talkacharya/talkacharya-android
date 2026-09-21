import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/util/async_value.dart';
import '../../../articles/data/models/article.dart';
import '../../../astrologers/data/models/astrologer.dart';
import '../../../birthprofiles/data/models/birth_profile.dart';
import '../../data/home_repository.dart';
import '../../data/horoscope_sign_store.dart';
import '../../data/models/home_consultation.dart';
import '../../data/models/home_promo.dart';
import '../../data/models/horoscope.dart';
import '../../data/models/live_stream_card.dart';
import '../../data/models/panchang.dart';
import '../../data/models/recharge_pack.dart';
import '../../data/models/referral_overview.dart';
import '../../data/models/wallet_balance.dart';
import '../../data/models/zodiac.dart';
import '../../../../core/network/friendly_error.dart';

part 'home_state.dart';

/// Drives the home feed. [load] fans out one independent fetch per section;
/// each writes only its own slice, so a slow or failing endpoint never holds
/// up the rest of the screen.
class HomeCubit extends Cubit<HomeState> {
  HomeCubit({
    required HomeRepository repo,
    required HoroscopeSignStore signStore,
  }) : _repo = repo,
       _signStore = signStore,
       super(const HomeState());

  final HomeRepository _repo;
  final HoroscopeSignStore _signStore;

  String? _activeProfileId;

  Future<void> load({BirthProfile? activeProfile}) async {
    _activeProfileId = activeProfile?.id;
    final sign = _resolveSign(activeProfile);
    emit(state.copyWith(sign: sign, hasActiveProfile: activeProfile != null));

    await Future.wait([
      _loadFeed(),
      _loadWallet(),
      _loadPacks(),
      _loadHoroscope(sign),
      _loadPanchang(activeProfile?.id),
      _loadTalkAgain(),
      _loadReferral(),
      _loadArticles(),
    ]);
  }

  /// `GET /app/home` fills online / live / resume / promos in one call. If it
  /// fails, fall back to the per-endpoint fan-out so the feed still fills in.
  Future<void> _loadFeed() async {
    emit(
      state.copyWith(
        online: AsyncValue.loading(state.online.value),
        live: AsyncValue.loading(state.live.value),
      ),
    );
    try {
      final feed = await _repo.homeFeed();
      emit(
        state.copyWith(
          online: AsyncValue.data(feed.astrologerRail),
          live: AsyncValue.data(feed.liveNow),
          resume: AsyncValue.data(feed.resume),
          promos: AsyncValue.data(
            feed.promos.isEmpty ? _repo.promos() : feed.promos,
          ),
        ),
      );
    } catch (_) {
      emit(state.copyWith(promos: AsyncValue.data(_repo.promos())));
      await Future.wait([_loadOnline(), _loadLive(), _loadResume()]);
    }
  }

  Future<void> _loadPacks() => _section(
    read: (s) => s.packs,
    write: (s, v) => s.copyWith(packs: v),
    fetch: () => _repo.rechargePacks(),
  );

  Future<void> refresh({BirthProfile? activeProfile}) =>
      load(activeProfile: activeProfile);

  // --- horoscope sign switching ---------------------------------------

  ZodiacSign _resolveSign(BirthProfile? profile) {
    final stored = _signStore.sign;
    if (stored != null) return stored;
    // Vedic horoscopes are read for the chandra rasi the engine computed.
    final rasi = ZodiacSign.forProfileSign(profile?.moonSign);
    if (rasi != null) return rasi;
    final birthDate = DateTime.tryParse(profile?.birthDate ?? '');
    return birthDate != null
        ? ZodiacSign.fromDate(birthDate)
        : ZodiacSign.aries;
  }

  Future<void> setSign(ZodiacSign sign) async {
    await _signStore.set(sign);
    emit(state.copyWith(sign: sign));
    await _loadHoroscope(sign);
  }

  // --- online rail channel filter -----------------------------------

  Future<void> setOnlineChannel(String channel) async {
    if (channel == state.onlineChannel) return;
    emit(state.copyWith(onlineChannel: channel));
    await _loadOnline();
  }

  // --- per-section loaders (also the retry entry points) ------------

  Future<void> retryOnline() => _loadOnline();
  Future<void> retryLive() => _loadLive();
  Future<void> retryHoroscope() => _loadHoroscope(state.sign);
  Future<void> retryPanchang() => _loadPanchang(_activeProfileId);

  /// Run one section's fetch. Every `emit` reads `state` *after* the await —
  /// the loaders run concurrently in [load], so a `state.copyWith(...)` whose
  /// receiver was captured before the await would clobber sibling slices with a
  /// stale snapshot.
  Future<void> _section<T>({
    required AsyncValue<T> Function(HomeState) read,
    required HomeState Function(HomeState, AsyncValue<T>) write,
    required Future<T> Function() fetch,
  }) async {
    emit(write(state, AsyncValue.loading(read(state).value)));
    try {
      final value = await fetch();
      emit(write(state, AsyncValue.data(value)));
    } catch (e) {
      emit(write(state, AsyncValue.error(friendlyError(e), read(state).value)));
    }
  }

  Future<void> _loadWallet() => _section(
    read: (s) => s.wallet,
    write: (s, v) => s.copyWith(wallet: v),
    fetch: _repo.wallet,
  );

  Future<void> _loadResume() => _section(
    read: (s) => s.resume,
    write: (s, v) => s.copyWith(resume: v),
    fetch: _repo.resumable,
  );

  Future<void> _loadLive() => _section(
    read: (s) => s.live,
    write: (s, v) => s.copyWith(live: v),
    fetch: _repo.liveNow,
  );

  Future<void> _loadOnline() {
    final channel = state.onlineChannel.isEmpty ? null : state.onlineChannel;
    return _section(
      read: (s) => s.online,
      write: (s, v) => s.copyWith(online: v),
      fetch: () => _repo.onlineAstrologers(channel: channel),
    );
  }

  Future<void> _loadHoroscope(ZodiacSign sign) => _section(
    read: (s) => s.horoscope,
    write: (s, v) => s.copyWith(horoscope: v),
    fetch: () => _repo.horoscope(sign),
  );

  Future<void> _loadPanchang(String? profileId) {
    if (profileId == null || profileId.isEmpty) {
      emit(state.copyWith(panchang: const AsyncValue.error('no-profile')));
      return Future.value();
    }
    return _section(
      read: (s) => s.panchang,
      write: (s, v) => s.copyWith(panchang: v),
      fetch: () => _repo.panchang(profileId),
    );
  }

  Future<void> _loadTalkAgain() => _section(
    read: (s) => s.talkAgain,
    write: (s, v) => s.copyWith(talkAgain: v),
    fetch: _repo.talkAgain,
  );

  Future<void> _loadArticles() => _section(
    read: (s) => s.articles,
    write: (s, v) => s.copyWith(articles: v),
    fetch: _repo.latestArticles,
  );

  Future<void> _loadReferral() => _section(
    read: (s) => s.referral,
    write: (s, v) => s.copyWith(referral: v),
    fetch: _repo.referrals,
  );
}
