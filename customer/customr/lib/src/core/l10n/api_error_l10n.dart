import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';

import '../network/api_exception.dart';
import '../network/friendly_error.dart';
import 'l10n.dart';

/// Turn any thrown error into a message in the user's language.
///
/// The backend `code` is stable and language-independent (docs/i18n.md §2) — we
/// map the codes we care about to localized strings, then fall back to the API's
/// own `message` (already localized to the request language) and finally a
/// generic line. A technical detail is appended only where [showErrorDetails]
/// allows it, i.e. never in a production build.
String localizedError(BuildContext context, Object? error) =>
    localizedErrorFor(context.l10n, error);

/// The same, for a callback that captured the localizations before an `await`
/// and can no longer touch its [BuildContext].
String localizedErrorFor(AppLocalizations l, Object? error) {
  final human = _localized(l, error);
  if (!showErrorDetails) return human;
  final detail = technicalError(error);
  return detail.isEmpty ? human : '$human\n\n[dev] $detail';
}

String _localized(AppLocalizations l, Object? error) {
  if (error is DioException) {
    return _localized(l, ApiException.fromDio(error));
  }
  if (error is SocketException || error is HttpException) return l.errNetwork;
  if (error is TimeoutException) return l.errTimeout;
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

  if (error.isNetwork) return l.errNetwork;

  final status = error.statusCode ?? 0;
  if (status == 401) return l.errSession;
  if (status == 403) return l.errForbidden;
  if (status == 404) return l.errNotFound;
  if (status == 429) return l.errRateLimited;
  if (status >= 500) return l.errServer;

  // Other 4xx: the backend writes `detail` for users, in their language — but
  // only a message that really came from the server may be shown.
  return error.fromServer && error.message.isNotEmpty
      ? error.message
      : l.errGeneric;
}
