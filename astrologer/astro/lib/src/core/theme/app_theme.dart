import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'brand_colors.dart';

/// Central theme. Customer brand seed is saffron; the astrologer app overrides
/// [_seed] with indigo. Keep widget code theme-driven (no hard-coded colours) —
/// reach for [BrandColors] (a [ThemeExtension]) when you need a role the
/// [ColorScheme] doesn't cover (live red, online green, the warm tint surface).
///
/// Type: **Fraunces** (warm characterful serif) for display / headline / title,
/// **Mukta** (clean sans with full Devanagari) for body / label / UI. Both come
/// from `google_fonts` — fetched once and cached, with a graceful system
/// fallback when offline.
class AppTheme {
  const AppTheme._();

  static const Color _seed = Color(0xFF4C3BCF); // indigo (astrologer)

  static ThemeData get light => _base(Brightness.light);
  static ThemeData get dark => _base(Brightness.dark);

  static ThemeData _base(Brightness brightness) {
    final scheme = ColorScheme.fromSeed(
      seedColor: _seed,
      brightness: brightness,
    );
    final base = ThemeData(brightness: brightness, useMaterial3: true);
    final brand = brightness == Brightness.light
        ? BrandColors.light
        : BrandColors.dark;

    final textTheme = _textTheme(base.textTheme).apply(
      bodyColor: scheme.onSurface,
      displayColor: scheme.onSurface,
    );

    return base.copyWith(
      colorScheme: scheme,
      scaffoldBackgroundColor: brand.canvas,
      extensions: [brand],
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        centerTitle: false,
        backgroundColor: brand.canvas,
        surfaceTintColor: Colors.transparent,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: scheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: brand.hairline),
        ),
        margin: EdgeInsets.zero,
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(999),
          side: BorderSide(color: brand.hairline),
        ),
        side: BorderSide(color: brand.hairline),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  /// Mukta everywhere, Fraunces for the big/expressive roles.
  static TextTheme _textTheme(TextTheme base) {
    final body = GoogleFonts.muktaTextTheme(base);
    final display = GoogleFonts.fraunces(
      fontWeight: FontWeight.w600,
      // Fraunces reads better with its "soft" optical treatment at display sizes.
    );
    TextStyle? fraunces(TextStyle? s) => s?.copyWith(
      fontFamily: display.fontFamily,
      fontFamilyFallback: display.fontFamilyFallback,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.2,
      height: 1.15,
    );
    return body.copyWith(
      displayLarge: fraunces(body.displayLarge),
      displayMedium: fraunces(body.displayMedium),
      displaySmall: fraunces(body.displaySmall),
      headlineLarge: fraunces(body.headlineLarge),
      headlineMedium: fraunces(body.headlineMedium),
      headlineSmall: fraunces(body.headlineSmall),
      titleLarge: fraunces(body.titleLarge),
    );
  }
}

/// 4-pt spacing scale.
class Gap {
  const Gap._();
  static const xs = SizedBox(height: 4, width: 4);
  static const sm = SizedBox(height: 8, width: 8);
  static const md = SizedBox(height: 16, width: 16);
  static const lg = SizedBox(height: 24, width: 24);
  static const xl = SizedBox(height: 40, width: 40);
}
