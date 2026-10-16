import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import 'assistant_models.dart';

/// Where an assistant conversation lives: on the phone.
///
/// The server only carries a message from one phone to the other and drops its
/// copy after a few days, so this is the history. One database per signed-in
/// account, so a phone shared between two logins never mixes their chats.
abstract class AssistantStore {
  /// The newest [limit] messages of [threadId], oldest first.
  Future<List<AssistantMessage>> latest(String threadId, {int limit = 50});

  /// Up to [limit] messages written before [before], oldest first.
  Future<List<AssistantMessage>> before(
    String threadId,
    DateTime before, {
    int limit = 50,
  });

  /// Keeps [messages] (confirmed ones; the same id twice is one row).
  Future<void> save(String threadId, List<AssistantMessage> messages);
}

/// Nothing kept: for tests, and the moment before the database opens.
class MemoryAssistantStore implements AssistantStore {
  final _rows = <String, Map<String, AssistantMessage>>{};

  List<AssistantMessage> _sorted(String threadId) =>
      (_rows[threadId]?.values.toList() ?? [])
        ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

  @override
  Future<List<AssistantMessage>> latest(
    String threadId, {
    int limit = 50,
  }) async {
    final all = _sorted(threadId);
    return all.sublist(all.length > limit ? all.length - limit : 0);
  }

  @override
  Future<List<AssistantMessage>> before(
    String threadId,
    DateTime before, {
    int limit = 50,
  }) async {
    final older = _sorted(
      threadId,
    ).where((m) => m.createdAt.isBefore(before)).toList();
    return older.sublist(older.length > limit ? older.length - limit : 0);
  }

  @override
  Future<void> save(String threadId, List<AssistantMessage> messages) async {
    final rows = _rows.putIfAbsent(threadId, () => {});
    for (final m in messages) {
      if (!m.pending && !m.failed) rows[m.id] = m;
    }
  }
}

/// SQLite on the phone.
class SqliteAssistantStore implements AssistantStore {
  SqliteAssistantStore._(this._db);

  final Database _db;

  static final _open = <String, Future<SqliteAssistantStore>>{};

  /// The store of account [userId], opened once per run.
  static Future<SqliteAssistantStore> forUser(
    String userId, {
    DatabaseFactory? factory,
    String? directory,
  }) => _open.putIfAbsent(userId, () async {
    final f = factory ?? databaseFactory;
    final dir = directory ?? await f.getDatabasesPath();
    final safe = userId.replaceAll(RegExp(r'[^A-Za-z0-9_-]'), '_');
    final db = await f.openDatabase(
      p.join(dir, 'assistant_$safe.db'),
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (db, _) async {
          await db.execute('''
            CREATE TABLE message (
              id TEXT PRIMARY KEY,
              thread_id TEXT NOT NULL,
              sender_role TEXT NOT NULL,
              body TEXT NOT NULL,
              created_at INTEGER NOT NULL
            )
          ''');
          await db.execute(
            'CREATE INDEX message_thread_time ON message (thread_id, created_at)',
          );
        },
      ),
    );
    return SqliteAssistantStore._(db);
  });

  /// Forgets the opened stores (sign-out, tests).
  static void reset() => _open.clear();

  static AssistantMessage _row(Map<String, Object?> r) => AssistantMessage(
    id: '${r['id']}',
    senderRole: '${r['sender_role']}',
    body: '${r['body']}',
    createdAt: DateTime.fromMillisecondsSinceEpoch(
      (r['created_at'] as num?)?.toInt() ?? 0,
    ),
  );

  Future<List<AssistantMessage>> _query(
    String where,
    List<Object?> args,
    int limit,
  ) async {
    final rows = await _db.query(
      'message',
      where: where,
      whereArgs: args,
      orderBy: 'created_at DESC, id DESC',
      limit: limit,
    );
    return rows.map(_row).toList().reversed.toList();
  }

  @override
  Future<List<AssistantMessage>> latest(String threadId, {int limit = 50}) =>
      _query('thread_id = ?', [threadId], limit);

  @override
  Future<List<AssistantMessage>> before(
    String threadId,
    DateTime before, {
    int limit = 50,
  }) => _query('thread_id = ? AND created_at < ?', [
    threadId,
    before.millisecondsSinceEpoch,
  ], limit);

  @override
  Future<void> save(String threadId, List<AssistantMessage> messages) async {
    final keep = messages.where((m) => !m.pending && !m.failed).toList();
    if (keep.isEmpty) return;
    final batch = _db.batch();
    for (final m in keep) {
      batch.insert('message', {
        'id': m.id,
        'thread_id': threadId,
        'sender_role': m.senderRole,
        'body': m.body,
        'created_at': m.createdAt.millisecondsSinceEpoch,
      }, conflictAlgorithm: ConflictAlgorithm.ignore);
    }
    await batch.commit(noResult: true);
  }
}

/// A store that is still opening: calls wait for it. Lets a room be built
/// straight away while the database opens underneath; if it cannot open, the
/// room carries on with what the server sends.
class DeferredAssistantStore implements AssistantStore {
  DeferredAssistantStore(Future<AssistantStore> Function() open)
    : _store = open().catchError((Object _) => MemoryAssistantStore());

  final Future<AssistantStore> _store;

  @override
  Future<List<AssistantMessage>> latest(String threadId, {int limit = 50}) async =>
      (await _store).latest(threadId, limit: limit);

  @override
  Future<List<AssistantMessage>> before(
    String threadId,
    DateTime before, {
    int limit = 50,
  }) async => (await _store).before(threadId, before, limit: limit);

  @override
  Future<void> save(String threadId, List<AssistantMessage> messages) async =>
      (await _store).save(threadId, messages);
}
