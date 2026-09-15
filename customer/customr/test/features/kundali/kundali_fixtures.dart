// Shared fixtures + a small-phone harness for the kundali screen tests.
import 'package:astro_kundali/astro_kundali.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:customr/src/core/config/config_repository.dart';
import 'package:customr/src/core/config/remote_config.dart';
import 'package:customr/src/core/di/service_locator.dart';
import 'package:customr/src/core/l10n/l10n.dart';
import 'package:customr/src/core/profile/active_profile_store.dart';
import 'package:customr/src/core/theme/brand_colors.dart';
import 'package:customr/src/features/birthprofiles/data/birth_profiles_repository.dart';
import 'package:customr/src/features/birthprofiles/presentation/bloc/birth_profiles_cubit.dart';
import 'package:customr/src/features/kundali/presentation/cubit/kundali_cubit.dart';
import 'package:customr/src/features/kundali/presentation/kundali_terms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockKundaliCubit extends MockCubit<KundaliState> implements KundaliCubit {
  /// Pages kick off `load*` calls in initState; unstubbed they'd return null
  /// where a Future is expected. Treat them as already-complete no-ops.
  @override
  dynamic noSuchMethod(Invocation invocation) {
    final result = super.noSuchMethod(invocation);
    if (result == null &&
        invocation.isMethod &&
        '${invocation.memberName}'.contains('"load')) {
      return Future<void>.value();
    }
    return result;
  }
}

class _MockConfig extends Mock implements ConfigRepository {}

class _MockBpRepo extends Mock implements BirthProfilesRepository {}

class _MockStore extends Mock implements ActiveProfileStore {}

const kPlanets = [
  NatalPlanet(
    name: 'Sun',
    sign: 'Gemini',
    signId: 3,
    degree: 0.34,
    house: 9,
    retrograde: false,
    nakshatra: 'Mrigashira',
    nakshatraPada: 3,
    dignity: 'friend',
  ),
  NatalPlanet(
    name: 'Moon',
    sign: 'Aquarius',
    signId: 11,
    degree: 20.79,
    house: 5,
    retrograde: false,
    nakshatra: 'Purva Bhadrapada',
    nakshatraPada: 1,
  ),
  NatalPlanet(
    name: 'Mars',
    sign: 'Pisces',
    signId: 12,
    degree: 17.27,
    house: 6,
    retrograde: false,
    nakshatra: 'Revati',
    nakshatraPada: 1,
  ),
  NatalPlanet(
    name: 'Mercury',
    sign: 'Taurus',
    signId: 2,
    degree: 11.85,
    house: 8,
    retrograde: false,
    nakshatra: 'Rohini',
    nakshatraPada: 1,
    combust: true,
  ),
  NatalPlanet(
    name: 'Jupiter',
    sign: 'Gemini',
    signId: 3,
    degree: 22.15,
    house: 9,
    retrograde: false,
    nakshatra: 'Punarvasu',
    nakshatraPada: 1,
  ),
  NatalPlanet(
    name: 'Venus',
    sign: 'Aries',
    signId: 1,
    degree: 24.97,
    house: 7,
    retrograde: false,
    nakshatra: 'Bharani',
    nakshatraPada: 4,
  ),
  NatalPlanet(
    name: 'Saturn',
    sign: 'Capricorn',
    signId: 10,
    degree: 0.31,
    house: 4,
    retrograde: true,
    nakshatra: 'Uttara Ashadha',
    nakshatraPada: 2,
    dignity: 'own',
  ),
  NatalPlanet(
    name: 'Rahu',
    sign: 'Capricorn',
    signId: 10,
    degree: 14.26,
    house: 4,
    retrograde: true,
    nakshatra: 'Shravana',
    nakshatraPada: 2,
  ),
  NatalPlanet(
    name: 'Ketu',
    sign: 'Cancer',
    signId: 4,
    degree: 14.26,
    house: 10,
    retrograde: true,
    nakshatra: 'Pushya',
    nakshatraPada: 4,
  ),
];

const _signOrder = [
  'Libra',
  'Scorpio',
  'Sagittarius',
  'Capricorn',
  'Aquarius',
  'Pisces',
  'Aries',
  'Taurus',
  'Gemini',
  'Cancer',
  'Leo',
  'Virgo',
];

