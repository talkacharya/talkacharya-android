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
    case 'r':
      // An invite link. The code is kept for the sign-up (see
      // [referralCodeFromUri]); someone already signed in lands on referrals.
      return '/profile/referrals';
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
      return id == null ? '/astrologers' : '/astrologers/$id';
    case 'astrologer':
      // `talkacharya://astrologer/<id>` in old pushes. On the web that path
      // belongs to the astrologer app and never reaches this one.
      if (uri.scheme == 'http' || uri.scheme == 'https') return null;
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
    case 'store':
    case 'shop':
    case 'remedies-store':
      return _storeLocation(segments.skip(1).toList(), uri.queryParameters);
    case 'product':
    case 'products':
      return _storeLocation([
        'products',
        ...segments.skip(1),
      ], uri.queryParameters);
    default:
      return null;
  }
}

/// `store/…` sub-paths. Unknown sub-paths land on the store home rather than
/// nowhere, so an outdated link in an old push still opens something useful.
String _storeLocation(List<String> rest, Map<String, String> query) {
  String withQuery(String path, [Map<String, String>? q]) {
    final params = q ?? query;
    return params.isEmpty
        ? path
        : Uri(path: path, queryParameters: params).toString();
  }

  final head = rest.isEmpty ? '' : rest.first;
  final slug = rest.length > 1 ? rest[1] : null;
  switch (head) {
    case '':
      return '/store';
    case 'products':
    case 'product':
      return slug == null
          ? withQuery('/store/products')
          : withQuery('/store/products/$slug');
    case 'categories':
    case 'category':
      return slug == null
          ? '/store/products'
          : withQuery('/store/products', {...query, 'category': slug});
    case 'collections':
    case 'collection':
      return slug == null ? '/store' : '/store/collections/$slug';
    case 'remedy':
    case 'remedies':
      return slug == null
          ? '/store'
          : withQuery('/store/products', {...query, 'remedy': slug});
    case 'cart':
    case 'checkout':
      return '/store/cart';
    case 'orders':
    case 'order':
      return slug == null ? '/store/orders' : '/store/orders/$slug';
    case 'bookings':
    case 'poojas':
      return '/store/orders?tab=poojas';
    case 'consults':
    case 'consult':
    case 'recommendations':
      return slug == null || head == 'recommendations'
          ? '/store/consults'
          : '/store/consults/$slug';
    default:
      return '/store';
  }
}

/// The referral code in an invite link — `https://talkacharya.com/r/<code>` or
/// `talkacharya://r/<code>` — or null when [uri] is not one.
String? referralCodeFromUri(Uri uri) {
  final segments = <String>[
    if (uri.scheme != 'http' && uri.scheme != 'https' && uri.host.isNotEmpty)
      uri.host,
    ...uri.pathSegments.where((s) => s.isNotEmpty),
  ];
  if (segments.length < 2 || segments.first != 'r') return null;
  final code = segments[1].trim();
  return code.isEmpty ? null : code;
}

/// Same as [locationForUri] but tolerant of a raw string (e.g. an FCM
/// `data.deeplink`). Returns `null` for empty / unparseable input.
String? locationForRaw(String? raw) {
  if (raw == null || raw.trim().isEmpty) return null;
  final uri = Uri.tryParse(raw.trim());
  return uri == null ? null : locationForUri(uri);
}
