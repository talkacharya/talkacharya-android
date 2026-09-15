import 'package:dio/dio.dart';

import '../../../core/constants/api_paths.dart';
import '../../../core/network/api_exception.dart';
import '../../home/data/models/zodiac.dart';
import 'models/sign_horoscope.dart';

/// `GET /app/horoscope?sign=&period=&day=` with a small in-memory cache — sign
/// readings change at most daily, so flipping between tabs and signs is instant
/// after the first load. Throws [ApiException].
class HoroscopeRepository {
  HoroscopeRepository(this._dio);

  final Dio _dio;
  final _cache = <String, (DateTime, SignHoroscope)>{};
  static const _ttl = Duration(minutes: 30);

  static String _key(ZodiacSign sign, HoroscopeSpan span) {
    final now = DateTime.now();
    return '${sign.slug}:${span.name}:${now.year}-${now.month}-${now.day}';
  }

  SignHoroscope? cached(ZodiacSign sign, HoroscopeSpan span) {
    final hit = _cache[_key(sign, span)];
    if (hit == null || DateTime.now().difference(hit.$1) > _ttl) return null;
    return hit.$2;
  }

  Future<SignHoroscope> fetch(
    ZodiacSign sign,
    HoroscopeSpan span, {
    bool force = false,
  }) async {
    if (!force) {
      final hit = cached(sign, span);
      if (hit != null) return hit;
    }
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        ApiPaths.horoscope,
        queryParameters: {
          'sign': sign.slug,
          'period': span.period,
          'day': ?span.day,
        },
      );
      if ((res.statusCode ?? 0) >= 400) {
        throw ApiException.fromDio(
          DioException(requestOptions: res.requestOptions, response: res),
        );
      }
      final h = SignHoroscope.fromJson(sign, span, res.data ?? const {});
      _cache[_key(sign, span)] = (DateTime.now(), h);
      return h;
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  void clear() => _cache.clear();
}
