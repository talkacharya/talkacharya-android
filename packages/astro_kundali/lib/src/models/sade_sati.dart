import 'package:freezed_annotation/freezed_annotation.dart';

part 'sade_sati.freezed.dart';

/// One dated Saturn phase (Sade Sati rising/peak/setting, or Dhaiya
/// kantaka/ashtama) from `/app/birth-profiles/{id}/sade-sati`.
@freezed
abstract class SadeSatiPhase with _$SadeSatiPhase {
  const SadeSatiPhase._();

  const factory SadeSatiPhase({
    @Default('') String key,
    @Default('') String kind, // sade_sati | dhaiya
    @Default('') String phase, // rising | peak | setting | kantaka | ashtama
    @Default('') String sign,
    @Default(0) int houseFromMoon,
    @Default('') String start,
    @Default('') String end,
    @Default(false) bool running,
    @Default(false) bool past,
    @Default('') String summary,
  }) = _SadeSatiPhase;

  factory SadeSatiPhase.fromMap(Map<String, dynamic> j) => SadeSatiPhase(
    key: j['key'] as String? ?? '',
    kind: j['kind'] as String? ?? '',
    phase: j['phase'] as String? ?? '',
    sign: j['sign'] as String? ?? '',
    houseFromMoon: (j['house_from_moon'] as num?)?.toInt() ?? 0,
    start: j['start'] as String? ?? '',
    end: j['end'] as String? ?? '',
    running: j['running'] as bool? ?? false,
    past: j['past'] as bool? ?? false,
    summary: j['summary'] as String? ?? '',
  );

  bool get isSadeSati => kind == 'sade_sati';
}

@freezed
abstract class SadeSatiPeriod with _$SadeSatiPeriod {
  const factory SadeSatiPeriod({
    @Default('') String start,
    @Default('') String end,
    @Default(false) bool running,
    @Default(false) bool past,
    @Default(<String>[]) List<String> signs,
    @Default(<SadeSatiPhase>[]) List<SadeSatiPhase> phases,
  }) = _SadeSatiPeriod;

  factory SadeSatiPeriod.fromMap(Map<String, dynamic> j) => SadeSatiPeriod(
    start: j['start'] as String? ?? '',
    end: j['end'] as String? ?? '',
    running: j['running'] as bool? ?? false,
    past: j['past'] as bool? ?? false,
    signs: (j['signs'] as List<dynamic>? ?? const [])
        .map((e) => e.toString())
        .toList(),
    phases: (j['phases'] as List<dynamic>? ?? const [])
        .map((e) => SadeSatiPhase.fromMap((e as Map).cast<String, dynamic>()))
        .toList(),
  );
}

@freezed
abstract class SadeSatiCalendar with _$SadeSatiCalendar {
  const SadeSatiCalendar._();

  const factory SadeSatiCalendar({
    @Default('') String natalMoonSign,
    SadeSatiPhase? current,
    SadeSatiPhase? next,
    @Default(<SadeSatiPeriod>[]) List<SadeSatiPeriod> sadeSatiPeriods,
    @Default(<SadeSatiPhase>[]) List<SadeSatiPhase> dhaiyaPeriods,
    @Default(<SadeSatiPhase>[]) List<SadeSatiPhase> phases,
    @Default('') String summary,
    @Default('') String disclaimer,
  }) = _SadeSatiCalendar;

  factory SadeSatiCalendar.fromMap(Map<String, dynamic> p) {
    SadeSatiPhase? phase(Object? v) => v is Map
        ? SadeSatiPhase.fromMap(v.cast<String, dynamic>())
        : null;
    return SadeSatiCalendar(
      natalMoonSign: p['natal_moon_sign'] as String? ?? '',
      current: phase(p['current']),
      next: phase(p['next']),
      sadeSatiPeriods: (p['sade_sati_periods'] as List<dynamic>? ?? const [])
          .map((e) => SadeSatiPeriod.fromMap((e as Map).cast<String, dynamic>()))
          .toList(),
      dhaiyaPeriods: (p['dhaiya_periods'] as List<dynamic>? ?? const [])
          .map((e) => SadeSatiPhase.fromMap((e as Map).cast<String, dynamic>()))
          .toList(),
      phases: (p['phases'] as List<dynamic>? ?? const [])
          .map((e) => SadeSatiPhase.fromMap((e as Map).cast<String, dynamic>()))
          .toList(),
      summary: p['summary'] as String? ?? '',
      disclaimer: p['disclaimer'] as String? ?? '',
    );
  }

  factory SadeSatiCalendar.fromArtifact(Map<String, dynamic> envelope) {
    final p =
        (envelope['payload'] as Map?)?.cast<String, dynamic>() ?? envelope;
    return SadeSatiCalendar.fromMap(p);
  }

  bool get anyActive => current != null;
}
