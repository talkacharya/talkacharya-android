import 'package:astro/src/core/astro/models/astro_profile.dart';
import 'package:astro/src/core/astro/onboarding_store.dart';
import 'package:astro/src/core/availability/availability_coordinator.dart';
import 'package:astro/src/core/di/service_locator.dart';
import 'package:astro/src/core/l10n/l10n.dart';
import 'package:astro/src/core/router/routes.dart';
import 'package:astro/src/features/auth/data/models/auth_user.dart';
import 'package:astro/src/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:astro/src/features/home/presentation/view/widgets/dashboard_header.dart';
import 'package:astro/src/features/notifications/presentation/bloc/notifications_cubit.dart';
import 'package:astro/src/features/notifications/presentation/view/notification_bell.dart';
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

  @override
  bool get enabled => _on;

  @override
  String presence = 'offline';

  @override
  DateTime? breakEndsAt;

  @override
  bool get onBreak => false;

  @override
  Future<void> setEnabled(bool value) async {
    _on = value;
    presence = value ? 'online' : 'offline';
    notifyListeners();
  }

  @override
  Future<void> dispose() async => super.dispose();

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

const _topPad = 32.0;

void main() {
  late _FakeCoord coord;
  late ScrollController scroll;

  setUp(() {
    coord = _FakeCoord();
    scroll = ScrollController();
    getIt
      ..registerSingleton<OnboardingStore>(_FakeStore())
      ..registerSingleton<AvailabilityCoordinator>(coord);
  });

  tearDown(() async {
    scroll.dispose();
    await getIt.reset();
  });

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

    var body = DashboardHeaderDelegate.initialBodyHeight;
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (_, _) => StatefulBuilder(
            builder: (context, setState) => Scaffold(
              body: CustomScrollView(
                controller: scroll,
                slivers: [
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: DashboardHeaderDelegate(
                      topPad: MediaQuery.paddingOf(context).top,
                      bodyHeight: body,
                      onBodyMeasured: (h) => setState(() => body = h),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 2000)),
                ],
              ),
            ),
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
        ],
        child: MaterialApp.router(
          routerConfig: router,
          locale: locale,
          theme: ThemeData(extensions: const [BrandColors.light]),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(
              padding: const EdgeInsets.only(top: _topPad),
              textScaler: TextScaler.linear(textScale),
            ),
            child: child!,
          ),
        ),
      ),
    );
    // LiveDot pulses forever, so never pumpAndSettle.
    await tester.pump(const Duration(milliseconds: 300));
  }

  double headerHeight(WidgetTester tester) => tester
      .getSize(
        find
            .descendant(
              of: find.byType(SliverPersistentHeader),
              matching: find.byType(ClipRRect),
            )
            .first,
      )
      .height;

  /// Natural height of the expanded layout (it sits in an OverflowBox, so
  /// it's never squeezed to fit the header).
  double expandedContentHeight(WidgetTester tester) => tester
      .getSize(
        find
            .descendant(
              of: find.byType(OverflowBox),
              matching: find.byType(Padding),
            )
            .first,
      )
      .height;

  for (final locale in const [Locale('en'), Locale('hi')]) {
    for (final scale in const [1.0, 1.3, 2.0]) {
      testWidgets('collapses without clipping or overflow '
          '(${locale.languageCode}, text ×$scale)', (tester) async {
        await pump(tester, textScale: scale, locale: locale);
        final expanded = headerHeight(tester);
        expect(expandedContentHeight(tester), lessThanOrEqualTo(expanded));

        // Down through the collapse and back up again.
        final range = expanded - (_topPad + 60);
        for (final f in [0.2, 0.5, 0.7, 1.0, 1.5, 0.6, 0.3, 0.0]) {
          scroll.jumpTo(range * f);
          await tester.pump();
          expect(tester.takeException(), isNull);
        }
        expect(headerHeight(tester), expanded);

        scroll.jumpTo(range * 2);
        await tester.pump();
        expect(headerHeight(tester), _topPad + 60);
      });
    }
  }

  testWidgets('Go online is tappable while expanded', (tester) async {
    await pump(tester);
    await tester.tap(find.text('Go online'));
    await tester.pump();
    // The slider's label flips halfway through its travel, not on the tap.
    await tester.pump(const Duration(milliseconds: 300));
    expect(coord.enabled, isTrue);
    expect(find.text('Go offline'), findsOneWidget);
  });

  testWidgets('collapsed bar shows presence and its bell opens the inbox', (
    tester,
  ) async {
    await pump(tester);
    await coord.setEnabled(true);
    coord
      ..presence = 'busy'
      ..notifyListeners();
    scroll.jumpTo(1000);
    await tester.pump();

    // Panel title and compact status come from the same helper.
    expect(find.text("You're in a session"), findsNWidgets(2));

    // The expanded layer's bell is ignored now; only the bar's one is hit.
    await tester.tap(find.byType(NotificationBell).last);
    await tester.pumpAndSettle();
    expect(find.text('inbox'), findsOneWidget);
  });
}