final kHouses = [
  for (var h = 1; h <= 12; h++)
    ChartHouse(
      house: h,
      sign: _signOrder[h - 1],
      planets: [
        for (final p in kPlanets)
          if (p.house == h) p.name,
      ],
    ),
];

final kKundali = Kundali(
  moonSign: 'Aquarius',
  sunSign: 'Gemini',
  lagnaSign: 'Libra',
  nakshatra: 'Purva Bhadrapada',
  nakshatraPada: 1,
  nakshatraLord: 'Jupiter',
  planets: kPlanets,
  houses: kHouses,
  mangalDosha: const MangalDosha(
    hasDosha: true,
    status: 'manglik',
    present: true,
    severityLabel: 'moderate',
    from: ['lagna', 'moon'],
  ),
  yogas: const [
    BasicYoga(name: 'Sasa Yoga', key: 'yoga.mahapurusha.sasa'),
    BasicYoga(name: 'Raja Yoga', key: 'yoga.raja'),
  ],
  timeAssumed: true,
);

DashaTimeline kDasha() {
  final now = DateTime.now();
  final start = DateTime(now.year - 2, 7, 2);
  final end = DateTime(now.year + 15, 7, 2);
  return DashaTimeline(
    periods: [
      DashaSpan(lord: 'Saturn', start: DateTime(1990), end: start),
      DashaSpan(
        lord: 'Mercury',
        start: start,
        end: end,
        children: [
          DashaSpan(lord: 'Mercury', start: start, end: DateTime(now.year + 1)),
          DashaSpan(lord: 'Ketu', start: DateTime(now.year + 1), end: end),
        ],
      ),
      DashaSpan(lord: 'Ketu', start: end, end: DateTime(now.year + 22)),
    ],
    balanceLord: 'Jupiter',
    balanceYears: 15.05,
    currentMaha: 'Mercury',
    currentAntar: 'Mercury',
    currentPratyantar: 'Saturn',
  );
}

const kTransits = Transits(
  natalMoonSign: 'Aquarius',
  sadeSatiActive: true,
  sadeSatiPhase: 'setting',
  saturnHouseFromMoon: 2,
  jupiterHouseFromMoon: 5,
  jupiterFavourable: true,
  positions: [
    TransitPlanet(name: 'Saturn', sign: 'Pisces', houseFromMoon: 2),
    TransitPlanet(name: 'Jupiter', sign: 'Gemini', houseFromMoon: 5),
  ],
);

/// One-time DI for widgets that read config / haptics.
void registerKundaliTestDi() {
  if (getIt.isRegistered<ConfigRepository>()) return;
  final config = _MockConfig();
  when(() => config.hapticEnabled).thenReturn(false);
  when(() => config.value).thenReturn(const RemoteConfig());
  getIt.registerSingleton<ConfigRepository>(config);
}

/// Sets a 360×740 phone for the duration of a test.
void usePhoneViewport() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized().platformDispatcher.views.first
      ..physicalSize = const Size(360, 740) * 3
      ..devicePixelRatio = 3;
  });
  tearDown(() {
    TestWidgetsFlutterBinding.instance.platformDispatcher.views.first
      ..resetPhysicalSize()
      ..resetDevicePixelRatio();
  });
}

/// Pumps [page] under a mocked [KundaliCubit] holding [state], the l10n scope
/// and a real (empty) [BirthProfilesCubit].
Future<MockKundaliCubit> pumpKundaliPage(
  WidgetTester tester,
  Widget page, {
  required KundaliState state,
  Locale locale = const Locale('en'),
}) async {
  final cubit = MockKundaliCubit();
  when(() => cubit.state).thenReturn(state);
  whenListen(cubit, const Stream<KundaliState>.empty(), initialState: state);
  when(() => cubit.refresh()).thenAnswer((_) async {});
  when(() => cubit.reloadForLanguage()).thenAnswer((_) async {});
  final bpRepo = _MockBpRepo();
  when(() => bpRepo.list()).thenAnswer((_) async => const []);
  await tester.pumpWidget(
    MultiBlocProvider(
      providers: [
        BlocProvider<KundaliCubit>.value(value: cubit),
        BlocProvider(
          create: (_) => BirthProfilesCubit(repo: bpRepo, store: _MockStore()),
        ),
      ],
      child: MaterialApp(
        locale: locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: const Color(0xFFEA6A1E),
          extensions: const [BrandColors.light],
        ),
        home: KundaliL10nScope(child: page),
      ),
    ),
  );
  await tester.pump(const Duration(milliseconds: 600));
  return cubit;
}

