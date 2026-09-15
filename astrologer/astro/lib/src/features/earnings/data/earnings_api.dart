import 'package:dio/dio.dart';

import '../../../core/constants/api_paths.dart';

class EarningsApi {
  EarningsApi(this._dio);
  final Dio _dio;

  Future<Map<String, dynamic>> summary() async {
    final res = await _dio.get<Map<String, dynamic>>(ApiPaths.astroEarnings);
    return res.data ?? const {};
  }

  Future<List<Map<String, dynamic>>> entries({String? cursor}) =>
      _page(ApiPaths.astroEarningEntries, cursor);

  Future<List<Map<String, dynamic>>> payouts({String? cursor}) =>
      _page(ApiPaths.astroPayouts, cursor);

  Future<Map<String, dynamic>> payout(String id) async {
    final res = await _dio.get<Map<String, dynamic>>(ApiPaths.astroPayout(id));
    return res.data ?? const {};
  }

  Future<List<Map<String, dynamic>>> taxDocuments({String? kind}) async {
    final res = await _dio.get<dynamic>(
      ApiPaths.astroTaxDocuments,
      queryParameters: {if (kind != null) 'kind': kind},
    );
    return _rows(res.data);
  }

  Future<List<Map<String, dynamic>>> _page(String path, String? cursor) async {
    final res = await _dio.get<Map<String, dynamic>>(
      path,
      queryParameters: {if (cursor != null) 'cursor': cursor},
    );
    return _rows(res.data?['results'] ?? res.data);
  }

  List<Map<String, dynamic>> _rows(dynamic data) => (data as List? ?? const [])
      .map((e) => (e as Map).cast<String, dynamic>())
      .toList();
}
