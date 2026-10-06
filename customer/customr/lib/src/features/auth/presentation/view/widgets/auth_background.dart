import 'package:flutter/material.dart';
import 'package:talkacharya_ui/talkacharya_ui.dart';

/// The sign-in screens' backdrop, in the app's own colours: the theme's canvas
/// with a soft saffron glow from the top and a faint zodiac wheel behind the
/// logo. Follows light and dark with the rest of the app.
class AuthBackground extends StatelessWidget {
  const AuthBackground({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final brand = context.brand;
    final size = MediaQuery.sizeOf(context);

    return Stack(
      children: [
        Positioned.fill(child: ColoredBox(color: brand.canvas)),
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0, -1.1),
                radius: 1.15,
                colors: [
                  scheme.primary.withValues(alpha: 0.20),
                  scheme.primary.withValues(alpha: 0.05),
                  Colors.transparent,
                ],
                stops: const [0, 0.55, 1],
              ),
            ),
          ),
        ),
        Positioned(
          top: -size.width * 0.28,
          left: -size.width * 0.1,
          right: -size.width * 0.1,
          child: IgnorePointer(
            child: Image.asset(
              'assets/images/login-bg.png',
              fit: BoxFit.contain,
              color: scheme.primary.withValues(alpha: 0.10),
              colorBlendMode: BlendMode.srcIn,
              errorBuilder: (_, _, _) => const SizedBox.shrink(),
            ),
          ),
        ),
        child,
      ],
    );
  }
}
