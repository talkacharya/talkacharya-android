/// App sounds for the TalkAcharya customer and astrologer apps: the phone's own
/// ringtone for incoming calls/requests, the caller's ringback, the notification
/// sound and short chat/call tones. Native (Android), so silent and vibrate mode
/// are respected. Every call is fire-and-forget and never throws; on platforms
/// without the plugin (tests, iOS for now) they do nothing.
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Short bundled tones.
enum SoundEffect {
  messageIn('message_in'),
  messageOut('message_out'),
  callConnected('call_connected'),
  callEnded('call_ended'),

  /// The call dropped, and the call came back — deliberately unlike the
  /// connect/end pair, so someone on a paid call can tell without looking
  /// whether they have just lost the astrologer or got them back.
  callReconnecting('call_reconnecting'),
  callReconnected('call_reconnected');

  const SoundEffect(this.wireName);
  final String wireName;
}

class AppSounds {
  AppSounds._();

  static const _channel = MethodChannel('talkacharya/sounds');

  /// Master switch (e.g. an in-app "Sounds" preference). Off = no sound at all;
  /// [stop] still works so a loop started earlier can be ended.
  static bool enabled = true;

  /// Incoming call / consultation request: looped ringtone + vibration until [stop].
  static Future<void> startRinging() => _play('startRinging');

  /// Caller side "tring tring" while the other phone rings, until [stop].
  static Future<void> startRingback() => _play('startRingback');

  /// Ends the ringtone / ringback loop and its vibration.
  static Future<void> stop() => _invoke('stop');

  /// The phone's notification sound, once (a short buzz in vibrate mode).
  static Future<void> notify() => _play('notify');

  static Future<void> effect(SoundEffect e) =>
      _play('effect', {'name': e.wireName});

  static Future<void> _play(String method, [Object? args]) =>
      enabled ? _invoke(method, args) : Future.value();

  static Future<void> _invoke(String method, [Object? args]) async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) return;
    try {
      await _channel.invokeMethod<void>(method, args);
    } on MissingPluginException {
      // widget tests / hosts without the plugin registered
    } on PlatformException catch (e) {
      debugPrint('AppSounds.$method failed: $e');
    }
  }
}
