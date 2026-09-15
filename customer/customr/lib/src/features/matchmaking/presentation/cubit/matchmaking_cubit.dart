import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/network/friendly_error.dart';
import '../../../../core/util/async_value.dart';
import '../../../birthprofiles/data/models/birth_profile.dart';
import '../../data/matchmaking_repository.dart';
import '../../data/models/match_result.dart';

part 'matchmaking_state.dart';

/// The matchmaking hub: the two people being matched, the run itself, and the
/// user's past matches.
class MatchmakingCubit extends Cubit<MatchmakingState> {
  MatchmakingCubit(this._repo) : super(const MatchmakingState());

  final MatchmakingRepository _repo;

  Future<void> loadHistory({bool force = false}) async {
    final current = state.history;
    if (!force && (current.status == AsyncStatus.data || current.isLoading))
      return;
    emit(state.copyWith(history: AsyncValue.loading(current.value)));
    try {
      final items = await _repo.history();
      if (isClosed) return;
      emit(state.copyWith(history: AsyncValue.data(items)));
    } catch (e) {
      if (isClosed) return;
      emit(
        state.copyWith(
          history: AsyncValue.error(friendlyError(e), current.value),
        ),
      );
    }
  }

  /// Pre-fill the slot matching the user's own profile gender — only if that slot
  /// is still empty and the person isn't already in the other slot. Never
  /// overrides a choice the user made.
  void suggestFrom(BirthProfile? self) {
    if (self == null) return;
    if (self.gender == 'male' &&
        state.boy == null &&
        state.girl?.id != self.id) {
      emit(state.copyWith(boy: self));
    } else if (self.gender == 'female' &&
        state.girl == null &&
        state.boy?.id != self.id) {
      emit(state.copyWith(girl: self));
    }
  }

  void setBoy(BirthProfile p) => emit(
    state.copyWith(boy: p, clearGirl: state.girl?.id == p.id, clearError: true),
  );

  void setGirl(BirthProfile p) => emit(
    state.copyWith(girl: p, clearBoy: state.boy?.id == p.id, clearError: true),
  );

  void swap() => emit(
    MatchmakingState(boy: state.girl, girl: state.boy, history: state.history),
  );

  /// Run the match. Returns the result on success, null on failure (the error is
  /// in [MatchmakingState.error]).
  Future<MatchResult?> run() async {
    final boy = state.boy;
    final girl = state.girl;
    if (boy == null || girl == null || state.running) return null;
    emit(state.copyWith(running: true, clearError: true));
    try {
      final result = await _repo.run(
        boyProfileId: boy.id,
        girlProfileId: girl.id,
      );
      if (isClosed) return result;
      emit(state.copyWith(running: false));
      await loadHistory(force: true);
      return result;
    } catch (e) {
      if (!isClosed)
        emit(state.copyWith(running: false, error: friendlyError(e)));
      return null;
    }
  }
}

/// Loads one saved match (deep link / history tap), seeded with what we have.
class MatchResultCubit extends Cubit<AsyncValue<MatchResult>> {
  MatchResultCubit({
    required MatchmakingRepository repo,
    required String id,
    MatchResult? seed,
  }) : _repo = repo,
       _id = id,
       super(
         seed != null && seed.hasDetail
             ? AsyncValue.data(seed)
             : const AsyncValue.idle(),
       );

  final MatchmakingRepository _repo;
  final String _id;

  Future<void> load({bool force = false}) async {
    if (!force && state.status == AsyncStatus.data) return;
    emit(AsyncValue.loading(state.value));
    try {
      final r = await _repo.detail(_id);
      if (!isClosed) emit(AsyncValue.data(r));
    } catch (e) {
      if (!isClosed) emit(AsyncValue.error(friendlyError(e), state.value));
    }
  }
}