/// Runs [action] and fails on the first layout exception, naming the widget
/// + source line that overflowed.
Future<void> expectNoLayoutError(
  WidgetTester tester,
  Future<void> Function() action,
) async {
  final where = <String>[];
  final previous = FlutterError.onError;
  FlutterError.onError = (details) {
    for (final line in details.toString().split('\n')) {
      if (line.contains('file:///')) where.add(line.trim());
    }
    previous?.call(details);
  };
  try {
    await action();
    expect(tester.takeException(), isNull, reason: where.join('\n'));
  } finally {
    FlutterError.onError = previous;
  }
}

/// Scrolls the page's main list to the end in steps, failing on the first
/// layout exception.
Future<void> scrollThrough(WidgetTester tester, {int steps = 8}) async {
  final scrollable = find.byType(Scrollable).first;
  for (var i = 0; i < steps; i++) {
    await expectNoLayoutError(tester, () async {
      await tester.drag(scrollable, const Offset(0, -700), warnIfMissed: false);
      await tester.pump(const Duration(milliseconds: 400));
    });
  }
}

VargaChart kVarga(String type) => VargaChart(
  chartType: type,
  name: type == 'transit' ? 'Transit (Gochar)' : 'Rasi',
  signifies: 'Body, self and overall life',
  verified: type != 'd7',
  ascendantSign: 'Libra',
  ascendantDegree: 17.1,
  ascendantVargottama: type == 'd9',
  houses: kHouses,
  asOf: type == 'transit' ? '2026-09-15T06:00:00+05:30' : null,
  planets: [
    for (final p in kPlanets)
      ChartPlacement(
        name: p.name,
        sign: p.sign,
        degree: p.degree,
        dms: "${p.degree.toStringAsFixed(0)}°12'",
        house: p.house,
        retrograde: p.retrograde,
        vargottama: p.name == 'Moon' && type == 'd9',
        shifted: type == 'bhava_chalit' && p.name == 'Mars',
        rasiHouse: type == 'bhava_chalit' && p.name == 'Mars' ? 5 : 0,
        houseFromMoon: type == 'transit' ? (p.house % 12) + 1 : 0,
      ),
  ],
);

const kChartMenu = [
  ChartTypeInfo(type: 'd1', name: 'Rasi', varga: 1, signifies: 'Body, self'),
  ChartTypeInfo(type: 'd9', name: 'Navamsa', varga: 9, signifies: 'Marriage'),
  ChartTypeInfo(type: 'd7', name: 'Saptamsa', varga: 7, verified: false),
  ChartTypeInfo(type: 'bhava_chalit', name: 'Bhava Chalit'),
  ChartTypeInfo(type: 'transit', name: 'Transit (Gochar)'),
];

final kBhava = [
  for (final h in kHouses)
    BhavaHouse(
      house: h.house,
      sign: h.sign,
      karaka: h.house == 10 ? 'Sun, Mercury, Jupiter, Saturn' : 'Jupiter',
      lord: 'Venus',
      lordSign: 'Aries',
      lordHouse: 7,
      lordDignity: h.house.isEven ? 'debilitated' : 'own',
      lordRetrograde: h.house == 4,
      occupants: h.planets,
      aspectedBy: h.house == 7 ? const ['Saturn', 'Mars', 'Jupiter'] : const [],
      beneficCount: h.house % 3,
      maleficCount: h.house % 4,
      netInfluence: (h.house % 3 - h.house % 4).toDouble(),
    ),
];

