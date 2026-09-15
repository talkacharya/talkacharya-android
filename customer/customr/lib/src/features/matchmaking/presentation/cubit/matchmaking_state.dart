part of 'matchmaking_cubit.dart';

class MatchmakingState extends Equatable {
  const MatchmakingState({
    this.boy,
    this.girl,
    this.running = false,
    this.error,
    this.history = const AsyncValue.idle(),
  });

  final BirthProfile? boy;
  final BirthProfile? girl;
  final bool running;
  final String? error;
  final AsyncValue<List<MatchResult>> history;

  bool get canRun => boy != null && girl != null && boy!.id != girl!.id;

  MatchmakingState copyWith({
    BirthProfile? boy,
    BirthProfile? girl,
    bool clearBoy = false,
    bool clearGirl = false,
    bool? running,
    String? error,
    bool clearError = false,
    AsyncValue<List<MatchResult>>? history,
  }) => MatchmakingState(
    boy: clearBoy ? null : (boy ?? this.boy),
    girl: clearGirl ? null : (girl ?? this.girl),
    running: running ?? this.running,
    error: clearError ? null : (error ?? this.error),
    history: history ?? this.history,
  );

  @override
  List<Object?> get props => [boy, girl, running, error, history];
}
