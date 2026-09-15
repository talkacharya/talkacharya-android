import 'package:dio/dio.dart';

import '../../../core/constants/api_paths.dart';
import '../../../core/network/api_exception.dart';

/// Transport for the paid-predictions endpoints. Returns raw JSON; the models
/// (from `package:talkacharya_predictions`) parse it. Throws [ApiException].
class PredictionsApi {
  PredictionsApi(this._dio);

  final Dio _dio;

  Future<Map<String, dynamic>> catalog() => _getMap(ApiPaths.predictionsCatalog);

  Future<List<dynamic>> orders() => _getList(ApiPaths.predictionsOrders);

  Future<Map<String, dynamic>> buyPack(int pack) =>
      _postMap(ApiPaths.predictionsOrders, {'pack': pack});

  Future<Map<String, dynamic>> subscription(
    String action, {
    String? birthProfileId,
  }) => _postMap(ApiPaths.predictionsSubscription, {
    'action': action,
    'birth_profile': ?birthProfileId,
  });

  Future<List<dynamic>> list() => _getList(ApiPaths.predictions);

  Future<Map<String, dynamic>> request({
    required String birthProfileId,
    required String area,
    required String period,
  }) => _postMap(ApiPaths.predictions, {
    'birth_profile': birthProfileId,
    'area': area,
    'period': period,
  });

  Future<Map<String, dynamic>> detail(String id) =>
      _getMap(ApiPaths.prediction(id));

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
