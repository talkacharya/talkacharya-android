import 'package:astro_kundali/astro_kundali.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/brand_colors.dart';
import '../cubit/kundali_cubit.dart';
import '../kundali_terms.dart';
import '../widgets/kundali_ui.dart';
import 'kundali_routes.dart';

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
    return Scaffold(
      appBar: AppBar(title: Text(l.kTrTitle)),
      body: BlocBuilder<KundaliCubit, KundaliState>(
        builder: (context, state) => SliceBuilder<Transits>(
          slice: state.transits,
          onRetry: () => context.read<KundaliCubit>().loadTransits(force: true),
          builder: (context, t) => ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
            children: [
              if (t.sadeSatiActive)
                _SadeSatiPanel(t: t)
              else if (t.smallPanotiActive)
                _PanotiPanel(t: t),
              if (t.sadeSatiActive || t.smallPanotiActive)
                const SizedBox(height: 14),
              OutlinedButton.icon(
                onPressed: () =>
                    context.push(KundaliRoutes.sadeSati(widget.profileId)),
                icon: const Icon(Icons.event_note_rounded, size: 18),
                label: Text(l.kTrSadeSatiCalendar),
              ),
              const SizedBox(height: 14),
              KLabel(l.kTrSkyNow),
              const SizedBox(height: 8),
              _CurrentSky(t: t),
              const SizedBox(height: 14),
              _JupiterCard(t: t),
              const SizedBox(height: 12),
              if (t.positions.any((p) => p.overNatal.isNotEmpty))
                _NotableCard(t: t),
              const SizedBox(height: 12),
              const _AvTransitSection(),
            ],
          ),
        ),
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
        return KCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l.avTransitHeading,
                style: theme.textTheme.titleMedium?.copyWith(fontSize: 14),
              ),
              const SizedBox(height: 4),
              Text(
                l.avTransitIntro,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 10),
              for (final row in r.transits.where((x) => x.planet != 'Moon'))
                Padding(
                  padding: const EdgeInsets.only(bottom: 7),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _BinduBadge(bindus: row.bindus, tone: row.tone),
                      const SizedBox(width: 9),
                      Expanded(
                        child: Text(
                          row.summary,
                          style: const TextStyle(fontSize: 12, height: 1.4),
                        ),
                      ),
                    ],
                  ),
                ),
              if (r.upcomingIngresses.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  l.avTransitUpcoming,
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                for (final u in r.upcomingIngresses)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: Text(
                      '·  ${u.summary}',
                      style: const TextStyle(fontSize: 12, height: 1.4),
                    ),
                  ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _BinduBadge extends StatelessWidget {
  const _BinduBadge({required this.bindus, required this.tone});
  final int bindus;
  final String tone;

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = switch (tone) {
      'supportive' => (const Color(0xFFDDF0E4), const Color(0xFF2C6B45)),
      'challenging' => (const Color(0xFFFBEBD8), const Color(0xFFB0691F)),
      _ => (const Color(0xFFE4E8F5), const Color(0xFF3F4E86)),
    };
    return Container(
      width: 34,
      height: 26,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$bindus',
        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: fg),
      ),
    );
  }
}

