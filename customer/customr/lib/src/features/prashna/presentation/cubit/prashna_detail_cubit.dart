import 'package:bloc/bloc.dart';
import 'package:astro_kundali/astro_kundali.dart';

import '../../../../core/network/friendly_error.dart';
import '../../../../core/util/async_value.dart';
import '../../data/prashna_repository.dart';

class PrashnaDetailCubit extends Cubit<AsyncValue<Prashna>> {
  PrashnaDetailCubit({required PrashnaRepository repo, required this.id})
    : _repo = repo,
      super(const AsyncValue.idle());

  final PrashnaRepository _repo;
  final String id;

  /// Seed with an already-loaded answer (from the ask flow) to skip a fetch.
  void seed(Prashna p) => emit(AsyncValue.data(p));

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
