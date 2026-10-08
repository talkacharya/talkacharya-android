import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../l10n/l10n.dart';

/// What to do about the Play Store's answer — kept apart from the plugin so the
/// decision can be tested without a Play Store.
enum AppUpdatePrompt {
  /// Nothing to say.
  none,

  /// A newer version is on the Play Store: offer to update.
  available,

  /// An update has been downloaded and only needs the app restarted.
  readyToInstall,
}

AppUpdatePrompt promptFor({
  required UpdateAvailability availability,
  required InstallStatus installStatus,
}) {
  if (installStatus == InstallStatus.downloaded) {
    return AppUpdatePrompt.readyToInstall;
  }
  if (availability == UpdateAvailability.updateAvailable) {
    return AppUpdatePrompt.available;
  }
  return AppUpdatePrompt.none;
}

/// Tells the person, with a snackbar, when the Play Store has a newer version
/// of the app, and updates it in place when they tap Update.
///
/// Asks the Play Store shortly after the app opens and again when it comes back
/// to the foreground, at most once every [_minGap]. The download runs in the
/// background ("flexible" update) so nobody is pulled out of a consultation;
/// when it is done a second snackbar offers the restart that installs it.
///
/// Android only, and only for an install that came from the Play Store — a
/// sideloaded or debug build has nothing to ask, and stays silent.
class AppUpdateWatcher extends StatefulWidget {
  const AppUpdateWatcher({required this.child, super.key});

  final Widget child;

  @override
  State<AppUpdateWatcher> createState() => _AppUpdateWatcherState();
}

class _AppUpdateWatcherState extends State<AppUpdateWatcher>
    with WidgetsBindingObserver {
  static const _minGap = Duration(hours: 6);

  DateTime? _lastCheck;
  StreamSubscription<InstallStatus>? _installs;
  bool _checking = false;

  bool get _supported =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  @override
  void initState() {
    super.initState();
    if (!_supported) return;
    WidgetsBinding.instance.addObserver(this);
    // After the first screens have settled — an update is never urgent enough
    // to compete with the app starting.
    Future<void>.delayed(const Duration(seconds: 4), _check);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _installs?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) unawaited(_check());
  }

  Future<void> _check() async {
    if (!mounted || _checking) return;
    final last = _lastCheck;
    if (last != null && DateTime.now().difference(last) < _minGap) return;
    _checking = true;
    try {
      final info = await InAppUpdate.checkForUpdate();
      _lastCheck = DateTime.now();
      if (!mounted) return;
      switch (promptFor(
        availability: info.updateAvailability,
        installStatus: info.installStatus,
      )) {
        case AppUpdatePrompt.readyToInstall:
          _offerRestart();
        case AppUpdatePrompt.available:
          _offerUpdate(info);
        case AppUpdatePrompt.none:
          break;
      }
    } catch (e) {
      // Not installed from the Play Store, or the store did not answer.
      debugPrint('AppUpdateWatcher: no update check ($e)');
    } finally {
      _checking = false;
    }
  }

  void _show(String message, String action, VoidCallback onAction) {
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return;
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 12),
          action: SnackBarAction(label: action, onPressed: onAction),
        ),
      );
  }

  void _offerUpdate(AppUpdateInfo info) {
    final l = context.l10n;
    _show(l.appUpdateAvailable, l.appUpdateAction, () => _update(info));
  }

  void _offerRestart() {
    final l = context.l10n;
    _show(l.appUpdateReady, l.appUpdateRestart, () async {
      try {
        await InAppUpdate.completeFlexibleUpdate();
      } catch (e) {
        debugPrint('AppUpdateWatcher: install failed ($e)');
      }
    });
  }

  Future<void> _update(AppUpdateInfo info) async {
    try {
      if (info.flexibleUpdateAllowed) {
        _installs ??= InAppUpdate.installUpdateListener.listen((status) {
          if (status == InstallStatus.downloaded && mounted) _offerRestart();
        });
        await InAppUpdate.startFlexibleUpdate();
        return;
      }
      if (info.immediateUpdateAllowed) {
        await InAppUpdate.performImmediateUpdate();
        return;
      }
    } catch (e) {
      debugPrint('AppUpdateWatcher: in-app update failed ($e)');
    }
    await _openStore();
  }

  /// The way out when the Play Store will not update in place.
  Future<void> _openStore() async {
    try {
      final package = (await PackageInfo.fromPlatform()).packageName;
      await launchUrl(
        Uri.parse('https://play.google.com/store/apps/details?id=$package'),
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      debugPrint('AppUpdateWatcher: could not open the store ($e)');
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
