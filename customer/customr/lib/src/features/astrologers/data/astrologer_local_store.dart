import 'dart:async';
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'astrologers_api.dart';
import 'models/astrologer.dart';

/// In-memory + disk-backed local cache for astrologers & recent search terms.
/// Serves as the Single Source of Truth for instant 0ms UI reads and local search.
class AstrologerLocalStore {
  AstrologerLocalStore(this._storage);

  final FlutterSecureStorage _storage;
  static const _storageKey = 'astrologers_cache_v1';
  static const _recentSearchesKey = 'astrologer_recent_searches_v1';

  final Map<String, Astrologer> _cache = {};
  final Map<String, DateTime> _queryFetchTimes = {};
  final List<String> _recentSearches = [];

  Future<void>? _init;

  /// Load persisted disk cache & recent searches into memory on app startup.
  /// Every caller waits for the same read, so a second one never sees the
  /// cache half-loaded.
  Future<void> init() => _init ??= _load();

  Future<void> _load() async {
    try {
      final raw = await _storage.read(key: _storageKey);
      if (raw != null && raw.isNotEmpty) {
        final list = jsonDecode(raw) as List<dynamic>;
        for (final item in list) {
          if (item is Map<String, dynamic>) {
            final a = Astrologer.fromJson(item);
            _cache[a.id] = a;
          }
        }
      }

      final rawRecent = await _storage.read(key: _recentSearchesKey);
      if (rawRecent != null && rawRecent.isNotEmpty) {
        final list = jsonDecode(rawRecent) as List<dynamic>;
        _recentSearches.clear();
        _recentSearches.addAll(list.cast<String>());
      }
    } catch (_) {}
  }

  // --- Recent Searches ---

  List<String> get recentSearches => List.unmodifiable(_recentSearches);

  Future<void> saveRecentSearch(String term) async {
    final t = term.trim();
    if (t.isEmpty) return;
    _recentSearches.removeWhere(
      (item) => item.toLowerCase() == t.toLowerCase(),
    );
    _recentSearches.insert(0, t);
    if (_recentSearches.length > 10) {
      _recentSearches.removeLast();
    }
    _persistRecentSearches();
  }

  Future<void> removeRecentSearch(String term) async {
    _recentSearches.removeWhere(
      (item) => item.toLowerCase() == term.toLowerCase(),
    );
    _persistRecentSearches();
  }

  Future<void> clearRecentSearches() async {
    _recentSearches.clear();
    _persistRecentSearches();
  }

  void _persistRecentSearches() {
    unawaited(
      Future(() async {
        try {
          await _storage.write(
            key: _recentSearchesKey,
            value: jsonEncode(_recentSearches),
          );
        } catch (_) {}
      }),
    );
  }

  // --- Astrologers Cache ---

  /// Most profiles kept. Secure storage encrypts every write and is slow with
  /// big values, so the cache stays small: the most recently seen win.
  static const _maxCached = 150;

  void saveAstrologers(List<Astrologer> items) {
    for (final a in items) {
      _cache.remove(a.id);
      _cache[a.id] = a;
    }
    _trim();
    _persistToDisk();
  }

  void saveAstrologer(Astrologer a) {
    _cache.remove(a.id);
    _cache[a.id] = a;
    _trim();
    _persistToDisk();
  }

  void _trim() {
    while (_cache.length > _maxCached) {
      _cache.remove(_cache.keys.first);
    }
  }

  Astrologer? getById(String id) => _cache[id];

  void markQueryFetched(AstrologerQuery query) {
    _queryFetchTimes[_queryKey(query)] = DateTime.now();
  }

  bool isCacheValid(
    AstrologerQuery query, {
    Duration ttl = const Duration(minutes: 3),
  }) {
    final fetchedAt = _queryFetchTimes[_queryKey(query)];
    if (fetchedAt == null) return false;
    return DateTime.now().difference(fetchedAt) < ttl;
  }

  List<Astrologer> searchLocal(AstrologerQuery query) {
    var items = _cache.values.toList();

    if (query.search != null && query.search!.trim().isNotEmpty) {
      final term = query.search!.trim().toLowerCase();
      items = items.where((a) {
        final nameMatch = a.name.toLowerCase().contains(term);
        final headlineMatch = a.headline.toLowerCase().contains(term);
        final skillMatch = a.skills.any(
          (s) =>
              s.name.toLowerCase().contains(term) ||
              s.slug.toLowerCase().contains(term),
        );
        final langMatch = a.languages.any(
          (l) =>
              l.name.toLowerCase().contains(term) ||
              l.code.toLowerCase().contains(term),
        );
        return nameMatch || headlineMatch || skillMatch || langMatch;
      }).toList();
    }

    if (query.channel != null && query.channel!.isNotEmpty) {
      items = items.where((a) => a.rateFor(query.channel!) != null).toList();
    }

    if (query.skill != null && query.skill!.isNotEmpty) {
      items = items
          .where((a) => a.skills.any((s) => s.slug == query.skill))
          .toList();
    }

    if (query.language != null && query.language!.isNotEmpty) {
      items = items
          .where((a) => a.languages.any((l) => l.code == query.language))
          .toList();
    }

    if (query.following) {
      items = items.where((a) => a.isFollowing).toList();
    }

    items.sort((a, b) {
      if (a.isAvailable != b.isAvailable) {
        return a.isAvailable ? -1 : 1;
      }
      switch (query.sort) {
        case 'rating':
          return b.ratingAvg.compareTo(a.ratingAvg);
        case 'experience':
          return b.yearsExperience.compareTo(a.yearsExperience);
        case 'consultations':
          return b.consultationsCount.compareTo(a.consultationsCount);
        default:
          return 0;
      }
    });

    return items;
  }

  String _queryKey(AstrologerQuery q) =>
      '${q.search}_${q.channel}_${q.skill}_${q.language}_${q.sort}_${q.following}';

  Timer? _persistTimer;

  /// Written once things settle: a page of results, then its details, then a
  /// scroll used to be a write each, every one re-encrypting the whole cache.
  void _persistToDisk() {
    _persistTimer?.cancel();
    _persistTimer = Timer(const Duration(seconds: 2), () async {
      try {
        final jsonList = _cache.values.map((a) => a.toJson()).toList();
        await _storage.write(key: _storageKey, value: jsonEncode(jsonList));
      } catch (_) {}
    });
  }
}
