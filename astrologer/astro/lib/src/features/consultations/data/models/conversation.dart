/// One permanent thread with a customer.
///
/// A consultation is a paid span *inside* a thread. The Chats tab shows one
/// row per customer, not one per session — five readings for the same person
/// are one conversation, which is how the astrologer remembers them.
class Conversation {
  const Conversation({
    required this.id,
    this.customerId = '',
    this.customerName = '',
    this.customerAvatar,
    this.lastMessage,
    this.unread = 0,
    this.window = const SendingWindow(),
    this.lastConsultationId,
    this.pendingConsultationId,
    this.muted = false,
    this.archived = false,
    this.blockedByMe = false,
    this.blockedByThem = false,
  });

  final String id;
  final String customerId;
  final String customerName;
  final String? customerAvatar;
  final MessagePreview? lastMessage;
  final int unread;
  final SendingWindow window;

  /// The session this thread is about: the live one, or the most recent ended
  /// one — which is what the earnings line and the wrap-up belong to.
  final String? lastConsultationId;

  /// A request in this thread not answered yet. The window only knows about
  /// sessions that can take messages, so without this the room could not see
  /// a customer asking while the astrologer is looking at their chat.
  final String? pendingConsultationId;

  /// This user's own settings for the thread. Muted: no push. Archived: listed
  /// under "Archived". Blocked by me: I blocked the other side here, and can
  /// undo it. Blocked by them: the other side did — nothing can be written.
  final bool muted;
  final bool archived;
  final bool blockedByMe;
  final bool blockedByThem;

  bool get blocked => blockedByMe || blockedByThem;

  factory Conversation.fromJson(Map<String, dynamic> j) {
    final peer = (j['peer'] as Map?)?.cast<String, dynamic>() ?? const {};
    final last = (j['last_message'] as Map?)?.cast<String, dynamic>();
    return Conversation(
      id: j['id']?.toString() ?? '',
      customerId: peer['id']?.toString() ?? '',
      customerName: peer['name'] as String? ?? '',
      customerAvatar: peer['avatar'] as String?,
      lastMessage: last == null ? null : MessagePreview.fromJson(last),
      unread: (j['unread'] as num?)?.toInt() ?? 0,
      window: SendingWindow.fromJson(
        (j['window'] as Map?)?.cast<String, dynamic>() ?? const {},
      ),
      lastConsultationId: j['last_consultation'] as String?,
      pendingConsultationId: j['pending_consultation'] as String?,
      muted: j['muted'] == true,
      archived: j['archived'] == true,
      blockedByMe: j['blocked_by_me'] == true,
      blockedByThem: j['blocked_by_them'] == true,
    );
  }

  DateTime? get lastActivity => lastMessage?.createdAt;

  /// A paid session is running in this thread right now.
  bool get isLive => window.isLive;

  /// The same row with new settings — the list keeps its preview and place.
  Conversation withSettings(Conversation u) => Conversation(
    id: id,
    customerId: customerId,
    customerName: customerName,
    customerAvatar: customerAvatar,
    lastMessage: lastMessage,
    unread: unread,
    window: u.window,
    lastConsultationId: lastConsultationId,
    pendingConsultationId: u.pendingConsultationId,
    muted: u.muted,
    archived: u.archived,
    blockedByMe: u.blockedByMe,
    blockedByThem: u.blockedByThem,
  );
}

class MessagePreview {
  const MessagePreview({
    this.seq = 0,
    this.senderRole = '',
    this.body = '',
    this.createdAt,
  });

  final int seq;
  final String senderRole;
  final String body;
  final DateTime? createdAt;

  factory MessagePreview.fromJson(Map<String, dynamic> j) => MessagePreview(
    seq: (j['seq'] as num?)?.toInt() ?? 0,
    senderRole: j['sender_role'] as String? ?? '',
    body: j['body'] as String? ?? '',
    createdAt: DateTime.tryParse('${j['created_at']}'),
  );

  bool get isMine => senderRole == 'astrologer';
}

/// Whether the thread takes messages right now, and why.
class SendingWindow {
  const SendingWindow({
    this.canSend = false,
    this.reason = 'closed',
    this.consultationId,
    this.followUpUntil,
  });

  final bool canSend;

  /// `consultation` — a paid session is live.
  /// `follow_up` — the free window after one ended; replies are unbilled.
  /// `closed` — history only.
  final String reason;

  /// The live consultation, when there is one.
  final String? consultationId;
  final DateTime? followUpUntil;

  factory SendingWindow.fromJson(Map<String, dynamic> j) => SendingWindow(
    canSend: j['can_send'] == true,
    reason: j['reason'] as String? ?? 'closed',
    consultationId: j['consultation'] as String?,
    followUpUntil: DateTime.tryParse('${j['follow_up_until']}'),
  );

  bool get isLive => reason == 'consultation';
  bool get isFollowUp => reason == 'follow_up';
  bool get isClosed => reason == 'closed';

  /// Either side blocked the other; nothing can be written until it is undone.
  bool get isBlocked => reason == 'blocked';
}
