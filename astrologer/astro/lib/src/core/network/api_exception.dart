import 'package:dio/dio.dart';

import 'friendly_error.dart';

/// Normalised error surfaced to blocs/UI. Carries the backend's machine `code`
/// (common/exceptions.py -> `{ "code": ..., "detail": ... }`) when present.
class ApiException implements Exception {
  ApiException({
    required this.message,
    this.code,
    this.statusCode,
    this.fieldErrors = const {},
    this.fromServer = false,
  });

  final String message;
  final String? code;
  final int? statusCode;
  final Map<String, List<String>> fieldErrors;

  /// True when [message] came from the API body. A synthesized placeholder
  /// ("Request failed (500).") must never be shown to a user, so anything that
  /// renders an error checks this first — see `friendlyError`.
  final bool fromServer;

  bool get isNetwork => statusCode == null;
  bool get isUnauthorized => statusCode == 401;

  /// Interpolating an exception (`'$e'`) is a common way for a raw string to
  /// reach the UI, so in production this reads as a sentence, not a dump.
  @override
  String toString() => showErrorDetails
      ? 'ApiException($statusCode, $code): $message'
      : humanError(this);

  factory ApiException.fromDio(DioException e) {
    final res = e.response;
    if (res == null) {
      // No response at all: the sentence below is ours and safe to show, and
      // `isNetwork` short-circuits ahead of `fromServer` everywhere it matters.
      return ApiException(
        message: switch (e.type) {
          DioExceptionType.connectionTimeout ||
          DioExceptionType.sendTimeout ||
          DioExceptionType.receiveTimeout =>
            'The server took too long to respond. Check your connection.',
          DioExceptionType.connectionError =>
            'Could not reach the server. Check your connection.',
          _ => 'Something went wrong. Please try again.',
        },
      );
    }

    final data = res.data;
    String? code;
    var message = 'Request failed (${res.statusCode}).';
    var fromServer = false;
    final fieldErrors = <String, List<String>>{};

    if (data is Map) {
      code = data['code'] as String?;
      final detail = data['detail'];
      final serverMessage = data['message'] as String?;

      if (serverMessage != null && serverMessage.isNotEmpty) {
        message = serverMessage;
        fromServer = true;
      } else if (detail is String) {
        message = detail;
        fromServer = true;
      } else if (detail is Map && detail.isNotEmpty) {
        message = detail.values.first.toString();
        fromServer = true;
      }

      for (final entry in data.entries) {
        if (entry.key == 'code' ||
            entry.key == 'detail' ||
            entry.key == 'message') {
          continue;
        }
        final value = entry.value;
        if (value is List) {
          fieldErrors[entry.key.toString()] = value
              .map((v) => v.toString())
              .toList();
        } else if (value is String) {
          fieldErrors[entry.key.toString()] = [value];
        }
      }

      if (fieldErrors.isNotEmpty &&
          detail is! String &&
          (serverMessage == null || serverMessage.isEmpty)) {
        message = fieldErrors.values.first.first;
        fromServer = true;
      }
    }

    return ApiException(
      message: message,
      code: code,
      statusCode: res.statusCode,
      fieldErrors: fieldErrors,
      fromServer: fromServer,
    );
  }
}

/// The app's Dio accepts 4xx responses (`validateStatus < 500`) so callers can
/// read error bodies. Call this where a 4xx must be treated as a failure.
extension EnsureOk<T> on Response<T> {
  Response<T> ensureOk() {
    if ((statusCode ?? 0) >= 400) {
      throw ApiException.fromDio(
        DioException(
          requestOptions: requestOptions,
          response: this,
          type: DioExceptionType.badResponse,
        ),
      );
    }
    return this;
  }
}
