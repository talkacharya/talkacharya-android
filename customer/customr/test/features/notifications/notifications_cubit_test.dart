import 'package:bloc_test/bloc_test.dart';
import 'package:customr/src/features/notifications/data/models/app_notification.dart';
import 'package:customr/src/features/notifications/data/notifications_api.dart';
import 'package:customr/src/features/notifications/data/notifications_repository.dart';
import 'package:customr/src/features/notifications/presentation/bloc/notifications_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepo extends Mock implements NotificationsRepository {}

AppNotification _n(String id, {DateTime? readAt}) =>
    AppNotification(id: id, title: 'T$id', body: 'B', readAt: readAt);

void main() {
  late _MockRepo repo;

  setUp(() => repo = _MockRepo());

  blocTest<NotificationsCubit, NotificationsState>(
    'load populates items and unread count',
    build: () {
      when(() => repo.page(cursor: null)).thenAnswer(
        (_) async => NotificationPage(
          items: [
            _n('1'),
            _n('2', readAt: DateTime(2026)),
          ],
          nextCursor: null,
        ),
      );
      return NotificationsCubit(repo);
    },
    act: (c) => c.load(),
    expect: () => [
      isA<NotificationsState>().having(
        (s) => s.status,
        'status',
        NotifStatus.loading,
      ),
      isA<NotificationsState>()
          .having((s) => s.status, 'status', NotifStatus.ready)
          .having((s) => s.items.length, 'items', 2)
          .having((s) => s.unreadCount, 'unread', 1),
    ],
  );

  blocTest<NotificationsCubit, NotificationsState>(
    'markRead flips the row optimistically and calls the repo',
    build: () {
      when(() => repo.page(cursor: null)).thenAnswer(
        (_) async => NotificationPage(items: [_n('1')], nextCursor: null),
      );
      when(() => repo.markRead('1')).thenAnswer((_) async {});
      return NotificationsCubit(repo);
    },
    act: (c) async {
      await c.load();
      await c.markRead('1');
    },
    verify: (c) {
      expect(c.state.unreadCount, 0);
      verify(() => repo.markRead('1')).called(1);
    },
  );

  blocTest<NotificationsCubit, NotificationsState>(
    'bump reloads the first page',
    build: () {
      when(() => repo.page(cursor: null)).thenAnswer(
        (_) async => NotificationPage(items: [_n('1')], nextCursor: null),
      );
      return NotificationsCubit(repo);
    },
    act: (c) => c.bump(),
    verify: (_) => verify(() => repo.page(cursor: null)).called(1),
  );
}
