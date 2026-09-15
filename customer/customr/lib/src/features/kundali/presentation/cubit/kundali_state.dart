part of 'kundali_cubit.dart';

class KundaliState extends Equatable {
  const KundaliState({
    this.overview = const AsyncValue.idle(),
    this.navamsa = const AsyncValue.idle(),
    this.dasha = const AsyncValue.idle(),
    this.allDashas = const AsyncValue.idle(),
    this.dashaNarrative = const AsyncValue.idle(),
    this.numerology = const AsyncValue.idle(),
    this.sadeSati = const AsyncValue.idle(),
    this.avTransit = const AsyncValue.idle(),
    this.muhurta = const AsyncValue.idle(),
    this.jyotishUpaya = const AsyncValue.idle(),
    this.lalKitab = const AsyncValue.idle(),
    this.varshphal = const AsyncValue.idle(),
    this.transits = const AsyncValue.idle(),
    this.yogas = const AsyncValue.idle(),
    this.doshas = const AsyncValue.idle(),
    this.insights = const AsyncValue.idle(),
    this.remedies = const AsyncValue.idle(),
    this.mood = const AsyncValue.idle(),
    this.bhava = const AsyncValue.idle(),
    this.chartTypes = const AsyncValue.idle(),
    this.charts = const {},
  });

  final AsyncValue<Kundali> overview;
  final AsyncValue<List<ChartHouse>> navamsa;
  final AsyncValue<DashaTimeline> dasha;
  final AsyncValue<Map<String, DashaTimeline>> allDashas;
  final AsyncValue<DashaNarrative> dashaNarrative;
  final AsyncValue<NumerologyReport> numerology;
  final AsyncValue<SadeSatiCalendar> sadeSati;
  final AsyncValue<AvTransitReading> avTransit;
  final AsyncValue<MuhurtaDay> muhurta;
  final AsyncValue<JyotishUpayaReport> jyotishUpaya;
  final AsyncValue<LalKitabReport> lalKitab;
  final AsyncValue<Varshphal> varshphal;
  final AsyncValue<Transits> transits;
  final AsyncValue<List<Yoga>> yogas;
  final AsyncValue<DoshaReport> doshas;
  final AsyncValue<OverviewReport> insights;
  final AsyncValue<RemedyReport> remedies;
  final AsyncValue<DailyMood> mood;
  final AsyncValue<List<BhavaHouse>> bhava;
  final AsyncValue<List<ChartTypeInfo>> chartTypes;
  final Map<String, AsyncValue<VargaChart>> charts;

  KundaliState copyWith({
    AsyncValue<Kundali>? overview,
    AsyncValue<List<ChartHouse>>? navamsa,
    AsyncValue<DashaTimeline>? dasha,
    AsyncValue<Map<String, DashaTimeline>>? allDashas,
    AsyncValue<DashaNarrative>? dashaNarrative,
    AsyncValue<NumerologyReport>? numerology,
    AsyncValue<SadeSatiCalendar>? sadeSati,
    AsyncValue<AvTransitReading>? avTransit,
    AsyncValue<MuhurtaDay>? muhurta,
    AsyncValue<JyotishUpayaReport>? jyotishUpaya,
    AsyncValue<LalKitabReport>? lalKitab,
    AsyncValue<Varshphal>? varshphal,
    AsyncValue<Transits>? transits,
    AsyncValue<List<Yoga>>? yogas,
    AsyncValue<DoshaReport>? doshas,
    AsyncValue<OverviewReport>? insights,
    AsyncValue<RemedyReport>? remedies,
    AsyncValue<DailyMood>? mood,
    AsyncValue<List<BhavaHouse>>? bhava,
    AsyncValue<List<ChartTypeInfo>>? chartTypes,
    Map<String, AsyncValue<VargaChart>>? charts,
  }) {
    return KundaliState(
      overview: overview ?? this.overview,
      navamsa: navamsa ?? this.navamsa,
      dasha: dasha ?? this.dasha,
      allDashas: allDashas ?? this.allDashas,
      dashaNarrative: dashaNarrative ?? this.dashaNarrative,
      numerology: numerology ?? this.numerology,
      sadeSati: sadeSati ?? this.sadeSati,
      avTransit: avTransit ?? this.avTransit,
      muhurta: muhurta ?? this.muhurta,
      jyotishUpaya: jyotishUpaya ?? this.jyotishUpaya,
      lalKitab: lalKitab ?? this.lalKitab,
      varshphal: varshphal ?? this.varshphal,
      transits: transits ?? this.transits,
      yogas: yogas ?? this.yogas,
      doshas: doshas ?? this.doshas,
      insights: insights ?? this.insights,
      remedies: remedies ?? this.remedies,
      mood: mood ?? this.mood,
      bhava: bhava ?? this.bhava,
      chartTypes: chartTypes ?? this.chartTypes,
      charts: charts ?? this.charts,
    );
  }

  @override
  List<Object?> get props => [
    overview,
    navamsa,
    dasha,
    allDashas,
    dashaNarrative,
    numerology,
    sadeSati,
    avTransit,
    muhurta,
    jyotishUpaya,
    lalKitab,
    varshphal,
    transits,
    yogas,
    doshas,
    insights,
    remedies,
    mood,
    bhava,
    chartTypes,
    charts,
  ];
}
