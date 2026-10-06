import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/di/service_locator.dart';
import '../../core/l10n/l10n.dart';
import '../../features/auth/presentation/bloc/auth/auth_bloc.dart';
import '../../features/profile/data/profile_api.dart';
import 'settings_widgets.dart';

/// App-bar shortcut to switch app language without diving into Profile.
class LanguageQuickButton extends StatelessWidget {
  const LanguageQuickButton({super.key});

  @override
  Widget build(BuildContext context) {
    if (kLanguageNativeNames.length < 2) return const SizedBox.shrink();

    return IconButton(
      tooltip: context.l10n.profileLanguage,
      icon: const Icon(Icons.translate_rounded, size: 22),
      onPressed: () => _pick(context),
    );
  }

  Future<void> _pick(BuildContext context) async {
    final l = context.l10n;
    final current = context.read<AuthBloc>().state.user?.preferredLanguage;

    final picked = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: RadioGroup<String>(
          groupValue: current,
          onChanged: (v) => Navigator.pop(context, v),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    l.profileLanguage,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ),
              for (final MapEntry(key: code, value: name)
                  in kLanguageNativeNames.entries)
                RadioListTile<String>(value: code, title: Text(name)),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );

    if (picked == null || picked == current) return;
    if (!context.mounted) return;

    final bloc = context.read<AuthBloc>();
    try {
      final user = await getIt<ProfileApi>().updateAccount(language: picked);
      bloc.add(AuthUserUpdated(user));
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.commonSaveFailed)),
        );
      }
    }
  }
}
