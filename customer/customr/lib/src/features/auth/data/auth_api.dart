import 'package:dio/dio.dart';

import '../../../core/constants/api_paths.dart';
import '../../../core/network/api_exception.dart';
import 'models/auth_session.dart';
import 'models/auth_user.dart';
import 'models/otp_request_result.dart';

/// Thin transport layer over the auth endpoints. Throws [ApiException].
class AuthApi {
  AuthApi(this._dio);

  final Dio _dio;

  Future<T> _guard<T>(
    Future<Response<Map<String, dynamic>>> Function() call,
    T Function(Map<String, dynamic>) parse,
  ) async {
    try {
      final res = await call();
      final status = res.statusCode ?? 0;
      if (status >= 400) {
        throw ApiException.fromDio(
          DioException(requestOptions: res.requestOptions, response: res),
        );
      }
      return parse(res.data ?? const {});
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<OtpRequestResult> requestOtp({
    required String phone,
    String purpose = 'login',
  }) {
    return _guard(
      () => _dio.post<Map<String, dynamic>>(
        ApiPaths.otpRequest,
        data: {'phone': phone, 'purpose': purpose},
      ),
      OtpRequestResult.fromJson,
    );
  }

  Future<AuthSession> verifyOtp({
    required String phone,
    required String code,
    String purpose = 'login',
    Map<String, dynamic>? device,
  }) {
    return _guard(
      () => _dio.post<Map<String, dynamic>>(
        ApiPaths.otpVerify,
        data: {
          'phone': phone,
          'code': code,
          'purpose': purpose,
          'device': ?device,
        },
      ),
      AuthSession.fromJson,
    );
  }

  Future<AuthUser> me() {
    return _guard(
      () => _dio.get<Map<String, dynamic>>(ApiPaths.me),
      AuthUser.fromJson,
    );
  }

  Future<void> logout(String refresh) async {
    try {
      await _dio.post<void>(ApiPaths.logout, data: {'refresh': refresh});
    } on DioException {
      // best-effort; local tokens are cleared regardless
    }
  }
}
