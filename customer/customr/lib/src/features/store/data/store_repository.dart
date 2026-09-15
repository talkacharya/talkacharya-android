import 'dart:math';

import 'models/address.dart';
import 'models/cart.dart';
import 'models/catalog.dart';
import 'models/checkout.dart';
import 'models/consult.dart';
import 'models/order.dart';
import 'models/product.dart';
import 'models/store_json.dart';
import 'store_api.dart';

/// Store data access with small session caches (store home, filter facets) so
/// tab switches and back-navigation don't refetch what hasn't changed.
class StoreRepository {
  StoreRepository(this._api, {DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;

  final StoreApi _api;
  final DateTime Function() _clock;

  static const _homeTtl = Duration(minutes: 3);

  StoreHome? _home;
  DateTime? _homeAt;
  final _facets = <String, List<FilterFacet>>{};

  // --- catalog -------------------------------------------------------------------

  Future<StoreHome> home({bool force = false}) async {
    final cached = _home;
    final at = _homeAt;
    if (!force &&
        cached != null &&
        at != null &&
        _clock().difference(at) < _homeTtl) {
      return cached;
    }
    final fresh = await _api.home();
    _home = fresh;
    _homeAt = _clock();
    return fresh;
  }

  Future<List<FilterFacet>> filters({String? type}) async {
    final key = type ?? '';
    final cached = _facets[key];
    if (cached != null) return cached;
    return _facets[key] = await _api.filters(type: type);
  }

  Future<List<StoreCategory>> categories() => _api.categories();

  Future<ProductPage> products(
    ProductQuery q, {
    int offset = 0,
    int limit = 20,
  }) => _api.products(q, offset: offset, limit: limit);

  Future<ProductDetail> product(String slug, {String? recommendationId}) =>
      _api.product(slug, recommendationId: recommendationId);

  Future<StoreCollection> collection(String slug) => _api.collection(slug);

  // --- cart ------------------------------------------------------------------------

  Future<Cart> cart() => _api.cart();

  Future<Cart> addToCart({
    required String variantId,
    int quantity = 1,
    Json inputs = const {},
    String? eventId,
    String? recommendationId,
  }) => _api.addToCart(
    variantId: variantId,
    quantity: quantity,
    inputs: inputs,
    eventId: eventId,
    recommendationId: recommendationId,
  );

  Future<Cart> setQuantity(String itemId, int quantity) =>
      _api.updateCartItem(itemId, quantity: quantity);

  Future<Cart> removeItem(String itemId) => _api.removeCartItem(itemId);

  Future<void> clearCart() => _api.clearCart();

  // --- addresses ---------------------------------------------------------------------

  Future<List<Address>> addresses() => _api.addresses();

  Future<Address> saveAddress(Address a) =>
      a.isSaved ? _api.updateAddress(a.id, a.toJson()) : _api.createAddress(a);

  Future<Address> makeDefault(Address a) =>
      _api.updateAddress(a.id, {'is_default': true});

  Future<void> deleteAddress(String id) => _api.deleteAddress(id);

  // --- checkout ----------------------------------------------------------------------

  Future<CheckoutQuote> quote({String? addressId, bool useWallet = true}) =>
      _api.quote(addressId: addressId, useWallet: useWallet);

  Future<StoreOrder> placeOrder({
    String? addressId,
    bool useWallet = true,
    String note = '',
    required String idempotencyKey,
  }) => _api.placeOrder(
    addressId: addressId,
    useWallet: useWallet,
    note: note,
    idempotencyKey: idempotencyKey,
  );

  Future<StoreOrder> verifyPayment(
    String orderId, {
    required String paymentId,
    required String signature,
  }) => _api.verifyPayment(orderId, paymentId: paymentId, signature: signature);

  Future<StorePayment> retryPayment(String orderId) =>
      _api.retryPayment(orderId);

  /// A fresh checkout attempt key: same key → the backend returns the same order.
  static String newCheckoutKey([Random? random]) {
    final r = random ?? Random.secure();
    final bytes = List<int>.generate(16, (_) => r.nextInt(256));
    return 'co_${bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join()}';
  }

  // --- orders --------------------------------------------------------------------------

  Future<({List<OrderSummary> items, String? next})> orders({String? cursor}) =>
      _api.orders(cursor: cursor);

  Future<StoreOrder> order(String id) => _api.order(id);

  Future<StoreOrder> cancelOrder(StoreOrder o, String reason) =>
      _api.cancelOrder(o.id, reason);

  Future<StoreOrder> cancelSubOrder(StoreOrder o, SubOrder s, String reason) =>
      _api.cancelSubOrder(o.id, s.id, reason);

  Future<List<StoreInvoice>> invoices(String orderId) => _api.invoices(orderId);

  Future<void> requestReturn(
    String orderId,
    String lineId, {
    required String reason,
    int quantity = 1,
    String details = '',
  }) => _api.requestReturn(
    orderId,
    lineId,
    reason: reason,
    quantity: quantity,
    details: details,
  );

  Future<String?> downloadUrl(String accessId) => _api.downloadUrl(accessId);

  Future<List<ServiceBooking>> bookings() => _api.bookings();

  // --- consult before buying --------------------------------------------------------

  Future<ConsultOptions> consultOptions(String slug, {String? channel}) =>
      _api.consultOptions(slug, channel: channel);

  Future<StartedConsult> startConsult({
    required ProductDetail product,
    required String astrologerId,
    String? variantId,
    String? channel,
    String question = '',
    String? birthProfileId,
  }) => _api.startConsult(
    productId: product.id,
    astrologerId: astrologerId,
    variantId: variantId,
    channel: channel,
    question: question,
    birthProfileId: birthProfileId,
  );

  Future<List<StoreConsult>> consults() => _api.consults();

  Future<StoreConsult?> consultForConsultation(String consultationId) async {
    final list = await _api.consults(consultationId: consultationId);
    return list.isEmpty ? null : list.first;
  }

  Future<StoreConsult> consult(String id) => _api.consult(id);

  /// Forget caches (after an order, a language change, a pull-to-refresh).
  void invalidate() {
    _home = null;
    _homeAt = null;
    _facets.clear();
  }
}
