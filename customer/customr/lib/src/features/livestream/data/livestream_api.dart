import 'package:dio/dio.dart';
import 'package:talkacharya_live/talkacharya_live.dart';

import '../../../core/constants/api_paths.dart';
import '../../../core/network/api_exception.dart';
import 'models/live_stream_summary.dart';

/// Raised when the stream can't be joined any more — it ended while we were
/// tapping, or a moderator banned this viewer.
class LiveStreamUnavailable implements Exception {
  const LiveStreamUnavailable(this.reason);

  /// `ended` | `banned` | `unknown`.
  final String reason;

  bool get banned => reason == 'banned';
}

/// Transport for `/app/livestreams`. Throws [ApiException] /
/// [LiveStreamUnavailable].
class LivestreamApi {
  LivestreamApi(this._dio);

  final Dio _dio;

  Future<List<LiveStreamSummary>> list({String? status}) async {
    try {
      final res = await _dio.get<dynamic>(
        ApiPaths.livestreams,
        queryParameters: {'status': ?status},
      );
      final data = res.data;
      final items = data is List
          ? data
          : (data is Map && data['results'] is List
                ? data['results'] as List
                : const []);
      return [
        for (final e in items)
          LiveStreamSummary.fromJson((e as Map).cast<String, dynamic>()),
      ];
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<LiveStreamSummary> detail(String id) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(ApiPaths.livestream(id));
      return LiveStreamSummary.fromJson(res.data ?? const {});
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<LiveJoin> join(String id) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '${ApiPaths.livestream(id)}/join',
      );
      return LiveJoin.fromJson(res.data ?? const {});
    } on DioException catch (e) {
      throw _translate(e);
    }
  }

  Future<void> leave(String id) async {
    try {
      await _dio.post<void>('${ApiPaths.livestream(id)}/leave');
    } on DioException {
      // leaving is best-effort: the viewer sweep drops us from the count anyway
    }
  }

  Future<int> heartbeat(String id) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '${ApiPaths.livestream(id)}/heartbeat',
      );
      return (res.data?['viewer_count'] as num?)?.toInt() ?? 0;
    } on DioException catch (e) {
      throw _translate(e);
    }
  }

  Future<List<LiveChatMessage>> chat(String id) async {
    try {
      final res = await _dio.get<dynamic>('${ApiPaths.livestream(id)}/chat');
      final data = res.data;
      final items = data is List ? data : const [];
      return [
        for (final e in items)
          LiveChatMessage.fromJson((e as Map).cast<String, dynamic>()),
      ];
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// Sends a chat line: text, a picture, or both. A picture goes as multipart.
  Future<void> sendChat(String id, String text, {String? imagePath}) async {
    try {
      final path = '${ApiPaths.livestream(id)}/chat';
      if (imagePath == null || imagePath.isEmpty) {
        await _dio.post<Map<String, dynamic>>(path, data: {'text': text});
        return;
      }
      await _dio.post<Map<String, dynamic>>(
        path,
        data: FormData.fromMap({
          'text': text,
          'image': await MultipartFile.fromFile(imagePath),
        }),
      );
    } on DioException catch (e) {
      throw _translate(e);
    }
  }

  /// The backend's domain codes, turned into something the UI can act on.
  Exception _translate(DioException e) {
    final api = ApiException.fromDio(e);
    return switch (api.code) {
      'livestream.banned' => const LiveStreamUnavailable('banned'),
      'invalid_state' => const LiveStreamUnavailable('ended'),
      _ => api,
    };
  }
}
