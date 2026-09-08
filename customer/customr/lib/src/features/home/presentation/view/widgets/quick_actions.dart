import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/router/routes.dart';
import '../../../../../core/theme/brand_colors.dart';
import 'home_shared.dart';

class QuickActionsRow extends StatelessWidget {
  const QuickActionsRow({super.key});

  @override
  Widget build(BuildContext context) {
    final actions = [
      _QuickAction(
        label: 'Kundali',
        icon: Icons.grid_on_rounded,
        onTap: () => context.push(Routes.birthProfiles),
      ),
      _QuickAction(
        label: 'Matching',
        icon: Icons.favorite_rounded,
        isComingSoon: true,
      ),
      _QuickAction(
        label: 'Horoscope',
        icon: Icons.auto_awesome_rounded,
        isComingSoon: true,
      ),
      _QuickAction(
        label: 'Vastu',
        icon: Icons.home_work_rounded,
        isComingSoon: true,
      ),
    ];

    return Padding(
      padding: HomeGaps.sidePad,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          for (final action in actions)
            _QuickActionButton(action: action),
        ],
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  const _QuickActionButton({required this.action});

  final _QuickAction action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brand = context.brand;

    return InkWell(
      onTap: action.isComingSoon
          ? () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Coming soon!')),
              )
          : action.onTap,
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: 72,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                shape: BoxShape.circle,
                border: Border.all(color: brand.hairline),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: _buildIcon(context),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              action.label,
              textAlign: TextAlign.center,
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(BuildContext context) {
    final brand = context.brand;
    final color = brand.onTint;

    if (action.svgPath != null) {
      return SvgPicture.asset(
        action.svgPath!,
        width: 24,
        height: 24,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      );
    }

    if (action.imagePath != null) {
      return Image.asset(
        action.imagePath!,
        width: 24,
        height: 24,
      );
    }

    return Icon(action.icon, size: 24, color: color);
  }
}

class _QuickAction {
  const _QuickAction({
    required this.label,
    this.icon,
    this.svgPath,
    this.imagePath,
    this.onTap,
    this.isComingSoon = false,
  });

  final String label;
  final IconData? icon;
  final String? svgPath;
  final String? imagePath;
  final VoidCallback? onTap;
  final bool isComingSoon;
}
