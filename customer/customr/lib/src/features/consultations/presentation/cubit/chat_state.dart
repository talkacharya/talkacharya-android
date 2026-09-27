part of 'chat_cubit.dart';

class ChatState extends Equatable {
  const ChatState({
    this.loading = false,
    this.conversation,
    this.consultation,
    this.lowBalance = false,
    this.awaitingPaymentUntil,
    this.error,
  });

  final bool loading;

  /// The permanent thread. Always present once loaded — the room exists even
  /// when no consultation is running in it.
  final Conversation? conversation;

  /// The paid session running right now, if there is one. Null between
  /// sessions, including through the free follow-up window.
  final Consultation? consultation;
  final bool lowBalance;

  /// The balance ran out while a recharge was open, so the consultation is
  /// being held rather than ended. Null when nothing is being held.
  final DateTime? awaitingPaymentUntil;

  bool get awaitingPayment => awaitingPaymentUntil != null;
  final String? error;

  ConsultationStatus get status =>
      consultation?.status ?? ConsultationStatus.unknown;

  SendingWindow get window => conversation?.window ?? const SendingWindow();

  /// Whether the composer is live: during a paid session, and through the
  /// free follow-up window after one ends.
  bool get canSend => window.canSend;

  /// History only — the customer has to start a consultation to write again.
  bool get isClosed => conversation != null && window.isClosed;

  /// The thread's id, which is what the realtime channels are keyed on.
  String? get threadId => conversation?.id;

  ChatState copyWith({
    bool? loading,
    Conversation? conversation,
    Consultation? consultation,
    bool clearConsultation = false,
    bool? lowBalance,
    DateTime? awaitingPaymentUntil,
    bool clearAwaitingPayment = false,
    String? error,
    bool clearError = false,
  }) {
    return ChatState(
      loading: loading ?? this.loading,
      conversation: conversation ?? this.conversation,
      consultation: clearConsultation
          ? null
          : (consultation ?? this.consultation),
      lowBalance: lowBalance ?? this.lowBalance,
      awaitingPaymentUntil: clearAwaitingPayment
          ? null
          : (awaitingPaymentUntil ?? this.awaitingPaymentUntil),
      error: clearError ? null : (error ?? this.error),
    );
  }

  @override
  List<Object?> get props => [
    loading,
    conversation,
    consultation,
    lowBalance,
    awaitingPaymentUntil,
    error,
  ];
}
