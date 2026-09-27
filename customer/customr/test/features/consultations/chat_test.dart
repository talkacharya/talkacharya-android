import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:customr/src/core/realtime/realtime_client.dart';
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
      when(() => repo.end('c1')).thenAnswer(
        (_) async => const Consultation(
          id: 'c1',
          status: ConsultationStatus.ended,
          astrologerName: 'Ravi',
          rateSnapshot: '20',
          currency: 'INR',
        ),
      );
      return build();
    },
    act: (c) async {
      await c.init();
      await c.endConsultation();
    },
    verify: (c) =>
        expect(c.state.consultation?.status, ConsultationStatus.ended),
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
}
