/// Route paths for the astrologer app. Keep in sync with `deep_link_parser.dart`.
class Routes {
  const Routes._();

  static const splash = '/';
  static const login = '/login';
  static const onboarding = '/onboarding';
  static const notifications = '/notifications';

  // bottom-nav branch roots
  static const home = '/home';
  static const requests = '/requests';
  static const earnings = '/earnings';
  static const chats = '/chats';
  static const profile = '/profile';

  static const branchRoots = [home, requests, earnings, chats, profile];

  // full-screen
  static String chatRoom(String id) => '/chats/$id';
  static String requestDetail(String id) => '/requests/$id';
  static String payout(String id) => '/earnings/payouts/$id';

  /// [profile] opens one of the people the customer shared (else the primary).
  static String consultationKundali(String id, {String? profile}) =>
      '/consultations/$id/kundali${profile == null ? '' : '?profile=$profile'}';

  /// Guna Milan report the customer shared.
  static String consultationMatch(String id, String matchId) =>
      '/consultations/$id/matches/$matchId';

  // profile sub-pages
  static const profileEdit = '/profile/edit';
  static const profileRates = '/profile/rates';
  static const profileWorkingHours = '/profile/working-hours';
  static const profileReviews = '/profile/reviews';
  static const profileKyc = '/profile/kyc';
  static const profileSound = '/profile/sound';
  static const profileFeatured = '/profile/featured';

  /// Prediction work queue (full-screen).
  static const predictions = '/predictions';

  /// Going live (full-screen; the broadcast room is pushed from here).
  static const goLive = '/go-live';
}
