import 'package:astro/src/core/availability/availability_coordinator.dart';
import 'package:astro/src/core/l10n/l10n.dart';
import 'package:astro/src/core/util/amount_privacy.dart';
import 'package:astro/src/core/util/async_value.dart';
import 'package:astro/src/features/home/presentation/view/widgets/break_card.dart';
import 'package:astro/src/features/home/presentation/view/widgets/earning_club_banner.dart';
import 'package:astro/src/features/home/presentation/view/widgets/today_pulse_card.dart';
import 'package:astro/src/features/performance/data/performance_api.dart';
import 'package:astro/src/features/performance/data/performance_models.dart';
import 'package:astro/src/features/performance/presentation/cubit/performance_cubit.dart';
import 'package:astro/src/features/performance/presentation/view/performance_page.dart';
import 'package:astro/src/features/performance/presentation/widgets/band_meter.dart';
import 'package:astro/src/features/performance/presentation/widgets/perf_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:talkacharya_ui/talkacharya_ui.dart';

class _MockApi extends Mock implements PerformanceApi {}

class _MockAvailability extends Mock implements AvailabilityCoordinator {}

class _MockStorage extends Mock implements FlutterSecureStorage {}

Map<String, dynamic> _metric(
  String key,
  String unit,
  num value,
  num previous,
  List<num> bands,
  num max,
  String band, {
  bool lower = false,
  int sample = 5,
}) => {
  'key': key,
  'unit': unit,
  'value': value,
  'previous': previous,
  'sample': sample,
  'bands': bands,
  'max': max,
  'lower_is_better': lower,
  'band': band,
};

final _json = <String, dynamic>{
  'window_days': 15,
  'updated_at': '2026-10-06T08:00:00+00:00',
  'metrics': [
    _metric('first_repeat', 'percent', 26.7, 20, [25, 32], 100, 'mid'),
    _metric('total_repeat', 'percent', 24.8, 30, [38, 45], 100, 'low'),
    _metric('avg_session', 'seconds', 443, 400, [600, 900], 3600, 'low'),
    _metric(
      'online_time',
      'seconds',
      41280,
      30000,
      [21600, 32400],
      86400,
      'good',
    ),
    _metric('missed', 'count', 3, 6, [3, 8], 15, 'mid', lower: true),
  ],
  'focus': 'avg_session',
  'loyal': {
    'percent': 11.0,
    'previous': 14.0,
    'count': 2,
    'customers': 18,
    'min_minutes': 15,
  },
  'sessions': 31,
  'missed': {
    'total': 3,
    'unanswered': 2,
    'declined': 1,
    'by_channel': {'voice': 3},
  },
  'online_by_day': [
    {'day': '2026-10-04', 'seconds': 30000},
    {'day': '2026-10-05', 'seconds': 0},
    {'day': '2026-10-06', 'seconds': 12000},
  ],
  'ratings': {
    'overall': {'avg': 4.67, 'count': 120},
    'by_channel': {
      'chat': {'avg': 4.51, 'count': 80},
      'voice': {'avg': 4.84, 'count': 40},
    },
  },
  'today': {
    'currency': 'INR',
    'gross': '1500.00',
    'net': '1240.00',
    'sessions': 4,
    'minutes': 52,
    'online_seconds': 15000,
  },
  'club': {
    'currency': 'INR',
    'month_to_date': '14500.00',
    'projected': '77000.00',
    'tier': 75000,
    'next_tier': 100000,
    'needed_today': 57,
    'progress': 0.08,
  },
};

Performance _perf() => Performance.fromJson(_json);

BreakStatus _break({DateTime? endsAt, int left = 3}) => BreakStatus(
  endsAt: endsAt,
  startedAt: endsAt?.subtract(const Duration(minutes: 10)),
  usedToday: 3 - left,
  limit: 3,
  left: left,
  durations: const [5, 10, 15, 30],
);

Widget _app(Widget child, PerformanceCubit cubit) => MaterialApp(
  theme: ThemeData(extensions: const [BrandColors.light]),
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: Scaffold(
    body: BlocProvider<PerformanceCubit>.value(
      value: cubit,
      child: SingleChildScrollView(child: child),
    ),
  ),
);

