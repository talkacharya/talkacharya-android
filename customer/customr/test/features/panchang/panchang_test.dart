// Panchang: payload parsing (place-local times, midnight rollover, "now"),
// the cubit (place resolution, date bounds), and the page at a small phone
// size in en/hi across today / another day / no place.
import 'package:customr/src/core/config/config_repository.dart';
import 'package:customr/src/core/di/service_locator.dart';
import 'package:customr/src/core/l10n/l10n.dart';
import 'package:customr/src/core/theme/brand_colors.dart';
import 'package:customr/src/features/birthprofiles/data/birth_profiles_repository.dart';
import 'package:customr/src/features/birthprofiles/presentation/bloc/birth_profiles_cubit.dart';
import 'package:customr/src/core/profile/active_profile_store.dart';
import 'package:customr/src/features/panchang/data/models/day_panchang.dart';
import 'package:customr/src/features/panchang/data/panchang_repository.dart';
import 'package:customr/src/features/panchang/presentation/cubit/panchang_cubit.dart';
import 'package:customr/src/features/panchang/presentation/view/panchang_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepo extends Mock implements PanchangRepository {}

class _MockConfig extends Mock implements ConfigRepository {}

class _MockBpRepo extends Mock implements BirthProfilesRepository {}

class _MockStore extends Mock implements ActiveProfileStore {}

const _varanasi = PanchangPlace(
  name: 'Varanasi, Uttar Pradesh, India',
  latitude: 25.32,
  longitude: 82.97,
);

List<Map<String, String>> _chog(List<String> names, List<String> times) => [
  for (var i = 0; i < 8; i++)
    {
      'name': names[i % names.length],
      'quality': i.isEven ? 'good' : 'bad',
      'start': times[i],
      'end': times[i + 1],
    },
];

Map<String, dynamic> _json({
  String date = '2026-09-13',
  bool wednesday = false,
}) => {
  'date': date,
  'place': 'Varanasi',
  'timezone': 'Asia/Kolkata',
  'payload': {
    'date': date,
    'vaara': wednesday ? 'Wednesday' : 'Sunday',
    'tithi': [
      {
        'index': 22,
        'name': 'Saptami',
        'paksha': 'Krishna',
        'starts_at': '2026-09-12T20:10:00+05:30',
        'ends_at': '2026-09-13T22:41:05+05:30',
      },
    ],
    'nakshatra': [
      {
        'name': 'Rohini',
        'pada': 2,
        'starts_at': '2026-09-13T01:00:00+05:30',
        'ends_at': '2026-09-14T03:05:00+05:30',
      },
    ],
    'yoga': [
      {
        'name': 'Siddhi',
        'starts_at': '2026-09-12T11:00:00+05:30',
        'ends_at': '2026-09-13T09:30:00+05:30',
      },
    ],
    'karana': [
      {
        'name': 'Vanija',
        'starts_at': '2026-09-13T08:00:00+05:30',
        'ends_at': '2026-09-13T21:00:00+05:30',
      },
    ],
    'sunrise': '05:48:10',
    'sunset': '18:12:40',
    'moon_sign': 'Taurus',
    'sun_sign': 'Leo',
    'inauspicious': {
      'rahu_kalam': {'start': '16:39', 'end': '18:12'},
      'yamaganda': {'start': '12:00', 'end': '13:33'},
      'gulika_kalam': {'start': '15:06', 'end': '16:39'},
    },
    'auspicious': {
      'brahma_muhurta': {'start': '04:12', 'end': '05:00'},
      if (!wednesday) 'abhijit_muhurta': {'start': '11:36', 'end': '12:25'},
    },
    'choghadiya': {
      'day': _chog(
        ['udveg', 'char', 'labh', 'amrit', 'kaal', 'shubh', 'rog'],
        [
          '05:48',
          '07:21',
          '08:54',
          '10:27',
          '12:00',
          '13:33',
          '15:06',
          '16:39',
          '18:12',
        ],
      ),
      'night': _chog(
        ['shubh', 'amrit', 'char', 'rog', 'kaal', 'labh', 'udveg'],
        [
          '18:12',
          '19:39',
          '21:06',
          '22:33',
          '00:00',
          '01:27',
          '02:54',
          '04:21',
          '05:48',
        ],
      ),
    },
  },
  'notes': [
    {
      'title': 'Ganesh Chaturthi',
      'body': 'Moon sighting should be avoided tonight.',
    },
  ],
};

