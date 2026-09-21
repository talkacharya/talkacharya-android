import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';

import '../features/consultations/presentation/room_presence.dart';
import '../features/consultations/presentation/view/widgets/live_session_banner.dart';
import '../core/config/flavor.dart';
import '../core/deeplink/deep_link_parser.dart';
import '../core/deeplink/deep_link_service.dart';
import '../core/di/service_locator.dart';
import '../core/l10n/l10n.dart';
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
import '../features/consultations/presentation/view/consultation_room_page.dart';

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

  @override
  void initState() {
    super.initState();
    getIt<AuthBloc>().add(const AuthStarted());
    _wireBackgroundServices();
  }

  void _wireBackgroundServices() {
    getIt<PushDeviceRegistrar>().start();
    getIt<RealtimeCoordinator>().start();

    final deepLinks = getIt<DeepLinkService>()..start();
    final notifRouter = getIt<NotificationRouter>()..start();

    _subs.add(
      deepLinks.uris.listen((uri) => _handleLocation(locationForUri(uri))),
    );
    _subs.add(notifRouter.locations.listen(_handleLocation));

    // Cold-start entry points, resolved once after the first frame.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _handleLocation(locationForUri(await deepLinks.initialLink() ?? Uri()));
      _handleLocation(await notifRouter.initialLocation());
    });
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
          final locale =
              (pref != null &&
                  kSupportedLocales.any((l) => l.languageCode == pref))
              ? Locale(pref)
              : null; // null → follow the device language, then fall back to en
          return MaterialApp.router(
            onGenerateTitle: (context) => context.l10n.appName,
            debugShowCheckedModeBanner: !config.isProd,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
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
              child: LiveSessionBanner(child: child ?? const SizedBox.shrink()),
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
