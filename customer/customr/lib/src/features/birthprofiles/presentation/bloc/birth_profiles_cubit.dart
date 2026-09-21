import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/profile/active_profile_store.dart';
import '../../data/birth_profiles_api.dart';
import '../../data/birth_profiles_repository.dart';
import '../../data/models/birth_profile.dart';
import '../../../../core/network/friendly_error.dart';

part 'birth_profiles_state.dart';

/// Owns the user's birth-profile list and which one is active. The active id
/// itself lives in [ActiveProfileStore] (persisted); this cubit keeps the list
/// and a resolved view in sync.
class BirthProfilesCubit extends Cubit<BirthProfilesState> {
  BirthProfilesCubit({
    required BirthProfilesRepository repo,
    required ActiveProfileStore store,
  }) : _repo = repo,
       _store = store,
       super(const BirthProfilesState()) {
    _store.addListener(_onStoreChanged);
    emit(state.copyWith(activeProfileId: _store.activeProfileId));
  }

  final BirthProfilesRepository _repo;
  final ActiveProfileStore _store;

  void _onStoreChanged() {
    if (isClosed) return;
    emit(state.copyWith(activeProfileId: _store.activeProfileId));
  }

  Future<void> load({bool force = false}) async {
    if (state.status == BpStatus.loading) return;
    if (state.status == BpStatus.ready && !force) return;
    emit(state.copyWith(status: BpStatus.loading, clearError: true));
    try {
      final profiles = await _repo.list();
      // If the active id no longer resolves (deleted elsewhere), drop it.
      // We don't auto-pick a replacement here — that would clear the post-login
      // profile gate. Screens that just need "the user's chart" read
      // `state.resolvedProfile`, which falls back to the primary on its own.
      final activeId = _store.activeProfileId;
      if (activeId != null && !profiles.any((p) => p.id == activeId)) {
        await _store.setActive(null);
      }
      emit(state.copyWith(status: BpStatus.ready, profiles: profiles));
    } catch (e) {
      emit(state.copyWith(status: BpStatus.error, error: friendlyError(e)));
    }
  }

  Future<void> select(String id) => _store.setActive(id);

  void skipSelection() => _store.skipLoginGate();

  Future<BirthProfile> create(
    NewBirthProfile input, {
    bool activate = true,
  }) async {
    final profile = await _repo.create(input);
    emit(state.copyWith(profiles: [profile, ...state.profiles]));
    if (activate) await _store.setActive(profile.id);
    return profile;
  }

  /// Edit an existing profile. Any birth-data change (date / time / place)
  /// re-keys its server-side chart cache, so the next kundali load is fresh.
  Future<BirthProfile> update(String id, EditBirthProfile input) async {
    final updated = await _repo.update(id, input);
    emit(
      state.copyWith(
        profiles: [for (final p in state.profiles) p.id == id ? updated : p],
      ),
    );
    return updated;
  }

  Future<void> makeDefault(String id) async {
    final updated = await _repo.setPrimary(id);
    emit(
      state.copyWith(
        profiles: [
          for (final p in state.profiles)
            p.id == id ? updated : p.copyWith(isPrimary: false),
        ],
      ),
    );
  }

  Future<void> remove(String id) async {
    await _repo.delete(id);
    emit(
      state.copyWith(
        profiles: state.profiles.where((p) => p.id != id).toList(),
      ),
    );
    if (_store.activeProfileId == id) await _store.setActive(null);
  }

  @override
  Future<void> close() {
    _store.removeListener(_onStoreChanged);
    return super.close();
  }
}
