import 'package:equatable/equatable.dart';

import '../../../core/util/json.dart';

/// Where a reading falls against its two cut points. [none] = nothing to
/// judge yet (no sessions in the window), which is not a bad score.
enum PerfBand { low, mid, good, none }

PerfBand _band(Object? v) => switch (v) {
  'low' => PerfBand.low,
  'mid' => PerfBand.mid,
  'good' => PerfBand.good,
  _ => PerfBand.none,
};

/// Keys of `metrics[]` from `GET /astro/analytics/performance`.
class PerfKeys {
  const PerfKeys._();

  static const firstRepeat = 'first_repeat';
  static const totalRepeat = 'total_repeat';
  static const avgSession = 'avg_session';
  static const onlineTime = 'online_time';
  static const missed = 'missed';
}

/// One banded meter. [unit] is `percent`, `seconds` or `count`; [bands] are
/// the two cut points on a scale that runs 0 → [max].
class PerfMetric extends Equatable {
  const PerfMetric({
    required this.key,
    required this.unit,
    required this.value,
    required this.previous,
    required this.sample,
    required this.bands,
    required this.max,
    required this.lowerIsBetter,
    required this.band,
  });

  final String key;
  final String unit;
  final double value;

  /// The same reading for the window before this one.
  final double previous;
  final int sample;
  final List<double> bands;
  final double max;
  final bool lowerIsBetter;
  final PerfBand band;

  /// Change against the previous window, signed so that positive is always
  /// "getting better" — a falling missed count is an improvement.
  double get improvement => lowerIsBetter ? previous - value : value - previous;

  factory PerfMetric.fromJson(Map<String, dynamic> j) => PerfMetric(
    key: '${j['key']}',
    unit: '${j['unit']}',
    value: toDouble(j['value']),
    previous: toDouble(j['previous']),
    sample: (j['sample'] as num?)?.toInt() ?? 0,
    bands: [for (final b in j['bands'] as List? ?? const []) toDouble(b)],
    max: toDouble(j['max']),
    lowerIsBetter: j['lower_is_better'] == true,
    band: _band(j['band']),
  );

  @override
  List<Object?> get props => [
    key,
    unit,
    value,
    previous,
    sample,
    bands,
    max,
    lowerIsBetter,
    band,
  ];
}

class LoyalStats extends Equatable {
  const LoyalStats({
    this.percent = 0,
    this.previous = 0,
    this.count = 0,
    this.customers = 0,
    this.minMinutes = 15,
  });

  final double percent;
  final double previous;
  final int count;
  final int customers;
  final int minMinutes;

  factory LoyalStats.fromJson(Map<String, dynamic> j) => LoyalStats(
    percent: toDouble(j['percent']),
    previous: toDouble(j['previous']),
    count: (j['count'] as num?)?.toInt() ?? 0,
    customers: (j['customers'] as num?)?.toInt() ?? 0,
    minMinutes: (j['min_minutes'] as num?)?.toInt() ?? 15,
  );

  @override
  List<Object?> get props => [percent, previous, count, customers, minMinutes];
}

class MissedStats extends Equatable {
  const MissedStats({
    this.total = 0,
    this.unanswered = 0,
    this.declined = 0,
    this.byChannel = const {},
  });

  final int total;
  final int unanswered;
  final int declined;
  final Map<String, int> byChannel;

  factory MissedStats.fromJson(Map<String, dynamic> j) => MissedStats(
    total: (j['total'] as num?)?.toInt() ?? 0,
    unanswered: (j['unanswered'] as num?)?.toInt() ?? 0,
    declined: (j['declined'] as num?)?.toInt() ?? 0,
    byChannel: {
      for (final e in _map(j['by_channel']).entries)
        e.key: (e.value as num?)?.toInt() ?? 0,
    },
  );

  @override
  List<Object?> get props => [total, unanswered, declined, byChannel];
}

class OnlineDay extends Equatable {
  const OnlineDay({required this.day, required this.seconds});

  final DateTime day;
  final int seconds;

  factory OnlineDay.fromJson(Map<String, dynamic> j) => OnlineDay(
    day: DateTime.tryParse('${j['day']}') ?? DateTime(1970),
    seconds: (j['seconds'] as num?)?.toInt() ?? 0,
  );

  @override
  List<Object?> get props => [day, seconds];
}

class RatingStat extends Equatable {
  const RatingStat({this.avg = 0, this.count = 0});

  final double avg;
  final int count;

  factory RatingStat.fromJson(Map<String, dynamic> j) => RatingStat(
    avg: toDouble(j['avg']),
    count: (j['count'] as num?)?.toInt() ?? 0,
  );

