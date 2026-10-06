import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:talkacharya_ui/talkacharya_ui.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/performance_models.dart';

/// Share of the window's customers who came back *and* stayed a while, as a
/// ring — and the way in to the ones who have stopped coming back.
class LoyalCard extends StatelessWidget {
  const LoyalCard({required this.loyal, required this.windowDays, super.key});

  final LoyalStats loyal;
  final int windowDays;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    const hue = AstroPalette.love;
    final reduce = MediaQuery.maybeDisableAnimationsOf(context) ?? false;

    return Pressable(
      child: HueTile(
        hue: hue,
        radius: Radii.lg,
        padding: const EdgeInsets.fromLTRB(14, 14, 8, 14),
        onTap: () => context.push(Routes.winBack),
        child: Row(
          children: [
            SizedBox.square(
              dimension: 64,
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: loyal.percent / 100),
                duration: reduce
                    ? Duration.zero
                    : const Duration(milliseconds: 900),
                curve: Curves.easeOutCubic,
                builder: (_, t, child) => CustomPaint(
                  painter: _RingPainter(progress: t, hue: hue),
                  child: child,
                ),
                child: Center(
                  child: Text(
                    '${loyal.percent.round()}%',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l.loyalTitle,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    l.loyalBody(windowDays, loyal.minMinutes),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: context.brand.inkMuted,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l.loyalWinBack,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: hue.end,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: hue.end),
          ],
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  const _RingPainter({required this.progress, required this.hue});

  final double progress;
  final AstroHue hue;

  @override
  void paint(Canvas canvas, Size size) {
    const stroke = 7.0;
    final rect = (Offset.zero & size).deflate(stroke / 2);
    final base = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..color = hue.tint(0.18);
    canvas.drawArc(rect, 0, math.pi * 2, false, base);
    if (progress <= 0) return;
    canvas.drawArc(
      rect,
      -math.pi / 2,
      math.pi * 2 * progress.clamp(0.0, 1.0),
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.round
        ..shader = hue.linear().createShader(rect),
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.progress != progress || old.hue != hue;
}
