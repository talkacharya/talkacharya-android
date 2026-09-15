import 'package:astro_kundali/astro_kundali.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/brand_colors.dart';
import '../cubit/kundali_cubit.dart';
import '../kundali_terms.dart';
import '../widgets/kundali_ui.dart';

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

  String _phaseLabel(AppLocalizations l, String phase) => switch (phase) {
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
    return Scaffold(
      appBar: AppBar(title: Text(l.sadeSatiTitle)),
      body: BlocBuilder<KundaliCubit, KundaliState>(
        buildWhen: (a, b) => a.sadeSati != b.sadeSati,
        builder: (context, state) => SliceBuilder<SadeSatiCalendar>(
          slice: state.sadeSati,
          onRetry: () => context.read<KundaliCubit>().loadSadeSati(),
          builder: (context, cal) {
            final theme = Theme.of(context);
            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 28),
              children: [
                Text(
                  l.sadeSatiIntro(cal.natalMoonSign),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 14),
                if (cal.current != null) ...[
                  _NowCard(
                    phase: cal.current!,
                    label: _phaseLabel(l, cal.current!.phase),
                  ),
                  const SizedBox(height: 12),
                ] else if (cal.summary.isNotEmpty) ...[
                  KCard(
                    child: Text(
                      cal.summary,
                      style: const TextStyle(fontSize: 13, height: 1.45),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                for (final period in cal.sadeSatiPeriods) ...[
                  _PeriodCard(
                    period: period,
                    phaseLabel: (p) => _phaseLabel(l, p),
                  ),
                  const SizedBox(height: 10),
                ],
                if (cal.dhaiyaPeriods.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    l.sadeSatiDhaiyaHeading,
                    style: theme.textTheme.titleMedium?.copyWith(fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  for (final d in cal.dhaiyaPeriods) ...[
                    _DhaiyaRow(phase: d, label: _phaseLabel(l, d.phase)),
                    const SizedBox(height: 8),
                  ],
                ],
                const SizedBox(height: 8),
                Text(
                  cal.disclaimer,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _NowCard extends StatelessWidget {
  const _NowCard({required this.phase, required this.label});
  final SadeSatiPhase phase;
  final String label;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return KCard(
      tint: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.brightness_3_rounded,
                size: 18,
                color: context.brand.onTint,
              ),
              const SizedBox(width: 8),
              Text(
                l.sadeSatiRunningNow,
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 12.5,
                  color: context.brand.onTint,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5),
          ),
          Text(
            l.sadeSatiRange(phase.start, phase.end),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            phase.summary,
            style: const TextStyle(fontSize: 13, height: 1.45),
          ),
        ],
      ),
    );
  }
}

class _PeriodCard extends StatelessWidget {
  const _PeriodCard({required this.period, required this.phaseLabel});
  final SadeSatiPeriod period;
  final String Function(String) phaseLabel;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final status = period.running
        ? l.sadeSatiRunningNow
        : period.past
        ? l.sadeSatiPast
        : l.sadeSatiUpcoming;
    return KCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '${l.kTrSadeSati} · '
                  '${period.signs.map((s) => KTerms.signName(l, s)).join(" → ")}',
                  style: theme.textTheme.titleMedium?.copyWith(fontSize: 14),
                ),
              ),
              _StatusChip(
                text: status,
                running: period.running,
                past: period.past,
              ),
            ],
          ),
          Text(
            l.sadeSatiRange(period.start, period.end),
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          for (final ph in period.phases)
            Container(
              margin: const EdgeInsets.only(bottom: 6),
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: ph.running
                    ? theme.colorScheme.primaryContainer.withValues(alpha: 0.5)
                    : theme.colorScheme.surfaceContainerHighest.withValues(
                        alpha: 0.35,
                      ),
                borderRadius: BorderRadius.circular(9),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    phaseLabel(ph.phase),
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    l.sadeSatiRange(ph.start, ph.end),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    ph.summary,
                    style: const TextStyle(fontSize: 11.5, height: 1.4),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _DhaiyaRow extends StatelessWidget {
  const _DhaiyaRow({required this.phase, required this.label});
  final SadeSatiPhase phase;
  final String label;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    return KCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 12.5,
                  ),
                ),
              ),
              _StatusChip(
                text: phase.running
                    ? l.sadeSatiRunningNow
                    : phase.past
                    ? l.sadeSatiPast
                    : l.sadeSatiUpcoming,
                running: phase.running,
                past: phase.past,
              ),
            ],
          ),
          Text(
            l.sadeSatiRange(phase.start, phase.end),
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            phase.summary,
            style: const TextStyle(fontSize: 11.5, height: 1.4),
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({
    required this.text,
    required this.running,
    required this.past,
  });
  final String text;
  final bool running;
  final bool past;

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = running
        ? (const Color(0xFFFBEBD8), const Color(0xFFB0691F))
        : past
        ? (const Color(0xFFECECEF), const Color(0xFF5B5B62))
        : (const Color(0xFFDDF0E4), const Color(0xFF2C6B45));
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: fg),
      ),
    );
  }
}
