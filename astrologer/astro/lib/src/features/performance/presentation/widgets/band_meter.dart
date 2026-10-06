import 'package:flutter/material.dart';
import 'package:talkacharya_ui/talkacharya_ui.dart';

import '../../../../core/l10n/l10n.dart';
import '../../data/performance_models.dart';
import 'perf_format.dart';

/// A three-zone track — needs work, moderate, good — with a knob where the
/// reading sits and the cut points labelled underneath.
///
/// The zones are drawn as equal thirds whatever the scale, and the reading is
/// placed proportionally *within* its zone: with cut points at 25% and 32% of
/// a 0–100 scale a true-to-scale track would squeeze "moderate" to a sliver.
class BandMeter extends StatelessWidget {
  const BandMeter({required this.metric, this.showScale = true, super.key});

  final PerfMetric metric;
  final bool showScale;

  /// 0–1 along the track for [value].
  static double position(PerfMetric m, double value) {
    if (m.bands.length < 2 || m.max <= 0) return 0;
    final stops = [0.0, m.bands[0], m.bands[1], m.max];
    final v = value.clamp(0.0, m.max);
    for (var i = 0; i < 3; i++) {
      final lo = stops[i];
      final hi = stops[i + 1];
      if (v <= hi || i == 2) {
        final span = hi - lo;
        final within = span <= 0 ? 0.0 : ((v - lo) / span).clamp(0.0, 1.0);
        return (i + within) / 3;
      }
    }
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    final m = metric;
    // Which third is the good one flips for "lower is better" readings.
    final zones = m.lowerIsBetter
        ? const [BandColors.good, BandColors.mid, BandColors.low]
        : const [BandColors.low, BandColors.mid, BandColors.good];
    final judged = m.band != PerfBand.none;
    final active = switch (m.band) {
      PerfBand.none => -1,
      PerfBand.mid => 1,
      PerfBand.low => m.lowerIsBetter ? 2 : 0,
      PerfBand.good => m.lowerIsBetter ? 0 : 2,
    };
    final target = judged ? position(m, m.value) : 0.0;
    final reduce = MediaQuery.maybeDisableAnimationsOf(context) ?? false;

    final labelStyle = Theme.of(
      context,
    ).textTheme.labelSmall?.copyWith(color: brand.inkMuted);

    return Semantics(
      label:
          '${metricTitle(l, m.key)}: ${formatMetricValue(l, m)}, '
          '${verdict(l, m.band)}',
      child: ExcludeSemantics(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 22,
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: target),
                duration: reduce
                    ? Duration.zero
                    : const Duration(milliseconds: 900),
                curve: Curves.easeOutCubic,
                builder: (_, t, _) => CustomPaint(
                  painter: _MeterPainter(
                    zones: zones,
                    position: t,
                    active: active,
                    knob: BandColors.of(m.band, context),
                    surface: Theme.of(context).colorScheme.surface,
                  ),
                ),
              ),
            ),
            if (showScale && m.bands.length >= 2) ...[
              const SizedBox(height: 6),
              SizedBox(
                height: 16,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(formatTick(l, m, 0), style: labelStyle),
                    ),
                    Align(
                      alignment: const Alignment(-1 / 3, 0),
                      child: Text(
                        formatTick(l, m, m.bands[0]),
                        style: labelStyle,
                      ),
                    ),
                    Align(
                      alignment: const Alignment(1 / 3, 0),
                      child: Text(
                        formatTick(l, m, m.bands[1]),
                        style: labelStyle,
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '${formatTick(l, m, m.max)}'
                        '${m.lowerIsBetter ? '+' : ''}',
                        style: labelStyle,
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
  }
}

class _MeterPainter extends CustomPainter {
  const _MeterPainter({
    required this.zones,
    required this.position,
    required this.active,
    required this.knob,
    required this.surface,
  });

  final List<Color> zones;
  final double position;

  /// Index of the zone the reading is in, or -1 when there is no reading.
  final int active;
  final Color knob;
  final Color surface;

  static const _track = 8.0;
  static const _gap = 4.0;

  @override
  void paint(Canvas canvas, Size size) {
    final cy = size.height / 2;
    final w = (size.width - _gap * 2) / 3;
    for (var i = 0; i < 3; i++) {
      final left = i * (w + _gap);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(left, cy - _track / 2, w, _track),
          const Radius.circular(_track),
        ),
        // The zone holding the reading is solid; the others step back.
        Paint()..color = zones[i].withValues(alpha: i == active ? 1 : 0.28),
      );
    }
    if (active < 0) return;

    final x = (position * size.width).clamp(9.0, size.width - 9.0);
    final c = Offset(x, cy);
    canvas.drawCircle(
      c.translate(0, 1.5),
      10,
      Paint()
        ..color = Colors.black.withValues(alpha: 0.18)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );
    canvas.drawCircle(c, 9, Paint()..color = surface);
    canvas.drawCircle(c, 6, Paint()..color = knob);
  }

  @override
  bool shouldRepaint(_MeterPainter old) =>
      old.position != position ||
      old.active != active ||
      old.knob != knob ||
      old.surface != surface;
}

/// Pill with the verdict for a band: "Doing well", "Almost there"…
class VerdictChip extends StatelessWidget {
  const VerdictChip({required this.band, super.key});

  final PerfBand band;

  @override
  Widget build(BuildContext context) {
    final color = BandColors.of(band, context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        verdict(context.l10n, band),
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: color,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
