import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:astro_kundali/astro_kundali.dart';
import 'package:talkacharya_predictions/talkacharya_predictions.dart';

import '../../app/view/splash_page.dart';
import '../../features/articles/data/articles_repository.dart';
import '../../features/articles/data/models/article.dart';
import '../../features/articles/presentation/cubit/article_cubit.dart';
import '../../features/articles/presentation/cubit/articles_cubit.dart';
import '../../features/articles/presentation/view/article_page.dart';
import '../../features/articles/presentation/view/articles_page.dart';
import '../../features/astrologers/presentation/view/astrologer_detail_page.dart';
import '../../features/astrologers/presentation/view/astrologers_page.dart';
import '../../features/auth/presentation/bloc/auth/auth_bloc.dart';
import '../../features/auth/presentation/view/login_page.dart';
import '../../features/birthprofiles/presentation/bloc/birth_profiles_cubit.dart';
import '../../features/birthprofiles/presentation/view/create_profile_page.dart';
import '../../features/birthprofiles/presentation/view/manage_profiles_page.dart';
import '../../features/birthprofiles/presentation/view/select_profile_page.dart';
import '../../features/consultations/presentation/view/chats_list_page.dart';
import '../../features/consultations/presentation/view/consultation_room_page.dart';
import '../../features/consultations/presentation/view/consultations_list_page.dart';
import '../../features/home/data/horoscope_sign_store.dart';
import '../../features/home/data/models/zodiac.dart';
import '../../features/home/presentation/view/home_page.dart';
import '../../features/horoscope/data/horoscope_repository.dart';
import '../../features/horoscope/data/models/sign_horoscope.dart';
import '../../features/horoscope/presentation/cubit/horoscope_cubit.dart';
import '../../features/horoscope/presentation/view/horoscope_page.dart';
import '../../features/matchmaking/data/matchmaking_repository.dart';
import '../../features/matchmaking/data/models/match_result.dart';
import '../../features/matchmaking/presentation/cubit/matchmaking_cubit.dart';
import '../../features/matchmaking/presentation/view/match_result_page.dart';
import '../../features/matchmaking/presentation/view/matchmaking_home_page.dart';
import '../../features/kundali/data/kundali_repository.dart';
import '../../features/kundali/presentation/cubit/kundali_cubit.dart';
import '../../features/kundali/presentation/kundali_terms.dart';
import '../../features/kundali/presentation/view/advanced_page.dart';
import '../../features/kundali/presentation/view/advanced_report_page.dart';
import '../../features/kundali/presentation/view/bhava_page.dart';
import '../../features/kundali/presentation/view/dasha_page.dart';
import '../../features/kundali/presentation/view/chart_detail_page.dart';
import '../../features/kundali/presentation/view/full_chart_page.dart';
import '../../features/kundali/presentation/view/insights_page.dart';
import '../../features/kundali/presentation/view/jyotish_upaya_page.dart';
import '../../features/kundali/presentation/view/kundali_overview_page.dart';
import '../../features/kundali/presentation/view/lal_kitab_page.dart';
import '../../features/kundali/presentation/view/mood_page.dart';
import '../../features/kundali/presentation/view/muhurta_page.dart';
import '../../features/kundali/presentation/view/numerology_page.dart';
import '../../features/kundali/presentation/view/planets_page.dart';
import '../../features/kundali/presentation/view/remedies_page.dart';
import '../../features/kundali/presentation/view/sade_sati_page.dart';
import '../../features/kundali/presentation/view/transits_page.dart';
import '../../features/kundali/presentation/view/varshphal_page.dart';
import '../../features/kundali/presentation/view/yogas_doshas_page.dart';
import '../../features/livestream/presentation/view/live_page.dart';
import '../../features/livestream/presentation/view/live_room_page.dart';
import '../../features/notifications/presentation/view/notifications_page.dart';
import '../../features/panchang/data/models/day_panchang.dart';
import '../../features/panchang/data/panchang_repository.dart';
import '../../features/panchang/presentation/cubit/panchang_cubit.dart';
import '../../features/panchang/presentation/view/panchang_page.dart';
import '../../features/prashna/data/prashna_repository.dart';
import '../../features/prashna/presentation/cubit/prashna_cubit.dart';
import '../../features/prashna/presentation/cubit/prashna_detail_cubit.dart';
import '../../features/prashna/presentation/view/prashna_detail_page.dart';
import '../../features/prashna/presentation/view/prashna_home_page.dart';
import '../../features/predictions/data/predictions_repository.dart';
import '../../features/predictions/presentation/cubit/prediction_detail_cubit.dart';
import '../../features/predictions/presentation/cubit/predictions_cubit.dart';
import '../../features/predictions/presentation/view/prediction_detail_page.dart';
import '../../features/predictions/presentation/view/predictions_home_page.dart';
import '../../features/predictions/presentation/view/request_prediction_page.dart';
import '../../features/profile/presentation/view/delete_account_page.dart';
import '../../features/profile/presentation/view/edit_profile_page.dart';
import '../../features/profile/presentation/view/notification_prefs_page.dart';
import '../../features/profile/presentation/view/profile_page.dart';
import '../../features/profile/presentation/view/referrals_page.dart';
import '../../features/shell/presentation/view/app_shell.dart';
import '../../features/support/data/models/dispute.dart';
import '../../features/support/data/support_repository.dart';
import '../../features/support/presentation/cubit/dispute_detail_cubit.dart';
import '../../features/support/presentation/cubit/help_cubit.dart';
import '../../features/support/presentation/cubit/report_issue_cubit.dart';
import '../../features/support/presentation/view/dispute_detail_page.dart';
import '../../features/support/presentation/view/help_page.dart';
import '../../features/support/presentation/view/report_issue_page.dart';
import '../../features/wallet/presentation/view/invoices_page.dart';
import '../../features/wallet/presentation/view/transactions_page.dart';
import '../../features/wallet/presentation/view/wallet_page.dart';
import '../di/service_locator.dart';
import '../profile/active_profile_store.dart';
import 'go_router_refresh.dart';
import 'pending_deep_link.dart';
import 'routes.dart';
import 'transitions.dart';

