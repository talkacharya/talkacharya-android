import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:talkacharya_predictions/talkacharya_predictions.dart';

import '../../../../core/network/friendly_error.dart';
import '../../../../core/util/async_value.dart';
import '../../data/predictions_repository.dart';

part 'predictions_state.dart';

/// Owns the predictions home: the catalog (packs, credit balance, subscription)
/// and the user's prediction list. Buying a pack / requesting refreshes both.
class PredictionsCubit extends Cubit<PredictionsState> {
  PredictionsCubit(this._repo) : super(const PredictionsState());

  final PredictionsRepository _repo;

  Future<void> load({bool force = false}) async {
    await Future.wait([loadCatalog(force: force), loadList(force: force)]);
  }

  Future<void> loadCatalog({bool force = false}) => _slice(
    () => state.catalog,
    (v) => emit(state.copyWith(catalog: v)),
    _repo.catalog,
    force: force,
  );

  Future<void> loadList({bool force = false}) => _slice(
    () => state.list,
    (v) => emit(state.copyWith(list: v)),
    _repo.list,
    force: force,
  );

  /// Buy a credit pack (wallet debit happens server-side). Returns the new
  /// balance, or throws a friendly message string.
  Future<int> buyPack(int pack) async {
    emit(state.copyWith(busy: true));
    try {
      final res = await _repo.buyPack(pack);
      await loadCatalog(force: true);
      return res.creditBalance;
    } catch (e) {
      throw friendlyError(e);
    } finally {
      emit(state.copyWith(busy: false));
    }
  }

  /// Request a prediction. Returns the created [Prediction] or throws a friendly
  /// message (e.g. "You don't have a prediction credit.").
  Future<Prediction> request({
    required String birthProfileId,
    required PredictionArea area,
    required PredictionPeriod period,
  }) async {
    emit(state.copyWith(busy: true));
    try {
      final p = await _repo.request(
        birthProfileId: birthProfileId,
        area: area,
        period: period,
      );
      await load(force: true);
      return p;
    } catch (e) {
      throw friendlyError(e);
    } finally {
      emit(state.copyWith(busy: false));
    }
  }

  Future<void> setSubscription(String action, {String? birthProfileId}) async {
    emit(state.copyWith(busy: true));
    try {
      await _repo.subscription(action, birthProfileId: birthProfileId);
      await loadCatalog(force: true);
    } catch (e) {
      throw friendlyError(e);
    } finally {
      emit(state.copyWith(busy: false));
    }
  }

  Future<void> _slice<T>(
    AsyncValue<T> Function() read,
    void Function(AsyncValue<T>) write,
    Future<T> Function() fetch, {
    bool force = false,
  }) async {
    final current = read();
    if (!force && (current.status == AsyncStatus.data || current.isLoading)) {
      return;
    }
    write(AsyncValue.loading(current.value));
    try {
      write(AsyncValue.data(await fetch()));
    } catch (e) {
      write(AsyncValue.error(friendlyError(e), current.value));
    }
  }
}
