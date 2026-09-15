import 'package:freezed_annotation/freezed_annotation.dart';

part 'birth_profile.freezed.dart';
part 'birth_profile.g.dart';

/// A birth record the user owns (self, partner, family). Mirrors the backend
/// `BirthProfileSerializer` (`GET/POST /app/birth-profiles`).
@freezed
abstract class BirthProfile with _$BirthProfile {
  const factory BirthProfile({
    required String id,
    @Default('') String label,
    @Default('self') String relation,
    @JsonKey(name: 'full_name') @Default('') String fullName,
    @Default('other') String gender,
    @JsonKey(name: 'birth_date') required String birthDate,
    @JsonKey(name: 'birth_time') String? birthTime,
    @JsonKey(name: 'birth_time_accuracy')
    @Default('exact')
    String birthTimeAccuracy,
    @JsonKey(name: 'birth_place_name') @Default('') String birthPlaceName,
    @Default('0') String latitude,
    @Default('0') String longitude,
    @JsonKey(name: 'birth_timezone') @Default('') String birthTimezone,
    @JsonKey(name: 'time_assumed') @Default(false) bool timeAssumed,
    @JsonKey(name: 'is_primary') @Default(false) bool isPrimary,
    @JsonKey(name: 'created_at') DateTime? createdAt,

    /// Vedic signs from the backend engine (null when it couldn't compute).
    ProfileSigns? signs,
  }) = _BirthProfile;

  const BirthProfile._();

  factory BirthProfile.fromJson(Map<String, dynamic> json) =>
      _$BirthProfileFromJson(json);

  String get displayName => fullName.isNotEmpty ? fullName : label;

  /// Chandra rasi (sidereal Moon sign) — the sign Vedic horoscopes are read for.
  String? get moonSign => signs?.moonSign;

  /// e.g. "Self · 14 Aug 1994"
  String get subtitle {
    final rel = relation.isEmpty
        ? ''
        : relation[0].toUpperCase() + relation.substring(1);
    return [rel, birthDate].where((s) => s.isNotEmpty).join(' · ');
  }
}

/// `signs` on a birth profile: sidereal Moon sign (rasi), Sun sign, lagna (null
/// when the birth time is unknown) and the Moon's nakshatra. English names.
@freezed
abstract class ProfileSigns with _$ProfileSigns {
  const factory ProfileSigns({
    @JsonKey(name: 'moon_sign') @Default('') String moonSign,
    @JsonKey(name: 'sun_sign') @Default('') String sunSign,
    String? lagna,
    @Default('') String nakshatra,
  }) = _ProfileSigns;

  factory ProfileSigns.fromJson(Map<String, dynamic> json) =>
      _$ProfileSignsFromJson(json);
}
