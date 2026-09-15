import 'package:dio/dio.dart';

import '../../../core/constants/api_paths.dart';
import '../../../core/network/api_exception.dart';
import '../../auth/data/models/auth_user.dart';

/// `PATCH /me` — update the signed-in user's profile and preferences.
class ProfileApi {
  ProfileApi(this._dio);

  final Dio _dio;

  Future<AuthUser> updatePreferences({String? language, String? currency}) {
    return _patch({
      'preferred_language': ?language,
      'preferred_currency': ?currency,
    });
  }

  Future<AuthUser> updateProfile({
    String? fullName,
    String? displayName,
    String? email,
    String? gender,
    String? dateOfBirth, // yyyy-MM-dd
    String? country,
  }) {
    return _patch({
      'full_name': ?fullName,
      'display_name': ?displayName,
      'email': ?email,
      'gender': ?gender,
      'date_of_birth': ?dateOfBirth,
      'country': ?country,
    });
  }

  /// Multipart PATCH with a new avatar file.
  Future<AuthUser> uploadAvatar(String filePath) async {
    try {
      final form = FormData.fromMap({
        'avatar': await MultipartFile.fromFile(filePath),
      });
      final res = await _dio.patch<Map<String, dynamic>>(
        ApiPaths.me,
        data: form,
      );
      _raiseFor(res);
      return AuthUser.fromJson(res.data ?? const {});
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<AuthUser> _patch(Map<String, dynamic> data) async {
    try {
      final res = await _dio.patch<Map<String, dynamic>>(
        ApiPaths.me,
        data: data,
      );
      _raiseFor(res);
      return AuthUser.fromJson(res.data ?? const {});
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  void _raiseFor(Response<dynamic> res) {
    if ((res.statusCode ?? 0) >= 400) {
      throw ApiException.fromDio(
        DioException(requestOptions: res.requestOptions, response: res),
      );
    }
  }
}
