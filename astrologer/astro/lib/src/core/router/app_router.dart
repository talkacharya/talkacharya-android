import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/bloc/auth/auth_bloc.dart';
import '../../features/auth/presentation/view/login_page.dart';
import '../../features/home/presentation/view/home_page.dart';
import '../../app/view/splash_page.dart';
import 'go_router_refresh.dart';

class Routes {
  const Routes._();
  static const splash = '/';
  static const login = '/login';
  static const home = '/home';
}

/// Route table + auth gate. `redirect` runs on every navigation and whenever
/// [AuthBloc] emits (via [GoRouterRefreshStream]).
GoRouter buildRouter(AuthBloc authBloc) {
  return GoRouter(
    initialLocation: Routes.splash,
    refreshListenable: GoRouterRefreshStream(authBloc.stream),
    redirect: (context, state) {
      final status = authBloc.state.status;
      final loc = state.matchedLocation;

      if (status == AuthStatus.unknown) {
        return loc == Routes.splash ? null : Routes.splash;
      }
      final loggedIn = status == AuthStatus.authenticated;
      final atLogin = loc == Routes.login;

      if (!loggedIn) return atLogin ? null : Routes.login;
      if (atLogin || loc == Routes.splash) return Routes.home;
      return null;
    },
    routes: [
      GoRoute(path: Routes.splash, builder: (_, _) => const SplashPage()),
      GoRoute(path: Routes.login, builder: (_, _) => const LoginPage()),
      GoRoute(path: Routes.home, builder: (_, _) => const HomePage()),
    ],
  );
}
