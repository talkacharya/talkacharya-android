import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:talkacharya_chat/talkacharya_chat.dart';

class _FakeTransport implements ChatTransport {
  List<ChatMessage> initial = const [];
  bool failSend = false;
  bool failUpload = false;
  final sent = <String>[];
  final translated = <int>[];
  final uploaded = <String>[];
  final reported = <(int, String)>[];
  final pinned = <int>[];
  int? lastReplyToSeq;

  @override
  Future<List<ChatMessage>> history({
    int afterSeq = 0,
    int? beforeSeq,
    int limit = 50,
  }) async {
    if (beforeSeq != null) return const [];
    return initial.where((m) => m.seq > afterSeq).toList();
  }

  @override
  Future<ChatMessage> send({
    String body = '',
    required String clientMessageId,
    List<String> attachmentIds = const [],
    int? replyToSeq,
  }) async {
    if (failSend) throw Exception('offline');
    sent.add(body);
    lastReplyToSeq = replyToSeq;
    return ChatMessage(
      id: 'srv-$clientMessageId',
      seq: 10 + sent.length,
      senderRole: ParticipantRole.customer,
      type: attachmentIds.isEmpty ? 'text' : 'image',
      body: body,
      clientMessageId: clientMessageId,
      replyTo: replyToSeq == null
          ? null
          : ChatReplyTo(seq: replyToSeq, body: 'quoted $replyToSeq'),
      attachments: [
        for (final id in attachmentIds)
          ChatAttachment(id: id, kind: 'image', url: 'https://cdn/$id'),
      ],
    );
  }

  @override
  Future<List<ChatPin>> pins() async => [
    for (final seq in pinned) ChatPin(id: 'p$seq', seq: seq, body: 'pinned $seq'),
  ];

  @override
  Future<void> pin(int seq) async => pinned.add(seq);

  @override
  Future<void> unpin(int seq) async => pinned.remove(seq);

  @override
  Future<void> markRead(int upToSeq) async {}
  @override
  Future<void> markDelivered(int upToSeq) async {}
  @override
  Future<void> sendTyping(bool isTyping) async {}

  @override
  Future<String?> translate(int seq, String target) async {
    translated.add(seq);
    return '[$target] translated';
  }

  @override
  Future<ChatPresence> presence() async =>
      const ChatPresence(otherOnline: true);

  @override
  Future<ChatAttachment> uploadAttachment(String filePath) async {
    if (failUpload) throw Exception('upload failed');
    uploaded.add(filePath);
    return ChatAttachment(
      id: 'att-${uploaded.length}',
      kind: 'image',
      url: 'https://cdn/$filePath',
    );
  }

  @override
  Future<void> reportMessage(int seq, String reason) async {
    reported.add((seq, reason));
  }
}

class _FakeRealtime implements ChatRealtime {
  final _frames = StreamController<Map<String, dynamic>>.broadcast();
  final _conn = StreamController<ConnectionStatus>.broadcast();
  @override
  Stream<Map<String, dynamic>> frames(String channel) => _frames.stream;
  @override
  Stream<ConnectionStatus> get connection => _conn.stream;
  @override
  ConnectionStatus get connectionNow => ConnectionStatus.online;
  final _presenceCtl = StreamController<PresenceEvent>.broadcast();
  final published = <(String, Map<String, dynamic>)>[];

  @override
  Stream<PresenceEvent> presenceEvents(String channel) => _presenceCtl.stream;

  @override
  Future<void> publish(String channel, Map<String, dynamic> data) async {
    published.add((channel, data));
  }

  void emit(Map<String, dynamic> f) => _frames.add(f);
  void emitPresence(PresenceEvent e) => _presenceCtl.add(e);
}

class _Identity implements ChatIdentity {
  _Identity({this.role = ParticipantRole.customer});
  @override
  final ParticipantRole role;
  @override
  String get language => 'en';
  @override
  String get userId => 'u1';
  @override
  bool get canDictate => role == ParticipantRole.astrologer;
}

class _NoTts implements TtsEngine {
  @override
  final speaking = ValueNotifier<bool>(false);
  @override
  Future<void> speak(String text, {required String language}) async {}
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
    required void Function(String, bool) onResult,
  }) async {}
  @override
  Future<void> stop() async {}
  @override
  void dispose() {}
}

