/// Who authored a message / who "I" am in a conversation.
enum ParticipantRole { customer, astrologer, system }

/// Local send lifecycle of a message the current user is sending.
enum SendStatus { sending, sent, failed }

/// Server-confirmed delivery of a message the current user sent.
enum DeliveryState { none, delivered, read }

/// The realtime socket's state, surfaced to the user as a banner.
enum ConnectionStatus { connecting, online, reconnecting, offline }

ParticipantRole roleFromString(String? s) => switch (s) {
  'astrologer' => ParticipantRole.astrologer,
  'system' => ParticipantRole.system,
  _ => ParticipantRole.customer,
};
