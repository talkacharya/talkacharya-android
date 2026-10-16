import 'package:dio/dio.dart';
import 'package:talkacharya_assistant/talkacharya_assistant.dart';

import '../../../core/constants/api_paths.dart';
import '../../../core/network/api_exception.dart';

Map<String, dynamic> _map(Object? v) =>
    v is Map ? v.cast<String, dynamic>() : const {};

/// `/astro/assistant/...` — the free, text-only chats with customers. A customer
/// starts one from the astrologer's profile; the astrologer can open one from
/// their consultation history once the two have had a real consultation.
class AssistantApi {
  AssistantApi(this._dio);

  final Dio _dio;

  Future<List<AssistantThread>> threads() async {
    final res = (await _dio.get<dynamic>(
      ApiPaths.astroAssistantThreads,
    )).ensureOk();
    return [
      for (final t in res.data as List? ?? const [])
        AssistantThread.fromJson(_map(t)),
    ];
  }

  /// The free chat with the customer of [consultationId], made if needed.
  Future<AssistantDetail> openForConsultation(String consultationId) async =>
      AssistantDetail.fromJson(
        _map(
          (await _dio.post<dynamic>(
            ApiPaths.astroAssistantThreads,
            data: {'consultation': consultationId},
          )).ensureOk().data,
        ),
      );

  Future<AssistantDetail> thread(String id) async => AssistantDetail.fromJson(
    _map(
      (await _dio.get<dynamic>(
        ApiPaths.astroAssistantThread(id),
      )).ensureOk().data,
    ),
  );

  Future<List<AssistantMessage>> messages(
    String id, {
    String? after,
    String? before,
  }) async {
    final res = (await _dio.get<dynamic>(
      ApiPaths.astroAssistantMessages(id),
      queryParameters: {'after': ?after, 'before': ?before},
    )).ensureOk();
    return [
      for (final m in res.data as List? ?? const [])
        AssistantMessage.fromJson(_map(m)),
    ];
  }

  Future<AssistantMessage> send(String id, String body) async =>
      AssistantMessage.fromJson(
        _map(
          (await _dio.post<dynamic>(
            ApiPaths.astroAssistantMessages(id),
            data: {'body': body},
          )).ensureOk().data,
        ),
      );
}
