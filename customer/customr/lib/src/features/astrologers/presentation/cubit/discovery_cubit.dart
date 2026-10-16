import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/network/friendly_error.dart';
import '../../data/astrologers_api.dart';
import '../../data/astrologers_repository.dart';
import '../../data/models/astrologer.dart';

part 'discovery_state.dart';

/// Owns the discovery list: the active [AstrologerQuery], the ranked results,
/// cursor pagination, and recent search history.
class DiscoveryCubit extends Cubit<DiscoveryState> {
  DiscoveryCubit(this._repo) : super(const DiscoveryState());

  final AstrologersRepository _repo;

  /// Guards against a burst of [loadMore] calls and re-filter race conditions.
  bool _pageInFlight = false;

  AstrologerQuery? _fetchingQuery;
  Timer? _searchDebounce;

  List<String> get recentSearches => _repo.recentSearches;

  Future<void> removeRecentSearch(String term) async {
    await _repo.removeRecentSearch(term);
    emit(state.copyWith()); // Trigger UI refresh for recent search list
  }

  Future<void> clearRecentSearches() async {
    await _repo.clearRecentSearches();
    emit(state.copyWith());
  }

  @override
  Future<void> close() {
    _searchDebounce?.cancel();
    final pending = _pendingSearch;
    if (pending != null && !pending.isCompleted) pending.complete();
    return super.close();
  }

  /// Replace the whole query and reload from page 1.
  /// Instant 0ms local search response followed by background server merge.
  Future<void> applyQuery(AstrologerQuery query, {bool force = false}) async {
    if (!force && query == state.query) {
      if (state.status == DiscoveryStatus.ready) return;
      if (_fetchingQuery == query) return;
    }

    // What the phone already has, shown at once while the server answers.
    var localMatches = const <Astrologer>[];
    try {
      localMatches = await _repo.localMatches(query);
    } catch (_) {}
    final hasLocal = localMatches.isNotEmpty;

    if (isClosed) return;
    emit(
      state.copyWith(
        query: query,
        status: hasLocal
            ? DiscoveryStatus.ready
            : (state.items.isEmpty
                  ? DiscoveryStatus.loading
                  : DiscoveryStatus.refiltering),
        items: hasLocal
            ? localMatches
            : (state.items.isEmpty ? const [] : state.items),
        clearCursor: true,
        hasMore: false,
        loadMoreError: false,
        clearError: true,
      ),
    );

    await _fetchFirst(query);
  }

  Completer<void>? _pendingSearch;

  Future<void> search(String? term) {
    _searchDebounce?.cancel();
    // A search replaced by the next keystroke is finished, not left hanging.
    final previous = _pendingSearch;
    if (previous != null && !previous.isCompleted) previous.complete();

    final t = (term ?? '').trim();
    final query = state.query.copyWith(search: t.isEmpty ? null : t);
    final completer = _pendingSearch = Completer<void>();
    _searchDebounce = Timer(const Duration(milliseconds: 300), () async {
      // Saved once typing pauses — not "k", "ka", "kar" for every keystroke.
      if (t.isNotEmpty) unawaited(_repo.saveRecentSearch(t));
      await applyQuery(query);
      if (!completer.isCompleted) completer.complete();
    });
    return completer.future;
  }

  Future<void> setChannel(String? channel) =>
      applyQuery(state.query.copyWith(channel: channel));

  Future<void> setSort(String? sort) =>
      applyQuery(state.query.copyWith(sort: sort));

  Future<void> refresh() => applyQuery(state.query, force: true);

  Future<void> retryLoadMore() {
    emit(state.copyWith(loadMoreError: false));
    return loadMore();
  }

  Future<void> loadMore() async {
    if (_pageInFlight ||
        !state.hasMore ||
        state.nextCursor == null ||
        state.status == DiscoveryStatus.loadingMore) {
      return;
    }
    _pageInFlight = true;
    final cursor = state.nextCursor;
    final query = state.query;
    if (isClosed) return;
    emit(
      state.copyWith(status: DiscoveryStatus.loadingMore, loadMoreError: false),
    );
    try {
      final page = await _repo.list(query: query, cursor: cursor);
      if (query != state.query || isClosed) return;
      emit(
        state.copyWith(
          status: DiscoveryStatus.ready,
          items: _dedupe([...state.items, ...page.items]),
          nextCursor: page.nextCursor,
          clearCursor: page.nextCursor == null,
          hasMore: page.hasMore,
        ),
      );
    } catch (_) {
      if (query != state.query || isClosed) return;
      emit(state.copyWith(status: DiscoveryStatus.ready, loadMoreError: true));
    } finally {
      _pageInFlight = false;
    }
  }

  Future<void> _fetchFirst(AstrologerQuery query) async {
    _pageInFlight = true;
    _fetchingQuery = query;
    try {
      final page = await _repo.list(query: query);
      if (query != state.query || isClosed) return;

      // The server's page replaces the cached guess: its order is the ranking,
      // and someone cached but no longer listed (offline, gone) drops out.
      emit(
        state.copyWith(
          status: DiscoveryStatus.ready,
          items: _dedupe(page.items),
          nextCursor: page.nextCursor,
          clearCursor: page.nextCursor == null,
          hasMore: page.hasMore,
        ),
      );
    } catch (e) {
      if (query != state.query || isClosed) return;
      if (state.items.isNotEmpty) {
        emit(state.copyWith(status: DiscoveryStatus.ready));
      } else {
        emit(
          state.copyWith(
            status: DiscoveryStatus.error,
            error: friendlyError(e),
          ),
        );
      }
    } finally {
      _pageInFlight = false;
      if (_fetchingQuery == query) _fetchingQuery = null;
    }
  }

  static List<Astrologer> _dedupe(List<Astrologer> items) {
    final seen = <String>{};
    return [
      for (final a in items)
        if (seen.add(a.id)) a,
    ];
  }
}
