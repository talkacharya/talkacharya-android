import 'package:dio/dio.dart';

import '../../../core/constants/api_paths.dart';
import '../../../core/network/api_exception.dart';
import 'models/match_result.dart';

/// Guna Milan endpoints (`/app/matchmaking`). Throws [ApiException].
class MatchmakingRepository {
  MatchmakingRepository(this._dio);

  final Dio _dio;

  Future<MatchResult> run({
    required String boyProfileId,
    required String girlProfileId,
  }) async {
    final data = await _send(
      () => _dio.post<Map<String, dynamic>>(
        ApiPaths.matchmaking,
        data: {'boy_profile': boyProfileId, 'girl_profile': girlProfileId},
      ),
    );
    return MatchResult.fromJson((data as Map).cast<String, dynamic>());
  }

  Future<List<MatchResult>> history() async {
    final data = await _send(() => _dio.get<dynamic>(ApiPaths.matchmaking));
    return [
      for (final m in (data is List ? data : const []))
        if (m is Map) MatchResult.fromJson(m.cast<String, dynamic>()),
    ];
  }

  Future<MatchResult> detail(String id) async {
    final data = await _send(
      () => _dio.get<Map<String, dynamic>>(ApiPaths.matchmakingDetail(id)),
    );
    return MatchResult.fromJson((data as Map).cast<String, dynamic>());
  }

  Future<dynamic> _send(Future<Response<dynamic>> Function() call) async {
    try {
      final res = await call();
      if ((res.statusCode ?? 0) >= 400) {
        throw ApiException.fromDio(
          DioException(requestOptions: res.requestOptions, response: res),
        );
      }
      return res.data ?? const {};
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}
