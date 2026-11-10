/// One way in for every link in the TalkAcharya apps.
///
/// A deep link, an App Link, a notification tap (from the tray, while open, or
/// on a cold start) and a link inside the app all go through [AppNavigator],
/// which decides *where* and *how* the destination opens:
///
/// * a tab opens as that tab;
/// * anything else opens above what is on screen, with the tabs beneath — on a
///   cold start Home comes up first, so back always has somewhere to go;
/// * nothing opens until the app is past its gates (signed in, onboarding…);
///   it waits, then opens;
/// * the page already on top is not opened twice; a second room of the same
///   kind replaces the first;
/// * during a call nothing tears the call down;
/// * a link that leads nowhere opens Home and says so;
/// * signed out, a public page (an article, a profile) opens without signing in.
///
/// Each app supplies its own [LinkHost] — its gates, tabs and public pages —
/// and its own parser from URI to location.
library;

export 'src/app_navigator.dart';
export 'src/link_host.dart';
