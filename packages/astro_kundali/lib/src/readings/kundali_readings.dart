/// Plain-language glosses so the UI never shows a bare Sanskrit / technical
/// term. Deliberately short and non-deterministic-sounding — the real reading
/// is "talk to an astrologer". Structural only; no predictions.
class KundaliReadings {
  const KundaliReadings._();

  static const signKeywords = <String, String>{
    'Aries': 'bold, direct, quick to start',
    'Taurus': 'steady, sensual, values comfort and security',
    'Gemini': 'curious, verbal, quick-thinking',
    'Cancer': 'caring, protective, led by feeling',
    'Leo': 'proud, warm, wants to be seen',
    'Virgo': 'precise, useful, improvement-minded',
    'Libra': 'fair, relational, seeks balance',
    'Scorpio': 'intense, private, all-or-nothing',
    'Sagittarius': 'free, believing, big-picture',
    'Capricorn': 'disciplined, ambitious, plays the long game',
    'Aquarius': 'independent, systems-minded, unconventional',
    'Pisces': 'imaginative, compassionate, boundary-less',
  };

  static const planetKeywords = <String, String>{
    'Sun': 'soul, confidence, father, authority',
    'Moon': 'mind, emotions, mother, comfort',
    'Mars': 'drive, courage, anger, siblings',
    'Mercury': 'intellect, speech, trade, skill',
    'Jupiter': 'wisdom, growth, luck, teachers, children',
    'Venus': 'love, beauty, comfort, partnership, art',
    'Saturn': 'discipline, time, limits, hard-won reward',
    'Rahu': 'ambition, obsession, the foreign and new',
    'Ketu': 'detachment, mastery, letting go, spirituality',
  };

  static const houseTitles = <int, String>{
    1: 'Self, body, vitality',
    2: 'Wealth, family, speech, food',
    3: 'Courage, siblings, effort, short travel',
    4: 'Home, mother, land, inner peace',
    5: 'Children, education, creativity, romance',
    6: 'Health, debt, enemies, daily work',
    7: 'Marriage, partnership, business',
    8: 'Longevity, sudden change, the hidden, inheritance',
    9: 'Fortune, dharma, father, higher learning, long travel',
    10: 'Career, status, public life',
    11: 'Income, gains, network, elder siblings',
    12: 'Loss, expenses, foreign lands, sleep, liberation',
  };

  static const houseSanskrit = <int, String>{
    1: 'Tanu Bhava',
    2: 'Dhana Bhava',
    3: 'Sahaja Bhava',
    4: 'Sukha Bhava',
    5: 'Putra Bhava',
    6: 'Ripu Bhava',
    7: 'Yuvati Bhava',
    8: 'Ayu / Randhra Bhava',
    9: 'Dharma Bhava',
    10: 'Karma Bhava',
    11: 'Labha Bhava',
    12: 'Vyaya Bhava',
  };

  static const dignityLabel = <String, String>{
    'exalted': 'Exalted — very strong',
    'debilitated': 'Debilitated — under strain here',
    'moolatrikona': 'Moolatrikona — comfortable and strong',
    'own': 'Own sign — stable and effective',
    'great_friend_sign': "In a great friend's sign — supported",
    'friend_sign': "In a friend's sign — supported",
    'neutral': 'Neutral sign',
    'enemy_sign': "In an enemy's sign — works harder",
    'great_enemy_sign': "In a great enemy's sign — under pressure",
  };

  static const dashaTone = <String, String>{
    'Sun': 'A period for identity, authority and recognition. Ego and health of the eyes/heart come into focus.',
    'Moon': 'A softer, more emotional chapter — home, mother, moods and public life.',
    'Mars': 'Energy, competition and initiative rise. Watch temper, accidents and property matters.',
    'Mercury': 'Learning, trading, writing and communication. Good for study and business, restless for stillness.',
    'Jupiter': 'Growth, teachers, family, meaning. Often a fortunate, expansive phase.',
    'Venus': 'Relationships, comfort, art, money and pleasure. Usually the easiest of the periods.',
    'Saturn': 'Hard work, responsibility and slow, lasting results. Rewards patience; punishes shortcuts.',
    'Rahu': 'Ambition without limits — foreign lands, technology, sudden rises and confusion.',
    'Ketu': 'Detachment, endings and spiritual turning inward. Material things feel hollow; skill deepens.',
  };

