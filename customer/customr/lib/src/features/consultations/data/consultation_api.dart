import 'package:dio/dio.dart';

import '../../../core/constants/api_paths.dart';
import '../../../core/network/api_exception.dart';
import 'models/consultation.dart';

/// Raised on `402` — the wallet needs a top-up before the consultation starts.
class InsufficientBalance implements Exception {
  InsufficientBalance({
    required this.required,
    required this.available,
    required this.currency,
  });
  final String required;
  final String available;
  final String currency;
}

/// Raised on `409` — the astrologer is busy; offer the queue.
class AstrologerBusy implements Exception {}

/// Raised when the astrologer is offline.
class AstrologerOffline implements Exception {
  AstrologerOffline([this.message]);
  final String? message;
}

class ConsultationApi {
  ConsultationApi(this._dio);

  final Dio _dio;

  void _raise(Response<dynamic> res) {
    if ((res.statusCode ?? 0) >= 400) {
      throw ApiException.fromDio(
        DioException(requestOptions: res.requestOptions, response: res),
      );
    }
  }

  Future<Consultation> request({
    required String astrologerId,
    required String channel,
    String? birthProfileId,
    String question = '',
    List<String> topics = const [],
  }) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        ApiPaths.consultations,
        data: {
          'astrologer': astrologerId,
          'channel': channel,
          'birth_profile': ?birthProfileId,
          'question': question,
          'topics': topics,
        },
      );
      final code = res.statusCode ?? 0;
      if (code == 402) {
        final d =
            (res.data?['detail'] as Map?)?.cast<String, dynamic>() ?? const {};
        throw InsufficientBalance(
          required: '${d['required'] ?? ''}',
          available: '${d['available'] ?? ''}',
          currency: '${d['currency'] ?? 'INR'}',
        );
      }
      if (code == 409) throw AstrologerBusy();
      if (res.data?['code'] == 'consultation.astrologer_unavailable') {
        throw AstrologerOffline(res.data?['message'] as String?);
      }
      _raise(res);
      return Consultation.fromMap(res.data ?? const {});
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<Consultation> detail(String id) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        ApiPaths.consultation(id),
      );
      _raise(res);
      return Consultation.fromMap(res.data ?? const {});
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<List<Consultation>> list({String? status}) async {
    try {
      final res = await _dio.get<List<dynamic>>(
        ApiPaths.consultations,
        queryParameters: {'status': ?status},
      );
      _raise(res);
      return (res.data ?? const [])
          .map((e) => Consultation.fromMap(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<Consultation> cancel(String id) async {
    final res = await _dio.post<Map<String, dynamic>>(
      ApiPaths.consultationCancel(id),
    );
    return Consultation.fromMap(res.data ?? const {});
  }

  Future<Consultation> end(String id) async {
    final res = await _dio.post<Map<String, dynamic>>(
      ApiPaths.consultationEnd(id),
    );
    return Consultation.fromMap(res.data ?? const {});
  }

  Future<void> review(String id, {required int rating, String text = ''}) =>
      _dio.post<void>(
        ApiPaths.consultationReview(id),
        data: {'rating': rating, 'text': text},
      );
}
