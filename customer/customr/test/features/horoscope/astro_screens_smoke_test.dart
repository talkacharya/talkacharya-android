// Renders the horoscope reading and match result screens at a small phone size in
// English and Hindi. Any RenderFlex overflow or build exception fails the test.
import 'package:customr/src/core/config/config_repository.dart';
import 'package:customr/src/core/di/service_locator.dart';
import 'package:customr/src/core/l10n/l10n.dart';
import 'package:customr/src/core/profile/active_profile_store.dart';
import 'package:customr/src/features/birthprofiles/data/birth_profiles_repository.dart';
import 'package:customr/src/features/birthprofiles/data/models/birth_profile.dart';
import 'package:customr/src/features/birthprofiles/presentation/bloc/birth_profiles_cubit.dart';
import 'package:customr/src/features/matchmaking/presentation/view/matchmaking_home_page.dart';
import 'package:customr/src/core/theme/brand_colors.dart';
import 'package:customr/src/core/util/async_value.dart';
import 'package:customr/src/features/home/data/models/zodiac.dart';
import 'package:customr/src/features/horoscope/data/models/sign_horoscope.dart';
import 'package:customr/src/features/horoscope/presentation/view/horoscope_page.dart';
import 'package:customr/src/features/matchmaking/data/matchmaking_repository.dart';
import 'package:customr/src/features/matchmaking/data/models/match_result.dart';
import 'package:customr/src/features/matchmaking/presentation/cubit/matchmaking_cubit.dart';
import 'package:customr/src/features/matchmaking/presentation/view/match_result_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockMatchRepo extends Mock implements MatchmakingRepository {}

class _MockConfig extends Mock implements ConfigRepository {}

class _MockBpRepo extends Mock implements BirthProfilesRepository {}

class _MockStore extends Mock implements ActiveProfileStore {}

Widget _app(Widget child, {Locale locale = const Locale('en')}) => MaterialApp(
  locale: locale,
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  theme: ThemeData(
    useMaterial3: true,
    colorSchemeSeed: const Color(0xFFEA6A1E),
    extensions: const [BrandColors.light],
  ),
  home: child,
);

SignHoroscope _reading(
  HoroscopeSpan span,
) => SignHoroscope.fromJson(ZodiacSign.sagittarius, span, {
  'payload': {
    'range': {'start': '2026-09-07', 'end': '2026-09-13'},
    'headline':
        'A standout week — momentum is on your side and things move quickly.',
    'band': 'Excellent',
    'prediction': {
      'general':
          'A standout week — momentum is on your side and things move quickly. Jupiter in your 11th house keeps a protective, growth-friendly backdrop. Your best days: Tue, Wed.',
    },
    'scores': {'overall': 5, 'love': 4, 'career': 2, 'money': 5, 'health': 1},
    'areas': [
      for (final k in ['love', 'career', 'money', 'health'])
        {
          'key': k,
          'score': k == 'health' ? 1 : 4,
          'tone': 'supportive',
          'text':
              'Venus is well placed in your 5th house — warmth and understanding come easily in all your relationships this week.',
        },
    ],
    'lucky': {
      'colour_label': 'Silver white',
      'colour_hex': '#E2E8F0',
      'number': 3,
      'planet': 'Jupiter',
    },
    'tip': {
      'planet': 'Saturn',
      'text':
          'Be patient, punctual and fair; helping someone in need eases Saturn.',
    },
    'moon': {
      'sign_label': 'Sagittarius',
      'nakshatra_label': 'Purva Ashadha',
      'house': 11,
    },
    'transits': [
      for (final p in [
        'Moon',
        'Sun',
        'Mercury',
        'Venus',
        'Mars',
        'Jupiter',
        'Saturn',
        'Rahu',
        'Ketu',
      ])
        {
          'planet': p,
          'house': 11,
          'sign': 'Sagittarius',
          'favourable': p.length.isEven,
        },
    ],
    'favourable_days': ['2026-09-08', '2026-09-09', '2026-09-12'],
  },
});

MatchResult _match() => MatchResult.fromJson({
  'id': 'm-1',
  'created_at': '2026-09-13T10:00:00Z',
  'total_points': '18.5',
  'max_points': '36',
  'verdict_key': 'good',
  'boy': {'id': 'b', 'name': 'Rahul Venkataraman Subramaniam'},
  'girl': {'id': 'g', 'name': 'Priyadarshini Chattopadhyay'},
  'payload': {
    'boy_info': {
      'rasi': 'Sagittarius',
      'nakshatra': 'Purva Ashadha',
      'gana': 'Manushya',
      'yoni': 'Monkey',
    },
    'girl_info': {
      'rasi': 'Capricorn',
      'nakshatra': 'Uttara Ashadha',
      'gana': 'Manushya',
      'yoni': 'Mongoose',
    },
    'koota': [
      for (final (k, n, m) in const [
        ('varna', 'Varna', 1),
        ('vashya', 'Vashya', 2),
        ('tara', 'Tara', 3),
        ('yoni', 'Yoni', 4),
        ('graha_maitri', 'Graha Maitri', 5),
        ('gana', 'Gana', 6),
        ('bhakoot', 'Bhakoot', 7),
        ('nadi', 'Nadi', 8),
      ])
        {
          'key': k,
          'name': n,
          'obtained_points': k == 'nadi' ? 0 : m / 2,
          'maximum_points': m,
        },
    ],
    'doshas': {'nadi': true, 'bhakoot': false, 'gana': false},
    'manglik': {
      'status': 'mismatch',
      'boy': {'is_manglik': true},
      'girl': {'is_manglik': false},
    },
  },
});

