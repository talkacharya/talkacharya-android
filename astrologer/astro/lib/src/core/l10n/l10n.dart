import 'package:flutter/widgets.dart';

import 'gen/app_localizations.dart';

export 'gen/app_localizations.dart';

/// `context.l10n.navHome` — the app's single string lookup.
extension L10nX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

/// Locales with an ARB file. A `preferred_language` outside this set falls
/// back to English (the customer app ships more; add ARBs here as they land).
const kSupportedLocales = AppLocalizations.supportedLocales;

/// Each supported language in its own script, for the language picker.
const kLanguageNativeNames = <String, String>{'en': 'English', 'hi': 'हिन्दी'};
