import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import '../../../firebase_options.dart';
import 'local_notifications.dart';

/// FCM background isolate entrypoint.
///
/// Ordinary pushes carry a `notification` block and the OS renders them itself.
/// The astrologer accepting a voice/video call does not: it arrives as data so
/// that *this* isolate can raise a ringing, full-screen notification even with
/// the app killed — otherwise a locked phone never rings for the call it's
/// already waiting on.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (_) {}
  if (message.data['ring'] != '1') return;
  final local = LocalNotifications();
  await local.init();
  await ringForCall(local, message.data);
}

/// Raise the ringing notification for a call the astrologer just accepted.
///
/// Lives outside [PushService] so the background isolate — which has no access
/// to the app's DI or its localizations — can call it too. The label is
/// English here by necessity; the app is en/hi+ and the notification only
/// lives as long as the connect window.
Future<void> ringForCall(LocalNotifications local, Map<String, dynamic> data) async {
  final seconds = int.tryParse('${data['expires_in'] ?? ''}') ?? 60;
  final who = '${data['astrologer_name'] ?? ''}'.trim();
  final channel = '${data['channel'] ?? 'voice'}';
  await local.showIncomingCall(
    title: who.isEmpty ? 'Incoming call' : who,
    body: switch (channel) {
      'video' => 'Video call is ready — tap to join',
      _ => 'Voice call is ready — tap to join',
    },
    data: Map<String, dynamic>.from(data),
    expiresIn: Duration(seconds: seconds),
  );
}

/// Wraps FCM. [init] never throws: if the app has no `google-services.json`
/// (Firebase not configured) it logs once and every accessor becomes a no-op,
/// so the rest of the app is unaffected.
class PushService {
  PushService(this._local, {bool Function()? realtimeOnline})
    : _realtimeOnline = realtimeOnline ?? _never;

  final LocalNotifications _local;

  /// Whether the in-app realtime socket is up (it then rings via the in-room
  /// UI itself, driven by the `call.ringing` realtime event).
  final bool Function() _realtimeOnline;
  static bool _never() => false;

  bool _available = false;
  bool get isAvailable => _available;

  final _tokens = StreamController<String>.broadcast();
  Stream<String> get tokens => _tokens.stream;

  /// `data` maps from notification taps (foreground-open and tray-open).
  final _taps = StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get taps => _taps.stream;

  Future<bool> init() async {
    // Firebase (and App Check) are brought up by FirebaseSetup in bootstrap.
    if (Firebase.apps.isEmpty) {
      debugPrint('PushService: Firebase not configured — push disabled');
      return false;
    }
    _available = true;

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
    if (message.data['ring'] == '1') {
      // With the socket up, the room screen is already reacting to the
      // `call.ringing` realtime event; a notification on top would only
      // double the sound.
      if (!_realtimeOnline()) unawaited(ringForCall(_local, message.data));
      return;
    }
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
