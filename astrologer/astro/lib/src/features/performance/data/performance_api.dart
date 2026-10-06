import 'package:dio/dio.dart';

import '../../../core/constants/api_paths.dart';
import '../../../core/network/api_exception.dart';
import 'performance_models.dart';

/// The scorecard, the win-back list and the break allowance.
class PerformanceApi {
  PerformanceApi(this._dio);

  final Dio _dio;

  Future<Performance> performance() async {
    final res = await _ok(
      _dio.get<Map<String, dynamic>>(ApiPaths.astroPerformance),
    );
    return Performance.fromJson(res.data ?? const {});
  }

  Future<LapsedCustomers> lapsedCustomers() async {
    final res = await _ok(
      _dio.get<Map<String, dynamic>>(ApiPaths.astroLapsedCustomers),
    );
    return LapsedCustomers.fromJson(res.data ?? const {});
  }

  Future<BreakStatus> breakStatus() async {
    final res = await _ok(_dio.get<Map<String, dynamic>>(ApiPaths.astroBreak));
    return BreakStatus.fromJson(res.data ?? const {});
  }

  Future<BreakStatus> startBreak(int minutes) async {
    final res = await _ok(
      _dio.post<Map<String, dynamic>>(
        ApiPaths.astroBreak,
        data: {'minutes': minutes},
      ),
    );
    return BreakStatus.fromJson(res.data ?? const {});
  }

  Future<BreakStatus> endBreak() async {
    final res = await _ok(
      _dio.delete<Map<String, dynamic>>(ApiPaths.astroBreak),
    );
    return BreakStatus.fromJson(res.data ?? const {});
  }

  /// Awaits [call] and throws on a 4xx (see [EnsureOk]).
  Future<Response<T>> _ok<T>(Future<Response<T>> call) async =>
      (await call).ensureOk();
}
