import 'package:customr/src/core/payments/razorpay_service.dart';
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
