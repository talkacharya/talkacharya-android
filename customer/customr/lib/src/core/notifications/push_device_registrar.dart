import 'dart:async';
import 'dart:io' show Platform;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../features/auth/presentation/bloc/auth/auth_bloc.dart';
import '../constants/api_paths.dart';
import 'push_service.dart';

/// Keeps the backend's `Device` row in sync: registers the FCM token once the
/// user is authenticated (and on every rotation), deregisters on logout.
class PushDeviceRegistrar {
  PushDeviceRegistrar({
    required PushService push,
    required AuthBloc authBloc,
    required Dio dio,
  }) : _push = push,
       _authBloc = authBloc,
       _dio = dio;

  final PushService _push;
  final AuthBloc _authBloc;
  final Dio _dio;

  StreamSubscription<AuthState>? _authSub;
  StreamSubscription<String>? _tokenSub;
  String? _lastRegisteredId;
  bool _wasAuthenticated = false;

  void start() {
    _tokenSub = _push.tokens.listen((_) => _registerIfPossible());
    _authSub = _authBloc.stream.listen(_onAuth);
    _onAuth(_authBloc.state);
  }

  void _onAuth(AuthState state) {
    final authed = state.status == AuthStatus.authenticated;
    if (authed && !_wasAuthenticated) {
      _registerIfPossible();
    } else if (!authed && _wasAuthenticated) {
      _deregister();
    }
    _wasAuthenticated = authed;
  }

  Future<void> _registerIfPossible() async {
    if (_authBloc.state.status != AuthStatus.authenticated) return;
    final token = await _push.currentToken();
    if (token == null || token.isEmpty) return;
    try {
      final info = await PackageInfo.fromPlatform();
      final res = await _dio.post<Map<String, dynamic>>(
        ApiPaths.meDevices,
        data: {
          'platform': Platform.isIOS ? 'ios' : 'android',
          'fcm_token': token,
          'app_version': info.version,
          'locale': PlatformDispatcher.instance.locale.toLanguageTag(),
        },
      );
      _lastRegisteredId = res.data?['id'] as String?;
    } catch (e) {
      debugPrint('PushDeviceRegistrar: register failed ($e)');
    }
  }

  Future<void> _deregister() async {
    final id = _lastRegisteredId;
    _lastRegisteredId = null;
    if (id == null) return;
    try {
      await _dio.delete<void>(ApiPaths.meDevice(id));
    } catch (e) {
      debugPrint('PushDeviceRegistrar: deregister failed ($e)');
    }
  }

  Future<void> dispose() async {
    await _authSub?.cancel();
    await _tokenSub?.cancel();
  }
}
