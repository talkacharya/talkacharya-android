import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

import 'link_host.dart';

/// Opens every link the same way, from wherever it came. See the library doc.
///
/// The one rule that makes the rest simple: **a page is only ever pushed onto
/// tabs that are already on screen.** Until the app is past its gates and the
/// tabs are up, a link waits in a single slot (the newest wins); the moment
/// they are, it opens. A `go` and a `push` are never issued together — they
/// race, and the push can lose.
///
/// Nothing here throws to the caller: a failure is reported to the host and
/// the app stays where it was.
class AppNavigator {
  AppNavigator({
    required GoRouter router,
    required LinkHost host,
    this.repeatWindow = const Duration(seconds: 2),
    DateTime Function()? now,
  }) : _router = router,
       _host = host,
       _now = now ?? DateTime.now;

  final GoRouter _router;
  final LinkHost _host;
  final DateTime Function() _now;

  /// The same destination asked for twice within this window opens once — a
  /// notification tapped twice, or one tap reported by two channels (the push
  /// and the local notification, or the launch link and the launch push).
  final Duration repeatWindow;

  _Waiting? _waiting;
  String? _last;
  DateTime? _lastAt;
  bool _started = false;
  bool _disposed = false;
  bool _flushQueued = false;

  /// A link is waiting for the app to be ready.
  bool get hasWaiting => _waiting != null;

  /// Listens for the gates opening and the tabs coming up.
  void start() {
    if (_started || _disposed) return;
    _started = true;
    _router.routerDelegate.addListener(_onChange);
    _host.changes.addListener(_onChange);
  }

  void dispose() {
    if (_disposed) return;
    _disposed = true;
    if (_started) {
      _router.routerDelegate.removeListener(_onChange);
      _host.changes.removeListener(_onChange);
    }
    _waiting = null;
  }

  /// Opens [location] (an in-app path from the app's link parser).
  ///
  /// [raw] is what came in — a URI, a push's `deeplink`. When it was there but
  /// [location] is null (the parser knows no such page) Home opens and the
  /// person is told the link is no longer available. Both empty: nothing.
  void open(
    String? location, {
    LinkSource source = LinkSource.inApp,
    String? raw,
  }) {
    if (_disposed) return;
    try {
      final asked = location?.trim() ?? '';
      final unknown = asked.isEmpty;
      if (unknown && (raw == null || raw.trim().isEmpty)) return;
      final target = unknown ? _host.homeLocation : asked;
      if (_isRepeat(unknown ? 'unknown:$raw' : target)) return;
      _host.breadcrumb(
        'link ${source.name}: ${unknown ? 'unknown "$raw" → home' : target}',
      );
      if (!_host.ready) {
        _waiting = _Waiting(target, unknown: unknown);
        _scheduleFlush();
        return;
      }
      _place(target, unknown: unknown);
    } catch (e, s) {
      _host.report(e, s, location: location ?? raw);
    }
  }

  /// Signed out, on something that needs a session (consult, follow, gift):
  /// to sign-in now, and — once signed in — to [location].
  void signInThen(String? location) {
    if (_disposed) return;
    try {
      final target = location?.trim() ?? '';
      if (target.isNotEmpty) {
        _waiting = _Waiting(target, unknown: false)..signInFirst = true;
      }
      _host.breadcrumb('link: sign in, then ${target.isEmpty ? '-' : target}');
      _router.go(_host.loginLocation);
    } catch (e, s) {
      _host.report(e, s, location: location);
    }
  }

  // --- waiting ----------------------------------------------------------------

  void _onChange() => _scheduleFlush();

  void _scheduleFlush() {
    if (_flushQueued || _disposed || _waiting == null) return;
    _flushQueued = true;
    // Never from inside the router's own notification or a build.
    scheduleMicrotask(() {
      _flushQueued = false;
      _flush();
    });
  }

