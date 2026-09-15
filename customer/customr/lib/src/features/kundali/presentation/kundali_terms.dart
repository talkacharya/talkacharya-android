import 'package:astro_kundali/astro_kundali.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/l10n/l10n.dart';
import 'cubit/kundali_cubit.dart';

/// Localises the package chart widgets for everything below it. A language
/// switch re-labels charts in place and re-fetches the server-written readings
/// (see [KundaliCubit.reloadForLanguage]).
class KundaliL10nScope extends StatefulWidget {
  const KundaliL10nScope({required this.child, super.key});
  final Widget child;

  @override
  State<KundaliL10nScope> createState() => _KundaliL10nScopeState();
}

class _KundaliL10nScopeState extends State<KundaliL10nScope> {
  Locale? _locale;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final locale = Localizations.localeOf(context);
    if (_locale != null && _locale != locale) {
      context.read<KundaliCubit>().reloadForLanguage();
    }
    _locale = locale;
  }

  @override
  Widget build(BuildContext context) => KundaliStringsScope(
    strings: KTerms.chartStrings(context.l10n),
    child: widget.child,
  );
}

/// Localised kundali glosses — the reading-content layer (sign / planet / house
/// keywords, dignity labels, dasha tones, nakshatra traits, and the Sade Sati /
/// planet-in-sign composers). Backed by the app's ARB; falls back to the
/// package's English [KundaliReadings] for anything not yet keyed.
///
/// Two kinds of lookup, kept deliberately separate: *glosses* ([planet],
/// [sign], [nakshatra] — "soul, confidence, father, authority" for the Sun)
/// feed reading prose; *names* ([planetName], [signName], [nakshatraName],
/// [chartName]) are what a label displays. Backend payloads carry canonical
/// English names; every displayed name should go through a *name* lookup.
class KTerms {
  const KTerms._();

  static String sign(AppLocalizations l, String s) => switch (s) {
    'Aries' => l.kSignAries,
    'Taurus' => l.kSignTaurus,
    'Gemini' => l.kSignGemini,
    'Cancer' => l.kSignCancer,
    'Leo' => l.kSignLeo,
    'Virgo' => l.kSignVirgo,
    'Libra' => l.kSignLibra,
    'Scorpio' => l.kSignScorpio,
    'Sagittarius' => l.kSignSagittarius,
    'Capricorn' => l.kSignCapricorn,
    'Aquarius' => l.kSignAquarius,
    'Pisces' => l.kSignPisces,
    _ => KundaliReadings.sign(s),
  };

  static String planet(AppLocalizations l, String p) => switch (p) {
    'Sun' => l.kPlanetSun,
    'Moon' => l.kPlanetMoon,
    'Mars' => l.kPlanetMars,
    'Mercury' => l.kPlanetMercury,
    'Jupiter' => l.kPlanetJupiter,
    'Venus' => l.kPlanetVenus,
    'Saturn' => l.kPlanetSaturn,
    'Rahu' => l.kPlanetRahu,
    'Ketu' => l.kPlanetKetu,
    _ => KundaliReadings.planet(p),
  };

  /// The planet's proper name — e.g. `Sun` → `Sun` (en) / `सूर्य` (hi).
  /// Unlike [planet] (a keyword gloss for reading prose), this is the name
  /// as displayed: chart tokens, legends, dasha rails.
  static String planetName(AppLocalizations l, String p) => switch (p) {
    'Sun' => l.kPlanetNameSun,
    'Moon' => l.kPlanetNameMoon,
    'Mars' => l.kPlanetNameMars,
    'Mercury' => l.kPlanetNameMercury,
    'Jupiter' => l.kPlanetNameJupiter,
    'Venus' => l.kPlanetNameVenus,
    'Saturn' => l.kPlanetNameSaturn,
    'Rahu' => l.kPlanetNameRahu,
    'Ketu' => l.kPlanetNameKetu,
    _ => p,
  };

