/// Assistant chat payloads, as `/app|astro/assistant/...` returns them.
///
/// Text only, and nothing about delivery or reading — a message is who wrote
/// it, what they wrote and when.
library;

Map<String, dynamic> _map(Object? v) =>
    v is Map ? v.cast<String, dynamic>() : const {};

DateTime? _time(Object? v) =>
    v is String && v.isNotEmpty ? DateTime.tryParse(v)?.toLocal() : null;

class AssistantMessage {
  const AssistantMessage({
    required this.id,
    required this.senderRole,
    required this.body,
    required this.createdAt,
    this.pending = false,
    this.failed = false,
  });

  factory AssistantMessage.fromJson(Map<String, dynamic> j) => AssistantMessage(
    id: '${j['id'] ?? ''}',
    senderRole: '${j['sender_role'] ?? ''}',
    body: '${j['body'] ?? ''}',
    createdAt: _time(j['created_at']) ?? DateTime.now(),
  );

  final String id;

  /// `customer` or `astrologer`.
  final String senderRole;
  final String body;
  final DateTime createdAt;

  /// Only on this phone: written, not yet confirmed by the server.
  final bool pending;

  /// Only on this phone: the send failed; tapping it tries again.
  final bool failed;

  AssistantMessage copyWith({bool? pending, bool? failed}) => AssistantMessage(
    id: id,
    senderRole: senderRole,
    body: body,
    createdAt: createdAt,
    pending: pending ?? this.pending,
    failed: failed ?? this.failed,
  );
}

/// One row of an inbox: who is on the other end and the last thing said.
class AssistantThread {
  const AssistantThread({
    required this.id,
    required this.otherId,
    required this.otherName,
    required this.otherAvatar,
    required this.lastBody,
    required this.lastSenderRole,
    required this.lastAt,
    required this.awaitingYou,
  });

  factory AssistantThread.fromJson(Map<String, dynamic> j) {
    final other = _map(j['other']);
    final last = _map(j['last_message']);
    return AssistantThread(
      id: '${j['id'] ?? ''}',
      otherId: '${other['id'] ?? ''}',
      otherName: '${other['name'] ?? ''}',
      otherAvatar: other['avatar'] as String?,
      lastBody: '${last['body'] ?? ''}',
      lastSenderRole: '${last['sender_role'] ?? ''}',
      lastAt: _time(last['created_at']),
      awaitingYou: j['awaiting_you'] == true,
    );
  }

  final String id;
  final String otherId;
  final String otherName;
  final String? otherAvatar;
  final String lastBody;
  final String lastSenderRole;
  final DateTime? lastAt;

  /// The other side wrote last: this one is waiting on you.
  final bool awaitingYou;
}

/// Why the composer is closed, if it is.
enum AssistantComposerState {
  open,

  /// The customer has sent as many as they may before a reply.
  waitForReply,

  /// One of them blocked the other.
  blocked,

  /// Switched off for everyone.
  disabled;

  static AssistantComposerState parse(Map<String, dynamic> j) {
    if (j['can_send'] == true) return open;
    return switch ('${j['reason'] ?? ''}') {
      'wait_for_reply' => waitForReply,
      'blocked' => blocked,
      _ => disabled,
    };
  }
}

/// `GET assistant/threads/{id}` (and the customer's `POST assistant/threads`).
class AssistantDetail {
  const AssistantDetail({
    required this.thread,
    required this.composer,
    required this.maxLength,
    required this.messages,
  });

  factory AssistantDetail.fromJson(Map<String, dynamic> j) => AssistantDetail(
    thread: AssistantThread.fromJson(j),
    composer: AssistantComposerState.parse(_map(j['composer'])),
    maxLength: (j['max_length'] as num?)?.toInt() ?? 1000,
    messages: [
      for (final m in j['messages'] as List? ?? const [])
        AssistantMessage.fromJson(_map(m)),
    ],
  );

  final AssistantThread thread;
  final AssistantComposerState composer;
  final int maxLength;
  final List<AssistantMessage> messages;
}

/// The `data` of an `assistant.message` realtime frame on the `user:` channel.
class AssistantIncoming {
  const AssistantIncoming({required this.threadId, required this.message});

  static AssistantIncoming? fromFrameData(Map<String, dynamic> data) {
    final thread = '${data['thread'] ?? ''}';
    final message = data['message'];
    if (thread.isEmpty || message is! Map) return null;
    return AssistantIncoming(
      threadId: thread,
      message: AssistantMessage.fromJson(message.cast<String, dynamic>()),
    );
  }

  final String threadId;
  final AssistantMessage message;
}
