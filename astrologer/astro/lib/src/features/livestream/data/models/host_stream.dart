import 'package:equatable/equatable.dart';

/// One of this astrologer's own streams (`LiveStreamSerializer`).
class HostStream extends Equatable {
  const HostStream({
    required this.id,
    this.title = '',
    this.description = '',
    this.language = 'en',
    this.status = 'scheduled',
    this.viewerCount = 0,
    this.peakViewers = 0,
    this.totalJoins = 0,
    this.totalGiftValue = 0,
    this.giftCurrency = 'INR',
    this.slowModeSeconds = 0,
    this.scheduledAt,
    this.startedAt,
    this.endedAt,
  });

  final String id;
  final String title;
  final String description;
  final String language;

  /// `scheduled` | `live` | `ended` | `cancelled`.
  final String status;
  final int viewerCount;
  final int peakViewers;
  final int totalJoins;
  final double totalGiftValue;
  final String giftCurrency;
  final int slowModeSeconds;
  final DateTime? scheduledAt;
  final DateTime? startedAt;
  final DateTime? endedAt;

  bool get isLive => status == 'live';
  bool get isScheduled => status == 'scheduled';

  factory HostStream.fromJson(Map<String, dynamic> j) => HostStream(
    id: '${j['public_id'] ?? j['id'] ?? ''}',
    title: '${j['title'] ?? ''}',
    description: '${j['description'] ?? ''}',
    language: '${j['language'] ?? 'en'}',
    status: '${j['status'] ?? 'scheduled'}',
    viewerCount: (j['viewer_count'] as num?)?.toInt() ?? 0,
    peakViewers: (j['peak_viewers'] as num?)?.toInt() ?? 0,
    totalJoins: (j['total_joins'] as num?)?.toInt() ?? 0,
    totalGiftValue: double.tryParse('${j['total_gift_value'] ?? 0}') ?? 0,
    giftCurrency: '${j['gift_currency'] ?? 'INR'}',
    slowModeSeconds: (j['slow_mode_seconds'] as num?)?.toInt() ?? 0,
    scheduledAt: DateTime.tryParse('${j['scheduled_at'] ?? ''}')?.toLocal(),
    startedAt: DateTime.tryParse('${j['started_at'] ?? ''}')?.toLocal(),
    endedAt: DateTime.tryParse('${j['ended_at'] ?? ''}')?.toLocal(),
  );

  @override
  List<Object?> get props => [id, status, viewerCount, title];
}

/// A viewer in the host's roster (`ViewerSerializer`).
class LiveViewer extends Equatable {
  const LiveViewer({
    required this.userId,
    required this.name,
    this.active = true,
  });

  final String userId;
  final String name;
  final bool active;

  factory LiveViewer.fromJson(Map<String, dynamic> j) => LiveViewer(
    userId: '${j['user'] ?? ''}',
    name: '${j['name'] ?? ''}',
    active: j['is_active'] != false,
  );

  @override
  List<Object?> get props => [userId, active];
}
