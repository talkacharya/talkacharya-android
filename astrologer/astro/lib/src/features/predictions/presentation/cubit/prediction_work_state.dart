part of 'prediction_work_cubit.dart';

class PredictionWorkState extends Equatable {
  const PredictionWorkState({
    this.prediction = const AsyncValue.idle(),
    this.saving = false,
    this.savedAt,
    this.error,
  });

  final AsyncValue<Prediction> prediction;
  final bool saving;
  final DateTime? savedAt;
  final String? error;

  PredictionWorkState copyWith({
    AsyncValue<Prediction>? prediction,
    bool? saving,
    DateTime? savedAt,
    String? error,
    bool clearError = false,
  }) => PredictionWorkState(
    prediction: prediction ?? this.prediction,
    saving: saving ?? this.saving,
    savedAt: savedAt ?? this.savedAt,
    error: clearError ? null : (error ?? this.error),
  );

  @override
  List<Object?> get props => [prediction, saving, savedAt, error];
}
