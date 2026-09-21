import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/l10n/l10n.dart';
import '../../../../../core/router/routes.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/theme/brand_colors.dart';
import '../../../../../core/util/money.dart';
import '../../../../../shared/widgets/pressable.dart';
import '../../../../../shared/widgets/skeleton.dart';
import '../../../data/dashboard_models.dart';
import '../../cubit/dashboard_cubit.dart';
import 'dash_shared.dart';

/// Net earnings for the selected window with a daily sparkline, and the
/// payout balance underneath (→ Earnings tab).
class EarningsCard extends StatelessWidget {
  const EarningsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    final theme = Theme.of(context);
    final state = context.watch<DashboardCubit>().state;
    final currency = state.payouts.value?.currency ?? 'INR';

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 16, 12, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l.dashEarningsTitle,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          l.dashLastDays(state.period),
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: brand.inkMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _PeriodPicker(
                    value: state.period,
                    onChanged: context.read<DashboardCubit>().setPeriod,
                  ),
                ],
              ),
            ),
            SectionSwitcher(
              child: state.stats.when(
                loading: () => const _StatsSkeleton(key: ValueKey('sk')),
                error: (_) => Padding(
                  key: const ValueKey('err'),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: SectionError(
                    onRetry: context.read<DashboardCubit>().loadStats,
                  ),
                ),
                data: (s) => _StatsBody(
                  key: const ValueKey('data'),
                  stats: s,
                  currency: currency,
                ),
              ),
            ),
            _PayoutStrip(summary: state.payouts.value),
          ],
        ),
      ),
    );
  }
}

class _StatsBody extends StatelessWidget {
  const _StatsBody({required this.stats, required this.currency, super.key});

  final DashboardStats stats;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(end: stats.net),
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOutCubic,
            builder: (_, v, _) => Text(
              Money.format(v.roundToDouble(), currency),
              style: theme.textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '${l.dashGross(Money.format(stats.gross, currency))}  ·  '
            '${l.dashFee(Money.format(stats.commission, currency))}',
            style: theme.textTheme.bodySmall?.copyWith(color: brand.inkMuted),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 76,
            child: stats.trend.length < 2
                ? Center(
                    child: Text(
                      l.dashNoTrend,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: brand.inkMuted,
                      ),
                    ),
                  )
                : TweenAnimationBuilder<double>(
                    key: ValueKey(stats.windowDays),
                    tween: Tween(begin: 0, end: 1),
                    duration: const Duration(milliseconds: 700),
                    curve: Curves.easeOutCubic,
                    builder: (_, t, _) => CustomPaint(
                      size: Size.infinite,
                      painter: SparklinePainter(
                        values: [for (final p in stats.trend) p.value],
                        color: theme.colorScheme.primary,
                        progress: t,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _StatsSkeleton extends StatelessWidget {
  const _StatsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(18, 14, 18, 14),
      child: AppShimmer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SkeletonBox(width: 150, height: 34, radius: 8),
            SizedBox(height: 8),
            SkeletonBox(width: 200),
            SizedBox(height: 14),
            SkeletonBox(height: 76, radius: 12),
          ],
        ),
      ),
    );
  }
}

class _PeriodPicker extends StatelessWidget {
  const _PeriodPicker({required this.value, required this.onChanged});

  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: brand.tint,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final d in kDashboardPeriods)
            Semantics(
              button: true,
              selected: d == value,
              child: GestureDetector(
                onTap: () => onChanged(d),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: d == value ? scheme.primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    context.l10n.dashPeriodChip(d),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: d == value ? scheme.onPrimary : brand.onTint,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _PayoutStrip extends StatelessWidget {
  const _PayoutStrip({required this.summary});

  final PayoutSummary? summary;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    final theme = Theme.of(context);
    final s = summary;
    return Pressable(
      child: Material(
        color: brand.tint,
        child: InkWell(
          onTap: () => context.go(Routes.earnings),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 12, 12, 12),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(colors: BrandColors.goldGradient),
                  ),
                  child: const Icon(
                    Icons.account_balance_wallet_rounded,
                    size: 20,
                    color: Color(0xFF3A1703),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l.dashAvailable,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: brand.onTint,
                        ),
                      ),
                      if (s == null)
                        const Padding(
                          padding: EdgeInsets.only(top: 4),
                          child: AppShimmer(
                            child: SkeletonBox(width: 90, height: 18),
                          ),
                        )
                      else
                        Text(
                          Money.format(s.available, s.currency),
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                    ],
                  ),
                ),
                if (s != null && s.pending > 0)
                  Text(
                    l.dashPending(Money.format(s.pending, s.currency)),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: brand.inkMuted,
                    ),
                  ),
                Icon(Icons.chevron_right_rounded, color: brand.onTint),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Smooth filled line of daily values. [progress] 0→1 draws it in from the
/// left. Pure painter, no chart dependency.
class SparklinePainter extends CustomPainter {
  const SparklinePainter({
    required this.values,
    required this.color,
    this.progress = 1,
  });

  final List<double> values;
  final Color color;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.length < 2) return;
    final maxV = values.reduce(math.max);
    final minV = math.min(0.0, values.reduce(math.min));
    final span = (maxV - minV) == 0 ? 1.0 : maxV - minV;
    const pad = 6.0;
    final h = size.height - pad * 2;
    final dx = size.width / (values.length - 1);
    final pts = [
      for (var i = 0; i < values.length; i++)
        Offset(i * dx, pad + h - (values[i] - minV) / span * h),
    ];

    final line = Path()..moveTo(pts.first.dx, pts.first.dy);
    for (var i = 1; i < pts.length; i++) {
      final a = pts[i - 1];
      final b = pts[i];
      final mid = (a.dx + b.dx) / 2;
      line.cubicTo(mid, a.dy, mid, b.dy, b.dx, b.dy);
    }
    final fill = Path.from(line)
      ..lineTo(pts.last.dx, size.height)
      ..lineTo(pts.first.dx, size.height)
      ..close();

    canvas.save();
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width * progress, size.height));
    canvas.drawPath(
      fill,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [color.withValues(alpha: 0.28), color.withValues(alpha: 0)],
        ).createShader(Offset.zero & size),
    );
    canvas.drawPath(
      line,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round
        ..color = color,
    );
    canvas.restore();

    if (progress >= 1) {
      final last = pts.last;
      canvas.drawCircle(last, 6, Paint()..color = color.withValues(alpha: 0.2));
      canvas.drawCircle(last, 3.5, Paint()..color = color);
    }
  }

  @override
  bool shouldRepaint(SparklinePainter old) =>
      old.values != values || old.color != color || old.progress != progress;
}
