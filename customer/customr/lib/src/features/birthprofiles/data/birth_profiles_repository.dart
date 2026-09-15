import 'birth_profiles_api.dart';
import 'models/birth_profile.dart';
import 'models/place.dart';

class BirthProfilesRepository {
  BirthProfilesRepository(this._api);

  final BirthProfilesApi _api;

  Future<List<BirthProfile>> list() => _api.list();

  Future<BirthProfile> create(NewBirthProfile input) => _api.create(input);

  Future<BirthProfile> update(String id, EditBirthProfile input) =>
      _api.update(id, input);

  Future<BirthProfile> setPrimary(String id) => _api.setPrimary(id);

  Future<void> delete(String id) => _api.delete(id);

  Future<List<Place>> searchPlaces(String query) => _api.searchPlaces(query);
}
