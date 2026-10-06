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
  // a busy astrologer's waitlist — this customer's places in line
  static const queue = '/app/queue';
  // is this customer's next consultation their welcome one?
  static const welcomeOffer = '/app/welcome-offer';
  static String queueEntry(String id) => '/app/queue/$id';
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

  /// The chats list: one thread per peer.
  static const conversations = '/conversations';
  static String conversation(String id) => '/conversations/$id';

  // Everything inside a thread is keyed on the thread, not on the session
  // running in it — a room outlives its consultation.
  static String messages(String id) => '/conversations/$id/messages';
  static String messageSearch(String id) =>
      '/conversations/$id/messages/search';
  static String transcript(String id) => '/conversations/$id/transcript';
  static String messagesRead(String id) => '/conversations/$id/messages/read';
  static String messagesDelivered(String id) =>
      '/conversations/$id/messages/delivered';
  static String messageTranslate(String id, int seq) =>
      '/conversations/$id/messages/$seq/translate';
  static String messagePins(String id) => '/conversations/$id/messages/pins';
  static String messageReport(String id, int seq) =>
      '/conversations/$id/messages/$seq/report';
  static String typing(String id) => '/conversations/$id/typing';
  static String chatPresence(String id) => '/conversations/$id/presence';
  static String attachments(String id) => '/conversations/$id/attachments';

  /// This user's mute / archive / block settings for a thread.
  static String conversationPreferences(String id) =>
      '/conversations/$id/preferences';

  /// Start another session inside a thread, without the booking form.
  static String conversationConsult(String id) =>
      '/app/conversations/$id/consult';

  /// Move a live consultation onto voice or video without re-booking.
  static String consultationUpgrade(String id) =>
      '/app/consultations/$id/upgrade';

  /// A standing instruction to top up mid-consultation, and the mandate
  /// registration that makes it live.
  static const autoRecharge = '/app/wallet/auto-recharge';
  static const autoRechargeAuthorize = '/app/wallet/auto-recharge/authorize';

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

  /// Ask a live host for a private reading — joins their consultation queue.
  static String livestreamConsult(String id) =>
      '/app/livestreams/$id/consult';

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
