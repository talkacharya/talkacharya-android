import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'api_exception.dart';

/// Whether the UI may show the technical detail behind an error.
///
/// `bootstrap` sets this from the flavor: development and staging builds show
/// the detail, so a bug can be diagnosed from a screenshot; **production never
/// does**. The default follows the build mode so tests and tooling behave
/// sensibly without any setup.
bool showErrorDetails = kDebugMode;

const _generic = 'Something went wrong. Please try again.';
const _offline = 'Could not reach the server. Check your connection.';
const _timeout = 'The server took too long to respond. Check your connection.';

/// Turns any thrown error into a short, user-facing sentence.
///
/// Technical details — type-cast failures, parser errors, raw exception
/// strings, stack traces — must never reach the user in production. Anything we
/// don't specifically recognise collapses to [fallback].
String friendlyError(Object? error, {String? fallback}) {
  final human = humanError(error, fallback: fallback);
  if (!showErrorDetails) return human;
  final detail = technicalError(error);
  return detail.isEmpty || detail == human ? human : '$human\n\n[dev] $detail';
}

/// The user-facing half of [friendlyError], with no developer detail ever.
String humanError(Object? error, {String? fallback}) {
  final generic = fallback ?? _generic;
  if (error is ApiException) {
    // Connectivity / timeout: ApiException already phrases these for humans.
    if (error.isNetwork) return error.message;

    final status = error.statusCode ?? 0;
    if (status == 401 || status == 403) {
      return 'Please sign in again to see this.';
    }
    if (status == 404) {
      return "We couldn't find this — it may have been removed.";
    }
    if (status == 429) {
      return "You're going a bit fast. Please try again in a moment.";
    }
    if (status >= 500) {
      return 'Our server ran into a problem. Please try again shortly.';
    }
    // Other 4xx: the backend writes `detail` for users (and in their language),
    // so surface it — but only when it really came from the server.
    return error.fromServer && error.message.trim().isNotEmpty
        ? error.message
        : generic;
  }
  if (error is DioException) {
    return humanError(ApiException.fromDio(error), fallback: fallback);
  }
  if (error is SocketException || error is HttpException) return _offline;
  if (error is TimeoutException) return _timeout;
  return generic;
}

/// What a developer needs and a user must never see.
String technicalError(Object? error) => switch (error) {
  null => '',
  final ApiException e =>
    'HTTP ${e.statusCode ?? '-'}'
        '${e.code == null ? '' : ' [${e.code}]'}: ${e.message}',
  final DioException e => '${e.type.name}: ${e.message ?? e}',
  _ => '${error.runtimeType}: $error',
};
