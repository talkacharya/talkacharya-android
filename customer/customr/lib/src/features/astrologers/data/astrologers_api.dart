import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

import '../../../core/constants/api_paths.dart';
import '../../../core/network/api_exception.dart';
import 'models/astrologer.dart';

/// One page of discovery results.
class AstrologerPage {
  const AstrologerPage({required this.items, this.nextCursor});
  final List<Astrologer> items;
  final String? nextCursor;
  bool get hasMore => nextCursor != null;
}

/// Filters for `GET /app/astrologers`. All optional; nulls are dropped.
class AstrologerQuery extends Equatable {
  const AstrologerQuery({
    this.skill,
    this.language,
    this.channel,
    this.minRating,
    this.minPrice,
    this.maxPrice,
    this.search,
    this.sort,
    this.following = false,
  });

  final String? skill;
  final String? language;
  final String? channel;
  final double? minRating;
  final num? minPrice;
  final num? maxPrice;
  final String? search;

  /// recommended | rating | experience | consultations | newest
  final String? sort;

  /// Only astrologers the signed-in user follows.
  final bool following;

  static const _unset = Object();

  AstrologerQuery copyWith({
    Object? skill = _unset,
    Object? language = _unset,
    Object? channel = _unset,
    Object? minRating = _unset,
    Object? minPrice = _unset,
    Object? maxPrice = _unset,
    Object? search = _unset,
    Object? sort = _unset,
    bool? following,
  }) {
    T pick<T>(Object? v, T current) => identical(v, _unset) ? current : v as T;
    return AstrologerQuery(
      skill: pick(skill, this.skill),
      language: pick(language, this.language),
      channel: pick(channel, this.channel),
      minRating: pick(minRating, this.minRating),
      minPrice: pick(minPrice, this.minPrice),
      maxPrice: pick(maxPrice, this.maxPrice),
      search: pick(search, this.search),
      sort: pick(sort, this.sort),
      following: following ?? this.following,
    );
  }

  @override
  List<Object?> get props => [
    skill,
    language,
    channel,
    minRating,
    minPrice,
    maxPrice,
    search,
    sort,
    following,
  ];

  Map<String, dynamic> toParams() => {
    'skill': ?skill,
    'language': ?language,
    'channel': ?channel,
    'min_rating': ?minRating,
    'min_price': ?minPrice,
    'max_price': ?maxPrice,
    'q': ?search,
    'sort': ?sort,
    if (following) 'following': '1',
  };
}

/// Transport for astrologer discovery. Throws [ApiException].
class AstrologersApi {
  AstrologersApi(this._dio);

  final Dio _dio;

  Future<AstrologerPage> list({
    AstrologerQuery query = const AstrologerQuery(),
    String? cursor,
  }) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        ApiPaths.astrologers,
        queryParameters: {...query.toParams(), 'cursor': ?cursor},
      );
      _raiseFor(res);
      final data = res.data ?? const {};
      final results = (data['results'] as List<dynamic>? ?? const [])
          .map((e) => Astrologer.fromJson(e as Map<String, dynamic>))
          .toList();
      return AstrologerPage(
        items: results,
        nextCursor: _cursorOf(data['next'] as String?),
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<Astrologer> detail(String id) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(ApiPaths.astrologer(id));
      _raiseFor(res);
      return Astrologer.fromJson(res.data ?? const {});
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