const kDoshas = DoshaReport(
  count: 2,
  presentKeys: ['mangal', 'kaal_sarpa'],
  doshas: [
    Dosha(
      key: 'mangal',
      name: 'Mangal Dosha',
      present: true,
      severity: 2,
      netSeverity: 1,
      severityLabel: 'moderate',
      netSeverityLabel: 'mild',
      planets: ['Mars'],
      houses: [7],
      reasons: [DoshaReason(key: 'r1', text: 'Mars in the 7th from Lagna')],
      cancellations: [
        DoshaCancellation(
          key: 'c1',
          text: 'Mars in its own sign softens it',
          applies: true,
        ),
      ],
      summary: 'Present but softened by a classical cancellation.',
    ),
    Dosha(
      key: 'kaal_sarpa',
      name: 'Kaal Sarpa',
      present: true,
      severity: 3,
      netSeverity: 3,
      severityLabel: 'strong',
      netSeverityLabel: 'strong',
      planets: ['Rahu', 'Ketu'],
      kaalSarpaType: 'Shankhpal',
      partial: true,
      summary: 'All planets between Rahu and Ketu.',
    ),
    Dosha(key: 'pitra', name: 'Pitra Dosha'),
    Dosha(key: 'grahan', name: 'Grahan Dosha'),
  ],
  disclaimer: 'Doshas describe tendencies, not fate.',
);

const kYogas = [
  Yoga(
    name: 'Sasa Yoga',
    key: 'yoga.mahapurusha.sasa',
    type: 'mahapurusha',
    planets: ['Saturn'],
    description: 'Saturn strong in a kendra.',
  ),
  Yoga(
    name: 'Gajakesari Yoga',
    key: 'yoga.gajakesari',
    type: 'lunar',
    planets: ['Jupiter', 'Moon'],
  ),
  Yoga(name: 'Some untranslated yoga', key: 'yoga.unknown'),
];

Map<String, DashaTimeline> kAllDashas() => {
  'vimshottari': kDasha(),
  'yogini': kDasha(),
  'ashtottari': kDasha(),
};

const kDashaNarrative = DashaNarrative(
  currentMaha: 'Mercury',
  currentAntar: 'Mercury',
  disclaimer: 'Periods describe themes, not events.',
  timeline: [
    DashaPeriodNote(
      lord: 'Mercury',
      tone: 'supportive',
      strength: 3,
      running: true,
      summary: 'Learning, trade and communication come forward.',
      antardashas: [
        DashaPeriodNote(
          level: 'antar',
          lord: 'Ketu',
          mahaLord: 'Mercury',
          tone: 'mixed',
          summary: 'A quieter, inward stretch.',
        ),
      ],
    ),
  ],
);

const kSadeSati = SadeSatiCalendar(
  natalMoonSign: 'Aquarius',
  current: SadeSatiPhase(
    kind: 'sade_sati',
    phase: 'setting',
    sign: 'Pisces',
    start: '2025-03-29',
    end: '2027-06-03',
    running: true,
    summary: 'The last stretch: consolidation and clearing up.',
  ),
  sadeSatiPeriods: [
    SadeSatiPeriod(
      start: '1991-12-15',
      end: '1998-04-17',
      past: true,
      signs: ['Capricorn', 'Aquarius', 'Pisces'],
      phases: [
        SadeSatiPhase(
          phase: 'rising',
          start: '1991-12-15',
          end: '1993-06-05',
          past: true,
          summary: 'Beginnings.',
        ),
      ],
    ),
    SadeSatiPeriod(
      start: '2020-01-24',
      end: '2027-06-03',
      running: true,
      signs: ['Capricorn', 'Aquarius', 'Pisces'],
      phases: [
        SadeSatiPhase(
          phase: 'rising',
          start: '2020-01-24',
          end: '2022-04-29',
          past: true,
          summary: 'Saturn in the 12th from the Moon.',
        ),
        SadeSatiPhase(
          phase: 'peak',
          start: '2022-04-29',
          end: '2025-03-29',
          past: true,
          summary: 'Saturn over the Moon.',
        ),
        SadeSatiPhase(
          phase: 'setting',
          start: '2025-03-29',
          end: '2027-06-03',
          running: true,
          summary: 'Saturn in the 2nd from the Moon.',
        ),
      ],
    ),
  ],
  dhaiyaPeriods: [
    SadeSatiPhase(
      kind: 'dhaiya',
      phase: 'ashtama',
      start: '2032-01-01',
      end: '2034-06-01',
      summary: 'Saturn in the 8th from the Moon.',
    ),
  ],
  summary: 'Sade Sati is in its final phase.',
  disclaimer: 'Dates are approximate to a few days.',
);

