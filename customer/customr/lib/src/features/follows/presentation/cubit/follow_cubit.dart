import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../astrologers/data/models/astrologer.dart';
import '../../data/follows_api.dart';
import '../../data/follows_repository.dart';

/// One astrologer's follow state as the app currently believes it.
class FollowEntry extends Equatable {
  const FollowEntry({required this.following, required this.followersCount});

  final bool following;
  final int followersCount;

  @override
  List<Object?> get props => [following, followersCount];
}

class FollowState extends Equatable {
  const FollowState({this.entries = const {}, this.pending = const {}});

  /// Keyed by astrologer id.
  final Map<String, FollowEntry> entries;

  /// Astrologers with a follow / unfollow request in flight.
  final Set<String> pending;

  FollowEntry? of(String astrologerId) => entries[astrologerId];

  bool isPending(String astrologerId) => pending.contains(astrologerId);

  @override
  List<Object?> get props => [entries, pending];
}

/// App-wide follow state, so the profile header, discovery cards, the
/// "Following" list and the post-session prompt all agree the moment one of
/// them toggles. Toggles are optimistic and revert when the request fails.
///
/// Screens seed it from the astrologers they load ([seed]) — the server's
/// `is_following` wins unless a toggle for that astrologer is in flight.
class FollowCubit extends Cubit<FollowState> {
  FollowCubit(this._repo) : super(const FollowState());

  final FollowsRepository _repo;

  void seed(Iterable<Astrologer> astrologers) {
    var next = state.entries;
    var changed = false;
    for (final a in astrologers) {
      if (state.isPending(a.id)) continue;
      final entry = FollowEntry(
        following: a.isFollowing,
        followersCount: a.followersCount,
      );
      if (next[a.id] == entry) continue;
      if (!changed) next = Map.of(next);
      next[a.id] = entry;
      changed = true;
    }
    if (changed) emit(FollowState(entries: next, pending: state.pending));
  }

  /// Loads the edge from the server — for screens that only know an id (e.g.
  /// the post-session prompt).
  Future<void> load(String astrologerId) async {
    if (state.isPending(astrologerId)) return;
    try {
      final s = await _repo.status(astrologerId);
      if (state.isPending(astrologerId)) return;
      _put(astrologerId, s.following, s.followersCount);
    } catch (_) {
      // leave unknown; the button simply shows "Follow"
    }
  }

  /// Flips the edge. Returns the new `following` value, or `null` when the
  /// request failed (the optimistic change is rolled back). [fallback] is what
  /// the caller's own data says when this astrologer was never seeded.
  Future<bool?> toggle(
    String astrologerId, {
    FollowSource source = FollowSource.profile,
    FollowEntry? fallback,
  }) async {
    if (state.isPending(astrologerId)) return null;
    final before = state.of(astrologerId) ?? fallback;
    final wasFollowing = before?.following ?? false;
    final count = before?.followersCount ?? 0;
    final optimistic = FollowEntry(
      following: !wasFollowing,
      followersCount: (count + (wasFollowing ? -1 : 1)).clamp(0, 1 << 31),
    );
    emit(
      FollowState(
        entries: {...state.entries, astrologerId: optimistic},
        pending: {...state.pending, astrologerId},
      ),
    );
    try {
      final s = await _repo.setFollowing(
        astrologerId,
        follow: !wasFollowing,
        source: source,
      );
      _settle(
        astrologerId,
        FollowEntry(following: s.following, followersCount: s.followersCount),
      );
      return s.following;
    } catch (_) {
      _settle(astrologerId, before);
      return null;
    }
  }

  void _put(String id, bool following, int count) => emit(
    FollowState(
      entries: {
        ...state.entries,
        id: FollowEntry(following: following, followersCount: count),
      },
      pending: state.pending,
    ),
  );

  void _settle(String id, FollowEntry? entry) {
    final entries = Map.of(state.entries);
    if (entry == null) {
      entries.remove(id);
    } else {
      entries[id] = entry;
    }
    emit(
      FollowState(entries: entries, pending: {...state.pending}..remove(id)),
    );
  }
}
