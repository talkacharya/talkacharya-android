import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:play_install_referrer/play_install_referrer.dart';

/// The invite code in a Play Store install referrer — the website's invite
/// page sends people to the store with `referrer=referral_code%3D<code>` — or
/// null when the install did not come from an invite.
String? referralCodeFromInstallReferrer(String? referrer) {
  if (referrer == null || referrer.trim().isEmpty) return null;
  try {
    final code = Uri.splitQueryString(referrer)['referral_code']?.trim();
    if (code == null || code.isEmpty) return null;
    return RegExp(r'^[A-Za-z0-9_-]{1,32}$').hasMatch(code) ? code : null;
  } catch (_) {
    return null;
  }
}

/// The referral code from an invite link (`https://talkacharya.com/r/<code>`)
/// that was opened before the person had an account.
///
/// Kept on the phone — the link and the sign-up can be minutes or an app
/// restart apart — and sent with the sign-in, which is where the server credits
/// the person who invited them. Cleared once a sign-in has carried it.
class PendingReferral {
  PendingReferral(this._storage);

  final FlutterSecureStorage _storage;

  static const _key = 'pending_referral_code';
  static const _checkedKey = 'install_referrer_checked';

  /// Someone without the app who opens an invite link is sent to the Play
  /// Store, and the code comes along as the install referrer. Read it once,
  /// on the first launch after the install, and keep it like a code from a
  /// link. A code already kept from a link wins.
  Future<void> captureInstallReferrer() async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) return;
    try {
      if (await _storage.read(key: _checkedKey) != null) return;
      final details = await PlayInstallReferrer.installReferrer;
      await _storage.write(key: _checkedKey, value: '1');
      final code = referralCodeFromInstallReferrer(details.installReferrer);
      if (code != null && await read() == null) await save(code);
    } catch (e) {
      // No Play Store on this phone, or it did not answer: asked again next
      // launch, and an invite simply is not credited if it never does.
      debugPrint('PendingReferral: install referrer unavailable ($e)');
    }
  }

  Future<void> save(String code) async {
    final clean = code.trim();
    if (clean.isEmpty) return;
    try {
      await _storage.write(key: _key, value: clean);
    } catch (_) {
      // Losing an invite code must never get in the way of opening the app.
    }
  }

  Future<String?> read() async {
    try {
      final code = await _storage.read(key: _key);
      return (code == null || code.isEmpty) ? null : code;
    } catch (_) {
      return null;
    }
  }

  Future<void> clear() async {
    try {
      await _storage.delete(key: _key);
    } catch (_) {}
  }
}
