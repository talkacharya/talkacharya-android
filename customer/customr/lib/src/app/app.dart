import '../core/notifications/local_notifications.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import '../features/consultations/presentation/room_presence.dart';
import '../features/consultations/presentation/view/widgets/call_room.dart';
import '../features/consultations/presentation/view/widgets/live_session_banner.dart';
import '../core/config/flavor.dart';
import '../core/deeplink/deep_link_parser.dart';
import '../core/deeplink/pending_referral.dart';
import '../core/deeplink/deep_link_service.dart';
import '../core/di/service_locator.dart';
import '../core/l10n/l10n.dart';
import '../core/update/app_update_watcher.dart';
import '../core/notifications/notification_router.dart';
import '../core/notifications/push_device_registrar.dart';
import '../core/profile/active_profile_store.dart';
import '../core/realtime/realtime_coordinator.dart';
import '../core/router/app_router.dart';
import '../core/router/pending_deep_link.dart';
import '../core/theme/app_theme.dart';
import '../features/auth/presentation/bloc/auth/auth_bloc.dart';
import '../features/birthprofiles/presentation/bloc/birth_profiles_cubit.dart';
import '../features/follows/presentation/cubit/follow_cubit.dart';
import '../features/consultations/presentation/cubit/chats_list_cubit.dart';
import '../features/notifications/presentation/bloc/notifications_cubit.dart';
import '../features/wallet/presentation/cubit/wallet_cubit.dart';
import 'package:talkacharya_call/talkacharya_call.dart';
import '../core/router/routes.dart';

class AppScrollBehavior extends ScrollBehavior {
  const AppScrollBehavior();
  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics());
  }
}

class TalkAcharyaApp extends StatefulWidget {
  const TalkAcharyaApp({super.key});

  @override
  State<TalkAcharyaApp> createState() => _TalkAcharyaAppState();
}

class _TalkAcharyaAppState extends State<TalkAcharyaApp> {
  late final GoRouter _router = buildRouter(
    getIt<AuthBloc>(),
    getIt<PendingDeepLink>(),
    getIt<ActiveProfileStore>(),
  );

  final _subs = <StreamSubscription<dynamic>>[];
  VoidCallback? _onHubChange;

  @override
  void initState() {
    super.initState();
    getIt<AuthBloc>().add(const AuthStarted());
    _wireBackgroundServices();
  }

  /// A link opened the app or arrived while it runs. An invite link's code is
  /// kept first, so it survives until the person signs up.
  void _onLink(Uri uri) {
    final code = referralCodeFromUri(uri);
    if (code != null) unawaited(getIt<PendingReferral>().save(code));
    _handleLocation(locationForUri(uri));
  }

  void _wireBackgroundServices() {
    // Installed from an invite page: pick the code up from the Play Store.
    unawaited(getIt<PendingReferral>().captureInstallReferrer());
    getIt<PushDeviceRegistrar>().start();
    getIt<RealtimeCoordinator>().start();

    final deepLinks = getIt<DeepLinkService>()..start();
    final notifRouter = getIt<NotificationRouter>()..start();

    _subs.add(deepLinks.uris.listen(_onLink));
    _subs.add(notifRouter.locations.listen(_handleLocation));
    _subs.add(CallTelecom.events.listen(_onTelecom));

    // If the astrologer disconnects while the incoming-call notification is
    // still ringing (user never opened the call room), no screen is present to
    // call cancelIncomingCall(). Listen to the hub so the ringtone is stopped
    // as soon as the call is known to be over.
    final hub = getIt<CallHub>();
    _onHubChange = () {
      final c = hub.controller;
      if (c != null && c.state.phase == CallPhase.ended) {
        unawaited(getIt<LocalNotifications>().cancelIncomingCall());
      }
    };
    hub.addListener(_onHubChange!);

    // Cold-start entry points, resolved once after the first frame.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _onLink(await deepLinks.initialLink() ?? Uri());
      _handleLocation(await notifRouter.initialLocation());
      // Answered from a headset or watch while the app was not running.
      final answered = await CallTelecom.takePendingAnswer();
      if (answered != null) _openCall(answered);
    });
  }

  /// The ringing call answered or declined by the system — a headset button,
  /// a watch, a car — rather than by tapping the notification.
  void _onTelecom(CallTelecomEvent event) {
    switch (event) {
      case TelecomAnswer(:final callId) when callId.isNotEmpty:
        _openCall(callId);
      case TelecomReject():
        // The astrologer's side times the call out; nothing to send.
        unawaited(getIt<LocalNotifications>().cancelIncomingCall());
      default:
        break;
    }
  }

  /// Into the call's room, whose controller adopts the answered Telecom call.
  void _openCall(String consultationId) {
    unawaited(getIt<LocalNotifications>().cancelIncomingCall());
    _handleLocation(Routes.consultation(consultationId));
  }

  void _handleLocation(String? location) {
    if (location == null || location.isEmpty) return;
    if (getIt<AuthBloc>().state.status == AuthStatus.authenticated) {
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
    final cb = _onHubChange;
    if (cb != null) getIt<CallHub>().removeListener(cb);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final config = getIt<AppConfig>();
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: getIt<AuthBloc>()),
        BlocProvider.value(value: getIt<NotificationsCubit>()),
        BlocProvider.value(value: getIt<BirthProfilesCubit>()),
        BlocProvider.value(value: getIt<FollowCubit>()),
        BlocProvider.value(value: getIt<WalletCubit>()),
        BlocProvider.value(value: getIt<ChatsListCubit>()),
      ],
      child: BlocBuilder<AuthBloc, AuthState>(
        buildWhen: (a, b) =>
            a.user?.preferredLanguage != b.user?.preferredLanguage,
        builder: (context, state) {
          final pref = state.user?.preferredLanguage;
          final locale = (pref != null && isSupportedLanguage(pref))
              ? Locale(pref)
              : null; // null → follow the device language, then fall back to en
          return MaterialApp.router(
            onGenerateTitle: (context) => context.l10n.appName,
            debugShowCheckedModeBanner: !config.isProd,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            scrollBehavior: const AppScrollBehavior(),
            routerConfig: _router,
            locale: locale,
            supportedLocales: kSupportedLocales,
            builder: (context, child) => CallOverlayHost(
              hub: getIt<CallHub>(),
              strings: callStrings(context.l10n),
              // Tapping the minimized call goes back to its room — or
              // raises the one already in the stack, rather than
              // stacking a second copy of the same conversation.
              onOpen: (info) => getIt<CallHub>().isRoomOpen(info.consultationId)
                  ? _router.pop()
                  : _router
                        .push(Routes.consultation(info.consultationId))
                        .ignore(),
              // Says so when the Play Store has a newer version.
              child: AppUpdateWatcher(
                child: LiveSessionBanner(
                  child: child ?? const SizedBox.shrink(),
                ),
              ),
            ),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            localeResolutionCallback: (device, supported) {
              if (locale != null) return locale;
              for (final s in supported) {
                if (s.languageCode == device?.languageCode) return s;
              }
              return const Locale('en');
            },
          );
        },
      ),
    );
  }
}
