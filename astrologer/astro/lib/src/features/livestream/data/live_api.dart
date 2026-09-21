import 'package:dio/dio.dart';
import 'package:talkacharya_live/talkacharya_live.dart';

import '../../../core/constants/api_paths.dart';
import '../../../core/network/api_exception.dart';
import 'models/host_stream.dart';

/// Transport for the astrologer's own streams (`/astro/livestreams`).
/// Throws [ApiException].
class LiveApi {
  LiveApi(this._dio);

  final Dio _dio;

  /// Everything this astrologer has scheduled, run or cancelled (newest first).
  Future<List<HostStream>> mine() async {
    try {
      final res = (await _dio.get<dynamic>(
        ApiPaths.astroLivestreams,
      )).ensureOk();
      final data = res.data;
      final items = data is List ? data : const [];
      return [
        for (final e in items)
          HostStream.fromJson((e as Map).cast<String, dynamic>()),
      ];
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// Creates the stream row. It is not on air until [start].
  Future<HostStream> schedule({
    required String title,
    String description = '',
    String language = 'en',
    DateTime? scheduledAt,
  }) async {
    try {
      final res = (await _dio.post<Map<String, dynamic>>(
        ApiPaths.astroLivestreams,
        data: {
          'title': title,
          'description': description,
          'language': language,
          if (scheduledAt != null)
            'scheduled_at': scheduledAt.toUtc().toIso8601String(),
        },
      )).ensureOk();
      return HostStream.fromJson(res.data ?? const {});
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// Goes on air — returns the publisher token for the room.
  Future<LiveJoin> start(String id) async {
    try {
      final res = (await _dio.post<Map<String, dynamic>>(
        ApiPaths.astroLiveStart(id),
      )).ensureOk();
      return LiveJoin.fromJson(res.data ?? const {});
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<void> end(String id, {String reason = ''}) async {
    try {
      (await _dio.post<Map<String, dynamic>>(
        ApiPaths.astroLiveEnd(id),
        data: {'reason': reason},
      )).ensureOk();
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<List<LiveChatMessage>> chat(String id) async {
    try {
      final res = (await _dio.get<dynamic>(
        ApiPaths.astroLiveChat(id),
      )).ensureOk();
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
      if (imagePath == null || imagePath.isEmpty) {
        (await _dio.post<Map<String, dynamic>>(
          ApiPaths.astroLiveChat(id),
          data: {'text': text},
        )).ensureOk();
        return;
      }
      (await _dio.post<Map<String, dynamic>>(
        ApiPaths.astroLiveChat(id),
        data: FormData.fromMap({
          'text': text,
          'image': await MultipartFile.fromFile(imagePath),
        }),
      )).ensureOk();
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// Bans and ejects a viewer, and hides what they already said.
  Future<void> removeViewer(
    String id,
    String userId, {
    String reason = '',
  }) async {
    try {
      (await _dio.post<Map<String, dynamic>>(
        ApiPaths.astroLiveRemoveViewer(id),
        data: {'user': userId, 'reason': reason},
      )).ensureOk();
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// 0 turns slow mode off; the server clamps to 0-300 s.
  Future<void> setSlowMode(String id, int seconds) async {
    try {
      (await _dio.post<Map<String, dynamic>>(
        ApiPaths.astroLiveSlowMode(id),
        data: {'seconds': seconds},
      )).ensureOk();
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<void> pinMessage(
    String id,
    String messageId, {
    bool pin = true,
    bool hide = false,
  }) async {
    try {
      (await _dio.post<Map<String, dynamic>>(
        ApiPaths.astroLivePin(id),
        data: {'message': messageId, 'pin': pin, 'hide': hide},
      )).ensureOk();
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// Who is watching right now.
  Future<List<LiveViewer>> viewers(String id) async {
    try {
      final res = (await _dio.get<dynamic>(
        ApiPaths.astroLiveViewers(id),
      )).ensureOk();
      final data = res.data;
      final items = data is List ? data : const [];
      return [
        for (final e in items)
          LiveViewer.fromJson((e as Map).cast<String, dynamic>()),
      ];
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}
