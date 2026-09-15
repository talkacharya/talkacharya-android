import 'package:equatable/equatable.dart';

import '../../../home/data/models/zodiac.dart';

/// Which reading the user is looking at. Maps onto
/// `GET /app/horoscope?period=&day=`.
enum HoroscopeSpan {
  yesterday('daily', 'yesterday'),
  today('daily', 'today'),
  tomorrow('daily', 'tomorrow'),
  week('weekly', null),
  month('monthly', null);

  const HoroscopeSpan(this.period, this.day);

  final String period;
  final String? day;

  bool get isDaily => period == 'daily';

  static HoroscopeSpan fromName(String? raw) {
    for (final s in values) {
      if (s.name == raw) return s;
    }
    return HoroscopeSpan.today;
  }
}

/// One life area (love / career / money / health) with a 1-5 score.
class HoroscopeArea extends Equatable {
  const HoroscopeArea({
    required this.key,
    required this.score,
    required this.tone,
    required this.text,
    this.driverPlanet,
    this.driverHouse,
  });

  final String key;
  final int score;

  /// `supportive` | `balanced` | `challenging`.
  final String tone;
  final String text;
  final String? driverPlanet;
  final int? driverHouse;

  factory HoroscopeArea.fromJson(Map<String, dynamic> j) {
    final driver = (j['driver'] as Map?)?.cast<String, dynamic>() ?? const {};
    return HoroscopeArea(
      key: '${j['key'] ?? ''}',
      score: _int(j['score'], 3),
      tone: '${j['tone'] ?? 'balanced'}',
      text: '${j['text'] ?? ''}',
      driverPlanet: driver['planet'] as String?,
      driverHouse: (driver['house'] as num?)?.toInt(),
    );
  }

  @override
  List<Object?> get props => [key, score, tone, text];
}

class HoroscopeTransit extends Equatable {
  const HoroscopeTransit({
    required this.planet,
    required this.planetLabel,
    required this.house,
    required this.sign,
    required this.signLabel,
    required this.favourable,
  });

  final String planet;
  final String planetLabel;
  final int house;
  final String sign;
  final String signLabel;
  final bool favourable;

  factory HoroscopeTransit.fromJson(Map<String, dynamic> j) => HoroscopeTransit(
    planet: '${j['planet'] ?? ''}',
    planetLabel: '${j['planet_label'] ?? j['planet'] ?? ''}',
    house: _int(j['house'], 1),
    sign: '${j['sign'] ?? ''}',
    signLabel: '${j['sign_label'] ?? j['sign'] ?? ''}',
    favourable: j['favourable'] == true,
  );

  @override
  List<Object?> get props => [planet, house, sign, favourable];
}

class HoroscopeLucky extends Equatable {
  const HoroscopeLucky({
    required this.colourLabel,
    required this.colourHex,
    required this.number,
    required this.planet,
    required this.planetLabel,
  });

  final String colourLabel;
  final String colourHex;
  final int number;
  final String planet;
  final String planetLabel;

  factory HoroscopeLucky.fromJson(Map<String, dynamic> j) => HoroscopeLucky(
    colourLabel: '${j['colour_label'] ?? ''}',
    colourHex: '${j['colour_hex'] ?? '#F2A93B'}',
    number: _int(j['number'], 1),
    planet: '${j['planet'] ?? ''}',
    planetLabel: '${j['planet_label'] ?? j['planet'] ?? ''}',
  );

  @override
  List<Object?> get props => [colourLabel, colourHex, number, planet];
}

/// A full sign reading from `GET /app/horoscope` (the backend's gochar engine).
/// A payload with only the minimal `prediction.*` block still parses, with the
/// richer sections left empty so the screen degrades gracefully.
class SignHoroscope extends Equatable {
  const SignHoroscope({
    required this.sign,
    required this.span,
    required this.headline,
    required this.general,
    required this.band,
    required this.overall,
    required this.areas,
    required this.start,
    required this.end,
    this.lucky,
    this.tip,
    this.tipPlanet,
    this.moonSignLabel,
    this.moonNakshatraLabel,
    this.moonHouse,
    this.transits = const [],
    this.favourableDays = const [],
    this.isEditorial = false,
  });

  final ZodiacSign sign;
  final HoroscopeSpan span;
  final String headline;
  final String general;
  final String band;

  /// 1..5
  final int overall;
  final List<HoroscopeArea> areas;
  final DateTime start;
  final DateTime end;
  final HoroscopeLucky? lucky;
  final String? tip;
  final String? tipPlanet;
  final String? moonSignLabel;
  final String? moonNakshatraLabel;
  final int? moonHouse;
  final List<HoroscopeTransit> transits;
  final List<DateTime> favourableDays;

