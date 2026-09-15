import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/network/friendly_error.dart';
import '../../../../core/util/async_value.dart';
import '../../data/models/catalog.dart';
import '../../data/models/consult.dart';
import '../../data/store_repository.dart';

/// Store landing: the catalog home + the customer's recent astrologer advice.
/// Slices load and fail independently.
class StoreHomeCubit extends Cubit<StoreHomeState> {
  StoreHomeCubit(this._repo) : super(const StoreHomeState());

  final StoreRepository _repo;

  Future<void> load({bool force = false}) =>
      Future.wait([_loadHome(force), _loadConsults()]);

  Future<void> _loadHome(bool force) async {
    emit(state.copyWith(home: AsyncValue.loading(state.home.value)));
    try {
      final home = await _repo.home(force: force);
      emit(state.copyWith(home: AsyncValue.data(home)));
    } catch (e) {
      emit(
        state.copyWith(
          home: AsyncValue.error(friendlyError(e), state.home.value),
        ),
      );
    }
  }

  Future<void> _loadConsults() async {
    try {
      final list = await _repo.consults();
      emit(state.copyWith(consults: AsyncValue.data(list)));
    } catch (_) {
      // advice is a bonus section — hide it on failure
      emit(state.copyWith(consults: const AsyncValue.data([])));
    }
  }
}

class StoreHomeState extends Equatable {
  const StoreHomeState({
    this.home = const AsyncValue.idle(),
    this.consults = const AsyncValue.idle(),
  });

  final AsyncValue<StoreHome> home;
  final AsyncValue<List<StoreConsult>> consults;

  /// The most recent consult that has an answer (or is waiting on one).
  StoreConsult? get latestAdvice {
    final list = consults.value ?? const <StoreConsult>[];
    for (final c in list) {
      if (c.status == ConsultStatus.verdictGiven ||
          c.status == ConsultStatus.awaitingVerdict) {
        return c;
      }
    }
    return null;
  }

  StoreHomeState copyWith({
    AsyncValue<StoreHome>? home,
    AsyncValue<List<StoreConsult>>? consults,
  }) => StoreHomeState(
    home: home ?? this.home,
    consults: consults ?? this.consults,
  );

  @override
  List<Object?> get props => [home, consults];
}
