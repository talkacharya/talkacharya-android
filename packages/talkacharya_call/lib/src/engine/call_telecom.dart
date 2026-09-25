import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// What Android's telecom stack tells us about a call it is managing.
sealed class CallTelecomEvent {
  const CallTelecomEvent();
}

/// Telecom wants the call gone — the headset hang-up button, or room being
/// made for an incoming cellular call.
class TelecomDisconnect extends CallTelecomEvent {
  const TelecomDisconnect();
}

/// A cellular call took the line; ours should go quiet but stay up.
class TelecomHold extends CallTelecomEvent {
  const TelecomHold();
}

/// The other call ended; ours can be heard again.
class TelecomUnhold extends CallTelecomEvent {
  const TelecomUnhold();
}

/// Telecom moved the audio somewhere — the loudspeaker, a Bluetooth headset,
/// back to the earpiece. It owns the route, so this is the truth and whatever
/// the speaker button currently shows is only a belief.
class TelecomAudioRoute extends CallTelecomEvent {
  const TelecomAudioRoute({required this.speaker, required this.bluetooth});

  final bool speaker;
  final bool bluetooth;
}

/// Registers a live consultation with Android as a **self-managed call**.
///
/// The point is what the OS does once it knows: a cellular call arriving
/// mid-consultation holds ours through [CallTelecomEvent.hold] instead of two
/// calls fighting over the microphone, Telecom owns audio routing (earpiece,
/// speaker, Bluetooth), and headset buttons arrive as call actions. It also
/// makes this a calling app in the eyes of Android 14, which is what keeps
/// `USE_FULL_SCREEN_INTENT` — and therefore the whole ringing flow — granted.
///
/// Android only, API 26+, and never load-bearing: below that, on iOS, in tests,
/// or when Telecom simply refuses, every call here no-ops and the consultation
/// behaves exactly as it did before. A paid call must never fail because the
/// platform declined to file it.
class CallTelecom {
  CallTelecom._();

  static const _channel = MethodChannel('talkacharya/telecom');

  static final _events = StreamController<CallTelecomEvent>.broadcast();

  /// Actions Telecom has taken on the call it is managing for us.
  static Stream<CallTelecomEvent> get events {
    _listen();
    return _events.stream;
  }

  static bool _listening = false;

  static void _listen() {
    if (_listening || !_android) return;
    _listening = true;
    try {
      _channel.setMethodCallHandler((call) async {
        switch (call.method) {
          case 'disconnect':
            _events.add(const TelecomDisconnect());
          case 'hold':
            _events.add(const TelecomHold());
          case 'unhold':
            _events.add(const TelecomUnhold());
          case 'audio':
            final args = (call.arguments as Map?)?.cast<String, dynamic>();
            _events.add(
              TelecomAudioRoute(
                speaker: args?['speaker'] == true,
                bluetooth: args?['bluetooth'] == true,
              ),
            );
        }
        return null;
      });
    } catch (_) {
      // Deliberately everything: without a binding this throws an
      // *AssertionError*, not an exception, and a plain unit test or a
      // background isolate has no binding. Telecom is a comfort — it may
      // never be the thing that stops a call from starting.
      _listening = false;
    }
  }

  static bool get _android =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  /// Hand a call that is already under way to Telecom. False when the platform
  /// won't take it, which is not an error — the call just runs unmanaged.
  static Future<bool> start({
    required String callId,
    required String peerName,
  }) async {
    if (!_android) return false;
    _listen();
    return await _invoke('start', {
          'callId': callId,
          'peerName': peerName,
        }) ??
        false;
  }

  /// Ask Telecom to move the audio. Returns false when it isn't managing this
  /// call, in which case the caller falls back to setting the route itself.
  ///
  /// Worth going through Telecom where we can: it owns the route now, so
  /// setting the speaker behind its back leaves the two disagreeing — and it
  /// is the only one that knows about a connected Bluetooth headset.
  static Future<bool> setSpeaker({required bool on}) async {
    if (!_android) return false;
    return await _invoke('setSpeaker', {'on': on}) ?? false;
  }

  /// The consultation ended — release the Telecom side too, or the OS goes on
  /// believing this phone is in a call.
  static Future<void> end() async {
    if (!_android) return;
    await _invoke('end');
  }

  static Future<bool?> _invoke(String method, [Object? args]) async {
    try {
      return await _channel.invokeMethod<bool>(method, args);
    } on PlatformException catch (e) {
      debugPrint('CallTelecom.$method failed: $e');
      return null;
    } catch (_) {
      // MissingPluginException on a host without the channel, or the
      // no-binding assertion — see _listen. Never load-bearing.
      return null;
    }
  }

  @visibleForTesting
  static void resetForTest() => _listening = false;
}
