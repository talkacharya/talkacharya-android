import 'package:floor/floor.dart';

/// One cached message.
///
/// The message itself is kept as the JSON the server sent, rather than a column
/// per field. Two reasons: the chat model gains fields regularly and none of
/// them are ever queried on, so a column each would mean a schema migration for
/// something nothing filters by; and a row decoded from JSON is decoded by
/// exactly the same code as a row off the wire, which is the only way the two
/// can't drift.
///
/// What *is* a column is what a query needs: which thread, and where in it.
@Entity(
  tableName: 'chat_message',
  primaryKeys: ['thread_id', 'seq'],
  indices: [
    Index(name: 'idx_thread_seq', value: ['thread_id', 'seq']),
  ],
)
class MessageRow {
  const MessageRow({
    required this.threadId,
    required this.seq,
    required this.payload,
  });

  @ColumnInfo(name: 'thread_id')
  final String threadId;

  /// Server-assigned and dense within a thread, which is what makes a cached
  /// page checkable for holes rather than merely plausible.
  final int seq;

  final String payload;
}
