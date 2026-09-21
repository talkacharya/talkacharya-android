/// What the wallet is allowed to put in front of a customer.
///
/// `available_balance` is the server's arithmetic — balance minus what live
/// sessions reserve — and it can come back below zero when a reservation
/// outlives its session. "−₹1,472" reads as money stolen, so the figure is
/// floored and the reserved part is named beside it.
library;

import 'package:customr/src/core/l10n/gen/app_localizations.dart';
import 'package:customr/src/features/wallet/data/models/wallet_balance.dart';
import 'package:customr/src/features/wallet/presentation/view/widgets/balance_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

WalletBalance _balance({
  double available = 0,
  double cached = 0,
  double held = 0,
}) => WalletBalance(
  currency: 'INR',
  available: available,
  cached: cached,
  held: held,
);

Future<void> _pumpCard(WidgetTester tester, WalletBalance balance) async {
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: BalanceCard(balance: balance, loading: false),
      ),
    ),
  );
  // CountUpText animates to its target.
  await tester.pump(const Duration(seconds: 2));
}

void main() {
  group('WalletBalance', () {
    test('parses the held amount the API sends', () {
      final b = WalletBalance.fromJson(const {
        'currency': 'INR',
        'cached_balance': '1000.00',
        'available_balance': '920.00',
        'held_amount': '80.00',
      });
      expect(b.cached, 1000);
      expect(b.available, 920);
      expect(b.held, 80);
      expect(b.hasHold, isTrue);
      expect(b.spendable, 920);
      expect(b.overReserved, isFalse);
    });

    test('a negative available never becomes a spendable figure', () {
      final b = _balance(available: -1472, cached: 442888, held: 444360);
      expect(b.spendable, 0);
      expect(b.overReserved, isTrue);
    });

    test('a tiny rounding negative is not called over-reserved', () {
      expect(_balance(available: -0.001).overReserved, isFalse);
    });
  });

  group('BalanceCard', () {
    testWidgets('shows the spendable figure, never a minus', (tester) async {
      await _pumpCard(
        tester,
        _balance(available: -1472, cached: 442888, held: 444360),
      );

      expect(find.textContaining('−'), findsNothing);
      expect(find.textContaining('-1,472'), findsNothing);
      expect(find.textContaining('₹0'), findsOneWidget);
    });

    testWidgets('balance and hold add up in front of the customer', (
      tester,
    ) async {
      await _pumpCard(tester, _balance(available: 920, cached: 1000, held: 80));

      expect(find.textContaining('₹920'), findsOneWidget); // spendable
      final breakdown = find.textContaining('₹1,000');
      expect(breakdown, findsOneWidget);
      expect(
        (tester.widget<Text>(breakdown)).data,
        contains('₹80'), // …and what is reserved
      );
    });

    testWidgets('no hold, no breakdown line', (tester) async {
      await _pumpCard(tester, _balance(available: 1000, cached: 1000));

      expect(find.textContaining('₹1,000'), findsOneWidget);
      expect(find.byIcon(Icons.info_outline_rounded), findsNothing);
    });

    testWidgets('tapping the breakdown explains what a hold is', (
      tester,
    ) async {
      await _pumpCard(tester, _balance(available: 920, cached: 1000, held: 80));

      await tester.tap(find.byIcon(Icons.info_outline_rounded));
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.text('Why is some money on hold?'), findsOneWidget);
    });
  });
}
