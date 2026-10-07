import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// One thing a phone needs before a consultation can ring it with the screen
/// off. See [CallReadiness].
enum CallReadinessItem {
  /// Notifications allowed for the app at all.
  notifications,

  /// The ringing channel not silenced or turned down.
  callChannel,

  /// Allowed to show over the lock screen (Android 14 asks for this apart).
  fullScreen,

  /// Exempt from battery optimisation, so a push can wake the app.
  battery,

  /// The phone maker's own "autostart" switch (Xiaomi, Oppo, Vivo, …).
  autostart,

  /// Xiaomi's separate "Show on lock screen" permission.
  lockScreen,
}

/// What [CallReadiness.check] found on this phone.
@immutable
class CallReadinessReport {
  const CallReadinessReport({
    required this.notifications,
    required this.callChannel,
    required this.fullScreen,
    required this.battery,
    required this.manufacturer,
  });

  factory CallReadinessReport.fromMap(Map<String, dynamic> m) =>
      CallReadinessReport(
        notifications: m['notifications'] != false,
        callChannel: m['callChannel'] != false,
        fullScreen: m['fullScreen'] != false,
        battery: m['battery'] != false,
        manufacturer: '${m['manufacturer'] ?? ''}'.toLowerCase(),
      );

  final bool notifications;
  final bool callChannel;
  final bool fullScreen;
  final bool battery;

  /// `Build.MANUFACTURER`, lower-case — `xiaomi`, `oppo`, `samsung`, ….
  final String manufacturer;

  static const _autostartMakers = {
    'xiaomi', 'redmi', 'poco', 'oppo', 'realme', 'oneplus', 'vivo', 'iqoo',
    'huawei', 'honor', 'asus', 'samsung', 'tecno', 'infinix', 'itel', 'lenovo',
    'motorola', 'meizu', 'letv', //
  };

  static const _lockScreenMakers = {'xiaomi', 'redmi', 'poco'};

  /// Whether this maker adds its own background or lock-screen switches, which
  /// no app can read — so they are listed to check by hand.
  bool get hasAutostart => _autostartMakers.contains(manufacturer);
  bool get hasLockScreenSwitch => _lockScreenMakers.contains(manufacturer);

  /// The switches the app can read, and whether each is on.
  Map<CallReadinessItem, bool> get readable => {
    CallReadinessItem.notifications: notifications,
    CallReadinessItem.callChannel: callChannel,
    CallReadinessItem.fullScreen: fullScreen,
    CallReadinessItem.battery: battery,
  };

  /// Everything the app can see is in order. Maker switches are not counted —
  /// they cannot be read, only opened.
  bool get ready => readable.values.every((on) => on);
}

/// Whether consultation calls will ring this phone with the screen off, and the
/// settings screens that fix it when they will not. Android only; elsewhere
/// [check] returns null and [open] does nothing.
class CallReadiness {
  CallReadiness._();

  static const _channel = MethodChannel('talkacharya/telecom');

  static bool get _android =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  /// [callChannelId] is the notification channel incoming consultations ring on.
  static Future<CallReadinessReport?> check({
    required String callChannelId,
  }) async {
    if (!_android) return null;
    try {
      final raw = await _channel.invokeMethod<Map<Object?, Object?>>(
        'readiness',
        {'callChannelId': callChannelId},
      );
      if (raw == null) return null;
      return CallReadinessReport.fromMap(raw.cast<String, dynamic>());
    } catch (e) {
      debugPrint('CallReadiness.check failed: $e');
      return null;
    }
  }

  /// Opens the settings screen for [item]. False when no screen could be opened.
  static Future<bool> open(
    CallReadinessItem item, {
    required String callChannelId,
  }) async {
    if (!_android) return false;
    try {
      return await _channel.invokeMethod<bool>('openReadinessSetting', {
            'which': item.name,
            'callChannelId': callChannelId,
          }) ??
          false;
    } catch (e) {
      debugPrint('CallReadiness.open failed: $e');
      return false;
    }
  }
}
