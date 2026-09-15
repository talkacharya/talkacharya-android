part of 'prashna_cubit.dart';

class PrashnaState extends Equatable {
  const PrashnaState({
    this.catalog = const AsyncValue.idle(),
    this.history = const AsyncValue.idle(),
    this.busy = false,
  });

  final AsyncValue<PrashnaCatalog> catalog;
  final AsyncValue<List<Prashna>> history;
  final bool busy;

  PrashnaState copyWith({
    AsyncValue<PrashnaCatalog>? catalog,
    AsyncValue<List<Prashna>>? history,
    bool? busy,
  }) => PrashnaState(
    catalog: catalog ?? this.catalog,
    history: history ?? this.history,
    busy: busy ?? this.busy,
  );

  @override
  List<Object?> get props => [catalog, history, busy];
}
