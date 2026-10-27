/// Backend REST paths, relative to `AppConfig.apiBaseUrl`.
/// Mirrors backend/docs/api-surface.md (astrologer surface = /api/v1/astro/...).
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

  /// GET what deleting the account would mean; POST to ask for it.
  static const accountDelete = '/me/account/delete';
  static const meDevices = '/me/devices';
  static String meDevice(String id) => '/me/devices/$id';
  static const realtimeToken = '/realtime/token';
  // Served from the shared app mount, not a `/reference/` namespace — which
  // does not exist, and answered both of these with a 404 that took the whole
  // Edit profile screen down with it.
  static const referenceSkills = '/app/skills';
  static const referenceLanguages = '/app/languages';

  // per-user inbox — shared mount
  static const notifications = '/notifications';
  static String notificationRead(String id) => '/notifications/$id/read';
  static const notificationsReadAll = '/notifications/read-all';

  // onboarding & profile
  static const astroOnboarding = '/astro/onboarding';
  static const astroOnboardingKyc = '/astro/onboarding/kyc';
  static const astroOnboardingBank = '/astro/onboarding/bank-account';
  static const astroOnboardingSubmit = '/astro/onboarding/submit';
  static const astroProfile = '/astro/profile';
  static const astroProfileBanner = '/astro/profile/banner';
  static const astroRates = '/astro/rates';
  static const astroRateBands = '/astro/rates/bands';
  static const astroFeaturedSlots = '/astro/featured-slots';
  static const astroFeaturedPricing = '/astro/featured-slots/pricing';

  // availability
  static const astroAvailability = '/astro/availability';
  static const astroHeartbeat = '/astro/availability/heartbeat';
  static const astroOnline = '/astro/availability/online';
  static const astroOffline = '/astro/availability/offline';
  static const astroBreak = '/astro/availability/break';
  static const astroNextOnline = '/astro/availability/next-online';

  // waitlist
  static const astroQueue = '/astro/queue';
  static String astroQueueEntry(String id) => '/astro/queue/$id';

  // charts the astrologer casts on their own. The chart engine's
  // birth-profile endpoints sit on the shared `/app` mount and are open to
  // any signed-in user, each seeing only their own profiles.
  static const birthProfiles = '/app/birth-profiles';
  static String birthProfile(String id) => '/app/birth-profiles/$id';
  static String birthProfileKundali(String id, String sub) =>
      '/app/birth-profiles/$id/$sub';
  static const chartTypes = '/app/astrology/chart-types';
  static const placesSearch = '/app/places/search';
  static const matchmaking = '/app/matchmaking';

  // the astrologer's own corner
  static const astroAnnouncements = '/astro/announcements';
  static const astroTraining = '/astro/training';
  static String astroTrainingProgress(String id) =>
      '/astro/training/$id/progress';
  static String astroTrainingQuiz(String id) => '/astro/training/$id/quiz';
  static const astroFavourites = '/astro/favourites';
  static String astroFavourite(String conversationId) =>
      '/astro/favourites/$conversationId';
  static const astroPhotos = '/astro/profile/photos';
  static String astroPhoto(String id) => '/astro/profile/photos/$id';
  static const astroFeedback = '/astro/feedback';

  /// Assistant chat: the free, text-only line customers write in.
  static const astroAssistantThreads = '/astro/assistant/threads';
  static String astroAssistantThread(String id) =>
      '/astro/assistant/threads/$id';
  static String astroAssistantMessages(String id) =>
      '/astro/assistant/threads/$id/messages';
  static const astroTestRing = '/astro/test-ring';
  static const astroFollowers = '/astro/followers';
  static const astroReferrals = '/astro/referrals';
  static const astroOffers = '/astro/offers';
  static String astroOffer(String id) => '/astro/offers/$id';

  // remedies suggested from the store
  static const astroStoreRecommendations = '/astro/store/recommendations';
  static const astroStoreProducts = '/astro/store/products';
  static const astroPoojaCalendar = '/astro/store/pooja-calendar';
  static const astroPoojaBookings = '/astro/store/pooja-bookings';
  static const astroRecommendedSales = '/astro/store/recommended-sales';

  // the astrologer's own store: setup, listings (seller/* for orders)
  static const astroStoreSeller = '/astro/store/seller';
  static const astroCatalogOptions = '/astro/store/catalog/options';
  static const astroListings = '/astro/store/catalog/products';
  static String astroListing(String id) => '/astro/store/catalog/products/$id';
  static String astroListingMedia(String id) =>
      '/astro/store/catalog/products/$id/media';
  static String astroListingMediaItem(String id, int mediaId) =>
      '/astro/store/catalog/products/$id/media/$mediaId';
  static String astroListingMediaOrder(String id) =>
      '/astro/store/catalog/products/$id/media/order';
  static String astroListingSubmit(String id) =>
      '/astro/store/catalog/products/$id/submit';
  static String astroListingWithdraw(String id) =>
      '/astro/store/catalog/products/$id/withdraw';
  static const sellerOrders = '/seller/orders';
  static String sellerOrder(String id) => '/seller/orders/$id';
  static String sellerOrderAction(String id, String action) =>
      '/seller/orders/$id/$action';
  static const sellerBookings = '/seller/bookings';
  static String sellerBookingAction(String id, String action) =>
      '/seller/bookings/$id/$action';

  // remedies that cost nothing to follow
  static const astroRemedyLibrary = '/astro/remedy-library';
  static const astroRemedyAdvice = '/astro/remedy-advice';
  static const astroWorkingHours = '/astro/working-hours';

  // consultations (astrologer-scoped)
  static const astroConsultations = '/astro/consultations';
  static const astroConsultationHistory = '/astro/consultations/history';
  static const astroConsultationRequests = '/astro/consultations/requests';
  static String astroConsultation(String id) => '/astro/consultations/$id';
  static String astroAccept(String id) => '/astro/consultations/$id/accept';
  static String astroReject(String id) => '/astro/consultations/$id/reject';
  static String astroEnd(String id) => '/astro/consultations/$id/end';
  static String astroConsultationMatch(String id, String matchId) =>
      '/astro/consultations/$id/matches/$matchId';
  static String astroConsultationChart(String id) =>
      '/astro/consultations/$id/chart';
  // in-session kundali surface (mirrors the customer /app/birth-profiles/{id}/{sub})
  static String astroConsultationKundali(String id, String sub) =>
      '/astro/consultations/$id/$sub';

  // live streaming (host side)
  static const astroLivestreams = '/astro/livestreams';
  static String astroLiveStart(String id) => '/astro/livestreams/$id/start';
  static String astroLiveEnd(String id) => '/astro/livestreams/$id/end';
  static String astroLiveChat(String id) => '/astro/livestreams/$id/chat';
  static String astroLiveViewers(String id) => '/astro/livestreams/$id/viewers';
  static String astroLiveRemoveViewer(String id) =>
      '/astro/livestreams/$id/viewers/remove';
  static String astroLiveSlowMode(String id) =>
      '/astro/livestreams/$id/slow-mode';
  static String astroLivePin(String id) => '/astro/livestreams/$id/chat/pin';
  static String astroLiveCalls(String id) => '/astro/livestreams/$id/calls';
  static String astroLiveCallEnd(String id, String request) =>
      '/astro/livestreams/$id/calls/$request/end';
  static String astroLiveCallMute(String id, String request) =>
      '/astro/livestreams/$id/calls/$request/mute';

  // predictions work queue
  static const predictionsQueue = '/astro/predictions/queue';
  static String prediction(String id) => '/astro/predictions/$id';
  static String predictionClaim(String id) => '/astro/predictions/$id/claim';
  static String predictionDeliver(String id) =>
      '/astro/predictions/$id/deliver';
  static String predictionRelease(String id) =>
      '/astro/predictions/$id/release';

  // in-session chat / call — shared mount, participant-checked

  /// The chats list: one thread per peer.
  static const conversations = '/conversations';

  /// This user's mute / archive / block settings for a thread.
  static String conversationPreferences(String id) =>
      '/conversations/$id/preferences';

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

  // quick replies — the astrologer's, not any one thread's
  static const savedReplies = '/astro/saved-replies';
  static String savedReply(String id) => '/astro/saved-replies/$id';

  static String rtcToken(String id) => '/consultations/$id/rtc-token';

  // earnings & payouts
  static const astroEarnings = '/astro/earnings';
  static const astroEarningEntries = '/astro/earnings/entries';
  static const astroEarningsStatement = '/astro/earnings/statement';
  static const astroEarningsStatementItems = '/astro/earnings/statement/items';
  static const astroPayouts = '/astro/payouts';
  static String astroPayout(String id) => '/astro/payouts/$id';
  static const astroTaxDocuments = '/astro/tax-documents';
  static String astroTaxDocumentPdf(String id) =>
      '/astro/tax-documents/$id/pdf';

  // analytics / reviews / gifts
  static const astroAnalytics = '/astro/analytics/dashboard';
  static const astroPerformance = '/astro/analytics/performance';
  static const astroLapsedCustomers = '/astro/analytics/lapsed-customers';
  static const astroReviews = '/astro/reviews';

  // reports customers raised on this astrologer's sessions
  static const astroDisputes = '/astro/disputes';
  static String astroDispute(String id) => '/astro/disputes/$id';
  static String astroDisputeResponse(String id) =>
      '/astro/disputes/$id/response';
  static String astroReviewReply(String id) => '/astro/reviews/$id/reply';
  static const astroGiftsReceived = '/astro/gifts/received';
}
