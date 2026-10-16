import 'dart:async';

import 'birth_profiles_api.dart';
import 'birth_profiles_local_store.dart';
import 'models/birth_profile.dart';
import 'models/place.dart';

class BirthProfilesRepository {
  BirthProfilesRepository(this._api, this._localStore);

  final BirthProfilesApi _api;
  final BirthProfilesLocalStore _localStore;

  BirthProfilesLocalStore get localStore => _localStore;

  /// Returns cached profiles immediately (0ms) if available, then revalidates in background.
  Future<List<BirthProfile>> list() async {
    final cached = _localStore.profiles;
    if (cached.isNotEmpty) {
      unawaited(_api.list().then((fresh) {
        _localStore.saveProfiles(fresh);
      }).catchError((_) {}));
      return cached;
    }
    final fresh = await _api.list();
    _localStore.saveProfiles(fresh);
    return fresh;
  }

  Future<BirthProfile> create(NewBirthProfile input) async {
    final profile = await _api.create(input);
    _localStore.saveProfile(profile);
    return profile;
  }

  Future<BirthProfile> update(String id, EditBirthProfile input) async {
    final updated = await _api.update(id, input);
    _localStore.saveProfile(updated);
    return updated;
  }

  Future<BirthProfile> setPrimary(String id) async {
    final updated = await _api.setPrimary(id);
    _localStore.saveProfile(updated);
    return updated;
  }

  Future<void> delete(String id) async {
    await _api.delete(id);
    _localStore.removeProfile(id);
  }

  Future<List<Place>> searchPlaces(String query) => _api.searchPlaces(query);
}
