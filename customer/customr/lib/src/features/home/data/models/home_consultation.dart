import 'package:equatable/equatable.dart';

/// A consultation row as home needs it — powers both the "Resume" card
/// (active / paused sessions) and the "Talk again" rail (recently ended).
/// Subset of `ConsultationSerializer` (`GET /app/consultations`).
class HomeConsultation extends Equatable {
  const HomeConsultation({
    required this.id,
    required this.astrologerId,
    required this.astrologerName,
    required this.channel,
    required this.status,
    this.startedAt,
    this.endedAt,
    this.rating,
  });

  final String id;
  final String astrologerId;
  final String astrologerName;
  final String channel;
  final String status;
  final DateTime? startedAt;
  final DateTime? endedAt;
  final int? rating;

  /// Statuses where the customer can jump back into a live/paused session.
  static const resumable = {
    'accepted',
    'active',
    'paused',
    'reconnecting',
    'in_progress',
  };

  bool get isResumable => resumable.contains(status);
  bool get isEnded => status == 'ended' || status == 'completed';

  factory HomeConsultation.fromJson(Map<String, dynamic> json) {
    return HomeConsultation(
      id: '${json['id'] ?? ''}',
      astrologerId: '${json['astrologer_id'] ?? ''}',
      astrologerName: '${json['astrologer_name'] ?? ''}',
      channel: '${json['channel'] ?? 'chat'}',
      status: '${json['status'] ?? ''}',
      startedAt: DateTime.tryParse('${json['started_at'] ?? ''}'),
      endedAt: DateTime.tryParse('${json['ended_at'] ?? ''}'),
      rating: (json['rating'] as num?)?.toInt(),
    );
  }

  @override
  List<Object?> get props => [id, status];
}
