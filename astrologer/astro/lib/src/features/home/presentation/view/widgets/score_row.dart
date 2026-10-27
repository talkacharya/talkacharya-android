import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:talkacharya_ui/talkacharya_ui.dart';

import '../../../../../core/l10n/l10n.dart';
import '../../../../../core/router/routes.dart';
import '../../../../performance/data/performance_models.dart';
import '../../../../performance/presentation/cubit/performance_cubit.dart';
import '../../../../performance/presentation/view/performance_page.dart';
import '../../../../performance/presentation/widgets/perf_format.dart';
import 'dash_shared.dart';

/// The scorecard in four small tiles — online per day, average session,
/// first-time repeat, loyal customers — each in its verdict colour with
/// which way it is moving, then the three readings that most need work as
/// their full cards. "See all" opens the performance dashboard.
class ScoreRow extends StatelessWidget {
  const ScoreRow({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final slice = context.select((PerformanceCubit c) => c.state.performance);
    final perf = slice.value;
    // A failed load already shows its retry on the Today card.
    if (perf == null && slice.isError) return const SizedBox.shrink();

    final online = perf?.metric(PerfKeys.onlineTime);
    final session = perf?.metric(PerfKeys.avgSession);
    final firstRepeat = perf?.metric(PerfKeys.firstRepeat);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DashLabel(
          title: l.homeScorecard,
          subtitle: perf == null ? null : l.scoreTitle(perf.windowDays),
          onSeeAll: () => context.push(Routes.performance),
        ),
        const SizedBox(height: 4),
        Padding(
          // Each tile pads itself by 3, so the row lines up with the cards.
          padding: const EdgeInsets.symmetric(horizontal: DashGaps.side - 3),
          child: perf == null
              ? const AppShimmer(child: SkeletonBox(height: 66, radius: 14))
              : IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (online != null)
                        _ScoreCell(
                          metric: online,
                          value: formatTick(l, online, online.value),
                          label: l.perfOnlineShort,
                        ),
                      if (session != null)
                        _ScoreCell(
                          metric: session,
                          value: l.perfMinutes(session.value ~/ 60),
                          label: l.perfSessionShort,
                        ),
                      if (firstRepeat != null)
                        _ScoreCell(
                          metric: firstRepeat,
                          value: '${firstRepeat.value.round()}%',
                          label: l.perfFirstRepeatShort,
                        ),
                      _LoyalCell(loyal: perf.loyal),
                    ],
                  ),
                ),
        ),
        if (perf != null) _MeterStrip(perf: perf),
      ],
    );
  }
}

/// How many readings Home shows in full.
const _homeMeters = 3;

/// The readings that most need work first (low, then moderate, then good),
/// each as its full scorecard card, one under the other.
class _MeterStrip extends StatelessWidget {
  const _MeterStrip({required this.perf});

  final Performance perf;

  @override
  Widget build(BuildContext context) {
    // Weakest band first; within a band, the server's order (sort is not
    // stable, so the index breaks ties).
    final judged =
        [
          for (final (i, m) in perf.metrics.indexed)
            if (m.band != PerfBand.none) (i, m),
        ]..sort((a, b) {
          final byBand = a.$2.band.index.compareTo(b.$2.band.index);
          return byBand != 0 ? byBand : a.$1.compareTo(b.$1);
        });
    final shown = [for (final (_, m) in judged.take(_homeMeters)) m];
    if (shown.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(DashGaps.side, 12, DashGaps.side, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < shown.length; i++) ...[
            if (i > 0) const SizedBox(height: 10),
            MetricCard.of(
              perf,
              shown[i],
              onTap: () => context.push(Routes.performance),
              key: ValueKey(shown[i].key),
            ),
          ],
        ],
      ),
    );
  }
}

class _ScoreCell extends StatelessWidget {
  const _ScoreCell({
    required this.metric,
    required this.value,
    required this.label,
  });

  final PerfMetric metric;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) => _Cell(
    value: metric.band == PerfBand.none ? '—' : value,
    color: BandColors.of(metric.band, context),
    arrow: TrendArrow(metric: metric),
    label: label,
  );
}

class _LoyalCell extends StatelessWidget {
  const _LoyalCell({required this.loyal});

  final LoyalStats loyal;

  @override
  Widget build(BuildContext context) {
    final delta = loyal.percent - loyal.previous;
    final empty = loyal.customers == 0;
    return _Cell(
      value: empty ? '—' : '${loyal.percent.round()}%',
      color: empty
          ? context.brand.inkMuted
          : Theme.of(context).colorScheme.primary,
      arrow: empty || delta == 0
          ? const SizedBox.shrink()
          : Icon(
              delta > 0
                  ? Icons.arrow_upward_rounded
                  : Icons.arrow_downward_rounded,
              size: 14,
              color: delta > 0 ? BandColors.good : BandColors.low,
            ),
      label: context.l10n.perfLoyalShort,
    );
  }
}

/// One small tile; the row gives each an equal share with a gap between.
class _Cell extends StatelessWidget {
  const _Cell({
    required this.value,
    required this.color,
    required this.arrow,
    required this.label,
  });

  final String value;
  final Color color;
  final Widget arrow;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brand = context.brand;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: Container(
          padding: const EdgeInsets.fromLTRB(6, 10, 6, 8),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: brand.hairline),
          ),
          child: Column(
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      value,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: color,
                      ),
                    ),
                    arrow,
                  ],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                maxLines: 2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: brand.inkMuted,
                  height: 1.15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
