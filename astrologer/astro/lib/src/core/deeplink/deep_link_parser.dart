/// Maps an inbound URI (`talkacharya://…` custom scheme or an `https://<host>/…`
/// App Link) to an in-app go_router location, or `null` when it points nowhere we
/// handle. Pure and side-effect free — unit-tested exhaustively.
String? locationForUri(Uri uri) {
  final segments = <String>[
    if (uri.scheme != 'http' && uri.scheme != 'https' && uri.host.isNotEmpty)
      uri.host,
    ...uri.pathSegments.where((s) => s.isNotEmpty),
  ];
  // On the web every link to this app lives under /astrologer — the site and
  // the customer app share the domain — so that prefix is not part of the
  // destination: https://talkacharya.com/astrologer/requests/1 is requests/1.
  if (uri.scheme == 'http' || uri.scheme == 'https') {
    if (segments.isEmpty || segments.first != 'astrologer') return null;
    segments.removeAt(0);
    if (segments.isEmpty) return '/home';
  }
  if (segments.isEmpty) return null;

  final id = segments.length > 1 ? segments[1] : null;

  switch (segments.first) {
    case 'home':
      return '/home';
    case 'requests':
      return id == null ? '/requests' : '/requests/$id';
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
      // A consultation link (usually an incoming-request push) opens the
      // request screen, which accepts or bounces into the room by status.
      return id == null ? '/requests' : '/requests/$id';
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
