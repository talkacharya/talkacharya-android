import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import '../../../firebase_options.dart';
import 'local_notifications.dart';

/// FCM background isolate entrypoint. The backend sends a `notification` block so
/// the OS renders the tray item itself — nothing to do here but keep Firebase
/// initialised for the isolate.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (_) {}
}

/// Wraps FCM. [init] never throws: if the app has no `google-services.json`
/// (Firebase not configured) it logs once and every accessor becomes a no-op,
/// so the rest of the app is unaffected.
class PushService {
  PushService(this._local);

  final LocalNotifications _local;

  bool _available = false;
  bool get isAvailable => _available;

  final _tokens = StreamController<String>.broadcast();
  Stream<String> get tokens => _tokens.stream;

  /// `data` maps from notification taps (foreground-open and tray-open).
  final _taps = StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get taps => _taps.stream;

  Future<bool> init() async {
    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      }
      _available = true;
    } catch (e) {
      debugPrint('PushService: Firebase not configured — push disabled ($e)');
      return false;
    }

    final messaging = FirebaseMessaging.instance;
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    try {
      await messaging.requestPermission();
      await _local.requestPermission();
    } catch (e) {
      debugPrint('PushService: permission request failed ($e)');
    }

    messaging.onTokenRefresh.listen(_tokens.add);
    FirebaseMessaging.onMessage.listen(_onForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(
      (m) => _taps.add(Map<String, dynamic>.from(m.data)),
    );

    return true;
  }

  /// The current FCM token, or `null` when push is unavailable.
  Future<String?> currentToken() async {
    if (!_available) return null;
    try {
      return await FirebaseMessaging.instance.getToken();
    } catch (e) {
      debugPrint('PushService: getToken failed ($e)');
      return null;
    }
  }

  /// The tap that cold-started the app, if any (checked once at startup).
  Future<Map<String, dynamic>?> initialMessageData() async {
    if (!_available) return null;
    try {
      final m = await FirebaseMessaging.instance.getInitialMessage();
      return m == null ? null : Map<String, dynamic>.from(m.data);
    } catch (_) {
      return null;
    }
  }

  void _onForegroundMessage(RemoteMessage message) {
    final n = message.notification;
    _local.show(
      title: n?.title ?? '',
      body: n?.body ?? '',
      data: Map<String, dynamic>.from(message.data),
    );
  }

  Future<void> dispose() async {
    await _tokens.close();
    await _taps.close();
  }
}
