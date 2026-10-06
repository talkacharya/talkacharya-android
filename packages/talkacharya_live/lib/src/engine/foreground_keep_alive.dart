import 'package:flutter/foundation.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';

@pragma('vm:entry-point')
void _liveServiceEntry() {
  FlutterForegroundTask.setTaskHandler(_IdleLiveTask());
}

/// The service only has to *exist* (it holds the microphone and camera "while in use" grant
/// and keeps the process alive); all live logic stays in the main isolate.
class _IdleLiveTask extends TaskHandler {
  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {}
  @override
  void onRepeatEvent(DateTime timestamp) {}
  @override
  Future<void> onDestroy(DateTime timestamp, bool isTimeout) async {}
}

class ForegroundServiceLiveKeepAlive {
  ForegroundServiceLiveKeepAlive({
    this.channelId = 'talkacharya_live',
    this.channelName = 'Live Stream',
  });

  final String channelId;
  final String channelName;

  bool get _supported =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  Future<void> start({
    required String title,
    required String text,
    bool video = true,
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
        serviceId: 4712,
        serviceTypes: video
            ? const [
                ForegroundServiceTypes.microphone,
                ForegroundServiceTypes.camera,
              ]
            : const [ForegroundServiceTypes.microphone],
        notificationTitle: title,
        notificationText: text,
        callback: _liveServiceEntry,
      );
    } catch (e) {
      debugPrint('live keep-alive: start failed ($e)');
    }
  }

  Future<void> stop() async {
    if (!_supported) return;
    try {
      if (await FlutterForegroundTask.isRunningService) {
        await FlutterForegroundTask.stopService();
      }
    } catch (e) {
      debugPrint('live keep-alive: stop failed ($e)');
    }
  }
}
