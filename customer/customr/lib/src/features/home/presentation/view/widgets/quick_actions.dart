import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/l10n/l10n.dart';
import '../../../../../core/router/routes.dart';
import '../../../../../core/theme/astro_palette.dart';
import '../../../../../core/theme/brand_colors.dart';
import '../../../../../shared/widgets/pressable.dart';
import 'home_shared.dart';

/// Floating dock of the four core tools, tucked up into the hero. Each tool owns a
/// colour family so the row reads as four distinct doors, not one brand hue.
class QuickActionsRow extends StatelessWidget {
  const QuickActionsRow({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    final actions = <_QuickAction>[
      _QuickAction(
        label: l.homeKundaliAction,
        hue: AstroPalette.money,
        image: 'assets/images/kundali.png',
        onTap: () => context.push(Routes.birthProfiles),
      ),
      _QuickAction(
        label: l.homeMatchingAction,
        hue: AstroPalette.love,
        svg: 'assets/svg/matching.svg',
        onTap: () => context.push(Routes.matchmaking),
      ),
      _QuickAction(
        label: l.homeHoroscopeAction,
        hue: AstroPalette.career,
        icon: Icons.auto_awesome_rounded,
        onTap: () => context.push(Routes.horoscope),
      ),
      _QuickAction(
        label: l.homeVastuAction,
        hue: AstroPalette.health,
        icon: Icons.home_work_rounded,
        onTap: () => context.go(Routes.astrologersWith(skill: 'vastu')),
      ),
    ];

    return Padding(
      padding: HomeGaps.sidePad,
      child: Container(
        padding: const EdgeInsets.fromLTRB(6, 14, 6, 12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(26),
          border: Border.all(color: brand.hairline),
          boxShadow: [
            BoxShadow(
              color: brand.cosmicStart.withValues(alpha: 0.16),
              blurRadius: 26,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Row(
          children: [
            for (final a in actions) Expanded(child: _QuickActionTile(a)),
          ],
        ),
      ),
    );
  }
}

class _QuickActionTile extends StatelessWidget {
  const _QuickActionTile(this.action);
  final _QuickAction action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final a = action;
    final Widget glyph = a.svg != null
        ? Padding(
            padding: const EdgeInsets.all(4),
            child: SvgPicture.asset(a.svg!),
          )
        : a.image != null
        ? Padding(
            padding: const EdgeInsets.all(5),
            child: ClipOval(child: Image.asset(a.image!, fit: BoxFit.cover)),
          )
        : Icon(a.icon, color: Colors.white, size: 28);

    return Pressable(
      child: InkWell(
        onTap: a.onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              HueIcon(hue: a.hue, size: 58, child: glyph),
              const SizedBox(height: 9),
              Text(
                a.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickAction {
  const _QuickAction({
    required this.label,
    required this.hue,
    required this.onTap,
    this.icon,
    this.svg,
    this.image,
  });

  final String label;
  final AstroHue hue;
  final VoidCallback onTap;
  final IconData? icon;
  final String? svg;
  final String? image;
}
