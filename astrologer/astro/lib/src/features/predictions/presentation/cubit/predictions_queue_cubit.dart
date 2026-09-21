import 'package:bloc/bloc.dart';
import 'package:talkacharya_predictions/talkacharya_predictions.dart';

import '../../../../core/util/async_value.dart';
import '../../data/predictions_repository.dart';
import '../../../../core/network/friendly_error.dart';

/// The astrologer's prediction work queue — unclaimed drafting requests plus
/// anything already assigned to them.
class PredictionsQueueCubit extends Cubit<AsyncValue<List<Prediction>>> {
  PredictionsQueueCubit(this._repo) : super(const AsyncValue.idle());

  final PredictionsRepository _repo;

  Future<void> load({bool force = false}) async {
    if (!force && (state.status == AsyncStatus.data || state.isLoading)) return;
    emit(AsyncValue.loading(state.value));
    try {
      emit(AsyncValue.data(await _repo.queue()));
    } catch (e) {
      emit(AsyncValue.error(friendlyError(e), state.value));
    }
  }

  Future<Prediction> claim(String id) async {
    final p = await _repo.claim(id);
    await load(force: true);
    return p;
  }
}
