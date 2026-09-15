import 'package:bloc_test/bloc_test.dart';
import 'package:customr/src/core/profile/active_profile_store.dart';
import 'package:customr/src/features/birthprofiles/data/birth_profiles_api.dart';
import 'package:customr/src/features/birthprofiles/data/birth_profiles_repository.dart';
import 'package:customr/src/features/birthprofiles/data/models/birth_profile.dart';
import 'package:customr/src/features/birthprofiles/presentation/bloc/birth_profiles_cubit.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepo extends Mock implements BirthProfilesRepository {}

class _MockStorage extends Mock implements FlutterSecureStorage {}

BirthProfile _p(
  String id, {
  bool primary = false,
  String relation = 'self',
  DateTime? createdAt,
}) => BirthProfile(
  id: id,
  label: 'P$id',
  relation: relation,
  birthDate: '1994-08-14',
  isPrimary: primary,
  createdAt: createdAt,
);

void main() {
  late _MockRepo repo;
  late _MockStorage storage;
  late ActiveProfileStore store;

  setUpAll(() {
    registerFallbackValue(
      const NewBirthProfile(
        label: '',
        relation: 'self',
        gender: 'male',
        birthDate: '2000-01-01',
        placeId: 'x',
      ),
    );
    registerFallbackValue(const EditBirthProfile());
  });

  setUp(() {
    repo = _MockRepo();
    storage = _MockStorage();
    when(
      () => storage.read(key: any(named: 'key')),
    ).thenAnswer((_) async => null);
    when(
      () => storage.write(
        key: any(named: 'key'),
        value: any(named: 'value'),
      ),
    ).thenAnswer((_) async {});
    when(() => storage.delete(key: any(named: 'key'))).thenAnswer((_) async {});
    store = ActiveProfileStore(storage);
  });

  BirthProfilesCubit build() => BirthProfilesCubit(repo: repo, store: store);

  blocTest<BirthProfilesCubit, BirthProfilesState>(
    'load populates the list (no active id is left as-is — the gate owns it)',
    build: () {
      when(
        repo.list,
      ).thenAnswer((_) async => [_p('1'), _p('2', primary: true)]);
      return build();
    },
    act: (c) => c.load(),
    expect: () => [
      isA<BirthProfilesState>().having(
        (s) => s.status,
        'status',
        BpStatus.loading,
      ),
      isA<BirthProfilesState>()
          .having((s) => s.status, 'status', BpStatus.ready)
          .having((s) => s.profiles.length, 'count', 2)
          // nothing explicitly active, but `resolvedProfile` covers it (P2 primary)
          .having((s) => s.activeProfile, 'activeProfile', isNull)
          .having((s) => s.resolvedProfile?.id, 'resolvedProfile', '2'),
    ],
    verify: (_) => expect(store.activeProfileId, isNull),
  );

  test('primaryProfile prefers is_primary, then self, then oldest', () {
    final s = BirthProfilesState(
      status: BpStatus.ready,
      profiles: [
        _p('a', relation: 'spouse', createdAt: DateTime(2024, 1, 3)),
        _p('b', relation: 'self', createdAt: DateTime(2024, 1, 2)),
        _p('c', primary: true, relation: 'spouse'),
      ],
    );
    expect(s.primaryProfile?.id, 'c'); // is_primary wins

    final noPrimary = BirthProfilesState(
      status: BpStatus.ready,
      profiles: [
        _p('a', relation: 'spouse', createdAt: DateTime(2024, 1, 3)),
        _p('b', relation: 'self', createdAt: DateTime(2024, 1, 2)),
      ],
    );
    expect(noPrimary.primaryProfile?.id, 'b'); // self relation

    final neither = BirthProfilesState(
      status: BpStatus.ready,
      profiles: [
        _p('a', relation: 'spouse', createdAt: DateTime(2024, 1, 3)),
        _p('b', relation: 'child', createdAt: DateTime(2024, 1, 2)),
      ],
    );
    expect(neither.primaryProfile?.id, 'b'); // oldest
  });

  blocTest<BirthProfilesCubit, BirthProfilesState>(
    'create prepends and activates the new profile',
    build: () {
      when(() => repo.create(any())).thenAnswer((_) async => _p('9'));
      return build();
    },
    act: (c) => c.create(
      const NewBirthProfile(
        label: 'Me',
        relation: 'self',
        gender: 'male',
        birthDate: '1994-08-14',
        placeId: 'fake:delhi',
      ),
    ),
    verify: (c) {
      expect(c.state.profiles.first.id, '9');
      expect(store.activeProfileId, '9');
      expect(c.state.activeProfileId, '9');
    },
  );

  blocTest<BirthProfilesCubit, BirthProfilesState>(
    'update replaces the profile in place, keeps the active id',
    build: () {
      when(repo.list).thenAnswer((_) async => [_p('1'), _p('2')]);
      when(() => repo.update('2', any())).thenAnswer(
        (_) async => _p('2', relation: 'spouse'),
      );
      return build();
    },
    act: (c) async {
      await c.load();
      await c.select('2');
      await c.update('2', const EditBirthProfile(birthTime: '16:46:00'));
    },
    verify: (c) {
      expect(c.state.profileById('2')?.relation, 'spouse');
      expect(c.state.profiles.length, 2);
      expect(store.activeProfileId, '2');
    },
  );

  blocTest<BirthProfilesCubit, BirthProfilesState>(
    'select delegates to the store and syncs state',
    build: () {
      when(repo.list).thenAnswer((_) async => [_p('1'), _p('2')]);
      return build();
    },
    act: (c) async {
      await c.load();
      await c.select('2');
    },
    verify: (c) {
      expect(store.activeProfileId, '2');
      expect(c.state.activeProfile?.id, '2');
    },
  );

  blocTest<BirthProfilesCubit, BirthProfilesState>(
    'load drops an active id that no longer exists (resolvedProfile still covers it)',
    build: () {
      when(repo.list).thenAnswer((_) async => [_p('1', primary: true)]);
      return build();
    },
    act: (c) async {
      await store.setActive('gone');
      await c.load(force: true);
    },
    verify: (c) {
      expect(store.activeProfileId, isNull);
      expect(c.state.resolvedProfile?.id, '1'); // falls back to the primary
    },
  );

  blocTest<BirthProfilesCubit, BirthProfilesState>(
    'remove deletes and clears active when it was the removed one',
    build: () {
      when(repo.list).thenAnswer((_) async => [_p('1'), _p('2')]);
      when(() => repo.delete('1')).thenAnswer((_) async {});
      return build();
    },
    act: (c) async {
      await c.load();
      await c.select('1');
      await c.remove('1');
    },
    verify: (c) {
      expect(c.state.profiles.map((p) => p.id), ['2']);
      expect(store.activeProfileId, isNull);
    },
  );
}
