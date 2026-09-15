part of 'chats_list_cubit.dart';

class ChatsListState extends Equatable {
  const ChatsListState({
    this.loading = false,
    this.consultations = const [],
    this.error,
  });

  final bool loading;
  final List<Consultation> consultations;
  final String? error;

  List<Consultation> get live =>
      consultations.where((c) => c.status.isLive).toList();

  List<Consultation> get past =>
      consultations.where((c) => !c.status.isLive).toList();

  int get totalUnread => consultations.fold(0, (sum, c) => sum + c.unreadCount);

  ChatsListState copyWith({
    bool? loading,
    List<Consultation>? consultations,
    String? error,
    bool clearError = false,
  }) => ChatsListState(
    loading: loading ?? this.loading,
    consultations: consultations ?? this.consultations,
    error: clearError ? null : (error ?? this.error),
  );

  @override
  List<Object?> get props => [loading, consultations, error];
}
