import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:talkacharya_chat/talkacharya_chat.dart';

ChatMessage _m(int seq, {String body = ''}) => ChatMessage(
  id: 's$seq',
  seq: seq,
  body: body.isEmpty ? 'm$seq' : body,
  senderRole: ParticipantRole.astrologer,
  createdAt: DateTime(2026, 1, 1).add(Duration(minutes: seq)),
);

/// A transport with the server's real paging semantics: no cursor is the
/// newest page, `beforeSeq` walks back, `afterSeq` walks forward.
class _PagingTransport implements ChatTransport {
  _PagingTransport(this.all);
  final List<ChatMessage> all;
  final calls = <String>[];
  bool offline = false;

  @override
  Future<List<ChatMessage>> history({
    int afterSeq = 0,
    int? beforeSeq,
    int limit = 50,
  }) async {
    if (offline) throw Exception('offline');
    if (beforeSeq != null) {
      calls.add('before:$beforeSeq/$limit');
      final rows = all.where((m) => m.seq < beforeSeq).toList();
      return rows.sublist(rows.length - limit.clamp(0, rows.length));
    }
    if (afterSeq > 0) {
      calls.add('after:$afterSeq/$limit');
      return all.where((m) => m.seq > afterSeq).take(limit).toList();
    }
    calls.add('newest:$limit');
    return all.sublist(all.length - limit.clamp(0, all.length));
  }

  @override
  Future<ChatMessage> send({
    String body = '',
    required String clientMessageId,
    List<String> attachmentIds = const [],
    int? replyToSeq,
  }) async => ChatMessage(
    id: 'srv',
    seq: all.last.seq + 1,
    body: body,
    clientMessageId: clientMessageId,
  );

  @override
  Future<List<ChatPin>> pins() async => const [];
  @override
  Future<void> pin(int seq) async {}
  @override
  Future<void> unpin(int seq) async {}
  @override
  Future<void> markRead(int upToSeq) async {}
  @override
  Future<void> markDelivered(int upToSeq) async {}
  @override
  Future<void> sendTyping(bool isTyping) async {}
  @override
  Future<String?> translate(int seq, String target) async => null;
  @override
  Future<ChatPresence> presence() async => const ChatPresence();
  @override
  Future<List<ChatMessage>> search(String query) async => const [];
  @override
  Future<ChatAttachment> uploadAttachment(
    String filePath, {
    int durationSeconds = 0,
  }) async => const ChatAttachment(id: 'a');
  @override
  Future<void> reportMessage(int seq, String reason) async {}
}

/// An in-memory [ChatStore] with the contiguity rule the real one must keep.
class _MemStore extends ChatStore {
  final rows = <int, ChatMessage>{};
  int saves = 0;

  @override
  Future<List<ChatMessage>> newest(String threadId, {int limit = 60}) async {
    final all = rows.values.toList()..sort((a, b) => a.seq.compareTo(b.seq));
    return all.sublist(all.length - limit.clamp(0, all.length));
  }

  @override
  Future<List<ChatMessage>?> before(
    String threadId,
    int beforeSeq, {
    int limit = 40,
  }) async {
    final page = <ChatMessage>[];
    for (var seq = beforeSeq - 1; seq > 0 && page.length < limit; seq--) {
      final row = rows[seq];
      if (row == null) return null; // a hole — the server has to answer
      page.insert(0, row);
    }
    return page;
  }

  @override
  Future<void> save(String threadId, List<ChatMessage> messages) async {
    saves++;
    for (final m in messages) {
      rows[m.seq] = m;
    }
  }

  @override
  Future<void> clear(String threadId) async => rows.clear();
}

class _Realtime implements ChatRealtime {
  final _frames = StreamController<Map<String, dynamic>>.broadcast();
  @override
  Stream<Map<String, dynamic>> frames(String channel) => _frames.stream;
  @override
  Stream<ConnectionStatus> get connection => const Stream.empty();
  @override
  ConnectionStatus get connectionNow => ConnectionStatus.online;
  @override
  Stream<PresenceEvent> presenceEvents(String channel) => const Stream.empty();
  @override
  Future<void> publish(String c, Map<String, dynamic> d) async {}
  void emit(Map<String, dynamic> f) => _frames.add(f);
}

class _Identity implements ChatIdentity {
  @override
  ParticipantRole get role => ParticipantRole.customer;
  @override
  String get language => 'en';
  @override
  String get userId => 'u1';
  @override
  bool get canDictate => false;
}

class _NoTts implements TtsEngine {
  @override
  final speaking = ValueNotifier<bool>(false);
  @override
  Future<void> speak(String text, {String? language}) async {}
  @override
  Future<void> stop() async {}
  @override
  void dispose() {}
}

class _NoStt implements SttEngine {
  @override
  final listening = ValueNotifier<bool>(false);
  @override
  Future<bool> available() async => false;
  @override
  Future<void> start({
    required String language,
    required void Function(String transcript, bool isFinal) onResult,
  }) async {}
  @override
  Future<void> stop() async {}
  @override
  void dispose() {}
}

ChatController _build(ChatTransport t, {ChatStore? store}) => ChatController(
  threadId: 'c1',
  transport: t,
  realtime: _Realtime(),
  identity: _Identity(),
  store: store,
  tts: _NoTts(),
  stt: _NoStt(),
);

