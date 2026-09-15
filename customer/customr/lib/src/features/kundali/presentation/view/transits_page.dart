import 'package:astro_kundali/astro_kundali.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/astro_palette.dart';
import '../../../../core/theme/brand_colors.dart';
import '../../../../shared/widgets/hue_widgets.dart';
import '../cubit/kundali_cubit.dart';
import '../kundali_terms.dart';
import '../widgets/kundali_ui.dart';
import '../widgets/sade_sati_card.dart';
import 'kundali_routes.dart';

/// Gochar: where the planets are today relative to your chart, Sade Sati /
/// panoti status, Jupiter's support, close contacts, and the ashtakavarga
/// scores for each transit.
class TransitsPage extends StatefulWidget {
  const TransitsPage({required this.profileId, super.key});
  final String profileId;

  @override
  State<TransitsPage> createState() => _TransitsPageState();
}

class _TransitsPageState extends State<TransitsPage> {
  @override
  void initState() {
    super.initState();
    context.read<KundaliCubit>()
      ..loadTransits()
      ..loadAvTransit();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return BlocBuilder<KundaliCubit, KundaliState>(
      builder: (context, state) {
        final cubit = context.read<KundaliCubit>();
        final t = state.transits.value;
        final hue = t?.sadeSatiActive ?? false
            ? AstroPalette.money
            : AstroPalette.air;

        return KundaliScaffold(
          title: l.kTrTitle,
          eyebrow: l.kSsSkyNow,
          headline: l.kTrTitle,
          subheadline: t == null || t.natalMoonSign.isEmpty
              ? null
              : l.kTrHeroSub(KTerms.signName(l, t.natalMoonSign)),
          hue: hue,
          heroTrailing: KHeroGlyph(
            hue: hue,
            icon: Icons.public_rounded,
            size: 72,
          ),
          heroChips: t == null
              ? const []
              : [
                  if (t.sadeSatiActive)
                    KHeroChip(
                      icon: Icons.brightness_3_rounded,
                      label: l.kTrSadeSati,
                      color: AstroPalette.money.start,
                    ),
                  KHeroChip(
                    icon: t.jupiterFavourable
                        ? Icons.thumb_up_alt_rounded
                        : Icons.remove_circle_outline_rounded,
                    label: l.kTrJupiterChip(
                      KTerms.nthHouse(l, t.jupiterHouseFromMoon),
                    ),
                    color: t.jupiterFavourable
                        ? AstroPalette.health.start
                        : null,
                  ),
                ],
          onRefresh: () async {
            await Future.wait([
              cubit.loadTransits(force: true),
              cubit.loadAvTransit(force: true),
            ]);
          },
          animate: t != null,
          children: t == null
              ? [
                  SliceBuilder<Transits>(
                    slice: state.transits,
                    onRetry: () => cubit.loadTransits(force: true),
                    skeleton: const KBodySkeleton(blocks: [170, 260, 90]),
                    builder: (_, _) => const SizedBox.shrink(),
                  ),
                ]
              : [
                  if (t.sadeSatiActive)
                    _SadeSatiPanel(t: t)
                  else if (t.smallPanotiActive)
                    SadeSatiCard(transits: t),
                  if (t.sadeSatiActive || t.smallPanotiActive)
                    const SizedBox(height: 12),
                  KNavRow(
                    icon: Icons.event_note_rounded,
                    hue: AstroPalette.money,
                    title: l.kTrSadeSatiCalendar,
                    subtitle: l.kTrSadeSatiCalendarSub,
                    onTap: () =>
                        context.push(KundaliRoutes.sadeSati(widget.profileId)),
                  ),
                  KSection(
                    title: l.kTrSkyNow,
                    hue: AstroPalette.air,
                    child: _CurrentSky(t: t),
                  ),
                  const SizedBox(height: 12),
                  _JupiterCard(t: t),
                  if (t.positions.any((p) => p.overNatal.isNotEmpty)) ...[
                    const SizedBox(height: 12),
                    _NotableCard(t: t),
                  ],
                  const _AvTransitSection(),
                  const KAskCta(),
                ],
        );
      },
    );
  }
}

