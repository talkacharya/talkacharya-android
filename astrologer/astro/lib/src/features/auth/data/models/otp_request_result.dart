import 'package:freezed_annotation/freezed_annotation.dart';

part 'otp_request_result.freezed.dart';
part 'otp_request_result.g.dart';

/// 202 body of POST /auth/otp/request. `devCode` is only present while the backend
/// runs with OTP['DEV_MODE'] on (see backend/docs/mobile.md).
@freezed
abstract class OtpRequestResult with _$OtpRequestResult {
  const factory OtpRequestResult({
    @JsonKey(name: 'challenge_id') required String challengeId,
    @JsonKey(name: 'expires_at') required DateTime expiresAt,
    @JsonKey(name: 'dev_code') String? devCode,
  }) = _OtpRequestResult;

  factory OtpRequestResult.fromJson(Map<String, dynamic> json) =>
      _$OtpRequestResultFromJson(json);
}
