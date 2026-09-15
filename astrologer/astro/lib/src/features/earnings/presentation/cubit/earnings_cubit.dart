import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/earnings_api.dart';

class EarningsState {
  const EarningsState({
    this.loading = true,
    this.summary = const {},
    this.entries = const [],
    this.payouts = const [],
    this.documents = const [],
  });
  final bool loading;
  final Map<String, dynamic> summary;
  final List<Map<String, dynamic>> entries;
  final List<Map<String, dynamic>> payouts;
  final List<Map<String, dynamic>> documents;

  List<Map<String, dynamic>> get byCurrency =>
      (summary['by_currency'] as List? ?? const [])
          .map((e) => (e as Map).cast<String, dynamic>())
          .toList();

  EarningsState copyWith({
    bool? loading,
    Map<String, dynamic>? summary,
    List<Map<String, dynamic>>? entries,
    List<Map<String, dynamic>>? payouts,
    List<Map<String, dynamic>>? documents,
  }) => EarningsState(
    loading: loading ?? this.loading,
    summary: summary ?? this.summary,
    entries: entries ?? this.entries,
    payouts: payouts ?? this.payouts,
    documents: documents ?? this.documents,
  );
}

class EarningsCubit extends Cubit<EarningsState> {
  EarningsCubit(this._api) : super(const EarningsState());
  final EarningsApi _api;

  Future<void> load() async {
    emit(state.copyWith(loading: true));
    try {
      final r = await Future.wait([
        _api.summary(),
        _api.entries(),
        _api.payouts(),
        _api.taxDocuments(),
      ]);
      emit(
        EarningsState(
          loading: false,
          summary: r[0] as Map<String, dynamic>,
          entries: r[1] as List<Map<String, dynamic>>,
          payouts: r[2] as List<Map<String, dynamic>>,
          documents: r[3] as List<Map<String, dynamic>>,
        ),
      );
    } catch (_) {
      emit(state.copyWith(loading: false));
    }
  }
}
