import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Displays heads-up notifications while the app is foregrounded (FCM only shows
/// its own tray notification when the app is backgrounded) and turns a tap into
/// a `data.deeplink` string on [taps].
class LocalNotifications {
  LocalNotifications([FlutterLocalNotificationsPlugin? plugin])
    : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;

  static const channelId = 'talkacharya_default';

  final _taps = StreamController<String>.broadcast();
  Stream<String> get taps => _taps.stream;

  bool _ready = false;

  Future<void> init() async {
    if (_ready) return;
    const settings = InitializationSettings(
      android: AndroidInitializationSettings('@drawable/ic_stat_notification'),
      iOS: DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      ),
    );
    try {
      await _plugin.initialize(
        settings,
        onDidReceiveNotificationResponse: (resp) => _emit(resp.payload),
      );
      await _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(
            const AndroidNotificationChannel(
              channelId,
              'General',
              description: 'Consultations, wallet and account updates',
              importance: Importance.high,
            ),
          );
      _ready = true;
    } catch (e) {
      debugPrint('LocalNotifications: init failed ($e)');
    }
  }

  /// Ask for the Android 13+ POST_NOTIFICATIONS permission (no-op below 33).
  Future<void> requestPermission() async {
    try {
      await _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestNotificationsPermission();
    } catch (_) {}
  }

  Future<void> show({
    required String title,
    required String body,
    required Map<String, dynamic> data,
  }) async {
    if (!_ready) return;
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        channelId,
        'General',
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );
    await _plugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title.isEmpty ? 'TalkAcharya' : title,
      body,
      details,
      payload: jsonEncode(data),
    );
  }

  /// Deep link the app was cold-started with via a local-notification tap.
  Future<String?> initialDeeplink() async {
    try {
      final launch = await _plugin.getNotificationAppLaunchDetails();
      if (launch?.didNotificationLaunchApp ?? false) {
        return _deeplinkOf(launch!.notificationResponse?.payload);
      }
    } catch (_) {}
    return null;
  }

  void _emit(String? payload) {
    final link = _deeplinkOf(payload);
    if (link != null) _taps.add(link);
  }

  String? _deeplinkOf(String? payload) {
    if (payload == null || payload.isEmpty) return null;
    try {
      final map = jsonDecode(payload) as Map<String, dynamic>;
      final link = map['deeplink'] as String?;
      return (link != null && link.isNotEmpty) ? link : null;
    } catch (_) {
      return null;
    }
  }

  Future<void> dispose() => _taps.close();
}
