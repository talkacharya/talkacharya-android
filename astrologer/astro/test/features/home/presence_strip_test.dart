import 'package:astro/src/core/astro/models/astro_profile.dart';
import 'package:astro/src/core/astro/onboarding_store.dart';
import 'package:astro/src/core/availability/availability_coordinator.dart';
import 'package:astro/src/core/di/service_locator.dart';
import 'package:astro/src/core/l10n/l10n.dart';
import 'package:astro/src/core/router/routes.dart';
import 'package:astro/src/features/auth/data/models/auth_user.dart';
import 'package:astro/src/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:astro/src/features/home/presentation/view/widgets/home_header.dart';
import 'package:astro/src/features/notifications/presentation/bloc/notifications_cubit.dart';
import 'package:astro/src/features/notifications/presentation/view/notification_bell.dart';
import 'package:astro/src/features/performance/presentation/cubit/performance_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:talkacharya_ui/talkacharya_ui.dart';

class _MockAuthBloc extends MockBloc<AuthEvent, AuthState>
    implements AuthBloc {}

class _MockNotifications extends MockCubit<NotificationsState>
    implements NotificationsCubit {}

class _FakeStore extends ChangeNotifier implements OnboardingStore {
  @override
  AstroProfile? profile = AstroProfile.fromJson(const {
    'id': 'p1',
    'rating_avg': '4.8',
    'rating_count': 12,
    'followers_count': 340,
  });

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeCoord extends ChangeNotifier implements AvailabilityCoordinator {
  bool _on = false;
  String? refuse;

  @override
  bool get enabled => _on;

  @override
  String presence = 'offline';

  @override
  DateTime? breakEndsAt;

  @override
  bool get onBreak => false;

  @override
  Future<String?> setEnabled(bool value) async {
    if (refuse != null) return refuse;
    _on = value;
    presence = value ? 'online' : 'offline';
    notifyListeners();
    return null;
  }

  @override
  Future<void> dispose() async => super.dispose();

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// No break status loaded, so the break row stays out.
class _Perf extends Cubit<PerformanceState> implements PerformanceCubit {
  _Perf() : super(const PerformanceState());

  @override
  dynamic noSuchMethod(Invocation invocation) => Future<void>.value();
}

void main() {
  late _FakeCoord coord;

  setUp(() {
    coord = _FakeCoord();
    getIt
      ..registerSingleton<OnboardingStore>(_FakeStore())
      ..registerSingleton<AvailabilityCoordinator>(coord);
  });

  tearDown(() async => getIt.reset());

  Future<void> pump(
    WidgetTester tester, {
    double textScale = 1.0,
    Locale locale = const Locale('en'),
  }) async {
    // A narrow phone: text wraps the most here.
    tester.view
      ..physicalSize = const Size(1080, 2340)
      ..devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    final auth = _MockAuthBloc();
    whenListen(
      auth,
      const Stream<AuthState>.empty(),
      initialState: const AuthState.authenticated(
        AuthUser(id: 'u1', phone: '+91', displayName: 'Pandit Raghunath'),
      ),
    );
    final notifs = _MockNotifications();
    whenListen(
      notifs,
      const Stream<NotificationsState>.empty(),
      initialState: const NotificationsState(),
    );

    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, _) => Scaffold(
            appBar: homeAppBar(context),
            body: ListView(children: const [PresenceStrip()]),
          ),
        ),
        GoRoute(
          path: Routes.notifications,
          builder: (_, _) => const Text('inbox'),
        ),
      ],
    );

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>.value(value: auth),
          BlocProvider<NotificationsCubit>.value(value: notifs),
          BlocProvider<PerformanceCubit>(create: (_) => _Perf()),
        ],
        child: MaterialApp.router(
          routerConfig: router,
          locale: locale,
          theme: ThemeData(extensions: const [BrandColors.light]),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: TextScaler.linear(textScale)),
            child: child!,
          ),
        ),
      ),
    );
    // LiveDot pulses forever, so never pumpAndSettle.
    await tester.pump(const Duration(milliseconds: 300));
  }

  for (final locale in const [Locale('en'), Locale('hi')]) {
    for (final scale in const [1.0, 1.3, 2.0]) {
      testWidgets('lays out without overflow '
          '(${locale.languageCode}, text ×$scale)', (tester) async {
        await pump(tester, textScale: scale, locale: locale);
        expect(tester.takeException(), isNull);
        await coord.setEnabled(true);
        await tester.pump();
        expect(tester.takeException(), isNull);
      });
    }
  }

  testWidgets('the switch takes them online and back', (tester) async {
    await pump(tester);
    expect(find.text("You're offline"), findsOneWidget);
    // Offline, followers hear when they come on.
    expect(find.textContaining('340 followers'), findsOneWidget);

    await tester.tap(find.byType(Switch));
    await tester.pump();
    expect(coord.enabled, isTrue);
    expect(find.text("You're online"), findsOneWidget);

    await tester.tap(find.byType(Switch));
    await tester.pump();
    expect(coord.enabled, isFalse);
  });

  testWidgets('a refused switch says why and stays off', (tester) async {
    coord.refuse = 'Finish your training first';
    await pump(tester);
    await tester.tap(find.byType(Switch));
    await tester.pump();
    expect(coord.enabled, isFalse);
    expect(find.text('Finish your training first'), findsOneWidget);
  });

  testWidgets('the app bar shows the rating and its bell opens the inbox', (
    tester,
  ) async {
    await pump(tester);
    expect(find.text('Pandit Raghunath'), findsOneWidget);
    expect(find.text('4.8'), findsOneWidget);

    await tester.tap(find.byType(NotificationBell));
    await tester.pumpAndSettle();
    expect(find.text('inbox'), findsOneWidget);
  });
}
