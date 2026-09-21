import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../../../core/firebase/firebase_setup.dart';
import '../../../core/network/friendly_error.dart';

/// A verification failure with a user-ready message. [code] is Firebase's error
/// code (or a local one) so callers/tests can branch without parsing text.
class FirebasePhoneAuthException implements Exception {
  FirebasePhoneAuthException(this.message, {this.code = 'unknown'});
  final String message;
  final String code;
  @override
  String toString() => message;
}

/// Thin wrapper over [FirebaseAuth] for the phone + SMS-code flow. The cubit
/// talks only to this; it hands back a Firebase **ID token** which the backend
/// (`POST /auth/firebase`) verifies and exchanges for our own session.
///
/// Every failure path — the `verifyPhoneNumber` future itself, the callbacks,
/// `signInWithCredential`, `getIdToken` — ends in exactly one error callback or a
/// [FirebasePhoneAuthException], so the login spinner can never hang.
class FirebasePhoneAuth {
  FirebasePhoneAuth([FirebaseAuth? auth, bool? verbose])
    : _auth = auth,
      verbose = verbose ?? showErrorDetails;

  FirebaseAuth? _auth;
  FirebaseAuth get _fa => _auth ??= FirebaseAuth.instance;

  /// Development builds append the raw Firebase code to messages, so an App Check
  /// / SHA / Play Integrity misconfiguration is visible on the device; a
  /// production build shows the sentence alone (see [showErrorDetails]).
  final bool verbose;

  /// Start verification for [e164]. Exactly one of [onCodeSent] / [onAutoVerified]
  /// / [onError] fires (Android may auto-retrieve the code and go straight to
  /// [onAutoVerified]). The returned future completes once that hand-off happens.
  Future<void> sendCode(
    String e164, {
    required void Function(String verificationId, int? resendToken) onCodeSent,
    required void Function(String idToken) onAutoVerified,
    required void Function(String message) onError,
    int? resendToken,
  }) async {
    final done = Completer<void>();
    var handedOff = false;
    void once(void Function() fn) {
      if (handedOff) return;
      handedOff = true;
      fn();
      if (!done.isCompleted) done.complete();
    }

    try {
      await _fa.verifyPhoneNumber(
        phoneNumber: e164,
        forceResendingToken: resendToken,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (credential) async {
          // Android auto-retrieved the SMS — possibly after `codeSent`, while the
          // user is on the OTP screen. Sign straight in either way.
          final codeAlreadySent = handedOff;
          try {
            final token = await _signIn(credential);
            if (codeAlreadySent) {
              onAutoVerified(token);
            } else {
              once(() => onAutoVerified(token));
            }
          } catch (e, st) {
            final message = _report(e, st, 'auto_verify');
            // After codeSent the user can still type the code; stay quiet.
            if (!codeAlreadySent) once(() => onError(message));
          }
        },
        verificationFailed: (e) =>
            once(() => onError(_report(e, StackTrace.current, 'verify'))),
        codeSent: (verificationId, forceResendingToken) =>
            once(() => onCodeSent(verificationId, forceResendingToken)),
        codeAutoRetrievalTimeout: (_) {},
      );
    } catch (e, st) {
      // Thrown synchronously by the plugin (e.g. App Check / Play Integrity
      // rejected before a request id existed) — never reaches a callback.
      once(() => onError(_report(e, st, 'verify_call')));
    }
    return done.future.timeout(
      const Duration(seconds: 75),
      onTimeout: () => once(
        () => onError(
          _message(
            'Verification is taking too long. Check your connection and try again.',
            'timeout',
          ),
        ),
      ),
    );
  }

  /// Confirm a manually-entered [smsCode] against [verificationId] → ID token.
  /// Throws [FirebasePhoneAuthException] only.
  Future<String> confirmCode(String verificationId, String smsCode) async {
    try {
      return await _signIn(
        PhoneAuthProvider.credential(
          verificationId: verificationId,
          smsCode: smsCode,
        ),
      );
    } on FirebasePhoneAuthException {
      rethrow;
    } catch (e, st) {
      throw FirebasePhoneAuthException(
        _report(e, st, 'confirm'),
        code: e is FirebaseAuthException ? e.code : 'unknown',
      );
    }
  }

  Future<String> _signIn(PhoneAuthCredential credential) async {
    final result = await _fa.signInWithCredential(credential);
    final token = await result.user?.getIdToken();
    if (token == null || token.isEmpty) {
      throw FirebasePhoneAuthException(
        'Could not complete sign-in. Try again.',
        code: 'no-id-token',
      );
    }
    return token;
  }

  /// Log the raw failure (debug console + Crashlytics non-fatal) and return the
  /// user-facing sentence.
  String _report(Object e, StackTrace st, String stage) {
    final code = e is FirebaseAuthException ? e.code : e.runtimeType.toString();
    final raw = e is FirebaseAuthException ? (e.message ?? '') : '$e';
    debugPrint(
      'FirebasePhoneAuth[$stage] $code: $raw '
      '(App Check provider: ${FirebaseSetup.androidProvider?.name ?? "none"})',
    );
    if (_isConfigProblem(code, raw)) {
      FirebaseSetup.recordNonFatal(e, st, reason: 'phone_auth_$stage:$code');
    }
    return _friendly(e);
  }

  static bool _isConfigProblem(String code, String raw) {
    const codes = {
      'app-not-authorized',
      'missing-client-identifier',
      'invalid-app-credential',
      'missing-app-credential',
      'captcha-check-failed',
      'internal-error',
      'unknown',
    };
    return codes.contains(code) || _looksLikeAppCheck(raw);
  }

  static bool _looksLikeAppCheck(String raw) {
    final m = raw.toLowerCase();
    return m.contains('app check') ||
        m.contains('appcheck') ||
        m.contains('app attestation') ||
        m.contains('play integrity') ||
        m.contains('attestation failed');
  }

  String _message(String text, String code) =>
      verbose ? '$text  [$code]' : text;

  String _friendly(Object e) {
    if (e is FirebasePhoneAuthException) return e.message;
    if (e is! FirebaseAuthException) {
      return _message('Verification failed. Please try again.', '$e');
    }
    final raw = e.message ?? '';
    if (_looksLikeAppCheck(raw)) {
      return _message(
        "We couldn't verify this copy of the app. Please update it from the "
            'Play Store and try again.',
        '${e.code}: $raw',
      );
    }
    final text = switch (e.code) {
      'invalid-phone-number' => 'That phone number looks invalid.',
      'invalid-verification-code' => 'That code is incorrect.',
      'invalid-verification-id' ||
      'session-expired' ||
      'code-expired' => 'The code expired. Request a new one.',
      'too-many-requests' => 'Too many attempts. Please try again later.',
      'quota-exceeded' => 'SMS limit reached. Please try again later.',
      'network-request-failed' =>
        'No internet connection. Check your network and try again.',
      'web-context-cancelled' || 'web-context-already-presented' =>
        'Verification was cancelled. Please try again.',
      'user-disabled' => 'This account has been disabled. Contact support.',
      'missing-client-identifier' ||
      'app-not-authorized' ||
      'invalid-app-credential' ||
      'missing-app-credential' ||
      'captcha-check-failed' =>
        "We couldn't verify this copy of the app. Please update it from the "
            'Play Store and try again.',
      _ => 'Verification failed. Please try again.',
    };
    return _message(text, verbose ? '${e.code}: $raw' : e.code);
  }
}
