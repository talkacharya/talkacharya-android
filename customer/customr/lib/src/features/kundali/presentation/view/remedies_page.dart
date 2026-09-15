import 'package:astro_kundali/astro_kundali.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/brand_colors.dart';
import '../cubit/kundali_cubit.dart';
import '../widgets/kundali_ui.dart';

class RemediesPage extends StatefulWidget {
  const RemediesPage({required this.profileId, super.key});
  final String profileId;

  @override
  State<RemediesPage> createState() => _RemediesPageState();
}

class _RemediesPageState extends State<RemediesPage> {
  @override
  void initState() {
    super.initState();
    context.read<KundaliCubit>().loadRemedies();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l.remediesTitle)),
      body: BlocBuilder<KundaliCubit, KundaliState>(
        buildWhen: (a, b) => a.remedies != b.remedies,
        builder: (context, state) => SliceBuilder<RemedyReport>(
          slice: state.remedies,
          onRetry: () => context.read<KundaliCubit>().loadRemedies(force: true),
          builder: (context, report) {
            if (report.isEmpty) {
              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  KCard(
                    child: Text(
                      l.remediesNone,
                      style: const TextStyle(fontSize: 13, height: 1.5),
                    ),
                  ),
                ],
              );
            }
            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 28),
              children: [
                Text(
                  l.remediesIntro,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 14),
                for (final group in report.groups) ...[
                  _GroupSection(group: group),
                  const SizedBox(height: 14),
                ],
                if (report.hasGated && report.gatedNote.isNotEmpty) ...[
                  KCard(
                    tint: true,
                    child: Row(
                      children: [
                        Icon(
                          Icons.verified_user_outlined,
                          size: 18,
                          color: context.brand.onTint,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            report.gatedNote,
                            style: const TextStyle(fontSize: 12.5, height: 1.4),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                Text(
                  report.disclaimer.isNotEmpty
                      ? report.disclaimer
                      : l.remediesDisclaimer,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),
                AskAstrologerBar(
                  label: l.remediesAskCta,
                  onTap: () => context.go(Routes.astrologers),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _GroupSection extends StatelessWidget {
  const _GroupSection({required this.group});
  final RemedyGroup group;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              RemedyCategoryInfo.icon(group.category),
              size: 17,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              remedyCategoryLabel(l, group.category),
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        for (final remedy in group.items) ...[
          _RemedyCard(remedy: remedy),
          const SizedBox(height: 8),
        ],
      ],
    );
  }
}

class _RemedyCard extends StatelessWidget {
  const _RemedyCard({required this.remedy});
  final Remedy remedy;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    return KCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            remedy.title,
            style: theme.textTheme.titleMedium?.copyWith(fontSize: 14.5),
          ),
          const SizedBox(height: 6),
          Text(remedy.body, style: const TextStyle(fontSize: 13, height: 1.5)),
          if (remedy.caution.isNotEmpty) ...[
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.info_outline_rounded,
                  size: 14,
                  color: Color(0xFFB0691F),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    remedy.caution,
                    style: const TextStyle(
                      fontSize: 11.5,
                      height: 1.4,
                      color: Color(0xFFB0691F),
                    ),
                  ),
                ),
              ],
            ),
          ],
          if (remedy.gated) ...[
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: () => context.go(Routes.astrologers),
              icon: const Icon(Icons.event_available_outlined, size: 16),
              label: Text(l.remediesConfirmCta),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(40),
              ),
            ),
          ],
          if (remedy.source.isNotEmpty && remedy.source != 'traditional') ...[
            const SizedBox(height: 6),
            Text(
              l.remediesSource(remedy.source),
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

String remedyCategoryLabel(AppLocalizations l, String category) =>
    switch (category) {
      'mantra' => l.remedyCatMantra,
      'stotra' => l.remedyCatStotra,
      'puja' => l.remedyCatPuja,
      'vrat' => l.remedyCatVrat,
      'daan' => l.remedyCatDaan,
      'lifestyle' => l.remedyCatLifestyle,
      'yantra' => l.remedyCatYantra,
      'gemstone' => l.remedyCatGemstone,
      'rudraksha' => l.remedyCatRudraksha,
      _ => RemedyCategoryInfo.label(category),
    };
