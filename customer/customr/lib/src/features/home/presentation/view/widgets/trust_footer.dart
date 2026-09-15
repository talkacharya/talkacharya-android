import 'package:flutter/material.dart';

import '../../../../../core/theme/astro_palette.dart';
import '../../../../../core/theme/brand_colors.dart';
import 'home_shared.dart';

/// Quiet reassurance at the end of the feed — three promises, each with its own
/// colour badge.
class TrustFooter extends StatelessWidget {
  const TrustFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brand = context.brand;
    final rows = <(IconData, AstroHue, String)>[
      (
        Icons.verified_user_rounded,
        AstroPalette.health,
        'Every astrologer is ID-verified before they go live',
      ),
      (
        Icons.lock_rounded,
        AstroPalette.career,
        '100% private & confidential consultations',
      ),
      (
        Icons.workspace_premium_rounded,
        AstroPalette.money,
        'Thousands of consultations every week',
      ),
    ];

    return Padding(
      padding: HomeGaps.sidePad,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: brand.hairline),
        ),
        child: Column(
          children: [
            for (var i = 0; i < rows.length; i++) ...[
              if (i > 0) Divider(height: 18, color: brand.hairline),
              Row(
                children: [
                  HueIcon(
                    hue: rows[i].$2,
                    icon: rows[i].$1,
                    size: 36,
                    iconSize: 18,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      rows[i].$3,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
