import 'package:flutter/material.dart';

import '../../../../core/config/config_repository.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/utils/haptic_service.dart';
import '../../../kundali/data/kundali_api.dart';

class NotificationPrefsPage extends StatelessWidget {
  const NotificationPrefsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final configRepo = Listenable.merge([getIt<ConfigRepository>()]);

    return Scaffold(
      appBar: AppBar(title: Text(l.profileNotificationPrefs)),
      body: ListenableBuilder(
        listenable: configRepo,
        builder: (context, _) {
          final repo = getIt<ConfigRepository>();
          return ListView(
            padding: const EdgeInsets.symmetric(vertical: 8),
            children: [
              SwitchListTile(
                secondary: const Icon(Icons.vibration_rounded),
                title: Text(l.profileHapticFeedback),
                subtitle: Text(l.profileHapticFeedbackDesc),
                value: repo.hapticEnabled,
                onChanged: (v) {
                  repo.setHapticEnabled(v);
                  if (v) HapticService.medium();
                },
              ),
              _AstroPushTile(
                icon: Icons.mood_rounded,
                title: l.prefsMoodAlerts,
                subtitle: l.prefsMoodAlertsDesc,
                load: getIt<KundaliApi>().moodAlertsEnabled,
                save: getIt<KundaliApi>().setMoodAlertsEnabled,
              ),
              _AstroPushTile(
                icon: Icons.public_rounded,
                title: l.prefsTransitAlerts,
                subtitle: l.prefsTransitAlertsDesc,
                load: getIt<KundaliApi>().transitAlertsEnabled,
                save: getIt<KundaliApi>().setTransitAlertsEnabled,
              ),
            ],
          );
        },
      ),
    );
  }
}

/// An astrology push toggle backed by a `GET/PUT {enabled}` endpoint (default on):
/// transit alerts (`/app/astrology/transit-alerts`) and daily mood
/// (`/app/astrology/mood-alerts`).
class _AstroPushTile extends StatefulWidget {
  const _AstroPushTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.load,
    required this.save,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Future<bool> Function() load;
  final Future<bool> Function(bool) save;

  @override
  State<_AstroPushTile> createState() => _AstroPushTileState();
}

class _AstroPushTileState extends State<_AstroPushTile> {
  bool _enabled = true;
  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final v = await widget.load();
      if (mounted) {
        setState(() {
          _enabled = v;
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _set(bool v) async {
    setState(() {
      _enabled = v;
      _saving = true;
    });
    try {
      final result = await widget.save(v);
      if (mounted) setState(() => _enabled = result);
    } catch (_) {
      if (mounted) setState(() => _enabled = !v); // revert
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      secondary: Icon(widget.icon),
      title: Text(widget.title),
      subtitle: Text(widget.subtitle),
      value: _enabled,
      onChanged: (_loading || _saving) ? null : _set,
    );
  }
}
