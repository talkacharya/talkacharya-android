import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:talkacharya_ui/talkacharya_ui.dart';

import '../../../../../core/l10n/l10n.dart';
import '../../../../../core/network/friendly_error.dart';
import '../../../../../core/router/routes.dart';
import '../../../data/astrologers_repository.dart';
import '../../../data/models/astrologer.dart';

/// What clients said, on an astrologer's profile: the overall rating with how
/// many gave each number of stars, the latest well-rated written reviews, and
/// the way to the rest. Shown even before the first review, so the section is
/// always where a customer looks for it.
class AstrologerReviewsCard extends StatelessWidget {
  const AstrologerReviewsCard({required this.astrologer, super.key});

  final Astrologer astrologer;

  static const _star = Color(0xFFF2A93B);

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final brand = context.brand;
    final a = astrologer;
    final total = a.ratingBreakdown.values.fold<int>(0, (s, n) => s + n);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: brand.hairline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.astroReviewsTitle,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          if (a.ratingCount == 0)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  const HueIcon(
                    hue: AstroPalette.money,
                    icon: Icons.star_outline_rounded,
                    size: 40,
                    iconSize: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      l.astroReviewsNone,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: brand.inkMuted,
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
            )
          else ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 96,
                  child: Column(
                    children: [
                      Text(
                        a.ratingAvg.toStringAsFixed(1),
                        style: theme.textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          height: 1,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (var i = 1; i <= 5; i++)
                            Icon(
                              i <= a.ratingAvg.round()
                                  ? Icons.star_rounded
                                  : Icons.star_outline_rounded,
                              size: 14,
                              color: _star,
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l.astroReviewsCount(a.ratingCount),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: brand.inkMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                if (total > 0)
                  Expanded(
                    child: Column(
                      children: [
                        for (var stars = 5; stars >= 1; stars--)
                          _BreakdownBar(
                            stars: stars,
                            count: a.ratingBreakdown['$stars'] ?? 0,
                            total: total,
                          ),
                      ],
                    ),
                  ),
              ],
            ),
            if (a.topReviews.isNotEmpty) ...[
              Divider(height: 28, color: brand.hairline),
              for (final r in a.topReviews) ...[
                ReviewTile(review: r),
                if (r != a.topReviews.last)
                  Divider(height: 20, color: brand.hairline),
              ],
            ],
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: TextButton(
                onPressed: () => context.push(Routes.astrologerReviews(a.id)),
                child: Text(l.astroReviewsSeeAll),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// One row of the breakdown: "5 ★", a bar for its share, and the count.
class _BreakdownBar extends StatelessWidget {
  const _BreakdownBar({
    required this.stars,
    required this.count,
    required this.total,
  });

  final int stars;
  final int count;
  final int total;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brand = context.brand;
    final muted = theme.textTheme.labelSmall?.copyWith(color: brand.inkMuted);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(width: 10, child: Text('$stars', style: muted)),
          const Icon(
            Icons.star_rounded,
            size: 12,
            color: AstrologerReviewsCard._star,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(99),
              child: LinearProgressIndicator(
                value: total == 0 ? 0 : count / total,
                minHeight: 6,
                backgroundColor: brand.hairline,
                color: AstrologerReviewsCard._star,
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 28,
            child: Text('$count', style: muted, textAlign: TextAlign.end),
          ),
        ],
      ),
    );
  }
}

/// One review: stars, what they wrote, who and when, and the astrologer's reply.
class ReviewTile extends StatelessWidget {
  const ReviewTile({required this.review, super.key});

  final AstrologerReview review;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final muted = theme.textTheme.bodySmall?.copyWith(
      color: context.brand.inkMuted,
    );
    final when = review.createdAt;
    final locale = Localizations.localeOf(context).toLanguageTag();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            for (var i = 1; i <= 5; i++)
              Icon(
                i <= review.rating
                    ? Icons.star_rounded
                    : Icons.star_outline_rounded,
                size: 16,
                color: const Color(0xFFF2A93B),
              ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                [
                  if (review.customerName.isNotEmpty) review.customerName,
                  if (when != null)
                    DateFormat.yMMMd(locale).format(when.toLocal()),
                ].join(' · '),
                style: muted,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          review.text,
          style: theme.textTheme.bodyMedium?.copyWith(height: 1.4),
        ),
        if (review.astrologerReply.isNotEmpty) ...[
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withValues(
                alpha: 0.5,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.astroReviewReply,
                  style: muted?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 2),
                Text(review.astrologerReply, style: theme.textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

/// Every well-rated, written review of one astrologer, newest first.
class AstrologerReviewsPage extends StatefulWidget {
  const AstrologerReviewsPage({required this.astrologerId, super.key});

  final String astrologerId;

  @override
  State<AstrologerReviewsPage> createState() => _AstrologerReviewsPageState();
}

class _AstrologerReviewsPageState extends State<AstrologerReviewsPage> {
  final _items = <AstrologerReview>[];
  String? _cursor;
  bool _loading = false;
  bool _done = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _more();
  }

  Future<void> _more() async {
    if (_loading || _done) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final page = await GetIt.I<AstrologersRepository>().positiveReviews(
        widget.astrologerId,
        cursor: _cursor,
      );
      if (!mounted) return;
      setState(() {
        _items.addAll(page.items);
        _cursor = page.nextCursor;
        _done = page.nextCursor == null;
      });
    } catch (e) {
      if (mounted) setState(() => _error = friendlyError(e));
    }
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l.astroReviewsTitle)),
      body: NotificationListener<ScrollNotification>(
        onNotification: (n) {
          if (n.metrics.pixels > n.metrics.maxScrollExtent - 300) _more();
          return false;
        },
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
          itemCount: _items.length + 1,
          separatorBuilder: (_, _) =>
              Divider(height: 24, color: context.brand.hairline),
          itemBuilder: (context, i) {
            if (i < _items.length) return ReviewTile(review: _items[i]);
            if (_error != null) {
              return ErrorView(message: _error!, onRetry: _more);
            }
            if (_loading) {
              return const Padding(
                padding: EdgeInsets.all(24),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            if (_items.isEmpty) {
              return Padding(
                padding: const EdgeInsets.only(top: 48),
                child: Center(child: Text(l.astroReviewsEmpty)),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
