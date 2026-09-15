import 'package:customr/src/features/gifting/data/gifting_api.dart';
import 'package:customr/src/features/gifting/data/gifting_repository.dart';
import 'package:customr/src/features/gifting/data/models/gift.dart';
import 'package:customr/src/features/gifting/presentation/cubit/send_gift_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepo extends Mock implements GiftingRepository {}

const _namaste = Gift(
  slug: 'namaste',
  name: 'Namaste',
  coins: 5,
  unitPrices: {'INR': 5},
);
const _rose = Gift(
  slug: 'rose',
  name: 'Rose',
  category: 'flower',
  coins: 10,
  unitPrices: {'INR': 10},
);
const _target = ProfileGiftTarget(
  astrologerId: 'astro-1',
  astrologerName: 'Pandit Ji',
  currency: 'INR',
);
const _txn = GiftTransaction(
  id: 'txn-1',
  gift: 'rose',
  giftName: 'Rose',
  quantity: 5,
  grossAmount: 50,
);

void main() {
  late _MockRepo repo;
  final keys = <String>[];

  setUpAll(() {
    registerFallbackValue(_rose);
    registerFallbackValue(_target);
  });

  setUp(() {
    repo = _MockRepo();
    keys.clear();
    when(() => repo.catalog()).thenAnswer((_) async => [_namaste, _rose]);
  });

  void stubSend(Future<GiftTransaction> Function() answer) {
    when(
      () => repo.send(
        gift: any(named: 'gift'),
        quantity: any(named: 'quantity'),
        target: any(named: 'target'),
        idempotencyKey: any(named: 'idempotencyKey'),
        message: any(named: 'message'),
      ),
    ).thenAnswer((inv) {
      keys.add(inv.namedArguments[#idempotencyKey] as String);
      return answer();
    });
  }

  test(
    'load preselects the second gift (the popular low-price pick)',
    () async {
      final cubit = SendGiftCubit(repo: repo, target: _target);
      await cubit.load();
      expect(cubit.state.status, SendGiftStatus.ready);
      expect(cubit.state.selected, _rose);
      expect(cubit.state.total?.amount, 10);
    },
  );

  test('send success → sent + wallet refresh callback', () async {
    var refreshed = 0;
    stubSend(() async => _txn);
    final cubit = SendGiftCubit(
      repo: repo,
      target: _target,
      onSent: () async => refreshed++,
    );
    await cubit.load();
    cubit.setQuantity(5);
    expect(cubit.state.total?.amount, 50);

    await cubit.send(message: '  thank you  ');
    expect(cubit.state.status, SendGiftStatus.sent);
    expect(cubit.state.sent, _txn);
    expect(refreshed, 1);
    verify(
      () => repo.send(
        gift: _rose,
        quantity: 5,
        target: _target,
        idempotencyKey: any(named: 'idempotencyKey'),
        message: 'thank you',
      ),
    ).called(1);
  });

  test('402 flags lowBalance and returns to ready', () async {
    stubSend(() async => throw const GiftInsufficientBalance());
    final cubit = SendGiftCubit(repo: repo, target: _target);
    await cubit.load();
    await cubit.send();
    expect(cubit.state.status, SendGiftStatus.ready);
    expect(cubit.state.lowBalance, isTrue);
    expect(cubit.state.error, isNull);
  });

  test('a retry after a failure reuses the idempotency key', () async {
    var calls = 0;
    stubSend(() async {
      calls++;
      if (calls == 1) throw Exception('timeout');
      return _txn;
    });
    final cubit = SendGiftCubit(repo: repo, target: _target);
    await cubit.load();
    await cubit.send();
    expect(cubit.state.error, isNotNull);
    await cubit.send();
    expect(cubit.state.status, SendGiftStatus.sent);
    expect(keys, hasLength(2));
    expect(keys[0], keys[1]);
  });

  test('changing the selection after a failure starts a new key', () async {
    var calls = 0;
    stubSend(() async {
      calls++;
      if (calls == 1) throw Exception('timeout');
      return _txn;
    });
    final cubit = SendGiftCubit(repo: repo, target: _target);
    await cubit.load();
    await cubit.send();
    cubit.select(_namaste);
    await cubit.send();
    expect(keys, hasLength(2));
    expect(keys[0], isNot(keys[1]));
  });

  test('catalog failure → failed; retry recovers', () async {
    when(() => repo.catalog()).thenThrow(Exception('offline'));
    final cubit = SendGiftCubit(repo: repo, target: _target);
    await cubit.load();
    expect(cubit.state.status, SendGiftStatus.failed);

    when(() => repo.catalog()).thenAnswer((_) async => [_rose]);
    await cubit.load();
    expect(cubit.state.status, SendGiftStatus.ready);
    expect(cubit.state.selected, isNull);
  });

  group('models', () {
    test('Gift parses string prices and estimates foreign currencies', () {
      final g = Gift.fromJson({
        'slug': 'diya',
        'name': 'Diya',
        'category': 'blessing',
        'coins': 20,
        'unit_prices': {'INR': '20', 'usd': '0.25'},
      });
      expect(g.priceIn('INR'), 20);
      expect(g.priceIn('USD'), 0.25);
      expect(g.displayPrice('USD').estimate, isFalse);
      final eur = g.displayPrice('EUR');
      expect(eur.estimate, isTrue);
      expect(eur.currency, 'INR');
      expect(eur.amount, 20);
    });

    test('targets send exactly one id', () {
      expect(_target.body, {'astrologer': 'astro-1'});
      expect(
        const ConsultationGiftTarget(
          consultationId: 'c-1',
          astrologerName: 'x',
          currency: 'INR',
        ).body,
        {'consultation': 'c-1'},
      );
    });

    test('idempotency keys are unique', () {
      final a = GiftingRepository.newIdempotencyKey();
      final b = GiftingRepository.newIdempotencyKey();
      expect(a, startsWith('gift-'));
      expect(a, isNot(b));
    });
  });
}
