import 'package:dio/dio.dart';

import '../../../core/constants/api_paths.dart';
import '../../../core/network/api_exception.dart';
import 'models/article.dart';

class ArticlesResult {
  const ArticlesResult({required this.items, this.nextCursor});
  final List<ArticleSummary> items;
  final String? nextCursor;
  bool get hasMore => nextCursor != null;
}

/// Transport for the public editorial API (`/content/articles`, `AllowAny`).
/// The backend localises titles and bodies from `Accept-Language`.
class ArticlesApi {
  ArticlesApi(this._dio);

  final Dio _dio;

  Future<ArticlesResult> list({
    ArticleCategory? category,
    String? cursor,
    int? pageSize,
  }) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        ApiPaths.articles,
        queryParameters: {
          'category': ?category?.name,
          'cursor': ?cursor,
          'page_size': ?pageSize,
        },
      );
      final json = res.data ?? const {};
      final next = json['next'] as String?;
      return ArticlesResult(
        items: (json['results'] as List<dynamic>? ?? const [])
            .map((e) => ArticleSummary.fromJson(e as Map<String, dynamic>))
            .toList(),
        nextCursor: next == null
            ? null
            : Uri.tryParse(next)?.queryParameters['cursor'],
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<Article> detail(String slug) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(ApiPaths.article(slug));
      return Article.fromJson(res.data ?? const {});
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}
