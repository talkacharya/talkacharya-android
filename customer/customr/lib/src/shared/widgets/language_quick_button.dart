import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/config/config_repository.dart';
import '../../core/config/remote_config.dart';
import '../../core/di/service_locator.dart';
import '../../core/l10n/l10n.dart';
import '../../features/auth/presentation/bloc/auth/auth_bloc.dart';
import '../../features/profile/data/profile_api.dart';
import 'app_bottom_sheet.dart';
import '../../core/l10n/api_error_l10n.dart';

/// App-bar shortcut to switch app language without diving into Profile.
class LanguageQuickButton extends StatelessWidget {
  const LanguageQuickButton({super.key});

  @override
  Widget build(BuildContext context) {
    final languages = getIt<ConfigRepository>().value.languages;
    if (languages.length < 2) return const SizedBox.shrink();

    return IconButton(
      tooltip: context.l10n.homeLanguageTooltip,
      icon: const Icon(Icons.translate_rounded, size: 22),
      onPressed: () => _pick(context, languages),
    );
  }

  Future<void> _pick(
    BuildContext context,
    List<ConfigLanguage> languages,
  ) async {
    final authBloc = context.read<AuthBloc>();
    final messenger = ScaffoldMessenger.of(context);
    final current = authBloc.state.user?.preferredLanguage ?? 'en';

    final picked = await showAppSheet<String>(
      context: context,
      title: context.l10n.homeChooseLanguageTitle,
      builder: (context) => ListView(
        shrinkWrap: true,
        children: [
          for (final l in languages)
            ListTile(
              title: Text(l.name),
              trailing: l.code == current
                  ? Icon(
                      Icons.check_rounded,
                      color: Theme.of(context).colorScheme.primary,
                    )
                  : null,
              selected: l.code == current,
              onTap: () => Navigator.pop(context, l.code),
            ),
        ],
      ),
    );

    if (picked == null || picked == current) return;
    try {
      final user = await getIt<ProfileApi>().updatePreferences(
        language: picked,
      );
      authBloc.add(AuthLoggedIn(user));
    } catch (e) {
      if (!context.mounted) return;
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            context.l10n.homeLanguageSwitchError(localizedError(context, e)),
          ),
        ),
      );
    }
  }
}
