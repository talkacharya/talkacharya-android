import 'package:equatable/equatable.dart';

import '../../../core/util/json.dart';

/// One page of a DRF cursor-paginated list.
class CursorPage<T> {
  const CursorPage(this.items, this.nextCursor);

  final List<T> items;

  /// Opaque `cursor` query value for the next page; `null` on the last page.
  final String? nextCursor;

  static CursorPage<T> parse<T>(
    Object? data,
    T Function(Map<String, dynamic>) item,
  ) {
    final map = data is Map ? data.cast<String, dynamic>() : null;
    final rows = (map?['results'] ?? data) as List? ?? const [];
    final next = map?['next'] as String?;
    return CursorPage(
      rows.map((e) => item((e as Map).cast<String, dynamic>())).toList(),
      next == null ? null : Uri.tryParse(next)?.queryParameters['cursor'],
    );
  }
}

/// `EarningKind` values (backend `apps/payouts/models.py`).
abstract final class EarningKinds {
  static const consultation = 'consultation';
  static const gift = 'gift';
  static const prediction = 'prediction';
  static const storeSale = 'store_sale';
  static const affiliate = 'affiliate';
  static const bonus = 'bonus';
  static const adjustment = 'adjustment';
}

class EarningEntry extends Equatable {
  const EarningEntry({
    required this.id,
    required this.kind,
    required this.gross,
    required this.commissionPercent,
    required this.commission,
    required this.net,
    required this.currency,
    required this.availableOn,
    required this.consultationId,
    required this.payoutId,
    required this.createdAt,
  });

  final String id;
  final String kind;
  final double gross;
  final double commissionPercent;
  final double commission;
  final double net;
  final String currency;

  /// Date the entry clears the dispute window and becomes payable.
  final DateTime? availableOn;
  final String? consultationId;
  final String? payoutId;
  final DateTime? createdAt;

  bool get isPaidOut => payoutId != null;

  bool isClearing(DateTime today) =>
      !isPaidOut && availableOn != null && availableOn!.isAfter(today);

  factory EarningEntry.fromJson(Map<String, dynamic> j) => EarningEntry(
    id: '${j['public_id'] ?? ''}',
    kind: j['kind'] as String? ?? EarningKinds.consultation,
    gross: toDouble(j['gross_amount']),
    commissionPercent: toDouble(j['commission_percentage']),
    commission: toDouble(j['commission_amount']),
    net: toDouble(j['net_amount']),
    currency: j['currency'] as String? ?? 'INR',
    availableOn: DateTime.tryParse('${j['available_on']}'),
    consultationId: j['consultation'] as String?,
    payoutId: j['payout'] as String?,
    createdAt: DateTime.tryParse('${j['created_at']}'),
  );

  @override
  List<Object?> get props => [id, kind, net, availableOn, payoutId];
}

/// `PayoutStatus` values.
abstract final class PayoutStatuses {
  static const pending = 'pending';
  static const processing = 'processing';
  static const paid = 'paid';
  static const failed = 'failed';
  static const onHold = 'on_hold';
  static const cancelled = 'cancelled';
}

class Payout extends Equatable {
  const Payout({
    required this.id,
    required this.currency,
    required this.gross,
    required this.tds,
    required this.otherDeductions,
    required this.net,
    required this.periodStart,
    required this.periodEnd,
    required this.status,
    required this.utr,
    required this.initiatedAt,
    required this.paidAt,
    required this.failureReason,
    required this.entryCount,
    required this.createdAt,
    this.entries = const [],
    this.documents = const [],
  });

  final String id;
  final String currency;
  final double gross;
  final double tds;
  final double otherDeductions;
  final double net;
  final DateTime? periodStart;
  final DateTime? periodEnd;
  final String status;
  final String utr;
  final DateTime? initiatedAt;
  final DateTime? paidAt;
  final String failureReason;
  final int entryCount;
  final DateTime? createdAt;

  /// Only filled by the detail endpoint.
  final List<EarningEntry> entries;
  final List<TaxDocument> documents;

