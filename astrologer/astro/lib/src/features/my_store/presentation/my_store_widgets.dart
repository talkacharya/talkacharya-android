import 'package:flutter/material.dart';
import 'package:talkacharya_ui/talkacharya_ui.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/util/money.dart';
import '../data/my_store_models.dart';

/// Label and colour of a listing's state, as the astrologer reads it.
({String label, Color color, IconData icon}) listingStatus(
  BuildContext context,
  MyListing item,
) {
  final l = context.l10n;
  final brand = context.brand;
  if (item.hasChangesRequested) {
    return (
      label: l.msStatusChanges,
      color: const Color(0xFFD9480F),
      icon: Icons.edit_note_rounded,
    );
  }
  return switch (item.status) {
    'published' => (
      label: l.msStatusLive,
      color: brand.online,
      icon: Icons.check_circle_rounded,
    ),
    'in_review' => (
      label: l.msStatusInReview,
      color: AstroPalette.career.end,
      icon: Icons.hourglass_top_rounded,
    ),
    _ => (
      label: l.msStatusDraft,
      color: brand.inkMuted,
      icon: Icons.edit_rounded,
    ),
  };
}

String orderStatusLabel(AppLocalizations l, String status) => switch (status) {
  'awaiting_approval' => l.msOrderAwaiting,
  'confirmed' => l.msOrderNew,
  'processing' => l.msOrderPreparing,
  'shipped' => l.msOrderShipped,
  'delivered' => l.msOrderDelivered,
  'completed' => l.msOrderCompleted,
  'cancelled' => l.msOrderCancelled,
  'returned' => l.msOrderReturned,
  _ => status,
};

String bookingStatusLabel(AppLocalizations l, String status) =>
    switch (status) {
      'confirmed' => l.msBookingToDo,
      'performed' => l.msBookingPerformed,
      'proof_uploaded' => l.msBookingProofShared,
      'completed' => l.msBookingDone,
      'cancelled' => l.msBookingCancelled,
      _ => status,
    };

/// A small rounded label in [color].
class MsPill extends StatelessWidget {
  const MsPill({
    required this.label,
    required this.color,
    this.icon,
    super.key,
  });

  final String label;
  final Color color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(999),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
        ],
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 11,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    ),
  );
}

/// A listing's photo, or its type's icon on a tint when it has none yet.
class ListingThumb extends StatelessWidget {
  const ListingThumb({
    required this.url,
    required this.service,
    this.size = 64,
    super.key,
  });

  final String? url;
  final bool service;
  final double size;

  @override
  Widget build(BuildContext context) {
    final u = url;
    final hue = service ? AstroPalette.fire : AstroPalette.money;
    final fallback = HueIcon(
      hue: hue,
      icon: service ? Icons.temple_hindu_rounded : Icons.diamond_rounded,
      size: size,
      iconSize: size * 0.45,
    );
    if (u == null || u.isEmpty) return fallback;
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: SizedBox.square(
        dimension: size,
        child: Image.network(
          u,
          fit: BoxFit.cover,
          loadingBuilder: (_, child, progress) =>
              progress == null ? child : fallback,
          errorBuilder: (_, _, _) => fallback,
        ),
      ),
    );
  }
}

/// One of the astrologer's listings in their list.
class ListingCard extends StatelessWidget {
  const ListingCard({required this.item, required this.onTap, super.key});

  final MyListing item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final brand = context.brand;
    final s = listingStatus(context, item);
    final price = item.price;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Pressable(
        child: Material(
          color: theme.colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: BorderSide(color: brand.hairline),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListingThumb(url: item.cover, service: item.isService),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${item.typeName} · ${item.categoryName}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: brand.inkMuted,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Wrap(
                              spacing: 6,
                              runSpacing: 4,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                MsPill(
                                  label: s.label,
                                  color: s.color,
                                  icon: s.icon,
                                ),
                                if (item.outOfStock && item.isLive)
                                  MsPill(
                                    label: l.msOutOfStock,
                                    color: const Color(0xFFCC0C39),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            price == null
                                ? '—'
                                : Money.format(price, item.currency),
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          if (item.tracksStock)
                            Text(
                              l.msStockCount(item.stock ?? 0),
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: brand.inkMuted,
                              ),
                            ),
                          if (item.soldCount > 0)
                            Text(
                              l.msSoldCount(item.soldCount),
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: brand.online,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                  if (item.hasChangesRequested) ...[
                    const SizedBox(height: 10),
                    NoteBox(
                      title: l.msTeamSaid,
                      text: item.reviewNote,
                      color: const Color(0xFFD9480F),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A tinted box for a note from the team or a hint.
class NoteBox extends StatelessWidget {
  const NoteBox({
    required this.text,
    required this.color,
    this.title,
    this.icon = Icons.info_outline_rounded,
    super.key,
  });

  final String? title;
  final String text;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null)
                  Text(
                    title!,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                Text(
                  text,
                  style: theme.textTheme.bodySmall?.copyWith(height: 1.35),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
