import 'package:flutter/material.dart';

import '../../../../core/theme/astro_palette.dart';
import '../../../../core/theme/brand_colors.dart';

/// The visual for a gift: its glyph on a gradient tile coloured by category.
///
/// The catalog's `icon_key` / `animation_key` point at artwork the content team
/// hasn't shipped yet, so the app draws every gift locally from its slug — an
/// unknown slug still gets a sensible tile (🎁 on its category colour).
class GiftArt extends StatelessWidget {
  const GiftArt({
    required this.slug,
    this.category = 'sticker',
    this.size = 56,
    this.glow = false,
    super.key,
  });

  final String slug;
  final String category;
  final double size;

  /// A soft coloured halo — used for the selected tile and the success face.
  final bool glow;

  static const _glyphs = <String, String>{
    'namaste': '🙏',
    'rose': '🌹',
    'diya': '🪔',
    'marigold-garland': '🌼',
    'silver-coin': '🪙',
    'kalash': '🏺',
    'gold-crown': '👑',
    'cosmic-blessing': '✨',
  };

  static String glyphFor(String slug) => _glyphs[slug] ?? '🎁';

  static List<Color> gradientFor(String category) => switch (category) {
    'flower' => AstroPalette.love.gradient,
    'blessing' => AstroPalette.fire.gradient,
    'jewelry' => AstroPalette.air.gradient,
    'premium' => BrandColors.goldGradient,
    'mega' => AstroPalette.romance,
    _ => AstroPalette.money.gradient,
  };

  @override
  Widget build(BuildContext context) {
    final colors = gradientFor(category);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.3),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [for (final c in colors) c.withValues(alpha: 0.22)],
        ),
        border: Border.all(color: colors.last.withValues(alpha: 0.35)),
        boxShadow: glow
            ? [
                BoxShadow(
                  color: colors.last.withValues(alpha: 0.4),
                  blurRadius: size * 0.35,
                  offset: Offset(0, size * 0.08),
                ),
              ]
            : null,
      ),
      alignment: Alignment.center,
      child: Text(
        glyphFor(slug),
        style: TextStyle(fontSize: size * 0.5, height: 1),
      ),
    );
  }
}
