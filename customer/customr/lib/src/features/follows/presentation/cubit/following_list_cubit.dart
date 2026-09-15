import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../astrologers/data/models/astrologer.dart';
import '../../data/follows_repository.dart';
import 'follow_cubit.dart';

enum FollowingListStatus { loading, ready, loadingMore, error }

class FollowingListState extends Equatable {
  const FollowingListState({
    this.status = FollowingListStatus.loading,
    this.items = const [],
    this.nextCursor,
  });

  final FollowingListStatus status;
  final List<Astrologer> items;
  final String? nextCursor;

  bool get hasMore => nextCursor != null;

  @override
  List<Object?> get props => [status, items, nextCursor];
}

/// `GET /app/me/following`, page by page. Astrologers unfollowed from this
/// screen stay listed (with the toggle off) until the next refresh, so an
/// accidental tap can be undone in place.
class FollowingListCubit extends Cubit<FollowingListState> {
  FollowingListCubit(this._repo, this._follow)
    : super(const FollowingListState());

  final FollowsRepository _repo;
  final FollowCubit _follow;
  bool _busy = false;

  Future<void> load() async {
    if (_busy) return;
    _busy = true;
    emit(FollowingListState(items: state.items));
    try {
      final page = await _repo.following();
      _follow.seed(page.items);
      emit(
        FollowingListState(
          status: FollowingListStatus.ready,
          items: page.items,
          nextCursor: page.nextCursor,
        ),
      );
    } catch (_) {
      emit(
        FollowingListState(
          status: FollowingListStatus.error,
          items: state.items,
        ),
      );
    } finally {
      _busy = false;
    }
  }

  Future<void> loadMore() async {
    if (_busy || !state.hasMore) return;
    _busy = true;
    emit(
      FollowingListState(
        status: FollowingListStatus.loadingMore,
        items: state.items,
        nextCursor: state.nextCursor,
      ),
    );
    try {
      final page = await _repo.following(cursor: state.nextCursor);
      _follow.seed(page.items);
      final seen = {for (final a in state.items) a.id};
      emit(
        FollowingListState(
          status: FollowingListStatus.ready,
          items: [
            ...state.items,
            for (final a in page.items)
              if (!seen.contains(a.id)) a,
          ],
          nextCursor: page.nextCursor,
        ),
      );
    } catch (_) {
      emit(
        FollowingListState(
          status: FollowingListStatus.ready,
          items: state.items,
          nextCursor: state.nextCursor,
        ),
      );
    } finally {
      _busy = false;
    }
  }
}
