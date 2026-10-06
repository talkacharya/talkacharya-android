import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:talkacharya_ui/talkacharya_ui.dart';

import '../../../../../core/di/service_locator.dart';
import '../../../../../core/l10n/l10n.dart';
import '../../../../../core/router/routes.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/util/amount_privacy.dart';
import '../../../../../core/util/money.dart';
import '../../../../../core/util/time_format.dart';
import '../../../../../core/utils/haptic_service.dart';
import '../../../../performance/data/performance_models.dart';
import '../../../../performance/presentation/cubit/performance_cubit.dart';
import '../../../../performance/presentation/widgets/perf_format.dart';
import 'dash_shared.dart';

/// Today at a glance, then the scorecard in four numbers: what was earned
/// today (maskable), today's sessions / talk time / hours online, and the
/// headline readings of the last window with which way each is moving.
/// Opens the full performance dashboard.
class TodayPulseCard extends StatelessWidget {
  const TodayPulseCard({super.key});

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    final theme = Theme.of(context);
    final slice = context.select((PerformanceCubit c) => c.state.performance);

    return Padding(
      padding: DashGaps.sidePad,
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(Radii.lg),
          border: Border.all(color: brand.hairline),
          boxShadow: brand.shadowWarm,
        ),
        clipBehavior: Clip.antiAlias,
        child: SectionSwitcher(
          child: slice.when(
            loading: () => const _Skeleton(key: ValueKey('sk')),
            error: (_) => Padding(
              key: const ValueKey('err'),
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: SectionError(
                onRetry: context.read<PerformanceCubit>().loadPerformance,
              ),
            ),
            data: (p) => _Body(key: const ValueKey('data'), perf: p),
          ),
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.perf, super.key});

  final Performance perf;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    final theme = Theme.of(context);
    final today = perf.today;
    final privacy = getIt<AmountPrivacy>();

    final online = perf.metric(PerfKeys.onlineTime);
    final session = perf.metric(PerfKeys.avgSession);
    final firstRepeat = perf.metric(PerfKeys.firstRepeat);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 16, 8, 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l.todayTitle,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      l.todaySub,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: brand.inkMuted,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () => context.go(Routes.earnings),
                child: Text(l.todayViewEarnings),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 4, 8, 0),
          child: ValueListenableBuilder<bool>(
            valueListenable: privacy,
            builder: (_, hidden, _) => Row(
              children: [
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    layoutBuilder: (current, previous) => Stack(
                      alignment: Alignment.centerLeft,
                      children: [...previous, ?current],
                    ),
                    child: Text(
                      privacy.mask(
                        Money.format(today.net.roundToDouble(), today.currency),
                      ),
                      key: ValueKey(hidden),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  tooltip: hidden ? l.todayShow : l.todayHide,
                  onPressed: () {
                    HapticService.selection();
                    privacy.toggle();
                  },
                  icon: Icon(
                    hidden
                        ? Icons.visibility_off_rounded
                        : Icons.visibility_rounded,
                    color: brand.inkMuted,
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 16),
          child: Row(
            children: [
              _TodayStat(
                icon: Icons.forum_rounded,
                hue: AstroPalette.career,
                value: '${today.sessions}',
                label: l.todaySessions,
              ),
              _TodayStat(
                icon: Icons.timer_rounded,
                hue: AstroPalette.air,
                value: l.perfMinutes(today.minutes),
                label: l.todayTalkTime,
              ),
              _TodayStat(
                icon: Icons.wifi_tethering_rounded,
                hue: AstroPalette.health,
                value: formatDuration(l, today.onlineSeconds ~/ 60 * 60),
                label: l.todayOnline,
              ),
            ],
          ),
        ),
        Divider(height: 1, color: brand.hairline),
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 4),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  l.scoreTitle(perf.windowDays),
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (perf.updatedAt != null)
                Text(
                  l.scoreUpdated(TimeFormat.relative(l, perf.updatedAt)),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: brand.inkMuted,
                  ),
                ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 8, 10, 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
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
        Pressable(
          child: Material(
            color: brand.tint,
            child: InkWell(
              onTap: () => context.push(Routes.performance),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 13),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      l.scoreOpen,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: brand.onTint,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 18,
                      color: brand.onTint,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _TodayStat extends StatelessWidget {
  const _TodayStat({
    required this.icon,
    required this.hue,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final AstroHue hue;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Row(
        children: [
          HueIcon(hue: hue, icon: icon, size: 30, iconSize: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: context.brand.inkMuted,
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

/// One headline reading: the value in its verdict colour, an arrow for the
/// direction since the previous window, and a two-line label.
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
              size: 16,
              color: delta > 0 ? BandColors.good : BandColors.low,
            ),
      label: context.l10n.perfLoyalShort,
    );
  }
}

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
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    value,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
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
                color: context.brand.inkMuted,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Skeleton extends StatelessWidget {
  const _Skeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(18),
      child: AppShimmer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SkeletonBox(width: 130, height: 16),
            SizedBox(height: 12),
            SkeletonBox(width: 160, height: 34, radius: 8),
            SizedBox(height: 16),
            SkeletonBox(height: 30, radius: 8),
            SizedBox(height: 20),
            SkeletonBox(height: 52, radius: 12),
          ],
        ),
      ),
    );
  }
}
