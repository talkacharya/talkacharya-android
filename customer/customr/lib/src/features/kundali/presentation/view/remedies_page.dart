import 'package:astro_kundali/astro_kundali.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/astro_palette.dart';
import '../../../../core/theme/brand_colors.dart';
import '../../../../shared/widgets/hue_widgets.dart';
import '../cubit/kundali_cubit.dart';
import '../widgets/kundali_ui.dart';

/// Remedies matched to this chart, grouped by kind (mantra, daan, lifestyle…).
/// Gemstone / rudraksha style items stay gated behind an astrologer check.
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
    const hue = AstroPalette.health;
    return BlocBuilder<KundaliCubit, KundaliState>(
      buildWhen: (a, b) => a.remedies != b.remedies,
      builder: (context, state) {
        final cubit = context.read<KundaliCubit>();
        final report = state.remedies.value;
        final total =
            report?.groups.fold<int>(0, (n, g) => n + g.items.length) ?? 0;
        return KundaliScaffold(
          title: l.remediesTitle,
          eyebrow: l.kOvTitle,
          headline: l.remediesTitle,
          subheadline: l.kRmHeroSub,
          hue: hue,
          heroTrailing: const KHeroGlyph(
            hue: hue,
            icon: Icons.spa_rounded,
            size: 72,
          ),
          heroChips: report == null || report.isEmpty
              ? const []
              : [
                  KHeroChip(
                    icon: Icons.checklist_rounded,
                    label: l.kRmCount(total),
                    color: AstroPalette.health.start,
                  ),
                  if (report.hasGated)
                    KHeroChip(
                      icon: Icons.verified_user_rounded,
                      label: l.kRmGatedChip,
                      color: AstroPalette.money.start,
                    ),
                ],
          onRefresh: () => cubit.loadRemedies(force: true),
          animate: report != null,
          children: report == null
              ? [
                  SliceBuilder<RemedyReport>(
                    slice: state.remedies,
                    onRetry: () => cubit.loadRemedies(force: true),
                    skeleton: const KBodySkeleton(blocks: [60, 160, 160, 160]),
                    builder: (_, _) => const SizedBox.shrink(),
                  ),
                ]
              : report.isEmpty
              ? [
                  KHueCard(
                    hue: hue,
                    child: Row(
                      children: [
                        const HueIcon(
                          hue: hue,
                          icon: Icons.check_rounded,
                          size: 40,
                          iconSize: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            l.remediesNone,
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.copyWith(height: 1.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  KAskCta(title: l.remediesAskCta),
                ]
              : [
                  Text(
                    l.remediesIntro,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: context.brand.inkMuted,
                      height: 1.45,
                    ),
                  ),
                  for (final group in report.groups)
                    KSection(
                      title: remedyCategoryLabel(l, group.category),
                      hue: remedyCategoryHue(group.category),
                      trailing: KPill(
                        '${group.items.length}',
                        hue: remedyCategoryHue(group.category),
                      ),
                      child: Column(
                        children: [
                          for (final remedy in group.items)
                            _RemedyCard(
                              remedy: remedy,
                              category: group.category,
                            ),
                        ],
                      ),
                    ),
                  if (report.hasGated && report.gatedNote.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    KHueCard(
                      hue: AstroPalette.money,
                      child: Row(
                        children: [
                          const HueIcon(
                            hue: AstroPalette.money,
                            icon: Icons.verified_user_rounded,
                            size: 38,
                            iconSize: 19,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              report.gatedNote,
                              style: Theme.of(
                                context,
                              ).textTheme.bodySmall?.copyWith(height: 1.45),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  KFootnote(
                    report.disclaimer.isNotEmpty
                        ? report.disclaimer
                        : l.remediesDisclaimer,
                  ),
                  KAskCta(title: l.remediesAskCta),
                ],
        );
      },
    );
  }
}

class _RemedyCard extends StatelessWidget {
  const _RemedyCard({required this.remedy, required this.category});
  final Remedy remedy;
  final String category;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final hue = remedyCategoryHue(category);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: KSurface(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                KIconBox(
                  icon: RemedyCategoryInfo.icon(category),
                  hue: hue,
                  size: 34,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    remedy.title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                if (remedy.gated)
                  const Icon(
                    Icons.lock_outline_rounded,
                    size: 16,
                    color: Color(0xFFB0691F),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              remedy.body,
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
            ),
            if (remedy.caution.isNotEmpty)
              KNoteBox(
                title: l.kRmCaution,
                icon: Icons.info_outline_rounded,
                hue: AstroPalette.money,
                child: Text(
                  remedy.caution,
                  style: theme.textTheme.bodySmall?.copyWith(height: 1.4),
                ),
              ),
            if (remedy.gated) ...[
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: () => context.go(Routes.astrologers),
                icon: const Icon(Icons.event_available_outlined, size: 16),
                label: Text(l.remediesConfirmCta),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(42),
                ),
              ),
            ],
            if (remedy.source.isNotEmpty && remedy.source != 'traditional') ...[
              const SizedBox(height: 8),
              Text(
                l.remediesSource(remedy.source),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: context.brand.inkMuted,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

AstroHue remedyCategoryHue(String category) => switch (category) {
  'mantra' || 'stotra' => AstroPalette.air,
  'puja' => AstroPalette.fire,
  'vrat' => AstroPalette.career,
  'daan' => AstroPalette.love,
  'lifestyle' => AstroPalette.health,
  'yantra' => AstroPalette.water,
  'gemstone' || 'rudraksha' => AstroPalette.money,
  _ => AstroPalette.earth,
};

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
