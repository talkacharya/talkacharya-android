import 'package:bloc/bloc.dart';
import 'package:talkacharya_predictions/talkacharya_predictions.dart';

import '../../../../core/network/friendly_error.dart';
import '../../../../core/util/async_value.dart';
import '../../data/predictions_repository.dart';

class PredictionDetailCubit extends Cubit<AsyncValue<Prediction>> {
  PredictionDetailCubit({required PredictionsRepository repo, required this.id})
    : _repo = repo,
      super(const AsyncValue.idle());

  final PredictionsRepository _repo;
  final String id;

  Future<void> load({bool force = false}) async {
    if (!force && (state.status == AsyncStatus.data || state.isLoading)) return;
    emit(AsyncValue.loading(state.value));
    try {
      emit(AsyncValue.data(await _repo.detail(id)));
    } catch (e) {
      emit(AsyncValue.error(friendlyError(e), state.value));
    }
  }
}
