import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

/// What the apps need a person to allow before a consultation can reach them.
enum AppPermission { notifications, microphone, camera }

/// The permissions asked for together, once, the first time someone is in
/// the app — instead of one by one at the moment each is needed, which for an
/// astrologer is the moment a paying customer is already waiting on the line.
///
/// Android has no way to ask at install; this is the nearest thing to it.
class StartupPermissions {
  StartupPermissions._();

  static Permission _of(AppPermission p) => switch (p) {
    AppPermission.notifications => Permission.notification,
    AppPermission.microphone => Permission.microphone,
    AppPermission.camera => Permission.camera,
  };

  static bool _ok(PermissionStatus s) => s.isGranted || s.isLimited;

  /// Which of [wanted] are allowed right now. Never prompts.
  static Future<Map<AppPermission, bool>> status([
    List<AppPermission> wanted = AppPermission.values,
  ]) async {
    final out = <AppPermission, bool>{};
    for (final p in wanted) {
      try {
        out[p] = _ok(await _of(p).status);
      } catch (e) {
        // A platform that has no such permission has nothing to refuse.
        debugPrint('StartupPermissions.status($p) failed: $e');
        out[p] = true;
      }
    }
    return out;
  }

  /// Asks for each of [wanted] that is not yet allowed, one system dialog
  /// after another, and reports where each ended up.
  static Future<Map<AppPermission, bool>> requestAll([
    List<AppPermission> wanted = AppPermission.values,
  ]) async {
    for (final p in wanted) {
      try {
        final permission = _of(p);
        if (!_ok(await permission.status)) await permission.request();
      } catch (e) {
        debugPrint('StartupPermissions.request($p) failed: $e');
      }
    }
    return status(wanted);
  }

  /// The app's page in system settings — the only way back from "don't ask
  /// again".
  static Future<void> openSettings() async {
    await openAppSettings();
  }
}