  factory Payout.fromJson(Map<String, dynamic> j) => Payout(
    id: '${j['public_id'] ?? ''}',
    currency: j['currency'] as String? ?? 'INR',
    gross: toDouble(j['gross']),
    tds: toDouble(j['tds_amount']),
    otherDeductions: toDouble(j['other_deductions']),
    net: toDouble(j['net_amount']),
    periodStart: DateTime.tryParse('${j['period_start']}'),
    periodEnd: DateTime.tryParse('${j['period_end']}'),
    status: j['status'] as String? ?? PayoutStatuses.pending,
    utr: j['utr'] as String? ?? '',
    initiatedAt: DateTime.tryParse('${j['initiated_at']}'),
    paidAt: DateTime.tryParse('${j['paid_at']}'),
    failureReason: j['failure_reason'] as String? ?? '',
    entryCount: (j['entry_count'] as num?)?.toInt() ?? 0,
    createdAt: DateTime.tryParse('${j['created_at']}'),
    entries: (j['entries'] as List? ?? const [])
        .map((e) => EarningEntry.fromJson((e as Map).cast<String, dynamic>()))
        .toList(),
    documents: (j['documents'] as List? ?? const [])
        .map((e) => TaxDocument.fromJson((e as Map).cast<String, dynamic>()))
        .toList(),
  );

  @override
  List<Object?> get props => [id, status, net, paidAt, entries, documents];
}

class TaxDocument extends Equatable {
  const TaxDocument({
    required this.id,
    required this.kind,
    required this.number,
    required this.currency,
    required this.total,
    required this.tax,
    required this.issuedAt,
  });

  final String id;
  final String kind;
  final String number;
  final String currency;
  final double total;
  final double tax;
  final DateTime? issuedAt;

  factory TaxDocument.fromJson(Map<String, dynamic> j) => TaxDocument(
    id: '${j['public_id'] ?? ''}',
    kind: j['kind'] as String? ?? '',
    number: j['number'] as String? ?? '',
    currency: j['currency'] as String? ?? 'INR',
    total: toDouble(j['total_amount']),
    tax: toDouble(j['tax_amount']),
    issuedAt: DateTime.tryParse('${j['issued_at']}'),
  );

  @override
  List<Object?> get props => [id, kind, number, total];
}

// --- statement (GET /astro/earnings/statement) ---------------------------------

/// What an earning or a payout is doing, as the statement says it.
abstract final class StatementStatuses {
  static const upcoming = 'upcoming'; // the cycle running now
  static const clearing = 'clearing'; // in the refund / dispute window
  static const ready = 'ready'; // in the next payout
  static const onHold = 'on_hold'; // a dispute, or payouts held
  static const processing = 'processing'; // sent to the bank
  static const credited = 'credited'; // in the bank
  static const failed = 'failed'; // sent back; it will go again
}

/// One service's line: what customers paid for it and what of it is yours.
class StatementService extends Equatable {
  const StatementService({
    required this.key,
    required this.count,
    required this.earned,
    required this.share,
    this.channels = const {},
  });

  /// consultation / gift / prediction / store / recommendation / bonus /
  /// refund / fine.
  final String key;
  final int count;
  final double earned;
  final double share;

  /// Consultations only: chat / voice / video / live_call, and what customers
  /// paid for each.
  final Map<String, double> channels;

  factory StatementService.fromJson(Map<String, dynamic> j) => StatementService(
    key: '${j['key'] ?? ''}',
    count: (j['count'] as num?)?.toInt() ?? 0,
    earned: toDouble(j['earned']),
    share: toDouble(j['share']),
    channels: {
      for (final e in ((j['channels'] as Map?) ?? const {}).entries)
        '${e.key}': toDouble(e.value),
    },
  );

  @override
  List<Object?> get props => [key, count, earned, share, channels];
}

/// What came off, down to the payout. A percentage is null when the earnings
/// in it were made at different rates.
class StatementTotals extends Equatable {
  const StatementTotals({
    this.earned = 0,
    this.platformFee = 0,
    this.platformFeePercent,
    this.gst = 0,
    this.gstPercent,
    this.gateway = 0,
    this.gatewayPercent,
    this.share = 0,
    this.tds = 0,
    this.tdsPercent,
    this.tdsSection = '',
    this.payout = 0,
    this.clearing = 0,
    this.onHold = 0,
  });

  final double earned;
  final double platformFee;
  final String? platformFeePercent;
  final double gst;
  final String? gstPercent;
  final double gateway;
  final String? gatewayPercent;
  final double share;
  final double tds;
  final String? tdsPercent;
  final String tdsSection;
  final double payout;

  /// The cycle running now: still in the refund window, and on hold.
  final double clearing;
  final double onHold;

