import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

import '../../../core/constants/api_paths.dart';
import '../../../core/network/api_exception.dart';

Map<String, dynamic> _map(Object? v) =>
    v is Map ? v.cast<String, dynamic>() : const {};

/// The birth details the customer shared in a session.
class SharedBirth extends Equatable {
  const SharedBirth({
    required this.id,
    required this.name,
    required this.gender,
    required this.date,
    required this.time,
    required this.place,
  });

  final String id;
  final String name;
  final String gender;
  final String? date;
  final String? time;
  final String place;

  static SharedBirth? fromJson(Object? raw) {
    final j = _map(raw);
    if (j.isEmpty) return null;
    return SharedBirth(
      id: '${j['id'] ?? ''}',
      name: '${j['full_name'] ?? ''}',
      gender: '${j['gender'] ?? ''}',
      date: j['birth_date'] as String?,
      time: j['birth_time'] as String?,
      place: '${j['birth_place'] ?? ''}',
    );
  }

  @override
  List<Object?> get props => [id, date, time, place];
}

/// One finished session, as the history card shows it.
class HistoryEntry extends Equatable {
  const HistoryEntry({
    required this.id,
    required this.shortId,
    required this.channel,
    required this.status,
    required this.requestedAt,
    required this.startedAt,
    required this.billedSeconds,
    required this.currency,
    required this.earned,
    required this.rating,
    required this.review,
    required this.customerName,
    required this.sessionNumber,
    required this.sessionsTotal,
    required this.birth,
    required this.tags,
    required this.conversationId,
    required this.favourite,
    required this.note,
    required this.assistantThreadId,
    required this.canMessage,
  });

  final String id;
  final String shortId;
  final String channel;
  final String status;
  final DateTime? requestedAt;
  final DateTime? startedAt;
  final int billedSeconds;
  final String currency;
  final double earned;
  final int? rating;
  final String review;
  final String customerName;
  final int? sessionNumber;
  final int sessionsTotal;
  final SharedBirth? birth;
  final List<String> tags;
  final String? conversationId;
  final bool favourite;
  final String note;
  final String? assistantThreadId;
  final bool canMessage;

  bool get isEnded => status == 'ended';

  factory HistoryEntry.fromJson(Map<String, dynamic> j) {
    final customer = _map(j['customer']);
    return HistoryEntry(
      id: '${j['id']}',
      shortId: '${j['short_id'] ?? ''}',
      channel: '${j['channel'] ?? 'chat'}',
      status: '${j['status'] ?? ''}',
      requestedAt: DateTime.tryParse('${j['requested_at']}'),
      startedAt: DateTime.tryParse('${j['started_at']}'),
      billedSeconds: (j['billed_seconds'] as num?)?.toInt() ?? 0,
      currency: '${j['currency'] ?? 'INR'}',
      earned: double.tryParse('${j['astrologer_amount']}') ?? 0,
      rating: (j['rating'] as num?)?.toInt(),
      review: '${j['review'] ?? ''}',
      customerName: '${customer['name'] ?? ''}',
      sessionNumber: (customer['session_number'] as num?)?.toInt(),
      sessionsTotal: (customer['sessions_total'] as num?)?.toInt() ?? 0,
      birth: SharedBirth.fromJson(j['birth']),
      tags: [for (final t in j['tags'] as List? ?? const []) '$t'],
      conversationId: j['conversation_id'] as String?,
      favourite: j['favourite'] == true,
      note: '${j['note'] ?? ''}',
      assistantThreadId: j['assistant_thread_id'] as String?,
      canMessage: j['can_message'] == true,
    );
  }

  HistoryEntry copyWith({bool? favourite, String? note}) => HistoryEntry(
    id: id,
    shortId: shortId,
    channel: channel,
    status: status,
    requestedAt: requestedAt,
    startedAt: startedAt,
    billedSeconds: billedSeconds,
    currency: currency,
    earned: earned,
    rating: rating,
    review: review,
    customerName: customerName,
    sessionNumber: sessionNumber,
    sessionsTotal: sessionsTotal,
    birth: birth,
    tags: tags,
    conversationId: conversationId,
    favourite: favourite ?? this.favourite,
    note: note ?? this.note,
    assistantThreadId: assistantThreadId,
    canMessage: canMessage,
  );

  @override
  List<Object?> get props => [id, status, favourite, note];
}

class HistoryPageData {
  const HistoryPageData(this.items, this.next);
  final List<HistoryEntry> items;

  /// The cursor for the following page, or null at the end.
  final String? next;
}

/// `GET /astro/consultations/history` — finished sessions, newest first.
class HistoryApi {
  HistoryApi(this._dio);
  final Dio _dio;

  Future<HistoryPageData> page({
    String? cursor,
    String? query,
    String? channel,
    bool favourites = false,
  }) async {
    final res = (await _dio.get<dynamic>(
      ApiPaths.astroConsultationHistory,
      queryParameters: {
        'cursor': ?cursor,
        if (query != null && query.isNotEmpty) 'q': query,
        'channel': ?channel,
        if (favourites) 'favourites': '1',
      },
    )).ensureOk();
    final j = _map(res.data);
    final next = j['next'] as String?;
    return HistoryPageData([
      for (final r in j['results'] as List? ?? const [])
        HistoryEntry.fromJson(_map(r)),
    ], next == null ? null : Uri.tryParse(next)?.queryParameters['cursor']);
  }
}
