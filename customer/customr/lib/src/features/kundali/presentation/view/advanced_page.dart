import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../birthprofiles/presentation/bloc/birth_profiles_cubit.dart';
import '../widgets/kundali_pdf_sheet.dart';
import '../widgets/kundali_ui.dart';
import 'kundali_routes.dart';

class AdvancedPage extends StatelessWidget {
  const AdvancedPage({required this.profileId, super.key});
  final String profileId;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final items = <(IconData, String, String, String)>[
      (
        Icons.grid_4x4_rounded,
        l.kAdvAshtakavarga,
        l.kAdvAshtakavargaSub,
        'ashtakavarga',
      ),
      (Icons.bar_chart_rounded, l.kAdvShadbala, l.kAdvShadbalaSub, 'shadbala'),
      (Icons.tune_rounded, l.kAdvKp, l.kAdvKpSub, 'kp'),
      (Icons.hub_rounded, l.kAdvJaimini, l.kAdvJaiminiSub, 'jaimini'),
    ];
    return Scaffold(
      appBar: AppBar(title: Text(l.kAdvTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
        children: [
          Text(
            l.kAdvIntro,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          for (final it in items) ...[
            KCard(
              padding: EdgeInsets.zero,
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                leading: CircleAvatar(
                  radius: 20,
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.primaryContainer,
                  child: Icon(
                    it.$1,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
                title: Text(
                  it.$2,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                subtitle: Text(it.$3),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => context.push(
                  KundaliRoutes.advancedReport(profileId, it.$4),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
          const SizedBox(height: 6),
          OutlinedButton.icon(
            onPressed: () {
              final profiles = context
                  .read<BirthProfilesCubit>()
                  .state
                  .profiles;
              final name = profiles
                  .where((p) => p.id == profileId)
                  .map((p) => p.displayName)
                  .firstOrNull;
              showKundaliPdfSheet(
                context,
                profileId: profileId,
                name: name ?? l.kOvTitle,
              );
            },
            icon: const Icon(Icons.download_rounded, size: 18),
            label: Text(l.kAdvDownloadPdf),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            l.kAdvFooter,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
