part of 'chats_list_cubit.dart';

class ChatsListState extends Equatable {
  const ChatsListState({
    this.loading = false,
    this.conversations = const [],
    this.error,
  });

  final bool loading;

  /// One per astrologer, newest activity first — not one per consultation,
  /// which is what made repeat sessions with the same person look like
  /// separate strangers.
  final List<Conversation> conversations;
  final String? error;

  /// Threads with a paid session running right now.
  List<Conversation> get live =>
      conversations.where((c) => c.window.isLive).toList();

  /// Everything else: finished readings, and the ones still inside their free
  /// follow-up window.
  List<Conversation> get past =>
      conversations.where((c) => !c.window.isLive).toList();

  int get totalUnread => conversations.fold(0, (sum, c) => sum + c.unread);

  ChatsListState copyWith({
    bool? loading,
    List<Conversation>? conversations,
    String? error,
    bool clearError = false,
  }) => ChatsListState(
    loading: loading ?? this.loading,
    conversations: conversations ?? this.conversations,
    error: clearError ? null : (error ?? this.error),
  );

  @override
  List<Object?> get props => [loading, conversations, error];
}