  static const nakshatra = <String, String>{
    'Ashwini': 'quick, pioneering, healing',
    'Bharani': 'intense, holds space for change, disciplined',
    'Krittika': 'sharp, cutting through, protective',
    'Rohini': 'creative, sensual, nurturing, magnetic',
    'Mrigashira': 'searching, curious, gentle',
    'Ardra': 'stormy, transformative, brilliant under pressure',
    'Punarvasu': 'renewing, generous, returns to safety',
    'Pushya': 'nourishing, dutiful, deeply supportive',
    'Ashlesha': 'perceptive, strategic, hypnotic',
    'Magha': 'regal, tradition-bound, ancestral',
    'Purva Phalguni': 'playful, romantic, values leisure',
    'Uttara Phalguni': 'reliable, contractual, helpful',
    'Hasta': 'skilled with the hands, clever, healing',
    'Chitra': 'artistic, striking, builds beautiful things',
    'Swati': 'independent, adaptable, freedom-loving',
    'Vishakha': 'goal-driven, determined, dual-natured',
    'Anuradha': 'devoted, friendly, thrives abroad',
    'Jyeshtha': 'senior, responsible, carries burdens',
    'Mula': 'root-seeking, radical, gets to the core',
    'Purva Ashadha': 'invincible spirit, persuasive',
    'Uttara Ashadha': 'principled, enduring, later success',
    'Shravana': 'listening, learning, connecting people',
    'Dhanishta': 'rhythmic, wealthy, musical, adaptable',
    'Shatabhisha': 'private, healing, systems-minded',
    'Purva Bhadrapada': 'idealistic, intense, transformative',
    'Uttara Bhadrapada': 'deep, calm, wise counsel',
    'Revati': 'kind, protective of travellers, imaginative',
  };

  static String sign(String s) => signKeywords[s] ?? '';
  static String planet(String p) => planetKeywords[p] ?? '';
  static String house(int h) => houseTitles[h] ?? '';
  static String dignity(String d) => dignityLabel[d] ?? d;
  static String dashaOf(String lord) => dashaTone[lord] ?? '';
  static String nak(String n) => nakshatra[n] ?? '';

  /// "Your Moon in Taurus makes you steady, sensual… In the 4th house it links
  /// your emotions to home and land."
  static String planetInSignHouse(String planet, String sign, int house) {
    final s = KundaliReadings.sign(sign);
    final h = KundaliReadings.house(house).toLowerCase();
    final sTxt = s.isEmpty ? '' : ' makes you $s';
    final hTxt = house == 0 ? '' : ' In the ${_ordinal(house)} house it touches $h.';
    return 'Your $planet in $sign$sTxt.$hTxt';
  }

  static String mangalDosha(List<String> from) {
    if (from.isEmpty) return 'Not Manglik — Mars is clear of the sensitive houses.';
    final refs = from
        .map((f) => switch (f) {
              'lagna' => 'the Lagna',
              'moon' => 'the Moon',
              'venus' => 'Venus',
              _ => f,
            })
        .join(' and ');
    final strength = from.length > 1 ? 'considered stronger' : 'considered mild';
    return 'Manglik — Mars falls in a sensitive house from $refs. '
        'Flagged from ${from.length == 1 ? 'one reference' : '${from.length} references'}, so it is $strength. '
        'It commonly cancels when the partner is also Manglik or Jupiter aspects Mars; an astrologer confirms this before marriage matching.';
  }

  static String sadeSati(String phase) => switch (phase) {
    'rising' => 'Rising phase — Saturn is in the 12th sign from your Moon. '
        'Endings, tiredness and a sense of things winding down. Start clearing what no longer works.',
    'peak' => 'Peak phase — Saturn is over your Moon sign itself. '
        'The heaviest stretch: responsibility, pressure and slow progress. Keep routines, protect your health.',
    'setting' => 'Setting phase — Saturn is in the 2nd sign from your Moon. '
        'The weight lifts. Money and family stabilise; the lessons of the last years start paying off.',
    _ => 'Saturn is transiting the signs around your Moon.',
  };

  static String _ordinal(int n) {
    if (n >= 11 && n <= 13) return '${n}th';
    return switch (n % 10) {
      1 => '${n}st',
      2 => '${n}nd',
      3 => '${n}rd',
      _ => '${n}th',
    };
  }

  static String ordinal(int n) => _ordinal(n);
}
