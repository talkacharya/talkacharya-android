import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/network/friendly_error.dart';
import '../../../../core/util/async_value.dart';
import '../../data/models/address.dart';
import '../../data/models/checkout.dart';
import '../../data/models/order.dart';
import '../../data/store_api.dart';
import '../../data/store_repository.dart';
import 'cart_cubit.dart';
import 'store_payment.dart';

enum CheckoutStage {
  /// Reviewing the quote.
  review,

  /// Creating the order (wallet share is debited here).
  placing,

  /// Razorpay sheet is open / payment is being confirmed.
  paying,

  /// Order exists — [CheckoutState.order] is set; the page moves to order detail.
  placed,
}

/// `/store/checkout` — address, wallet toggle, live quote, place + pay.
///
/// The quote is the only source of totals: every change of address or wallet use
/// re-quotes. One idempotency key per attempt means a double tap or a retried
/// request returns the same order instead of charging twice; the key rotates when
/// what the customer is agreeing to changes.
class CheckoutCubit extends Cubit<CheckoutState> {
  CheckoutCubit({
    required StoreRepository repo,
    required CartCubit cart,
    required StorePaymentFlow payments,
  }) : _repo = repo,
       _cart = cart,
       _payments = payments,
       super(CheckoutState(attemptKey: StoreRepository.newCheckoutKey()));

  final StoreRepository _repo;
  final CartCubit _cart;
  final StorePaymentFlow _payments;
  int _quoteGen = 0;

  bool get _needsAddress => _cart.state.cart.value?.needsAddress ?? true;

  Future<void> init() async {
    if (_needsAddress) {
      await loadAddresses();
    } else {
      emit(state.copyWith(addresses: const AsyncValue.data([])));
    }
    await requote();
  }

  Future<void> loadAddresses({String? select}) async {
    emit(state.copyWith(addresses: AsyncValue.loading(state.addresses.value)));
    try {
      final list = await _repo.addresses();
      final keep = select ?? state.addressId;
      final chosen = list.any((a) => a.id == keep)
          ? keep
          : (list.where((a) => a.isDefault).firstOrNull ?? list.firstOrNull)
                ?.id;
      emit(state.copyWith(addresses: AsyncValue.data(list), addressId: chosen));
    } catch (e) {
      emit(
        state.copyWith(
          addresses: AsyncValue.error(friendlyError(e), state.addresses.value),
        ),
      );
    }
  }

  /// After adding / editing an address on the address page.
  Future<void> addressesChanged({String? select}) async {
    await loadAddresses(select: select);
    await requote();
  }

  Future<void> selectAddress(String id) async {
    if (id == state.addressId) return;
    emit(
      state.copyWith(
        addressId: id,
        attemptKey: StoreRepository.newCheckoutKey(),
      ),
    );
    await requote();
  }

  Future<void> setUseWallet(bool value) async {
    if (value == state.useWallet) return;
    emit(
      state.copyWith(
        useWallet: value,
        attemptKey: StoreRepository.newCheckoutKey(),
      ),
    );
    await requote();
  }

  void setNote(String note) => emit(state.copyWith(note: note));

  Future<void> requote() async {
    final gen = ++_quoteGen;
    emit(
      state.copyWith(
        quote: AsyncValue.loading(state.quote.value),
        clearError: true,
      ),
    );
    try {
      final q = await _repo.quote(
        addressId: state.addressId,
        useWallet: state.useWallet,
      );
      if (gen != _quoteGen) return;
      emit(state.copyWith(quote: AsyncValue.data(q)));
    } catch (e) {
      if (gen != _quoteGen) return;
      emit(
        state.copyWith(
          quote: AsyncValue.error(friendlyError(e), state.quote.value),
        ),
      );
    }
  }

