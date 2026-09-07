import 'dart:io' show Platform;

import '../../../core/storage/token_storage.dart';
import 'auth_api.dart';
import 'models/auth_session.dart';
import 'models/auth_user.dart';
import 'models/otp_request_result.dart';

/// Coordinates the auth API with token persistence. Blocs talk only to this.
class AuthRepository {
  AuthRepository({required AuthApi api, required TokenStorage tokens})
    : _api = api,
      _tokens = tokens;

  final AuthApi _api;
  final TokenStorage _tokens;

  Future<bool> hasSession() => _tokens.hasSession;

  Future<OtpRequestResult> requestOtp(String phone) =>
      _api.requestOtp(phone: phone);

  Future<AuthUser> verifyOtp({
    required String phone,
    required String code,
  }) async {
    final session = await _api.verifyOtp(
      phone: phone,
      code: code,
      device: _devicePayload(),
    );
    await _persist(session);
    return session.user;
  }

  Future<AuthUser> currentUser() => _api.me();

  Future<void> logout() async {
    final refresh = await _tokens.readRefresh();
    if (refresh != null && refresh.isNotEmpty) {
      await _api.logout(refresh);
    }
    await _tokens.clear();
  }

  Future<void> _persist(AuthSession s) =>
      _tokens.save(access: s.access, refresh: s.refresh);

  Map<String, dynamic> _devicePayload() => {
    'platform': Platform.isIOS ? 'ios' : 'android',
    'app_version': '1.0.0',
  };
}
