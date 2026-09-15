import 'package:astro_kundali/astro_kundali.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/astro_palette.dart';
import '../../../../core/theme/brand_colors.dart';
import '../cubit/kundali_cubit.dart';
import '../kundali_terms.dart';
import '../widgets/kundali_ui.dart';

/// Jyotish upaya (`/jyotish-upaya`) — the per-planet remedy table. Colour, day,
/// deity, mantra and charity are free to adopt; gemstone and rudraksha lines are
/// ALWAYS shown behind a "confirm with an astrologer first" gate.
class JyotishUpayaPage extends StatefulWidget {
  const JyotishUpayaPage({required this.profileId, super.key});
  final String profileId;

  @override
  State<JyotishUpayaPage> createState() => _JyotishUpayaPageState();
}

class _JyotishUpayaPageState extends State<JyotishUpayaPage> {
  @override
  void initState() {
    super.initState();
    context.read<KundaliCubit>().loadJyotishUpaya();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return BlocBuilder<KundaliCubit, KundaliState>(
      buildWhen: (a, b) => a.jyotishUpaya != b.jyotishUpaya,
      builder: (context, state) {
        final cubit = context.read<KundaliCubit>();
        final r = state.jyotishUpaya.value;
        final hue = kSignHue(r?.lagnaSign ?? '');
        final ordered = r == null
            ? const <UpayaPlanet>[]
            : [
                ...r.planets.where((p) => p.priority),
                ...r.planets.where((p) => p.isStrengthen && !p.priority),
                ...r.planets.where((p) => !p.isStrengthen && !p.priority),
              ];
        final strengthen = ordered.where((p) => p.role == 'strengthen').length;
        final pacify = ordered.where((p) => p.role == 'pacify').length;

        return KundaliScaffold(
          title: l.upayaTitle,
          eyebrow: l.kOvTitle,
          headline: l.upayaTitle,
          subheadline: l.kUpHeroSub,
          hue: hue,
          heroTrailing: KHeroGlyph(
            hue: hue,
            icon: Icons.self_improvement_rounded,
            size: 72,
          ),
          heroChips: r == null
              ? const []
              : [
                  KHeroChip(
                    icon: Icons.arrow_upward_rounded,
                    label: l.kUpStrengthenCount(strengthen),
                    color: AstroPalette.health.start,
                  ),
                  KHeroChip(
                    icon: Icons.water_drop_rounded,
                    label: l.kUpPacifyCount(pacify),
                    color: AstroPalette.money.start,
                  ),
                ],
          onRefresh: () => cubit.loadJyotishUpaya(force: true),
          animate: r != null,
          children: r == null
              ? [
                  SliceBuilder<JyotishUpayaReport>(
                    slice: state.jyotishUpaya,
                    onRetry: () => cubit.loadJyotishUpaya(force: true),
                    skeleton: const KBodySkeleton(blocks: [180, 90, 90, 90]),
                    builder: (_, _) => const SizedBox.shrink(),
                  ),
                ]
              : [
                  Text(
                    l.upayaIntro(KTerms.signName(l, r.lagnaSign)),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: context.brand.inkMuted,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 14),
                  _LagnaCard(report: r),
                  if (r.gateNotice.isNotEmpty)
                    KNoteBox(
                      title: l.kUpGateTitle,
                      icon: Icons.verified_user_rounded,
                      hue: AstroPalette.money,
                      child: Text(
                        r.gateNotice,
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(height: 1.45),
                      ),
                    ),
                  KSection(
                    title: l.kUpPlanetsTitle,
                    hue: hue,
                    child: Column(
                      children: [
                        for (final p in ordered) _PlanetCard(planet: p),
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

class _LagnaCard extends StatelessWidget {
  const _LagnaCard({required this.report});
  final JyotishUpayaReport report;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final hue = kSignHue(report.lagnaSign);
    return KHueCard(
      hue: hue,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.upayaLagnaFavourable,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          if (report.lagnaColours.isNotEmpty)
            KInfoRow(
              icon: Icons.palette_rounded,
              hue: AstroPalette.love,
              label: l.upayaColours,
              value: report.lagnaColours.join(', '),
            ),
          if (report.lagnaDirection.isNotEmpty)
            KInfoRow(
              icon: Icons.explore_rounded,
              hue: AstroPalette.air,
              label: l.upayaDirection,
              value: report.lagnaDirection,
            ),
          if (report.lagnaDay.isNotEmpty)
            KInfoRow(
              icon: Icons.calendar_today_rounded,
              hue: AstroPalette.career,
              label: l.upayaDay,
              value: report.lagnaDay,
            ),
          if (report.lagnaDeity.isNotEmpty)
            KInfoRow(
              icon: Icons.temple_hindu_rounded,
              hue: AstroPalette.money,
              label: l.upayaDeity,
              value: report.lagnaDeity,
            ),
          if (report.summary.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              report.summary,
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.45),
            ),
          ],
        ],
      ),
    );
  }
}

class _PlanetCard extends StatelessWidget {
  const _PlanetCard({required this.planet});
  final UpayaPlanet planet;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final (roleLabel, roleTone, roleHue) = switch (planet.role) {
      'strengthen' => (l.upayaStrengthen, KTone.good, null),
      'pacify' => (l.upayaPacify, KTone.caution, null),
      'mixed' => (l.upayaMixed, KTone.neutral, AstroPalette.air),
      _ => (l.upayaNeutral, KTone.neutral, null),
    };
    const gate = AstroPalette.money;
    final substitute =
        planet.gemstoneSubstitute.isNotEmpty && planet.gemstoneSubstitute != '-'
        ? ' (${l.kUpOr(planet.gemstoneSubstitute)})'
        : '';

    return KExpandable(
      initiallyOpen: planet.priority,
      hue: planet.priority ? kPlanetHue(planet.planet) : null,
      header: Row(
        children: [
          PlanetBadge(planet.planet, size: 42),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  KTerms.planetName(l, planet.planet),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    KToneChip(roleLabel, tone: roleTone, hue: roleHue),
                    if (planet.priority)
                      KToneChip(l.upayaPriority, hue: AstroPalette.health),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (planet.summary.isNotEmpty)
            Text(
              planet.summary,
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.45),
            ),
          KNoteBox(
            title: l.upayaFreeMeasures,
            icon: Icons.volunteer_activism_rounded,
            hue: AstroPalette.health,
            lines: [
              if (planet.colours.isNotEmpty)
                '${l.upayaColours}: ${planet.colours.join(", ")}',
              if (planet.direction.isNotEmpty)
                '${l.upayaDirection}: ${planet.direction}',
              if (planet.mantra.isNotEmpty)
                '${l.upayaMantra}: ${planet.mantra}',
              if (planet.charity.isNotEmpty)
                '${l.upayaCharity}: ${planet.charity}',
            ],
          ),
          if (planet.gemstone.isNotEmpty || planet.rudrakshaMukhi.isNotEmpty)
            KNoteBox(
              title: l.kUpGateTitle,
              icon: Icons.lock_outline_rounded,
              hue: gate,
              lines: [
                if (planet.gemstone.isNotEmpty)
                  '${l.upayaGemstone}: ${planet.gemstone}$substitute',
                if (planet.gemstoneMetal.isNotEmpty)
                  '${planet.gemstoneMetal} · ${l.kUpFinger(planet.gemstoneFinger)} · ${planet.gemstoneStartDay}',
                if (planet.rudrakshaMukhi.isNotEmpty)
                  '${l.upayaRudraksha}: ${planet.rudrakshaMukhi}',
              ],
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: TextButton.icon(
                  onPressed: () => context.go(Routes.astrologers),
                  icon: const Icon(Icons.verified_user_outlined, size: 16),
                  label: Text(l.upayaGatedCta),
                  style: TextButton.styleFrom(
                    foregroundColor: gate.end,
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
