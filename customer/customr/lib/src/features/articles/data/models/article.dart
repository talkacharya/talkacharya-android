import 'package:equatable/equatable.dart';

/// Backend `ArticleCategory`.
enum ArticleCategory {
  astrology,
  horoscope,
  festivals,
  remedies,
  guides,
  news;

  static ArticleCategory parse(String? s) => ArticleCategory.values.firstWhere(
    (c) => c.name == s,
    orElse: () => ArticleCategory.guides,
  );
}

/// A published article as listed (`GET /content/articles`).
class ArticleSummary extends Equatable {
  const ArticleSummary({
    required this.slug,
    required this.title,
    this.id = '',
    this.excerpt = '',
    this.category = ArticleCategory.guides,
    this.heroImage,
    this.publishedAt,
    this.readingMinutes = 1,
    this.authorName = '',
  });

  final String id;
  final String slug;
  final String title;
  final String excerpt;
  final ArticleCategory category;
  final String? heroImage;
  final DateTime? publishedAt;
  final int readingMinutes;
  final String authorName;

  bool get hasImage => heroImage != null && heroImage!.isNotEmpty;

  factory ArticleSummary.fromJson(Map<String, dynamic> j) => ArticleSummary(
    id: '${j['id'] ?? ''}',
    slug: '${j['slug'] ?? ''}',
    title: '${j['title'] ?? ''}',
    excerpt: '${j['excerpt'] ?? ''}',
    category: ArticleCategory.parse(j['category'] as String?),
    heroImage: (j['hero_image'] as String?)?.trim(),
    publishedAt: DateTime.tryParse('${j['published_at']}'),
    readingMinutes: (j['reading_minutes'] as num?)?.toInt() ?? 1,
    authorName: '${j['author_name'] ?? ''}',
  );

  @override
  List<Object?> get props => [slug, title, category, heroImage, publishedAt];
}

/// One article to read (`GET /content/articles/{slug}`) — markdown body plus
/// a few related reads.
class Article extends Equatable {
  const Article({
    required this.summary,
    this.body = '',
    this.related = const [],
  });

  final ArticleSummary summary;

  /// Markdown.
  final String body;
  final List<ArticleSummary> related;

  factory Article.fromJson(Map<String, dynamic> j) => Article(
    summary: ArticleSummary.fromJson(j),
    body: '${j['body'] ?? ''}',
    related: [
      for (final r in (j['related'] as List<dynamic>? ?? const []))
        if (r is Map) ArticleSummary.fromJson(r.cast<String, dynamic>()),
    ],
  );

  @override
  List<Object?> get props => [summary, body, related];
}
