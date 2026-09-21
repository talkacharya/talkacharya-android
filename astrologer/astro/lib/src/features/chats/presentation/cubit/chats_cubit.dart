import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/realtime/realtime_client.dart';
import '../../../../core/realtime/realtime_event.dart';
import '../../../consultations/data/consultation_api.dart';
import '../../../consultations/data/models/consultation.dart';
import '../../../../core/network/friendly_error.dart';

class ChatsState extends Equatable {
  const ChatsState({
    this.loading = true,
    this.all = const [],
    this.query = '',
    this.error,
  });

  final bool loading;

  /// Every conversation that got past the request stage, newest first.
  final List<Consultation> all;
  final String query;
  final String? error;

  List<Consultation> get _filtered {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return all;
    return all.where((c) => c.customerName.toLowerCase().contains(q)).toList();
  }

  List<Consultation> get live => _filtered.where((c) => c.isLive).toList();
  List<Consultation> get recent => _filtered.where((c) => !c.isLive).toList();

  /// Unread messages across live conversations — the Chats nav badge.
  int get totalUnread =>
      all.where((c) => c.isLive).fold(0, (sum, c) => sum + c.unreadCount);

  ChatsState copyWith({
    bool? loading,
    List<Consultation>? all,
    String? query,
    Object? error = _s,
  }) => ChatsState(
    loading: loading ?? this.loading,
    all: all ?? this.all,
    query: query ?? this.query,
    error: error == _s ? this.error : error as String?,
  );
  static const _s = Object();

  @override
  List<Object?> get props => [loading, all, query, error];
}

/// App-level (singleton) backing for the Chats tab and its unread badge.
/// Refreshes on realtime nudges, and polls slowly while the tab is visible.
class ChatsCubit extends Cubit<ChatsState> {
  ChatsCubit({required ConsultationApi api, required RealtimeClient realtime})
    : _api = api,
      super(const ChatsState()) {
    _sub = realtime.events.listen(_onEvent);
  }

  final ConsultationApi _api;
  StreamSubscription<RealtimeEvent>? _sub;
  Timer? _poll;
  Timer? _coalesce;

  static const statuses = 'accepted,active,ended,no_show';

  Future<void> load() async {
    emit(state.copyWith(loading: state.all.isEmpty, error: null));
    try {
      final all = await _api.list(status: statuses);
      if (!isClosed) emit(state.copyWith(loading: false, all: all));
    } catch (e) {
      if (!isClosed) {
        emit(state.copyWith(loading: false, error: friendlyError(e)));
      }
    }
  }

  void search(String query) => emit(state.copyWith(query: query));

  void startPolling() {
    _poll?.cancel();
    _poll = Timer.periodic(const Duration(seconds: 20), (_) => load());
  }

  void stopPolling() {
    _poll?.cancel();
    _poll = null;
  }

  void _onEvent(RealtimeEvent e) {
    switch (e) {
      case ConsultationEvent():
      case NewChatMessage():
      case InboxPing():
        _coalesce?.cancel();
        _coalesce = Timer(const Duration(milliseconds: 600), load);
      default:
        break;
    }
  }

  @override
  Future<void> close() async {
    _poll?.cancel();
    _coalesce?.cancel();
    await _sub?.cancel();
    return super.close();
  }
}
