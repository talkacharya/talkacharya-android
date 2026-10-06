/// One permanent thread with an astrologer.
///
/// A consultation is a paid span *inside* a thread. The chats list shows one
/// row per astrologer, not one per session — five readings with the same
/// person are one conversation, the way they are everywhere else.
class Conversation {
  const Conversation({
    required this.id,
    required this.astrologerId,
    this.peerName = '',
    this.peerAvatar,
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
  final String astrologerId;
  final String peerName;
  final String? peerAvatar;
  final MessagePreview? lastMessage;
  final int unread;
  final SendingWindow window;

  /// The session this room is about: the live one, or the most recent ended
  /// one — which is what the wrap-up and the rating belong to once the live
  /// one is gone.
  final String? lastConsultationId;

  /// A request in this thread nobody has answered yet — a chat waiting to be
  /// accepted, a call still ringing. The window only knows about sessions
  /// that can take messages, so without this a room opened on a ringing call
  /// showed the last *ended* chat instead.
  final String? pendingConsultationId;

  /// This user's own settings for the thread. Muted: no push. Archived: listed
  /// under "Archived". Blocked by me: I blocked the other side here, and can
  /// undo it. Blocked by them: the other side did — nothing can be written.
  final bool muted;
  final bool archived;
  final bool blockedByMe;
  final bool blockedByThem;

  bool get blocked => blockedByMe || blockedByThem;

  factory Conversation.fromMap(Map<String, dynamic> j) {
    final peer = (j['peer'] as Map?)?.cast<String, dynamic>() ?? const {};
    final last = (j['last_message'] as Map?)?.cast<String, dynamic>();
    return Conversation(
      id: j['id']?.toString() ?? '',
      astrologerId: j['astrologer_id']?.toString() ?? '',
      peerName: peer['name'] as String? ?? '',
      peerAvatar: peer['avatar'] as String?,
      lastMessage: last == null ? null : MessagePreview.fromMap(last),
      unread: (j['unread'] as num?)?.toInt() ?? 0,
      window: SendingWindow.fromMap(
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

  factory MessagePreview.fromMap(Map<String, dynamic> j) => MessagePreview(
    seq: (j['seq'] as num?)?.toInt() ?? 0,
    senderRole: j['sender_role'] as String? ?? '',
    body: j['body'] as String? ?? '',
    createdAt: DateTime.tryParse('${j['created_at']}'),
  );

  bool get isMine => senderRole == 'customer';
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
  /// `follow_up` — the free window after one ended.
  /// `closed` — history only; start a consultation to write again.
  final String reason;

  /// The live consultation, when there is one.
  final String? consultationId;
  final DateTime? followUpUntil;

  factory SendingWindow.fromMap(Map<String, dynamic> j) => SendingWindow(
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
