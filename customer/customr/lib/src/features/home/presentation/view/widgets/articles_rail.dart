import 'package:customr/src/core/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/router/routes.dart';
import '../../../../../core/theme/astro_palette.dart';
import '../../../../../core/theme/brand_colors.dart';
import '../../../../../shared/widgets/pressable.dart';
import '../../../../articles/data/models/article.dart';
import '../../../../articles/presentation/widgets/article_ui.dart';
import '../../cubit/home_cubit.dart';
import 'home_shared.dart';

/// "Read & learn" — the newest editorial articles (`/content/articles`).
/// Hidden when there's nothing published, so the feed never shows an empty rail.
class ArticlesRail extends StatelessWidget {
  const ArticlesRail({super.key});

  static const double _height = 236;

  @override
  Widget build(BuildContext context) {
    final articles = context.select((HomeCubit c) => c.state.articles);
    final items = articles.value ?? const <ArticleSummary>[];
    if (!articles.isLoading && items.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: context.l10n.articlesTitle,
          subtitle: context.l10n.articlesRailSubtitle,
          hue: AstroPalette.air,
          onSeeAll: () => context.push(Routes.articles),
        ),
        const SizedBox(height: 14),
        // Each face owns its height: the switcher lays the outgoing child out
        // unbounded vertically, which a horizontal list can't take.
        SectionSwitcher(
          child: items.isEmpty
              ? const _RailSkeleton(key: ValueKey('skeleton'))
              : SizedBox(
                  key: const ValueKey('items'),
                  height: _height,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.fromLTRB(
                      HomeGaps.side,
                      0,
                      HomeGaps.side,
                      12,
                    ),
                    itemCount: items.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 12),
                    itemBuilder: (context, i) => _Card(article: items[i]),
                  ),
                ),
        ),
      ],
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.article});
  final ArticleSummary article;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brand = context.brand;
    return Pressable(
      child: SizedBox(
        width: 230,
        child: Material(
          color: theme.colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: brand.hairline),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () =>
                context.push(Routes.article(article.slug), extra: article),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 118,
                  width: double.infinity,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ArticleCover(article: article),
                      Positioned(
                        left: 10,
                        top: 10,
                        child: ArticleCategoryPill(
                          category: article.category,
                          onDark: true,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          article.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            height: 1.25,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          articleMeta(context, article),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: brand.inkMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RailSkeleton extends StatelessWidget {
  const _RailSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ArticlesRail._height,
      child: HomeShimmer(
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            HomeGaps.side,
            0,
            HomeGaps.side,
            12,
          ),
          itemCount: 3,
          separatorBuilder: (_, _) => const SizedBox(width: 12),
          itemBuilder: (_, _) =>
              const SkeletonBox(width: 230, height: 224, radius: 20),
        ),
      ),
    );
  }
}
