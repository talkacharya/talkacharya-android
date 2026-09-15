import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/network/friendly_error.dart';
import '../../../../core/util/async_value.dart';
import '../../../auth/presentation/bloc/auth/auth_bloc.dart';
import '../../data/models/cart.dart';
import '../../data/models/store_json.dart';
import '../../data/store_repository.dart';

/// The customer's cart, app-wide (the badge on every store app bar reads it).
///
/// Mutations return the fresh [Cart] from the server — the backend re-validates
/// price, stock and inputs on every change, so the client never guesses totals.
/// `add` rethrows typed store errors so the calling screen can react in context
/// (inline form errors, out of stock, consult required).
class CartCubit extends Cubit<CartState> {
  CartCubit(this._repo, {Stream<AuthState>? auth}) : super(const CartState()) {
    // A signed-out device must not show the previous customer's cart badge.
    _authSub = auth?.listen((a) {
      if (a.status != AuthStatus.authenticated) reset();
    });
  }

  final StoreRepository _repo;
  StreamSubscription<AuthState>? _authSub;
  bool _loading = false;

  Future<void> load() async {
    if (_loading) return;
    _loading = true;
    emit(state.copyWith(cart: AsyncValue.loading(state.cart.value)));
    try {
      final cart = await _repo.cart();
      emit(state.copyWith(cart: AsyncValue.data(cart)));
    } catch (e) {
      emit(
        state.copyWith(
          cart: AsyncValue.error(friendlyError(e), state.cart.value),
        ),
      );
    } finally {
      _loading = false;
    }
  }

  Future<Cart> add({
    required String variantId,
    int quantity = 1,
    Json inputs = const {},
    String? eventId,
    String? recommendationId,
  }) async {
    final cart = await _repo.addToCart(
      variantId: variantId,
      quantity: quantity,
      inputs: inputs,
      eventId: eventId,
      recommendationId: recommendationId,
    );
    emit(state.copyWith(cart: AsyncValue.data(cart)));
    return cart;
  }

  Future<void> setQuantity(CartItem item, int quantity) =>
      _mutate(item.id, () => _repo.setQuantity(item.id, quantity));

  Future<void> remove(CartItem item) =>
      _mutate(item.id, () => _repo.removeItem(item.id));

  Future<void> _mutate(String itemId, Future<Cart> Function() run) async {
    emit(state.copyWith(busy: {...state.busy, itemId}, clearError: true));
    try {
      final cart = await run();
      emit(
        state.copyWith(
          cart: AsyncValue.data(cart),
          busy: {...state.busy}..remove(itemId),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          busy: {...state.busy}..remove(itemId),
          error: friendlyError(e),
        ),
      );
    }
  }

  /// After a successful order the server empties the cart.
  void markOrdered() => emit(
    state.copyWith(
      cart: AsyncValue.data(
        Cart(currency: state.cart.value?.currency ?? 'INR'),
      ),
    ),
  );

  /// Logout: drop the previous customer's cart.
  void reset() {
    if (state != const CartState()) emit(const CartState());
  }

  @override
  Future<void> close() async {
    await _authSub?.cancel();
    return super.close();
  }
}

class CartState extends Equatable {
  const CartState({
    this.cart = const AsyncValue.idle(),
    this.busy = const {},
    this.error,
  });

  final AsyncValue<Cart> cart;

  /// Items with a change in flight (stepper / remove spinners).
  final Set<String> busy;
  final String? error;

  int get count => cart.value?.count ?? 0;

  CartState copyWith({
    AsyncValue<Cart>? cart,
    Set<String>? busy,
    String? error,
    bool clearError = false,
  }) => CartState(
    cart: cart ?? this.cart,
    busy: busy ?? this.busy,
    error: clearError ? null : (error ?? this.error),
  );

  @override
  List<Object?> get props => [cart, busy, error];
}
