import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';

import '../core/astro/onboarding_store.dart';
import '../core/availability/availability_coordinator.dart';
import '../core/config/flavor.dart';
import '../core/deeplink/deep_link_parser.dart';
import '../core/deeplink/deep_link_service.dart';
import '../core/di/service_locator.dart';
import '../core/l10n/l10n.dart';
import '../core/notifications/notification_router.dart';
import '../core/notifications/push_device_registrar.dart';
import '../core/realtime/realtime_coordinator.dart';
import '../core/router/app_router.dart';
import '../core/router/pending_deep_link.dart';
import '../core/theme/app_theme.dart';
import '../features/auth/presentation/bloc/auth/auth_bloc.dart';
import '../features/chats/presentation/cubit/chats_cubit.dart';
import '../features/consultations/presentation/room_presence.dart';
import '../features/consultations/presentation/widgets/live_session_banner.dart';
import '../features/notifications/presentation/bloc/notifications_cubit.dart';
import '../features/requests/presentation/cubit/requests_cubit.dart';
import 'package:talkacharya_call/talkacharya_call.dart';
import '../features/consultations/presentation/view/consultation_room_page.dart';
import '../core/router/routes.dart';
import '../core/notifications/local_notifications.dart';
import '../features/consultations/data/consultation_api.dart';

class TalkAcharyaApp extends StatefulWidget {
  const TalkAcharyaApp({super.key});

  @override
  State<TalkAcharyaApp> createState() => _TalkAcharyaAppState();
}

class _TalkAcharyaAppState extends State<TalkAcharyaApp> {
  late final GoRouter _router = buildRouter(
    getIt<AuthBloc>(),
    getIt<PendingDeepLink>(),
    getIt<OnboardingStore>(),
  );

  final _subs = <StreamSubscription<dynamic>>[];

  @override
  void initState() {
    super.initState();
    getIt<AuthBloc>().add(const AuthStarted());
    unawaited(getIt<OnboardingStore>().load());
    _wireBackgroundServices();
  }

  void _wireBackgroundServices() {
    getIt<PushDeviceRegistrar>().start();
    getIt<RealtimeCoordinator>().start();
    getIt<AvailabilityCoordinator>().start();

    // The cold-start load() runs before login when there's no session, so its
    // request fails and the gate would sit on the splash forever. Reload the
    // onboarding status on every login and drop it on logout.
    final onboarding = getIt<OnboardingStore>();
    var lastStatus = getIt<AuthBloc>().state.status;
    _subs.add(
      getIt<AuthBloc>().stream.listen((s) {
        final prev = lastStatus;
        lastStatus = s.status;
        if (s.status == prev) return;
        if (s.status == AuthStatus.authenticated &&
            prev == AuthStatus.unauthenticated) {
          unawaited(onboarding.refresh());
        } else if (s.status == AuthStatus.unauthenticated) {
          unawaited(onboarding.clear());
        }
      }),
    );

    final deepLinks = getIt<DeepLinkService>()..start();
    final notifRouter = getIt<NotificationRouter>()..start();

    _subs.add(deepLinks.uris.listen((u) => _handle(locationForUri(u))));
    _subs.add(notifRouter.locations.listen(_handle));
    _subs.add(getIt<LocalNotifications>().callActions.listen(_onCallAction));

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _handle(locationForUri(await deepLinks.initialLink() ?? Uri()));
      _handle(await notifRouter.initialLocation());
    });
  }

  /// Accept or decline tapped on the ringing notification, with the app in
  /// the background. Accepting opens the room; declining answers the customer
  /// without the astrologer ever opening the app, so nobody is left waiting out
  /// the full ninety seconds for a "no".
  Future<void> _onCallAction(({String action, String payload}) event) async {
    Map<String, dynamic> data;
    try {
      data = jsonDecode(event.payload) as Map<String, dynamic>;
    } on FormatException {
      return;
    }
    final id = '${data['consultation_id'] ?? ''}';
    if (id.isEmpty) return;

    if (event.action == LocalNotifications.answerAction) {
      _handle(locationForRaw('${data['deeplink'] ?? ''}'));
      return;
    }
    try {
      await getIt<ConsultationApi>().reject(id, 'declined');
    } on Object {
      // Nothing to show — the app is in the background. The request expires on
      // its own, which is the same outcome.
    }
  }

  void _handle(String? location) {
    if (location == null || location.isEmpty) return;
    if (getIt<AuthBloc>().state.status == AuthStatus.authenticated &&
        getIt<OnboardingStore>().stage == OnboardingStage.approved) {
      // During a call, `go` would tear the room down and drop the call —
      // stack the destination on top instead.
      if (getIt<RoomPresence>().callOnScreen) {
        _router.push(location).ignore();
        return;
      }
      _router.go(location);
    } else {
      getIt<PendingDeepLink>().set(location);
    }
  }

  @override
  void dispose() {
    for (final s in _subs) {
      s.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final config = getIt<AppConfig>();
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: getIt<AuthBloc>()),
        BlocProvider.value(value: getIt<NotificationsCubit>()),
        BlocProvider.value(value: getIt<RequestsCubit>()),
        BlocProvider.value(value: getIt<ChatsCubit>()),
      ],
      child: BlocBuilder<AuthBloc, AuthState>(
        buildWhen: (a, b) =>
            a.user?.preferredLanguage != b.user?.preferredLanguage,
        builder: (context, state) {
          final pref = state.user?.preferredLanguage;
          final locale =
              (pref != null &&
                  kSupportedLocales.any((l) => l.languageCode == pref))
              ? Locale(pref)
              : null;
          return MaterialApp.router(
            title: config.appName,
            debugShowCheckedModeBanner: !config.isProd,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            routerConfig: _router,
            locale: locale,
            builder: (context, child) => CallOverlayHost(
              hub: getIt<CallHub>(),
              strings: astroCallStrings(context.l10n),
              // Tapping the minimized call returns to its room, or
              // raises the one already in the stack rather than
              // stacking a second copy of the same consultation.
              onOpen: (info) => getIt<CallHub>().isRoomOpen(info.consultationId)
                  ? _router.pop()
                  : _router.push(Routes.chatRoom(info.consultationId)).ignore(),
              child: LiveSessionBanner(child: child ?? const SizedBox.shrink()),
            ),
            supportedLocales: kSupportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
          );
        },
      ),
    );
  }
}
