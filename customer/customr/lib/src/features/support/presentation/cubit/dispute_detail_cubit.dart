import 'package:bloc/bloc.dart';

import '../../../../core/util/async_value.dart';
import '../../data/models/dispute.dart';
import '../../data/support_repository.dart';

/// One report. A fresh [seed] (e.g. straight after submitting) renders
/// immediately while the server copy loads behind it.
class DisputeDetailCubit extends Cubit<AsyncValue<Dispute>> {
  DisputeDetailCubit({
    required SupportRepository repo,
    required String id,
    Dispute? seed,
  }) : _repo = repo,
       _id = id,
       super(seed == null ? const AsyncValue.idle() : AsyncValue.loading(seed));

  final SupportRepository _repo;
  final String _id;

  Future<void> load() async {
    emit(AsyncValue.loading(state.value));
    try {
      emit(AsyncValue.data(await _repo.dispute(_id)));
    } catch (e) {
      emit(AsyncValue.error('$e', state.value));
    }
  }
}
