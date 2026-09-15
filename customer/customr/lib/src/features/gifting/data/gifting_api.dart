import 'package:dio/dio.dart';

import '../../../core/constants/api_paths.dart';
import '../../../core/network/api_exception.dart';
import 'models/gift.dart';

/// Raised on `402` — the wallet can't cover the gift.
class GiftInsufficientBalance implements Exception {
  const GiftInsufficientBalance();
}

class SentGiftsPage {
  const SentGiftsPage({required this.items, this.nextCursor});
  final List<GiftTransaction> items;
  final String? nextCursor;
  bool get hasMore => nextCursor != null;
}

/// Transport for `/app/gifts`. Throws [ApiException] / [GiftInsufficientBalance].
class GiftingApi {
  GiftingApi(this._dio);

  final Dio _dio;

  Future<List<Gift>> catalog() async {
    try {
      final res = await _dio.get<dynamic>(ApiPaths.gifts);
      final data = res.data;
      final list = data is List
          ? data
          : (data is Map && data['results'] is List
                ? data['results'] as List
                : const []);
      return list
          .map((e) => Gift.fromJson((e as Map).cast<String, dynamic>()))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<GiftTransaction> send({
    required String gift,
    required int quantity,
    required GiftTarget target,
    required String idempotencyKey,
    String message = '',
  }) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        ApiPaths.giftsSend,
        data: {
          'gift': gift,
          'quantity': quantity,
          ...target.body,
          if (message.isNotEmpty) 'message': message,
          'idempotency_key': idempotencyKey,
        },
      );
      return GiftTransaction.fromJson(res.data ?? const {});
    } on DioException catch (e) {
      final err = ApiException.fromDio(e);
      if (err.statusCode == 402 || err.code == 'wallet.insufficient_balance') {
        throw const GiftInsufficientBalance();
      }
      throw err;
    }
  }

  Future<SentGiftsPage> sent({String? cursor}) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        ApiPaths.giftsSent,
        queryParameters: {'cursor': ?cursor},
      );
      final json = res.data ?? const {};
      final next = json['next'] as String?;
      return SentGiftsPage(
        items: (json['results'] as List<dynamic>? ?? const [])
            .map((e) => GiftTransaction.fromJson(e as Map<String, dynamic>))
            .toList(),
        nextCursor: next == null
            ? null
            : Uri.tryParse(next)?.queryParameters['cursor'],
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}
