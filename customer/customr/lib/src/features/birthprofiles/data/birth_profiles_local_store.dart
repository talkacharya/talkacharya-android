import 'dart:async';
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'models/birth_profile.dart';

/// In-memory + disk-backed local storage for Birth Profiles.
/// Enables 0ms instant loading for profile selectors, Kundali, Panchang and Home.
class BirthProfilesLocalStore {
  BirthProfilesLocalStore(this._storage);

  final FlutterSecureStorage _storage;
  static const _storageKey = 'birth_profiles_local_v1';

  final List<BirthProfile> _cache = [];
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;
    try {
      final raw = await _storage.read(key: _storageKey);
      if (raw != null && raw.isNotEmpty) {
        final list = jsonDecode(raw) as List<dynamic>;
        _cache.clear();
        for (final item in list) {
          if (item is Map<String, dynamic>) {
            _cache.add(BirthProfile.fromJson(item));
          }
        }
      }
    } catch (_) {}
  }

  List<BirthProfile> get profiles => List.unmodifiable(_cache);

  bool get hasProfiles => _cache.isNotEmpty;

  void saveProfiles(List<BirthProfile> profiles) {
    _cache.clear();
    _cache.addAll(profiles);
    _persist();
  }

  void saveProfile(BirthProfile profile) {
    final index = _cache.indexWhere((p) => p.id == profile.id);
    if (index >= 0) {
      _cache[index] = profile;
    } else {
      _cache.insert(0, profile);
    }
    _persist();
  }

  void removeProfile(String id) {
    _cache.removeWhere((p) => p.id == id);
    _persist();
  }

  void _persist() {
    unawaited(Future(() async {
      try {
        final jsonList = _cache.map((p) => p.toJson()).toList();
        await _storage.write(key: _storageKey, value: jsonEncode(jsonList));
      } catch (_) {}
    }));
  }
}
