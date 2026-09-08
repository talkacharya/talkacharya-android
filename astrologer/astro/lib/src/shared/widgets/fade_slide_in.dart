import 'package:flutter/material.dart';

/// Fade + upward-slide entrance. Wrap any widget and give each sibling an
/// increasing [delay] to stagger a screen into view. Respects the OS
/// "reduce motion" setting (snaps straight to visible).
class FadeSlideIn extends StatefulWidget {
  const FadeSlideIn({
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 460),
    this.offset = 20,
    super.key,
  });

  final Widget child;
  final Duration delay;
  final Duration duration;
  final double offset;

  /// Stagger a list of children: `FadeSlideIn.list(children, step: 60ms)`.
  static List<Widget> list(
    List<Widget> children, {
    Duration step = const Duration(milliseconds: 55),
    Duration start = Duration.zero,
  }) {
    return [
      for (var i = 0; i < children.length; i++)
        FadeSlideIn(delay: start + step * i, child: children[i]),
    ];
  }

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

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.maybeDisableAnimationsOf(context) ?? false) {
      return widget.child;
    }
    return AnimatedBuilder(
      animation: _c,
      builder: (context, child) {
        final t = Curves.easeOutCubic.transform(_c.value);
        return Opacity(
          opacity: _c.value.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, (1 - t) * widget.offset),
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}
