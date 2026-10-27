import '../models/live_call.dart';
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

  /// `GET .../calls` — prices, the call on air, this viewer's place and, on
  /// their turn, how to come on air.
  Future<LiveViewerCalls> calls();

  /// `POST .../calls` — join the line for a [mode] call.
  Future<LiveViewerCalls> requestCall(LiveCallMode mode);

  /// `POST .../calls/{id}/connected` — the microphone is live; billing starts.
  Future<void> callConnected(String requestId);

  /// `POST .../calls/{id}/end` — leave the line, or hang up.
  Future<void> endCall(String requestId);
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

  /// `GET .../calls` — the stream's call line and a private call's room.
  Future<LiveHostCalls> calls();

  /// `POST .../calls/{id}/end` — end the call on air, or take someone off the line.
  Future<void> endCall(String requestId);

  /// `POST .../calls/{id}/mute` — take a public caller's microphone away / back.
  Future<void> muteCall(String requestId, {required bool muted});
}

/// Realtime transport — the app's Centrifugo client, for chat / viewer counts /
/// gifts. Video does not go through here.
abstract class LiveSignaling {
  Stream<Map<String, dynamic>> frames(String channel);
}

enum LiveMediaPermission { granted, denied, permanentlyDenied }

/// Camera + microphone for a host; the microphone alone for a viewer who calls in.
abstract class LivePermissions {
  Future<LiveMediaPermission> requestCameraAndMicrophone();
  Future<LiveMediaPermission> requestMicrophone();
  Future<void> openSettings();
}
