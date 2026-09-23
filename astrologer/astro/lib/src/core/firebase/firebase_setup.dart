import 'dart:async';

import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

import '../../../firebase_options.dart';
import '../config/flavor.dart';

/// Brings Firebase up before anything uses it, in the right order:
///
/// 1. `Firebase.initializeApp`
/// 2. **App Check** — must be activated *before* the first Firebase Auth call, or
///    phone sign-in goes out without an attestation and fails once App Check is
///    enforced for Authentication in the console.
/// 3. **Crashlytics** — Flutter + platform error hooks.
///
/// Mirrors the customer app's `FirebaseSetup`. Never throws: without
/// `google-services.json` the app still runs, just without push / Firebase
/// login / crash reports ([isAvailable] stays false).
class FirebaseSetup {
  FirebaseSetup._();

  static bool _available = false;
  static bool get isAvailable => _available;

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

  /// Play Integrity only for a Play-distributed release of the prod flavor; every
  /// other build uses the debug provider (register its token in Firebase console →
  /// App Check → Apps → Manage debug tokens). Override with
  /// `--dart-define=APP_CHECK_PROVIDER=debug|playIntegrity`.
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
          'App Check: DEBUG provider active. Register the debug token from '
          '`adb logcat -d | grep "debug secret"` in Firebase console → App Check.',
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

  static String? _token;
  static DateTime _tokenAt = DateTime.fromMillisecondsSinceEpoch(0);
  static DateTime _retryAfter = DateTime.fromMillisecondsSinceEpoch(0);
  static Future<String?>? _inFlight;

  /// Cached App Check token for `X-Firebase-AppCheck` (20 min reuse, 2 min
  /// back-off after a failure), or null.
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
}
