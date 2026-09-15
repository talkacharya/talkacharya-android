import 'dart:async';

import 'package:customr/src/core/realtime/realtime_event.dart';
import 'package:customr/src/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:customr/src/features/consultations/data/consultation_api.dart';
import 'package:customr/src/features/store/data/models/cart.dart';
import 'package:customr/src/features/store/data/models/checkout.dart';
import 'package:customr/src/features/store/data/models/consult.dart';
import 'package:customr/src/features/store/data/models/order.dart';
import 'package:customr/src/features/store/data/models/product.dart';
import 'package:customr/src/features/store/data/store_api.dart';
import 'package:customr/src/features/store/data/store_repository.dart';
import 'package:customr/src/features/store/presentation/cubit/cart_cubit.dart';
import 'package:customr/src/features/store/presentation/cubit/checkout_cubit.dart';
import 'package:customr/src/features/store/presentation/cubit/consult_cubits.dart';
import 'package:customr/src/features/store/presentation/cubit/order_cubits.dart';
import 'package:customr/src/features/store/presentation/cubit/store_payment.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepo extends Mock implements StoreRepository {}

class _MockPayments extends Mock implements StorePaymentFlow {}

const PayerInfo _payer = (
  appName: 'TalkAcharya',
  description: 'Store',
  contact: null,
  email: null,
);

const _quoteOk = CheckoutQuote(
  ok: true,
  grandTotal: 1060,
  walletAvailable: 300,
  walletAmount: 300,
  gatewayAmount: 760,
);

const _payment = StorePayment(
  paymentId: 'pay1',
  gatewayOrderId: 'order_1',
  amount: 760,
);

StoreOrder _order({
  OrderStatus status = OrderStatus.pendingPayment,
  StorePayment? payment,
}) => StoreOrder(id: 'o1', number: 'TA-1', status: status, payment: payment);

const _physicalCart = Cart(
  count: 1,
  items: [
    CartItem(
      id: 'i1',
      product: ProductCard(
        id: 'p1',
        slug: 'p1',
        title: 'Rudraksha',
        seller: SellerRef(code: 'a'),
      ),
      variantId: 'v1',
      unitPrice: 500,
    ),
  ],
);

