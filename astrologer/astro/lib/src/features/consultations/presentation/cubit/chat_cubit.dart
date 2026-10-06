import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/realtime/realtime_client.dart';
import '../../data/consultation_api.dart';
import '../../data/models/consultation.dart';
import '../../data/models/conversation.dart';
import '../../../../core/network/friendly_error.dart';

class ChatState {
  const ChatState({
    this.loading = true,
    this.conversation,
    this.consultation,
    this.clientLowBalance = false,
    this.clientRunwaySeconds,
    this.customerToppingUp = false,
    this.error,
  });
  final bool loading;

  /// The permanent thread. The room exists even when no session runs in it.
  final Conversation? conversation;

  /// The session this room is about: the live one, else the most recent — the
  /// wrap-up and the earnings line still belong to it after it ends.
  final Consultation? consultation;

  /// The customer's wallet is running low (from a `billing.low_balance` frame on
  /// `conv:`). The astrologer sees a "wrap up soon" hint.
  final bool clientLowBalance;

  /// Seconds of talk time the customer's wallet still covers (from
  /// `billing.tick`); `null` until the first tick.
  final int? clientRunwaySeconds;

  /// The customer ran out mid-session and is paying right now, so the
  /// consultation is being held rather than ended. Nothing is being billed —
  /// which the astrologer has to be told, or the quiet looks like a customer
  /// who has walked off and they end a session that is about to resume.
  final bool customerToppingUp;
  final String? error;

  SendingWindow get window => conversation?.window ?? const SendingWindow();

  /// Whether the composer is live: during a paid session, and through the
  /// free follow-up window after one ends.
  bool get canSend => window.canSend;

  /// History only — nothing more can be written in this thread until the
  /// customer starts another consultation.
  bool get isClosed => conversation != null && window.isClosed;

  ChatState copyWith({
    bool? loading,
    Conversation? conversation,
    Consultation? consultation,
    bool? clientLowBalance,
    int? clientRunwaySeconds,
    bool? customerToppingUp,
    Object? error = _s,
  }) => ChatState(
    loading: loading ?? this.loading,
    conversation: conversation ?? this.conversation,
    consultation: consultation ?? this.consultation,
    clientLowBalance: clientLowBalance ?? this.clientLowBalance,
    clientRunwaySeconds: clientRunwaySeconds ?? this.clientRunwaySeconds,
    customerToppingUp: customerToppingUp ?? this.customerToppingUp,
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
    required this.threadId,
  }) : _api = api,
       _realtime = realtime,
       super(const ChatState());

  final ConsultationApi _api;
  final RealtimeClient _realtime;

  /// Either id resolves — the server accepts a consultation's too — but the
  /// realtime channel is keyed on the thread.
  final String threadId;

  Timer? _poll;
  StreamSubscription<Map<String, dynamic>>? _frames;

  /// Loads the consultation and starts polling + realtime. Safe to call again
  /// (the room's retry does).
  Future<void> init() async {
    _poll?.cancel();
    await _frames?.cancel();
    if (!state.loading) emit(state.copyWith(loading: true, error: null));
    try {
      final conversation = await _api.conversation(threadId);
      emit(state.copyWith(conversation: conversation));
      await _loadSession(conversation);
      _frames = _realtime
          .channelFrames('conv:${conversation.id}')
          .listen(_onFrame, onError: (_) {});
      emit(state.copyWith(loading: false));
    } catch (e) {
      emit(state.copyWith(loading: false, error: friendlyError(e)));
    }
    _poll = Timer.periodic(const Duration(seconds: 8), (_) => _refreshDetail());
  }

  /// The session the room is about: the live one, then one the customer is
  /// asking for right now (which the card answers with Accept / Decline),
  /// else the most recent.
  Future<void> _loadSession(Conversation conversation) async {
    final id =
        conversation.window.consultationId ??
        conversation.pendingConsultationId ??
        conversation.lastConsultationId;
    if (id == null) return;
    try {
      emit(state.copyWith(consultation: await _api.detail(id)));
    } catch (_) {
      // the thread still opens; only the session chrome is missing
    }
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
      case 'billing.awaiting_payment':
        // Out of money, payment in flight: the session is held, not over.
        emit(state.copyWith(customerToppingUp: true));
      case 'billing.resumed':
        emit(state.copyWith(customerToppingUp: false, clientLowBalance: false));
      case 'billing.payment_grace_expired':
        emit(state.copyWith(customerToppingUp: false));
      case 'consultation.shared':
      case 'consultation.started':
      case 'consultation.accepted':
      case 'consultation.ended':
      case 'consultation.no_show':
      case 'call.ringing':
        _refreshDetail();
      // The customer asked, withdrew, or the ask ran out — in a thread that is
      // closed at the time, which the ordinary refresh would skip.
      case 'consultation.requested':
      case 'consultation.cancelled':
      case 'consultation.expired':
      case 'consultation.rejected':
        _refreshDetail(force: true);
    }
  }

  /// Accept the request waiting in this room. For a chat the session starts
  /// right here; for a call the room turns into the call screen.
  Future<bool> acceptPending(Future<Object?> Function(String id) accept) =>
      _answerPending(accept);

  /// Decline it without leaving the conversation.
  Future<bool> declinePending(Future<Object?> Function(String id) decline) =>
      _answerPending(decline);

  Future<bool> _answerPending(Future<Object?> Function(String id) act) async {
    final c = state.consultation;
    if (c == null || !c.isRequested) return false;
    final done = await act(c.id);
    // Whatever happened, re-read: the thread moves from closed to live on an
    // accept, and back to its last session on a decline.
    await _refreshDetail(force: true);
    _poll?.cancel();
    _poll = Timer.periodic(const Duration(seconds: 8), (_) => _refreshDetail());
    return done != null && done != false;
  }

  /// Re-read the thread and its session (e.g. after the call ended on the
  /// other side).
  Future<void> refresh() => _refreshDetail();

  Future<void> _refreshDetail({bool force = false}) async {
    // Nothing moves in a closed thread by itself — but a request waiting in
    // it does (accepted, declined, expired), and so does one just made.
    final waiting = state.consultation?.isRequested ?? false;
    if (state.isClosed && !waiting && !force) {
      _poll?.cancel();
      return;
    }
    try {
      final conversation = await _api.conversation(threadId);
      emit(state.copyWith(conversation: conversation));
      await _loadSession(conversation);
    } catch (_) {}
  }

  /// Mute or block from the room. Returns the error to show, or null —
  /// blocking during an open session is refused by the server, and that
  /// refusal is the message.
  Future<String?> setPreferences({bool? muted, bool? blocked}) async {
    try {
      final updated = await _api.setPreferences(
        state.conversation?.id ?? threadId,
        muted: muted,
        blocked: blocked,
      );
      emit(state.copyWith(conversation: updated));
      return null;
    } catch (e) {
      return friendlyError(e);
    }
  }

  /// Ends the session; returns whether the backend accepted it.
  Future<bool> endConsultation() async {
    final id = state.window.consultationId ?? state.consultation?.id;
    if (id == null) return false;
    try {
      await _api.end(id);
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
