import 'package:dio/dio.dart';

import '../../../core/constants/api_paths.dart';
import '../../../core/network/api_exception.dart';
import 'models/consultation.dart';
import 'models/conversation.dart';
import 'models/queue_entry.dart';

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
    String? matchId,
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
          'match': ?matchId,
          'question': question,
          'topics': topics,
        },
      );
      return _booked(res);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// Ask for another session inside thread [threadId], carrying over who the
  /// reading is for. Returns the one already pending if there is one.
  Future<Consultation> consultAgain(
    String threadId, {
    String channel = 'chat',
  }) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        ApiPaths.conversationConsult(threadId),
        data: {'channel': channel},
      );
      return _booked(res);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// A booking response, or the reason there is no booking — typed, because
  /// each one has its own way forward (top up, wait, try someone else).
  Consultation _booked(Response<Map<String, dynamic>> res) {
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
  }

  /// A PDF (or plain text, where the server cannot make one) of the thread,
  /// or of one session in it.
  Future<List<int>> transcript(String threadId, {String? consultationId}) async {
    final res = await _dio.get<List<int>>(
      ApiPaths.transcript(threadId),
      queryParameters: {'consultation': ?consultationId},
      options: Options(responseType: ResponseType.bytes),
    );
    return res.data ?? const [];
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

  /// The chats list: one row per astrologer, newest activity first.
  Future<List<Conversation>> conversations() async {
    try {
      final res = await _dio.get<List<dynamic>>(ApiPaths.conversations);
      _raise(res);
      return (res.data ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(Conversation.fromMap)
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// One thread: peer, unread count and whether it takes messages right now.
  /// Switch a live consultation to another channel. Returns the **new**
  /// consultation — the old one ends, priced as what it was.
  Future<Consultation> upgradeChannel(String id, String channel) async {
    final res = await _dio.post<Map<String, dynamic>>(
      ApiPaths.consultationUpgrade(id),
      data: {'channel': channel},
    );
    return Consultation.fromMap(res.data ?? const {});
  }

  Future<Conversation> conversation(String id) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        ApiPaths.conversation(id),
      );
      _raise(res);
      return Conversation.fromMap(res.data ?? const {});
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// Mute, archive or block — this user's own settings for the thread.
  /// Returns the thread as it now stands.
  Future<Conversation> setPreferences(
    String threadId, {
    bool? muted,
    bool? archived,
    bool? blocked,
  }) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        ApiPaths.conversationPreferences(threadId),
        data: {'muted': ?muted, 'archived': ?archived, 'blocked': ?blocked},
      );
      _raise(res);
      return Conversation.fromMap(res.data ?? const {});
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

  /// Share a birth profile or a match with the astrologer mid-session.
  Future<Consultation> share(
    String id, {
    String? birthProfileId,
    String? matchId,
  }) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        ApiPaths.consultationShares(id),
        data: {'birth_profile': ?birthProfileId, 'match': ?matchId},
      );
      _raise(res);
      return Consultation.fromMap(res.data ?? const {});
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

  /// Take a place in a busy astrologer's waitlist. Joining twice returns the
  /// place already held.
  Future<QueueEntry> joinQueue({
    required String astrologerId,
    required String channel,
  }) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        ApiPaths.queue,
        data: {'astrologer': astrologerId, 'channel': channel},
      );
      _raise(res);
      return QueueEntry.fromMap(res.data ?? const {});
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// Free minutes this customer's next consultation gets back under the
  /// welcome offer; 0 when it is not theirs (or the answer is unknown).
  Future<int> welcomeOfferMinutes() async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(ApiPaths.welcomeOffer);
      if ((res.statusCode ?? 0) >= 400) return 0;
      if (res.data?['eligible'] != true) return 0;
      return (res.data?['free_minutes'] as num?)?.toInt() ?? 0;
    } on DioException {
      return 0;
    }
  }

  /// Every waitlist this customer is still in.
  Future<List<QueueEntry>> myQueue() async {
    try {
      final res = await _dio.get<List<dynamic>>(ApiPaths.queue);
      _raise(res);
      return (res.data ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(QueueEntry.fromMap)
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<void> leaveQueue(String id) async {
    try {
      final res = await _dio.delete<void>(ApiPaths.queueEntry(id));
      _raise(res);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}
