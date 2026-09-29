/// Floor-backed local history for a consultation thread: the disk half of
/// `talkacharya_chat`'s [ChatStore] port.
///
/// Wire it where the [ChatController] is built:
///
/// ```dart
/// ChatController(..., store: getIt<FloorChatStore>())
/// ```
///
/// and clear it on sign-out, since it holds the conversation itself.
library;

export 'src/chat_database.dart';
export 'src/floor_chat_store.dart';
