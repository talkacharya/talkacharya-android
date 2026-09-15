import 'articles_api.dart';
import 'models/article.dart';

class ArticlesRepository {
  ArticlesRepository(this._api);

  final ArticlesApi _api;

  /// Articles opened this session — re-opening one (or going back from a
  /// related read) is instant, and a refresh still hits the network.
  final _read = <String, Article>{};

  Future<ArticlesResult> list({ArticleCategory? category, String? cursor}) =>
      _api.list(category: category, cursor: cursor);

  /// Newest few, for the home rail.
  Future<List<ArticleSummary>> latest({int count = 5}) async =>
      (await _api.list(pageSize: count)).items;

  Article? cached(String slug) => _read[slug];

  Future<Article> detail(String slug) async =>
      _read[slug] = await _api.detail(slug);
}