  @override
  List<Object?> get props => [avg, count];
}

class TodayStats extends Equatable {
  const TodayStats({
    this.currency = 'INR',
    this.gross = 0,
    this.net = 0,
    this.sessions = 0,
    this.minutes = 0,
    this.onlineSeconds = 0,
  });

  final String currency;
  final double gross;
  final double net;
  final int sessions;
  final int minutes;
  final int onlineSeconds;

  factory TodayStats.fromJson(Map<String, dynamic> j) => TodayStats(
    currency: j['currency'] as String? ?? 'INR',
    gross: toDouble(j['gross']),
    net: toDouble(j['net']),
    sessions: (j['sessions'] as num?)?.toInt() ?? 0,
    minutes: (j['minutes'] as num?)?.toInt() ?? 0,
    onlineSeconds: (j['online_seconds'] as num?)?.toInt() ?? 0,
  );

  @override
  List<Object?> get props => [
    currency,
    gross,
    net,
    sessions,
    minutes,
    onlineSeconds,
  ];
}

/// The month's earning club: where net earnings are heading at the pace so
/// far. [tier] is null below the first club, [nextTier] null above the last.
class EarningClub extends Equatable {
  const EarningClub({
    required this.currency,
    required this.monthToDate,
    required this.projected,
    required this.tier,
    required this.nextTier,
    required this.neededToday,
    required this.progress,
  });

  final String currency;
  final double monthToDate;
  final double projected;
  final double? tier;
  final double? nextTier;

  /// What today still has to bring in for the projection to reach [nextTier].
  final double? neededToday;

  /// 0–1 of the way from [tier] to [nextTier].
  final double progress;

  factory EarningClub.fromJson(Map<String, dynamic> j) => EarningClub(
    currency: j['currency'] as String? ?? 'INR',
    monthToDate: toDouble(j['month_to_date']),
    projected: toDouble(j['projected']),
    tier: j['tier'] == null ? null : toDouble(j['tier']),
    nextTier: j['next_tier'] == null ? null : toDouble(j['next_tier']),
    neededToday: j['needed_today'] == null ? null : toDouble(j['needed_today']),
    progress: toDouble(j['progress']).clamp(0, 1).toDouble(),
  );

  @override
  List<Object?> get props => [
    currency,
    monthToDate,
    projected,
    tier,
    nextTier,
    neededToday,
    progress,
  ];
}

/// Mirrors `apps/analytics/services/performance.py::astrologer_performance`.
/// Sessions with customers on the platform's welcome offer: how they rated,
/// and how many came back and paid.
class PromoStats extends Equatable {
  const PromoStats({
    this.sessions = 0,
    this.rating,
    this.customers = 0,
    this.returned = 0,
    this.repeatPercent = 0,
  });

  final int sessions;
  final double? rating;
  final int customers;
  final int returned;
  final double repeatPercent;

  factory PromoStats.fromJson(Map<String, dynamic> j) => PromoStats(
    sessions: (j['sessions'] as num?)?.toInt() ?? 0,
    rating: (j['rating'] as num?)?.toDouble(),
    customers: (j['customers'] as num?)?.toInt() ?? 0,
    returned: (j['returned'] as num?)?.toInt() ?? 0,
    repeatPercent: (j['repeat_percent'] as num?)?.toDouble() ?? 0,
  );

  @override
  List<Object?> get props => [
    sessions,
    rating,
    customers,
    returned,
    repeatPercent,
  ];
}

class Performance extends Equatable {
  const Performance({
    required this.windowDays,
    required this.updatedAt,
    required this.metrics,
    required this.focus,
    required this.loyal,
    required this.sessions,
    required this.missed,
    required this.onlineByDay,
    required this.overallRating,
    required this.ratingByChannel,
    required this.today,
    required this.club,
    this.promo = const PromoStats(),
  });

  final int windowDays;
  final DateTime? updatedAt;
  final List<PerfMetric> metrics;

  /// Key of the one metric most worth working on, if any is below "good".
  final String? focus;
  final LoyalStats loyal;
  final int sessions;
  final MissedStats missed;
  final List<OnlineDay> onlineByDay;
  final RatingStat overallRating;
  final Map<String, RatingStat> ratingByChannel;
  final TodayStats today;
  final EarningClub? club;

  /// Customers on the platform's welcome offer.
  final PromoStats promo;

  PerfMetric? metric(String key) {
    for (final m in metrics) {
      if (m.key == key) return m;
    }
    return null;
  }

