import 'dart:async';

import 'package:astro/src/core/l10n/l10n.dart';
import 'package:astro/src/core/realtime/realtime_client.dart';
import 'package:astro/src/core/realtime/realtime_event.dart';
import 'package:astro/src/core/router/routes.dart';
import 'package:astro/src/core/util/async_value.dart';
import 'package:astro/src/features/call_history/presentation/view/call_history_page.dart';
import 'package:astro/src/features/consultations/data/consultation_api.dart';
import 'package:astro/src/features/consultations/data/models/consultation.dart';
import 'package:astro/src/features/remedies/data/remedies_api.dart';
import 'package:astro/src/features/remedies/presentation/view/remedies_page.dart';
import 'package:astro/src/features/remedies/presentation/view/suggest_remedy_page.dart';
import 'package:astro/src/features/waitlist/data/waitlist_api.dart';
import 'package:astro/src/features/waitlist/presentation/cubit/waitlist_cubit.dart';
import 'package:astro/src/features/waitlist/presentation/view/waitlist_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:talkacharya_ui/talkacharya_ui.dart';

class _MockWaitlistApi extends Mock implements WaitlistApi {}

class _MockRealtime extends Mock implements RealtimeClient {}

class _MockConsultations extends Mock implements ConsultationApi {}

class _MockRemedies extends Mock implements RemediesApi {}

WaitlistEntry _entry(
  String id, {
  String status = 'waiting',
  int past = 0,
  DateTime? expires,
}) => WaitlistEntry.fromJson({
  'id': id,
  'customer_name': 'Customer $id',
  'channel': 'voice',
  'status': status,
  'position': 1,
  'joined_at': DateTime.now()
      .subtract(const Duration(minutes: 12))
      .toIso8601String(),
  'offer_expires_at': expires?.toIso8601String(),
  'past_sessions': past,
});

Consultation _call(String id, String status, {int seconds = 0}) =>
    Consultation.fromJson({
      'id': id,
      'channel': 'voice',
      'status': status,
      'customer_name': 'Asha $id',
      'billed_seconds': seconds,
      'astrologer_amount': '120.00',
      'currency': 'INR',
      'requested_at': '2026-10-05T10:00:00Z',
      'ended_at': '2026-10-05T10:10:00Z',
    });

Widget _app(Widget home) => MaterialApp(
  theme: ThemeData(extensions: const [BrandColors.light]),
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: home,
);

