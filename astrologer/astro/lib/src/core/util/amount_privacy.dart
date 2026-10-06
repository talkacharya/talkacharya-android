import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Whether earnings are masked on screen — astrologers work with customers,
/// family and other astrologers looking over their shoulder. `true` = hidden.
/// Remembered across launches.
class AmountPrivacy extends ValueNotifier<bool> {
  AmountPrivacy(this._storage) : super(false) {
    _restore();
  }

  final FlutterSecureStorage _storage;
  static const _key = 'ta_astro_hide_amounts';

  Future<void> _restore() async {
    try {
      if (await _storage.read(key: _key) == 'true') value = true;
    } catch (_) {}
  }

  Future<void> toggle() async {
    value = !value;
    try {
      await _storage.write(key: _key, value: value.toString());
    } catch (_) {}
  }

  /// [formatted] as given, or dots in its place while hidden.
  String mask(String formatted) => value ? '• • • •' : formatted;
}
