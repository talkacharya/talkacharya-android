import 'package:flutter/foundation.dart';

/// The account was signed in on another phone, which ended this one's session.
const kSessionReplaced = 'session.replaced';

/// Why the last session ended, when the server said so — read once by the
/// sign-in screen to tell the person, then cleared. Null: nothing to say (an
/// ordinary sign-out or an expired session).
final ValueNotifier<String?> sessionEndReason = ValueNotifier<String?>(null);
