import 'package:equatable/equatable.dart';

/// One line in the stream chat. Arrives either from `GET .../chat` (the backfill a
/// late joiner sees) or as a `chat.message` frame on the Centrifugo channel.
class LiveChatMessage extends Equatable {
  const LiveChatMessage({
    required this.id,
    required this.name,
    required this.text,
    this.userId = '',
    this.imageUrl,
    this.isHost = false,
    this.pinned = false,
    this.at,
  });

  final String id;
  final String userId;
  final String name;
  final String text;

  /// Picture sent with the line, if any. May be a relative `/media/...` path —
  /// the app resolves it against its API origin.
  final String? imageUrl;
  final bool isHost;

  bool get hasImage => (imageUrl ?? '').isNotEmpty;
  final bool pinned;
  final DateTime? at;

  /// Accepts both shapes: the REST backfill calls the id `public_id`, the realtime
  /// frame calls it `id`.
  factory LiveChatMessage.fromJson(Map<String, dynamic> j) => LiveChatMessage(
    id: '${j['id'] ?? j['public_id'] ?? ''}',
    userId: '${j['user'] ?? ''}',
    name: '${j['name'] ?? ''}',
    text: '${j['text'] ?? ''}',
    imageUrl: (j['image_url'] as String?)?.isNotEmpty == true
        ? j['image_url'] as String
        : null,
    isHost: j['is_host'] == true,
    pinned: j['is_pinned'] == true,
    at: DateTime.tryParse('${j['created_at'] ?? ''}')?.toLocal(),
  );

  LiveChatMessage copyWith({bool? pinned}) => LiveChatMessage(
    id: id,
    userId: userId,
    name: name,
    text: text,
    imageUrl: imageUrl,
    isHost: isHost,
    pinned: pinned ?? this.pinned,
    at: at,
  );

  @override
  List<Object?> get props => [id, text, imageUrl, pinned];
}

/// A gift announced on the stream (`gift.received`), shown as a floating banner.
class LiveGiftEvent extends Equatable {
  const LiveGiftEvent({
    required this.id,
    required this.senderName,
    required this.giftSlug,
    required this.giftName,
    this.quantity = 1,
  });

  final String id;
  final String senderName;
  final String giftSlug;
  final String giftName;
  final int quantity;

  factory LiveGiftEvent.fromJson(Map<String, dynamic> j) => LiveGiftEvent(
    id: '${j['id'] ?? DateTime.now().microsecondsSinceEpoch}',
    senderName: '${j['sender_name'] ?? j['name'] ?? ''}',
    giftSlug: '${j['gift'] ?? j['slug'] ?? ''}',
    giftName: '${j['gift_name'] ?? ''}',
    quantity: (j['quantity'] as num?)?.toInt() ?? 1,
  );

  @override
  List<Object?> get props => [id];
}
