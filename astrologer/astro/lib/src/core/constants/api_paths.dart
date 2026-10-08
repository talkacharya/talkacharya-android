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
  static const astroTrainingVideos = '/astro/training-videos';
  static const astroFavourites = '/astro/favourites';
  static String astroFavourite(String conversationId) =>
      '/astro/favourites/$conversationId';
  static const astroPhotos = '/astro/profile/photos';
  static String astroPhoto(String id) => '/astro/profile/photos/$id';
  static const astroFeedback = '/astro/feedback';
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

  // remedies that cost nothing to follow
  static const astroRemedyLibrary = '/astro/remedy-library';
  static const astroRemedyAdvice = '/astro/remedy-advice';
  static const astroWorkingHours = '/astro/working-hours';

  // consultations (astrologer-scoped)
  static const astroConsultations = '/astro/consultations';
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
  static String astroReviewReply(String id) => '/astro/reviews/$id/reply';
  static const astroGiftsReceived = '/astro/gifts/received';
}
