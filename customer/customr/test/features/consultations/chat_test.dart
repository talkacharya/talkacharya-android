import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:customr/src/core/realtime/realtime_client.dart';
import 'package:customr/src/features/consultations/data/consultation_api.dart';
import 'package:customr/src/features/consultations/data/consultation_repository.dart';
import 'package:customr/src/features/consultations/data/models/consultation.dart';
import 'package:customr/src/features/consultations/data/models/conversation.dart';
import 'package:customr/src/features/consultations/presentation/cubit/chat_cubit.dart';
import 'package:customr/src/features/consultations/presentation/view/widgets/quick_top_up.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepo extends Mock implements ConsultationRepository {}

class _FakeRealtime extends Fake implements RealtimeClient {
  final frames = StreamController<Map<String, dynamic>>.broadcast();

  @override
  Stream<Map<String, dynamic>> channelFrames(String name) => frames.stream;
}

Consultation _active() => const Consultation(
  id: 'c1',
  status: ConsultationStatus.active,
  astrologerName: 'Ravi',
  rateSnapshot: '20',
  currency: 'INR',
  runwaySeconds: 300,
);

void main() {
  late _MockRepo repo;
  late _FakeRealtime realtime;

  setUp(() {
    repo = _MockRepo();
    realtime = _FakeRealtime();
    // The room resolves its thread first; the live session inside it is what
    // carries the rate and the end button.
    when(() => repo.conversation('c1')).thenAnswer(
      (_) async => const Conversation(
        id: 't1',
        astrologerId: 'a1',
        peerName: 'Ravi',
        window: SendingWindow(
          canSend: true,
          reason: 'consultation',
          consultationId: 'c1',
        ),
        lastConsultationId: 'c1',
      ),
    );
    when(() => repo.detail('c1')).thenAnswer((_) async => _active());
  });

  ChatCubit build() =>
      ChatCubit(repo: repo, realtime: realtime, consultationId: 'c1');

  group('a session asked for from inside the room', () {
    Consultation pending() => const Consultation(
      id: 'c2',
      status: ConsultationStatus.requested,
      astrologerId: 'a1',
      astrologerName: 'Ravi',
      rateSnapshot: '20',
      currency: 'INR',
    );

    /// The thread as it reads between sessions: nothing live, so the sending
    /// window knows nothing about a request that has only been made.
    Conversation closed() => const Conversation(
      id: 't1',
      astrologerId: 'a1',
      peerName: 'Ravi',
      window: SendingWindow(reason: 'closed'),
      lastConsultationId: 'c1',
    );

    blocTest<ChatCubit, ChatState>(
      'is taken on in place rather than opening a second room',
      build: build,
      act: (c) async {
        await c.init();
        c.adopt(pending());
      },
      verify: (c) {
        expect(c.state.consultation?.id, 'c2');
        expect(c.state.status, ConsultationStatus.requested);
        // The thread is untouched — the room is still the same room.
        expect(c.state.conversation?.id, 't1');
      },
    );

    blocTest<ChatCubit, ChatState>(
      'is picked up from the thread channel when it started elsewhere',
      build: build,
      act: (c) async {
        await c.init();
        when(() => repo.detail('c2')).thenAnswer((_) async => pending());
        realtime.frames.add({
          'type': 'consultation.requested',
          'data': {'consultation': 'c2'},
        });
        await Future<void>.delayed(Duration.zero);
      },
      verify: (c) => expect(c.state.consultation?.id, 'c2'),
    );

    blocTest<ChatCubit, ChatState>(
      'cancels the pending session, not the id the room was opened with',
      build: build,
      act: (c) async {
        await c.init();
        c.adopt(pending());
        when(() => repo.cancel(any())).thenAnswer(
          (_) async => pending().copyWith(status: ConsultationStatus.cancelled),
        );
        when(() => repo.conversation('c1')).thenAnswer((_) async => closed());
        await c.cancelRequest();
      },
      verify: (_) {
        // 'c1' is the room's route id and the previous session; cancelling it
        // would withdraw the wrong thing, or nothing at all.
        verify(() => repo.cancel('c2')).called(1);
        verifyNever(() => repo.cancel('c1'));
      },
    );

    blocTest<ChatCubit, ChatState>(
      'puts the room back on the thread once the request is withdrawn',
      build: build,
      act: (c) async {
        await c.init();
        c.adopt(pending());
        when(() => repo.cancel('c2')).thenAnswer(
          (_) async => pending().copyWith(status: ConsultationStatus.cancelled),
        );
        when(() => repo.conversation('c1')).thenAnswer((_) async => closed());
        await c.cancelRequest();
        await Future<void>.delayed(Duration.zero);
      },
      verify: (c) {
        expect(c.state.conversation?.window.isClosed, isTrue);
        expect(c.state.consultation?.id, 'c1', reason: 'the last real session');
      },
    );
  });

  test('Consultation.fromMap parses the room fields', () {
    final c = Consultation.fromMap({
      'id': 'x',
      'status': 'active',
      'astrologer_name': 'Ravi',
      'rate_snapshot': '25.00',
      'currency': 'INR',
      'runway_seconds': 300,
      'unread_count': 2,
      'billed_seconds': 90,
      'gross_amount': '37.50',
    });
    expect(c.status, ConsultationStatus.active);
    expect(c.status.canChat, isTrue);
    expect(c.billedMinutes, 2);
    expect(c.gross, 37.5);
  });

  blocTest<ChatCubit, ChatState>(
    'init loads the thread and the session running inside it',
    build: build,
    act: (c) => c.init(),
    verify: (c) {
      expect(c.state.conversation?.id, 't1');
      expect(c.state.consultation?.astrologerName, 'Ravi');
      expect(c.state.canSend, isTrue);
    },
  );

  blocTest<ChatCubit, ChatState>(
    'a closed thread still opens: history and the last session, no composer',
    build: () {
      when(() => repo.conversation('c1')).thenAnswer(
        (_) async => const Conversation(
          id: 't1',
          astrologerId: 'a1',
          peerName: 'Ravi',
          lastConsultationId: 'c1',
        ),
      );
      return build();
    },
    act: (c) => c.init(),
    verify: (c) {
      expect(c.state.conversation?.id, 't1');
      // the ended session stays loaded — the wrap-up and the rating are its
      expect(c.state.consultation?.id, 'c1');
      expect(c.state.canSend, isFalse);
      expect(c.state.isClosed, isTrue);
    },
  );

  blocTest<ChatCubit, ChatState>(
    'a thread that never had a session opens empty rather than failing',
    build: () {
      when(() => repo.conversation('c1')).thenAnswer(
        (_) async => const Conversation(id: 't1', astrologerId: 'a1'),
      );
      return build();
    },
    act: (c) => c.init(),
    verify: (c) {
      expect(c.state.conversation?.id, 't1');
      expect(c.state.consultation, isNull);
      expect(c.state.error, isNull);
      verifyNever(() => repo.detail(any()));
    },
  );

  blocTest<ChatCubit, ChatState>(
    'endConsultation swaps in the terminal consultation',
    build: () {
      const ended = Consultation(
        id: 'c1',
        status: ConsultationStatus.ended,
        astrologerName: 'Ravi',
        rateSnapshot: '20',
        currency: 'INR',
      );
      when(() => repo.end('c1')).thenAnswer((_) async => ended);
      return build();
    },
    act: (c) async {
      await c.init();
      // What the server says once it has ended: nothing live, the free
      // follow-up open, and the wrap-up pointing at the session just finished.
      when(() => repo.conversation('c1')).thenAnswer(
        (_) async => Conversation(
          id: 't1',
          astrologerId: 'a1',
          peerName: 'Ravi',
          window: SendingWindow(
            canSend: true,
            reason: 'follow_up',
            followUpUntil: DateTime.now().add(const Duration(hours: 24)),
          ),
          lastConsultationId: 'c1',
        ),
      );
      when(() => repo.detail('c1')).thenAnswer(
        (_) async => const Consultation(
          id: 'c1',
          status: ConsultationStatus.ended,
          astrologerName: 'Ravi',
          rateSnapshot: '20',
          currency: 'INR',
        ),
      );
      await c.endConsultation();
      await Future<void>.delayed(Duration.zero);
    },
    verify: (c) {
      expect(c.state.consultation?.status, ConsultationStatus.ended);
      // The composer follows the window, which has moved on to the follow-up.
      expect(c.state.window.isFollowUp, isTrue);
    },
  );

  group('the session the room opens on', () {
    blocTest<ChatCubit, ChatState>(
      'is the ringing call, not the chat that ended before it',
      build: () {
        // The window only counts sessions that take messages, so a call
        // still ringing is invisible to it; the thread names it separately.
        when(() => repo.conversation('c1')).thenAnswer(
          (_) async => const Conversation(
            id: 't1',
            astrologerId: 'a1',
            window: SendingWindow(reason: 'closed'),
            lastConsultationId: 'old',
            pendingConsultationId: 'call',
          ),
        );
        when(() => repo.detail('call')).thenAnswer(
          (_) async => const Consultation(
            id: 'call',
            channel: 'voice',
            status: ConsultationStatus.requested,
            astrologerName: 'Ravi',
          ),
        );
        return build();
      },
      act: (c) => c.init(),
      verify: (c) {
        expect(c.state.consultation?.id, 'call');
        expect(c.state.consultation?.channel, 'voice');
      },
    );
  });

  group('starting again from the thread', () {
    Conversation closed() => const Conversation(
      id: 't1',
      astrologerId: 'a1',
      window: SendingWindow(reason: 'closed'),
      lastConsultationId: 'c1',
    );

    blocTest<ChatCubit, ChatState>(
      'asks for it on the thread and shows it being answered in place',
      build: () {
        when(() => repo.conversation('c1')).thenAnswer((_) async => closed());
        when(() => repo.consultAgain('t1', channel: 'chat')).thenAnswer(
          (_) async => const Consultation(
            id: 'c2',
            status: ConsultationStatus.requested,
            astrologerName: 'Ravi',
          ),
        );
        return build();
      },
      act: (c) async {
        await c.init();
        await c.startAgain();
      },
      verify: (c) {
        // The thread's id, not the one the route carried.
        verify(() => repo.consultAgain('t1', channel: 'chat')).called(1);
        expect(c.state.consultation?.id, 'c2');
        expect(c.state.status, ConsultationStatus.requested);
      },
    );

    blocTest<ChatCubit, ChatState>(
      'lets a short wallet through to the room, which offers the top-up',
      build: () {
        when(() => repo.conversation('c1')).thenAnswer((_) async => closed());
        when(() => repo.consultAgain('t1', channel: 'chat')).thenThrow(
          InsufficientBalance(required: '20', available: '5', currency: 'INR'),
        );
        return build();
      },
      act: (c) async {
        await c.init();
        await expectLater(c.startAgain(), throwsA(isA<InsufficientBalance>()));
      },
      verify: (c) => expect(c.state.consultation?.id, 'c1'),
    );
  });

  blocTest<ChatCubit, ChatState>(
    'rates the session it shows, not the thread id the room was opened with',
    build: () {
      when(() => repo.conversation('t1')).thenAnswer(
        (_) async => const Conversation(
          id: 't1',
          astrologerId: 'a1',
          window: SendingWindow(reason: 'closed'),
          lastConsultationId: 'c1',
        ),
      );
      when(
        () => repo.review(any(), rating: any(named: 'rating')),
      ).thenAnswer((_) async {});
      return ChatCubit(repo: repo, realtime: realtime, consultationId: 't1');
    },
    act: (c) async {
      await c.init();
      await c.submitReview(5);
    },
    verify: (_) =>
        verify(() => repo.review('c1', rating: 5, text: '')).called(1),
  );

  test('a held consultation is shown as held, not as a dead call', () async {
    final cubit = build();
    await cubit.init();
    expect(cubit.state.awaitingPayment, isFalse);

    // Out of money with a recharge in flight: the server holds the line and
    // says until when. Without this the room just goes quiet and the customer
    // hangs up on a call they have already paid to continue.
    realtime.frames.add({
      'type': 'billing.awaiting_payment',
      'data': {
        'until': DateTime.now()
            .add(const Duration(seconds: 120))
            .toIso8601String(),
      },
    });
    await Future<void>.delayed(Duration.zero);
    expect(cubit.state.awaitingPayment, isTrue);

    realtime.frames.add({'type': 'billing.resumed', 'data': {}});
    await Future<void>.delayed(Duration.zero);
    expect(cubit.state.awaitingPayment, isFalse);
    expect(cubit.state.lowBalance, isFalse);
    await cubit.close();
  });

  test('a hold that ran out clears too, so nothing counts down forever', () async {
    final cubit = build();
    await cubit.init();
    realtime.frames.add({
      'type': 'billing.awaiting_payment',
      'data': {'until': DateTime.now().toIso8601String()},
    });
    await Future<void>.delayed(Duration.zero);
    expect(cubit.state.awaitingPayment, isTrue);

    realtime.frames.add({'type': 'billing.payment_grace_expired', 'data': {}});
    await Future<void>.delayed(Duration.zero);
    expect(cubit.state.awaitingPayment, isFalse);
    await cubit.close();
  });

  group('QuickTopUp.amountFor', () {
    test('rounds to an amount a person would pick, never below the minimum', () {
      // ₹25/min for 10 minutes = 250 -> a round 300, not 250.
      expect(QuickTopUp.amountFor(25, 10), 300);
      expect(QuickTopUp.amountFor(25, 25), 700);
      // A cheap astrologer must not produce a sub-minimum top-up.
      expect(QuickTopUp.amountFor(2, 10, minimum: 100), 100);
    });
  });

  test('switching to a call hands back the new session', () async {
    when(() => repo.upgradeChannel('c1', 'voice')).thenAnswer(
      (_) async => const Consultation(
        id: 'c2',
        channel: 'voice',
        status: ConsultationStatus.requested,
        astrologerName: 'Ravi',
        rateSnapshot: '30',
        currency: 'INR',
      ),
    );
    final cubit = build();
    await cubit.init();

    final id = await cubit.upgradeChannel('voice');

    // The new consultation, not the old one: a voice minute is priced as a
    // voice minute, so the room has to follow the new session.
    expect(id, 'c2');
    expect(cubit.state.consultation?.id, 'c2');
    expect(cubit.state.consultation?.channel, 'voice');
    await cubit.close();
  });

  test('a refused switch leaves the chat alone and says why', () async {
    when(
      () => repo.upgradeChannel('c1', 'video'),
    ).thenThrow(Exception('astrologer unavailable'));
    final cubit = build();
    await cubit.init();

    final id = await cubit.upgradeChannel('video');

    expect(id, isNull);
    // Still the chat: the customer must never be left between two sessions.
    expect(cubit.state.consultation?.id, 'c1');
    expect(cubit.state.error, isNotNull);
    await cubit.close();
  });

  test('the runway counts down between server ticks', () async {
    // The server speaks once a minute. A number that only moves then is a
    // receipt, not a warning — by the time it changes it is already too late
    // to do anything about it.
    when(() => repo.detail('c1')).thenAnswer(
      (_) async => const Consultation(
        id: 'c1',
        status: ConsultationStatus.active,
        astrologerName: 'Ravi',
        rateSnapshot: '20',
        currency: 'INR',
        runwaySeconds: 300,
      ),
    );
    final cubit = build();
    await cubit.init();

    realtime.frames.add({
      'type': 'billing.tick',
      'data': {'runway_seconds': 120},
    });
    await Future<void>.delayed(Duration.zero);
    expect(cubit.state.consultation?.runwaySeconds, 120);

    await Future<void>.delayed(const Duration(milliseconds: 2100));
    final now = cubit.state.consultation!.runwaySeconds;
    expect(now, lessThan(120), reason: 'the countdown never started');
    expect(now, greaterThanOrEqualTo(117));

    // A server figure is the truth and overrides whatever we counted to.
    realtime.frames.add({
      'type': 'billing.tick',
      'data': {'runway_seconds': 240},
    });
    await Future<void>.delayed(Duration.zero);
    expect(cubit.state.consultation?.runwaySeconds, 240);
    await cubit.close();
  });

  test('a held consultation does not count down', () async {
    // The meter is off during a payment hold. Counting through it would tell
    // the customer the opposite of the truth.
    final cubit = build();
    await cubit.init();
    realtime.frames.add({
      'type': 'billing.tick',
      'data': {'runway_seconds': 60},
    });
    await Future<void>.delayed(Duration.zero);

    realtime.frames.add({
      'type': 'billing.awaiting_payment',
      'data': {
        'until': DateTime.now().add(const Duration(minutes: 2)).toIso8601String(),
      },
    });
    await Future<void>.delayed(const Duration(milliseconds: 2100));

    expect(cubit.state.consultation?.runwaySeconds, 60);
    await cubit.close();
  });

  test('the room never reports a failure while it is still loading', () async {
    // `loading` used to clear as soon as the thread resolved, so for the whole
    // of the second request the state read "not loading, no consultation" —
    // which the room renders as an error screen, complaining about a request
    // that is still in flight.
    when(() => repo.detail('c1')).thenAnswer((_) async {
      await Future<void>.delayed(const Duration(milliseconds: 60));
      return _active();
    });
    final cubit = build();

    final states = <ChatState>[];
    final sub = cubit.stream.listen(states.add);
    await cubit.init();
    await sub.cancel();

    for (final s in states) {
      if (!s.loading && s.consultation == null && s.error == null) {
        fail('room would have shown a blank failure mid-load');
      }
    }
    expect(cubit.state.consultation?.id, 'c1');
    expect(cubit.state.loading, isFalse);
    await cubit.close();
  });

  test('a session that fails to load says why', () async {
    // It used to be swallowed with a comment claiming the thread still opens.
    // The view has no branch for that, so the customer got a blank failure
    // with nothing to act on.
    when(() => repo.detail('c1')).thenThrow(Exception('offline'));
    final cubit = build();
    await cubit.init();

    expect(cubit.state.consultation, isNull);
    expect(cubit.state.error, isNotNull);
    expect(cubit.state.loading, isFalse);
    await cubit.close();
  });
}
