import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/config/flavor.dart';
import '../core/di/service_locator.dart';
import '../core/router/app_router.dart';
import '../core/theme/app_theme.dart';
import '../features/auth/presentation/bloc/auth/auth_bloc.dart';

class TalkAcharyaApp extends StatelessWidget {
  const TalkAcharyaApp({super.key});

  @override
  Widget build(BuildContext context) {
    final config = getIt<AppConfig>();
    return BlocProvider.value(
      value: getIt<AuthBloc>()..add(const AuthStarted()),
      child: Builder(
        builder: (context) {
          final router = buildRouter(context.read<AuthBloc>());
          return MaterialApp.router(
            title: config.appName,
            debugShowCheckedModeBanner: !config.isProd,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            routerConfig: router,
          );
        },
      ),
    );
  }
}
