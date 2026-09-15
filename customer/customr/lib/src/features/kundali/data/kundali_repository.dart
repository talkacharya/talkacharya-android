import 'kundali_api.dart';
import 'models/daily_mood.dart';
import 'package:astro_kundali/astro_kundali.dart';

class KundaliRepository {
  KundaliRepository(this._api);

  final KundaliApi _api;

  Future<List<int>> pdf(
    String id, {
    String style = 'north',
    bool full = true,
  }) => _api.pdf(id, style: style, full: full);

  Future<Kundali> overview(String id, {String? lang}) async =>
      Kundali.fromArtifact(await _api.overview(id, lang: lang));

  Future<DashaTimeline> dasha(String id) async =>
      DashaTimeline.fromArtifact(await _api.dasha(id));

  /// All three nakshatra-dasha systems in one call.
  Future<Map<String, DashaTimeline>> allDashas(String id) async {
    final env = await _api.allDashas(id);
    final p = (env['payload'] as Map?)?.cast<String, dynamic>() ?? env;
    DashaTimeline of(String key) {
      final v = (p[key] as Map?)?.cast<String, dynamic>() ?? const {};
      // vimshottari is nested one level deeper (dasha_periods); yogini/ashtottari
      // are flatter but share the periods key.
      final inner = v['dasha_periods'] != null
          ? v
          : (v['vimshottari'] as Map?)?.cast<String, dynamic>() ?? v;
      return DashaTimeline.fromPayload(inner, system: key);
    }

    return {
      'vimshottari': of('vimshottari'),
      'yogini': of('yogini'),
      'ashtottari': of('ashtottari'),
    };
  }

  Future<Transits> transits(String id) async =>
      Transits.fromArtifact(await _api.transits(id));

  Future<DashaNarrative> dashaNarrative(String id) async =>
      DashaNarrative.fromArtifact(await _api.dashaNarrative(id));

  Future<NumerologyReport> numerology(String id) async =>
      NumerologyReport.fromArtifact(await _api.numerology(id));

  Future<SadeSatiCalendar> sadeSati(String id) async =>
      SadeSatiCalendar.fromArtifact(await _api.sadeSati(id));

  Future<AvTransitReading> avTransit(String id) async =>
      AvTransitReading.fromArtifact(await _api.avTransit(id));

  Future<MuhurtaDay> muhurta(String id) async =>
      MuhurtaDay.fromArtifact(await _api.muhurta(id));

  Future<JyotishUpayaReport> jyotishUpaya(String id) async =>
      JyotishUpayaReport.fromArtifact(await _api.jyotishUpaya(id));

  Future<LalKitabReport> lalKitab(String id) async =>
      LalKitabReport.fromArtifact(await _api.lalKitab(id));

  Future<Varshphal> varshphal(String id, {int? year}) async =>
      Varshphal.fromArtifact(await _api.varshphal(id, year: year));

  Future<List<Yoga>> yogas(String id) async =>
      Yoga.listFromArtifact(await _api.yogas(id));

  Future<DoshaReport> doshas(String id) async =>
      DoshaReport.fromArtifact(await _api.doshas(id));

  Future<OverviewReport> insights(String id) async =>
      OverviewReport.fromArtifact(await _api.insights(id));

  Future<DailyMood> mood(String id) async =>
      DailyMood.fromJson(await _api.mood(id));

  Future<RemedyReport> remedies(String id) async =>
      RemedyReport.fromArtifact(await _api.remedies(id));

  Future<List<BhavaHouse>> bhava(String id) async =>
      BhavaHouse.listFromArtifact(await _api.bhava(id));

  /// D9 (or any varga) chart houses — legacy flat helper used by the overview.
  Future<List<ChartHouse>> chart(String id, {String type = 'd9'}) async {
    final env = await _api.chart(id, type: type);
    final p = (env['payload'] as Map?)?.cast<String, dynamic>() ?? env;
    return (p['houses'] as List<dynamic>? ?? const [])
        .map((e) => ChartHouse.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  /// Any of d1..d60, `bhava_chalit`, `transit` — the full [VargaChart].
  Future<VargaChart> vargaChart(String id, String type, {String? asOf}) async =>
      VargaChart.fromArtifact(await _api.chart(id, type: type, asOf: asOf));

  Future<List<ChartTypeInfo>> chartTypes(String _) async {
    final env = await _api.chartTypes();
    List<ChartTypeInfo> parse(String key) =>
        (env[key] as List<dynamic>? ?? const [])
            .map(
              (e) => ChartTypeInfo.fromMap((e as Map).cast<String, dynamic>()),
            )
            .toList();
    return [...parse('divisional'), ...parse('other')];
  }

  Future<Ashtakavarga> ashtakavarga(String id) async =>
      Ashtakavarga.fromArtifact(await _api.ashtakavarga(id));

  Future<Shadbala> shadbala(String id) async =>
      Shadbala.fromArtifact(await _api.shadbala(id));

  Future<Map<String, dynamic>> kp(String id) async {
    final env = await _api.kp(id);
    return (env['payload'] as Map?)?.cast<String, dynamic>() ?? env;
  }

  Future<Map<String, dynamic>> jaimini(String id) async {
    final env = await _api.jaimini(id);
    return (env['payload'] as Map?)?.cast<String, dynamic>() ?? env;
  }
}
