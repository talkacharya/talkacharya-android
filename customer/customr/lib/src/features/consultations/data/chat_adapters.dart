import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:talkacharya_chat/talkacharya_chat.dart';

import '../../../core/constants/api_paths.dart';
import '../../../core/realtime/realtime_client.dart';

/// Customer-side wiring for the shared chat engine.

/// Disk-backed [ChatOutbox] so a message composed and sent while the app is
/// killed isn't lost. Tiny payloads, keyed per consultation.
class SecureStorageChatOutbox extends ChatOutbox {
  const SecureStorageChatOutbox(this._store);
  final FlutterSecureStorage _store;

  String _key(String id) => 'chat_outbox_$id';

  @override
  Future<List<ChatMessage>> load(String consultationId) async {
    try {
      final raw = await _store.read(key: _key(consultationId));
      if (raw == null || raw.isEmpty) return const [];
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .whereType<Map<String, dynamic>>()
          .map(ChatOutbox.decode)
          .toList();
    } catch (_) {
      return const [];
    }
  }

  @override
  Future<void> save(String consultationId, List<ChatMessage> unsent) async {
    try {
      if (unsent.isEmpty) {
        await _store.delete(key: _key(consultationId));
        return;
      }
      await _store.write(
        key: _key(consultationId),
        value: jsonEncode(unsent.map(ChatOutbox.encode).toList()),
      );
    } catch (_) {}
  }
}

class DioChatTransport implements ChatTransport {
  DioChatTransport(this._dio, this.consultationId);
  final Dio _dio;
  final String consultationId;

  @override
  Future<List<ChatMessage>> history({
    int afterSeq = 0,
    int? beforeSeq,
    int limit = 50,
  }) async {
    final res = await _dio.get<List<dynamic>>(
      ApiPaths.messages(consultationId),
      queryParameters: {
        if (beforeSeq != null) 'before_seq': beforeSeq else 'after': afterSeq,
        'limit': limit,
      },
    );
    return (res.data ?? const [])
        .map((e) => ChatMessage.fromMap((e as Map).cast<String, dynamic>()))
        .toList();
  }

  @override
  Future<ChatMessage> send({
    String body = '',
    required String clientMessageId,
    List<String> attachmentIds = const [],
    int? replyToSeq,
  }) async {
    final res = await _dio.post<Map<String, dynamic>>(
      ApiPaths.messages(consultationId),
      data: {
        'body': body,
        'attachment_ids': attachmentIds,
        'client_message_id': clientMessageId,
        'reply_to_seq': ?replyToSeq,
      },
    );
    return ChatMessage.fromMap(res.data ?? const {});
  }

  @override
  Future<void> markRead(int upToSeq) => _dio.post<void>(
    ApiPaths.messagesRead(consultationId),
    data: {'up_to_seq': upToSeq},
  );

  @override
  Future<void> markDelivered(int upToSeq) => _dio.post<void>(
    ApiPaths.messagesDelivered(consultationId),
    data: {'up_to_seq': upToSeq},
  );

  @override
  Future<void> sendTyping(bool isTyping) => _dio.post<void>(
    ApiPaths.typing(consultationId),
    data: {'is_typing': isTyping},
  );

  @override
  Future<String?> translate(int seq, String target) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        ApiPaths.messageTranslate(consultationId, seq),
        data: {'target': target},
      );
      return res.data?['text'] as String?;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<ChatPresence> presence() async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        ApiPaths.chatPresence(consultationId),
      );
      return ChatPresence.fromMap(res.data ?? const {}, iAmCustomer: true);
    } catch (_) {
      return const ChatPresence();
    }
  }

  @override
  Future<ChatAttachment> uploadAttachment(String filePath) async {
    final name = filePath.split(RegExp(r'[/\\]')).last;
    final form = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath, filename: name),
    });
    final res = await _dio.post<Map<String, dynamic>>(
      ApiPaths.attachments(consultationId),
      data: form,
    );
    return ChatAttachment.fromMap(res.data ?? const {});
  }

  @override
  Future<void> reportMessage(int seq, String reason) => _dio.post<void>(
    ApiPaths.messageReport(consultationId, seq),
    data: {'reason': reason},
  );

  @override
  Future<List<ChatPin>> pins() async {
    final res = await _dio.get<List<dynamic>>(
      ApiPaths.messagePins(consultationId),
    );
    return (res.data ?? const [])
        .whereType<Map<String, dynamic>>()
        .map(ChatPin.fromMap)
        .toList();
  }

  @override
  Future<void> pin(int seq) => _dio.post<void>(
    ApiPaths.messagePins(consultationId),
    data: {'seq': seq},
  );

  @override
  Future<void> unpin(int seq) => _dio.delete<void>(
    ApiPaths.messagePins(consultationId),
    data: {'seq': seq},
  );
}

/// `image_picker`-backed [PickImages] for the shared composer.
Future<List<String>> pickChatImages(PickSource source) async {
  final picker = ImagePicker();
  if (source == PickSource.camera) {
    final shot = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 82,
      maxWidth: 2000,
    );
    return shot == null ? const [] : [shot.path];
  }
  final shots = await picker.pickMultiImage(imageQuality: 82, maxWidth: 2000);
  return shots.map((x) => x.path).toList();
}

class RealtimeChatAdapter implements ChatRealtime {
  RealtimeChatAdapter(this._rt) {
    _rt.connected.addListener(_emitConnection);
  }
  final RealtimeClient _rt;
  final _conn = StreamController<ConnectionStatus>.broadcast();

  void _emitConnection() => _conn.add(connectionNow);

  @override
  Stream<Map<String, dynamic>> frames(String channel) =>
      _rt.channelFrames(channel);

  @override
  Stream<ConnectionStatus> get connection => _conn.stream;

  @override
  ConnectionStatus get connectionNow =>
      _rt.isConnected ? ConnectionStatus.online : ConnectionStatus.reconnecting;

  @override
  Stream<PresenceEvent> presenceEvents(String channel) => _rt
      .channelPresence(channel)
      .map((e) => PresenceEvent(userId: e.userId, joined: e.joined));

  @override
  Future<void> publish(String channel, Map<String, dynamic> data) =>
      _rt.publishToChannel(channel, data);

  void dispose() {
    _rt.connected.removeListener(_emitConnection);
    _conn.close();
  }
}

class CustomerChatIdentity implements ChatIdentity {
  CustomerChatIdentity({required this.userId, required this.language});
  @override
  final String userId;
  @override
  final String language;
  @override
  ParticipantRole get role => ParticipantRole.customer;
  @override
  bool get canDictate => false;
}
