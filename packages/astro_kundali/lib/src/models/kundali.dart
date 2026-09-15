import 'package:freezed_annotation/freezed_annotation.dart';

import 'natal_planet.dart';

part 'kundali.freezed.dart';

/// One house of a chart: `{house, sign, planets:[names]}`.
@freezed
abstract class ChartHouse with _$ChartHouse {
  const factory ChartHouse({
    required int house,
    required String sign,
    @Default(<String>[]) List<String> planets,
  }) = _ChartHouse;

  factory ChartHouse.fromMap(Map<String, dynamic> j) => ChartHouse(
    house: (j['house'] as num).toInt(),
    sign: j['sign'] as String? ?? '',
    planets: (j['planets'] as List<dynamic>? ?? const [])
        .map((e) => e.toString())
        .toList(),
  );
}

/// The janma avakahada chakra — the classificatory attributes a traditional
/// birth chart prints, all derived from the Moon's nakshatra and rasi.
@freezed
abstract class BirthChakra with _$BirthChakra {
  const factory BirthChakra({
    @Default('') String nakshatra,
    @Default(0) int nakshatraPada,
    @Default('') String nakshatraLord,
    @Default('') String rasi,
    @Default('') String rasiLord,
    @Default('') String varna,
    @Default('') String vashya,
    @Default('') String yoni,
    @Default('') String gana,
    @Default('') String nadi,
    @Default('') String tara,
    @Default('') String tattva,
    @Default('') String yunja,
    @Default('') String rasiPaya,
    @Default('') String nakshatraPaya,
  }) = _BirthChakra;

  const BirthChakra._();

  bool get isEmpty => nakshatra.isEmpty && rasi.isEmpty;

  factory BirthChakra.fromMap(Map<String, dynamic> j) => BirthChakra(
    nakshatra: j['nakshatra'] as String? ?? '',
    nakshatraPada: (j['nakshatra_pada'] as num?)?.toInt() ?? 0,
    nakshatraLord: j['nakshatra_lord'] as String? ?? '',
    rasi: j['rasi'] as String? ?? '',
    rasiLord: j['rasi_lord'] as String? ?? '',
    varna: j['varna'] as String? ?? '',
    vashya: j['vashya'] as String? ?? '',
    yoni: j['yoni'] as String? ?? '',
    gana: j['gana'] as String? ?? '',
    nadi: j['nadi'] as String? ?? '',
    tara: j['tara'] as String? ?? '',
    tattva: j['tattva'] as String? ?? '',
    yunja: j['yunja'] as String? ?? '',
    rasiPaya: j['rasi_paya'] as String? ?? '',
    nakshatraPaya: j['nakshatra_paya'] as String? ?? '',
  );
}

/// The five panchang limbs running at the birth instant, plus sunrise/sunset
/// and the ishta kala (elapsed time since sunrise, in ghati/pala/vipala).
@freezed
abstract class BirthPanchang with _$BirthPanchang {
  const factory BirthPanchang({
    @Default('') String vaara,
    @Default('') String tithi,
    @Default('') String paksha,
    @Default('') String nakshatra,
    @Default(0) int nakshatraPada,
    @Default('') String yoga,
    @Default('') String karana,
    @Default('') String sunrise,
    @Default('') String sunset,
    @Default(0) int ishtaGhati,
    @Default(0) int ishtaPala,
    @Default(0) int ishtaVipala,
  }) = _BirthPanchang;

  const BirthPanchang._();

  bool get isEmpty => vaara.isEmpty && tithi.isEmpty;
  bool get hasIshta => ishtaGhati > 0 || ishtaPala > 0 || ishtaVipala > 0;

  factory BirthPanchang.fromMap(Map<String, dynamic> j) {
    Map<String, dynamic> m(Object? v) =>
        (v as Map?)?.cast<String, dynamic>() ?? const {};
    final tithi = m(j['tithi']);
    final nak = m(j['nakshatra']);
    final ishta = m(j['ishta_kala']);
    return BirthPanchang(
      vaara: j['vaara'] as String? ?? '',
      tithi: tithi['name'] as String? ?? '',
      paksha: tithi['paksha'] as String? ?? '',
      nakshatra: nak['name'] as String? ?? '',
      nakshatraPada: (nak['pada'] as num?)?.toInt() ?? 0,
      yoga: m(j['yoga'])['name'] as String? ?? '',
      karana: m(j['karana'])['name'] as String? ?? '',
      sunrise: j['sunrise'] as String? ?? '',
      sunset: j['sunset'] as String? ?? '',
      ishtaGhati: (ishta['ghati'] as num?)?.toInt() ?? 0,
      ishtaPala: (ishta['pala'] as num?)?.toInt() ?? 0,
      ishtaVipala: (ishta['vipala'] as num?)?.toInt() ?? 0,
    );
  }
}

/// Overview Manglik verdict — the same calculation as the Doshas screen and
/// matchmaking, cancellations included.
///
/// [status]: `manglik` (dosha active) · `cancelled` (Mars placement flagged but a
/// classical factor cancels it — **not** Manglik) · `clear`.
@freezed
abstract class MangalDosha with _$MangalDosha {
  const MangalDosha._();

