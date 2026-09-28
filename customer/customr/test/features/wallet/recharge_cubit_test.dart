import 'package:customr/src/core/payments/razorpay_service.dart';
import 'package:customr/src/features/wallet/data/models/auto_recharge.dart';
import 'package:customr/src/features/wallet/data/models/recharge_order.dart';
import 'package:customr/src/features/wallet/data/wallet_repository.dart';
import 'package:customr/src/features/wallet/presentation/cubit/recharge_cubit.dart';
import 'package:customr/src/features/wallet/presentation/cubit/wallet_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepo extends Mock implements WalletRepository {}

class _MockRazorpay extends Mock implements RazorpayService {}

class _MockWallet extends Mock implements WalletCubit {}

const _order = RechargeOrder(
  paymentId: 'pay-1',
  gatewayOrderId: 'order_1',
  amount: 500,
  currency: 'INR',
  keyId: 'rzp_test',
);

PaymentStatus _status(PaymentState s) =>
    PaymentStatus(paymentId: 'pay-1', state: s, amount: 500, currency: 'INR');

void main() {
  _autoRechargeTests();
  late _MockRepo repo;
  late _MockRazorpay razorpay;
  late _MockWallet wallet;

  setUpAll(() {
    registerFallbackValue(_order);
  });

  setUp(() {
    repo = _MockRepo();
    razorpay = _MockRazorpay();
    wallet = _MockWallet();
    when(
      () => repo.createRecharge(
        amount: any(named: 'amount'),
        currency: any(named: 'currency'),
      ),
    ).thenAnswer((_) async => _order);
    when(() => wallet.refreshBalance()).thenAnswer((_) async {});
    when(() => wallet.state).thenReturn(const WalletState());
  });

  RechargeCubit build() =>
      RechargeCubit(repo: repo, razorpay: razorpay, wallet: wallet);

  test(
    'happy path: order → checkout success → verify captured → success',
    () async {
      when(
        () => razorpay.checkout(
          order: any(named: 'order'),
          appName: any(named: 'appName'),
          description: any(named: 'description'),
          contact: any(named: 'contact'),
          email: any(named: 'email'),
        ),
      ).thenAnswer(
        (_) async => const RazorpaySuccess(
          paymentId: 'rzp_pay_1',
          orderId: 'order_1',
          signature: 'sig',
        ),
      );
      when(
        () => repo.verifyRecharge(
          any(),
          razorpayPaymentId: any(named: 'razorpayPaymentId'),
          razorpayOrderId: any(named: 'razorpayOrderId'),
          razorpaySignature: any(named: 'razorpaySignature'),
        ),
      ).thenAnswer((_) async => _status(PaymentState.captured));

      final cubit = build();
      await cubit.start(
        amount: 500,
        currency: 'INR',
        appName: 'TalkAcharya',
        description: 'x',
      );

      expect(cubit.state.status, RechargeStatus.success);
      expect(cubit.state.pendingWebhook, isFalse);
      verify(() => wallet.refreshBalance()).called(1);
    },
  );

  test(
    'user cancels Razorpay → failed, marked cancelled, not charged',
    () async {
      when(
        () => razorpay.checkout(
          order: any(named: 'order'),
          appName: any(named: 'appName'),
          description: any(named: 'description'),
          contact: any(named: 'contact'),
          email: any(named: 'email'),
        ),
      ).thenAnswer((_) async => const RazorpayFailure(code: 2));

      final cubit = build();
      await cubit.start(
        amount: 500,
        currency: 'INR',
        appName: 'TalkAcharya',
        description: 'x',
      );

      expect(cubit.state.status, RechargeStatus.failed);
      expect(cubit.state.cancelled, isTrue);
    },
  );

  test('verify fails but polling finds it captured → success', () async {
    when(
      () => razorpay.checkout(
        order: any(named: 'order'),
        appName: any(named: 'appName'),
        description: any(named: 'description'),
        contact: any(named: 'contact'),
        email: any(named: 'email'),
      ),
    ).thenAnswer(
      (_) async => const RazorpaySuccess(
        paymentId: 'p',
        orderId: 'order_1',
        signature: 's',
      ),
    );
    when(
      () => repo.verifyRecharge(
        any(),
        razorpayPaymentId: any(named: 'razorpayPaymentId'),
        razorpayOrderId: any(named: 'razorpayOrderId'),
        razorpaySignature: any(named: 'razorpaySignature'),
      ),
    ).thenThrow(Exception('verify hiccup'));
    when(
      () => repo.rechargeStatus(any()),
    ).thenAnswer((_) async => _status(PaymentState.captured));

    final cubit = build();
    await cubit.start(
      amount: 500,
      currency: 'INR',
      appName: 'TalkAcharya',
      description: 'x',
    );

    expect(cubit.state.status, RechargeStatus.success);
  });

  test(
    'webhook still pending after polling → success with credited-soon flag',
    () async {
      when(
        () => razorpay.checkout(
          order: any(named: 'order'),
          appName: any(named: 'appName'),
          description: any(named: 'description'),
          contact: any(named: 'contact'),
          email: any(named: 'email'),
        ),
      ).thenAnswer(
        (_) async => const RazorpaySuccess(
          paymentId: 'p',
          orderId: 'order_1',
          signature: 's',
        ),
      );
      when(
        () => repo.verifyRecharge(
          any(),
          razorpayPaymentId: any(named: 'razorpayPaymentId'),
          razorpayOrderId: any(named: 'razorpayOrderId'),
          razorpaySignature: any(named: 'razorpaySignature'),
        ),
      ).thenAnswer((_) async => _status(PaymentState.pending));
      when(
        () => repo.rechargeStatus(any()),
      ).thenAnswer((_) async => _status(PaymentState.pending));

      final cubit = build();
      await cubit.start(
        amount: 500,
        currency: 'INR',
        appName: 'TalkAcharya',
        description: 'x',
      );

      expect(cubit.state.status, RechargeStatus.success);
      expect(cubit.state.pendingWebhook, isTrue);
    },
    timeout: const Timeout(Duration(seconds: 15)),
  );
}

void _autoRechargeTests() {
  group('AutoRecharge', () {
    test('enabled and armed are not the same thing', () {
      // Between setting the amounts and the bank agreeing, the customer has
      // asked for this but nothing can be charged. Showing "on" there is how
      // someone loses a call they believed was covered.
      final pending = AutoRecharge.fromMap({
        'enabled': false,
        'armed': false,
        'amount': '500.00',
        'threshold_amount': '150.00',
      });
      expect(pending.enabled, isFalse);
      expect(pending.armed, isFalse);
      expect(pending.amount, 500);

      final live = AutoRecharge.fromMap({
        'enabled': true,
        'armed': true,
        'amount': '500.00',
        'threshold_amount': '150.00',
        'daily_cap': '2000.00',
      });
      expect(live.armed, isTrue);
      expect(live.dailyCap, 2000);
    });

    test('a mandate the bank killed is reported as such', () {
      final stopped = AutoRecharge.fromMap({
        'enabled': false,
        'armed': false,
        'disabled_reason': 'repeated_failures',
      });
      expect(stopped.stoppedByBank, isTrue);

      // Switched off by the customer is not the same message.
      final byUser = AutoRecharge.fromMap({
        'enabled': false,
        'disabled_reason': 'customer',
      });
      expect(byUser.stoppedByBank, isFalse);
    });

    test('an empty payload reads as off, not as broken', () {
      final none = AutoRecharge.fromMap(const {});
      expect(none.enabled, isFalse);
      expect(none.armed, isFalse);
      expect(none.amount, 0);
    });
  });
}
