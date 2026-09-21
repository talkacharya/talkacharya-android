import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import '../../features/auth/data/auth_api.dart';
import '../../features/auth/data/auth_repository.dart';
import '../../features/auth/data/firebase_phone_auth.dart';
import '../../features/auth/presentation/bloc/auth/auth_bloc.dart';
import '../../features/astrologers/data/astrologers_api.dart';
import '../../features/astrologers/data/astrologers_repository.dart';
import '../../features/astrologers/presentation/cubit/discovery_cubit.dart';
import '../../features/articles/data/articles_api.dart';
import '../../features/articles/data/articles_repository.dart';
import '../../features/birthprofiles/data/birth_profiles_api.dart';
import '../../features/birthprofiles/data/birth_profiles_repository.dart';
import '../../features/birthprofiles/presentation/bloc/birth_profiles_cubit.dart';
import '../../features/consultations/data/consultation_api.dart';
import '../../features/consultations/data/consultation_repository.dart';
import '../../features/consultations/presentation/cubit/chats_list_cubit.dart';
import '../../features/gifting/data/gifting_api.dart';
import '../../features/livestream/data/livestream_api.dart';
import '../../features/follows/data/follows_api.dart';
import '../../features/follows/data/follows_repository.dart';
import '../../features/follows/presentation/cubit/follow_cubit.dart';
import '../../features/gifting/data/gifting_repository.dart';
import '../../features/panchang/data/panchang_api.dart';
import '../../features/panchang/data/panchang_repository.dart';
import '../../features/store/data/store_api.dart';
import '../../features/store/data/store_repository.dart';
import '../../features/store/presentation/cubit/cart_cubit.dart';
import '../../features/support/data/support_api.dart';
import '../../features/support/data/support_repository.dart';
import '../../features/kundali/data/kundali_api.dart';
import '../../features/kundali/data/kundali_repository.dart';
import '../../features/prashna/data/prashna_api.dart';
import '../../features/prashna/data/prashna_repository.dart';
import '../../features/predictions/data/predictions_api.dart';
import '../../features/predictions/data/predictions_repository.dart';
import '../../features/home/data/home_api.dart';
import '../../features/horoscope/data/horoscope_repository.dart';
import '../../features/consultations/data/pending_share.dart';
import '../../features/consultations/presentation/room_presence.dart';
import '../../features/matchmaking/data/matchmaking_repository.dart';
import '../../features/wallet/data/wallet_api.dart';
import '../../features/wallet/data/wallet_repository.dart';
import '../../features/wallet/presentation/cubit/transactions_cubit.dart';
import '../../features/wallet/presentation/cubit/wallet_cubit.dart';
import '../payments/razorpay_service.dart';
import '../../features/home/data/home_repository.dart';
import '../../features/home/data/horoscope_sign_store.dart';
import '../../features/home/presentation/cubit/home_cubit.dart';
import '../../features/notifications/data/notifications_api.dart';
import '../../features/notifications/data/notifications_repository.dart';
import '../../features/notifications/presentation/bloc/notifications_cubit.dart';
import '../../features/profile/data/profile_api.dart';
import '../../features/profile/data/referrals_api.dart';
import '../config/config_repository.dart';
import '../config/flavor.dart';
import '../deeplink/deep_link_service.dart';
import '../profile/active_profile_store.dart';
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
import 'package:talkacharya_call/talkacharya_call.dart';

final getIt = GetIt.instance;