  factory Performance.fromJson(Map<String, dynamic> j) {
    final ratings = _map(j['ratings']);
    return Performance(
      windowDays: (j['window_days'] as num?)?.toInt() ?? 15,
      updatedAt: DateTime.tryParse('${j['updated_at']}'),
      metrics: [
        for (final m in j['metrics'] as List? ?? const [])
          PerfMetric.fromJson(_map(m)),
      ],
      focus: j['focus'] as String?,
      loyal: LoyalStats.fromJson(_map(j['loyal'])),
      sessions: (j['sessions'] as num?)?.toInt() ?? 0,
      missed: MissedStats.fromJson(_map(j['missed'])),
      onlineByDay: [
        for (final d in j['online_by_day'] as List? ?? const [])
          OnlineDay.fromJson(_map(d)),
      ],
      overallRating: RatingStat.fromJson(_map(ratings['overall'])),
      ratingByChannel: {
        for (final e in _map(ratings['by_channel']).entries)
          e.key: RatingStat.fromJson(_map(e.value)),
      },
      today: TodayStats.fromJson(_map(j['today'])),
      club: j['club'] == null ? null : EarningClub.fromJson(_map(j['club'])),
      promo: PromoStats.fromJson(_map(j['promo'])),
    );
  }

  @override
  List<Object?> get props => [
    windowDays,
    updatedAt,
    metrics,
    focus,
    loyal,
    sessions,
    missed,
    onlineByDay,
    overallRating,
    ratingByChannel,
    today,
    club,
    promo,
  ];
}

/// `GET /astro/availability/break`.
class BreakStatus extends Equatable {
  const BreakStatus({
    this.endsAt,
    this.startedAt,
    this.usedToday = 0,
    this.limit = 0,
    this.left = 0,
    this.durations = const [],
  });

  /// Set while a break is running.
  final DateTime? endsAt;
  final DateTime? startedAt;
  final int usedToday;
  final int limit;
  final int left;

  /// Break lengths on offer, in minutes.
  final List<int> durations;

  bool get onBreak => endsAt != null && endsAt!.isAfter(DateTime.now());

  factory BreakStatus.fromJson(Map<String, dynamic> j) {
    final active = _map(j['active']);
    return BreakStatus(
      endsAt: DateTime.tryParse('${active['ends_at']}'),
      startedAt: DateTime.tryParse('${active['started_at']}'),
      usedToday: (j['used_today'] as num?)?.toInt() ?? 0,
      limit: (j['limit'] as num?)?.toInt() ?? 0,
      left: (j['left'] as num?)?.toInt() ?? 0,
      durations: [
        for (final d in j['durations_minutes'] as List? ?? const [])
          (d as num).toInt(),
      ],
    );
  }

  @override
  List<Object?> get props => [
    endsAt,
    startedAt,
    usedToday,
    limit,
    left,
    durations,
  ];
}

class LapsedCustomer extends Equatable {
  const LapsedCustomer({
    required this.name,
    required this.sessions,
    required this.minutes,
    required this.lastAt,
    required this.conversationId,
  });

  final String name;
  final int sessions;
  final int minutes;
  final DateTime? lastAt;

  /// Their thread, when one exists to open.
  final String? conversationId;

  factory LapsedCustomer.fromJson(Map<String, dynamic> j) => LapsedCustomer(
    name: j['name'] as String? ?? '',
    sessions: (j['sessions'] as num?)?.toInt() ?? 0,
    minutes: (j['minutes'] as num?)?.toInt() ?? 0,
    lastAt: DateTime.tryParse('${j['last_at']}'),
    conversationId: j['conversation'] as String?,
  );

  @override
  List<Object?> get props => [name, sessions, minutes, lastAt, conversationId];
}

/// `GET /astro/analytics/lapsed-customers`.
class LapsedCustomers extends Equatable {
  const LapsedCustomers({
    this.afterDays = 14,
    this.total = 0,
    this.customers = const [],
  });

  final int afterDays;
  final int total;
  final List<LapsedCustomer> customers;

  factory LapsedCustomers.fromJson(Map<String, dynamic> j) => LapsedCustomers(
    afterDays: (j['after_days'] as num?)?.toInt() ?? 14,
    total: (j['total'] as num?)?.toInt() ?? 0,
    customers: [
      for (final c in j['customers'] as List? ?? const [])
        LapsedCustomer.fromJson(_map(c)),
    ],
  );

  @override
  List<Object?> get props => [afterDays, total, customers];
}

Map<String, dynamic> _map(Object? v) =>
    v is Map ? v.cast<String, dynamic>() : const {};
