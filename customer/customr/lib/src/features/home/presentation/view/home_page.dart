import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../auth/presentation/bloc/auth/auth_bloc.dart';

/// Placeholder shell shown once authenticated. Real customer surfaces
/// (astrologer discovery, wallet, consultations) hang off here.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.select((AuthBloc b) => b.state.user);
    return Scaffold(
      appBar: AppBar(
        title: const Text('TalkAcharya'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () =>
                context.read<AuthBloc>().add(const AuthLogoutRequested()),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.auto_awesome, size: 56),
              Gap.md,
              Text(
                'Namaste, ${user?.shortName ?? ''}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Gap.sm,
              Text(
                'Phone ${user?.phone ?? '-'}  ·  ${user?.preferredCurrency ?? ''}',
              ),
              Gap.lg,
              const Text(
                'You are signed in. Astrologer discovery and consultations '
                'will appear here.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
