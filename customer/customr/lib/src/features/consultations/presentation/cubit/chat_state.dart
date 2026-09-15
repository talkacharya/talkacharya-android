part of 'chat_cubit.dart';

class ChatState extends Equatable {
  const ChatState({
    this.loading = false,
    this.consultation,
    this.lowBalance = false,
    this.error,
  });

  final bool loading;
  final Consultation? consultation;
  final bool lowBalance;
  final String? error;

  ConsultationStatus get status =>
      consultation?.status ?? ConsultationStatus.unknown;

  ChatState copyWith({
    bool? loading,
    Consultation? consultation,
    bool? lowBalance,
    String? error,
    bool clearError = false,
  }) {
    return ChatState(
      loading: loading ?? this.loading,
      consultation: consultation ?? this.consultation,
      lowBalance: lowBalance ?? this.lowBalance,
      error: clearError ? null : (error ?? this.error),
    );
  }

  @override
  List<Object?> get props => [loading, consultation, lowBalance, error];
}
