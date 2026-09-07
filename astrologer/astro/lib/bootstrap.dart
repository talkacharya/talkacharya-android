import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'src/app/app.dart';
import 'src/core/config/flavor.dart';
import 'src/core/di/service_locator.dart';

class _AppBlocObserver extends BlocObserver {
  const _AppBlocObserver();

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    debugPrint('onError(${bloc.runtimeType}): $error');
    super.onError(bloc, error, stackTrace);
  }
}

/// Single entrypoint for every flavor. `main_*.dart` just calls this.
Future<void> bootstrap(Flavor flavor) async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    debugPrint('FlutterError: ${details.exceptionAsString()}');
  };

  Bloc.observer = const _AppBlocObserver();

  await configureDependencies(AppConfig.fromEnvironment(flavor));

  runApp(const TalkAcharyaApp());
}
