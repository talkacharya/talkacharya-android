import 'package:astro_kundali/astro_kundali.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/astro_palette.dart';
import '../../../../core/theme/brand_colors.dart';
import '../cubit/kundali_cubit.dart';
import '../kundali_terms.dart';
import '../widgets/kundali_ui.dart';
import '../widgets/sade_sati_card.dart';

/// Dated Sade Sati / Dhaiya calendar (`/sade-sati`). A map of Saturn's transit
/// windows over the lifetime — traditional themes and years, not events.
class SadeSatiPage extends StatefulWidget {
  const SadeSatiPage({required this.profileId, super.key});
  final String profileId;

  @override
  State<SadeSatiPage> createState() => _SadeSatiPageState();
}

class _SadeSatiPageState extends State<SadeSatiPage> {
  @override
  void initState() {
    super.initState();
    context.read<KundaliCubit>().loadSadeSati();
  }

  static String phaseLabel(AppLocalizations l, String phase) => switch (phase) {
    'rising' => l.sadeSatiPhaseRising,
    'peak' => l.sadeSatiPhasePeak,
    'setting' => l.sadeSatiPhaseSetting,
    'kantaka' => l.sadeSatiPhaseKantaka,
    'ashtama' => l.sadeSatiPhaseAshtama,
    _ => phase,
  };

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return BlocBuilder<KundaliCubit, KundaliState>(
      buildWhen: (a, b) => a.sadeSati != b.sadeSati,
      builder: (context, state) {
        final cubit = context.read<KundaliCubit>();
        final cal = state.sadeSati.value;
        final current = cal?.current;
        final hue = current != null ? AstroPalette.money : AstroPalette.air;

        return KundaliScaffold(
          title: l.sadeSatiTitle,
          eyebrow: l.kSsEyebrow,
          headline: l.sadeSatiTitle,
          subheadline: current == null
              ? null
              : '${phaseLabel(l, current.phase)} · ${l.sadeSatiRange(current.start, current.end)}',
          hue: hue,
          heroTrailing: const PlanetBadge('Saturn', size: 70),
          heroChips: cal == null
              ? const []
              : [
                  if (cal.natalMoonSign.isNotEmpty)
                    KHeroChip(
                      icon: Icons.nightlight_round,
                      label: l.kOvMoonChip(
                        KTerms.signName(l, cal.natalMoonSign),
                      ),
                    ),
                  KHeroChip(
                    icon: current != null
                        ? Icons.brightness_3_rounded
                        : Icons.check_circle_rounded,
                    label: current != null
                        ? l.sadeSatiRunningNow
                        : l.kSsNotRunning,
                    color: current != null
                        ? AstroPalette.money.start
                        : AstroPalette.health.start,
                  ),
                ],
          onRefresh: () => cubit.loadSadeSati(force: true),
          animate: cal != null,
          children: cal == null
              ? [
                  SliceBuilder<SadeSatiCalendar>(
                    slice: state.sadeSati,
                    onRetry: () => cubit.loadSadeSati(force: true),
                    skeleton: const KBodySkeleton(blocks: [150, 200, 200]),
                    builder: (_, _) => const SizedBox.shrink(),
                  ),
                ]
              : [
                  Text(
                    l.sadeSatiIntro(KTerms.signName(l, cal.natalMoonSign)),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: context.brand.inkMuted,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 14),
                  if (current != null)
                    _NowCard(
                      phase: current,
                      label: phaseLabel(l, current.phase),
                    )
                  else if (cal.summary.isNotEmpty)
                    ReadingCard(body: cal.summary, hue: AstroPalette.health),
                  if (cal.sadeSatiPeriods.isNotEmpty)
                    KSection(
                      title: l.kSsLifetimeTitle,
                      hue: AstroPalette.money,
                      child: Column(
                        children: [
                          for (final period in cal.sadeSatiPeriods)
                            _PeriodCard(period: period),
                        ],
                      ),
                    ),
                  if (cal.dhaiyaPeriods.isNotEmpty)
                    KSection(
                      title: l.sadeSatiDhaiyaHeading,
                      hue: AstroPalette.air,
                      child: Column(
                        children: [
                          for (final d in cal.dhaiyaPeriods)
                            _PhaseTile(phase: d, label: phaseLabel(l, d.phase)),
                        ],
                      ),
                    ),
                  if (cal.disclaimer.isNotEmpty) KFootnote(cal.disclaimer),
                  const KAskCta(),
                ],
        );
      },
    );
  }
}

