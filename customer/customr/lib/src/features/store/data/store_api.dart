import 'package:dio/dio.dart';

import '../../../core/constants/api_paths.dart';
import '../../../core/network/api_exception.dart';
import '../../consultations/data/consultation_api.dart'
    show AstrologerBusy, AstrologerOffline, InsufficientBalance;
import '../../consultations/data/models/consultation.dart';
import 'models/address.dart';
import 'models/cart.dart';
import 'models/catalog.dart';
import 'models/checkout.dart';
import 'models/consult.dart';
import 'models/order.dart';
import 'models/product.dart';
import 'models/store_json.dart';

/// The customer typed something the product's form rejects (`store.invalid_inputs`).
class StoreInputsInvalid implements Exception {
  const StoreInputsInvalid(this.fields);

  /// field key → message
  final Map<String, String> fields;
}

/// Checkout refused: something in the cart / address needs attention.
class StoreCheckoutProblem implements Exception {
  const StoreCheckoutProblem(this.problems);
  final List<QuoteProblem> problems;
}

/// This product needs an astrologer's recommendation first.
class StoreConsultRequired implements Exception {
  const StoreConsultRequired([this.productSlug]);
  final String? productSlug;
}

/// A started consult: the store link plus the consultation it created.
class StartedConsult {
  const StartedConsult({required this.consult, required this.consultation});
  final StoreConsult consult;
  final Consultation consultation;
}

/// Transport for `/app/store/*`. Throws [ApiException] (and the typed errors
/// above where the UI reacts differently).
class StoreApi {
  StoreApi(this._dio);

  final Dio _dio;

  Never _fail(DioException e) {
    final res = e.response;
    final data = res?.data;
    if (data is Map) {
      final code = data['code'] as String?;
      final detail = data['detail'];
      switch (code) {
        case 'store.invalid_inputs':
          if (detail is Map) {
            throw StoreInputsInvalid({
              for (final entry in detail.entries)
                '${entry.key}': '${entry.value}',
            });
          }
        case 'store.checkout_problem':
          if (detail is Map) {
            throw StoreCheckoutProblem(
              jList(detail['problems'], QuoteProblem.fromJson),
            );
          }
        case 'store.consult_required':
          throw StoreConsultRequired(
            detail is Map ? '${detail['product']}' : null,
          );
        case 'consultation.astrologer_busy':
          throw AstrologerBusy();
        case 'consultation.astrologer_unavailable':
          throw AstrologerOffline(data['message'] as String?);
      }
      if (res?.statusCode == 402) {
        final d = detail is Map ? detail : const {};
        throw InsufficientBalance(
          required: '${d['required'] ?? ''}',
          available: '${d['available'] ?? ''}',
          currency: '${d['currency'] ?? 'INR'}',
        );
      }
    }
    throw ApiException.fromDio(e);
  }

  Future<T> _get<T>(
    String path,
    T Function(Object? data) parse, {
    Map<String, dynamic>? query,
  }) async {
    try {
      final res = await _dio.get<Object?>(path, queryParameters: query);
      return parse(res.data);
    } on DioException catch (e) {
      _fail(e);
    }
  }

  Future<T> _send<T>(
    String method,
    String path,
    T Function(Object? data) parse, {
    Object? body,
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final res = await _dio.request<Object?>(
        path,
        data: body,
        queryParameters: query,
        options: Options(method: method, headers: headers),
      );
      return parse(res.data);
    } on DioException catch (e) {
      _fail(e);
    }
  }

  // --- catalog -----------------------------------------------------------------

  Future<StoreHome> home() =>
      _get(ApiPaths.storeHome, (d) => StoreHome.fromJson(jMap(d)));

  Future<List<StoreCategory>> categories() =>
      _get(ApiPaths.storeCategories, (d) => jList(d, StoreCategory.fromJson));

  Future<List<FilterFacet>> filters({String? type}) => _get(
    ApiPaths.storeFilters,
    (d) => jList(jMap(d)['facets'], FilterFacet.fromJson),
    query: {'type': ?type},
  );

