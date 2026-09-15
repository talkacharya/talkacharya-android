import 'package:equatable/equatable.dart';

/// What went wrong — mirrors backend `DisputeType`.
enum DisputeType {
  billing('billing'),
  quality('quality'),
  conduct('conduct'),
  noShow('no_show'),
  technical('technical');

  const DisputeType(this.wire);
  final String wire;

  static DisputeType parse(String? s) => DisputeType.values.firstWhere(
    (t) => t.wire == s,
    orElse: () => DisputeType.quality,
  );
}

/// Backend `DisputeStatus`. `open` + `investigating` are "in progress".
enum DisputeStatus {
  open,
  investigating,
  resolved,
  rejected;

  static DisputeStatus parse(String? s) => switch (s) {
    'investigating' => investigating,
    'resolved' => resolved,
    'rejected' => rejected,
    _ => open,
  };

  bool get isOpen => this == open || this == investigating;
}

/// The session a report is about (a compact copy, so the report reads on its own).
class DisputeConsultation extends Equatable {
  const DisputeConsultation({
    required this.id,
    this.channel = 'chat',
    this.astrologerId = '',
    this.astrologerName = '',
    this.startedAt,
    this.endedAt,
    this.billedSeconds = 0,
    this.grossAmount = 0,
    this.currency = 'INR',
  });

  final String id;
  final String channel;
  final String astrologerId;
  final String astrologerName;
  final DateTime? startedAt;
  final DateTime? endedAt;
  final int billedSeconds;
  final double grossAmount;
  final String currency;

  int get billedMinutes => (billedSeconds / 60).ceil();

  factory DisputeConsultation.fromJson(Map<String, dynamic> j) =>
      DisputeConsultation(
        id: '${j['id'] ?? ''}',
        channel: '${j['channel'] ?? 'chat'}',
        astrologerId: '${j['astrologer_id'] ?? ''}',
        astrologerName: '${j['astrologer_name'] ?? ''}',
        startedAt: DateTime.tryParse('${j['started_at']}'),
        endedAt: DateTime.tryParse('${j['ended_at']}'),
        billedSeconds: (j['billed_seconds'] as num?)?.toInt() ?? 0,
        grossAmount: double.tryParse('${j['gross_amount']}') ?? 0,
        currency: '${j['currency'] ?? 'INR'}',
      );

  @override
  List<Object?> get props => [id, channel, astrologerName, endedAt];
}

/// A step on the customer-visible timeline: `raised`, `reviewing`, `resolved`,
/// `rejected`.
class DisputeStep extends Equatable {
  const DisputeStep({required this.type, this.at});
  final String type;
  final DateTime? at;

  @override
  List<Object?> get props => [type, at];
}

/// One report, from `GET /app/disputes[/{id}]`.
class Dispute extends Equatable {
  const Dispute({
    required this.id,
    required this.consultation,
    this.type = DisputeType.quality,
    this.description = '',
    this.status = DisputeStatus.open,
    this.resolution = '',
    this.resolutionNote = '',
    this.refundAmount,
    this.resolvedAt,
    this.createdAt,
    this.timeline = const [],
  });

  final String id;
  final DisputeConsultation consultation;
  final DisputeType type;
  final String description;
  final DisputeStatus status;

  /// `refund_full` | `refund_partial` | `no_action` | `astrologer_penalised` | ''.
  final String resolution;
  final String resolutionNote;
  final double? refundAmount;
  final DateTime? resolvedAt;
  final DateTime? createdAt;
  final List<DisputeStep> timeline;

  bool get refunded => (refundAmount ?? 0) > 0;

  factory Dispute.fromJson(Map<String, dynamic> j) => Dispute(
    id: '${j['id'] ?? ''}',
    consultation: DisputeConsultation.fromJson(
      (j['consultation'] as Map?)?.cast<String, dynamic>() ?? const {},
    ),
    type: DisputeType.parse(j['type'] as String?),
    description: '${j['description'] ?? ''}',
    status: DisputeStatus.parse(j['status'] as String?),
    resolution: '${j['resolution'] ?? ''}',
    resolutionNote: '${j['resolution_note'] ?? ''}',
    refundAmount: j['refund_amount'] == null
        ? null
        : double.tryParse('${j['refund_amount']}'),
    resolvedAt: DateTime.tryParse('${j['resolved_at']}'),
    createdAt: DateTime.tryParse('${j['created_at']}'),
    timeline: [
      for (final e in (j['timeline'] as List<dynamic>? ?? const []))
        if (e is Map)
          DisputeStep(
            type: '${e['type'] ?? ''}',
            at: DateTime.tryParse('${e['created_at']}'),
          ),
    ],
  );

  @override
  List<Object?> get props => [
    id,
    status,
    resolution,
    resolutionNote,
    refundAmount,
    timeline,
  ];
}
