import 'package:astro_kundali/astro_kundali.dart';
import 'package:flutter/material.dart';

import 'kundali_hi_terms.dart';

/// The language the kundali is read in. It is the kundali's own setting, not
/// the app's: an astrologer who works in English can still read a client's
/// chart in Hindi. Null follows the app's language; it lasts for the session.
final ValueNotifier<String?> kundaliLanguage = ValueNotifier<String?>(null);

/// Languages the engine writes its readings in.
const kKundaliLanguages = <String, String>{'en': 'English', 'hi': 'हिन्दी'};

/// The kundali language in effect for [context].
String kundaliLanguageOf(BuildContext context) {
  final picked = kundaliLanguage.value;
  if (picked != null) return picked;
  final app = Localizations.localeOf(context).languageCode;
  return kKundaliLanguages.containsKey(app) ? app : 'en';
}

/// Every word the kundali screens draw themselves, in the kundali's language.
///
/// The server writes the readings (summaries, reasons, remedies) in the
/// requested language, but keeps names and codes canonical English — "Libra",
/// "Saturn", `friend_sign`, `rising` — so apps can switch on them. [term] turns
/// those into what is displayed; the getters are the screens' own labels.
///
/// Kept in code rather than the ARB because it follows the kundali's language,
/// which can differ from the app's, and because the Hindi names are generated
/// from the engine's own catalog (`kundali_hi_terms.dart`) so labels and prose agree.
@immutable
class KT {
  const KT(this.lang);

  final String lang;

  bool get hi => lang == 'hi';

  static KT of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<KundaliTextScope>()?.text ??
      KT(kundaliLanguageOf(context));

  String _s(String en, String hindi) => hi ? hindi : en;

  // --- names and codes -------------------------------------------------------

  static const _enCodes = <String, String>{
    'friend_sign': "friend's sign",
    'great_friend_sign': "great friend's sign",
    'enemy_sign': "enemy's sign",
    'great_enemy_sign': "great enemy's sign",
    'neutral': 'neutral',
    'own': 'own sign',
    'moolank': 'Moolank',
    'bhagyank': 'Bhagyank',
    'naamank': 'Naamank',
    'muntha_lord': 'Muntha lord',
    'varsha_lagna_lord': 'Varsha Lagna lord',
    'sun_sign_lord': 'Sun-sign lord',
    'moon_sign_lord': 'Moon-sign lord',
    'birth_lagna_lord': 'birth Lagna lord',
  };

