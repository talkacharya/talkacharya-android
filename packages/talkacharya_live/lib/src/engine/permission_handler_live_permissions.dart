import 'package:permission_handler/permission_handler.dart';

import '../ports/live_ports.dart';

/// Camera + microphone on `permission_handler`. A host needs both; the stream is
/// not worth starting with only one of them.
class PermissionHandlerLivePermissions implements LivePermissions {
  const PermissionHandlerLivePermissions();

  @override
  Future<LiveMediaPermission> requestCameraAndMicrophone() async {
    final camera = await _ask(Permission.camera);
    if (camera != LiveMediaPermission.granted) return camera;
    return _ask(Permission.microphone);
  }

  Future<LiveMediaPermission> _ask(Permission permission) async {
    var status = await permission.status;
    if (!status.isGranted) status = await permission.request();
    if (status.isGranted || status.isLimited) {
      return LiveMediaPermission.granted;
    }
    if (status.isPermanentlyDenied || status.isRestricted) {
      return LiveMediaPermission.permanentlyDenied;
    }
    return LiveMediaPermission.denied;
  }

  @override
  Future<void> openSettings() async {
    await openAppSettings();
  }
}
