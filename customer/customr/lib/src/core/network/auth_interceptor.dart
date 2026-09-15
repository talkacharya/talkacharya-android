import 'dart:async';

import 'package:dio/dio.dart';

import '../constants/api_paths.dart';
import '../storage/token_storage.dart';

enum _RefreshOutcome { ok, rejected, transient }

class _RefreshResult {
  const _RefreshResult(this.outcome, [this.access]);
  final _RefreshOutcome outcome;
  final String? access;
}

/// Attaches the bearer token and, on a 401, silently refreshes the access token
/// and replays the failed request — the caller never sees the 401.
///
/// * A single in-flight refresh is shared by every concurrent 401 (single-flight),
///   so a burst of requests triggers exactly one `POST /auth/token/refresh`.
/// * The session is cleared and [onSessionExpired] fires **only** when the refresh
///   token is definitively rejected (the refresh endpoint answers 4xx). A network
///   failure during refresh is transient: the request fails but the user stays
///   logged in and the next request retries.
class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required this.tokens,
    required Dio refreshClient,
    required this.onSessionExpired,
  }) : _refreshClient = refreshClient;

  final TokenStorage tokens;
  final Dio _refreshClient; // no interceptors — never recurses into this class
  final Future<void> Function() onSessionExpired;

  Completer<_RefreshResult>? _inFlight;

  static const _noAuthPaths = <String>{
    ApiPaths.otpRequest,
    ApiPaths.otpVerify,
    ApiPaths.tokenRefresh,
  };

  bool _isNoAuth(String path) => _noAuthPaths.any(path.endsWith);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (!_isNoAuth(options.path)) {
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
    final is401 = err.response?.statusCode == 401;
    final alreadyRetried = err.requestOptions.extra['__auth_retried'] == true;
    if (!is401 || alreadyRetried || _isNoAuth(err.requestOptions.path)) {
      return handler.next(err);
    }

    final result = await _refreshOnce();
    switch (result.outcome) {
      case _RefreshOutcome.rejected:
        await tokens.clear();
        await onSessionExpired();
        return handler.next(err);
      case _RefreshOutcome.transient:
        return handler.next(err); // keep the session; caller can retry later
      case _RefreshOutcome.ok:
        break;
    }

    try {
      final retry = err.requestOptions
        ..headers['Authorization'] = 'Bearer ${result.access}'
        ..extra['__auth_retried'] = true;
      final replayed = await _refreshClient.fetch<dynamic>(retry);
      return handler.resolve(replayed);
    } on DioException catch (e) {
      return handler.next(e);
    }
  }

  /// One shared refresh for all concurrent callers.
  Future<_RefreshResult> _refreshOnce() {
    final existing = _inFlight;
    if (existing != null) return existing.future;

    final gate = Completer<_RefreshResult>();
    _inFlight = gate;
    _doRefresh()
        .then(gate.complete)
        .catchError(
          (_) => gate.complete(const _RefreshResult(_RefreshOutcome.transient)),
        )
        .whenComplete(() => _inFlight = null);
    return gate.future;
  }

  Future<_RefreshResult> _doRefresh() async {
    final refresh = await tokens.readRefresh();
    if (refresh == null || refresh.isEmpty) {
      return const _RefreshResult(_RefreshOutcome.rejected);
    }
    try {
      final res = await _refreshClient.post<Map<String, dynamic>>(
        ApiPaths.tokenRefresh,
        data: {'refresh': refresh},
      );
      final status = res.statusCode ?? 0;
      if (status == 401 || status == 400) {
        return const _RefreshResult(_RefreshOutcome.rejected);
      }
      if (status >= 400) {
        return const _RefreshResult(_RefreshOutcome.transient);
      }
      final data = res.data ?? const <String, dynamic>{};
      final access = data['access'] as String?;
      if (access == null || access.isEmpty) {
        return const _RefreshResult(_RefreshOutcome.rejected);
      }
      final rotated = data['refresh'] as String?;
      if (rotated != null && rotated.isNotEmpty) {
        await tokens.save(access: access, refresh: rotated);
      } else {
        await tokens.saveAccess(access);
      }
      return _RefreshResult(_RefreshOutcome.ok, access);
    } on DioException catch (e) {
      final code = e.response?.statusCode;
      if (code == 401 || code == 400) {
        return const _RefreshResult(_RefreshOutcome.rejected);
      }
      return const _RefreshResult(
        _RefreshOutcome.transient,
      ); // network / server down
    }
  }
}