void main() {
  final l = lookupAppLocalizations(const Locale('en'));

  group('Performance.fromJson', () {
    test('parses meters, loyalty, today and the club', () {
      final p = _perf();
      expect(p.windowDays, 15);
      expect(p.metrics, hasLength(5));
      expect(p.metric(PerfKeys.firstRepeat)!.band, PerfBand.mid);
      expect(p.metric(PerfKeys.onlineTime)!.bands, [21600, 32400]);
      expect(p.focus, PerfKeys.avgSession);
      expect(p.loyal.percent, 11);
      expect(p.missed.byChannel, {'voice': 3});
      expect(p.onlineByDay.last.seconds, 12000);
      expect(p.ratingByChannel['voice']!.avg, 4.84);
      expect(p.today.net, 1240);
      expect(p.club!.tier, 75000);
      expect(p.club!.neededToday, 57);
    });

    test('tolerates an empty payload', () {
      final p = Performance.fromJson(const {});
      expect(p.metrics, isEmpty);
      expect(p.club, isNull);
      expect(p.today.net, 0);
    });

    test('a falling missed count is an improvement', () {
      final p = _perf();
      expect(p.metric(PerfKeys.missed)!.improvement, 3);
      expect(p.metric(PerfKeys.totalRepeat)!.improvement, closeTo(-5.2, 0.01));
    });
  });

  group('formatting', () {
    test('durations keep their two biggest units', () {
      expect(formatDuration(l, 41280), '11h 28m');
      expect(formatDuration(l, 443), '7m 23s');
      expect(formatDuration(l, 45), '45s');
    });

    test('club names are round figures', () {
      expect(compactMoney(75000, 'INR'), '₹75K');
      expect(compactMoney(150000, 'INR'), '₹1.5L');
      expect(compactMoney(2000, 'USD'), r'$2K');
      expect(compactMoney(500, 'INR'), '₹500');
    });
  });

  group('BandMeter.position', () {
    final m = _perf().metric(PerfKeys.firstRepeat)!; // cut points 25, 32 of 100

    test('each zone takes a third of the track', () {
      expect(BandMeter.position(m, 0), 0);
      expect(BandMeter.position(m, 25), closeTo(1 / 3, 1e-9));
      expect(BandMeter.position(m, 32), closeTo(2 / 3, 1e-9));
      expect(BandMeter.position(m, 100), 1);
    });

    test('a reading sits proportionally inside its zone', () {
      expect(BandMeter.position(m, 12.5), closeTo(1 / 6, 1e-9));
      expect(BandMeter.position(m, 28.5), closeTo(0.5, 1e-9));
      expect(BandMeter.position(m, 500), 1);
    });
  });

  group('PerformanceCubit', () {
    late _MockApi api;
    late _MockAvailability availability;

    setUp(() {
      api = _MockApi();
      availability = _MockAvailability();
      when(() => availability.refresh()).thenAnswer((_) async {});
      when(() => api.performance()).thenAnswer((_) async => _perf());
      when(() => api.breakStatus()).thenAnswer((_) async => _break());
    });

    PerformanceCubit build() =>
        PerformanceCubit(api: api, availability: availability);

    test('load fills the scorecard and the break allowance', () async {
      final cubit = build();
      await cubit.load();
      expect(cubit.state.performance.value?.sessions, 31);
      expect(cubit.state.breaks.value?.left, 3);
      await cubit.close();
    });

    test('one failing slice does not blank the other', () async {
      when(() => api.performance()).thenThrow(Exception('boom'));
      final cubit = build();
      await cubit.load();
      expect(cubit.state.performance.isError, isTrue);
      expect(cubit.state.breaks.value?.limit, 3);
      await cubit.close();
    });

    test(
      'starting a break updates the allowance and re-reads presence',
      () async {
        final endsAt = DateTime.now().add(const Duration(minutes: 10));
        when(
          () => api.startBreak(10),
        ).thenAnswer((_) async => _break(endsAt: endsAt, left: 2));
        final cubit = build();
        await cubit.load();

        expect(await cubit.startBreak(10), isNull);

        expect(cubit.state.breaks.value!.onBreak, isTrue);
        expect(cubit.state.breaks.value!.left, 2);
        expect(cubit.state.breakBusy, isFalse);
        verify(() => availability.refresh()).called(1);
        await cubit.close();
      },
    );

    test('a refused break reports why and changes nothing', () async {
      when(() => api.startBreak(10)).thenThrow(Exception('no breaks left'));
      final cubit = build();
      await cubit.load();

      expect(await cubit.startBreak(10), isNotNull);

      expect(cubit.state.breaks.value!.onBreak, isFalse);
      expect(cubit.state.breakBusy, isFalse);
      verifyNever(() => availability.refresh());
      await cubit.close();
    });
  });

  group('widgets', () {
    late _MockAvailability availability;

    setUp(() {
      final storage = _MockStorage();
      when(
        () => storage.read(key: any(named: 'key')),
      ).thenAnswer((_) async => null);
      when(
        () => storage.write(
          key: any(named: 'key'),
          value: any(named: 'value'),
        ),
      ).thenAnswer((_) async {});
      availability = _MockAvailability();
      when(() => availability.enabled).thenReturn(true);
      GetIt.I
        ..registerSingleton<AmountPrivacy>(AmountPrivacy(storage))
        ..registerSingleton<AvailabilityCoordinator>(availability);
    });

    tearDown(GetIt.I.reset);

    testWidgets('club banner names the club and what today needs', (
      tester,
    ) async {
      final cubit = _FixedCubit(
        PerformanceState(performance: AsyncValue.data(_perf())),
      );
      await tester.pumpWidget(_app(const EarningClubBanner(), cubit));
      await tester.pump(const Duration(seconds: 1));

      expect(find.text("You're in the ₹75K club"), findsOneWidget);
      expect(find.textContaining('Earn ₹57 more today'), findsOneWidget);
      expect(find.textContaining('₹1L club'), findsOneWidget);
      expect(find.text('On pace for ₹77,000 this month'), findsOneWidget);
    });

    testWidgets('today card masks the amount on the eye toggle', (
      tester,
    ) async {
      final cubit = _FixedCubit(
        PerformanceState(performance: AsyncValue.data(_perf())),
      );
      await tester.pumpWidget(_app(const TodayPulseCard(), cubit));
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('₹1,240'), findsOneWidget);
      expect(find.text('11h'), findsOneWidget); // online per day
      expect(find.text('27%'), findsOneWidget); // first-time repeat

      await tester.tap(find.byTooltip('Hide amounts'));
      // One frame to start the cross-fade, one to finish it.
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.text('₹1,240'), findsNothing);
      expect(find.byTooltip('Show amounts'), findsOneWidget);
    });

    testWidgets('break card offers a break only while online', (tester) async {
      final cubit = _FixedCubit(
        PerformanceState(breaks: AsyncValue.data(_break(left: 2))),
      );
      await tester.pumpWidget(_app(const BreakCard(), cubit));
      expect(find.text('2 breaks left today'), findsOneWidget);

      when(() => availability.enabled).thenReturn(false);
      await tester.pumpWidget(_app(const BreakCard(key: ValueKey(2)), cubit));
      expect(find.text('2 breaks left today'), findsNothing);
    });

    testWidgets('break card counts down a running break', (tester) async {
      final cubit = _FixedCubit(
        PerformanceState(
          breaks: AsyncValue.data(
            _break(
              endsAt: DateTime.now().add(const Duration(minutes: 8)),
              left: 2,
            ),
          ),
        ),
      );
      await tester.pumpWidget(_app(const BreakCard(), cubit));
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('On a break'), findsOneWidget);
      expect(find.text("I'm back"), findsOneWidget);
      expect(find.textContaining('Back online in 0'), findsOneWidget);
      // Let the ticking timer go with the widget.
      await tester.pumpWidget(const SizedBox());
    });

    testWidgets('performance page shows every meter and explains one', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 6000);
      tester.view.devicePixelRatio = 2;
      addTearDown(tester.view.reset);
      GetIt.I.registerFactory<PerformanceCubit>(
        () => _FixedCubit(
          PerformanceState(performance: AsyncValue.data(_perf())),
        ),
      );
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(extensions: const [BrandColors.light]),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const PerformancePage(),
        ),
      );
      await tester.pump(const Duration(seconds: 2));

      expect(find.byType(BandMeter), findsNWidgets(5));
      expect(find.text('First-time repeat'), findsOneWidget);
      expect(find.text('7m 23s'), findsOneWidget);
      expect(find.text('11h 28m'), findsOneWidget);
      expect(find.text('Almost there'), findsNWidgets(2));
      expect(find.text('Timed out · 2'), findsOneWidget);
      expect(find.text('4.84'), findsOneWidget);
      expect(find.text('Where to focus'), findsOneWidget);

      expect(find.textContaining('Example: 10 new customers'), findsNothing);
      await tester.tap(find.text("How it's calculated").first);
      await tester.pump(const Duration(milliseconds: 400));
      expect(find.textContaining('Example: 10 new customers'), findsOneWidget);
    });
  });
}

/// A cubit frozen at one state, for widget tests.
class _FixedCubit extends Cubit<PerformanceState> implements PerformanceCubit {
  _FixedCubit(super.initial);

  @override
  dynamic noSuchMethod(Invocation invocation) => Future<void>.value();
}
