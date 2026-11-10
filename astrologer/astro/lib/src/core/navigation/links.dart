import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:talkacharya_nav/talkacharya_nav.dart';

import '../../features/auth/presentation/bloc/auth/auth_bloc.dart';
import '../../features/consultations/presentation/room_presence.dart';
import '../../shared/widgets/settings_widgets.dart' show showToast;
import '../astro/onboarding_store.dart';
import '../deeplink/deep_link_parser.dart';
import '../di/service_locator.dart';
import '../firebase/firebase_setup.dart';
import '../l10n/l10n.dart';
import '../router/go_router_refresh.dart';
import '../router/routes.dart';

export 'package:talkacharya_nav/talkacharya_nav.dart'
    show AppNavigator, LinkSource;

/// Opens any link — a URI, a push's `deeplink`, an in-app path (`/earnings`)
/// — the one way every link in the app is opened (see `talkacharya_nav`).
void openLink(String? raw, {LinkSource source = LinkSource.inApp}) {
  if (!getIt.isRegistered<AppNavigator>()) return;
  final link = raw?.trim() ?? '';
  if (link.isEmpty) return;
  final location = link.startsWith('/') ? link : locationForRaw(link);
  getIt<AppNavigator>().open(location, source: source, raw: link);
}

/// Opens an in-app [location] (a `Routes.…` path).
void openLocation(String location, {LinkSource source = LinkSource.inApp}) {
  if (!getIt.isRegistered<AppNavigator>()) return;
  getIt<AppNavigator>().open(location, source: source, raw: location);
}

/// What the navigator needs to know about the astrologer app.
class AstroLinkHost extends LinkHost {
  AstroLinkHost({
    required AuthBloc auth,
    required OnboardingStore onboarding,
    required GlobalKey<NavigatorState> navigatorKey,
  }) : _auth = auth,
       _onboarding = onboarding,
       _navigatorKey = navigatorKey,
       _changes = Listenable.merge([
         GoRouterRefreshStream(auth.stream),
         onboarding,
       ]);

  final AuthBloc _auth;
  final OnboardingStore _onboarding;
  final GlobalKey<NavigatorState> _navigatorKey;
  final Listenable _changes;

  @override
  Listenable get changes => _changes;

  @override
  bool get settled => _auth.state.status != AuthStatus.unknown;

  @override
  bool get signedIn => _auth.state.status == AuthStatus.authenticated;

  /// Signed in and approved: past onboarding, the tabs can be shown.
  @override
  bool get ready => signedIn && _onboarding.stage == OnboardingStage.approved;

  @override
  bool get callOnScreen =>
      getIt.isRegistered<RoomPresence>() && getIt<RoomPresence>().callOnScreen;

  @override
  String get homeLocation => Routes.home;

  @override
  String get loginLocation => Routes.login;

  @override
  Set<String> get tabRoots => Routes.branchRoots.toSet();

  @override
  String? roomKind(String path) {
    final segments = Uri(path: path).pathSegments;
    if (segments.length != 2) return null;
    return switch (segments.first) {
      'chats' => 'chat',
      'requests' => 'request',
      'assistant' => 'assistant',
      _ => null,
    };
  }

  @override
  void unavailable() {
    final context = _navigatorKey.currentContext;
    if (context == null || !context.mounted) return;
    showToast(context, context.l10n.linkUnavailable);
  }

  @override
  void report(Object error, StackTrace stack, {String? location}) {
    debugPrint('link failed ($location): $error');
    FirebaseSetup.recordNonFatal(error, stack, reason: 'link: $location');
  }

  @override
  void breadcrumb(String message) => FirebaseSetup.log(message);
}
