import 'package:customr/src/core/util/async_value.dart';
import 'package:customr/src/features/astrologers/data/models/astrologer.dart';
import 'package:customr/src/features/birthprofiles/data/models/birth_profile.dart';
import 'package:customr/src/features/home/data/home_repository.dart';
import 'package:customr/src/features/home/data/horoscope_sign_store.dart';
import 'package:customr/src/features/home/data/models/home_consultation.dart';
import 'package:customr/src/features/home/data/models/home_feed.dart';
import 'package:customr/src/features/home/data/models/home_promo.dart';
import 'package:customr/src/features/home/data/models/horoscope.dart';
import 'package:customr/src/features/home/data/models/live_stream_card.dart';
import 'package:customr/src/features/home/data/models/panchang.dart';
import 'package:customr/src/features/home/data/models/recharge_pack.dart';
import 'package:customr/src/features/home/data/models/referral_overview.dart';
import 'package:customr/src/features/home/data/models/wallet_balance.dart';
import 'package:customr/src/features/home/data/models/zodiac.dart';
import 'package:customr/src/features/home/presentation/cubit/home_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepo extends Mock implements HomeRepository {}

class _MockSignStore extends Mock implements HoroscopeSignStore {}

BirthProfile _profile() =>
    const BirthProfile(id: 'bp-1', birthDate: '1994-08-14');

void main() {
  late _MockRepo repo;
  late _MockSignStore signStore;

  setUpAll(() => registerFallbackValue(ZodiacSign.aries));

  setUp(() {
    repo = _MockRepo();
    signStore = _MockSignStore();

    when(() => signStore.sign).thenReturn(null);
    when(() => signStore.set(any())).thenAnswer((_) async {});

    when(() => repo.homeFeed()).thenAnswer(
      (_) async => const HomeFeed(
        onlineNow: [Astrologer(id: 'a1', name: 'Acharya One')],
        promos: [
          RichPromo(
            id: 'p1',
            title: 'Diwali bonus',
            subtitle: 'Get 20% extra',
            cta: 'Claim',
          ),
        ],
      ),
    );
    when(() => repo.wallet()).thenAnswer(
      (_) async => [
        WalletBalance.fromJson({
          'currency': 'INR',
          'available_balance': '1240',
        }),
      ],
    );
    when(() => repo.rechargePacks(currency: any(named: 'currency'))).thenAnswer(
      (_) async =>
          RechargePack.suggestionsFor(minRecharge: 100, currency: 'INR'),
    );
    when(() => repo.promos()).thenReturn(const []);
    when(() => repo.resumable()).thenAnswer((_) async => null);
    when(() => repo.latestArticles()).thenAnswer((_) async => const []);
    when(
      () => repo.liveNow(),
    ).thenAnswer((_) async => const <LiveStreamCard>[]);
    when(
      () => repo.onlineAstrologers(channel: any(named: 'channel')),
    ).thenAnswer((_) async => const <Astrologer>[]);
    when(() => repo.horoscope(any())).thenAnswer(
      (_) async => const Horoscope(sign: ZodiacSign.leo, general: 'Steady.'),
    );
    when(() => repo.panchang(any())).thenAnswer(
      (_) async => const Panchang(tithi: 'Shukla 5', nakshatra: 'Rohini'),
    );
    when(
      () => repo.talkAgain(),
    ).thenAnswer((_) async => const <HomeConsultation>[]);
    when(
      () => repo.referrals(),
    ).thenAnswer((_) async => const ReferralOverview(code: 'TA123'));
  });

  HomeCubit build() => HomeCubit(repo: repo, signStore: signStore);

  test('load fans out and fills every slice', () async {
    final cubit = build();
    await cubit.load(activeProfile: _profile());

    final s = cubit.state;
    expect(s.wallet.status, AsyncStatus.data);
    expect(s.wallet.value!.single.available, 1240);
    expect(s.online.value!.single.name, 'Acharya One');
    expect((s.promos.value!.single as RichPromo).title, 'Diwali bonus');
    expect(s.horoscope.value!.general, 'Steady.');
    expect(s.panchang.value!.tithi, 'Shukla 5');
    expect(s.referral.value!.code, 'TA123');
    expect(s.packs.value, isNotEmpty);
    expect(s.hasActiveProfile, isTrue);
    // sun sign of 1994-08-14
    expect(s.sign, ZodiacSign.leo);
  });

  test('feed failure falls back to the per-endpoint fan-out', () async {
    when(() => repo.homeFeed()).thenThrow(Exception('home down'));
    when(
      () => repo.onlineAstrologers(channel: any(named: 'channel')),
    ).thenAnswer((_) async => [const Astrologer(id: 'fb', name: 'Fallback')]);
    final cubit = build();
    await cubit.load(activeProfile: _profile());

    expect(cubit.state.online.value!.single.name, 'Fallback');
    expect(
      cubit.state.promos.value,
      isEmpty,
    ); // static fallback (stubbed empty)
    verify(() => repo.onlineAstrologers(channel: null)).called(1);
    verify(() => repo.liveNow()).called(1);
  });

  test('a failing section errors without touching the others', () async {
    when(() => repo.horoscope(any())).thenThrow(Exception('boom'));
    final cubit = build();
    await cubit.load(activeProfile: _profile());

    expect(cubit.state.horoscope.status, AsyncStatus.error);
    expect(cubit.state.wallet.status, AsyncStatus.data);
    expect(cubit.state.panchang.status, AsyncStatus.data);
  });

  test('no active profile -> panchang is the no-profile error', () async {
    final cubit = build();
    await cubit.load();

    expect(cubit.state.panchang.status, AsyncStatus.error);
    expect(cubit.state.panchang.error, 'no-profile');
    expect(cubit.state.hasActiveProfile, isFalse);
  });

  test('setSign persists and refetches the horoscope', () async {
    final cubit = build();
    await cubit.load(activeProfile: _profile());

    when(() => repo.horoscope(ZodiacSign.aries)).thenAnswer(
      (_) async => const Horoscope(sign: ZodiacSign.aries, general: 'Bold.'),
    );
    await cubit.setSign(ZodiacSign.aries);

    verify(() => signStore.set(ZodiacSign.aries)).called(1);
    expect(cubit.state.sign, ZodiacSign.aries);
    expect(cubit.state.horoscope.value!.general, 'Bold.');
  });

  test('setOnlineChannel re-queries the rail with the channel', () async {
    final cubit = build();
    await cubit.load(activeProfile: _profile());

    await cubit.setOnlineChannel('voice');

    expect(cubit.state.onlineChannel, 'voice');
    verify(() => repo.onlineAstrologers(channel: 'voice')).called(1);
  });
}
