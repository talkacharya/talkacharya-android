import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/network/friendly_error.dart';
import '../../../../core/realtime/realtime_event.dart';
import '../../../../core/util/async_value.dart';
import '../../data/models/address.dart';
import '../../data/models/catalog.dart';
import '../../data/models/order.dart';
import '../../data/store_repository.dart';
import 'store_payment.dart';

// --- orders list ------------------------------------------------------------------------

class OrdersState extends Equatable {
  const OrdersState({
    this.orders = const AsyncValue.idle(),
    this.next,
    this.loadingMore = false,
    this.bookings = const AsyncValue.idle(),
  });

  final AsyncValue<List<OrderSummary>> orders;
  final String? next;
  final bool loadingMore;
  final AsyncValue<List<ServiceBooking>> bookings;

  bool get hasMore => next != null;

  OrdersState copyWith({
    AsyncValue<List<OrderSummary>>? orders,
    String? Function()? next,
    bool? loadingMore,
    AsyncValue<List<ServiceBooking>>? bookings,
  }) => OrdersState(
    orders: orders ?? this.orders,
    next: next == null ? this.next : next(),
    loadingMore: loadingMore ?? this.loadingMore,
    bookings: bookings ?? this.bookings,
  );

  @override
  List<Object?> get props => [orders, next, loadingMore, bookings];
}

/// `/store/orders` — all orders (cursor paged) and the pooja bookings tab.
class OrdersCubit extends Cubit<OrdersState> {
  OrdersCubit(this._repo, {Stream<RealtimeEvent>? realtime})
    : super(const OrdersState()) {
    _sub = realtime?.listen((e) {
      if (e is StoreOrderUpdated) {
        unawaited(loadOrders());
        if (state.bookings.hasValue) unawaited(loadBookings());
      }
    });
  }

  final StoreRepository _repo;
  StreamSubscription<RealtimeEvent>? _sub;

  Future<void> loadOrders() async {
    emit(state.copyWith(orders: AsyncValue.loading(state.orders.value)));
    try {
      final page = await _repo.orders();
      emit(
        state.copyWith(
          orders: AsyncValue.data(page.items),
          next: () => page.next,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          orders: AsyncValue.error(friendlyError(e), state.orders.value),
        ),
      );
    }
  }

  Future<void> loadMore() async {
    final current = state.orders.value;
    if (current == null || state.next == null || state.loadingMore) return;
    emit(state.copyWith(loadingMore: true));
    try {
      final page = await _repo.orders(cursor: state.next);
      emit(
        state.copyWith(
          orders: AsyncValue.data([...current, ...page.items]),
          next: () => page.next,
          loadingMore: false,
        ),
      );
    } catch (_) {
      emit(state.copyWith(loadingMore: false));
    }
  }

  Future<void> loadBookings() async {
    emit(state.copyWith(bookings: AsyncValue.loading(state.bookings.value)));
    try {
      emit(state.copyWith(bookings: AsyncValue.data(await _repo.bookings())));
    } catch (e) {
      emit(
        state.copyWith(
          bookings: AsyncValue.error(friendlyError(e), state.bookings.value),
        ),
      );
    }
  }

  @override
  Future<void> close() async {
    await _sub?.cancel();
    return super.close();
  }
}

// --- order detail -------------------------------------------------------------------------

class OrderDetailState extends Equatable {
  const OrderDetailState({
    this.order = const AsyncValue.idle(),
    this.invoices = const AsyncValue.idle(),
    this.paying = false,
    this.busy = const {},
  });

  final AsyncValue<StoreOrder> order;
  final AsyncValue<List<StoreInvoice>> invoices;
  final bool paying;

  /// Ids with an action in flight (order id for cancel, sub-order ids, download ids).
  final Set<String> busy;

  OrderDetailState copyWith({
    AsyncValue<StoreOrder>? order,
    AsyncValue<List<StoreInvoice>>? invoices,
    bool? paying,
    Set<String>? busy,
  }) => OrderDetailState(
    order: order ?? this.order,
    invoices: invoices ?? this.invoices,
    paying: paying ?? this.paying,
    busy: busy ?? this.busy,
  );

  @override
  List<Object?> get props => [order, invoices, paying, busy];
}

/// `/store/orders/:id` — tracking, pay again, cancel, downloads, invoices.
/// Refreshes itself on `store.order.updated` for this order.
class OrderDetailCubit extends Cubit<OrderDetailState> {
  OrderDetailCubit({
    required StoreRepository repo,
    required StorePaymentFlow payments,
    required String id,
    Stream<RealtimeEvent>? realtime,
  }) : _repo = repo,
       _payments = payments,
       _id = id,
       super(const OrderDetailState()) {
    _sub = realtime?.listen((e) {
      if (e is StoreOrderUpdated && e.orderId == _id) {
        unawaited(load(silent: true));
      }
    });
  }

