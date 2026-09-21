import 'package:flutter/material.dart';
import 'package:talkacharya_sounds/talkacharya_sounds.dart';

import '../../../../core/config/config_repository.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/astro_palette.dart';
import '../../../../core/utils/haptic_service.dart';
import '../../../../shared/widgets/settings_widgets.dart';

/// Whether the app may make a sound or vibrate at all.
///
/// Both switches sit above the phone's own silent/vibrate mode, which always
/// wins. An astrologer who wants the ringtone but not the buzz — or the reverse
/// — sets it here rather than silencing the whole app in system settings and
/// missing consultations.
class SoundSettingsPage extends StatelessWidget {
  const SoundSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final repo = getIt<ConfigRepository>();

    return ListenableBuilder(
      listenable: repo,
      builder: (context, _) => SubPageScaffold(
        title: l.profileSoundVibration,
        subtitle: l.profileSoundVibrationSub,
        children: [
          SettingsCard(
            icon: Icons.volume_up_rounded,
            hue: AstroPalette.love,
            child: Column(
              children: [
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l.profileSounds),
                  subtitle: Text(l.profileSoundsDesc),
                  value: repo.soundEnabled,
                  onChanged: (v) {
                    repo.setSoundEnabled(v);
                    // Let them hear what they just turned back on.
                    if (v) AppSounds.effect(SoundEffect.messageIn);
                  },
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l.profileHapticFeedback),
                  subtitle: Text(l.profileHapticFeedbackDesc),
                  value: repo.hapticEnabled,
                  onChanged: (v) {
                    repo.setHapticEnabled(v);
                    if (v) HapticService.medium();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
