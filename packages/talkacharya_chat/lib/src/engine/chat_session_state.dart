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
    error,
  ];
}
