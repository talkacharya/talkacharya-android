import 'package:astro_kundali/astro_kundali.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/astro_palette.dart';
import '../../../../core/theme/brand_colors.dart';
import '../../../../shared/widgets/hue_widgets.dart';
import '../cubit/kundali_cubit.dart';
import '../kundali_terms.dart';
import '../widgets/kundali_ui.dart';

/// Lal Kitab (`/lal-kitab`) — the inherited debts (rin) in the chart and their
/// signature totka remedies. Simple, free household acts — never gemstones.
class LalKitabPage extends StatefulWidget {
  const LalKitabPage({required this.profileId, super.key});
  final String profileId;

  @override
  State<LalKitabPage> createState() => _LalKitabPageState();
}

class _LalKitabPageState extends State<LalKitabPage> {
  @override
  void initState() {
    super.initState();
    context.read<KundaliCubit>().loadLalKitab();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    const hue = AstroPalette.fire;
    return BlocBuilder<KundaliCubit, KundaliState>(
      buildWhen: (a, b) => a.lalKitab != b.lalKitab,
      builder: (context, state) {
        final cubit = context.read<KundaliCubit>();
        final r = state.lalKitab.value;
        return KundaliScaffold(
          title: l.lalKitabTitle,
          eyebrow: l.kOvTitle,
          headline: l.lalKitabTitle,
          subheadline: l.kLkHeroSub,
          hue: hue,
          heroTrailing: const KHeroGlyph(
            hue: hue,
            icon: Icons.menu_book_rounded,
            size: 72,
          ),
          heroChips: r == null
              ? const []
              : [
                  KHeroChip(
                    icon: Icons.receipt_long_rounded,
                    label: l.kLkDebtCount(r.activeRins.length),
                    color: r.activeRins.isEmpty
                        ? AstroPalette.health.start
                        : AstroPalette.money.start,
                  ),
                  if (r.mandaPlanets.isNotEmpty)
                    KHeroChip(
                      icon: Icons.battery_2_bar_rounded,
                      label: l.kLkWeakCount(r.mandaPlanets.length),
                    ),
                ],
          onRefresh: () => cubit.loadLalKitab(force: true),
          animate: r != null,
          children: r == null
              ? [
                  SliceBuilder<LalKitabReport>(
                    slice: state.lalKitab,
                    onRetry: () => cubit.loadLalKitab(force: true),
                    skeleton: const KBodySkeleton(blocks: [110, 200, 200]),
                    builder: (_, _) => const SizedBox.shrink(),
                  ),
                ]
              : [
                  Text(
                    l.lalKitabIntro,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: context.brand.inkMuted,
                      height: 1.45,
                    ),
                  ),
                  if (r.summary.isNotEmpty) ...[
                    const SizedBox(height: 14),
                    ReadingCard(body: r.summary, hue: hue),
                  ],
                  KSection(
                    title: l.lalKitabActiveDebts,
                    hue: AstroPalette.money,
                    child: r.activeRins.isEmpty
                        ? KHueCard(
                            hue: AstroPalette.health,
                            child: Row(
                              children: [
                                const HueIcon(
                                  hue: AstroPalette.health,
                                  icon: Icons.check_rounded,
                                  size: 38,
                                  iconSize: 20,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    l.lalKitabNoDebts,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(height: 1.45),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Column(
                            children: [
                              for (final rin in r.activeRins)
                                _RinCard(rin: rin),
                            ],
                          ),
                  ),
                  if (r.mandaPlanets.isNotEmpty)
                    KSection(
                      title: l.lalKitabWeakPlanets,
                      hue: AstroPalette.air,
                      child: Column(
                        children: [
                          for (final m in r.mandaPlanets) _MandaCard(manda: m),
                        ],
                      ),
                    ),
                  if (r.disclaimer.isNotEmpty) KFootnote(r.disclaimer),
                  const KAskCta(),
                ],
        );
      },
    );
  }
}

class _RinCard extends StatelessWidget {
  const _RinCard({required this.rin});
  final LalKitabRin rin;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final hue = rin.planet.isEmpty
        ? AstroPalette.money
        : kPlanetHue(rin.planet);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: KSurface(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (rin.planet.isNotEmpty)
                  PlanetBadge(rin.planet, size: 38)
                else
                  HueIcon(
                    hue: hue,
                    icon: Icons.receipt_long_rounded,
                    size: 38,
                    iconSize: 19,
                  ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    rin.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            if (rin.reasons.isNotEmpty)
              KNoteBox(
                title: l.lalKitabWhyFlagged,
                icon: Icons.search_rounded,
                hue: AstroPalette.air,
                lines: rin.reasons,
              ),
            if (rin.remedy.isNotEmpty)
              KNoteBox(
                title: l.lalKitabRemedy,
                icon: Icons.spa_rounded,
                hue: AstroPalette.health,
                child: Text(
                  rin.remedy,
                  style: theme.textTheme.bodyMedium?.copyWith(height: 1.45),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _MandaCard extends StatelessWidget {
  const _MandaCard({required this.manda});
  final LalKitabManda manda;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final hue = kPlanetHue(manda.planet);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: KSurface(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (manda.planet.isNotEmpty) ...[
                  PlanetBadge(manda.planet, size: 34),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (manda.planet.isNotEmpty)
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                KTerms.planetName(l, manda.planet),
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            if (manda.house > 0) ...[
                              const SizedBox(width: 8),
                              KPill(KTerms.nthHouse(l, manda.house), hue: hue),
                            ],
                          ],
                        ),
                      const SizedBox(height: 4),
                      Text(
                        manda.summary,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          height: 1.45,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (manda.remedy.isNotEmpty)
              KNoteBox(
                title: l.lalKitabRemedy,
                icon: Icons.spa_rounded,
                hue: AstroPalette.health,
                child: Text(
                  manda.remedy,
                  style: theme.textTheme.bodySmall?.copyWith(height: 1.45),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
