import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/realtime/realtime_client.dart';
import '../../../../core/realtime/realtime_event.dart';
import '../../../consultations/data/consultation_repository.dart';
import '../../../consultations/data/models/consultation.dart';

class RequestsState extends Equatable {
  const RequestsState({
    this.loading = true,
    this.incoming = const [],
    this.active = const [],
    this.history = const [],
    this.error,
  });

  final bool loading;
  final List<Consultation> incoming;
  final List<Consultation> active;
  final List<Consultation> history;
  final String? error;

  RequestsState copyWith({
    bool? loading,
    List<Consultation>? incoming,
    List<Consultation>? active,
    List<Consultation>? history,
    Object? error = _s,
  }) => RequestsState(
    loading: loading ?? this.loading,
    incoming: incoming ?? this.incoming,
    active: active ?? this.active,
    history: history ?? this.history,
    error: error == _s ? this.error : error as String?,
  );
  static const _s = Object();

  @override
  List<Object?> get props => [loading, incoming, active, history, error];
}

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

  Future<void> load() async {
    emit(state.copyWith(loading: true, error: null));
    try {
      final results = await Future.wait([
        _repo.api.incoming(),
        _repo.api.list(status: 'active'),
        _repo.api.list(status: 'ended'),
      ]);
      emit(
        state.copyWith(
          loading: false,
          incoming: results[0],
          active: results[1],
          history: results[2],
        ),
      );
    } catch (e) {
      emit(state.copyWith(loading: false, error: '$e'));
    }
  }

  Future<Consultation?> accept(String id) async {
    try {
      final c = await _repo.api.accept(id);
      _removeIncoming(id);
      emit(state.copyWith(active: [c, ...state.active]));
      return c;
    } catch (e) {
      emit(state.copyWith(error: '$e'));
      return null;
    }
  }

  Future<void> reject(String id, String reason) async {
    try {
      await _repo.api.reject(id, reason);
      _removeIncoming(id);
    } catch (e) {
      emit(state.copyWith(error: '$e'));
    }
  }

  void _removeIncoming(String id) => emit(
    state.copyWith(incoming: state.incoming.where((c) => c.id != id).toList()),
  );

  void _onEvent(RealtimeEvent e) {
    switch (e) {
      case ConsultationRequested():
        load();
      case RequestRemoved(:final consultationId):
        _removeIncoming(consultationId);
      case ConsultationEvent(kind: 'ended'):
      case ConsultationEvent(kind: 'accepted'):
      case ConsultationEvent(kind: 'started'):
      case NewChatMessage():
        load();
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
