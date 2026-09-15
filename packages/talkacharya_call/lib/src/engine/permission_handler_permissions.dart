import 'package:permission_handler/permission_handler.dart';

import '../ports/call_ports.dart';

/// Microphone permission on `permission_handler`.
class PermissionHandlerCallPermissions implements CallPermissions {
  const PermissionHandlerCallPermissions();

  @override
  Future<MicPermission> requestMicrophone() async {
    var status = await Permission.microphone.status;
    if (!status.isGranted) status = await Permission.microphone.request();
    if (status.isGranted || status.isLimited) return MicPermission.granted;
    if (status.isPermanentlyDenied || status.isRestricted) {
      return MicPermission.permanentlyDenied;
    }
    return MicPermission.denied;
  }

  @override
  Future<void> openSettings() async {
    await openAppSettings();
  }
}
