/// Mirrors backend `ConsultationSerializer` (astrologer view).
class Consultation {
  Consultation({
    required this.id,
    required this.channel,
    required this.status,
    required this.customerName,
    required this.question,
    required this.rateSnapshot,
    required this.currency,
    required this.billedSeconds,
    required this.grossAmount,
    required this.astrologerAmount,
    required this.runwaySeconds,
    required this.unreadCount,
    required this.requestedAt,
    required this.endedAt,
    this.rating,
  });

  final String id;
  final String channel;
  final String status;
  final String customerName;
  final String question;
  final String rateSnapshot;
  final String currency;
  final int billedSeconds;
  final String grossAmount;
  final String astrologerAmount;
  final int runwaySeconds;
  final int unreadCount;
  final DateTime? requestedAt;
  final DateTime? endedAt;
  final int? rating;

  bool get isLive => status == 'active' || status == 'accepted';
  bool get isRequested => status == 'requested';
  bool get isEnded => status == 'ended';
  bool get isCall => channel != 'chat';
  bool get isTerminal => const {
    'ended',
    'rejected',
    'cancelled',
    'expired',
    'no_show',
    'failed',
  }.contains(status);
  int get billedMinutes => (billedSeconds / 60).ceil();

  factory Consultation.fromJson(Map<String, dynamic> j) => Consultation(
    id: j['id']?.toString() ?? '',
    channel: j['channel'] as String? ?? 'chat',
    status: j['status'] as String? ?? 'requested',
    customerName: j['customer_name'] as String? ?? 'Customer',
    question: j['question'] as String? ?? '',
    rateSnapshot: '${j['rate_snapshot'] ?? '0'}',
    currency: j['currency'] as String? ?? 'INR',
    billedSeconds: (j['billed_seconds'] as num?)?.toInt() ?? 0,
    grossAmount: '${j['gross_amount'] ?? '0'}',
    astrologerAmount: '${j['astrologer_amount'] ?? '0'}',
    runwaySeconds: (j['runway_seconds'] as num?)?.toInt() ?? 0,
    unreadCount: (j['unread_count'] as num?)?.toInt() ?? 0,
    requestedAt: DateTime.tryParse('${j['requested_at'] ?? ''}'),
    endedAt: DateTime.tryParse('${j['ended_at'] ?? ''}'),
    rating: (j['rating'] as num?)?.toInt(),
  );
}
