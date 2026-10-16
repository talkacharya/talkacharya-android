import 'package:dio/dio.dart';
import 'package:talkacharya_assistant/talkacharya_assistant.dart';

import '../../../core/constants/api_paths.dart';
import '../../../core/network/api_exception.dart';

Map<String, dynamic> _map(Object? v) =>
    v is Map ? v.cast<String, dynamic>() : const {};

/// `/app/assistant/...` — the free, text-only chat with an astrologer, outside
/// any consultation. The astrologer replies themselves. Throws [ApiException].
class AssistantApi {
  AssistantApi(this._dio);

  final Dio _dio;

  Future<List<AssistantThread>> threads() => _call(() async {
    final res = await _dio.get<dynamic>(ApiPaths.assistantThreads);
    _raiseFor(res);
    return [
      for (final t in res.data as List? ?? const [])
        AssistantThread.fromJson(_map(t)),
    ];
  });

  /// The thread with [astrologerId], made the first time.
  Future<AssistantDetail> open(String astrologerId) => _call(() async {
    final res = await _dio.post<dynamic>(
      ApiPaths.assistantThreads,
      data: {'astrologer': astrologerId},
    );
    _raiseFor(res);
    return AssistantDetail.fromJson(_map(res.data));
  });

  Future<AssistantDetail> thread(String id) => _call(() async {
    final res = await _dio.get<dynamic>(ApiPaths.assistantThread(id));
    _raiseFor(res);
    return AssistantDetail.fromJson(_map(res.data));
  });

  Future<List<AssistantMessage>> messages(
    String id, {
    String? after,
    String? before,
  }) => _call(() async {
    final res = await _dio.get<dynamic>(
      ApiPaths.assistantMessages(id),
      queryParameters: {'after': ?after, 'before': ?before},
    );
    _raiseFor(res);
    return [
      for (final m in res.data as List? ?? const [])
        AssistantMessage.fromJson(_map(m)),
    ];
  });

  Future<AssistantMessage> send(String id, String body) => _call(() async {
    final res = await _dio.post<dynamic>(
      ApiPaths.assistantMessages(id),
      data: {'body': body},
    );
    _raiseFor(res);
    return AssistantMessage.fromJson(_map(res.data));
  });

  Future<T> _call<T>(Future<T> Function() run) async {
    try {
      return await run();
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  void _raiseFor(Response<dynamic> res) {
    if ((res.statusCode ?? 0) >= 400) {
      throw ApiException.fromDio(
        DioException(requestOptions: res.requestOptions, response: res),
      );
    }
  }
}
