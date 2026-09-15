import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/models/wallet_transaction.dart';
import '../../data/wallet_repository.dart';

part 'transactions_state.dart';

/// Paginated wallet ledger. The backend has no kind filter, so filtering is
/// client-side over whatever pages have been loaded.
class TransactionsCubit extends Cubit<TransactionsState> {
  TransactionsCubit(this._repo) : super(const TransactionsState());

  final WalletRepository _repo;

  Future<void> load() async {
    if (state.status == TxnStatus.loading) return;
    emit(state.copyWith(status: TxnStatus.loading, clearError: true));
    try {
      final page = await _repo.transactions();
      emit(
        state.copyWith(
          status: TxnStatus.ready,
          items: page.items,
          nextCursor: () => page.nextCursor,
          hasMore: page.hasMore,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: TxnStatus.error, error: '$e'));
    }
  }

  Future<void> refresh() => load();

  Future<void> loadMore() async {
    if (!state.hasMore || state.status == TxnStatus.loadingMore) return;
    emit(state.copyWith(status: TxnStatus.loadingMore));
    try {
      final page = await _repo.transactions(cursor: state.nextCursor);
      emit(
        state.copyWith(
          status: TxnStatus.ready,
          items: [...state.items, ...page.items],
          nextCursor: () => page.nextCursor,
          hasMore: page.hasMore,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: TxnStatus.ready));
    }
  }

  void setFilter(TxnFilter filter) => emit(state.copyWith(filter: filter));
}
