import 'package:talkacharya_call/talkacharya_call.dart';
import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart' show AppLifecycleListener;
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
    bool watchApp = true,
  }) : _repo = repo,
       _realtime = realtime,
       super(const RequestsState()) {
    _sub = realtime.events.listen(_onEvent);
    // A frame sent while the socket was down is gone for good — a customer who
    // withdrew in that moment left the request ringing here until someone
    // pulled to refresh. So the list is re-read whenever the socket comes back
    // and whenever the app comes back to the front.
    _wasConnected = realtime.connected.value;
    realtime.connected.addListener(_onConnection);
    if (watchApp) _lifecycle = AppLifecycleListener(onResume: _reloadSoon);
  }

  final ConsultationRepository _repo;
  final RealtimeClient _realtime;
  StreamSubscription<RealtimeEvent>? _sub;
  Timer? _coalesce;
  AppLifecycleListener? _lifecycle;
  bool _wasConnected = false;

  /// While a request is waiting, the list is also re-read every so often: the
  /// belt to the socket's braces, for the request that ends unseen.
  Timer? _watch;
  static const watchEvery = Duration(seconds: 12);

  final _gone = StreamController<String>.broadcast();

  /// Requests that left the waiting list without this phone acting on them —
  /// withdrawn, timed out, answered on another phone — however that was learnt
  /// (a frame, or a re-read). The ringing sheet and the tray ring stop on it.
  Stream<String> get gone => _gone.stream;

  void _onConnection() {
    final now = _realtime.connected.value;
    if (now && !_wasConnected) _reloadSoon();
    _wasConnected = now;
  }

  /// Our own accept / decline: not "gone" in the sense above.
  final _handledHere = <String>{};

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
      final fresh = {for (final c in results[0]) c.id};
      for (final c in state.incoming) {
        if (!fresh.contains(c.id) && !_handledHere.contains(c.id)) {
          _gone.add(c.id);
        }
      }
      emit(
        state.copyWith(
          loading: false,
          incoming: results[0],
          active: results[1],
          history: results[2],
        ),
      );
      _syncWatch();
    } catch (e) {
      if (!isClosed) {
        emit(state.copyWith(loading: false, error: friendlyError(e)));
      }
    }
  }

  Future<Consultation?> accept(String id) async {
    _handledHere.add(id);
    _setBusy(id, true);
    try {
      final c = await _repo.api.accept(id);
      // If Android was told this request is ringing, the ring becomes the
      // call — the room adopts it instead of placing a second one.
      unawaited(CallTelecom.answerIncoming(id));
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
    _handledHere.add(id);
    _setBusy(id, true);
    try {
      await _repo.api.reject(id, reason);
      unawaited(CallTelecom.declineIncoming(id));
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
  void expireLocally(String id) {
    _handledHere.add(id);
    _removeIncoming(id);
  }

  void clearError() => emit(state.copyWith(error: null));

  void _setBusy(String id, bool on) {
    if (isClosed) return;
    final next = {...state.busy};
    on ? next.add(id) : next.remove(id);
    emit(state.copyWith(busy: next));
  }

  void _removeIncoming(String id) {
    emit(
      state.copyWith(
        incoming: state.incoming.where((c) => c.id != id).toList(),
      ),
    );
    _syncWatch();
  }

  void _syncWatch() {
    if (isClosed) return;
    if (state.incoming.isEmpty) {
      _watch?.cancel();
      _watch = null;
    } else {
      _watch ??= Timer.periodic(watchEvery, (_) => load());
    }
  }

  void _onEvent(RealtimeEvent e) {
    switch (e) {
      case RequestRemoved(:final consultationId):
        if (!_handledHere.contains(consultationId)) _gone.add(consultationId);
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
    _watch?.cancel();
    _lifecycle?.dispose();
    _realtime.connected.removeListener(_onConnection);
    await _sub?.cancel();
    await _gone.close();
    return super.close();
  }
}
