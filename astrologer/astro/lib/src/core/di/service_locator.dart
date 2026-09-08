import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import '../../features/auth/data/auth_api.dart';
import '../../features/auth/data/auth_repository.dart';
import '../../features/auth/presentation/bloc/auth/auth_bloc.dart';
import '../../features/consultations/data/consultation_api.dart';
import '../../features/consultations/data/consultation_repository.dart';
import '../../features/earnings/data/earnings_api.dart';
import '../../features/earnings/presentation/cubit/earnings_cubit.dart';
import '../../features/home/presentation/cubit/dashboard_cubit.dart';
import '../../features/notifications/data/notifications_api.dart';
import '../../features/notifications/data/notifications_repository.dart';
import '../../features/notifications/presentation/bloc/notifications_cubit.dart';
import '../../features/onboarding/data/onboarding_api.dart';
import '../../features/onboarding/data/onboarding_repository.dart';
import '../../features/onboarding/presentation/cubit/onboarding_cubit.dart';
import '../../features/profile/data/profile_api.dart';
import '../../features/requests/presentation/cubit/requests_cubit.dart';
import '../astro/onboarding_store.dart';
import '../availability/availability_coordinator.dart';
import '../config/config_repository.dart';
import '../config/flavor.dart';
import '../deeplink/deep_link_service.dart';
import '../network/connectivity_service.dart';
import '../network/dio_client.dart';
import '../notifications/local_notifications.dart';
import '../notifications/notification_router.dart';
import '../notifications/push_device_registrar.dart';
import '../notifications/push_service.dart';
import '../realtime/realtime_client.dart';
import '../realtime/realtime_coordinator.dart';
import '../router/pending_deep_link.dart';
import '../storage/token_storage.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies(AppConfig config) async {
  getIt
    ..registerSingleton<AppConfig>(config)
    ..registerLazySingleton<FlutterSecureStorage>(
      () => const FlutterSecureStorage(
        aOptions: AndroidOptions(encryptedSharedPreferences: true),
      ),
    )
    ..registerLazySingleton<TokenStorage>(() => TokenStorage(getIt()))
    ..registerLazySingleton<DioClientFactory>(
      () => DioClientFactory(getIt(), getIt()),
    );

  late final AuthBloc authBloc;
  final dio = getIt<DioClientFactory>().buildApiClient(
    onSessionExpired: () async => authBloc.add(const AuthSessionExpired()),
  );

  getIt
    ..registerSingleton<Dio>(dio)
    ..registerLazySingleton<AuthApi>(() => AuthApi(dio))
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepository(api: getIt(), tokens: getIt()),
    );

  authBloc = AuthBloc(getIt<AuthRepository>());
  getIt.registerSingleton<AuthBloc>(authBloc);

  // --- shell infra --------------------------------------------------------
  getIt
    ..registerSingleton<PendingDeepLink>(PendingDeepLink())
    ..registerSingleton<ConnectivityService>(ConnectivityService())
    ..registerSingleton<ConfigRepository>(
      ConfigRepository(dio: dio, storage: getIt()),
    )
    ..registerSingleton<OnboardingStore>(OnboardingStore(dio, getIt()));

  // --- onboarding --------------------------------------------------------
  getIt
    ..registerLazySingleton<OnboardingApi>(() => OnboardingApi(dio))
    ..registerLazySingleton<OnboardingRepository>(
      () => OnboardingRepository(getIt()),
    )
    ..registerFactory<OnboardingCubit>(
      () => OnboardingCubit(repo: getIt(), store: getIt()),
    );

  // --- notifications inbox ---------------------------------------------
  getIt
    ..registerLazySingleton<NotificationsApi>(() => NotificationsApi(dio))
    ..registerLazySingleton<NotificationsRepository>(
      () => NotificationsRepository(getIt()),
    )
    ..registerLazySingleton<NotificationsCubit>(
      () => NotificationsCubit(getIt()),
    );

  // --- push -------------------------------------------------------------
  final local = LocalNotifications();
  final push = PushService(local);
  getIt
    ..registerSingleton<LocalNotifications>(local)
    ..registerSingleton<PushService>(push)
    ..registerSingleton<NotificationRouter>(
      NotificationRouter(push: push, local: local),
    )
    ..registerSingleton<PushDeviceRegistrar>(
      PushDeviceRegistrar(push: push, authBloc: authBloc, dio: dio),
    )
    ..registerSingleton<DeepLinkService>(DeepLinkService());

  // --- realtime + availability ---------------------------------------
  final realtime = RealtimeClient(dio);
  getIt
    ..registerSingleton<RealtimeClient>(realtime)
    ..registerSingleton<RealtimeCoordinator>(
      RealtimeCoordinator(
        client: realtime,
        authBloc: authBloc,
        onboarding: getIt(),
      ),
    )
    ..registerSingleton<AvailabilityCoordinator>(
      AvailabilityCoordinator(
        dio: dio,
        authBloc: authBloc,
        onboarding: getIt(),
      ),
    );

  // --- features ------------------------------------------------------
  getIt
    ..registerLazySingleton<ConsultationApi>(() => ConsultationApi(dio))
    ..registerLazySingleton<ConsultationRepository>(
      () => ConsultationRepository(getIt()),
    )
    ..registerLazySingleton<EarningsApi>(() => EarningsApi(dio))
    ..registerLazySingleton<ProfileApi>(() => ProfileApi(dio))
    ..registerFactory<DashboardCubit>(() => DashboardCubit(dio))
    ..registerFactory<RequestsCubit>(
      () => RequestsCubit(repo: getIt(), realtime: realtime),
    )
    ..registerFactory<EarningsCubit>(() => EarningsCubit(getIt()));
}
