import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:talkacharya_nav/talkacharya_nav.dart';

import '../../features/auth/presentation/bloc/auth/auth_bloc.dart';
import '../profile/active_profile_store.dart';
import '../../features/consultations/presentation/room_presence.dart';
import '../../shared/widgets/app_snack.dart';
import '../deeplink/deep_link_parser.dart';
import '../di/service_locator.dart';
import '../firebase/firebase_setup.dart';
import '../l10n/l10n.dart';
import '../router/go_router_refresh.dart';
import '../router/routes.dart';

export 'package:talkacharya_nav/talkacharya_nav.dart'
    show AppNavigator, LinkSource;

/// Opens any link — a URI, a push's `deeplink`, an in-app path (`/wallet`) —
/// the one way every link in the app is opened (see `talkacharya_nav`).
void openLink(String? raw, {LinkSource source = LinkSource.inApp}) {
  if (!getIt.isRegistered<AppNavigator>()) return;
  final link = raw?.trim() ?? '';
  if (link.isEmpty) return;
  // An in-app path goes as it is (the navigator checks it exists); anything
  // else is a URI for the parser.
  final location = link.startsWith('/') ? link : locationForRaw(link);
  getIt<AppNavigator>().open(location, source: source, raw: link);
}

/// Opens an in-app [location] (a `Routes.…` path).
void openLocation(String location, {LinkSource source = LinkSource.inApp}) {
  if (!getIt.isRegistered<AppNavigator>()) return;
  getIt<AppNavigator>().open(location, source: source, raw: location);
}

/// True when signed in. Signed out (someone reading a shared profile or an
/// article), it sends them to sign in and, once they have, back to
/// [returnTo] — consulting, following, gifting need a session.
bool ensureSignedIn({String? returnTo}) {
  // Without a session to ask about (a widget shown on its own) there is
  // nothing to guard: let the action go ahead rather than block or throw.
  if (!getIt.isRegistered<AuthBloc>()) return true;
  if (getIt<AuthBloc>().state.status == AuthStatus.authenticated) return true;
  if (getIt.isRegistered<AppNavigator>()) {
    getIt<AppNavigator>().signInThen(returnTo);
  }
  return false;
}

/// What the navigator needs to know about the customer app.
class CustomerLinkHost extends LinkHost {
  CustomerLinkHost({
    required AuthBloc auth,
    required ActiveProfileStore profiles,
    required GlobalKey<NavigatorState> navigatorKey,
  }) : _auth = auth,
       _profiles = profiles,
       _navigatorKey = navigatorKey,
       _changes = Listenable.merge([
         GoRouterRefreshStream(auth.stream),
         profiles,
       ]);

  final AuthBloc _auth;
  final ActiveProfileStore _profiles;
  final GlobalKey<NavigatorState> _navigatorKey;
  final Listenable _changes;

  @override
  Listenable get changes => _changes;

  @override
  bool get settled => _auth.state.status != AuthStatus.unknown;

  @override
  bool get signedIn => _auth.state.status == AuthStatus.authenticated;

  /// Signed in and past the birth-profile picker shown after sign-in.
  @override
  bool get ready => signedIn && !_profiles.loginGatePending;

  @override
  bool get callOnScreen =>
      getIt.isRegistered<RoomPresence>() && getIt<RoomPresence>().callOnScreen;

  @override
  String get homeLocation => Routes.home;

  @override
  String get loginLocation => Routes.login;

  @override
  Set<String> get tabRoots => const {
    Routes.home,
    Routes.astrologers,
    Routes.store,
    Routes.profile,
  };

  @override
  String? publicLocation(String location) =>
      isPublicLocation(location) ? location : null;

  @override
  String? roomKind(String path) {
    final segments = Uri(path: path).pathSegments;
    if (segments.length != 2) return null;
    return switch (segments.first) {
      'consultations' => 'consultation',
      'assistant' => 'assistant',
      'live' => 'live',
      _ => null,
    };
  }

  @override
  void unavailable() {
    final context = _navigatorKey.currentContext;
    if (context == null || !context.mounted) return;
    AppSnack.showTop(context, context.l10n.linkUnavailable);
  }

  @override
  void report(Object error, StackTrace stack, {String? location}) {
    debugPrint('link failed ($location): $error');
    FirebaseSetup.recordNonFatal(error, stack, reason: 'link: $location');
  }

  @override
  void breadcrumb(String message) => FirebaseSetup.log(message);
}

/// Pages anyone may open without signing in: articles, the horoscope and an
/// astrologer's profile. Signing in is asked for when they consult, follow
/// or gift.
bool isPublicLocation(String location) {
  final segments = (Uri.tryParse(location)?.pathSegments ?? const <String>[])
      .where((s) => s.isNotEmpty)
      .toList();
  if (segments.isEmpty) return false;
  return switch (segments.first) {
    'articles' || 'horoscope' => true,
    // `/astrologers/<id>` (and its reviews) — not the Astrologers tab.
    'astrologers' => segments.length >= 2,
    _ => false,
  };
}
