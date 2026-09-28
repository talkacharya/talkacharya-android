part of 'chat_controller.dart';

class ChatSessionState extends Equatable {
  const ChatSessionState({
    this.loading = true,
    this.messages = const [],
    this.connection = ConnectionStatus.connecting,
    this.presence = const ChatPresence(),
    this.otherTyping = false,
    this.loadingOlder = false,
    this.hasMoreOlder = true,
    this.autoTranslate = false,
    this.pins = const [],
    this.searchQuery = '',
    this.searchResults = const [],
    this.searching = false,
    this.jumpToSeq,
    this.replyingTo,
    this.error,
  });

  final bool loading;
  final List<ChatMessage> messages;
  final ConnectionStatus connection;
  final ChatPresence presence;
  final bool otherTyping;
  final bool loadingOlder;
  final bool hasMoreOlder;
  final bool autoTranslate;

  /// Pinned messages, newest first. Shared by both participants.
  final List<ChatPin> pins;

  /// What is being looked for in this thread, and what came back.
  final String searchQuery;
  final List<ChatMessage> searchResults;
  final bool searching;

  bool get isSearching => searchQuery.length >= 2;

  /// A message the transcript should scroll to, set when a search result is
  /// picked and cleared once the list has moved. Null the rest of the time.
  final int? jumpToSeq;

  /// The message the composer is currently replying to, if any.
  final ChatMessage? replyingTo;
  final String? error;

  int get lastSeq =>
      messages.where((m) => m.seq > 0).fold(0, (a, m) => m.seq > a ? m.seq : a);
  int get firstSeq => messages
      .where((m) => m.seq > 0)
      .fold(1 << 30, (a, m) => m.seq < a ? m.seq : a);

  ChatSessionState copyWith({
    bool? loading,
    List<ChatMessage>? messages,
    ConnectionStatus? connection,
    ChatPresence? presence,
    bool? otherTyping,
    bool? loadingOlder,
    bool? hasMoreOlder,
    bool? autoTranslate,
    List<ChatPin>? pins,
    String? searchQuery,
    List<ChatMessage>? searchResults,
    bool? searching,
    int? jumpToSeq,
    bool clearJump = false,
    Object? replyingTo = _unset,
    Object? error = _unset,
  }) {
    return ChatSessionState(
      loading: loading ?? this.loading,
      messages: messages ?? this.messages,
      connection: connection ?? this.connection,
      presence: presence ?? this.presence,
      otherTyping: otherTyping ?? this.otherTyping,
      loadingOlder: loadingOlder ?? this.loadingOlder,
      hasMoreOlder: hasMoreOlder ?? this.hasMoreOlder,
      autoTranslate: autoTranslate ?? this.autoTranslate,
      pins: pins ?? this.pins,
      searchQuery: searchQuery ?? this.searchQuery,
      searchResults: searchResults ?? this.searchResults,
      searching: searching ?? this.searching,
      jumpToSeq: clearJump ? null : (jumpToSeq ?? this.jumpToSeq),
      replyingTo: replyingTo == _unset
          ? this.replyingTo
          : replyingTo as ChatMessage?,
      error: error == _unset ? this.error : error as String?,
    );
  }

  static const _unset = Object();

  @override
  List<Object?> get props => [
    loading,
    messages,
    connection,
    presence,
    otherTyping,
    loadingOlder,
    hasMoreOlder,
    autoTranslate,
    pins,
    searchQuery,
    searchResults,
    searching,
    jumpToSeq,
    replyingTo,
    error,
  ];
}
