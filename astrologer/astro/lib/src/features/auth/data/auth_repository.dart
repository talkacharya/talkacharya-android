import 'dart:convert';
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
    await cacheUser(session.user);
    return session.user;
  }

  /// Exchange a verified Firebase ID token for our session.
  Future<AuthUser> loginWithFirebase(String idToken) async {
    final session = await _api.loginWithFirebase(
      idToken: idToken,
      device: _devicePayload(),
    );
    await _persist(session);
    await cacheUser(session.user);
    return session.user;
  }

  /// Fetch `/me` and refresh the offline cache.
  Future<AuthUser> currentUser() async {
    final user = await _api.me();
    await cacheUser(user);
    return user;
  }

  /// The last user we saw, from secure storage — used to open the app instantly
  /// and to stay logged in while offline.
  Future<AuthUser?> cachedUser() async {
    final raw = await _tokens.readUserJson();
    if (raw == null || raw.isEmpty) return null;
    try {
      return AuthUser.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  Future<void> logout() async {
    final refresh = await _tokens.readRefresh();
    if (refresh != null && refresh.isNotEmpty) {
      await _api.logout(refresh);
    }
    await _tokens.clear();
  }

  Future<void> _persist(AuthSession s) =>
      _tokens.save(access: s.access, refresh: s.refresh);

  /// Persist [user] as the offline copy used at the next cold start.
  Future<void> cacheUser(AuthUser user) =>
      _tokens.saveUserJson(jsonEncode(user.toJson()));

  Map<String, dynamic> _devicePayload() => {
    'platform': Platform.isIOS ? 'ios' : 'android',
    'app_version': '1.0.0',
  };
}
