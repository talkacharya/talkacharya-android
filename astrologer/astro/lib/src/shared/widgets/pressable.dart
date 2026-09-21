import 'package:flutter/material.dart';
import '../../core/utils/haptic_service.dart';

/// Wraps a tappable surface so it gently scales down while the finger is on it
/// and springs back on release — the tactile "give" that a bare [InkWell]
/// ripple doesn't provide.
///
/// It listens to raw pointer events instead of owning a gesture, so any
/// [InkWell]/[GestureDetector] inside still fires normally. Honours the OS
/// "reduce motion" setting (stays at full scale).
class Pressable extends StatefulWidget {
  const Pressable({
    required this.child,
    this.scale = 0.97,
    this.duration = const Duration(milliseconds: 130),
    this.haptic = HapticLevel.light,
    super.key,
  });

  final Widget child;
  final double scale;
  final Duration duration;
  final HapticLevel haptic;

  @override
  State<Pressable> createState() => _PressableState();
}

class _PressableState extends State<Pressable> {
  bool _down = false;

  void _set(bool v) {
    if (_down != v) {
      setState(() => _down = v);
      if (v && widget.haptic != HapticLevel.none) {
        switch (widget.haptic) {
          case HapticLevel.selection:
            HapticService.selection();
          case HapticLevel.light:
            HapticService.light();
          case HapticLevel.medium:
            HapticService.medium();
          case HapticLevel.heavy:
            HapticService.heavy();
          case HapticLevel.none:
            break;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    return Listener(
      onPointerDown: (_) => _set(true),
      onPointerUp: (_) => _set(false),
      onPointerCancel: (_) => _set(false),
      child: AnimatedScale(
        scale: (_down && !reduceMotion) ? widget.scale : 1.0,
        duration: widget.duration,
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}
