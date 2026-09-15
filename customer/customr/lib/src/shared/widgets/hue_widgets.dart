import 'package:flutter/material.dart';

import '../../core/theme/astro_palette.dart';

/// A soft, hue-tinted tappable tile: tint → surface gradient, hue hairline, glow.
class HueTile extends StatelessWidget {
  const HueTile({
    required this.hue,
    required this.child,
    this.onTap,
    this.radius = 20,
    this.padding = const EdgeInsets.all(12),
    super.key,
  });

  final AstroHue hue;
  final Widget child;
  final VoidCallback? onTap;
  final double radius;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final surface = Theme.of(context).colorScheme.surface;
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radius),
      side: BorderSide(color: hue.tint(0.22)),
    );
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: hue.start.withValues(alpha: 0.12),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        shape: shape,
        clipBehavior: Clip.antiAlias,
        color: surface,
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [hue.tint(0.13), surface],
            ),
          ),
          child: InkWell(
            onTap: onTap,
            child: Padding(padding: padding, child: child),
          ),
        ),
      ),
    );
  }
}

/// Rounded-square gradient icon with a coloured glow.
class HueIcon extends StatelessWidget {
  const HueIcon({
    required this.hue,
    this.icon,
    this.child,
    this.size = 44,
    this.iconSize = 22,
    super.key,
  });

  final AstroHue hue;
  final IconData? icon;
  final Widget? child;
  final double size;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.32),
        gradient: hue.linear(),
        boxShadow: [
          BoxShadow(
            color: hue.start.withValues(alpha: 0.35),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: child ?? Icon(icon, color: Colors.white, size: iconSize),
    );
  }
}

/// Photo, or the name's initial on a colour-family gradient (never a flat blob).
class HueAvatar extends StatelessWidget {
  const HueAvatar({
    required this.name,
    required this.hue,
    this.url,
    this.size = 56,
    super.key,
  });

  final String name;
  final String? url;
  final AstroHue hue;
  final double size;

  @override
  Widget build(BuildContext context) {
    final trimmed = name.trim();
    final initial = Center(
      child: Text(
        trimmed.isEmpty ? '★' : trimmed.characters.first.toUpperCase(),
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: size * 0.42,
        ),
      ),
    );
    final u = url;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, gradient: hue.linear()),
      clipBehavior: Clip.antiAlias,
      child: (u != null && u.isNotEmpty)
          ? Image.network(
              u,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => initial,
            )
          : initial,
    );
  }
}
