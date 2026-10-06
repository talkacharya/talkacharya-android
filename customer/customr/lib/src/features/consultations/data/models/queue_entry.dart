import 'package:flutter/foundation.dart';

/// A place in a busy astrologer's waitlist.
///
/// `waiting` until the astrologer is free; then `offered`, which is this
/// customer's turn until [offerExpiresAt] — after that it passes to the next
/// in line.
class QueueEntry {
  const QueueEntry({
    required this.id,
    required this.astrologerId,
    required this.channel,
    required this.status,
    required this.position,
    this.offerExpiresAt,
  });

  factory QueueEntry.fromMap(Map<String, dynamic> m) => QueueEntry(
    id: '${m['id'] ?? ''}',
    astrologerId: '${m['astrologer_id'] ?? ''}',
    channel: '${m['channel'] ?? 'chat'}',
    status: '${m['status'] ?? 'waiting'}',
    position: (m['position'] as num?)?.toInt() ?? 0,
    offerExpiresAt: DateTime.tryParse('${m['offer_expires_at'] ?? ''}'),
  );

  final String id;
  final String astrologerId;
  final String channel; // chat | voice | video
  final String status; // waiting | offered
  final int position;
  final DateTime? offerExpiresAt;

  /// It is this customer's turn, and the turn has not run out.
  bool isTurnAt(DateTime now) =>
      status == 'offered' && (offerExpiresAt?.isAfter(now) ?? false);

  /// The offer ran out: the turn has passed on, so this is no longer a place
  /// in line worth showing.
  bool isLapsedAt(DateTime now) => status == 'offered' && !isTurnAt(now);
}

/// Bumped whenever this customer's waitlist changes from inside the app (they
/// joined or left), so a screen showing it knows to read it again.
final ValueNotifier<int> waitlistChanges = ValueNotifier<int>(0);
