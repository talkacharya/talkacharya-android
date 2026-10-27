import 'dart:math';

/// A new value each time the app starts, sent with the astrologer list and the
/// home feed: the server shuffles astrologers by it, so each customer sees their
/// own order, the same while they scroll, and a fresh one on the next launch.
final String launchSeed = Random.secure().nextInt(1 << 32).toRadixString(36);
