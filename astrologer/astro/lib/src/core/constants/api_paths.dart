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
  static const referenceSkills = '/reference/skills';
  static const referenceLanguages = '/reference/languages';

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
  static const astroFeaturedSlots = '/astro/featured-slots';

  // availability
  static const astroAvailability = '/astro/availability';
  static const astroHeartbeat = '/astro/availability/heartbeat';
  static const astroOffline = '/astro/availability/offline';
  static const astroWorkingHours = '/astro/working-hours';

  // consultations (astrologer-scoped)
  static const astroConsultations = '/astro/consultations';
  static const astroConsultationRequests = '/astro/consultations/requests';
  static String astroConsultation(String id) => '/astro/consultations/$id';
  static String astroAccept(String id) => '/astro/consultations/$id/accept';
  static String astroReject(String id) => '/astro/consultations/$id/reject';
  static String astroEnd(String id) => '/astro/consultations/$id/end';
  static String astroConsultationChart(String id) =>
      '/astro/consultations/$id/chart';
  // in-session kundali surface (mirrors the customer /app/birth-profiles/{id}/{sub})
  static String astroConsultationKundali(String id, String sub) =>
      '/astro/consultations/$id/$sub';

  // predictions work queue
  static const predictionsQueue = '/astro/predictions/queue';
  static String prediction(String id) => '/astro/predictions/$id';
  static String predictionClaim(String id) => '/astro/predictions/$id/claim';
  static String predictionDeliver(String id) =>
      '/astro/predictions/$id/deliver';
  static String predictionRelease(String id) =>
      '/astro/predictions/$id/release';

  // in-session chat / call — shared mount, participant-checked
  static String messages(String id) => '/consultations/$id/messages';
  static String messagesRead(String id) => '/consultations/$id/messages/read';
  static String messagesDelivered(String id) =>
      '/consultations/$id/messages/delivered';
  static String messageTranslate(String id, int seq) =>
      '/consultations/$id/messages/$seq/translate';
  static String messageReport(String id, int seq) =>
      '/consultations/$id/messages/$seq/report';
  static String typing(String id) => '/consultations/$id/typing';
  static String chatPresence(String id) => '/consultations/$id/presence';
  static String attachments(String id) => '/consultations/$id/attachments';
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
  static const astroReviews = '/astro/reviews';
  static String astroReviewReply(String id) => '/astro/reviews/$id/reply';
  static const astroGiftsReceived = '/astro/gifts/received';
}
