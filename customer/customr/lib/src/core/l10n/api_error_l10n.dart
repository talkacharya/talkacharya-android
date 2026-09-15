import 'package:flutter/widgets.dart';

import '../network/api_exception.dart';
import 'l10n.dart';

/// Turn any thrown error into a message in the user's language.
///
/// The backend `code` is stable and language-independent (docs/i18n.md §2) — we
/// map the codes we care about to localized strings, then fall back to the API's
/// own `message` (already localized to the request language) and finally a
/// generic line.
String localizedError(BuildContext context, Object? error) {
  final l = context.l10n;
  if (error is! ApiException) return l.errGeneric;

  switch (error.code) {
    case 'otp.invalid':
      return l.errOtpInvalid;
    case 'otp.max_attempts':
      return l.errOtpMaxAttempts;
    case 'auth.wrong_app':
      return l.errAuthWrongApp;
    case 'wallet.insufficient_balance':
      return l.errWalletInsufficient;
    case 'rate_limited':
    case 'otp.rate_limited_phone':
    case 'otp.rate_limited_ip':
      return l.errRateLimited;
    case 'promo.not_redeemable':
      return l.errPromoNotRedeemable;
    case 'recharge.invalid_amount':
      return l.errRechargeInvalidAmount;
  }

  if (error.isUnauthorized) return l.errSession;
  if (error.isNetwork) return l.errNetwork;
  return error.message.isNotEmpty ? error.message : l.errGeneric;
}
