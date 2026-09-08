// Placeholder. Run `flutterfire configure --project=<id>` with an Android app for
// each flavor (com.talkacharya.astrologer{,.dev,.staging}) to generate the real file
// and drop the matching google-services.json under android/app/src/<flavor>/.
// Until then PushService.init() catches the failure and disables push.
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (defaultTargetPlatform == TargetPlatform.android) {
      throw UnsupportedError(
        'Firebase is not configured for the astrologer app yet. '
        'Run `flutterfire configure` and add google-services.json.',
      );
    }
    throw UnsupportedError('Firebase not configured for this platform.');
  }
}