  void _flush() {
    final w = _waiting;
    if (w == null || _disposed) return;
    try {
      if (_host.ready) {
        if (_shellUp) {
          _waiting = null;
          _place(w.location, unknown: w.unknown);
        } else if (!w.homeAsked) {
          // Past the gates but something other than the tabs is up (a page
          // opened on its own): bring the tabs up once, then open from there.
          w.homeAsked = true;
          _router.go(_host.homeLocation);
        }
        return;
      }
      if (_host.settled && !_host.signedIn) {
        // Signed out: a public page opens over the sign-in screen; anything
        // else keeps waiting for the sign-in.
        final public = w.signInFirst ? null : _host.publicLocation(w.location);
        if (public != null && _at(_host.loginLocation)) {
          _waiting = null;
          _host.breadcrumb('link: public $public over sign-in');
          _router.push(public).ignore();
        }
      }
    } catch (e, s) {
      _waiting = null;
      _host.report(e, s, location: w.location);
    }
  }

  // --- placing ----------------------------------------------------------------

  void _place(String target, {required bool unknown}) {
    final uri = Uri.tryParse(target);
    if (uri == null || !_exists(uri)) {
      // The parser mapped it, but the app has no such page (any more).
      if (target != _host.homeLocation) {
        _host.breadcrumb('link: no route for $target → home');
        _place(_host.homeLocation, unknown: true);
      }
      return;
    }

    if (_host.callOnScreen) {
      // A `go` would tear the call's room down. Stack pages on top; a tab
      // can wait until the call is over.
      if (!_isTab(uri)) _router.push(target).ignore();
      if (unknown) _host.unavailable();
      return;
    }

    if (_isTab(uri)) {
      _router.go(target);
      if (unknown) _host.unavailable();
      return;
    }

    if (!_shellUp) {
      // Nothing beneath yet (a cold start): Home first; this opens on top as
      // soon as the tabs are up.
      _waiting = _Waiting(target, unknown: unknown)..homeAsked = true;
      _router.go(_host.homeLocation);
      return;
    }

    final top = _topUri();
    if (top.path == uri.path &&
        mapEquals(top.queryParameters, uri.queryParameters)) {
      return; // already looking at it
    }
    final kind = _host.roomKind(uri.path);
    if (kind != null && kind == _host.roomKind(top.path)) {
      // Chat A is open and the link is chat B: B takes A's place.
      _router.pushReplacement(target).ignore();
    } else {
      _router.push(target).ignore();
    }
    if (unknown) _host.unavailable();
  }

  // --- the router's state -----------------------------------------------------

  bool _exists(Uri uri) {
    final match = _router.configuration.findMatch(uri);
    return !match.isError && match.matches.isNotEmpty;
  }

  bool _isTab(Uri uri) => _host.tabRoots.contains(uri.path);

  /// The tabs are at the bottom of what is on screen.
  bool get _shellUp {
    final matches = _router.routerDelegate.currentConfiguration.matches;
    return matches.isNotEmpty && matches.first is ShellRouteMatch;
  }

  bool _at(String location) =>
      _router.routerDelegate.currentConfiguration.uri.path == location;

  /// The location of the page on top, pushed pages included.
  Uri _topUri() {
    var list = _router.routerDelegate.currentConfiguration;
    while (list.matches.isNotEmpty &&
        list.matches.last is ImperativeRouteMatch) {
      list = (list.matches.last as ImperativeRouteMatch).matches;
    }
    return list.uri;
  }

  bool _isRepeat(String key) {
    final now = _now();
    final repeat =
        key == _last &&
        _lastAt != null &&
        now.difference(_lastAt!) < repeatWindow;
    _last = key;
    _lastAt = now;
    return repeat;
  }
}

class _Waiting {
  _Waiting(this.location, {required this.unknown});

  final String location;
  final bool unknown;

  /// Home has been asked for once already — never twice, so a gate that
  /// redirects Home elsewhere cannot loop.
  bool homeAsked = false;

  /// Waits for a sign-in even when the page is public: they asked to do
  /// something on it that needs one.
  bool signInFirst = false;
}
