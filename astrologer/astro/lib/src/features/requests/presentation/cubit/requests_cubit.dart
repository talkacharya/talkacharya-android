import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/realtime/realtime_client.dart';
import '../../../../core/realtime/realtime_event.dart';
import '../../../consultations/data/consultation_repository.dart';
import '../../../consultations/data/models/consultation.dart';
import '../../../../core/network/friendly_error.dart';

class RequestsState extends Equatable {
  const RequestsState({
    this.loading = true,
    this.incoming = const [],
    this.active = const [],
    this.history = const [],
    this.busy = const {},
    this.error,
  });

  final bool loading;
  final List<Consultation> incoming;
  final List<Consultation> active;
  final List<Consultation> history;

  /// Request ids with an accept / decline in flight.
  final Set<String> busy;
  final String? error;

  bool get isEmpty => incoming.isEmpty && active.isEmpty && history.isEmpty;

  RequestsState copyWith({
    bool? loading,
    List<Consultation>? incoming,
    List<Consultation>? active,
    List<Consultation>? history,
    Set<String>? busy,
    Object? error = _s,
  }) => RequestsState(
    loading: loading ?? this.loading,
    incoming: incoming ?? this.incoming,
    active: active ?? this.active,
    history: history ?? this.history,
    busy: busy ?? this.busy,
    error: error == _s ? this.error : error as String?,
  );
  static const _s = Object();

  @override
  List<Object?> get props => [loading, incoming, active, history, busy, error];
}

/// App-level (singleton) source for the Requests tab and its nav badge:
/// waiting requests, live sessions and completed history, kept fresh by
/// realtime frames.
class RequestsCubit extends Cubit<RequestsState> {
  RequestsCubit({
    required ConsultationRepository repo,
    required RealtimeClient realtime,
  }) : _repo = repo,
       super(const RequestsState()) {
    _sub = realtime.events.listen(_onEvent);
  }

  final ConsultationRepository _repo;
  StreamSubscription<RealtimeEvent>? _sub;
  Timer? _coalesce;

  Future<void> load() async {
    // Keep the current lists on screen during a refresh.
    emit(state.copyWith(loading: state.isEmpty, error: null));
    try {
      final results = await Future.wait([
        _repo.api.incoming(),
        _repo.api.list(status: 'accepted,active'),
        _repo.api.list(status: 'ended'),
      ]);
      if (isClosed) return;
      emit(
        state.copyWith(
          loading: false,
          incoming: results[0],
          active: results[1],
          history: results[2],
        ),
      );
    } catch (e) {
      if (!isClosed) {
        emit(state.copyWith(loading: false, error: friendlyError(e)));
      }
    }
  }

  Future<Consultation?> accept(String id) async {
    _setBusy(id, true);
    try {
      final c = await _repo.api.accept(id);
      _removeIncoming(id);
      emit(
        state.copyWith(active: [c, ...state.active.where((a) => a.id != id)]),
      );
      return c;
    } catch (e) {
      emit(state.copyWith(error: friendlyError(e)));
      return null;
    } finally {
      _setBusy(id, false);
    }
  }

  Future<bool> reject(String id, String reason) async {
    _setBusy(id, true);
    try {
      await _repo.api.reject(id, reason);
      _removeIncoming(id);
      return true;
    } catch (e) {
      emit(state.copyWith(error: friendlyError(e)));
      return false;
    } finally {
      _setBusy(id, false);
    }
  }

  /// Drops a request whose accept window has run out locally; the server's
  /// `consultation.expired` frame usually arrives first anyway.
  void expireLocally(String id) => _removeIncoming(id);

  void clearError() => emit(state.copyWith(error: null));

  void _setBusy(String id, bool on) {
    if (isClosed) return;
    final next = {...state.busy};
    on ? next.add(id) : next.remove(id);
    emit(state.copyWith(busy: next));
  }

  void _removeIncoming(String id) => emit(
    state.copyWith(incoming: state.incoming.where((c) => c.id != id).toList()),
  );

  void _onEvent(RealtimeEvent e) {
    switch (e) {
      case RequestRemoved(:final consultationId):
        _removeIncoming(consultationId);
      case ConsultationRequested():
      case ConsultationEvent():
      case NewChatMessage():
        _reloadSoon();
      default:
        break;
    }
  }

  /// Realtime frames arrive in bursts; collapse them into one reload.
  void _reloadSoon() {
    _coalesce?.cancel();
    _coalesce = Timer(const Duration(milliseconds: 500), load);
  }

  @override
  Future<void> close() async {
    _coalesce?.cancel();
    await _sub?.cancel();
    return super.close();
  }
}
