import 'package:flutter/material.dart' show IconData, Icons;
import 'package:freezed_annotation/freezed_annotation.dart';

part 'remedy.freezed.dart';

/// One traditional remedy from `/app/birth-profiles/{id}/remedies`. Editorial
/// content matched to the chart — never computed. [gated] remedies (gemstone /
/// yantra / rudraksha) must be confirmed with an astrologer first.
@freezed
abstract class Remedy with _$Remedy {
  const factory Remedy({
    @Default('') String key,
    @Default('') String category,
    @Default('') String title,
    @Default('') String body,
    @Default('') String caution,
    @Default(false) bool gated,
    @Default('traditional') String source,
    @Default('') String triggerType,
    @Default('') String triggerValue,
  }) = _Remedy;

  factory Remedy.fromMap(Map<String, dynamic> j) => Remedy(
    key: j['key'] as String? ?? '',
    category: j['category'] as String? ?? '',
    title: j['title'] as String? ?? '',
    body: j['body'] as String? ?? '',
    caution: j['caution'] as String? ?? '',
    gated: j['gated'] as bool? ?? false,
    source: j['source'] as String? ?? 'traditional',
    triggerType: j['trigger_type'] as String? ?? '',
    triggerValue: j['trigger_value'] as String? ?? '',
  );
}

@freezed
abstract class RemedyGroup with _$RemedyGroup {
  const factory RemedyGroup({
    required String category,
    @Default(<Remedy>[]) List<Remedy> items,
  }) = _RemedyGroup;

  factory RemedyGroup.fromMap(Map<String, dynamic> j) => RemedyGroup(
    category: j['category'] as String? ?? '',
    items: (j['items'] as List<dynamic>? ?? const [])
        .map((e) => Remedy.fromMap((e as Map).cast<String, dynamic>()))
        .toList(),
  );
}

/// The whole `/remedies` payload.
@freezed
abstract class RemedyReport with _$RemedyReport {
  const RemedyReport._();

  const factory RemedyReport({
    @Default(0) int count,
    @Default(<RemedyGroup>[]) List<RemedyGroup> groups,
    @Default('') String gatedNote,
    @Default('') String disclaimer,
  }) = _RemedyReport;

  factory RemedyReport.fromMap(Map<String, dynamic> p) => RemedyReport(
    count: (p['count'] as num?)?.toInt() ?? 0,
    groups: (p['groups'] as List<dynamic>? ?? const [])
        .map((e) => RemedyGroup.fromMap((e as Map).cast<String, dynamic>()))
        .toList(),
    gatedNote: p['gated_note'] as String? ?? '',
    disclaimer: p['disclaimer'] as String? ?? '',
  );

  factory RemedyReport.fromArtifact(Map<String, dynamic> envelope) {
    final p =
        (envelope['payload'] as Map?)?.cast<String, dynamic>() ?? envelope;
    return RemedyReport.fromMap(p);
  }

  bool get isEmpty => groups.isEmpty;

  bool get hasGated => groups.any((g) => g.items.any((r) => r.gated));
}

/// English fallback for a remedy category — the client localises via ARB.
class RemedyCategoryInfo {
  const RemedyCategoryInfo._();

  static String label(String category) => switch (category) {
    'mantra' => 'Mantra & japa',
    'stotra' => 'Stotra & path',
    'puja' => 'Puja & ritual',
    'vrat' => 'Vrat & fasting',
    'daan' => 'Daan & charity',
    'lifestyle' => 'Lifestyle',
    'yantra' => 'Yantra',
    'gemstone' => 'Gemstone',
    'rudraksha' => 'Rudraksha',
    _ => category,
  };

  static IconData icon(String category) => switch (category) {
    'mantra' => Icons.self_improvement_rounded,
    'stotra' => Icons.menu_book_rounded,
    'puja' => Icons.local_fire_department_outlined,
    'vrat' => Icons.no_food_outlined,
    'daan' => Icons.volunteer_activism_outlined,
    'lifestyle' => Icons.spa_outlined,
    'yantra' => Icons.grid_4x4_rounded,
    'gemstone' => Icons.diamond_outlined,
    'rudraksha' => Icons.circle_outlined,
    _ => Icons.auto_awesome_outlined,
  };

  static bool isGated(String category) =>
      category == 'gemstone' || category == 'yantra' || category == 'rudraksha';
}