  /// The sign's proper name — `Libra` → `तुला` (hi).
  static String signName(AppLocalizations l, String s) => switch (s) {
    'Aries' => l.kSignNameAries,
    'Taurus' => l.kSignNameTaurus,
    'Gemini' => l.kSignNameGemini,
    'Cancer' => l.kSignNameCancer,
    'Leo' => l.kSignNameLeo,
    'Virgo' => l.kSignNameVirgo,
    'Libra' => l.kSignNameLibra,
    'Scorpio' => l.kSignNameScorpio,
    'Sagittarius' => l.kSignNameSagittarius,
    'Capricorn' => l.kSignNameCapricorn,
    'Aquarius' => l.kSignNameAquarius,
    'Pisces' => l.kSignNamePisces,
    _ => s,
  };

  /// The nakshatra's proper name — `Swati` → `स्वाति` (hi).
  static String nakshatraName(AppLocalizations l, String n) => switch (n) {
    'Ashwini' => l.kNakNameAshwini,
    'Bharani' => l.kNakNameBharani,
    'Krittika' => l.kNakNameKrittika,
    'Rohini' => l.kNakNameRohini,
    'Mrigashira' => l.kNakNameMrigashira,
    'Ardra' => l.kNakNameArdra,
    'Punarvasu' => l.kNakNamePunarvasu,
    'Pushya' => l.kNakNamePushya,
    'Ashlesha' => l.kNakNameAshlesha,
    'Magha' => l.kNakNameMagha,
    'Purva Phalguni' => l.kNakNamePurvaPhalguni,
    'Uttara Phalguni' => l.kNakNameUttaraPhalguni,
    'Hasta' => l.kNakNameHasta,
    'Chitra' => l.kNakNameChitra,
    'Swati' => l.kNakNameSwati,
    'Vishakha' => l.kNakNameVishakha,
    'Anuradha' => l.kNakNameAnuradha,
    'Jyeshtha' => l.kNakNameJyeshtha,
    'Mula' => l.kNakNameMula,
    'Purva Ashadha' => l.kNakNamePurvaAshadha,
    'Uttara Ashadha' => l.kNakNameUttaraAshadha,
    'Shravana' => l.kNakNameShravana,
    'Dhanishta' => l.kNakNameDhanishta,
    'Shatabhisha' => l.kNakNameShatabhisha,
    'Purva Bhadrapada' => l.kNakNamePurvaBhadrapada,
    'Uttara Bhadrapada' => l.kNakNameUttaraBhadrapada,
    'Revati' => l.kNakNameRevati,
    _ => n,
  };

  // --- panchang limbs (engine emits canonical English / lowercase keys) -----

  static String _select(
    String Function(String key, Object raw) msg,
    String r,
  ) => msg(r.replaceAll(' ', ''), r);

  /// `Saptami` → `सप्तमी` (hi).
  static String tithiName(AppLocalizations l, String t) =>
      _select(l.kBdTithi, t);

  /// `Shukla` / `Krishna`.
  static String pakshaName(AppLocalizations l, String p) =>
      _select(l.kBdPaksha, p);

  static String yogaName(AppLocalizations l, String y) => _select(l.kBdYoga, y);

  static String karanaName(AppLocalizations l, String k) =>
      _select(l.kBdKarana, k);

  /// `Monday` → `Somvara (Monday)`.
  static String vaaraName(AppLocalizations l, String v) => switch (v) {
    'Monday' => l.vaaraMonday,
    'Tuesday' => l.vaaraTuesday,
    'Wednesday' => l.vaaraWednesday,
    'Thursday' => l.vaaraThursday,
    'Friday' => l.vaaraFriday,
    'Saturday' => l.vaaraSaturday,
    'Sunday' => l.vaaraSunday,
    _ => v,
  };

