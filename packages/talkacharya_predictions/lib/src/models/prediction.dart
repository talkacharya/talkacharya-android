import 'package:freezed_annotation/freezed_annotation.dart';

import 'prediction_enums.dart';

part 'prediction.freezed.dart';

/// One prediction request from `/app/predictions` or `/astro/predictions/queue`.
/// The astrologer view additionally carries [factorBrief] + [aiDraft] +
/// [claimedAt]; the customer view never sees them.
@freezed
abstract class Prediction with _$Prediction {
  const Prediction._();

  const factory Prediction({
    required String id,
    required PredictionArea area,
    required PredictionPeriod period,
    required PredictionStatus status,
    @Default('') String birthProfileId,
    @Default('') String profileLabel,
    @Default('en') String language,
    @Default('') String title,
    @Default('') String body,
    @Default('') String astrologerName,
    @Default('') String pricePaid,
    @Default('INR') String currency,
    DateTime? createdAt,
    DateTime? deliveredAt,
    DateTime? dueAt,
    DateTime? claimedAt,
    Map<String, dynamic>? factorBrief,
    @Default('') String aiDraft,
  }) = _Prediction;

  factory Prediction.fromMap(Map<String, dynamic> j) => Prediction(
    id: j['id']?.toString() ?? '',
    area: PredictionArea.fromWire(j['area'] as String? ?? 'general'),
    period: PredictionPeriod.fromWire(j['period'] as String? ?? 'year'),
    status: PredictionStatus.fromWire(j['status'] as String? ?? 'requested'),
    birthProfileId: j['birth_profile']?.toString() ?? '',
    profileLabel: j['profile_label'] as String? ?? '',
    language: j['language'] as String? ?? 'en',
    title: j['title'] as String? ?? '',
    body: j['body'] as String? ?? '',
    astrologerName: j['astrologer_name'] as String? ?? '',
    pricePaid: j['price_paid']?.toString() ?? '',
    currency: j['currency'] as String? ?? 'INR',
    createdAt: _dt(j['created_at']),
    deliveredAt: _dt(j['delivered_at']),
    dueAt: _dt(j['due_at']),
    claimedAt: _dt(j['claimed_at']),
    factorBrief: (j['factor_brief'] as Map?)?.cast<String, dynamic>(),
    aiDraft: j['ai_draft'] as String? ?? '',
  );

  static DateTime? _dt(Object? v) =>
      v is String && v.isNotEmpty ? DateTime.tryParse(v) : null;

  int get bodyWordCount =>
      body.trim().isEmpty ? 0 : body.trim().split(RegExp(r'\s+')).length;
}
