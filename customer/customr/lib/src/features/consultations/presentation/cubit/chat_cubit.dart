import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/realtime/realtime_client.dart';
import '../../data/consultation_repository.dart';
import '../../data/models/consultation.dart';
import '../../../../core/network/friendly_error.dart';

part 'chat_state.dart';

/// The consultation-room shell: detail, status, billing and lifecycle actions.
/// The message stream itself is owned by the shared `ChatController`
/// (`package:talkacharya_chat`) — this only tracks the consultation around it.
class ChatCubit extends Cubit<ChatState> {
  ChatCubit({
    required ConsultationRepository repo,
    required RealtimeClient realtime,
    required this.consultationId,
  }) : _repo = repo,
       _realtime = realtime,
       super(const ChatState());

  final ConsultationRepository _repo;
  final RealtimeClient _realtime;
  final String consultationId;

  Timer? _poll;
  StreamSubscription<Map<String, dynamic>>? _frames;
  int _tick = 0;

  Future<void> init() async {
    emit(state.copyWith(loading: true, clearError: true));
    try {
      final consultation = await _repo.detail(consultationId);
      emit(state.copyWith(loading: false, consultation: consultation));
    } catch (e) {
      emit(state.copyWith(loading: false, error: friendlyError(e)));
    }
    _startPolling();
    _frames = _realtime
        .channelFrames('conv:$consultationId')
        .listen(_onFrame, onError: (_) {});
  }

  void _onFrame(Map<String, dynamic> frame) {
    final type = frame['type'] as String? ?? '';
    final data = (frame['data'] as Map?)?.cast<String, dynamic>() ?? const {};
    switch (type) {
      case 'billing.tick':
        final runway = (data['runway_seconds'] as num?)?.toInt();
        _applyBilling(
          runway: runway,
          gross: data['amount_charged']?.toString(),
        );
        // a healthy runway after a recharge clears the warning
        if (state.lowBalance && runway != null && runway > 180) {
          emit(state.copyWith(lowBalance: false));
        }
      case 'billing.low_balance':
        emit(state.copyWith(lowBalance: true));
        _applyBilling(runway: (data['runway_seconds'] as num?)?.toInt());
      case 'call.ringing':
        // voice/video: the astrologer accepted — the room starts the call
        final c = state.consultation;
        if (c != null && c.status == ConsultationStatus.requested) {
          emit(
            state.copyWith(
              consultation: c.copyWith(status: ConsultationStatus.accepted),
            ),
          );
        }
        _refreshDetail();
      case 'consultation.started':
      case 'consultation.accepted':
        // flip the local view to "live" at once; the refresh reconciles the rest
        final c = state.consultation;
        if (c != null && !c.status.canChat) {
          emit(
            state.copyWith(
              consultation: c.copyWith(status: ConsultationStatus.active),
            ),
          );
        }
        _refreshDetail();
      case 'consultation.shared':
        _refreshDetail();
      case 'consultation.ended':
      case 'consultation.rejected':
      case 'consultation.no_show':
        _refreshDetail();
    }
  }

  void _startPolling() {
    _poll?.cancel();
    _poll = Timer.periodic(const Duration(seconds: 5), (_) => _tickNow());
  }

  Future<void> _tickNow() async {
    final c = state.consultation;
    if (c == null || c.status.isTerminal) {
      _poll?.cancel();
      return;
    }
    _tick++;
    if (_tick % 3 == 0) await _refreshDetail();
  }

  /// Re-read the consultation (e.g. after the call ended on the other side).
  Future<void> refresh() => _refreshDetail();

  Future<void> _refreshDetail() async {
    try {
      final c = await _repo.detail(consultationId);
      emit(state.copyWith(consultation: c));
      if (c.status.isTerminal) _poll?.cancel();
    } catch (_) {}
  }

  void _applyBilling({int? runway, String? gross}) {
    final c = state.consultation;
    if (c == null) return;
    emit(
      state.copyWith(
        consultation: c.copyWith(
          runwaySeconds: runway ?? c.runwaySeconds,
          grossAmount: gross ?? c.grossAmount,
        ),
      ),
    );
  }

  /// Shares a birth profile or a match with the astrologer. Returns the error
  /// message on failure, or null when it worked.
  Future<String?> share({String? birthProfileId, String? matchId}) async {
    try {
      final c = await _repo.share(
        consultationId,
        birthProfileId: birthProfileId,
        matchId: matchId,
      );
      emit(state.copyWith(consultation: c));
      return null;
    } catch (e) {
      return friendlyError(e);
    }
  }

  Future<void> endConsultation() async {
    try {
      emit(state.copyWith(consultation: await _repo.end(consultationId)));
      _poll?.cancel();
    } catch (e) {
      emit(state.copyWith(error: friendlyError(e)));
    }
  }

  Future<void> cancelRequest() async {
    try {
      emit(state.copyWith(consultation: await _repo.cancel(consultationId)));
    } catch (e) {
      emit(state.copyWith(error: friendlyError(e)));
    }
  }

  Future<void> submitReview(int rating, {String text = ''}) async {
    try {
      await _repo.review(consultationId, rating: rating, text: text);
      final c = state.consultation;
      if (c != null) {
        emit(state.copyWith(consultation: c.copyWith(rating: rating)));
      }
    } catch (e) {
      emit(state.copyWith(error: friendlyError(e)));
      rethrow;
    }
  }

  @override
  Future<void> close() {
    _poll?.cancel();
    _frames?.cancel();
    return super.close();
  }
}
