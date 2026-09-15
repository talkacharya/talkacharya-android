import 'package:flutter/widgets.dart';

import 'gen/app_localizations.dart';

export 'gen/app_localizations.dart';

/// `context.l10n.walletTitle` — the app's single string lookup.
extension L10nX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

/// The launch language set (docs/i18n.md §1). `en` is the base + ultimate
/// fallback; the other locales resolve to English for any key not yet translated.
const kSupportedLocales = <Locale>[
  Locale('en'),
  Locale('hi'),
  Locale('bn'),
  Locale('mr'),
  Locale('te'),
  Locale('ta'),
  Locale('gu'),
  Locale('kn'),
];

/// Each language written in its own script — so the picker is legible to a
/// speaker regardless of the app's current locale.
const kLanguageNativeNames = <String, String>{
  'en': 'English',
  'hi': 'हिन्दी',
  'bn': 'বাংলা',
  'mr': 'मराठी',
  'te': 'తెలుగు',
  'ta': 'தமிழ்',
  'gu': 'ગુજરાતી',
  'kn': 'ಕನ್ನಡ',
};

/// English name too (useful when showing "हिन्दी (Hindi)" or for search).
const kLanguageEnglishNames = <String, String>{
  'en': 'English',
  'hi': 'Hindi',
  'bn': 'Bengali',
  'mr': 'Marathi',
  'te': 'Telugu',
  'ta': 'Tamil',
  'gu': 'Gujarati',
  'kn': 'Kannada',
};
