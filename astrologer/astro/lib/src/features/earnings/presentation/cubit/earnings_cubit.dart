import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/util/async_value.dart';
import '../../../home/data/dashboard_models.dart';
import '../../data/earnings_api.dart';
import '../../data/earnings_models.dart';
import '../../../../core/network/friendly_error.dart';

/// A cursor-paginated list slice.
class Paged<T> extends Equatable {
  const Paged({
    this.items = const [],
    this.cursor,
    this.loading = true,
    this.loadingMore = false,
    this.error = false,
  });

  final List<T> items;
  final String? cursor;
  final bool loading;
  final bool loadingMore;
  final bool error;

  bool get hasMore => cursor != null;

  Paged<T> copyWith({
    List<T>? items,
    Object? cursor = _s,
    bool? loading,
    bool? loadingMore,
    bool? error,
  }) => Paged(
    items: items ?? this.items,
    cursor: cursor == _s ? this.cursor : cursor as String?,
    loading: loading ?? this.loading,
    loadingMore: loadingMore ?? this.loadingMore,
    error: error ?? this.error,
  );
  static const _s = Object();

  @override
  List<Object?> get props => [items, cursor, loading, loadingMore, error];
}

class EarningsState extends Equatable {
  const EarningsState({
    this.summary = const AsyncValue.idle(),
    this.kind,
    this.ledger = const Paged(),
    this.payouts = const Paged(),
    this.documents = const AsyncValue.idle(),
  });

  final AsyncValue<PayoutSummary> summary;

  /// Ledger filter (an [EarningKinds] value); `null` = all.
  final String? kind;
  final Paged<EarningEntry> ledger;
  final Paged<Payout> payouts;
  final AsyncValue<List<TaxDocument>> documents;

  EarningsState copyWith({
    AsyncValue<PayoutSummary>? summary,
    Object? kind = _s,
    Paged<EarningEntry>? ledger,
    Paged<Payout>? payouts,
    AsyncValue<List<TaxDocument>>? documents,
  }) => EarningsState(
    summary: summary ?? this.summary,
    kind: kind == _s ? this.kind : kind as String?,
    ledger: ledger ?? this.ledger,
    payouts: payouts ?? this.payouts,
    documents: documents ?? this.documents,
  );
  static const _s = Object();

  @override
  List<Object?> get props => [summary, kind, ledger, payouts, documents];
}

/// Earnings tab: balance summary, the earnings ledger (filterable, paged),
/// payouts (paged) and tax documents.
class EarningsCubit extends Cubit<EarningsState> {
  EarningsCubit(this._api) : super(const EarningsState());
  final EarningsApi _api;

  Future<void> load() => Future.wait([
    _loadSummary(),
    _loadLedger(),
    _loadPayouts(),
    _loadDocuments(),
  ]);

  Future<void> _loadSummary() async {
    emit(state.copyWith(summary: AsyncValue.loading(state.summary.value)));
    try {
      final s = PayoutSummary.fromJson(await _api.summary());
      if (!isClosed) emit(state.copyWith(summary: AsyncValue.data(s)));
    } catch (e) {
      if (!isClosed) {
        emit(
          state.copyWith(
            summary: AsyncValue.error(friendlyError(e), state.summary.value),
          ),
        );
      }
    }
  }

  // --- ledger -------------------------------------------------------------

  Future<void> setKind(String? kind) async {
    if (kind == state.kind) return;
    emit(state.copyWith(kind: kind, ledger: const Paged()));
    await _loadLedger();
  }

  Future<void> _loadLedger() async {
    final kind = state.kind;
    emit(
      state.copyWith(
        ledger: state.ledger.copyWith(loading: true, error: false),
      ),
    );
    try {
      final page = await _api.entries(kind: kind);
      if (isClosed || state.kind != kind) return;
      emit(
        state.copyWith(
          ledger: Paged(
            items: page.items,
            cursor: page.nextCursor,
            loading: false,
          ),
        ),
      );
    } catch (_) {
      if (isClosed || state.kind != kind) return;
      emit(
        state.copyWith(
          ledger: state.ledger.copyWith(loading: false, error: true),
        ),
      );
    }
  }

  Future<void> loadMoreLedger() async {
    final l = state.ledger;
    if (!l.hasMore || l.loadingMore || l.loading) return;
    final kind = state.kind;
    emit(state.copyWith(ledger: l.copyWith(loadingMore: true)));
    try {
      final page = await _api.entries(cursor: l.cursor, kind: kind);
      if (isClosed || state.kind != kind) return;
      final cur = state.ledger;
      emit(
        state.copyWith(
          ledger: cur.copyWith(
            items: [...cur.items, ...page.items],
            cursor: page.nextCursor,
            loadingMore: false,
          ),
        ),
      );
    } catch (_) {
      if (!isClosed) {
        emit(state.copyWith(ledger: state.ledger.copyWith(loadingMore: false)));
      }
    }
  }

  // --- payouts ------------------------------------------------------------

  Future<void> _loadPayouts() async {
    emit(
      state.copyWith(
        payouts: state.payouts.copyWith(loading: true, error: false),
      ),
    );
    try {
      final page = await _api.payouts();
      if (isClosed) return;
      emit(
        state.copyWith(
          payouts: Paged(
            items: page.items,
            cursor: page.nextCursor,
            loading: false,
          ),
        ),
      );
    } catch (_) {
      if (!isClosed) {
        emit(
          state.copyWith(
            payouts: state.payouts.copyWith(loading: false, error: true),
          ),
        );
      }
    }
  }

  Future<void> loadMorePayouts() async {
    final p = state.payouts;
    if (!p.hasMore || p.loadingMore || p.loading) return;
    emit(state.copyWith(payouts: p.copyWith(loadingMore: true)));
    try {
      final page = await _api.payouts(cursor: p.cursor);
      if (isClosed) return;
      final cur = state.payouts;
      emit(
        state.copyWith(
          payouts: cur.copyWith(
            items: [...cur.items, ...page.items],
            cursor: page.nextCursor,
            loadingMore: false,
          ),
        ),
      );
    } catch (_) {
      if (!isClosed) {
        emit(
          state.copyWith(payouts: state.payouts.copyWith(loadingMore: false)),
        );
      }
    }
  }

  // --- documents ----------------------------------------------------------

  Future<void> _loadDocuments() async {
    emit(state.copyWith(documents: AsyncValue.loading(state.documents.value)));
    try {
      final docs = await _api.taxDocuments();
      if (!isClosed) emit(state.copyWith(documents: AsyncValue.data(docs)));
    } catch (e) {
      if (!isClosed) {
        emit(
          state.copyWith(
            documents: AsyncValue.error(
              friendlyError(e),
              state.documents.value,
            ),
          ),
        );
      }
    }
  }
}
