import '../models/chat_enums.dart';
import '../models/chat_message.dart';

/// Persists a consultation's *unsent* messages so a full app-kill mid-send
/// doesn't lose them. The [ChatController] saves after every enqueue / status
/// change and restores in [ChatController.start]. Each app supplies a real
/// implementation (disk-backed); the default keeps nothing.
abstract class ChatOutbox {
  const ChatOutbox();

  Future<List<ChatMessage>> load(String consultationId);
  Future<void> save(String consultationId, List<ChatMessage> unsent);

  /// Serialise the minimum needed to re-send a message.
  static Map<String, dynamic> encode(ChatMessage m) => {
    'cmid': m.clientMessageId,
    'body': m.body,
    'type': m.type,
    'role': m.senderRole.name,
    'lang': m.sourceLanguage,
    'at': m.createdAt?.toIso8601String(),
    'paths': [
      for (final a in m.attachments)
        if (a.localPath.isNotEmpty) a.localPath,
    ],
  };

  static ChatMessage decode(Map<String, dynamic> j) {
    final paths =
        (j['paths'] as List?)?.whereType<String>().toList() ?? const [];
    return ChatMessage(
      id: j['cmid'] as String? ?? '',
      clientMessageId: j['cmid'] as String? ?? '',
      body: j['body'] as String? ?? '',
      type: j['type'] as String? ?? 'text',
      senderRole: roleFromString(j['role'] as String?),
      sourceLanguage: j['lang'] as String? ?? '',
      createdAt: DateTime.tryParse('${j['at']}'),
      sendStatus: SendStatus.failed,
      attachments: [
        for (final p in paths)
          ChatAttachment(id: '', kind: 'image', localPath: p),
      ],
    );
  }
}

/// Default — remembers nothing (unsent messages still survive a reconnect within
/// a session, just not a process death).
class NoopChatOutbox extends ChatOutbox {
  const NoopChatOutbox();

  @override
  Future<List<ChatMessage>> load(String consultationId) async => const [];

  @override
  Future<void> save(String consultationId, List<ChatMessage> unsent) async {}
}
