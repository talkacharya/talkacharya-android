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

  /// The astrologer's own profile, as a customer sees it.
  static const profilePublic = '/profile/public';
  static const profileRates = '/profile/rates';
  static const profileWorkingHours = '/profile/working-hours';
  static const profileReviews = '/profile/reviews';
  static const profileKyc = '/profile/kyc';
  static const profileSound = '/profile/sound';
  static const callSetup = '/profile/calls';

  /// The ringing screen; the push's data goes in `extra`.
  static const incomingCall = '/incoming-call';
  static const callSetupTested = '/profile/calls?tested=1';
  static const profileFeatured = '/profile/featured';

  /// Prediction work queue (full-screen).
  static const predictions = '/predictions';

  /// The banded scorecard, and the returning customers gone quiet.
  static const performance = '/performance';
  static const winBack = '/performance/win-back';

  /// Every tool, grouped (Home shows only the first eight).
  static const tools = '/tools';
  static const announcements = '/announcements';
  static const training = '/training';
  static const favourites = '/favourites';
  static const community = '/community';
  static const referral = '/referral';
  static const offers = '/offers';
  static const gallery = '/gallery';
  static const feedback = '/feedback';
  static const quickReplies = '/quick-replies';
  static const calendar = '/calendar';

  /// Charts cast outside any consultation, and Guna Milan between them.
  static const clientCharts = '/client-charts';
  static const clientChartNew = '/client-charts/new';
  static String clientKundali(String id) => '/client-charts/$id/kundali';
  static const matchmaking = '/matchmaking';

  /// Poojas open for booking, and those booked on the astrologer's advice.
  static const poojaCalendar = '/poojas';
  static const poojaBookings = '/poojas/bookings';

  static const waitlist = '/waitlist';
  static const callHistory = '/call-history';

  /// Reports customers raised on the astrologer's sessions.
  static const reports = '/reports';
  static String reportDetail(String id) => '/reports/$id';
  static const remedies = '/remedies';

  /// [consultation] presets the customer when opened from their session.
  static String suggestRemedy({String? consultation, String? name}) {
    final q = <String, String>{'consultation': ?consultation, 'name': ?name};
    return Uri(
      path: '/remedies/suggest',
      queryParameters: q.isEmpty ? null : q,
    ).toString();
  }

  /// Free advice (a mantra, a fast…), as against a store product.
  static String adviseRemedy({String? consultation, String? name}) {
    final q = <String, String>{'consultation': ?consultation, 'name': ?name};
    return Uri(
      path: '/remedies/advise',
      queryParameters: q.isEmpty ? null : q,
    ).toString();
  }

  /// Going live (full-screen; the broadcast room is pushed from here).
  static const goLive = '/go-live';
}
