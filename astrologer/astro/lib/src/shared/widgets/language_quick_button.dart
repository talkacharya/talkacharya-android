import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talkacharya_ui/talkacharya_ui.dart';

import '../../core/di/service_locator.dart';
import '../../core/l10n/l10n.dart';
import '../../features/auth/presentation/bloc/auth/auth_bloc.dart';
import '../../features/profile/data/profile_api.dart';
import 'settings_widgets.dart';

/// App-bar shortcut to switch the app's language without going into Profile.
class LanguageQuickButton extends StatelessWidget {
  const LanguageQuickButton({this.color, super.key});

  /// Icon colour, for a bar that is not the default surface.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    if (kLanguageNativeNames.length < 2) return const SizedBox.shrink();

    return IconButton(
      tooltip: context.l10n.profileLanguage,
      icon: Icon(Icons.translate_rounded, size: 22, color: color),
      onPressed: () => _pick(context),
    );
  }

  Future<void> _pick(BuildContext context) async {
    final l = context.l10n;
    final bloc = context.read<AuthBloc>();
    final current = bloc.state.user?.preferredLanguage ?? 'en';

    final picked = await showAppSheet<String>(
      context: context,
      title: l.profileLanguage,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final MapEntry(key: code, value: name)
              in kLanguageNativeNames.entries)
            _LanguageTile(
              name: name,
              selected: code == current,
              onTap: () => Navigator.pop(context, code),
            ),
          const SizedBox(height: 4),
        ],
      ),
    );

    if (picked == null || picked == current) return;
    try {
      final user = await getIt<ProfileApi>().updateAccount(language: picked);
      bloc.add(AuthUserUpdated(user));
    } catch (_) {
      if (context.mounted) showToast(context, l.commonSaveFailed);
    }
  }
}

/// One language, written in its own script; the current one is marked.
class _LanguageTile extends StatelessWidget {
  const _LanguageTile({
    required this.name,
    required this.selected,
    required this.onTap,
  });

  final String name;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brand = context.brand;
    final primary = theme.colorScheme.primary;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Pressable(
        child: Material(
          color: selected
              ? primary.withValues(alpha: 0.08)
              : theme.colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: selected ? primary : brand.hairline,
              width: selected ? 1.6 : 1,
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              child: Row(
                children: [
                  HueIcon(
                    hue: AstroPalette.air,
                    size: 38,
                    child: Text(
                      name.characters.first,
                      style: TextStyle(
                        color: AstroPalette.air.end,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Icon(
                    selected
                        ? Icons.check_circle_rounded
                        : Icons.radio_button_unchecked_rounded,
                    color: selected ? primary : brand.hairline,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
