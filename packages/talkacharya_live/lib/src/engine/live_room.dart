import 'dart:async';

/// A renderable video track. Opaque on purpose: the real engine hands back a
/// LiveKit `VideoTrack`, tests hand back anything, and only [LiveVideoView] looks
/// inside.
typedef LiveVideoTrack = Object;

/// Where the connection to the media server stands.
enum LiveConnection { connecting, connected, reconnecting, disconnected }

/// One LiveKit room, seen from the app.
///
/// A host connects with publishing on (their camera and mic go out to everyone); a
/// viewer connects subscribe-only and just receives [remoteVideo]. Abstracted so the
/// cubits are unit-testable without a device or a server.
abstract class LiveRoomEngine {
  /// Joins [url] with [token]. [publish] turns the camera and microphone on — the
  /// server rejects it anyway unless the token allows publishing.
  Future<void> connect({
    required String url,
    required String token,
    bool publish = false,
  });

  /// The host's video as seen by a viewer (null before it arrives / after it goes).
  Stream<LiveVideoTrack?> get remoteVideo;

  /// Our own camera, when publishing.
  Stream<LiveVideoTrack?> get localVideo;

  Stream<LiveConnection> get connectionStates;

  /// True while the host is actually publishing video (viewers only).
  Stream<bool> get remoteVideoEnabled;

  Future<void> setCameraEnabled(bool enabled);
  Future<void> setMicrophoneEnabled(bool enabled);

  /// Front <-> back. Returns true when the front camera is now active.
  Future<bool> switchCamera();

  Future<void> disconnect();
}
