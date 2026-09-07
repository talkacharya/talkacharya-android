import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../auth/presentation/bloc/auth/auth_bloc.dart';

/// Placeholder shell shown once authenticated. Real astrologer surfaces
/// (availability toggle, incoming consultation requests, earnings, payouts)
/// hang off here.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.select((AuthBloc b) => b.state.user);
    final isAstrologer = user?.isAstrologer ?? false;

    return Scaffold(
      appBar: AppBar(
        title: const Text('TalkAcharya Astrologer'),
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
              Icon(
                isAstrologer
                    ? Icons.dashboard_customize
                    : Icons.hourglass_empty,
                size: 56,
              ),
              Gap.md,
              Text(
                'Namaste, ${user?.shortName ?? ''}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Gap.sm,
              Text('Phone ${user?.phone ?? '-'}'),
              Gap.lg,
              Text(
                isAstrologer
                    ? 'Your profile is approved. Availability, consultation '
                          'requests, earnings and payouts will appear here.'
                    : 'This number is not registered as an astrologer yet. '
                          'Complete onboarding from the web console, or ask ops '
                          'to approve your application.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
