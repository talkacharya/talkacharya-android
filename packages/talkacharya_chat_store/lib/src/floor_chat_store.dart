import 'dart:async';
import 'dart:convert';

import 'package:talkacharya_chat/talkacharya_chat.dart';

import 'chat_database.dart';
import 'message_dao.dart';
import 'message_row.dart';

/// The disk half of [ChatStore].
///
/// Opening the database is deferred to the first call and shared from then on,
/// so an app that never opens a chat never pays for it, and one that opens ten
/// rooms opens one database.
class FloorChatStore extends ChatStore {
  FloorChatStore({
    this.name = 'talkacharya_chat.db',
    this.keepPerThread = 1000,
    Future<ChatDatabase> Function()? open,
  }) : _open = open;

  /// The file, under the app's private database directory.
  final String name;

  /// How the database is opened. Overridden in tests to get an in-memory one;
  /// everywhere else this is the file named above.
  final Future<ChatDatabase> Function()? _open;

  /// How much of one thread is worth keeping. Past this the oldest go; the
  /// hole that leaves is refused by [before], so the server answers instead of
  /// the cache inventing continuity it doesn't have.
  final int keepPerThread;

  Future<MessageDao>? _opening;

  Future<MessageDao> _dao() =>
      _opening ??=
          (_open?.call() ?? $FloorChatDatabase.databaseBuilder(name).build())
              .then((db) => db.messageDao);

  @override
  Future<List<ChatMessage>> newest(String threadId, {int limit = 60}) async {
    final rows = await (await _dao()).newest(threadId, limit);
    return _decode(rows.reversed);
  }

  @override
  Future<List<ChatMessage>?> before(
    String threadId,
    int beforeSeq, {
    int limit = 40,
  }) async {
    if (beforeSeq <= 1) return const [];
    final rows = await (await _dao()).before(threadId, beforeSeq, limit);
    if (rows.isEmpty) return null;

    // `seq` is dense and server-assigned, so an unbroken page is provable
    // rather than assumed: row i must be exactly i below the anchor. Anything
    // else means a stretch of the conversation is missing from the middle, and
    // drawing the two ends as neighbours would be a lie about what was said.
    for (var i = 0; i < rows.length; i++) {
      if (rows[i].seq != beforeSeq - 1 - i) return null;
    }
    // A short page is only the truth if it reaches the start of the thread.
    // Otherwise it is simply where this cache happens to stop, and there is
    // more above it that only the server has.
    if (rows.length < limit && rows.last.seq != 1) return null;
    return _decode(rows.reversed);
  }

  @override
  Future<void> save(String threadId, List<ChatMessage> messages) async {
    final rows = [
      for (final m in messages)
        if (m.seq > 0)
          MessageRow(
            threadId: threadId,
            seq: m.seq,
            payload: jsonEncode(m.toMap()),
          ),
    ];
    if (rows.isEmpty) return;
    final dao = await _dao();
    await dao.upsertAll(rows);
    // Only on a batch. Single writes are the live tail — one per message
    // arriving — and counting the thread each time would double the work for
    // a cap that a one-row insert can barely move. A batch means a room just
    // opened or paged, which is the right moment and rare enough to pay for.
    if (rows.length == 1) return;
    final count = await dao.countIn(threadId) ?? 0;
    if (count > keepPerThread) {
      await dao.trim(threadId, keepPerThread);
    }
  }

  @override
  Future<void> clear(String threadId) async =>
      (await _dao()).clearThread(threadId);

  /// Everything, for every thread — what signing out must leave behind.
  Future<void> clearEverything() async => (await _dao()).clearAll();

  List<ChatMessage> _decode(Iterable<MessageRow> rows) {
    final out = <ChatMessage>[];
    for (final row in rows) {
      try {
        out.add(
          ChatMessage.fromMap(jsonDecode(row.payload) as Map<String, dynamic>),
        );
      } catch (_) {
        // A row written by an older build that can no longer be read. Skipping
        // it leaves a hole, which `before` already refuses — so the server
        // fills it in rather than the room showing a gap.
      }
    }
    return out;
  }
}
