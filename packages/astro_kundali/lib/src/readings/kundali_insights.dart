import 'package:flutter/material.dart' show IconData, Icons;

import '../models/overview.dart';

/// English fallback layer for the free D1 overview (`/overview`). Gives the UI a
/// title, a short "what this reads from" blurb, a tone word, an icon per life
/// area, and a one-line gloss for each governing factor.
///
/// The customer app localises the title / tone / blurb through ARB; the
/// per-factor lines fall back to these strings until roadmap Phase 1 keys them.
/// Deliberately descriptive — never a prediction.
class KundaliInsights {
  const KundaliInsights._();

  /// The order the sections are shown in.
  static const areaOrder = <String>[
    'personality',
    'appearance',
    'mind_emotions',
    'career',
    'wealth',
    'education',
    'marriage',
    'family',
    'health',
    'fortune',
    'strengths_challenges',
  ];

  static const _title = <String, String>{
    'personality': 'Personality & Nature',
    'appearance': 'Physical Appearance',
    'mind_emotions': 'Mind & Emotions',
    'career': 'Career & Profession',
    'wealth': 'Wealth & Finances',
    'education': 'Education & Intellect',
    'marriage': 'Marriage & Spouse',
    'family': 'Family & Relationships',
    'health': 'Health & Vitality',
    'fortune': 'Fortune & Dharma',
    'strengths_challenges': 'Strengths & Challenges',
  };

  static const _blurb = <String, String>{
    'personality': 'From your rising sign, its ruler, the Moon and the Sun.',
    'appearance': 'From the rising sign, its lord and what touches the 1st house.',
    'mind_emotions': 'From the Moon — its sign, house, nakshatra and company.',
    'career': 'From the 10th house, its lord and the planets in it.',
    'wealth': 'From the 2nd and 11th houses, their lords and Jupiter.',
    'education': 'From the 4th and 5th houses, Mercury and Jupiter.',
    'marriage': 'From the 7th house and sign, its lord, Venus and the Darakaraka.',
    'family': 'From the 2nd, 3rd and 4th houses, the Sun and the Moon.',
    'health': 'From the 1st house and its lord, the 6th house and any malefics on it.',
    'fortune': 'From the 9th house and its lord, the 5th house and Jupiter.',
    'strengths_challenges': 'The supportive yogas and the doshas to keep an eye on.',
  };

  static String title(String area) => _title[area] ?? area;

  static String blurb(String area) => _blurb[area] ?? '';

  static String toneWord(String tone) => switch (tone) {
    'supportive' => 'Supportive',
    'challenging' => 'Needs care',
    'mixed' => 'Mixed',
    _ => 'Balanced',
  };

  static IconData icon(String area) => switch (area) {
    'personality' => Icons.face_retouching_natural_outlined,
    'appearance' => Icons.accessibility_new_rounded,
    'mind_emotions' => Icons.psychology_outlined,
    'career' => Icons.work_outline_rounded,
    'wealth' => Icons.savings_outlined,
    'education' => Icons.school_outlined,
    'marriage' => Icons.favorite_outline_rounded,
    'family' => Icons.diversity_1_outlined,
    'health' => Icons.monitor_heart_outlined,
    'fortune' => Icons.auto_awesome_outlined,
    'strengths_challenges' => Icons.balance_outlined,
    _ => Icons.circle_outlined,
  };

  /// A single readable line for one factor. Empty string → don't render it.
  static String factorText(OverviewFactor f) {
    switch (f.key) {
      case 'overview.factor.lagna_sign':
        return 'Rising sign ${f.sign}';
      case 'overview.factor.lagna_lord':
        final where = f.inHouse > 0 ? ' in the ${_ord(f.inHouse)} house' : '';
        final dig = f.dignity.isNotEmpty ? ' (${_dignity(f.dignity)})' : '';
        return 'Ascendant lord ${f.planet}$where$dig';
      case 'overview.factor.house_lord':
        final where = f.inHouse > 0 ? ' in the ${_ord(f.inHouse)} house' : '';
        return '${_ord(f.house)}-house lord ${f.planet}$where';
      case 'overview.factor.house_strength':
        return '${_ord(f.house)} house — ${_strength(f.strength)}';
      case 'overview.factor.moon_sign':
        return 'Moon in ${f.sign}';
      case 'overview.factor.moon_house':
        return 'Moon in the ${_ord(f.house)} house';
      case 'overview.factor.moon_nakshatra':
        return 'Moon nakshatra ${f.nakshatra}'
            '${f.pada > 0 ? ' · pada ${f.pada}' : ''}';
      case 'overview.factor.moon_dignity':
        return 'Moon ${_dignity(f.dignity)}';
      case 'overview.factor.sun_sign':
        return 'Sun in ${f.sign}';
      case 'overview.factor.seventh_sign':
        return '7th house in ${f.sign}';
      case 'overview.factor.planet_in_house':
        return '${f.planet} in the ${_ord(f.house)} house';
      case 'overview.factor.planet_with_moon':
        return '${f.planet} with the Moon';
      case 'overview.factor.appearance_influence':
        return '${f.planet} ${f.occupant ? 'in' : 'aspecting'} the 1st house';
      case 'overview.factor.malefic_on_lagna':
        return '${f.planet} pressing on the ascendant';
      case 'overview.factor.karaka':
        return '${_role(f.role)}: ${f.planet}';
      case 'overview.factor.yoga':
        return 'Yoga — ${f.name}';
      case 'overview.factor.dosha':
        final sev = f.netSeverity > 0 ? ' (${_strength(f.netSeverity)})' : '';
        return 'Dosha — ${f.name}$sev';
      default:
        return '';
    }
  }

  static String _role(String role) => switch (role) {
    'spouse' => 'Spouse significator',
    'darakaraka' => 'Darakaraka (Jaimini)',
    'wealth' => 'Wealth significator',
    'intellect' => 'Intellect significator',
    'wisdom' => 'Wisdom significator',
    'fortune' => 'Fortune significator',
    'father' => 'Father significator',
    'mother' => 'Mother significator',
    _ => 'Significator',
  };

  static String _dignity(String d) => switch (d) {
    'exalted' => 'exalted',
    'moolatrikona' => 'moolatrikona',
    'own' => 'own sign',
    'great_friend_sign' => "great friend's sign",
    'friend_sign' => "friend's sign",
    'neutral' => 'neutral sign',
    'enemy_sign' => "enemy's sign",
    'great_enemy_sign' => "great enemy's sign",
    'debilitated' => 'debilitated',
    _ => d,
  };

  static String _strength(int s) => switch (s) {
    >= 3 => 'strong',
    2 => 'steady',
    1 => 'under strain',
    0 => 'weak',
    _ => 'mixed',
  };

  static String _ord(int n) {
    if (n >= 11 && n <= 13) return '${n}th';
    return switch (n % 10) {
      1 => '${n}st',
      2 => '${n}nd',
      3 => '${n}rd',
      _ => '${n}th',
    };
  }
}
