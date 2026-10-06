import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:talkacharya_ui/talkacharya_ui.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/settings_widgets.dart';
import '../../../consultations/presentation/widgets/consultation_style.dart';
import '../../data/performance_models.dart';
import '../cubit/performance_cubit.dart';
import '../widgets/band_meter.dart';
import '../widgets/loyal_card.dart';
import '../widgets/perf_format.dart';

/// The full scorecard: every reading on a three-zone meter with what it means
/// and how it moved, hours online day by day, ratings by channel and the
/// requests that got away.
class PerformancePage extends StatelessWidget {
  const PerformancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<PerformanceCubit>()..loadPerformance(),
      child: const _PerformanceView(),
    );
  }
}

class _PerformanceView extends StatelessWidget {
  const _PerformanceView();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final cubit = context.read<PerformanceCubit>();
    final slice = context.select((PerformanceCubit c) => c.state.performance);
    final perf = slice.value;

    return SubPageScaffold(
      title: l.perfTitle,
      subtitle: perf == null ? null : l.perfSubtitle(perf.windowDays),
      onRefresh: cubit.loadPerformance,
      children: slice.when(
        loading: () => const [_PageSkeleton()],
        error: (message) => [
          Padding(
            padding: const EdgeInsets.only(top: 48),
            child: ErrorView(message: message, onRetry: cubit.loadPerformance),
          ),
        ],
        data: (p) => FadeSlideIn.list([
          if (focusTip(l, p.focus) case final tip?) _FocusCard(tip: tip),
          const _Legend(),
          for (final m in p.metrics)
            _MetricCard(
              metric: m,
              chart: m.key == PerfKeys.onlineTime && p.onlineByDay.isNotEmpty
                  ? _OnlineChart(days: p.onlineByDay, goal: m.bands.first)
                  : null,
              footer: m.key == PerfKeys.missed && p.missed.total > 0
                  ? _MissedBreakdown(missed: p.missed)
                  : null,
            ),
          LoyalCard(loyal: p.loyal, windowDays: p.windowDays),
          _RatingsCard(perf: p),
        ], step: const Duration(milliseconds: 50)).map(_spaced).toList(),
      ),
    );
  }

  static Widget _spaced(Widget child) =>
      Padding(padding: const EdgeInsets.only(bottom: 14), child: child);
}

class _FocusCard extends StatelessWidget {
  const _FocusCard({required this.tip});

  final String tip;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const hue = AstroPalette.money;
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: hue.tint(0.12),
        borderRadius: BorderRadius.circular(Radii.md),
        border: Border.all(color: hue.tint(0.35)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.lightbulb_rounded, color: hue.end),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.perfFocusTitle,
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(tip, style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final style = Theme.of(
      context,
    ).textTheme.labelMedium?.copyWith(color: context.brand.inkMuted);
    Widget item(Color color, String label) => Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 18,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        const SizedBox(width: 6),
        Text(label, style: style),
      ],
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Wrap(
        spacing: 18,
        runSpacing: 6,
        children: [
          item(BandColors.low, l.perfLegendLow),
          item(BandColors.mid, l.perfLegendMid),
          item(BandColors.good, l.perfLegendGood),
        ],
      ),
    );
  }
}

/// One reading: value, verdict, meter, movement since the previous window,
/// and an explanation that opens in place.
class _MetricCard extends StatefulWidget {
  const _MetricCard({required this.metric, this.chart, this.footer});

  final PerfMetric metric;
  final Widget? chart;
  final Widget? footer;

  @override
  State<_MetricCard> createState() => _MetricCardState();
}

