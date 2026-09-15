import 'package:dio/dio.dart';

/// Normalised error surfaced to blocs/UI. Carries the backend's machine `code`
/// (common/exceptions.py -> `{ "code": ..., "detail": ... }`) when present.
class ApiException implements Exception {
  ApiException({
    required this.message,
    this.code,
    this.statusCode,
    this.fieldErrors = const {},
  });

  final String message;
  final String? code;
  final int? statusCode;
  final Map<String, List<String>> fieldErrors;

  bool get isNetwork => statusCode == null;
  bool get isUnauthorized => statusCode == 401;

  @override
  String toString() => 'ApiException($statusCode, $code): $message';

  factory ApiException.fromDio(DioException e) {
    final res = e.response;
    if (res == null) {
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
    final fieldErrors = <String, List<String>>{};

    if (data is Map) {
      code = data['code'] as String?;
      final detail = data['detail'];
      final serverMessage = data['message'] as String?;

      if (serverMessage != null && serverMessage.isNotEmpty) {
        message = serverMessage;
      } else if (detail is String) {
        message = detail;
      } else if (detail is Map && detail.isNotEmpty) {
        message = detail.values.first.toString();
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
      }
    }

    return ApiException(
      message: message,
      code: code,
      statusCode: res.statusCode,
      fieldErrors: fieldErrors,
    );
  }
}
