import 'package:dio/dio.dart';

import '../../../core/constants/api_paths.dart';
import '../../../core/network/api_exception.dart';

/// Transport for the consultation-scoped kundali surface
/// (`/api/v1/astro/consultations/{id}/{sub}`). Every method returns the raw
/// `{kind, language, payload}` envelope; the models pull what they need.
class KundaliApi {
  KundaliApi(this._dio);

  final Dio _dio;

  Future<Map<String, dynamic>> _sub(
    String consultationId,
    String sub, {
    Map<String, dynamic>? query,
  }) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        ApiPaths.astroConsultationKundali(consultationId, sub),
        queryParameters: query,
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
