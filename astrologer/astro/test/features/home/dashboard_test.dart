import 'dart:async';

import 'package:astro/src/core/astro/models/astro_profile.dart';
import 'package:astro/src/core/astro/onboarding_store.dart';
import 'package:astro/src/core/l10n/l10n.dart';
import 'package:astro/src/core/realtime/realtime_client.dart';
import 'package:astro/src/core/realtime/realtime_event.dart';
import 'package:astro/src/core/router/routes.dart';
import 'package:astro/src/core/theme/brand_colors.dart';
import 'package:astro/src/core/util/async_value.dart';
import 'package:astro/src/features/consultations/data/consultation_api.dart';
import 'package:astro/src/features/consultations/data/models/consultation.dart';
import 'package:astro/src/features/home/data/dashboard_api.dart';
import 'package:astro/src/features/home/data/dashboard_models.dart';
import 'package:astro/src/features/home/presentation/cubit/dashboard_cubit.dart';
import 'package:astro/src/features/home/presentation/view/widgets/earnings_card.dart';
import 'package:astro/src/features/home/presentation/view/widgets/profile_strength_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockApi extends Mock implements DashboardApi {}

class _MockConsultations extends Mock implements ConsultationApi {}

class _MockStore extends Mock implements OnboardingStore {}

class _MockRealtime extends Mock implements RealtimeClient {}

const _statsJson = {
  'window_days': 7,
  'earnings': {'gross': '1500.00', 'net': '1200.00', 'commission': '300.00'},
  'consultations': {
    'requested': 10,
    'completed': 8,
    'acceptance_rate': 90.0,
    'completion_rate': 88.9,
    'minutes': 95.5,
  },
  'rating': {'avg': 0, 'count': 0},
  'repeat_client_rate': 25.0,
  'lifetime': {
    'rating_avg': '4.60',
    'consultations': 120,
    'response_rate': '0.9',
  },
  'net_trend': [
    {'day': '2026-09-10', 'value': '200.00', 'count': 2},
    {'day': '2026-09-11', 'value': '350.50', 'count': 3},
  ],
};

DashboardStats _stats([int days = 7]) =>
    DashboardStats.fromJson({..._statsJson, 'window_days': days});

Consultation _consult(String id) =>
    Consultation.fromJson({'id': id, 'customer_name': 'Asha'});

AstroProfile _profile({
  String headline = '',
  String bio = '',
  List<Map<String, dynamic>> rates = const [],
}) => AstroProfile.fromJson({
  'id': 'p1',
  'headline': headline,
  'bio': bio,
  'rates': rates,
  'languages': ['hi'],
  'skills': [
    {'slug': 'vedic'},
    {'slug': 'tarot'},
    {'slug': 'numerology'},
  ],
});