ChatController _make(
  _FakeTransport t,
  _FakeRealtime rt, {
  ChatIdentity? id,
  PickImages? pickImages,
  ChatSounds sounds = const NoopChatSounds(),
}) => ChatController(
  consultationId: 'c1',
  transport: t,
  realtime: rt,
  identity: id ?? _Identity(),
  pickImages: pickImages,
  tts: _NoTts(),
  stt: _NoStt(),
  sounds: sounds,
);

class _Sounds implements ChatSounds {
  final played = <String>[];
  @override
  void incoming() => played.add('in');
  @override
  void sent() => played.add('out');
}

void main() {
  test(
    'sounds: sent once, incoming only for new messages from the other side',
    () async {
      final t = _FakeTransport();
      final rt = _FakeRealtime();
      final sounds = _Sounds();
      final c = _make(t, rt, sounds: sounds);
      await c.start();

      await c.sendText('hi');
      expect(sounds.played, ['out']);

      // the server echo of my own message is silent
      final mine = c.state.messages.single;
      rt.emit({
        'type': 'message.new',
        'data': {
          'id': mine.id,
          'seq': mine.seq,
          'sender_role': 'customer',
          'body': 'hi',
          'client_message_id': mine.clientMessageId,
        },
      });
      // a system line is silent
      rt.emit({
        'type': 'message.new',
        'data': {'id': 's1', 'seq': 50, 'sender_role': 'system', 'body': 'x'},
      });
      final theirs = {
        'type': 'message.new',
        'data': {
          'id': 'a1',
          'seq': 51,
          'sender_role': 'astrologer',
          'body': 'ji',
        },
      };
      rt.emit(theirs);
      rt.emit(theirs); // redelivery of the same message is silent
      await Future<void>.delayed(const Duration(milliseconds: 10));
      expect(sounds.played, ['out', 'in']);
      await c.close();
    },
  );

  test('ChatMessage.fromMap reads the backend shape', () {
    final m = ChatMessage.fromMap({
      'id': 'm1',
      'seq': 3,
      'sender_role': 'astrologer',
      'body': 'namaste',
      'source_language': 'hi',
      'translations': {'en': 'greetings'},
      'attachments': [
        {'id': 'a1', 'kind': 'image', 'url': '/x/a1'},
      ],
      'delivered_at': '2026-01-01T00:00:00Z',
    });
    expect(m.senderRole, ParticipantRole.astrologer);
    expect(m.attachments.single.id, 'a1');
    expect(m.deliveredAt, isNotNull);
    expect(m.bodyFor('en', preferTranslation: true), 'greetings');
    expect(m.bodyFor('en', preferTranslation: false), 'namaste');
  });

  test(
    'optimistic send reconciles with the server echo to one message',
    () async {
      final t = _FakeTransport();
      final c = _make(t, _FakeRealtime());
      await c.start();
      await c.sendText('hi');
      expect(c.state.messages.length, 1);
      expect(c.state.messages.single.id, startsWith('srv-'));
      expect(c.state.messages.single.sendStatus, SendStatus.sent);
      await c.close();
    },
  );

  test('failed send marks the bubble failed; reconnect retries it', () async {
    final t = _FakeTransport()..failSend = true;
    final rt = _FakeRealtime();
    final c = _make(t, rt);
    await c.start();
    await c.sendText('hi');
    expect(c.state.messages.single.sendStatus, SendStatus.failed);

    t.failSend = false;
    rt._conn.add(ConnectionStatus.reconnecting);
    rt._conn.add(ConnectionStatus.online);
    await Future<void>.delayed(const Duration(milliseconds: 20));
    expect(t.sent, contains('hi'));
    await c.close();
  });

  test('message.new frame appends; receipt advances my ticks', () async {
    final t = _FakeTransport();
    final rt = _FakeRealtime();
    final c = _make(t, rt);
    await c.start();
    await c.sendText('hello');
    final mySeq = c.state.messages.single.seq;

    rt.emit({
      'type': 'message.receipt',
      'data': {'state': 'read', 'up_to_seq': mySeq, 'by': 'astrologer'},
    });
    await Future<void>.delayed(const Duration(milliseconds: 10));
    expect(c.state.messages.single.readAt, isNotNull);

    rt.emit({
      'type': 'message.new',
      'data': {'id': 'x', 'seq': 99, 'sender_role': 'astrologer', 'body': 'ji'},
    });
    await Future<void>.delayed(const Duration(milliseconds: 10));
    expect(c.state.messages.any((m) => m.body == 'ji'), isTrue);
    await c.close();
  });

  test('only the astrologer identity may dictate', () {
    expect(_Identity(role: ParticipantRole.astrologer).canDictate, isTrue);
    expect(_Identity().canDictate, isFalse);
  });

  test(
    'auto-translate fetches for incoming foreign-language messages',
    () async {
      final t = _FakeTransport()
        ..initial = [
          const ChatMessage(
            id: 'm1',
            seq: 1,
            senderRole: ParticipantRole.astrologer,
            body: 'namaste',
            sourceLanguage: 'hi',
          ),
        ];
      final c = _make(t, _FakeRealtime());
      await c.start();
      await c.setAutoTranslate(true);
      await Future<void>.delayed(const Duration(milliseconds: 10));
      expect(t.translated, contains(1));
      expect(c.state.messages.single.hasTranslationFor('en'), isTrue);
      await c.close();
    },
  );

  test(
    'attachImages: optimistic image bubble → upload → server echo',
    () async {
      final t = _FakeTransport();
      final c = _make(
        t,
        _FakeRealtime(),
        pickImages: (_) async => ['/tmp/a.jpg'],
      );
      await c.start();
      expect(c.canAttachImages, isTrue);

      await c.attachImages(PickSource.gallery);
      // optimistic bubble shows the local file immediately
      final opt = c.state.messages.single;
      expect(opt.type, 'image');
      expect(opt.attachments.single.localPath, '/tmp/a.jpg');

      await Future<void>.delayed(const Duration(milliseconds: 20));
      expect(t.uploaded, ['/tmp/a.jpg']);
      final done = c.state.messages.single;
      expect(done.sendStatus, SendStatus.sent);
      expect(done.attachments.single.url, startsWith('https://cdn/'));
      await c.close();
    },
  );

  test(
    'failed image upload marks the bubble failed; retry re-uploads',
    () async {
      final t = _FakeTransport()..failUpload = true;
      final c = _make(
        t,
        _FakeRealtime(),
        pickImages: (_) async => ['/tmp/b.jpg'],
      );
      await c.start();
      await c.attachImages(PickSource.camera);
      await Future<void>.delayed(const Duration(milliseconds: 20));
      expect(c.state.messages.single.sendStatus, SendStatus.failed);

      t.failUpload = false;
      await c.retry(c.state.messages.single);
      await Future<void>.delayed(const Duration(milliseconds: 20));
      expect(c.state.messages.single.sendStatus, SendStatus.sent);
      await c.close();
    },
  );

  test('reportMessage forwards to the transport', () async {
    final t = _FakeTransport();
    final c = _make(t, _FakeRealtime());
    await c.start();
    await c.reportMessage(7, 'abuse');
    expect(t.reported, [(7, 'abuse')]);
    await c.close();
  });

  test('canAttachImages is false without a picker', () async {
    final c = _make(_FakeTransport(), _FakeRealtime());
    expect(c.canAttachImages, isFalse);
    await c.close();
  });

  test('typing prefers a direct publish while online', () async {
    final rt = _FakeRealtime();
    final t = _FakeTransport();
    final c = _make(t, rt);
    await c.start();
    rt._conn.add(ConnectionStatus.online);
    await Future<void>.delayed(const Duration(milliseconds: 5));

    c.onComposerChanged('h');
    await Future<void>.delayed(const Duration(milliseconds: 5));
    expect(rt.published.single.$1, 'chattyping:c1');
    expect(rt.published.single.$2['is_typing'], true);
  });

  test('a presence join/leave flips the header state', () async {
    final rt = _FakeRealtime();
    final c = _make(_FakeTransport(), rt);
    await c.start();
    rt.emitPresence(const PresenceEvent(userId: 'other', joined: true));
    await Future<void>.delayed(const Duration(milliseconds: 5));
    expect(c.state.presence.otherOnline, isTrue);
    rt.emitPresence(const PresenceEvent(userId: 'other', joined: false));
    await Future<void>.delayed(const Duration(milliseconds: 5));
    expect(c.state.presence.otherOnline, isFalse);
    expect(c.state.presence.otherLastSeen, isNotNull);
    await c.close();
  });

  test('outbox: an unsent message survives a controller restart', () async {
    final box = _MemOutbox();

    // first session: send fails, message is persisted as failed
    final t1 = _FakeTransport()..failSend = true;
    final c1 = ChatController(
      consultationId: 'c1',
      transport: t1,
      realtime: _FakeRealtime(),
      identity: _Identity(),
      outbox: box,
      tts: _NoTts(),
      stt: _NoStt(),
    );
    await c1.start();
    await c1.sendText('did this survive?');
    await Future<void>.delayed(const Duration(milliseconds: 10));
    expect(c1.state.messages.single.sendStatus, SendStatus.failed);
    expect(box.store['c1'], isNotEmpty);
    await c1.close();

    // second session: outbox restores it, and the socket is fine now → it sends
    final t2 = _FakeTransport();
    final c2 = ChatController(
      consultationId: 'c1',
      transport: t2,
      realtime: _FakeRealtime(),
      identity: _Identity(),
      outbox: box,
      tts: _NoTts(),
      stt: _NoStt(),
    );
    await c2.start();
    await Future<void>.delayed(const Duration(milliseconds: 20));
    expect(t2.sent, contains('did this survive?'));
    expect(
      c2.state.messages.any((m) => m.sendStatus == SendStatus.sent),
      isTrue,
    );
    await c2.close();
  });

  test('a reply carries the quote optimistically and clears the composer', () async {
    final t = _FakeTransport();
    final c = _make(t, _FakeRealtime());
    await c.start();
    await c.sendText('what about marriage?');
    final quoted = c.state.messages.last;

    c.replyTo(quoted);
    expect(c.state.replyingTo, quoted);

    await c.sendText('let me look');
    expect(t.lastReplyToSeq, quoted.seq);
    expect(c.state.messages.last.replyTo?.seq, quoted.seq);
    // ...and the composer stops quoting once it has been sent.
    expect(c.state.replyingTo, isNull);

    // The quote is on the bubble straight away, not only once the server
    // answers: with the send failing there is no echo to supply it, and it is
    // still there. Otherwise a reply looks unanchored until the round-trip.
    t.failSend = true;
    c.replyTo(quoted);
    await c.sendText('and one more thing');
    final optimistic = c.state.messages.last;
    expect(optimistic.sendStatus, SendStatus.failed);
    expect(optimistic.replyTo?.body, 'what about marriage?');
  });

  test('pins load on start and follow the other side pinning', () async {
    final t = _FakeTransport()..pinned.add(7);
    final rt = _FakeRealtime();
    final c = _make(t, rt);
    await c.start();
    await Future<void>.delayed(const Duration(milliseconds: 10));
    expect(c.state.pins.single.seq, 7);

    // The astrologer pins something; the customer's room follows without a
    // reload, because a pin is shared between the two of them.
    t.pinned.add(9);
    rt.emit({'type': 'message.pinned', 'data': {'seq': 9}});
    await Future<void>.delayed(const Duration(milliseconds: 10));
    expect(c.state.pins.map((p) => p.seq), containsAll([7, 9]));
  });

  test('unpinning removes it', () async {
    final t = _FakeTransport()..pinned.addAll([3, 4]);
    final c = _make(t, _FakeRealtime());
    await c.start();
    await Future<void>.delayed(const Duration(milliseconds: 10));

    await c.unpin(3);
    expect(c.state.pins.map((p) => p.seq), [4]);
  });

}

class _MemOutbox extends ChatOutbox {
  final store = <String, List<Map<String, dynamic>>>{};

  @override
  Future<List<ChatMessage>> load(String consultationId) async =>
      (store[consultationId] ?? const []).map(ChatOutbox.decode).toList();

  @override
  Future<void> save(String consultationId, List<ChatMessage> unsent) async {
    store[consultationId] = unsent.map(ChatOutbox.encode).toList();
  }
}
