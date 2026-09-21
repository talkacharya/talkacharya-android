import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/realtime/realtime_client.dart';
import '../../data/consultation_api.dart';
import '../../data/models/consultation.dart';
import '../../../../core/network/friendly_error.dart';

class ChatState {
  const ChatState({
    this.loading = true,
    this.consultation,
    this.clientLowBalance = false,
    this.clientRunwaySeconds,
    this.error,
  });
  final bool loading;
  final Consultation? consultation;

  /// The customer's wallet is running low (from a `billing.low_balance` frame on
  /// `conv:`). The astrologer sees a "wrap up soon" hint.
  final bool clientLowBalance;

  /// Seconds of talk time the customer's wallet still covers (from
  /// `billing.tick`); `null` until the first tick.
  final int? clientRunwaySeconds;
  final String? error;

  ChatState copyWith({
    bool? loading,
    Consultation? consultation,
    bool? clientLowBalance,
    int? clientRunwaySeconds,
    Object? error = _s,
  }) => ChatState(
    loading: loading ?? this.loading,
    consultation: consultation ?? this.consultation,
    clientLowBalance: clientLowBalance ?? this.clientLowBalance,
    clientRunwaySeconds: clientRunwaySeconds ?? this.clientRunwaySeconds,
    error: error == _s ? this.error : error as String?,
  );
  static const _s = Object();
}

/// The consultation-room shell on the astrologer side: detail + status +
/// lifecycle. The message stream is the shared `ChatController`
/// (`package:talkacharya_chat`).
class ChatCubit extends Cubit<ChatState> {
  ChatCubit({
    required ConsultationApi api,
    required RealtimeClient realtime,
    required this.consultationId,
  }) : _api = api,
       _realtime = realtime,
       super(const ChatState());

  final ConsultationApi _api;
  final RealtimeClient _realtime;
  final String consultationId;

  Timer? _poll;
  StreamSubscription<Map<String, dynamic>>? _frames;

  /// Loads the consultation and starts polling + realtime. Safe to call again
  /// (the room's retry does).
  Future<void> init() async {
    _poll?.cancel();
    await _frames?.cancel();
    if (!state.loading) emit(state.copyWith(loading: true, error: null));
    try {
      emit(
        state.copyWith(
          loading: false,
          consultation: await _api.detail(consultationId),
        ),
      );
    } catch (e) {
      emit(state.copyWith(loading: false, error: friendlyError(e)));
    }
    _poll = Timer.periodic(const Duration(seconds: 8), (_) => _refreshDetail());
    _frames = _realtime
        .channelFrames('conv:$consultationId')
        .listen(_onFrame, onError: (_) {});
  }

  void _onFrame(Map<String, dynamic> frame) {
    final data = (frame['data'] as Map?)?.cast<String, dynamic>() ?? const {};
    switch (frame['type']) {
      case 'billing.low_balance':
        emit(state.copyWith(clientLowBalance: true));
      case 'billing.tick':
        final runway = (data['runway_seconds'] as num?)?.toInt() ?? 0;
        emit(
          state.copyWith(
            clientRunwaySeconds: runway,
            clientLowBalance: state.clientLowBalance && runway <= 180,
          ),
        );
      case 'consultation.shared':
      case 'consultation.started':
      case 'consultation.accepted':
      case 'consultation.ended':
      case 'consultation.no_show':
      case 'call.ringing':
        _refreshDetail();
    }
  }

  /// Re-read the consultation (e.g. after the call ended on the other side).
  Future<void> refresh() => _refreshDetail();

  Future<void> _refreshDetail() async {
    final c = state.consultation;
    if (c != null && c.isTerminal) {
      _poll?.cancel();
      return;
    }
    try {
      emit(state.copyWith(consultation: await _api.detail(consultationId)));
    } catch (_) {}
  }

  /// Ends the session; returns whether the backend accepted it.
  Future<bool> endConsultation() async {
    try {
      await _api.end(consultationId);
      await _refreshDetail();
      return true;
    } catch (e) {
      emit(state.copyWith(error: friendlyError(e)));
      return false;
    }
  }

  @override
  Future<void> close() async {
    _poll?.cancel();
    await _frames?.cancel();
    return super.close();
  }
}