void main() {
  group('DashboardStats.fromJson', () {
    test('parses decimal strings, percentages and the trend', () {
      final s = _stats();
      expect(s.net, 1200);
      expect(s.gross, 1500);
      expect(s.commission, 300);
      expect(s.completed, 8);
      expect(s.acceptanceRate, 90);
      expect(s.minutes, 95.5);
      expect(s.repeatClientRate, 25);
      expect(s.trend.map((p) => p.value), [200, 350.5]);
      expect(s.trend.first.day, DateTime(2026, 9, 10));
    });

    test('falls back to the lifetime rating when the window has none', () {
      expect(_stats().ratingAvg, 4.6);
    });

    test('tolerates an empty payload', () {
      final s = DashboardStats.fromJson(const {});
      expect(s.net, 0);
      expect(s.trend, isEmpty);
    });
  });

  group('PayoutSummary.fromJson', () {
    test('reads the first currency row', () {
      final p = PayoutSummary.fromJson({
        'by_currency': [
          {
            'currency': 'INR',
            'available_to_pay': '812.40',
            'pending_clearance': '100',
            'lifetime_net': '9000',
          },
        ],
      });
      expect(p.available, 812.4);
      expect(p.pending, 100);
      expect(p.lifetime, 9000);
    });

    test('is empty with no rows', () {
      expect(
        PayoutSummary.fromJson({'by_currency': []}),
        const PayoutSummary.empty(),
      );
    });
  });

  group('profileTips', () {
    test('flags missing headline, bio, banner and rates', () {
      final tips = profileTips(_profile());
      expect(tips.map((t) => t.done), [false, false, false, false, true, true]);
      expect(tips[3].route, Routes.profileRates);
    });

    test('a short bio does not count', () {
      expect(profileTips(_profile(bio: 'short'))[1].done, isFalse);
      expect(profileTips(_profile(bio: 'x' * 120))[1].done, isTrue);
    });
  });

  group('DashboardCubit', () {
    late _MockApi api;
    late _MockConsultations consultations;
    late _MockStore store;
    late StreamController<RealtimeEvent> events;

    setUp(() {
      api = _MockApi();
      consultations = _MockConsultations();
      store = _MockStore();
      events = StreamController<RealtimeEvent>.broadcast();
      when(() => store.refresh()).thenAnswer((_) async {});
      when(
        () => api.stats(days: any(named: 'days')),
      ).thenAnswer((i) async => _stats(i.namedArguments[#days] as int));
      when(
        () => api.payouts(),
      ).thenAnswer((_) async => const PayoutSummary.empty());
      when(
        () => consultations.incoming(),
      ).thenAnswer((_) async => [_consult('r1'), _consult('r2')]);
      when(
        () => consultations.list(status: 'active'),
      ).thenAnswer((_) async => []);
    });

    tearDown(() => events.close());

    DashboardCubit build() {
      final rt = _MockRealtime();
      when(() => rt.events).thenAnswer((_) => events.stream);
      return DashboardCubit(
        api: api,
        consultations: consultations,
        onboarding: store,
        realtime: rt,
      );
    }

    test('load fills every slice independently', () async {
      when(() => api.payouts()).thenThrow(Exception('boom'));
      final cubit = build();
      await cubit.load();
      expect(cubit.state.stats.value?.net, 1200);
      expect(cubit.state.payouts.isError, isTrue);
      expect(cubit.state.incoming.value, hasLength(2));
      expect(cubit.state.active.value, isEmpty);
      await cubit.close();
    });

    test('setPeriod refetches stats for the new window', () async {
      final cubit = build();
      await cubit.setPeriod(30);
      expect(cubit.state.period, 30);
      expect(cubit.state.stats.value?.windowDays, 30);
      verify(() => api.stats(days: 30)).called(1);
      await cubit.close();
    });

    test('drops a stats response for a period switched away from', () async {
      final slow = Completer<DashboardStats>();
      when(() => api.stats(days: 30)).thenAnswer((_) => slow.future);
      final cubit = build();
      final pending = cubit.setPeriod(30);
      await cubit.setPeriod(90);
      slow.complete(_stats(30));
      await pending;
      expect(cubit.state.period, 90);
      expect(cubit.state.stats.value?.windowDays, 90);
      await cubit.close();
    });

    test('RequestRemoved drops the request without refetching', () async {
      final cubit = build();
      await cubit.load();
      clearInteractions(consultations);
      events.add(const RequestRemoved(consultationId: 'r1', reason: 'expired'));
      await Future<void>.delayed(Duration.zero);
      expect(cubit.state.incoming.value!.map((c) => c.id), ['r2']);
      verifyNever(() => consultations.incoming());
      await cubit.close();
    });
  });

  group('EarningsCard', () {
    Future<void> pump(WidgetTester tester, DashboardState state) async {
      final cubit = _FixedCubit(state);
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(extensions: const [BrandColors.light]),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: BlocProvider<DashboardCubit>.value(
              value: cubit,
              child: const SingleChildScrollView(child: EarningsCard()),
            ),
          ),
        ),
      );
      // Skeleton shimmer never settles; the count-up/sparkline finish in <1s.
      await tester.pump(const Duration(seconds: 1));
    }

    testWidgets('shows net earnings, fee split and payout balance', (
      tester,
    ) async {
      await pump(
        tester,
        DashboardState(
          stats: AsyncValue.data(_stats()),
          payouts: const AsyncValue.data(
            PayoutSummary(
              currency: 'INR',
              available: 812,
              pending: 0,
              lifetime: 0,
            ),
          ),
        ),
      );
      expect(find.text('₹1,200'), findsOneWidget);
      expect(find.textContaining('Platform fee ₹300'), findsOneWidget);
      expect(find.text('₹812'), findsOneWidget);
      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('shows a retry row when stats fail', (tester) async {
      await pump(tester, const DashboardState(stats: AsyncValue.error('nope')));
      expect(find.text('Retry'), findsOneWidget);
    });
  });
}

/// A cubit frozen at one state, for widget tests.
class _FixedCubit extends Cubit<DashboardState> implements DashboardCubit {
  _FixedCubit(super.initial);

  @override
  dynamic noSuchMethod(Invocation invocation) => Future<void>.value();
}
