import 'package:freezed_annotation/freezed_annotation.dart';

import 'consultation_share.dart';

part 'consultation.freezed.dart';

enum ConsultationStatus {
  requested,
  accepted,
  active,
  ended,
  rejected,
  cancelled,
  expired,
  noShow,
  failed,
  unknown;

  static ConsultationStatus parse(String? s) => switch (s) {
    'requested' => requested,
    'accepted' => accepted,
    'active' => active,
    'ended' => ended,
    'rejected' => rejected,
    'cancelled' => cancelled,
    'expired' => expired,
    'no_show' => noShow,
    'failed' => failed,
    _ => unknown,
  };

  bool get isLive => this == accepted || this == active;
  bool get isTerminal =>
      this == ended ||
      this == rejected ||
      this == cancelled ||
      this == expired ||
      this == noShow ||
      this == failed;
  bool get canChat => this == accepted || this == active;
}

@freezed
abstract class Consultation with _$Consultation {
  const factory Consultation({
    required String id,
    @Default('chat') String channel,
    @Default(ConsultationStatus.unknown) ConsultationStatus status,
    @Default('') String astrologerId,
    @Default('') String astrologerName,
    String? astrologerAvatar,
    @Default('') String question,
    @Default('0') String rateSnapshot,
    @Default('INR') String currency,
    @Default(0) int billedSeconds,
    @Default('0') String grossAmount,
    @Default(0) int runwaySeconds,
    @Default(0) int unreadCount,
    int? rating,
    DateTime? requestedAt,
    DateTime? startedAt,
    DateTime? endedAt,
    @Default('') String endReason,

    /// Birth profiles / matches the customer shared for this reading.
    @Default(<ConsultationShare>[]) List<ConsultationShare> shares,
  }) = _Consultation;

  const Consultation._();

  factory Consultation.fromMap(Map<String, dynamic> j) => Consultation(
    id: j['id'] as String? ?? '',
    channel: j['channel'] as String? ?? 'chat',
    status: ConsultationStatus.parse(j['status'] as String?),
    astrologerId: j['astrologer_id'] as String? ?? '',
    astrologerName: j['astrologer_name'] as String? ?? '',
    astrologerAvatar: j['astrologer_avatar'] as String?,
    question: j['question'] as String? ?? '',
    rateSnapshot: '${j['rate_snapshot'] ?? '0'}',
    currency: j['currency'] as String? ?? 'INR',
    billedSeconds: (j['billed_seconds'] as num?)?.toInt() ?? 0,
    grossAmount: '${j['gross_amount'] ?? '0'}',
    runwaySeconds: (j['runway_seconds'] as num?)?.toInt() ?? 0,
    unreadCount: (j['unread_count'] as num?)?.toInt() ?? 0,
    rating: (j['rating'] as num?)?.toInt(),
    requestedAt: DateTime.tryParse('${j['requested_at']}'),
    startedAt: DateTime.tryParse('${j['started_at']}'),
    endedAt: DateTime.tryParse('${j['ended_at']}'),
    endReason: j['end_reason'] as String? ?? '',
    shares: ConsultationShare.listFrom(j['shares']),
  );

  double get ratePerMinute => double.tryParse(rateSnapshot) ?? 0;
  double get gross => double.tryParse(grossAmount) ?? 0;
  int get billedMinutes => (billedSeconds / 60).ceil();

  /// Ids already shared, so the share sheet can mark them.
  Set<String> get sharedProfileIds => {
    for (final s in shares)
      if (s.person != null) s.person!.id,
  };
  Set<String> get sharedMatchIds => {
    for (final s in shares)
      if (s.match != null) s.match!.id,
  };
}
