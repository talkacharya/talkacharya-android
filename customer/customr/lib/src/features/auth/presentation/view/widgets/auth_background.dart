import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Cosmic backdrop: a deep dark space, a faint zodiac-chart asset in the
/// top-right, drifting orbs, and twinkling stars.
class AuthBackground extends StatefulWidget {
  const AuthBackground({required this.child, super.key});

  final Widget child;

  @override
  State<AuthBackground> createState() => _AuthBackgroundState();
}

class _AuthBackgroundState extends State<AuthBackground>
    with TickerProviderStateMixin {
  late final AnimationController _drift = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 22),
  )..repeat();

  late final AnimationController _twinkle = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 5),
  )..repeat(reverse: true);

  static final List<_Star> _stars = List.generate(40, (i) {
    return _Star(
      dx: _hash(i * 1.37),
      dy: _hash(i * 2.71),
      radius: 0.6 + _hash(i * 3.14) * 1.8,
      phase: _hash(i * 4.19),
    );
  });

  static double _hash(double x) => (math.sin(x) * 43758.5453).abs() % 1.0;

  @override
  void dispose() {
    _drift.dispose();
    _twinkle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        // Base Space Color
        Positioned.fill(child: Container(color: const Color(0xFF0B0B13))),

        // Astrology Chart Asset (Top Right)
        Positioned(
          top: -size.height * 0.05,
          right: -size.width * 0.1,
          child: Opacity(
            opacity: 0.25,
            child: Image.asset(
              'assets/images/login-bg.png',
              width: size.width * 0.8,
              fit: BoxFit.contain,
              errorBuilder: (_, _, _) => const SizedBox.shrink(),
            ),
          ),
        ),

        // Drifting Orbs & Twinkling Stars
        Positioned.fill(
          child: RepaintBoundary(
            child: AnimatedBuilder(
              animation: Listenable.merge([_drift, _twinkle]),
              builder: (context, child) => CustomPaint(
                painter: _BackdropPainter(
                  drift: _drift.value,
                  twinkle: _twinkle.value,
                  stars: _stars,
                ),
              ),
            ),
          ),
        ),

        // Bottom Fog/Gradient
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0, 1.2),
                radius: 1.5,
                colors: [
                  const Color(0xFF1A1230).withValues(alpha: 0.4),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),

        widget.child,
      ],
    );
  }
}

class _Star {
  const _Star({
    required this.dx,
    required this.dy,
    required this.radius,
    required this.phase,
  });
  final double dx, dy, radius, phase;
}

class _BackdropPainter extends CustomPainter {
  _BackdropPainter({
    required this.drift,
    required this.twinkle,
    required this.stars,
  });

  final double drift, twinkle;
  final List<_Star> stars;

  @override
  void paint(Canvas canvas, Size size) {
    final t = drift * 2 * math.pi;
    final paint = Paint();

    void orb(Offset base, double radius, Color color, double sway) {
      final center =
          base + Offset(math.cos(t + sway) * 15, math.sin(t * 0.8 + sway) * 20);
      canvas.drawCircle(
        center,
        radius,
        paint
          ..color = color
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, radius * 0.7),
      );
    }

    final unit = size.shortestSide;
    // Purple/Gold subtle glows
    orb(
      Offset(size.width * 0.1, size.height * 0.15),
      unit * 0.3,
      const Color(0xFF5E35B1).withValues(alpha: 0.12),
      0,
    );
    orb(
      Offset(size.width * 0.9, size.height * 0.85),
      unit * 0.4,
      const Color(0xFFC5A358).withValues(alpha: 0.08),
      2.5,
    );

    // Stars
    for (final s in stars) {
      final tw = 0.5 + 0.5 * math.sin((twinkle + s.phase) * 2 * math.pi);
      paint.color = Colors.white.withValues(alpha: 0.05 + 0.25 * tw);
      paint.maskFilter = null;
      canvas.drawCircle(
        Offset(s.dx * size.width, s.dy * size.height),
        s.radius * (0.8 + 0.2 * tw),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_BackdropPainter old) =>
      old.drift != drift || old.twinkle != twinkle;
}
