import 'package:equatable/equatable.dart';

/// A place the panchang is computed for.
class PanchangPlace extends Equatable {
  const PanchangPlace({
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  final String name;
  final double latitude;
  final double longitude;

  Map<String, Object> toJson() => {
    'name': name,
    'latitude': latitude,
    'longitude': longitude,
  };

  static PanchangPlace? fromJson(Map<String, dynamic>? j) {
    final lat = (j?['latitude'] as num?)?.toDouble();
    final lon = (j?['longitude'] as num?)?.toDouble();
    if (j == null || lat == null || lon == null) return null;
    return PanchangPlace(
      name: '${j['name'] ?? ''}',
      latitude: lat,
      longitude: lon,
    );
  }

  @override
  List<Object?> get props => [name, latitude, longitude];
}

/// A wall-clock instant in the *place's* own timezone, kept as the server wrote
/// it (`2026-09-13T22:41:05+05:30`) so it displays as local time there no
/// matter where the phone is.
class PlaceTime extends Equatable {
  const PlaceTime({
    required this.date,
    required this.hour,
    required this.minute,
  });

  /// Calendar date at the place.
  final DateTime date;
  final int hour;
  final int minute;

  /// A naive DateTime (no zone) for ordering and formatting.
  DateTime get local => DateTime(date.year, date.month, date.day, hour, minute);

  static PlaceTime? parseIso(String? raw) {
    if (raw == null || raw.length < 16) return null;
    final d = DateTime.tryParse(raw.substring(0, 10));
    final h = int.tryParse(raw.substring(11, 13));
    final m = int.tryParse(raw.substring(14, 16));
    if (d == null || h == null || m == null) return null;
    return PlaceTime(date: d, hour: h, minute: m);
  }

  /// `HH:MM[:SS]` on [on].
  static PlaceTime? parseClock(String? raw, DateTime on) {
    if (raw == null || raw.length < 5) return null;
    final h = int.tryParse(raw.substring(0, 2));
    final m = int.tryParse(raw.substring(3, 5));
    if (h == null || m == null) return null;
    return PlaceTime(date: on, hour: h, minute: m);
  }

  @override
  List<Object?> get props => [date, hour, minute];
}

/// The next calendar date — not `+24h`, which can land on the same date across
/// a daylight-saving change.
DateTime _nextDay(DateTime d) => DateTime(d.year, d.month, d.day + 1);

/// A start–end window.
class TimeWindow extends Equatable {
  const TimeWindow(this.start, this.end);
  final PlaceTime start;
  final PlaceTime end;

  bool contains(DateTime placeNow) =>
      !placeNow.isBefore(start.local) && placeNow.isBefore(end.local);

  @override
  List<Object?> get props => [start, end];
}

/// One of the five limbs with its active span, e.g. Saptami until 10:41 pm.
class PanchangLimb extends Equatable {
  const PanchangLimb({required this.name, this.detail = '', this.span});

  /// Canonical engine name (`Saptami`, `Rohini`, `Siddhi`, `Vanija`).
  final String name;

  /// Tithi paksha (`Shukla`) or nakshatra pada (`2`).
  final String detail;
  final TimeWindow? span;

  static PanchangLimb? fromList(Object? raw, {String detailKey = ''}) {
    final list = raw is List ? raw : const [];
    if (list.isEmpty || list.first is! Map) return null;
    final m = (list.first as Map).cast<String, dynamic>();
    final start = PlaceTime.parseIso(m['starts_at'] as String?);
    final end = PlaceTime.parseIso(m['ends_at'] as String?);
    return PanchangLimb(
      name: '${m['name'] ?? ''}',
      detail: detailKey.isEmpty ? '' : '${m[detailKey] ?? ''}',
      span: start != null && end != null ? TimeWindow(start, end) : null,
    );
  }

  @override
  List<Object?> get props => [name, detail, span];
}

class PanchangChoghadiya extends Equatable {
  const PanchangChoghadiya({
    required this.name,
    required this.quality,
    required this.window,
  });

  /// Engine key: `udveg` `char` `labh` `amrit` `kaal` `shubh` `rog`.
  final String name;

  /// `good` | `neutral` | `bad`.
  final String quality;
  final TimeWindow window;

  @override
  List<Object?> get props => [name, quality, window];
}

/// `GET /app/panchang` — one day at one place.
class DayPanchang extends Equatable {
  const DayPanchang({
    required this.date,
    this.place = '',
    this.timezone = '',
    this.vaara = '',
    this.tithi,
    this.nakshatra,
    this.yoga,
    this.karana,
    this.sunrise,
    this.sunset,
    this.moonSign = '',
    this.sunSign = '',
    this.rahuKaal,
    this.yamaganda,
    this.gulika,
    this.brahmaMuhurta,
    this.abhijit,
    this.dayChoghadiya = const [],
    this.nightChoghadiya = const [],
    this.notes = const [],
    this.utcOffset,
  });

  final DateTime date;
  final String place;
  final String timezone;
  final String vaara;
  final PanchangLimb? tithi;
  final PanchangLimb? nakshatra;
  final PanchangLimb? yoga;
  final PanchangLimb? karana;
  final PlaceTime? sunrise;
  final PlaceTime? sunset;
  final String moonSign;
  final String sunSign;
  final TimeWindow? rahuKaal;
  final TimeWindow? yamaganda;
  final TimeWindow? gulika;
  final TimeWindow? brahmaMuhurta;

  /// `null` on Wednesdays (not observed).
  final TimeWindow? abhijit;
  final List<PanchangChoghadiya> dayChoghadiya;
  final List<PanchangChoghadiya> nightChoghadiya;
  final List<({String title, String body})> notes;

  /// The place's offset from UTC (read off the element timestamps), used to
  /// tell what is running "now" there.
  final Duration? utcOffset;

  /// Wall-clock time at the place right now, or null if unknown.
  DateTime? placeNow([DateTime? nowUtc]) {
    final off = utcOffset;
    if (off == null) return null;
    final u = (nowUtc ?? DateTime.now()).toUtc().add(off);
    return DateTime(u.year, u.month, u.day, u.hour, u.minute, u.second);
  }

  factory DayPanchang.fromJson(Map<String, dynamic> j) {
    final p = (j['payload'] as Map?)?.cast<String, dynamic>() ?? const {};
    final date =
        DateTime.tryParse('${j['date'] ?? p['date']}') ?? DateTime.now();
    final day = DateTime(date.year, date.month, date.day);

    TimeWindow? clockWindow(Object? raw, DateTime on) {
      if (raw is! Map) return null;
      final s = PlaceTime.parseClock(raw['start'] as String?, on);
      var e = PlaceTime.parseClock(raw['end'] as String?, on);
      if (s == null || e == null) return null;
      if (e.local.isBefore(s.local)) {
        final next = _nextDay(on);
        e = PlaceTime(date: next, hour: e.hour, minute: e.minute);
      }
      return TimeWindow(s, e);
    }

    // Choghadiya slots are HH:MM; the night rolls past midnight, so walk the
    // list and move to the next date whenever the clock goes backwards.
    List<PanchangChoghadiya> slots(Object? raw) {
      final out = <PanchangChoghadiya>[];
      var on = day;
      DateTime? last;
      for (final item in raw is List ? raw : const []) {
        if (item is! Map) continue;
        var start = PlaceTime.parseClock(item['start'] as String?, on);
        if (start == null) continue;
        if (last != null && start.local.isBefore(last)) {
          on = _nextDay(on);
          start = PlaceTime(date: on, hour: start.hour, minute: start.minute);
        }
        var end = PlaceTime.parseClock(item['end'] as String?, on);
        if (end == null) continue;
        if (end.local.isBefore(start.local)) {
          on = _nextDay(on);
          end = PlaceTime(date: on, hour: end.hour, minute: end.minute);
        }
        last = end.local;
        out.add(
          PanchangChoghadiya(
            name: '${item['name'] ?? ''}',
            quality: '${item['quality'] ?? 'neutral'}',
            window: TimeWindow(start, end),
          ),
        );
      }
      return out;
    }

    final inausp = (p['inauspicious'] as Map?) ?? const {};
    final ausp = (p['auspicious'] as Map?) ?? const {};
    final chog = (p['choghadiya'] as Map?) ?? const {};

    return DayPanchang(
      date: day,
      place: '${j['place'] ?? ''}',
      timezone: '${j['timezone'] ?? ''}',
      vaara: '${p['vaara'] ?? ''}',
      tithi: PanchangLimb.fromList(p['tithi'], detailKey: 'paksha'),
      nakshatra: PanchangLimb.fromList(p['nakshatra'], detailKey: 'pada'),
      yoga: PanchangLimb.fromList(p['yoga']),
      karana: PanchangLimb.fromList(p['karana']),
      sunrise: PlaceTime.parseClock(p['sunrise'] as String?, day),
      sunset: PlaceTime.parseClock(p['sunset'] as String?, day),
      moonSign: '${p['moon_sign'] ?? ''}',
      sunSign: '${p['sun_sign'] ?? ''}',
      rahuKaal: clockWindow(inausp['rahu_kalam'], day),
      yamaganda: clockWindow(inausp['yamaganda'], day),
      gulika: clockWindow(inausp['gulika_kalam'], day),
      brahmaMuhurta: clockWindow(ausp['brahma_muhurta'], day),
      abhijit: clockWindow(ausp['abhijit_muhurta'], day),
      dayChoghadiya: slots(chog['day']),
      nightChoghadiya: slots(chog['night']),
      notes: [
        for (final n in (j['notes'] as List<dynamic>? ?? const []))
          if (n is Map)
            (title: '${n['title'] ?? ''}', body: '${n['body'] ?? ''}'),
      ],
      utcOffset: _offsetOf(p),
    );
  }

  static Duration? _offsetOf(Map<String, dynamic> p) {
    final raw = (p['tithi'] is List && (p['tithi'] as List).isNotEmpty)
        ? ((p['tithi'] as List).first as Map)['starts_at'] as String?
        : null;
    if (raw == null) return null;
    final m = RegExp(r'([+-])(\d{2}):(\d{2})$').firstMatch(raw);
    if (m == null) return raw.endsWith('Z') ? Duration.zero : null;
    final d = Duration(
      hours: int.parse(m.group(2)!),
      minutes: int.parse(m.group(3)!),
    );
    return m.group(1) == '-' ? -d : d;
  }

  @override
  List<Object?> get props => [date, place, vaara, tithi, nakshatra, sunrise];
}
