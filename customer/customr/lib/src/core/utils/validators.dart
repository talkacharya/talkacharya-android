class Validators {
  const Validators._();

  /// Accepts a 10-digit Indian mobile (optionally prefixed with +91 / 0 / spaces).
  /// Returns the E.164 form (`+91XXXXXXXXXX`) or null if invalid.
  static String? toE164India(String raw) {
    var digits = raw.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.length == 12 && digits.startsWith('91')) {
      digits = digits.substring(2);
    }
    if (digits.length == 11 && digits.startsWith('0')) {
      digits = digits.substring(1);
    }
    if (digits.length != 10 || !RegExp(r'^[6-9]').hasMatch(digits)) return null;
    return '+91$digits';
  }

  static bool isValidOtp(String raw, {int length = 6}) =>
      RegExp('^[0-9]{$length}\$').hasMatch(raw.trim());
}
