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
  static String consultationKundali(String id) => '/consultations/$id/kundali';

  // profile sub-pages
  static const profileEdit = '/profile/edit';
  static const profileRates = '/profile/rates';
  static const profileWorkingHours = '/profile/working-hours';
  static const profileReviews = '/profile/reviews';
  static const profileKyc = '/profile/kyc';
  static const profileFeatured = '/profile/featured';
}
