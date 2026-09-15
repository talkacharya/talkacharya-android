import 'package:flutter/material.dart';

/// Colour roles the Material [ColorScheme] doesn't give us but the product
/// needs consistently: the warm off-white canvas, hairline borders, the LIVE
/// red, the "online" green, and the warm tint used for promos / packs.
///
/// Access via `Theme.of(context).extension<BrandColors>()!` or the
/// [BuildContext] getter in `theme_x.dart`.
@immutable
class BrandColors extends ThemeExtension<BrandColors> {
  const BrandColors({
    required this.canvas,
    required this.hairline,
    required this.tint,
    required this.onTint,
    required this.live,
    required this.online,
    required this.gold,
    required this.shimmerBase,
    required this.shimmerHighlight,
  });

  /// App background — a subtly warm white, not pure grey.
  final Color canvas;

  /// 1px card / divider borders.
  final Color hairline;

  /// Warm container fill for promos, recharge packs, refer-&-earn.
  final Color tint;
  final Color onTint;

  /// LIVE badge, Rahu Kaal, destructive accents on warm surfaces.
  final Color live;

  /// Presence dot, recharge bonus, positive deltas.
  final Color online;

  /// Rating stars.
  final Color gold;

  final Color shimmerBase;
  final Color shimmerHighlight;

  static const light = BrandColors(
    canvas: Color(0xFFF7F7FB),
    hairline: Color(0xFFE6E6EF),
    tint: Color(0xFFEEEBFA),
    onTint: Color(0xFF3A2E9E),
    live: Color(0xFFE0362C),
    online: Color(0xFF2E9E4F),
    gold: Color(0xFFF2A93B),
    shimmerBase: Color(0xFFE9E9F1),
    shimmerHighlight: Color(0xFFF6F6FB),
  );

  static const dark = BrandColors(
    canvas: Color(0xFF13131A),
    hairline: Color(0xFF2C2C3A),
    tint: Color(0xFF211E3A),
    onTint: Color(0xFFC7BEF6),
    live: Color(0xFFFF6B60),
    online: Color(0xFF5FD07E),
    gold: Color(0xFFF2A93B),
    shimmerBase: Color(0xFF232330),
    shimmerHighlight: Color(0xFF2E2E3E),
  );

  @override
  BrandColors copyWith({
    Color? canvas,
    Color? hairline,
    Color? tint,
    Color? onTint,
    Color? live,
    Color? online,
    Color? gold,
    Color? shimmerBase,
    Color? shimmerHighlight,
  }) {
    return BrandColors(
      canvas: canvas ?? this.canvas,
      hairline: hairline ?? this.hairline,
      tint: tint ?? this.tint,
      onTint: onTint ?? this.onTint,
      live: live ?? this.live,
      online: online ?? this.online,
      gold: gold ?? this.gold,
      shimmerBase: shimmerBase ?? this.shimmerBase,
      shimmerHighlight: shimmerHighlight ?? this.shimmerHighlight,
    );
  }

  @override
  BrandColors lerp(ThemeExtension<BrandColors>? other, double t) {
    if (other is! BrandColors) return this;
    return BrandColors(
      canvas: Color.lerp(canvas, other.canvas, t)!,
      hairline: Color.lerp(hairline, other.hairline, t)!,
      tint: Color.lerp(tint, other.tint, t)!,
      onTint: Color.lerp(onTint, other.onTint, t)!,
      live: Color.lerp(live, other.live, t)!,
      online: Color.lerp(online, other.online, t)!,
      gold: Color.lerp(gold, other.gold, t)!,
      shimmerBase: Color.lerp(shimmerBase, other.shimmerBase, t)!,
      shimmerHighlight: Color.lerp(
        shimmerHighlight,
        other.shimmerHighlight,
        t,
      )!,
    );
  }
}

extension BrandColorsX on BuildContext {
  BrandColors get brand => Theme.of(this).extension<BrandColors>()!;
}
