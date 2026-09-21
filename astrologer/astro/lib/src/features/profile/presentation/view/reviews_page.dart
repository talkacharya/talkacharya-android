import 'package:flutter/material.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/astro_palette.dart';
import '../../../../core/theme/brand_colors.dart';
import '../../../../core/util/time_format.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../../../shared/widgets/fade_slide_in.dart';
import '../../../../shared/widgets/hue_widgets.dart';
import '../../../../shared/widgets/settings_widgets.dart';
import '../../data/profile_api.dart';
import '../../data/profile_models.dart';

enum ReviewFilter { all, unreplied, low, top }

/// Reviews matching [filter].
List<Review> filterReviews(List<Review> all, ReviewFilter filter) =>
    switch (filter) {
      ReviewFilter.all => all,
      ReviewFilter.unreplied =>
        all.where((r) => !r.hasReply && r.isPublished).toList(),
      ReviewFilter.low => all.where((r) => r.rating <= 3).toList(),
      ReviewFilter.top => all.where((r) => r.rating == 5).toList(),
    };

/// Rating summary, filters and the review list with public replies.
class ReviewsPage extends StatefulWidget {
  const ReviewsPage({super.key});
  @override
  State<ReviewsPage> createState() => _ReviewsPageState();
}

class _ReviewsPageState extends State<ReviewsPage> {
  final _api = getIt<ProfileApi>();
  List<Review> _reviews = const [];
  ReviewFilter _filter = ReviewFilter.all;
  bool _loading = true;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _failed = false);
    try {
      final rows = await _api.reviews();
      if (mounted) {
        setState(() {
          _reviews = rows;
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _loading = false;
          _failed = true;
        });
      }
    }
  }

  Future<void> _reply(Review r) async {
    final updated = await showModalBottomSheet<Review>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => _ReplySheet(review: r),
    );
    if (updated == null || !mounted) return;
    setState(() {
      _reviews = [
        for (final x in _reviews)
          if (x.id == r.id)
            (updated.id.isEmpty ? x.withReply(updated.reply) : updated)
          else
            x,
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final shown = filterReviews(_reviews, _filter);
    final published = _reviews.where((r) => r.isPublished).toList();

    return SubPageScaffold(
      title: l.dashActionReviews,
      onRefresh: _load,
      children: [
        if (_loading)
          const Padding(
            padding: EdgeInsets.all(48),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (_failed)
          ErrorView(message: l.commonLoadFailed, onRetry: _load)
        else if (_reviews.isEmpty)
          SizedBox(
            height: 380,
            child: EmptyState(
              icon: Icons.reviews_rounded,
              hue: AstroPalette.fire,
              title: l.reviewsEmptyTitle,
              message: l.reviewsEmptyBody,
            ),
          )
        else ...[
          _Summary(reviews: published),
          const SizedBox(height: 12),
          _Filters(
            value: _filter,
            unreplied: filterReviews(_reviews, ReviewFilter.unreplied).length,
            onChanged: (f) => setState(() => _filter = f),
          ),
          const SizedBox(height: 12),
          if (shown.isEmpty)
            Padding(
              padding: const EdgeInsets.all(32),
              child: Center(
                child: Text(
                  l.reviewsNoMatch,
                  style: TextStyle(color: context.brand.inkMuted),
                ),
              ),
            )
          else
            for (var i = 0; i < shown.length; i++)
              FadeSlideIn(
                key: ValueKey(shown[i].id),
                delay: Duration(milliseconds: 30 * i.clamp(0, 10)),
                child: _ReviewCard(
                  review: shown[i],
                  onReply: () => _reply(shown[i]),
                ),
              ),
        ],
      ],
    );
  }
}

class _Summary extends StatelessWidget {
  const _Summary({required this.reviews});

  final List<Review> reviews;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    final theme = Theme.of(context);
    final n = reviews.length;
    final avg = n == 0 ? 0.0 : reviews.fold<int>(0, (s, r) => s + r.rating) / n;
    final counts = {
      for (var s = 5; s >= 1; s--)
        s: reviews.where((r) => r.rating == s).length,
    };

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(Radii.lg),
        border: Border.all(color: brand.hairline),
        boxShadow: brand.shadowWarm,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Column(
              children: [
                Text(
                  avg.toStringAsFixed(1),
                  style: theme.textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                _Stars(rating: avg.round(), size: 16),
                const SizedBox(height: 4),
                Text(
                  l.reviewsBasedOn(n),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: brand.inkMuted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              children: [
                for (final MapEntry(key: star, value: count) in counts.entries)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 14,
                          child: Text(
                            '$star',
                            style: theme.textTheme.labelMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Icon(Icons.star_rounded, size: 12, color: brand.gold),
                        const SizedBox(width: 6),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(999),
                            child: TweenAnimationBuilder<double>(
                              tween: Tween(end: n == 0 ? 0 : count / n),
                              duration: const Duration(milliseconds: 600),
                              curve: Curves.easeOutCubic,
                              builder: (_, v, _) => LinearProgressIndicator(
                                value: v,
                                minHeight: 7,
                                color: AstroPalette.band(star).end,
                                backgroundColor: brand.sectionBg,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 28,
                          child: Text(
                            '$count',
                            textAlign: TextAlign.end,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: brand.inkMuted,
                            ),
                          ),
                        ),
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

class _Filters extends StatelessWidget {
  const _Filters({
    required this.value,
    required this.unreplied,
    required this.onChanged,
  });

  final ReviewFilter value;
  final int unreplied;
  final ValueChanged<ReviewFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final labels = {
      ReviewFilter.all: l.earnKindAll,
      ReviewFilter.unreplied: unreplied > 0
          ? '${l.reviewsFilterUnreplied} · $unreplied'
          : l.reviewsFilterUnreplied,
      ReviewFilter.low: l.reviewsFilterLow,
      ReviewFilter.top: l.reviewsFilterTop,
    };
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final MapEntry(key: f, value: label) in labels.entries)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                selected: f == value,
                showCheckmark: false,
                label: Text(label),
                labelStyle: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: f == value ? scheme.onPrimary : null,
                ),
                selectedColor: scheme.primary,
                onSelected: (_) => onChanged(f),
              ),
            ),
        ],
      ),
    );
  }
}

class _Stars extends StatelessWidget {
  const _Stars({required this.rating, this.size = 16});

  final int rating;
  final double size;

  @override
  Widget build(BuildContext context) {
    final gold = context.brand.gold;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 1; i <= 5; i++)
          Icon(
            i <= rating ? Icons.star_rounded : Icons.star_outline_rounded,
            size: size,
            color: gold,
          ),
      ],
    );
  }
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({required this.review, required this.onReply});

  final Review review;
  final VoidCallback onReply;

  @override
  Widget build(BuildContext context) {
    final r = review;
    final l = context.l10n;
    final brand = context.brand;
    final theme = Theme.of(context);
    final name = r.customerName.trim().isEmpty
        ? l.reviewsAnonymous
        : r.customerName;
    final statusLabel = switch (r.status) {
      'pending_moderation' => l.reviewsPending,
      'hidden' || 'removed' => l.reviewsHidden,
      _ => null,
    };

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  HueAvatar(
                    name: name,
                    hue: AstroPalette.forId(name),
                    size: 38,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Row(
                          children: [
                            _Stars(rating: r.rating, size: 14),
                            const SizedBox(width: 6),
                            Text(
                              TimeFormat.relative(l, r.createdAt),
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: brand.inkMuted,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (statusLabel != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AstroPalette.money.tint(0.14),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        statusLabel,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: AstroPalette.money.end,
                        ),
                      ),
                    ),
                ],
              ),
              if (r.text.isNotEmpty) ...[
                const SizedBox(height: 10),
                Text(
                  r.text,
                  style: theme.textTheme.bodyMedium?.copyWith(height: 1.4),
                ),
              ],
              if (r.helpfulCount > 0) ...[
                const SizedBox(height: 6),
                Text(
                  l.reviewsHelpful(r.helpfulCount),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: brand.inkMuted,
                  ),
                ),
              ],
              if (r.hasReply)
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: brand.tint,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(14),
                      bottomLeft: Radius.circular(14),
                      bottomRight: Radius.circular(14),
                      topLeft: Radius.circular(4),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l.reviewsYourReply,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: brand.onTint,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(r.reply),
                    ],
                  ),
                )
              else if (r.isPublished)
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: onReply,
                    icon: const Icon(Icons.reply_rounded, size: 18),
                    label: Text(l.reviewsReply),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReplySheet extends StatefulWidget {
  const _ReplySheet({required this.review});

  final Review review;

  @override
  State<_ReplySheet> createState() => _ReplySheetState();
}

