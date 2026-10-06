import 'package:flutter/material.dart';
import 'package:talkacharya_ui/talkacharya_ui.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/performance_models.dart';

/// How the astrologer does with customers on the platform's welcome offer:
/// how many they took, how those rated them, and how many came back paying.
class PromoCard extends StatelessWidget {
  const PromoCard({required this.promo, super.key});

  final PromoStats promo;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final rating = promo.rating;
    return HueTile(
      hue: AstroPalette.money,
      radius: Radii.lg,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.perfPromoTitle,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            l.perfPromoBody,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _Figure(
                  value: '${promo.sessions}',
                  label: l.perfPromoSessions,
                ),
              ),
              Expanded(
                child: _Figure(
                  value: rating == null ? '—' : rating.toStringAsFixed(1),
                  label: l.perfPromoRating,
                ),
              ),
              Expanded(
                child: _Figure(
                  value: '${promo.repeatPercent.round()}%',
                  label: l.perfPromoRepeat(promo.returned, promo.customers),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Figure extends StatelessWidget {
  const _Figure({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
