class Validators {
  const Validators._();

  /// Generic E.164 formatter. If input already has +, returns it cleaned.
  /// Otherwise defaults to India (+91).
  static String? toE164(String raw) {
    final clean = raw.replaceAll(RegExp(r'[^0-9+]'), '');
    if (clean.startsWith('+')) {
      return clean.length >= 8 ? clean : null;
    }

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