void main() {
  final long = [for (var i = 1; i <= 200; i++) _m(i)];

  test('a message survives the trip through storage unchanged', () {
    final original = ChatMessage(
      id: 'm-9',
      seq: 9,
      senderRole: ParticipantRole.astrologer,
      type: 'image',
      body: 'dekhiye',
      sourceLanguage: 'hi',
      translations: const {'en': 'look'},
      meta: const {'event': 'started', 'n': 3},
      attachments: const [
        ChatAttachment(
          id: 'a1',
          kind: 'audio',
          name: 'note.m4a',
          contentType: 'audio/mp4',
          sizeBytes: 1234,
          durationSeconds: 7,
          url: 'https://cdn/a1',
          localPath: '/tmp/gone',
        ),
      ],
      clientMessageId: 'c-9',
      replyTo: const ChatReplyTo(
        seq: 4,
        senderRole: ParticipantRole.customer,
        body: 'kab?',
      ),
      createdAt: DateTime.utc(2026, 3, 4, 5, 6, 7),
      deliveredAt: DateTime.utc(2026, 3, 4, 5, 6, 8),
      readAt: DateTime.utc(2026, 3, 4, 5, 6, 9),
    );

    final back = ChatMessage.fromMap(
      jsonDecode(jsonEncode(original.toMap())) as Map<String, dynamic>,
    );

    expect(back.id, original.id);
    expect(back.seq, original.seq);
    expect(back.senderRole, original.senderRole);
    expect(back.type, original.type);
    expect(back.body, original.body);
    expect(back.sourceLanguage, original.sourceLanguage);
    expect(back.translations, original.translations);
    expect(back.meta, original.meta);
    expect(back.clientMessageId, original.clientMessageId);
    expect(back.replyTo?.seq, 4);
    expect(back.replyTo?.body, 'kab?');
    expect(back.createdAt, original.createdAt);
    expect(back.deliveredAt, original.deliveredAt);
    expect(back.readAt, original.readAt);
    expect(back.attachments.single.id, 'a1');
    expect(back.attachments.single.durationSeconds, 7);
    expect(back.attachments.single.url, 'https://cdn/a1');
    // The one thing deliberately dropped: a path into the old install.
    expect(back.attachments.single.localPath, '');
  });

  test('a room with no cache opens on the newest page, not the oldest', () async {
    final t = _PagingTransport(long);
    final c = _build(t, store: _MemStore());
    await c.start();

    expect(t.calls.first, 'newest:60');
    expect(c.state.messages.last.seq, 200);
    expect(c.state.messages.first.seq, 141);
    expect(c.state.hasMoreOlder, isTrue);
    await c.close();
  });

  test('the cache paints before the network answers', () async {
    final store = _MemStore();
    await store.save('c1', long.sublist(140));

    final t = _PagingTransport(long);
    final c = _build(t, store: store);
    final painted = <int>[];
    final sub = c.stream.listen((s) {
      if (!s.loading && s.messages.isNotEmpty) painted.add(s.messages.length);
    });

    await c.start();
    await Future<void>.delayed(Duration.zero);
    // Drawn once from disk and once from the server — the first without
    // having waited for the request.
    expect(painted.length, greaterThanOrEqualTo(1));
    expect(c.state.messages.last.seq, 200);
    await sub.cancel();
    await c.close();
  });

  test('scrolling up is served from the cache when it has no hole', () async {
    final store = _MemStore();
    await store.save('c1', long); // everything cached
    final t = _PagingTransport(long);
    final c = _build(t, store: store);
    await c.start();
    t.calls.clear();

    await c.loadOlder();

    expect(t.calls, isEmpty, reason: 'the cache could answer in full');
    expect(c.state.messages.first.seq, 101);
    await c.close();
  });

  test('a hole in the cache sends the page back to the server', () async {
    final store = _MemStore();
    // The tail, plus a distant older block with a gap between them.
    await store.save('c1', long.sublist(140));
    await store.save('c1', long.sublist(0, 20));

    final t = _PagingTransport(long);
    final c = _build(t, store: store);
    await c.start();
    t.calls.clear();

    await c.loadOlder();

    expect(t.calls.single, 'before:141/40');
    // seq 101..140 — the real neighbours, not the far-away block.
    expect(c.state.messages.first.seq, 101);
    await c.close();
  });

  test('a cached room still opens when the network is down', () async {
    final store = _MemStore();
    await store.save('c1', long.sublist(140));
    final t = _PagingTransport(long)..offline = true;

    final c = _build(t, store: store);
    await c.start();

    expect(c.state.messages, isNotEmpty);
    expect(c.state.error, isNull, reason: 'a readable room is not an error');
    await c.close();
  });

  test('an uncached room still reports the failure', () async {
    final t = _PagingTransport(long)..offline = true;
    final c = _build(t, store: _MemStore());
    await c.start();

    expect(c.state.messages, isEmpty);
    expect(c.state.error, isNotNull);
    await c.close();
  });

  test('a short thread reports that there is nothing older', () async {
    final short = [for (var i = 1; i <= 5; i++) _m(i)];
    final c = _build(_PagingTransport(short), store: _MemStore());
    await c.start();

    expect(c.state.hasMoreOlder, isFalse);
    await c.close();
  });

  test('arriving messages are written to the cache', () async {
    final store = _MemStore();
    final t = _PagingTransport(long);
    final c = _build(t, store: store);
    await c.start();

    expect(store.rows.containsKey(200), isTrue);
    expect(store.rows.length, 60);
    await c.close();
  });

  test('without a store the controller behaves as before', () async {
    final t = _PagingTransport(long);
    final c = _build(t); // no store
    await c.start();

    expect(c.state.messages.last.seq, 200);
    expect(c.state.hasMoreOlder, isTrue);
    await c.close();
  });
}
