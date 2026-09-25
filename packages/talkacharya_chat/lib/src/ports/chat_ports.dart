import '../models/chat_message.dart';
import '../models/chat_enums.dart';
import '../models/chat_pin.dart';
import '../models/chat_presence.dart';

/// REST transport for one consultation's chat. Each app implements this against
/// its own Dio client + API paths.
abstract class ChatTransport {
  /// Forward from [afterSeq] (live tail / reconnect backfill) OR the page of
  /// messages immediately before [beforeSeq] (scroll-up). Oldest-first.
  Future<List<ChatMessage>> history({
    int afterSeq = 0,
    int? beforeSeq,
    int limit = 50,
  });

  Future<ChatMessage> send({
    String body = '',
    required String clientMessageId,
    List<String> attachmentIds = const [],
    int? replyToSeq,
  });

  Future<void> markRead(int upToSeq);
  Future<void> markDelivered(int upToSeq);

  /// Fallback typing signal (used when the realtime layer can't publish).
  Future<void> sendTyping(bool isTyping);

  /// Translate one message into [target] (bcp-47 base). Returns the text, or null.
  Future<String?> translate(int seq, String target);

  Future<ChatPresence> presence();

  /// Upload one local file (image) and return the server [ChatAttachment]
  /// (its `id` is then passed to [send] as an `attachmentId`).
  Future<ChatAttachment> uploadAttachment(String filePath);

  /// Report a message for moderation. [reason] is one of
  /// `abuse` | `spam` | `inappropriate` | `other`.
  Future<void> reportMessage(int seq, String reason);

  /// Pinned messages, shared by both participants.
  Future<List<ChatPin>> pins();
  Future<void> pin(int seq);
  Future<void> unpin(int seq);
}

/// Where the app should source images from.
enum PickSource { camera, gallery }

/// Supplied by each app (wraps `image_picker`): returns picked file paths.
typedef PickImages = Future<List<String>> Function(PickSource source);

/// Realtime transport — a live view of the `conv:{id}` channel plus the socket's
/// connection state. `frames` yields the raw `{v,type,ts,data}` frames.
abstract class ChatRealtime {
  Stream<Map<String, dynamic>> frames(String channel);
  Stream<ConnectionStatus> get connection;
  ConnectionStatus get connectionNow;

  /// Centrifugo join/leave for the channel. May be an empty stream if the app's
  /// realtime client doesn't surface them.
  Stream<PresenceEvent> presenceEvents(String channel) => const Stream.empty();

  /// Publish [data] directly to [channel] (the ephemeral `chattyping:` channel).
  /// Default no-op — the controller falls back to the HTTP typing endpoint.
  Future<void> publish(String channel, Map<String, dynamic> data) async {}
}

/// Who the current user is in this conversation.
abstract class ChatIdentity {
  ParticipantRole get role;
  String get userId;

  /// The reader's preferred language (bcp-47 base, e.g. `hi`, `en`).
  String get language;

  /// Whether this user may dictate messages by voice (astrologer = true).
  bool get canDictate;
}

/// Room sounds. The app plugs in its sound player; the default is silent.
abstract class ChatSounds {
  /// A new message from the other participant arrived while the room is open.
  void incoming();

  /// The server confirmed a message this user sent.
  void sent();
}

class NoopChatSounds implements ChatSounds {
  const NoopChatSounds();
  @override
  void incoming() {}
  @override
  void sent() {}
}
