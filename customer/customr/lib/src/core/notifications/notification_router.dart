import 'dart:async';

import 'local_notifications.dart';
import 'push_service.dart';

/// Single stream of the `deeplink`s of notification taps — whichever surface
/// they came from (FCM tray-open, FCM foreground-open, or a local heads-up
/// notification). Raw, as sent: the app's navigator parses them, so a link it
/// cannot place still opens Home with a word instead of nothing.
class NotificationRouter {
  NotificationRouter({
    required PushService push,
    required LocalNotifications local,
  }) : _push = push,
       _local = local;

  final PushService _push;
  final LocalNotifications _local;

  final _links = StreamController<String>.broadcast();
  Stream<String> get links => _links.stream;

  final _subs = <StreamSubscription<dynamic>>[];

  void start() {
    _subs.add(_push.taps.listen((data) => _emit(data['deeplink'] as String?)));
    _subs.add(_local.taps.listen(_emit));
  }

  /// The deeplink of the notification that launched the app, checked once.
  Future<String?> initialLink() async {
    try {
      final fromPush = await _push.initialMessageData();
      final link = fromPush?['deeplink'] as String?;
      if (link != null && link.trim().isNotEmpty) return link;
      return await _local.initialDeeplink();
    } catch (_) {
      return null;
    }
  }

  void _emit(String? rawDeeplink) {
    // Harmless no-op if this tap wasn't the ringing call notification.
    unawaited(_local.cancelIncomingCall());
    final link = rawDeeplink?.trim() ?? '';
    if (link.isNotEmpty && !_links.isClosed) _links.add(link);
  }

  Future<void> dispose() async {
    for (final s in _subs) {
      await s.cancel();
    }
    await _links.close();
  }
}
