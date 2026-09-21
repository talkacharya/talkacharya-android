import 'package:permission_handler/permission_handler.dart';

import '../ports/call_ports.dart';

/// Microphone + camera permission on `permission_handler`.
class PermissionHandlerCallPermissions implements CallPermissions {
  const PermissionHandlerCallPermissions();

  @override
  Future<MediaPermission> requestMicrophone() => _ask(Permission.microphone);

  @override
  Future<MediaPermission> requestCamera() => _ask(Permission.camera);

  Future<MediaPermission> _ask(Permission permission) async {
    var status = await permission.status;
    if (!status.isGranted) status = await permission.request();
    if (status.isGranted || status.isLimited) return MediaPermission.granted;
    if (status.isPermanentlyDenied || status.isRestricted) {
      return MediaPermission.permanentlyDenied;
    }
    return MediaPermission.denied;
  }

  @override
  Future<void> openSettings() async {
    await openAppSettings();
  }
}
