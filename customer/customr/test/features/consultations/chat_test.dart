import 'package:bloc_test/bloc_test.dart';
import 'package:customr/src/core/realtime/realtime_client.dart';
import 'package:customr/src/features/consultations/data/consultation_repository.dart';
import 'package:customr/src/features/consultations/data/models/consultation.dart';
import 'package:customr/src/features/consultations/presentation/cubit/chat_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepo extends Mock implements ConsultationRepository {}

class _FakeRealtime extends Fake implements RealtimeClient {
  @override
  Stream<Map<String, dynamic>> channelFrames(String name) =>
      const Stream.empty();
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

  setUp(() {
    repo = _MockRepo();
    when(() => repo.detail('c1')).thenAnswer((_) async => _active());
  });

  ChatCubit build() =>
      ChatCubit(repo: repo, realtime: _FakeRealtime(), consultationId: 'c1');

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
    'init loads the consultation detail',
    build: build,
    act: (c) => c.init(),
    verify: (c) => expect(c.state.consultation?.astrologerName, 'Ravi'),
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
}
