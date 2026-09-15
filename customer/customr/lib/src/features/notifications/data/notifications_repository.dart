import 'notifications_api.dart';

class NotificationsRepository {
  NotificationsRepository(this._api);

  final NotificationsApi _api;

  Future<NotificationPage> page({String? cursor}) => _api.list(cursor: cursor);

  Future<void> markRead(String id) => _api.markRead(id);

  Future<void> markAllRead() => _api.markAllRead();
}
