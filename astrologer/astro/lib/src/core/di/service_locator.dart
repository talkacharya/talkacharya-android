import 'package:talkacharya_chat/talkacharya_chat.dart';
import '../../features/consultations/data/chat_adapters.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import '../../features/auth/data/auth_api.dart';
import '../../features/auth/data/auth_repository.dart';
import '../../features/auth/data/firebase_phone_auth.dart';
import '../../features/auth/presentation/bloc/auth/auth_bloc.dart';
import '../../features/chats/presentation/cubit/chats_cubit.dart';
import '../../features/consultations/data/consultation_api.dart';
import '../../features/consultations/presentation/room_presence.dart';
import '../../features/consultations/data/consultation_repository.dart';
import '../../features/earnings/data/earnings_api.dart';
import '../../features/earnings/presentation/cubit/earnings_cubit.dart';
import '../../features/kundali/data/kundali_api.dart';
import '../../features/kundali/data/kundali_repository.dart';
import '../../features/livestream/data/live_api.dart';
import '../../features/predictions/data/predictions_api.dart';
import '../../features/predictions/data/predictions_repository.dart';
import '../../features/performance/data/performance_api.dart';
import '../../features/performance/presentation/cubit/performance_cubit.dart';
import '../util/amount_privacy.dart';
import '../../features/remedies/data/remedies_api.dart';
import '../../features/waitlist/data/waitlist_api.dart';
import '../../features/reports/data/reports_api.dart';
import '../../features/training/data/training_api.dart';
import '../../features/workspace/data/workspace_api.dart';
import '../../features/waitlist/presentation/cubit/waitlist_cubit.dart';
import '../../features/client_charts/data/client_charts_api.dart';
import '../../features/home/data/dashboard_api.dart';
import '../../features/home/presentation/cubit/tool_counts_cubit.dart';
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
import '../network/session_end.dart';
import '../notifications/local_notifications.dart';
import '../notifications/notification_router.dart';
import '../notifications/push_device_registrar.dart';
import '../notifications/push_service.dart';
import '../realtime/realtime_client.dart';
import '../realtime/realtime_coordinator.dart';
import '../router/pending_deep_link.dart';
import '../storage/token_storage.dart';
import 'package:talkacharya_call/talkacharya_call.dart';

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
    // Chat photos and voice notes, downloaded once and kept on the device.
    ..registerLazySingleton<ChatMediaStore>(
      () => DeviceChatMediaStore(download: chatMediaDownloader(dio)),
    )
    ..registerLazySingleton<AuthApi>(() => AuthApi(dio))
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepository(api: getIt(), tokens: getIt()),
    )
    ..registerLazySingleton<FirebasePhoneAuth>(() => FirebasePhoneAuth());

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
  final push = PushService(
    local,
    realtimeOnline: () =>
        getIt.isRegistered<RealtimeClient>() &&
        getIt<RealtimeClient>().isConnected,
    roomOpen: (thread) =>
        getIt.isRegistered<RoomPresence>() &&
        getIt<RoomPresence>().isOpen(thread),
  );
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
  // Signed in on another phone: leave at once, and say why on the sign-in
  // screen, rather than waiting for the next request to be refused.
  realtime.sessionReplaced.listen((_) async {
    sessionEndReason.value = kSessionReplaced;
    await getIt<TokenStorage>().clear();
    authBloc.add(const AuthSessionExpired());
  });
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
        storage: getIt(),
      ),
    );

  // --- features ------------------------------------------------------
  getIt
    ..registerLazySingleton<ConsultationApi>(() => ConsultationApi(dio))
    ..registerLazySingleton<ConsultationRepository>(
      () => ConsultationRepository(getIt()),
    )
    ..registerLazySingleton<KundaliApi>(() => KundaliApi(dio))
    ..registerLazySingleton<KundaliRepository>(() => KundaliRepository(getIt()))
    ..registerLazySingleton<LiveApi>(() => LiveApi(dio))
    ..registerLazySingleton<PredictionsApi>(() => PredictionsApi(dio))
    ..registerLazySingleton<PredictionsRepository>(
      () => PredictionsRepository(getIt()),
    )
    ..registerLazySingleton<EarningsApi>(() => EarningsApi(dio))
    ..registerLazySingleton<ProfileApi>(() => ProfileApi(dio))
    ..registerLazySingleton<DashboardApi>(() => DashboardApi(dio, getIt()))
    ..registerFactory<DashboardCubit>(
      () => DashboardCubit(
        api: getIt(),
        consultations: getIt(),
        onboarding: getIt(),
        realtime: realtime,
      ),
    )
    // App-level: they also feed the Requests / Chats nav badges.
    ..registerLazySingleton<RequestsCubit>(
      () => RequestsCubit(repo: getIt(), realtime: realtime),
    )
    ..registerLazySingleton<RoomPresence>(RoomPresence.new)
    // Owns the one running call, so it outlives the room screen.
    ..registerLazySingleton<CallHub>(CallHub.new)
    ..registerLazySingleton<ChatsCubit>(
      () => ChatsCubit(api: getIt(), realtime: realtime),
    )
    ..registerFactory<EarningsCubit>(() => EarningsCubit(getIt()))
    ..registerLazySingleton<AmountPrivacy>(() => AmountPrivacy(getIt()))
    ..registerLazySingleton<PerformanceApi>(() => PerformanceApi(dio))
    ..registerLazySingleton<RemediesApi>(() => RemediesApi(dio))
    ..registerLazySingleton<WaitlistApi>(() => WaitlistApi(dio))
    ..registerLazySingleton<WorkspaceApi>(() => WorkspaceApi(dio))
    ..registerLazySingleton<TrainingApi>(() => TrainingApi(dio))
    ..registerLazySingleton<ReportsApi>(() => ReportsApi(dio))
    ..registerLazySingleton<ClientChartsApi>(() => ClientChartsApi(dio))
    // App-level: it also feeds the badge on the Home waitlist tile.
    ..registerLazySingleton<WaitlistCubit>(
      () => WaitlistCubit(api: getIt(), realtime: realtime),
    )
    ..registerLazySingleton<ToolCountsCubit>(
      () => ToolCountsCubit(
        consultations: getIt(),
        predictions: getIt(),
        workspace: getIt(),
        storage: getIt(),
        realtime: realtime,
      ),
    )
    ..registerFactory<PerformanceCubit>(
      () => PerformanceCubit(api: getIt(), availability: getIt()),
    );
}