  Future<ProductPage> products(
    ProductQuery query, {
    int limit = 20,
    int offset = 0,
  }) => _get(
    ApiPaths.storeProducts,
    (d) => ProductPage.fromJson(jMap(d)),
    query: {...query.toParams(), 'limit': limit, 'offset': offset},
  );

  Future<ProductDetail> product(String slug, {String? recommendationId}) =>
      _get(
        ApiPaths.storeProduct(slug),
        (d) => ProductDetail.fromJson(jMap(d)),
        query: {'rec': ?recommendationId},
      );

  Future<List<ServiceEvent>> productEvents(String slug) => _get(
    ApiPaths.storeProductEvents(slug),
    (d) => jList(d, ServiceEvent.fromJson),
  );

  Future<StoreCollection> collection(String slug) => _get(
    ApiPaths.storeCollection(slug),
    (d) => StoreCollection.fromJson(jMap(d)),
  );

  // --- cart ----------------------------------------------------------------------

  Future<Cart> cart() =>
      _get(ApiPaths.storeCart, (d) => Cart.fromJson(jMap(d)));

  Future<void> clearCart() => _send('DELETE', ApiPaths.storeCart, (_) {});

  Future<Cart> addToCart({
    required String variantId,
    int quantity = 1,
    Json inputs = const {},
    String? eventId,
    String? recommendationId,
  }) => _send(
    'POST',
    ApiPaths.storeCartItems,
    (d) => Cart.fromJson(jMap(d)),
    body: {
      'variant_id': variantId,
      'quantity': quantity,
      'inputs': inputs,
      'event_id': ?eventId,
      'recommendation_id': ?recommendationId,
    },
  );

  Future<Cart> updateCartItem(String itemId, {int? quantity, Json? inputs}) =>
      _send(
        'PATCH',
        ApiPaths.storeCartItem(itemId),
        (d) => Cart.fromJson(jMap(d)),
        body: {'quantity': ?quantity, 'inputs': ?inputs},
      );

  Future<Cart> removeCartItem(String itemId) => _send(
    'DELETE',
    ApiPaths.storeCartItem(itemId),
    (d) => Cart.fromJson(jMap(d)),
  );

  // --- addresses -------------------------------------------------------------------

  Future<List<Address>> addresses() =>
      _get(ApiPaths.storeAddresses, (d) => jList(d, Address.fromJson));

  Future<Address> createAddress(Address a) => _send(
    'POST',
    ApiPaths.storeAddresses,
    (d) => Address.fromJson(jMap(d)),
    body: a.toJson(),
  );

  Future<Address> updateAddress(String id, Json patch) => _send(
    'PATCH',
    ApiPaths.storeAddress(id),
    (d) => Address.fromJson(jMap(d)),
    body: patch,
  );

  Future<void> deleteAddress(String id) =>
      _send('DELETE', ApiPaths.storeAddress(id), (_) {});

  // --- checkout ----------------------------------------------------------------------

  Future<CheckoutQuote> quote({String? addressId, bool useWallet = true}) =>
      _send(
        'POST',
        ApiPaths.storeCheckoutQuote,
        (d) => CheckoutQuote.fromJson(jMap(d)),
        body: {'address_id': ?addressId, 'use_wallet': useWallet},
      );

  Future<StoreOrder> placeOrder({
    String? addressId,
    bool useWallet = true,
    String note = '',
    required String idempotencyKey,
  }) => _send(
    'POST',
    ApiPaths.storeCheckout,
    (d) => StoreOrder.fromJson(jMap(d)),
    body: {
      'address_id': ?addressId,
      'use_wallet': useWallet,
      'note': note,
      'idempotency_key': idempotencyKey,
    },
    headers: {
      'Idempotency-Key': idempotencyKey,
      'X-Client-Platform': 'android',
    },
  );

  // --- orders ------------------------------------------------------------------------

