import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../constants/api_paths.dart';

/// "Delivered" for chat messages that reach this phone outside their room —
/// the second tick on the sender's side. (Inside the room, ChatController says
/// delivered/read itself.)
///
/// Three ways a message arrives outside the room: the realtime inbox frame
/// while the app is open, a push while it is in front, and a push while it is
/// in the background or killed. The server takes the same receipt twice
/// without harm, so each path just reports what it saw.

/// Where the background isolate finds the API: it has no flavor or DI, so the
/// main isolate leaves the base URL here at startup.
const _kApiBase = 'ta_api_base_url';
const _kAccess = 'ta_access_token';

const _store = FlutterSecureStorage(
  aOptions: AndroidOptions(encryptedSharedPreferences: true),
);

Future<void> rememberApiBase(String baseUrl) async {
  try {
    await _store.write(key: _kApiBase, value: baseUrl);
  } catch (_) {}
}

/// With the app's own [Dio] (auth, retries) — the app is running.
Future<void> reportChatDelivered(Dio dio, String thread, int seq) async {
  if (thread.isEmpty || seq <= 0) return;
  try {
    await dio.post<void>(
      ApiPaths.messagesDelivered(thread),
      data: {'up_to_seq': seq},
    );
  } catch (_) {
    // Best-effort: the room marks it delivered (and read) when opened.
  }
}

/// From a push's data (thread and seq), with no app around it — the FCM
/// background isolate. Uses the saved token as-is: an expired one just means
/// this tick waits for the room to be opened.
Future<void> reportChatDeliveredFromPush(Map<String, dynamic> data) async {
  final thread = '${data['thread'] ?? ''}';
  final seq = int.tryParse('${data['seq'] ?? ''}') ?? 0;
  if (thread.isEmpty || seq <= 0) return;
  try {
    final base = await _store.read(key: _kApiBase);
    final token = await _store.read(key: _kAccess);
    if (base == null || base.isEmpty || token == null || token.isEmpty) return;
    final dio = Dio(
      BaseOptions(
        baseUrl: base,
        connectTimeout: const Duration(seconds: 8),
        receiveTimeout: const Duration(seconds: 8),
        headers: {
          'Authorization': 'Bearer $token',
          'X-Client-App': 'astrologer',
        },
      ),
    );
    await dio.post<void>(
      ApiPaths.messagesDelivered(thread),
      data: {'up_to_seq': seq},
    );
  } catch (_) {}
}
