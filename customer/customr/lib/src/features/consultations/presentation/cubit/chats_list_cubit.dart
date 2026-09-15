import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/realtime/realtime_client.dart';
import '../../../../core/realtime/realtime_event.dart';
import '../../data/consultation_repository.dart';
import '../../data/models/consultation.dart';

part 'chats_list_state.dart';

/// Backs the Chats tab: the customer's consultations split into live + past,
/// refreshed on realtime nudges (a new message, an accept, an end) and a slow
/// foreground poll. Also the source of the bottom-nav unread badge.
class ChatsListCubit extends Cubit<ChatsListState> {
  ChatsListCubit({
    required ConsultationRepository repo,
    required RealtimeClient realtime,
  }) : _repo = repo,
       super(const ChatsListState()) {
    _sub = realtime.events.listen(_onEvent);
  }

  final ConsultationRepository _repo;
  StreamSubscription<RealtimeEvent>? _sub;
  Timer? _poll;
  Timer? _coalesce;
  DateTime _lastLoad = DateTime.fromMillisecondsSinceEpoch(0);

  Future<void> load({bool force = false}) async {
    if (!force &&
        DateTime.now().difference(_lastLoad) < const Duration(seconds: 2)) {
      return;
    }
    _lastLoad = DateTime.now();
    if (state.consultations.isEmpty) {
      emit(state.copyWith(loading: true, clearError: true));
    }
    try {
      final all = await _repo.list();
      emit(
        state.copyWith(loading: false, consultations: all, clearError: true),
      );
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  void startPolling() {
    _poll?.cancel();
    _poll = Timer.periodic(const Duration(seconds: 20), (_) => load());
  }

  void stopPolling() {
    _poll?.cancel();
    _poll = null;
  }

  void _onEvent(RealtimeEvent event) {
    switch (event) {
      case ConsultationEvent():
      case NewChatMessage():
      case InboxPing():
        _coalescedReload();
      default:
        break;
    }
  }

  /// Realtime nudges can burst; collapse them into one refresh ~600ms later
  /// (and bypass the poll's 2s debounce so the unread badge stays fresh).
  void _coalescedReload() {
    _coalesce?.cancel();
    _coalesce = Timer(
      const Duration(milliseconds: 600),
      () => load(force: true),
    );
  }

  @override
  Future<void> close() {
    _poll?.cancel();
    _coalesce?.cancel();
    _sub?.cancel();
    return super.close();
  }
}
