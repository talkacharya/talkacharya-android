import 'package:intl/intl.dart';

/// Currency formatting for the app. Amounts are plain numbers from the API;
/// grouping follows the locale (Indian 1,20,000 for INR/*-IN).
class Money {
  const Money._();

  static String symbol(String currency) => switch (currency.toUpperCase()) {
    'INR' => '₹',
    'USD' => r'$',
    'EUR' => '€',
    'GBP' => '£',
    'AUD' => r'A$',
    'CAD' => r'C$',
    _ => '${currency.toUpperCase()} ',
  };

  /// "₹1,240" — no decimals when the amount is whole, two otherwise.
  static String format(num amount, String currency, {String? locale}) {
    final whole = amount == amount.roundToDouble();
    final fmt = NumberFormat.decimalPattern(
      locale ?? (currency.toUpperCase() == 'INR' ? 'en_IN' : 'en_US'),
    )..minimumFractionDigits = whole ? 0 : 2
     ..maximumFractionDigits = whole ? 0 : 2;
    return '${symbol(currency)}${fmt.format(amount)}';
  }

  /// "+₹500" / "−₹216" for a signed ledger amount.
  static String signed(num signedAmount, String currency, {String? locale}) {
    final sign = signedAmount < 0 ? '−' : '+';
    return '$sign${format(signedAmount.abs(), currency, locale: locale)}';
  }
}
