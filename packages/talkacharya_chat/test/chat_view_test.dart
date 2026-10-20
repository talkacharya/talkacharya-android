import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:talkacharya_chat/talkacharya_chat.dart';

/// Frames for a while — the room has animations that never stop (the
/// composer), so "settled" never comes.
Future<void> settle(WidgetTester tester) async {
  for (var i = 0; i < 12; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

/// Unmount, close, and let the controller's timers run out (fake time).
Future<void> done(WidgetTester tester, ChatController c) async {
  await tester.pumpWidget(const SizedBox());
  unawaited(c.close());
  await tester.pump(const Duration(seconds: 8));
}

/// The room list itself: it must not move under the reader.
void main() {
  List<ChatMessage> thread(int n) => [
    for (var i = 1; i <= n; i++)
      ChatMessage(
        id: 'm$i',
        seq: i,
        senderRole: i.isEven
            ? ParticipantRole.customer
            : ParticipantRole.astrologer,
        body: 'message number $i',
        createdAt: DateTime(2026, 10, 20, 10, i),
      ),
  ];

  Future<(ChatController, _Realtime)> pumpRoom(
    WidgetTester tester,
    List<ChatMessage> messages,
  ) async {
    final rt = _Realtime();
    final c = ChatController(
      threadId: 'c1',
      transport: _Transport(messages),
      realtime: rt,
      identity: _Me(),
      tts: _NoTts(),
      stt: _NoStt(),
    );
    await c.start();
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider.value(
          value: c,
          child: Scaffold(
            appBar: AppBar(title: const ChatHeaderStatus()),
            body: const ChatView(),
          ),
        ),
      ),
    );
    await settle(tester);
    return (c, rt);
  }

  ScrollPosition listPosition(WidgetTester tester) => tester
      .state<ScrollableState>(
        find
            .descendant(
              of: find.byType(ChatView),
              matching: find.byType(Scrollable),
            )
            .first,
      )
      .position;

  testWidgets('"typing…" shows in the header and moves nothing', (
    tester,
  ) async {
    final (c, rt) = await pumpRoom(tester, thread(3));
    final before = tester.getTopLeft(find.text('message number 3'));

    rt.emit({'role': 'astrologer', 'user_id': 'a1', 'is_typing': true});
    await tester.pump();
    await tester.pump();

    expect(find.text('typing…'), findsOneWidget);
    expect(tester.getTopLeft(find.text('message number 3')), before);
    await done(tester, c);
  });

  testWidgets('sending from up the thread brings the reader back down', (
    tester,
  ) async {
    final (c, _) = await pumpRoom(tester, thread(60));
    await tester.drag(find.byType(ChatView), const Offset(0, 900));
    await settle(tester);
    expect(listPosition(tester).pixels, greaterThan(300));

    unawaited(c.sendText('on my way'));
    await settle(tester);

    expect(listPosition(tester).pixels, 0);
    await done(tester, c);
  });

  testWidgets('a jump lands on the message, however far up it is', (
    tester,
  ) async {
    final (c, _) = await pumpRoom(tester, thread(200));
    expect(find.text('message number 20'), findsNothing);

    c.jumpTo(20);
    await settle(tester);

    final target = find.text('message number 20');
    expect(target, findsOneWidget);
    final y = tester.getCenter(target).dy;
    final view = tester.getRect(find.byType(ChatView));
    expect(y, inInclusiveRange(view.top, view.bottom), reason: 'on screen');
    await done(tester, c);
  });

  testWidgets('their message arriving does not pull the reader down', (
    tester,
  ) async {
    final (c, rt) = await pumpRoom(tester, thread(60));
    await tester.drag(find.byType(ChatView), const Offset(0, 900));
    await settle(tester);
    final reading = listPosition(tester).pixels;

    rt.emit({
      'type': 'message.new',
      'data': {
        'id': 'm61',
        'seq': 61,
        'sender_role': 'astrologer',
        'body': 'a new one',
        'created_at': '2026-10-20T11:01:00Z',
      },
    });
    await settle(tester);

    expect(listPosition(tester).pixels, greaterThan(reading - 1));
    await done(tester, c);
  });
}

class _Transport implements ChatTransport {
  _Transport(this.all);
  final List<ChatMessage> all;
  var _sent = 0;

  @override
  Future<List<ChatMessage>> history({
    int afterSeq = 0,
    int? beforeSeq,
    int limit = 50,
  }) async {
    if (beforeSeq != null) return const [];
    return all.where((m) => m.seq > afterSeq).toList();
  }

  @override
  Future<ChatMessage> send({
    String body = '',
    required String clientMessageId,
    List<String> attachmentIds = const [],
    int? replyToSeq,
  }) async {
    _sent++;
    return ChatMessage(
      id: 'sent$_sent',
      seq: 1000 + _sent,
      senderRole: ParticipantRole.customer,
      body: body,
      clientMessageId: clientMessageId,
    );
  }

  @override
  Future<List<ChatMessage>> search(String query) async => const [];
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
  Future<ChatAttachment> uploadAttachment(
    String filePath, {
    int durationSeconds = 0,
  }) async => const ChatAttachment(id: 'a');
  @override
  Future<void> reportMessage(int seq, String reason) async {}
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
  Future<void> publish(String channel, Map<String, dynamic> data) async {}

  void emit(Map<String, dynamic> f) => _frames.add(f);
}

class _Me implements ChatIdentity {
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
