import 'package:dio/dio.dart';

import '../../../core/constants/api_paths.dart';
import '../../../core/network/api_exception.dart';
import 'models/consultation.dart';

class ConsultationApi {
  ConsultationApi(this._dio);
  final Dio _dio;

  Future<List<Consultation>> list({String? status}) async {
    final res = await _dio.get<dynamic>(
      ApiPaths.astroConsultations,
      queryParameters: {if (status != null) 'status': status},
    );
    return (res.data as List? ?? const [])
        .map((e) => Consultation.fromJson((e as Map).cast<String, dynamic>()))
        .toList();
  }

  Future<List<Consultation>> incoming() async {
    final res = await _dio.get<dynamic>(ApiPaths.astroConsultationRequests);
    return (res.data as List? ?? const [])
        .map((e) => Consultation.fromJson((e as Map).cast<String, dynamic>()))
        .toList();
  }

  Future<Consultation> detail(String id) async {
    final res = await _dio.get<Map<String, dynamic>>(
      ApiPaths.astroConsultation(id),
    );
    return Consultation.fromJson(res.data ?? const {});
  }

  Future<Consultation> accept(String id) => _act(ApiPaths.astroAccept(id));

  Future<Consultation> reject(String id, String reason) =>
      _act(ApiPaths.astroReject(id), body: {'reason': reason});

  Future<Consultation> end(String id) => _act(ApiPaths.astroEnd(id));

  Future<Consultation> _act(String path, {Map<String, dynamic>? body}) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(path, data: body ?? {});
      return Consultation.fromJson(res.data ?? const {});
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<Map<String, dynamic>> chart(
    String id, {
    String type = 'kundli',
  }) async {
    final res = await _dio.get<Map<String, dynamic>>(
      ApiPaths.astroConsultationChart(id),
      queryParameters: {'type': type},
    );
    return res.data ?? const {};
  }
}
