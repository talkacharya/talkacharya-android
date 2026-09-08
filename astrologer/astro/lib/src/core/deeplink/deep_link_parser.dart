/// Maps an inbound URI (`talkacharya://…` custom scheme or an `https://<host>/…`
/// App Link) to an in-app go_router location, or `null` when it points nowhere we
/// handle. Pure and side-effect free — unit-tested exhaustively.
String? locationForUri(Uri uri) {
  final segments = <String>[
    if (uri.scheme != 'http' && uri.scheme != 'https' && uri.host.isNotEmpty)
      uri.host,
    ...uri.pathSegments.where((s) => s.isNotEmpty),
  ];
  if (segments.isEmpty) return null;

  final id = segments.length > 1 ? segments[1] : null;

  switch (segments.first) {
    case 'home':
      return '/home';
    case 'requests':
      return '/requests';
    case 'earnings':
    case 'payouts':
      return '/earnings';
    case 'chats':
      return id == null ? '/chats' : '/chats/$id';
    case 'notifications':
      return '/notifications';
    case 'onboarding':
      return '/onboarding';
    case 'consultations':
    case 'consultation':
      // an astrologer's consultation link opens the session room
      return id == null ? '/chats' : '/chats/$id';
    case 'profile':
      // talkacharya://profile/kyc, talkacharya://profile/reviews, …
      return id == null ? '/profile' : '/profile/$id';
    case 'reviews':
      return '/profile/reviews';
    case 'livestreams':
    case 'livestream':
    case 'live':
      return '/profile/featured'; // host livestream entry lives under Profile for now
    default:
      return null;
  }
}

/// Same as [locationForUri] but tolerant of a raw string (e.g. an FCM
/// `data.deeplink`). Returns `null` for empty / unparseable input.
String? locationForRaw(String? raw) {
  if (raw == null || raw.trim().isEmpty) return null;
  final uri = Uri.tryParse(raw.trim());
  return uri == null ? null : locationForUri(uri);
}
