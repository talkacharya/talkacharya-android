import 'package:flutter/foundation.dart';

/// Where a link came from. The rules are the same for every source; it is
/// kept for the breadcrumb so a wrong landing can be traced back.
enum LinkSource {
  /// The link or notification that started the app.
  launch,

  /// A notification tapped while the app was running or in the background.
  push,

  /// A deep link / App Link opened while the app was running.
  link,

  /// A link inside the app: the notifications list, a banner, an article.
  inApp,
}

/// What [AppNavigator] needs to know about the app it navigates.
abstract class LinkHost {
  /// Changes whenever [settled], [signedIn] or [ready] may have changed (the
  /// auth bloc, onboarding, the birth-profile gate…). The navigator re-checks
  /// its waiting link on every change.
  Listenable get changes;

  /// The session is known — signed in or not. False while the splash decides.
  bool get settled;

  /// Signed in (gates may still be ahead).
  bool get signedIn;

  /// Signed in and past every gate: the tabs can be shown.
  bool get ready;

  /// A call is on screen: nothing may replace the stack under it.
  bool get callOnScreen;

  /// The first tab — what comes up beneath a page on a cold start.
  String get homeLocation;

  /// Where a signed-out user is sent.
  String get loginLocation;

  /// The tab roots. A link to one switches to that tab.
  Set<String> get tabRoots;

  /// For a signed-out user: where [location] can be shown without signing in,
  /// or null when it needs a session.
  String? publicLocation(String location) => null;

  /// Pages of one kind where a second replaces the first rather than stacking
  /// (a chat room). Two paths with the same non-null kind are the same kind.
  String? roomKind(String path) => null;

  /// The link led nowhere (unknown, or its page no longer exists): Home has
  /// been opened instead — tell the person.
  void unavailable();

  /// Something went wrong opening a link. Never thrown to the caller.
  void report(Object error, StackTrace stack, {String? location}) {}

  /// A line for the crash reporter's breadcrumbs: which link, from where, how
  /// it was opened.
  void breadcrumb(String message) {}
}
