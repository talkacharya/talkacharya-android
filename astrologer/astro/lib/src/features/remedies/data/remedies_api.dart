import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

import '../../../core/constants/api_paths.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/util/json.dart';

/// A store product the astrologer can suggest as a remedy.
class RemedyProduct extends Equatable {
  const RemedyProduct({
    required this.id,
    required this.title,
    this.subtitle = '',
    this.image,
    this.priceFrom,
  });

  final String id;
  final String title;
  final String subtitle;
  final String? image;
  final double? priceFrom;

  factory RemedyProduct.fromJson(Map<String, dynamic> j) => RemedyProduct(
    id: '${j['id']}',
    title: j['title'] as String? ?? '',
    subtitle: j['subtitle'] as String? ?? '',
    image: j['image'] as String?,
    priceFrom: j['price_from'] == null ? null : toDouble(j['price_from']),
  );

  @override
  List<Object?> get props => [id, title, subtitle, image, priceFrom];
}

/// A remedy this astrologer suggested to a customer. [status] moves
/// `sent` → `viewed` → `purchased`, or to `expired` if never bought.
class RemedySuggestion extends Equatable {
  const RemedySuggestion({
    required this.id,
    required this.productTitle,
    required this.productImage,
    required this.customerName,
    required this.note,
    required this.status,
    required this.createdAt,
    required this.commissionPercent,
  });

  final String id;
  final String productTitle;
  final String? productImage;
  final String customerName;
  final String note;
  final String status;
  final DateTime? createdAt;

  /// The astrologer's share when the customer buys through the suggestion.
  final double commissionPercent;

  bool get purchased => status == 'purchased';

  factory RemedySuggestion.fromJson(Map<String, dynamic> j) {
    final product = j['product'] is Map
        ? (j['product'] as Map).cast<String, dynamic>()
        : const <String, dynamic>{};
    return RemedySuggestion(
      id: '${j['id']}',
      productTitle: product['title'] as String? ?? '',
      productImage: product['image'] as String?,
      customerName: j['customer_name'] as String? ?? '',
      note: j['note'] as String? ?? '',
      status: j['status'] as String? ?? 'sent',
      createdAt: DateTime.tryParse('${j['created_at']}'),
      commissionPercent: toDouble(j['commission_percent']),
    );
  }

  @override
  List<Object?> get props => [
    id,
    productTitle,
    productImage,
    customerName,
    note,
    status,
    createdAt,
    commissionPercent,
  ];
}

/// Suggesting store products to customers — `/astro/store/…`.
class RemediesApi {
  RemediesApi(this._dio);

  final Dio _dio;

  Future<List<RemedySuggestion>> suggestions() async {
    final res = (await _dio.get<dynamic>(
      ApiPaths.astroStoreRecommendations,
    )).ensureOk();
    return [
      for (final e in res.data as List? ?? const [])
        RemedySuggestion.fromJson((e as Map).cast<String, dynamic>()),
    ];
  }

  /// Published products matching [query] (the catalogue's best sellers when
  /// it is empty).
  Future<List<RemedyProduct>> products({String query = ''}) async {
    final res = (await _dio.get<Map<String, dynamic>>(
      ApiPaths.astroStoreProducts,
      queryParameters: {
        'limit': 30,
        if (query.trim().isNotEmpty) 'q': query.trim() else 'sort': 'popular',
      },
    )).ensureOk();
    return [
      for (final e in res.data?['results'] as List? ?? const [])
        RemedyProduct.fromJson((e as Map).cast<String, dynamic>()),
    ];
  }

  /// Suggests [productId] to the customer of [consultationId].
  Future<RemedySuggestion> suggest({
    required String consultationId,
    required String productId,
    String note = '',
  }) async {
    final res = (await _dio.post<Map<String, dynamic>>(
      ApiPaths.astroStoreRecommendations,
      data: {
        'consultation_id': consultationId,
        'product_id': productId,
        'note': note.trim(),
      },
    )).ensureOk();
    return RemedySuggestion.fromJson(res.data ?? const {});
  }
}