void main() {
  setUpAll(() {
    // Pressable → HapticService reads the haptics toggle from DI.
    final config = _MockConfig();
    when(() => config.hapticEnabled).thenReturn(false);
    getIt.registerSingleton<ConfigRepository>(config);
  });

  for (final locale in const [Locale('en'), Locale('hi')]) {
    group('small phone · ${locale.languageCode}', () {
      setUp(() {
        final binding = TestWidgetsFlutterBinding.ensureInitialized();
        binding.platformDispatcher.views.first
          ..physicalSize = const Size(360, 740) * 3
          ..devicePixelRatio = 3;
      });
      tearDown(() {
        TestWidgetsFlutterBinding.instance.platformDispatcher.views.first
          ..resetPhysicalSize()
          ..resetDevicePixelRatio();
      });

      for (final span in [HoroscopeSpan.today, HoroscopeSpan.week]) {
        testWidgets('horoscope reading (${span.name}) lays out', (
          tester,
        ) async {
          await tester.pumpWidget(
            _app(
              Scaffold(
                body: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: HoroscopeReading(horoscope: _reading(span)),
                ),
              ),
              locale: locale,
            ),
          );
          await tester.pumpAndSettle(const Duration(seconds: 2));
          expect(tester.takeException(), isNull);
          expect(find.byType(HoroscopeReading), findsOneWidget);
        });
      }

      testWidgets('sign grid lays out', (tester) async {
        await tester.pumpWidget(
          _app(
            Scaffold(
              body: SignGrid(selected: ZodiacSign.leo, onSelect: (_) {}),
            ),
            locale: locale,
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });

      testWidgets('matchmaking home lays out with both slots filled', (
        tester,
      ) async {
        final store = _MockStore();
        when(() => store.activeProfileId).thenReturn(null);
        final bpRepo = _MockBpRepo();
        const me = BirthProfile(
          id: 'b1',
          fullName: 'Rahul Venkataraman',
          gender: 'male',
          birthDate: '1992-03-01',
          isPrimary: true,
        );
        const her = BirthProfile(
          id: 'g1',
          fullName: 'Priyadarshini Chattopadhyay',
          gender: 'female',
          birthDate: '1994-07-15',
        );
        when(bpRepo.list).thenAnswer((_) async => [me, her]);
        final profiles = BirthProfilesCubit(repo: bpRepo, store: store);
        final matchRepo = _MockMatchRepo();
        when(matchRepo.history).thenAnswer((_) async => [_match()]);
        final cubit = MatchmakingCubit(matchRepo)..setGirl(her);

        await tester.pumpWidget(
          _app(
            MultiBlocProvider(
              providers: [
                BlocProvider.value(value: profiles),
                BlocProvider.value(value: cubit),
              ],
              child: const MatchmakingHomePage(),
            ),
            locale: locale,
          ),
        );
        await tester.pump(const Duration(seconds: 2));
        expect(cubit.state.boy, me); // pre-filled from the primary profile
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox());
        await tester.pump(const Duration(seconds: 1));
      });

      testWidgets('match result lays out and expands a koota', (tester) async {
        final cubit = MatchResultCubit(
          repo: _MockMatchRepo(),
          id: 'm-1',
          seed: _match(),
        );
        await tester.pumpWidget(
          _app(
            BlocProvider.value(value: cubit, child: const MatchResultPage()),
            locale: locale,
          ),
        );
        await tester.pump(const Duration(seconds: 2));
        expect(cubit.state.status, AsyncStatus.data);
        expect(tester.takeException(), isNull);

        await tester.scrollUntilVisible(
          find.byIcon(Icons.health_and_safety_rounded),
          300,
        );
        await tester.tap(find.byIcon(Icons.health_and_safety_rounded));
        await tester.pump(const Duration(milliseconds: 400));
        expect(tester.takeException(), isNull);

        // Let staggered entrance timers of lazily-built rows run out.
        await tester.pump(const Duration(seconds: 2));
        await tester.pumpWidget(const SizedBox());
        await tester.pump(const Duration(seconds: 1));
      });
    });
  }
}
