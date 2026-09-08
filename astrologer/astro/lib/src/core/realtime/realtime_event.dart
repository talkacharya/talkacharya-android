/// Typed view of the Centrifugo frames the astrologer app reacts to across
/// `user:`, `astro:`, `conv:` and `call:`. See backend/docs/realtime.md.
///
/// Raw frame shape: `{ "v": 1, "type": "...", "ts": <ms>, "data": {...} }`.
sealed class RealtimeEvent {
  const RealtimeEvent();

  /// Parse a decoded frame. Returns `null` for frame types we ignore.
  static RealtimeEvent? fromFrame(Map<String, dynamic> frame) {
    final type = frame['type'] as String? ?? '';
    final data = (frame['data'] as Map?)?.cast<String, dynamic>() ?? const {};
    switch (type) {
      case 'consultation.requested':
        return ConsultationRequested(
          consultationId: _nested(data, 'consultation', 'id') ??
              data['consultation']?.toString() ??
              '',
          channel: data['channel'] as String? ?? 'chat',
          question: data['question'] as String? ?? '',
        );
      case 'call.ringing':
        return CallRinging(
          consultationId: _nested(data, 'consultation', 'id') ??
              data['consultation']?.toString() ??
              '',
          channel: data['channel'] as String? ?? 'voice',
          agoraChannel: data['agora_channel'] as String?,
        );
      case 'consultation.cancelled':
      case 'consultation.expired':
      case 'consultation.no_show':
        return RequestRemoved(
          consultationId: _nested(data, 'consultation', 'id') ??
              data['consultation']?.toString() ??
              '',
          reason: type.split('.').last,
        );
      case 'consultation.accepted':
      case 'consultation.started':
      case 'consultation.ended':
      case 'consultation.rejected':
        return ConsultationEvent(
          kind: type.split('.').last,
          consultationId: _nested(data, 'consultation', 'id'),
        );
      case 'billing.tick':
        return BillingTick(
          minutesBilled: (data['minutes_billed'] as num?)?.toInt() ?? 0,
          amountCharged: '${data['amount_charged'] ?? ''}',
          runwaySeconds: (data['runway_seconds'] as num?)?.toInt() ?? 0,
        );
      case 'billing.low_balance':
        return LowBalance(
          runwaySeconds: (data['runway_seconds'] as num?)?.toInt() ?? 0,
        );
      case 'gift.received':
        return GiftReceived(
          senderName: data['sender_name'] as String?,
          giftName: _nested(data, 'gift', 'name'),
          animationKey: data['animation_key'] as String?,
        );
      case 'system.reconnect_hint':
        return const ReconnectHint();
      default:
        return const InboxPing();
    }
  }

  static String? _nested(Map<String, dynamic> data, String key, String inner) {
    final obj = data[key];
    if (obj is Map) return obj[inner]?.toString();
    return data['${key}_$inner']?.toString();
  }
}

class ConsultationRequested extends RealtimeEvent {
  const ConsultationRequested({
    required this.consultationId,
    required this.channel,
    required this.question,
  });
  final String consultationId;
  final String channel;
  final String question;
}

class CallRinging extends RealtimeEvent {
  const CallRinging({
    required this.consultationId,
    required this.channel,
    this.agoraChannel,
  });
  final String consultationId;
  final String channel;
  final String? agoraChannel;
}

class RequestRemoved extends RealtimeEvent {
  const RequestRemoved({required this.consultationId, required this.reason});
  final String consultationId;
  final String reason; // cancelled | expired | no_show
}

class ConsultationEvent extends RealtimeEvent {
  const ConsultationEvent({required this.kind, this.consultationId});
  final String kind; // accepted | started | ended | rejected
  final String? consultationId;
}

class BillingTick extends RealtimeEvent {
  const BillingTick({
    required this.minutesBilled,
    required this.amountCharged,
    required this.runwaySeconds,
  });
  final int minutesBilled;
  final String amountCharged;
  final int runwaySeconds;
}

class LowBalance extends RealtimeEvent {
  const LowBalance({required this.runwaySeconds});
  final int runwaySeconds;
}

class GiftReceived extends RealtimeEvent {
  const GiftReceived({this.senderName, this.giftName, this.animationKey});
  final String? senderName;
  final String? giftName;
  final String? animationKey;
}

class InboxPing extends RealtimeEvent {
  const InboxPing();
}

class ReconnectHint extends RealtimeEvent {
  const ReconnectHint();
}
