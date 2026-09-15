import 'package:dio/dio.dart';

import '../../../core/constants/api_paths.dart';
import '../../../core/network/api_exception.dart';

/// Transport for the astrologer prediction work queue. Throws [ApiException].
class PredictionsApi {
  PredictionsApi(this._dio);

  final Dio _dio;

  Future<List<dynamic>> queue() => _getList(ApiPaths.predictionsQueue);

  Future<Map<String, dynamic>> detail(String id) =>
      _getMap(ApiPaths.prediction(id));

  Future<Map<String, dynamic>> claim(String id) =>
      _postMap(ApiPaths.predictionClaim(id), const {});

  Future<Map<String, dynamic>> saveDraft(
    String id, {
    required String title,
    required String body,
  }) async {
    try {
      final res = await _dio.patch<Map<String, dynamic>>(
        ApiPaths.prediction(id),
        data: {'title': title, 'body': body},
      );
      _raise(res);
      return res.data ?? const {};
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<Map<String, dynamic>> deliver(
    String id, {
    required String title,
    required String body,
  }) => _postMap(ApiPaths.predictionDeliver(id), {'title': title, 'body': body});

  Future<Map<String, dynamic>> release(String id) =>
      _postMap(ApiPaths.predictionRelease(id), const {});

  // --- helpers ---------------------------------------------------------

  Future<Map<String, dynamic>> _getMap(String path) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(path);
      _raise(res);
      return res.data ?? const {};
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<List<dynamic>> _getList(String path) async {
    try {
      final res = await _dio.get<dynamic>(path);
      _raise(res);
      final data = res.data;
      return data is List ? data : const [];
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<Map<String, dynamic>> _postMap(
    String path,
    Map<String, dynamic> body,
  ) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(path, data: body);
      _raise(res);
      return res.data ?? const {};
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  void _raise(Response<dynamic> res) {
    if ((res.statusCode ?? 0) >= 400) {
      throw ApiException.fromDio(
        DioException(requestOptions: res.requestOptions, response: res),
      );
    }
  }
}
