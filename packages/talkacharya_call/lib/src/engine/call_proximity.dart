import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Screen-off-at-the-ear for a voice call, the way every dialer behaves.
///
/// Android only, and thin for the same reason as [CallPip]: the proximity
/// wake lock belongs to the host app's `MainActivity`, which owns the
/// `talkacharya/proximity` channel. Without it a voice call keeps a bright
/// screen against the caller's cheek — muting themselves, hanging up, and
/// burning battery for the length of the consultation.
///
/// Safe on hosts without the channel (iOS, tests, an older build of either
/// app): every call no-ops.
class CallProximity {
  CallProximity._();

  static const _channel = MethodChannel('talkacharya/proximity');

  /// Hold the screen off while the phone is at the ear ([active] true), or let
  /// it behave normally again. Always turned off when a call ends — a wake
  /// lock outliving its call would leave the phone seemingly dead.
  static Future<void> setActive({required bool active}) async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) return;
    try {
      await _channel.invokeMethod<void>('setActive', {'active': active});
    } on MissingPluginException {
      // host without the channel — the screen simply stays on
    } on FlutterError {
      // no binding (plain unit test / background isolate)
    } on PlatformException catch (e) {
      debugPrint('CallProximity.setActive failed: $e');
    }
  }
}
