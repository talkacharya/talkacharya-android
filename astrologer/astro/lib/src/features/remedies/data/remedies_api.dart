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

/// One date a pooja is being performed on, still open for booking.
class PoojaDate extends Equatable {
  const PoojaDate({
    required this.id,
    required this.product,
    required this.startsAt,
    required this.venue,
    required this.temple,
    required this.currency,
    required this.remaining,
  });

  final String id;
  final RemedyProduct product;
  final DateTime? startsAt;
  final String venue;
  final String temple;
  final String currency;

  /// Places left; null when the pooja takes any number.
  final int? remaining;

  factory PoojaDate.fromJson(Map<String, dynamic> j) {
    final p = (j['product'] as Map?)?.cast<String, dynamic>() ?? const {};
    return PoojaDate(
      id: '${j['id']}',
      product: RemedyProduct.fromJson(p),
      startsAt: DateTime.tryParse('${j['starts_at']}'),
      venue: j['venue'] as String? ?? '',
      temple: p['temple'] as String? ?? '',
      currency: p['currency'] as String? ?? 'INR',
      remaining: (j['remaining'] as num?)?.toInt(),
    );
  }

  @override
  List<Object?> get props => [id, product, startsAt, venue, remaining];
}

/// A pooja a customer booked on this astrologer's suggestion.
class PoojaBooking extends Equatable {
  const PoojaBooking({
    required this.id,
    required this.status,
    required this.customerName,
    required this.title,
    required this.package,
    required this.temple,
    required this.scheduledFor,
    required this.bookedAt,
  });

  final String id;

  /// `pending`, `confirmed`, `performed`, `proof_uploaded`, `completed` or
  /// `cancelled`.
  final String status;
  final String customerName;
  final String title;
  final String package;
  final String temple;
  final DateTime? scheduledFor;
  final DateTime? bookedAt;

  factory PoojaBooking.fromJson(Map<String, dynamic> j) => PoojaBooking(
    id: '${j['id']}',
    status: j['status'] as String? ?? 'confirmed',
    customerName: j['customer_name'] as String? ?? '',
    title: j['title'] as String? ?? '',
    package: j['package'] as String? ?? '',
    temple: j['temple'] as String? ?? '',
    scheduledFor: DateTime.tryParse('${j['scheduled_for']}'),
    bookedAt: DateTime.tryParse('${j['booked_at']}'),
  );

  @override
  List<Object?> get props => [id, status, customerName, title, scheduledFor];
}

/// A curated remedy from the library, to advise as it is or to edit first.
class RemedyTemplate extends Equatable {
  const RemedyTemplate({
    required this.id,
    required this.category,
    required this.title,
    required this.body,
    this.caution = '',
  });

  final String id;
  final String category;
  final String title;
  final String body;
  final String caution;

  factory RemedyTemplate.fromJson(Map<String, dynamic> j) => RemedyTemplate(
    id: '${j['id']}',
    category: j['category'] as String? ?? '',
    title: j['title'] as String? ?? '',
    body: j['body'] as String? ?? '',
    caution: j['caution'] as String? ?? '',
  );

  @override
  List<Object?> get props => [id, category, title, body, caution];
}

/// Free advice the astrologer gave a customer.
class RemedyAdvice extends Equatable {
  const RemedyAdvice({
    required this.id,
    required this.customerName,
    required this.category,
    required this.title,
    required this.body,
    required this.createdAt,
  });

  final String id;
  final String customerName;
  final String category;
  final String title;
  final String body;
  final DateTime? createdAt;

  factory RemedyAdvice.fromJson(Map<String, dynamic> j) => RemedyAdvice(
    id: '${j['id']}',
    customerName: j['customer_name'] as String? ?? '',
    category: j['category'] as String? ?? '',
    title: j['title'] as String? ?? '',
    body: j['body'] as String? ?? '',
    createdAt: DateTime.tryParse('${j['created_at']}'),
  );

  @override
  List<Object?> get props => [id, customerName, category, title, body];
}

/// Suggesting store products to customers — `/astro/store/…` — and advising
/// remedies that cost nothing.
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

  Future<List<PoojaDate>> poojaCalendar() async {
    final res = (await _dio.get<dynamic>(
      ApiPaths.astroPoojaCalendar,
    )).ensureOk();
    return [
      for (final e in res.data as List? ?? const [])
        PoojaDate.fromJson((e as Map).cast<String, dynamic>()),
    ];
  }

  Future<List<PoojaBooking>> poojaBookings() async {
    final res = (await _dio.get<dynamic>(
      ApiPaths.astroPoojaBookings,
    )).ensureOk();
    return [
      for (final e in res.data as List? ?? const [])
        PoojaBooking.fromJson((e as Map).cast<String, dynamic>()),
    ];
  }

  /// Library remedies in [category] that cost nothing to follow.
  Future<List<RemedyTemplate>> library({String? category}) async {
    final res = (await _dio.get<dynamic>(
      ApiPaths.astroRemedyLibrary,
      queryParameters: {'category': ?category},
    )).ensureOk();
    return [
      for (final e in res.data as List? ?? const [])
        RemedyTemplate.fromJson((e as Map).cast<String, dynamic>()),
    ];
  }

  Future<List<RemedyAdvice>> advice() async {
    final res = (await _dio.get<dynamic>(
      ApiPaths.astroRemedyAdvice,
    )).ensureOk();
    return [
      for (final e in res.data as List? ?? const [])
        RemedyAdvice.fromJson((e as Map).cast<String, dynamic>()),
    ];
  }

  /// Sends free advice to the customer of [consultationId], as a message in
  /// their chat.
  Future<RemedyAdvice> advise({
    required String consultationId,
    required String title,
    required String body,
    String? templateId,
    String category = '',
  }) async {
    final res = (await _dio.post<Map<String, dynamic>>(
      ApiPaths.astroRemedyAdvice,
      data: {
        'consultation_id': consultationId,
        'template_id': ?templateId,
        'category': category,
        'title': title.trim(),
        'body': body.trim(),
      },
    )).ensureOk();
    return RemedyAdvice.fromJson(res.data ?? const {});
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
