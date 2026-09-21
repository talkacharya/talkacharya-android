import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/livestream_api.dart';
import '../../data/models/live_stream_summary.dart';

enum LiveListStatus { loading, ready, failed }

/// The Live tab: what is on air now and what is coming up.
///
/// The list is refreshed on a timer while the tab is open — a stream starting is
/// the whole point of the tab, and the viewer counts go stale in seconds.
class LiveListCubit extends Cubit<LiveListState> {
  LiveListCubit(this._api, {this.refreshEvery = const Duration(seconds: 20)})
    : super(const LiveListState());

  final LivestreamApi _api;
  final Duration refreshEvery;
  Timer? _timer;

  Future<void> load({bool silent = false}) async {
    if (!silent) emit(state.copyWith(status: LiveListStatus.loading));
    try {
      final all = await _api.list();
      emit(
        LiveListState(
          status: LiveListStatus.ready,
          live: [
            for (final s in all)
              if (s.isLive) s,
          ],
          upcoming: [
            for (final s in all)
              if (s.isScheduled) s,
          ],
        ),
      );
    } catch (e) {
      if (state.status == LiveListStatus.ready && silent) return;
      emit(state.copyWith(status: LiveListStatus.failed, error: e));
    }
  }

  /// Starts (or restarts) the background refresh — called when the tab appears.
  void watch() {
    _timer?.cancel();
    _timer = Timer.periodic(refreshEvery, (_) => load(silent: true));
    unawaited(load(silent: state.status == LiveListStatus.ready));
  }

  void unwatch() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}

class LiveListState extends Equatable {
  const LiveListState({
    this.status = LiveListStatus.loading,
    this.live = const [],
    this.upcoming = const [],
    this.error,
  });

  final LiveListStatus status;
  final List<LiveStreamSummary> live;
  final List<LiveStreamSummary> upcoming;
  final Object? error;

  bool get isEmpty => live.isEmpty && upcoming.isEmpty;

  LiveListState copyWith({
    LiveListStatus? status,
    List<LiveStreamSummary>? live,
    List<LiveStreamSummary>? upcoming,
    Object? error,
  }) => LiveListState(
    status: status ?? this.status,
    live: live ?? this.live,
    upcoming: upcoming ?? this.upcoming,
    error: error ?? this.error,
  );

  @override
  List<Object?> get props => [status, live, upcoming, error];
}
