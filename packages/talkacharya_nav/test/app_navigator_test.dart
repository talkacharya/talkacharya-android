import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:talkacharya_nav/talkacharya_nav.dart';

class _Host extends LinkHost {
  final notifier = ChangeNotifier();
  bool isSettled = true;
  bool isSignedIn = true;
  bool isReady = true;
  bool inCall = false;
  int unavailableCount = 0;
  final errors = <Object>[];

  void set({bool? settled, bool? signedIn, bool? ready}) {
    isSettled = settled ?? isSettled;
    isSignedIn = signedIn ?? isSignedIn;
    isReady = ready ?? isReady;
    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    notifier.notifyListeners();
  }

  @override
  Listenable get changes => notifier;
  @override
  bool get settled => isSettled;
  @override
  bool get signedIn => isSignedIn;
  @override
  bool get ready => isReady;
  @override
  bool get callOnScreen => inCall;
  @override
  String get homeLocation => '/home';
  @override
  String get loginLocation => '/login';
  @override
  Set<String> get tabRoots => const {'/home', '/astrologers', '/profile'};

  @override
  String? publicLocation(String location) =>
      location.startsWith('/articles/') ? location : null;

  @override
  String? roomKind(String path) =>
      path.startsWith('/consultations/') ? 'room' : null;

  @override
  void unavailable() => unavailableCount++;

  @override
  void report(Object error, StackTrace stack, {String? location}) =>
      errors.add(error);
}

Widget _page(String name) => Scaffold(body: Center(child: Text(name)));

GoRouter _router(_Host host, {String initial = '/'}) {
  final root = GlobalKey<NavigatorState>();
  return GoRouter(
    navigatorKey: root,
    initialLocation: initial,
    // The apps' routers re-run their redirect when the session changes.
    refreshListenable: host.notifier,
    redirect: (_, state) {
      final loc = state.matchedLocation;
      if (!host.settled) return loc == '/' ? null : '/';
      if (!host.signedIn) {
        if (loc.startsWith('/articles/')) return null;
        return loc == '/login' ? null : '/login';
      }
      if (loc == '/' || loc == '/login') return '/home';
      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (_, _) => _page('splash')),
      GoRoute(path: '/login', builder: (_, _) => _page('login')),
      GoRoute(
        path: '/notifications',
        parentNavigatorKey: root,
        builder: (_, _) => _page('notifications'),
      ),
      GoRoute(
        path: '/consultations/:id',
        parentNavigatorKey: root,
        builder: (_, s) => _page('room ${s.pathParameters['id']}'),
      ),
      GoRoute(
        path: '/articles/:id',
        parentNavigatorKey: root,
        builder: (_, s) => _page('article ${s.pathParameters['id']}'),
      ),
      StatefulShellRoute.indexedStack(
        builder: (_, _, shell) => Scaffold(body: shell),
        branches: [
          StatefulShellBranch(
            routes: [GoRoute(path: '/home', builder: (_, _) => _page('home'))],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/astrologers',
                builder: (_, _) => _page('astrologers'),
                routes: [
                  GoRoute(
                    path: ':id',
                    parentNavigatorKey: root,
                    builder: (_, s) =>
                        _page('astrologer ${s.pathParameters['id']}'),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/profile', builder: (_, _) => _page('profile')),
            ],
          ),
        ],
      ),
    ],
  );
}

Future<(GoRouter, AppNavigator)> _app(
  WidgetTester tester,
  _Host host, {
  String initial = '/',
}) async {
  final router = _router(host, initial: initial);
  final nav = AppNavigator(router: router, host: host)..start();
  addTearDown(nav.dispose);
  await tester.pumpWidget(MaterialApp.router(routerConfig: router));
  await tester.pumpAndSettle();
  return (router, nav);
}

