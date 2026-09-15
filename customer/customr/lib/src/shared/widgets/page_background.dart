import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

/// A full-screen SVG background that automatically switches between
/// light and dark versions based on the current theme.
class PageBackground extends StatelessWidget {
  const PageBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SvgPicture.asset(
      isDark ? 'assets/svg/bg-dark.svg' : 'assets/svg/bg-light.svg',
      fit: BoxFit.cover,
      alignment: Alignment.center,
      width: double.infinity,
      height: double.infinity,
    );
  }
}
