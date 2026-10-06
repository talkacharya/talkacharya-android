import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Where call audio can go. Telecom reports which of these exist right now; the
/// call screen offers a choice only when there is more than a speaker toggle's
/// worth of them.
enum CallAudioOutput {
  /// The phone's earpiece — or a wired headset, which Android treats as
  /// replacing it.
  earpiece,
  speaker,
  wired,
  bluetooth;

  static CallAudioOutput parse(Object? raw) => switch (raw) {
    'speaker' => speaker,
    'wired' => wired,
    'bluetooth' => bluetooth,
    _ => earpiece,
  };
}

/// What Android's telecom stack tells us about a call it is managing.
sealed class CallTelecomEvent {
  const CallTelecomEvent();
}

/// Telecom wants the live call gone — the headset hang-up button, or room being
/// made for an incoming cellular call.
class TelecomDisconnect extends CallTelecomEvent {
  const TelecomDisconnect({this.callId = ''});

  /// Empty on events from before calls carried their id.
  final String callId;
}

/// A cellular call took the line; ours should go quiet but stay up.
class TelecomHold extends CallTelecomEvent {
  const TelecomHold();
}

/// The other call ended; ours can be heard again.
class TelecomUnhold extends CallTelecomEvent {
  const TelecomUnhold();
}

/// A ringing consultation was answered by the system — a headset button, a
/// watch, a car — rather than the app's own Answer button.
class TelecomAnswer extends CallTelecomEvent {
  const TelecomAnswer(this.callId);
  final String callId;
}

/// A ringing consultation was declined by the system.
class TelecomReject extends CallTelecomEvent {
  const TelecomReject(this.callId);
  final String callId;
}

/// A ringing consultation went unanswered until it timed out.
class TelecomMissed extends CallTelecomEvent {
  const TelecomMissed(this.callId);
  final String callId;
}

/// Telecom moved the audio somewhere, or the set of places it could go changed
/// (a headset connected). It owns the route, so this is the truth and whatever
/// the speaker button currently shows is only a belief.
class TelecomAudioRoute extends CallTelecomEvent {
  const TelecomAudioRoute({
    required this.speaker,
    required this.bluetooth,
    this.route,
    this.routes = const {},
  });

  final bool speaker;
  final bool bluetooth;

  /// Where the audio is now. Null from a platform that only reports the flags.
  final CallAudioOutput? route;

  /// Where it could go.
  final Set<CallAudioOutput> routes;
}

/// Registers consultation calls with Android as **self-managed calls**.
///
/// The point is what the OS does once it knows:
/// * a ringing voice/video consultation ([reportIncoming]) is a call as far as
///   Android is concerned — a headset or watch can answer it, and a cellular
///   call already in progress gets the system's own "answer and end the other"
///   choice;
/// * a cellular call arriving mid-consultation holds ours ([TelecomHold]);
/// * Telecom owns audio routing and says which routes exist ([TelecomAudioRoute]),
///   which is what lets the call screen offer earpiece / speaker / headset;
/// * it makes this a calling app in the eyes of Android 14, which keeps
///   `USE_FULL_SCREEN_INTENT` — and therefore the ringing flow — granted.
///
/// The native side is a plugin in this package, so it is attached to every
/// engine, including the FCM background isolate that rings a killed app.
///
/// Android only, API 26+, and never load-bearing: below that, on iOS, in tests,
/// or when Telecom simply refuses, every call here no-ops and the consultation
/// behaves exactly as it did before. A paid call must never fail because the
/// platform declined to file it.
class CallTelecom {
  CallTelecom._();

  static const _channel = MethodChannel('talkacharya/telecom');

  static final _events = StreamController<CallTelecomEvent>.broadcast();

  /// Actions Telecom has taken on the calls it is managing for us.
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
        final args =
            (call.arguments as Map?)?.cast<String, dynamic>() ?? const {};
        final id = '${args['callId'] ?? ''}';
        switch (call.method) {
          case 'disconnect':
            _events.add(TelecomDisconnect(callId: id));
          case 'hold':
            _events.add(const TelecomHold());
          case 'unhold':
            _events.add(const TelecomUnhold());
          case 'answer':
            _events.add(TelecomAnswer(id));
          case 'reject':
            _events.add(TelecomReject(id));
          case 'missed':
            _events.add(TelecomMissed(id));
          case 'audio':
            _events.add(
              TelecomAudioRoute(
                speaker: args['speaker'] == true,
                bluetooth: args['bluetooth'] == true,
                route: args.containsKey('route')
                    ? CallAudioOutput.parse(args['route'])
                    : null,
                routes: {
                  for (final r in (args['routes'] as List?) ?? const [])
                    CallAudioOutput.parse(r),
                },
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

  /// Tell Android a voice/video consultation is ringing on this phone.
  ///
  /// The app still shows its own full-screen notification — that is the UI.
  /// This is what makes the OS treat it as a call. Unanswered, Telecom ends it
  /// by itself after [expiresIn], so a request that times out never leaves a
  /// phantom call behind. False when the platform won't take it.
  static Future<bool> reportIncoming({
    required String callId,
    required String peerName,
    required bool video,
    required Duration expiresIn,
  }) async {
    if (!_android || callId.isEmpty) return false;
    return await _invoke('reportIncoming', {
          'callId': callId,
          'peerName': peerName,
          'video': video,
          'expiresMs': expiresIn.inMilliseconds,
        }) ??
        false;
  }

  /// The app answered a ringing consultation with its own button. The ring
  /// becomes the live call, which [start] later adopts instead of placing a
  /// second one.
  static Future<bool> answerIncoming(String callId) async {
    if (!_android || callId.isEmpty) return false;
    return await _invoke('answerIncoming', {'callId': callId}) ?? false;
  }

  /// Declined in the app, or the request was withdrawn. A no-op unless that
  /// call is still ringing.
  static Future<void> declineIncoming(String callId) async {
    if (!_android || callId.isEmpty) return;
    await _invoke('declineIncoming', {'callId': callId});
  }

  /// A call answered through Telecom (headset, watch) while no app screen was
  /// listening — collect it once at start-up so the answer is not lost.
  static Future<String?> takePendingAnswer() async {
    if (!_android) return null;
    try {
      final id = await _channel.invokeMethod<String>('takePendingAnswer');
      return (id == null || id.isEmpty) ? null : id;
    } catch (_) {
      return null;
    }
  }

  /// Hand a call that is under way to Telecom — adopting the ringing one if
  /// it was reported as incoming. False when the platform won't take it, which
  /// is not an error: the call just runs unmanaged.
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
  static Future<bool> setSpeaker({required bool on}) async {
    if (!_android) return false;
    return await _invoke('setSpeaker', {'on': on}) ?? false;
  }

  /// Move the audio to [output]. False when Telecom isn't managing the call.
  ///
  /// Worth going through Telecom where we can: it owns the route, and it is
  /// the only one that knows about a connected Bluetooth headset.
  static Future<bool> setAudioRoute(CallAudioOutput output) async {
    if (!_android) return false;
    return await _invoke('setAudioRoute', {'route': output.name}) ?? false;
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
