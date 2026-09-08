import 'package:dio/dio.dart';

import '../../../core/constants/api_paths.dart';
import '../../../core/network/api_exception.dart';
import 'models/chat_message.dart';
import 'models/consultation.dart';

class ConsultationApi {
  ConsultationApi(this._dio);
  final Dio _dio;

  Future<List<Consultation>> list({String? status}) async {
    final res = await _dio.get<dynamic>(
      ApiPaths.astroConsultations,
      queryParameters: {if (status != null) 'status': status},
    );
    return (res.data as List? ?? const [])
        .map((e) => Consultation.fromJson((e as Map).cast<String, dynamic>()))
        .toList();
  }

  Future<List<Consultation>> incoming() async {
    final res = await _dio.get<dynamic>(ApiPaths.astroConsultationRequests);
    return (res.data as List? ?? const [])
        .map((e) => Consultation.fromJson((e as Map).cast<String, dynamic>()))
        .toList();
  }

  Future<Consultation> detail(String id) async {
    final res = await _dio.get<Map<String, dynamic>>(
      ApiPaths.astroConsultation(id),
    );
    return Consultation.fromJson(res.data ?? const {});
  }

  Future<Consultation> accept(String id) => _act(ApiPaths.astroAccept(id));

  Future<Consultation> reject(String id, String reason) =>
      _act(ApiPaths.astroReject(id), body: {'reason': reason});

  Future<Consultation> end(String id) => _act(ApiPaths.astroEnd(id));

  Future<Consultation> _act(String path, {Map<String, dynamic>? body}) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(path, data: body ?? {});
      return Consultation.fromJson(res.data ?? const {});
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<List<ChatMessage>> messages(String id, {int? after}) async {
    final res = await _dio.get<dynamic>(
      ApiPaths.messages(id),
      queryParameters: {if (after != null) 'after': after},
    );
    return (res.data as List? ?? const [])
        .map((e) => ChatMessage.fromJson((e as Map).cast<String, dynamic>()))
        .toList();
  }

  Future<ChatMessage> send(
    String id, {
    required String body,
    required String clientId,
    List<String> attachmentIds = const [],
  }) async {
    final res = await _dio.post<Map<String, dynamic>>(
      ApiPaths.messages(id),
      data: {
        'body': body,
        'type': attachmentIds.isEmpty ? 'text' : 'image',
        'client_message_id': clientId,
        if (attachmentIds.isNotEmpty) 'attachment_ids': attachmentIds,
      },
    );
    return ChatMessage.fromJson(res.data ?? const {});
  }

  Future<void> markRead(String id, int upToSeq) =>
      _dio.post(ApiPaths.messagesRead(id), data: {'up_to_seq': upToSeq});

  Future<void> typing(String id, bool isTyping) =>
      _dio.post(ApiPaths.typing(id), data: {'is_typing': isTyping});

  Future<Map<String, dynamic>> chart(String id, {String type = 'kundli'}) async {
    final res = await _dio.get<Map<String, dynamic>>(
      ApiPaths.astroConsultationChart(id),
      queryParameters: {'type': type},
    );
    return res.data ?? const {};
  }
}
