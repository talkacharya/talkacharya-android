import 'package:freezed_annotation/freezed_annotation.dart';

import 'chat_enums.dart';

part 'chat_message.freezed.dart';

@freezed
abstract class ChatAttachment with _$ChatAttachment {
  const factory ChatAttachment({
    required String id,
    @Default('image') String kind, // image | audio
    @Default('') String name,
    @Default('') String contentType,
    @Default(0) int sizeBytes,
    @Default(0) int durationSeconds,
    @Default('') String url,
    // client-only: local file path while an optimistic upload is in flight
    @Default('') String localPath,
  }) = _ChatAttachment;

  factory ChatAttachment.fromMap(Map<String, dynamic> j) => ChatAttachment(
    id: j['id'] as String? ?? '',
    kind: j['kind'] as String? ?? 'image',
    name: j['name'] as String? ?? '',
    contentType: j['content_type'] as String? ?? '',
    sizeBytes: (j['size_bytes'] as num?)?.toInt() ?? 0,
    durationSeconds: (j['duration_seconds'] as num?)?.toInt() ?? 0,
    url: j['url'] as String? ?? '',
  );
}

/// One message in a consultation. Unified across both apps — the reader decides
/// "mine" via [ChatIdentity.role], not a baked-in flag.
@freezed
abstract class ChatMessage with _$ChatMessage {
  const factory ChatMessage({
    required String id,
    @Default(0) int seq,
    @Default(ParticipantRole.customer) ParticipantRole senderRole,
    @Default('text') String type, // text | image | audio | system_event
    @Default('') String body,
    @Default('') String sourceLanguage,
    @Default(<String, String>{}) Map<String, String> translations,
    @Default(<String, dynamic>{})
    Map<String, dynamic> meta, // system_event payload
    @Default(<ChatAttachment>[]) List<ChatAttachment> attachments,
    @Default('') String clientMessageId,
    DateTime? createdAt,
    DateTime? deliveredAt,
    DateTime? readAt,
    // client-only
    @Default(SendStatus.sent) SendStatus sendStatus,
  }) = _ChatMessage;

  const ChatMessage._();

  factory ChatMessage.fromMap(Map<String, dynamic> j) => ChatMessage(
    id: j['id']?.toString() ?? '',
    seq: (j['seq'] as num?)?.toInt() ?? 0,
    senderRole: roleFromString(j['sender_role'] as String?),
    type: j['type'] as String? ?? 'text',
    body: j['body'] as String? ?? '',
    sourceLanguage: j['source_language'] as String? ?? '',
    translations: ((j['translations'] as Map?) ?? const {}).map(
      (k, v) => MapEntry('$k', '$v'),
    ),
    meta: (j['meta'] as Map?)?.cast<String, dynamic>() ?? const {},
    attachments: (j['attachments'] as List<dynamic>? ?? const [])
        .whereType<Map<String, dynamic>>()
        .where((m) => m['id'] != null)
        .map(ChatAttachment.fromMap)
        .toList(),
    clientMessageId: j['client_message_id'] as String? ?? '',
    createdAt: DateTime.tryParse('${j['created_at']}'),
    deliveredAt: DateTime.tryParse('${j['delivered_at']}'),
    readAt: DateTime.tryParse('${j['read_at']}'),
  );

  bool get isSystem =>
      senderRole == ParticipantRole.system || type == 'system_event';
  String get systemEvent => meta['event'] as String? ?? '';
  String get dedupeKey =>
      clientMessageId.isNotEmpty ? 'c:$clientMessageId' : 'i:$id';

  /// The text to show a reader who prefers [lang]: the translation if we have one
  /// and it differs from the source, else the original body.
  String bodyFor(String lang, {required bool preferTranslation}) {
    if (!preferTranslation) return body;
    final base = lang.split('-').first;
    if (base.isEmpty || base == sourceLanguage) return body;
    return translations[base] ?? body;
  }

  bool hasTranslationFor(String lang) =>
      translations.containsKey(lang.split('-').first);
}
