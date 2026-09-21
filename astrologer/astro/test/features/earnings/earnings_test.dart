import 'dart:async';

import 'package:astro/src/core/l10n/l10n.dart';
import 'package:astro/src/core/theme/brand_colors.dart';
import 'package:astro/src/features/earnings/data/earnings_api.dart';
import 'package:astro/src/features/earnings/data/earnings_models.dart';
import 'package:astro/src/features/earnings/presentation/cubit/earnings_cubit.dart';
import 'package:astro/src/features/earnings/presentation/widgets/earnings_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockApi extends Mock implements EarningsApi {}

Map<String, dynamic> _entry(
  String id, {
  String kind = 'consultation',
  String? payout,
  String availableOn = '2020-01-01',
}) => {
  'public_id': id,
  'kind': kind,
  'gross_amount': '100.00',
  'commission_percentage': '20.00',
  'commission_amount': '20.00',
  'net_amount': '80.00',
  'currency': 'INR',
  'available_on': availableOn,
  'consultation': 'c-$id',
  'payout': payout,
  'created_at': '2026-09-15T10:00:00Z',
};

CursorPage<EarningEntry> _page(List<String> ids, {String? next}) =>
    CursorPage([for (final id in ids) EarningEntry.fromJson(_entry(id))], next);

void main() {
  group('models', () {
    test('CursorPage pulls the cursor out of the next URL', () {
      final page = CursorPage.parse({
        'next':
            'https://api.test/api/v1/astro/earnings/entries?cursor=cD0y&kind=gift',
        'previous': null,
        'results': [_entry('e1')],
      }, EarningEntry.fromJson);
      expect(page.items.single.id, 'e1');
      expect(page.nextCursor, 'cD0y');
    });

    test('CursorPage handles the last page and bare lists', () {
      expect(
        CursorPage.parse({
          'next': null,
          'results': [],
        }, EarningEntry.fromJson).nextCursor,
        isNull,
      );
      expect(
        CursorPage.parse([_entry('e1')], EarningEntry.fromJson).items,
        hasLength(1),
      );
    });

    test('EarningEntry parses decimals and clearing state', () {
      final e = EarningEntry.fromJson(_entry('e1', availableOn: '2026-09-20'));
      expect(e.net, 80);
      expect(e.commissionPercent, 20);
      expect(e.isPaidOut, isFalse);
      expect(e.isClearing(DateTime(2026, 9, 16)), isTrue);
      expect(e.isClearing(DateTime(2026, 9, 21)), isFalse);
      expect(
        EarningEntry.fromJson(_entry('e2', payout: 'p1')).isPaidOut,
        isTrue,
      );
    });

    test('Payout detail parses entries and documents', () {
      final p = Payout.fromJson({
        'public_id': 'p1',
        'currency': 'INR',
        'gross': '1000.00',
        'tds_amount': '100.00',
        'other_deductions': '0.00',
        'net_amount': '900.00',
        'period_start': '2026-09-01',
        'period_end': '2026-09-07',
        'status': 'paid',
        'utr': 'UTR123',
        'paid_at': '2026-09-08T09:00:00Z',
        'entry_count': 1,
        'entries': [_entry('e1', payout: 'p1')],
        'documents': [
          {
            'public_id': 'd1',
            'kind': 'tds_certificate',
            'number': 'TDS/1',
            'currency': 'INR',
            'total_amount': '100.00',
            'tax_amount': '100.00',
            'issued_at': '2026-09-08T09:00:00Z',
          },
        ],
      });
      expect(p.net, 900);
      expect(p.tds, 100);
      expect(p.entries.single.payoutId, 'p1');
      expect(p.documents.single.kind, 'tds_certificate');
      expect(p.periodEnd, DateTime(2026, 9, 7));
    });
  });

  group('EarningsCubit', () {
    late _MockApi api;

    setUp(() {
      api = _MockApi();
      when(() => api.summary()).thenAnswer(
        (_) async => {
          'by_currency': [
            {
              'currency': 'INR',
              'available_to_pay': '500',
              'pending_clearance': '80',
              'lifetime_net': '5000',
            },
          ],
        },
      );
      when(
        () => api.entries(
          cursor: any(named: 'cursor'),
          kind: any(named: 'kind'),
        ),
      ).thenAnswer((_) async => _page(['e1', 'e2'], next: 'c2'));
      when(
        () => api.payouts(cursor: any(named: 'cursor')),
      ).thenAnswer((_) async => const CursorPage([], null));
      when(() => api.taxDocuments()).thenAnswer((_) async => []);
    });

    test('load fills every slice', () async {
      final cubit = EarningsCubit(api);
      await cubit.load();
      expect(cubit.state.summary.value?.available, 500);
      expect(cubit.state.ledger.items, hasLength(2));
      expect(cubit.state.ledger.hasMore, isTrue);
      expect(cubit.state.payouts.loading, isFalse);
      expect(cubit.state.documents.value, isEmpty);
      await cubit.close();
    });

    test('loadMoreLedger appends and stops at the last page', () async {
      when(
        () => api.entries(
          cursor: 'c2',
          kind: any(named: 'kind'),
        ),
      ).thenAnswer((_) async => _page(['e3']));
      final cubit = EarningsCubit(api);
      await cubit.load();
      await cubit.loadMoreLedger();
      expect(cubit.state.ledger.items.map((e) => e.id), ['e1', 'e2', 'e3']);
      expect(cubit.state.ledger.hasMore, isFalse);
      await cubit.loadMoreLedger(); // no-op
      verify(
        () => api.entries(
          cursor: 'c2',
          kind: any(named: 'kind'),
        ),
      ).called(1);
      await cubit.close();
    });

    test('a stale filter response is dropped', () async {
      final slowGifts = Completer<CursorPage<EarningEntry>>();
      when(
        () => api.entries(
          cursor: any(named: 'cursor'),
          kind: 'gift',
        ),
      ).thenAnswer((_) => slowGifts.future);
      when(
        () => api.entries(
          cursor: any(named: 'cursor'),
          kind: 'bonus',
        ),
      ).thenAnswer((_) async => _page(['b1']));
      final cubit = EarningsCubit(api);
      final gifts = cubit.setKind('gift');
      await cubit.setKind('bonus');
      slowGifts.complete(_page(['g1']));
      await gifts;
      expect(cubit.state.kind, 'bonus');
      expect(cubit.state.ledger.items.map((e) => e.id), ['b1']);
      await cubit.close();
    });

    test('a failed ledger load flags an error', () async {
      when(
        () => api.entries(
          cursor: any(named: 'cursor'),
          kind: any(named: 'kind'),
        ),
      ).thenThrow(Exception('boom'));
      final cubit = EarningsCubit(api);
      await cubit.load();
      expect(cubit.state.ledger.error, isTrue);
      expect(cubit.state.ledger.loading, isFalse);
      await cubit.close();
    });
  });

  group('widgets', () {
    Future<void> pump(WidgetTester tester, Widget child) => tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(extensions: const [BrandColors.light]),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: child),
      ),
    );

    testWidgets('EarningEntryTile shows net, fee and payout state', (
      tester,
    ) async {
      await pump(
        tester,
        EarningEntryTile(
          entry: EarningEntry.fromJson(_entry('e1', payout: 'p1')),
        ),
      );
      expect(find.text('Consultations'), findsOneWidget);
      expect(find.text('+₹80'), findsOneWidget);
      expect(find.text('20% fee on ₹100'), findsOneWidget);
      expect(find.text('Paid out'), findsOneWidget);
    });

    testWidgets('PayoutCard shows amount and status', (tester) async {
      await pump(
        tester,
        PayoutCard(
          payout: Payout.fromJson({
            'public_id': 'p1',
            'net_amount': '1250.50',
            'status': 'failed',
            'entry_count': 3,
          }),
          onTap: () {},
        ),
      );
      expect(find.text('₹1,250.50'), findsOneWidget);
      expect(find.text('Failed'), findsOneWidget);
      expect(find.textContaining('3 earnings'), findsOneWidget);
    });
  });
}
