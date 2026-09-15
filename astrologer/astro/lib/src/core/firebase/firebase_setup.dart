import 'dart:async';

import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import '../../../firebase_options.dart';
import '../config/flavor.dart';

/// Brings Firebase up before anything uses it: `initializeApp`, then **App Check**
/// — which must be active before the first Firebase Auth call, or phone sign-in
/// fails once App Check is enforced for Authentication in the console.
///
/// Mirrors the customer app's `FirebaseSetup` (minus Crashlytics). Never throws.
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
    } catch (e) {
      debugPrint('App Check: activation failed ($e)');
    }
  }

  /// No crash reporter in this app yet — keep the call sites shared with the
  /// customer app and just log.
  static Future<void> recordNonFatal(
    Object error,
    StackTrace? stack, {
    String? reason,
  }) async {
    debugPrint('non-fatal${reason == null ? '' : ' [$reason]'}: $error');
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
