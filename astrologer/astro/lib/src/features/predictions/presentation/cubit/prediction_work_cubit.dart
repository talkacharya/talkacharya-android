import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:talkacharya_predictions/talkacharya_predictions.dart';

import '../../../../core/util/async_value.dart';
import '../../data/predictions_repository.dart';
import '../../../../core/network/friendly_error.dart';

part 'prediction_work_state.dart';

/// Drives one prediction editor: load, autosave the draft, deliver, release.
class PredictionWorkCubit extends Cubit<PredictionWorkState> {
  PredictionWorkCubit({required PredictionsRepository repo, required this.id})
    : _repo = repo,
      super(const PredictionWorkState());

  final PredictionsRepository _repo;
  final String id;

  Future<void> load() async {
    emit(
      state.copyWith(prediction: AsyncValue.loading(state.prediction.value)),
    );
    try {
      emit(state.copyWith(prediction: AsyncValue.data(await _repo.detail(id))));
    } catch (e) {
      emit(
        state.copyWith(
          prediction: AsyncValue.error(
            friendlyError(e),
            state.prediction.value,
          ),
        ),
      );
    }
  }

  Future<void> claim() async {
    try {
      emit(state.copyWith(prediction: AsyncValue.data(await _repo.claim(id))));
    } catch (e) {
      emit(state.copyWith(error: friendlyError(e)));
    }
  }

  Future<void> saveDraft({required String title, required String body}) async {
    emit(state.copyWith(saving: true, clearError: true));
    try {
      final p = await _repo.saveDraft(id, title: title, body: body);
      emit(
        state.copyWith(
          prediction: AsyncValue.data(p),
          saving: false,
          savedAt: DateTime.now(),
        ),
      );
    } catch (e) {
      emit(state.copyWith(saving: false, error: friendlyError(e)));
    }
  }

  Future<bool> deliver({required String title, required String body}) async {
    emit(state.copyWith(saving: true, clearError: true));
    try {
      final p = await _repo.deliver(id, title: title, body: body);
      emit(state.copyWith(prediction: AsyncValue.data(p), saving: false));
      return true;
    } catch (e) {
      emit(state.copyWith(saving: false, error: friendlyError(e)));
      return false;
    }
  }

  Future<void> release() async {
    try {
      emit(
        state.copyWith(prediction: AsyncValue.data(await _repo.release(id))),
      );
    } catch (e) {
      emit(state.copyWith(error: friendlyError(e)));
    }
  }
}
