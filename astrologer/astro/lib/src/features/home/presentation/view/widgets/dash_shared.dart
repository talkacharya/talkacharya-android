import 'package:flutter/material.dart';

import '../../../../../core/l10n/l10n.dart';
import '../../../../../core/theme/astro_palette.dart';
import '../../../../../core/theme/brand_colors.dart';

export '../../../../../shared/widgets/hue_widgets.dart';
export '../../../../consultations/presentation/widgets/consultation_style.dart'
    show channelStyle;

/// Layout constants shared across dashboard sections (same values as the
/// customer home feed).
class DashGaps {
  const DashGaps._();

  static const double side = 20;
  static const double section = 18;
  static const EdgeInsets sidePad = EdgeInsets.symmetric(horizontal: side);
}

/// Section title with a gradient accent bar and an optional "See all" pill.
/// Port of the customer app's home `SectionHeader`.
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    required this.title,
    this.subtitle,
    this.onSeeAll,
    this.trailing,
    this.hue = AstroPalette.career,
    super.key,
  });

  final String title;
  final String? subtitle;
  final VoidCallback? onSeeAll;
  final Widget? trailing;
  final AstroHue hue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brand = context.brand;
    return Padding(
      padding: DashGaps.sidePad,
      child: Row(
        children: [
          Container(
            width: 4,
            height: subtitle == null ? 22 : 36,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              gradient: hue.linear(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: brand.inkMuted,
                    ),
                  ),
              ],
            ),
          ),
          if (onSeeAll != null)
            _SeeAllPill(hue: hue, onTap: onSeeAll!)
          else
            ?trailing,
        ],
      ),
    );
  }
}

class _SeeAllPill extends StatelessWidget {
  const _SeeAllPill({required this.hue, required this.onTap});

  final AstroHue hue;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final label = context.l10n.commonSeeAll;
    return Semantics(
      button: true,
      label: label,
      child: Material(
        color: hue.tint(0.12),
        shape: const StadiumBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 34, minWidth: 44),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 6, 6, 6),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: hue.end,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Icon(Icons.chevron_right_rounded, size: 18, color: hue.end),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Cross-fades between a section's states (skeleton → content → error).
/// Branches must differ in type or [Key]. Respects "reduce motion".
class SectionSwitcher extends StatelessWidget {
  const SectionSwitcher({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.maybeDisableAnimationsOf(context) ?? false) return child;
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 320),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeIn,
      // Keep the outgoing child from forcing extra height while it fades.
      layoutBuilder: (current, previous) => Stack(
        alignment: Alignment.topLeft,
        children: [
          ...previous.map((c) => Positioned(left: 0, right: 0, child: c)),
          ?current,
        ],
      ),
      transitionBuilder: (child, animation) =>
          FadeTransition(opacity: animation, child: child),
      child: child,
    );
  }
}

/// Compact inline "couldn't load · Retry" row for a failed section.
class SectionError extends StatelessWidget {
  const SectionError({required this.onRetry, super.key});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    return Padding(
      padding: DashGaps.sidePad,
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 6, 6, 6),
        decoration: BoxDecoration(
          color: brand.tint,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(Icons.cloud_off_rounded, size: 18, color: brand.inkMuted),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                l.dashLoadFailed,
                style: TextStyle(color: brand.inkMuted),
              ),
            ),
            TextButton(onPressed: onRetry, child: Text(l.commonRetry)),
          ],
        ),
      ),
    );
  }
}
