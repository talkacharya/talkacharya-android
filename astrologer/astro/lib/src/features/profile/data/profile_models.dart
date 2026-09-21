import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart' show TimeOfDay;

import '../../../core/util/json.dart';

/// Consultation channels an astrologer can price and enable (backend
/// `common.enums.CONSULTATION_CHANNELS`).
const kChannels = ['chat', 'voice', 'video'];

/// Platform-set allowed per-minute range (`GET /astro/rates/bands`).
class RateBand extends Equatable {
  const RateBand({
    required this.channel,
    required this.currency,
    required this.min,
    required this.max,
    required this.suggested,
  });

  final String channel;
  final String currency;
  final double min;
  final double max;
  final double suggested;

  double clamp(double v) => v.clamp(min, max).toDouble();
  bool contains(double v) => v >= min && v <= max;

  factory RateBand.fromJson(Map<String, dynamic> j) => RateBand(
    channel: j['channel'] as String? ?? '',
    currency: j['currency'] as String? ?? 'INR',
    min: toDouble(j['min_per_minute']),
    max: toDouble(j['max_per_minute']),
    suggested: toDouble(j['default_per_minute']),
  );

  @override
  List<Object?> get props => [channel, currency, min, max, suggested];
}

/// One weekly working window (`weekday` 0 = Monday … 6 = Sunday).
class WorkingWindow extends Equatable {
  const WorkingWindow({
    required this.weekday,
    required this.start,
    required this.end,
  });

  final int weekday;
  final TimeOfDay start;
  final TimeOfDay end;

  bool get isValid => _minutes(end) > _minutes(start);

  WorkingWindow copyWith({TimeOfDay? start, TimeOfDay? end, int? weekday}) =>
      WorkingWindow(
        weekday: weekday ?? this.weekday,
        start: start ?? this.start,
        end: end ?? this.end,
      );

  factory WorkingWindow.fromJson(Map<String, dynamic> j) => WorkingWindow(
    weekday: (j['weekday'] as num?)?.toInt() ?? 0,
    start: parseTime('${j['start_time']}'),
    end: parseTime('${j['end_time']}'),
  );

  Map<String, dynamic> toJson() => {
    'weekday': weekday,
    'start_time': formatTime(start),
    'end_time': formatTime(end),
  };

  static int _minutes(TimeOfDay t) => t.hour * 60 + t.minute;

  /// "09:30" or "09:30:00" → 09:30.
  static TimeOfDay parseTime(String s) {
    final p = s.split(':');
    return TimeOfDay(
      hour: int.tryParse(p.first) ?? 0,
      minute: p.length > 1 ? int.tryParse(p[1]) ?? 0 : 0,
    );
  }

  static String formatTime(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  @override
  List<Object?> get props => [weekday, start, end];
}

/// `GET/PUT /astro/availability` (the non-presence settings).
class AvailabilitySettings extends Equatable {
  const AvailabilitySettings({
    required this.channels,
    required this.maxConcurrent,
  });

  final List<String> channels;
  final int maxConcurrent;

  factory AvailabilitySettings.fromJson(Map<String, dynamic> j) =>
      AvailabilitySettings(
        channels: (j['channels_enabled'] as List? ?? const [])
            .map((e) => e.toString())
            .toList(),
        maxConcurrent: (j['max_concurrent_chats'] as num?)?.toInt() ?? 1,
      );

  @override
  List<Object?> get props => [channels, maxConcurrent];
}

class Review extends Equatable {
  const Review({
    required this.id,
    required this.rating,
    required this.text,
    required this.status,
    required this.customerName,
    required this.reply,
    required this.helpfulCount,
    required this.createdAt,
  });

  final String id;
  final int rating;
  final String text;

  /// published | pending_moderation | hidden | removed
  final String status;
  final String customerName;
  final String reply;
  final int helpfulCount;
  final DateTime? createdAt;

  bool get hasReply => reply.trim().isNotEmpty;
  bool get isPublished => status == 'published';

  Review withReply(String text) => Review(
    id: id,
    rating: rating,
    text: this.text,
    status: status,
    customerName: customerName,
    reply: text,
    helpfulCount: helpfulCount,
    createdAt: createdAt,
  );

  factory Review.fromJson(Map<String, dynamic> j) => Review(
    id: '${j['id'] ?? j['public_id'] ?? ''}',
    rating: ((j['rating'] as num?)?.toInt() ?? 0).clamp(0, 5),
    text: j['text'] as String? ?? '',
    status: j['status'] as String? ?? 'published',
    customerName: j['customer_name'] as String? ?? '',
    reply: j['astrologer_reply'] as String? ?? '',
    helpfulCount: (j['helpful_count'] as num?)?.toInt() ?? 0,
    createdAt: DateTime.tryParse('${j['created_at']}'),
  );

  @override
  List<Object?> get props => [id, rating, text, status, reply];
}

/// A skill or language from `/reference/*`.
class RefOption extends Equatable {
  const RefOption({required this.code, required this.name});

  final String code;
  final String name;

  factory RefOption.skill(Map<String, dynamic> j) => RefOption(
    code: j['slug'] as String? ?? '',
    name: j['name'] as String? ?? '${j['slug']}',
  );

  factory RefOption.language(Map<String, dynamic> j) => RefOption(
    code: j['code'] as String? ?? '',
    name: (j['native_name'] as String?)?.isNotEmpty == true
        ? j['native_name'] as String
        : j['name'] as String? ?? '${j['code']}',
  );

  @override
  List<Object?> get props => [code, name];
}

/// `FeaturedPlacement` values.
const kFeaturedPlacements = ['home_hero', 'category_top', 'search_boost'];

/// `GET /astro/featured-slots/pricing`.
class FeaturedPricing extends Equatable {
  const FeaturedPricing({required this.maxDays, required this.perDay});

  final int maxDays;

  /// placement → currency → price per day.
  final Map<String, Map<String, double>> perDay;

  double? priceFor(String placement, [String currency = 'INR']) =>
      perDay[placement]?[currency];

  factory FeaturedPricing.fromJson(Map<String, dynamic> j) => FeaturedPricing(
    maxDays: (j['max_days'] as num?)?.toInt() ?? 30,
    perDay: {
      for (final e in ((j['per_day'] as Map?) ?? const {}).entries)
        '${e.key}': {
          for (final c in ((e.value as Map?) ?? const {}).entries)
            '${c.key}': toDouble(c.value),
        },
    },
  );

  @override
  List<Object?> get props => [maxDays, perDay];
}

class FeaturedSlot extends Equatable {
  const FeaturedSlot({
    required this.id,
    required this.placement,
    required this.skill,
    required this.startsAt,
    required this.endsAt,
    required this.status,
    required this.price,
    required this.currency,
    required this.notes,
  });

  final String id;
  final String placement;
  final String? skill;
  final DateTime? startsAt;
  final DateTime? endsAt;

  /// requested | scheduled | active | expired | cancelled | rejected
  final String status;
  final double price;
  final String currency;
  final String notes;

  factory FeaturedSlot.fromJson(Map<String, dynamic> j) => FeaturedSlot(
    id: '${j['id'] ?? ''}',
    placement: j['placement'] as String? ?? '',
    skill: j['skill'] as String?,
    startsAt: DateTime.tryParse('${j['starts_at']}'),
    endsAt: DateTime.tryParse('${j['ends_at']}'),
    status: j['status'] as String? ?? 'requested',
    price: toDouble(j['price_amount']),
    currency: j['currency'] as String? ?? 'INR',
    notes: j['notes'] as String? ?? '',
  );

  @override
  List<Object?> get props => [id, status, startsAt, endsAt];
}