class _ReplySheetState extends State<_ReplySheet> {
  final _text = TextEditingController();
  bool _busy = false;

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  Future<void> _post() async {
    final l = context.l10n;
    final text = _text.text.trim();
    if (text.isEmpty) return;
    setState(() => _busy = true);
    try {
      final updated = await getIt<ProfileApi>().replyToReview(
        widget.review.id,
        text,
      );
      if (mounted) {
        Navigator.pop(
          context,
          updated.hasReply ? updated : widget.review.withReply(text),
        );
      }
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _busy = false);
      showToast(context, e.isNetwork ? l.reviewsReplyFailed : e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final r = widget.review;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        0,
        20,
        16 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l.reviewsReply, style: Theme.of(context).textTheme.titleLarge),
          if (r.text.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              '“${r.text}”',
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: context.brand.inkMuted,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
          const SizedBox(height: 12),
          TextField(
            controller: _text,
            autofocus: true,
            minLines: 3,
            maxLines: 6,
            maxLength: 1000,
            textCapitalization: TextCapitalization.sentences,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(hintText: l.reviewsReplyHint),
          ),
          const SizedBox(height: 8),
          BusyButton(
            label: l.reviewsPost,
            icon: Icons.send_rounded,
            busy: _busy,
            onPressed: _text.text.trim().isEmpty ? null : _post,
          ),
        ],
      ),
    );
  }
}
