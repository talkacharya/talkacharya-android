import 'dart:async';

import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

import '../../../firebase_options.dart';
import '../config/flavor.dart';

/// One place that brings Firebase up, in the right order, before anything uses it:
///
/// 1. `Firebase.initializeApp`
/// 2. **App Check** — must be activated *before* the first Firebase Auth call, or
///    phone sign-in goes out without an attestation and fails once App Check is
///    enforced for Authentication in the console.
/// 3. **Crashlytics** — Flutter + platform error hooks.
///
/// Never throws: without `google-services.json` the app still runs, just without
/// push / Firebase login / crash reports ([isAvailable] stays false).
class FirebaseSetup {
  FirebaseSetup._();

  static bool _available = false;
  static bool get isAvailable => _available;

  /// Which App Check provider this build uses — shown in debug logs so a failing
  /// login can be traced to the right console setting.
  static AndroidProvider? androidProvider;

  static Future<void> init(Flavor flavor) async {
    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      }
      _available = true;
    } catch (e) {
      debugPrint('FirebaseSetup: Firebase not configured ($e)');
      return;
    }

    await _activateAppCheck(flavor);
    await _setUpCrashlytics(flavor);
  }

  /// Play Integrity only works for a **release build of the prod flavor that Google
  /// Play recognises** (installed from a Play track, signed by Play App Signing, with
  /// that key's SHA-256 registered for Play Integrity in App Check). Every other
  /// build — debug runs, dev/staging, sideloaded APKs — uses the **debug provider**,
  /// whose per-install token must be added under App Check → Apps → Manage debug
  /// tokens. `make appcheck-token` prints it from logcat.
  ///
  /// `--dart-define=APP_CHECK_PROVIDER=debug|playIntegrity` overrides the choice
  /// (e.g. `debug` to test a sideloaded prod release APK).
  static Future<void> _activateAppCheck(Flavor flavor) async {
    const override = String.fromEnvironment('APP_CHECK_PROVIDER');
    final usePlayIntegrity = switch (override) {
      'debug' => false,
      'playIntegrity' => true,
      _ => kReleaseMode && flavor == Flavor.prod,
    };
    androidProvider = usePlayIntegrity
        ? AndroidProvider.playIntegrity
        : AndroidProvider.debug;
    try {
      await FirebaseAppCheck.instance.activate(
        androidProvider: androidProvider!,
        appleProvider: usePlayIntegrity
            ? AppleProvider.appAttestWithDeviceCheckFallback
            : AppleProvider.debug,
      );
      await FirebaseAppCheck.instance.setTokenAutoRefreshEnabled(true);
      if (!usePlayIntegrity) {
        debugPrint(
          'App Check: DEBUG provider active. Register this install\'s debug token in '
          'Firebase console → App Check → Apps → (this app) → Manage debug tokens. '
          'Find it with: adb logcat -d | grep "debug secret"  (or `make appcheck-token`).',
        );
      }
    } catch (e, st) {
      debugPrint('App Check: activation failed ($e)');
      unawaited(recordNonFatal(e, st, reason: 'app_check_activate'));
    }
  }

  static Future<void> _setUpCrashlytics(Flavor flavor) async {
    final crashlytics = FirebaseCrashlytics.instance;
    // Debug runs stay out of the dashboard; every release/profile build reports.
    await crashlytics.setCrashlyticsCollectionEnabled(!kDebugMode);
    await crashlytics.setCustomKey('flavor', flavor.name);

    final previous = FlutterError.onError;
    FlutterError.onError = (details) {
      previous?.call(details);
      crashlytics.recordFlutterFatalError(details);
    };
    PlatformDispatcher.instance.onError = (error, stack) {
      crashlytics.recordError(error, stack, fatal: true);
      return true;
    };
  }

  static String? _token;
  static DateTime _tokenAt = DateTime.fromMillisecondsSinceEpoch(0);
  static DateTime _retryAfter = DateTime.fromMillisecondsSinceEpoch(0);
  static Future<String?>? _inFlight;

  /// An App Check token for our own API (`X-Firebase-AppCheck`), or null.
  ///
  /// Called before every request, so it must be cheap: the token is reused for
  /// 20 minutes (they live ~1h), concurrent callers share one fetch, and after a
  /// failure (e.g. an unregistered debug token) we stop asking for 2 minutes
  /// instead of adding a doomed network round-trip to every API call.
  static Future<String?> appCheckToken() {
    if (!_available) return Future.value();
    final now = DateTime.now();
    if (_token != null &&
        now.difference(_tokenAt) < const Duration(minutes: 20)) {
      return Future.value(_token);
    }
    if (now.isBefore(_retryAfter)) return Future.value(_token);
    return _inFlight ??= _fetchToken().whenComplete(() => _inFlight = null);
  }

  static Future<String?> _fetchToken() async {
    try {
      final token = await FirebaseAppCheck.instance.getToken().timeout(
        const Duration(seconds: 6),
      );
      if (token != null && token.isNotEmpty) {
        _token = token;
        _tokenAt = DateTime.now();
      }
      return _token;
    } catch (e) {
      debugPrint('App Check: getToken failed ($e)');
      _retryAfter = DateTime.now().add(const Duration(minutes: 2));
      return _token;
    }
  }

  static Future<void> recordNonFatal(
    Object error,
    StackTrace? stack, {
    String? reason,
  }) async {
    if (!_available) return;
    try {
      await FirebaseCrashlytics.instance.recordError(
        error,
        stack,
        reason: reason,
      );
    } catch (_) {}
  }

  static Future<void> setUser(String? id) async {
    if (!_available) return;
    try {
      await FirebaseCrashlytics.instance.setUserIdentifier(id ?? '');
    } catch (_) {}
  }

  static Future<void> log(String message) async {
    if (!_available) return;
    try {
      await FirebaseCrashlytics.instance.log(message);
    } catch (_) {}
  }
}
