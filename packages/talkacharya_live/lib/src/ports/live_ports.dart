import '../models/live_chat_message.dart';
import '../models/live_join.dart';

/// REST side of a live stream — implemented per app over its Dio client.
///
/// The viewer app implements [LiveViewerBackend]; the astrologer app implements
/// [LiveHostBackend]. Both talk to `apps/livestream` (see backend docs/livestream.md).
abstract class LiveViewerBackend {
  /// `POST /app/livestreams/{id}/join` — room, token and the chat channel.
  Future<LiveJoin> join();

  /// `POST .../heartbeat` — keeps us in the live count; returns it.
  Future<int> heartbeat();

  /// `POST .../leave`.
  Future<void> leave();

  /// `GET .../chat` — the recent messages a late joiner should see.
  Future<List<LiveChatMessage>> chatHistory();

  /// `POST .../chat` — `text`, an `imagePath` (multipart), or both.
  Future<void> sendChat(String text, {String? imagePath});
}

abstract class LiveHostBackend {
  /// `POST /astro/livestreams/{id}/start` — goes live and returns the publisher token.
  Future<LiveJoin> start();

  /// `POST /astro/livestreams/{id}/end`.
  Future<void> end();

  Future<List<LiveChatMessage>> chatHistory();
  Future<void> sendChat(String text, {String? imagePath});

  /// `POST .../viewers/remove` — ban + eject someone.
  Future<void> removeViewer(String userId, {String reason});

  /// `POST .../slow-mode`.
  Future<void> setSlowMode(int seconds);

  /// `POST .../chat/pin`.
  Future<void> pinMessage(String messageId, {bool pin, bool hide});
}

/// Realtime transport — the app's Centrifugo client, for chat / viewer counts /
/// gifts. Video does not go through here.
abstract class LiveSignaling {
  Stream<Map<String, dynamic>> frames(String channel);
}

enum LiveMediaPermission { granted, denied, permanentlyDenied }

/// Camera + microphone, asked only of a host.
abstract class LivePermissions {
  Future<LiveMediaPermission> requestCameraAndMicrophone();
  Future<void> openSettings();
}
