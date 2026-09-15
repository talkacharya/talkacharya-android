import 'package:dio/dio.dart';

import '../../../core/constants/api_paths.dart';
import '../../../core/network/api_exception.dart';
import 'models/invoice.dart';
import 'models/recharge_order.dart';
import 'models/recharge_pack.dart';
import 'models/wallet_balance.dart';
import 'models/wallet_transaction.dart';

class TransactionsPage {
  const TransactionsPage({required this.items, this.nextCursor});
  final List<WalletTransaction> items;
  final String? nextCursor;
  bool get hasMore => nextCursor != null;
}

class PromoResult {
  const PromoResult({
    required this.grantedAmount,
    required this.availableBalance,
  });
  final double grantedAmount;
  final double availableBalance;
}

/// Transport for the wallet. Throws [ApiException].
class WalletApi {
  WalletApi(this._dio);

  final Dio _dio;

  Future<List<WalletBalance>> balances() async {
    final data = await _getList(ApiPaths.wallet);
    return data
        .map((e) => WalletBalance.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<WalletPacks> packs({String? currency}) async {
    final json = await _getMap(
      ApiPaths.walletPacks,
      query: {'currency': ?currency},
    );
    return WalletPacks.fromJson(json);
  }

  Future<TransactionsPage> transactions({
    String? cursor,
    String? currency,
  }) async {
    final json = await _getMap(
      ApiPaths.walletTransactions,
      query: {'cursor': ?cursor, 'currency': ?currency},
    );
    final results = (json['results'] as List<dynamic>? ?? const [])
        .map((e) => WalletTransaction.fromJson(e as Map<String, dynamic>))
        .toList();
    return TransactionsPage(
      items: results,
      nextCursor: _cursorOf(json['next'] as String?),
    );
  }

  Future<RechargeOrder> createRecharge({
    required num amount,
    String? currency,
  }) async {
    final json = await _postMap(
      ApiPaths.walletRecharge,
      body: {'amount': amount.toString(), 'currency': ?currency},
    );
    return RechargeOrder.fromJson(json);
  }

  Future<PaymentStatus> rechargeStatus(String paymentId) async {
    return PaymentStatus.fromJson(
      await _getMap(ApiPaths.rechargeStatus(paymentId)),
    );
  }

  Future<PaymentStatus> verifyRecharge(
    String paymentId, {
    required String razorpayPaymentId,
    required String razorpayOrderId,
    required String razorpaySignature,
  }) async {
    final json = await _postMap(
      ApiPaths.rechargeVerify(paymentId),
      body: {
        'razorpay_payment_id': razorpayPaymentId,
        'razorpay_order_id': razorpayOrderId,
        'razorpay_signature': razorpaySignature,
      },
    );
    return PaymentStatus.fromJson(json);
  }

  Future<List<Invoice>> invoices() async {
    final data = await _getList(ApiPaths.invoices);
    return data
        .map((e) => Invoice.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Raw PDF bytes for one invoice (the endpoint needs the auth header, so we
  /// download here rather than handing a URL to the browser).
  Future<List<int>> invoicePdf(String id) async {
    try {
      final res = await _dio.get<List<int>>(
        ApiPaths.invoicePdf(id),
        options: Options(responseType: ResponseType.bytes),
      );
      _raiseFor(res);
      return res.data ?? const [];
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<PromoResult> redeemPromo({
    required String code,
    String? currency,
    num? rechargeAmount,
  }) async {
    final json = await _postMap(
      ApiPaths.promoRedeem,
      body: {
        'code': code,
        'currency': ?currency,
        'recharge_amount': ?rechargeAmount?.toString(),
      },
    );
    return PromoResult(
      grantedAmount: double.tryParse('${json['granted_amount'] ?? 0}') ?? 0,
      availableBalance:
          double.tryParse('${json['available_balance'] ?? 0}') ?? 0,
    );
  }

  // --- helpers ---------------------------------------------------------

  Future<Map<String, dynamic>> _getMap(
    String path, {
    Map<String, dynamic>? query,
  }) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        path,
        queryParameters: query,
      );
      _raiseFor(res);
      return res.data ?? const {};
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<Map<String, dynamic>> _postMap(
    String path, {
    Map<String, dynamic>? body,
  }) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(path, data: body);
      _raiseFor(res);
      return res.data ?? const {};
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<List<dynamic>> _getList(String path) async {
    try {
      final res = await _dio.get<dynamic>(path);
      _raiseFor(res);
      final data = res.data;
      if (data is List) return data;
      if (data is Map && data['results'] is List) {
        return data['results'] as List<dynamic>;
      }
      return const [];
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  void _raiseFor(Response<dynamic> res) {
    if ((res.statusCode ?? 0) >= 400) {
      throw ApiException.fromDio(
        DioException(requestOptions: res.requestOptions, response: res),
      );
    }
  }

  static String? _cursorOf(String? nextUrl) {
    if (nextUrl == null) return null;
    return Uri.tryParse(nextUrl)?.queryParameters['cursor'];
  }
}
