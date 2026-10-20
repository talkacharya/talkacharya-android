import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// The last thing the server said about a room — its thread and its session —
/// kept on the phone, so a room opens on what it looked like last time while
/// the fresh copy is on its way, the way a chat app opens: at once.
///
/// Raw server JSON, keyed by the id it was asked for. Small (two documents a
/// room) and cleared on sign-out with the rest of this account's chat.
class RoomSnapshots {
  RoomSnapshots(this._store);

  final FlutterSecureStorage _store;
  static const _prefix = 'room-snap:';

  String _conv(String id) => '${_prefix}conv:$id';
  String _cons(String id) => '${_prefix}cons:$id';

  Future<Map<String, dynamic>?> conversation(String id) => _read(_conv(id));
  Future<Map<String, dynamic>?> consultation(String id) => _read(_cons(id));

  /// Kept under every id the room can be opened with.
  Future<void> putConversation(
    Iterable<String> ids,
    Map<String, dynamic> json,
  ) => _write([for (final id in ids) _conv(id)], json);

  Future<void> putConsultation(String id, Map<String, dynamic> json) =>
      _write([_cons(id)], json);

  Future<void> clear() async {
    try {
      final all = await _store.readAll();
      for (final key in all.keys) {
        if (key.startsWith(_prefix)) await _store.delete(key: key);
      }
    } catch (_) {}
  }

  Future<Map<String, dynamic>?> _read(String key) async {
    try {
      final raw = await _store.read(key: key);
      if (raw == null || raw.isEmpty) return null;
      return (jsonDecode(raw) as Map).cast<String, dynamic>();
    } catch (_) {
      return null;
    }
  }

  Future<void> _write(List<String> keys, Map<String, dynamic> json) async {
    try {
      final raw = jsonEncode(json);
      for (final key in keys) {
        await _store.write(key: key, value: raw);
      }
    } catch (_) {
      // A snapshot is a head start, never a requirement.
    }
  }
}
