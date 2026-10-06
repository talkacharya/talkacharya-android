import 'package:flutter/material.dart';

/// Fade + upward-slide entrance. Wrap it around any widget and give each
/// sibling an increasing [delay] to stagger a screen into view.
class FadeSlideIn extends StatefulWidget {
  const FadeSlideIn({
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 480),
    this.offset = 22,
    super.key,
  });

  final Widget child;
  final Duration delay;
  final Duration duration;

  /// Distance in logical pixels the child travels upward as it fades in.
  final double offset;

  @override
  State<FadeSlideIn> createState() => _FadeSlideInState();
}

class _FadeSlideInState extends State<FadeSlideIn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: widget.duration,
  );

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(widget.delay, () {
      if (mounted) _c.forward();
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  // Pre-compute both animations once from the single controller.
  late final Animation<double> _opacity = CurvedAnimation(
    parent: _c,
    curve: Curves.easeOutCubic,
  );
  late final Animation<Offset> _slide = Tween<Offset>(
    // Offset is in fractional units — 0.08 ≈ 8% of the child's own height,
    // which visually matches the old 22 px absolute offset at typical sizes.
    begin: Offset(0, widget.offset / 300),
    end: Offset.zero,
  ).animate(CurvedAnimation(parent: _c, curve: Curves.easeOutCubic));

  @override
  Widget build(BuildContext context) {
    // FadeTransition + SlideTransition are compositor-driven: no Opacity
    // widget layer, no per-frame CPU layout. The GPU handles blend + offset.
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(
        position: _slide,
        child: widget.child,
      ),
    );
  }
}