const kAvTransit = AvTransitReading(
  natalMoonSign: 'Aquarius',
  transits: [
    AvTransitRow(
      planet: 'Saturn',
      bindus: 2,
      tone: 'challenging',
      summary: 'Saturn through a low-score sign: slow and steady.',
    ),
    AvTransitRow(
      planet: 'Jupiter',
      bindus: 6,
      tone: 'supportive',
      summary: 'Jupiter through a strong sign for you.',
    ),
    AvTransitRow(planet: 'Moon', bindus: 4, summary: 'skipped'),
  ],
  upcomingIngresses: [
    AvTransitRow(
      planet: 'Mars',
      date: '2026-10-20',
      summary: 'Mars moves into Cancer on 20 Oct.',
    ),
  ],
);

const kTransitsFull = Transits(
  natalMoonSign: 'Aquarius',
  sadeSatiActive: true,
  sadeSatiPhase: 'setting',
  saturnHouseFromMoon: 2,
  jupiterHouseFromMoon: 5,
  jupiterFavourable: true,
  positions: [
    TransitPlanet(
      name: 'Sun',
      sign: 'Virgo',
      houseFromLagna: 12,
      houseFromMoon: 8,
    ),
    TransitPlanet(
      name: 'Saturn',
      sign: 'Pisces',
      houseFromLagna: 6,
      houseFromMoon: 2,
      overNatal: ['Mars'],
    ),
    TransitPlanet(
      name: 'Jupiter',
      sign: 'Gemini',
      houseFromLagna: 9,
      houseFromMoon: 5,
      overNatal: ['Sun', 'Jupiter'],
    ),
  ],
);

const kVarshphal = Varshphal(
  year: 2026,
  age: 34,
  starts: '2026-06-18',
  ends: '2027-06-18',
  varshaLagna: 'Scorpio',
  munthaSign: 'Sagittarius',
  munthaHouse: 10,
  munthaLord: 'Jupiter',
  munthaTheme: 'career and public standing',
  yearLord: 'Mars',
  yearLordHouse: 6,
  yearLordDignity: 'own',
  tajikaYoga: 'ithasala',
  tajikaSummary: 'Lagna lord applies to the 10th lord, effort is rewarded.',
  planets: [
    VarshphalPlanet(name: 'Sun', sign: 'Gemini', house: 8, dignity: 'friend'),
    VarshphalPlanet(
      name: 'Saturn',
      sign: 'Pisces',
      house: 5,
      retrograde: true,
      dignity: 'debilitated',
    ),
  ],
  summary: 'A working year: steady effort brings visible results.',
  disclaimer: 'Annual charts describe themes.',
);

const kLalKitab = LalKitabReport(
  activeRins: [
    LalKitabRin(
      name: 'Pitri Rin (ancestral debt)',
      planet: 'Jupiter',
      present: true,
      reasons: ['Venus and Mercury in the 9th', 'Rahu in the 4th'],
      remedy: 'Collect a coin from each family member and donate it together.',
    ),
    LalKitabRin(name: 'Matri Rin', reasons: ['Ketu in the 4th']),
  ],
  mandaPlanets: [
    LalKitabManda(
      planet: 'Saturn',
      house: 1,
      pakkaGhar: 10,
      summary: 'Saturn is weak in the first house.',
      remedy: 'Feed crows on Saturdays.',
    ),
  ],
  summary: 'Two debts to work on gently.',
  disclaimer: 'Lal Kitab remedies are traditional household acts.',
);

const kRemedies = RemedyReport(
  count: 3,
  groups: [
    RemedyGroup(
      category: 'mantra',
      items: [
        Remedy(
          category: 'mantra',
          title: 'Shani mantra',
          body: 'Chant Om Sham Shanaischaraya Namah 108 times on Saturdays.',
          caution: 'Keep the practice steady rather than intense.',
        ),
      ],
    ),
    RemedyGroup(
      category: 'gemstone',
      items: [
        Remedy(
          category: 'gemstone',
          title: 'Blue sapphire',
          body: 'Traditionally worn for Saturn.',
          gated: true,
          source: 'classical',
        ),
        Remedy(category: 'gemstone', title: 'Amethyst', body: 'A substitute.'),
      ],
    ),
  ],
  gatedNote: 'Gemstones can be strong, confirm with an astrologer.',
  disclaimer: 'Remedies support, they do not replace effort.',
);

