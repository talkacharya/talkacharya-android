import 'package:equatable/equatable.dart';

import 'live_call.dart';

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
    this.waitingCount = 0,
    this.calls,
    this.hostCalls,
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

  /// Host only: viewers already queued for a private reading.
  final int waitingCount;

  /// Viewer: calling here — prices, the call on air, their own place.
  final LiveViewerCalls? calls;

  /// Host: the call line and a private call's room (a host reopening mid-call).
  final LiveHostCalls? hostCalls;

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
    waitingCount: (j['waiting_count'] as num?)?.toInt() ?? 0,
    calls: j['calls'] is Map
        ? LiveViewerCalls.fromJson((j['calls'] as Map).cast())
        : null,
    hostCalls: j['call_line'] is List
        ? LiveHostCalls.fromJson({
            'line': j['call_line'],
            'media': j['call_media'],
          })
        : null,
  );

  @override
  List<Object?> get props => [url, room, token, identity, role, canPublish];
}
