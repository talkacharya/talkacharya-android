import 'package:astro_kundali/astro_kundali.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/astro_palette.dart';
import '../../../../core/theme/brand_colors.dart';
import '../cubit/kundali_cubit.dart';
import '../kundali_terms.dart';
import '../widgets/kundali_ui.dart';

/// The nine grahas: where each sits, how strong it is there, and what that
/// means — the Moon opens by default.
class PlanetsPage extends StatefulWidget {
  const PlanetsPage({required this.profileId, super.key});
  final String profileId;

  @override
  State<PlanetsPage> createState() => _PlanetsPageState();
}

class _PlanetsPageState extends State<PlanetsPage> {
  @override
  void initState() {
    super.initState();
    context.read<KundaliCubit>().loadOverview();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return BlocBuilder<KundaliCubit, KundaliState>(
      builder: (context, state) {
        final cubit = context.read<KundaliCubit>();
        final k = state.overview.value;
        final byName = <String, NatalPlanet>{
          for (final p in k?.planets ?? const <NatalPlanet>[]) p.name: p,
        };
        final ordered = [
          for (final name in planetOrder)
            if (byName[name] != null) byName[name]!,
        ];
        final retro = ordered.where((p) => p.retrograde).length;
        final strong = ordered
            .where(
              (p) =>
                  const {'exalted', 'moolatrikona', 'own'}.contains(p.dignity),
            )
            .length;

        return KundaliScaffold(
          title: l.kFcPlanets,
          eyebrow: l.kOvTitle,
          headline: l.kFcPlanets,
          subheadline: l.kPlanetsHeroSub,
          hue: kSignHue(k?.lagnaSign ?? ''),
          heroTrailing: const _OrbitGlyph(),
          heroChips: k == null
              ? const []
              : [
                  KHeroChip(
                    icon: Icons.workspace_premium_rounded,
                    label: l.kPlanetsStrongCount(strong),
                    color: AstroPalette.health.start,
                  ),
                  KHeroChip(
                    icon: Icons.replay_rounded,
                    label: l.kPlanetsRetroCount(retro),
                    color: AstroPalette.air.start,
                  ),
                ],
          onRefresh: () => cubit.loadOverview(force: true),
          children: k == null
              ? [
                  SliceBuilder<Kundali>(
                    slice: state.overview,
                    onRetry: () => cubit.loadOverview(force: true),
                    skeleton: const KBodySkeleton(blocks: [84, 84, 84, 84]),
                    builder: (_, _) => const SizedBox.shrink(),
                  ),
                ]
              : [
                  Text(
                    l.kPlanetsIntro,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: context.brand.inkMuted,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 14),
                  for (final p in ordered)
                    _PlanetCard(
                      planet: p,
                      house: k.houseForSign(p.sign) ?? p.house,
                      initiallyOpen: p.name == 'Moon',
                    ),
                  const KAskCta(),
                ],
        );
      },
    );
  }
}

class _OrbitGlyph extends StatelessWidget {
  const _OrbitGlyph();

  @override
  Widget build(BuildContext context) {
    const planets = ['Sun', 'Moon', 'Jupiter', 'Venus', 'Saturn'];
    return SizedBox(
      width: 86,
      height: 86,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
            ),
          ),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
            ),
          ),
          const PlanetBadge('Sun', size: 26),
          for (var i = 1; i < planets.length; i++)
            Align(
              alignment: [
                const Alignment(0.95, -0.35),
                const Alignment(-0.9, 0.5),
                const Alignment(0.2, 0.98),
                const Alignment(-0.35, -0.95),
              ][i - 1],
              child: PlanetBadge(planets[i], size: 18),
            ),
        ],
      ),
    );
  }
}

class _PlanetCard extends StatelessWidget {
  const _PlanetCard({
    required this.planet,
    required this.house,
    required this.initiallyOpen,
  });

  final NatalPlanet planet;
  final int house;
  final bool initiallyOpen;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = context.l10n;
    final brand = context.brand;
    final hue = kPlanetHue(planet.name);
    final gloss = KTerms.planet(l, planet.name).split(',').first;
    final dignityShort = KTerms.dignityShort(l, planet.dignity);
    final tone = switch (planet.dignity) {
      'exalted' || 'moolatrikona' || 'own' => KTone.good,
      'debilitated' => KTone.bad,
      'enemy_sign' || 'great_enemy_sign' => KTone.caution,
      _ => KTone.neutral,
    };

    return KExpandable(
      initiallyOpen: initiallyOpen,
      header: Row(
        children: [
          PlanetBadge(planet.name, size: 46),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  KTerms.planetName(l, planet.name),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  gloss,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: hue.end,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  l.kPlanetRowMeta(
                    KTerms.signName(l, planet.sign),
                    KTerms.nthHouse(l, house),
                    planet.degree.toStringAsFixed(0),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: brand.inkMuted,
                  ),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: [
                    if (dignityShort.isNotEmpty)
                      KToneChip(dignityShort, tone: tone),
                    if (planet.retrograde)
                      KToneChip(
                        '℞ ${l.kPlanetRetrograde}',
                        tone: KTone.neutral,
                      ),
                    if (planet.combust)
                      KToneChip(l.kPlanetCombust, tone: KTone.caution),
                    if (planet.nakshatra.isNotEmpty)
                      KToneChip(
                        KTerms.nakshatraName(l, planet.nakshatra),
                        hue: AstroPalette.career,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: hue.tint(0.08),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              KTerms.dignity(l, planet.dignity),
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w800,
                color: hue.end,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              KTerms.planetInSignHouse(l, planet.name, planet.sign, house),
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
            ),
            if (planet.combust) ...[
              const SizedBox(height: 8),
              Text(
                l.kCombustNote,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: brand.inkMuted,
                  height: 1.4,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
