// Opens the gift sheet at a small phone size in English and Hindi, walks the
// picker → sent faces, and renders the post-session prompt card. Any RenderFlex
// overflow or build exception fails the test.
import 'package:bloc_test/bloc_test.dart';
import 'package:customr/src/core/config/config_repository.dart';
import 'package:customr/src/core/di/service_locator.dart';
import 'package:customr/src/core/l10n/l10n.dart';
import 'package:customr/src/core/theme/brand_colors.dart';
import 'package:customr/src/core/util/async_value.dart';
import 'package:customr/src/features/gifting/data/gifting_repository.dart';
import 'package:customr/src/features/gifting/data/models/gift.dart';
import 'package:customr/src/features/gifting/presentation/view/gift_sheet.dart';
import 'package:customr/src/features/gifting/presentation/widgets/gift_prompt_card.dart';
import 'package:customr/src/features/wallet/data/models/wallet_balance.dart';
import 'package:customr/src/features/wallet/presentation/cubit/wallet_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockConfig extends Mock implements ConfigRepository {}

class _MockRepo extends Mock implements GiftingRepository {}

class _MockWallet extends MockCubit<WalletState> implements WalletCubit {}

const _gifts = [
  Gift(slug: 'namaste', name: 'Namaste', coins: 5, unitPrices: {'INR': 5}),
  Gift(
    slug: 'rose',
    name: 'Rose',
    category: 'flower',
    coins: 10,
    unitPrices: {'INR': 10},
  ),
  Gift(
    slug: 'diya',
    name: 'Diya',
    category: 'blessing',
    coins: 20,
    unitPrices: {'INR': 20},
  ),
  Gift(
    slug: 'marigold-garland',
    name: 'Marigold Garland',
    category: 'flower',
    coins: 50,
    unitPrices: {'INR': 50},
  ),
  Gift(
    slug: 'silver-coin',
    name: 'Silver Coin',
    category: 'jewelry',
    coins: 100,
    unitPrices: {'INR': 100},
  ),
  Gift(
    slug: 'kalash',
    name: 'Sacred Kalash',
    category: 'blessing',
    coins: 250,
    unitPrices: {'INR': 250},
  ),
  Gift(
    slug: 'gold-crown',
    name: 'Gold Crown',
    category: 'premium',
    coins: 500,
    unitPrices: {'INR': 500},
  ),
  Gift(
    slug: 'cosmic-blessing',
    name: 'Cosmic Blessing',
    category: 'mega',
    coins: 1000,
    unitPrices: {'INR': 1000},
  ),
];

const _target = ProfileGiftTarget(
  astrologerId: 'astro-1',
  astrologerName: 'Acharya Vishwanath Shastri',
  currency: 'INR',
);

void main() {
  late _MockRepo repo;
  late _MockWallet wallet;

  setUpAll(() {
    final config = _MockConfig();
    when(() => config.hapticEnabled).thenReturn(false);
    getIt.registerSingleton<ConfigRepository>(config);
    registerFallbackValue(_gifts.first);
    registerFallbackValue(_target);
  });

  setUp(() {
    repo = _MockRepo();
    wallet = _MockWallet();
    if (getIt.isRegistered<GiftingRepository>()) {
      getIt.unregister<GiftingRepository>();
    }
    getIt.registerSingleton<GiftingRepository>(repo);
    when(() => repo.catalog()).thenAnswer((_) async => _gifts);
    when(() => wallet.state).thenReturn(
      const WalletState(
        balances: AsyncValue.data([
          WalletBalance(currency: 'INR', available: 1240),
        ]),
      ),
    );
    when(() => wallet.refreshBalance()).thenAnswer((_) async {});
  });

  Widget app(Widget child, Locale locale) => BlocProvider<WalletCubit>.value(
    value: wallet,
    child: MaterialApp(
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFFEA6A1E),
        extensions: const [BrandColors.light],
      ),
      home: Scaffold(body: child),
    ),
  );

  for (final locale in const [Locale('en'), Locale('hi')]) {
    group('small phone · ${locale.languageCode}', () {
      setUp(() {
        TestWidgetsFlutterBinding.ensureInitialized()
            .platformDispatcher
            .views
            .first
          ..physicalSize = const Size(360, 740) * 3
          ..devicePixelRatio = 3;
      });
      tearDown(() {
        TestWidgetsFlutterBinding.instance.platformDispatcher.views.first
          ..resetPhysicalSize()
          ..resetDevicePixelRatio();
      });

      testWidgets('picker → send → sent face lays out', (tester) async {
        when(
          () => repo.send(
            gift: any(named: 'gift'),
            quantity: any(named: 'quantity'),
            target: any(named: 'target'),
            idempotencyKey: any(named: 'idempotencyKey'),
            message: any(named: 'message'),
          ),
        ).thenAnswer(
          (_) async => const GiftTransaction(
            id: 't1',
            gift: 'rose',
            giftName: 'Rose',
            quantity: 5,
            grossAmount: 50,
          ),
        );

        await tester.pumpWidget(
          app(
            Builder(
              builder: (context) => Center(
                child: TextButton(
                  onPressed: () => showGiftSheet(context, target: _target),
                  child: const Text('open'),
                ),
              ),
            ),
            locale,
          ),
        );
        await tester.tap(find.text('open'));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        expect(find.text('Cosmic Blessing'), findsOneWidget);

        await tester.tap(find.text('×5'));
        await tester.pumpAndSettle();
        await tester.tap(find.byIcon(Icons.card_giftcard_rounded).last);
        await tester.pump();
        await tester.pump(const Duration(seconds: 2));
        expect(tester.takeException(), isNull);
        verify(
          () => repo.send(
            gift: _gifts[1],
            quantity: 5,
            target: _target,
            idempotencyKey: any(named: 'idempotencyKey'),
            message: '',
          ),
        ).called(1);
        verify(() => wallet.refreshBalance()).called(1);
      });

      testWidgets('prompt card lays out', (tester) async {
        await tester.pumpWidget(
          app(
            const Padding(
              padding: EdgeInsets.all(20),
              child: GiftPromptCard(target: _target),
            ),
            locale,
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        expect(find.byType(GiftPromptCard), findsOneWidget);
      });
    });
  }
}
