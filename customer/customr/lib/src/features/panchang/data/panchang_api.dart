import 'package:dio/dio.dart';

import '../../../core/constants/api_paths.dart';
import '../../../core/network/api_exception.dart';
import 'models/day_panchang.dart';

/// `GET /app/panchang` — the day's panchang for any place. Throws [ApiException].
class PanchangApi {
  PanchangApi(this._dio);

  final Dio _dio;

  Future<DayPanchang> forPlace(PanchangPlace place, DateTime date) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        ApiPaths.panchang,
        queryParameters: {
          'latitude': place.latitude.toStringAsFixed(4),
          'longitude': place.longitude.toStringAsFixed(4),
          'date':
              '${date.year.toString().padLeft(4, '0')}-'
              '${date.month.toString().padLeft(2, '0')}-'
              '${date.day.toString().padLeft(2, '0')}',
          if (place.name.isNotEmpty) 'place': place.name,
        },
      );
      return DayPanchang.fromJson(res.data ?? const {});
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}
