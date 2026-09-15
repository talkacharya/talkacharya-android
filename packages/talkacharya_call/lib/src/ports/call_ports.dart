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

enum MicPermission { granted, denied, permanentlyDenied }

/// Microphone permission — overridable for tests.
abstract class CallPermissions {
  Future<MicPermission> requestMicrophone();
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
