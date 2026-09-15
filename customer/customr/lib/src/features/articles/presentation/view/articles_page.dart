import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/api_error_l10n.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/brand_colors.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../../../shared/widgets/fade_slide_in.dart';
import '../../../../shared/widgets/pressable.dart';
import '../../../../shared/widgets/skeleton.dart';
import '../../data/models/article.dart';
import '../cubit/articles_cubit.dart';
import '../widgets/article_ui.dart';

/// "Read & learn" (`/articles`, `?category=` pre-selects).
class ArticlesPage extends StatefulWidget {
  const ArticlesPage({super.key});

  @override
  State<ArticlesPage> createState() => _ArticlesPageState();
}

class _ArticlesPageState extends State<ArticlesPage> {
  final _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    _scroll.addListener(() {
      if (_scroll.position.extentAfter < 600) {
        context.read<ArticlesCubit>().loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      backgroundColor: context.brand.canvas,
      appBar: AppBar(
        title: Text(l.articlesTitle),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(52),
          child: _CategoryBar(),
        ),
      ),
      body: BlocBuilder<ArticlesCubit, ArticlesState>(
        builder: (context, state) {
          final cubit = context.read<ArticlesCubit>();
          if (state.items.isEmpty) {
            return switch (state.status) {
              ArticlesStatus.loading => const _ListSkeleton(),
              ArticlesStatus.failed => ErrorView(
                message: localizedError(context, state.error),
                onRetry: cubit.load,
              ),
              ArticlesStatus.ready => EmptyState(
                icon: Icons.menu_book_rounded,
                title: l.articlesEmptyTitle,
                message: l.articlesEmptyBody,
              ),
            };
          }
          final rest = state.items.skip(1).toList();
          return RefreshIndicator(
            onRefresh: cubit.load,
            child: ListView(
              controller: _scroll,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
              children: [
                FadeSlideIn(
                  key: ValueKey('featured-${state.items.first.slug}'),
                  child: _FeaturedCard(article: state.items.first),
                ),
                const SizedBox(height: 14),
                for (var i = 0; i < rest.length; i++)
                  FadeSlideIn(
                    key: ValueKey(rest[i].slug),
                    delay: Duration(milliseconds: 40 * (i > 6 ? 6 : i)),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: ArticleRowTile(article: rest[i]),
                    ),
                  ),
                if (state.loadingMore)
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _CategoryBar extends StatelessWidget {
  const _CategoryBar();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final selected = context.select((ArticlesCubit c) => c.state.category);
    final cubit = context.read<ArticlesCubit>();
    final options = <(ArticleCategory?, String)>[
      (null, l.articlesAll),
      for (final c in ArticleCategory.values) (c, c.label(l)),
    ];
    return SizedBox(
      height: 52,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(16, 6, 16, 10),
        itemCount: options.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final (category, label) = options[i];
          final active = category == selected;
          final hue = category?.hue;
          final accent = hue?.end ?? Theme.of(context).colorScheme.primary;
          return Pressable(
            child: Material(
              color: active
                  ? accent.withValues(alpha: 0.14)
                  : Theme.of(context).colorScheme.surface,
              shape: StadiumBorder(
                side: BorderSide(
                  color: active ? accent : context.brand.hairline,
                ),
              ),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () => cubit.setCategory(category),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (category != null) ...[
                        Icon(
                          category.icon,
                          size: 15,
                          color: active ? accent : context.brand.inkMuted,
                        ),
                        const SizedBox(width: 6),
                      ],
                      Text(
                        label,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: active ? accent : context.brand.ink,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _FeaturedCard extends StatelessWidget {
  const _FeaturedCard({required this.article});
  final ArticleSummary article;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Pressable(
      child: GestureDetector(
        onTap: () => context.push(Routes.article(article.slug), extra: article),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: AspectRatio(
            aspectRatio: 4 / 3,
            child: Stack(
              fit: StackFit.expand,
              children: [
                ArticleCover(article: article, iconSize: 56),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0.35, 1],
                      colors: [Colors.transparent, Color(0xE6120A1F)],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ArticleCategoryPill(
                        category: article.category,
                        onDark: true,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        article.title,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        articleMeta(context, article),
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
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

/// Thumbnail + title row — used in the list and for related reads.
class ArticleRowTile extends StatelessWidget {
  const ArticleRowTile({
    required this.article,
    this.replace = false,
    super.key,
  });

  final ArticleSummary article;

  /// From inside a reader: swap the page rather than stacking readers.
  final bool replace;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hue = article.category.hue;
    return Pressable(
      child: Material(
        color: theme.colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: context.brand.hairline),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => replace
              ? context.pushReplacement(
                  Routes.article(article.slug),
                  extra: article,
                )
              : context.push(Routes.article(article.slug), extra: article),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: 88,
                    height: 88,
                    child: ArticleCover(article: article, iconSize: 28),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        article.category.label(context.l10n).toUpperCase(),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: hue.end,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        article.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          height: 1.25,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        articleMeta(context, article),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: context.brand.inkMuted,
                        ),
                      ),
                    ],
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

class _ListSkeleton extends StatelessWidget {
  const _ListSkeleton();

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        children: [
          const AspectRatio(aspectRatio: 4 / 3, child: SkeletonBox(radius: 22)),
          for (var i = 0; i < 4; i++)
            const Padding(
              padding: EdgeInsets.only(top: 12),
              child: Row(
                children: [
                  SkeletonBox(width: 88, height: 88, radius: 12),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SkeletonBox(width: 70, height: 10),
                        SizedBox(height: 8),
                        SkeletonBox(height: 14),
                        SizedBox(height: 6),
                        SkeletonBox(width: 140, height: 14),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
