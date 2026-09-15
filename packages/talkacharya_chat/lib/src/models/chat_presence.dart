/// Snapshot of who is connected to the conversation channel.
class ChatPresence {
  const ChatPresence({this.otherOnline = false, this.otherLastSeen});

  final bool otherOnline;
  final DateTime? otherLastSeen;

  ChatPresence copyWith({bool? otherOnline, DateTime? otherLastSeen}) =>
      ChatPresence(
        otherOnline: otherOnline ?? this.otherOnline,
        otherLastSeen: otherLastSeen ?? this.otherLastSeen,
      );

  factory ChatPresence.fromMap(
    Map<String, dynamic> j, {
    required bool iAmCustomer,
  }) {
    final other = iAmCustomer
        ? j['astrologer_online'] == true
        : j['customer_online'] == true;
    return ChatPresence(otherOnline: other);
  }
}

/// A Centrifugo join/leave on the conv channel.
class PresenceEvent {
  const PresenceEvent({required this.userId, required this.joined});
  final String userId;
  final bool joined;
}
