import 'package:equatable/equatable.dart';

import '../../../core/util/json.dart';

/// One day of `net_trend` from `GET /astro/analytics/dashboard`.
class TrendPoint extends Equatable {
  const TrendPoint({required this.day, required this.value, this.count = 0});

  final DateTime day;
  final double value;
  final int count;

  factory TrendPoint.fromJson(Map<String, dynamic> j) => TrendPoint(
    day: DateTime.tryParse('${j['day']}') ?? DateTime(1970),
    value: toDouble(j['value']),
    count: (j['count'] as num?)?.toInt() ?? 0,
  );

  @override
  List<Object?> get props => [day, value, count];
}

/// Mirrors `apps/analytics/services/reports.py::astrologer_dashboard`.
/// Percentages arrive as 0–100 floats.
class DashboardStats extends Equatable {
  const DashboardStats({
    required this.windowDays,
    required this.gross,
    required this.net,
    required this.commission,
    required this.requested,
    required this.completed,
    required this.acceptanceRate,
    required this.minutes,
    required this.ratingAvg,
    required this.ratingCount,
    required this.repeatClientRate,
    required this.trend,
  });

  final int windowDays;
  final double gross;
  final double net;
  final double commission;
  final int requested;
  final int completed;
  final double acceptanceRate;
  final double minutes;
  final double ratingAvg;
  final int ratingCount;
  final double repeatClientRate;
  final List<TrendPoint> trend;

  factory DashboardStats.fromJson(Map<String, dynamic> j) {
    final earn = _map(j['earnings']);
    final cons = _map(j['consultations']);
    final rating = _map(j['rating']);
    final lifetime = _map(j['lifetime']);
    // A new astrologer has no published reviews in the window; fall back to
    // the lifetime average so the tile isn't a bare 0.0.
    final windowAvg = toDouble(rating['avg']);
    return DashboardStats(
      windowDays: (j['window_days'] as num?)?.toInt() ?? 7,
      gross: toDouble(earn['gross']),
      net: toDouble(earn['net']),
      commission: toDouble(earn['commission']),
      requested: (cons['requested'] as num?)?.toInt() ?? 0,
      completed: (cons['completed'] as num?)?.toInt() ?? 0,
      acceptanceRate: toDouble(cons['acceptance_rate']),
      minutes: toDouble(cons['minutes']),
      ratingAvg: windowAvg > 0 ? windowAvg : toDouble(lifetime['rating_avg']),
      ratingCount: (rating['count'] as num?)?.toInt() ?? 0,
      repeatClientRate: toDouble(j['repeat_client_rate']),
      trend: (j['net_trend'] as List? ?? const [])
          .map((e) => TrendPoint.fromJson(_map(e)))
          .toList(),
    );
  }

  @override
  List<Object?> get props => [
    windowDays,
    gross,
    net,
    commission,
    requested,
    completed,
    acceptanceRate,
    minutes,
    ratingAvg,
    ratingCount,
    repeatClientRate,
    trend,
  ];
}

/// First currency row of `GET /astro/earnings`.
class PayoutSummary extends Equatable {
  const PayoutSummary({
    required this.currency,
    required this.available,
    required this.pending,
    required this.lifetime,
  });

  const PayoutSummary.empty()
    : currency = 'INR',
      available = 0,
      pending = 0,
      lifetime = 0;

  final String currency;
  final double available;
  final double pending;
  final double lifetime;

  factory PayoutSummary.fromJson(Map<String, dynamic> j) {
    final rows = j['by_currency'] as List? ?? const [];
    if (rows.isEmpty) return const PayoutSummary.empty();
    final r = _map(rows.first);
    return PayoutSummary(
      currency: r['currency'] as String? ?? 'INR',
      available: toDouble(r['available_to_pay']),
      pending: toDouble(r['pending_clearance']),
      lifetime: toDouble(r['lifetime_net']),
    );
  }

  @override
  List<Object?> get props => [currency, available, pending, lifetime];
}

Map<String, dynamic> _map(Object? v) =>
    v is Map ? v.cast<String, dynamic>() : const {};
