import 'package:dio/dio.dart';

import '../../../core/constants/api_paths.dart';
import '../../../core/network/api_exception.dart';

/// Transport for the horary (Prashna) endpoints. Throws [ApiException].
class PrashnaApi {
  PrashnaApi(this._dio);

  final Dio _dio;

  Future<Map<String, dynamic>> catalog() => _getMap(ApiPaths.prashnaCatalog);

  Future<List<dynamic>> list() => _getList(ApiPaths.prashna);

  Future<Map<String, dynamic>> detail(String id) =>
      _getMap(ApiPaths.prashnaDetail(id));

  Future<Map<String, dynamic>> ask({
    required String question,
    required String category,
    double? latitude,
    double? longitude,
    String? placeLabel,
  }) => _postMap(ApiPaths.prashna, {
    'question': question,
    'category': category,
    'latitude': ?latitude,
    'longitude': ?longitude,
    'place_label': ?placeLabel,
  });

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
