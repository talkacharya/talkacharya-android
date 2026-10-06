import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

import '../../../core/constants/api_paths.dart';
import '../../../core/network/api_exception.dart';
import '../../consultations/data/models/consultation_share.dart';

Map<String, dynamic> _map(Object? v) =>
    v is Map ? v.cast<String, dynamic>() : const {};

/// Someone whose birth details the astrologer saved to cast a chart for —
/// a walk-in, a phone client, a family member. Private to the astrologer.
class ClientChart extends Equatable {
  const ClientChart({
    required this.id,
    required this.name,
    required this.gender,
    required this.birthDate,
    required this.birthTime,
    required this.place,
    required this.moonSign,
  });

  final String id;
  final String name;
  final String gender;
  final DateTime? birthDate;

  /// `HH:mm:ss`, or null when the time of birth is not known.
  final String? birthTime;
  final String place;

  /// Chandra rasi, when the server could work it out.
  final String moonSign;

  factory ClientChart.fromJson(Map<String, dynamic> j) {
    final signs = _map(j['signs']);
    final name = (j['full_name'] as String? ?? '').trim();
    return ClientChart(
      id: '${j['id']}',
      name: name.isEmpty ? (j['label'] as String? ?? '') : name,
      gender: j['gender'] as String? ?? 'other',
      birthDate: DateTime.tryParse('${j['birth_date']}'),
      birthTime: j['birth_time'] as String?,
      place: j['birth_place_name'] as String? ?? '',
      moonSign: '${signs['moon_sign'] ?? signs['rasi'] ?? ''}',
    );
  }

  @override
  List<Object?> get props => [id, name, gender, birthDate, birthTime, place];
}

class PlaceHit extends Equatable {
  const PlaceHit({required this.id, required this.name});

  final String id;
  final String name;

  @override
  List<Object?> get props => [id, name];
}

/// A Guna Milan the astrologer ran, as a list row.
class MatchRow extends Equatable {
  const MatchRow({required this.summary, required this.createdAt});

  final SharedMatch summary;
  final DateTime? createdAt;

  @override
  List<Object?> get props => [summary.id, createdAt];
}

/// Charts the astrologer casts on their own, outside any consultation. The
/// chart engine's birth-profile endpoints are open to any signed-in user and
/// keep each user's profiles to themselves, so the astrologer's saved charts
/// are simply their own birth profiles.
class ClientChartsApi {
  ClientChartsApi(this._dio);

  final Dio _dio;

  Future<List<ClientChart>> list() async {
    final res = (await _dio.get<dynamic>(ApiPaths.birthProfiles)).ensureOk();
    return [
      for (final e in res.data as List? ?? const [])
        ClientChart.fromJson(_map(e)),
    ];
  }

  Future<ClientChart> create({
    required String name,
    required String gender,
    required DateTime birthDate,
    required String? birthTime,
    required PlaceHit place,
  }) async {
    String two(int n) => n.toString().padLeft(2, '0');
    final res = (await _dio.post<Map<String, dynamic>>(
      ApiPaths.birthProfiles,
      data: {
        'label': name.trim(),
        'full_name': name.trim(),
        'relation': 'other',
        'gender': gender,
        'birth_date':
            '${birthDate.year}-${two(birthDate.month)}-${two(birthDate.day)}',
        'birth_time': birthTime,
        'birth_time_accuracy': birthTime == null ? 'unknown' : 'exact',
        'place_id': place.id,
        'birth_place_name': place.name,
      },
    )).ensureOk();
    return ClientChart.fromJson(res.data ?? const {});
  }

  Future<void> delete(String id) async {
    (await _dio.delete<dynamic>(ApiPaths.birthProfile(id))).ensureOk();
  }

  Future<List<PlaceHit>> searchPlaces(String query) async {
    if (query.trim().length < 2) return const [];
    final res = (await _dio.get<dynamic>(
      ApiPaths.placesSearch,
      queryParameters: {'q': query.trim(), 'limit': 6},
    )).ensureOk();
    return [
      for (final e in res.data as List? ?? const [])
        PlaceHit(id: '${_map(e)['place_id']}', name: '${_map(e)['name']}'),
    ];
  }

  Future<List<MatchRow>> matches() async {
    final res = (await _dio.get<dynamic>(ApiPaths.matchmaking)).ensureOk();
    return [
      for (final e in res.data as List? ?? const [])
        if (SharedMatch.fromJson(_map(e)) case final m?)
          MatchRow(
            summary: m,
            createdAt: DateTime.tryParse('${_map(e)['created_at']}'),
          ),
    ];
  }

  /// Runs a Guna Milan for two saved charts and returns the full report.
  Future<MatchReport> match({
    required String boyId,
    required String girlId,
  }) async {
    final res = (await _dio.post<Map<String, dynamic>>(
      ApiPaths.matchmaking,
      data: {'boy_profile': boyId, 'girl_profile': girlId},
    )).ensureOk();
    return MatchReport.fromJson(res.data ?? const {});
  }
}
