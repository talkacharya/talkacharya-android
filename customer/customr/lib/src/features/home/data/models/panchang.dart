import 'package:equatable/equatable.dart';

/// Today's panchang, flattened from `GET /app/birth-profiles/{id}/panchang`.
/// Provider payloads vary; each element may be a `{name: ...}` map, a list of
/// those, or a bare string.
class Panchang extends Equatable {
  const Panchang({
    this.tithi,
    this.nakshatra,
    this.yoga,
    this.karana,
    this.vaara,
    this.sunrise,
    this.sunset,
  });

  final String? tithi;
  final String? nakshatra;
  final String? yoga;
  final String? karana;
  final String? vaara;
  final String? sunrise;
  final String? sunset;

  bool get isEmpty =>
      tithi == null && nakshatra == null && yoga == null && sunrise == null;

  factory Panchang.fromArtifact(Map<String, dynamic> json) {
    final p = (json['payload'] as Map?)?.cast<String, dynamic>() ?? const {};

    String? pick(String key) {
      final v = p[key];
      if (v == null) return null;
      final first = v is List ? (v.isEmpty ? null : v.first) : v;
      if (first == null) return null;
      if (first is Map) {
        final name = first['name'] ?? first['tithi'] ?? first['value'];
        return name?.toString();
      }
      return first.toString();
    }

    String? time(String key) {
      final v = p[key]?.toString();
      if (v == null || v.isEmpty) return null;
      // "06:12:00" -> "06:12"
      final parts = v.split(':');
      return parts.length >= 2 ? '${parts[0]}:${parts[1]}' : v;
    }

    return Panchang(
      tithi: pick('tithi'),
      nakshatra: pick('nakshatra'),
      yoga: pick('yoga'),
      karana: pick('karana'),
      vaara: pick('vaara') ?? pick('vara') ?? pick('day'),
      sunrise: time('sunrise'),
      sunset: time('sunset'),
    );
  }

  @override
  List<Object?> get props => [
    tithi,
    nakshatra,
    yoga,
    karana,
    vaara,
    sunrise,
    sunset,
  ];
}