  /// Engine key `udveg` / `char` / … → `Udveg` / `उद्वेग`.
  static String choghadiyaName(AppLocalizations l, String key) =>
      l.kMuChoghadiya(
        key,
        key.isEmpty ? key : '${key[0].toUpperCase()}${key.substring(1)}',
      );

  /// Any canonical name the engine emits — planet, sign or nakshatra — as
  /// displayed; unknown text is returned unchanged.
  static String displayName(AppLocalizations l, String s) {
    final t = s.trim();
    final p = planetName(l, t);
    if (p != t) return p;
    final g = signName(l, t);
    if (g != t) return g;
    return nakshatraName(l, t);
  }

  /// [displayName] over each item of a list / comma-separated string.
  static String displayNames(AppLocalizations l, Iterable<String> names) =>
      names.map((n) => displayName(l, n)).join(', ');

  static String displayNameCsv(AppLocalizations l, String csv) =>
      displayNames(l, csv.split(','));

  /// Chart title by type key; [fallback] is the payload's English name.
  static String chartName(AppLocalizations l, String type, String fallback) =>
      switch (type) {
        'd1' => l.kChartNameD1,
        'd2' => l.kChartNameD2,
        'd3' => l.kChartNameD3,
        'd4' => l.kChartNameD4,
        'd5' => l.kChartNameD5,
        'd6' => l.kChartNameD6,
        'd7' => l.kChartNameD7,
        'd8' => l.kChartNameD8,
        'd9' => l.kChartNameD9,
        'd10' => l.kChartNameD10,
        'd11' => l.kChartNameD11,
        'd12' => l.kChartNameD12,
        'd16' => l.kChartNameD16,
        'd20' => l.kChartNameD20,
        'd24' => l.kChartNameD24,
        'd27' => l.kChartNameD27,
        'd30' => l.kChartNameD30,
        'd40' => l.kChartNameD40,
        'd45' => l.kChartNameD45,
        'd60' => l.kChartNameD60,
        'moon' || 'chandra' => l.kChartNameMoon,
        'bhava_chalit' => l.kChartNameChalit,
        'transit' => l.kChartNameTransit,
        _ => fallback,
      };

  static String chartSignifies(
    AppLocalizations l,
    String type,
    String fallback,
  ) => switch (type) {
    'd1' => l.kChartSigD1,
    'd2' => l.kChartSigD2,
    'd3' => l.kChartSigD3,
    'd4' => l.kChartSigD4,
    'd5' => l.kChartSigD5,
    'd6' => l.kChartSigD6,
    'd7' => l.kChartSigD7,
    'd8' => l.kChartSigD8,
    'd9' => l.kChartSigD9,
    'd10' => l.kChartSigD10,
    'd11' => l.kChartSigD11,
    'd12' => l.kChartSigD12,
    'd16' => l.kChartSigD16,
    'd20' => l.kChartSigD20,
    'd24' => l.kChartSigD24,
    'd27' => l.kChartSigD27,
    'd30' => l.kChartSigD30,
    'd40' => l.kChartSigD40,
    'd45' => l.kChartSigD45,
    'd60' => l.kChartSigD60,
    'moon' || 'chandra' => l.kChartSigMoon,
    'bhava_chalit' => l.kChartSigChalit,
    'transit' => l.kChartSigTransit,
    _ => fallback,
  };

  static String chartShortLabel(AppLocalizations l, String type) =>
      switch (type) {
        'moon' || 'chandra' => l.kChartShortMoon,
        'bhava_chalit' => l.kChartShortChalit,
        'transit' => l.kChartShortTransit,
        _ => type.toUpperCase(),
      };