  factory StatementTotals.fromJson(Map<String, dynamic>? j) => StatementTotals(
    earned: toDouble(j?['earned']),
    platformFee: toDouble(j?['platform_fee']),
    platformFeePercent: j?['platform_fee_percent'] as String?,
    gst: toDouble(j?['gst']),
    gstPercent: j?['gst_percent'] as String?,
    gateway: toDouble(j?['gateway']),
    gatewayPercent: j?['gateway_percent'] as String?,
    share: toDouble(j?['share']),
    tds: toDouble(j?['tds']),
    tdsPercent: j?['tds_percent'] as String?,
    tdsSection: '${j?['tds_section'] ?? ''}',
    payout: toDouble(j?['payout']),
    clearing: toDouble(j?['clearing']),
    onHold: toDouble(j?['on_hold']),
  );

  @override
  List<Object?> get props => [
    earned,
    platformFee,
    gst,
    gateway,
    share,
    tds,
    payout,
    clearing,
    onHold,
  ];
}

/// A payout's statement, or the one of the cycle running now ([payoutId] null).
class EarningsStatement extends Equatable {
  const EarningsStatement({
    required this.status,
    required this.currency,
    this.payoutId,
    this.periodStart,
    this.periodEnd,
    this.paysOn,
    this.paidAt,
    this.utr = '',
    this.failureReason = '',
    this.cycleDays = 7,
    this.services = const [],
    this.totals = const StatementTotals(),
  });

  final String? payoutId;
  final String status;
  final String currency;
  final DateTime? periodStart;
  final DateTime? periodEnd;

  /// When it is (or was) paid.
  final DateTime? paysOn;
  final DateTime? paidAt;
  final String utr;
  final String failureReason;
  final int cycleDays;
  final List<StatementService> services;
  final StatementTotals totals;

  bool get isCurrent => payoutId == null;

  factory EarningsStatement.fromJson(Map<String, dynamic> j) =>
      EarningsStatement(
        payoutId: j['id'] as String?,
        status: '${j['status'] ?? StatementStatuses.upcoming}',
        currency: '${j['currency'] ?? 'INR'}',
        periodStart: DateTime.tryParse('${j['period_start']}'),
        periodEnd: DateTime.tryParse('${j['period_end']}'),
        paysOn: DateTime.tryParse('${j['pays_on']}'),
        paidAt: DateTime.tryParse('${j['paid_at']}'),
        utr: '${j['utr'] ?? ''}',
        failureReason: '${j['failure_reason'] ?? ''}',
        cycleDays: (j['cycle_days'] as num?)?.toInt() ?? 7,
        services: [
          for (final s in (j['services'] as List?) ?? const [])
            StatementService.fromJson((s as Map).cast<String, dynamic>()),
        ],
        totals: StatementTotals.fromJson((j['totals'] as Map?)?.cast()),
      );

  @override
  List<Object?> get props => [payoutId, status, totals, services, paysOn];
}

/// One earning behind a statement, with its own breakdown.
class StatementItem extends Equatable {
  const StatementItem({
    required this.id,
    required this.service,
    required this.title,
    required this.status,
    this.at,
    this.consultationId,
    this.minutes,
    this.earned = 0,
    this.platformFee = 0,
    this.platformFeePercent = '',
    this.gst = 0,
    this.gstPercent = '',
    this.gateway = 0,
    this.gatewayPercent = '',
    this.share = 0,
    this.tdsPercent,
    this.availableOn,
  });

  final String id;
  final String service;
  final String title;
  final String status;
  final DateTime? at;
  final String? consultationId;
  final int? minutes;
  final double earned;
  final double platformFee;
  final String platformFeePercent;
  final double gst;
  final String gstPercent;
  final double gateway;
  final String gatewayPercent;
  final double share;
  final String? tdsPercent;
  final DateTime? availableOn;

  factory StatementItem.fromJson(Map<String, dynamic> j) => StatementItem(
    id: '${j['id'] ?? ''}',
    service: '${j['service'] ?? ''}',
    title: '${j['title'] ?? ''}',
    status: '${j['status'] ?? ''}',
    at: DateTime.tryParse('${j['at']}'),
    consultationId: j['consultation'] as String?,
    minutes: (j['minutes'] as num?)?.toInt(),
    earned: toDouble(j['earned']),
    platformFee: toDouble(j['platform_fee']),
    platformFeePercent: '${j['platform_fee_percent'] ?? ''}',
    gst: toDouble(j['gst']),
    gstPercent: '${j['gst_percent'] ?? ''}',
    gateway: toDouble(j['gateway']),
    gatewayPercent: '${j['gateway_percent'] ?? ''}',
    share: toDouble(j['share']),
    tdsPercent: j['tds_percent'] as String?,
    availableOn: DateTime.tryParse('${j['available_on']}'),
  );

  @override
  List<Object?> get props => [id, status, share];
}
