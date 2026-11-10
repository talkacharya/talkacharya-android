import 'dart:async';

import 'package:customr/src/core/realtime/realtime_client.dart';
import 'package:customr/src/features/consultations/data/consultation_api.dart';
import 'package:customr/src/features/consultations/data/consultation_repository.dart';
import 'package:customr/src/features/consultations/presentation/cubit/chat_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockApi extends Mock implements ConsultationApi {}

class _FakeRealtime extends Fake implements RealtimeClient {
  final frames = StreamController<Map<String, dynamic>>.broadcast();

  @override
  Stream<Map<String, dynamic>> channelFrames(String name) => frames.stream;
}

Map<String, dynamic> _thread({required bool live}) => {
  'id': 't1',
  'astrologer_id': 'a1',
  'peer': {'name': 'Ravi'},
  'window': live
      ? {'can_send': true, 'reason': 'consultation', 'consultation': 'c2'}
      : {'can_send': false, 'reason': 'closed'},
  'last_consultation': live ? 'c2' : 'c1',
};

Map<String, dynamic> _session(String id, String status) => {
  'id': id,
  'channel': 'chat',
  'status': status,
  'astrologer_name': 'Ravi',
  'rate_snapshot': '20',
  'currency': 'INR',
};

void main() {
  test('a chat started from the room turns the composer on at once, '
      'whatever the repository has cached', () async {
    final api = _MockApi();
    final realtime = _FakeRealtime();
    final repo = ConsultationRepository(api);

    // Before: the thread is closed, the last session ended.
    var live = false;
    when(
      () => api.conversationJson(any()),
    ).thenAnswer((_) async => _thread(live: live));
    when(() => api.conversation(any())).thenAnswer(
      (_) async => throw StateError('the room must not read the cached copy'),
    );
    when(() => api.detailJson(any())).thenAnswer(
      (inv) async => _session(
        inv.positionalArguments.first as String,
        live ? 'active' : 'ended',
      ),
    );

    final cubit = ChatCubit(
      repo: repo,
      realtime: realtime,
      consultationId: 't1',
    );
    await cubit.init();
    expect(cubit.state.canSend, isFalse);

    // The astrologer accepts the chat asked for from inside the room.
    live = true;
    realtime.frames.add({
      'type': 'consultation.started',
      'data': {'consultation': 'c2'},
    });
    await Future<void>.delayed(const Duration(milliseconds: 50));

    expect(cubit.state.consultation?.id, 'c2');
    expect(cubit.state.canSend, isTrue);
    await cubit.close();
  });
}
