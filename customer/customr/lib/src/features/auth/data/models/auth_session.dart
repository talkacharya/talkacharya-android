import 'package:freezed_annotation/freezed_annotation.dart';

import 'auth_user.dart';

part 'auth_session.freezed.dart';
part 'auth_session.g.dart';

/// 200 body of POST /auth/otp/verify.
@freezed
abstract class AuthSession with _$AuthSession {
  const factory AuthSession({
    required String access,
    required String refresh,
    required AuthUser user,
    @Default(false) bool created,
  }) = _AuthSession;

  factory AuthSession.fromJson(Map<String, dynamic> json) =>
      _$AuthSessionFromJson(json);
}
