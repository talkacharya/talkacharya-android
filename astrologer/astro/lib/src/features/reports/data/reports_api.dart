import 'package:dio/dio.dart';

import '../../../core/constants/api_paths.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/util/json.dart';

/// A customer's report on one of this astrologer's sessions, as the
/// astrologer is allowed to see it (`/astro/disputes`): what was said, the
/// session it is about, their own reply, and what the team decided.
class SessionReport {
  const SessionReport({
    required this.id,
    required this.type,
    required this.description,
    required this.status,
    required this.createdAt,
    required this.responseDueAt,
    required this.canRespond,
    required this.myResponse,
    required this.myResponseAt,
    required this.customerName,
    required this.channel,
    required this.sessionAt,
    required this.billedSeconds,
    required this.grossAmount,
    required this.currency,
    required this.outcome,
  });

  final String id;

  /// billing | conduct | quality | no_show | technical
  final String type;
  final String description;

  /// open | investigating | resolved | rejected
  final String status;
  final DateTime? createdAt;

  /// Until when a reply is asked for.
  final DateTime? responseDueAt;

  /// Still open, and not yet answered.
  final bool canRespond;
  final String? myResponse;
  final DateTime? myResponseAt;

  /// First name only.
  final String customerName;
  final String channel;
  final DateTime? sessionAt;
  final int billedSeconds;
  final double grossAmount;
  final String currency;

  /// Null until the team has decided.
  final ReportOutcome? outcome;

  bool get decided => outcome != null;

  factory SessionReport.fromJson(Map<String, dynamic> j) {
    final c = (j['consultation'] as Map?)?.cast<String, dynamic>() ?? const {};
    final mine = (j['my_response'] as Map?)?.cast<String, dynamic>();
    final out = (j['outcome'] as Map?)?.cast<String, dynamic>();
    DateTime? at(Object? v) => DateTime.tryParse('$v')?.toLocal();
    return SessionReport(
      id: '${j['id'] ?? ''}',
      type: j['type'] as String? ?? '',
      description: j['description'] as String? ?? '',
      status: j['status'] as String? ?? 'open',
      createdAt: at(j['created_at']),
      responseDueAt: at(j['response_due_at']),
      canRespond: j['can_respond'] == true,
      myResponse: mine?['text'] as String?,
      myResponseAt: at(mine?['at']),
      customerName: c['customer_name'] as String? ?? '',
      channel: c['channel'] as String? ?? 'chat',
      sessionAt: at(c['started_at']) ?? at(c['ended_at']),
      billedSeconds: (c['billed_seconds'] as num?)?.toInt() ?? 0,
      grossAmount: toDouble(c['gross_amount']),
      currency: c['currency'] as String? ?? 'INR',
      outcome: out == null ? null : ReportOutcome.fromJson(out),
    );
  }
}

/// What a decided report meant for the astrologer.
class ReportOutcome {
  const ReportOutcome({
    required this.kind,
    required this.deductedAmount,
    required this.currency,
    required this.note,
    required this.decidedAt,
  });

  /// `none` — nothing done; `refund` — the customer got money back and the
  /// astrologer's earning is untouched; `penalty` — taken from the earning.
  final String kind;
  final double? deductedAmount;
  final String currency;

  /// The reviewer's note on the decision.
  final String note;
  final DateTime? decidedAt;

  factory ReportOutcome.fromJson(Map<String, dynamic> j) => ReportOutcome(
    kind: j['kind'] as String? ?? 'none',
    deductedAmount: j['deducted_amount'] == null
        ? null
        : toDouble(j['deducted_amount']),
    currency: j['currency'] as String? ?? 'INR',
    note: j['note'] as String? ?? '',
    decidedAt: DateTime.tryParse('${j['decided_at']}')?.toLocal(),
  );
}

class ReportsApi {
  ReportsApi(this._dio);
  final Dio _dio;

  Future<T> _guard<T>(Future<T> Function() run) async {
    try {
      return await run();
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<List<SessionReport>> list() => _guard(() async {
    final res = (await _dio.get<List<dynamic>>(
      ApiPaths.astroDisputes,
    )).ensureOk();
    return [
      for (final row in res.data ?? const [])
        SessionReport.fromJson((row as Map).cast<String, dynamic>()),
    ];
  });

  Future<SessionReport> detail(String id) => _guard(() async {
    final res = (await _dio.get<Map<String, dynamic>>(
      ApiPaths.astroDispute(id),
    )).ensureOk();
    return SessionReport.fromJson(res.data ?? const {});
  });

  /// The astrologer's side of it. Accepted once.
  Future<SessionReport> respond(String id, String text) => _guard(() async {
    final res = (await _dio.post<Map<String, dynamic>>(
      ApiPaths.astroDisputeResponse(id),
      data: {'text': text},
    )).ensureOk();
    return SessionReport.fromJson(res.data ?? const {});
  });
}
