import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import '../../features/auth/data/auth_api.dart';
import '../../features/auth/data/auth_repository.dart';
import '../../features/auth/presentation/bloc/auth/auth_bloc.dart';
import '../config/flavor.dart';
import '../network/dio_client.dart';
import '../storage/token_storage.dart';

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
    ..registerLazySingleton<AuthApi>(() => AuthApi(dio))
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepository(api: getIt(), tokens: getIt()),
    );

  authBloc = AuthBloc(getIt<AuthRepository>());
  getIt.registerSingleton<AuthBloc>(authBloc);
}
