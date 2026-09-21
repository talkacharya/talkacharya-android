import 'package:equatable/equatable.dart';

/// `POST /app|astro/livestreams/{id}/join` (or `/start` for the host) — where the
/// room is and what this participant may do in it.
///
/// The token is minted by Django and only the host's carries publish rights, so a
/// viewer cannot broadcast into someone else's stream even with a valid token.
class LiveJoin extends Equatable {
  const LiveJoin({
    required this.url,
    required this.room,
    required this.token,
    required this.identity,
    required this.role,
    required this.canPublish,
    required this.chatChannel,
    this.viewerCount = 0,
  });

  /// Our media server, e.g. `wss://media.talkacharya.com`.
  final String url;
  final String room;
  final String token;

  /// Who we are inside the room (the user's public id).
  final String identity;

  /// `host` | `viewer`.
  final String role;
  final bool canPublish;

  /// Centrifugo channel carrying chat, viewer counts and gifts (`live:{id}`).
  final String chatChannel;
  final int viewerCount;

  bool get isHost => role == 'host';

  factory LiveJoin.fromJson(Map<String, dynamic> j) => LiveJoin(
    url: '${j['url'] ?? ''}',
    room: '${j['room'] ?? ''}',
    token: '${j['token'] ?? ''}',
    identity: '${j['identity'] ?? ''}',
    role: '${j['role'] ?? 'viewer'}',
    canPublish: j['can_publish'] == true,
    chatChannel: '${j['chat_channel'] ?? ''}',
    viewerCount: (j['viewer_count'] as num?)?.toInt() ?? 0,
  );

  @override
  List<Object?> get props => [url, room, token, identity, role, canPublish];
}
