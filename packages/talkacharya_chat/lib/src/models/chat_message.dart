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
    // False once the server has deleted its copy (it keeps media a week);
    // the device's own copy is then the only one.
    @Default(true) bool available,
    // When the server copy goes.
    DateTime? expiresAt,
  }) = _ChatAttachment;

  const ChatAttachment._();

  factory ChatAttachment.fromMap(Map<String, dynamic> j) => ChatAttachment(
    id: j['id'] as String? ?? '',
    kind: j['kind'] as String? ?? 'image',
    name: j['name'] as String? ?? '',
    contentType: j['content_type'] as String? ?? '',
    sizeBytes: (j['size_bytes'] as num?)?.toInt() ?? 0,
    durationSeconds: (j['duration_seconds'] as num?)?.toInt() ?? 0,
    url: j['url'] as String? ?? '',
    available: j['available'] as bool? ?? true,
    expiresAt: DateTime.tryParse('${j['expires_at'] ?? ''}'),
  );

  /// `localPath` is left out on purpose: it names a file in this install's
  /// sandbox, which is meaningless to anything reading this back later.
  Map<String, dynamic> toMap() => {
    'id': id,
    'kind': kind,
    'name': name,
    'content_type': contentType,
    'size_bytes': sizeBytes,
    'duration_seconds': durationSeconds,
    'url': url,
    'available': available,
    'expires_at': expiresAt?.toIso8601String(),
  };
}

/// Just enough of a quoted message to draw the header above a reply.
///
/// Denormalised by the server on purpose: a reply to something far out of the
/// loaded window must still render, without holding the whole history.
@freezed
abstract class ChatReplyTo with _$ChatReplyTo {
  const factory ChatReplyTo({
    required int seq,
    @Default(ParticipantRole.customer) ParticipantRole senderRole,
    @Default('text') String type,
    @Default('') String body,
    @Default(false) bool redacted,
  }) = _ChatReplyTo;

  const ChatReplyTo._();

  factory ChatReplyTo.fromMap(Map<String, dynamic> j) => ChatReplyTo(
    seq: (j['seq'] as num?)?.toInt() ?? 0,
    senderRole: roleFromString(j['sender_role'] as String?),
    type: j['type'] as String? ?? 'text',
    body: j['body'] as String? ?? '',
    redacted: j['redacted'] == true,
  );

  Map<String, dynamic> toMap() => {
    'seq': seq,
    'sender_role': senderRole.name,
    'type': type,
    'body': body,
    'redacted': redacted,
  };
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
    ChatReplyTo? replyTo,
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
    replyTo: (j['reply_to'] as Map?) == null
        ? null
        : ChatReplyTo.fromMap((j['reply_to'] as Map).cast<String, dynamic>()),
    createdAt: DateTime.tryParse('${j['created_at']}'),
    deliveredAt: DateTime.tryParse('${j['delivered_at']}'),
    readAt: DateTime.tryParse('${j['read_at']}'),
  );

  /// The wire shape, which is also the storage shape — see [ChatMessage.fromMap].
  /// `sendStatus` is not here: it describes this device's attempt to send, and
  /// anything with a `seq` has already arrived.
  Map<String, dynamic> toMap() => {
    'id': id,
    'seq': seq,
    'sender_role': senderRole.name,
    'type': type,
    'body': body,
    'source_language': sourceLanguage,
    'translations': translations,
    'meta': meta,
    'attachments': [for (final a in attachments) a.toMap()],
    'client_message_id': clientMessageId,
    'reply_to': replyTo?.toMap(),
    'created_at': createdAt?.toIso8601String(),
    'delivered_at': deliveredAt?.toIso8601String(),
    'read_at': readAt?.toIso8601String(),
  };

  bool get isSystem =>
      senderRole == ParticipantRole.system || type == 'system_event';

  /// A birth profile or match the customer shared, drawn as a card rather than
  /// a grey system line.
  bool get isKundaliRef => type == 'kundali_ref';

  /// The shared person's summary, carried on the message so the card renders
  /// without a second fetch.
  Map<String, dynamic> get shareSummary =>
      (meta['summary'] as Map?)?.cast<String, dynamic>() ?? const {};

  /// What a shared-details card opens: a birth profile's kundali, or a match
  /// report. Null on anything that is not such a card, or one too old to say.
  SharedDetails? get shared {
    if (!isKundaliRef) return null;
    final id = shareSummary['id']?.toString() ?? '';
    if (id.isEmpty) return null;
    return SharedDetails(
      isMatch: meta['share_kind'] == 'match',
      id: id,
      consultationId: meta['consultation_id']?.toString() ?? '',
      name: _sharedName(shareSummary),
    );
  }
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


/// The target of a shared-details card. [id] is the birth profile's id, or the
/// match's; [consultationId] is the session it was shared in, which is what
/// scopes the astrologer's access to it.
class SharedDetails {
  const SharedDetails({
    required this.isMatch,
    required this.id,
    required this.consultationId,
    required this.name,
  });

  final bool isMatch;
  final String id;
  final String consultationId;
  final String name;
}

String _sharedName(Map<String, dynamic> summary) {
  String nameOf(Object? m) {
    final map = (m as Map?)?.cast<String, dynamic>() ?? const {};
    final full = (map['full_name'] as String? ?? '').trim();
    return full.isNotEmpty ? full : (map['label'] as String? ?? '').trim();
  }

  if (summary['boy'] != null || summary['girl'] != null) {
    return [nameOf(summary['boy']), nameOf(summary['girl'])]
        .where((n) => n.isNotEmpty)
        .join(' & ');
  }
  return nameOf(summary);
}