  Future<void> placeOrder(PayerInfo payer) async {
    final q = state.quote.value;
    if (q == null || !q.ok || state.stage != CheckoutStage.review) return;
    emit(state.copyWith(stage: CheckoutStage.placing, clearError: true));

    final StoreOrder order;
    try {
      order = await _repo.placeOrder(
        addressId: state.addressId,
        useWallet: state.useWallet,
        note: state.note.trim(),
        idempotencyKey: state.attemptKey,
      );
    } on StoreCheckoutProblem catch (e) {
      // Price, stock or a slot changed since the quote — show the fresh picture.
      emit(
        state.copyWith(
          stage: CheckoutStage.review,
          quote: AsyncValue.data(_withProblems(q, e.problems)),
          attemptKey: StoreRepository.newCheckoutKey(),
        ),
      );
      await requote();
      return;
    } catch (e) {
      emit(
        state.copyWith(stage: CheckoutStage.review, error: friendlyError(e)),
      );
      return;
    }

    // The order exists: the server has emptied the cart.
    _cart.markOrdered();
    _repo.invalidate();

    final payment = order.payment;
    if (!order.awaitingPayment || payment == null || payment.amount <= 0) {
      emit(state.copyWith(stage: CheckoutStage.placed, order: order));
      return;
    }

    emit(state.copyWith(stage: CheckoutStage.paying, order: order));
    final outcome = await _payments.pay(
      orderId: order.id,
      payment: payment,
      payer: payer,
    );
    emit(
      state.copyWith(
        stage: CheckoutStage.placed,
        order: outcome is GatewayPaid ? outcome.order : order,
        outcome: outcome,
      ),
    );
  }

  CheckoutQuote _withProblems(CheckoutQuote q, List<QuoteProblem> problems) =>
      CheckoutQuote(
        currency: q.currency,
        problems: problems,
        needsAddress: q.needsAddress,
        sellers: q.sellers,
        subtotal: q.subtotal,
        shipping: q.shipping,
        taxIncluded: q.taxIncluded,
        grandTotal: q.grandTotal,
        walletAvailable: q.walletAvailable,
        walletAmount: q.walletAmount,
        gatewayAmount: q.gatewayAmount,
      );
}

class CheckoutState extends Equatable {
  const CheckoutState({
    required this.attemptKey,
    this.addresses = const AsyncValue.idle(),
    this.addressId,
    this.useWallet = true,
    this.note = '',
    this.quote = const AsyncValue.idle(),
    this.stage = CheckoutStage.review,
    this.order,
    this.outcome,
    this.error,
  });

  final String attemptKey;
  final AsyncValue<List<Address>> addresses;
  final String? addressId;
  final bool useWallet;
  final String note;
  final AsyncValue<CheckoutQuote> quote;
  final CheckoutStage stage;
  final StoreOrder? order;

  /// Result of the gateway step, when there was one.
  final GatewayOutcome? outcome;
  final String? error;

  Address? get address =>
      addresses.value?.where((a) => a.id == addressId).firstOrNull;

  bool get busy =>
      stage == CheckoutStage.placing || stage == CheckoutStage.paying;

  bool get canPlace {
    final q = quote.value;
    return q != null &&
        q.ok &&
        !quote.isLoading &&
        stage == CheckoutStage.review;
  }

  CheckoutState copyWith({
    String? attemptKey,
    AsyncValue<List<Address>>? addresses,
    String? addressId,
    bool? useWallet,
    String? note,
    AsyncValue<CheckoutQuote>? quote,
    CheckoutStage? stage,
    StoreOrder? order,
    GatewayOutcome? outcome,
    String? error,
    bool clearError = false,
  }) => CheckoutState(
    attemptKey: attemptKey ?? this.attemptKey,
    addresses: addresses ?? this.addresses,
    addressId: addressId ?? this.addressId,
    useWallet: useWallet ?? this.useWallet,
    note: note ?? this.note,
    quote: quote ?? this.quote,
    stage: stage ?? this.stage,
    order: order ?? this.order,
    outcome: outcome ?? this.outcome,
    error: clearError ? null : (error ?? this.error),
  );

  @override
  List<Object?> get props => [
    attemptKey,
    addresses,
    addressId,
    useWallet,
    note,
    quote,
    stage,
    order,
    outcome,
    error,
  ];
}
