import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/astrologers_api.dart';
import '../../data/astrologers_repository.dart';
import '../../data/models/astrologer.dart';
import '../../../../core/network/friendly_error.dart';

part 'discovery_state.dart';

/// Owns the discovery list: the active [AstrologerQuery], the ranked results,
/// and cursor pagination. The home rails, concern chips and CTAs all deep-link
/// into `/astrologers` with query params → [applyQuery] turns those into a fetch.
class DiscoveryCubit extends Cubit<DiscoveryState> {
  DiscoveryCubit(this._repo) : super(const DiscoveryState());

  final AstrologersRepository _repo;

  /// Guards against a burst of [loadMore] calls (the scroll listener fires many
  /// times per frame) and against a re-filter racing an in-flight page.
  bool _pageInFlight = false;

  AstrologerQuery? _fetchingQuery;

  /// Replace the whole query (from a deep-link or a filter change) and reload
  /// from page 1. No-op when nothing changed and that query is already loaded or
  /// in flight.
  Future<void> applyQuery(AstrologerQuery query, {bool force = false}) async {
    if (!force && query == state.query) {
      if (state.status == DiscoveryStatus.ready) return;
      if (_fetchingQuery == query) return;
    }

    final firstEver = state.items.isEmpty;
    emit(
      state.copyWith(
        query: query,
        status: firstEver
            ? DiscoveryStatus.loading
            : DiscoveryStatus.refiltering,
        // Keep the old list visible while re-filtering so the screen never
        // flashes back to a skeleton.
        items: firstEver ? const [] : state.items,
        clearCursor: true,
        hasMore: false,
        loadMoreError: false,
        clearError: true,
      ),
    );
    await _fetchFirst(query);
  }

  Future<void> search(String? term) {
    final t = (term ?? '').trim();
    return applyQuery(state.query.copyWith(search: t.isEmpty ? null : t));
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
    emit(
      state.copyWith(status: DiscoveryStatus.loadingMore, loadMoreError: false),
    );
    try {
      final page = await _repo.list(query: query, cursor: cursor);
      // A re-filter landed while we were fetching — drop this stale page.
      if (query != state.query) return;
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
      if (query != state.query) return;
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
      // A newer query superseded this one mid-flight.
      if (query != state.query) return;
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
      if (query != state.query) return;
      emit(
        state.copyWith(status: DiscoveryStatus.error, error: friendlyError(e)),
      );
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