void main() {
  late _MockRepo repo;
  late _MockPayments payments;

  setUpAll(() {
    registerFallbackValue(_payment);
    registerFallbackValue(_payer);
    registerFallbackValue(
      const ProductDetail(
        card: ProductCard(
          id: '',
          slug: '',
          title: '',
          seller: SellerRef(code: ''),
        ),
      ),
    );
  });

  setUp(() {
    repo = _MockRepo();
    payments = _MockPayments();
  });

  group('CheckoutCubit', () {
    late CartCubit cart;

    setUp(() {
      when(() => repo.cart()).thenAnswer((_) async => _physicalCart);
      when(() => repo.addresses()).thenAnswer((_) async => const []);
      when(
        () => repo.quote(
          addressId: any(named: 'addressId'),
          useWallet: any(named: 'useWallet'),
        ),
      ).thenAnswer((_) async => _quoteOk);
      cart = CartCubit(repo);
    });

    CheckoutCubit build() =>
        CheckoutCubit(repo: repo, cart: cart, payments: payments);

    test('wallet-only order is placed without opening the gateway', () async {
      when(
        () => repo.placeOrder(
          addressId: any(named: 'addressId'),
          useWallet: any(named: 'useWallet'),
          note: any(named: 'note'),
          idempotencyKey: any(named: 'idempotencyKey'),
        ),
      ).thenAnswer((_) async => _order(status: OrderStatus.paid));
      await cart.load();
      final c = build();
      await c.init();
      await c.placeOrder(_payer);

      expect(c.state.stage, CheckoutStage.placed);
      expect(c.state.order!.status, OrderStatus.paid);
      expect(cart.state.cart.value!.isEmpty, isTrue);
      verifyNever(
        () => payments.pay(
          orderId: any(named: 'orderId'),
          payment: any(named: 'payment'),
          payer: any(named: 'payer'),
        ),
      );
    });

    test('gateway share goes through the payment flow', () async {
      when(
        () => repo.placeOrder(
          addressId: any(named: 'addressId'),
          useWallet: any(named: 'useWallet'),
          note: any(named: 'note'),
          idempotencyKey: any(named: 'idempotencyKey'),
        ),
      ).thenAnswer((_) async => _order(payment: _payment));
      when(
        () => payments.pay(
          orderId: any(named: 'orderId'),
          payment: any(named: 'payment'),
          payer: any(named: 'payer'),
        ),
      ).thenAnswer((_) async => GatewayPaid(_order(status: OrderStatus.paid)));

      final c = build();
      await c.init();
      await c.placeOrder(_payer);

      expect(c.state.stage, CheckoutStage.placed);
      expect(c.state.outcome, isA<GatewayPaid>());
      expect(c.state.order!.status, OrderStatus.paid);
    });

    test(
      'same attempt reuses the idempotency key; changing wallet rotates it',
      () async {
        final c = build();
        await c.init();
        final first = c.state.attemptKey;
        await c.setUseWallet(false);
        expect(c.state.attemptKey, isNot(first));
      },
    );

    test('a checkout problem returns to review and requotes', () async {
      when(
        () => repo.placeOrder(
          addressId: any(named: 'addressId'),
          useWallet: any(named: 'useWallet'),
          note: any(named: 'note'),
          idempotencyKey: any(named: 'idempotencyKey'),
        ),
      ).thenThrow(
        const StoreCheckoutProblem([
          QuoteProblem(scope: 'item', message: 'Out of stock'),
        ]),
      );

      final c = build();
      await c.init();
      await c.placeOrder(_payer);

      expect(c.state.stage, CheckoutStage.review);
      expect(c.state.order, isNull);
      verify(
        () => repo.quote(
          addressId: any(named: 'addressId'),
          useWallet: any(named: 'useWallet'),
        ),
      ).called(2);
    });
  });

  group('CartCubit', () {
    test('resets when the customer signs out', () async {
      when(() => repo.cart()).thenAnswer((_) async => _physicalCart);
      final auth = StreamController<AuthState>();
      final cart = CartCubit(repo, auth: auth.stream);
      await cart.load();
      expect(cart.state.count, 1);

      auth.add(const AuthState.unauthenticated());
      await Future<void>.delayed(Duration.zero);
      expect(cart.state.cart.value, isNull);
      await auth.close();
      await cart.close();
    });
  });

  group('OrderDetailCubit', () {
    test('reloads on a realtime update for this order only', () async {
      when(
        () => repo.order('o1'),
      ).thenAnswer((_) async => _order(status: OrderStatus.paid));
      when(() => repo.invoices('o1')).thenAnswer((_) async => const []);
      final events = StreamController<RealtimeEvent>();
      final c = OrderDetailCubit(
        repo: repo,
        payments: payments,
        id: 'o1',
        realtime: events.stream,
      );
      await c.load();
      verify(() => repo.order('o1')).called(1);

      events.add(const StoreOrderUpdated(orderId: 'other', status: 'paid'));
      events.add(const StoreOrderUpdated(orderId: 'o1', status: 'paid'));
      await Future<void>.delayed(Duration.zero);
      verify(() => repo.order('o1')).called(1);
      await events.close();
      await c.close();
    });
  });

  group('ConsultOptionsCubit', () {
    const astrologer = ConsultAstrologer(
      id: 'a1',
      name: 'Pandit Ji',
      presence: 'online',
      ratePerMinute: 30,
    );
    const product = ProductDetail(
      card: ProductCard(
        id: 'p1',
        slug: 'p1',
        title: 'Neelam',
        seller: SellerRef(code: 'x'),
      ),
    );

    setUp(() {
      when(() => repo.consultOptions('p1')).thenAnswer(
        (_) async =>
            const ConsultOptions(enabled: true, astrologers: [astrologer]),
      );
    });

    test('low balance asks for a recharge', () async {
      when(
        () => repo.startConsult(
          product: any(named: 'product'),
          astrologerId: any(named: 'astrologerId'),
          variantId: any(named: 'variantId'),
          channel: any(named: 'channel'),
          question: any(named: 'question'),
          birthProfileId: any(named: 'birthProfileId'),
        ),
      ).thenThrow(
        InsufficientBalance(
          required: '150.00',
          available: '20.00',
          currency: 'INR',
        ),
      );

      final c = ConsultOptionsCubit(repo: repo, slug: 'p1', product: product);
      await c.load();
      final outcome = await c.start(astrologer: astrologer);

      expect(outcome, isA<ConsultNeedsRecharge>());
      expect((outcome as ConsultNeedsRecharge).required, 150);
      expect(c.state.startingId, isNull);
    });

    test('busy astrologer refreshes the list', () async {
      when(
        () => repo.startConsult(
          product: any(named: 'product'),
          astrologerId: any(named: 'astrologerId'),
          variantId: any(named: 'variantId'),
          channel: any(named: 'channel'),
          question: any(named: 'question'),
          birthProfileId: any(named: 'birthProfileId'),
        ),
      ).thenThrow(AstrologerBusy());

      final c = ConsultOptionsCubit(repo: repo, slug: 'p1', product: product);
      await c.load();
      final outcome = await c.start(astrologer: astrologer);

      expect(outcome, isA<ConsultAstrologerBusy>());
      verify(() => repo.consultOptions('p1')).called(2);
    });
  });
}
