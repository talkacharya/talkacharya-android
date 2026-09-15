import 'package:dio/dio.dart';

import '../../../core/constants/api_paths.dart';
import '../../../core/network/api_exception.dart';
import 'models/app_notification.dart';

class NotificationPage {
  const NotificationPage({required this.items, this.nextCursor});
  final List<AppNotification> items;
  final String? nextCursor;
}

/// Transport for the in-app notification inbox. Throws [ApiException].
class NotificationsApi {
  NotificationsApi(this._dio);

  final Dio _dio;

  Future<NotificationPage> list({String? cursor}) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        ApiPaths.notifications,
        queryParameters: {'cursor': ?cursor},
      );
      if ((res.statusCode ?? 0) >= 400) {
        throw ApiException.fromDio(
          DioException(requestOptions: res.requestOptions, response: res),
        );
      }
      final data = res.data ?? const {};
      final results = (data['results'] as List<dynamic>? ?? const [])
          .map((e) => AppNotification.fromJson(e as Map<String, dynamic>))
          .toList();
      return NotificationPage(
        items: results,
        nextCursor: _cursorOf(data['next'] as String?),
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<void> markRead(String id) =>
      _dio.post<void>(ApiPaths.notificationRead(id));

  Future<void> markAllRead() => _dio.post<void>(ApiPaths.notificationsReadAll);

  static String? _cursorOf(String? nextUrl) {
    if (nextUrl == null) return null;
    return Uri.tryParse(nextUrl)?.queryParameters['cursor'];
  }
}