  Future<({List<OrderSummary> items, String? next})> orders({
    String? cursor,
    String? status,
  }) => _get(ApiPaths.storeOrders, (d) {
    final m = jMap(d);
    final next = jStrOrNull(m['next']);
    return (
      items: jList(m['results'], OrderSummary.fromJson),
      next: next == null ? null : Uri.parse(next).queryParameters['cursor'],
    );
  }, query: {'cursor': ?cursor, 'status': ?status});

  Future<StoreOrder> order(String id) =>
      _get(ApiPaths.storeOrder(id), (d) => StoreOrder.fromJson(jMap(d)));

  Future<StoreOrder> verifyPayment(
    String orderId, {
    required String paymentId,
    required String signature,
  }) => _send(
    'POST',
    ApiPaths.storeOrderVerify(orderId),
    (d) => StoreOrder.fromJson(jMap(d)),
    body: {'razorpay_payment_id': paymentId, 'razorpay_signature': signature},
  );

  Future<StorePayment> retryPayment(String orderId) => _send(
    'POST',
    ApiPaths.storeOrderRetry(orderId),
    (d) => StorePayment.fromJson(jMap(d)),
  );

  Future<StoreOrder> cancelOrder(String orderId, String reason) => _send(
    'POST',
    ApiPaths.storeOrderCancel(orderId),
    (d) => StoreOrder.fromJson(jMap(d)),
    body: {'reason': reason},
  );

  Future<StoreOrder> cancelSubOrder(
    String orderId,
    String subOrderId,
    String reason,
  ) => _send(
    'POST',
    ApiPaths.storeSubOrderCancel(orderId, subOrderId),
    (d) => StoreOrder.fromJson(jMap(d)),
    body: {'reason': reason},
  );

  Future<List<StoreInvoice>> invoices(String orderId) => _get(
    ApiPaths.storeOrderInvoices(orderId),
    (d) => jList(d, StoreInvoice.fromJson),
  );

  Future<void> requestReturn(
    String orderId,
    String lineId, {
    required String reason,
    int quantity = 1,
    String details = '',
  }) => _send(
    'POST',
    ApiPaths.storeLineReturn(orderId, lineId),
    (_) {},
    body: {'reason': reason, 'quantity': quantity, 'details': details},
  );

  Future<List<ServiceBooking>> bookings() =>
      _get(ApiPaths.storeBookings, (d) => jList(d, ServiceBooking.fromJson));

  Future<String?> downloadUrl(String accessId) =>
      _get(ApiPaths.storeDownload(accessId), (d) => jStrOrNull(jMap(d)['url']));

  // --- consult before buying ------------------------------------------------------

  Future<ConsultOptions> consultOptions(String slug, {String? channel}) => _get(
    ApiPaths.storeProductConsult(slug),
    (d) => ConsultOptions.fromJson(jMap(d)),
    query: {'channel': ?channel},
  );

  Future<StartedConsult> startConsult({
    required String productId,
    required String astrologerId,
    String? variantId,
    String? channel,
    String question = '',
    String? birthProfileId,
    String source = 'product',
  }) => _send(
    'POST',
    ApiPaths.storeConsults,
    (d) {
      final m = jMap(d);
      return StartedConsult(
        consult: StoreConsult.fromJson(m),
        consultation: Consultation.fromMap(jMap(m['consultation_detail'])),
      );
    },
    body: {
      'product_id': productId,
      'astrologer_id': astrologerId,
      'variant_id': ?variantId,
      'channel': ?channel,
      'question': question,
      'birth_profile_id': ?birthProfileId,
      'source': source,
    },
  );

  Future<List<StoreConsult>> consults({
    String? productSlug,
    String? consultationId,
  }) => _get(
    ApiPaths.storeConsults,
    (d) => jList(d, StoreConsult.fromJson),
    query: {'product': ?productSlug, 'consultation': ?consultationId},
  );

  Future<StoreConsult> consult(String id) =>
      _get(ApiPaths.storeConsult(id), (d) => StoreConsult.fromJson(jMap(d)));
}