void main() {
  late _MockRepo repo;

  setUpAll(() {
    final config = _MockConfig();
    when(() => config.hapticEnabled).thenReturn(false);
    getIt.registerSingleton<ConfigRepository>(config);
    registerFallbackValue(_varanasi);
    registerFallbackValue(DateTime(2026));
  });

  setUp(() => repo = _MockRepo());

  group('DayPanchang.fromJson', () {
    final d = DayPanchang.fromJson(_json());

    test('keeps place-local wall-clock times from the ISO strings', () {
      expect(d.tithi!.name, 'Saptami');
      expect(d.tithi!.detail, 'Krishna');
      expect(d.tithi!.span!.end.hour, 22);
      expect(d.tithi!.span!.end.minute, 41);
      expect(d.nakshatra!.detail, '2');
      expect(d.nakshatra!.span!.end.date, DateTime(2026, 9, 14));
      expect(d.utcOffset, const Duration(hours: 5, minutes: 30));
    });

    test('night choghadiya rolls past midnight onto the next date', () {
      final night = d.nightChoghadiya;
      expect(night, hasLength(8));
      expect(night[3].window.end.date, DateTime(2026, 9, 14));
      expect(night[4].window.start.date, DateTime(2026, 9, 14));
      expect(night.last.window.end.local, DateTime(2026, 9, 14, 5, 48));
      for (var i = 1; i < night.length; i++) {
        expect(night[i].window.start.local, night[i - 1].window.end.local);
      }
    });

    test('placeNow converts from UTC with the place offset', () {
      // 12:30 UTC = 18:00 IST → inside Rahu Kaal (16:39–18:12)
      final now = d.placeNow(DateTime.utc(2026, 9, 13, 12, 30));
      expect(now, DateTime(2026, 9, 13, 18));
      expect(d.rahuKaal!.contains(now!), isTrue);
      expect(d.abhijit, isNotNull);
      expect(DayPanchang.fromJson(_json(wednesday: true)).abhijit, isNull);
    });
  });

  group('PanchangCubit', () {
    test('saved place wins over the profile fallback', () async {
      const saved = PanchangPlace(
        name: 'Pune',
        latitude: 18.5,
        longitude: 73.8,
      );
      when(() => repo.savedPlace()).thenAnswer((_) async => saved);
      when(() => repo.cached(any(), any())).thenReturn(null);
      when(
        () => repo.day(any(), any()),
      ).thenAnswer((_) async => DayPanchang.fromJson(_json()));
      final cubit = PanchangCubit(repo: repo, fallbackPlace: _varanasi);
      await cubit.init();
      expect(cubit.state.place, saved);
      expect(cubit.state.day.value?.tithi?.name, 'Saptami');
    });

    test('no saved place and no profile → asks for a city', () async {
      when(() => repo.savedPlace()).thenAnswer((_) async => null);
      final cubit = PanchangCubit(repo: repo);
      await cubit.init();
      expect(cubit.state.needsPlace, isTrue);
      verifyNever(() => repo.day(any(), any()));
    });

    test('dates are clamped to ±400 days and setPlace persists', () async {
      when(() => repo.savedPlace()).thenAnswer((_) async => null);
      when(() => repo.savePlace(any())).thenAnswer((_) async {});
      when(() => repo.cached(any(), any())).thenReturn(null);
      when(
        () => repo.day(any(), any()),
      ).thenAnswer((_) async => DayPanchang.fromJson(_json()));
      final cubit = PanchangCubit(
        repo: repo,
        clock: () => DateTime(2026, 9, 13, 9),
      );
      await cubit.init();
      await cubit.setPlace(_varanasi);
      verify(() => repo.savePlace(_varanasi)).called(1);

      await cubit.shiftDays(1);
      expect(cubit.state.date, DateTime(2026, 9, 14));
      await cubit.setDate(DateTime(2030));
      expect(cubit.state.date, DateTime(2026, 9, 14));
    });
  });

  // --- page ---------------------------------------------------------------------

  Widget app(Widget child, Locale locale) {
    final bpRepo = _MockBpRepo();
    final store = _MockStore();
    return BlocProvider<BirthProfilesCubit>(
      create: (_) => BirthProfilesCubit(repo: bpRepo, store: store),
      child: MaterialApp(
        locale: locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: const Color(0xFFEA6A1E),
          extensions: const [BrandColors.light],
        ),
        home: child,
      ),
    );
  }

  for (final locale in const [Locale('en'), Locale('hi')]) {
    group('small phone · ${locale.languageCode}', () {
      setUp(() {
        TestWidgetsFlutterBinding.ensureInitialized()
            .platformDispatcher
            .views
            .first
          ..physicalSize = const Size(360, 740) * 3
          ..devicePixelRatio = 3;
      });
      tearDown(() {
        TestWidgetsFlutterBinding.instance.platformDispatcher.views.first
          ..resetPhysicalSize()
          ..resetDevicePixelRatio();
      });

      for (final today in [true, false]) {
        testWidgets('full page lays out (${today ? 'today' : 'other day'})', (
          tester,
        ) async {
          when(() => repo.savedPlace()).thenAnswer((_) async => _varanasi);
          when(() => repo.cached(any(), any())).thenReturn(null);
          when(
            () => repo.day(any(), any()),
          ).thenAnswer((_) async => DayPanchang.fromJson(_json()));
          await tester.pumpWidget(
            app(
              BlocProvider(
                create: (_) => PanchangCubit(
                  repo: repo,
                  initialDate: today ? null : DateTime(2026, 9, 13),
                )..init(),
                child: const PanchangPage(),
              ),
              locale,
            ),
          );
          await tester.pumpAndSettle(const Duration(seconds: 1));
          expect(tester.takeException(), isNull);

          await tester.drag(
            find.byType(CustomScrollView),
            const Offset(0, -900),
          );
          await tester.pumpAndSettle();
          final night = find.byIcon(Icons.nightlight_round);
          if (night.evaluate().isNotEmpty) {
            await tester.tap(night.last);
            await tester.pumpAndSettle();
          }
          await tester.drag(
            find.byType(CustomScrollView),
            const Offset(0, -3000),
          );
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
        });
      }

      testWidgets('no place → choose-city prompt', (tester) async {
        when(() => repo.savedPlace()).thenAnswer((_) async => null);
        await tester.pumpWidget(
          app(
            BlocProvider(
              create: (_) => PanchangCubit(repo: repo)..init(),
              child: const PanchangPage(),
            ),
            locale,
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        expect(find.byIcon(Icons.location_city_rounded), findsOneWidget);
      });
    });
  }
}