class _SadeSatiPanel extends StatelessWidget {
  const _SadeSatiPanel({required this.t});
  final Transits t;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    const phases = ['rising', 'peak', 'setting'];
    final idx = phases.indexOf(t.sadeSatiPhase);
    final tips = [l.kTrTip1, l.kTrTip2, l.kTrTip3, l.kTrTip4];
    const hue = AstroPalette.money;
    return KHueCard(
      hue: hue,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const PlanetBadge('Saturn', size: 42),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  l.kTrSadeSati,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              KToneChip(l.kTrPhaseOf(idx + 1), hue: hue),
            ],
          ),
          const SizedBox(height: 14),
          SaturnPhaseStepper(
            labels: [l.kSsRising, l.kSsPeak, l.kSsSetting],
            hints: [
              l.kTrPhaseHintRising,
              l.kTrPhaseHintPeak,
              l.kTrPhaseHintSetting,
            ],
            active: idx,
          ),
          const SizedBox(height: 14),
          Text(
            KTerms.sadeSati(l, t.sadeSatiPhase),
            style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.kTrHowToWork,
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: hue.end,
                  ),
                ),
                const SizedBox(height: 6),
                for (final tip in tips)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.check_rounded,
                          size: 16,
                          color: AstroPalette.health.end,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            tip,
                            style: theme.textTheme.bodySmall?.copyWith(
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CurrentSky extends StatelessWidget {
  const _CurrentSky({required this.t});
  final Transits t;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final brand = context.brand;
    final ordered = [
      for (final name in planetOrder)
        ...t.positions.where((p) => p.name == name),
    ];
    return KSurface(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      child: Column(
        children: [
          for (var i = 0; i < ordered.length; i++) ...[
            if (i > 0) Divider(height: 1, color: brand.hairline),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  PlanetBadge(ordered[i].name, size: 36),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l.kTrPlanetInSign(
                            KTerms.planetName(l, ordered[i].name),
                            KTerms.signName(l, ordered[i].sign),
                          ),
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        if (ordered[i].houseFromLagna > 0)
                          Text(
                            l.kTransitHouseLine(
                              KTerms.nthHouse(l, ordered[i].houseFromLagna),
                              KTerms.house(
                                l,
                                ordered[i].houseFromLagna,
                              ).toLowerCase(),
                            ),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: brand.inkMuted,
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (ordered[i].name == 'Saturn' && t.sadeSatiActive)
                    KToneChip(l.kTrSadeSati, hue: AstroPalette.money),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _JupiterCard extends StatelessWidget {
  const _JupiterCard({required this.t});
  final Transits t;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final hue = t.jupiterFavourable ? AstroPalette.health : AstroPalette.air;
    return KHueCard(
      hue: hue,
      child: Row(
        children: [
          const PlanetBadge('Jupiter', size: 40),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              t.jupiterFavourable ? l.kTrJupiterGood : l.kTrJupiterNeutral,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(height: 1.45),
            ),
          ),
          const SizedBox(width: 8),
          HueIcon(
            hue: hue,
            icon: t.jupiterFavourable
                ? Icons.check_rounded
                : Icons.remove_rounded,
            size: 28,
            iconSize: 16,
          ),
        ],
      ),
    );
  }
}

class _NotableCard extends StatelessWidget {
  const _NotableCard({required this.t});
  final Transits t;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final hits = t.positions.where((p) => p.overNatal.isNotEmpty).toList();
    return KSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const KIconBox(
                icon: Icons.join_inner_rounded,
                hue: AstroPalette.love,
                size: 32,
              ),
              const SizedBox(width: 10),
              Text(
                l.kTrCloseContacts,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          for (final p in hits)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PlanetBadge(p.name, size: 24),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      l.kTrCloseContactLine(
                        KTerms.planetName(l, p.name),
                        KTerms.displayNames(l, p.overNatal),
                      ),
                      style: theme.textTheme.bodySmall?.copyWith(height: 1.45),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _AvTransitSection extends StatelessWidget {
  const _AvTransitSection();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return BlocBuilder<KundaliCubit, KundaliState>(
      buildWhen: (a, b) => a.avTransit != b.avTransit,
      builder: (context, state) {
        final r = state.avTransit.value;
        if (r == null) return const SizedBox.shrink();
        final theme = Theme.of(context);
        final rows = r.transits.where((x) => x.planet != 'Moon').toList();
        return KSection(
          title: l.avTransitHeading,
          subtitle: l.avTransitIntro,
          hue: AstroPalette.career,
          child: KSurface(
            padding: const EdgeInsets.fromLTRB(14, 8, 14, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final row in rows)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _BinduScore(bindus: row.bindus, tone: row.tone),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            row.summary,
                            style: theme.textTheme.bodySmall?.copyWith(
                              height: 1.45,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                if (r.upcomingIngresses.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    l.avTransitUpcoming,
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  for (final u in r.upcomingIngresses)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          PlanetBadge(u.planet, size: 22),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              u.summary,
                              style: theme.textTheme.bodySmall?.copyWith(
                                height: 1.45,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

/// 0–8 ashtakavarga bindus as a tone-coloured score with an 8-dot meter.
class _BinduScore extends StatelessWidget {
  const _BinduScore({required this.bindus, required this.tone});
  final int bindus;
  final String tone;

  @override
  Widget build(BuildContext context) {
    final hue = switch (tone) {
      'supportive' => AstroPalette.health,
      'challenging' => AstroPalette.fire,
      _ => AstroPalette.air,
    };
    return Container(
      width: 46,
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: hue.tint(0.13),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            '$bindus',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: hue.end,
            ),
          ),
          const SizedBox(height: 3),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 0; i < 8; i++)
                Container(
                  width: 3,
                  height: 3,
                  margin: const EdgeInsets.symmetric(horizontal: 0.6),
                  decoration: BoxDecoration(
                    color: i < bindus ? hue.end : hue.tint(0.3),
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
