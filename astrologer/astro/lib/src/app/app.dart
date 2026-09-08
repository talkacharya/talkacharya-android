import 'dart:async';

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
import '../core/notifications/notification_router.dart';
import '../core/notifications/push_device_registrar.dart';
import '../core/realtime/realtime_coordinator.dart';
import '../core/router/app_router.dart';
import '../core/router/pending_deep_link.dart';
import '../core/theme/app_theme.dart';
import '../features/auth/presentation/bloc/auth/auth_bloc.dart';
import '../features/notifications/presentation/bloc/notifications_cubit.dart';

const _supportedLocales = <Locale>[
  Locale('en'), Locale('hi'), Locale('bn'), Locale('mr'),
  Locale('te'), Locale('ta'), Locale('gu'), Locale('kn'),
];

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

    final deepLinks = getIt<DeepLinkService>()..start();
    final notifRouter = getIt<NotificationRouter>()..start();

    _subs.add(deepLinks.uris.listen((u) => _handle(locationForUri(u))));
    _subs.add(notifRouter.locations.listen(_handle));

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _handle(locationForUri(await deepLinks.initialLink() ?? Uri()));
      _handle(await notifRouter.initialLocation());
    });
  }

  void _handle(String? location) {
    if (location == null || location.isEmpty) return;
    if (getIt<AuthBloc>().state.status == AuthStatus.authenticated &&
        getIt<OnboardingStore>().stage == OnboardingStage.approved) {
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
      ],
      child: BlocBuilder<AuthBloc, AuthState>(
        buildWhen: (a, b) =>
            a.user?.preferredLanguage != b.user?.preferredLanguage,
        builder: (context, state) {
          final pref = state.user?.preferredLanguage;
          final locale = (pref != null &&
                  _supportedLocales.any((l) => l.languageCode == pref))
              ? Locale(pref)
              : null;
          return MaterialApp.router(
            title: config.appName,
            debugShowCheckedModeBanner: !config.isProd,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            routerConfig: _router,
            locale: locale,
            supportedLocales: _supportedLocales,
            localizationsDelegates: const [
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
