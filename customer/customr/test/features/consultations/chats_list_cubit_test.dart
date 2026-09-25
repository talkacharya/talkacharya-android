import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:customr/src/core/realtime/realtime_client.dart';
import 'package:customr/src/core/realtime/realtime_event.dart';
import 'package:customr/src/features/consultations/data/consultation_repository.dart';
import 'package:customr/src/features/consultations/data/models/conversation.dart';
import 'package:customr/src/features/consultations/presentation/cubit/chats_list_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepo extends Mock implements ConsultationRepository {}

class _FakeRealtime extends Fake implements RealtimeClient {
  final _ctl = StreamController<RealtimeEvent>.broadcast();
  @override
  Stream<RealtimeEvent> get events => _ctl.stream;
  void fire(RealtimeEvent e) => _ctl.add(e);
}

/// A thread. `live` means a paid session is running inside it right now;
/// anything else — including one still inside its free follow-up window —
/// belongs under "recent".
Conversation _c(String id, {int unread = 0, String reason = 'consultation'}) =>
    Conversation(
      id: id,
      astrologerId: 'astro-$id',
      peerName: 'Ravi',
      unread: unread,
      window: SendingWindow(
        canSend: reason != 'closed',
        reason: reason,
        consultationId: reason == 'consultation' ? 'c-$id' : null,
      ),
    );

void main() {
  late _MockRepo repo;
  late _FakeRealtime rt;

  setUp(() {
    repo = _MockRepo();
    rt = _FakeRealtime();
  });

  ChatsListCubit build() => ChatsListCubit(repo: repo, realtime: rt);

  blocTest<ChatsListCubit, ChatsListState>(
    'load splits live vs past and sums unread',
    build: () {
      when(() => repo.conversations()).thenAnswer(
        (_) async => [
          _c('a', unread: 2),
          _c('b', reason: 'follow_up'),
        ],
      );
      return build();
    },
    act: (c) => c.load(),
    verify: (c) {
      expect(c.state.live.map((x) => x.id), ['a']);
      expect(c.state.past.map((x) => x.id), ['b']);
      expect(c.state.totalUnread, 2);
    },
  );

  blocTest<ChatsListCubit, ChatsListState>(
    'a NewChatMessage realtime event triggers a reload',
    build: () {
      when(() => repo.conversations()).thenAnswer(
        (_) async => [_c('a', unread: 1)],
      );
      return build();
    },
    act: (c) async {
      await c.load();
      when(() => repo.conversations()).thenAnswer(
        (_) async => [_c('a', unread: 3)],
      );
      rt.fire(
        const NewChatMessage(consultationId: 'a', preview: 'hi', senderRole: 'astrologer'),
      );
      await Future<void>.delayed(const Duration(milliseconds: 800));
    },
    verify: (c) => expect(c.state.totalUnread, 3),
  );
}
