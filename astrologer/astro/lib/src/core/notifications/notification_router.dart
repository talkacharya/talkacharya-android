import 'dart:async';

import '../deeplink/deep_link_parser.dart';
import 'local_notifications.dart';
import 'push_service.dart';

/// Single stream of go_router locations produced by notification taps —
/// whichever surface they came from (FCM tray-open, FCM foreground-open, or a
/// local heads-up notification).
class NotificationRouter {
  NotificationRouter({
    required PushService push,
    required LocalNotifications local,
  }) : _push = push,
       _local = local;

  final PushService _push;
  final LocalNotifications _local;

  final _locations = StreamController<String>.broadcast();
  Stream<String> get locations => _locations.stream;

  final _subs = <StreamSubscription<dynamic>>[];

  void start() {
    _subs.add(
      _push.taps.listen((data) => _emit(data['deeplink'] as String?)),
    );
    _subs.add(_local.taps.listen(_emit));
  }

  /// Deep link the app was launched by via a notification, checked once.
  Future<String?> initialLocation() async {
    final fromPush = await _push.initialMessageData();
    final link = fromPush?['deeplink'] as String? ??
        await _local.initialDeeplink();
    return locationForRaw(link);
  }

  void _emit(String? rawDeeplink) {
    final loc = locationForRaw(rawDeeplink);
    if (loc != null) _locations.add(loc);
  }

  Future<void> dispose() async {
    for (final s in _subs) {
      await s.cancel();
    }
    await _locations.close();
  }
}
