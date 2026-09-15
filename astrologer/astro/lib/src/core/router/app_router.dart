import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../app/view/splash_page.dart';
import '../../features/auth/presentation/bloc/auth/auth_bloc.dart';
import '../../features/auth/presentation/view/login_page.dart';
import '../../features/consultations/presentation/view/consultation_room_page.dart';
import '../../features/earnings/presentation/view/earnings_page.dart';
import '../../features/earnings/presentation/view/payout_detail_page.dart';
import '../../features/home/presentation/view/home_page.dart';
import '../../features/kundali/presentation/view/chart_detail_page.dart';
import '../../features/kundali/presentation/view/consultation_kundali_page.dart';
import '../../features/notifications/presentation/view/notifications_page.dart';
import '../../features/onboarding/presentation/view/onboarding_gate_page.dart';
import '../../features/onboarding/presentation/view/wizard_page.dart';
import '../../features/predictions/presentation/view/prediction_work_page.dart';
import '../../features/predictions/presentation/view/predictions_queue_page.dart';
import '../../features/profile/presentation/view/edit_profile_page.dart';
import '../../features/profile/presentation/view/kyc_page.dart';
import '../../features/profile/presentation/view/profile_page.dart';
import '../../features/profile/presentation/view/rates_page.dart';
import '../../features/profile/presentation/view/reviews_page.dart';
import '../../features/profile/presentation/view/working_hours_page.dart';
import '../../features/requests/presentation/view/request_detail_page.dart';
import '../../features/requests/presentation/view/requests_page.dart';
import '../../features/shell/presentation/view/app_shell.dart';
import '../astro/onboarding_store.dart';
import 'go_router_refresh.dart';
import 'pending_deep_link.dart';
import 'routes.dart';

final _rootKey = GlobalKey<NavigatorState>();

GoRoute _leaf(String path, Widget Function(GoRouterState) child) =>
    GoRoute(path: path, builder: (_, s) => child(s));

/// Route table + auth gate + onboarding gate + deferred deep-link replay.
GoRouter buildRouter(
  AuthBloc authBloc,
  PendingDeepLink pending,
  OnboardingStore onboarding,
) {
  return GoRouter(
    navigatorKey: _rootKey,
    initialLocation: Routes.splash,
    refreshListenable: Listenable.merge([
      GoRouterRefreshStream(authBloc.stream),
      onboarding,
    ]),
    redirect: (context, state) {
      final status = authBloc.state.status;
      final loc = state.matchedLocation;
      final atLogin = loc == Routes.login;
      final atSplash = loc == Routes.splash;

      if (status == AuthStatus.unknown) return atSplash ? null : Routes.splash;

      final loggedIn = status == AuthStatus.authenticated;
      if (!loggedIn) {
        if (!atLogin && !atSplash) pending.set(state.uri.toString());
        return atLogin ? null : Routes.login;
      }

      // Onboarding gate: anything but `approved` stays on /onboarding.
      final atOnboarding = loc.startsWith(Routes.onboarding);
      final approved = onboarding.stage == OnboardingStage.approved;
      if (onboarding.stage == OnboardingStage.loading) {
        return atSplash ? null : Routes.splash;
      }
      if (!approved) return atOnboarding ? null : Routes.onboarding;

      if (atLogin || atSplash || atOnboarding) {
        return pending.take() ?? Routes.home;
      }
      return null;
    },
    routes: [
      GoRoute(path: Routes.splash, builder: (_, _) => const SplashPage()),
      GoRoute(path: Routes.login, builder: (_, _) => const LoginPage()),

      GoRoute(
        path: Routes.onboarding,
        parentNavigatorKey: _rootKey,
        builder: (_, _) => const OnboardingGatePage(),
        routes: [_leaf('wizard', (_) => const WizardPage())],
      ),

      GoRoute(
        path: Routes.notifications,
        parentNavigatorKey: _rootKey,
        builder: (_, _) => const NotificationsPage(),
      ),
      GoRoute(
        path: '/chats/:id',
        parentNavigatorKey: _rootKey,
        builder: (_, s) =>
            ConsultationRoomPage(consultationId: s.pathParameters['id']!),
      ),
      GoRoute(
        path: '/requests/:id',
        parentNavigatorKey: _rootKey,
        builder: (_, s) =>
            RequestDetailPage(consultationId: s.pathParameters['id']!),
      ),
      GoRoute(
        path: '/consultations/:id/kundali',
        parentNavigatorKey: _rootKey,
        builder: (_, s) => ConsultationKundaliPage(
          consultationId: s.pathParameters['id']!,
          clientName: s.extra is String ? s.extra as String : null,
        ),
      ),
      GoRoute(
        path: '/consultations/:id/kundali/chart/:type',
        parentNavigatorKey: _rootKey,
        builder: (_, s) => ChartDetailPage(
          consultationId: s.pathParameters['id']!,
          type: s.pathParameters['type']!,
        ),
      ),
      GoRoute(
        path: '/earnings/payouts/:id',
        parentNavigatorKey: _rootKey,
        builder: (_, s) => PayoutDetailPage(payoutId: s.pathParameters['id']!),
      ),
      GoRoute(
        path: '/predictions',
        parentNavigatorKey: _rootKey,
        builder: (_, _) => const PredictionsQueuePage(),
      ),
      GoRoute(
        path: '/predictions/:id',
        parentNavigatorKey: _rootKey,
        builder: (_, s) =>
            PredictionWorkPage(id: s.pathParameters['id']!),
      ),

      StatefulShellRoute.indexedStack(
        builder: (_, _, shell) => AppShell(navigationShell: shell),
        branches: [
          StatefulShellBranch(
            routes: [_leaf(Routes.home, (_) => const HomePage())],
          ),
          StatefulShellBranch(
            routes: [_leaf(Routes.requests, (_) => const RequestsPage())],
          ),
          StatefulShellBranch(
            routes: [_leaf(Routes.earnings, (_) => const EarningsPage())],
          ),
          StatefulShellBranch(
            routes: [_leaf(Routes.chats, (_) => const _ChatsTab())],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.profile,
                builder: (_, _) => const ProfilePage(),
                routes: [
                  _leaf('edit', (_) => const EditProfilePage()),
                  _leaf('rates', (_) => const RatesPage()),
                  _leaf('working-hours', (_) => const WorkingHoursPage()),
                  _leaf('reviews', (_) => const ReviewsPage()),
                  _leaf('kyc', (_) => const KycPage()),
                  _leaf('featured', (_) => const _FeaturedStub()),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

// Chats tab currently reuses the consultations list; a dedicated widget keeps the
// route tree readable.
class _ChatsTab extends StatelessWidget {
  const _ChatsTab();
  @override
  Widget build(BuildContext context) => const RequestsPage(initialTab: 1);
}

class _FeaturedStub extends StatelessWidget {
  const _FeaturedStub();
  @override
  Widget build(BuildContext context) => const _Stub('Featured slots');
}

class _Stub extends StatelessWidget {
  const _Stub(this.label);
  final String label;
  @override
  Widget build(BuildContext context) =>
      Center(child: Text('$label — coming soon'));
}