  static const _hiCodes = <String, String>{
    // dignities, as a short label
    'friend_sign': 'मित्र राशि',
    'great_friend_sign': 'अधिमित्र राशि',
    'enemy_sign': 'शत्रु राशि',
    'great_enemy_sign': 'अधिशत्रु राशि',
    'neutral': 'सम',
    'own': 'स्वराशि',
    'exalted': 'उच्च',
    'debilitated': 'नीच',
    'moolatrikona': 'मूलत्रिकोण',
    // tones and grades
    'supportive': 'अनुकूल',
    'balanced': 'संतुलित',
    'mixed': 'मिश्रित',
    'challenging': 'चुनौतीपूर्ण',
    'none': 'नहीं',
    'mild': 'हल्का',
    'moderate': 'मध्यम',
    'strong': 'प्रबल',
    'severe': 'तीव्र',
    'favourable': 'अनुकूल',
    'caution': 'सावधानी',
    'good': 'शुभ',
    'bad': 'अशुभ',
    'day': 'दिन',
    'night': 'रात',
    // roles in the upaya table
    'strengthen': 'बल दें',
    'pacify': 'शांत करें',
    // yoga families
    'wealth': 'धन',
    'mahapurusha': 'महापुरुष',
    'chandra': 'चंद्र',
    'lunar': 'चंद्र',
    'solar': 'सूर्य',
    'surya': 'सूर्य',
    'raja': 'राज',
    'dhana': 'धन',
    'affliction': 'पीड़ा',
    'vipreet': 'विपरीत राज',
    'parivartana': 'परिवर्तन',
    'kartari': 'कर्तरी',
    'general': 'सामान्य',
    'benefic': 'शुभ',
    'malefic': 'पाप',
    'nabhasa': 'नाभस',
    // numerology
    'moolank': 'मूलांक',
    'bhagyank': 'भाग्यांक',
    'naamank': 'नामांक',
    'strength': 'बल',
    'weakness': 'कमी',
    'partial': 'आंशिक',
    // remedy triggers and sources
    'dosha': 'दोष',
    'planet': 'ग्रह',
    'dasha': 'दशा',
    'house': 'भाव',
    'yoga': 'योग',
    'nakshatra': 'नक्षत्र',
    'classical': 'शास्त्रीय',
    'traditional': 'परंपरागत',
    'lal_kitab': 'लाल किताब',
    // varshphal
    'muntha_lord': 'मुंथेश',
    'varsha_lagna_lord': 'वर्ष लग्नेश',
    'sun_sign_lord': 'सूर्य राशि का स्वामी',
    'moon_sign_lord': 'चंद्र राशि का स्वामी',
    'birth_lagna_lord': 'जन्म लग्नेश',
    // dasha systems and the yoginis
    'vimshottari': 'विंशोत्तरी',
    'yogini': 'योगिनी',
    'ashtottari': 'अष्टोत्तरी',
    'Mangala': 'मंगला',
    'Pingala': 'पिंगला',
    'Dhanya': 'धान्या',
    'Bhramari': 'भ्रामरी',
    'Bhadrika': 'भद्रिका',
    'Ulka': 'उल्का',
    'Siddha': 'सिद्धा',
    'Sankata': 'संकटा',
    // Jaimini
    'Atmakaraka': 'आत्मकारक',
    'Amatyakaraka': 'अमात्यकारक',
    'Bhratrikaraka': 'भ्रातृकारक',
    'Matrikaraka': 'मातृकारक',
    'Putrakaraka': 'पुत्रकारक',
    'Gnatikaraka': 'ज्ञातिकारक',
    'Darakaraka': 'दारकारक',
    'lahiri': 'लाहिरी',
  };

  static const _hiKeys = <String, String>{
    'chara_karakas': 'चर कारक',
    'karaka_by_planet': 'ग्रह अनुसार कारक',
    'arudha_lagna': 'आरूढ़ लग्न',
    'arudhas': 'आरूढ़ पद',
    'upapada': 'उपपद',
    'karakamsha': 'कारकांश',
    'chara_dasha': 'चर दशा',
    'cuspal_sublords': 'भाव संधि उप-स्वामी',
    'house_significators': 'भाव कारक ग्रह',
    'planet_significators': 'ग्रहों के कारकत्व',
    'ruling_planets': 'शासक ग्रह',
    'planets': 'ग्रह',
    'ayanamsa': 'अयनांश',
    'system': 'पद्धति',
    'current': 'वर्तमान',
    'mahadashas': 'महादशाएँ',
    'antardashas': 'अंतर्दशाएँ',
    'sign': 'राशि',
    'sign_lord': 'राशि स्वामी',
    'star': 'नक्षत्र',
    'star_lord': 'नक्षत्र स्वामी',
    'sub_lord': 'उप-स्वामी',
    'sub_sub_lord': 'उप-उप-स्वामी',
    'lord': 'स्वामी',
    'house': 'भाव',
    'cusp': 'संधि',
    'degree': 'अंश',
    'longitude': 'भोगांश',
    'start': 'आरंभ',
    'end': 'अंत',
    'years': 'वर्ष',
    'day_lord': 'वार स्वामी',
    'moon_star_lord': 'चंद्र नक्षत्र स्वामी',
    'moon_sign_lord': 'चंद्र राशि स्वामी',
    'lagna_star_lord': 'लग्न नक्षत्र स्वामी',
    'lagna_sign_lord': 'लग्न राशि स्वामी',
    'lagna_sub_lord': 'लग्न उप-स्वामी',
  };

