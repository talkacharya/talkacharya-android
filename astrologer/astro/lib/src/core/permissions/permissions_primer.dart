import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:talkacharya_call/talkacharya_call.dart';
import 'package:talkacharya_ui/talkacharya_ui.dart';

import '../di/service_locator.dart';
import '../l10n/l10n.dart';

/// Shown once: bump the suffix to show it to everyone again.
const _seenKey = 'ta_permissions_primer_v1';

const _wanted = [
  AppPermission.notifications,
  AppPermission.microphone,
  AppPermission.camera,
];

/// The first time someone is inside the app, ask for everything it needs on
/// one screen (Android cannot ask at install). Does nothing when it has been
/// shown before, or when everything is already allowed.
Future<void> maybeShowPermissionsPrimer(BuildContext context) async {
  try {
    final storage = getIt<FlutterSecureStorage>();
    if (await storage.read(key: _seenKey) == 'true') return;
    final now = await StartupPermissions.status(_wanted);
    await storage.write(key: _seenKey, value: 'true');
    if (now.values.every((ok) => ok) || !context.mounted) return;
  } catch (_) {
    return; // storage or the platform said no: never block the app on this
  }
  await showPermissionsPrimer(context);
}

/// The permissions screen itself, for a "check permissions" entry point too.
Future<void> showPermissionsPrimer(BuildContext context) {
  final l = context.l10n;
  Future<List<bool>> ordered(Future<Map<AppPermission, bool>> from) async {
    final map = await from;
    return [for (final p in _wanted) map[p] ?? false];
  }

  return Navigator.of(context, rootNavigator: true).push(
    MaterialPageRoute<void>(
      fullscreenDialog: true,
      builder: (_) => PermissionsPrimerPage(
        strings: PrimerStrings(
          title: l.primerTitle,
          body: l.primerBody,
          allow: l.primerAllow,
          later: l.primerLater,
          done: l.primerDone,
          openSettings: l.primerOpenSettings,
          allowed: l.primerAllowed,
          blockedNote: l.primerBlockedNote,
        ),
        items: [
          PrimerItem(
            icon: Icons.notifications_active_rounded,
            hue: AstroPalette.fire,
            title: l.primerNotifications,
            why: l.primerNotificationsWhy,
          ),
          PrimerItem(
            icon: Icons.mic_rounded,
            hue: AstroPalette.health,
            title: l.primerMicrophone,
            why: l.primerMicrophoneWhy,
          ),
          PrimerItem(
            icon: Icons.videocam_rounded,
            hue: AstroPalette.love,
            title: l.primerCamera,
            why: l.primerCameraWhy,
          ),
        ],
        load: () => ordered(StartupPermissions.status(_wanted)),
        request: () => ordered(StartupPermissions.requestAll(_wanted)),
        openSettings: StartupPermissions.openSettings,
      ),
    ),
  );
}
