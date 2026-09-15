/// The 12 signs, with the lowercase slugs the backend `GET /app/horoscope`
/// endpoint expects (`sign=aries`).
enum ZodiacSign {
  aries('aries', 'Aries', '♈'),
  taurus('taurus', 'Taurus', '♉'),
  gemini('gemini', 'Gemini', '♊'),
  cancer('cancer', 'Cancer', '♋'),
  leo('leo', 'Leo', '♌'),
  virgo('virgo', 'Virgo', '♍'),
  libra('libra', 'Libra', '♎'),
  scorpio('scorpio', 'Scorpio', '♏'),
  sagittarius('sagittarius', 'Sagittarius', '♐'),
  capricorn('capricorn', 'Capricorn', '♑'),
  aquarius('aquarius', 'Aquarius', '♒'),
  pisces('pisces', 'Pisces', '♓');

  const ZodiacSign(this.slug, this.label, this.glyph);

  final String slug;
  final String label;
  final String glyph;

  String get svgPath => 'assets/svg/zodiac/$slug.svg';

  static ZodiacSign? fromSlug(String? slug) {
    if (slug == null) return null;
    final s = slug.toLowerCase().trim();
    for (final z in ZodiacSign.values) {
      if (z.slug == s || z.label.toLowerCase() == s) return z;
    }
    return null;
  }

  /// The sign for a birth profile's engine-computed chandra rasi (e.g. `Libra`).
  /// Vedic horoscopes are read for the Moon sign, so this is the right default.
  static ZodiacSign? forProfileSign(String? moonSign) => fromSlug(moonSign);

  /// Western sun sign for a birth date — only a fallback when the profile has no
  /// computed rasi yet; prefer [forProfileSign].
  static ZodiacSign fromDate(DateTime date) {
    final m = date.month;
    final d = date.day;
    if ((m == 3 && d >= 21) || (m == 4 && d <= 19)) return ZodiacSign.aries;
    if ((m == 4 && d >= 20) || (m == 5 && d <= 20)) return ZodiacSign.taurus;
    if ((m == 5 && d >= 21) || (m == 6 && d <= 20)) return ZodiacSign.gemini;
    if ((m == 6 && d >= 21) || (m == 7 && d <= 22)) return ZodiacSign.cancer;
    if ((m == 7 && d >= 23) || (m == 8 && d <= 22)) return ZodiacSign.leo;
    if ((m == 8 && d >= 23) || (m == 9 && d <= 22)) return ZodiacSign.virgo;
    if ((m == 9 && d >= 23) || (m == 10 && d <= 22)) return ZodiacSign.libra;
    if ((m == 10 && d >= 23) || (m == 11 && d <= 21)) return ZodiacSign.scorpio;
    if ((m == 11 && d >= 22) || (m == 12 && d <= 21)) {
      return ZodiacSign.sagittarius;
    }
    if ((m == 12 && d >= 22) || (m == 1 && d <= 19)) {
      return ZodiacSign.capricorn;
    }
    if ((m == 1 && d >= 20) || (m == 2 && d <= 18)) return ZodiacSign.aquarius;
    return ZodiacSign.pisces;
  }
}