const kUpaya = JyotishUpayaReport(
  lagnaSign: 'Libra',
  lagnaLord: 'Venus',
  lagnaColours: ['White', 'Light blue'],
  lagnaDirection: 'West',
  lagnaDay: 'Friday',
  lagnaDeity: 'Lakshmi',
  strengthen: ['Saturn'],
  pacify: ['Mars'],
  priorityPlanets: ['Saturn'],
  planets: [
    UpayaPlanet(
      planet: 'Saturn',
      role: 'strengthen',
      priority: true,
      colours: ['Black', 'Navy'],
      direction: 'West',
      mantra: 'Om Sham Shanaischaraya Namah',
      charity: 'Black sesame on Saturdays',
      gemstone: 'Blue sapphire',
      gemstoneSubstitute: 'Amethyst',
      gemstoneMetal: 'Silver',
      gemstoneFinger: 'middle',
      gemstoneStartDay: 'Saturday',
      rudrakshaMukhi: '14 mukhi',
      summary: 'Yogakaraka for Libra lagna, worth strengthening.',
    ),
    UpayaPlanet(
      planet: 'Mars',
      role: 'pacify',
      colours: ['Red'],
      mantra: 'Om Angarakaya Namah',
      summary: 'Rules the 2nd and 7th, pacify rather than strengthen.',
    ),
    UpayaPlanet(planet: 'Mercury', role: 'mixed'),
  ],
  summary: 'Venus and Saturn are your friends.',
  gateNotice: 'Gemstones and rudraksha only after a consultation.',
  disclaimer: 'Traditional correspondences.',
);

const kNumerology = NumerologyReport(
  moolank: 5,
  bhagyank: 8,
  numbers: [
    NumerologyNumber(
      kind: 'moolank',
      value: 5,
      planet: 'Mercury',
      summary: 'Quick, curious, adaptable.',
      friendly: [1, 6],
      unfriendly: [2],
      days: ['Wednesday'],
      colours: ['Green'],
      direction: 'North',
      deity: 'Vishnu',
      gemstone: 'Emerald',
      gemstoneNote: 'Only after consulting an astrologer.',
    ),
    NumerologyNumber(kind: 'bhagyank', value: 8, planet: 'Saturn'),
    NumerologyNumber(kind: 'naamank', value: 3, planet: 'Jupiter'),
  ],
  combination: '5 with 8: speed meets patience.',
  loShu: LoShuGrid(
    counts: {1: 2, 5: 1, 6: 1, 9: 1, 2: 1},
    missing: [3, 4, 7, 8],
    repeated: [1],
    lines: [
      LoShuLine(
        name: 'Mind',
        status: 'strength',
        gloss: 'Planning comes easily.',
      ),
      LoShuLine(name: 'Action', status: 'weakness', gloss: 'Start small.'),
      LoShuLine(name: 'Soul'),
    ],
    summary: 'A thinking grid.',
  ),
  disclaimer: 'Numerology is descriptive.',
);

const _choNames = [
  'chal',
  'labh',
  'amrit',
  'kaal',
  'shubh',
  'rog',
  'udveg',
  'chal',
];
const _choQuality = [
  'neutral',
  'good',
  'good',
  'bad',
  'good',
  'bad',
  'bad',
  'neutral',
];

