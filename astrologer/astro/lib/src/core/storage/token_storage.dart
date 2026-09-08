import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Persists the JWT pair in the platform keystore/keychain. The single source of
/// truth for "is there a session"; the auth interceptor and AuthBloc both read it.
class TokenStorage {
  TokenStorage(this._store);

  final FlutterSecureStorage _store;

  static const _kAccess = 'ta_access_token';
  static const _kRefresh = 'ta_refresh_token';
  static const _kUser = 'ta_user_json';

  Future<String?> readAccess() => _store.read(key: _kAccess);
  Future<String?> readRefresh() => _store.read(key: _kRefresh);

  Future<bool> get hasSession async =>
      (await readRefresh())?.isNotEmpty ?? false;

  /// Last known user, cached so the app opens instantly (and works offline)
  /// while `/me` is re-fetched in the background.
  Future<String?> readUserJson() => _store.read(key: _kUser);
  Future<void> saveUserJson(String json) => _store.write(key: _kUser, value: json);

  Future<void> save({required String access, required String refresh}) async {
    await Future.wait([
      _store.write(key: _kAccess, value: access),
      _store.write(key: _kRefresh, value: refresh),
    ]);
  }

  Future<void> saveAccess(String access) =>
      _store.write(key: _kAccess, value: access);

  Future<void> clear() async {
    await Future.wait([
      _store.delete(key: _kAccess),
      _store.delete(key: _kRefresh),
      _store.delete(key: _kUser),
    ]);
  }
}
