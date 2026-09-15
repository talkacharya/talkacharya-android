import 'dart:async';

import 'package:customr/src/core/util/async_value.dart';
import 'package:customr/src/features/wallet/data/models/recharge_pack.dart';
import 'package:customr/src/features/wallet/data/models/wallet_balance.dart';
import 'package:customr/src/features/wallet/data/wallet_api.dart';
import 'package:customr/src/features/wallet/data/wallet_repository.dart';
import 'package:customr/src/features/wallet/presentation/cubit/wallet_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepo extends Mock implements WalletRepository {}

const _packs = WalletPacks(currency: 'INR', minRecharge: 100);

void main() {
  late _MockRepo repo;

  setUp(() {
    repo = _MockRepo();
    when(
      () => repo.packs(currency: any(named: 'currency')),
    ).thenAnswer((_) async => _packs);
    when(
      () => repo.transactions(
        cursor: any(named: 'cursor'),
        currency: any(named: 'currency'),
      ),
    ).thenAnswer((_) async => const TransactionsPage(items: []));
  });

  test(
    'load fills the balance even when it resolves before its siblings',
    () async {
      // The three loaders run concurrently. If a sibling's emit captured state
      // before its await, a late sibling would overwrite the fresh balance with a
      // stale "loading" snapshot — the bug this pins.
      final balancesDone = Completer<List<WalletBalance>>();
      final txnsDone = Completer<TransactionsPage>();

      when(() => repo.balances()).thenAnswer((_) => balancesDone.future);
      when(
        () => repo.transactions(
          cursor: any(named: 'cursor'),
          currency: any(named: 'currency'),
        ),
      ).thenAnswer((_) => txnsDone.future);

      final cubit = WalletCubit(repo: repo);
      final loaded = cubit.load();

      // Balance lands first…
      balancesDone.complete(const [
        WalletBalance(currency: 'INR', available: 250),
      ]);
      await Future<void>.delayed(Duration.zero);
      // …then the slower sibling.
      txnsDone.complete(const TransactionsPage(items: []));
      await loaded;

      expect(cubit.state.balances.status, AsyncStatus.data);
      expect(cubit.state.balances.value!.single.available, 250);
      await cubit.close();
    },
  );

  test(
    'a failing balance fetch surfaces as error, not a stuck spinner',
    () async {
      when(() => repo.balances()).thenThrow(Exception('boom'));

      final cubit = WalletCubit(repo: repo);
      await cubit.load();

      expect(cubit.state.balances.status, AsyncStatus.error);
      await cubit.close();
    },
  );

  test('concurrent load() calls are de-duped', () async {
    var calls = 0;
    when(() => repo.balances()).thenAnswer((_) async {
      calls++;
      return const [WalletBalance(currency: 'INR', available: 10)];
    });

    final cubit = WalletCubit(repo: repo);
    await Future.wait([cubit.load(), cubit.load()]);

    expect(calls, 1);
    expect(cubit.state.balances.value!.single.available, 10);
    await cubit.close();
  });
}