  const factory MangalDosha({
    @Default(false) bool hasDosha,
    @Default('clear') String status,
    @Default(false) bool present,
    @Default(false) bool isCancelled,
    @Default('none') String severityLabel,
    @Default(<String>[]) List<String> from,
  }) = _MangalDosha;

  factory MangalDosha.fromMap(Map<String, dynamic> j) {
    final hasDosha = (j['has_dosha'] ?? false) as bool;
    final isCancelled = (j['is_cancelled'] ?? false) as bool;
    // Payloads from engines < 1.15 carry only has_dosha (raw, uncancelled).
    final present = (j['present'] as bool?) ?? hasDosha;
    final status =
        j['status'] as String? ??
        (hasDosha && !isCancelled ? 'manglik' : 'clear');
    return MangalDosha(
      hasDosha: status == 'manglik',
      status: status,
      present: present,
      isCancelled: isCancelled || status == 'cancelled',
      severityLabel: j['severity_label'] as String? ?? 'none',
      from: (j['from'] as List<dynamic>? ?? const [])
          .map((e) => e.toString())
          .toList(),
    );
  }

  bool get isManglik => status == 'manglik';
  bool get isCancelledManglik => status == 'cancelled';
}

@freezed
abstract class BasicYoga with _$BasicYoga {
  const factory BasicYoga({
    required String name,
    @Default('') String key,
    @Default('') String description,
  }) = _BasicYoga;

  factory BasicYoga.fromMap(Map<String, dynamic> j) => BasicYoga(
    name: j['name'] as String? ?? '',
    key: j['key'] as String? ?? '',
    description: j['description'] as String? ?? '',
  );
}

/// The consolidated `/app/birth-profiles/{id}/kundli` payload — everything the
/// Overview screen needs in one call.
@freezed
abstract class Kundali with _$Kundali {
  const factory Kundali({
    @Default('') String moonSign,
    @Default('') String sunSign,
    @Default('') String lagnaSign,
    @Default('') String nakshatra,
    @Default(0) int nakshatraPada,
    @Default('') String nakshatraLord,
    @Default('') String sunNakshatra,
    @Default(0) int sunNakshatraPada,
    @Default(<NatalPlanet>[]) List<NatalPlanet> planets,
    @Default(<ChartHouse>[]) List<ChartHouse> houses,
    @Default(MangalDosha()) MangalDosha mangalDosha,
    @Default(<BasicYoga>[]) List<BasicYoga> yogas,
    @Default(BirthChakra()) BirthChakra chakra,
    @Default(BirthPanchang()) BirthPanchang panchang,
    @Default(false) bool timeAssumed,
  }) = _Kundali;

  const Kundali._();

  factory Kundali.fromArtifact(Map<String, dynamic> envelope) {
    final p =
        (envelope['payload'] as Map?)?.cast<String, dynamic>() ?? envelope;
    final nak = (p['nakshatra'] as Map?)?.cast<String, dynamic>() ?? const {};
    return Kundali(
      timeAssumed: (envelope['time_assumed'] ?? false) as bool,
      moonSign: _nested(p, 'chandra_rasi', 'name'),
      sunSign: _nested(p, 'soorya_rasi', 'name'),
      lagnaSign: _nested(p, 'lagna', 'name'),
      nakshatra: nak['name'] as String? ?? '',
      nakshatraPada: (nak['pada'] as num?)?.toInt() ?? 0,
      nakshatraLord: nak['lord'] as String? ?? '',
      sunNakshatra: _nested(p, 'soorya_nakshatra', 'name'),
      sunNakshatraPada:
          ((p['soorya_nakshatra'] as Map?)?['pada'] as num?)?.toInt() ?? 0,
      chakra: BirthChakra.fromMap(
        (p['avakahada'] as Map?)?.cast<String, dynamic>() ?? const {},
      ),
      panchang: BirthPanchang.fromMap(
        (p['panchang'] as Map?)?.cast<String, dynamic>() ?? const {},
      ),
      planets: (p['planet_position'] as List<dynamic>? ?? const [])
          .map((e) => NatalPlanet.fromMap(e as Map<String, dynamic>))
          .toList(),
      houses: (p['houses'] as List<dynamic>? ?? const [])
          .map((e) => ChartHouse.fromMap(e as Map<String, dynamic>))
          .toList(),
      mangalDosha: MangalDosha.fromMap(
        (p['mangal_dosha'] as Map?)?.cast<String, dynamic>() ?? const {},
      ),
      yogas: (p['yoga'] as List<dynamic>? ?? const [])
          .map((e) => BasicYoga.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }

  NatalPlanet? planet(String name) {
    for (final p in planets) {
      if (p.name == name) return p;
    }
    return null;
  }

  /// House number (1-12) a sign sits in, given the ascendant.
  int? houseForSign(String sign) {
    for (final h in houses) {
      if (h.sign == sign) return h.house;
    }
    return null;
  }

  static String _nested(Map<String, dynamic> m, String key, String inner) =>
      ((m[key] as Map?)?[inner] as String?) ?? '';
}
