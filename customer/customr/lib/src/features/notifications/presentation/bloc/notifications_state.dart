part of 'notifications_cubit.dart';

enum NotifStatus { initial, loading, loadingMore, ready, error }

class NotificationsState extends Equatable {
  const NotificationsState({
    this.status = NotifStatus.initial,
    this.items = const [],
    this.nextCursor,
    this.hasMore = false,
    this.error,
  });

  final NotifStatus status;
  final List<AppNotification> items;
  final String? nextCursor;
  final bool hasMore;
  final String? error;

  int get unreadCount => items.where((n) => !n.isRead).length;

  NotificationsState copyWith({
    NotifStatus? status,
    List<AppNotification>? items,
    String? nextCursor,
    bool? hasMore,
    String? error,
    bool clearError = false,
  }) {
    return NotificationsState(
      status: status ?? this.status,
      items: items ?? this.items,
      nextCursor: nextCursor ?? this.nextCursor,
      hasMore: hasMore ?? this.hasMore,
      error: clearError ? null : (error ?? this.error),
    );
  }

  @override
  List<Object?> get props => [status, items, nextCursor, hasMore, error];
}
