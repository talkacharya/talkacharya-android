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
  static const _hapticKey = 'ta_haptic_enabled';

  RemoteConfig _value = RemoteConfig.fallback();
  RemoteConfig get value => _value;

  bool _hapticEnabled = true;
  bool get hapticEnabled => _hapticEnabled;

  Future<void> prime() async {
    await _loadCached();
    await _loadHapticPref();
    await refresh();
  }

  Future<void> _loadHapticPref() async {
    try {
      final raw = await _storage.read(key: _hapticKey);
      if (raw != null) {
        _hapticEnabled = raw == 'true';
        notifyListeners();
      }
    } catch (e) {
      debugPrint('ConfigRepository: haptic load failed ($e)');
    }
  }

  Future<void> setHapticEnabled(bool enabled) async {
    if (_hapticEnabled == enabled) return;
    _hapticEnabled = enabled;
    notifyListeners();
    try {
      await _storage.write(key: _hapticKey, value: enabled.toString());
    } catch (e) {
      debugPrint('ConfigRepository: haptic save failed ($e)');
    }
  }

  Future<void> _loadCached() async {
    try {
      final raw = await _storage.read(key: _cacheKey);
      if (raw != null && raw.isNotEmpty) {
        _value = RemoteConfig.fromJson(jsonDecode(raw) as Map<String, dynamic>);
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
      debugPrint(
        'ConfigRepository: refresh failed ($e) — using cached/fallback',
      );
    }
  }
}
