import 'package:dio/dio.dart';

import '../../../core/constants/api_paths.dart';
import '../../../core/network/api_exception.dart';
import 'models/dispute.dart';

/// Raised when the session already has a report in progress
/// (`dispute.already_open`). The view offers to open it instead.
class DisputeAlreadyOpen implements Exception {
  const DisputeAlreadyOpen();
}

/// Transport for consultation reports (`apps/disputes`). Throws [ApiException].
class SupportApi {
  SupportApi(this._dio);

  final Dio _dio;

  Future<List<Dispute>> disputes({String? consultationId}) async {
    try {
      final res = await _dio.get<List<dynamic>>(
        ApiPaths.disputes,
        queryParameters: {'consultation': ?consultationId},
      );
      return (res.data ?? const [])
          .map((e) => Dispute.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<Dispute> dispute(String id) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(ApiPaths.dispute(id));
      return Dispute.fromJson(res.data ?? const {});
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<Dispute> raise({
    required String consultationId,
    required DisputeType type,
    required String description,
  }) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        ApiPaths.consultationDispute(consultationId),
        data: {'type': type.wire, 'description': description},
      );
      return Dispute.fromJson(res.data ?? const {});
    } on DioException catch (e) {
      final err = ApiException.fromDio(e);
      if (err.code == 'dispute.already_open') throw const DisputeAlreadyOpen();
      throw err;
    }
  }
}
