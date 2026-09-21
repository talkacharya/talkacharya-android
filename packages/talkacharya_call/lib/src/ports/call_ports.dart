import 'package:flutter/services.dart';

import '../models/call_join.dart';
import '../models/call_state.dart';

/// REST side of a call — implemented per app over its Dio client.
abstract class CallBackend {
  /// `POST /consultations/{id}/call/join`.
  Future<CallJoin> join();

  /// `POST /consultations/{id}/call/state` — on change and as the heartbeat.
  Future<void> reportState(CallNetState state, {bool? relayed});

  /// End the consultation (`POST /app|astro/consultations/{id}/end`).
  Future<void> endConsultation();
}

/// Signaling transport — the app's Centrifugo client.
abstract class CallSignaling {
  /// Decoded publications on [channel] (keeps the subscription alive while listened).
  Stream<Map<String, dynamic>> frames(String channel);

  /// Publish [data] to [channel] (the `call` namespace allows subscriber publish).
  Future<void> publish(String channel, Map<String, dynamic> data);
}

enum MediaPermission { granted, denied, permanentlyDenied }

/// The old name, from when calls were voice-only.
typedef MicPermission = MediaPermission;

/// Microphone + camera permission — overridable for tests.
abstract class CallPermissions {
  Future<MediaPermission> requestMicrophone();

  /// Asked only for a video call, and only after the microphone was granted.
  Future<MediaPermission> requestCamera();
  Future<void> openSettings();
}

/// Keeps the process + microphone alive while the app is backgrounded during a
/// call (an Android foreground service). Apps without one use [NoopCallKeepAlive].
abstract class CallKeepAlive {
  Future<void> start({required String title, required String text});
  Future<void> stop();
}

class NoopCallKeepAlive implements CallKeepAlive {
  const NoopCallKeepAlive();
  @override
  Future<void> start({required String title, required String text}) async {}
  @override
  Future<void> stop() async {}
}

/// Call sounds. The app plugs in its sound player; the default is silent.
abstract class CallSounds {
  /// Start / stop the caller's ringback loop.
  void startRingback();
  void stopRingback();

  /// Audio started flowing for the first time.
  void connected();

  /// The call (or the attempt to place it) ended.
  void ended();
}

/// The tick a call control gives back when it is pressed.
///
/// A port, not a direct `HapticFeedback` call, because each app has its own
/// "vibrate" preference and a control inside a shared widget must respect it
/// like every other button in the app.
abstract class CallHaptics {
  void tap();
}

/// The platform's own selection tick — the sensible default for a host that has
/// no preference to consult.
class SystemCallHaptics implements CallHaptics {
  const SystemCallHaptics();
  @override
  void tap() => HapticFeedback.selectionClick();
}

class NoopCallHaptics implements CallHaptics {
  const NoopCallHaptics();
  @override
  void tap() {}
}

/// What the call controls buzz with. A host with a "vibrate" preference sets
/// this once at startup — app-wide state, like the preference itself, rather
/// than a parameter threaded through every button.
CallHaptics callHaptics = const SystemCallHaptics();

class NoopCallSounds implements CallSounds {
  const NoopCallSounds();
  @override
  void startRingback() {}
  @override
  void stopRingback() {}
  @override
  void connected() {}
  @override
  void ended() {}
}
