import 'package:dio/dio.dart';

import '../../../core/constants/api_paths.dart';
import '../../../core/network/api_exception.dart';

/// The server can't render PDFs right now (`503 astrology.pdf_unavailable`).
class KundaliPdfUnavailable implements Exception {
  const KundaliPdfUnavailable();
}

/// Transport for the astrology artifact endpoints. Every method returns the raw
/// `{kind, language, time_assumed, generated_at, payload}` envelope; the models
/// pull what they need out of it. Throws [ApiException].
class KundaliApi {
  KundaliApi(this._dio);

  final Dio _dio;

  Future<Map<String, dynamic>> _get(
    String path, {
    Map<String, dynamic>? query,
  }) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        path,
        queryParameters: query,
      );
      if ((res.statusCode ?? 0) >= 400) {
        throw ApiException.fromDio(
          DioException(requestOptions: res.requestOptions, response: res),
        );
      }
      return res.data ?? const {};
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<Map<String, dynamic>> _sub(
    String profileId,
    String sub, {
    Map<String, dynamic>? query,
  }) => _get(ApiPaths.kundaliArtifact(profileId, sub), query: query);

  /// The kundali report as PDF bytes. [full] = the multi-page report, else the
  /// one-page summary; [style] = `north` | `south` | `east`.
  Future<List<int>> pdf(
    String profileId, {
    String style = 'north',
    bool full = true,
  }) async {
    try {
      final res = await _dio.get<List<int>>(
        ApiPaths.kundaliPdf(profileId),
        queryParameters: {'style': style, 'report': full ? 'full' : 'basic'},
        options: Options(responseType: ResponseType.bytes),
      );
      return res.data ?? const [];
    } on DioException catch (e) {
      if (e.response?.statusCode == 503) throw const KundaliPdfUnavailable();
      throw ApiException.fromDio(e);
    }
  }

  Future<Map<String, dynamic>> overview(String profileId, {String? lang}) =>
      _sub(profileId, 'kundli', query: {'lang': ?lang});

  Future<Map<String, dynamic>> advanced(String profileId) =>
      _sub(profileId, 'kundli/advanced');

  Future<Map<String, dynamic>> dasha(String profileId) =>
      _sub(profileId, 'dasha');

  Future<Map<String, dynamic>> allDashas(String profileId) =>
      _sub(profileId, 'dashas');

  /// Plain-language "what to expect" per maha / antar period.
  Future<Map<String, dynamic>> dashaNarrative(String profileId) =>
      _sub(profileId, 'dasha-narrative');

  /// DOB numerology (Moolank / Bhagyank / Naamank) + the Lo Shu birth grid.
  Future<Map<String, dynamic>> numerology(String profileId) =>
      _sub(profileId, 'numerology');

  /// Dated Sade Sati / Dhaiya Saturn windows across the lifetime.
  Future<Map<String, dynamic>> sadeSati(String profileId) =>
      _sub(profileId, 'sade-sati');

  /// Ashtakavarga bindu strength of today's transits.
  Future<Map<String, dynamic>> avTransit(String profileId) =>
      _sub(profileId, 'av-transit');

  /// Personalised Choghadiya / Hora timing for today.
  Future<Map<String, dynamic>> muhurta(String profileId) =>
      _sub(profileId, 'muhurta');

  /// Per-planet remedy table (colour/day/deity/mantra + gated gemstone/rudraksha).
  Future<Map<String, dynamic>> jyotishUpaya(String profileId) =>
      _sub(profileId, 'jyotish-upaya');

  /// Lal Kitab rin (inherited debts) + totka remedies.
  Future<Map<String, dynamic>> lalKitab(String profileId) =>
      _sub(profileId, 'lal-kitab');

  /// Varshphal (Tajika annual chart) for the current solar-return year.
  Future<Map<String, dynamic>> varshphal(String profileId, {int? year}) =>
      _sub(profileId, 'varshphal', query: {'year': ?year?.toString()});

  Future<Map<String, dynamic>> transits(String profileId, {String? asOf}) =>
      _sub(profileId, 'transits', query: {'as_of': ?asOf});

  Future<Map<String, dynamic>> yogas(String profileId) =>
      _sub(profileId, 'yogas');

  Future<Map<String, dynamic>> doshas(String profileId) =>
      _sub(profileId, 'doshas');

  /// Free D1 character & life sketch (structural, not a forecast).
  Future<Map<String, dynamic>> insights(String profileId) =>
      _sub(profileId, 'overview');

  /// Traditional remedies matched to the chart (editorial content).
  Future<Map<String, dynamic>> remedies(String profileId) =>
      _sub(profileId, 'remedies');

  Future<Map<String, dynamic>> bhava(String profileId) =>
      _sub(profileId, 'bhava');

  Future<Map<String, dynamic>> chart(
    String profileId, {
    String type = 'd1',
    String? asOf,
  }) => _sub(profileId, 'chart', query: {'type': type, 'as_of': ?asOf});

  Future<Map<String, dynamic>> chartTypes() =>
      _get(ApiPaths.astrologyChartTypes);

  Future<Map<String, dynamic>> ashtakavarga(String profileId) =>
      _sub(profileId, 'ashtakavarga');

  Future<Map<String, dynamic>> shadbala(String profileId) =>
      _sub(profileId, 'shadbala');

  Future<Map<String, dynamic>> kp(String profileId) => _sub(profileId, 'kp');

  Future<Map<String, dynamic>> jaimini(String profileId) =>
      _sub(profileId, 'jaimini');

  /// Today's mood (not an artifact envelope — the reading itself).
  Future<Map<String, dynamic>> mood(String profileId) =>
      _sub(profileId, 'mood');

  /// User-level daily-mood push preference (default on).
  Future<bool> moodAlertsEnabled() async {
    final res = await _get(ApiPaths.astrologyMoodAlerts);
    return res['enabled'] as bool? ?? true;
  }

  Future<bool> setMoodAlertsEnabled(bool enabled) async {
    try {
      final res = await _dio.put<Map<String, dynamic>>(
        ApiPaths.astrologyMoodAlerts,
        data: {'enabled': enabled},
      );
      return res.data?['enabled'] as bool? ?? enabled;
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// User-level "slow planet changes sign" push preference (not profile-scoped).
  Future<bool> transitAlertsEnabled() async {
    final res = await _get(ApiPaths.astrologyTransitAlerts);
    return res['enabled'] as bool? ?? true;
  }

  Future<bool> setTransitAlertsEnabled(bool enabled) async {
    try {
      final res = await _dio.put<Map<String, dynamic>>(
        ApiPaths.astrologyTransitAlerts,
        data: {'enabled': enabled},
      );
      return res.data?['enabled'] as bool? ?? enabled;
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}
