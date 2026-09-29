import 'package:floor/floor.dart';

import 'message_row.dart';

@dao
abstract class MessageDao {
  /// Newest-first — the caller reverses. SQLite can only take the top of a
  /// descending index, so asking for the tail this way is the cheap direction.
  @Query(
    'SELECT * FROM chat_message WHERE thread_id = :threadId '
    'ORDER BY seq DESC LIMIT :limit',
  )
  Future<List<MessageRow>> newest(String threadId, int limit);

  @Query(
    'SELECT * FROM chat_message WHERE thread_id = :threadId AND seq < :beforeSeq '
    'ORDER BY seq DESC LIMIT :limit',
  )
  Future<List<MessageRow>> before(String threadId, int beforeSeq, int limit);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> upsertAll(List<MessageRow> rows);

  @Query('DELETE FROM chat_message WHERE thread_id = :threadId')
  Future<void> clearThread(String threadId);

  @Query('DELETE FROM chat_message')
  Future<void> clearAll();

  /// Drops everything below the newest [keep] messages of a thread. The hole
  /// this leaves at the bottom is safe: a page that cannot be proved
  /// contiguous is refused, so the server answers instead.
  @Query(
    'DELETE FROM chat_message WHERE thread_id = :threadId AND seq < ('
    'SELECT MIN(seq) FROM (SELECT seq FROM chat_message '
    'WHERE thread_id = :threadId ORDER BY seq DESC LIMIT :keep))',
  )
  Future<void> trim(String threadId, int keep);

  @Query('SELECT COUNT(*) FROM chat_message WHERE thread_id = :threadId')
  Future<int?> countIn(String threadId);
}
