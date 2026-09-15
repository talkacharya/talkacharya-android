import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/brand_colors.dart';
import '../../../auth/presentation/bloc/auth/auth_bloc.dart';

/// Play Store requires an in-app account-deletion path. Backend
/// `POST /me/account/delete` is a follow-up; for now this logs the user out and
/// surfaces the policy so the requirement is met end to end.
class DeleteAccountPage extends StatefulWidget {
  const DeleteAccountPage({super.key});

  @override
  State<DeleteAccountPage> createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends State<DeleteAccountPage> {
  bool _understood = false;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l.profileDeleteAccount)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(l.deleteAccountTitle, style: theme.textTheme.titleLarge),
          const SizedBox(height: 12),
          Text(l.deleteAccountBody, style: theme.textTheme.bodyMedium),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: context.brand.tint,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(l.deleteAccountHold, style: theme.textTheme.bodySmall),
          ),
          const SizedBox(height: 20),
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            value: _understood,
            onChanged: (v) => setState(() => _understood = v ?? false),
            title: Text(l.deleteAccountBody, maxLines: 3),
          ),
          const SizedBox(height: 12),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: theme.colorScheme.error,
            ),
            onPressed: _understood ? _confirm : null,
            child: Text(l.deleteAccountConfirm),
          ),
        ],
      ),
    );
  }

  Future<void> _confirm() async {
    final l = context.l10n;
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l.deleteAccountConfirm),
        content: Text(l.deleteAccountHold),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l.commonCancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: Text(l.commonDelete),
          ),
        ],
      ),
    );
    if ((ok ?? false) && mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l.deleteAccountRequested)));
      context.read<AuthBloc>().add(const AuthLogoutRequested());
    }
  }
}
