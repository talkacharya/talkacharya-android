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
  });

  final LoginStep step;
  final String phone;
  final bool submitting;
  final String? error;
  final DateTime? challengeExpiresAt;

  /// Non-null only when the backend runs in OTP dev mode — surfaced in the UI so
  /// QA can log in without SMS.
  final String? devCode;

  LoginState copyWith({
    LoginStep? step,
    String? phone,
    bool? submitting,
    String? error,
    DateTime? challengeExpiresAt,
    String? devCode,
    bool clearDevCode = false,
  }) {
    return LoginState(
      step: step ?? this.step,
      phone: phone ?? this.phone,
      submitting: submitting ?? this.submitting,
      error: error,
      challengeExpiresAt: challengeExpiresAt ?? this.challengeExpiresAt,
      devCode: clearDevCode ? null : (devCode ?? this.devCode),
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
  ];
}