  /// The package chart widgets' copy, filled from this app's ARB. Provided to
  /// the whole kundali section by [KundaliStringsScope] in the router.
  static KundaliStrings chartStrings(AppLocalizations l) => KundaliStrings(
    planetName: (p) => planetName(l, p),
    signName: (s) => signName(l, s),
    chartName: (t, f) => chartName(l, t, f),
    chartSignifies: (t, f) => chartSignifies(l, t, f),
    chartShortLabel: (t) => chartShortLabel(l, t),
    ascendant: l.kChAscendant,
    lagnaVargottama: l.kChLagnaVargottama,
    asOf: l.kChAsOf,
    unverified: l.kChUnverified,
    chalitShifted: (planets, count) => count == 1
        ? l.kChChalitShiftedOne(planets)
        : l.kChChalitShiftedMany(planets),
    colPlanet: l.kChColPlanet,
    colSign: l.kChColSign,
    colDegree: l.kChColDegree,
    colHouse: l.kChColHouse,
    colBhava: l.kChColBhava,
    colFromMoon: l.kChColFromMoon,
    legend: l.kChLegend,
    legendNote: l.kChLegendNote,
    northIndian: l.kChNorthIndian,
    southIndian: l.kChSouthIndian,
    pickerCharts: l.kChPickerCharts,
    pickerDivisional: l.kChPickerDivisional,
    retry: l.homeRetryBtn,
  );

  static String house(AppLocalizations l, int h) => switch (h) {
    1 => l.kHouse1,
    2 => l.kHouse2,
    3 => l.kHouse3,
    4 => l.kHouse4,
    5 => l.kHouse5,
    6 => l.kHouse6,
    7 => l.kHouse7,
    8 => l.kHouse8,
    9 => l.kHouse9,
    10 => l.kHouse10,
    11 => l.kHouse11,
    12 => l.kHouse12,
    _ => KundaliReadings.house(h),
  };

  static String dignity(AppLocalizations l, String d) => switch (d) {
    'exalted' => l.kDignityExalted,
    'debilitated' => l.kDignityDebilitated,
    'moolatrikona' => l.kDignityMoolatrikona,
    'own' => l.kDignityOwn,
    'great_friend_sign' => l.kDignityGreatFriend,
    'friend_sign' => l.kDignityFriend,
    'neutral' => l.kDignityNeutral,
    'enemy_sign' => l.kDignityEnemy,
    'great_enemy_sign' => l.kDignityGreatEnemy,
    _ => KundaliReadings.dignity(d),
  };

  /// Short badge label — exalted / moolatrikona / own / debilitated / enemy.
  static String dignityShort(AppLocalizations l, String d) => switch (d) {
    'exalted' => l.kDignityShortExalted,
    'moolatrikona' => l.kDignityShortMoolatrikona,
    'own' => l.kDignityShortOwn,
    'debilitated' => l.kDignityShortDebilitated,
    'enemy_sign' => l.kDignityShortEnemy,
    'great_enemy_sign' => l.kDignityShortGreatEnemy,
    _ => '',
  };

  static String dashaTone(AppLocalizations l, String lord) => switch (lord) {
    'Sun' => l.kDashaSun,
    'Moon' => l.kDashaMoon,
    'Mars' => l.kDashaMars,
    'Mercury' => l.kDashaMercury,
    'Jupiter' => l.kDashaJupiter,
    'Venus' => l.kDashaVenus,
    'Saturn' => l.kDashaSaturn,
    'Rahu' => l.kDashaRahu,
    'Ketu' => l.kDashaKetu,
    _ => KundaliReadings.dashaOf(lord),
  };