class _MetricCardState extends State<_MetricCard> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    final theme = Theme.of(context);
    final m = widget.metric;
    final judged = m.band != PerfBand.none;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(Radii.lg),
        border: Border.all(color: brand.hairline),
        boxShadow: brand.shadowWarm,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        metricTitle(l, m.key),
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      VerdictChip(band: m.band),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  judged ? formatMetricValue(l, m) : '—',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: judged ? BandColors.of(m.band, context) : null,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
            child: BandMeter(metric: m),
          ),
          if (judged)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
              child: _Movement(metric: m),
            ),
          if (widget.chart != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: widget.chart,
            ),
          if (widget.footer != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
              child: widget.footer,
            ),
          const SizedBox(height: 6),
          InkWell(
            onTap: () => setState(() => _open = !_open),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 12, 10),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _open ? l.perfShowLess : l.perfHowCalculated,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    turns: _open ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.expand_more_rounded,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            alignment: Alignment.topCenter,
            child: _open
                ? Container(
                    width: double.infinity,
                    color: brand.tint,
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
                    child: Text(
                      metricAbout(l, m.key),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: brand.onTint,
                        height: 1.4,
                      ),
                    ),
                  )
                : const SizedBox(width: double.infinity),
          ),
        ],
      ),
    );
  }
}

/// "▲ 4.2% vs the 15 days before" — green when it is an improvement.
class _Movement extends StatelessWidget {
  const _Movement({required this.metric});

