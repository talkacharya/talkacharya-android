import 'dart:async';

import 'astrologer_local_store.dart';
import 'astrologers_api.dart';
import 'models/astrologer.dart';

class AstrologersRepository {
  AstrologersRepository(this._api, this._localStore);

  final AstrologersApi _api;
  final AstrologerLocalStore _localStore;

  AstrologerLocalStore get localStore => _localStore;

  // --- Recent Searches ---
  List<String> get recentSearches => _localStore.recentSearches;
  Future<void> saveRecentSearch(String term) =>
      _localStore.saveRecentSearch(term);
  Future<void> removeRecentSearch(String term) =>
      _localStore.removeRecentSearch(term);
  Future<void> clearRecentSearches() => _localStore.clearRecentSearches();

  /// Synchronous local search from memory DB (0ms response).
  List<Astrologer> searchLocal(AstrologerQuery query) =>
      _localStore.searchLocal(query);

  /// What the phone already has for [query], loading the disk cache first —
  /// shown while the server answers.
  Future<List<Astrologer>> localMatches(AstrologerQuery query) async {
    await _localStore.init();
    return _localStore.searchLocal(query);
  }

  /// Fetch astrologers page from API and save to local store.
  Future<AstrologerPage> list({
    AstrologerQuery query = const AstrologerQuery(),
    String? cursor,
  }) async {
    final page = await _api.list(query: query, cursor: cursor);
    _localStore.saveAstrologers(page.items);
    _localStore.markQueryFetched(query);
    return page;
  }

  /// The cached profile, if this phone has one — for showing something at
  /// once while [detail] fetches.
  Astrologer? cachedDetail(String id) => _localStore.getById(id);

  /// Astrologer detail, fresh from the server; the cached copy only when the
  /// network fails. Not cache-first: a profile is where the customer books, so
  /// the rate, busy state and channels on it must be current — a stale rate
  /// would show one price and charge another.
  Future<Astrologer> detail(String id) async {
    try {
      final fresh = await _api.detail(id);
      _localStore.saveAstrologer(fresh);
      return fresh;
    } catch (_) {
      await _localStore.init();
      final cached = _localStore.getById(id);
      if (cached != null && cached.bio.isNotEmpty) return cached;
      rethrow;
    }
  }

  Future<({List<AstrologerReview> items, String? nextCursor})> positiveReviews(
    String id, {
    String? cursor,
  }) => _api.positiveReviews(id, cursor: cursor);
}