class _SadeSatiPanel extends StatelessWidget {
  const _SadeSatiPanel({required this.t});
  final Transits t;

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    final l = context.l10n;
    const phases = ['rising', 'peak', 'setting'];
    final idx = phases.indexOf(t.sadeSatiPhase);
    final phaseLabels = [l.kSsRising, l.kSsPeak, l.kSsSetting];
    final phaseHints = [
      l.kTrPhaseHintRising,
      l.kTrPhaseHintPeak,
      l.kTrPhaseHintSetting,
    ];
    final tips = [l.kTrTip1, l.kTrTip2, l.kTrTip3, l.kTrTip4];
    return KCard(
      tint: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.brightness_3_rounded, size: 18, color: brand.onTint),
              const SizedBox(width: 8),
              Text(
                l.kTrSadeSati,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(color: brand.onTint),
              ),
              const Spacer(),
              Text(
                l.kTrPhaseOf(idx + 1),
                style: TextStyle(
                  color: brand.onTint,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              for (var i = 0; i < 3; i++) ...[
                if (i != 0) const SizedBox(width: 6),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 9),
                    decoration: BoxDecoration(
                      color: i == idx
                          ? brand.onTint.withValues(alpha: 0.16)
                          : Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: brand.hairline),
                    ),
                    child: Column(
                      children: [
                        Text(
                          phaseLabels[i],
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 11.5,
                            color: i == idx
                                ? brand.onTint
                                : Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                          ),
                        ),
                        Text(
                          phaseHints[i],
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                fontSize: 10,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),
          Text(
            KTerms.sadeSati(l, t.sadeSatiPhase),
            style: const TextStyle(fontSize: 13.5, height: 1.45),
          ),
          const SizedBox(height: 12),
          Text(
            l.kTrHowToWork,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5),
          ),
          const SizedBox(height: 6),
          for (final tip in tips)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                '·  $tip',
                style: const TextStyle(fontSize: 12.5, height: 1.35),
              ),
            ),
        ],
      ),
    );
  }
}

class _PanotiPanel extends StatelessWidget {
  const _PanotiPanel({required this.t});
  final Transits t;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return KCard(
      tint: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.kSsPanotiTitle(t.smallPanotiType),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 6),
          Text(
            l.kTrPanotiBody,
            style: const TextStyle(fontSize: 13.5, height: 1.45),
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
    final scheme = Theme.of(context).colorScheme;
    final brand = context.brand;
    final l = context.l10n;
    final ordered = [
      for (final name in planetOrder)
        ...t.positions.where((p) => p.name == name),
    ];
    return KCard(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Column(
        children: [
          for (var i = 0; i < ordered.length; i++)
            Container(
              decoration: BoxDecoration(
                border: i == ordered.length - 1
                    ? null
                    : Border(bottom: BorderSide(color: scheme.outlineVariant)),
              ),
              padding: const EdgeInsets.symmetric(vertical: 11),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 26,
                    height: 26,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: planetColor(ordered[i].name),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      KundaliStrings.of(context).planetToken(ordered[i].name),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 10,
                      ),
                    ),
                  ),
                  const SizedBox(width: 11),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l.kTrPlanetInSign(
                            KTerms.planetName(l, ordered[i].name),
                            KTerms.signName(l, ordered[i].sign),
                          ),
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13.5,
                          ),
                        ),
                        Text(
                          l.kTransitHouseLine(
                            KTerms.nthHouse(l, ordered[i].houseFromLagna),
                            KTerms.house(
                              l,
                              ordered[i].houseFromLagna,
                            ).toLowerCase(),
                          ),
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: scheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                  if (ordered[i].name == 'Saturn' && t.sadeSatiActive)
                    Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.only(top: 4),
                      decoration: BoxDecoration(
                        color: brand.onTint,
                        shape: BoxShape.circle,
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

class _JupiterCard extends StatelessWidget {
  const _JupiterCard({required this.t});
  final Transits t;

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    final l = context.l10n;
    return KCard(
      child: Row(
        children: [
          Icon(
            t.jupiterFavourable
                ? Icons.check_circle_rounded
                : Icons.remove_circle_outline_rounded,
            color: t.jupiterFavourable ? brand.online : brand.onTint,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              t.jupiterFavourable ? l.kTrJupiterGood : l.kTrJupiterNeutral,
              style: const TextStyle(fontSize: 13, height: 1.4),
            ),
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
    final hits = t.positions.where((p) => p.overNatal.isNotEmpty).toList();
    return KCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.kTrCloseContacts,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 12.5,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 6),
          for (final p in hits)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                l.kTrCloseContactLine(
                  KTerms.planetName(l, p.name),
                  KTerms.displayNames(l, p.overNatal),
                ),
                style: const TextStyle(fontSize: 12.5, height: 1.4),
              ),
            ),
        ],
      ),
    );
  }
}
