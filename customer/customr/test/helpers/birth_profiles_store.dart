import 'package:customr/src/features/birthprofiles/data/birth_profiles_local_store.dart';
import 'package:customr/src/features/birthprofiles/data/birth_profiles_repository.dart';
import 'package:mocktail/mocktail.dart';

class _MockLocalStore extends Mock implements BirthProfilesLocalStore {}

/// The on-device copy of the birth-profile list, empty: a cubit over a mocked
/// repository then loads from the repository like a first run.
BirthProfilesLocalStore emptyBirthProfilesStore() {
  final store = _MockLocalStore();
  when(store.init).thenAnswer((_) async {});
  when(() => store.profiles).thenReturn(const []);
  return store;
}

/// Wire [emptyBirthProfilesStore] into a mocked [BirthProfilesRepository].
/// (Built first: mocktail can't set up one stub inside another.)
void stubLocalStore(BirthProfilesRepository repo) {
  final store = emptyBirthProfilesStore();
  when(() => repo.localStore).thenReturn(store);
}
