part of 'predictions_cubit.dart';

class PredictionsState extends Equatable {
  const PredictionsState({
    this.catalog = const AsyncValue.idle(),
    this.list = const AsyncValue.idle(),
    this.busy = false,
  });

  final AsyncValue<PredictionCatalog> catalog;
  final AsyncValue<List<Prediction>> list;
  final bool busy;

  PredictionsState copyWith({
    AsyncValue<PredictionCatalog>? catalog,
    AsyncValue<List<Prediction>>? list,
    bool? busy,
  }) => PredictionsState(
    catalog: catalog ?? this.catalog,
    list: list ?? this.list,
    busy: busy ?? this.busy,
  );

  @override
  List<Object?> get props => [catalog, list, busy];
}