void main() {
  group('RealtimeEvent', () {
    test('queue.updated carries how many are waiting', () {
      final e = RealtimeEvent.fromFrame({
        'type': 'queue.updated',
        'data': {'waiting': 3},
      });
      expect(e, isA<QueueUpdated>());
      expect((e! as QueueUpdated).waiting, 3);
    });
  });

  group('WaitlistCubit', () {
    late _MockWaitlistApi api;
    late StreamController<RealtimeEvent> events;

    setUp(() {
      api = _MockWaitlistApi();
      events = StreamController<RealtimeEvent>.broadcast();
      when(
        () => api.list(),
      ).thenAnswer((_) async => [_entry('a'), _entry('b')]);
    });

    tearDown(() => events.close());

    WaitlistCubit build() {
      final rt = _MockRealtime();
      when(() => rt.events).thenAnswer((_) => events.stream);
      return WaitlistCubit(api: api, realtime: rt);
    }

    test('load fills the list and the badge count', () async {
      final cubit = build();
      await cubit.load();
      expect(cubit.state.count, 2);
      await cubit.close();
    });

    test('a queue.updated frame reloads it', () async {
      final cubit = build();
      events.add(const QueueUpdated(waiting: 2));
      await Future<void>.delayed(Duration.zero);
      await Future<void>.delayed(Duration.zero);
      verify(() => api.list()).called(1);
      expect(cubit.state.count, 2);
      await cubit.close();
    });

    test('inviting marks the row; removing drops it', () async {
      final expires = DateTime.now().add(const Duration(minutes: 2));
      when(() => api.invite('a')).thenAnswer(
        (_) async => _entry('a', status: 'offered', expires: expires),
      );
      when(() => api.remove('b')).thenAnswer((_) async {});
      final cubit = build();
      await cubit.load();

      expect(await cubit.invite('a'), isNull);
      expect(cubit.state.entries.value!.first.invited, isTrue);

      expect(await cubit.remove('b'), isNull);
      expect(cubit.state.entries.value!.map((e) => e.id), ['a']);
      expect(cubit.state.busy, isEmpty);
      await cubit.close();
    });

    test('a refused invite reports why and leaves the row as it was', () async {
      when(() => api.invite('a')).thenThrow(Exception('already invited'));
      final cubit = build();
      await cubit.load();

      expect(await cubit.invite('a'), isNotNull);
      expect(cubit.state.entries.value!.first.invited, isFalse);
      expect(cubit.state.busy, isEmpty);
      await cubit.close();
    });
  });

  testWidgets('waitlist page tells a regular from a new customer', (
    tester,
  ) async {
    final cubit = _FixedWaitlist(
      WaitlistState(
        entries: AsyncValue.data([
          _entry('a', past: 3),
          _entry(
            'b',
            status: 'offered',
            expires: DateTime.now().add(const Duration(seconds: 90)),
          ),
        ]),
      ),
    );
    await tester.pumpWidget(
      _app(
        BlocProvider<WaitlistCubit>.value(
          value: cubit,
          child: const WaitlistPage(),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 600));

    expect(find.text('Customer a'), findsOneWidget);
    expect(find.textContaining('3 sessions with you'), findsOneWidget);
    expect(find.textContaining('New customer'), findsOneWidget);
    expect(find.textContaining('Waiting 12m'), findsOneWidget);
    expect(find.textContaining('Invited · 1:'), findsOneWidget);
    // Only the customer still waiting can be called in.
    expect(find.text('Call in'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  group('call history', () {
    final calls = [
      _call('1', 'ended', seconds: 600),
      _call('2', 'expired'),
      _call('3', 'rejected'),
      _call('4', 'cancelled'),
      _call('5', 'active'),
    ];

    test('filters split completed from missed, and skip live calls', () {
      expect(filterCalls(calls, CallFilter.all).map((c) => c.id), [
        '1',
        '2',
        '3',
        '4',
      ]);
      expect(filterCalls(calls, CallFilter.completed).map((c) => c.id), ['1']);
      expect(filterCalls(calls, CallFilter.missed).map((c) => c.id), [
        '2',
        '3',
      ]);
    });

    testWidgets('page asks for calls only and summarises them', (tester) async {
      final api = _MockConsultations();
      when(
        () => api.list(channel: 'voice,video'),
      ).thenAnswer((_) async => calls);
      GetIt.I.registerSingleton<ConsultationApi>(api);
      addTearDown(GetIt.I.reset);

      await tester.pumpWidget(_app(const CallHistoryPage()));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));

      verify(() => api.list(channel: 'voice,video')).called(1);
      expect(find.text('10m 0s'), findsOneWidget); // talk time
      expect(find.text('Asha 1'), findsOneWidget);
      expect(find.text('Asha 5'), findsNothing); // still in progress

      await tester.tap(find.widgetWithText(ChoiceChip, 'Missed'));
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('Asha 1'), findsNothing);
      expect(find.text('Asha 2'), findsOneWidget);
      expect(find.text('Asha 3'), findsOneWidget);
    });
  });

  group('remedies', () {
    test('suggestion and product parse', () {
      final s = RemedySuggestion.fromJson({
        'id': 'r1',
        'product': {'id': 'p1', 'title': 'Blue Sapphire', 'image': null},
        'customer_name': 'Asha',
        'note': 'Saturday',
        'status': 'purchased',
        'created_at': '2026-10-05T10:00:00Z',
        'commission_percent': '10',
      });
      expect(s.productTitle, 'Blue Sapphire');
      expect(s.purchased, isTrue);
      expect(s.commissionPercent, 10);

      final p = RemedyProduct.fromJson({
        'id': 'p1',
        'title': 'Rudraksha',
        'price_from': '499.00',
      });
      expect(p.priceFrom, 499);
    });

    test('one row per customer, latest session first', () {
      final sessions = [
        Consultation.fromJson({'id': 'c3', 'customer_name': 'Asha'}),
        Consultation.fromJson({'id': 'c2', 'customer_name': 'Ravi'}),
        Consultation.fromJson({'id': 'c1', 'customer_name': 'asha '}),
      ];
      expect(latestPerCustomer(sessions).map((c) => c.id), ['c3', 'c2']);
    });

    test('opening from a session carries the customer in the route', () {
      final uri = Uri.parse(
        Routes.suggestRemedy(consultation: 'c1', name: 'Asha R'),
      );
      expect(uri.path, '/remedies/suggest');
      expect(uri.queryParameters, {'consultation': 'c1', 'name': 'Asha R'});
      expect(Routes.suggestRemedy(), '/remedies/suggest');
    });

    testWidgets('list shows what became of each suggestion', (tester) async {
      final api = _MockRemedies();
      when(() => api.suggestions()).thenAnswer(
        (_) async => [
          RemedySuggestion.fromJson({
            'id': 'r1',
            'product': {'title': 'Blue Sapphire'},
            'customer_name': 'Asha',
            'status': 'purchased',
            'commission_percent': '10',
          }),
          RemedySuggestion.fromJson({
            'id': 'r2',
            'product': {'title': 'Rudraksha Mala'},
            'customer_name': 'Ravi',
            'status': 'viewed',
            'commission_percent': '10',
          }),
        ],
      );
      GetIt.I.registerSingleton<RemediesApi>(api);
      addTearDown(GetIt.I.reset);

      await tester.pumpWidget(_app(const RemediesPage()));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('2 suggested · 1 bought'), findsOneWidget);
      expect(find.textContaining('You earn 10%'), findsOneWidget);
      expect(find.text('Blue Sapphire'), findsOneWidget);
      expect(find.text('Bought'), findsOneWidget);
      expect(find.text('Seen'), findsOneWidget);
    });

    testWidgets('from a session: pick a product, add a note, send', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 4000);
      tester.view.devicePixelRatio = 2;
      addTearDown(tester.view.reset);
      final api = _MockRemedies();
      when(() => api.products(query: any(named: 'query'))).thenAnswer(
        (_) async => const [
          RemedyProduct(id: 'p1', title: 'Blue Sapphire', priceFrom: 2000),
          RemedyProduct(id: 'p2', title: 'Rudraksha Mala', priceFrom: 499),
        ],
      );
      when(
        () => api.suggest(
          consultationId: any(named: 'consultationId'),
          productId: any(named: 'productId'),
          note: any(named: 'note'),
        ),
      ).thenAnswer(
        (_) async => RemedySuggestion.fromJson({
          'id': 'r1',
          'product': {'title': 'Rudraksha Mala'},
        }),
      );
      GetIt.I.registerSingleton<RemediesApi>(api);
      addTearDown(GetIt.I.reset);

      await tester.pumpWidget(
        _app(
          const SuggestRemedyPage(consultationId: 'c1', customerName: 'Asha'),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('For Asha'), findsOneWidget);
      // The customer is decided, so nobody is asked who it is for.
      expect(find.text('Who is it for?'), findsNothing);

      await tester.tap(find.text('Rudraksha Mala'));
      await tester.pump();
      await tester.enterText(find.byType(TextField).last, 'Wear on Monday');
      await tester.tap(find.text('Send suggestion'));
      await tester.pump();

      verify(
        () => api.suggest(
          consultationId: 'c1',
          productId: 'p2',
          note: 'Wear on Monday',
        ),
      ).called(1);
    });
  });
}

/// A cubit frozen at one state, for widget tests.
class _FixedWaitlist extends Cubit<WaitlistState> implements WaitlistCubit {
  _FixedWaitlist(super.initial);

  @override
  dynamic noSuchMethod(Invocation invocation) => Future<void>.value();
}
