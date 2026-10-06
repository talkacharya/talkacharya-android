import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:talkacharya_ui/talkacharya_ui.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/util/money.dart';
import '../../data/performance_models.dart';

/// The three verdict colours of a meter. Fixed rather than themed: red, amber
/// and green are the meaning here, not decoration.
class BandColors {
  const BandColors._();

  static const low = Color(0xFFE5484D);
  static const mid = Color(0xFFF5A524);
  static const good = Color(0xFF30A46C);

  static Color of(PerfBand band, BuildContext context) => switch (band) {
    PerfBand.low => low,
    PerfBand.mid => mid,
    PerfBand.good => good,
    PerfBand.none => context.brand.inkMuted,
  };
}

/// "11h 28m" · "7m 23s" · "45s" — the two most significant units.
String formatDuration(AppLocalizations l, num seconds) {
  final s = seconds.round();
  if (s >= 3600) return l.perfHoursMinutes(s ~/ 3600, (s % 3600) ~/ 60);
  if (s >= 60) return l.perfMinutesSeconds(s ~/ 60, s % 60);
  return l.perfSeconds(s);
}

/// A metric's reading in its own unit: "26.7%", "7m 23s", "3".
String formatMetricValue(AppLocalizations l, PerfMetric m, [double? value]) {
  final v = value ?? m.value;
  return switch (m.unit) {
    'percent' => formatPercent(v),
    'seconds' => formatDuration(l, v),
    _ => v.round().toString(),
  };
}

String formatPercent(double v) =>
    '${v == v.roundToDouble() ? v.round() : v.toStringAsFixed(1)}%';

/// Scale labels under a meter: "25%", "6h", "10m".
String formatTick(AppLocalizations l, PerfMetric m, double v) =>
    switch (m.unit) {
      'percent' => '${v.round()}%',
      'seconds' =>
        v >= 3600 ? l.perfHours((v / 3600).round()) : l.perfMinutes(v ~/ 60),
      _ => v.round().toString(),
    };

/// "₹75K" · "₹1.5L" · "$2K" — club names, where the round figure is the point.
String compactMoney(num amount, String currency) {
  final symbol = Money.symbol(currency);
  String trim(double v) =>
      v == v.roundToDouble() ? v.round().toString() : v.toStringAsFixed(1);
  if (currency.toUpperCase() == 'INR' && amount >= 100000) {
    return '$symbol${trim(amount / 100000)}L';
  }
  if (amount >= 1000000) return '$symbol${trim(amount / 1000000)}M';
  if (amount >= 1000) return '$symbol${trim(amount / 1000)}K';
  return '$symbol${NumberFormat.decimalPattern().format(amount)}';
}

String metricTitle(AppLocalizations l, String key) => switch (key) {
  PerfKeys.firstRepeat => l.perfFirstRepeat,
  PerfKeys.totalRepeat => l.perfTotalRepeat,
  PerfKeys.avgSession => l.perfAvgSession,
  PerfKeys.onlineTime => l.perfOnlineTime,
  PerfKeys.missed => l.perfMissed,
  _ => key,
};

String metricAbout(AppLocalizations l, String key) => switch (key) {
  PerfKeys.firstRepeat => l.perfFirstRepeatAbout,
  PerfKeys.totalRepeat => l.perfTotalRepeatAbout,
  PerfKeys.avgSession => l.perfAvgSessionAbout,
  PerfKeys.onlineTime => l.perfOnlineTimeAbout,
  PerfKeys.missed => l.perfMissedAbout,
  _ => '',
};

/// One line on what to do about the weakest metric.
String? focusTip(AppLocalizations l, String? key) => switch (key) {
  PerfKeys.onlineTime => l.perfTipOnline,
  PerfKeys.avgSession => l.perfTipSession,
  PerfKeys.firstRepeat => l.perfTipFirstRepeat,
  PerfKeys.totalRepeat => l.perfTipTotalRepeat,
  PerfKeys.missed => l.perfTipMissed,
  _ => null,
};

String verdict(AppLocalizations l, PerfBand band) => switch (band) {
  PerfBand.low => l.perfVerdictLow,
  PerfBand.mid => l.perfVerdictMid,
  PerfBand.good => l.perfVerdictGood,
  PerfBand.none => l.perfVerdictNone,
};

/// ▲ / ▼ against the previous window, coloured by whether it is an
/// improvement (a falling missed count is green). Nothing when unchanged.
class TrendArrow extends StatelessWidget {
  const TrendArrow({required this.metric, this.size = 16, super.key});

  final PerfMetric metric;
  final double size;

  @override
  Widget build(BuildContext context) {
    final delta = metric.value - metric.previous;
    if (delta == 0 || metric.band == PerfBand.none) {
      return const SizedBox.shrink();
    }
    return Icon(
      delta > 0 ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
      size: size,
      color: metric.improvement > 0 ? BandColors.good : BandColors.low,
    );
  }
}
