import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'models/day_panchang.dart';
import 'panchang_api.dart';

class PanchangRepository {
  PanchangRepository({
    required PanchangApi api,
    required FlutterSecureStorage storage,
  }) : _api = api,
       _storage = storage;

  final PanchangApi _api;
  final FlutterSecureStorage _storage;

  static const _placeKey = 'ta_panchang_place';

  /// Days fetched this session, keyed by place + date — flipping back and
  /// forth between days is instant.
  final _days = <String, DayPanchang>{};

  String _key(PanchangPlace p, DateTime d) =>
      '${p.latitude.toStringAsFixed(2)},${p.longitude.toStringAsFixed(2)}:'
      '${d.year}-${d.month}-${d.day}';

  DayPanchang? cached(PanchangPlace place, DateTime date) =>
      _days[_key(place, date)];

  Future<DayPanchang> day(PanchangPlace place, DateTime date) async =>
      _days[_key(place, date)] = await _api.forPlace(place, date);

  /// The city the user picked last time, if any.
  Future<PanchangPlace?> savedPlace() async {
    try {
      final raw = await _storage.read(key: _placeKey);
      if (raw == null) return null;
      return PanchangPlace.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (e) {
      debugPrint('PanchangRepository: read place failed ($e)');
      return null;
    }
  }

  Future<void> savePlace(PanchangPlace place) async {
    try {
      await _storage.write(key: _placeKey, value: jsonEncode(place.toJson()));
    } catch (e) {
      debugPrint('PanchangRepository: persist place failed ($e)');
    }
  }
}