final _rootKey = GlobalKey<NavigatorState>();

ZodiacSign _initialHoroscopeSign(String? fromQuery) {
  final explicit = ZodiacSign.fromSlug(fromQuery);
  if (explicit != null) return explicit;
  final remembered = getIt<HoroscopeSignStore>().sign;
  if (remembered != null) return remembered;
  final bp = getIt<BirthProfilesCubit>().state;
  final profile = bp.activeProfile ?? bp.primaryProfile;
  final rasi = ZodiacSign.forProfileSign(profile?.moonSign);
  if (rasi != null) return rasi;
  final born = DateTime.tryParse(profile?.birthDate ?? '');
  return born == null ? ZodiacSign.aries : ZodiacSign.fromDate(born);
}

/// The active (else primary) birth profile's city, as a panchang place.
PanchangPlace? _profilePlace() {
  final p = getIt<BirthProfilesCubit>().state.resolvedProfile;
  final lat = double.tryParse(p?.latitude ?? '');
  final lon = double.tryParse(p?.longitude ?? '');
  if (p == null || lat == null || lon == null || (lat == 0 && lon == 0)) {
    return null;
  }
  return PanchangPlace(name: p.birthPlaceName, latitude: lat, longitude: lon);
}

GoRoute _leaf(String path, Widget Function(GoRouterState) child) =>
    GoRoute(path: path, builder: (_, state) => child(state));

