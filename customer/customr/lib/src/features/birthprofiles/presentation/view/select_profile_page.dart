import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/routes.dart';
import '../../../../shared/widgets/error_view.dart';
import '../bloc/birth_profiles_cubit.dart';
import 'widgets/profile_card.dart';

/// Shown once after an OTP login: pick which birth profile to use, or add one.
/// Soft gate — "Not now" lets the user into the app without choosing.
class SelectProfilePage extends StatefulWidget {
  const SelectProfilePage({super.key});

  @override
  State<SelectProfilePage> createState() => _SelectProfilePageState();
}

class _SelectProfilePageState extends State<SelectProfilePage> {
  @override
  void initState() {
    super.initState();
    context.read<BirthProfilesCubit>().load(force: true);
  }

  void _choose(String id) {
    context.read<BirthProfilesCubit>().select(id);
    context.go(Routes.home);
  }

  Future<void> _create() async {
    final created = await context.push<Object?>(Routes.selectProfileNew);
    if (created != null && mounted) context.go(Routes.home);
  }

  void _skip() {
    context.read<BirthProfilesCubit>().skipSelection();
    context.go(Routes.home);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<BirthProfilesCubit, BirthProfilesState>(
          builder: (context, state) {
            if (state.status == BpStatus.loading && state.profiles.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.status == BpStatus.error && state.profiles.isEmpty) {
              return ErrorView(
                message: state.error ?? 'Could not load your profiles.',
                onRetry: () =>
                    context.read<BirthProfilesCubit>().load(force: true),
              );
            }

            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 32, 20, 20),
              children: [
                Text(
                  state.profiles.isEmpty
                      ? 'Create your birth profile'
                      : 'Choose a profile',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  state.profiles.isEmpty
                      ? 'We use your birth details to build your kundali and '
                            'match you with the right astrologers. You can add '
                            'more profiles later.'
                      : 'Pick whose chart you want to work with. You can switch '
                            'or add profiles anytime.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 24),
                for (final p in state.profiles)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: ProfileCard(
                      profile: p,
                      selected: p.id == state.activeProfileId,
                      onTap: () => _choose(p.id),
                    ),
                  ),
                const SizedBox(height: 4),
                OutlinedButton.icon(
                  onPressed: _create,
                  icon: const Icon(Icons.add_rounded),
                  label: Text(
                    state.profiles.isEmpty
                        ? 'Create birth profile'
                        : 'Add another profile',
                  ),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: TextButton(
                    onPressed: _skip,
                    child: const Text('Not now'),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
