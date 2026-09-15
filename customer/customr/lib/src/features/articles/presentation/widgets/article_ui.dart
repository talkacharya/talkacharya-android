import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/astro_palette.dart';
import '../../../../core/theme/brand_colors.dart';
import '../../../../shared/widgets/cosmic.dart';
import '../../data/models/article.dart';

/// Label, icon and colour per category — shared by the rail, list and reader.
extension ArticleCategoryUi on ArticleCategory {
  String label(AppLocalizations l) => switch (this) {
    ArticleCategory.astrology => l.articleCatAstrology,
    ArticleCategory.horoscope => l.articleCatHoroscope,
    ArticleCategory.festivals => l.articleCatFestivals,
    ArticleCategory.remedies => l.articleCatRemedies,
    ArticleCategory.guides => l.articleCatGuides,
    ArticleCategory.news => l.articleCatNews,
  };

  IconData get icon => switch (this) {
    ArticleCategory.astrology => Icons.auto_awesome_rounded,
    ArticleCategory.horoscope => Icons.brightness_4_rounded,
    ArticleCategory.festivals => Icons.celebration_rounded,
    ArticleCategory.remedies => Icons.spa_rounded,
    ArticleCategory.guides => Icons.menu_book_rounded,
    ArticleCategory.news => Icons.newspaper_rounded,
  };

  AstroHue get hue => switch (this) {
    ArticleCategory.astrology => AstroPalette.air,
    ArticleCategory.horoscope => AstroPalette.career,
    ArticleCategory.festivals => AstroPalette.fire,
    ArticleCategory.remedies => AstroPalette.health,
    ArticleCategory.guides => AstroPalette.money,
    ArticleCategory.news => AstroPalette.love,
  };
}

/// "5 min read · 12 Sep 2026".
String articleMeta(BuildContext context, ArticleSummary a) {
  final l = context.l10n;
  final locale = Localizations.localeOf(context).toLanguageTag();
  return [
    l.articleMinRead(a.readingMinutes),
    if (a.publishedAt != null)
      DateFormat('d MMM yyyy', locale).format(a.publishedAt!.toLocal()),
  ].join(' · ');
}

/// The article's hero photo, or — when there is none — a cosmic panel with
/// the category glyph, so a card never shows an empty grey box.
class ArticleCover extends StatelessWidget {
  const ArticleCover({required this.article, this.iconSize = 34, super.key});

  final ArticleSummary article;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final fallback = _Fallback(category: article.category, iconSize: iconSize);
    if (!article.hasImage) return fallback;
    return CachedNetworkImage(
      imageUrl: article.heroImage!,
      fit: BoxFit.cover,
      placeholder: (_, _) => ColoredBox(color: context.brand.shimmerBase),
      errorWidget: (_, _, _) => fallback,
    );
  }
}

class _Fallback extends StatelessWidget {
  const _Fallback({required this.category, required this.iconSize});

  final ArticleCategory category;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final hue = category.hue;
    return Stack(
      fit: StackFit.expand,
      children: [
        const CosmicBackdrop(),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: [hue.start.withValues(alpha: 0.35), Colors.transparent],
            ),
          ),
        ),
        Center(
          child: Icon(
            category.icon,
            size: iconSize,
            color: Colors.white.withValues(alpha: 0.9),
          ),
        ),
      ],
    );
  }
}

/// Small tinted category pill.
class ArticleCategoryPill extends StatelessWidget {
  const ArticleCategoryPill({
    required this.category,
    this.onDark = false,
    super.key,
  });

  final ArticleCategory category;

  /// On a photo / cosmic surface: frosted white instead of the hue tint.
  final bool onDark;

  @override
  Widget build(BuildContext context) {
    final hue = category.hue;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: onDark ? Colors.black.withValues(alpha: 0.35) : hue.tint(0.13),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(category.icon, size: 12, color: onDark ? Colors.white : hue.end),
          const SizedBox(width: 4),
          Text(
            category.label(context.l10n),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: onDark ? Colors.white : hue.end,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
