/// Route locations. Grouped: top-level (outside the shell) and the shell tabs.
class Routes {
  const Routes._();

  // top-level
  static const splash = '/';
  static const login = '/login';
  static const notifications = '/notifications';

  /// Post-login birth-profile picker (soft gate).
  static const selectProfile = '/select-profile';
  static const selectProfileNew = '/select-profile/new';

  /// `/consultations/:id`
  static String consultation(String id) => '/consultations/$id';
  static const consultationPattern = '/consultations/:id';

  // shell branches (bottom-nav tab roots)
  static const home = '/home';
  static const astrologers = '/astrologers';
  static const live = '/live';
  static const profile = '/profile';

  /// Full-screen, not tabs — reached from the home header + Profile.
  static const wallet = '/wallet';
  static const chats = '/chats'; // "Orders" in Profile

  /// Full horoscope; `?sign=leo&span=week` pre-selects.
  static const horoscope = '/horoscope';
  static String horoscopeFor({String? sign, String? span}) {
    final q = <String, String>{'sign': ?sign, 'span': ?span};
    return q.isEmpty
        ? horoscope
        : Uri(path: horoscope, queryParameters: q).toString();
  }

  /// Kundali Milan (Guna Milan) hub + a saved result.
  static const matchmaking = '/matchmaking';
  static String matchResult(String id) => '/matchmaking/$id';

  // nested inside a branch (keep the tab selected)
  static String astrologer(String id) => '/astrologers/$id';
  static String liveRoom(String id) => '/live/$id';

  /// Discovery tab, optionally pre-filtered. Unknown params are ignored by the
  /// page today but kept so deep-links/rails stay forward-compatible.
  static String astrologersWith({
    String? skill,
    String? channel,
    String? sort,
    String? query,
  }) {
    final q = <String, String>{
      'skill': ?skill,
      'channel': ?channel,
      'sort': ?sort,
      'q': ?query,
    };
    if (q.isEmpty) return astrologers;
    final qs = q.entries
        .map((e) => '${e.key}=${Uri.encodeQueryComponent(e.value)}')
        .join('&');
    return '$astrologers?$qs';
  }

  static const walletTransactions = '/wallet/transactions';
  static const walletInvoices = '/wallet/invoices';

  static const referrals = '/profile/referrals';

  /// Full daily panchang for a chosen city (`?date=YYYY-MM-DD`).
  static const panchang = '/panchang';

  /// Editorial "Read & learn" list (`?category=`) + the reader.
  static const articles = '/articles';
  static String article(String slug) => '/articles/$slug';

  /// Help & support hub; reports are full-screen so deep links land cleanly.
  static const help = '/profile/help';
  static String dispute(String id) => '/disputes/$id';
  static const disputePattern = '/disputes/:id';
  static String reportIssue(String consultationId) =>
      '/consultations/$consultationId/report';
  static const editProfile = '/profile/edit';
  static const notificationPrefs = '/profile/notifications';
  static const following = '/profile/following';
  static const deleteAccount = '/profile/delete-account';
  static const birthProfiles = '/profile/birth-profiles';
  static const birthProfileNew = '/profile/birth-profiles/new';
  static String birthProfileEdit(String id) =>
      '/profile/birth-profiles/$id/edit';

  // --- store (remedies shop, poojas, consult before buying) — full-screen -----
  static const store = '/store';
  static const storeProducts = '/store/products';
  static String storeProductsWith(Map<String, String> query) => query.isEmpty
      ? storeProducts
      : Uri(path: storeProducts, queryParameters: query).toString();
  static String storeProduct(String slug, {String? recommendationId}) =>
      recommendationId == null
      ? '/store/products/$slug'
      : Uri(
          path: '/store/products/$slug',
          queryParameters: {'rec': recommendationId},
        ).toString();
  static String storeProductConsult(String slug) =>
      '/store/products/$slug/consult';
  static String storeCollection(String slug) => '/store/collections/$slug';
  static const storeCart = '/store/cart';
  static const storeCheckout = '/store/checkout';
  static const storeAddresses = '/store/addresses';
  static const storeAddressNew = '/store/addresses/new';
  static const storeOrders = '/store/orders';
  static const storePoojaBookings = '/store/orders?tab=poojas';

  /// [placed] shows the "order placed" celebration on arrival from checkout.
  static String storeOrder(String id, {bool placed = false}) =>
      placed ? '/store/orders/$id?placed=1' : '/store/orders/$id';
  static String storeAddressEdit(String id) => '/store/addresses/$id/edit';
  static String storeReturn(String orderId, String lineId) =>
      '/store/orders/$orderId/lines/$lineId/return';
  static const storeConsults = '/store/consults';
  static String storeConsult(String id) => '/store/consults/$id';

  /// Order of the branches — index maps to the bottom-nav destinations.
  static const branchRoots = [home, astrologers, live, profile];
}
