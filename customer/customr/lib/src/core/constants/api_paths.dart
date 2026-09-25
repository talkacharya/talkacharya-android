/// Backend REST paths, relative to `AppConfig.apiBaseUrl`.
/// Mirrors backend/docs/api-surface.md.
class ApiPaths {
  const ApiPaths._();

  // shared / auth
  static const otpRequest = '/auth/otp/request';
  static const otpVerify = '/auth/otp/verify';
  static const authFirebase = '/auth/firebase';
  static const tokenRefresh = '/auth/token/refresh';
  static const logout = '/auth/logout';
  static const config = '/config';
  static const me = '/me';
  static const meDevices = '/me/devices';
  static String meDevice(String id) => '/me/devices/$id';
  static const realtimeToken = '/realtime/token';

  // customer app surface — /api/v1/app/...
  static const birthProfiles = '/app/birth-profiles';
  static String birthProfile(String id) => '/app/birth-profiles/$id';
  static String birthProfilePrimary(String id) =>
      '/app/birth-profiles/$id/primary';
  static String birthProfilePanchang(String id) =>
      '/app/birth-profiles/$id/panchang';
  static const placesSearch = '/app/places/search';

  // kundali — /app/birth-profiles/{id}/{sub}
  static String kundaliArtifact(String id, String sub) =>
      '/app/birth-profiles/$id/$sub';
  static String kundaliPdf(String id) => '/app/birth-profiles/$id/kundli.pdf';

  // astrology
  static const horoscope = '/app/horoscope';

  /// `?latitude=&longitude=&date=&place=` — any place, not tied to a profile.
  static const panchang = '/app/panchang';
  static const matchmaking = '/app/matchmaking';
  static String matchmakingDetail(String id) => '/app/matchmaking/$id';
  static const astrologyChartTypes = '/app/astrology/chart-types';
  static const astrologyTransitAlerts = '/app/astrology/transit-alerts';
  static const astrologyMoodAlerts = '/app/astrology/mood-alerts';

  static const astrologers = '/app/astrologers';
  static String astrologer(String id) => '/app/astrologers/$id';
  static String astrologerFollow(String id) => '/app/astrologers/$id/follow';
  static const meFollowing = '/app/me/following';
  static const followAlerts = '/app/follows/alerts';
  static const home = '/app/home';
  static const wallet = '/app/wallet';
  static const walletPacks = '/app/wallet/packs';
  static const walletTransactions = '/app/wallet/transactions';
  static const walletRecharge = '/app/wallet/recharge';
  static String rechargeStatus(String id) => '/app/wallet/recharge/$id';
  static String rechargeVerify(String id) => '/app/wallet/recharge/$id/verify';
  static const promoRedeem = '/app/promo/redeem';
  static const invoices = '/app/invoices';
  static String invoicePdf(String id) => '/app/invoices/$id/pdf';

  // prashna (horary) — /app/prashna/...
  static const prashnaCatalog = '/app/prashna/catalog';
  static const prashna = '/app/prashna';
  static String prashnaDetail(String id) => '/app/prashna/$id';

  // predictions — /app/predictions/...
  static const predictionsCatalog = '/app/predictions/catalog';
  static const predictionsOrders = '/app/predictions/orders';
  static const predictionsSubscription = '/app/predictions/subscription';
  static const predictions = '/app/predictions';
  static String prediction(String id) => '/app/predictions/$id';
  static const consultations = '/app/consultations';
  static String consultation(String id) => '/app/consultations/$id';
  static String consultationCancel(String id) =>
      '/app/consultations/$id/cancel';
  static String consultationEnd(String id) => '/app/consultations/$id/end';
  static String consultationShares(String id) =>
      '/app/consultations/$id/shares';
  static String consultationReview(String id) =>
      '/app/consultations/$id/review';
  static String consultationDispute(String id) =>
      '/app/consultations/$id/dispute';
  // help & disputes — /app/disputes/...
  static const disputes = '/app/disputes';
  static String dispute(String id) => '/app/disputes/$id';
  // chat / call — shared mount, no /app prefix
  static String messages(String id) => '/consultations/$id/messages';
  static String messagesRead(String id) => '/consultations/$id/messages/read';
  static String messagesDelivered(String id) =>
      '/consultations/$id/messages/delivered';
  static String messageTranslate(String id, int seq) =>
      '/consultations/$id/messages/$seq/translate';
  static String messagePins(String id) =>
      '/consultations/$id/messages/pins';

  static String messageReport(String id, int seq) =>
      '/consultations/$id/messages/$seq/report';
  static String typing(String id) => '/consultations/$id/typing';
  static String chatPresence(String id) => '/consultations/$id/presence';
  static String attachments(String id) => '/consultations/$id/attachments';
  static const referrals = '/app/referrals';
  // editorial — public, no /app prefix
  static const articles = '/content/articles';
  static String article(String slug) => '/content/articles/$slug';
  // gifting — /app/gifts/...
  static const gifts = '/app/gifts';
  static const giftsSend = '/app/gifts/send';
  static const giftsSent = '/app/gifts/sent';
  // per-user inbox — shared mount, no /app prefix
  static const notifications = '/notifications';
  static String notificationRead(String id) => '/notifications/$id/read';
  static const notificationsReadAll = '/notifications/read-all';
  static const livestreams = '/app/livestreams';
  static String livestream(String id) => '/app/livestreams/$id';

  // store — /app/store/... (products, poojas, orders, consult before buying)
  static const storeHome = '/app/store/home';
  static const storeCategories = '/app/store/categories';
  static const storeFilters = '/app/store/filters';
  static const storeProducts = '/app/store/products';
  static String storeProduct(String slug) => '/app/store/products/$slug';
  static String storeProductEvents(String slug) =>
      '/app/store/products/$slug/events';
  static String storeProductConsult(String slug) =>
      '/app/store/products/$slug/consult';
  static String storeCollection(String slug) => '/app/store/collections/$slug';
  static const storeCart = '/app/store/cart';
  static const storeCartItems = '/app/store/cart/items';
  static String storeCartItem(String id) => '/app/store/cart/items/$id';
  static const storeAddresses = '/app/store/addresses';
  static String storeAddress(String id) => '/app/store/addresses/$id';
  static const storeCheckoutQuote = '/app/store/checkout/quote';
  static const storeCheckout = '/app/store/checkout';
  static const storeOrders = '/app/store/orders';
  static String storeOrder(String id) => '/app/store/orders/$id';
  static String storeOrderVerify(String id) =>
      '/app/store/orders/$id/verify-payment';
  static String storeOrderRetry(String id) =>
      '/app/store/orders/$id/retry-payment';
  static String storeOrderCancel(String id) => '/app/store/orders/$id/cancel';
  static String storeSubOrderCancel(String orderId, String subOrderId) =>
      '/app/store/orders/$orderId/sub-orders/$subOrderId/cancel';
  static String storeOrderInvoices(String id) =>
      '/app/store/orders/$id/invoices';
  static String storeLineReturn(String orderId, String lineId) =>
      '/app/store/orders/$orderId/lines/$lineId/return';
  static const storeReturns = '/app/store/returns';
  static const storeBookings = '/app/store/bookings';
  static String storeDownload(String id) => '/app/store/downloads/$id';
  static const storeRecommendations = '/app/store/recommendations';
  static const storeConsults = '/app/store/consults';
  static String storeConsult(String id) => '/app/store/consults/$id';
}
