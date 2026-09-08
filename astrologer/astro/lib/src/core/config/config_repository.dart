import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../constants/api_paths.dart';
import 'remote_config.dart';

/// Fetches and caches [RemoteConfig]. [prime] is awaited during bootstrap; it
/// never throws — on failure it falls back to the cached copy, then to
/// [RemoteConfig.fallback].
class ConfigRepository extends ChangeNotifier {
  ConfigRepository({required Dio dio, required FlutterSecureStorage storage})
    : _dio = dio,
      _storage = storage;

  final Dio _dio;
  final FlutterSecureStorage _storage;

  static const _cacheKey = 'ta_remote_config';

  RemoteConfig _value = RemoteConfig.fallback();
  RemoteConfig get value => _value;

  Future<void> prime() async {
    await _loadCached();
    await refresh();
  }

  Future<void> _loadCached() async {
    try {
      final raw = await _storage.read(key: _cacheKey);
      if (raw != null && raw.isNotEmpty) {
        _value = RemoteConfig.fromJson(
          jsonDecode(raw) as Map<String, dynamic>,
        );
        notifyListeners();
      }
    } catch (e) {
      debugPrint('ConfigRepository: bad cache ($e)');
    }
  }

  Future<void> refresh() async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(ApiPaths.config);
      final data = res.data;
      if (res.statusCode == 200 && data != null) {
        _value = RemoteConfig.fromJson(data);
        await _storage.write(key: _cacheKey, value: jsonEncode(data));
        notifyListeners();
      }
    } catch (e) {
      debugPrint('ConfigRepository: refresh failed ($e) — using cached/fallback');
    }
  }
}
