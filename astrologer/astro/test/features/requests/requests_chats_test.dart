import 'dart:async';

import 'package:astro/src/core/l10n/l10n.dart';
import 'package:astro/src/core/realtime/realtime_client.dart';
import 'package:astro/src/core/realtime/realtime_event.dart';
import 'package:astro/src/core/theme/brand_colors.dart';
import 'package:astro/src/core/util/time_format.dart';
import 'package:astro/src/features/chats/presentation/cubit/chats_cubit.dart';
import 'package:astro/src/features/consultations/data/consultation_api.dart';
import 'package:astro/src/features/consultations/data/consultation_repository.dart';
import 'package:astro/src/features/consultations/data/models/consultation.dart';
import 'package:astro/src/features/requests/presentation/cubit/requests_cubit.dart';
import 'package:astro/src/features/requests/presentation/view/widgets/request_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mocktail/mocktail.dart';

class _MockApi extends Mock implements ConsultationApi {}

class _MockRealtime extends Mock implements RealtimeClient {}

Consultation _c(
  String id, {
  String status = 'requested',
  String name = 'Asha',
  int unread = 0,
  DateTime? requestedAt,
}) => Consultation.fromJson({
  'id': id,
  'status': status,
  'customer_name': name,
  'unread_count': unread,
  'rate_snapshot': '25.00',
  'requested_at': requestedAt?.toIso8601String(),
});

