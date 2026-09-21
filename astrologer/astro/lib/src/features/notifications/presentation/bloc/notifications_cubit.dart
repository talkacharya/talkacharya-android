import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/models/app_notification.dart';
import '../../data/notifications_repository.dart';
import '../../../../core/network/friendly_error.dart';

part 'notifications_state.dart';

/// Owns the in-app inbox list + unread badge. [bump] is called when a realtime
/// `inbox.ping` frame or a foreground push arrives.
class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit(this._repo) : super(const NotificationsState());

  final NotificationsRepository _repo;

  Future<void> load({bool refresh = false}) async {
    if (state.status == NotifStatus.loading) return;
    emit(state.copyWith(status: NotifStatus.loading, clearError: true));
    try {
      final page = await _repo.page();
      emit(
        state.copyWith(
          status: NotifStatus.ready,
          items: page.items,
          nextCursor: page.nextCursor,
          hasMore: page.nextCursor != null,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: NotifStatus.error, error: friendlyError(e)));
    }
  }

  Future<void> loadMore() async {
    if (!state.hasMore || state.status == NotifStatus.loadingMore) return;
    emit(state.copyWith(status: NotifStatus.loadingMore));
    try {
      final page = await _repo.page(cursor: state.nextCursor);
      emit(
        state.copyWith(
          status: NotifStatus.ready,
          items: [...state.items, ...page.items],
          nextCursor: page.nextCursor,
          hasMore: page.nextCursor != null,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: NotifStatus.ready));
    }
  }

  /// Something changed server-side — reload the first page.
  void bump() => load(refresh: true);

  Future<void> markRead(String id) async {
    emit(
      state.copyWith(
        items: [
          for (final n in state.items)
            if (n.id == id && !n.isRead)
              n.copyWith(readAt: DateTime.now())
            else
              n,
        ],
      ),
    );
    try {
      await _repo.markRead(id);
    } catch (_) {
      /* optimistic; a later refresh reconciles */
    }
  }

  Future<void> markAllRead() async {
    final now = DateTime.now();
    emit(
      state.copyWith(
        items: [
          for (final n in state.items) n.isRead ? n : n.copyWith(readAt: now),
        ],
      ),
    );
    try {
      await _repo.markAllRead();
    } catch (_) {}
  }

  void reset() => emit(const NotificationsState());
}
