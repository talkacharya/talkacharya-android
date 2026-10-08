import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../app/view/splash_page.dart';
import '../../features/auth/presentation/bloc/auth/auth_bloc.dart';
import '../../features/auth/presentation/view/login_page.dart';
import '../../features/chats/presentation/view/chats_page.dart';
import '../../features/consultations/presentation/view/consultation_room_page.dart';
import '../../features/consultations/presentation/view/match_report_page.dart';
import '../../features/earnings/presentation/view/earnings_page.dart';
import '../../features/earnings/presentation/view/payout_detail_page.dart';
import '../../features/home/presentation/view/home_page.dart';
import '../../features/livestream/presentation/view/go_live_page.dart';
import '../../features/kundali/presentation/view/chart_detail_page.dart';
import '../../features/kundali/presentation/view/consultation_kundali_page.dart';
import '../../features/performance/presentation/view/performance_page.dart';
import '../../features/performance/presentation/view/win_back_page.dart';
import '../../features/call_history/presentation/view/call_history_page.dart';
import '../../features/remedies/presentation/view/advise_remedy_page.dart';
import '../../features/remedies/data/remedies_api.dart';
import '../../features/remedies/presentation/view/pooja_pages.dart';
import '../../features/remedies/presentation/view/remedies_page.dart';
import '../../features/remedies/presentation/view/suggest_remedy_page.dart';
import '../../features/reports/presentation/view/reports_pages.dart';
import '../../features/waitlist/presentation/view/waitlist_page.dart';
import '../../features/home/presentation/view/tools_page.dart';
import '../../features/workspace/presentation/view/calendar_page.dart';
import '../../features/workspace/presentation/view/notices_pages.dart';
import '../../features/workspace/presentation/view/offers_page.dart';
import '../../features/workspace/presentation/view/people_pages.dart';
import '../../features/workspace/presentation/view/studio_pages.dart';
import '../../features/client_charts/presentation/view/client_charts_pages.dart';
import '../../features/notifications/presentation/view/notifications_page.dart';
import '../../features/onboarding/presentation/view/onboarding_gate_page.dart';
import '../../features/onboarding/presentation/view/wizard_page.dart';
import '../../features/predictions/presentation/view/prediction_work_page.dart';
import '../../features/predictions/presentation/view/predictions_queue_page.dart';
import '../../features/profile/presentation/view/edit_profile_page.dart';
import '../../features/profile/presentation/view/featured_slots_page.dart';
import '../../features/profile/presentation/view/kyc_page.dart';
import '../../features/profile/presentation/view/profile_page.dart';
import '../../features/profile/presentation/view/rates_page.dart';
import '../../features/profile/presentation/view/reviews_page.dart';
import '../../features/profile/presentation/view/working_hours_page.dart';
import '../../features/requests/presentation/view/incoming_call_page.dart';
import '../../features/requests/presentation/view/request_detail_page.dart';
import '../../features/requests/presentation/view/requests_page.dart';
import '../../features/shell/presentation/view/app_shell.dart';
import '../astro/onboarding_store.dart';
import 'go_router_refresh.dart';
import 'pending_deep_link.dart';
import 'transitions.dart';
import 'routes.dart';
import '../../features/profile/presentation/view/sound_settings_page.dart';
import '../../features/profile/presentation/view/call_setup_page.dart';
import '../../features/profile/presentation/view/delete_account_page.dart';
import '../../features/profile/presentation/view/public_profile_page.dart';

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
        routes: [
          _leaf(
            'wizard',
            (s) => WizardPage(initialStep: s.uri.queryParameters['step']),
          ),
        ],
      ),

      GoRoute(
        path: Routes.incomingCall,
        parentNavigatorKey: _rootKey,
        builder: (_, s) => IncomingCallPage(
          data: switch (s.extra) {
            final Map<String, dynamic> data => data,
            _ => const {},
          },
        ),
      ),
      GoRoute(
        path: Routes.goLive,
        parentNavigatorKey: _rootKey,
        builder: (_, _) => const GoLivePage(),
      ),
      GoRoute(
        path: Routes.tools,
        parentNavigatorKey: _rootKey,
        builder: (_, _) => const ToolsPage(),
      ),
      GoRoute(
        path: Routes.announcements,
        parentNavigatorKey: _rootKey,
        builder: (_, _) => const AnnouncementsPage(),
      ),
      GoRoute(
        path: Routes.training,
        parentNavigatorKey: _rootKey,
        builder: (_, _) => const TrainingPage(),
      ),
      GoRoute(
        path: Routes.favourites,
        parentNavigatorKey: _rootKey,
        builder: (_, _) => const FavouritesPage(),
      ),
      GoRoute(
        path: Routes.community,
        parentNavigatorKey: _rootKey,
        builder: (_, _) => const CommunityPage(),
      ),
      GoRoute(
        path: Routes.referral,
        parentNavigatorKey: _rootKey,
        builder: (_, _) => const ReferralPage(),
      ),
      GoRoute(
        path: Routes.offers,
        parentNavigatorKey: _rootKey,
        builder: (_, _) => const OffersPage(),
      ),
      GoRoute(
        path: Routes.gallery,
        parentNavigatorKey: _rootKey,
        builder: (_, _) => const GalleryPage(),
      ),
      GoRoute(
        path: Routes.feedback,
        parentNavigatorKey: _rootKey,
        builder: (_, _) => const FeedbackPage(),
      ),
      GoRoute(
        path: Routes.quickReplies,
        parentNavigatorKey: _rootKey,
        builder: (_, _) => const QuickRepliesPage(),
      ),
      GoRoute(
        path: Routes.calendar,
        parentNavigatorKey: _rootKey,
        builder: (_, _) => const CalendarPage(),
      ),
      GoRoute(
        path: Routes.clientCharts,
        parentNavigatorKey: _rootKey,
        builder: (_, _) => const ClientChartsPage(),
      ),
      GoRoute(
        path: Routes.clientChartNew,
        parentNavigatorKey: _rootKey,
        builder: (_, _) => const NewClientChartPage(),
      ),
      GoRoute(
        path: '/client-charts/:id/kundali',
        parentNavigatorKey: _rootKey,
        builder: (_, s) => ConsultationKundaliPage(
          consultationId: s.pathParameters['id']!,
          clientName: s.extra is String ? s.extra as String : null,
          standalone: true,
        ),
      ),
      GoRoute(
        path: '/client-charts/:id/kundali/chart/:type',
        parentNavigatorKey: _rootKey,
        builder: (_, s) => ChartDetailPage(
          consultationId: s.pathParameters['id']!,
          type: s.pathParameters['type']!,
          standalone: true,
        ),
      ),
      GoRoute(
        path: Routes.matchmaking,
        parentNavigatorKey: _rootKey,
        builder: (_, _) => const MatchmakingPage(),
      ),
      GoRoute(
        path: Routes.waitlist,
        parentNavigatorKey: _rootKey,
        builder: (_, _) => const WaitlistPage(),
      ),
      GoRoute(
        path: Routes.callHistory,
        parentNavigatorKey: _rootKey,
        builder: (_, _) => const CallHistoryPage(),
      ),
      GoRoute(
        path: Routes.reports,
        parentNavigatorKey: _rootKey,
        builder: (_, _) => const ReportsPage(),
        routes: [
          GoRoute(
            path: ':id',
            parentNavigatorKey: _rootKey,
            builder: (_, s) =>
                ReportDetailPage(reportId: s.pathParameters['id']!),
          ),
        ],
      ),
      GoRoute(
        path: Routes.remedies,
        parentNavigatorKey: _rootKey,
        builder: (_, _) => const RemediesPage(),
      ),
      GoRoute(
        path: '/remedies/advise',
        parentNavigatorKey: _rootKey,
        builder: (_, s) => AdviseRemedyPage(
          consultationId: s.uri.queryParameters['consultation'],
          customerName: s.uri.queryParameters['name'],
        ),
      ),
      GoRoute(
        path: '/remedies/suggest',
        parentNavigatorKey: _rootKey,
        builder: (_, s) => SuggestRemedyPage(
          consultationId: s.uri.queryParameters['consultation'],
          customerName: s.uri.queryParameters['name'],
          // From the pooja calendar: the product is already chosen.
          product: s.extra is RemedyProduct ? s.extra as RemedyProduct : null,
        ),
      ),
      GoRoute(
        path: Routes.poojaCalendar,
        parentNavigatorKey: _rootKey,
        builder: (_, _) => const PoojaCalendarPage(),
      ),
      GoRoute(
        path: Routes.poojaBookings,
        parentNavigatorKey: _rootKey,
        builder: (_, _) => const PoojaBookingsPage(),
      ),
      GoRoute(
        path: Routes.performance,
        parentNavigatorKey: _rootKey,
        builder: (_, _) => const PerformancePage(),
      ),
      GoRoute(
        path: Routes.winBack,
        parentNavigatorKey: _rootKey,
        builder: (_, _) => const WinBackPage(),
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
          profileId: s.uri.queryParameters['profile'],
        ),
      ),
      GoRoute(
        path: '/consultations/:id/matches/:matchId',
        parentNavigatorKey: _rootKey,
        builder: (_, s) => MatchReportPage(
          consultationId: s.pathParameters['id']!,
          matchId: s.pathParameters['matchId']!,
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
        builder: (_, s) => PredictionWorkPage(id: s.pathParameters['id']!),
      ),

      StatefulShellRoute(
        builder: (_, _, shell) => AppShell(navigationShell: shell),
        // Cross-fade between tabs instead of the instant IndexedStack swap.
        navigatorContainerBuilder: (_, shell, children) =>
            AnimatedBranchContainer(
              currentIndex: shell.currentIndex,
              children: children,
            ),
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
            routes: [_leaf(Routes.chats, (_) => const ChatsPage())],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.profile,
                builder: (_, _) => const ProfilePage(),
                routes: [
                  _leaf('edit', (_) => const EditProfilePage()),
                  _leaf('public', (_) => const PublicProfilePage()),
                  _leaf('rates', (_) => const RatesPage()),
                  _leaf('working-hours', (_) => const WorkingHoursPage()),
                  _leaf('reviews', (_) => const ReviewsPage()),
                  _leaf('kyc', (_) => const KycPage()),
                  _leaf('delete-account', (_) => const DeleteAccountPage()),
                  _leaf('featured', (_) => const FeaturedSlotsPage()),
                  _leaf('sound', (_) => const SoundSettingsPage()),
                  _leaf(
                    'calls',
                    (s) => CallSetupPage(
                      tested: s.uri.queryParameters['tested'] == '1',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
