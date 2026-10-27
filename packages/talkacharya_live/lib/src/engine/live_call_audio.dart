import 'package:livekit_client/livekit_client.dart' as lk;

/// The two-person audio room of a private live-stream call.
///
/// The host keeps their video in the stream and moves their microphone here; the
/// caller joins with a token only they were given. Audio only — nothing else.
/// Abstracted so the cubits are testable without a server.
abstract class LiveCallAudio {
  /// Joins [url] with [token] and turns the microphone on.
  Future<void> connect({required String url, required String token});

  Future<void> setMicrophoneEnabled(bool enabled);

  Future<void> disconnect();
}

/// [LiveCallAudio] on the LiveKit SDK.
class LiveKitCallAudio implements LiveCallAudio {
  lk.Room? _room;

  @override
  Future<void> connect({required String url, required String token}) async {
    if (_room != null) return;
    final room = lk.Room();
    _room = room;
    await room.connect(url, token);
    try {
      // a live call is heard out loud, like the stream itself
      await lk.Hardware.instance.setSpeakerphoneOn(true);
    } catch (_) {}
    await room.localParticipant?.setMicrophoneEnabled(true);
  }

  @override
  Future<void> setMicrophoneEnabled(bool enabled) async {
    await _room?.localParticipant?.setMicrophoneEnabled(enabled);
  }

  @override
  Future<void> disconnect() async {
    final room = _room;
    _room = null;
    if (room == null) return;
    try {
      await room.disconnect();
    } catch (_) {}
    await room.dispose();
  }
}
