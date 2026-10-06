import 'package:flutter/material.dart';

/// Three-dot "the other person is typing" bubble.
class TypingIndicator extends StatefulWidget {
  const TypingIndicator({super.key});

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ac = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  )..repeat();

  @override
  void dispose() {
    _ac.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final base = scheme.onSurfaceVariant;
    // RepaintBoundary isolates the 1100 ms repeating animation from the
    // message list. Without it, every frame repaints the chat list background.
    return RepaintBoundary(
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: scheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(14),
          ),
          child: AnimatedBuilder(
            animation: _ac,
            // Encode opacity into the dot color instead of using Opacity
            // widgets. Opacity creates a GPU compositing layer per dot (3 ×
            // per frame). Color alpha is a pure-paint value — no extra layers.
            builder: (context, _) => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var i = 0; i < 3; i++)
                  Padding(
                    padding: EdgeInsets.only(right: i == 2 ? 0 : 4),
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: base.withValues(
                          alpha: ((((_ac.value * 3) - i).clamp(0.0, 1.0) *
                                      0.7) +
                                  0.3)
                              .clamp(0.0, 1.0),
                        ),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
