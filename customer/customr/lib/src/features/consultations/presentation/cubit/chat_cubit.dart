import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/realtime/realtime_client.dart';
import '../../data/consultation_api.dart';
import '../../data/consultation_repository.dart';
import '../../data/models/consultation.dart';
import '../../data/models/conversation.dart';
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

  /// Counts the runway down between server ticks, which arrive once a minute.
  Timer? _runway;

  Future<void> init() async {
    emit(state.copyWith(loading: true, clearError: true));
    try {
      // `consultationId` may be either id — the server resolves both — but the
      // realtime channel is keyed on the thread, so subscribe only once we
      // know which thread this is.
      final conversation = await _repo.conversation(consultationId);
      if (isClosed) return;
      emit(state.copyWith(conversation: conversation));
      await _loadLiveConsultation(conversation);
      if (isClosed) return;
      emit(state.copyWith(loading: false));
      _frames = _realtime
          .channelFrames('conv:${conversation.id}')
          .listen(_onFrame, onError: (_) {});
    } catch (e) {
      if (isClosed) return;
      emit(state.copyWith(loading: false, error: friendlyError(e)));
    }
    _startPolling();
  }

  /// The session this room is about: the live one when there is one, then
  /// one still waiting to be answered, else the most recent — the wrap-up and
  /// the rating still belong to it after it ends, and the thread outlives both.
  ///
  /// The pending one matters most on a call: the window does not count a
  /// ringing call as live, so this used to fall through to the last ended chat
  /// and the customer watched a finished conversation while the phone rang.
  Future<void> _loadLiveConsultation(Conversation conversation) async {
    final id =
        conversation.window.consultationId ??
        conversation.pendingConsultationId ??
        conversation.lastConsultationId;
    if (id == null) {
      // A thread nobody has ever consulted in. Rare — threads are created by
      // consultations — and not an error, so nothing is said about it.
      emit(state.copyWith(clearConsultation: true));
      return;
    }
    try {
      emit(state.copyWith(consultation: await _repo.detail(id), clearError: true));
    } catch (e) {
      // Surfaced, not swallowed: the room cannot draw without this, so the
      // customer is about to see a failure either way and deserves the reason.
      emit(state.copyWith(error: friendlyError(e)));
    }
  }


  /// Take on a session that was just started from inside this room.
  ///
  /// The thread's sending window only knows about *live* sessions, so a
  /// request nobody has accepted yet is invisible to it — re-reading the
  /// thread here would quietly put the room back on the last ended chat. The
  /// caller has the new session in hand; this is how it arrives.
  void adopt(Consultation started) {
    emit(state.copyWith(consultation: started, clearError: true));
    _startPolling();
  }

  /// Mute or block from the room. Returns the error to show, or null.
  ///
  /// Blocking is refused while a session is open (the server says so), which
  /// comes back here as the message to show.
  Future<String?> setPreferences({bool? muted, bool? blocked}) async {
    try {
      final updated = await _repo.setPreferences(
        state.threadId ?? consultationId,
        muted: muted,
        blocked: blocked,
      );
      emit(state.copyWith(conversation: updated));
      return null;
    } catch (e) {
      return friendlyError(e);
    }
  }

  /// Ask this astrologer for another session, from inside the thread.
  ///
  /// No booking form: the server carries over who the reading is for, and the
  /// room shows the request being answered where the button was. Throws the
  /// booking exceptions ([InsufficientBalance], [AstrologerBusy],
  /// [AstrologerOffline]) for the room to answer in place.
  Future<Consultation> startAgain({String channel = 'chat'}) async {
    final started = await _repo.consultAgain(
      state.threadId ?? consultationId,
      channel: channel,
    );
    adopt(started);
    return started;
  }

  /// The session actions aim at: the live one, else the one the room shows.
  /// Never [consultationId] first — opened from the chats list, that is the
  /// *thread's* id, and the consultation endpoints answer it with a 404.
  String get _sessionId =>
      state.window.consultationId ?? state.consultation?.id ?? consultationId;

  /// Move this consultation onto [channel]. The chat ends and a new session
  /// is requested with the same astrologer, in the same thread — so the room
  /// the customer is looking at does not change, only what is running in it.
  ///
  /// Returns the new consultation's id, or null if it could not be done.
  Future<String?> upgradeChannel(String channel) async {
    final id = state.window.consultationId ?? state.consultation?.id;
    if (id == null) return null;
    try {
      final upgraded = await _repo.upgradeChannel(id, channel);
      // Deliberately no thread refresh here. The new session is `requested`,
      // which the window does not count as live, so a re-read would point the
      // room back at the chat that was just ended. The caller navigates to the
      // new consultation, which resolves the same thread on the way in.
      emit(state.copyWith(consultation: upgraded, clearError: true));
      return upgraded.id;
    } catch (e) {
      emit(state.copyWith(error: friendlyError(e)));
      return null;
    }
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
      case 'billing.awaiting_payment':
        // Out of money with a recharge in flight: the consultation is being
        // held open. Saying so is the whole point — silence here looks like a
        // call that has already dropped.
        emit(
          state.copyWith(
            awaitingPaymentUntil:
                DateTime.tryParse('${data['until']}') ??
                DateTime.now().add(const Duration(seconds: 120)),
          ),
        );
      case 'billing.resumed':
        emit(state.copyWith(clearAwaitingPayment: true, lowBalance: false));
      case 'billing.payment_grace_expired':
        emit(state.copyWith(clearAwaitingPayment: true));
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
      case 'consultation.requested':
        // Someone in this thread asked for a session — usually this device a
        // moment ago, but it also covers a request made from the astrologer's
        // profile in another tab, or a room reopened while one is pending.
        final id = data['consultation']?.toString() ?? '';
        if (id.isNotEmpty && id != state.consultation?.id) {
          unawaited(_adoptById(id));
        }
      case 'consultation.shared':
        _refreshDetail();
      case 'consultation.ended':
      case 'consultation.rejected':
      case 'consultation.no_show':
      case 'consultation.expired':
      case 'consultation.cancelled':
        _refreshDetail();
    }
  }

  Future<void> _adoptById(String id) async {
    try {
      adopt(await _repo.detail(id));
    } catch (_) {
      // The frame told us there is one; failing to read it just means the
      // room keeps showing the session it already had.
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

  /// Re-read the thread (its window may have moved from live to follow-up to
  /// closed) and whatever session is in it.
  Future<void> _refreshThread() async {
    try {
      final conversation = await _repo.conversation(consultationId);
      emit(state.copyWith(conversation: conversation));
      await _loadLiveConsultation(conversation);
      // Nothing left to poll for once the thread stops taking messages and
      // nothing is waiting to be answered; a new consultation re-opens the room
      // through its own realtime frame.
      if (conversation.window.isClosed &&
          conversation.pendingConsultationId == null) {
        _poll?.cancel();
      }
    } catch (_) {}
  }

  /// Everything that used to ask "what is this consultation doing?" now asks
  /// the thread, because the answer may be "nothing — it ended, and we are in
  /// the follow-up window".
  Future<void> _refreshDetail() => _refreshThread();

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
    // A server figure resets the local count: it is the one that is right.
    if (runway != null) _startRunwayCountdown();
  }

  /// Tick the runway down locally, one second at a time.
  ///
  /// Purely cosmetic — nothing bills off this, and every server frame
  /// overwrites it. What it buys is a number that visibly moves, so someone
  /// watching their balance run out can act while there is still time to.
  void _startRunwayCountdown() {
    _runway?.cancel();
    _runway = Timer.periodic(const Duration(seconds: 1), (_) {
      final c = state.consultation;
      if (c == null || isClosed) return;
      // The meter is off while a payment is being waited for; counting down
      // through a hold would tell the customer the opposite of the truth.
      if (state.awaitingPayment || !c.status.canChat) return;
      if (c.runwaySeconds <= 0) return;
      emit(
        state.copyWith(
          consultation: c.copyWith(runwaySeconds: c.runwaySeconds - 1),
        ),
      );
    });
  }

  /// Shares a birth profile or a match with the astrologer. Returns the error
  /// message on failure, or null when it worked.
  Future<String?> share({String? birthProfileId, String? matchId}) async {
    try {
      final c = await _repo.share(
        _sessionId,
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
      emit(state.copyWith(consultation: await _repo.end(_sessionId)));
      // The window has moved to the free follow-up, which is what decides
      // whether the composer stays open — so read it rather than guess.
      unawaited(_reloadThread());
    } catch (e) {
      emit(state.copyWith(error: friendlyError(e)));
    }
  }

  /// Withdraw the request the room is waiting on.
  ///
  /// Aimed at the pending session rather than at [consultationId], which is
  /// the thread's id whenever the room was opened from the chats list — and,
  /// once a second session has been requested inside the thread, is the wrong
  /// session even when it is a consultation id.
  Future<void> cancelRequest() async {
    final id = state.consultation?.id ?? consultationId;
    try {
      final cancelled = await _repo.cancel(id);
      emit(state.copyWith(consultation: cancelled));
      // Nothing is running now, so the room goes back to being the thread:
      // history, the follow-up window if one is open, and the way to start
      // again. Re-reading is safe here precisely because the pending session
      // that made it unsafe is the one just cancelled.
      unawaited(_reloadThread());
    } catch (e) {
      emit(state.copyWith(error: friendlyError(e)));
    }
  }

  Future<void> _reloadThread() async {
    try {
      final fresh = await _repo.conversation(consultationId);
      emit(state.copyWith(conversation: fresh));
      await _loadLiveConsultation(fresh);
    } catch (_) {
      // The room is still readable on what it already has.
    }
  }

  Future<void> submitReview(int rating, {String text = ''}) async {
    try {
      await _repo.review(
        state.consultation?.id ?? consultationId,
        rating: rating,
        text: text,
      );
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
    _runway?.cancel();
    _frames?.cancel();
    return super.close();
  }
}