  final StoreRepository _repo;
  final StorePaymentFlow _payments;
  final String _id;
  StreamSubscription<RealtimeEvent>? _sub;

  Future<void> load({bool silent = false}) async {
    if (!silent) {
      emit(state.copyWith(order: AsyncValue.loading(state.order.value)));
    }
    try {
      final o = await _repo.order(_id);
      emit(state.copyWith(order: AsyncValue.data(o)));
      if (o.paidAt != null) unawaited(loadInvoices());
    } catch (e) {
      if (!silent || !state.order.hasValue) {
        emit(
          state.copyWith(
            order: AsyncValue.error(friendlyError(e), state.order.value),
          ),
        );
      }
    }
  }

  Future<void> loadInvoices() async {
    try {
      emit(
        state.copyWith(invoices: AsyncValue.data(await _repo.invoices(_id))),
      );
    } catch (e) {
      emit(
        state.copyWith(
          invoices: AsyncValue.error(friendlyError(e), state.invoices.value),
        ),
      );
    }
  }

  /// Pay the outstanding gateway share again. Returns null when there was nothing to pay.
  Future<GatewayOutcome?> payNow(PayerInfo payer) async {
    final o = state.order.value;
    if (o == null || !o.awaitingPayment || state.paying) return null;
    emit(state.copyWith(paying: true));
    try {
      final payment = await _repo.retryPayment(o.id);
      final outcome = await _payments.pay(
        orderId: o.id,
        payment: payment,
        payer: payer,
      );
      if (outcome is GatewayPaid) {
        emit(state.copyWith(order: AsyncValue.data(outcome.order)));
        unawaited(loadInvoices());
      } else {
        await load(silent: true);
      }
      return outcome;
    } catch (e) {
      await load(silent: true);
      return GatewayFailed(friendlyError(e));
    } finally {
      emit(state.copyWith(paying: false));
    }
  }

  /// Cancel the whole order ([sub] null) or one seller's part. Returns an error message.
  Future<String?> cancel(String reason, {SubOrder? sub}) async {
    final o = state.order.value;
    if (o == null) return null;
    final key = sub?.id ?? o.id;
    emit(state.copyWith(busy: {...state.busy, key}));
    try {
      final updated = sub == null
          ? await _repo.cancelOrder(o, reason)
          : await _repo.cancelSubOrder(o, sub, reason);
      emit(state.copyWith(order: AsyncValue.data(updated)));
      return null;
    } catch (e) {
      return friendlyError(e);
    } finally {
      emit(state.copyWith(busy: {...state.busy}..remove(key)));
    }
  }

  /// Signed, short-lived URL for a digital download.
  Future<String?> downloadUrl(String accessId) async {
    emit(state.copyWith(busy: {...state.busy, accessId}));
    try {
      return await _repo.downloadUrl(accessId);
    } finally {
      emit(state.copyWith(busy: {...state.busy}..remove(accessId)));
    }
  }

  @override
  Future<void> close() async {
    await _sub?.cancel();
    return super.close();
  }
}

// --- addresses ------------------------------------------------------------------------------

class AddressesCubit extends Cubit<AsyncValue<List<Address>>> {
  AddressesCubit(this._repo) : super(const AsyncValue.idle());

  final StoreRepository _repo;

  Future<void> load() async {
    emit(AsyncValue.loading(state.value));
    try {
      emit(AsyncValue.data(await _repo.addresses()));
    } catch (e) {
      emit(AsyncValue.error(friendlyError(e), state.value));
    }
  }

  Future<String?> makeDefault(Address a) async {
    try {
      await _repo.makeDefault(a);
      await load();
      return null;
    } catch (e) {
      return friendlyError(e);
    }
  }

  Future<String?> delete(Address a) async {
    try {
      await _repo.deleteAddress(a.id);
      emit(
        AsyncValue.data([...?state.value]..removeWhere((x) => x.id == a.id)),
      );
      return null;
    } catch (e) {
      return friendlyError(e);
    }
  }
}

// --- collection -------------------------------------------------------------------------------

class CollectionCubit extends Cubit<AsyncValue<StoreCollection>> {
  CollectionCubit({required StoreRepository repo, required String slug})
    : _repo = repo,
      _slug = slug,
      super(const AsyncValue.idle());

  final StoreRepository _repo;
  final String _slug;

  Future<void> load() async {
    emit(AsyncValue.loading(state.value));
    try {
      emit(AsyncValue.data(await _repo.collection(_slug)));
    } catch (e) {
      emit(AsyncValue.error(friendlyError(e), state.value));
    }
  }
}
