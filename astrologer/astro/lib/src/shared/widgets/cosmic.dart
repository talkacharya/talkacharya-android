import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/theme/astro_palette.dart';
import '../../core/theme/brand_colors.dart';

/// Deep-space gradient with three coloured nebula glows, a starfield and a
/// faint orbit — the same visual language as the Horoscope and Matching heroes.
class CosmicBackdrop extends StatelessWidget {
  const CosmicBackdrop({super.key});

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    Widget glow(Alignment at, double radius, Color color, double alpha) =>
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: at,
              radius: radius,
              colors: [
                color.withValues(alpha: alpha),
                color.withValues(alpha: 0),
              ],
            ),
          ),
        );
    // Clip: the orbit/planet glow paints past its box, and headers that
    // collapse (SliverAppBar) don't clip their flexible space.
    return ClipRect(
      child: Stack(
        fit: StackFit.expand,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  brand.cosmicStart,
                  brand.cosmicEnd,
                  const Color(0xFF3B0F5C),
                ],
              ),
            ),
          ),
          glow(
            const Alignment(0.95, -0.55),
            0.85,
            AstroPalette.romance[1],
            0.5,
          ),
          glow(
            const Alignment(-1.0, 0.95),
            0.9,
            AstroPalette.career.start,
            0.45,
          ),
          glow(const Alignment(0.2, 1.1), 0.6, AstroPalette.money.start, 0.28),
          const CustomPaint(painter: _OrbitPainter()),
        ],
      ),
    );
  }
}

/// Pulsing green "live" dot.
class LiveDot extends StatefulWidget {
  const LiveDot({super.key});

  @override
  State<LiveDot> createState() => LiveDotState();
}

class LiveDotState extends State<LiveDot> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const color = Color(0xFF4ADE80);
    final reduce = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    Widget dot(double t) => Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.35 + 0.35 * t),
            blurRadius: 4 + 6 * t,
            spreadRadius: 1 + t,
          ),
        ],
      ),
    );
    if (reduce) return dot(0.5);
    return AnimatedBuilder(
      animation: _c,
      builder: (_, _) => dot(Curves.easeInOut.transform(_c.value)),
    );
  }
}

/// Starfield plus two faint orbit arcs with a couple of "planets".
class _OrbitPainter extends CustomPainter {
  const _OrbitPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final rnd = math.Random(11);
    final star = Paint();
    for (var i = 0; i < 80; i++) {
      star.color = Colors.white.withValues(
        alpha: 0.12 + rnd.nextDouble() * 0.5,
      );
      canvas.drawCircle(
        Offset(rnd.nextDouble() * size.width, rnd.nextDouble() * size.height),
        rnd.nextDouble() * 1.2 + 0.2,
        star,
      );
    }

    final center = Offset(size.width * 0.92, size.height * 0.22);
    final orbit = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = Colors.white.withValues(alpha: 0.10);
    for (final r in [size.width * 0.38, size.width * 0.58]) {
      canvas.drawCircle(center, r, orbit);
    }

    void planet(double r, double angle, double radius, List<Color> colors) {
      final p = center + Offset(math.cos(angle) * r, math.sin(angle) * r);
      canvas.drawCircle(
        p,
        radius * 2.4,
        Paint()..color = colors.first.withValues(alpha: 0.18),
      );
      canvas.drawCircle(
        p,
        radius,
        Paint()
          ..shader = LinearGradient(
            colors: colors,
          ).createShader(Rect.fromCircle(center: p, radius: radius)),
      );
    }

    planet(size.width * 0.38, 2.35, 5, AstroPalette.money.gradient);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Twinkling-free, deterministic star dots for cosmic surfaces.
class StarfieldPainter extends CustomPainter {
  const StarfieldPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final rnd = math.Random(7);
    final paint = Paint()..color = Colors.white;
    for (var i = 0; i < 70; i++) {
      final dx = rnd.nextDouble() * size.width;
      final dy = rnd.nextDouble() * size.height;
      final r = rnd.nextDouble() * 1.3 + 0.2;
      paint.color = Colors.white.withValues(
        alpha: 0.15 + rnd.nextDouble() * 0.55,
      );
      canvas.drawCircle(Offset(dx, dy), r, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
