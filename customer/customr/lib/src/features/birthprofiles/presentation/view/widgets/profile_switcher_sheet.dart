import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/router/routes.dart';
import '../../../../../shared/widgets/app_bottom_sheet.dart';
import '../../bloc/birth_profiles_cubit.dart';
import 'profile_card.dart';

/// Bottom sheet to switch the active birth profile or jump to adding one.
/// Opened from the Home app-bar chip.
Future<void> showProfileSwitcherSheet(BuildContext context) {
  final cubit = context.read<BirthProfilesCubit>();
  cubit.load();
  return showAppSheet<void>(
    context: context,
    title: 'Birth profile',
    builder: (sheetContext) =>
        BlocBuilder<BirthProfilesCubit, BirthProfilesState>(
          bloc: cubit,
          builder: (context, state) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (state.status == BpStatus.loading && state.profiles.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else ...[
                  for (final p in state.profiles)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: ProfileCard(
                        profile: p,
                        selected: p.id == state.activeProfileId,
                        onTap: () {
                          cubit.select(p.id);
                          Navigator.pop(sheetContext);
                        },
                      ),
                    ),
                ],
                const SizedBox(height: 4),
                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(sheetContext);
                    context.push(Routes.birthProfileNew);
                  },
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('Add a profile'),
                ),
              ],
            );
          },
        ),
  );
}
