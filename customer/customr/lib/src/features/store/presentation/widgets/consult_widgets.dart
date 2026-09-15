import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/astro_palette.dart';
import '../../../../core/theme/brand_colors.dart';
import '../../../../shared/widgets/hue_widgets.dart';
import '../../../../shared/widgets/pressable.dart';
import '../../data/models/consult.dart';
import '../../data/models/product.dart';
import 'store_ui.dart';

/// Colour + icon for a verdict.
({AstroHue hue, IconData icon}) verdictStyle(VerdictKind kind) =>
    switch (kind) {
      VerdictKind.suitable => (
        hue: AstroPalette.health,
        icon: Icons.check_circle_rounded,
      ),
      VerdictKind.notSuitable => (
        hue: AstroPalette.fire,
        icon: Icons.do_not_disturb_on_rounded,
      ),
      VerdictKind.alternative => (
        hue: AstroPalette.money,
        icon: Icons.swap_horiz_rounded,
      ),
    };

String verdictLabel(BuildContext context, VerdictKind kind) {
  final l = context.l10n;
  return switch (kind) {
    VerdictKind.suitable => l.storeVerdictSuitable,
    VerdictKind.notSuitable => l.storeVerdictNotSuitable,
    VerdictKind.alternative => l.storeVerdictAlternative,
  };
}

/// One-line status for a consult ("Waiting for advice", "Suitable — go ahead" …).
String consultStatusLine(BuildContext context, StoreConsult c) {
  final l = context.l10n;
  final v = c.verdict;
  if (v != null) return verdictLabel(context, v.kind);
  return switch (c.status) {
    ConsultStatus.cancelled => l.storeConsultCancelled,
    ConsultStatus.expired => l.storeConsultExpired,
    _ => c.callLive ? l.storeConsultCallLive : l.storeConsultAwaiting,
  };
}

/// Compact card: product + astrologer + verdict / status. Taps into the consult.
class ConsultSummaryCard extends StatelessWidget {
  const ConsultSummaryCard({required this.consult, super.key});
  final StoreConsult consult;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brand = context.brand;
    final c = consult;
    final v = c.verdict;
    final style = v == null ? null : verdictStyle(v.kind);
    return Pressable(
      child: Material(
        color: theme.colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: style?.hue.tint(0.3) ?? brand.hairline),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => context.push(Routes.storeConsult(c.id)),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                SizedBox(
                  width: 56,
                  height: 56,
                  child: StoreImage(
                    url: c.product?.image,
                    slug: c.product?.type ?? '',
                    radius: 14,
                    iconSize: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        c.product?.title ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        context.l10n.storeConsultWith(c.astrologerName),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: brand.inkMuted,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            style?.icon ?? Icons.hourglass_top_rounded,
                            size: 16,
                            color: style?.hue.end ?? brand.inkMuted,
                          ),
                          const SizedBox(width: 5),
                          Flexible(
                            child: Text(
                              consultStatusLine(context, c),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: style?.hue.end ?? brand.inkMuted,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: brand.inkMuted),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// The verdict itself, with the astrologer's note and a way to act on it.
class VerdictCard extends StatelessWidget {
  const VerdictCard({
    required this.consult,
    this.onBuyRecommended,
    this.onOpenAlternative,
    super.key,
  });

  final StoreConsult consult;
  final VoidCallback? onBuyRecommended;
  final ValueChanged<ProductCard>? onOpenAlternative;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final brand = context.brand;
    final v = consult.verdict;
    if (v == null) return const SizedBox.shrink();
    final style = verdictStyle(v.kind);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: style.hue.tint(0.32)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [style.hue.tint(0.14), theme.colorScheme.surface],
        ),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              HueAvatar(
                name: consult.astrologerName,
                url: consult.astrologerAvatar,
                hue: AstroPalette.forId(consult.astrologerId),
                size: 40,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l.storeVerdictFrom(consult.astrologerName),
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: brand.inkMuted,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(style.icon, size: 18, color: style.hue.end),
                        const SizedBox(width: 5),
                        Flexible(
                          child: Text(
                            verdictLabel(context, v.kind),
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: style.hue.end,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (v.note.trim().isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              '“${v.note.trim()}”',
              style: theme.textTheme.bodyMedium?.copyWith(
                height: 1.45,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
          if (v.kind == VerdictKind.alternative &&
              v.alternativeProduct != null) ...[
            const SizedBox(height: 12),
            _AlternativeRow(
              product: v.alternativeProduct!,
              onTap: () => onOpenAlternative?.call(v.alternativeProduct!),
            ),
          ],
          if (v.kind == VerdictKind.suitable && onBuyRecommended != null) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: onBuyRecommended,
                icon: const Icon(Icons.shopping_bag_rounded),
                label: Text(l.storeBuyRecommended),
                style: FilledButton.styleFrom(
                  backgroundColor: style.hue.end,
                  minimumSize: const Size.fromHeight(46),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _AlternativeRow extends StatelessWidget {
  const _AlternativeRow({required this.product, required this.onTap});
  final ProductCard product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(14),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              SizedBox(
                width: 48,
                height: 48,
                child: StoreImage(
                  url: product.image,
                  slug: product.type,
                  radius: 12,
                  iconSize: 20,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.storeSuggestedInstead,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: context.brand.inkMuted,
                      ),
                    ),
                    Text(
                      product.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              PriceTag(price: product.priceFrom),
              const Icon(Icons.chevron_right_rounded),
            ],
          ),
        ),
      ),
    );
  }
}

/// "Not sure? Talk to an astrologer first" — the entry to consult before buying.
class ConsultPrompt extends StatelessWidget {
  const ConsultPrompt({
    required this.required,
    required this.onConsult,
    this.waiting,
    super.key,
  });

  /// The purchase is locked until an astrologer recommends it.
  final bool required;
  final VoidCallback onConsult;

  /// A consult already in progress (call live / awaiting the verdict).
  final StoreConsult? waiting;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final w = waiting;
    return HueTile(
      hue: AstroPalette.career,
      padding: const EdgeInsets.all(14),
      onTap: w == null
          ? onConsult
          : () => w.callLive
                ? context.push(Routes.consultation(w.consultationId))
                : context.push(Routes.storeConsult(w.id)),
      child: Row(
        children: [
          const HueIcon(
            hue: AstroPalette.career,
            icon: Icons.videocam_rounded,
            size: 48,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  w == null
                      ? (required
                            ? l.storeConsultRequiredTitle
                            : l.storeConsultPromptTitle)
                      : consultStatusLine(context, w),
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  w == null
                      ? (required
                            ? l.storeConsultRequiredBody
                            : l.storeConsultPromptBody)
                      : l.storeConsultWith(w.astrologerName),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: context.brand.inkMuted,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Icon(Icons.chevron_right_rounded, color: AstroPalette.career.end),
        ],
      ),
    );
  }
}
