import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/birth_profiles_cubit.dart';
import 'profile_switcher_sheet.dart';

/// App-bar chip showing the active birth profile; tap to switch or add one.
class ActiveProfileChip extends StatelessWidget {
  const ActiveProfileChip({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return BlocBuilder<BirthProfilesCubit, BirthProfilesState>(
      builder: (context, state) {
        final active = state.activeProfile;
        final label =
            active?.displayName ??
            (state.activeProfileId != null ? 'Profile' : 'Add profile');
        return InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => showProfileSwitcherSheet(context),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  active == null
                      ? Icons.person_add_alt_rounded
                      : Icons.person_rounded,
                  size: 18,
                  color: scheme.primary,
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    label,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const Icon(Icons.expand_more_rounded, size: 18),
              ],
            ),
          ),
        );
      },
    );
  }
}
