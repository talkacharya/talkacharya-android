import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'src/app/app.dart';
import 'src/core/config/config_repository.dart';
import 'src/core/config/flavor.dart';
import 'src/core/network/friendly_error.dart';
import 'src/shared/widgets/app_error_widget.dart';
import 'src/core/di/service_locator.dart';
import 'src/core/firebase/firebase_setup.dart';
import 'src/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'src/core/profile/active_profile_store.dart';
import 'src/core/notifications/local_notifications.dart';
import 'src/core/notifications/push_service.dart';
import 'src/features/home/data/horoscope_sign_store.dart';
import 'package:talkacharya_call/talkacharya_call.dart';
import 'src/core/sounds/app_sound_adapters.dart';

class _AppBlocObserver extends BlocObserver {
  const _AppBlocObserver();

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    // `error.toString()` is deliberately human-readable in production, so logs
    // and crash reports carry the technical form explicitly.
    final detail = technicalError(error);
    debugPrint('onError(${bloc.runtimeType}): $detail');
    unawaited(
      FirebaseSetup.recordNonFatal(
        error,
        stackTrace,
        reason: 'bloc:${bloc.runtimeType} $detail',
      ),
    );
    super.onError(bloc, error, stackTrace);
  }
}

/// Single entrypoint for every flavor. `main_*.dart` just calls this.
Future<void> bootstrap(Flavor flavor) async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Color(0x00000000),
      systemNavigationBarColor: Color(0x00000000),
      systemNavigationBarContrastEnforced: false,
    ),
  );
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    debugPrint('FlutterError: ${details.exceptionAsString()}');
  };

  // Firebase + App Check + Crashlytics first: App Check must be active before the
  // first Firebase Auth call, and Crashlytics should see startup failures.
  await FirebaseSetup.init(flavor);

  Bloc.observer = const _AppBlocObserver();

  // Call controls buzz through the app's preference, like every other
  // button.
  callHaptics = const AppCallHaptics();

  final config = AppConfig.fromEnvironment(flavor);
  // Production shows people a sentence, never an exception. Dev and staging keep
  // the technical detail on screen so a bug is diagnosable from a screenshot.
  showErrorDetails = !config.isProd;
  ErrorWidget.builder = (details) => AppErrorWidget(details: details);

  await configureDependencies(config);
  getIt<AuthBloc>().stream.listen((s) => FirebaseSetup.setUser(s.user?.id));

  // Non-fatal startup work: push + local notifications degrade to no-ops if
  // Firebase is unavailable; the config prime falls back to a cached/default copy.
  await getIt<LocalNotifications>().init();
  await getIt<PushService>().init();
  await getIt<ActiveProfileStore>().load();
  await getIt<HoroscopeSignStore>().load();
  unawaited(getIt<ConfigRepository>().prime());

  runApp(const TalkAcharyaApp());
}
