import 'package:dio/dio.dart';

import '../../../core/constants/api_paths.dart';
import '../../../core/network/api_exception.dart';

/// Transport for the consultation-scoped kundali surface
/// (`/api/v1/astro/consultations/{id}/{sub}`). Every method returns the raw
/// `{kind, language, payload}` envelope; the models pull what they need.
class KundaliApi {
  KundaliApi(
    this._dio, {
    this.profileId,
    this.standalone = false,
    this.language,
  });

  final Dio _dio;

  /// Which shared person to read. Null = the consultation's primary profile;
  /// set it to open another profile the customer shared (e.g. either side of a
  /// shared kundali match).
  final String? profileId;

  /// True when the id passed to each call is one of the astrologer's own
  /// saved charts (a birth profile) rather than a consultation.
  final bool standalone;

  /// The language the readings are asked for in (`?lang=`), which wins over
  /// the account's language on the server. Null leaves it to the account.
  final String? language;

  /// A view of this API bound to one shared person.
  KundaliApi forProfile(String? id) => id == null
      ? this
      : KundaliApi(
          _dio,
          profileId: id,
          standalone: standalone,
          language: language,
        );

  /// A view of this API that reads the astrologer's own saved charts.
  KundaliApi forOwnCharts() =>
      KundaliApi(_dio, standalone: true, language: language);

  /// A view of this API that asks for everything in [code].
  KundaliApi withLanguage(String code) => KundaliApi(
    _dio,
    profileId: profileId,
    standalone: standalone,
    language: code,
  );

  Future<Map<String, dynamic>> _sub(
    String consultationId,
    String sub, {
    Map<String, dynamic>? query,
  }) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        !standalone
            ? ApiPaths.astroConsultationKundali(consultationId, sub)
            // The list of chart types is the same for everyone there.
            : sub == 'chart-types'
            ? ApiPaths.chartTypes
            : ApiPaths.birthProfileKundali(consultationId, sub),
        queryParameters: {
          ...?query,
          'profile': ?profileId,
          'lang': ?language,
        },
      );
      return res.data ?? const {};
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<Map<String, dynamic>> overview(String id) => _sub(id, 'kundli');

  Future<Map<String, dynamic>> chart(String id, {String type = 'd1'}) =>
      _sub(id, 'chart', query: {'type': type});

  Future<Map<String, dynamic>> chartTypes(String id) => _sub(id, 'chart-types');

  Future<Map<String, dynamic>> dasha(String id) => _sub(id, 'dasha');

  Future<Map<String, dynamic>> allDashas(String id) => _sub(id, 'dashas');

  Future<Map<String, dynamic>> dashaNarrative(String id) =>
      _sub(id, 'dasha-narrative');

  Future<Map<String, dynamic>> numerology(String id) => _sub(id, 'numerology');

  Future<Map<String, dynamic>> sadeSati(String id) => _sub(id, 'sade-sati');

  Future<Map<String, dynamic>> avTransit(String id) => _sub(id, 'av-transit');

  Future<Map<String, dynamic>> muhurta(String id) => _sub(id, 'muhurta');

  Future<Map<String, dynamic>> jyotishUpaya(String id) =>
      _sub(id, 'jyotish-upaya');

  Future<Map<String, dynamic>> lalKitab(String id) => _sub(id, 'lal-kitab');

  Future<Map<String, dynamic>> varshphal(String id) => _sub(id, 'varshphal');

  Future<Map<String, dynamic>> yogas(String id) => _sub(id, 'yogas');

  Future<Map<String, dynamic>> doshas(String id) => _sub(id, 'doshas');

  Future<Map<String, dynamic>> insights(String id) => _sub(id, 'overview');

  Future<Map<String, dynamic>> remedies(String id) => _sub(id, 'remedies');

  Future<Map<String, dynamic>> bhava(String id) => _sub(id, 'bhava');

  Future<Map<String, dynamic>> transits(String id) => _sub(id, 'transits');

  Future<Map<String, dynamic>> ashtakavarga(String id) =>
      _sub(id, 'ashtakavarga');

  Future<Map<String, dynamic>> shadbala(String id) => _sub(id, 'shadbala');

  Future<Map<String, dynamic>> kp(String id) => _sub(id, 'kp');

  Future<Map<String, dynamic>> jaimini(String id) => _sub(id, 'jaimini');
}
