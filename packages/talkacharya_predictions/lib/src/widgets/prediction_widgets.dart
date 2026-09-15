import 'package:flutter/material.dart';

import '../labels/prediction_labels.dart';
import '../models/prediction.dart';
import '../models/prediction_enums.dart';

/// Small status pill. [roleColor] maps `pending` / `done` / `warn` to the host
/// app's palette; defaults to sensible neutrals.
class PredictionStatusChip extends StatelessWidget {
  const PredictionStatusChip({
    required this.status,
    this.label,
    this.roleColor,
    super.key,
  });

  final PredictionStatus status;
  final String? label;
  final Color? Function(String role)? roleColor;

  @override
  Widget build(BuildContext context) {
    final role = PredictionLabels.statusRole(status);
    final Color fg =
        roleColor?.call(role) ??
        switch (role) {
          'done' => const Color(0xFF2C6B45),
          'warn' => const Color(0xFFB0691F),
          _ => const Color(0xFF5B5B62),
        };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(
        color: fg.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label ?? PredictionLabels.statusLabel(status),
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: fg),
      ),
    );
  }
}

/// A row/tile for a prediction in a list.
class PredictionCard extends StatelessWidget {
  const PredictionCard({
    required this.prediction,
    this.onTap,
    this.areaTitle,
    this.periodTitle,
    this.statusLabel,
    this.trailingDate,
    super.key,
  });

  final Prediction prediction;
  final VoidCallback? onTap;
  final String? areaTitle;
  final String? periodTitle;
  final String? statusLabel;
  final String? trailingDate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              CircleAvatar(
                radius: 19,
                backgroundColor: scheme.primaryContainer,
                child: Icon(
                  PredictionLabels.areaIcon(prediction.area),
                  size: 19,
                  color: scheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      areaTitle ?? PredictionLabels.areaTitle(prediction.area),
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      [
                        periodTitle ??
                            PredictionLabels.periodTitle(prediction.period),
                        if ((trailingDate ?? '').isNotEmpty) trailingDate,
                      ].whereType<String>().join(' · '),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              PredictionStatusChip(
                status: prediction.status,
                label: statusLabel,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The delivered forecast — a headline, the body, and a fixed disclaimer.
class PredictionBodyView extends StatelessWidget {
  const PredictionBodyView({
    required this.prediction,
    this.disclaimer,
    super.key,
  });

  final Prediction prediction;
  final String? disclaimer;

  static const _defaultDisclaimer =
      'Written for you by an astrologer from your birth chart, dasha and current '
      'transits. Astrology is guidance for reflection and planning — the choices '
      'and the outcome stay yours.';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (prediction.title.isNotEmpty) ...[
          Text(prediction.title, style: theme.textTheme.titleLarge),
          const SizedBox(height: 4),
        ],
        if (prediction.astrologerName.isNotEmpty)
          Text(
            'by ${prediction.astrologerName}',
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        const SizedBox(height: 14),
        SelectableText(
          prediction.body,
          style: const TextStyle(fontSize: 15, height: 1.55),
        ),
        const SizedBox(height: 18),
        Text(
          disclaimer ?? _defaultDisclaimer,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}

/// Credit balance as a pill with an optional "Buy" affordance.
class CreditBalancePill extends StatelessWidget {
  const CreditBalancePill({
    required this.balance,
    this.label,
    this.onBuy,
    super.key,
  });

  final int balance;
  final String? label;
  final VoidCallback? onBuy;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.confirmation_number_outlined, size: 16, color: scheme.primary),
          const SizedBox(width: 6),
          Text(
            label ?? '$balance credit${balance == 1 ? '' : 's'}',
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5),
          ),
          if (onBuy != null) ...[
            const SizedBox(width: 4),
            TextButton(
              onPressed: onBuy,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                minimumSize: const Size(0, 32),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text('Buy'),
            ),
          ],
        ],
      ),
    );
  }
}
