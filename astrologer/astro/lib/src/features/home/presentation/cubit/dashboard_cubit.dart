import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/astro/onboarding_store.dart';
import '../../../../core/realtime/realtime_client.dart';
import '../../../../core/realtime/realtime_event.dart';
import '../../../../core/util/async_value.dart';
import '../../../consultations/data/consultation_api.dart';
import '../../../consultations/data/models/consultation.dart';
import '../../data/dashboard_api.dart';
import '../../data/dashboard_models.dart';
import '../../../../core/network/friendly_error.dart';

/// The stats windows offered on the earnings card.
const kDashboardPeriods = [7, 30, 90];

class DashboardState extends Equatable {
  const DashboardState({
    this.period = 7,
    this.stats = const AsyncValue.idle(),
    this.payouts = const AsyncValue.idle(),
    this.incoming = const AsyncValue.idle(),
    this.active = const AsyncValue.idle(),
  });

  final int period;
  final AsyncValue<DashboardStats> stats;
  final AsyncValue<PayoutSummary> payouts;
  final AsyncValue<List<Consultation>> incoming;
  final AsyncValue<List<Consultation>> active;

  DashboardState copyWith({
    int? period,
    AsyncValue<DashboardStats>? stats,
    AsyncValue<PayoutSummary>? payouts,
    AsyncValue<List<Consultation>>? incoming,
    AsyncValue<List<Consultation>>? active,
  }) => DashboardState(
    period: period ?? this.period,
    stats: stats ?? this.stats,
    payouts: payouts ?? this.payouts,
    incoming: incoming ?? this.incoming,
    active: active ?? this.active,
  );

  @override
  List<Object?> get props => [period, stats, payouts, incoming, active];
}

/// Home dashboard. Each section is an independent [AsyncValue] slice so one
/// failing endpoint doesn't blank the screen. Realtime consultation events
/// refresh the request/session slices.
class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit({
    required DashboardApi api,
    required ConsultationApi consultations,
    required OnboardingStore onboarding,
    required RealtimeClient realtime,
  }) : _api = api,
       _consultations = consultations,
       _onboarding = onboarding,
       super(const DashboardState()) {
    _sub = realtime.events.listen(_onEvent);
  }

  final DashboardApi _api;
  final ConsultationApi _consultations;
  final OnboardingStore _onboarding;
  StreamSubscription<RealtimeEvent>? _sub;

  Future<void> load() async {
    await Future.wait([
      loadStats(),
      _loadPayouts(),
      _loadSessions(),
      // Followers / profile-strength read the store's profile.
      _onboarding.refresh(),
    ]);
  }

  Future<void> setPeriod(int days) async {
    if (days == state.period) return;
    emit(state.copyWith(period: days));
    await loadStats();
  }

  Future<void> loadStats() {
    final period = state.period;
    return _section<DashboardStats>(
      read: (s) => s.stats,
      write: (s, v) => s.copyWith(stats: v),
      fetch: () => _api.stats(days: period),
      // Drop a response for a period the user has already switched away from.
      stillWanted: () => state.period == period,
    );
  }

  Future<void> _loadPayouts() => _section<PayoutSummary>(
    read: (s) => s.payouts,
    write: (s, v) => s.copyWith(payouts: v),
    fetch: _api.payouts,
  );

  Future<void> _loadSessions() => Future.wait([
    _section<List<Consultation>>(
      read: (s) => s.incoming,
      write: (s, v) => s.copyWith(incoming: v),
      fetch: _consultations.incoming,
    ),
    _section<List<Consultation>>(
      read: (s) => s.active,
      write: (s, v) => s.copyWith(active: v),
      fetch: () => _consultations.list(status: 'active'),
    ),
  ]);

  /// Loads one slice. `state` is read only *after* the await so concurrent
  /// loaders never overwrite each other with a stale snapshot.
  Future<void> _section<T>({
    required AsyncValue<T> Function(DashboardState) read,
    required DashboardState Function(DashboardState, AsyncValue<T>) write,
    required Future<T> Function() fetch,
    bool Function()? stillWanted,
  }) async {
    emit(write(state, AsyncValue.loading(read(state).value)));
    AsyncValue<T> next;
    try {
      next = AsyncValue.data(await fetch());
    } catch (e) {
      next = AsyncValue.error(friendlyError(e), read(state).value);
    }
    if (isClosed || (stillWanted != null && !stillWanted())) return;
    emit(write(state, next));
  }

  void _onEvent(RealtimeEvent e) {
    switch (e) {
      case ConsultationRequested():
      case ConsultationEvent():
        _loadSessions();
      case RequestRemoved(:final consultationId):
        final list = state.incoming.value;
        if (list == null) return;
        emit(
          state.copyWith(
            incoming: AsyncValue.data(
              list.where((c) => c.id != consultationId).toList(),
            ),
          ),
        );
      default:
        break;
    }
  }

  @override
  Future<void> close() async {
    await _sub?.cancel();
    return super.close();
  }
}