MuhurtaDay kMuhurta({bool available = true}) => MuhurtaDay(
  available: available,
  date: '2026-09-15',
  weekday: 'Tuesday',
  dayLord: 'Mars',
  sunrise: '06:04',
  sunset: '18:21',
  choghadiya: [
    for (var i = 0; i < 8; i++)
      ChoghadiyaSlot(
        index: i,
        name: _choNames[i],
        lord: 'Mars',
        quality: _choQuality[i],
        start: '${(6 + i).toString().padLeft(2, '0')}:04',
        end: '${(7 + i).toString().padLeft(2, '0')}:36',
        running: i == 2,
      ),
    for (var i = 0; i < 8; i++)
      const ChoghadiyaSlot(
        period: 'night',
        name: 'shubh',
        lord: 'Jupiter',
        quality: 'good',
        start: '19:00',
        end: '20:30',
      ),
  ],
  horas: [
    for (final (i, p) in const ['Mars', 'Sun', 'Venus', 'Mercury'].indexed)
      HoraSlot(
        index: i,
        lord: p,
        start: '${(6 + i).toString().padLeft(2, '0')}:04',
        end: '${(7 + i).toString().padLeft(2, '0')}:04',
        running: i == 1,
        goodFor: 'Government work, authority, health',
        personal: const ['caution', 'favourable', 'neutral', 'favourable'][i],
      ),
  ],
  currentChoghadiya: const ChoghadiyaSlot(
    name: 'amrit',
    lord: 'Moon',
    quality: 'good',
    start: '09:10',
    end: '10:42',
    running: true,
  ),
  currentHora: const HoraSlot(lord: 'Sun', start: '07:04', end: '08:04'),
  bestWindows: const [
    MuhurtaBestWindow(
      start: '09:10',
      end: '10:04',
      horaLord: 'Venus',
      choghadiya: 'amrit',
      summary: 'Amrit choghadiya in a Venus hora, good for agreements.',
    ),
  ],
  abhijit: const MuhurtaBestWindow(
    start: '11:48',
    end: '12:36',
    summary: 'Abhijit, auspicious for most starts.',
  ),
  summary: 'A good window is running now.',
  disclaimer: 'Timing is guidance, not a rule.',
);

const kInsights = OverviewReport(
  sections: [
    OverviewSection(
      area: 'personality',
      strength: 3,
      tone: 'supportive',
      summary: 'Balanced, diplomatic and fair-minded.',
      factors: [
        OverviewFactor(key: 'overview.factor.lagna_sign', sign: 'Libra'),
        OverviewFactor(
          key: 'overview.factor.lagna_lord',
          planet: 'Venus',
          inHouse: 7,
          dignity: 'exalted',
        ),
      ],
    ),
    OverviewSection(
      area: 'career',
      strength: 1,
      tone: 'challenging',
      summary: 'Work asks for patience.',
      factors: [
        OverviewFactor(
          key: 'overview.factor.house_strength',
          house: 10,
          strength: 1,
        ),
      ],
    ),
    OverviewSection(area: 'marriage', tone: 'mixed', summary: 'Mixed signals.'),
    OverviewSection(area: 'health', strength: 2, summary: 'Steady.'),
  ],
  disclaimer: 'Tendencies, not a forecast.',
);

Ashtakavarga kAshtakavarga() => Ashtakavarga(
  sarvaByHouse: {for (var h = 1; h <= 12; h++) '$h': 20 + h},
  sarvaTotal: 337,
  bhinnaTotals: const {
    'Sun': 48,
    'Moon': 49,
    'Mars': 39,
    'Mercury': 54,
    'Jupiter': 56,
    'Venus': 52,
    'Saturn': 39,
  },
);

const kShadbala = Shadbala(
  planets: [
    PlanetStrength(
      name: 'Sun',
      totalRupa: 6.2,
      requiredRupa: 5,
      ratio: 1.24,
      isStrong: true,
    ),
    PlanetStrength(
      name: 'Saturn',
      totalRupa: 4.1,
      requiredRupa: 5,
      ratio: 0.82,
    ),
  ],
  strongest: 'Sun',
  weakest: 'Saturn',
);

final kKundaliWithBirth = kKundali.copyWith(
  panchang: const BirthPanchang(
    vaara: 'Tuesday',
    tithi: 'Dashami',
    paksha: 'Shukla',
    nakshatra: 'Purva Bhadrapada',
    nakshatraPada: 1,
    yoga: 'Siddhi',
    karana: 'Garaja',
    sunrise: '05:43:10',
    sunset: '19:02:44',
    ishtaGhati: 12,
    ishtaPala: 30,
    ishtaVipala: 4,
  ),
  chakra: const BirthChakra(
    nakshatra: 'Purva Bhadrapada',
    rasi: 'Aquarius',
    nakshatraLord: 'Jupiter',
    rasiLord: 'Saturn',
    varna: 'Shudra',
    vashya: 'Manava',
    yoni: 'Simha',
    gana: 'Manushya',
    nadi: 'Adi',
    tara: 'Janma',
    tattva: 'Air',
    yunja: 'Madhya',
    rasiPaya: 'Silver',
    nakshatraPaya: 'Copper',
  ),
);