void main() {
  late _MockApi api;
  late StreamController<RealtimeEvent> events;
  late _MockRealtime realtime;

  setUp(() {
    api = _MockApi();
    events = StreamController<RealtimeEvent>.broadcast();
    realtime = _MockRealtime();
    when(() => realtime.events).thenAnswer((_) => events.stream);
  });

  tearDown(() => events.close());

  group('RequestsCubit', () {
    RequestsCubit build() =>
        RequestsCubit(repo: ConsultationRepository(api), realtime: realtime);

    setUp(() {
      when(() => api.incoming()).thenAnswer((_) async => [_c('r1'), _c('r2')]);
      when(
        () => api.list(status: 'accepted,active'),
      ).thenAnswer((_) async => []);
      when(
        () => api.list(status: 'ended'),
      ).thenAnswer((_) async => [_c('h1', status: 'ended')]);
    });

    test('load splits incoming, active and history', () async {
      final cubit = build();
      await cubit.load();
      expect(cubit.state.loading, isFalse);
      expect(cubit.state.incoming.map((c) => c.id), ['r1', 'r2']);
      expect(cubit.state.history.single.id, 'h1');
      await cubit.close();
    });

    test('accept moves the request into active and clears busy', () async {
      when(
        () => api.accept('r1'),
      ).thenAnswer((_) async => _c('r1', status: 'accepted'));
      final cubit = build();
      await cubit.load();
      final seenBusy = <bool>[];
      final sub = cubit.stream.listen(
        (s) => seenBusy.add(s.busy.contains('r1')),
      );
      final c = await cubit.accept('r1');
      await sub.cancel();
      expect(c?.id, 'r1');
      expect(seenBusy, contains(true));
      expect(cubit.state.busy, isEmpty);
      expect(cubit.state.incoming.map((c) => c.id), ['r2']);
      expect(cubit.state.active.single.id, 'r1');
      await cubit.close();
    });

    test('a failed reject keeps the request and reports an error', () async {
      when(() => api.reject('r1', 'busy')).thenThrow(Exception('409'));
      final cubit = build();
      await cubit.load();
      expect(await cubit.reject('r1', 'busy'), isFalse);
      expect(cubit.state.incoming, hasLength(2));
      expect(cubit.state.error, isNotNull);
      await cubit.close();
    });

    test('RequestRemoved and local expiry drop a request', () async {
      final cubit = build();
      await cubit.load();
      events.add(const RequestRemoved(consultationId: 'r1', reason: 'expired'));
      await Future<void>.delayed(Duration.zero);
      cubit.expireLocally('r2');
      expect(cubit.state.incoming, isEmpty);
      await cubit.close();
    });
  });

  group('ChatsCubit', () {
    ChatsCubit build() => ChatsCubit(api: api, realtime: realtime);

    setUp(() {
      when(() => api.list(status: ChatsCubit.statuses)).thenAnswer(
        (_) async => [
          _c('a', status: 'active', name: 'Ravi', unread: 2),
          _c('b', status: 'accepted', name: 'Meena', unread: 1),
          _c('c', status: 'ended', name: 'Ravi Kumar', unread: 5),
        ],
      );
    });

    test('splits live / recent and counts unread on live only', () async {
      final cubit = build();
      await cubit.load();
      expect(cubit.state.live.map((c) => c.id), ['a', 'b']);
      expect(cubit.state.recent.map((c) => c.id), ['c']);
      expect(cubit.state.totalUnread, 3);
      await cubit.close();
    });

    test('search filters by customer name, case-insensitively', () async {
      final cubit = build();
      await cubit.load();
      cubit.search('  ravi ');
      expect(cubit.state.live.map((c) => c.id), ['a']);
      expect(cubit.state.recent.map((c) => c.id), ['c']);
      // The badge ignores the search filter.
      expect(cubit.state.totalUnread, 3);
      await cubit.close();
    });

    test('a chat message nudge reloads (coalesced)', () async {
      final cubit = build();
      await cubit.load();
      clearInteractions(api);
      events
        ..add(const NewChatMessage(consultationId: 'a', preview: 'hi'))
        ..add(const NewChatMessage(consultationId: 'a', preview: 'there'));
      await Future<void>.delayed(const Duration(milliseconds: 700));
      verify(() => api.list(status: ChatsCubit.statuses)).called(1);
      await cubit.close();
    });
  });

  group('TimeFormat', () {
    final l = lookupAppLocalizations(const Locale('en'));
    final now = DateTime(2026, 9, 16, 15);

    // In the app, GlobalMaterialLocalizations loads the date symbols.
    setUpAll(() => initializeDateFormatting('en'));

    test('relative', () {
      String r(DateTime at) => TimeFormat.relative(l, at, now: now);
      expect(r(now.subtract(const Duration(seconds: 20))), 'Just now');
      expect(r(now.subtract(const Duration(minutes: 5))), '5m ago');
      expect(r(now.subtract(const Duration(hours: 3))), '3h ago');
      expect(r(DateTime(2026, 9, 15, 23)), 'Yesterday');
      expect(r(DateTime(2026, 9, 2, 10)), 'Sep 2');
      expect(TimeFormat.relative(l, null, now: now), '');
    });

    test('day', () {
      expect(TimeFormat.day(l, DateTime(2026, 9, 16, 1), now: now), 'Today');
      expect(
        TimeFormat.day(l, DateTime(2026, 9, 15, 1), now: now),
        'Yesterday',
      );
    });
  });

  group('IncomingRequestCard', () {
    Future<void> pump(
      WidgetTester tester,
      Consultation c, {
      VoidCallback? onExpired,
      VoidCallback? onAccept,
    }) => tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(extensions: const [BrandColors.light]),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: IncomingRequestCard(
            consultation: c,
            busy: false,
            onAccept: onAccept ?? () {},
            onDecline: () {},
            onTap: () {},
            onExpired: onExpired ?? () {},
          ),
        ),
      ),
    );

    testWidgets('shows who, rate and the countdown; accept fires', (
      tester,
    ) async {
      var accepted = false;
      await pump(
        tester,
        _c('r1', requestedAt: DateTime.now()),
        onAccept: () => accepted = true,
      );
      expect(find.text('Asha'), findsOneWidget);
      expect(find.text('₹25/min'), findsOneWidget);
      expect(find.textContaining('Expires in'), findsOneWidget);
      await tester.tap(find.text('Accept'));
      expect(accepted, isTrue);
    });

    testWidgets('fires onExpired once the window has passed', (tester) async {
      var expired = 0;
      await pump(
        tester,
        _c(
          'r1',
          requestedAt: DateTime.now().subtract(const Duration(seconds: 120)),
        ),
        onExpired: () => expired++,
      );
      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(seconds: 3));
      expect(expired, 1);
      expect(find.text('Expired'), findsOneWidget);
    });
  });
}
