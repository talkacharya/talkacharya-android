/// Typed view of the Centrifugo frames the customer shell reacts to on the
/// personal `user:{id}` channel. See backend/docs/realtime.md.
///
/// Raw frame shape: `{ "v": 1, "type": "...", "ts": "<iso>", "data": {...} }`.
sealed class RealtimeEvent {
  const RealtimeEvent();

  /// Parse a decoded frame. Returns `null` for frame types the shell ignores.
  static RealtimeEvent? fromFrame(Map<String, dynamic> frame) {
    final type = frame['type'] as String? ?? '';
    final data = (frame['data'] as Map?)?.cast<String, dynamic>() ?? const {};
    switch (type) {
      case 'wallet.updated':
        return WalletUpdated(
          currency: data['currency'] as String? ?? 'INR',
          availableBalance: '${data['available_balance'] ?? ''}',
        );
      case 'billing.low_balance':
        return LowBalance(
          runwaySeconds: (data['runway_seconds'] as num?)?.toInt() ?? 0,
          rechargeDeeplink: data['recharge_deeplink'] as String?,
        );
      case 'queue.offer':
        return QueueOffer(
          astrologerName: _nested(data, 'astrologer', 'display_name'),
          offerExpiresAt: data['offer_expires_at'] as String?,
        );
      case 'chat.new_message':
        return NewChatMessage(
          consultationId:
              _nested(data, 'consultation', 'id') ??
              data['consultation']?.toString() ??
              '',
          preview: data['preview'] as String? ?? '',
          senderRole: data['sender_role'] as String? ?? '',
        );
      case 'consultation.requested':
      case 'consultation.accepted':
      case 'consultation.started':
      case 'consultation.ended':
        return ConsultationEvent(
          kind: type.split('.').last,
          consultationId: _nested(data, 'consultation', 'id'),
        );
      case 'system.reconnect_hint':
        return const ReconnectHint();
      default:
        // Anything else on `user:` (notifications, activity) → just nudge the inbox.
        return const InboxPing();
    }
  }

  static String? _nested(Map<String, dynamic> data, String key, String inner) {
    final obj = data[key];
    if (obj is Map) return obj[inner]?.toString();
    return data['${key}_$inner']?.toString();
  }
}

class WalletUpdated extends RealtimeEvent {
  const WalletUpdated({required this.currency, required this.availableBalance});
  final String currency;
  final String availableBalance;
}

class LowBalance extends RealtimeEvent {
  const LowBalance({required this.runwaySeconds, this.rechargeDeeplink});
  final int runwaySeconds;
  final String? rechargeDeeplink;
}

class QueueOffer extends RealtimeEvent {
  const QueueOffer({this.astrologerName, this.offerExpiresAt});
  final String? astrologerName;
  final String? offerExpiresAt;
}

class ConsultationEvent extends RealtimeEvent {
  const ConsultationEvent({required this.kind, this.consultationId});
  final String kind; // requested | accepted | started | ended
  final String? consultationId;
}

class NewChatMessage extends RealtimeEvent {
  const NewChatMessage({
    required this.consultationId,
    required this.preview,
    required this.senderRole,
  });
  final String consultationId;
  final String preview;
  final String senderRole;
}

class InboxPing extends RealtimeEvent {
  const InboxPing();
}

class ReconnectHint extends RealtimeEvent {
  const ReconnectHint();
}
