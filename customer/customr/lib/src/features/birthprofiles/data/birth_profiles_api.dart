import 'package:dio/dio.dart';

import '../../../core/constants/api_paths.dart';
import '../../../core/network/api_exception.dart';
import 'models/birth_profile.dart';
import 'models/place.dart';

/// Fields the create form collects. `birthTime` null ⇒ backend forces accuracy
/// to "unknown".
class NewBirthProfile {
  const NewBirthProfile({
    required this.label,
    required this.relation,
    required this.gender,
    required this.birthDate,
    required this.placeId,
    this.fullName = '',
    this.birthTime,
    this.birthTimeAccuracy = 'exact',
    this.makePrimary = false,
  });

  final String label;
  final String relation;
  final String gender;
  final String fullName;

  /// `YYYY-MM-DD`
  final String birthDate;

  /// `HH:mm:ss` or null
  final String? birthTime;
  final String birthTimeAccuracy;
  final String placeId;
  final bool makePrimary;

  Map<String, dynamic> toJson() => {
    'label': label,
    'relation': relation,
    'gender': gender,
    'full_name': fullName,
    'birth_date': birthDate,
    'birth_time': birthTime,
    'birth_time_accuracy': birthTime == null ? 'unknown' : birthTimeAccuracy,
    'place_id': placeId,
    'make_primary': makePrimary,
  };
}

/// A partial edit for `PATCH /app/birth-profiles/{id}`. Only the non-null
/// fields are sent; the place is only re-geocoded when [placeId] is given (so
/// changing just the birth time keeps the existing coordinates).
class EditBirthProfile {
  const EditBirthProfile({
    this.label,
    this.relation,
    this.gender,
    this.fullName,
    this.birthDate,
    this.birthTime,
    this.clearBirthTime = false,
    this.birthTimeAccuracy,
    this.placeId,
  });

  final String? label;
  final String? relation;
  final String? gender;
  final String? fullName;

  /// `YYYY-MM-DD`
  final String? birthDate;

  /// `HH:mm:ss` — ignored when [clearBirthTime] is true.
  final String? birthTime;

  /// Send `birth_time: null` (⇒ backend forces accuracy to "unknown").
  final bool clearBirthTime;
  final String? birthTimeAccuracy;

  /// Only set when the user picks a new birth place.
  final String? placeId;

  Map<String, dynamic> toJson() {
    final m = <String, dynamic>{};
    if (label != null) m['label'] = label;
    if (relation != null) m['relation'] = relation;
    if (gender != null) m['gender'] = gender;
    if (fullName != null) m['full_name'] = fullName;
    if (birthDate != null) m['birth_date'] = birthDate;
    if (clearBirthTime) {
      m['birth_time'] = null;
      m['birth_time_accuracy'] = 'unknown';
    } else {
      if (birthTime != null) m['birth_time'] = birthTime;
      if (birthTimeAccuracy != null) {
        m['birth_time_accuracy'] = birthTimeAccuracy;
      }
    }
    if (placeId != null) m['place_id'] = placeId;
    return m;
  }

  bool get isEmpty => toJson().isEmpty;
}

class BirthProfilesApi {
  BirthProfilesApi(this._dio);

  final Dio _dio;

  Future<List<BirthProfile>> list() async {
    try {
      final res = await _dio.get<List<dynamic>>(ApiPaths.birthProfiles);
      if ((res.statusCode ?? 0) >= 400) {
        throw ApiException.fromDio(
          DioException(requestOptions: res.requestOptions, response: res),
        );
      }
      return (res.data ?? const [])
          .map((e) => BirthProfile.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<BirthProfile> create(NewBirthProfile input) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        ApiPaths.birthProfiles,
        data: input.toJson(),
      );
      if ((res.statusCode ?? 0) >= 400) {
        throw ApiException.fromDio(
          DioException(requestOptions: res.requestOptions, response: res),
        );
      }
      return BirthProfile.fromJson(res.data ?? const {});
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<BirthProfile> update(String id, EditBirthProfile input) async {
    try {
      final res = await _dio.patch<Map<String, dynamic>>(
        ApiPaths.birthProfile(id),
        data: input.toJson(),
      );
      if ((res.statusCode ?? 0) >= 400) {
        throw ApiException.fromDio(
          DioException(requestOptions: res.requestOptions, response: res),
        );
      }
      return BirthProfile.fromJson(res.data ?? const {});
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<BirthProfile> setPrimary(String id) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        ApiPaths.birthProfilePrimary(id),
      );
      return BirthProfile.fromJson(res.data ?? const {});
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<void> delete(String id) =>
      _dio.delete<void>(ApiPaths.birthProfile(id));

  Future<List<Place>> searchPlaces(String query) async {
    try {
      final res = await _dio.get<List<dynamic>>(
        ApiPaths.placesSearch,
        queryParameters: {'q': query},
      );
      return (res.data ?? const [])
          .map((e) => Place.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}
