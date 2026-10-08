import 'package:flutter/widgets.dart';

import 'gen/app_localizations.dart';

export 'gen/app_localizations.dart';

/// `context.l10n.walletTitle` — the app's single string lookup.
extension L10nX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

/// The languages the app is offered in. Only the two that are fully
/// translated and checked: the six in [kPlannedLocales] have their .arb files
/// but hundreds of strings still in English, and a half-English screen reads
/// as broken. Move a locale up here once its translation has been verified.
const kSupportedLocales = <Locale>[Locale('en'), Locale('hi')];

/// Translations in progress (docs/i18n.md §1) — not selectable yet.
const kPlannedLocales = <Locale>[
  Locale('bn'),
  Locale('mr'),
  Locale('te'),
  Locale('ta'),
  Locale('gu'),
  Locale('kn'),
];

/// Whether the app can be shown in [code] today.
bool isSupportedLanguage(String? code) =>
    kSupportedLocales.any((l) => l.languageCode == code);

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
