import 'package:equatable/equatable.dart';

/// A livestream tile for the "Live now" rail — a subset of `LiveStreamSerializer`
/// (`GET /app/livestreams?status=live`).
class LiveStreamCard extends Equatable {
  const LiveStreamCard({
    required this.id,
    required this.hostName,
    this.hostId,
    this.title = '',
    this.status = 'live',
    this.viewerCount = 0,
    this.startedAt,
  });

  final String id;
  final String? hostId;
  final String hostName;
  final String title;
  final String status;
  final int viewerCount;
  final DateTime? startedAt;

  bool get isLive => status == 'live';

  factory LiveStreamCard.fromJson(Map<String, dynamic> json) {
    String pick(List<String> keys) {
      for (final k in keys) {
        final v = json[k]?.toString();
        if (v != null && v.isNotEmpty) return v;
      }
      return '';
    }

    return LiveStreamCard(
      id: pick(['public_id', 'id']),
      hostId: json['host']?.toString(),
      hostName: pick(['host_name', 'hostName']),
      title: pick(['title']),
      status: pick(['status']).isEmpty ? 'live' : pick(['status']),
      viewerCount:
          (json['viewer_count'] as num?)?.toInt() ??
          (json['peak_viewers'] as num?)?.toInt() ??
          0,
      startedAt: DateTime.tryParse('${json['started_at'] ?? ''}'),
    );
  }

  @override
  List<Object?> get props => [id, status, viewerCount, title];
}
