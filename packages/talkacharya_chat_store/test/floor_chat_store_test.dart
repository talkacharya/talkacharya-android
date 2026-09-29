import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:talkacharya_chat/talkacharya_chat.dart';
import 'package:talkacharya_chat_store/talkacharya_chat_store.dart';

ChatMessage _m(int seq) => ChatMessage(
  id: 's$seq',
  seq: seq,
  body: 'm$seq',
  senderRole: ParticipantRole.astrologer,
  createdAt: DateTime.utc(2026, 1, 1).add(Duration(minutes: seq)),
);

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  late FloorChatStore store;

  FloorChatStore build({int keep = 1000}) => FloorChatStore(
    keepPerThread: keep,
    open: () => $FloorChatDatabase.inMemoryDatabaseBuilder().build(),
  );

  // sqflite hands back the same in-memory database to every builder, so the
  // isolation has to be explicit.
  setUp(() async {
    store = build();
    await store.clearEverything();
  });

  test('the newest page comes back oldest-first', () async {
    await store.save('t1', [for (var i = 1; i <= 100; i++) _m(i)]);

    final page = await store.newest('t1', limit: 10);

    expect(page.map((m) => m.seq), [91, 92, 93, 94, 95, 96, 97, 98, 99, 100]);
  });

  test('threads do not see each other', () async {
    await store.save('t1', [_m(1), _m(2)]);
    await store.save('t2', [_m(1)]);

    expect((await store.newest('t1')).length, 2);
    expect((await store.newest('t2')).length, 1);
  });

  test('a full unbroken page is served', () async {
    await store.save('t1', [for (var i = 1; i <= 100; i++) _m(i)]);

    final page = await store.before('t1', 51, limit: 10);

    expect(page!.map((m) => m.seq), [41, 42, 43, 44, 45, 46, 47, 48, 49, 50]);
  });

  test('a page with a hole in it is refused', () async {
    // 1..20 and 41..100: everything between is missing.
    await store.save('t1', [
      for (var i = 1; i <= 20; i++) _m(i),
      for (var i = 41; i <= 100; i++) _m(i),
    ]);

    // Asking from 41 would otherwise hand back 20, 19, 18… as if they were
    // the messages just before it.
    expect(await store.before('t1', 41, limit: 10), isNull);
  });

  test('a short page is refused unless it reaches the start', () async {
    await store.save('t1', [for (var i = 41; i <= 100; i++) _m(i)]);

    // Only 5 rows exist below 46, and seq 41 is not the start of the thread.
    expect(await store.before('t1', 46, limit: 10), isNull);
  });

  test('a short page that does reach the start is the truth', () async {
    await store.save('t1', [for (var i = 1; i <= 100; i++) _m(i)]);

    final page = await store.before('t1', 4, limit: 10);

    expect(page!.map((m) => m.seq), [1, 2, 3]);
  });

  test('the very top of a thread is an empty page, not a miss', () async {
    await store.save('t1', [_m(1), _m(2)]);

    expect(await store.before('t1', 1), isEmpty);
  });

  test('an uncached thread answers nothing at all', () async {
    expect(await store.before('t1', 50), isNull);
    expect(await store.newest('t1'), isEmpty);
  });

  test('saving the same message twice replaces it', () async {
    await store.save('t1', [_m(1)]);
    await store.save('t1', [_m(1).copyWith(body: 'edited')]);

    final page = await store.newest('t1');
    expect(page.single.body, 'edited');
  });

  test('a message keeps its content across the round trip', () async {
    await store.save('t1', [
      _m(1).copyWith(
        type: 'image',
        translations: const {'en': 'look'},
        attachments: const [
          ChatAttachment(id: 'a1', url: 'https://cdn/a1', durationSeconds: 7),
        ],
        replyTo: const ChatReplyTo(seq: 0, body: 'earlier'),
      ),
    ]);

    final back = (await store.newest('t1')).single;
    expect(back.type, 'image');
    expect(back.translations['en'], 'look');
    expect(back.attachments.single.url, 'https://cdn/a1');
    expect(back.replyTo?.body, 'earlier');
  });

  test('an unsent message is never cached', () async {
    await store.save('t1', [
      const ChatMessage(id: 'x', seq: 0, clientMessageId: 'c1', body: 'draft'),
    ]);

    expect(await store.newest('t1'), isEmpty);
  });

  test('an outgrown thread is trimmed from the bottom', () async {
    final small = build(keep: 20);
    await small.save('t1', [for (var i = 1; i <= 50; i++) _m(i)]);

    final all = await small.newest('t1', limit: 100);
    expect(all.length, lessThanOrEqualTo(20));
    expect(all.last.seq, 50, reason: 'the newest are what is kept');
    // And the hole the trim left is refused rather than papered over.
    expect(await small.before('t1', all.first.seq), isNull);
  });

  test('clearing a thread leaves the others alone', () async {
    await store.save('t1', [_m(1)]);
    await store.save('t2', [_m(1)]);

    await store.clear('t1');

    expect(await store.newest('t1'), isEmpty);
    expect(await store.newest('t2'), isNotEmpty);
  });

  test('signing out takes everything', () async {
    await store.save('t1', [_m(1)]);
    await store.save('t2', [_m(1)]);

    await store.clearEverything();

    expect(await store.newest('t1'), isEmpty);
    expect(await store.newest('t2'), isEmpty);
  });
}
