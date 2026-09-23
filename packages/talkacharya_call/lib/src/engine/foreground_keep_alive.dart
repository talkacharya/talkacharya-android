import 'package:flutter/foundation.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';

import '../ports/call_ports.dart';

@pragma('vm:entry-point')
void _callServiceEntry() {
  FlutterForegroundTask.setTaskHandler(_IdleCallTask());
}

/// The service only has to *exist* (it holds the microphone "while in use" grant and
/// keeps the process alive); all call logic stays in the main isolate.
class _IdleCallTask extends TaskHandler {
  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {}
  @override
  void onRepeatEvent(DateTime timestamp) {}
  @override
  Future<void> onDestroy(DateTime timestamp, bool isTimeout) async {}
}

/// Android foreground service of type `microphone` for the duration of a call.
///
/// Since Android 11 an app in the background (screen locked, user switched apps)
/// loses microphone access unless such a service is running — without it the other
/// side hears silence. Each app's manifest must declare:
///
/// ```xml
/// <uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
/// <uses-permission android:name="android.permission.FOREGROUND_SERVICE_MICROPHONE" />
/// <uses-permission android:name="android.permission.FOREGROUND_SERVICE_CAMERA" />
/// <service android:name="com.pravera.flutter_foreground_task.service.ForegroundService"
///     android:foregroundServiceType="microphone|camera" android:exported="false" />
/// ```
///
/// No-op on other platforms (iOS keeps audio alive via the `audio` background mode).
class ForegroundServiceCallKeepAlive implements CallKeepAlive {
  ForegroundServiceCallKeepAlive({
    this.channelId = 'talkacharya_call',
    this.channelName = 'Ongoing call',
  });

  final String channelId;
  final String channelName;

  bool get _supported =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  @override
  Future<void> start({
    required String title,
    required String text,
    bool video = false,
  }) async {
    if (!_supported) return;
    try {
      FlutterForegroundTask.init(
        androidNotificationOptions: AndroidNotificationOptions(
          channelId: channelId,
          channelName: channelName,
          channelImportance: NotificationChannelImportance.LOW,
          priority: NotificationPriority.LOW,
          onlyAlertOnce: true,
        ),
        iosNotificationOptions: const IOSNotificationOptions(),
        foregroundTaskOptions: ForegroundTaskOptions(
          eventAction: ForegroundTaskEventAction.nothing(),
          allowWakeLock: true,
          allowAutoRestart: false,
        ),
      );
      if (await FlutterForegroundTask.isRunningService) {
        await FlutterForegroundTask.updateService(
          notificationTitle: title,
          notificationText: text,
        );
        return;
      }
      await FlutterForegroundTask.startService(
        serviceId: 4711,
        // A video call must claim the camera here too: from Android 14 a
        // foreground service may only use the types it started with, so a
        // microphone-only service loses the camera the moment the call is
        // backgrounded.
        serviceTypes: video
            ? const [
                ForegroundServiceTypes.microphone,
                ForegroundServiceTypes.camera,
              ]
            : const [ForegroundServiceTypes.microphone],
        notificationTitle: title,
        notificationText: text,
        callback: _callServiceEntry,
      );
    } catch (e) {
      debugPrint('call keep-alive: start failed ($e)');
    }
  }

  @override
  Future<void> stop() async {
    if (!_supported) return;
    try {
      if (await FlutterForegroundTask.isRunningService) {
        await FlutterForegroundTask.stopService();
      }
    } catch (e) {
      debugPrint('call keep-alive: stop failed ($e)');
    }
  }
}
