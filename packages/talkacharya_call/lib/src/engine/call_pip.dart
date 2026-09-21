import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Picture-in-picture for a video consultation.
///
/// Android only, and deliberately thin: the host app's `MainActivity` owns the
/// `talkacharya/pip` channel, because entering PiP is an Activity call and the
/// moment to do it — `onUserLeaveHint`, when the user presses home or swipes up
/// — only exists natively.
///
/// [setActive] marks a video call as worth following out of the app; the
/// Activity then enters PiP by itself when the user leaves. [inPip] says
/// whether we are in that small window, so the UI can shrink to just the other
/// person's face — a full app screen scaled to a thumbnail is unreadable.
///
/// Every call is safe on hosts without the channel (iOS, tests, the older build
/// of either app): they no-op and [inPip] stays false.
class CallPip {
  CallPip._();

  static const _channel = MethodChannel('talkacharya/pip');

  /// True while the app is showing as a picture-in-picture window.
  static final ValueNotifier<bool> inPip = ValueNotifier<bool>(false);

  static bool _listening = false;

  static void _listen() {
    if (_listening) return;
    _listening = true;
    try {
      _channel.setMethodCallHandler((call) async {
        if (call.method == 'pipChanged') inPip.value = call.arguments == true;
        return null;
      });
    } on FlutterError {
      // No binding (a plain unit test, a background isolate). PiP is a comfort,
      // never a reason for a call to fall over.
      _listening = false;
    }
  }

  /// Whether a live video call should follow the user out of the app.
  static Future<void> setActive({required bool active}) async {
    if (!active) inPip.value = false;
    await _invoke('setActive', {'active': active});
  }

  /// Enter picture-in-picture now (the minimize button's video counterpart).
  /// Returns false when the platform or the device says no.
  static Future<bool> enter() async => await _invoke('enter') ?? false;

  /// False on devices and Android versions without PiP, so the UI can keep
  /// offering plain minimize instead.
  static Future<bool> isSupported() async =>
      await _invoke('isSupported') ?? false;

  static Future<bool?> _invoke(String method, [Object? args]) async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) return null;
    _listen();
    try {
      return await _channel.invokeMethod<bool>(method, args);
    } on FlutterError {
      return null; // binding not up — see _listen
    } on MissingPluginException {
      return null; // host without the channel — PiP simply isn't available
    } on PlatformException catch (e) {
      debugPrint('CallPip.$method failed: $e');
      return null;
    }
  }

  @visibleForTesting
  static void resetForTest() {
    _listening = false;
    inPip.value = false;
  }
}