  /// A name or code from a payload — planet, sign, nakshatra, yoga, dosha,
  /// dignity, tone, phase, day, colour, gemstone — as it should be displayed.
  /// Anything unknown is returned as it came.
  String term(String raw) {
    final value = raw.trim();
    if (value.isEmpty) return value;
    if (!hi) return _enCodes[value] ?? value;
    return _hiCodes[value] ??
        kHiTerms[value] ??
        kHiTerms[value.replaceAll('_', ' ')] ??
        _hiCodes[value.toLowerCase()] ??
        kHiTerms[_capitalised(value)] ??
        value;
  }

  static String _capitalised(String s) =>
      s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';

  /// [term] over each of [values], joined.
  String terms(Iterable<String> values, {String separator = ', '}) =>
      values.map(term).join(separator);

  /// A payload field name (`sub_lord`) as a row label.
  String fieldName(String key) {
    if (hi) {
      final known = _hiKeys[key] ?? _hiCodes[key] ?? kHiTerms[key];
      if (known != null) return known;
    }
    return key.replaceAll('_', ' ');
  }

  /// A raw value of unknown shape, with every name in it translated. Used for
  /// the KP and Jaimini tables, which are shown as the engine sends them.
  String value(Object? v) {
    if (v is Map) {
      return v.entries
          .map((e) => '${fieldName('${e.key}')}: ${value(e.value)}')
          .join(', ');
    }
    if (v is List) return v.map(value).join(', ');
    if (v is String) return term(v);
    return '$v';
  }

