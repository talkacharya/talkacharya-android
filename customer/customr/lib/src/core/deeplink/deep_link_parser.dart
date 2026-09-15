/// Maps an inbound URI (custom scheme `talkacharya://…` or an https App Link)
/// to an in-app go_router location, or `null` when it points nowhere we handle.
///
/// Pure and side-effect free so it can be unit-tested exhaustively.
String? locationForUri(Uri uri) {
  // For `talkacharya://wallet` the "wallet" part is the host; for
  // `https://talkacharya.com/wallet` it is the first path segment. Normalise
  // both into a single segment list.
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
    case 'wallet':
      return '/wallet';
    case 'notifications':
      return '/notifications';
    case 'referrals':
      return '/profile/referrals';
    case 'panchang':
    case 'panchangam':
      return '/panchang';
    case 'articles':
    case 'article':
    case 'blog':
      return id == null ? '/articles' : '/articles/$id';
    case 'help':
    case 'support':
      return '/profile/help';
    case 'disputes':
    case 'dispute':
      return id == null ? '/profile/help' : '/disputes/$id';
    case 'astrologers':
    case 'astrologer':
      return id == null ? '/astrologers' : '/astrologers/$id';
    case 'consultations':
    case 'consultation':
      return id == null ? null : '/consultations/$id';
    case 'kundali':
      // talkacharya://kundali/<id>[/<section>] — e.g. .../transits, .../sade-sati
      if (id == null) return null;
      final section = segments.length > 2 ? segments[2] : null;
      return section == null ? '/kundali/$id' : '/kundali/$id/$section';
    case 'predictions':
    case 'prediction':
      return id == null ? '/predictions' : '/predictions/$id';
    case 'horoscope':
    case 'rashifal':
      // talkacharya://horoscope[/<sign>] — e.g. .../horoscope/leo
      return id == null ? '/horoscope' : '/horoscope?sign=$id';
    case 'matchmaking':
    case 'kundli-milan':
    case 'match':
      return id == null ? '/matchmaking' : '/matchmaking/$id';
    case 'livestreams':
    case 'livestream':
    case 'live':
      return id == null ? '/live' : '/live/$id';
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
