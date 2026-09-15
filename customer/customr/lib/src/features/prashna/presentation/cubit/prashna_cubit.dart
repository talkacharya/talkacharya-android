import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:astro_kundali/astro_kundali.dart';

import '../../../../core/network/friendly_error.dart';
import '../../../../core/util/async_value.dart';
import '../../data/prashna_repository.dart';

part 'prashna_state.dart';

/// Owns the Prashna home: the catalog (price, categories, wallet balance) and
/// the user's question history. Asking a question debits the wallet server-side.
class PrashnaCubit extends Cubit<PrashnaState> {
  PrashnaCubit(this._repo) : super(const PrashnaState());

  final PrashnaRepository _repo;

  Future<void> load({bool force = false}) async {
    await Future.wait([loadCatalog(force: force), loadHistory(force: force)]);
  }

  Future<void> loadCatalog({bool force = false}) => _slice(
    () => state.catalog,
    (v) => emit(state.copyWith(catalog: v)),
    _repo.catalog,
    force: force,
  );

  Future<void> loadHistory({bool force = false}) => _slice(
    () => state.history,
    (v) => emit(state.copyWith(history: v)),
    _repo.list,
    force: force,
  );

  /// Ask a question. Returns the answered [Prashna] or throws a friendly message
  /// (e.g. "Wallet balance is too low" / "Please wait a little").
  Future<Prashna> ask({
    required String question,
    required String category,
    double? latitude,
    double? longitude,
    String? placeLabel,
  }) async {
    emit(state.copyWith(busy: true));
    try {
      final p = await _repo.ask(
        question: question,
        category: category,
        latitude: latitude,
        longitude: longitude,
        placeLabel: placeLabel,
      );
      await load(force: true);
      return p;
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
