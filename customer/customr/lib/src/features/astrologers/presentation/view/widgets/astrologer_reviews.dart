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

/// What clients said, on an astrologer's profile: the latest well-rated,
/// written reviews, and the way to the rest of them.
class AstrologerReviewsCard extends StatelessWidget {
  const AstrologerReviewsCard({
    required this.astrologer,
    super.key,
  });

  final Astrologer astrologer;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final a = astrologer;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.brand.hairline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l.astroReviewsTitle,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              if (a.ratingCount > 0) ...[
                const Icon(Icons.star_rounded, size: 18, color: Color(0xFFF2A93B)),
                const SizedBox(width: 2),
                Text(
                  a.ratingAvg.toStringAsFixed(1),
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                const SizedBox(width: 4),
                Text(
                  '(${l.astroReviewsCount(a.ratingCount)})',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          for (final r in a.topReviews) ...[
            ReviewTile(review: r),
            if (r != a.topReviews.last)
              Divider(height: 20, color: context.brand.hairline),
          ],
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: TextButton(
              onPressed: () => context.push(Routes.astrologerReviews(a.id)),
              child: Text(l.astroReviewsSeeAll),
            ),
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
                  if (when != null) DateFormat.yMMMd(locale).format(when.toLocal()),
                ].join(' · '),
                style: muted,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(review.text, style: theme.textTheme.bodyMedium?.copyWith(height: 1.4)),
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
