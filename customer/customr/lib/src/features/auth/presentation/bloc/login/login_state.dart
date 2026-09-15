part of 'login_cubit.dart';

enum LoginStep { enterPhone, enterOtp }

class LoginState extends Equatable {
  const LoginState({
    this.step = LoginStep.enterPhone,
    this.phone = '',
    this.submitting = false,
    this.error,
    this.challengeExpiresAt,
    this.devCode,
    this.verificationId,
    this.resendToken,
  });

  final LoginStep step;
  final String phone;
  final bool submitting;
  final String? error;
  final DateTime? challengeExpiresAt;

  /// Non-null only when the backend runs in OTP dev mode — surfaced in the UI so
  /// QA can log in without SMS.
  final String? devCode;

  /// Firebase phone-auth flow only: the id returned by `codeSent`, needed to
  /// confirm the SMS code; and the resend token for a forced re-send.
  final String? verificationId;
  final int? resendToken;

  LoginState copyWith({
    LoginStep? step,
    String? phone,
    bool? submitting,
    String? error,
    DateTime? challengeExpiresAt,
    String? devCode,
    bool clearDevCode = false,
    String? verificationId,
    int? resendToken,
  }) {
    return LoginState(
      step: step ?? this.step,
      phone: phone ?? this.phone,
      submitting: submitting ?? this.submitting,
      error: error,
      challengeExpiresAt: challengeExpiresAt ?? this.challengeExpiresAt,
      devCode: clearDevCode ? null : (devCode ?? this.devCode),
      verificationId: verificationId ?? this.verificationId,
      resendToken: resendToken ?? this.resendToken,
    );
  }

  @override
  List<Object?> get props => [
    step,
    phone,
    submitting,
    error,
    challengeExpiresAt,
    devCode,
    verificationId,
    resendToken,
  ];
}
