import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'models/zodiac.dart';

/// Remembers the sign the user picked for their daily horoscope. Birth profiles
/// don't carry a rasi, so the home card defaults to the Western sun sign of the
/// active profile's birth date and lets the user override it here.
class HoroscopeSignStore extends ChangeNotifier {
  HoroscopeSignStore(this._storage);

  final FlutterSecureStorage _storage;
  static const _key = 'ta_horoscope_sign';

  ZodiacSign? _sign;
  ZodiacSign? get sign => _sign;

  Future<void> load() async {
    try {
      _sign = ZodiacSign.fromSlug(await _storage.read(key: _key));
    } catch (e) {
      debugPrint('HoroscopeSignStore: load failed ($e)');
    }
    notifyListeners();
  }

  Future<void> set(ZodiacSign sign) async {
    _sign = sign;
    notifyListeners();
    try {
      await _storage.write(key: _key, value: sign.slug);
    } catch (e) {
      debugPrint('HoroscopeSignStore: persist failed ($e)');
    }
  }
}
