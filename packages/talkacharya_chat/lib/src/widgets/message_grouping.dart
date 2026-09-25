import '../models/chat_message.dart';

/// How close together two messages have to be to read as one turn.
const kTurnWindow = Duration(minutes: 3);

/// Whether [b] continues [a] — same sender, same day, moments apart.
///
/// A run of short messages is one person talking, and drawing five identical
/// cards with five timestamps makes a chat look like a log file. System lines
/// and shared-chart cards never join a run: they are the thing you scroll back
/// to find, so they keep their own space.
bool continuesTurn(ChatMessage? a, ChatMessage? b, {Duration window = kTurnWindow}) {
  if (a == null || b == null) return false;
  if (a.isSystem || b.isSystem || a.isKundaliRef || b.isKundaliRef) return false;
  if (a.senderRole != b.senderRole) return false;

  final at = a.createdAt?.toLocal();
  final bt = b.createdAt?.toLocal();
  if (at == null || bt == null) return false;
  if (at.year != bt.year || at.month != bt.month || at.day != bt.day) {
    return false;
  }
  return bt.difference(at).abs() <= window;
}
