import 'chat_enums.dart';

/// A message pinned to the top of the consultation. Shared: either side can
/// pin, and both see it — the point is agreeing what matters in the
/// conversation, not keeping a private bookmark.
class ChatPin {
  const ChatPin({
    required this.id,
    required this.seq,
    this.senderRole = ParticipantRole.customer,
    this.type = 'text',
    this.body = '',
  });

  final String id;
  final int seq;
  final ParticipantRole senderRole;
  final String type;
  final String body;

  factory ChatPin.fromMap(Map<String, dynamic> j) => ChatPin(
    id: j['id']?.toString() ?? '',
    seq: (j['seq'] as num?)?.toInt() ?? 0,
    senderRole: roleFromString(j['sender_role'] as String?),
    type: j['type'] as String? ?? 'text',
    body: j['body'] as String? ?? '',
  );
}
