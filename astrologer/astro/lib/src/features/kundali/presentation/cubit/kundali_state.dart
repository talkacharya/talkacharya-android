part of 'kundali_cubit.dart';

class KundaliState extends Equatable {
  const KundaliState({
    this.overview = const AsyncValue.idle(),
    this.chartTypes = const AsyncValue.idle(),
    this.charts = const {},
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
    this.yogas = const AsyncValue.idle(),
    this.doshas = const AsyncValue.idle(),
    this.insights = const AsyncValue.idle(),
    this.remedies = const AsyncValue.idle(),
    this.bhava = const AsyncValue.idle(),
    this.transits = const AsyncValue.idle(),
    this.ashtakavarga = const AsyncValue.idle(),
    this.shadbala = const AsyncValue.idle(),
    this.kp = const AsyncValue.idle(),
    this.jaimini = const AsyncValue.idle(),
  });

  final AsyncValue<Kundali> overview;
  final AsyncValue<List<ChartTypeInfo>> chartTypes;
  final Map<String, AsyncValue<VargaChart>> charts;
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
  final AsyncValue<List<Yoga>> yogas;
  final AsyncValue<DoshaReport> doshas;
  final AsyncValue<OverviewReport> insights;
  final AsyncValue<RemedyReport> remedies;
  final AsyncValue<List<BhavaHouse>> bhava;
  final AsyncValue<Transits> transits;
  final AsyncValue<Ashtakavarga> ashtakavarga;
  final AsyncValue<Shadbala> shadbala;
  final AsyncValue<Map<String, dynamic>> kp;
  final AsyncValue<Map<String, dynamic>> jaimini;

  KundaliState copyWith({
    AsyncValue<Kundali>? overview,
    AsyncValue<List<ChartTypeInfo>>? chartTypes,
    Map<String, AsyncValue<VargaChart>>? charts,
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
    AsyncValue<List<Yoga>>? yogas,
    AsyncValue<DoshaReport>? doshas,
    AsyncValue<OverviewReport>? insights,
    AsyncValue<RemedyReport>? remedies,
    AsyncValue<List<BhavaHouse>>? bhava,
    AsyncValue<Transits>? transits,
    AsyncValue<Ashtakavarga>? ashtakavarga,
    AsyncValue<Shadbala>? shadbala,
    AsyncValue<Map<String, dynamic>>? kp,
    AsyncValue<Map<String, dynamic>>? jaimini,
  }) {
    return KundaliState(
      overview: overview ?? this.overview,
      chartTypes: chartTypes ?? this.chartTypes,
      charts: charts ?? this.charts,
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
      yogas: yogas ?? this.yogas,
      doshas: doshas ?? this.doshas,
      insights: insights ?? this.insights,
      remedies: remedies ?? this.remedies,
      bhava: bhava ?? this.bhava,
      transits: transits ?? this.transits,
      ashtakavarga: ashtakavarga ?? this.ashtakavarga,
      shadbala: shadbala ?? this.shadbala,
      kp: kp ?? this.kp,
      jaimini: jaimini ?? this.jaimini,
    );
  }

  @override
  List<Object?> get props => [
    overview,
    chartTypes,
    charts,
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
    yogas,
    doshas,
    insights,
    remedies,
    bhava,
    transits,
    ashtakavarga,
    shadbala,
    kp,
    jaimini,
  ];
}
