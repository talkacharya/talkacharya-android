import 'package:freezed_annotation/freezed_annotation.dart';

part 'muhurta.freezed.dart';

/// One Choghadiya slot from `/app/birth-profiles/{id}/muhurta`.
@freezed
abstract class ChoghadiyaSlot with _$ChoghadiyaSlot {
  const ChoghadiyaSlot._();

  const factory ChoghadiyaSlot({
    @Default('') String key,
    @Default('day') String period, // day | night
    @Default(0) int index,
    @Default('') String name,
    @Default('') String lord,
    @Default('neutral') String quality, // good | bad | neutral
    @Default('') String start,
    @Default('') String end,
    @Default(false) bool running,
  }) = _ChoghadiyaSlot;

  factory ChoghadiyaSlot.fromMap(Map<String, dynamic> j) => ChoghadiyaSlot(
    key: j['key'] as String? ?? '',
    period: j['period'] as String? ?? 'day',
    index: (j['index'] as num?)?.toInt() ?? 0,
    name: j['name'] as String? ?? '',
    lord: j['lord'] as String? ?? '',
    quality: j['quality'] as String? ?? 'neutral',
    start: j['start'] as String? ?? '',
    end: j['end'] as String? ?? '',
    running: j['running'] as bool? ?? false,
  );
}

/// One planetary Hora.
@freezed
abstract class HoraSlot with _$HoraSlot {
  const factory HoraSlot({
    @Default('') String key,
    @Default(0) int index,
    @Default('day') String period,
    @Default('') String lord,
    @Default('') String start,
    @Default('') String end,
    @Default(false) bool running,
    @Default('') String goodFor,
    @Default('neutral') String personal, // favourable | caution | neutral
  }) = _HoraSlot;

  factory HoraSlot.fromMap(Map<String, dynamic> j) => HoraSlot(
    key: j['key'] as String? ?? '',
    index: (j['index'] as num?)?.toInt() ?? 0,
    period: j['period'] as String? ?? 'day',
    lord: j['lord'] as String? ?? '',
    start: j['start'] as String? ?? '',
    end: j['end'] as String? ?? '',
    running: j['running'] as bool? ?? false,
    goodFor: j['good_for'] as String? ?? '',
    personal: j['personal'] as String? ?? 'neutral',
  );
}

@freezed
abstract class MuhurtaBestWindow with _$MuhurtaBestWindow {
  const factory MuhurtaBestWindow({
    @Default('') String start,
    @Default('') String end,
    @Default('') String horaLord,
    @Default('') String choghadiya,
    @Default('') String summary,
  }) = _MuhurtaBestWindow;

  factory MuhurtaBestWindow.fromMap(Map<String, dynamic> j) => MuhurtaBestWindow(
    start: j['start'] as String? ?? '',
    end: j['end'] as String? ?? '',
    horaLord: j['hora_lord'] as String? ?? '',
    choghadiya: j['choghadiya'] as String? ?? '',
    summary: j['summary'] as String? ?? '',
  );
}

@freezed
abstract class MuhurtaDay with _$MuhurtaDay {
  const MuhurtaDay._();

  const factory MuhurtaDay({
    @Default(false) bool available,
    @Default('') String date,
    @Default('') String weekday,
    @Default('') String dayLord,
    @Default('') String sunrise,
    @Default('') String sunset,
    @Default(<ChoghadiyaSlot>[]) List<ChoghadiyaSlot> choghadiya,
    @Default(<HoraSlot>[]) List<HoraSlot> horas,
    MuhurtaBestWindow? abhijit,
    @Default(<MuhurtaBestWindow>[]) List<MuhurtaBestWindow> bestWindows,
    ChoghadiyaSlot? currentChoghadiya,
    HoraSlot? currentHora,
    @Default(<String>[]) List<String> favourablePlanets,
    @Default(<String>[]) List<String> cautionPlanets,
    @Default('') String summary,
    @Default('') String disclaimer,
  }) = _MuhurtaDay;

  factory MuhurtaDay.fromMap(Map<String, dynamic> p) {
    final cur = (p['current'] as Map?)?.cast<String, dynamic>() ?? const {};
    final ab = p['abhijit'];
    return MuhurtaDay(
      available: p['available'] as bool? ?? false,
      date: p['date'] as String? ?? '',
      weekday: p['weekday'] as String? ?? '',
      dayLord: p['day_lord'] as String? ?? '',
      sunrise: p['sunrise'] as String? ?? '',
      sunset: p['sunset'] as String? ?? '',
      choghadiya: (p['choghadiya'] as List<dynamic>? ?? const [])
          .map((e) => ChoghadiyaSlot.fromMap((e as Map).cast<String, dynamic>()))
          .toList(),
      horas: (p['horas'] as List<dynamic>? ?? const [])
          .map((e) => HoraSlot.fromMap((e as Map).cast<String, dynamic>()))
          .toList(),
      abhijit: ab is Map
          ? MuhurtaBestWindow.fromMap(ab.cast<String, dynamic>())
          : null,
      bestWindows: (p['best_windows'] as List<dynamic>? ?? const [])
          .map((e) => MuhurtaBestWindow.fromMap((e as Map).cast<String, dynamic>()))
          .toList(),
      currentChoghadiya: cur['choghadiya'] is Map
          ? ChoghadiyaSlot.fromMap((cur['choghadiya'] as Map).cast<String, dynamic>())
          : null,
      currentHora: cur['hora'] is Map
          ? HoraSlot.fromMap((cur['hora'] as Map).cast<String, dynamic>())
          : null,
      favourablePlanets: (p['favourable_planets'] as List<dynamic>? ?? const [])
          .map((e) => e.toString())
          .toList(),
      cautionPlanets: (p['caution_planets'] as List<dynamic>? ?? const [])
          .map((e) => e.toString())
          .toList(),
      summary: p['summary'] as String? ?? '',
      disclaimer: p['disclaimer'] as String? ?? '',
    );
  }

  factory MuhurtaDay.fromArtifact(Map<String, dynamic> envelope) {
    final p =
        (envelope['payload'] as Map?)?.cast<String, dynamic>() ?? envelope;
    return MuhurtaDay.fromMap(p);
  }

  List<ChoghadiyaSlot> get dayChoghadiya =>
      choghadiya.where((c) => c.period == 'day').toList();
  List<ChoghadiyaSlot> get nightChoghadiya =>
      choghadiya.where((c) => c.period == 'night').toList();
}