  /// An astrologer-written reading replaced the computed text.
  final bool isEditorial;

  factory SignHoroscope.fromJson(
    ZodiacSign sign,
    HoroscopeSpan span,
    Map<String, dynamic> json,
  ) {
    final p = (json['payload'] as Map?)?.cast<String, dynamic>() ?? const {};
    final pred = (p['prediction'] is Map)
        ? (p['prediction'] as Map).cast<String, dynamic>()
        : const <String, dynamic>{};
    final scores = (p['scores'] as Map?)?.cast<String, dynamic>() ?? const {};
    final range = (p['range'] as Map?)?.cast<String, dynamic>() ?? const {};
    final moon = (p['moon'] as Map?)?.cast<String, dynamic>();
    final tip = (p['tip'] as Map?)?.cast<String, dynamic>();

    var areas = [
      for (final a in (p['areas'] as List? ?? const []))
        if (a is Map) HoroscopeArea.fromJson(a.cast<String, dynamic>()),
    ];
    if (areas.isEmpty) {
      // Legacy payload: text only, neutral scores.
      areas = [
        for (final k in const ['love', 'career', 'money', 'health'])
          if (_str(pred[k]) != null)
            HoroscopeArea(
              key: k,
              score: 3,
              tone: 'balanced',
              text: _str(pred[k])!,
            ),
      ];
    }

    var general = _str(pred['general']) ?? _str(p['prediction']) ?? '';
    var headline = _str(p['headline']) ?? '';

    // Editorial (astrologer-written) text wins when present.
    final editorial = (json['editorial'] as Map?)?.cast<String, dynamic>();
    final editorialBody = _str(editorial?['prediction']);
    if (editorialBody != null) {
      general = editorialBody;
      headline = '';
      areas = [
        for (final a in areas)
          HoroscopeArea(
            key: a.key,
            score: a.score,
            tone: a.tone,
            text: _str(editorial?[a.key]) ?? a.text,
            driverPlanet: a.driverPlanet,
            driverHouse: a.driverHouse,
          ),
      ];
    }
    // Headline is the first sentence of `general` — don't show it twice.
    if (headline.isNotEmpty && general.startsWith(headline)) {
      general = general.substring(headline.length).trim();
    }

    final today = DateTime.now();
    return SignHoroscope(
      sign: sign,
      span: span,
      headline: headline,
      general: general,
      band: _str(p['band']) ?? _str(pred['luck']) ?? '',
      overall: _int(scores['overall'], 3),
      areas: areas,
      start: DateTime.tryParse('${range['start'] ?? p['date'] ?? ''}') ?? today,
      end: DateTime.tryParse('${range['end'] ?? p['date'] ?? ''}') ?? today,
      lucky: p['lucky'] is Map
          ? HoroscopeLucky.fromJson((p['lucky'] as Map).cast<String, dynamic>())
          : null,
      tip: _str(tip?['text']),
      tipPlanet: _str(tip?['planet']),
      moonSignLabel: _str(moon?['sign_label']),
      moonNakshatraLabel: _str(moon?['nakshatra_label']),
      moonHouse: (moon?['house'] as num?)?.toInt(),
      transits: [
        for (final t in (p['transits'] as List? ?? const []))
          if (t is Map) HoroscopeTransit.fromJson(t.cast<String, dynamic>()),
      ],
      favourableDays: [
        for (final d in (p['favourable_days'] as List? ?? const []))
          ?DateTime.tryParse('$d'),
      ],
      isEditorial: editorialBody != null,
    );
  }

  /// Plain-text version for the share sheet.
  String shareText(String signName, String dateLabel) {
    final b = StringBuffer('$signName · $dateLabel\n\n');
    if (headline.isNotEmpty) b.writeln(headline);
    if (general.isNotEmpty) b.writeln(general);
    for (final a in areas) {
      b.writeln('\n${a.key[0].toUpperCase()}${a.key.substring(1)}: ${a.text}');
    }
    return b.toString().trim();
  }

  @override
  List<Object?> get props => [sign, span, general, overall, areas, start];
}

String? _str(dynamic v) {
  if (v is! String) return null;
  final s = v.trim();
  return s.isEmpty ? null : s;
}

int _int(dynamic v, int fallback) =>
    v is num ? v.toInt() : int.tryParse('$v') ?? fallback;
