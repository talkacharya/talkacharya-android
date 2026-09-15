import 'package:equatable/equatable.dart';

/// `POST /consultations/{id}/call/join` — everything needed to place the call.
class CallJoin extends Equatable {
  const CallJoin({
    required this.room,
    required this.signalingChannel,
    required this.role,
    required this.initiator,
    required this.iceServers,
    this.video = false,
    this.peerId = '',
    this.peerName = '',
    this.status = '',
    this.heartbeatSeconds = 10,
    this.reconnectGraceSeconds = 30,
    this.turnAvailable = false,
  });

  final String room;

  /// Participant-only Centrifugo channel (`call:{consultation}`) for SDP / ICE.
  final String signalingChannel;

  /// `customer` | `astrologer`.
  final String role;

  /// True for the side that sends the offer (the customer).
  final bool initiator;

  /// RTCConfiguration `iceServers` — STUN + our TURN with short-lived credentials.
  final List<Map<String, dynamic>> iceServers;
  final bool video;
  final String peerId;
  final String peerName;

  /// Consultation status at join time (`accepted` = ringing, `active` = billing).
  final String status;
  final int heartbeatSeconds;
  final int reconnectGraceSeconds;
  final bool turnAvailable;

  factory CallJoin.fromJson(Map<String, dynamic> j) {
    final peer = (j['peer'] as Map?)?.cast<String, dynamic>() ?? const {};
    return CallJoin(
      room: '${j['room'] ?? ''}',
      signalingChannel: '${j['signaling_channel'] ?? ''}',
      role: '${j['role'] ?? ''}',
      initiator: j['initiator'] == true,
      video: j['video'] == true,
      iceServers: [
        for (final s in (j['ice_servers'] as List? ?? const []))
          if (s is Map) s.cast<String, dynamic>(),
      ],
      peerId: '${peer['id'] ?? ''}',
      peerName: '${peer['name'] ?? ''}',
      status: '${j['status'] ?? ''}',
      heartbeatSeconds: (j['heartbeat_seconds'] as num?)?.toInt() ?? 10,
      reconnectGraceSeconds:
          (j['reconnect_grace_seconds'] as num?)?.toInt() ?? 30,
      turnAvailable: j['turn_available'] == true,
    );
  }

  @override
  List<Object?> get props => [room, signalingChannel, role, initiator];
}
