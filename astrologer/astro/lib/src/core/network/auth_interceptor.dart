import 'dart:async';

import 'package:dio/dio.dart';

import '../constants/api_paths.dart';
import '../storage/token_storage.dart';

/// Attaches the bearer token, and on a 401 tries a one-shot refresh + replay.
/// A single in-flight refresh is shared by all concurrent 401s. If refresh fails
/// the session is cleared and [onSessionExpired] fires (router redirects to login).
class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required this.tokens,
    required Dio refreshClient,
    required this.onSessionExpired,
  }) : _refreshClient = refreshClient;

  final TokenStorage tokens;
  final Dio _refreshClient;
  final Future<void> Function() onSessionExpired;

  Future<String?>? _refreshing;

  static const _skipAuth = {
    ApiPaths.otpRequest,
    ApiPaths.otpVerify,
    ApiPaths.tokenRefresh,
  };

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (!_skipAuth.contains(options.path)) {
      final access = await tokens.readAccess();
      if (access != null && access.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $access';
      }
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final response = err.response;
    final isAuthPath = _skipAuth.contains(err.requestOptions.path);
    if (response?.statusCode != 401 ||
        isAuthPath ||
        err.requestOptions.extra['retried'] == true) {
      return handler.next(err);
    }

    final newAccess = await (_refreshing ??= _refresh());
    _refreshing = null;

    if (newAccess == null) {
      await tokens.clear();
      await onSessionExpired();
      return handler.next(err);
    }

    try {
      final opts = err.requestOptions
        ..headers['Authorization'] = 'Bearer $newAccess'
        ..extra['retried'] = true;
      final clone = await _refreshClient.fetch<dynamic>(opts);
      return handler.resolve(clone);
    } on DioException catch (e) {
      return handler.next(e);
    }
  }

  Future<String?> _refresh() async {
    final refresh = await tokens.readRefresh();
    if (refresh == null || refresh.isEmpty) return null;
    try {
      final res = await _refreshClient.post<Map<String, dynamic>>(
        ApiPaths.tokenRefresh,
        data: {'refresh': refresh},
      );
      final data = res.data ?? const {};
      final access = data['access'] as String?;
      final rotated = data['refresh'] as String?;
      if (access == null) return null;
      if (rotated != null) {
        await tokens.save(access: access, refresh: rotated);
      } else {
        await tokens.saveAccess(access);
      }
      return access;
    } on DioException {
      return null;
    }
  }
}
