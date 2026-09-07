/// Backend REST paths, relative to `AppConfig.apiBaseUrl`.
/// Mirrors backend/docs/api-surface.md.
class ApiPaths {
  const ApiPaths._();

  static const otpRequest = '/auth/otp/request';
  static const otpVerify = '/auth/otp/verify';
  static const tokenRefresh = '/auth/token/refresh';
  static const logout = '/auth/logout';
  static const me = '/me';

  // customer app surface
  static const astrologers = '/app/astrologers';
  static const wallet = '/app/wallet';
}
