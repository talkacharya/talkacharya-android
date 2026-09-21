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

  /// For the incoming-call extension below.
  FlutterLocalNotificationsPlugin get plugin => _plugin;

  static const channelId = 'talkacharya_default';

  /// Incoming consultations ring on their own channel: the phone's ringtone
  /// instead of a notification blip, and a full-screen intent so a locked phone
  /// shows the request rather than a line in the shade. Android freezes a
  /// channel's sound and importance at creation, which is why this can never be
  /// the same channel as everything else.
  static const callChannelId = 'talkacharya_incoming_call';

  /// One id, so a second push for the same request replaces the first and
  /// answering or declining can take it away again.
  static const callNotificationId = 424242;

  final _taps = StreamController<String>.broadcast();
  Stream<String> get taps => _taps.stream;

  /// Answer / decline taps on a ringing notification, as `(action, payload)`.
  final _callActions =
      StreamController<({String action, String payload})>.broadcast();
  Stream<({String action, String payload})> get callActions =>
      _callActions.stream;

  static const answerAction = 'answer';
  static const declineAction = 'decline';

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
        onDidReceiveNotificationResponse: (resp) {
          final action = resp.actionId;
          if (action == answerAction || action == declineAction) {
            _callActions.add((action: action!, payload: resp.payload ?? ''));
            return;
          }
          _emit(resp.payload);
        },
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
      await _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(incomingCallChannel);
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

/// The channel a ringing consultation arrives on.
const incomingCallChannel = AndroidNotificationChannel(
  LocalNotifications.callChannelId,
  'Incoming consultations',
  description: 'Rings when a customer asks to talk',
  importance: Importance.max,
  // The phone's own ringtone, so it sounds like the call it is.
  sound: UriAndroidNotificationSound('content://settings/system/ringtone'),
  audioAttributesUsage: AudioAttributesUsage.notificationRingtone,
  enableVibration: true,
  vibrationPattern: null,
);

extension IncomingCallNotification on LocalNotifications {
  /// Ring for a consultation request the app could not show in person.
  ///
  /// Used when a request arrives with the app backgrounded or killed — with the
  /// app open the in-app sheet does this job. It rings until it is answered,
  /// declined or times out, because a request that expires unheard is a lost
  /// consultation for the astrologer and a customer left waiting.
  Future<void> showIncomingCall({
    required String title,
    required String body,
    required Map<String, dynamic> data,
    required Duration expiresIn,
    required String answerLabel,
    required String declineLabel,
  }) async {
    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        LocalNotifications.callChannelId,
        'Incoming consultations',
        importance: Importance.max,
        priority: Priority.max,
        category: AndroidNotificationCategory.call,
        // Shows over the lock screen instead of waiting in the shade.
        fullScreenIntent: true,
        // Not swipeable: it goes away by being answered, declined or expiring.
        ongoing: true,
        autoCancel: false,
        timeoutAfter: expiresIn.inMilliseconds,
        // FLAG_INSISTENT — keep ringing rather than chiming once.
        additionalFlags: Int32List.fromList(<int>[4]),
        actions: <AndroidNotificationAction>[
          AndroidNotificationAction(
            LocalNotifications.declineAction,
            declineLabel,
            cancelNotification: true,
          ),
          AndroidNotificationAction(
            LocalNotifications.answerAction,
            answerLabel,
            showsUserInterface: true,
            cancelNotification: true,
          ),
        ],
      ),
    );
    await plugin.show(
      LocalNotifications.callNotificationId,
      title.isEmpty ? 'Incoming consultation' : title,
      body,
      details,
      payload: jsonEncode(data),
    );
  }

  /// Answered, declined, expired, or handled in the app — stop ringing.
  Future<void> cancelIncomingCall() =>
      plugin.cancel(LocalNotifications.callNotificationId);
}
