import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/util/amount_privacy.dart';
import '../../../../core/util/money.dart';
import '../../../home/data/dashboard_api.dart';
import '../../../home/data/dashboard_models.dart';

import 'package:talkacharya_ui/talkacharya_ui.dart';

/// The windows the trend card offers.
const kTrendPeriods = [7, 30, 90];

/// Net earnings over the last 7 / 30 / 90 days with a daily line, and the
/// gross / platform-fee split under the figure.
class EarningsTrendCard extends StatefulWidget {
  const EarningsTrendCard({required this.currency, this.api, super.key});

  final String currency;

  /// Defaults to the app's [DashboardApi].
  final DashboardApi? api;

  @override
  State<EarningsTrendCard> createState() => _EarningsTrendCardState();
}

class _EarningsTrendCardState extends State<EarningsTrendCard> {
  late final DashboardApi _api = widget.api ?? getIt<DashboardApi>();
  int _days = 7;
  DashboardStats? _stats;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final days = _days;
    setState(() => _failed = false);
    try {
      final stats = await _api.stats(days: days);
      // Dropped when the window was switched while this was on its way.
      if (mounted && days == _days) setState(() => _stats = stats);
    } catch (_) {
      if (mounted && days == _days) setState(() => _failed = true);
    }
  }

  void _pick(int days) {
    if (days == _days) return;
    setState(() => _days = days);
    _load();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    final theme = Theme.of(context);
    final privacy = getIt<AmountPrivacy>();
    final cur = widget.currency;
    final s = _stats;

    final Widget body;
    if (s == null && _failed) {
      body = Row(
        children: [
          Expanded(
            child: Text(
              l.dashLoadFailed,
              style: theme.textTheme.bodySmall?.copyWith(color: brand.inkMuted),
            ),
          ),
          TextButton(onPressed: _load, child: Text(l.commonRetry)),
        ],
      );
    } else if (s == null) {
      body = const AppShimmer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SkeletonBox(width: 120, height: 26, radius: 8),
            SizedBox(height: 8),
            SkeletonBox(height: 64, radius: 12),
          ],
        ),
      );
    } else {
      body = ListenableBuilder(
        listenable: privacy,
        builder: (context, _) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              privacy.mask(Money.format(s.net.roundToDouble(), cur)),
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(
              '${l.dashGross(privacy.mask(Money.format(s.gross, cur)))}'
              '  ·  '
              '${l.dashFee(privacy.mask(Money.format(s.commission, cur)))}',
              style: theme.textTheme.bodySmall?.copyWith(color: brand.inkMuted),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 64,
              child: s.trend.length < 2
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
                      key: ValueKey(s.windowDays),
                      tween: Tween(begin: 0, end: 1),
                      duration: const Duration(milliseconds: 700),
                      curve: Curves.easeOutCubic,
                      builder: (_, t, _) => CustomPaint(
                        size: Size.infinite,
                        painter: SparklinePainter(
                          values: [for (final p in s.trend) p.value],
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

    return Card(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    l.dashEarningsTitle,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                _PeriodPicker(value: _days, onChanged: _pick),
              ],
            ),
            const SizedBox(height: 8),
            body,
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
          for (final d in kTrendPeriods)
            Semantics(
              button: true,
              selected: d == value,
              child: GestureDetector(
                onTap: () => onChanged(d),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
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