  final PerfMetric metric;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final m = metric;
    final delta = m.value - m.previous;
    final style = Theme.of(context).textTheme.bodySmall;
    if (delta == 0) {
      return Text(
        l.perfNoChange,
        style: style?.copyWith(color: context.brand.inkMuted),
      );
    }
    final better = m.improvement > 0;
    final color = better ? BandColors.good : BandColors.low;
    final amount = switch (m.unit) {
      'percent' => formatPercent(delta.abs()),
      'seconds' => formatDuration(l, delta.abs()),
      _ => delta.abs().round().toString(),
    };
    return Row(
      children: [
        TrendArrow(metric: m, size: 15),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            delta > 0 ? l.perfDeltaUp(amount) : l.perfDeltaDown(amount),
            style: style?.copyWith(color: color, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}

/// Hours online per day across the window, with the daily goal as a line.
class _OnlineChart extends StatelessWidget {
  const _OnlineChart({required this.days, required this.goal});

  final List<OnlineDay> days;

  /// Seconds a day that count as enough (the first cut point).
  final double goal;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    final theme = Theme.of(context);
    final peak = days.fold<double>(
      goal * 1.25,
      (p, d) => d.seconds > p ? d.seconds.toDouble() : p,
    );
    final fmt = DateFormat.d(l.localeName);
    final reduce = MediaQuery.maybeDisableAnimationsOf(context) ?? false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                l.perfOnlineChart,
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Container(width: 14, height: 2, color: brand.inkMuted),
            const SizedBox(width: 6),
            Text(
              l.perfGoalLine((goal / 3600).round()),
              style: theme.textTheme.labelSmall?.copyWith(
                color: brand.inkMuted,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 96,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: reduce
                ? Duration.zero
                : const Duration(milliseconds: 700),
            curve: Curves.easeOutCubic,
            builder: (_, t, _) => CustomPaint(
              size: Size.infinite,
              painter: _BarsPainter(
                values: [for (final d in days) d.seconds.toDouble()],
                goal: goal,
                peak: peak,
                progress: t,
                goalColor: brand.inkMuted,
                idle: brand.hairline,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (final d in [days.first, days[days.length ~/ 2], days.last])
              Text(
                fmt.format(d.day),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: brand.inkMuted,
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _BarsPainter extends CustomPainter {
  const _BarsPainter({
    required this.values,
    required this.goal,
    required this.peak,
    required this.progress,
    required this.goalColor,
    required this.idle,
  });

  final List<double> values;
  final double goal;
  final double peak;
  final double progress;
  final Color goalColor;
  final Color idle;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty || peak <= 0) return;
    final slot = size.width / values.length;
    final barW = (slot * 0.62).clamp(3.0, 18.0);
    for (var i = 0; i < values.length; i++) {
      final v = values[i];
      final x = i * slot + (slot - barW) / 2;
      // A day with nothing still gets a stub, so the gap reads as a day off
      // rather than as missing data.
      final h = v <= 0
          ? 3.0
          : (v / peak * size.height * progress).clamp(3.0, size.height);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, size.height - h, barW, h),
          Radius.circular(barW / 2),
        ),
        Paint()
          ..color = v <= 0
              ? idle
              : v >= goal
              ? BandColors.good
              : BandColors.mid,
      );
    }
    final gy = size.height - goal / peak * size.height;
    final dash = Paint()
      ..color = goalColor
      ..strokeWidth = 1;
    for (var x = 0.0; x < size.width; x += 7) {
      canvas.drawLine(Offset(x, gy), Offset(x + 4, gy), dash);
    }
  }

  @override
  bool shouldRepaint(_BarsPainter old) =>
      old.values != values || old.progress != progress || old.peak != peak;
}

class _MissedBreakdown extends StatelessWidget {
  const _MissedBreakdown({required this.missed});

  final MissedStats missed;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        if (missed.unanswered > 0)
          _Pill(
            icon: Icons.timer_off_rounded,
            label: l.perfMissedUnanswered(missed.unanswered),
          ),
        if (missed.declined > 0)
          _Pill(
            icon: Icons.block_rounded,
            label: l.perfMissedDeclined(missed.declined),
          ),
        for (final e in missed.byChannel.entries)
          _Pill(
            icon: channelStyle(context, e.key).icon,
            label: '${channelStyle(context, e.key).label} · ${e.value}',
          ),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 5, 10, 5),
      decoration: BoxDecoration(
        color: brand.tint,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: brand.onTint),
          const SizedBox(width: 5),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: brand.onTint,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

/// Lifetime rating overall and per channel, each as a bar out of five.
class _RatingsCard extends StatelessWidget {
  const _RatingsCard({required this.perf});

  final Performance perf;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final overall = perf.overallRating;
    return SettingsCard(
      title: l.perfRatings,
      subtitle: l.perfRatingsAbout,
      icon: Icons.star_rounded,
      child: overall.count == 0
          ? Text(
              l.perfNoRatings,
              style: TextStyle(color: context.brand.inkMuted),
            )
          : Column(
              children: [
                _RatingRow(label: l.perfRatingOverall, stat: overall),
                for (final ch in const ['chat', 'voice', 'video'])
                  if (perf.ratingByChannel[ch] case final stat?)
                    _RatingRow(
                      label: channelStyle(context, ch).label,
                      stat: stat,
                    ),
              ],
            ),
    );
  }
}

class _RatingRow extends StatelessWidget {
  const _RatingRow({required this.label, required this.stat});

  final String label;
  final RatingStat stat;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    final theme = Theme.of(context);
    // Same reading as the meters: a 4.5+ is green, under 4 needs work.
    final color = stat.avg >= 4.5
        ? BandColors.good
        : stat.avg >= 4
        ? BandColors.mid
        : BandColors.low;
    final reduce = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                l.perfRatingCount(stat.count),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: brand.inkMuted,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                stat.avg.toStringAsFixed(2),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: (stat.avg / 5).clamp(0.0, 1.0)),
              duration: reduce
                  ? Duration.zero
                  : const Duration(milliseconds: 800),
              curve: Curves.easeOutCubic,
              builder: (_, t, _) => LinearProgressIndicator(
                value: t,
                minHeight: 8,
                color: color,
                backgroundColor: color.withValues(alpha: 0.16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PageSkeleton extends StatelessWidget {
  const _PageSkeleton();

  @override
  Widget build(BuildContext context) {
    return const AppShimmer(
      child: Column(
        children: [
          SkeletonBox(height: 64, radius: 16),
          SizedBox(height: 14),
          SkeletonBox(height: 170, radius: 20),
          SizedBox(height: 14),
          SkeletonBox(height: 170, radius: 20),
          SizedBox(height: 14),
          SkeletonBox(height: 170, radius: 20),
        ],
      ),
    );
  }
}