  static const _hiOrdinals = <String>[
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
  static const _hiOrdinalsOblique = <String>[
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

  String _enOrdinal(int n) {
    if (n >= 11 && n <= 13) return '${n}th';
    return switch (n % 10) {
      1 => '${n}st',
      2 => '${n}nd',
      3 => '${n}rd',
      _ => '${n}th',
    };
  }

  /// "7th" / "सातवाँ".
  String ordinal(int n) =>
      hi ? (n >= 1 && n <= 12 ? _hiOrdinals[n] : '$n') : _enOrdinal(n);

  /// "the 7th house" / "सातवें भाव" — as used inside a sentence.
  String nthHouse(int n) => hi
      ? '${n >= 1 && n <= 12 ? _hiOrdinalsOblique[n] : '$n'} भाव'
      : 'the ${_enOrdinal(n)} house';

  /// Short house tag in a table: "H7" / "भाव 7".
  String h(int n) => hi ? 'भाव $n' : 'H$n';

  // --- page ------------------------------------------------------------------

  String get title => _s('Kundali', 'कुंडली');
  String titleFor(String name) => _s("$name's kundali", '$name की कुंडली');
  String get language => _s('Kundali language', 'कुंडली की भाषा');
  String get retry => _s('Retry', 'फिर कोशिश करें');
  String get noData => _s('No data', 'कोई जानकारी नहीं');
  String get loadFailed =>
      _s('Could not load this chart', 'यह कुंडली नहीं खुल सकी');

  List<String> get tabs => hi
      ? const [
          'कुंडलियाँ',
          'ग्रह',
          'दशा',
          'योग',
          'दोष',
          'सार',
          'उपाय',
          'भाव',
          'गोचर',
          'अंक',
          'विस्तृत',
        ]
      : const [
          'Charts',
          'Planets',
          'Dasha',
          'Yogas',
          'Doshas',
          'Overview',
          'Remedies',
          'Bhava',
          'Gochar',
          'Numbers',
          'Advanced',
        ];

  // --- charts ----------------------------------------------------------------

  String get allCharts => _s('All charts — D1 to D60', 'सभी कुंडलियाँ — D1 से D60');
  String get allChartsShort => _s('All charts', 'सभी कुंडलियाँ');

  String chartShortLabel(String type) => switch (type) {
    'moon' || 'chandra' => _s('Moon', kHiChartStrings['kChartShortMoon']!),
    'bhava_chalit' => _s('Chalit', kHiChartStrings['kChartShortChalit']!),
    'transit' => _s('Transit', kHiChartStrings['kChartShortTransit']!),
    _ => type.toUpperCase(),
  };

  static String _chartKey(String type) => switch (type) {
    'chandra' => 'moon',
    'bhava_chalit' => 'chalit',
    _ => type,
  };

  String chartName(String type, String fallback) =>
      hi ? (kHiChartNames[_chartKey(type)] ?? fallback) : fallback;

  String chartSignifies(String type, String fallback) =>
      hi ? (kHiChartSignifies[_chartKey(type)] ?? fallback) : fallback;

  /// The shared chart widgets' copy, in the kundali's language.
  KundaliStrings get chartStrings {
    if (!hi) return const KundaliStrings();
    const c = kHiChartStrings;
    return KundaliStrings(
      planetName: term,
      signName: term,
      chartName: chartName,
      chartSignifies: chartSignifies,
      chartShortLabel: chartShortLabel,
      ascendant: c['kChAscendant']!,
      lagnaVargottama: c['kChLagnaVargottama']!,
      asOf: (when) => c['kChAsOf']!.replaceAll('{when}', when),
      unverified: c['kChUnverified']!,
      chalitShifted: (planets, count) =>
          (count == 1 ? c['kChChalitShiftedOne']! : c['kChChalitShiftedMany']!)
              .replaceAll('{planets}', planets),
      colPlanet: c['kChColPlanet']!,
      colSign: c['kChColSign']!,
      colDegree: c['kChColDegree']!,
      colHouse: c['kChColHouse']!,
      colBhava: c['kChColBhava']!,
      colFromMoon: c['kChColFromMoon']!,
      legend: c['kChLegend']!,
      legendNote: c['kChLegendNote']!,
      northIndian: c['kChNorthIndian']!,
      southIndian: c['kChSouthIndian']!,
      pickerCharts: c['kChPickerCharts']!,
      pickerDivisional: c['kChPickerDivisional']!,
      retry: retry,
    );
  }

  // --- planets ---------------------------------------------------------------

  String get lagna => _s('Lagna', 'लग्न');
  String get moon => term('Moon');
  String get sun => term('Sun');
  String get nakshatra => _s('Nakshatra', 'नक्षत्र');

  // --- dasha -----------------------------------------------------------------

  String get running => _s('Running', 'चल रही');
  String get balance => _s('Balance', 'शेष');
  String years(double y) =>
      _s('${y.toStringAsFixed(1)}y', '${y.toStringAsFixed(1)} वर्ष');

  // --- yogas, doshas ---------------------------------------------------------

  String get noYogas =>
      _s('No notable yogas found.', 'कोई उल्लेखनीय योग नहीं मिला।');

  String doshaCount(int present, int checked) => _s(
    '$present present of $checked checked · structural only, cancellations '
        'flagged.',
    '$checked में से $present दोष मौजूद · केवल ग्रह-स्थिति के आधार पर, भंग '
        'अलग से दिखाए गए हैं।',
  );
  String get doshaClear => _s('clear', 'नहीं है');
  String get doshaCancelled => _s('cancelled', 'भंग');
  String get doshaStrong => _s('strong', 'प्रबल');
  String get doshaModerate => _s('moderate', 'मध्यम');
  String get doshaMild => _s('mild', 'हल्का');
  String get partial => _s('partial', 'आंशिक');

  // --- overview --------------------------------------------------------------

  String get overviewIntro => _s(
    'Descriptive D1 read — the free "at a glance" the client also sees. '
        'Tendencies, not a forecast.',
    'लग्न कुंडली का वर्णनात्मक सार — वही जो ग्राहक भी मुफ़्त में देखता है। '
        'ये प्रवृत्तियाँ हैं, भविष्यवाणी नहीं।',
  );

  String toneWord(String tone) => switch (tone) {
    'supportive' => _s('supportive', 'अनुकूल'),
    'challenging' => _s('needs care', 'ध्यान चाहिए'),
    'mixed' => _s('mixed', 'मिश्रित'),
    _ => _s('balanced', 'संतुलित'),
  };

  static const _hiAreas = <String, String>{
    'personality': 'व्यक्तित्व और स्वभाव',
    'appearance': 'शारीरिक रूप',
    'mind_emotions': 'मन और भावनाएँ',
    'career': 'करियर और व्यवसाय',
    'wealth': 'धन और वित्त',
    'education': 'शिक्षा और बुद्धि',
    'marriage': 'विवाह और जीवनसाथी',
    'family': 'परिवार और रिश्ते',
    'health': 'स्वास्थ्य और ऊर्जा',
    'fortune': 'भाग्य और धर्म',
    'strengths_challenges': 'बल और चुनौतियाँ',
  };

  String areaTitle(String area) =>
      hi ? (_hiAreas[area] ?? area) : KundaliInsights.title(area);

  String _strength(int s) => switch (s) {
    >= 3 => _s('strong', 'बलवान'),
    2 => _s('steady', 'स्थिर'),
    1 => _s('under strain', 'दबाव में'),
    0 => _s('weak', 'कमज़ोर'),
    _ => _s('mixed', 'मिश्रित'),
  };

  String _role(String role) => switch (role) {
    'spouse' => _s('Spouse significator', 'जीवनसाथी का कारक'),
    'darakaraka' => _s('Darakaraka (Jaimini)', 'दारकारक (जैमिनी)'),
    'wealth' => _s('Wealth significator', 'धन का कारक'),
    'intellect' => _s('Intellect significator', 'बुद्धि का कारक'),
    'wisdom' => _s('Wisdom significator', 'ज्ञान का कारक'),
    'fortune' => _s('Fortune significator', 'भाग्य का कारक'),
    'father' => _s('Father significator', 'पिता का कारक'),
    'mother' => _s('Mother significator', 'माता का कारक'),
    _ => _s('Significator', 'कारक'),
  };

  /// One readable line for a factor behind an overview section; empty when
  /// there is nothing to say for it.
  String factorText(OverviewFactor f) {
    if (!hi) return KundaliInsights.factorText(f);
    final planet = term(f.planet);
    final sign = term(f.sign);
    switch (f.key) {
      case 'overview.factor.lagna_sign':
        return 'लग्न राशि $sign';
      case 'overview.factor.lagna_lord':
        final where = f.inHouse > 0 ? ' ${nthHouse(f.inHouse)} में' : '';
        final dig = f.dignity.isNotEmpty ? ' (${term(f.dignity)})' : '';
        return 'लग्नेश $planet$where$dig';
      case 'overview.factor.house_lord':
        final where = f.inHouse > 0 ? ' ${nthHouse(f.inHouse)} में' : '';
        return '${nthHouse(f.house)} का स्वामी $planet$where';
      case 'overview.factor.house_strength':
        return '${ordinal(f.house)} भाव — ${_strength(f.strength)}';
      case 'overview.factor.moon_sign':
        return 'चंद्र $sign में';
      case 'overview.factor.moon_house':
        return 'चंद्र ${nthHouse(f.house)} में';
      case 'overview.factor.moon_nakshatra':
        return 'चंद्र नक्षत्र ${term(f.nakshatra)}'
            '${f.pada > 0 ? ' · चरण ${f.pada}' : ''}';
      case 'overview.factor.moon_dignity':
        return 'चंद्र ${term(f.dignity)}';
      case 'overview.factor.sun_sign':
        return 'सूर्य $sign में';
      case 'overview.factor.seventh_sign':
        return 'सातवाँ भाव $sign में';
      case 'overview.factor.planet_in_house':
        return '$planet ${nthHouse(f.house)} में';
      case 'overview.factor.planet_with_moon':
        return '$planet चंद्र के साथ';
      case 'overview.factor.appearance_influence':
        return f.occupant
            ? '$planet पहले भाव में'
            : '$planet की पहले भाव पर दृष्टि';
      case 'overview.factor.malefic_on_lagna':
        return '$planet का लग्न पर दबाव';
      case 'overview.factor.karaka':
        return '${_role(f.role)}: $planet';
      case 'overview.factor.yoga':
        return 'योग — ${term(f.name)}';
      case 'overview.factor.dosha':
        final sev = f.netSeverity > 0 ? ' (${_strength(f.netSeverity)})' : '';
        return 'दोष — ${term(f.name)}$sev';
      default:
        return '';
    }
  }

  // --- remedies --------------------------------------------------------------

  String remediesIntro(int count) => _s(
    "$count remedies matched to this chart's doshas, weak planets, dasha and "
        'afflicted houses. Gemstone / yantra / rudraksha entries are flagged '
        '— confirm before advising them.',
    'इस कुंडली के दोषों, कमज़ोर ग्रहों, दशा और पीड़ित भावों के अनुसार $count '
        'उपाय। रत्न / यंत्र / रुद्राक्ष वाले उपाय चिह्नित हैं — सलाह देने से '
        'पहले जाँच लें।',
  );

  static const _hiRemedyCategories = <String, String>{
    'mantra': 'मंत्र और जप',
    'stotra': 'स्तोत्र और पाठ',
    'puja': 'पूजा और अनुष्ठान',
    'vrat': 'व्रत और उपवास',
    'daan': 'दान',
    'lifestyle': 'जीवनशैली',
    'yantra': 'यंत्र',
    'gemstone': 'रत्न',
    'rudraksha': 'रुद्राक्ष',
  };

  String remedyCategory(String category) => hi
      ? (_hiRemedyCategories[category] ?? category)
      : RemedyCategoryInfo.label(category);

  String get confirmFirst => _s('confirm first', 'पहले जाँचें');
  String get gated => _s('gated', 'जाँच ज़रूरी');

  String get lalKitabTitle =>
      _s('Lal Kitab — rin & totke', 'लाल किताब — ऋण और टोटके');

  String upayaTitle(String sign, String lord) => _s(
    'Upaya table — $sign lagna ($lord)',
    'उपाय तालिका — $sign लग्न ($lord)',
  );
  String get support => _s('Support', 'बल दें');
  String get pacify => _s('Pacify', 'शांत करें');
  String get priority => _s('Priority', 'प्राथमिकता');
  String get gem => _s('gem', 'रत्न');
  String get rudraksha => _s('rudraksha', 'रुद्राक्ष');

  // --- bhava -----------------------------------------------------------------

  String bhavaHeader(
    String sign,
    String lord,
    String lordSign,
    int lordHouse,
  ) {
    final where = lordSign.isEmpty
        ? ''
        : _s(' in $lordSign (${h(lordHouse)})', ' $lordSign में (${h(lordHouse)})');
    return _s('$sign  ·  lord $lord$where', '$sign  ·  स्वामी $lord$where');
  }

  String get occupants => _s('Occupants', 'स्थित ग्रह');
  String get aspectedBy => _s('Aspected by', 'दृष्टि');
  String get karaka => _s('Karaka', 'कारक');
  String beneficMalefic(int benefic, int malefic) =>
      _s('+$benefic benefic   −$malefic malefic', '+$benefic शुभ   −$malefic पाप');

  // --- gochar ----------------------------------------------------------------

  String sadeIntro(String moonSign) => _s(
    'Dated Saturn windows from the natal Moon ($moonSign). Same view the '
        'client sees.',
    'जन्म चंद्र ($moonSign) से शनि के गोचर की तिथियाँ। ग्राहक भी यही देखता है।',
  );
  String get sadeSati => _s('Sade Sati', 'साढ़े साती');
  String get dhaiya => _s('Dhaiya', 'ढैया');
  String get runningNow => _s('running', 'चल रही है');

  String varshphalTitle(int age, String starts, String ends) => _s(
    'Varshphal — age $age ($starts → $ends)',
    'वर्षफल — आयु $age ($starts → $ends)',
  );
  String get varshaLagna => _s('Varsha Lagna', 'वर्ष लग्न');
  String get muntha => _s('Muntha', 'मुंथा');
  String get yearLord => _s('year lord', 'वर्षेश');

  String muhurtaTitle(String weekday, String dayLord, String rise, String set) =>
      _s(
        "Today's timing — $weekday ($dayLord), $rise/$set",
        'आज का मुहूर्त — $weekday ($dayLord), $rise/$set',
      );

  String get avTransitTitle =>
      _s('Ashtakavarga transit reading', 'अष्टकवर्ग गोचर फल');
  String get retro => _s(' R', ' वक्री');

  // --- numerology ------------------------------------------------------------

  String get numerologyIntro => _s(
    'DOB numerology + Lo Shu grid — the same view the client sees. '
        'Traditional; gemstones are gated.',
    'जन्मतिथि का अंक ज्योतिष और लो शू ग्रिड — ग्राहक भी यही देखता है। '
        'परंपरागत; रत्न की सलाह जाँच के बाद ही दें।',
  );
  String get friendly => _s('Friendly', 'मित्र अंक');
  String get clashing => _s('clashing', 'शत्रु अंक');
  String get days => _s('days', 'दिन');
  String get colours => _s('colours', 'रंग');
  String get gemstoneGated => _s('Gemstone (gated)', 'रत्न (जाँच ज़रूरी)');
  String get loShu => _s('Lo Shu birth grid', 'लो शू जन्म ग्रिड');

  // --- advanced --------------------------------------------------------------

  String get sarvashtakavarga => _s(
    'Sarvashtakavarga (bindus by house)',
    'सर्वाष्टकवर्ग (भाव अनुसार बिंदु)',
  );
  String get shadbala =>
      _s('Shadbala (rupa / required)', 'षड्बल (रूप / आवश्यक)');
  String get kp => _s('KP significators', 'केपी कारक ग्रह');
  String get jaimini => _s('Jaimini (karakas, arudhas)', 'जैमिनी (कारक, आरूढ़)');
}

/// Gives the kundali screens their [KT], and the shared chart widgets their
/// [KundaliStrings], in the kundali's language.
class KundaliTextScope extends InheritedWidget {
  KundaliTextScope({required String language, required Widget child, super.key})
    : text = KT(language),
      super(
        child: KundaliStringsScope(
          strings: KT(language).chartStrings,
          child: child,
        ),
      );

  final KT text;

  @override
  bool updateShouldNotify(KundaliTextScope oldWidget) =>
      oldWidget.text.lang != text.lang;
}

/// App-bar button that switches the language the kundali is read in — the
/// kundali only; the rest of the app keeps its language.
class KundaliLanguageButton extends StatelessWidget {
  const KundaliLanguageButton({super.key});

  @override
  Widget build(BuildContext context) {
    final current = kundaliLanguageOf(context);
    return PopupMenuButton<String>(
      tooltip: KT.of(context).language,
      icon: const Icon(Icons.translate_rounded, size: 22),
      initialValue: current,
      onSelected: (code) => kundaliLanguage.value = code,
      itemBuilder: (_) => [
        for (final MapEntry(key: code, value: name) in kKundaliLanguages.entries)
          CheckedPopupMenuItem<String>(
            value: code,
            checked: code == current,
            child: Text(name),
          ),
      ],
    );
  }
}
