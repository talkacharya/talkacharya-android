import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

import '../../../core/constants/api_paths.dart';
import '../../../core/network/api_exception.dart';

/// One customer in line. Mirrors `AstroQueueEntrySerializer`.
class WaitlistEntry extends Equatable {
  const WaitlistEntry({
    required this.id,
    required this.customerName,
    required this.channel,
    required this.status,
    required this.position,
    required this.joinedAt,
    required this.offerExpiresAt,
    required this.pastSessions,
  });

  final String id;
  final String customerName;
  final String channel;

  /// `waiting`, or `offered` once they have been told it is their turn.
  final String status;
  final int position;
  final DateTime? joinedAt;
  final DateTime? offerExpiresAt;

  /// Finished sessions with this astrologer before — a regular, if any.
  final int pastSessions;

  /// Told it is their turn, and still inside the time they have to come in.
  bool get invited =>
      status == 'offered' && (offerExpiresAt?.isAfter(DateTime.now()) ?? false);

  factory WaitlistEntry.fromJson(Map<String, dynamic> j) => WaitlistEntry(
    id: '${j['id']}',
    customerName: j['customer_name'] as String? ?? '',
    channel: j['channel'] as String? ?? 'chat',
    status: j['status'] as String? ?? 'waiting',
    position: (j['position'] as num?)?.toInt() ?? 0,
    joinedAt: DateTime.tryParse('${j['joined_at']}'),
    offerExpiresAt: DateTime.tryParse('${j['offer_expires_at']}'),
    pastSessions: (j['past_sessions'] as num?)?.toInt() ?? 0,
  );

  @override
  List<Object?> get props => [
    id,
    customerName,
    channel,
    status,
    position,
    joinedAt,
    offerExpiresAt,
    pastSessions,
  ];
}

class WaitlistApi {
  WaitlistApi(this._dio);

  final Dio _dio;

  Future<List<WaitlistEntry>> list() async {
    final res = (await _dio.get<dynamic>(ApiPaths.astroQueue)).ensureOk();
    return [
      for (final e in res.data as List? ?? const [])
        WaitlistEntry.fromJson((e as Map).cast<String, dynamic>()),
    ];
  }

  /// Tells this customer it is their turn now.
  Future<WaitlistEntry> invite(String id) async {
    final res = (await _dio.post<Map<String, dynamic>>(
      ApiPaths.astroQueueEntry(id),
    )).ensureOk();
    return WaitlistEntry.fromJson(res.data ?? const {});
  }

  Future<void> remove(String id) async {
    (await _dio.delete<dynamic>(ApiPaths.astroQueueEntry(id))).ensureOk();
  }
}
