import 'package:flutter/material.dart';

/// Purposeful colour families for the astrology tools (horoscope, matchmaking).
///
/// Each life area and zodiac element owns a two-stop gradient plus a soft tint, so a
/// screen reads as a set of distinct, meaningful colours instead of one brand hue.
/// Tints are alpha-based and sit well on both the light canvas and dark surfaces.
@immutable
class AstroHue {
  const AstroHue(this.start, this.end);

  final Color start;
  final Color end;

  List<Color> get gradient => [start, end];
  Color get solid => Color.lerp(start, end, 0.5)!;
  Color tint([double alpha = 0.12]) => solid.withValues(alpha: alpha);

  LinearGradient linear({
    AlignmentGeometry begin = Alignment.topLeft,
    AlignmentGeometry end = Alignment.bottomRight,
  }) => LinearGradient(begin: begin, end: end, colors: gradient);
}

class AstroPalette {
  const AstroPalette._();

  // --- life areas ---------------------------------------------------------
  static const love = AstroHue(Color(0xFFFF5C8A), Color(0xFFE63E9B));
  static const career = AstroHue(Color(0xFF6D7CFF), Color(0xFF4F46E5));
  static const money = AstroHue(Color(0xFFFFB02E), Color(0xFFF07B16));
  static const health = AstroHue(Color(0xFF2DD4A7), Color(0xFF0EA5A0));

  static AstroHue area(String key) => switch (key) {
    'love' => love,
    'career' => career,
    'money' => money,
    'health' => health,
    _ => career,
  };

  static IconData areaIcon(String key) => switch (key) {
    'love' => Icons.favorite_rounded,
    'career' => Icons.work_rounded,
    'money' => Icons.account_balance_wallet_rounded,
    'health' => Icons.spa_rounded,
    _ => Icons.auto_awesome_rounded,
  };

  // --- zodiac elements ------------------------------------------------------
  static const fire = AstroHue(Color(0xFFFF7A45), Color(0xFFE8364F));
  static const earth = AstroHue(Color(0xFF7BC67B), Color(0xFF3F9A5C));
  static const air = AstroHue(Color(0xFF5EC8FF), Color(0xFF7A6CFF));
  static const water = AstroHue(Color(0xFF36D1DC), Color(0xFF3A7BD5));

  /// Element for sign index 0 (Aries) … 11 (Pisces): fire, earth, air, water.
  static AstroHue element(int signIndex) =>
      const [fire, earth, air, water][signIndex % 4];

  // --- score bands (1..5) ---------------------------------------------------
  static const _bands = <int, AstroHue>{
    5: AstroHue(Color(0xFF34D399), Color(0xFF059669)),
    4: AstroHue(Color(0xFFA3E635), Color(0xFF22C55E)),
    3: AstroHue(Color(0xFFFCD34D), Color(0xFFF59E0B)),
    2: AstroHue(Color(0xFFFDBA74), Color(0xFFF97316)),
    1: AstroHue(Color(0xFFFDA4AF), Color(0xFFE11D48)),
  };

  static AstroHue band(int score) => _bands[score.clamp(1, 5)]!;

  /// Map a 0..1 ratio (e.g. guna points / 36) onto the five bands.
  static AstroHue ratio(double r) => band(
    r >= 0.78
        ? 5
        : r >= 0.6
        ? 4
        : r >= 0.45
        ? 3
        : r >= 0.33
        ? 2
        : 1,
  );

  // --- matchmaking partners ------------------------------------------------
  static const partnerA = AstroHue(Color(0xFF60A5FA), Color(0xFF6366F1));
  static const partnerB = AstroHue(Color(0xFFF472B6), Color(0xFFDB2777));

  // --- rotating identity colours ------------------------------------------
  /// Families rotated across cards so neighbours never share a hue.
  static const cycle = <AstroHue>[career, love, health, money, air, fire];

  static AstroHue at(int i) => cycle[i % cycle.length];

  /// Stable colour for an id — the same astrologer wears the same hue everywhere.
  static AstroHue forId(String id) =>
      cycle[id.codeUnits.fold<int>(0, (a, b) => a + b) % cycle.length];

  /// The romantic hero gradient (matchmaking): coral → magenta → violet.
  static const romance = [
    Color(0xFFFF7E6B),
    Color(0xFFE83E8C),
    Color(0xFF7B3FE4),
  ];
}
