enum SendStatus { sent, pending, failed }

class ChatMessage {
  ChatMessage({
    required this.id,
    required this.seq,
    required this.senderRole,
    required this.body,
    required this.type,
    required this.createdAt,
    this.clientId,
    this.status = SendStatus.sent,
    this.readAt,
    this.attachmentUrl,
  });

  final String id;
  final int seq;
  final String senderRole; // customer | astrologer | system
  final String body;
  final String type; // text | image | audio | system
  final DateTime createdAt;
  final String? clientId;
  final SendStatus status;
  final DateTime? readAt;
  final String? attachmentUrl;

  bool get isMine => senderRole == 'astrologer';
  bool get isSystem => senderRole == 'system' || type == 'system';

  ChatMessage copyWith({SendStatus? status, DateTime? readAt}) => ChatMessage(
        id: id,
        seq: seq,
        senderRole: senderRole,
        body: body,
        type: type,
        createdAt: createdAt,
        clientId: clientId,
        status: status ?? this.status,
        readAt: readAt ?? this.readAt,
        attachmentUrl: attachmentUrl,
      );

  factory ChatMessage.fromJson(Map<String, dynamic> j) => ChatMessage(
        id: j['id']?.toString() ?? '',
        seq: (j['seq'] as num?)?.toInt() ?? 0,
        senderRole: j['sender_role'] as String? ?? 'system',
        body: j['body'] as String? ?? '',
        type: j['type'] as String? ?? 'text',
        createdAt:
            DateTime.tryParse('${j['created_at'] ?? ''}') ?? DateTime.now(),
        clientId: j['client_message_id'] as String?,
        readAt: DateTime.tryParse('${j['read_at'] ?? ''}'),
        attachmentUrl: (j['attachment'] as Map?)?['url'] as String? ??
            (j['attachments'] is List && (j['attachments'] as List).isNotEmpty
                ? ((j['attachments'] as List).first as Map)['url'] as String?
                : null),
      );
}
