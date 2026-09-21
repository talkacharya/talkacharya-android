import 'package:flutter/material.dart';

import '../../core/theme/astro_palette.dart';
import '../../core/theme/brand_colors.dart';
import 'hue_widgets.dart';

/// Centered hue icon + title + optional message and action, used for
/// "nothing here yet" and "coming soon" surfaces.
class EmptyState extends StatelessWidget {
  const EmptyState({
    required this.icon,
    required this.title,
    this.message,
    this.action,
    this.hue = AstroPalette.career,
    super.key,
  });

  final IconData icon;
  final String title;
  final String? message;
  final Widget? action;
  final AstroHue hue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: hue.tint(0.10),
              ),
              child: HueIcon(hue: hue, icon: icon, size: 60, iconSize: 30),
            ),
            const SizedBox(height: 18),
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge,
            ),
            if (message != null) ...[
              const SizedBox(height: 6),
              Text(
                message!,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: context.brand.inkMuted,
                ),
              ),
            ],
            if (action != null) ...[const SizedBox(height: 20), action!],
          ],
        ),
      ),
    );
  }
}
