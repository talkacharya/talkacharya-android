import 'package:dio/dio.dart';

import '../../../core/constants/api_paths.dart';
import '../../../core/network/api_exception.dart';

Map<String, dynamic> _map(Object? v) =>
    v is Map ? v.cast<String, dynamic>() : const {};

/// One message to support, and the team's reply once there is one.
class SupportMessage {
  const SupportMessage({
    required this.id,
    required this.topic,
    required this.message,
    required this.status,
    this.reply = '',
    this.repliedAt,
    this.unreadReply = false,
    this.createdAt,
  });

  factory SupportMessage.fromJson(Map<String, dynamic> j) => SupportMessage(
    id: '${j['id'] ?? ''}',
    topic: '${j['topic'] ?? 'other'}',
    message: '${j['message'] ?? ''}',
    status: '${j['status'] ?? 'open'}',
    reply: '${j['reply'] ?? ''}',
    repliedAt: DateTime.tryParse('${j['replied_at'] ?? ''}')?.toLocal(),
    unreadReply: j['unread_reply'] == true,
    createdAt: DateTime.tryParse('${j['created_at'] ?? ''}')?.toLocal(),
  );

  final String id;

  /// payment | consultation | order | account | app | other
  final String topic;
  final String message;

  /// open | answered | closed
  final String status;
  final String reply;
  final DateTime? repliedAt;
  final bool unreadReply;
  final DateTime? createdAt;

  bool get answered => reply.isNotEmpty;
}

class SupportInbox {
  const SupportInbox({this.unreadReplies = 0, this.messages = const []});

  factory SupportInbox.fromJson(Map<String, dynamic> j) => SupportInbox(
    unreadReplies: (j['unread_replies'] as num?)?.toInt() ?? 0,
    messages: [
      for (final m in j['messages'] as List? ?? const [])
        SupportMessage.fromJson(_map(m)),
    ],
  );

  final int unreadReplies;
  final List<SupportMessage> messages;
}

/// `/app/support/messages` — write to the team and read their replies.
/// Throws [ApiException].
class SupportMessagesApi {
  SupportMessagesApi(this._dio);

  final Dio _dio;

  Future<SupportInbox> inbox() => _call(() async {
    final res = await _dio.get<dynamic>(ApiPaths.supportMessages);
    _raiseFor(res);
    return SupportInbox.fromJson(_map(res.data));
  });

  Future<SupportMessage> send({
    required String topic,
    required String message,
    String appVersion = '',
  }) => _call(() async {
    final res = await _dio.post<dynamic>(
      ApiPaths.supportMessages,
      data: {
        'topic': topic,
        'message': message.trim(),
        'app_version': appVersion,
      },
    );
    _raiseFor(res);
    return SupportMessage.fromJson(_map(res.data));
  });

  Future<void> markSeen() => _call(() async {
    _raiseFor(await _dio.post<dynamic>(ApiPaths.supportMessagesSeen));
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
