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
    required this.cosmicStart,
    required this.cosmicEnd,
    required this.glowAccent,
    required this.cardGlow,
    required this.sectionBg,
    required this.ink,
    required this.inkMuted,
    required this.primaryPressed,
    required this.cosmicAccent,
    required this.onCosmic,
    required this.onCosmicMuted,
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

  /// Zodiac / horoscope dark panel gradient start.
  final Color cosmicStart;

  /// Zodiac / horoscope dark panel gradient end.
  final Color cosmicEnd;

  /// Active glow, premium highlights — luminous amber-gold.
  final Color glowAccent;

  /// Soft warm card shadow colour.
  final Color cardGlow;

  /// Warm section background for grids / chips.
  final Color sectionBg;

  /// Primary text — warm charcoal (light) / warm cream (dark), replacing
  /// Material's auto-generated `onSurface` everywhere via [AppTheme].
  final Color ink;

  /// Secondary text — captions, meta rows, inactive nav icons.
  final Color inkMuted;

  /// Pressed / active state on a saffron fill (buttons, active tab underline).
  final Color primaryPressed;

  /// Soft lavender — icons/dividers on a [cosmicStart]→[cosmicEnd] surface.
  /// Same in light and dark app mode; the cosmic surface itself is always dark.
  final Color cosmicAccent;

  /// Primary text on a cosmic surface (chart/dasha/horoscope hero cards).
  final Color onCosmic;

  /// Secondary text on a cosmic surface.
  final Color onCosmicMuted;

  /// Gold gradient for primary CTA buttons and premium badges — one per
  /// screen, never a general-purpose fill.
  static const goldGradient = [
    Color(0xFFF6D695),
    Color(0xFFF2A93B),
    Color(0xFFE8871A),
  ];

  static const light = BrandColors(
    canvas: Color(0xFFFFF8F4),
    hairline: Color(0xFFF0E3D8),
    tint: Color(0xFFFBF1E9),
    onTint: Color(0xFF8A3B0E),
    live: Color(0xFFE0362C),
    online: Color(0xFF2E9E4F),
    gold: Color(0xFFF2A93B),
    shimmerBase: Color(0xFFEFE7DF),
    shimmerHighlight: Color(0xFFF9F4EF),
    cosmicStart: Color(0xFF1A0B2E),
    cosmicEnd: Color(0xFF2D1854),
    glowAccent: Color(0xFFFFB347),
    cardGlow: Color(0x33EA6A1E),
    sectionBg: Color(0xFFFFF5ED),
    ink: Color(0xFF2A1C12),
    inkMuted: Color(0xFF8A7565),
    primaryPressed: Color(0xFFC8570F),
    cosmicAccent: Color(0xFFA78BFA),
    onCosmic: Color(0xFFF5EDE3),
    onCosmicMuted: Color(0xFFC9B8DE),
  );

  static const dark = BrandColors(
    canvas: Color(0xFF17120E),
    hairline: Color(0xFF352C25),
    tint: Color(0xFF2A1D13),
    onTint: Color(0xFFF6C9A8),
    live: Color(0xFFFF6B60),
    online: Color(0xFF5FD07E),
    gold: Color(0xFFF2A93B),
    shimmerBase: Color(0xFF2A231D),
    shimmerHighlight: Color(0xFF372E26),
    cosmicStart: Color(0xFF0D0720),
    cosmicEnd: Color(0xFF1A0E38),
    glowAccent: Color(0xFFFFB347),
    cardGlow: Color(0x40EA6A1E),
    sectionBg: Color(0xFF1E1710),
    // Dark-mode ink reuses onCosmic — one warm off-white for primary text once
    // the canvas itself is dark. inkMuted is a separate, deliberately
    // warm-gray (not lavender-tinted) value for the plain dark canvas.
    ink: Color(0xFFF5EDE3),
    inkMuted: Color(0xFF6E6255),
    primaryPressed: Color(0xFFFF8A3D),
    cosmicAccent: Color(0xFFA78BFA),
    onCosmic: Color(0xFFF5EDE3),
    onCosmicMuted: Color(0xFFC9B8DE),
  );

  /// Soft warm ambient shadow — hero teasers, feature callouts, CTA banners
  /// on the ordinary canvas. Reserved for cards that should feel lifted;
  /// ordinary rows stay flat (hairline border, no shadow).
  List<BoxShadow> get shadowWarm => [
    BoxShadow(color: cardGlow, blurRadius: 22, offset: const Offset(0, 10)),
  ];

  /// Cosmic-surface elevation — chart, dasha and premium cards on a
  /// [cosmicStart]→[cosmicEnd] gradient background.
  List<BoxShadow> get shadowCosmic => [
    BoxShadow(
      color: cosmicStart.withValues(alpha: 0.5),
      blurRadius: 28,
      offset: const Offset(0, 14),
    ),
  ];

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
    Color? cosmicStart,
    Color? cosmicEnd,
    Color? glowAccent,
    Color? cardGlow,
    Color? sectionBg,
    Color? ink,
    Color? inkMuted,
    Color? primaryPressed,
    Color? cosmicAccent,
    Color? onCosmic,
    Color? onCosmicMuted,
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
      cosmicStart: cosmicStart ?? this.cosmicStart,
      cosmicEnd: cosmicEnd ?? this.cosmicEnd,
      glowAccent: glowAccent ?? this.glowAccent,
      cardGlow: cardGlow ?? this.cardGlow,
      sectionBg: sectionBg ?? this.sectionBg,
      ink: ink ?? this.ink,
      inkMuted: inkMuted ?? this.inkMuted,
      primaryPressed: primaryPressed ?? this.primaryPressed,
      cosmicAccent: cosmicAccent ?? this.cosmicAccent,
      onCosmic: onCosmic ?? this.onCosmic,
      onCosmicMuted: onCosmicMuted ?? this.onCosmicMuted,
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
      cosmicStart: Color.lerp(cosmicStart, other.cosmicStart, t)!,
      cosmicEnd: Color.lerp(cosmicEnd, other.cosmicEnd, t)!,
      glowAccent: Color.lerp(glowAccent, other.glowAccent, t)!,
      cardGlow: Color.lerp(cardGlow, other.cardGlow, t)!,
      sectionBg: Color.lerp(sectionBg, other.sectionBg, t)!,
      ink: Color.lerp(ink, other.ink, t)!,
      inkMuted: Color.lerp(inkMuted, other.inkMuted, t)!,
      primaryPressed: Color.lerp(primaryPressed, other.primaryPressed, t)!,
      cosmicAccent: Color.lerp(cosmicAccent, other.cosmicAccent, t)!,
      onCosmic: Color.lerp(onCosmic, other.onCosmic, t)!,
      onCosmicMuted: Color.lerp(onCosmicMuted, other.onCosmicMuted, t)!,
    );
  }
}

extension BrandColorsX on BuildContext {
  BrandColors get brand => Theme.of(this).extension<BrandColors>()!;
}