/// Wire singletons once, at startup. [onSessionExpired] is injected late (after
/// [AuthBloc] exists) so the Dio auth interceptor can notify it on refresh failure.
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
    )
    ..registerLazySingleton<FirebasePhoneAuth>(() => FirebasePhoneAuth());

  authBloc = AuthBloc(getIt<AuthRepository>());
  getIt.registerSingleton<AuthBloc>(authBloc);

  // --- config / connectivity -------------------------------------------------
  getIt
    ..registerSingleton<PendingDeepLink>(PendingDeepLink())
    ..registerSingleton<ConnectivityService>(ConnectivityService())
    ..registerSingleton<ActiveProfileStore>(ActiveProfileStore(getIt()))
    ..registerSingleton<ConfigRepository>(
      ConfigRepository(dio: dio, storage: getIt()),
    );

  // --- birth profiles ------------------------------------------------------
  getIt
    ..registerLazySingleton<BirthProfilesApi>(() => BirthProfilesApi(dio))
    ..registerLazySingleton<BirthProfilesRepository>(
      () => BirthProfilesRepository(getIt()),
    )
    ..registerLazySingleton<BirthProfilesCubit>(
      () => BirthProfilesCubit(repo: getIt(), store: getIt()),
    )
    ..registerLazySingleton<KundaliApi>(() => KundaliApi(dio))
    ..registerLazySingleton<KundaliRepository>(() => KundaliRepository(getIt()))
    ..registerLazySingleton<PredictionsApi>(() => PredictionsApi(dio))
    ..registerLazySingleton<PredictionsRepository>(
      () => PredictionsRepository(getIt()),
    )
    ..registerLazySingleton<PrashnaApi>(() => PrashnaApi(dio))
    ..registerLazySingleton<PrashnaRepository>(() => PrashnaRepository(getIt()))
    ..registerLazySingleton<PendingShare>(PendingShare.new)
    ..registerLazySingleton<RoomPresence>(RoomPresence.new)
    // Owns the one running call, so it outlives the room screen.
    ..registerLazySingleton<CallHub>(CallHub.new)
    ..registerLazySingleton<MatchmakingRepository>(
      () => MatchmakingRepository(dio),
    )
    ..registerLazySingleton<HoroscopeRepository>(() => HoroscopeRepository(dio))
    ..registerLazySingleton<ConsultationApi>(() => ConsultationApi(dio))
    ..registerLazySingleton<ConsultationRepository>(
      () => ConsultationRepository(getIt()),
    );

  // --- discovery + home feed ---------------------------------------------
  getIt
    ..registerLazySingleton<AstrologersApi>(() => AstrologersApi(dio))
    ..registerLazySingleton<AstrologersRepository>(
      () => AstrologersRepository(getIt()),
    )
    ..registerLazySingleton<FollowsApi>(() => FollowsApi(dio))
    ..registerLazySingleton<FollowsRepository>(() => FollowsRepository(getIt()))
    // app-wide: every follow control reads the same edges
    ..registerLazySingleton<FollowCubit>(() => FollowCubit(getIt()))
    ..registerFactory<DiscoveryCubit>(() => DiscoveryCubit(getIt()))
    ..registerLazySingleton<LivestreamApi>(() => LivestreamApi(dio))
    ..registerLazySingleton<ArticlesApi>(() => ArticlesApi(dio))
    ..registerLazySingleton<ArticlesRepository>(
      () => ArticlesRepository(getIt()),
    )
    ..registerLazySingleton<HomeApi>(() => HomeApi(dio))
    ..registerSingleton<HoroscopeSignStore>(HoroscopeSignStore(getIt()))
    ..registerLazySingleton<HomeRepository>(
      () => HomeRepository(
        api: getIt(),
        astrologers: getIt(),
        config: getIt(),
        articles: getIt(),
      ),
    )
    ..registerFactory<HomeCubit>(
      () => HomeCubit(repo: getIt(), signStore: getIt()),
    );

  // --- notifications inbox -------------------------------------------------
  getIt
    ..registerLazySingleton<NotificationsApi>(() => NotificationsApi(dio))
    ..registerLazySingleton<NotificationsRepository>(
      () => NotificationsRepository(getIt()),
    )
    ..registerLazySingleton<ProfileApi>(() => ProfileApi(dio))
    ..registerLazySingleton<ReferralsApi>(() => ReferralsApi(dio))
    ..registerLazySingleton<NotificationsCubit>(
      () => NotificationsCubit(getIt()),
    );

  // --- push -----------------------------------------------------------------
  final local = LocalNotifications();
  final push = PushService(
    local,
    realtimeOnline: () =>
        getIt.isRegistered<RealtimeClient>() &&
        getIt<RealtimeClient>().isConnected,
  );
  getIt
    ..registerSingleton<LocalNotifications>(local)
    ..registerSingleton<PushService>(push)
    ..registerSingleton<NotificationRouter>(
      NotificationRouter(push: push, local: local),
    )
    ..registerSingleton<PushDeviceRegistrar>(
      PushDeviceRegistrar(push: push, authBloc: authBloc, dio: dio),
    );

  // --- deep links ---------------------------------------------------------
  getIt.registerSingleton<DeepLinkService>(DeepLinkService());

  // --- realtime ---------------------------------------------------------
  final realtime = RealtimeClient(dio);
  getIt
    ..registerSingleton<RealtimeClient>(realtime)
    ..registerSingleton<RealtimeCoordinator>(
      RealtimeCoordinator(client: realtime, authBloc: authBloc),
    )
    ..registerLazySingleton<ChatsListCubit>(
      () => ChatsListCubit(repo: getIt(), realtime: realtime),
    );

  // --- wallet ----------------------------------------------------------
  getIt
    ..registerLazySingleton<RazorpayService>(RazorpayService.new)
    ..registerLazySingleton<WalletApi>(() => WalletApi(dio))
    ..registerLazySingleton<WalletRepository>(
      () => WalletRepository(api: getIt(), config: getIt()),
    )
    ..registerSingleton<WalletCubit>(
      WalletCubit(repo: getIt(), realtime: realtime),
    )
    ..registerFactory<TransactionsCubit>(() => TransactionsCubit(getIt()));

  // --- gifting ---------------------------------------------------------
  getIt
    ..registerLazySingleton<GiftingApi>(() => GiftingApi(dio))
    ..registerLazySingleton<GiftingRepository>(
      () => GiftingRepository(getIt()),
    );

  // --- panchang ----------------------------------------------------------
  getIt
    ..registerLazySingleton<PanchangApi>(() => PanchangApi(dio))
    ..registerLazySingleton<PanchangRepository>(
      () => PanchangRepository(api: getIt(), storage: getIt()),
    );

  // --- help & disputes -----------------------------------------------------
  getIt
    ..registerLazySingleton<SupportApi>(() => SupportApi(dio))
    ..registerLazySingleton<SupportRepository>(
      () => SupportRepository(api: getIt(), consultations: getIt()),
    );

  // --- store (remedies shop, poojas, consult before buying) ----------------
  getIt
    ..registerLazySingleton<StoreApi>(() => StoreApi(dio))
    ..registerLazySingleton<StoreRepository>(() => StoreRepository(getIt()))
    ..registerLazySingleton<CartCubit>(
      () => CartCubit(getIt(), auth: getIt<AuthBloc>().stream),
    );
}
