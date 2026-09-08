import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_notification.freezed.dart';
part 'app_notification.g.dart';

/// One row from `GET /api/v1/app/notifications` (the in-app inbox).
@freezed
abstract class AppNotification with _$AppNotification {
  const factory AppNotification({
    required String id,
    @Default('') String title,
    @Default('') String body,
    @Default('') String deeplink,
    @Default(<String, dynamic>{}) Map<String, dynamic> data,
    @JsonKey(name: 'read_at') DateTime? readAt,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _AppNotification;

  const AppNotification._();

  factory AppNotification.fromJson(Map<String, dynamic> json) =>
      _$AppNotificationFromJson(json);

  bool get isRead => readAt != null;
}
