import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/astro_palette.dart';
import '../../../../core/theme/brand_colors.dart';

/// Label for a backend `verification_level`.
String verificationLabel(AppLocalizations l, String level) => switch (level) {
  'verified' => l.verifVerified,
  'featured' => l.verifFeatured,
  'documents_submitted' => l.verifSubmitted,
  _ => l.verifUnverified,
};

/// Explanation shown on the KYC page.
String verificationHint(AppLocalizations l, String level) => switch (level) {
  'verified' || 'featured' => l.verifVerifiedHint,
  'documents_submitted' => l.verifSubmittedHint,
  _ => l.verifUnverifiedHint,
};

({IconData icon, Color color}) verificationStyle(
  BuildContext context,
  String level,
) {
  final brand = context.brand;
  return switch (level) {
    'verified' => (icon: Icons.verified_rounded, color: brand.online),
    'featured' => (
      icon: Icons.workspace_premium_rounded,
      color: brand.glowAccent,
    ),
    'documents_submitted' => (
      icon: Icons.hourglass_top_rounded,
      color: AstroPalette.money.end,
    ),
    _ => (icon: Icons.shield_outlined, color: brand.inkMuted),
  };
}

/// Pill showing the verification level. [onDark] for cosmic surfaces.
class VerificationBadge extends StatelessWidget {
  const VerificationBadge({
    required this.level,
    this.onDark = false,
    super.key,
  });

  final String level;
  final bool onDark;

  @override
  Widget build(BuildContext context) {
    final s = verificationStyle(context, level);
    final color = onDark && level == 'unverified'
        ? context.brand.onCosmicMuted
        : s.color;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: onDark
            ? Colors.white.withValues(alpha: 0.12)
            : color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(s.icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            verificationLabel(context.l10n, level),
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
