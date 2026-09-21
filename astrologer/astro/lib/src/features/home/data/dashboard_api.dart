import 'package:dio/dio.dart';

import '../../../core/constants/api_paths.dart';
import '../../../core/network/api_exception.dart';
import '../../earnings/data/earnings_api.dart';
import 'dashboard_models.dart';

/// Home-dashboard reads. Consultation lists come from [ConsultationApi].
class DashboardApi {
  DashboardApi(this._dio, this._earnings);

  final Dio _dio;
  final EarningsApi _earnings;

  Future<DashboardStats> stats({required int days}) async {
    final res = await _ok(
      _dio.get<Map<String, dynamic>>(
        ApiPaths.astroAnalytics,
        queryParameters: {'days': days},
      ),
    );
    return DashboardStats.fromJson(res.data ?? const {});
  }

  Future<PayoutSummary> payouts() async =>
      PayoutSummary.fromJson(await _earnings.summary());

  /// Awaits [call] and throws on a 4xx (see [EnsureOk]).
  Future<Response<T>> _ok<T>(Future<Response<T>> call) async =>
      (await call).ensureOk();
}