String _status(AppLocalizations l, bool running, bool past) => running
    ? l.sadeSatiRunningNow
    : past
    ? l.sadeSatiPast
    : l.sadeSatiUpcoming;

KTone _tone(bool running, bool past) => running
    ? KTone.caution
    : past
    ? KTone.neutral
    : KTone.good;

class _NowCard extends StatelessWidget {
  const _NowCard({required this.phase, required this.label});
  final SadeSatiPhase phase;
  final String label;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    const phases = ['rising', 'peak', 'setting'];
    final idx = phases.indexOf(phase.phase);
    return KHueCard(
      hue: AstroPalette.money,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 6,
            children: [
              KToneChip(l.sadeSatiRunningNow, tone: KTone.caution),
              Text(
                l.sadeSatiRange(phase.start, phase.end),
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AstroPalette.money.end,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            label,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          if (idx >= 0) ...[
            const SizedBox(height: 12),
            SaturnPhaseStepper(
              labels: [l.kSsRising, l.kSsPeak, l.kSsSetting],
              active: idx,
            ),
          ],
          const SizedBox(height: 12),
          Text(
            phase.summary,
            style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
          ),
        ],
      ),
    );
  }
}

class _PeriodCard extends StatelessWidget {
  const _PeriodCard({required this.period});
  final SadeSatiPeriod period;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    return KExpandable(
      initiallyOpen: period.running,
      hue: period.running ? AstroPalette.money : null,
      header: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: period.past ? null : AstroPalette.money.linear(),
              color: period.past ? context.brand.hairline : null,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              period.start.length >= 4 ? period.start.substring(0, 4) : '—',
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w800,
                color: period.past ? context.brand.inkMuted : Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  period.signs.map((s) => KTerms.signName(l, s)).join(' → '),
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  l.sadeSatiRange(period.start, period.end),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: context.brand.inkMuted,
                  ),
                ),
              ],
            ),
          ),
          KToneChip(
            _status(l, period.running, period.past),
            tone: _tone(period.running, period.past),
          ),
        ],
      ),
      body: Column(
        children: [
          for (final ph in period.phases)
            _PhaseTile(
              phase: ph,
              label: _SadeSatiPageState.phaseLabel(l, ph.phase),
              dense: true,
            ),
        ],
      ),
    );
  }
}

class _PhaseTile extends StatelessWidget {
  const _PhaseTile({
    required this.phase,
    required this.label,
    this.dense = false,
  });
  final SadeSatiPhase phase;
  final String label;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final hue = phase.running ? AstroPalette.money : AstroPalette.air;
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            KToneChip(
              _status(l, phase.running, phase.past),
              tone: _tone(phase.running, phase.past),
            ),
          ],
        ),
        Text(
          l.sadeSatiRange(phase.start, phase.end),
          style: theme.textTheme.labelMedium?.copyWith(
            color: context.brand.inkMuted,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          phase.summary,
          style: theme.textTheme.bodySmall?.copyWith(height: 1.45),
        ),
      ],
    );
    if (dense) {
      return Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: phase.running ? hue.tint(0.12) : context.brand.sectionBg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: content,
      );
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: KSurface(
        radius: 16,
        padding: const EdgeInsets.all(14),
        child: content,
      ),
    );
  }
}
