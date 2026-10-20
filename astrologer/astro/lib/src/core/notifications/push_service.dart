import 'package:talkacharya_call/talkacharya_call.dart';
import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';

import '../../../firebase_options.dart';
import 'chat_delivery.dart';
import 'local_notifications.dart';
import 'package:talkacharya_assistant/talkacharya_assistant.dart';

/// FCM background isolate entrypoint.
///
/// Ordinary pushes carry a `notification` block and the OS renders them itself.
/// A consultation request does not: it arrives as data so that *this* isolate
/// can raise a ringing, full-screen notification even with the app killed —
/// which is the difference between an astrologer taking the call and a customer
/// staring at an unanswered request.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (_) {}
  // A chat message reached the phone: that is the sender's second tick.
  if ('${message.data['thread'] ?? ''}'.isNotEmpty) {
    await reportChatDeliveredFromPush(message.data);
  }
  // "ring": "0" — the server says the request this phone is ringing for is over.
  if (message.data['ring'] == '0') {
    final local = LocalNotifications();
    await local.init();
    await stopRingFor(
      local,
      '${message.data['consultation_id'] ?? ''}',
      reason: '${message.data['reason'] ?? ''}',
    );
    return;
  }
  if (message.data['ring'] != '1') return;
  final local = LocalNotifications();
  await local.init();
  await ringForRequest(local, message.data);
}

/// A ring that is no longer wanted — the request was withdrawn or ran out, or
/// it was answered or declined on another phone. Stops the tray's ringing
/// notification (only if it is this one's) and Android's ringing call.
///
/// [reason] `accepted` / `connected` also reaches the phone that did the
/// answering, possibly before its own answer has gone through; there Android's
/// call is about to become the live one, so it is only dropped on a phone whose
/// tray is still ringing for it — one that never answered.
Future<void> stopRingFor(
  LocalNotifications local,
  String consultationId, {
  String reason = '',
}) async {
  if (consultationId.isEmpty) return;
  final ringing = await local.ringingCall();
  final ringingHere = '${ringing?['consultation_id'] ?? ''}' == consultationId;
  if (ringingHere) await local.cancelIncomingCall();
  final answeredSomewhere = reason == 'accepted' || reason == 'connected';
  if (ringingHere || !answeredSomewhere) {
    await CallTelecom.declineIncoming(consultationId);
  }
}

/// Whether the app is the thing on screen right now. Locked, or behind
/// another app, it is not — even though its process (and socket) are alive.
bool appOnScreen() =>
    WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed;

/// Raise the ringing notification for an incoming consultation.
///
/// Lives outside [PushService] so the background isolate — which has no access
/// to the app's DI or its localizations — can call it too. The action labels are
/// English here by necessity; the app is en/hi and the notification is gone in
/// ninety seconds.
Future<void> ringForRequest(
  LocalNotifications local,
  Map<String, dynamic> data,
) async {
  final seconds = int.tryParse('${data['expires_in'] ?? ''}') ?? 90;
  final who = '${data['customer_name'] ?? ''}'.trim();
  final channel = '${data['channel'] ?? 'chat'}';
  // A voice/video request is a call: tell Android, so it is treated as one —
  // a headset or watch can answer it, and a cellular call in progress gets the
  // system's own choice. A chat request is not a call and stays a notification.
  if (channel == 'voice' || channel == 'video') {
    await CallTelecom.reportIncoming(
      callId: '${data['consultation_id'] ?? ''}',
      peerName: who.isEmpty ? 'Customer' : who,
      video: channel == 'video',
      expiresIn: Duration(seconds: seconds),
    );
  }
  await local.showIncomingCall(
    title: who.isEmpty ? 'Incoming consultation' : who,
    body: switch (channel) {
      'voice' => 'Voice consultation request',
      'video' => 'Video consultation request',
      _ => 'Chat consultation request',
    },
    data: Map<String, dynamic>.from(data),
    expiresIn: Duration(seconds: seconds),
    answerLabel: 'Accept',
    declineLabel: 'Decline',
  );
}

/// Wraps FCM. [init] never throws: if the app has no `google-services.json`
/// (Firebase not configured) it logs once and every accessor becomes a no-op,
/// so the rest of the app is unaffected.
class PushService {
  PushService(
    this._local, {
    bool Function()? realtimeOnline,
    bool Function(String thread)? roomOpen,
  }) : _realtimeOnline = realtimeOnline ?? _never,
       _roomOpen = roomOpen ?? _nowhere;

  /// Whether the room for this thread is the one on screen.
  final bool Function(String thread) _roomOpen;
  static bool _nowhere(String _) => false;

  final LocalNotifications _local;

  /// Whether the in-app realtime socket is up (it then delivers requests itself).
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
    if (message.data['ring'] == '0') {
      unawaited(
        stopRingFor(
          _local,
          '${message.data['consultation_id'] ?? ''}',
          reason: '${message.data['reason'] ?? ''}',
        ),
      );
      return;
    }
    if (message.data['ring'] == '1') {
      // With the socket up and the app on screen the in-app sheet is already
      // ringing in person; a notification on top would only double the sound.
      // Off screen (a locked phone, another app in front) the sheet can't be
      // seen or reliably heard, so the tray rings: the system plays it with
      // the phone's ringtone and vibration, and wakes the screen for it.
      // A test ring has no in-app sheet behind it, so it always rings.
      if (message.data['test'] == '1' || !_realtimeOnline() || !appOnScreen()) {
        unawaited(ringForRequest(_local, message.data));
      }
      return;
    }
    // A chat message. The server pushes every one now — a live socket is no
    // proof the user saw it — so the call is made here, where it is known:
    // in that room, the message is already on screen; elsewhere in the app
    // with the socket up, the in-app toast has just said it. Only with the
    // socket down does the foreground need the tray.
    // An assistant message for the room that is open: already on screen.
    if (AssistantPresence.isOpen('${message.data['assistant_thread'] ?? ''}')) {
      return;
    }
    final thread = '${message.data['thread'] ?? ''}';
    // Outside its room the message is "delivered" from here (the room does
    // its own delivered/read). Harmless if the realtime frame said it first.
    if (thread.isNotEmpty && !_roomOpen(thread)) {
      unawaited(reportChatDeliveredFromPush(message.data));
    }
    if (thread.isNotEmpty && (_roomOpen(thread) || _realtimeOnline())) return;
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