/// Route table + auth gate + deferred deep-link replay.
///
/// `redirect` runs on every navigation and whenever [AuthBloc] emits. A location
/// that arrives while unauthenticated is stashed in [pending] and replayed the
/// moment the session becomes authenticated.
GoRouter buildRouter(
  AuthBloc authBloc,
  PendingDeepLink pending,
  ActiveProfileStore profileStore,
) {
  return GoRouter(
    navigatorKey: _rootKey,
    initialLocation: Routes.splash,
    refreshListenable: Listenable.merge([
      GoRouterRefreshStream(authBloc.stream),
      profileStore,
    ]),
    redirect: (context, state) {
      final status = authBloc.state.status;
      final loc = state.matchedLocation;
      final goingToLogin = loc == Routes.login;
      final goingToSplash = loc == Routes.splash;

      if (status == AuthStatus.unknown) {
        return goingToSplash ? null : Routes.splash;
      }

      final loggedIn = status == AuthStatus.authenticated;

      if (!loggedIn) {
        // Remember a real destination so we can resume after login.
        if (!goingToLogin && !goingToSplash) pending.set(state.uri.toString());
        return goingToLogin ? null : Routes.login;
      }

      // Just verified an OTP → show the birth-profile picker once (soft gate:
      // the picker's "Not now" clears it, then navigates on).
      final atProfileGate = loc.startsWith(Routes.selectProfile);
      if (profileStore.loginGatePending && !atProfileGate) {
        return Routes.selectProfile;
      }

      if (goingToLogin || goingToSplash) {
        return profileStore.loginGatePending
            ? Routes.selectProfile
            : (pending.take() ?? Routes.home);
      }
      return null;
    },
    routes: [
      GoRoute(path: Routes.splash, builder: (_, _) => const SplashPage()),
      GoRoute(path: Routes.login, builder: (_, _) => const LoginPage()),

      GoRoute(
        path: Routes.selectProfile,
        parentNavigatorKey: _rootKey,
        builder: (_, _) => const SelectProfilePage(),
        routes: [
          GoRoute(
            path: 'new',
            parentNavigatorKey: _rootKey,
            builder: (_, _) => const CreateProfilePage(),
          ),
        ],
      ),

      // full-screen, above the bottom nav
      GoRoute(
        path: Routes.notifications,
        parentNavigatorKey: _rootKey,
        builder: (_, _) => const NotificationsPage(),
      ),
      GoRoute(
        path: '/consultations',
        parentNavigatorKey: _rootKey,
        builder: (_, _) => const ConsultationsListPage(),
      ),
      GoRoute(
        path: Routes.consultationPattern,
        parentNavigatorKey: _rootKey,
        builder: (_, state) =>
            ConsultationRoomPage(consultationId: state.pathParameters['id']!),
        routes: [
          GoRoute(
            path: 'report',
            parentNavigatorKey: _rootKey,
            builder: (_, s) => BlocProvider(
              create: (_) => ReportIssueCubit(
                repo: getIt<SupportRepository>(),
                consultationId: s.pathParameters['id']!,
              )..load(),
              child: const ReportIssuePage(),
            ),
          ),
        ],
      ),
      GoRoute(
        path: Routes.disputePattern,
        parentNavigatorKey: _rootKey,
        builder: (_, s) => BlocProvider(
          key: ValueKey('dispute-${s.pathParameters['id']}'),
          create: (_) => DisputeDetailCubit(
            repo: getIt<SupportRepository>(),
            id: s.pathParameters['id']!,
            seed: s.extra is Dispute ? s.extra as Dispute : null,
          )..load(),
          child: const DisputeDetailPage(),
        ),
      ),

      // Wallet — full-screen, above the bottom nav. Reached from the home
      // header chip and the Profile page, not a tab.
      GoRoute(
        path: Routes.wallet,
        parentNavigatorKey: _rootKey,
        builder: (_, state) => WalletPage(
          initialAmount: state.extra is int ? state.extra as int : null,
        ),
        routes: [
          GoRoute(
            path: 'transactions',
            parentNavigatorKey: _rootKey,
            builder: (_, _) => const TransactionsPage(),
          ),
          GoRoute(
            path: 'invoices',
            parentNavigatorKey: _rootKey,
            builder: (_, _) => const InvoicesPage(),
          ),
        ],
      ),

      // Panchang — full-screen. The city is the saved pick, else the active
      // birth profile's place; `?date=` opens a specific day.
      GoRoute(
        path: Routes.panchang,
        parentNavigatorKey: _rootKey,
        builder: (_, s) => BlocProvider(
          create: (_) => PanchangCubit(
            repo: getIt<PanchangRepository>(),
            fallbackPlace: _profilePlace(),
            initialDate: DateTime.tryParse(s.uri.queryParameters['date'] ?? ''),
          )..init(),
          child: const PanchangPage(),
        ),
      ),

      // Read & learn — full-screen; the list keys on its category filter.
      GoRoute(
        path: Routes.articles,
        parentNavigatorKey: _rootKey,
        builder: (_, s) => BlocProvider(
          create: (_) => ArticlesCubit(
            getIt<ArticlesRepository>(),
            initialCategory: s.uri.queryParameters['category'] == null
                ? null
                : ArticleCategory.parse(s.uri.queryParameters['category']),
          )..load(),
          child: const ArticlesPage(),
        ),
        routes: [
          GoRoute(
            path: ':slug',
            parentNavigatorKey: _rootKey,
            builder: (_, s) {
              final slug = s.pathParameters['slug']!;
              return BlocProvider(
                key: ValueKey('article-$slug'),
                create: (_) =>
                    ArticleCubit(repo: getIt<ArticlesRepository>(), slug: slug)
                      ..load(),
                child: ArticlePage(
                  preview: s.extra is ArticleSummary
                      ? s.extra as ArticleSummary
                      : null,
                ),
              );
            },
          ),
        ],
      ),

      // Chats ("Orders") — full-screen, reached from the Profile page.
      GoRoute(
        path: Routes.chats,
        parentNavigatorKey: _rootKey,
        builder: (_, _) => const ChatsListPage(),
      ),

      // Horoscope — sign + span come from the query (deep links / home card),
      // else the remembered sign, else the user's own sun sign.
      GoRoute(
        path: Routes.horoscope,
        parentNavigatorKey: _rootKey,
        builder: (_, state) => BlocProvider(
          create: (_) => HoroscopeCubit(
            repo: getIt<HoroscopeRepository>(),
            signStore: getIt<HoroscopeSignStore>(),
            initialSign: _initialHoroscopeSign(
              state.uri.queryParameters['sign'],
            ),
            initialSpan: HoroscopeSpan.fromName(
              state.uri.queryParameters['span'],
            ),
          ),
          child: const HoroscopePage(),
        ),
      ),

      // Kundali Milan — one MatchmakingCubit across the hub + results.
      ShellRoute(
        parentNavigatorKey: _rootKey,
        builder: (context, state, child) => BlocProvider(
          create: (_) => MatchmakingCubit(getIt<MatchmakingRepository>()),
          child: child,
        ),
        routes: [
          GoRoute(
            path: Routes.matchmaking,
            builder: (_, _) => const MatchmakingHomePage(),
          ),
          GoRoute(
            path: '/matchmaking/:id',
            builder: (_, s) => BlocProvider(
              create: (_) => MatchResultCubit(
                repo: getIt<MatchmakingRepository>(),
                id: s.pathParameters['id']!,
                seed: s.extra is MatchResult ? s.extra as MatchResult : null,
              ),
              child: const MatchResultPage(),
            ),
          ),
        ],
      ),

      // Prashna (horary) — one PrashnaCubit across the section.
      ShellRoute(
        parentNavigatorKey: _rootKey,
        builder: (context, state, child) => BlocProvider(
          create: (_) => PrashnaCubit(getIt<PrashnaRepository>()),
          child: child,
        ),
        routes: [
          GoRoute(path: '/prashna', builder: (_, _) => const PrashnaHomePage()),
          GoRoute(
            path: '/prashna/:id',
            builder: (_, s) {
              final id = s.pathParameters['id']!;
              return BlocProvider(
                create: (_) => PrashnaDetailCubit(
                  repo: getIt<PrashnaRepository>(),
                  id: id,
                ),
                child: PrashnaDetailPage(
                  id: id,
                  seed: s.extra is Prashna ? s.extra as Prashna : null,
                ),
              );
            },
          ),
        ],
      ),

      // Predictions — one PredictionsCubit across the section.
      ShellRoute(
        parentNavigatorKey: _rootKey,
        builder: (context, state, child) => BlocProvider(
          create: (_) => PredictionsCubit(getIt<PredictionsRepository>()),
          child: child,
        ),
        routes: [
          GoRoute(
            path: '/predictions',
            builder: (_, _) => const PredictionsHomePage(),
          ),
          GoRoute(
            path: '/predictions/request',
            builder: (_, s) => RequestPredictionPage(
              initialArea: s.extra is PredictionArea
                  ? s.extra as PredictionArea
                  : null,
            ),
          ),
          GoRoute(
            path: '/predictions/:id',
            builder: (_, s) {
              final id = s.pathParameters['id']!;
              return BlocProvider(
                create: (_) => PredictionDetailCubit(
                  repo: getIt<PredictionsRepository>(),
                  id: id,
                ),
                child: PredictionDetailPage(id: id),
              );
            },
          ),
        ],
      ),

      // Kundali — one KundaliCubit shared across the section (per birth profile).
      ShellRoute(
        parentNavigatorKey: _rootKey,
        builder: (context, state, child) {
          final id = state.pathParameters['id']!;
          return BlocProvider(
            key: ValueKey('kundali-$id'),
            create: (_) =>
                KundaliCubit(repo: getIt<KundaliRepository>(), profileId: id),
            child: KundaliL10nScope(child: child),
          );
        },
        routes: [
          GoRoute(
            path: '/kundali/:id',
            builder: (_, s) =>
                KundaliOverviewPage(profileId: s.pathParameters['id']!),
          ),
          GoRoute(
            path: '/kundali/:id/chart',
            builder: (_, s) => FullChartPage(
              profileId: s.pathParameters['id']!,
              initialHouse: s.extra is int ? s.extra as int : null,
            ),
          ),
          GoRoute(
            path: '/kundali/:id/chart/:type',
            builder: (_, s) => ChartDetailPage(
              profileId: s.pathParameters['id']!,
              type: s.pathParameters['type']!,
            ),
          ),
          GoRoute(
            path: '/kundali/:id/insights',
            builder: (_, s) => InsightsPage(profileId: s.pathParameters['id']!),
          ),
          GoRoute(
            path: '/kundali/:id/mood',
            builder: (_, s) => MoodPage(profileId: s.pathParameters['id']!),
          ),
          GoRoute(
            path: '/kundali/:id/remedies',
            builder: (_, s) => RemediesPage(profileId: s.pathParameters['id']!),
          ),
          GoRoute(
            path: '/kundali/:id/numerology',
            builder: (_, s) =>
                NumerologyPage(profileId: s.pathParameters['id']!),
          ),
          GoRoute(
            path: '/kundali/:id/planets',
            builder: (_, s) => PlanetsPage(profileId: s.pathParameters['id']!),
          ),
          GoRoute(
            path: '/kundali/:id/dasha',
            builder: (_, s) => DashaPage(profileId: s.pathParameters['id']!),
          ),
          GoRoute(
            path: '/kundali/:id/transits',
            builder: (_, s) => TransitsPage(profileId: s.pathParameters['id']!),
          ),
          GoRoute(
            path: '/kundali/:id/sade-sati',
            builder: (_, s) => SadeSatiPage(profileId: s.pathParameters['id']!),
          ),
          GoRoute(
            path: '/kundali/:id/muhurta',
            builder: (_, s) => MuhurtaPage(profileId: s.pathParameters['id']!),
          ),
          GoRoute(
            path: '/kundali/:id/jyotish-upaya',
            builder: (_, s) =>
                JyotishUpayaPage(profileId: s.pathParameters['id']!),
          ),
          GoRoute(
            path: '/kundali/:id/lal-kitab',
            builder: (_, s) => LalKitabPage(profileId: s.pathParameters['id']!),
          ),
          GoRoute(
            path: '/kundali/:id/varshphal',
            builder: (_, s) =>
                VarshphalPage(profileId: s.pathParameters['id']!),
          ),
          GoRoute(
            path: '/kundali/:id/yogas',
            builder: (_, s) =>
                YogasDoshasPage(profileId: s.pathParameters['id']!),
          ),
          GoRoute(
            path: '/kundali/:id/houses',
            builder: (_, s) => BhavaPage(profileId: s.pathParameters['id']!),
          ),
          GoRoute(
            path: '/kundali/:id/advanced',
            builder: (_, s) => AdvancedPage(profileId: s.pathParameters['id']!),
          ),
          GoRoute(
            path: '/kundali/:id/advanced/:report',
            builder: (_, s) => AdvancedReportPage(
              profileId: s.pathParameters['id']!,
              report: s.pathParameters['report']!,
            ),
          ),
        ],
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
            routes: [
              GoRoute(
                path: Routes.astrologers,
                // Key on the query so re-navigating with new filters (from a
                // home rail / concern chip) rebuilds the discovery state, and
                // pass the parsed filters straight in (no GoRouterState lookup
                // from inside the page).
                builder: (_, s) => AstrologersPage.fromParams(
                  s.uri.queryParameters,
                  key: ValueKey('discovery:${s.uri.query}'),
                ),
                routes: [
                  _leaf(
                    ':id',
                    (s) => AstrologerDetailPage(
                      astrologerId: s.pathParameters['id']!,
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.live,
                builder: (_, _) => const LivePage(),
                routes: [
                  _leaf(
                    ':id',
                    (s) => LiveRoomPage(streamId: s.pathParameters['id']!),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.profile,
                builder: (_, _) => const ProfilePage(),
                routes: [
                  _leaf('referrals', (_) => const ReferralsPage()),
                  _leaf('edit', (_) => const EditProfilePage()),
                  _leaf('notifications', (_) => const NotificationPrefsPage()),
                  _leaf('delete-account', (_) => const DeleteAccountPage()),
                  _leaf(
                    'help',
                    (_) => BlocProvider(
                      create: (_) =>
                          HelpCubit(getIt<SupportRepository>())..load(),
                      child: const HelpPage(),
                    ),
                  ),
                  GoRoute(
                    path: 'birth-profiles',
                    builder: (_, _) => const ManageProfilesPage(),
                    routes: [
                      GoRoute(
                        path: 'new',
                        parentNavigatorKey: _rootKey,
                        builder: (_, _) =>
                            const CreateProfilePage(activate: false),
                      ),
                      GoRoute(
                        path: ':id/edit',
                        parentNavigatorKey: _rootKey,
                        builder: (_, s) => CreateProfilePage.edit(
                          profileId: s.pathParameters['id']!,
                        ),
                      ),
                    ],
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
