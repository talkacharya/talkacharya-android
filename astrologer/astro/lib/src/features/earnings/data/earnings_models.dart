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
