import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Tracks which birth profile the app is currently working with, and whether the
/// post-login "choose a profile" step is still owed for this session.
///
/// - [activeProfileId] persists across launches (restored in [load]).
/// - [loginGatePending] is in-memory only: [LoginCubit] sets it after a fresh
///   OTP verify; a cold start with a saved session never sets it. The router
///   sends a pending gate to `/select-profile`.
class ActiveProfileStore extends ChangeNotifier {
  ActiveProfileStore(this._storage);

  final FlutterSecureStorage _storage;
  static const _key = 'ta_active_profile_id';

  String? _activeProfileId;
  String? get activeProfileId => _activeProfileId;
  bool get hasActive => _activeProfileId != null;

  bool _loginGatePending = false;
  bool get loginGatePending => _loginGatePending;

  Future<void> load() async {
    try {
      _activeProfileId = await _storage.read(key: _key);
    } catch (e) {
      debugPrint('ActiveProfileStore: load failed ($e)');
    }
    notifyListeners();
  }

  /// Called by the login flow right before `AuthLoggedIn` so the router shows
  /// the profile picker once after this sign-in.
  void markLoginGatePending() {
    _loginGatePending = true;
    notifyListeners();
  }

  Future<void> setActive(String? id) async {
    _activeProfileId = id;
    _loginGatePending = false;
    try {
      if (id == null) {
        await _storage.delete(key: _key);
      } else {
        await _storage.write(key: _key, value: id);
      }
    } catch (e) {
      debugPrint('ActiveProfileStore: persist failed ($e)');
    }
    notifyListeners();
  }

  /// User chose to deal with profiles later — clear the gate, keep no active id.
  void skipLoginGate() {
    _loginGatePending = false;
    notifyListeners();
  }

  Future<void> clear() => setActive(null);
}
