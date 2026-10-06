import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:talkacharya_ui/talkacharya_ui.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/network/friendly_error.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/util/time_format.dart';
import '../../../../shared/widgets/settings_widgets.dart';
import '../../../performance/presentation/widgets/perf_format.dart';
import '../../data/remedies_api.dart';

/// Label + colour for where a suggestion has got to.
({String label, Color color}) remedyStatusStyle(
  BuildContext context,
  String status,
) {
  final l = context.l10n;
  return switch (status) {
    'purchased' => (label: l.remedyStatusPurchased, color: BandColors.good),
    'viewed' => (label: l.remedyStatusViewed, color: AstroPalette.career.end),
    'expired' => (label: l.remedyStatusExpired, color: context.brand.inkMuted),
    _ => (label: l.remedyStatusSent, color: AstroPalette.money.end),
  };
}

/// Remedies the astrologer has suggested from the store, and what became of
/// each: sent, seen, bought. A purchase pays the astrologer a commission.
class RemediesPage extends StatefulWidget {
  const RemediesPage({super.key});

  @override
  State<RemediesPage> createState() => _RemediesPageState();
}

class _RemediesPageState extends State<RemediesPage> {
  List<RemedySuggestion>? _items;
  List<RemedyAdvice> _advice = const [];
  String? _error;

  /// Showing free advice instead of store suggestions.
  bool _free = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final items = await getIt<RemediesApi>().suggestions();
      // The free-advice list is the smaller half of the page: without it
      // the store suggestions still show.
      var advice = const <RemedyAdvice>[];
      try {
        advice = await getIt<RemediesApi>().advice();
      } catch (_) {}
      if (mounted) {
        setState(() {
          _items = items;
          _advice = advice;
          _error = null;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _error = friendlyError(e));
    }
  }

  Future<void> _suggest() async {
    final sent = await context.push<bool>(
      _free ? Routes.adviseRemedy() : Routes.suggestRemedy(),
    );
    if (sent == true) await _load();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final items = _items;

    final List<Widget> body;
    if (items == null && _error != null) {
      body = [
        Padding(
          padding: const EdgeInsets.only(top: 48),
          child: ErrorView(message: _error!, onRetry: _load),
        ),
      ];
    } else if (items == null) {
      body = const [_Skeleton()];
    } else if (_free) {
      body = _advice.isEmpty
          ? [
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: EmptyState(
                  icon: Icons.self_improvement_rounded,
                  hue: AstroPalette.career,
                  title: l.adviceEmptyTitle,
                  message: l.adviceEmptyBody,
                ),
              ),
            ]
          : [for (final a in _advice) _AdviceTile(advice: a)];
    } else if (items.isEmpty) {
      body = [
        Padding(
          padding: const EdgeInsets.only(top: 40),
          child: EmptyState(
            icon: Icons.spa_rounded,
            hue: AstroPalette.health,
            title: l.remediesEmptyTitle,
            message: l.remediesEmptyBody,
          ),
        ),
      ];
    } else {
      body = [
        _Summary(items: items),
        const SizedBox(height: 14),
        ...FadeSlideIn.list([
          for (final s in items) _SuggestionTile(suggestion: s),
        ], step: const Duration(milliseconds: 40)),
      ];
    }

    return SubPageScaffold(
      title: l.remediesTitle,
      subtitle: _free ? l.adviceListSubtitle : l.remediesSubtitle,
      onRefresh: _load,
      bottomBar: StickyActionBar(
        child: BusyButton(
          label: _free ? l.adviceTitle : l.remediesSuggest,
          icon: Icons.add_rounded,
          onPressed: _suggest,
        ),
      ),
      children: [
        SegmentedButton<bool>(
          showSelectedIcon: false,
          segments: [
            ButtonSegment(
              value: false,
              icon: const Icon(Icons.storefront_rounded),
              label: Text(l.remediesTabStore),
            ),
            ButtonSegment(
              value: true,
              icon: const Icon(Icons.self_improvement_rounded),
              label: Text(l.remediesTabFree),
            ),
          ],
          selected: {_free},
          onSelectionChanged: (s) => setState(() => _free = s.first),
        ),
        const SizedBox(height: 14),
        ...body,
      ],
    );
  }
}

class _AdviceTile extends StatelessWidget {
  const _AdviceTile({required this.advice});

  final RemedyAdvice advice;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    final theme = Theme.of(context);
    final a = advice;
    final name = a.customerName.trim().isEmpty
        ? l.winBackCustomer
        : a.customerName;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(Radii.md),
          border: Border.all(color: brand.hairline),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              a.title,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              l.remedyFor(name, TimeFormat.relative(l, a.createdAt)),
              style: theme.textTheme.bodySmall?.copyWith(color: brand.inkMuted),
            ),
            const SizedBox(height: 4),
            Text(
              a.body,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

/// How many went out, how many were bought, and the commission on offer.
class _Summary extends StatelessWidget {
  const _Summary({required this.items});

  final List<RemedySuggestion> items;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    const hue = AstroPalette.health;
    final bought = items.where((s) => s.purchased).length;
    final pct = items.first.commissionPercent;
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: hue.tint(0.10),
        borderRadius: BorderRadius.circular(Radii.md),
        border: Border.all(color: hue.tint(0.35)),
      ),
      child: Row(
        children: [
          const HueIcon(hue: hue, icon: Icons.spa_rounded),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.remediesSummary(items.length, bought),
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if (pct > 0)
                  Text(
                    l.remediesCommission(formatPercent(pct)),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: context.brand.inkMuted,
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

class _SuggestionTile extends StatelessWidget {
  const _SuggestionTile({required this.suggestion});

  final RemedySuggestion suggestion;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    final theme = Theme.of(context);
    final s = suggestion;
    final status = remedyStatusStyle(context, s.status);
    final name = s.customerName.trim().isEmpty
        ? l.winBackCustomer
        : s.customerName;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(Radii.md),
          border: Border.all(color: brand.hairline),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProductThumb(url: s.productImage),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    s.productTitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    l.remedyFor(name, TimeFormat.relative(l, s.createdAt)),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: brand.inkMuted,
                    ),
                  ),
                  if (s.note.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      s.note,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: status.color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      status.label,
                      style: TextStyle(
                        color: status.color,
                        fontSize: 11,
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
    );
  }
}

/// Square product image, or a leaf where there is none.
class ProductThumb extends StatelessWidget {
  const ProductThumb({required this.url, this.size = 56, super.key});

  final String? url;
  final double size;

  @override
  Widget build(BuildContext context) {
    const hue = AstroPalette.health;
    final fallback = ColoredBox(
      color: hue.tint(0.14),
      child: Icon(Icons.spa_rounded, color: hue.end, size: size * 0.42),
    );
    return ClipRRect(
      borderRadius: BorderRadius.circular(Radii.sm),
      child: SizedBox.square(
        dimension: size,
        child: url == null || url!.isEmpty
            ? fallback
            : Image.network(
                url!,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => fallback,
              ),
      ),
    );
  }
}

class _Skeleton extends StatelessWidget {
  const _Skeleton();

  @override
  Widget build(BuildContext context) {
    return const AppShimmer(
      child: Column(
        children: [
          SkeletonBox(height: 64, radius: 16),
          SizedBox(height: 14),
          SkeletonBox(height: 96, radius: 16),
          SizedBox(height: 10),
          SkeletonBox(height: 96, radius: 16),
        ],
      ),
    );
  }
}