  static String nakshatra(AppLocalizations l, String n) => switch (n) {
    'Ashwini' => l.kNakAshwini,
    'Bharani' => l.kNakBharani,
    'Krittika' => l.kNakKrittika,
    'Rohini' => l.kNakRohini,
    'Mrigashira' => l.kNakMrigashira,
    'Ardra' => l.kNakArdra,
    'Punarvasu' => l.kNakPunarvasu,
    'Pushya' => l.kNakPushya,
    'Ashlesha' => l.kNakAshlesha,
    'Magha' => l.kNakMagha,
    'Purva Phalguni' => l.kNakPurvaPhalguni,
    'Uttara Phalguni' => l.kNakUttaraPhalguni,
    'Hasta' => l.kNakHasta,
    'Chitra' => l.kNakChitra,
    'Swati' => l.kNakSwati,
    'Vishakha' => l.kNakVishakha,
    'Anuradha' => l.kNakAnuradha,
    'Jyeshtha' => l.kNakJyeshtha,
    'Mula' => l.kNakMula,
    'Purva Ashadha' => l.kNakPurvaAshadha,
    'Uttara Ashadha' => l.kNakUttaraAshadha,
    'Shravana' => l.kNakShravana,
    'Dhanishta' => l.kNakDhanishta,
    'Shatabhisha' => l.kNakShatabhisha,
    'Purva Bhadrapada' => l.kNakPurvaBhadrapada,
    'Uttara Bhadrapada' => l.kNakUttaraBhadrapada,
    'Revati' => l.kNakRevati,
    _ => KundaliReadings.nak(n),
  };

  static const _hiOrd = <String>[
    '',
    'पहला',
    'दूसरा',
    'तीसरा',
    'चौथा',
    'पाँचवाँ',
    'छठा',
    'सातवाँ',
    'आठवाँ',
    'नौवाँ',
    'दसवाँ',
    'ग्यारहवाँ',
    'बारहवाँ',
  ];
  static const _hiOrdOblique = <String>[
    '',
    'पहले',
    'दूसरे',
    'तीसरे',
    'चौथे',
    'पाँचवें',
    'छठे',
    'सातवें',
    'आठवें',
    'नौवें',
    'दसवें',
    'ग्यारहवें',
    'बारहवें',
  ];

  static bool _isHi(AppLocalizations l) => l.localeName.startsWith('hi');

  /// "7th" / "7वाँ" — the standalone ordinal.
  static String ordinal(AppLocalizations l, int n) => _isHi(l)
      ? (n >= 1 && n <= 12 ? _hiOrd[n] : '$n')
      : KundaliReadings.ordinal(n);

  /// "7th house" / "सातवें भाव" — the phrase used mid-sentence.
  static String nthHouse(AppLocalizations l, int n) => _isHi(l)
      ? '${n >= 1 && n <= 12 ? _hiOrdOblique[n] : "$n"} भाव'
      : '${KundaliReadings.ordinal(n)} house';

  static String houseSanskrit(AppLocalizations l, int h) => switch (h) {
    1 => l.kHouseSans1,
    2 => l.kHouseSans2,
    3 => l.kHouseSans3,
    4 => l.kHouseSans4,
    5 => l.kHouseSans5,
    6 => l.kHouseSans6,
    7 => l.kHouseSans7,
    8 => l.kHouseSans8,
    9 => l.kHouseSans9,
    10 => l.kHouseSans10,
    11 => l.kHouseSans11,
    12 => l.kHouseSans12,
    _ => KundaliReadings.houseSanskrit[h] ?? '',
  };

  static String sadeSati(AppLocalizations l, String phase) => switch (phase) {
    'rising' => l.kSadeSatiRising,
    'peak' => l.kSadeSatiPeak,
    'setting' => l.kSadeSatiSetting,
    _ => l.kSadeSatiGeneric,
  };

  /// "Your Moon in Taurus makes you steady… In the 4th house it touches home
  /// and land." — [house] 0 drops the house clause.
  static String planetInSignHouse(
    AppLocalizations l,
    String planet,
    String sign,
    int house,
  ) {
    final trait = KTerms.sign(l, sign);
    final p = planetName(l, planet);
    final s = signName(l, sign);
    if (house == 0) {
      return l.kPlanetInSign(p, s, trait);
    }
    return l.kPlanetInSignHouse(
      p,
      s,
      trait,
      KundaliReadings.ordinal(house),
      KTerms.house(l, house).toLowerCase(),
    );
  }
}
