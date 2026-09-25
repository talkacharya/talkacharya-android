import 'package:dio/dio.dart';

import '../../../core/constants/api_paths.dart';
import '../../../core/network/api_exception.dart';
import 'models/consultation.dart';
import 'models/conversation.dart';
import 'models/saved_reply.dart';
import 'models/consultation_share.dart';

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

  /// The Chats tab: one permanent thread per customer, newest activity first.
  Future<List<Conversation>> conversations() async {
    final res = await _dio.get<dynamic>(ApiPaths.conversations);
    return (res.data as List? ?? const [])
        .map((e) => Conversation.fromJson((e as Map).cast<String, dynamic>()))
        .toList();
  }

  /// Resolves a thread. Takes either id — the server accepts a consultation's
  /// too, which is what a push or a deep link carries.
  Future<Conversation> conversation(String id) async {
    try {
      final res = (await _dio.get<Map<String, dynamic>>(
        ApiPaths.conversation(id),
      )).ensureOk();
      return Conversation.fromJson(res.data ?? const {});
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<List<Consultation>> incoming() async {
    final res = await _dio.get<dynamic>(ApiPaths.astroConsultationRequests);
    return (res.data as List? ?? const [])
        .map((e) => Consultation.fromJson((e as Map).cast<String, dynamic>()))
        .toList();
  }

  /// Quick replies, most-used first. The server seeds a starter set the
  /// first time, so this is never empty on a new account.
  Future<List<SavedReply>> savedReplies() async {
    final res = await _dio.get<dynamic>(ApiPaths.savedReplies);
    return (res.data as List? ?? const [])
        .map((e) => SavedReply.fromJson((e as Map).cast<String, dynamic>()))
        .toList();
  }

  Future<SavedReply> createSavedReply(String body) async {
    try {
      final res = (await _dio.post<Map<String, dynamic>>(
        ApiPaths.savedReplies,
        data: {'body': body},
      )).ensureOk();
      return SavedReply.fromJson(res.data ?? const {});
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<void> deleteSavedReply(String id) =>
      _dio.delete<void>(ApiPaths.savedReply(id));

  /// Records that one was used; the list orders itself from this.
  Future<void> useSavedReply(String id) =>
      _dio.post<void>(ApiPaths.savedReply(id));

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
      final res = (await _dio.post<Map<String, dynamic>>(
        path,
        data: body ?? {},
      )).ensureOk();
      return Consultation.fromJson(res.data ?? const {});
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// Full Guna Milan report for a match the customer shared.
  Future<MatchReport> sharedMatch(String consultationId, String matchId) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        ApiPaths.astroConsultationMatch(consultationId, matchId),
      );
      return MatchReport.fromJson(res.ensureOk().data ?? const {});
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<Map<String, dynamic>> chart(
    String id, {
    String type = 'kundli',
  }) async {
    final res = await _dio.get<Map<String, dynamic>>(
      ApiPaths.astroConsultationChart(id),
      queryParameters: {'type': type},
    );
    return res.data ?? const {};
  }
}
