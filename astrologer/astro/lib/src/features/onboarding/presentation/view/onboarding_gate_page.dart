import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/astro/onboarding_store.dart';
import '../../../../core/di/service_locator.dart';
import '../../../auth/presentation/bloc/auth/auth_bloc.dart';

/// The screen a not-yet-approved astrologer sees. Renders per [OnboardingStage].
class OnboardingGatePage extends StatefulWidget {
  const OnboardingGatePage({super.key});

  @override
  State<OnboardingGatePage> createState() => _OnboardingGatePageState();
}

class _OnboardingGatePageState extends State<OnboardingGatePage> {
  @override
  void initState() {
    super.initState();
    // keep the status fresh while this screen is up (e.g. ops approves)
    getIt<OnboardingStore>().refresh();
  }

  @override
  Widget build(BuildContext context) {
    final store = getIt<OnboardingStore>();
    return AnimatedBuilder(
      animation: store,
      builder: (context, _) {
        final stage = store.stage;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Become an astrologer'),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout_rounded),
                onPressed: () =>
                    context.read<AuthBloc>().add(const AuthLogoutRequested()),
              ),
            ],
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: switch (stage) {
                OnboardingStage.wizard => _Wizard(store: store),
                OnboardingStage.underReview => const _Simple(
                    icon: Icons.hourglass_top_rounded,
                    title: 'Application under review',
                    body:
                        'Our team is verifying your profile and documents. '
                        "You'll get a notification the moment it's approved — "
                        'usually within 1–2 business days.',
                  ),
                OnboardingStage.suspended => const _Simple(
                    icon: Icons.block_rounded,
                    title: 'Account suspended',
                    body:
                        'Your astrologer account is suspended. Contact support '
                        'to understand why and how to reinstate it.',
                    showSupport: true,
                  ),
                OnboardingStage.notAstrologer => const _Simple(
                    icon: Icons.person_off_rounded,
                    title: 'Not an astrologer account',
                    body:
                        'This phone number is not registered as an astrologer. '
                        'If you believe this is a mistake, contact support.',
                    showSupport: true,
                  ),
                _ => const CircularProgressIndicator(),
              },
            ),
          ),
        );
      },
    );
  }
}

class _Wizard extends StatelessWidget {
  const _Wizard({required this.store});
  final OnboardingStore store;

  @override
  Widget build(BuildContext context) {
    final rejected = store.profile?.rejectionReason ?? '';
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.auto_awesome_rounded,
            size: 56, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 16),
        Text(
          rejected.isEmpty ? 'Set up your profile' : 'A few things to fix',
          style: Theme.of(context).textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          rejected.isEmpty
              ? 'Add your expertise, verify your identity and bank account, '
                  'then submit for review.'
              : rejected,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 24),
        FilledButton(
          onPressed: () => context.push('/onboarding/wizard'),
          child: Text(rejected.isEmpty ? 'Get started' : 'Continue'),
        ),
      ],
    );
  }
}

class _Simple extends StatelessWidget {
  const _Simple({
    required this.icon,
    required this.title,
    required this.body,
    this.showSupport = false,
  });
  final IconData icon;
  final String title;
  final String body;
  final bool showSupport;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 56, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 16),
        Text(title,
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center),
        const SizedBox(height: 8),
        Text(body,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium),
        if (showSupport) ...[
          const SizedBox(height: 20),
          OutlinedButton.icon(
            icon: const Icon(Icons.mail_outline_rounded),
            label: const Text('Contact support'),
            onPressed: () =>
                launchUrl(Uri.parse('mailto:support@talkacharya.com')),
          ),
        ],
      ],
    );
  }
}
