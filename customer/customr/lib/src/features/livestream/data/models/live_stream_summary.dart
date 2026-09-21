import 'package:equatable/equatable.dart';

/// One stream as the browse list and the room header need it —
/// `LiveStreamSerializer` (`GET /app/livestreams`).
class LiveStreamSummary extends Equatable {
  const LiveStreamSummary({
    required this.id,
    required this.hostName,
    this.hostId = '',
    this.title = '',
    this.description = '',
    this.language = 'en',
    this.tags = const [],
    this.status = 'live',
    this.viewerCount = 0,
    this.peakViewers = 0,
    this.giftingEnabled = true,
    this.giftCurrency = 'INR',
    this.slowModeSeconds = 0,
    this.startedAt,
    this.scheduledAt,
  });

  final String id;
  final String hostId;
  final String hostName;
  final String title;
  final String description;
  final String language;
  final List<String> tags;

  /// `scheduled` | `live` | `ended` | `cancelled`.
  final String status;
  final int viewerCount;
  final int peakViewers;
  final bool giftingEnabled;
  final String giftCurrency;
  final int slowModeSeconds;
  final DateTime? startedAt;
  final DateTime? scheduledAt;

  bool get isLive => status == 'live';
  bool get isScheduled => status == 'scheduled';
  bool get isOver => status == 'ended' || status == 'cancelled';

  factory LiveStreamSummary.fromJson(Map<String, dynamic> j) =>
      LiveStreamSummary(
        id: '${j['public_id'] ?? j['id'] ?? ''}',
        hostId: '${j['host'] ?? ''}',
        hostName: '${j['host_name'] ?? ''}',
        title: '${j['title'] ?? ''}',
        description: '${j['description'] ?? ''}',
        language: '${j['language'] ?? 'en'}',
        tags: [for (final t in (j['tags'] as List? ?? const [])) '$t'],
        status: '${j['status'] ?? 'live'}',
        viewerCount: (j['viewer_count'] as num?)?.toInt() ?? 0,
        peakViewers: (j['peak_viewers'] as num?)?.toInt() ?? 0,
        giftingEnabled: j['is_gifting_enabled'] != false,
        giftCurrency: '${j['gift_currency'] ?? 'INR'}',
        slowModeSeconds: (j['slow_mode_seconds'] as num?)?.toInt() ?? 0,
        startedAt: DateTime.tryParse('${j['started_at'] ?? ''}')?.toLocal(),
        scheduledAt: DateTime.tryParse('${j['scheduled_at'] ?? ''}')?.toLocal(),
      );

  LiveStreamSummary copyWith({int? viewerCount, String? status}) =>
      LiveStreamSummary(
        id: id,
        hostId: hostId,
        hostName: hostName,
        title: title,
        description: description,
        language: language,
        tags: tags,
        status: status ?? this.status,
        viewerCount: viewerCount ?? this.viewerCount,
        peakViewers: peakViewers,
        giftingEnabled: giftingEnabled,
        giftCurrency: giftCurrency,
        slowModeSeconds: slowModeSeconds,
        startedAt: startedAt,
        scheduledAt: scheduledAt,
      );

  @override
  List<Object?> get props => [id, status, viewerCount, title];
}
