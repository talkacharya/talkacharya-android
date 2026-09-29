import '../models/chat_message.dart';

/// A local copy of a thread's history.
///
/// The thread with an astrologer is permanent now — it outlives every
/// consultation inside it — so by the fifth reading the room is opening onto
/// months of messages the customer has already read, fetched again over a
/// phone connection every single time. This keeps them on the device: the room
/// paints from disk immediately and the network only reconciles the tail.
///
/// Only server-confirmed messages belong here. Unsent ones are the
/// [ChatOutbox]'s job, and mixing the two would resurrect a failed send as
/// though it had gone through.
///
/// Every method may be called on a cold cache and must simply return nothing
/// rather than throw: a chat that works is more important than a chat that is
/// fast, and the network is always still there behind this.
abstract class ChatStore {
  const ChatStore();

  /// The newest [limit] messages of [threadId], oldest-first — what opening
  /// the room asks for.
  Future<List<ChatMessage>> newest(String threadId, {int limit = 60});

  /// The [limit] messages immediately before [beforeSeq], oldest-first.
  ///
  /// Returns `null` — not an empty list — when the cache cannot answer without
  /// leaving a hole. `seq` is dense and server-assigned, so a page is only
  /// honest if it runs unbroken down from `beforeSeq - 1`; anything else would
  /// draw two distant stretches of the conversation as though they were
  /// consecutive. An empty list means the real beginning of the thread.
  Future<List<ChatMessage>?> before(
    String threadId,
    int beforeSeq, {
    int limit = 40,
  });

  /// Insert or replace [messages] in [threadId].
  Future<void> save(String threadId, List<ChatMessage> messages);

  /// Forget everything held for [threadId].
  Future<void> clear(String threadId);
}

/// The default: remembers nothing, so the controller behaves exactly as it did
/// before a store was wired in.
class NoopChatStore extends ChatStore {
  const NoopChatStore();

  @override
  Future<List<ChatMessage>> newest(String threadId, {int limit = 60}) async =>
      const [];

  @override
  Future<List<ChatMessage>?> before(
    String threadId,
    int beforeSeq, {
    int limit = 40,
  }) async => null;

  @override
  Future<void> save(String threadId, List<ChatMessage> messages) async {}

  @override
  Future<void> clear(String threadId) async {}
}
