import 'dart:math' as math;

import 'package:flutter/material.dart';

/// An animated circular gauge: a soft track plus a gradient arc that sweeps from
/// 0 to [value] (0..1) on first build and eases to new values afterwards.
///
/// [center] is laid out inside the ring (e.g. "24 / 36"). Honours the OS
/// "reduce motion" setting.
class ScoreRing extends StatelessWidget {
  const ScoreRing({
    required this.value,
    required this.colors,
    this.size = 140,
    this.stroke = 12,
    this.trackColor,
    this.center,
    this.duration = const Duration(milliseconds: 1100),
    super.key,
  });

  final double value;
  final List<Color> colors;
  final double size;
  final double stroke;
  final Color? trackColor;
  final Widget? center;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    final reduce = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    final track =
        trackColor ??
        Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.08);
    final target = value.clamp(0.0, 1.0);
    return SizedBox.square(
      dimension: size,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: target),
        duration: reduce ? Duration.zero : duration,
        curve: Curves.easeOutCubic,
        builder: (context, t, child) => CustomPaint(
          painter: _RingPainter(
            progress: t,
            colors: colors,
            stroke: stroke,
            track: track,
          ),
          child: child,
        ),
        child: Center(child: center),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({
    required this.progress,
    required this.colors,
    required this.stroke,
    required this.track,
  });

  final double progress;
  final List<Color> colors;
  final double stroke;
  final Color track;

  @override
  void paint(Canvas canvas, Size size) {
    final rect =
        Offset(stroke / 2, stroke / 2) &
        Size(size.width - stroke, size.height - stroke);
    const start = -math.pi / 2;

    canvas.drawArc(
      rect,
      0,
      math.pi * 2,
      false,
      Paint()
        ..color = track
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke,
    );
    if (progress <= 0) return;

    final sweep = math.pi * 2 * progress;
    final shader = SweepGradient(
      startAngle: 0,
      endAngle: math.pi * 2,
      colors: colors.length == 1 ? [colors.first, colors.first] : colors,
      transform: const GradientRotation(start),
    ).createShader(rect);

    // Soft glow under the arc.
    canvas.drawArc(
      rect,
      start,
      sweep,
      false,
      Paint()
        ..shader = shader
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = stroke
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6)
        ..color = Colors.white.withValues(alpha: 0.35),
    );
    canvas.drawArc(
      rect,
      start,
      sweep,
      false,
      Paint()
        ..shader = shader
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = stroke,
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.progress != progress ||
      old.stroke != stroke ||
      old.track != track ||
      old.colors != colors;
}
