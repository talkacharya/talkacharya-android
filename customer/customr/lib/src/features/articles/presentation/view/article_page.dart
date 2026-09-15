import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/l10n/api_error_l10n.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/brand_colors.dart';
import '../../../../core/util/async_value.dart';
import '../../../../shared/widgets/cosmic.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../../../shared/widgets/fade_slide_in.dart';
import '../../../../shared/widgets/pressable.dart';
import '../../../../shared/widgets/skeleton.dart';
import '../../data/models/article.dart';
import '../cubit/article_cubit.dart';
import '../widgets/article_ui.dart';
import '../widgets/markdown_view.dart';
import 'articles_page.dart' show ArticleRowTile;

/// The reader (`/articles/:slug`, deep link `talkacharya://articles/{slug}`).
/// A [preview] from the list paints the header while the body loads.
class ArticlePage extends StatelessWidget {
  const ArticlePage({this.preview, super.key});

  final ArticleSummary? preview;

  /// Public web address used when sharing.
  static String shareUrl(String slug) =>
      'https://talkacharya.com/articles/$slug';

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: context.brand.canvas,
        body: BlocBuilder<ArticleCubit, AsyncValue<Article>>(
          builder: (context, state) {
            final article = state.value;
            final summary = article?.summary ?? preview;
            if (summary == null) {
              return _Chrome(
                child: state.isError
                    ? ErrorView(
                        message: localizedError(context, state.error),
                        onRetry: () => context.read<ArticleCubit>().load(),
                      )
                    : const Center(child: CircularProgressIndicator()),
              );
            }
            return RefreshIndicator(
              edgeOffset: 80,
              onRefresh: () => context.read<ArticleCubit>().load(),
              child: CustomScrollView(
                slivers: [
                  _Header(summary: summary),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 48),
                    sliver: SliverList.list(
                      children: [
                        _TitleBlock(summary: summary),
                        const SizedBox(height: 18),
                        if (article != null)
                          FadeSlideIn(
                            child: MarkdownView(
                              data: article.body,
                              accent: summary.category.hue,
                            ),
                          )
                        else if (state.isError)
                          _InlineError(
                            message: localizedError(context, state.error),
                          )
                        else
                          const _BodySkeleton(),
                        if (article != null) ...[
                          const SizedBox(height: 12),
                          const _AskCta(),
                          if (article.related.isNotEmpty) ...[
                            const SizedBox(height: 28),
                            Text(
                              context.l10n.articleMoreToRead,
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 12),
                            for (final r in article.related)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: ArticleRowTile(
                                  article: r,
                                  replace: true,
                                ),
                              ),
                          ],
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.summary});
  final ArticleSummary summary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SliverAppBar(
      pinned: true,
      expandedHeight: 250,
      backgroundColor: context.brand.cosmicStart,
      foregroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      actions: [
        IconButton(
          tooltip: context.l10n.articleShare,
          icon: const Icon(Icons.ios_share_rounded),
          onPressed: () => Share.share(
            '${summary.title}\n${ArticlePage.shareUrl(summary.slug)}',
          ),
        ),
      ],
      flexibleSpace: LayoutBuilder(
        builder: (context, box) {
          final top = MediaQuery.paddingOf(context).top;
          final collapsed = box.maxHeight <= top + kToolbarHeight + 20;
          return FlexibleSpaceBar(
            collapseMode: CollapseMode.parallax,
            titlePadding: const EdgeInsetsDirectional.only(
              start: 56,
              end: 56,
              bottom: 16,
            ),
            title: AnimatedOpacity(
              duration: const Duration(milliseconds: 160),
              opacity: collapsed ? 1 : 0,
              child: Text(
                summary.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            background: Stack(
              fit: StackFit.expand,
              children: [
                ArticleCover(article: summary, iconSize: 64),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0x99120A1F),
                        Colors.transparent,
                        Color(0x66120A1F),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _TitleBlock extends StatelessWidget {
  const _TitleBlock({required this.summary});
  final ArticleSummary summary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brand = context.brand;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ArticleCategoryPill(category: summary.category),
        const SizedBox(height: 10),
        Text(
          summary.title,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Icon(Icons.schedule_rounded, size: 15, color: brand.inkMuted),
            const SizedBox(width: 5),
            Expanded(
              child: Text(
                [
                  if (summary.authorName.isNotEmpty) summary.authorName,
                  articleMeta(context, summary),
                ].join(' · '),
                style: theme.textTheme.labelMedium?.copyWith(
                  color: brand.inkMuted,
                ),
              ),
            ),
          ],
        ),
        if (summary.excerpt.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(
            summary.excerpt,
            style: theme.textTheme.titleMedium?.copyWith(
              color: brand.inkMuted,
              height: 1.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
        const SizedBox(height: 16),
        Divider(height: 1, color: brand.hairline),
      ],
    );
  }
}

/// "Want guidance for your own chart?" → discovery. The one conversion
/// surface on a reading page, so it sits after the body, never inside it.
class _AskCta extends StatelessWidget {
  const _AskCta();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final brand = context.brand;
    return Pressable(
      child: GestureDetector(
        onTap: () => context.go(Routes.astrologers),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              const Positioned.fill(child: CosmicBackdrop()),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 16, 14, 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l.articleAskTitle,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: brand.onCosmic,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            l.articleAskBody,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: brand.onCosmicMuted,
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: BrandColors.goldGradient,
                        ),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        l.articleAskCta,
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: const Color(0xFF3A1703),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BodySkeleton extends StatelessWidget {
  const _BodySkeleton();

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < 9; i++) ...[
            SkeletonBox(width: i % 4 == 3 ? 180 : null, height: 13),
            SizedBox(height: i % 4 == 3 ? 22 : 10),
          ],
        ],
      ),
    );
  }
}

class _InlineError extends StatelessWidget {
  const _InlineError({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.cloud_off_rounded, color: context.brand.inkMuted),
        const SizedBox(width: 10),
        Expanded(child: Text(message)),
        TextButton(
          onPressed: () => context.read<ArticleCubit>().load(),
          child: Text(context.l10n.commonRetry),
        ),
      ],
    );
  }
}

class _Chrome extends StatelessWidget {
  const _Chrome({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          backgroundColor: context.brand.cosmicStart,
          foregroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          systemOverlayStyle: SystemUiOverlayStyle.light,
          flexibleSpace: const CosmicBackdrop(),
          title: Text(
            context.l10n.articlesTitle,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: Colors.white),
          ),
        ),
        SliverFillRemaining(hasScrollBody: false, child: child),
      ],
    );
  }
}