Future<void> _back(WidgetTester tester, GoRouter router) async {
  router.pop();
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('a tab opens as that tab', (tester) async {
    final host = _Host();
    final (_, nav) = await _app(tester, host);
    nav.open('/profile', source: LinkSource.push);
    await tester.pumpAndSettle();
    expect(find.text('profile'), findsOneWidget);
  });

  testWidgets('a page opens above where the person is; back returns there', (
    tester,
  ) async {
    final host = _Host();
    final (router, nav) = await _app(tester, host);
    router.go('/profile');
    await tester.pumpAndSettle();

    nav.open('/astrologers/a1', source: LinkSource.push);
    await tester.pumpAndSettle();
    expect(find.text('astrologer a1'), findsOneWidget);

    await _back(tester, router);
    expect(find.text('profile'), findsOneWidget);
  });

  testWidgets('a cold start waits for the gates, then opens over Home', (
    tester,
  ) async {
    final host = _Host()
      ..isSettled = false
      ..isReady = false;
    final (router, nav) = await _app(tester, host);
    nav.open('/consultations/c1', source: LinkSource.launch);
    await tester.pumpAndSettle();
    expect(find.text('splash'), findsOneWidget);
    expect(nav.hasWaiting, isTrue);

    host.set(settled: true, ready: true);
    await tester.pumpAndSettle();
    expect(find.text('room c1'), findsOneWidget);
    await _back(tester, router);
    expect(find.text('home'), findsOneWidget, reason: 'tabs beneath');
  });

  testWidgets('signed out, a private page waits for the sign-in', (
    tester,
  ) async {
    final host = _Host()
      ..isSignedIn = false
      ..isReady = false;
    final (_, nav) = await _app(tester, host);
    nav.open('/consultations/c1', source: LinkSource.link);
    await tester.pumpAndSettle();
    expect(find.text('login'), findsOneWidget);

    host.set(signedIn: true, ready: true);
    await tester.pumpAndSettle();
    expect(find.text('room c1'), findsOneWidget);
  });

  testWidgets('signed out, a public page opens over the sign-in screen', (
    tester,
  ) async {
    final host = _Host()
      ..isSignedIn = false
      ..isReady = false;
    final (router, nav) = await _app(tester, host);
    nav.open('/articles/x', source: LinkSource.link);
    await tester.pumpAndSettle();
    expect(find.text('article x'), findsOneWidget);
    await _back(tester, router);
    expect(find.text('login'), findsOneWidget);
  });

  testWidgets('acting on a public page signs in, then returns to it', (
    tester,
  ) async {
    final host = _Host()
      ..isSignedIn = false
      ..isReady = false;
    final (_, nav) = await _app(tester, host);
    nav.open('/articles/x', source: LinkSource.link);
    await tester.pumpAndSettle();

    nav.signInThen('/articles/x');
    await tester.pumpAndSettle();
    expect(find.text('login'), findsOneWidget, reason: 'not the page again');

    host.set(signedIn: true, ready: true);
    await tester.pumpAndSettle();
    expect(find.text('article x'), findsOneWidget);
  });

  testWidgets('the page on top is not opened twice', (tester) async {
    final host = _Host();
    final (router, nav) = await _app(tester, host);
    nav.open('/notifications');
    await tester.pumpAndSettle();
    nav.open('/notifications', source: LinkSource.push);
    await tester.pumpAndSettle();
    await _back(tester, router);
    expect(find.text('home'), findsOneWidget);
  });

  testWidgets('a second room replaces the first', (tester) async {
    final host = _Host();
    final (router, nav) = await _app(tester, host);
    nav.open('/consultations/a');
    await tester.pumpAndSettle();
    nav.open('/consultations/b', source: LinkSource.push);
    await tester.pumpAndSettle();
    expect(find.text('room b'), findsOneWidget);
    await _back(tester, router);
    expect(find.text('home'), findsOneWidget, reason: 'A was replaced');
  });

  testWidgets('an unknown link opens Home and says so', (tester) async {
    final host = _Host();
    final (router, nav) = await _app(tester, host);
    router.go('/profile');
    await tester.pumpAndSettle();
    nav.open(null, source: LinkSource.push, raw: 'talkacharya://nowhere');
    await tester.pumpAndSettle();
    expect(find.text('home'), findsOneWidget);
    expect(host.unavailableCount, 1);
  });

  testWidgets('a mapped link with no page behind it opens Home', (
    tester,
  ) async {
    final host = _Host();
    final (_, nav) = await _app(tester, host);
    nav.open('/no/such/page', source: LinkSource.push);
    await tester.pumpAndSettle();
    expect(find.text('home'), findsOneWidget);
    expect(host.unavailableCount, 1);
    expect(host.errors, isEmpty);
  });

  testWidgets('during a call pages stack on top and tabs wait', (tester) async {
    final host = _Host();
    final (router, nav) = await _app(tester, host);
    nav.open('/consultations/call');
    await tester.pumpAndSettle();
    host.inCall = true;

    nav.open('/profile', source: LinkSource.push);
    await tester.pumpAndSettle();
    expect(find.text('room call'), findsOneWidget, reason: 'call kept');

    nav.open('/notifications', source: LinkSource.push);
    await tester.pumpAndSettle();
    await _back(tester, router);
    expect(find.text('room call'), findsOneWidget);
  });

  testWidgets('one tap reported twice opens once', (tester) async {
    final host = _Host();
    final (router, nav) = await _app(tester, host);
    nav.open('/astrologers/a1', source: LinkSource.push);
    nav.open('/astrologers/a1', source: LinkSource.push);
    await tester.pumpAndSettle();
    await _back(tester, router);
    expect(find.text('home'), findsOneWidget);
  });

  testWidgets('nothing at all opens nothing', (tester) async {
    final host = _Host();
    final (_, nav) = await _app(tester, host);
    nav.open(null);
    nav.open('  ', raw: '');
    await tester.pumpAndSettle();
    expect(find.text('home'), findsOneWidget);
    expect(host.unavailableCount, 0);
  });
}
