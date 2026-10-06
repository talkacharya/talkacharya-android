import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/availability/availability_coordinator.dart';
import '../../../../core/network/friendly_error.dart';
import '../../../../core/util/async_value.dart';
import '../../data/performance_api.dart';
import '../../data/performance_models.dart';

class PerformanceState extends Equatable {
  const PerformanceState({
    this.performance = const AsyncValue.idle(),
    this.breaks = const AsyncValue.idle(),
    this.lapsed = const AsyncValue.idle(),
    this.breakBusy = false,
  });

  final AsyncValue<Performance> performance;
  final AsyncValue<BreakStatus> breaks;
  final AsyncValue<LapsedCustomers> lapsed;

  /// A break is being started or ended.
  final bool breakBusy;

  PerformanceState copyWith({
    AsyncValue<Performance>? performance,
    AsyncValue<BreakStatus>? breaks,
    AsyncValue<LapsedCustomers>? lapsed,
    bool? breakBusy,
  }) => PerformanceState(
    performance: performance ?? this.performance,
    breaks: breaks ?? this.breaks,
    lapsed: lapsed ?? this.lapsed,
    breakBusy: breakBusy ?? this.breakBusy,
  );

  @override
  List<Object?> get props => [performance, breaks, lapsed, breakBusy];
}

/// The scorecard, the break allowance and the win-back list — independent
/// [AsyncValue] slices, like the dashboard's.
class PerformanceCubit extends Cubit<PerformanceState> {
  PerformanceCubit({
    required PerformanceApi api,
    required AvailabilityCoordinator availability,
  }) : _api = api,
       _availability = availability,
       super(const PerformanceState());

  final PerformanceApi _api;
  final AvailabilityCoordinator _availability;
  Timer? _breakTimer;

  Future<void> load() => Future.wait([loadPerformance(), loadBreak()]);

  Future<void> loadPerformance() => _section<Performance>(
    read: (s) => s.performance,
    write: (s, v) => s.copyWith(performance: v),
    fetch: _api.performance,
  );

  Future<void> loadLapsed() => _section<LapsedCustomers>(
    read: (s) => s.lapsed,
    write: (s, v) => s.copyWith(lapsed: v),
    fetch: _api.lapsedCustomers,
  );

  Future<void> loadBreak() async {
    await _section<BreakStatus>(
      read: (s) => s.breaks,
      write: (s, v) => s.copyWith(breaks: v),
      fetch: _api.breakStatus,
    );
    _armBreakTimer();
  }

  /// Returns an error message, or null when the break started.
  Future<String?> startBreak(int minutes) =>
      _changeBreak(() => _api.startBreak(minutes));

  /// Comes back early. Returns an error message, or null on success.
  Future<String?> endBreak() => _changeBreak(_api.endBreak);

  Future<String?> _changeBreak(Future<BreakStatus> Function() call) async {
    if (state.breakBusy) return null;
    emit(state.copyWith(breakBusy: true));
    String? error;
    try {
      final next = await call();
      if (isClosed) return null;
      emit(state.copyWith(breaks: AsyncValue.data(next), breakBusy: false));
      _armBreakTimer();
      // Presence changed with it; don't leave the header a tick behind.
      unawaited(_availability.refresh());
    } catch (e) {
      error = friendlyError(e);
      if (!isClosed) emit(state.copyWith(breakBusy: false));
    }
    return error;
  }

  /// When the running break runs out, re-read both the allowance and presence:
  /// the astrologer comes back online without touching anything.
  void _armBreakTimer() {
    _breakTimer?.cancel();
    final endsAt = state.breaks.value?.endsAt;
    if (endsAt == null) return;
    final wait = endsAt.difference(DateTime.now());
    if (wait.isNegative) return;
    _breakTimer = Timer(wait + const Duration(seconds: 1), () async {
      if (isClosed) return;
      await _availability.refresh();
      if (!isClosed) await loadBreak();
    });
  }

  Future<void> _section<T>({
    required AsyncValue<T> Function(PerformanceState) read,
    required PerformanceState Function(PerformanceState, AsyncValue<T>) write,
    required Future<T> Function() fetch,
  }) async {
    emit(write(state, AsyncValue.loading(read(state).value)));
    AsyncValue<T> next;
    try {
      next = AsyncValue.data(await fetch());
    } catch (e) {
      next = AsyncValue.error(friendlyError(e), read(state).value);
    }
    if (isClosed) return;
    emit(write(state, next));
  }

  @override
  Future<void> close() {
    _breakTimer?.cancel();
    return super.close();
  }
}
