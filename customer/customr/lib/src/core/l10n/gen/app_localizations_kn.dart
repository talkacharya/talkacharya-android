// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Kannada (`kn`).
class AppLocalizationsKn extends AppLocalizations {
  AppLocalizationsKn([String locale = 'kn']) : super(locale);

  @override
  String get appName => 'TalkAcharya';

  @override
  String get commonOk => 'ಸರಿ';

  @override
  String get commonCancel => 'ರದ್ದುಮಾಡಿ';

  @override
  String get commonDone => 'ಮುಗಿದಿದೆ';

  @override
  String get commonNext => 'ಮುಂದೆ';

  @override
  String get commonBack => 'ಹಿಂದಕ್ಕೆ';

  @override
  String get commonRetry => 'ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ';

  @override
  String get commonSave => 'ಉಳಿಸಿ';

  @override
  String get commonEdit => 'ತಿದ್ದಿ';

  @override
  String get commonDelete => 'ಅಳಿಸಿ';

  @override
  String get commonClose => 'ಮುಚ್ಚಿ';

  @override
  String get commonContinue => 'ಮುಂದುವರಿಸಿ';

  @override
  String get commonConfirm => 'ಖಚಿತಪಡಿಸಿ';

  @override
  String get commonSeeAll => 'ಎಲ್ಲವನ್ನೂ ನೋಡಿ';

  @override
  String get commonViewAll => 'ಎಲ್ಲವನ್ನೂ ನೋಡಿ';

  @override
  String get commonShare => 'ಹಂಚಿಕೊಳ್ಳಿ';

  @override
  String get commonCopy => 'ನಕಲಿಸಿ';

  @override
  String get commonCopied => 'ನಕಲಿಸಲಾಗಿದೆ';

  @override
  String get commonApply => 'ಅನ್ವಯಿಸಿ';

  @override
  String get commonSearch => 'ಹುಡುಕಿ';

  @override
  String get commonYes => 'ಹೌದು';

  @override
  String get commonNo => 'ಇಲ್ಲ';

  @override
  String get commonLoading => 'ಲೋಡ್ ಆಗುತ್ತಿದೆ…';

  @override
  String get commonSomethingWentWrong => 'ಏನೋ ತಪ್ಪಾಗಿದೆ';

  @override
  String get commonCheckConnection =>
      'ನಿಮ್ಮ ಇಂಟರ್ನೆಟ್ ಸಂಪರ್ಕವನ್ನು ಪರೀಕ್ಷಿಸಿ ಮತ್ತು ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ';

  @override
  String get commonComingSoon => 'ಶೀಘ್ರದಲ್ಲೇ ಬರಲಿದೆ';

  @override
  String get commonToday => 'ಇಂದು';

  @override
  String get commonYesterday => 'ನಿನ್ನೆ';

  @override
  String commonMinutesShort(int count) {
    return '$count ನಿಮಿಷ';
  }

  @override
  String get commonOffline => 'ನೀವು ಆಫ್‌ಲೈನ್‌ನಲ್ಲಿದ್ದೀರಿ';

  @override
  String get navHome => 'ಮುಖಪುಟ';

  @override
  String get navAstrologers => 'ಜ್ಯೋತಿಷಿಗಳು';

  @override
  String get navLive => 'ಲೈವ್';

  @override
  String get navWallet => 'ವ್ಯಾಲೆಟ್';

  @override
  String get navProfile => 'ಪ್ರೊಫೈಲ್';

  @override
  String get authWelcomeTitle => 'ನಂಬಿಕಸ್ತ ಜ್ಯೋತಿಷಿಗಳೊಂದಿಗೆ ಮಾತನಾಡಿ';

  @override
  String get authWelcomeSubtitle =>
      'ಪ್ರೀತಿ, ವೃತ್ತಿಜೀವನ, ಹಣ ಮತ್ತು ಹೆಚ್ಚಿನ ಮಾರ್ಗದರ್ಶನಕ್ಕಾಗಿ ಚಾಟ್ ಮಾಡಿ ಅಥವಾ ಕರೆ ಮಾಡಿ';

  @override
  String get authPhoneTitle => 'ನಿಮ್ಮ ಮೊಬೈಲ್ ಸಂಖ್ಯೆಯನ್ನು ನಮೂದಿಸಿ';

  @override
  String get authPhoneSubtitle =>
      'ನಿಮ್ಮ ಮೊಬೈಲ್ ಸಂಖ್ಯೆಯನ್ನು ನಮೂದಿಸಿ ಮತ್ತು ನಾವು ನಿಮಗೆ ಒಂದು ಬಾರಿ ಬಳಸುವ ಕೋಡ್ ಕಳುಹಿಸುತ್ತೇವೆ.';

  @override
  String authOtpSubtitle(String phone) {
    return 'ನಾವು $phone ಗೆ 6-ಅಂಕಿಯ ಕೋಡ್ ಕಳುಹಿಸಿದ್ದೇವೆ.';
  }

  @override
  String authTestModeCode(String code) {
    return 'ಟೆಸ್ಟ್ ಮೋಡ್ — ನಿಮ್ಮ ಕೋಡ್ $code';
  }

  @override
  String get authPhoneHint => 'ಮೊಬೈಲ್ ಸಂಖ್ಯೆ';

  @override
  String get authPhoneHelper =>
      'ನಾವು SMS ಮೂಲಕ ಒಂದು ಬಾರಿ ಬಳಸುವ ಕೋಡ್ ಕಳುಹಿಸುತ್ತೇವೆ';

  @override
  String get authGetOtp => 'OTP ಪಡೆಯಿರಿ';

  @override
  String get authOtpTitle => '6-ಅಂಕಿಯ ಕೋಡ್ ನಮೂದಿಸಿ';

  @override
  String authOtpSentTo(String phone) {
    return '$phone ಗೆ ಕಳುಹಿಸಲಾಗಿದೆ';
  }

  @override
  String get authOtpResend => 'ಕೋಡ್ ಮತ್ತೆ ಕಳುಹಿಸಿ';

  @override
  String authOtpResendIn(int seconds) {
    return '$seconds ಸೆಕೆಂಡುಗಳಲ್ಲಿ ಮತ್ತೆ ಕಳುಹಿಸಿ';
  }

  @override
  String get authVerify => 'ಪರಿಶೀಲಿಸಿ';

  @override
  String get authChangeNumber => 'ಸಂಖ್ಯೆ ಬದಲಾಯಿಸಿ';

  @override
  String get authInvalidPhone => 'ಮಾನ್ಯವಾದ ಮೊಬೈಲ್ ಸಂಖ್ಯೆಯನ್ನು ನಮೂದಿಸಿ';

  @override
  String get authInvalidOtp => '6-ಅಂಕಿಯ ಕೋಡ್ ನಮೂದಿಸಿ';

  @override
  String get authWrongApp => 'ಈ ಸಂಖ್ಯೆಯು ಜ್ಯೋತಿಷಿ ಆಪ್‌ಗಾಗಿ ನೋಂದಾಯಿಸಲಾಗಿದೆ';

  @override
  String authDevCode(String code) {
    return 'ದೇವ್ ಕೋಡ್: $code';
  }

  @override
  String get authTermsNotice =>
      'ಮುಂದುವರಿಯುವ ಮೂಲಕ ನೀವು ನಮ್ಮ ನಿಯಮಗಳು ಮತ್ತು ಗೌಪ್ಯತಾ ನೀತಿಯನ್ನು ಒಪ್ಪುತ್ತೀರಿ';

  @override
  String get authLogout => 'ಲೋಗ್ ಔಟ್';

  @override
  String get authLogoutConfirm =>
      'TalkAcharya ದಿಂದ ಲೋಗ್ ಔಟ್ ಮಾಡಬೇಕೆ? ನೀವು ಮತ್ತೆ ಸೈನ್ ಇನ್ ಮಾಡಬೇಕಾಗುತ್ತದೆ.';

  @override
  String homeGreeting(String name) {
    return 'ನಮಸ್ತೆ, $name';
  }

  @override
  String get homeGuidanceTagline => 'ನಿಮಗೆ ಅಗತ್ಯವಿರುವಾಗ ಮಾರ್ಗದರ್ಶನ';

  @override
  String get homeGreetingFallbackName => 'ಅಲ್ಲಿ';

  @override
  String get walletAddShort => 'ಸೇರಿಸಿ';

  @override
  String get homeChatNow => 'ಈಗಲೇ ಚಾಟ್ ಮಾಡಿ';

  @override
  String get homeCallNow => 'ಈಗಲೇ ಕರೆ ಮಾಡಿ';

  @override
  String homeFromPerMin(String price) {
    return '$price/ನಿಮಿಷದಿಂದ';
  }

  @override
  String homeOnlineCount(int count) {
    return '$count ಜನರು ಆನ್‌ಲೈನ್‌ನಲ್ಲಿದ್ದಾರೆ';
  }

  @override
  String get homeOnlineNow => 'ಈಗ ಆನ್‌ಲೈನ್‌ನಲ್ಲಿ';

  @override
  String get homeTalkToAstrologer => 'ಜ್ಯೋತಿಷಿಯೊಂದಿಗೆ ಮಾತನಾಡಿ';

  @override
  String get homeLiveNow => 'ಈಗ ಲೈವ್';

  @override
  String get homeWhatsOnYourMind => 'ನಿಮ್ಮ ಮನಸ್ಸಿನಲ್ಲಿ ಏನಿದೆ?';

  @override
  String get homeTodaysHoroscope => 'ಇಂದಿನ ರಾಶಿಫಲ';

  @override
  String get homeChooseYourSign => 'ನಿಮ್ಮ ರಾಶಿಯನ್ನು ಆರಿಸಿ';

  @override
  String get homeReadMore => 'ಹೆಚ್ಚು ಓದಿ';

  @override
  String get homeShowLess => 'ಕಡಿಮೆ ತೋರಿಸಿ';

  @override
  String homeLuckToday(String rating) {
    return 'ಇಂದಿನ ಅದೃಷ್ಟ · $rating';
  }

  @override
  String get homeTodaysPanchang => 'ಇಂದಿನ ಪಂಚಾಂಗ';

  @override
  String get homePanchangAddProfile =>
      'ನಿಮ್ಮ ಸ್ಥಳಕ್ಕೆ ಅನುಗುಣವಾಗಿ ಪಂಚಾಂಗ ಪಡೆಯಲು ಜನ್ಮ ವಿವರಗಳನ್ನು ಸೇರಿಸಿ';

  @override
  String get homeFreeTools => 'ಉಚಿತ ಪರಿಕರಗಳು';

  @override
  String get homeTalkAgain => 'ಮತ್ತೆ ಮಾತನಾಡಿ';

  @override
  String get homeAddMoneyGetBonus => 'ಹಣ ಸೇರಿಸಿ, ಬೋನಸ್ ಪಡೆಯಿರಿ';

  @override
  String get homeReferAFriend => 'ಸ್ನೇಹಿತರನ್ನು ಶಿಫಾರಸು ಮಾಡಿ, ಇಬ್ಬರೂ ಸಂಪಾದಿಸಿ';

  @override
  String get homeReferShort =>
      'ನಿಮ್ಮ ಕೋಡ್ ಹಂಚಿಕೊಳ್ಳಿ — ನಿಮ್ಮಿಬ್ಬರಿಗೂ ವ್ಯಾಲೆಟ್ ಕ್ರೆಡಿಟ್ ಸಿಗುತ್ತದೆ';

  @override
  String homeReferYourCode(String code) {
    return 'ನಿಮ್ಮ ಕೋಡ್: $code';
  }

  @override
  String get homeInvite => 'ಆಹ್ವಾನಿಸಿ';

  @override
  String homeResumeInProgress(String channel) {
    return '$channel · ಪ್ರಗತಿಯಲ್ಲಿದೆ';
  }

  @override
  String homeResumePaused(String channel) {
    return '$channel · ವಿರಾಮಗೊಳಿಸಲಾಗಿದೆ';
  }

  @override
  String get homeResume => 'ಪುನರಾರಂಭಿಸಿ';

  @override
  String get homeTrustVerified =>
      'ಪ್ರತಿ ಜ್ಯೋತಿಷಿಯು ಲೈವ್ ಹೋಗುವ ಮೊದಲು ಐಡಿ-ಪರಿಶೀಲನೆಗೆ ಒಳಗಾಗುತ್ತಾರೆ';

  @override
  String get homeTrustPrivate => '100% ಖಾಸಗಿ ಮತ್ತು ಗೌಪ್ಯ ಸಮಾಲೋಚನೆಗಳು';

  @override
  String get homeTrustVolume => 'ಪ್ರತಿ ವಾರ ಸಾವಿರಾರು ಸಮಾಲೋಚನೆಗಳು';

  @override
  String get homeCouldntLoadAstrologers =>
      'ಜ್ಯೋತಿಷಿಗಳನ್ನು ಲೋಡ್ ಮಾಡಲು ಸಾಧ್ಯವಾಗಲಿಲ್ಲ';

  @override
  String get homeCouldntLoadReading => 'ಇಂದಿನ ರಾಶಿಫಲ ಪಡೆಯಲು ಸಾಧ್ಯವಾಗಲಿಲ್ಲ';

  @override
  String get homeCouldntLoadPanchang => 'ಪಂಚಾಂಗ ಲೋಡ್ ಮಾಡಲು ಸಾಧ್ಯವಾಗಲಿಲ್ಲ';

  @override
  String get homeNoAstrologersFilter =>
      'ಈ ಫಿಲ್ಟರ್‌ಗೆ ಹೊಂದಿಕೆಯಾಗುವ ಯಾವುದೇ ಜ್ಯೋತಿಷಿಗಳು ಈಗ ಲಭ್ಯವಿಲ್ಲ';

  @override
  String get concernLove => 'ಪ್ರೀತಿ';

  @override
  String get concernMarriage => 'ಮದುವೆ';

  @override
  String get concernCareer => 'ವೃತ್ತಿಜೀವನ';

  @override
  String get concernFinance => 'ಹಣಕಾಸು';

  @override
  String get concernHealth => 'ಆರೋಗ್ಯ';

  @override
  String get concernEducation => 'ಶಿಕ್ಷಣ';

  @override
  String get concernBusiness => 'ವ್ಯವಹಾರ';

  @override
  String get concernLegal => 'ಕಾನೂನು';

  @override
  String get channelChat => 'ಚಾಟ್';

  @override
  String get channelCall => 'ಕರೆ';

  @override
  String get channelVoice => 'ವಾಯ್ಸ್ ಕರೆ';

  @override
  String get channelVideo => 'ವಿಡಿಯೋ ಕರೆ';

  @override
  String get channelAll => 'ಎಲ್ಲಾ';

  @override
  String get astroFilterAll => 'ಎಲ್ಲಾ';

  @override
  String get astroSortRecommended => 'ಶಿಫಾರಸು ಮಾಡಿದ';

  @override
  String get astroSortTopRated => 'ಉನ್ನತ ಶ್ರೇಣಿಯ';

  @override
  String get astroSortExperienced => 'ಹೆಚ್ಚು ಅನುಭವಿ';

  @override
  String get astroSortConsulted => 'ಹೆಚ್ಚು ಸಮಾಲೋಚಿಸಿದ';

  @override
  String get astroSortNew => 'ಇಲ್ಲಿ ಹೊಸಬರು';

  @override
  String get astroOnline => 'ಆನ್‌ಲೈನ್';

  @override
  String get astroBusy => 'ಕಾರ್ಯನಿರತ';

  @override
  String get astroNotifyMe => 'ನನಗೆ ತಿಳಿಸಿ';

  @override
  String astroWaitMinutes(int count) {
    return '~$count ನಿಮಿಷ ಕಾಯುವಿಕೆ';
  }

  @override
  String astroPerMinute(String price) {
    return '$price/ನಿಮಿಷ';
  }

  @override
  String astroYearsExp(int count) {
    return '$count ವರ್ಷಗಳ ಅನುಭವ';
  }

  @override
  String get astroRatingNew => 'ಹೊಸ';

  @override
  String astroSessionsCount(String count) {
    return '$count ಸೆಷನ್‌ಗಳು';
  }

  @override
  String get astroSearchHint => 'ಹೆಸರು, ಕೌಶಲ ಅಥವಾ ಭಾಷೆಯ ಮೂಲಕ ಹುಡುಕಿ';

  @override
  String get astroNoneFound => 'ಯಾವುದೇ ಜ್ಯೋತಿಷಿಗಳು ಕಂಡುಬಂದಿಲ್ಲ';

  @override
  String get astroNoneFoundHint =>
      'ಫಿಲ್ಟರ್ ತೆಗೆದುಹಾಕಲು ಅಥವಾ ಬೇರೆ ಯಾವುದನ್ನಾದರೂ ಹುಡುಕಲು ಪ್ರಯತ್ನಿಸಿ';

  @override
  String get astroThatsEveryone => 'ಸದ್ಯಕ್ಕೆ ಇಷ್ಟೇ';

  @override
  String get astroRateOnRequest => 'ವಿನಂತಿಯ ಮೇರೆಗೆ ದರ';

  @override
  String get astroCouldntLoad => 'ಜ್ಯೋತಿಷಿಗಳನ್ನು ಲೋಡ್ ಮಾಡಲು ಸಾಧ್ಯವಾಗಲಿಲ್ಲ.';

  @override
  String get astroSortBy => 'ವಿಂಗಡಿಸಿ';

  @override
  String get astroLoadMoreFailed => 'ಇನ್ನಷ್ಟು ಲೋಡ್ ಮಾಡಲು ಸಾಧ್ಯವಾಗಲಿಲ್ಲ.';

  @override
  String get astroDefaultSkill => 'ವೈದಿಕ ಜ್ಯೋತಿಷ್ಯ';

  @override
  String astroYears(int count) {
    return '$count ವರ್ಷಗಳು';
  }

  @override
  String astroSessions(String count) {
    return '$count ಅವಧಿಗಳು';
  }

  @override
  String get astroChat => 'ಚಾಟ್ ಮಾಡಿ';

  @override
  String get astroCall => 'ಕರೆ ಮಾಡಿ';

  @override
  String get astroVideo => 'ವೀಡಿಯೊ';

  @override
  String get astroProfileTitle => 'ಜ್ಯೋತಿಷಿ';

  @override
  String get astroExpertiseTitle => 'Expertise';

  @override
  String get astroAboutTitle => 'ನಮ್ಮ ಬಗ್ಗೆ';

  @override
  String get astroRatesTitle => 'ಸಮಾಲೋಚನೆ ದರಗಳು';

  @override
  String astroReviewsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count reviews',
      one: '1 review',
      zero: 'No reviews yet',
    );
    return '$_temp0';
  }

  @override
  String get astroStatRating => 'ರೇಟಿಂಗ್';

  @override
  String get astroStatExperience => 'ಅನುಭವ';

  @override
  String get astroStatSessions => 'ಅವಧಿಗಳು';

  @override
  String get astroStatRepeatClients => 'ಪುನರಾವರ್ತಿತ ಕ್ಲೈಂಟ್‌ಗಳು';

  @override
  String astroSpeaks(String languages) {
    return '$languages ಮಾತನಾಡುತ್ತಾರೆ';
  }

  @override
  String astroRepliesIn(String time) {
    return '~ $time ಗಳಲ್ಲಿ ಪ್ರತ್ಯುತ್ತರಗಳು';
  }

  @override
  String get astroOnlineNow => 'ಈಗ ಆನ್‌ಲೈನ್‌ನಲ್ಲಿ';

  @override
  String get astroOfflineTitle => 'ಪ್ರಸ್ತುತ ಆಫ್‌ಲೈನ್‌ನಲ್ಲಿದ್ದಾರೆ';

  @override
  String get astroNotifyWhenOnline => 'ಆನ್‌ಲೈನ್‌ನಲ್ಲಿರುವಾಗ ನನಗೆ ಸೂಚಿಸಿ';

  @override
  String get astroReadMore => 'ಮತ್ತಷ್ಟು ಓದು';

  @override
  String get astroReadLess => 'ಕಡಿಮೆ ತೋರಿಸಿ';

  @override
  String get astroCouldntLoadOne => 'ಈ ಜ್ಯೋತಿಷಿಯನ್ನು ಲೋಡ್ ಮಾಡಲು ಸಾಧ್ಯವಾಗಲಿಲ್ಲ.';

  @override
  String get astroCallsComingSoon =>
      'ಧ್ವನಿ ಮತ್ತು ವೀಡಿಯೊ ಕರೆಗಳು ಶೀಘ್ರದಲ್ಲೇ ಬರಲಿವೆ.';

  @override
  String get astroTrustLine =>
      'ಐಡಿ-ಪರಿಶೀಲಿಸಲಾಗಿದೆ · ಖಾಸಗಿ ಮತ್ತು ಗೌಪ್ಯ · ನಿಮಿಷಕ್ಕೆ ಪಾವತಿಸಿ';

  @override
  String get walletTitle => 'ವ್ಯಾಲೆಟ್';

  @override
  String get walletAvailableBalance => 'ಲಭ್ಯವಿರುವ ಬ್ಯಾಲೆನ್ಸ್';

  @override
  String walletOnHold(String amount) {
    return '$amount ತಡೆಹಿಡಿಯಲಾಗಿದೆ';
  }

  @override
  String walletOnHoldReason(String amount) {
    return '$amount ತಡೆಹಿಡಿಯಲಾಗಿದೆ · ಕರೆ ನಡೆಯುತ್ತಿದೆ';
  }

  @override
  String get walletAddMoney => 'ಹಣ ಸೇರಿಸಿ';

  @override
  String get walletRecentActivity => 'ಇತ್ತೀಚಿನ ಚಟುವಟಿಕೆ';

  @override
  String get walletTransactions => 'ವಹಿವಾಟುಗಳು';

  @override
  String get walletHowItWorksTitle => 'ವ್ಯಾಲೆಟ್ ಹೇಗೆ ಕೆಲಸ ಮಾಡುತ್ತದೆ';

  @override
  String get walletHowItWorksBody =>
      'ವ್ಯಾಲೆಟ್ ಬ್ಯಾಲೆನ್ಸ್ ಅನ್ನು ಸಮಾಲೋಚನೆಗಳಿಗೆ ಮಾತ್ರ ಬಳಸಲಾಗುತ್ತದೆ ಮತ್ತು ಇದು ಎಂದಿಗೂ ಅವಧಿ ಮೀರುವುದಿಲ್ಲ. ಬಳಸದ ಬ್ಯಾಲೆನ್ಸ್ ಮರುಪಾವತಿಗೆ ಅರ್ಹವಾಗಿದೆ — ನಮ್ಮ ಮರುಪಾವತಿ ನೀತಿಯನ್ನು ನೋಡಿ.';

  @override
  String get walletRefundPolicy => 'ಮರುಪಾವತಿ ನೀತಿ';

  @override
  String get walletHaveCoupon => 'ಕೂಪನ್ ಕೋಡ್ ಇದೆಯೇ?';

  @override
  String get walletCouponHint => 'ಕೋಡ್ ನಮೂದಿಸಿ';

  @override
  String walletCouponApplied(String amount) {
    return '$amount ನಿಮ್ಮ ವ್ಯಾಲೆಟ್‌ಗೆ ಸೇರಿಸಲಾಗಿದೆ';
  }

  @override
  String get walletSecuredBy =>
      'Razorpay · UPI · ಕಾರ್ಡ್‌ಗಳು · ನೆಟ್‌ಬ್ಯಾಂಕಿಂಗ್ ಮೂಲಕ ಸುರಕ್ಷಿತವಾಗಿದೆ';

  @override
  String get walletGstInvoices => 'GST ಇನ್‌ವಾಯ್ಸ್‌ಗಳು';

  @override
  String get walletInvoicesSubtitle =>
      'ನಿಮ್ಮ ರೀಚಾರ್ಜ್‌ಗಳ ಇನ್‌ವಾಯ್ಸ್‌ಗಳು ಮತ್ತು ರಶೀದಿಗಳು';

  @override
  String get walletNoTransactions => 'ಇನ್ನೂ ಯಾವುದೇ ವಹಿವಾಟುಗಳಿಲ್ಲ';

  @override
  String get walletNoTransactionsHint =>
      'ಪ್ರಾರಂಭಿಸಲು ನಿಮ್ಮ ವ್ಯಾಲೆಟ್‌ಗೆ ಹಣವನ್ನು ಸೇರಿಸಿ';

  @override
  String walletBalanceAfter(String amount) {
    return 'ಬ್ಯಾಲೆನ್ಸ್ $amount';
  }

  @override
  String get walletFilterAll => 'ಎಲ್ಲಾ';

  @override
  String get walletFilterRecharge => 'ಸೇರಿಸಲಾಗಿದೆ';

  @override
  String get walletFilterConsultation => 'ಸಮಾಲೋಚನೆಗಳು';

  @override
  String get walletFilterRefund => 'ಮರುಪಾವತಿಗಳು';

  @override
  String get walletFilterBonus => 'ಬೋನಸ್';

  @override
  String get kindRecharge => 'ಹಣ ಸೇರಿಸಲಾಗಿದೆ';

  @override
  String get kindConsultationCharge => 'ಸಮಾಲೋಚನೆ';

  @override
  String get kindConsultationRefund => 'ಮರುಪಾವತಿ';

  @override
  String get kindPromoCredit => 'ಪ್ರೋಮೊ ಕ್ರೆಡಿಟ್';

  @override
  String get kindCouponDiscount => 'ಕೂಪನ್ ರಿಯಾಯಿತಿ';

  @override
  String get kindSignupBonus => 'ಸೈನ್ ಅಪ್ ಬೋನಸ್';

  @override
  String get kindReferralBonus => 'ರೆಫರಲ್ ಬೋನಸ್';

  @override
  String get kindAdjustment => 'ಹೊಂದಾಣಿಕೆ';

  @override
  String get kindGiftSpend => 'ಉಡುಗೊರೆ ಕಳುಹಿಸಲಾಗಿದೆ';

  @override
  String get kindHold => 'ಕರೆಗಾಗಿ ಕಾಯ್ದಿರಿಸಲಾಗಿದೆ';

  @override
  String get kindChargeback => 'ಚಾರ್ಜ್‌ಬ್ಯಾಕ್';

  @override
  String get rechargeChooseAmount => 'ವ್ಯಾಲೆಟ್‌ಗೆ ಹಣ ಸೇರಿಸಿ';

  @override
  String get rechargeAmountLabel => 'ಮೊತ್ತ';

  @override
  String rechargePayAmount(String amount) {
    return '$amount ಪಾವತಿಸಿ';
  }

  @override
  String get rechargeAddCoupon => 'ಕೂಪನ್ ಕೋಡ್ ಸೇರಿಸಿ';

  @override
  String rechargeBonusBadge(String amount) {
    return '+$amount';
  }

  @override
  String get rechargeStarterPack => 'ಸ್ಟಾರ್ಟರ್';

  @override
  String rechargeMinAmount(String amount) {
    return 'ಕನಿಷ್ಠ $amount';
  }

  @override
  String rechargeMaxAmount(String amount) {
    return 'ಗರಿಷ್ಠ $amount';
  }

  @override
  String get rechargeOpeningCheckout => 'ಸುರಕ್ಷಿತ ಚೆಕ್‌ಔಟ್ ತೆರೆಯಲಾಗುತ್ತಿದೆ…';

  @override
  String get rechargeConfirming =>
      'ಪಾವತಿ ಸ್ವೀಕರಿಸಲಾಗಿದೆ — ನಿಮ್ಮ ಬ್ಯಾಲೆನ್ಸ್ ಅಪ್‌ಡೇಟ್ ಮಾಡಲಾಗುತ್ತಿದೆ…';

  @override
  String rechargeSuccessTitle(String amount) {
    return '$amount ಸೇರಿಸಲಾಗಿದೆ';
  }

  @override
  String rechargeNewBalance(String amount) {
    return 'ಹೊಸ ಬ್ಯಾಲೆನ್ಸ್ $amount';
  }

  @override
  String get rechargeViewTransaction => 'ವಹಿವಾಟು ನೋಡಿ';

  @override
  String get rechargeFailedTitle => 'ಪಾವತಿ ವಿಫಲವಾಗಿದೆ';

  @override
  String get rechargeNotCharged => 'ನಿಮಗೆ ಯಾವುದೇ ಶುಲ್ಕ ವಿಧಿಸಲಾಗಿಲ್ಲ.';

  @override
  String get rechargeAutoRefund =>
      'ಯಾವುದೇ ಮೊತ್ತ ಕಡಿತವಾಗಿದ್ದರೆ, ಅದು 3-5 ಕೆಲಸದ ದಿನಗಳಲ್ಲಿ ಮರುಪಾವತಿಯಾಗುತ್ತದೆ.';

  @override
  String get rechargeTryAgain => 'ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ';

  @override
  String get rechargeChangeAmount => 'ಮೊತ್ತ ಬದಲಾಯಿಸಿ';

  @override
  String get rechargeCreditedSoon =>
      'ಪಾವತಿ ಸ್ವೀಕರಿಸಲಾಗಿದೆ. ನಾವು ಶೀಘ್ರದಲ್ಲೇ ಅದನ್ನು ನಿಮ್ಮ ವ್ಯಾಲೆಟ್‌ಗೆ ಜಮಾ ಮಾಡುತ್ತೇವೆ.';

  @override
  String rechargeOfferAutoApplied(String amount, String bonus) {
    return '$amount ಸೇರಿಸಿ, $bonus ಹೆಚ್ಚುವರಿ ಪಡೆಯಿರಿ — ಸ್ವಯಂ-ಅನ್ವಯಿಸಲಾಗಿದೆ';
  }

  @override
  String get profileTitle => 'ಪ್ರೊಫೈಲ್';

  @override
  String get profileEditProfile => 'ಪ್ರೊಫೈಲ್ ತಿದ್ದಿ';

  @override
  String profilePhoneMasked(String last4) {
    return '+91 ●●●●● $last4';
  }

  @override
  String get profileCompleteAddEmail =>
      'ನಿಮ್ಮ ಪ್ರೊಫೈಲ್ ಪೂರ್ಣಗೊಳಿಸಲು ಇಮೇಲ್ ಸೇರಿಸಿ';

  @override
  String get profileCompleteAddBirth =>
      'ವೈಯಕ್ತಿಕ ರಾಶಿಫಲಗಳಿಗಾಗಿ ನಿಮ್ಮ ಜನ್ಮ ವಿವರಗಳನ್ನು ಸೇರಿಸಿ';

  @override
  String get profileRoleCustomer => 'ಗ್ರಾಹಕ';

  @override
  String get profileWallet => 'ವ್ಯಾಲೆಟ್';

  @override
  String get profileBirthProfiles => 'ಜನ್ಮ ವಿವರಗಳು';

  @override
  String profileBirthProfilesCount(int count) {
    return '$count ಚಾರ್ಟ್‌ಗಳು';
  }

  @override
  String get profileGroupAccount => 'ಖಾತೆ';

  @override
  String get profileGroupMoney => 'ಹಣ';

  @override
  String get profileGroupPreferences => 'ಆದ್ಯತೆಗಳು';

  @override
  String get profileGroupSupport => 'ಬೆಂಬಲ';

  @override
  String get profileGroupLegal => 'ಕಾನೂನು';

  @override
  String get profileNotifications => 'ಅಧಿಸೂಚನೆಗಳು';

  @override
  String get profileNotificationPrefs => 'ಅಧಿಸೂಚನೆ ಆದ್ಯತೆಗಳು';

  @override
  String get profileHapticFeedback => 'ಸ್ಪರ್ಶ ಪ್ರತಿಕ್ರಿಯೆ';

  @override
  String get profileHapticFeedbackDesc => 'ಬಟನ್‌ಗಳು ಮತ್ತು ಸಂವಹನಗಳಲ್ಲಿ ಕಂಪಿಸಿ';

  @override
  String get profileWalletAndTransactions => 'ವ್ಯಾಲೆಟ್ ಮತ್ತು ವಹಿವಾಟುಗಳು';

  @override
  String get profileOrders => 'Orders';

  @override
  String profileOrdersUnread(int count) {
    return '$count new';
  }

  @override
  String get profileReferAndEarn => 'ರೆಫರ್ ಮಾಡಿ ಮತ್ತು ಸಂಪಾದಿಸಿ';

  @override
  String get profileLanguage => 'ಭಾಷೆ';

  @override
  String get profileCurrency => 'ಕರೆನ್ಸಿ';

  @override
  String get profileHelpCentre => 'ಸಹಾಯ ಕೇಂದ್ರ';

  @override
  String get profileContactWhatsapp => 'WhatsApp ನಲ್ಲಿ ನಮ್ಮನ್ನು ಸಂಪರ್ಕಿಸಿ';

  @override
  String get profileRateApp => 'TalkAcharya ರೇಟ್ ಮಾಡಿ';

  @override
  String get profileShareApp => 'ಆಪ್ ಹಂಚಿಕೊಳ್ಳಿ';

  @override
  String profileShareMessage(String link) {
    return 'ನಾನು ಜ್ಯೋತಿಷಿಗಳೊಂದಿಗೆ ಮಾತನಾಡಲು TalkAcharya ಬಳಸುತ್ತಿದ್ದೇನೆ. ನೀವೂ ಪ್ರಯತ್ನಿಸಿ: $link';
  }

  @override
  String get profileTerms => 'ಸೇವಾ ನಿಯಮಗಳು';

  @override
  String get profilePrivacy => 'ಗೌಪ್ಯತಾ ನೀತಿ';

  @override
  String get profileLicenses => 'ಓಪನ್ ಸೋರ್ಸ್ ಪರವಾನಗಿಗಳು';

  @override
  String get profileDeleteAccount => 'ಖಾತೆ ಅಳಿಸಿ';

  @override
  String profileVersion(String version, String build) {
    return 'TalkAcharya · v$version ($build)';
  }

  @override
  String get editFullName => 'ಪೂರ್ಣ ಹೆಸರು';

  @override
  String get editDisplayName => 'ಪ್ರದರ್ಶನದ ಹೆಸರು';

  @override
  String get editDateOfBirth => 'ಜನ್ಮ ದಿನಾಂಕ';

  @override
  String get editGender => 'ಲಿಂಗ';

  @override
  String get editGenderMale => 'ಪುರುಷ';

  @override
  String get editGenderFemale => 'ಮಹಿಳೆ';

  @override
  String get editGenderOther => 'ಇತರೆ';

  @override
  String get editEmail => 'ಇಮೇಲ್';

  @override
  String get editEmailUnverified => 'ಪರಿಶೀಲಿಸಿಲ್ಲ';

  @override
  String get editChangePhoto => 'ಫೋಟೋ ಬದಲಾಯಿಸಿ';

  @override
  String get editProfileSaved => 'ಪ್ರೊಫೈಲ್ ಅಪ್‌ಡೇಟ್ ಮಾಡಲಾಗಿದೆ';

  @override
  String get editProfileSaveError => 'ನಿಮ್ಮ ಬದಲಾವಣೆಗಳನ್ನು ಉಳಿಸಲು ಸಾಧ್ಯವಾಗಲಿಲ್ಲ';

  @override
  String get editGenderUndisclosed => 'Prefer not to say';

  @override
  String get editNameInvalid => 'Enter your name (at least 2 letters)';

  @override
  String get editEmailInvalid => 'Enter a valid email address';

  @override
  String get editPhone => 'Mobile number';

  @override
  String get editPhoneLocked => 'Your login number can\'t be changed';

  @override
  String get editSectionPersonal => 'Personal details';

  @override
  String get editSectionContact => 'Contact';

  @override
  String get editDobPlaceholder => 'Add your date of birth';

  @override
  String get editPhotoUpdated => 'Photo updated';

  @override
  String get editCountry => 'ದೇಶ';

  @override
  String get chooseLanguage => 'ಭಾಷೆ ಆರಿಸಿ';

  @override
  String get chooseCurrency => 'ಕರೆನ್ಸಿ ಆರಿಸಿ';

  @override
  String get deleteAccountTitle => 'ನಿಮ್ಮ ಖಾತೆ ಅಳಿಸಿ';

  @override
  String get deleteAccountBody =>
      'ಇದು ನಿಮ್ಮ ಪ್ರೊಫೈಲ್, ಜನ್ಮ ಚಾರ್ಟ್‌ಗಳು ಮತ್ತು ಚಾಟ್ ಇತಿಹಾಸವನ್ನು ಶಾಶ್ವತವಾಗಿ ತೆಗೆದುಹಾಕುತ್ತದೆ. ನಿಮ್ಮ ವ್ಯಾಲೆಟ್ ಬ್ಯಾಲೆನ್ಸ್ ಏನಾದರೂ ಇದ್ದರೆ ಅದನ್ನು ಮೂಲ ಪಾವತಿ ವಿಧಾನಕ್ಕೆ ಮರುಪಾವತಿಸಲಾಗುತ್ತದೆ. ಕಾನೂನಿನ ಪ್ರಕಾರ ಸಮಾಲೋಚನೆ ದಾಖಲೆಗಳನ್ನು ಇರಿಸಲಾಗುತ್ತದೆ.';

  @override
  String get deleteAccountHold =>
      'ನಿಮ್ಮ ಖಾತೆಯನ್ನು ತಕ್ಷಣವೇ ನಿಷ್ಕ್ರಿಯಗೊಳಿಸಲಾಗುತ್ತದೆ ಮತ್ತು 30 ದಿನಗಳ ನಂತರ ಸಂಪೂರ್ಣವಾಗಿ ಅಳಿಸಲಾಗುತ್ತದೆ. ರದ್ದುಗೊಳಿಸಲು 30 ದಿನಗಳ ಒಳಗೆ ಮತ್ತೆ ಸೈನ್ ಇನ್ ಮಾಡಿ.';

  @override
  String get deleteAccountConfirm => 'ಹೌದು, ನನ್ನ ಖಾತೆ ಅಳಿಸಿ';

  @override
  String get deleteAccountRequested => 'ಖಾತೆ ಅಳಿಸುವಿಕೆ ವಿನಂತಿಸಲಾಗಿದೆ';

  @override
  String get referTitle => 'ರೆಫರ್ ಮಾಡಿ ಮತ್ತು ಸಂಪಾದಿಸಿ';

  @override
  String referHeroTitle(String friendAmount, String youAmount) {
    return '$friendAmount ನೀಡಿ, $youAmount ಪಡೆಯಿರಿ';
  }

  @override
  String referHeroBody(String friendAmount, String youAmount) {
    return 'ನಿಮ್ಮ ಸ್ನೇಹಿತರಿಗೆ ಅವರ ಮೊದಲ ಸಮಾಲೋಚನೆಯಲ್ಲಿ $friendAmount ರಿಯಾಯಿತಿ ಸಿಗುತ್ತದೆ. ಅವರು ಅದನ್ನು ಪಡೆದಾಗ ನಿಮ್ಮ ವ್ಯಾಲೆಟ್‌ಗೆ $youAmount ಸಿಗುತ್ತದೆ.';
  }

  @override
  String get referYourCode => 'ನಿಮ್ಮ ರೆಫರಲ್ ಕೋಡ್';

  @override
  String get referShareLink => 'ಆಹ್ವಾನ ಲಿಂಕ್ ಹಂಚಿಕೊಳ್ಳಿ';

  @override
  String get referInvited => 'ಆಹ್ವಾನಿಸಲಾಗಿದೆ';

  @override
  String get referJoined => 'ಸೇರಿದ್ದಾರೆ';

  @override
  String get referEarned => 'ಸಂಪಾದಿಸಲಾಗಿದೆ';

  @override
  String get referHowItWorks => 'ಇದು ಹೇಗೆ ಕೆಲಸ ಮಾಡುತ್ತದೆ';

  @override
  String get referStep1 =>
      'ನಿಮ್ಮ ಕೋಡ್ ಅಥವಾ ಲಿಂಕ್ ಹಂಚಿಕೊಳ್ಳಿ. ಸೈನ್ ಅಪ್ ಮಾಡುವಾಗ ನಿಮ್ಮ ಸ್ನೇಹಿತ ಅದನ್ನು ನಮೂದಿಸುತ್ತಾರೆ.';

  @override
  String referStep2(String amount) {
    return 'ಅವರ ಮೊದಲ ಪಾವತಿಸಿದ ಸಮಾಲೋಚನೆಯಲ್ಲಿ ಅವರಿಗೆ $amount ರಿಯಾಯಿತಿ ಸಿಗುತ್ತದೆ.';
  }

  @override
  String referStep3(String amount) {
    return 'ಸಮಾಲೋಚನೆಯ ಬಿಲ್ ಆದ ತಕ್ಷಣ, $amount ನಿಮ್ಮ ವ್ಯಾಲೆಟ್‌ಗೆ ಬರುತ್ತದೆ.';
  }

  @override
  String get referYourReferrals => 'ನಿಮ್ಮ ರೆಫರಲ್‌ಗಳು';

  @override
  String get referStatusPending => 'ಬಾಕಿ ಇದೆ';

  @override
  String get referStatusJoined => 'ಸೇರಿದ್ದಾರೆ';

  @override
  String get referStatusRewarded => 'ಬಹುಮಾನ ನೀಡಲಾಗಿದೆ';

  @override
  String referJoinedOn(String date) {
    return '$date ರಂದು ಸೇರಿದ್ದಾರೆ';
  }

  @override
  String get referFirstCallDone => 'ಮೊದಲ ಕರೆ ಮುಗಿದಿದೆ';

  @override
  String referShareText(String code, String amount, String link) {
    return 'TalkAcharya ದಲ್ಲಿ ನನ್ನ ಕೋಡ್ $code ಬಳಸಿ ಮತ್ತು ನಿಮ್ಮ ಮೊದಲ ಜ್ಯೋತಿಷ್ಯ ಸಮಾಲೋಚನೆಯಲ್ಲಿ $amount ರಿಯಾಯಿತಿ ಪಡೆಯಿರಿ. $link';
  }

  @override
  String get kundaliYogasDoshasTitle => 'ಯೋಗಗಳು ಮತ್ತು ದೋಷಗಳು';

  @override
  String get kundaliTabDoshas => 'ದೋಶಗಳು';

  @override
  String get kundaliTabYogas => 'ಯೋಗಗಳು';

  @override
  String get doshaIntro =>
      'ದೋಷಗಳು ಕುಂಡಲಿಯಲ್ಲಿ ಸೂಕ್ಷ್ಮ ಬಿಂದುಗಳಾಗಿವೆ. ಹೆಚ್ಚಿನ ದೋಷಗಳು ಸಮಯ, ಬೆಂಬಲಿತ ದಶಾ ಅಥವಾ ಶಾಸ್ತ್ರೀಯ ಪರಿಹಾರದೊಂದಿಗೆ ಮೃದುವಾಗುತ್ತವೆ - ನಿಮಗೆ ನಿಜವಾಗಿಯೂ ಮುಖ್ಯವಾದುದನ್ನು ಜ್ಯೋತಿಷಿ ದೃಢೀಕರಿಸುತ್ತಾರೆ.';

  @override
  String get doshaDisclaimer =>
      'ರಚನಾತ್ಮಕ ಸೂಚನೆಗಳು ಮಾತ್ರ, ಭವಿಷ್ಯವಾಣಿಗಳಲ್ಲ. ರತ್ನವನ್ನು ಧರಿಸುವ ಮೊದಲು ಅಥವಾ ಗಂಭೀರ ಪರಿಹಾರವನ್ನು ಪ್ರಾರಂಭಿಸುವ ಮೊದಲು ಜ್ಯೋತಿಷಿಯೊಂದಿಗೆ ಮಾತನಾಡಿ.';

  @override
  String get doshaPresent => 'ಪ್ರಸ್ತುತ';

  @override
  String get doshaNotPresent => 'ಇಲ್ಲ';

  @override
  String get doshaCancelled => 'ಪರಿಣಾಮಕಾರಿಯಾಗಿ ರದ್ದುಗೊಳಿಸಲಾಗಿದೆ';

  @override
  String get doshaSeverityClear => 'ಸ್ಪಷ್ಟ';

  @override
  String get doshaSeverityMild => 'ಸೌಮ್ಯ';

  @override
  String get doshaSeverityModerate => 'ಮಧ್ಯಮ';

  @override
  String get doshaSeverityStrong => 'ಬಲಿಷ್ಠ';

  @override
  String get doshaWhy => 'ಅದನ್ನು ಏಕೆ ಫ್ಲ್ಯಾಗ್ ಮಾಡಲಾಗಿದೆ';

  @override
  String get doshaWhatReduces => 'ಏನು ಕಡಿಮೆ ಮಾಡುತ್ತದೆ?';

  @override
  String doshaReducedNote(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count classical factors',
      one: 'One classical factor',
    );
    return '$_temp0 in your chart ease this.';
  }

  @override
  String get doshaClearSectionTitle => 'ಸ್ಪಷ್ಟವಾಗಿದೆ — ನಿಮ್ಮ ಪಟ್ಟಿಯಲ್ಲಿಲ್ಲ.';

  @override
  String get doshaAllClear => 'ನಿಮ್ಮ ಜಾತಕದಲ್ಲಿ ಸಾಮಾನ್ಯ ದೋಷಗಳು ಯಾವುದೂ ಇಲ್ಲ.';

  @override
  String get doshaAskCta =>
      'ಇದು ನಿಮಗೆ ಏನನ್ನು ಸೂಚಿಸುತ್ತದೆ ಎಂದು ಜ್ಯೋತಿಷಿಯನ್ನು ಕೇಳಿ.';

  @override
  String get insightsTitle => 'ವ್ಯಕ್ತಿತ್ವ ಮತ್ತು ಜೀವನದ ಅವಲೋಕನ';

  @override
  String get insightsIntro =>
      'ನಿಮ್ಮ ಜನ್ಮ (D1) ಚಾರ್ಟ್‌ನ ಉಚಿತ ಓದುವಿಕೆ - ಜೀವನದ ಪ್ರಮುಖ ಕ್ಷೇತ್ರಗಳಲ್ಲಿ ಅದು ಒಲವು ತೋರುವ ಪ್ರವೃತ್ತಿಗಳು. ಇದು ಆತ್ಮಾವಲೋಕನಕ್ಕಾಗಿ ಒಂದು ರೇಖಾಚಿತ್ರವಾಗಿದೆ, ಘಟನೆಗಳು ಅಥವಾ ದಿನಾಂಕಗಳ ಮುನ್ಸೂಚನೆಯಲ್ಲ.';

  @override
  String get insightsDisclaimer =>
      'ನಿಮ್ಮ ಚಾರ್ಟ್‌ನಿಂದ ಸಾಮಾನ್ಯ ಮಾರ್ಗದರ್ಶನ, ಭವಿಷ್ಯವಾಣಿಯಲ್ಲ. ಇದು ಯಾವುದೇ ದಿನಾಂಕಗಳನ್ನು ಹೆಸರಿಸುವುದಿಲ್ಲ ಮತ್ತು ಆರೋಗ್ಯ, ಜೀವಿತಾವಧಿ ಅಥವಾ ಸಂಬಂಧಗಳ ಬಗ್ಗೆ ಯಾವುದೇ ಹಕ್ಕುಗಳನ್ನು ನೀಡುವುದಿಲ್ಲ. ನಿರ್ದಿಷ್ಟವಾದ ಯಾವುದಕ್ಕೂ, ಜ್ಯೋತಿಷಿಯೊಂದಿಗೆ ಮಾತನಾಡಿ.';

  @override
  String get insightsAskCta => 'ನಿಮ್ಮ ನಕ್ಷೆಯ ಬಗ್ಗೆ ಜ್ಯೋತಿಷಿಯನ್ನು ಕೇಳಿ';

  @override
  String get insightsWhatItReadsFrom => 'ಇದರಿಂದ ಏನು ಓದುತ್ತದೆ';

  @override
  String get insightsToneSupportive => 'ಬೆಂಬಲ ನೀಡುವ';

  @override
  String get insightsToneBalanced => 'ಸಮತೋಲಿತ';

  @override
  String get insightsToneChallenging => 'ಕಾಳಜಿ ಬೇಕು';

  @override
  String get insightsToneMixed => 'ಮಿಶ್ರಿತ';

  @override
  String get insightsAreaPersonality => 'ವ್ಯಕ್ತಿತ್ವ ಮತ್ತು ಪ್ರಕೃತಿ';

  @override
  String get insightsAreaAppearance => 'ದೈಹಿಕ ಗೋಚರತೆ';

  @override
  String get insightsAreaMind => 'ಮನಸ್ಸು ಮತ್ತು ಭಾವನೆಗಳು';

  @override
  String get insightsAreaCareer => 'ವೃತ್ತಿ & ವೃತ್ತಿ';

  @override
  String get insightsAreaWealth => 'ಸಂಪತ್ತು ಮತ್ತು ಹಣಕಾಸು';

  @override
  String get insightsAreaEducation => 'ಶಿಕ್ಷಣ ಮತ್ತು ಬುದ್ಧಿಶಕ್ತಿ';

  @override
  String get insightsAreaMarriage => 'ಮದುವೆ ಮತ್ತು ಸಂಗಾತಿ';

  @override
  String get insightsAreaFamily => 'ಕುಟುಂಬ ಮತ್ತು ಸಂಬಂಧಗಳು';

  @override
  String get insightsAreaHealth => 'ಆರೋಗ್ಯ ಮತ್ತು ಚೈತನ್ಯ';

  @override
  String get insightsAreaFortune => 'ಅದೃಷ್ಟ ಮತ್ತು ಧರ್ಮ';

  @override
  String get insightsAreaStrengths => 'ಸಾಮರ್ಥ್ಯಗಳು ಮತ್ತು ಸವಾಲುಗಳು';

  @override
  String get predTitle => 'ಭವಿಷ್ಯವಾಣಿಗಳು';

  @override
  String get predReadingTitle => 'ನಿಮ್ಮ ಮುನ್ಸೂಚನೆ';

  @override
  String get predRequestTitle => 'ಮುನ್ಸೂಚನೆಯನ್ನು ವಿನಂತಿಸಿ';

  @override
  String get predHeroTitle => 'ನಿಮಗಾಗಿ ಬರೆಯಲಾದ ಮುನ್ಸೂಚನೆ';

  @override
  String get predHeroBody =>
      'ಜ್ಯೋತಿಷಿಯೊಬ್ಬರು ನಿಮ್ಮ ಜನ್ಮ ಕುಂಡಲಿ, ದಶಾ ಮತ್ತು ಪ್ರಸ್ತುತ ಸಂಚಾರಗಳನ್ನು ಓದುತ್ತಾರೆ ಮತ್ತು ಜೀವನದ ಒಂದು ಕ್ಷೇತ್ರಕ್ಕೆ ಭವಿಷ್ಯವನ್ನು ಬರೆಯುತ್ತಾರೆ. ಸಾಮಾನ್ಯವಾಗಿ 3 ದಿನಗಳಲ್ಲಿ ನಿಮ್ಮ ಭಾಷೆಯಲ್ಲಿ ತಲುಪಿಸಲಾಗುತ್ತದೆ.';

  @override
  String get predChooseArea => 'ಪ್ರದೇಶವನ್ನು ಆರಿಸಿ';

  @override
  String get predMyReadings => 'ನಿಮ್ಮ ಮುನ್ಸೂಚನೆಗಳು';

  @override
  String get predNoReadings =>
      'ಇನ್ನೂ ಯಾವುದೇ ಮುನ್ಸೂಚನೆಗಳಿಲ್ಲ. ವಿನಂತಿಸಲು ಮೇಲಿನ ಪ್ರದೇಶವನ್ನು ಆರಿಸಿ.';

  @override
  String get predSeePacks => 'ಪ್ಯಾಕ್‌ಗಳನ್ನು ನೋಡಿ';

  @override
  String get predSubscribed => 'ಚಂದಾದಾರರಾಗಿದ್ದಾರೆ';

  @override
  String predCredits(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count credits',
      one: '1 credit',
    );
    return '$_temp0';
  }

  @override
  String get predBuyTitle => 'ಭವಿಷ್ಯವಾಣಿ ಕ್ರೆಡಿಟ್‌ಗಳು';

  @override
  String get predBuyBody =>
      'ಒಂದು ಕ್ರೆಡಿಟ್ = ಒಂದು ಲಿಖಿತ ಮುನ್ಸೂಚನೆ. ಒಂದು ಪ್ಯಾಕ್ ಖರೀದಿಸಿ, ನಿಮಗೆ ಓದುವಿಕೆ ಬೇಕಾದಾಗ ಅದು ಸಿದ್ಧವಾಗಿರುತ್ತದೆ.';

  @override
  String get predBuyWalletNote =>
      'ನಿಮ್ಮ ವ್ಯಾಲೆಟ್ ಬ್ಯಾಲೆನ್ಸ್‌ನಿಂದ ಪಾವತಿಸಲಾಗಿದೆ.';

  @override
  String predPackName(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Pack of $count',
      one: '1 credit',
    );
    return '$_temp0';
  }

  @override
  String predPackPer(String price) {
    return 'ಪ್ರತಿ ಕ್ರೆಡಿಟ್‌ಗೆ $price';
  }

  @override
  String predBuySuccess(int count) {
    return 'ಸೇರಿಸಲಾಗಿದೆ. ನೀವು ಈಗ $count ಕ್ರೆಡಿಟ್‌ಗಳನ್ನು ಹೊಂದಿದ್ದೀರಿ.';
  }

  @override
  String get predForProfile => 'ಯಾವ ಜನ್ಮ ವಿವರಕ್ಕಾಗಿ';

  @override
  String get predAddProfile => 'ಜನನ ಪ್ರೊಫೈಲ್ ಸೇರಿಸಿ';

  @override
  String get predPickProfile => 'ಮೊದಲು ಜನನ ವಿವರವನ್ನು ಆರಿಸಿ.';

  @override
  String get predArea => 'ಜೀವನದ ಕ್ಷೇತ್ರ.';

  @override
  String get predPeriod => 'ಅವಧಿ';

  @override
  String predCostsOne(int count) {
    return 'ನಿಮ್ಮ $count ಕ್ರೆಡಿಟ್‌ಗಳಲ್ಲಿ 1 ಅನ್ನು ಬಳಸುತ್ತದೆ.';
  }

  @override
  String get predNoCreditYet =>
      'ನಿಮಗೆ ಕ್ರೆಡಿಟ್ ಬೇಕಾಗುತ್ತದೆ — ನಾವು ಮುಂದೆ ಪ್ಯಾಕ್‌ಗಳನ್ನು ತೋರಿಸುತ್ತೇವೆ.';

  @override
  String get predRequestCta => 'ಮುನ್ಸೂಚನೆ ವಿನಂತಿಸಿ';

  @override
  String get predRequestDisclaimer =>
      'ಜ್ಯೋತಿಷಿಯು ನಿಮ್ಮ ಜಾತಕ, ದಶಾ ಮತ್ತು ಸಂಚಾರಗಳನ್ನು ಆಧರಿಸಿ ಬರೆಯುತ್ತಾರೆ. ಜ್ಯೋತಿಷ್ಯವು ಚಿಂತನೆ ಮತ್ತು ಯೋಜನೆಗೆ ಮಾರ್ಗದರ್ಶನವಾಗಿದೆ, ಖಾತರಿಯಲ್ಲ.';

  @override
  String get predAreaCareer => 'ವೃತ್ತಿ ಮತ್ತು ಕೆಲಸ';

  @override
  String get predAreaMarriage => 'ಮದುವೆ ಮತ್ತು ಪ್ರೀತಿ';

  @override
  String get predAreaFinance => 'ಹಣ ಮತ್ತು ಹಣಕಾಸು';

  @override
  String get predAreaHealth => 'ಆರೋಗ್ಯ ಮತ್ತು ಶಕ್ತಿ';

  @override
  String get predAreaEducation => 'ಅಧ್ಯಯನ ಮತ್ತು ಕಲಿಕೆ';

  @override
  String get predAreaGeneral => 'ಜೀವನ ಅವಲೋಕನ';

  @override
  String get predPeriodMonth => 'ಮುಂಬರುವ ತಿಂಗಳು';

  @override
  String get predPeriodQuarter => 'ಮುಂದಿನ 3 ತಿಂಗಳುಗಳು';

  @override
  String get predPeriodYear => 'ಮುಂಬರುವ ವರ್ಷ';

  @override
  String get predStatusWriting => 'ಬರೆಯಲಾಗುತ್ತಿದೆ';

  @override
  String get predStatusReview => 'ಪರಿಶೀಲನೆಯಲ್ಲಿದೆ';

  @override
  String get predStatusReady => 'ಓದಲು ಸಿದ್ಧವಾಗಿದೆ';

  @override
  String get predStatusUnavailable => 'ಲಭ್ಯವಿಲ್ಲ';

  @override
  String get predStatusRefunded => 'ಮರುಪಾವತಿಸಲಾಗಿದೆ';

  @override
  String predDeliveredOn(String date) {
    return 'ತಲುಪಿಸಲಾಗಿದೆ $date';
  }

  @override
  String predEta(String date) {
    return '$date ರೊಳಗೆ ನಿರೀಕ್ಷಿಸಲಾಗಿದೆ';
  }

  @override
  String get predWritingTitle => 'ಇದನ್ನು ಒಬ್ಬ ಜ್ಯೋತಿಷಿ ಬರೆಯುತ್ತಿದ್ದಾರೆ.';

  @override
  String get predWritingBody =>
      'ಅದು ಸಿದ್ಧವಾದ ತಕ್ಷಣ ನಾವು ನಿಮಗೆ ಅಧಿಸೂಚನೆಯನ್ನು ಕಳುಹಿಸುತ್ತೇವೆ.';

  @override
  String predWritingEta(String date) {
    return '$date ರೊಳಗೆ ನಿರೀಕ್ಷಿಸಲಾಗಿದೆ. ಅದು ಸಿದ್ಧವಾದಾಗ ನಾವು ನಿಮಗೆ ತಿಳಿಸುತ್ತೇವೆ.';
  }

  @override
  String get predRefundedTitle => 'ಕ್ರೆಡಿಟ್ ಮರುಪಾವತಿಸಲಾಗಿದೆ';

  @override
  String get predRefundedBody =>
      'ನಾವು ಇದನ್ನು ಸಮಯಕ್ಕೆ ತಲುಪಿಸಲು ಸಾಧ್ಯವಾಗಲಿಲ್ಲ, ಆದ್ದರಿಂದ ನಿಮ್ಮ ಕ್ರೆಡಿಟ್ ನಿಮ್ಮ ಖಾತೆಗೆ ಹಿಂತಿರುಗಿದೆ.';

  @override
  String get predDisclaimer =>
      'ನಿಮ್ಮ ಜನ್ಮ ಕುಂಡಲಿ, ದಶಾ ಮತ್ತು ಪ್ರಸ್ತುತ ಸಂಚಾರಗಳನ್ನು ಆಧರಿಸಿ ಜ್ಯೋತಿಷಿಯೊಬ್ಬರು ನಿಮಗಾಗಿ ಬರೆದಿದ್ದಾರೆ. ಜ್ಯೋತಿಷ್ಯವು ಚಿಂತನೆ ಮತ್ತು ಯೋಜನೆಗೆ ಮಾರ್ಗದರ್ಶನವಾಗಿದೆ - ಆಯ್ಕೆಗಳು ಮತ್ತು ಫಲಿತಾಂಶವು ನಿಮ್ಮದೇ ಆಗಿರುತ್ತದೆ.';

  @override
  String get predAskFollowUp => 'ಮುಂದಿನ ಪ್ರಶ್ನೆಯನ್ನು ಕೇಳಿ';

  @override
  String get remediesTitle => 'ಪರಿಹಾರಗಳು';

  @override
  String get remediesIntro =>
      'ನಿಮ್ಮ ಜಾತಕದಲ್ಲಿ ತೋರಿಸಿರುವ ಸಕ್ರಿಯ ದೋಷಗಳು, ದುರ್ಬಲ ಗ್ರಹಗಳು, ಚಾಲನೆಯಲ್ಲಿರುವ ದಶಾ ಮತ್ತು ಒತ್ತಡದ ಮನೆಗಳಿಗೆ ಹೊಂದಿಕೆಯಾಗುವ ಸಾಂಪ್ರದಾಯಿಕ ಪರಿಹಾರಗಳು. ಅವು ನಿಮ್ಮ ನಂಬಿಕೆ, ಆರೋಗ್ಯ ಮತ್ತು ಸಾಧನಗಳಿಗೆ ಸರಿಹೊಂದುವಂತೆ ಆಯ್ಕೆ ಮಾಡಲಾದ ಶಿಸ್ತು ಮತ್ತು ಭಕ್ತಿಯ ಕ್ರಿಯೆಗಳಾಗಿವೆ.';

  @override
  String get remediesNone =>
      'ನಿಮ್ಮ ಪಟ್ಟಿಯಲ್ಲಿ ಈಗ ನಿರ್ದಿಷ್ಟ ಪರಿಹಾರದ ಅಗತ್ಯವಿರುವ ಯಾವುದೂ ಎದ್ದು ಕಾಣುತ್ತಿಲ್ಲ. ಸಣ್ಣ, ಸ್ಥಿರವಾದ ದೈನಂದಿನ ಅಭ್ಯಾಸವನ್ನು ಇಟ್ಟುಕೊಳ್ಳುವುದು ಯಾವಾಗಲೂ ಯೋಗ್ಯವಾಗಿರುತ್ತದೆ.';

  @override
  String get remediesDisclaimer =>
      'ನಿಮ್ಮ ನಂಬಿಕೆ, ಆರೋಗ್ಯ ಮತ್ತು ಆರ್ಥಿಕ ಸ್ಥಿತಿಗೆ ಸರಿಹೊಂದುವದನ್ನು ಮಾತ್ರ ಮಾಡಿ. ನಿಮಗೆ ಅಸುರಕ್ಷಿತವಾಗಿದ್ದರೆ ಉಪವಾಸವನ್ನು ಬಿಟ್ಟುಬಿಡಿ ಮತ್ತು ದಾನ ಮಾಡಲು ಎಂದಿಗೂ ಸಾಲ ತೆಗೆದುಕೊಳ್ಳಬೇಡಿ.';

  @override
  String get remediesAskCta => 'ನಿಮ್ಮ ಪರಿಹಾರಗಳ ಬಗ್ಗೆ ಜ್ಯೋತಿಷಿಯೊಂದಿಗೆ ಮಾತನಾಡಿ';

  @override
  String get remediesConfirmCta => 'ಮೊದಲು ಜ್ಯೋತಿಷಿಯೊಂದಿಗೆ ದೃಢೀಕರಿಸಿ';

  @override
  String remediesSource(String source) {
    return 'ಮೂಲ: $source';
  }

  @override
  String get doshaSeeRemedies => 'ನಿಮ್ಮ ಚಾರ್ಟ್‌ಗೆ ಪರಿಹಾರಗಳನ್ನು ನೋಡಿ.';

  @override
  String get remedyCatMantra => 'ಮಂತ್ರ ಮತ್ತು ಜಪ';

  @override
  String get remedyCatStotra => 'ಸ್ತೋತ್ರ ಮತ್ತು ಪಠಣ';

  @override
  String get remedyCatPuja => 'ಪೂಜೆ ಮತ್ತು ಆಚರಣೆ';

  @override
  String get remedyCatVrat => 'ವ್ರತ ಮತ್ತು ಉಪವಾಸ';

  @override
  String get remedyCatDaan => 'ದಾನ ಮತ್ತು ದತ್ತಿ';

  @override
  String get remedyCatLifestyle => 'ಜೀವನ ಶೈಲಿ';

  @override
  String get remedyCatYantra => 'ಯಂತ್ರ';

  @override
  String get remedyCatGemstone => 'ರತ್ನ';

  @override
  String get remedyCatRudraksha => 'ರುದ್ರಾಕ್ಷ';

  @override
  String get prashnaTitle => 'ಒಂದು ಪ್ರಶ್ನೆ ಕೇಳಿ';

  @override
  String get prashnaHeroTitle => 'ಈ ಕ್ಷಣಕ್ಕೆ ಹೌದು ಅಥವಾ ಇಲ್ಲ ಎಂಬ ಉತ್ತರ';

  @override
  String get prashnaHeroBody =>
      'ನೀವು ಪ್ರಶ್ನೆ ಕೇಳುವ ಕ್ಷಣವನ್ನೇ ಕೆ.ಪಿ. ಹೊರಾರಿ (ಪ್ರಶ್ನ) ಓದುತ್ತಾರೆ. ಅವರು ಹೌದು, ಇಲ್ಲ ಅಥವಾ ಮಿಶ್ರಿತ ಎಂಬ ಒಲವನ್ನು ತಾರ್ಕಿಕವಾಗಿ ನೀಡುತ್ತಾರೆ. ಇದು ಒಂದು ಸಾಂಪ್ರದಾಯಿಕ ವಿಧಾನದ ಸೂಚಕ, ಭರವಸೆಯಲ್ಲ.';

  @override
  String get prashnaAbout => 'ಪ್ರಶ್ನೆ ಯಾವುದರ ಬಗ್ಗೆ?';

  @override
  String get prashnaHint => 'ಉದಾ: ನನಗೆ ಈ ಉದ್ಯೋಗದ ಆಫರ್ ಸಿಗುತ್ತದೆಯೇ?';

  @override
  String prashnaAskCta(String price) {
    return 'ಕೇಳಿ ( $price )';
  }

  @override
  String get prashnaDisclaimer =>
      'ನೀವು ಕೇಳಿದ ಕ್ಷಣದ ಕೆಪಿಯ ಭಯಾನಕ ಓದುವಿಕೆ. ಇದು ಒಂದು ಸಾಂಪ್ರದಾಯಿಕ ವಿಧಾನದ ಸೂಚಕ - ಭರವಸೆಯಲ್ಲ, ಮತ್ತು ಪೂರ್ಣ ಸಮಾಲೋಚನೆಗೆ ಪರ್ಯಾಯವಲ್ಲ.';

  @override
  String get prashnaNeedQuestion =>
      'ಮೊದಲು ಒಂದು ವಿಷಯವನ್ನು ಆರಿಸಿ ಮತ್ತು ನಿಮ್ಮ ಪ್ರಶ್ನೆಯನ್ನು ಟೈಪ್ ಮಾಡಿ.';

  @override
  String get prashnaLowBalance =>
      'ನಿಮ್ಮ ವಾಲೆಟ್ ಬ್ಯಾಲೆನ್ಸ್ ತುಂಬಾ ಕಡಿಮೆ ಇದೆ. ಕೇಳಲು ಹಣವನ್ನು ಸೇರಿಸಿ.';

  @override
  String get prashnaHistory => 'ನಿಮ್ಮ ಪ್ರಶ್ನೆಗಳು';

  @override
  String get prashnaNoHistory => 'ನೀವು ಇನ್ನೂ ಯಾವುದೇ ಪ್ರಶ್ನೆಯನ್ನು ಕೇಳಿಲ್ಲ.';

  @override
  String get prashnaAnswerTitle => 'ಓದುವಿಕೆ';

  @override
  String get prashnaAskAstrologer => 'ಜ್ಯೋತಿಷಿ ಜೊತೆ ಮಾತನಾಡಿ';

  @override
  String get prashnaHowRead => 'ಇದನ್ನು ಹೇಗೆ ಓದಲಾಯಿತು';

  @override
  String prashnaConfidence(int level) {
    String _temp0 = intl.Intl.pluralLogic(
      level,
      locale: localeName,
      other: 'clear',
      two: 'moderate',
      one: 'weak',
      zero: 'unclear',
    );
    return '$_temp0 indication';
  }

  @override
  String get prashnaVerdictYes => 'ಹೌದು ಎಂದು ಬಾಗಿ';

  @override
  String get prashnaVerdictNo => 'ಇಲ್ಲ ಎಂದು ಹೇಳುವುದು';

  @override
  String get prashnaVerdictMixed => 'ಮಿಶ್ರ ಸಂಕೇತಗಳು';

  @override
  String get prashnaVerdictUnclear => 'ನಿರ್ಣಾಯಕವಲ್ಲ';

  @override
  String get prashnaCatMarriage => 'ಮದುವೆ';

  @override
  String get prashnaCatJob => 'ಒಂದು ಕೆಲಸ';

  @override
  String get prashnaCatPromotion => 'ಪ್ರಚಾರ';

  @override
  String get prashnaCatBusiness => 'ವ್ಯಾಪಾರ';

  @override
  String get prashnaCatProperty => 'ಆಸ್ತಿ';

  @override
  String get prashnaCatMoney => 'ಸಾಲ ಅಥವಾ ಹಣ';

  @override
  String get prashnaCatChild => 'ಮಕ್ಕಳು';

  @override
  String get prashnaCatTravel => 'ವಿದೇಶ ಪ್ರಯಾಣ';

  @override
  String get prashnaCatLitigation => 'ನ್ಯಾಯಾಲಯದ ವಿಷಯ';

  @override
  String get prashnaCatHealth => 'ಆರೋಗ್ಯ ಮತ್ತು ಚೇತರಿಕೆ';

  @override
  String get prashnaCatLost => 'ಕಳೆದುಹೋದ ವಸ್ತು';

  @override
  String get prashnaCatReunion => 'ಪುನರ್ಮಿಲನ';

  @override
  String get prashnaCatGeneral => 'ಬೇರೆ ಏನೋ';

  @override
  String get yogaIntro =>
      'ಯೋಗಗಳು ಪ್ರವೃತ್ತಿಗಳು, ಖಾತರಿಗಳಲ್ಲ - ಗ್ರಹಗಳು ಉತ್ತಮ ಸ್ಥಾನದಲ್ಲಿದ್ದಾಗ ಮತ್ತು ಅವುಗಳ ದಶಾವನ್ನು ನಡೆಸಿದಾಗ ಅವು ಬಲಗೊಳ್ಳುತ್ತವೆ.';

  @override
  String get yogaNoneTitle => 'ಯಾವುದೇ ಶಾಸ್ತ್ರೀಯ ಯೋಗಗಳು ಪತ್ತೆಯಾಗಿಲ್ಲ.';

  @override
  String get yogaNoneBody =>
      'ಅದು ಸಾಮಾನ್ಯ ಮತ್ತು ಕೆಟ್ಟ ಸಂಕೇತವಲ್ಲ - ಚಾರ್ಟ್ ಅನ್ನು ಇನ್ನೂ ಅದರ ಮನೆಗಳು ಮತ್ತು ದಶಾಗಳಲ್ಲಿ ಓದಲಾಗುತ್ತದೆ.';

  @override
  String get kundaliTalkToAstrologer => 'ಜ್ಯೋತಿಷಿ ಜೊತೆ ಮಾತನಾಡಿ';

  @override
  String get kundaliHowItPlaysOut =>
      'ಇವು ನಿಮ್ಮ ಜೀವನ ಮತ್ತು ಸಮಯದಲ್ಲಿ ಹೇಗೆ ಪರಿಣಾಮ ಬೀರುತ್ತವೆ ಎಂದು ತಿಳಿಯಲು ಬಯಸುವಿರಾ?';

  @override
  String get yogaGajakesariName => 'ಗಜಕೇಸರಿ ಯೋಗ';

  @override
  String get yogaGajakesariMeaning =>
      'ಚಂದ್ರನಿಂದ ಕೇಂದ್ರದಲ್ಲಿ ಗುರು - ಸಮತೋಲನ, ಉತ್ತಮ ತೀರ್ಪು ಮತ್ತು ತೂಕವನ್ನು ಹೊಂದಿರುವ ಹೆಸರು.';

  @override
  String get yogaBudhadityaName => 'ಬುಧಾದಿತ್ಯ ಯೋಗ';

  @override
  String get yogaBudhadityaMeaning =>
      'ಸೂರ್ಯ ಮತ್ತು ಬುಧ ಒಟ್ಟಿಗೆ - ತೀಕ್ಷ್ಣವಾದ, ಅಭಿವ್ಯಕ್ತಿಶೀಲ ಮನಸ್ಸು; ಅಧ್ಯಯನ, ಬರವಣಿಗೆ ಮತ್ತು ವಿಶ್ಲೇಷಣೆಗೆ ಬಲಿಷ್ಠ.';

  @override
  String get yogaChandraMangalaName => 'ಚಂದ್ರ-ಮಂಗಳ ಯೋಗ';

  @override
  String get yogaChandraMangalaMeaning =>
      'ಮಂಗಳನೊಂದಿಗೆ ಚಂದ್ರ - ಹಣ ಮತ್ತು ಉದ್ಯಮದ ಸುತ್ತ ಚಾಲನೆ; ಪ್ರಯತ್ನ ಮತ್ತು ಉಪಕ್ರಮದ ಮೂಲಕ ಗಳಿಕೆ.';

  @override
  String get yogaRajaName => 'ರಾಜ ಯೋಗ';

  @override
  String get yogaRajaMeaning =>
      'ತ್ರಿಕೋನ ಅಧಿಪತಿಗೆ ಬಂಧಿಸಲಾದ ಕೇಂದ್ರ ಅಧಿಪತಿ - ಅವಧಿ ಮುಗಿದಾಗ ಸ್ಥಾನಮಾನ, ಅಧಿಕಾರ ಮತ್ತು ಅವಕಾಶದಲ್ಲಿ ಏರಿಕೆ.';

  @override
  String get yogaDhanaName => 'ಧನ ಯೋಗ';

  @override
  String get yogaDhanaMeaning =>
      'ಸಂಪತ್ತು ಮತ್ತು ಲಾಭಗಳು ಮನೆಗಳಿಗೆ ಸಂಬಂಧಿಸಿವೆ - ಉಳಿತಾಯ ಮತ್ತು ಸ್ಥಿರ ಆರ್ಥಿಕ ಬೆಳವಣಿಗೆಯನ್ನು ಬೆಂಬಲಿಸುತ್ತದೆ.';

  @override
  String get yogaNeechabhangaName => 'ನೀಚಭಂಗ ರಾಜ ಯೋಗ';

  @override
  String get yogaNeechabhangaMeaning =>
      'ದುರ್ಬಲಗೊಂಡ ಗ್ರಹ, ಅದರ ದೌರ್ಬಲ್ಯವು ರದ್ದಾಗುತ್ತದೆ - ಆರಂಭಿಕ ಹೋರಾಟವು ಬಲವಾಗಿ ಬದಲಾಗುತ್ತದೆ.';

  @override
  String get yogaKaalSarpaName => 'ಕಾಲ ಸರ್ಪ ಯೋಗ';

  @override
  String get yogaKaalSarpaMeaning =>
      'ರಾಹು-ಕೇತು ಅಕ್ಷದ ಒಂದು ಬದಿಯಲ್ಲಿರುವ ಎಲ್ಲಾ ಏಳು ಗ್ರಹಗಳು - ಸ್ಪಷ್ಟ ದಿಕ್ಕು ಕಂಡುಬರುವವರೆಗೆ ಜೀವನವು ಸೀಮಿತವಾಗಿರಬಹುದು.';

  @override
  String get yogaAdhiName => 'ಅಧಿ ಯೋಗ';

  @override
  String get yogaAdhiMeaning =>
      'ಚಂದ್ರನಿಂದ 6ನೇ, 7ನೇ ಮತ್ತು 8ನೇ ಮನೆಯಲ್ಲಿ ಶುಭಫಲಗಳು - ರಕ್ಷಣೆ, ಸಮರ್ಥ ಸಹಾಯಕರು ಮತ್ತು ಸ್ಥಿರ ಸ್ಥಾನ.';

  @override
  String get yogaShakataName => 'ಶಕಟ ಯೋಗ';

  @override
  String get yogaShakataMeaning =>
      'ಗುರು ಗ್ರಹದಿಂದ 6, 8 ಅಥವಾ 12ನೇ ಮನೆಯಲ್ಲಿ ಚಂದ್ರ - ಏರಿಳಿತಗೊಳ್ಳುವ ಅದೃಷ್ಟ; ಚಂದ್ರ ಬಲವಾಗಿದ್ದಾಗ ಸ್ಥಿರವಾಗಿರುತ್ತದೆ.';

  @override
  String get yogaVishName => 'ವಿಷ್ ಯೋಗಾ';

  @override
  String get yogaVishMeaning =>
      'ಶನಿಯೊಂದಿಗೆ ಚಂದ್ರ - ಮನಸ್ಸು ಭಾರವನ್ನು ಹೊರುತ್ತದೆ; ಫಲಿತಾಂಶಗಳು ಸಾಮಾನ್ಯವಾಗಿ ನಂತರ, ಪ್ರಬುದ್ಧತೆಯೊಂದಿಗೆ ಬರುತ್ತವೆ.';

  @override
  String get yogaKahalaName => 'ಕಹಲ ಯೋಗ';

  @override
  String get yogaKahalaMeaning =>
      'ಬಲವಾದ ಲಗ್ನಾಧಿಪತಿಯೊಂದಿಗೆ ಪರಸ್ಪರ ಕೇಂದ್ರದಲ್ಲಿ 4 ಮತ್ತು 9 ನೇ ಅಧಿಪತಿಗಳು - ಧೈರ್ಯಶಾಲಿ, ಉದ್ಯಮಶೀಲ, ಅಪಾಯವನ್ನು ತೆಗೆದುಕೊಳ್ಳಲು ಸಿದ್ಧರಿರುವವರು.';

  @override
  String get yogaPushkalaName => 'ಪುಷ್ಕಲಾ ಯೋಗ';

  @override
  String get yogaPushkalaMeaning =>
      'ಚಂದ್ರನ ಅಧಿಪತಿಯು ಲಗ್ನಾಧಿಪತಿ ಕೇಂದ್ರದಲ್ಲಿ — ಗೌರವ, ಒಳ್ಳೆಯ ಹೆಸರು ಮತ್ತು ಮನವೊಲಿಸುವ ಮಾತು.';

  @override
  String get yogaDaridraName => 'ದರಿದ್ರ ಯೋಗ';

  @override
  String get yogaDaridraMeaning =>
      '11 ನೇ (ಲಾಭ) ಅಧಿಪತಿಯು ಕಠಿಣ ಮನೆಗೆ ಬಿದ್ದಿದ್ದಾನೆ - ಲಾಭಗಳು ನಿಧಾನವಾಗಿ ಬರುತ್ತವೆ; ಬಲವಾದ ದಶಾ ಅದನ್ನು ತಿರುಗಿಸುತ್ತದೆ.';

  @override
  String get yogaAmalaName => 'ಅಮಲ ಯೋಗ';

  @override
  String get yogaAmalaMeaning =>
      'ಲಗ್ನ ಅಥವಾ ಚಂದ್ರನಿಂದ 10ನೇ ಮನೆಯಲ್ಲಿ ಶುಭ - ಶುದ್ಧ ಖ್ಯಾತಿ ಮತ್ತು ಶಾಶ್ವತ ಸದ್ಭಾವನೆ.';

  @override
  String get yogaSaraswatiName => 'ಸರಸ್ವತಿ ಯೋಗ';

  @override
  String get yogaSaraswatiMeaning =>
      'ಬುಧ, ಶುಕ್ರ ಮತ್ತು ಬಲಿಷ್ಠ ಗುರು ಉತ್ತಮ ಸ್ಥಾನದಲ್ಲಿದ್ದಾರೆ - ಕಲಿಕೆ, ಕಲೆ ಮತ್ತು ವಾಗ್ಮಿತೆ.';

  @override
  String get yogaLakshmiName => 'ಲಕ್ಷ್ಮಿ ಯೋಗಾ';

  @override
  String get yogaLakshmiMeaning =>
      'ಕೇಂದ್ರ ಅಥವಾ ತ್ರಿಕೋನದಲ್ಲಿ ಬಲಿಷ್ಠ 9ನೇ ಅಧಿಪತಿಯು ಬಲಿಷ್ಠ ಲಗ್ನಾಧಿಪತಿಯೊಂದಿಗೆ - ಅದೃಷ್ಟ, ಸೌಕರ್ಯ ಮತ್ತು ಅನುಗ್ರಹ.';

  @override
  String get yogaRuchakaName => 'ರುಚಕ ಯೋಗ';

  @override
  String get yogaRuchakaMeaning =>
      'ಮಂಗಳ ಕೇಂದ್ರದಲ್ಲಿ ಬಲಶಾಲಿ - ಧೈರ್ಯ, ದೈಹಿಕ ಶಕ್ತಿ ಮತ್ತು ಒತ್ತಡದಲ್ಲಿ ನಾಯಕತ್ವ.';

  @override
  String get yogaBhadraName => 'ಭದ್ರ ಯೋಗ';

  @override
  String get yogaBhadraMeaning =>
      'ಕೇಂದ್ರದಲ್ಲಿ ಬುಧ ಬಲಶಾಲಿ — ಬುದ್ಧಿವಂತಿಕೆ, ಸ್ಪಷ್ಟ ಮಾತು ಮತ್ತು ವ್ಯಾಪಾರ ಮತ್ತು ಸಂವಹನದಲ್ಲಿ ಕೌಶಲ್ಯ.';

  @override
  String get yogaHamsaName => 'ಹಂಸ ಯೋಗ';

  @override
  String get yogaHamsaMeaning =>
      'ಕೇಂದ್ರದಲ್ಲಿ ಗುರು ಬಲಶಾಲಿ - ಬುದ್ಧಿವಂತಿಕೆ, ನೀತಿಶಾಸ್ತ್ರ, ಬೋಧನೆ ಅಥವಾ ಸಲಹೆ ನೀಡುವ ಸ್ವಭಾವ ಮತ್ತು ಸಾಮಾನ್ಯ ಅದೃಷ್ಟ.';

  @override
  String get yogaMalavyaName => 'ಮಾಲವ್ಯ ಯೋಗ';

  @override
  String get yogaMalavyaMeaning =>
      'ಕೇಂದ್ರದಲ್ಲಿ ಶುಕ್ರ ಬಲಶಾಲಿ - ಮೋಡಿ, ಸೌಕರ್ಯ, ಸೌಂದರ್ಯದ ಕಣ್ಣು ಮತ್ತು ಆಹ್ಲಾದಕರ ಗೃಹ ಜೀವನ.';

  @override
  String get yogaSasaName => 'ಸಸ ಯೋಗ';

  @override
  String get yogaSasaMeaning =>
      'ಕೇಂದ್ರದಲ್ಲಿ ಬಲಿಷ್ಠವಾಗಿರುವ ಶನಿ - ಶಿಸ್ತು, ಸಹಿಷ್ಣುತೆ ಮತ್ತು ಅಧಿಕಾರ ನಿಧಾನವಾಗಿ ನಿರ್ಮಿಸಲ್ಪಟ್ಟಿದೆ ಮತ್ತು ನಿರ್ವಹಿಸಲ್ಪಡುತ್ತದೆ.';

  @override
  String get yogaUbhayachariName => 'ಉಭಯಚಾರಿ ಯೋಗ';

  @override
  String get yogaUbhayachariMeaning =>
      'ಸೂರ್ಯನ ಎರಡೂ ಬದಿಗಳಲ್ಲಿರುವ ಗ್ರಹಗಳು - ಉತ್ತಮ ಬೆಂಬಲಿತ, ಗೋಚರ ಜೀವನ ಮತ್ತು ಉತ್ತಮ ಸರ್ವತೋಮುಖ ನಿಲುವು.';

  @override
  String get yogaVesiName => 'ವೆಸಿ ಯೋಗ';

  @override
  String get yogaVesiMeaning =>
      'ಸೂರ್ಯನಿಂದ 2 ನೇ ಮನೆಯಲ್ಲಿ ಗ್ರಹ - ಸ್ಥಿರ ಮಾತು, ಸಮತೋಲಿತ ದೃಷ್ಟಿಕೋನ ಮತ್ತು ಉತ್ತಮ ಹೆಸರು.';

  @override
  String get yogaVasiName => 'ವಾಸಿ ಯೋಗ';

  @override
  String get yogaVasiMeaning =>
      'ಸೂರ್ಯನಿಂದ 12ನೇ ಮನೆಯಲ್ಲಿ ಗ್ರಹ - ಸಾಮರ್ಥ್ಯ, ಪ್ರಭಾವ ಮತ್ತು ಉದಾರ ಗುಣ.';

  @override
  String get yogaShubhaKartariName => 'ಶುಭ ಕರ್ತಾರಿ ಯೋಗ';

  @override
  String get yogaShubhaKartariMeaning =>
      'ಲಗ್ನದ ಎರಡೂ ಬದಿಗಳಲ್ಲಿ ಶುಭಫಲಗಳು - ರಕ್ಷಣೆ, ಸೌಮ್ಯ ಮಾರ್ಗ ಮತ್ತು ಸಹಾಯಕವಾದ ಸಂದರ್ಭಗಳು.';

  @override
  String get yogaPapaKartariName => 'ಪಾಪಾ ಕರ್ತಾರಿ ಯೋಗ';

  @override
  String get yogaPapaKartariMeaning =>
      'ಲಗ್ನದ ಎರಡೂ ಬದಿಗಳಲ್ಲಿ ದೋಷಗಳು - ಸ್ವಯಂ ಮತ್ತು ಆರೋಗ್ಯದ ಮೇಲೆ ಒತ್ತಡ; ನಿಮ್ಮ ಶಕ್ತಿ ಮತ್ತು ಗಡಿಗಳನ್ನು ಕಾಪಾಡಿಕೊಳ್ಳಿ.';

  @override
  String get yogaDurudharaName => 'ದುರುಧಾರ ಯೋಗ';

  @override
  String get yogaDurudharaMeaning =>
      'ಗ್ರಹಗಳು 2 ಮತ್ತು 12 ನೇ ಸ್ಥಾನದಲ್ಲಿ ಚಂದ್ರನ ಪಕ್ಕದಲ್ಲಿವೆ - ನಿಮ್ಮ ಸುತ್ತಲಿನ ಸಂಪನ್ಮೂಲಗಳು, ಸೌಕರ್ಯ ಮತ್ತು ಸ್ಥಿರ ಬೆಂಬಲ.';

  @override
  String get yogaSunaphaName => 'ಸುನಫ ಯೋಗ';

  @override
  String get yogaSunaphaMeaning =>
      'ಚಂದ್ರನಿಂದ 2 ನೇ ಮನೆಯಲ್ಲಿ ಇರುವ ಗ್ರಹ - ಸ್ವ-ನಿರ್ಮಿತ ಸಾಧನ, ಬುದ್ಧಿವಂತಿಕೆ ಮತ್ತು ಒಳ್ಳೆಯ ಹೆಸರು.';

  @override
  String get yogaAnaphaName => 'ಅನಫ ಯೋಗ';

  @override
  String get yogaAnaphaMeaning =>
      'ಚಂದ್ರನಿಂದ 12 ನೇ ಮನೆಯಲ್ಲಿ ಇರುವ ಗ್ರಹ - ಸುಲಭ ಸ್ವಭಾವ, ಯೋಗಕ್ಷೇಮ ಮತ್ತು ಬಡತನದಿಂದ ಮುಕ್ತಿ.';

  @override
  String get yogaKemadrumaYogaName => 'ಕೇಮದ್ರುಮ ಯೋಗ';

  @override
  String get yogaKemadrumaYogaMeaning =>
      'ಚಂದ್ರನು ಬೆಂಬಲವಿಲ್ಲದೆ ಒಂಟಿಯಾಗಿ ನಿಲ್ಲುತ್ತಾನೆ - ಚಂದ್ರನು ಬಲವಾಗಿದ್ದಾಗ ಅಥವಾ ಒಂದು ಕೇಂದ್ರವು ಕಾರ್ಯನಿರತವಾಗಿದ್ದಾಗ ಶಮನವಾಗುವ ಆಂತರಿಕ ಚಡಪಡಿಕೆ.';

  @override
  String get yogaVasumatiName => 'ವಸುಮತಿ ಯೋಗ';

  @override
  String get yogaVasumatiMeaning =>
      'ಲಗ್ನ ಅಥವಾ ಚಂದ್ರನಿಂದ ಬೆಳವಣಿಗೆಯ ಮನೆಗಳಲ್ಲಿ ಶುಭಫಲಗಳು - ಸಂಪತ್ತು ಸಂಗ್ರಹವಾಗುವುದು ಮತ್ತು ಸಂಪನ್ಮೂಲಗಳು ಹೆಚ್ಚಾಗುವುದು.';

  @override
  String get yogaKalanidhiName => 'ಕಲಾನಿಧಿ ಯೋಗ';

  @override
  String get yogaKalanidhiMeaning =>
      '2 ಅಥವಾ 5 ನೇ ಮನೆಯಲ್ಲಿ ಗುರು ಬುಧ ಅಥವಾ ಶುಕ್ರನೊಂದಿಗೆ ಸಂಬಂಧ ಹೊಂದಿದ್ದಾನೆ - ಕಲಿಕೆ, ಕಲೆಗಳು, ಸುಧಾರಣೆ ಮತ್ತು ಗೌರವ.';

  @override
  String get yogaChamaraName => 'ಚಾಮರ ಯೋಗ';

  @override
  String get yogaChamaraMeaning =>
      'ಗುರುವಿನ ದೃಷ್ಟಿಯಲ್ಲಿರುವ ಕೇಂದ್ರದಲ್ಲಿ ಲಗ್ನಾಧಿಪತಿ ಉತ್ತುಂಗಕ್ಕೇರಿದ್ದಾನೆ - ವಾಗ್ಮಿತೆ, ದೀರ್ಘಾಯುಷ್ಯ ಮತ್ತು ಗೌರವಾನ್ವಿತ ಸ್ಥಾನ.';

  @override
  String get yogaShankhaName => 'ಶಂಖ ಯೋಗ';

  @override
  String get yogaShankhaMeaning =>
      '5 ನೇ ಮತ್ತು 6 ನೇ ಅಧಿಪತಿಗಳು ಬಲವಾದ ಲಗ್ನಾಧಿಪತಿಯೊಂದಿಗೆ ಸಂಬಂಧ ಹೊಂದಿದ್ದಾರೆ - ಉತ್ತಮ ಜೀವನ, ದಯೆಯ ಸ್ವಭಾವ ಮತ್ತು ನಂತರದ ವರ್ಷಗಳಲ್ಲಿ ಸೌಕರ್ಯ.';

  @override
  String get yogaParvataName => 'ಪರ್ವತ ಯೋಗ';

  @override
  String get yogaParvataMeaning =>
      '6 ನೇ ಮತ್ತು 8 ನೇ ವಾಸಸ್ಥಾನವು ಶುದ್ಧವಾಗಿರುವ ಕೇಂದ್ರಗಳಲ್ಲಿ ಲಾಭಕಾರರು - ಅದೃಷ್ಟ, ಔದಾರ್ಯ ಮತ್ತು ಶ್ರೇಷ್ಠ ಹೆಸರು.';

  @override
  String get yogaHarshaName => 'ಹರ್ಷ ಯೋಗಾ';

  @override
  String get yogaHarshaMeaning =>
      'ಕಠಿಣ ಮನೆಯಲ್ಲಿ 6 ನೇ ಅಧಿಪತಿ - ಶತ್ರುಗಳು, ಸಾಲಗಳು ಮತ್ತು ಅನಾರೋಗ್ಯವು ತಮ್ಮ ಹಿಡಿತವನ್ನು ಕಳೆದುಕೊಳ್ಳುತ್ತದೆ; ಸ್ಪರ್ಧಾತ್ಮಕ ಶಕ್ತಿ.';

  @override
  String get yogaSaralaName => 'ಸರಳಾ ಯೋಗಾ';

  @override
  String get yogaSaralaMeaning =>
      'ಕಠಿಣ ಮನೆಯಲ್ಲಿ 8 ನೇ ಅಧಿಪತಿ - ಬಿಕ್ಕಟ್ಟುಗಳ ಮೂಲಕ ಸ್ಥಿತಿಸ್ಥಾಪಕತ್ವ, ದೀರ್ಘಾಯುಷ್ಯ ಮತ್ತು ನಿರ್ಭಯತೆ.';

  @override
  String get yogaVimalaName => 'ವಿಮಲ ಯೋಗ';

  @override
  String get yogaVimalaMeaning =>
      'ಕಠಿಣ ಮನೆಯಲ್ಲಿ 12 ನೇ ಅಧಿಪತಿ — ನಿಯಂತ್ರಿತ ಖರ್ಚು, ಶುದ್ಧ ಮನಸ್ಸಾಕ್ಷಿ ಮತ್ತು ಸ್ವತಂತ್ರ ಜೀವನ.';

  @override
  String get yogaMahaParivartanaName => 'ಮಹಾ ಪರಿವರ್ತನಾ ಯೋಗ';

  @override
  String get yogaMahaParivartanaMeaning =>
      'ಒಳ್ಳೆಯ ಮನೆಗಳ ಇಬ್ಬರು ಅಧಿಪತಿಗಳು ಚಿಹ್ನೆಗಳನ್ನು ವಿನಿಮಯ ಮಾಡಿಕೊಳ್ಳುತ್ತಾರೆ - ಎರಡೂ ಮನೆಗಳ ವ್ಯವಹಾರಗಳು ಕಾಲಾನಂತರದಲ್ಲಿ ಪರಸ್ಪರ ಎತ್ತುತ್ತವೆ.';

  @override
  String get yogaKhalaParivartanaName => 'ಖಲ ಪರಿವರ್ತನಾ ಯೋಗ';

  @override
  String get yogaKhalaParivartanaMeaning =>
      '3 ನೇ ಮನೆಯನ್ನು ಒಳಗೊಂಡ ವಿನಿಮಯ - ಮಿಶ್ರ ಫಲಿತಾಂಶಗಳು, ಏರಿಳಿತಗಳು, ಪ್ರಯತ್ನ ಮತ್ತು ಧೈರ್ಯದಿಂದ ಲಾಭಗಳು.';

  @override
  String get yogaDainyaParivartanaName => 'ದೈನ್ಯ ಪರಿವರ್ತನಾ ಯೋಗ';

  @override
  String get yogaDainyaParivartanaMeaning =>
      'ಕಷ್ಟಕರವಾದ ಮನೆಯನ್ನು ಒಳಗೊಂಡ ವಿನಿಮಯ - ತಾಳ್ಮೆ ಅಗತ್ಯವಿರುವ ಅಡೆತಡೆಗಳು; ಬಲವಾದ ದಶಾ ಅದನ್ನು ತಿರುಗಿಸುತ್ತದೆ.';

  @override
  String get kSignAries => 'ದಪ್ಪ, ನೇರ, ತ್ವರಿತವಾಗಿ ಪ್ರಾರಂಭಿಸಿ';

  @override
  String get kSignTaurus =>
      'ಸ್ಥಿರ, ಇಂದ್ರಿಯ, ಸೌಕರ್ಯ ಮತ್ತು ಭದ್ರತೆಯನ್ನು ಮೌಲ್ಯೀಕರಿಸುತ್ತದೆ';

  @override
  String get kSignGemini => 'ಕುತೂಹಲ, ಮಾತಿನ, ಚುರುಕಾಗಿ ಯೋಚಿಸುವ';

  @override
  String get kSignCancer => 'ಕಾಳಜಿಯುಳ್ಳ, ರಕ್ಷಣಾತ್ಮಕ, ಭಾವನೆಯಿಂದ ನಡೆಸಲ್ಪಡುವ';

  @override
  String get kSignLeo => 'ಹೆಮ್ಮೆ, ಆತ್ಮೀಯತೆ, ನೋಡಲು ಬಯಸುತ್ತೇನೆ';

  @override
  String get kSignVirgo => 'ನಿಖರ, ಉಪಯುಕ್ತ, ಸುಧಾರಣಾ ಮನೋಭಾವದ';

  @override
  String get kSignLibra => 'ನ್ಯಾಯಯುತ, ಸಂಬಂಧಾತ್ಮಕ, ಸಮತೋಲನವನ್ನು ಬಯಸುತ್ತದೆ';

  @override
  String get kSignScorpio => 'ತೀವ್ರ, ಖಾಸಗಿ, ಎಲ್ಲವೂ ಅಥವಾ ಏನೂ ಇಲ್ಲ';

  @override
  String get kSignSagittarius => 'ಸ್ವತಂತ್ರ, ನಂಬಿಕೆಯುಳ್ಳ, ದೊಡ್ಡ ಚಿತ್ರಣ';

  @override
  String get kSignCapricorn =>
      'ಶಿಸ್ತುಬದ್ಧ, ಮಹತ್ವಾಕಾಂಕ್ಷೆಯುಳ್ಳ, ದೀರ್ಘ ಆಟವನ್ನು ಆಡುವ';

  @override
  String get kSignAquarius => 'ಸ್ವತಂತ್ರ, ವ್ಯವಸ್ಥೆ-ಮನಸ್ಸಿನ, ಅಸಾಂಪ್ರದಾಯಿಕ';

  @override
  String get kSignPisces => 'ಕಲ್ಪನಾತ್ಮಕ, ಕರುಣಾಮಯ, ಮಿತಿಯಿಲ್ಲದ';

  @override
  String get kPlanetNameSun => 'Sun';

  @override
  String get kPlanetNameMoon => 'Moon';

  @override
  String get kPlanetNameMars => 'Mars';

  @override
  String get kPlanetNameMercury => 'Mercury';

  @override
  String get kPlanetNameJupiter => 'Jupiter';

  @override
  String get kPlanetNameVenus => 'Venus';

  @override
  String get kPlanetNameSaturn => 'Saturn';

  @override
  String get kPlanetNameRahu => 'Rahu';

  @override
  String get kPlanetNameKetu => 'Ketu';

  @override
  String get kPlanetSun => 'ಆತ್ಮ, ವಿಶ್ವಾಸ, ತಂದೆ, ಅಧಿಕಾರ';

  @override
  String get kPlanetMoon => 'ಮನಸ್ಸು, ಭಾವನೆಗಳು, ತಾಯಿ, ಸಾಂತ್ವನ';

  @override
  String get kPlanetMars => 'ಚಾಲನೆ, ಧೈರ್ಯ, ಕೋಪ, ಒಡಹುಟ್ಟಿದವರು';

  @override
  String get kPlanetMercury => 'ಬುದ್ಧಿಶಕ್ತಿ, ಮಾತು, ವ್ಯಾಪಾರ, ಕೌಶಲ್ಯ';

  @override
  String get kPlanetJupiter =>
      'ಬುದ್ಧಿವಂತಿಕೆ, ಬೆಳವಣಿಗೆ, ಅದೃಷ್ಟ, ಶಿಕ್ಷಕರು, ಮಕ್ಕಳು';

  @override
  String get kPlanetVenus => 'ಪ್ರೀತಿ, ಸೌಂದರ್ಯ, ಸೌಕರ್ಯ, ಪಾಲುದಾರಿಕೆ, ಕಲೆ';

  @override
  String get kPlanetSaturn => 'ಶಿಸ್ತು, ಸಮಯ, ಮಿತಿಗಳು, ಕಷ್ಟಪಟ್ಟು ಗಳಿಸಿದ ಪ್ರತಿಫಲ';

  @override
  String get kPlanetRahu => 'ಮಹತ್ವಾಕಾಂಕ್ಷೆ, ಗೀಳು, ವಿದೇಶಿ ಮತ್ತು ಹೊಸದು';

  @override
  String get kPlanetKetu =>
      'ನಿರ್ಲಿಪ್ತತೆ, ಪಾಂಡಿತ್ಯ, ಬಿಟ್ಟುಬಿಡುವುದು, ಆಧ್ಯಾತ್ಮಿಕತೆ';

  @override
  String get kHouse1 => 'ಆತ್ಮ, ದೇಹ, ಚೈತನ್ಯ';

  @override
  String get kHouse2 => 'ಸಂಪತ್ತು, ಕುಟುಂಬ, ಮಾತು, ಆಹಾರ';

  @override
  String get kHouse3 => 'ಧೈರ್ಯ, ಒಡಹುಟ್ಟಿದವರು, ಪ್ರಯತ್ನ, ಸಣ್ಣ ಪ್ರಯಾಣ';

  @override
  String get kHouse4 => 'ಮನೆ, ತಾಯಿ, ಭೂಮಿ, ಆಂತರಿಕ ಶಾಂತಿ';

  @override
  String get kHouse5 => 'ಮಕ್ಕಳು, ಶಿಕ್ಷಣ, ಸೃಜನಶೀಲತೆ, ಪ್ರಣಯ';

  @override
  String get kHouse6 => 'ಆರೋಗ್ಯ, ಸಾಲ, ಶತ್ರುಗಳು, ದೈನಂದಿನ ಕೆಲಸ';

  @override
  String get kHouse7 => 'ಮದುವೆ, ಪಾಲುದಾರಿಕೆ, ವ್ಯವಹಾರ';

  @override
  String get kHouse8 => 'ದೀರ್ಘಾಯುಷ್ಯ, ಹಠಾತ್ ಬದಲಾವಣೆ, ಗುಪ್ತ, ಆನುವಂಶಿಕತೆ';

  @override
  String get kHouse9 => 'ಅದೃಷ್ಟ, ಧರ್ಮ, ತಂದೆ, ಉನ್ನತ ಶಿಕ್ಷಣ, ದೀರ್ಘ ಪ್ರಯಾಣ';

  @override
  String get kHouse10 => 'ವೃತ್ತಿ, ಸ್ಥಾನಮಾನ, ಸಾರ್ವಜನಿಕ ಜೀವನ';

  @override
  String get kHouse11 => 'ಆದಾಯ, ಲಾಭಗಳು, ನೆಟ್‌ವರ್ಕ್, ಅಣ್ಣ-ತಂಗಿಯರು';

  @override
  String get kHouse12 => 'ನಷ್ಟ, ಖರ್ಚುಗಳು, ವಿದೇಶಿ ಭೂಮಿ, ನಿದ್ರೆ, ಮುಕ್ತಿ';

  @override
  String get kDignityExalted => 'ಉದಾತ್ತ - ಬಹಳ ಬಲಶಾಲಿ';

  @override
  String get kDignityDebilitated => 'ದುರ್ಬಲ — ಇಲ್ಲಿ ಒತ್ತಡದಲ್ಲಿದೆ';

  @override
  String get kDignityMoolatrikona => 'ಮೂಲತ್ರಿಕೋನ — ಆರಾಮದಾಯಕ ಮತ್ತು ಬಲವಾದ';

  @override
  String get kDignityOwn => 'ಸ್ವಂತ ಚಿಹ್ನೆ — ಸ್ಥಿರ ಮತ್ತು ಪರಿಣಾಮಕಾರಿ';

  @override
  String get kDignityGreatFriend =>
      'ಉತ್ತಮ ಸ್ನೇಹಿತನ ಚಿಹ್ನೆಯಲ್ಲಿ — ಬೆಂಬಲಿತವಾಗಿದೆ';

  @override
  String get kDignityFriend => 'ಸ್ನೇಹಿತನ ಚಿಹ್ನೆಯಲ್ಲಿ — ಬೆಂಬಲಿತವಾಗಿದೆ';

  @override
  String get kDignityNeutral => 'ತಟಸ್ಥ ಚಿಹ್ನೆ';

  @override
  String get kDignityEnemy => 'ಶತ್ರುವಿನ ಚಿಹ್ನೆಯಲ್ಲಿ — ಹೆಚ್ಚು ಶ್ರಮಿಸುತ್ತದೆ';

  @override
  String get kDignityGreatEnemy => 'ದೊಡ್ಡ ಶತ್ರುವಿನ ಚಿಹ್ನೆಯಲ್ಲಿ — ಒತ್ತಡದಲ್ಲಿ';

  @override
  String get kDashaSun =>
      'ಗುರುತು, ಅಧಿಕಾರ ಮತ್ತು ಮನ್ನಣೆಗೆ ಒಂದು ಅವಧಿ. ಕಣ್ಣುಗಳು/ಹೃದಯದ ಅಹಂ ಮತ್ತು ಆರೋಗ್ಯವು ಗಮನಕ್ಕೆ ಬರುತ್ತದೆ.';

  @override
  String get kDashaMoon =>
      'ಮೃದುವಾದ, ಹೆಚ್ಚು ಭಾವನಾತ್ಮಕ ಅಧ್ಯಾಯ - ಮನೆ, ತಾಯಿ, ಮನಸ್ಥಿತಿಗಳು ಮತ್ತು ಸಾರ್ವಜನಿಕ ಜೀವನ.';

  @override
  String get kDashaMars =>
      'ಶಕ್ತಿ, ಸ್ಪರ್ಧೆ ಮತ್ತು ಉಪಕ್ರಮ ಹೆಚ್ಚಾಗುತ್ತದೆ. ಕೋಪ, ಅಪಘಾತಗಳು ಮತ್ತು ಆಸ್ತಿ ವಿಷಯಗಳಲ್ಲಿ ನಿಗಾ ಇರಿಸಿ.';

  @override
  String get kDashaMercury =>
      'ಕಲಿಕೆ, ವ್ಯಾಪಾರ, ಬರವಣಿಗೆ ಮತ್ತು ಸಂವಹನ. ಅಧ್ಯಯನ ಮತ್ತು ವ್ಯವಹಾರಕ್ಕೆ ಒಳ್ಳೆಯದು, ನಿಶ್ಚಲತೆಗೆ ಚಡಪಡಿಕೆ.';

  @override
  String get kDashaJupiter =>
      'ಬೆಳವಣಿಗೆ, ಶಿಕ್ಷಕರು, ಕುಟುಂಬ, ಅರ್ಥ. ಆಗಾಗ್ಗೆ ಅದೃಷ್ಟದ, ವಿಸ್ತಾರವಾದ ಹಂತ.';

  @override
  String get kDashaVenus =>
      'ಸಂಬಂಧಗಳು, ಸೌಕರ್ಯ, ಕಲೆ, ಹಣ ಮತ್ತು ಸಂತೋಷ. ಸಾಮಾನ್ಯವಾಗಿ ಋತುಚಕ್ರಗಳಲ್ಲಿ ಅತ್ಯಂತ ಸುಲಭವಾದದ್ದು.';

  @override
  String get kDashaSaturn =>
      'ಕಠಿಣ ಪರಿಶ್ರಮ, ಜವಾಬ್ದಾರಿ ಮತ್ತು ನಿಧಾನ, ಶಾಶ್ವತ ಫಲಿತಾಂಶಗಳು. ತಾಳ್ಮೆಗೆ ಪ್ರತಿಫಲ ನೀಡುತ್ತದೆ; ಶಾರ್ಟ್‌ಕಟ್‌ಗಳನ್ನು ಶಿಕ್ಷಿಸುತ್ತದೆ.';

  @override
  String get kDashaRahu =>
      'ಮಿತಿಯಿಲ್ಲದ ಮಹತ್ವಾಕಾಂಕ್ಷೆ - ವಿದೇಶಿ ನೆಲ, ತಂತ್ರಜ್ಞಾನ, ಹಠಾತ್ ಏರಿಕೆ ಮತ್ತು ಗೊಂದಲ.';

  @override
  String get kDashaKetu =>
      'ನಿರ್ಲಿಪ್ತತೆ, ಅಂತ್ಯಗಳು ಮತ್ತು ಆಧ್ಯಾತ್ಮಿಕ ಒಳಮುಖ ತಿರುಗುವಿಕೆ. ಭೌತಿಕ ವಸ್ತುಗಳು ಟೊಳ್ಳಾಗಿವೆ ಎಂದು ಭಾಸವಾಗುತ್ತದೆ; ಕೌಶಲ್ಯವು ಆಳವಾಗುತ್ತದೆ.';

  @override
  String get kNakAshwini => 'ತ್ವರಿತ, ಪ್ರವರ್ತಕ, ಗುಣಪಡಿಸುವುದು';

  @override
  String get kNakBharani => 'ತೀವ್ರ, ಬದಲಾವಣೆಗೆ ಜಾಗವಿದೆ, ಶಿಸ್ತುಬದ್ಧ';

  @override
  String get kNakKrittika => 'ತೀಕ್ಷ್ಣ, ಕತ್ತರಿಸುವ, ರಕ್ಷಣಾತ್ಮಕ';

  @override
  String get kNakRohini => 'ಸೃಜನಶೀಲ, ಇಂದ್ರಿಯ, ಪೋಷಣೆ, ಕಾಂತೀಯ';

  @override
  String get kNakMrigashira => 'ಹುಡುಕುವ, ಕುತೂಹಲಕಾರಿ, ಸೌಮ್ಯ';

  @override
  String get kNakArdra => 'ಬಿರುಗಾಳಿ, ಪರಿವರ್ತಕ, ಒತ್ತಡದಲ್ಲಿ ಅದ್ಭುತ';

  @override
  String get kNakPunarvasu => 'ನವೀಕರಿಸುವುದು, ಉದಾರ, ಸುರಕ್ಷತೆಗೆ ಮರಳುವುದು';

  @override
  String get kNakPushya => 'ಪೋಷಣೆ ನೀಡುವ, ಕರ್ತವ್ಯನಿಷ್ಠ, ಆಳವಾಗಿ ಬೆಂಬಲಿಸುವ';

  @override
  String get kNakAshlesha => 'ಗ್ರಹಿಸುವ, ಕಾರ್ಯತಂತ್ರದ, ಸಂಮೋಹನ';

  @override
  String get kNakMagha => 'ರಾಜಮನೆತನದ, ಸಂಪ್ರದಾಯಬದ್ಧ, ಪೂರ್ವಜ';

  @override
  String get kNakPurvaPhalguni => 'ತಮಾಷೆಯ, ಪ್ರಣಯಭರಿತ, ಮೌಲ್ಯಯುತ ವಿರಾಮ';

  @override
  String get kNakUttaraPhalguni => 'ವಿಶ್ವಾಸಾರ್ಹ, ಒಪ್ಪಂದದ, ಸಹಾಯಕ';

  @override
  String get kNakHasta => 'ಕೈಗಳಲ್ಲಿ ನೈಪುಣ್ಯ, ಚತುರ, ಗುಣಪಡಿಸುವ';

  @override
  String get kNakChitra =>
      'ಕಲಾತ್ಮಕ, ಆಕರ್ಷಕ, ಸುಂದರವಾದ ವಸ್ತುಗಳನ್ನು ನಿರ್ಮಿಸುತ್ತದೆ';

  @override
  String get kNakSwati => 'ಸ್ವತಂತ್ರ, ಹೊಂದಿಕೊಳ್ಳುವ, ಸ್ವಾತಂತ್ರ್ಯ ಪ್ರಿಯ';

  @override
  String get kNakVishakha => 'ಗುರಿ-ಚಾಲಿತ, ದೃಢನಿಶ್ಚಯ, ದ್ವಂದ್ವ ಸ್ವಭಾವದ';

  @override
  String get kNakAnuradha =>
      'ಶ್ರದ್ಧೆಯುಳ್ಳ, ಸ್ನೇಹಪರ, ವಿದೇಶದಲ್ಲಿ ಅಭಿವೃದ್ಧಿ ಹೊಂದುತ್ತಾನೆ';

  @override
  String get kNakJyeshtha => 'ಹಿರಿಯ, ಜವಾಬ್ದಾರಿಯುತ, ಹೊರೆಗಳನ್ನು ಹೊತ್ತವನು';

  @override
  String get kNakMula => 'ಬೇರು ಹುಡುಕುವ, ಮೂಲಭೂತ, ಮೂಲಕ್ಕೆ ಹೋಗುತ್ತದೆ';

  @override
  String get kNakPurvaAshadha => 'ಅಜೇಯ ಚೈತನ್ಯ, ಮನವೊಲಿಸುವ';

  @override
  String get kNakUttaraAshadha => 'ತತ್ವಬದ್ಧ, ಶಾಶ್ವತ, ನಂತರದ ಯಶಸ್ಸು';

  @override
  String get kNakShravana => 'ಆಲಿಸುವುದು, ಕಲಿಯುವುದು, ಜನರನ್ನು ಸಂಪರ್ಕಿಸುವುದು';

  @override
  String get kNakDhanishta => 'ಲಯಬದ್ಧ, ಶ್ರೀಮಂತ, ಸಂಗೀತಮಯ, ಹೊಂದಿಕೊಳ್ಳುವ';

  @override
  String get kNakShatabhisha => 'ಖಾಸಗಿ, ಗುಣಪಡಿಸುವಿಕೆ, ವ್ಯವಸ್ಥೆ-ಮನಸ್ಸಿನ';

  @override
  String get kNakPurvaBhadrapada => 'ಆದರ್ಶವಾದಿ, ತೀವ್ರ, ಪರಿವರ್ತಕ';

  @override
  String get kNakUttaraBhadrapada => 'ಆಳವಾದ, ಶಾಂತ, ಬುದ್ಧಿವಂತ ಸಲಹೆ';

  @override
  String get kNakRevati => 'ದಯಾಳು, ಪ್ರಯಾಣಿಕರನ್ನು ರಕ್ಷಿಸುವ, ಕಲ್ಪನಾಶೀಲ';

  @override
  String get kSadeSatiRising =>
      'ಉದಯ ಹಂತ — ಶನಿಯು ನಿಮ್ಮ ಚಂದ್ರನಿಂದ 12 ನೇ ರಾಶಿಯಲ್ಲಿದ್ದಾನೆ. ಅಂತ್ಯಗಳು, ಆಯಾಸ ಮತ್ತು ಕೆಲಸಗಳು ಮುಗಿಯುತ್ತಿವೆ ಎಂಬ ಭಾವನೆ. ಇನ್ನು ಮುಂದೆ ಕೆಲಸ ಮಾಡದಿರುವುದನ್ನು ತೆರವುಗೊಳಿಸಲು ಪ್ರಾರಂಭಿಸಿ.';

  @override
  String get kSadeSatiPeak =>
      'ಗರಿಷ್ಠ ಹಂತ — ಶನಿಯು ನಿಮ್ಮ ಚಂದ್ರ ರಾಶಿಯ ಮೇಲೆ ನಿಂತಿದ್ದಾನೆ. ಅತ್ಯಂತ ಭಾರವಾದ ಹಂತ: ಜವಾಬ್ದಾರಿ, ಒತ್ತಡ ಮತ್ತು ನಿಧಾನಗತಿಯ ಪ್ರಗತಿ. ದಿನಚರಿಗಳನ್ನು ಕಾಪಾಡಿಕೊಳ್ಳಿ, ನಿಮ್ಮ ಆರೋಗ್ಯವನ್ನು ರಕ್ಷಿಸಿ.';

  @override
  String get kSadeSatiSetting =>
      'ಸೆಟ್ಟಿಂಗ್ ಹಂತ — ಶನಿಯು ನಿಮ್ಮ ಚಂದ್ರನಿಂದ ಎರಡನೇ ರಾಶಿಯಲ್ಲಿದ್ದಾನೆ. ತೂಕ ಹೆಚ್ಚಾಗುತ್ತದೆ. ಹಣ ಮತ್ತು ಕುಟುಂಬ ಸ್ಥಿರಗೊಳ್ಳುತ್ತದೆ; ಕಳೆದ ವರ್ಷಗಳ ಪಾಠಗಳು ಫಲ ನೀಡಲು ಪ್ರಾರಂಭಿಸುತ್ತವೆ.';

  @override
  String get kSadeSatiGeneric =>
      'ಶನಿಯು ನಿಮ್ಮ ಚಂದ್ರನ ಸುತ್ತ ರಾಶಿಗಳಲ್ಲಿ ಸಾಗುತ್ತಿದೆ.';

  @override
  String kPlanetInSignHouse(
    Object planet,
    Object sign,
    Object signTrait,
    Object house,
    Object houseTheme,
  ) {
    return '$sign ಯಲ್ಲಿರುವ ನಿಮ್ಮ $planet ವು ನಿಮ್ಮನ್ನು $signTrait ಮಾಡುತ್ತದೆ. $house ಮನೆಯಲ್ಲಿ ಅದು $houseTheme ಅನ್ನು ಮುಟ್ಟುತ್ತದೆ.';
  }

  @override
  String kPlanetInSign(Object planet, Object sign, Object signTrait) {
    return 'Your $planet in $sign makes you $signTrait.';
  }

  @override
  String get kHouseSans1 => 'ತನು ಭವ';

  @override
  String get kHouseSans2 => 'ಧನ ಭವ';

  @override
  String get kHouseSans3 => 'ಸಹಜ ಭವ';

  @override
  String get kHouseSans4 => 'ಸುಖ ಭವ';

  @override
  String get kHouseSans5 => 'ಪುತ್ರ ಭವ';

  @override
  String get kHouseSans6 => 'ರಿಪು ಭವ';

  @override
  String get kHouseSans7 => 'ಯುವತಿ ಭವ';

  @override
  String get kHouseSans8 => 'ಆಯು / ರಂಧ್ರ ಭವ';

  @override
  String get kHouseSans9 => 'ಧರ್ಮ ಭವ';

  @override
  String get kHouseSans10 => 'ಕರ್ಮ ಭವ';

  @override
  String get kHouseSans11 => 'ಲಾಭ ಭವ';

  @override
  String get kHouseSans12 => 'ವ್ಯಯ ಭವ';

  @override
  String kHouseTitleWithSign(Object sign, Object theme) {
    return '$sign · $theme';
  }

  @override
  String kHouseSheetTitle(Object ordinal, Object sign) {
    return '$ordinal ಮನೆ · $sign';
  }

  @override
  String kHouseSheetSubtitle(Object sanskrit, Object theme) {
    return '$sanskrit — $theme';
  }

  @override
  String kHouseChipLord(Object lord) {
    return 'ಮನೆಯ ಒಡೆಯ · $lord';
  }

  @override
  String kHouseChipLordIn(Object nthHouse) {
    return '$nthHouse ನಲ್ಲಿ ಭಗವಂತ';
  }

  @override
  String kHouseNoPlanets(Object lord, Object lordWhere) {
    return 'ಈ ಮನೆಯಲ್ಲಿ ಯಾವುದೇ ಗ್ರಹಗಳು ಕುಳಿತುಕೊಳ್ಳುವುದಿಲ್ಲ. ಇದರ ಕಥೆಯನ್ನು ಮುಖ್ಯವಾಗಿ ಅದರ ಅಧಿಪತಿ, $lord $lordWhere ಹೇಳುತ್ತಾನೆ.';
  }

  @override
  String kHouseLordWhere(Object nthHouse) {
    return ', ಈಗ $nthHouse ನಲ್ಲಿದೆ';
  }

  @override
  String get kHousePlanetsHeader => 'ಈ ಮನೆಯಲ್ಲಿರುವ ಗ್ರಹಗಳು';

  @override
  String kHouseAskCta(Object ordinal) {
    return 'ನಿಮ್ಮ ಮನೆಯ ಬಗ್ಗೆ $ordinal ಕೇಳಿ';
  }

  @override
  String kHouseReadingLord(
    Object ordinal,
    Object lord,
    Object nthHouse,
    Object theme,
    Object lordTheme,
  ) {
    return 'ನಿಮ್ಮ $ordinal -ಮನೆಯ ಅಧಿಪತಿ $lord $nthHouse ನಲ್ಲಿ ಕುಳಿತುಕೊಳ್ಳುತ್ತಾರೆ, ಆದ್ದರಿಂದ $theme $lordTheme ಗೆ ಸಂಪರ್ಕಿಸುತ್ತದೆ.';
  }

  @override
  String kHouseReadingOccupant(
    Object planet,
    Object planetTheme,
    Object theme,
  ) {
    return '$planet ಇಲ್ಲಿ ತನ್ನ ಥೀಮ್‌ಗಳನ್ನು — $planetTheme — $theme ಗೆ ತರುತ್ತದೆ.';
  }

  @override
  String get kHouseReadingEmpty =>
      'ಈ ಮನೆಯನ್ನು ಅದರ ಅಧಿಪತಿ ಮತ್ತು ಅದನ್ನು ನೋಡುವ ಗ್ರಹಗಳ ಮೂಲಕ ಓದಲಾಗುತ್ತದೆ. ಒಬ್ಬ ಜ್ಯೋತಿಷಿ ನಿಮಗೆ ಅದರ ಮೂಲಕ ಮಾರ್ಗದರ್ಶನ ನೀಡಬಹುದು.';

  @override
  String kBhavaSubheadKaraka(Object karaka) {
    return 'ಕರಕ $karaka';
  }

  @override
  String kBhavaSubheadLord(Object lord, Object nthHouse) {
    return 'ಲಾರ್ಡ್ $lord , $nthHouse';
  }

  @override
  String kBhavaSubheadLordOnly(Object lord) {
    return 'ಪ್ರಭು $lord';
  }

  @override
  String kBhavaReadingGoverns(Object theme) {
    return 'ಈ ಮನೆ $theme ಅನ್ನು ನಿಯಂತ್ರಿಸುತ್ತದೆ.';
  }

  @override
  String kBhavaReadingLord(
    Object lord,
    Object nthHouse,
    Object theme,
    Object lordTheme,
    Object dignity,
    Object occupants,
  ) {
    return 'ಇದರ ಅಧಿಪತಿ $lord $nthHouse ನಲ್ಲಿದ್ದಾರೆ, ಆದ್ದರಿಂದ $theme $lordTheme ಗೆ ಸಂಪರ್ಕಿಸುತ್ತದೆ. $dignity $occupants';
  }

  @override
  String kBhavaReadingDignity(Object dignity) {
    return ' ಭಗವಂತ ಎಂದರೆ $dignity .';
  }

  @override
  String kBhavaReadingOccupants(Object planets, Object themes) {
    return ' $planets ಇಲ್ಲಿ ಕುಳಿತು, $themes ಸೇರಿಸುತ್ತಿವೆ.';
  }

  @override
  String kTransitHouseLine(Object nthHouse, Object theme) {
    return 'ನಿಮ್ಮ $nthHouse · $theme';
  }

  @override
  String kPlanetRowMeta(Object sign, Object nthHouse, Object degree) {
    return '$sign · $nthHouse · $degree °';
  }

  @override
  String kLagnaLordIn(Object nthHouse) {
    return '$nthHouse ನಲ್ಲಿ';
  }

  @override
  String get kDignityShortExalted => 'ಉನ್ನತ';

  @override
  String get kDignityShortMoolatrikona => 'ಮೂಲತ್ರಿಕೋನ';

  @override
  String get kDignityShortOwn => 'ಸ್ವಂತ';

  @override
  String get kDignityShortDebilitated => 'ದುರ್ಬಲಗೊಂಡಿದೆ';

  @override
  String get kDignityShortEnemy => 'ಶತ್ರು ಚಿಹ್ನೆ';

  @override
  String get kDignityShortGreatEnemy => 'ಮಹಾ ಶತ್ರು';

  @override
  String get kCombustNote =>
      'ದಹನ - ಸೂರ್ಯನಿಗೆ ಬಹಳ ಹತ್ತಿರದಲ್ಲಿದೆ, ಆದ್ದರಿಂದ ಅದರ ಸ್ವತಂತ್ರ ಧ್ವನಿ ಮಂದವಾಗಿರುತ್ತದೆ.';

  @override
  String get kWhatThisMeans => 'ಇದು ನಿಮಗೆ ಏನು ಅರ್ಥ ನೀಡುತ್ತದೆ';

  @override
  String get ovStrengthStrong => 'ಬಲವಾದ';

  @override
  String get ovStrengthSteady => 'ಸ್ಥಿರ';

  @override
  String get ovStrengthStrain => 'ಒತ್ತಡದಲ್ಲಿ';

  @override
  String get ovStrengthWeak => 'ದುರ್ಬಲ';

  @override
  String get ovRoleSpouse => 'ಸಂಗಾತಿಯ ಸೂಚಕ';

  @override
  String get ovRoleDarakaraka => 'ದರಕಾರಕ (ಜೈಮಿನಿ)';

  @override
  String get ovRoleWealth => 'ಸಂಪತ್ತಿನ ಸೂಚಕ';

  @override
  String get ovRoleIntellect => 'ಬುದ್ಧಿಶಕ್ತಿ ಮಹತ್ವ';

  @override
  String get ovRoleWisdom => 'ಬುದ್ಧಿವಂತಿಕೆಯ ಅರ್ಥಕಾರಕ';

  @override
  String get ovRoleFortune => 'ಅದೃಷ್ಟ ಸೂಚಕ';

  @override
  String get ovRoleFather => 'ತಂದೆಯ ಮಹತ್ವ';

  @override
  String get ovRoleMother => 'ತಾಯಿ ಸೂಚಕ';

  @override
  String get ovRoleGeneric => 'ಸೂಚಕ';

  @override
  String ovfPada(int pada) {
    return 'ಪದ $pada';
  }

  @override
  String ovfLagnaSign(Object sign) {
    return 'ಏರುತ್ತಿರುವ ಚಿಹ್ನೆ $sign';
  }

  @override
  String ovfLagnaLord(Object planet, Object nthHouse, Object dignity) {
    return '$nthHouse $dignity ಯಲ್ಲಿ ಲಗ್ನ ಅಧಿಪತಿ $planet';
  }

  @override
  String ovfHouseLord(Object ordinal, Object planet, Object nthHouse) {
    return '$nthHouse ನಲ್ಲಿ $ordinal -ಮನೆಯ ಅಧಿಪತಿ $planet';
  }

  @override
  String ovfHouseStrength(Object ordinal, Object strength) {
    return '$ordinal ಮನೆ — $strength';
  }

  @override
  String ovfMoonSign(Object sign) {
    return '$sign ಯಲ್ಲಿ ಚಂದ್ರ';
  }

  @override
  String ovfMoonHouse(Object nthHouse) {
    return '$nthHouse ನಲ್ಲಿ ಚಂದ್ರ';
  }

  @override
  String ovfMoonNakshatra(Object nakshatra) {
    return 'ಚಂದ್ರ ನಕ್ಷತ್ರ $nakshatra';
  }

  @override
  String ovfMoonDignity(Object dignity) {
    return 'ಚಂದ್ರ $dignity';
  }

  @override
  String ovfSunSign(Object sign) {
    return 'ಸೂರ್ಯ $sign ಯಲ್ಲಿ';
  }

  @override
  String ovfSeventhSign(Object sign) {
    return '$sign ಯಲ್ಲಿ 7 ನೇ ಮನೆ';
  }

  @override
  String ovfPlanetInHouse(Object planet, Object nthHouse) {
    return '$planet in the $nthHouse';
  }

  @override
  String ovfPlanetWithMoon(Object planet) {
    return 'ಚಂದ್ರನೊಂದಿಗೆ $planet';
  }

  @override
  String ovfAppearanceIn(Object planet) {
    return '1 ನೇ ಮನೆಯಲ್ಲಿ $planet';
  }

  @override
  String ovfAppearanceAspect(Object planet) {
    return '$planet 1 ನೇ ಮನೆಯ ದೃಷ್ಟಿಕೋನವನ್ನು ಹೊಂದಿದೆ';
  }

  @override
  String ovfMaleficOnLagna(Object planet) {
    return '$planet ಆರೋಹಣ ನಕ್ಷತ್ರದ ಮೇಲೆ ಒತ್ತುತ್ತಿದೆ';
  }

  @override
  String ovfKaraka(Object role, Object planet) {
    return '$role : $planet';
  }

  @override
  String ovfYoga(Object name) {
    return 'ಯೋಗ — $name';
  }

  @override
  String ovfDosha(Object name) {
    return 'ದೋಶ — $name';
  }

  @override
  String get doshaMangalName => 'ಮಂಗಲ್ ದೋಷ';

  @override
  String get doshaMangalMeaning =>
      'ಸೂಕ್ಷ್ಮ ಮನೆಯಲ್ಲಿ ಮಂಗಳ - ಸಾಂಪ್ರದಾಯಿಕವಾಗಿ ಮದುವೆಗೆ ಮೊದಲು ತೂಕ ಇಡಲಾಗುತ್ತದೆ. ಇಬ್ಬರೂ ಪಾಲುದಾರರು ಮಂಗಳ ಗ್ರಹದ ಮೇಲೆ ಪ್ರಭಾವ ಬೀರಿದಾಗ ಅಥವಾ ಗುರು ಗ್ರಹದ ಪ್ರಭಾವದಡಿಯಲ್ಲಿದ್ದಾಗ ಹೆಚ್ಚಾಗಿ ಸಮತೋಲನದಲ್ಲಿರುತ್ತಾರೆ.';

  @override
  String get doshaKaalSarpaName => 'ಕಾಲ ಸರ್ಪ ದೋಷ';

  @override
  String get doshaKaalSarpaMeaning =>
      'ರಾಹು ಮತ್ತು ಕೇತುವಿನ ನಡುವೆ ನಡೆಯುವ ಇಡೀ ನಕ್ಷೆ - ಸ್ಪಷ್ಟ ನಿರ್ದೇಶನ ದೊರೆಯುವವರೆಗೆ ಜೀವನವು ಸೀಮಿತವಾಗಿರುತ್ತದೆ, ನಂತರ ಗಮನವು ತೀವ್ರವಾಗುತ್ತದೆ.';

  @override
  String get doshaPitraName => 'ಪಿತ್ರ ದೋಷ';

  @override
  String get doshaPitraMeaning =>
      'ಸೂರ್ಯ ಮತ್ತು 9 ನೇ ಮನೆಯು ಪೂರ್ವಜರ ಕರ್ಮದ ನೆರಳನ್ನು ಹೊಂದಿರುತ್ತದೆ - ಇದನ್ನು ಹೆಚ್ಚಾಗಿ ತಂದೆಯ ಹೆಸರಿನಲ್ಲಿ ಶ್ರದ್ಧೆ ಮತ್ತು ದಾನದಿಂದ ಸಂಬೋಧಿಸಲಾಗುತ್ತದೆ.';

  @override
  String get doshaGandmoolName => 'ಗಂಡಮೂಲ ದೋಸೆ';

  @override
  String get doshaGandmoolMeaning =>
      'ಚಂದ್ರನು ಜಂಕ್ಷನ್ ನಕ್ಷತ್ರದಲ್ಲಿ ಕುಳಿತುಕೊಳ್ಳುತ್ತಾನೆ. 27 ನೇ ದಿನದಂದು ಶಾಂತಿ ಪೂಜೆ ಮಾಡುವುದು ಸಾಂಪ್ರದಾಯಿಕ ಪ್ರತಿಕ್ರಿಯೆಯಾಗಿದೆ.';

  @override
  String get doshaGrahanName => 'ಗ್ರಹಣ ದೋಷ';

  @override
  String get doshaGrahanMeaning =>
      'ಒಂದು ಜ್ಯೋತಿಷಿ (ಸೂರ್ಯ ಅಥವಾ ಚಂದ್ರ) ಒಂದು ನೋಡ್‌ನೊಂದಿಗೆ ಕುಳಿತುಕೊಳ್ಳುತ್ತಾನೆ, ಆದ್ದರಿಂದ ಆ ಗ್ರಹದ ಮಹತ್ವಗಳು ಅದರ ಮೇಲೆ ಕೆಲಸ ಮಾಡುವವರೆಗೆ ಮಂದವಾಗಿರುತ್ತವೆ.';

  @override
  String get doshaShrapitName => 'ಶ್ರಪಿತ್ ದೋಷ';

  @override
  String get doshaShrapitMeaning =>
      'ರಾಹು ಜೊತೆ ಶನಿ - ಆರಂಭದಲ್ಲಿ ವಿಳಂಬ ಮತ್ತು ಗೊಂದಲ; ಸ್ಥಿರ, ತಾಳ್ಮೆಯ ಪ್ರಯತ್ನವೇ ದಾರಿ.';

  @override
  String get doshaGuruChandalName => 'ಗುರು ಚಂದಲ್ ದೋಷ';

  @override
  String get doshaGuruChandalMeaning =>
      'ನೋಡ್ ಹೊಂದಿರುವ ಗುರು - ಅಸಾಂಪ್ರದಾಯಿಕ ವಿಚಾರಗಳೊಂದಿಗೆ ಬೆರೆತ ಬುದ್ಧಿವಂತಿಕೆ; ನಿಮ್ಮ ಶಿಕ್ಷಕರು ಮತ್ತು ನಂಬಿಕೆಗಳನ್ನು ಎಚ್ಚರಿಕೆಯಿಂದ ಆರಿಸಿ.';

  @override
  String get doshaAngarakName => 'ಅಂಗಾರಕ ದೋಸೆ';

  @override
  String get doshaAngarakMeaning =>
      'ನೋಡ್ ಹೊಂದಿರುವ ಮಂಗಳ - ಹಠಾತ್ ಪ್ರವೃತ್ತಿಯ ಆವೇಶ; ಕೋಪ, ಅಪಘಾತಗಳು ಮತ್ತು ಆಸ್ತಿ ವಿವಾದಗಳಿಗೆ ಎಚ್ಚರಿಕೆಯ ಅಗತ್ಯವಿದೆ.';

  @override
  String get doshaKemadrumaName => 'ಕೇಮದ್ರುಮ ದೋಷ';

  @override
  String get doshaKemadrumaMeaning =>
      'ಚಂದ್ರನು ತನ್ನ ಸುತ್ತಲೂ ಯಾವುದೇ ಆಧಾರವಿಲ್ಲದೆ ಏಕಾಂಗಿಯಾಗಿ ನಿಲ್ಲುತ್ತಾನೆ - ಒಂದು ಕೇಂದ್ರವು ಆಕ್ರಮಿಸಿಕೊಂಡಾಗ ಅಥವಾ ಚಂದ್ರನು ಬಲವಾಗಿದ್ದಾಗ ಅದು ಸಡಿಲಗೊಳ್ಳುತ್ತದೆ.';

  @override
  String get doshaDaridraName => 'ದರಿದ್ರ ದೋಷ';

  @override
  String get doshaDaridraMeaning =>
      'ಹಣದ ಮನೆಗಳು ಸಂಕಷ್ಟದಲ್ಲಿವೆ - ಶಿಸ್ತುಬದ್ಧ ಉಳಿತಾಯ ಮತ್ತು ಬಲವಾದ ದಶಾ ಅದನ್ನು ತಿರುಗಿಸುತ್ತದೆ.';

  @override
  String get birthDetailsCta => 'ಜನನದ ಸಂಪೂರ್ಣ ವಿವರಗಳು';

  @override
  String get birthDetailsTitle => 'ಜನನ ವಿವರಗಳು';

  @override
  String get birthDetailsAyanamsa => 'ಅಯನಾಂಶ';

  @override
  String get birthDetailsPanchangTitle => 'ಹುಟ್ಟಿದಾಗ ಪಂಚಾಂಗ';

  @override
  String get birthDetailsChakraTitle => 'ಅವಕಾಹಡ ಚಕ್ರ';

  @override
  String get birthDetailsWeekday => 'ವಾರದ ದಿನ';

  @override
  String get birthDetailsTithi => 'ತಿಥಿ';

  @override
  String get birthDetailsNakshatra => 'ನಕ್ಷತ್ರ';

  @override
  String get birthDetailsYoga => 'ಯೋಗ';

  @override
  String get birthDetailsKarana => 'ಕರಣ';

  @override
  String get birthDetailsMoonSign => 'ಚಂದ್ರ ರಾಶಿ';

  @override
  String get birthDetailsSunSign => 'ಸೂರ್ಯ ರಾಶಿ';

  @override
  String get birthDetailsSuryaNakshatra => 'ಸೂರ್ಯನ ನಕ್ಷತ್ರ';

  @override
  String get birthDetailsSunrise => 'ಸೂರ್ಯೋದಯ';

  @override
  String get birthDetailsSunset => 'ಸೂರ್ಯಾಸ್ತ';

  @override
  String get birthDetailsIshtaKala => 'ಇಷ್ಟ ಕಲಾ';

  @override
  String birthDetailsPada(int count) {
    return 'ಪದ $count';
  }

  @override
  String birthDetailsGhatiPala(int ghati, int pala, int vipala) {
    return '$ghati ಘಾಟಿ $pala ಪಲಾ $vipala ವಿಪಾಲ';
  }

  @override
  String get birthDetailsNakshatraLord => 'ನಕ್ಷತ್ರ ಅಧಿಪತಿ';

  @override
  String get birthDetailsRashiLord => 'ರಾಶಿ ಅಧಿಪತಿ';

  @override
  String get birthDetailsVarna => 'ವರ್ಣ';

  @override
  String get birthDetailsVashya => 'ವಶ್ಯ';

  @override
  String get birthDetailsYoni => 'ಯೋನಿ';

  @override
  String get birthDetailsGana => 'ಗಣ';

  @override
  String get birthDetailsNadi => 'ನಾಡಿ';

  @override
  String get birthDetailsTara => 'ತಾರಾ';

  @override
  String get birthDetailsTattva => 'ತತ್ವ';

  @override
  String get birthDetailsYunja => 'ಯುಂಜಾ';

  @override
  String get birthDetailsRashiPaya => 'ರಾಶಿ ಪಾಯ';

  @override
  String get birthDetailsNakshatraPaya => 'ನಕ್ಷತ್ರ ಪಾಯ';

  @override
  String get birthDetailsDisclaimer =>
      'ಶಾಸ್ತ್ರೀಯ ವರ್ಗೀಕರಣದ ಗುಣಲಕ್ಷಣಗಳು - ಮುಖ್ಯವಾಗಿ ಮುಹೂರ್ತ ಮತ್ತು ಮದುವೆಯ ಸಮಯದಲ್ಲಿ ಬಳಸಲಾಗುತ್ತದೆ, ಭವಿಷ್ಯವಾಣಿಗಳಲ್ಲ.';

  @override
  String get vaaraMonday => 'ಸೋಮವಾರ (ಸೋಮವಾರ)';

  @override
  String get vaaraTuesday => 'ಮಂಗಳವಾರ (ಮಂಗಳವಾರ)';

  @override
  String get vaaraWednesday => 'ಬುಧ್ವರ (ಬುಧವಾರ)';

  @override
  String get vaaraThursday => 'ಗುರುವಾರ (ಗುರುವಾರ)';

  @override
  String get vaaraFriday => 'ಶುಕ್ರವಾರ (ಶುಕ್ರವಾರ)';

  @override
  String get vaaraSaturday => 'ಶನಿವಾರ (ಶನಿವಾರ)';

  @override
  String get vaaraSunday => 'ರವಿವಾರ (ಭಾನುವಾರ)';

  @override
  String get tattvaFire => 'ಅಗ್ನಿ (ಬೆಂಕಿ)';

  @override
  String get tattvaEarth => 'ಪೃಥ್ವಿ (ಭೂಮಿ)';

  @override
  String get tattvaAir => 'ವಾಯು (ಗಾಳಿ)';

  @override
  String get tattvaWater => 'ಜಲ (ನೀರು)';

  @override
  String get payaGold => 'ಚಿನ್ನ';

  @override
  String get payaSilver => 'ಅರ್ಜೆಂಟ';

  @override
  String get payaCopper => 'ತಾಮ್ರ';

  @override
  String get payaIron => 'ಕಬ್ಬಿಣ';

  @override
  String get roomAppBarTitle => 'ಸಮಾಲೋಚನೆ';

  @override
  String get roomOpenError => 'ನಮಗೆ ಈ ಸಮಾಲೋಚನೆಯನ್ನು ತೆರೆಯಲು ಸಾಧ್ಯವಾಗಲಿಲ್ಲ.';

  @override
  String roomWaitingTitle(String name) {
    return '$name ಸ್ವೀಕರಿಸಲು ಕಾಯಲಾಗುತ್ತಿದೆ';
  }

  @override
  String get roomWaitingBody =>
      'ಸಾಮಾನ್ಯವಾಗಿ ಒಂದು ನಿಮಿಷಕ್ಕಿಂತ ಕಡಿಮೆ ಸಮಯ ತೆಗೆದುಕೊಳ್ಳುತ್ತದೆ. ಅವರು ಸೇರಿದ ಕ್ಷಣ ನಾವು ಚಾಟ್ ತೆರೆಯುತ್ತೇವೆ.';

  @override
  String get roomCancelRequest => 'ವಿನಂತಿಯನ್ನು ರದ್ದುಮಾಡಿ';

  @override
  String get roomEndConfirmTitle => 'ಈ ಸಮಾಲೋಚನೆಯನ್ನು ಕೊನೆಗೊಳಿಸುವುದೇ?';

  @override
  String get roomEndConfirmBody => 'ಅವಧಿ ಮುಗಿದಾಗ ಬಿಲ್ಲಿಂಗ್ ನಿಲ್ಲುತ್ತದೆ.';

  @override
  String get roomKeepTalking => 'ಮಾತನಾಡುತ್ತಲೇ ಇರಿ';

  @override
  String get roomEnd => 'ಅಂತ್ಯ';

  @override
  String get roomAutoTranslateOn => 'ಸ್ವಯಂ-ಅನುವಾದ ಆನ್ ಆಗಿದೆ';

  @override
  String get roomAutoTranslateOff => 'ಸ್ವಯಂ-ಅನುವಾದ ಆಫ್ ಆಗಿದೆ';

  @override
  String get roomEndedTitle => 'ಸಮಾಲೋಚನೆ ಕೊನೆಗೊಂಡಿದೆ';

  @override
  String get roomBalanceOutTitle => 'ನಿಮ್ಮ ಬ್ಯಾಲೆನ್ಸ್ ಖಾಲಿಯಾಗಿದೆ.';

  @override
  String roomBalanceOutBody(String name) {
    return 'ನಿಮ್ಮ ವಾಲೆಟ್ ಬ್ಯಾಲೆನ್ಸ್ ಮುಗಿದ ಕಾರಣ ಚಾಟ್ ಕೊನೆಗೊಂಡಿತು. ರೀಚಾರ್ಜ್ ಮಾಡಿ ಮತ್ತು $name ನೊಂದಿಗೆ ಮುಂದುವರಿಸಲು ಮತ್ತೆ ಪ್ರಾರಂಭಿಸಿ.';
  }

  @override
  String get roomRechargeWallet => 'ರೀಚಾರ್ಜ್ ವಾಲೆಟ್';

  @override
  String roomStartAgain(String name) {
    return '$name ನೊಂದಿಗೆ ಮತ್ತೆ ಪ್ರಾರಂಭಿಸಿ';
  }

  @override
  String get roomRowAstrologer => 'ಜ್ಯೋತಿಷಿ';

  @override
  String get roomRowDuration => 'ಅವಧಿ';

  @override
  String get roomRowAmount => 'ಮೊತ್ತ';

  @override
  String get roomRowRate => 'ದರ';

  @override
  String roomMinutes(int minutes) {
    return '$minutes ನಿಮಿಷ';
  }

  @override
  String roomRatePerMinute(String currency, String amount) {
    return '$currency $amount /ನಿಮಿಷ';
  }

  @override
  String get roomRateQuestion => 'ನಿಮ್ಮ ಸಮಾಲೋಚನೆ ಹೇಗಿತ್ತು?';

  @override
  String get roomSubmitRating => 'ರೇಟಿಂಗ್ ಸಲ್ಲಿಸಿ';

  @override
  String get roomRatingThanks => 'ಪ್ರತಿಕ್ರಿಯೆಗೆ ಧನ್ಯವಾದಗಳು!';

  @override
  String get roomBackHome => 'ಮನೆಗೆ ಹಿಂತಿರುಗಿ';

  @override
  String get roomStatusRejected =>
      'ಜ್ಯೋತಿಷಿಗೆ ಈ ವಿನಂತಿಯನ್ನು ಸ್ವೀಕರಿಸಲು ಸಾಧ್ಯವಾಗಲಿಲ್ಲ.';

  @override
  String get roomStatusCancelled => 'ವಿನಂತಿಯನ್ನು ರದ್ದುಗೊಳಿಸಲಾಗಿದೆ';

  @override
  String get roomStatusExpired =>
      'ವಿನಂತಿಯ ಅವಧಿ ಮುಗಿದಿದೆ — ಸಮಯಕ್ಕೆ ಪ್ರತಿಕ್ರಿಯೆ ಇಲ್ಲ.';

  @override
  String get roomStatusNoShow => 'ಕರೆ ಸಂಪರ್ಕಗೊಳ್ಳಲಿಲ್ಲ.';

  @override
  String get roomStatusClosed => 'ಸಮಾಲೋಚನೆ ಮುಕ್ತಾಯಗೊಂಡಿದೆ';

  @override
  String get roomBalanceRunningOut => 'ಬ್ಯಾಲೆನ್ಸ್ ಖಾಲಿಯಾಗುತ್ತಿದೆ';

  @override
  String roomMinLeftRecharge(int minutes) {
    return '~ $minutes ನಿಮಿಷಗಳು ಉಳಿದಿವೆ · ಮಾತನಾಡುತ್ತಲೇ ಇರಲು ರೀಚಾರ್ಜ್ ಮಾಡಿ';
  }

  @override
  String roomSpentMinLeft(String currency, String amount, int minutes) {
    return '$currency $amount ಖರ್ಚು ಮಾಡಲಾಗಿದೆ · ~ $minutes ನಿಮಿಷ ಉಳಿದಿದೆ';
  }

  @override
  String get roomAddMoney => 'ಹಣವನ್ನು ಸೇರಿಸಿ';

  @override
  String get roomClientBalanceLow =>
      'ಕ್ಲೈಂಟ್‌ನ ಬ್ಯಾಲೆನ್ಸ್ ಕಡಿಮೆಯಾಗಿದೆ — ಶೀಘ್ರದಲ್ಲೇ ಮುಗಿಸಿ';

  @override
  String get navChats => 'ಚಾಟ್‌ಗಳು';

  @override
  String get chatsTitle => 'ಚಾಟ್‌ಗಳು';

  @override
  String get chatsLoadError =>
      'ನಿಮ್ಮ ಚಾಟ್‌ಗಳನ್ನು ಲೋಡ್ ಮಾಡಲು ನಮಗೆ ಸಾಧ್ಯವಾಗಲಿಲ್ಲ.';

  @override
  String get chatsEmptyTitle => 'ಇನ್ನೂ ಯಾವುದೇ ಚಾಟ್‌ಗಳಿಲ್ಲ.';

  @override
  String get chatsEmptyBody =>
      'ಜ್ಯೋತಿಷಿ ಜೊತೆ ಸಮಾಲೋಚನೆ ಪ್ರಾರಂಭಿಸಿ ಮತ್ತು ಅದು ಇಲ್ಲಿ ತೋರಿಸುತ್ತದೆ.';

  @override
  String get chatsSectionActive => 'ಸಕ್ರಿಯ';

  @override
  String get chatsSectionRecent => 'ಇತ್ತೀಚಿನದು';

  @override
  String get chatsAstrologerFallback => 'ಜ್ಯೋತಿಷಿ';

  @override
  String get chatsStatusWaiting => 'ಜ್ಯೋತಿಷಿ ಸ್ವೀಕರಿಸಲು ಕಾಯುತ್ತಿದ್ದೇನೆ';

  @override
  String get chatsStatusLive => 'ಈಗ ಲೈವ್ · ತೆರೆಯಲು ಟ್ಯಾಪ್ ಮಾಡಿ';

  @override
  String chatsStatusEnded(int minutes) {
    return '$minutes ನಿಮಿಷ ಸಮಾಲೋಚನೆ';
  }

  @override
  String get chatsStatusCancelled => 'ರದ್ದುಗೊಳಿಸಲಾಗಿದೆ';

  @override
  String get chatsStatusRejected => 'ಸ್ವೀಕರಿಸಲಾಗಿಲ್ಲ';

  @override
  String get chatsStatusExpired => 'ವಿನಂತಿಯ ಅವಧಿ ಮುಗಿದಿದೆ';

  @override
  String get chatsStatusGeneric => 'ಸಮಾಲೋಚನೆ';

  @override
  String get numerologyTitle => 'ಸಂಖ್ಯಾಶಾಸ್ತ್ರ ಮತ್ತು ಲೋ ಶು ಗ್ರಿಡ್';

  @override
  String get numerologyIntro =>
      'ನಿಮ್ಮ ಜನ್ಮ ದಿನಾಂಕ (ಮತ್ತು ಹೆಸರು) ದಿಂದ ಓದುವ ಸಾಂಪ್ರದಾಯಿಕ ಸಂಖ್ಯೆಗಳು - ಪ್ರತಿಯೊಂದು ಸಂಖ್ಯೆಯು ಒಲವು ತೋರುವ ಪ್ರವೃತ್ತಿಗಳು, ಅನುಕೂಲಕರ ದಿನಗಳು ಮತ್ತು ಬಣ್ಣಗಳು ಮತ್ತು ನಿಮ್ಮ ಲೋ ಶು ಜನ್ಮ ಗ್ರಿಡ್. ಚಿಂತನೆಗಾಗಿ, ದಿನಾಂಕದ ಮುನ್ಸೂಚನೆಯಲ್ಲ.';

  @override
  String get numMoolank => 'ಮೂಲಂಕ್ · ಮಾನಸಿಕ ಸಂಖ್ಯೆ';

  @override
  String get numBhagyank => 'ಭಾಗ್ಯಂಕ್ · ವಿಧಿ ಸಂಖ್ಯೆ';

  @override
  String get numNaamank => 'ನಾಮಾನ್ಕ್ · ಹೆಸರು ಸಂಖ್ಯೆ';

  @override
  String numRuledBy(String planet) {
    return '$planet ನಿಂದ ಆಳಲ್ಪಡುತ್ತಿದೆ';
  }

  @override
  String get numFriendly => 'ಸ್ನೇಹಪರ';

  @override
  String get numNeutral => 'ತಟಸ್ಥ';

  @override
  String get numUnfriendly => 'ಘರ್ಷಣೆ';

  @override
  String get numFavDays => 'ಅನುಕೂಲಕರ ದಿನಗಳು';

  @override
  String get numFavColours => 'ಅನುಕೂಲಕರ ಬಣ್ಣಗಳು';

  @override
  String get numDirection => 'ನಿರ್ದೇಶನ';

  @override
  String get numDeity => 'ದೇವತೆ';

  @override
  String get numGemstone => 'ಸಾಂಪ್ರದಾಯಿಕ ರತ್ನ';

  @override
  String get numLoShuTitle => 'ಲೋ ಶು ಜನನ ಜಾಲ';

  @override
  String numLoShuMissing(String nums) {
    return 'ನಿಮ್ಮ ಗ್ರಿಡ್‌ನಲ್ಲಿ ಇಲ್ಲ: $nums';
  }

  @override
  String numLoShuRepeated(String nums) {
    return 'ಒತ್ತಿಹೇಳಲಾಗಿದೆ: $nums';
  }

  @override
  String get numArrowStrength => 'ಸಂಪೂರ್ಣ ಸಾಲು';

  @override
  String get numArrowAbsence => 'ಅನುಪಸ್ಥಿತಿಯ ಸಾಲು';

  @override
  String get numAskCta => 'ಇದರ ಬಗ್ಗೆ ಜ್ಯೋತಿಷಿಯೊಂದಿಗೆ ಮಾತನಾಡಿ';

  @override
  String get sadeSatiTitle => 'ಸಾಡೆ ಸತಿ ಮತ್ತು ಧೈಯಾ ಕ್ಯಾಲೆಂಡರ್';

  @override
  String sadeSatiIntro(String sign) {
    return 'ನಿಮ್ಮ ಚಂದ್ರ $sign ಲೆಕ್ಕ ಹಾಕಲಾದ ದಿನಾಂಕಿತ ಶನಿಯು ನಿಮ್ಮ ಜೀವನವನ್ನು ಆವರಿಸುತ್ತದೆ. ಸಾಡೇ ಸಾತಿಯು ಚಂದ್ರನಿಂದ 12ನೇ, 1ನೇ ಮತ್ತು 2ನೇ ಗ್ರಹದವರೆಗೆ (~7½ ವರ್ಷಗಳು) ಶನಿಯಾಗಿದೆ; ಧೈಯಾ ಗ್ರಹವು 4ನೇ ಅಥವಾ 8ನೇ (~2½ ವರ್ಷಗಳು) ಆಗಿದೆ.';
  }

  @override
  String get sadeSatiRunningNow => 'ಈಗ ಚಾಲನೆಯಲ್ಲಿದೆ';

  @override
  String get sadeSatiPast => 'ಹಿಂದಿನದು';

  @override
  String get sadeSatiUpcoming => 'ಮುಂಬರುವ';

  @override
  String get sadeSatiPhaseRising => '12ನೇ ತಾರೀಖಿನಲ್ಲಿ ಶನಿ ಉದಯ.';

  @override
  String get sadeSatiPhasePeak => 'ಚಂದ್ರನ ಮೇಲೆ ಶನಿ ಗ್ರಹದ ಶಿಖರ ·';

  @override
  String get sadeSatiPhaseSetting => 'ಸೆಟ್ಟಿಂಗ್ · 2 ನೇ ಮನೆಯಲ್ಲಿ ಶನಿ';

  @override
  String get sadeSatiPhaseKantaka => 'ಕಂಟಕ · ೪ನೇ ಮನೆಯಲ್ಲಿ ಶನಿ';

  @override
  String get sadeSatiPhaseAshtama => 'ಅಷ್ಟಮ · 8ನೇ ಮನೆಯಲ್ಲಿ ಶನಿ';

  @override
  String get sadeSatiDhaiyaHeading => 'ಧೈಯಾ (ಸಣ್ಣ ಪನೋಟಿ) ಅವಧಿಗಳು';

  @override
  String sadeSatiRange(String start, String end) {
    return '$start → $end';
  }

  @override
  String get avTransitHeading => 'ಇಂದಿನ ಸಂಚಾರದ ಅಷ್ಟಕವರ್ಗ ಬಲ';

  @override
  String get avTransitIntro =>
      'ನಿಮ್ಮ ಜನ್ಮ ಬಿಂದು ಅಂಕಗಳಿಂದ, ಪ್ರತಿಯೊಂದು ಗ್ರಹದ ಸಂಚಾರವು ಎಷ್ಟು ಮುಕ್ತವಾಗಿ ಫಲಿತಾಂಶಗಳನ್ನು ನೀಡುತ್ತದೆ. 8 ರಲ್ಲಿ 5+ ಬೆಂಬಲಿತವಾಗಿದೆ, 4 ಮಿಶ್ರವಾಗಿದೆ, ಕಡಿಮೆ ದುರ್ಬಲವಾಗಿದೆ.';

  @override
  String avTransitBindus(int bindus) {
    return '$bindus /8 ಬಿಂದುಗಳು';
  }

  @override
  String get avTransitUpcoming => 'ಬರುತ್ತಿದೆ';

  @override
  String avTransitInHouse(String planet, String house) {
    return '$planet in your $house house';
  }

  @override
  String get muhurtaTitle => 'Today\'s timing';

  @override
  String get muhurtaIntro =>
      'Choghadiya and Hora for today, worked out for your birth city and personalised to your chart\'s helpful planets. A guide to better and weaker windows for starting things — not a rule.';

  @override
  String muhurtaSunTimes(
    String sunrise,
    String sunset,
    String weekday,
    String lord,
  ) {
    return '$sunrise sunrise · $sunset sunset · $weekday ($lord)';
  }

  @override
  String get muhurtaBestWindows => 'Best windows for you today';

  @override
  String get muhurtaNoBest =>
      'No stand-out window today — pick a good Choghadiya below.';

  @override
  String get muhurtaDayChoghadiya => 'Day Choghadiya';

  @override
  String get muhurtaNightChoghadiya => 'Night Choghadiya';

  @override
  String get muhurtaHora => 'Planetary Hora';

  @override
  String get muhurtaNow => 'Now';

  @override
  String get muhurtaChoGood => 'Good';

  @override
  String get muhurtaChoBad => 'Avoid';

  @override
  String get muhurtaChoNeutral => 'Neutral';

  @override
  String get muhurtaHoraFavourable => 'Good for you';

  @override
  String get muhurtaHoraCaution => 'Keep light';

  @override
  String get upayaTitle => 'Gemstones & upaya';

  @override
  String upayaIntro(String sign) {
    return 'The classical remedy table for your ascendant ($sign) — favourable colours, days, deities, mantras and charity you can adopt freely, plus the traditional gemstone and rudraksha for each planet.';
  }

  @override
  String get upayaLagnaFavourable => 'Favourable for your ascendant';

  @override
  String get upayaColours => 'Colours';

  @override
  String get upayaDirection => 'Direction';

  @override
  String get upayaDay => 'Day';

  @override
  String get upayaDeity => 'Deity';

  @override
  String get upayaStrengthen => 'Support';

  @override
  String get upayaPacify => 'Pacify';

  @override
  String get upayaMixed => 'Mixed';

  @override
  String get upayaNeutral => 'Neutral';

  @override
  String get upayaFreeMeasures => 'Free measures';

  @override
  String get upayaMantra => 'Mantra';

  @override
  String get upayaCharity => 'Charity (daan)';

  @override
  String get upayaGemstone => 'Gemstone';

  @override
  String get upayaRudraksha => 'Rudraksha';

  @override
  String get upayaGatedCta => 'Confirm with an astrologer first';

  @override
  String get upayaPriority => 'Priority';

  @override
  String get lalKitabTitle => 'Lal Kitab — debts & remedies';

  @override
  String get lalKitabIntro =>
      'Lal Kitab reads a few inherited debts (rin) from your chart and clears each with simple, free household acts (totke). No gemstones, no cost.';

  @override
  String get lalKitabActiveDebts => 'Active debts';

  @override
  String get lalKitabNoDebts =>
      'No strongly active rin — keep the everyday duties and nothing builds up.';

  @override
  String get lalKitabWhyFlagged => 'Why it\'s flagged';

  @override
  String get lalKitabRemedy => 'Remedy (totka)';

  @override
  String get lalKitabWeakPlanets => 'Weak planet placements';

  @override
  String get lalKitabAllRemedies => 'Your remedies';

  @override
  String lalKitabPakkaGhar(String planet, String house) {
    return '$planet\'s home house is the $house';
  }

  @override
  String get varshphalTitle => 'Varshphal — this year\'s chart';

  @override
  String varshphalIntro(String age) {
    return 'The Tajika annual chart for your $age-year, cast for the moment the Sun returns to its birth position. Themes to work with — not fixed events.';
  }

  @override
  String varshphalWindow(String start, String end) {
    return '$start → $end';
  }

  @override
  String get varshphalLagna => 'Varsha Lagna';

  @override
  String get varshphalMuntha => 'Muntha';

  @override
  String get varshphalYearLord => 'Year lord (Varsheshwara)';

  @override
  String get varshphalTajika => 'Tajika aspect';

  @override
  String varshphalMunthaLine(String house, String theme) {
    return 'Muntha in the $house house — $theme';
  }

  @override
  String get varshphalChart => 'Annual chart planets';

  @override
  String get prefsTransitAlerts => 'Transit alerts';

  @override
  String get prefsTransitAlertsDesc =>
      'A heads-up when a slow planet (Jupiter, Saturn) is about to change sign into a new house in your chart.';

  @override
  String get errNetwork =>
      'ಸರ್ವರ್ ಸಂಪರ್ಕಿಸಲು ಸಾಧ್ಯವಾಗಲಿಲ್ಲ. ನಿಮ್ಮ ಸಂಪರ್ಕವನ್ನು ಪರೀಕ್ಷಿಸಿ.';

  @override
  String get errTimeout => 'ಸರ್ವರ್ ಪ್ರತಿಕ್ರಿಯಿಸಲು ಬಹಳ ಸಮಯ ತೆಗೆದುಕೊಳ್ಳುತ್ತಿದೆ.';

  @override
  String get errSession =>
      'ನಿಮ್ಮ ಸೆಷನ್ ಅವಧಿ ಮುಗಿದಿದೆ. ದಯವಿಟ್ಟು ಮತ್ತೆ ಸೈನ್ ಇನ್ ಮಾಡಿ.';

  @override
  String get errWalletInsufficient =>
      'ಇದಕ್ಕಾಗಿ ನಿಮ್ಮ ವ್ಯಾಲೆಟ್ ಬ್ಯಾಲೆನ್ಸ್ ತುಂಬಾ ಕಡಿಮೆಯಿದೆ.';

  @override
  String get errRateLimited =>
      'ಬಹಳಷ್ಟು ಪ್ರಯತ್ನಗಳು ನಡೆದಿವೆ. ದಯವಿಟ್ಟು ಸ್ವಲ್ಪ ಸಮಯ ಕಾಯ್ದು ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.';

  @override
  String get errOtpInvalid => 'ಕೋಡ್ ತಪ್ಪಾಗಿದೆ ಅಥವಾ ಅವಧಿ ಮುಗಿದಿದೆ.';

  @override
  String get errOtpMaxAttempts =>
      'ಬಹಳಷ್ಟು ತಪ್ಪು ಪ್ರಯತ್ನಗಳು. ಹೊಸ ಕೋಡ್‌ಗಾಗಿ ವಿನಂತಿಸಿ.';

  @override
  String get errPromoNotRedeemable => 'ಈ ಕೂಪನ್ ಕೋಡ್ ಬಳಸಲು ಸಾಧ್ಯವಿಲ್ಲ.';

  @override
  String get errRechargeInvalidAmount =>
      'ಅನುಮತಿಸಲಾದ ಮಿತಿಯೊಳಗೆ ಮೊತ್ತವನ್ನು ನಮೂದಿಸಿ.';

  @override
  String get errAuthWrongApp =>
      'ಈ ಸಂಖ್ಯೆಯು ಇತರ TalkAcharya ಆಪ್‌ಗಾಗಿ ನೋಂದಾಯಿಸಲಾಗಿದೆ.';

  @override
  String get errGeneric => 'ಏನೋ ತಪ್ಪಾಗಿದೆ. ದಯವಿಟ್ಟು ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.';

  @override
  String get homePanchangTitle => 'ಇಂದಿನ ಪಂಚಾಂಗ';

  @override
  String get homeLiveNowTitle => 'ಈಗ ಲೈವ್';

  @override
  String get homeFreeToolsTitle => 'ಉಚಿತ ಪರಿಕರಗಳು';

  @override
  String get homeResumeBtn => 'ಪುನರಾರಂಭ';

  @override
  String get homeAddBtn => 'ಸೇರಿಸಿ';

  @override
  String get homeNotifyMeBtn => 'ನನಗೆ ಸೂಚಿಸಿ';

  @override
  String get homeKundaliAction => 'ಕುಂಡಲಿ';

  @override
  String get homeMatchingAction => 'ಹೊಂದಾಣಿಕೆ';

  @override
  String get homeHoroscopeAction => 'ಜಾತಕ';

  @override
  String get homeVastuAction => 'ವಾಸ್ತು';

  @override
  String get homeRetryBtn => 'ಮರುಪ್ರಯತ್ನಿಸಿ';

  @override
  String get homeChooseSignTitle => 'ನಿಮ್ಮ ಚಿಹ್ನೆಯನ್ನು ಆರಿಸಿ';

  @override
  String get homeChooseLanguageTitle => 'ಭಾಷೆಯನ್ನು ಆರಿಸಿ';

  @override
  String get homeLanguageTooltip => 'ಭಾಷೆ';

  @override
  String homeLanguageSwitchError(String error) {
    return 'ಬದಲಾಯಿಸಲು ಸಾಧ್ಯವಾಗಲಿಲ್ಲ: $error';
  }

  @override
  String get homeComingSoonSnackbar => 'ಶೀಘ್ರದಲ್ಲೇ ಬರಲಿದೆ!';

  @override
  String get homeTalkAgainTitle => 'ಮತ್ತೆ ಮಾತನಾಡಿ';

  @override
  String get homeRechargeWalletTitle => 'ನಿಮ್ಮ ವ್ಯಾಲೆಟ್ ಅನ್ನು ರೀಚಾರ್ಜ್ ಮಾಡಿ';

  @override
  String get homeTalkToAstrologerTitle => 'ಜ್ಯೋತಿಷಿ ಜೊತೆ ಮಾತನಾಡಿ';

  @override
  String get kSignNameAries => 'Aries';

  @override
  String get kSignNameTaurus => 'Taurus';

  @override
  String get kSignNameGemini => 'Gemini';

  @override
  String get kSignNameCancer => 'Cancer';

  @override
  String get kSignNameLeo => 'Leo';

  @override
  String get kSignNameVirgo => 'Virgo';

  @override
  String get kSignNameLibra => 'Libra';

  @override
  String get kSignNameScorpio => 'Scorpio';

  @override
  String get kSignNameSagittarius => 'Sagittarius';

  @override
  String get kSignNameCapricorn => 'Capricorn';

  @override
  String get kSignNameAquarius => 'Aquarius';

  @override
  String get kSignNamePisces => 'Pisces';

  @override
  String get kNakNameAshwini => 'Ashwini';

  @override
  String get kNakNameBharani => 'Bharani';

  @override
  String get kNakNameKrittika => 'Krittika';

  @override
  String get kNakNameRohini => 'Rohini';

  @override
  String get kNakNameMrigashira => 'Mrigashira';

  @override
  String get kNakNameArdra => 'Ardra';

  @override
  String get kNakNamePunarvasu => 'Punarvasu';

  @override
  String get kNakNamePushya => 'Pushya';

  @override
  String get kNakNameAshlesha => 'Ashlesha';

  @override
  String get kNakNameMagha => 'Magha';

  @override
  String get kNakNamePurvaPhalguni => 'Purva Phalguni';

  @override
  String get kNakNameUttaraPhalguni => 'Uttara Phalguni';

  @override
  String get kNakNameHasta => 'Hasta';

  @override
  String get kNakNameChitra => 'Chitra';

  @override
  String get kNakNameSwati => 'Swati';

  @override
  String get kNakNameVishakha => 'Vishakha';

  @override
  String get kNakNameAnuradha => 'Anuradha';

  @override
  String get kNakNameJyeshtha => 'Jyeshtha';

  @override
  String get kNakNameMula => 'Mula';

  @override
  String get kNakNamePurvaAshadha => 'Purva Ashadha';

  @override
  String get kNakNameUttaraAshadha => 'Uttara Ashadha';

  @override
  String get kNakNameShravana => 'Shravana';

  @override
  String get kNakNameDhanishta => 'Dhanishta';

  @override
  String get kNakNameShatabhisha => 'Shatabhisha';

  @override
  String get kNakNamePurvaBhadrapada => 'Purva Bhadrapada';

  @override
  String get kNakNameUttaraBhadrapada => 'Uttara Bhadrapada';

  @override
  String get kNakNameRevati => 'Revati';

  @override
  String get kChartNameD1 => 'Rashi';

  @override
  String get kChartSigD1 => 'Physical body, overall life, everything';

  @override
  String get kChartNameD2 => 'Hora';

  @override
  String get kChartSigD2 => 'Wealth, financial prosperity';

  @override
  String get kChartNameD3 => 'Drekkana';

  @override
  String get kChartSigD3 => 'Siblings, courage, initiative';

  @override
  String get kChartNameD4 => 'Chaturthamsha';

  @override
  String get kChartSigD4 => 'Fortune, property, fixed assets, home';

  @override
  String get kChartNameD5 => 'Panchamsha';

  @override
  String get kChartSigD5 => 'Fame, authority, spiritual merit (punya)';

  @override
  String get kChartNameD6 => 'Shashthamsha';

  @override
  String get kChartSigD6 => 'Health, disease, debts, enemies';

  @override
  String get kChartNameD7 => 'Saptamsha';

  @override
  String get kChartSigD7 => 'Children, progeny, creativity';

  @override
  String get kChartNameD8 => 'Ashtamsha';

  @override
  String get kChartSigD8 => 'Sudden events, longevity troubles, obstacles';

  @override
  String get kChartNameD9 => 'Navamsha';

  @override
  String get kChartSigD9 =>
      'Spouse, dharma, inner self — the primary support chart';

  @override
  String get kChartNameD10 => 'Dashamsha';

  @override
  String get kChartSigD10 => 'Career, profession, status, achievement';

  @override
  String get kChartNameD11 => 'Rudramsha';

  @override
  String get kChartSigD11 => 'Death, destruction, gains from adversity (Labha)';

  @override
  String get kChartNameD12 => 'Dvadashamsha';

  @override
  String get kChartSigD12 => 'Parents, ancestry, inherited karma';

  @override
  String get kChartNameD16 => 'Shodashamsha';

  @override
  String get kChartSigD16 => 'Vehicles, comforts, luxuries, happiness';

  @override
  String get kChartNameD20 => 'Vimshamsha';

  @override
  String get kChartSigD20 => 'Spiritual practice, worship, devotion';

  @override
  String get kChartNameD24 => 'Chaturvimshamsha';

  @override
  String get kChartSigD24 => 'Education, learning, knowledge';

  @override
  String get kChartNameD27 => 'Saptavimshamsha';

  @override
  String get kChartSigD27 => 'Strength and weakness, stamina';

  @override
  String get kChartNameD30 => 'Trimshamsha';

  @override
  String get kChartSigD30 => 'Misfortunes, evils, moral character';

  @override
  String get kChartNameD40 => 'Chatvarimshamsha';

  @override
  String get kChartSigD40 => 'Maternal legacy, auspicious/inauspicious effects';

  @override
  String get kChartNameD45 => 'Akshavedamsha';

  @override
  String get kChartSigD45 => 'Paternal legacy, overall character and conduct';

  @override
  String get kChartNameD60 => 'Shashtiamsha';

  @override
  String get kChartSigD60 => 'Past-life karma, the finest layer — overall';

  @override
  String get kChartNameMoon => 'Moon chart (Chandra)';

  @override
  String get kChartSigMoon =>
      'The mind and emotions — the rasi chart read from the Moon';

  @override
  String get kChartNameChalit => 'Bhava Chalit';

  @override
  String get kChartSigChalit =>
      'House results by the actual bhava cusps (Sripati), not whole sign';

  @override
  String get kChartNameTransit => 'Transit (Gochar)';

  @override
  String get kChartSigTransit => 'Current grahas over the natal houses';

  @override
  String get kChartShortMoon => 'Moon';

  @override
  String get kChartShortChalit => 'Chalit';

  @override
  String get kChartShortTransit => 'Transit';

  @override
  String get kChAscendant => 'Ascendant';

  @override
  String get kChLagnaVargottama => 'Lagna vargottama';

  @override
  String kChAsOf(Object when) {
    return 'As of $when';
  }

  @override
  String get kChUnverified =>
      'This division is not yet verified against DrikPanchang — treat the placements as experimental.';

  @override
  String kChChalitShiftedOne(Object planets) {
    return '$planets sits in a different bhava than the whole-sign house.';
  }

  @override
  String kChChalitShiftedMany(Object planets) {
    return '$planets sit in a different bhava than the whole-sign house.';
  }

  @override
  String get kChColPlanet => 'PLANET';

  @override
  String get kChColSign => 'SIGN';

  @override
  String get kChColDegree => 'DEG';

  @override
  String get kChColHouse => 'HOUSE';

  @override
  String get kChColBhava => 'BHAVA';

  @override
  String get kChColFromMoon => 'MOON';

  @override
  String get kChLegend => 'Legend';

  @override
  String get kChLegendNote =>
      '℞ retrograde   ⬦ vargottama   ← moved bhava (chalit)\nNorth: cell number = rasi (1 Aries … 12 Pisces), 1st house is top-centre.';

  @override
  String get kChNorthIndian => 'North Indian';

  @override
  String get kChSouthIndian => 'South Indian';

  @override
  String get kChPickerCharts => 'Charts';

  @override
  String get kChPickerDivisional => 'Divisional charts (Varga)';

  @override
  String get kOvTitle => 'Kundali';

  @override
  String kOvTitleNamed(Object name) {
    return '$name’s Kundali';
  }

  @override
  String get kOvDownloadPdf => 'Download PDF';

  @override
  String get kOvShare => 'Share';

  @override
  String get kOvMoonSignLabel => 'Moon sign · Rashi';

  @override
  String kOvLagnaChip(Object sign) {
    return 'Lagna · $sign';
  }

  @override
  String kOvNakshatraChip(Object name) {
    return 'Nakshatra · $name';
  }

  @override
  String get kOvTimeApprox => 'Birth time approximate';

  @override
  String get kOvEdit => 'Edit';

  @override
  String get kOvLagnaChart => 'Lagna chart';

  @override
  String get kOvD1Rasi => 'D1 Rasi';

  @override
  String get kOvOpenFullChart => 'Open full chart';

  @override
  String get kOvDashaUnavailable => 'Dasha unavailable right now.';

  @override
  String get kOvDashaRunning => 'You are currently running';

  @override
  String kOvMahadasha(Object planet) {
    return '$planet Mahadasha';
  }

  @override
  String kOvSubPeriods(Object antar, Object pratyantar) {
    return '$antar sub-period · $pratyantar pratyantar';
  }

  @override
  String kOvDashaProgress(Object end, Object percent, Object start) {
    return '$start → $end  ·  $percent% through';
  }

  @override
  String get kOvSeeTimeline => 'See full timeline';

  @override
  String get kOvAtAGlance => 'At a glance';

  @override
  String get kOvMangalDosha => 'Mangal Dosha';

  @override
  String get kOvManglik => 'Manglik';

  @override
  String get kOvNotManglik => 'Not Manglik';

  @override
  String kOvMangalFrom(Object refs) {
    return 'From $refs';
  }

  @override
  String get kOvMarsClear => 'Mars is clear';

  @override
  String get kOvMangalCancelled => 'Present, but cancelled in your chart';

  @override
  String kOvMangalLevelFrom(Object level, Object refs) {
    return '$level · from $refs';
  }

  @override
  String get kOvRefLagna => 'Lagna';

  @override
  String get kOvYogas => 'Yogas';

  @override
  String kOvYogasFound(Object count) {
    return '$count found';
  }

  @override
  String get kOvNakshatra => 'Nakshatra';

  @override
  String get kOvLagnaLord => 'Lagna lord';

  @override
  String get kOvExInsights => 'Personality & life overview';

  @override
  String get kOvExInsightsSub =>
      'A free reading of your chart — nature, work, marriage & more';

  @override
  String get kOvExForecast => 'Written forecast';

  @override
  String get kOvExForecastSub =>
      'A paid forecast for one area of life, written by an astrologer';

  @override
  String get kOvExPlanets => 'Planets & positions';

  @override
  String get kOvExPlanetsSub => 'Where each planet sits and what it does';

  @override
  String get kOvExDasha => 'Dasha periods';

  @override
  String get kOvExDashaSub => 'Your life timeline — Vimshottari';

  @override
  String get kOvExVarshphal => 'Varshphal (annual chart)';

  @override
  String get kOvExVarshphalSub =>
      'This solar-return year — Muntha, year lord & Tajika aspect';

  @override
  String get kOvExYogas => 'Yogas & Doshas';

  @override
  String get kOvExYogasSub => 'Special combinations in your chart';

  @override
  String get kOvExRemedies => 'Remedies';

  @override
  String get kOvExRemediesSub =>
      'Traditional mantras, daan and practices for your chart';

  @override
  String get kOvExUpaya => 'Gemstones & upaya';

  @override
  String get kOvExUpayaSub =>
      'Per-planet gemstone, colour, day & mantra — gemstones gated';

  @override
  String get kOvExLalKitab => 'Lal Kitab';

  @override
  String get kOvExLalKitabSub =>
      'Inherited debts (rin) and their simple, free totka remedies';

  @override
  String get kOvExTransits => 'Transits & Sade Sati';

  @override
  String get kOvExTransitsSub => 'What the sky is doing right now';

  @override
  String get kOvExSadeSati => 'Sade Sati & Dhaiya calendar';

  @override
  String get kOvExSadeSatiSub =>
      'Every Saturn window over your life, with dates';

  @override
  String get kOvExMuhurta => 'Today\'s timing';

  @override
  String get kOvExMuhurtaSub =>
      'Choghadiya & Hora, with your best windows marked';

  @override
  String get kOvExHouses => 'Houses (Bhava)';

  @override
  String get kOvExHousesSub => 'A reading for each of the 12 houses';

  @override
  String get kOvExNumerology => 'Numerology & Lo Shu grid';

  @override
  String get kOvExNumerologySub =>
      'Your numbers from date of birth — days, colours, birth grid';

  @override
  String get kOvExAdvanced => 'Advanced reports';

  @override
  String get kOvExAdvancedSub => 'Ashtakavarga, Shadbala, KP, Jaimini';

  @override
  String get kOvAskAstrologer => 'Ask an astrologer about your kundali';

  @override
  String get kReadingCardTitle => 'What this means';

  @override
  String kSsTitle(Object phase) {
    return 'Sade Sati · $phase phase';
  }

  @override
  String get kSsPhaseRising => 'Rising (1 of 3)';

  @override
  String get kSsPhasePeak => 'Peak (2 of 3)';

  @override
  String get kSsPhaseSetting => 'Setting (3 of 3)';

  @override
  String get kSsRising => 'Rising';

  @override
  String get kSsPeak => 'Peak';

  @override
  String get kSsSetting => 'Setting';

  @override
  String get kSsNotCurse =>
      'Sade Sati is a period of hard work and maturing — not a curse. Steady, honest effort is rewarded.';

  @override
  String get kSsWhatForMe => 'What this means for me';

  @override
  String kSsPanotiTitle(Object type) {
    return 'Small Panoti — $type';
  }

  @override
  String get kSsPanotiBody =>
      'A shorter Saturn phase (about 2½ years) that asks for patience with health, effort and daily obstacles.';

  @override
  String get kSsSeeTransits => 'See transits';

  @override
  String get kSsSkyNow => 'Right now in the sky';

  @override
  String get kSsJupiterGood =>
      'Jupiter is transiting favourably for you — a supportive window for growth, learning and money.';

  @override
  String get kSsJupiterNeutral =>
      'No Sade Sati or major Saturn phase is active. Jupiter’s transit is neutral for you right now.';

  @override
  String get kSsSeeAllTransits => 'See all transits';

  @override
  String get kFcTitle => 'Birth chart';

  @override
  String get kFcTransitingGrahas => 'Transiting grahas';

  @override
  String get kFcPlanets => 'Planets';

  @override
  String get kFcAllHouses => 'All 12 houses & readings';

  @override
  String get kFcAllCharts => 'All charts — D1 to D60';

  @override
  String get kFcAllChartsTooltip => 'All charts';

  @override
  String get kFcLoadError => 'Could not load this chart';

  @override
  String get kFcTwelveHouses => 'The 12 houses';

  @override
  String get kFcNoPlanets => 'No planets';

  @override
  String kBdTithi(String key, Object raw) {
    String _temp0 = intl.Intl.selectLogic(key, {'other': '$raw'});
    return '$_temp0';
  }

  @override
  String kBdPaksha(String key, Object raw) {
    String _temp0 = intl.Intl.selectLogic(key, {'other': '$raw'});
    return '$_temp0';
  }

  @override
  String kBdYoga(String key, Object raw) {
    String _temp0 = intl.Intl.selectLogic(key, {'other': '$raw'});
    return '$_temp0';
  }

  @override
  String kBdKarana(String key, Object raw) {
    String _temp0 = intl.Intl.selectLogic(key, {'other': '$raw'});
    return '$_temp0';
  }

  @override
  String kBdVarna(String key, Object raw) {
    String _temp0 = intl.Intl.selectLogic(key, {'other': '$raw'});
    return '$_temp0';
  }

  @override
  String kBdVashya(String key, Object raw) {
    String _temp0 = intl.Intl.selectLogic(key, {'other': '$raw'});
    return '$_temp0';
  }

  @override
  String kBdYoni(String key, Object raw) {
    String _temp0 = intl.Intl.selectLogic(key, {'other': '$raw'});
    return '$_temp0';
  }

  @override
  String kBdGana(String key, Object raw) {
    String _temp0 = intl.Intl.selectLogic(key, {'other': '$raw'});
    return '$_temp0';
  }

  @override
  String kBdNadi(String key, Object raw) {
    String _temp0 = intl.Intl.selectLogic(key, {'other': '$raw'});
    return '$_temp0';
  }

  @override
  String kBdTara(String key, Object raw) {
    String _temp0 = intl.Intl.selectLogic(key, {'other': '$raw'});
    return '$_temp0';
  }

  @override
  String kBdYunja(String key, Object raw) {
    String _temp0 = intl.Intl.selectLogic(key, {'other': '$raw'});
    return '$_temp0';
  }

  @override
  String get horoTitle => 'Horoscope';

  @override
  String get horoReadFull => 'Read full horoscope';

  @override
  String get horoSpanYesterday => 'Yesterday';

  @override
  String get horoSpanToday => 'Today';

  @override
  String get horoSpanTomorrow => 'Tomorrow';

  @override
  String get horoSpanWeek => 'This week';

  @override
  String get horoSpanMonth => 'This month';

  @override
  String get horoAreaLove => 'Love';

  @override
  String get horoAreaCareer => 'Career';

  @override
  String get horoAreaMoney => 'Money';

  @override
  String get horoAreaHealth => 'Health';

  @override
  String get horoOverall => 'Overall';

  @override
  String get horoOutOfFive => 'out of 5';

  @override
  String get horoToneSupportive => 'Supportive';

  @override
  String get horoToneBalanced => 'Balanced';

  @override
  String get horoToneChallenging => 'Needs care';

  @override
  String get horoLuckyColour => 'Lucky colour';

  @override
  String get horoLuckyNumber => 'Lucky number';

  @override
  String get horoLuckyPlanet => 'Strongest planet';

  @override
  String get horoBestDays => 'Your best days';

  @override
  String get horoTipTitle => 'Remedy & tip';

  @override
  String horoTipFor(String planet) {
    return 'Remedy for $planet';
  }

  @override
  String get horoWhyTitle => 'Why the stars say this';

  @override
  String get horoWhyBody =>
      'Vedic horoscopes are read from where each planet is transiting, counted from your Moon sign. Arrows show whether a placement supports you or asks for care.';

  @override
  String horoMoonLine(String sign, String nakshatra, String house) {
    return 'Moon in $sign · $nakshatra · house $house';
  }

  @override
  String horoHouseN(String n) {
    return 'House $n';
  }

  @override
  String horoAboutSign(String sign) {
    return 'About $sign';
  }

  @override
  String get horoElement => 'Element';

  @override
  String get horoRuler => 'Ruling planet';

  @override
  String get horoQuality => 'Nature';

  @override
  String get horoElementFire => 'Fire';

  @override
  String get horoElementEarth => 'Earth';

  @override
  String get horoElementAir => 'Air';

  @override
  String get horoElementWater => 'Water';

  @override
  String get horoQualityMovable => 'Movable';

  @override
  String get horoQualityFixed => 'Fixed';

  @override
  String get horoQualityDual => 'Dual';

  @override
  String get horoChangeSign => 'Change sign';

  @override
  String get horoChooseSign => 'Choose your sign';

  @override
  String get horoWhichSignTitle => 'Which sign should I pick?';

  @override
  String get horoWhichSignBody =>
      'Vedic horoscopes are read from your Moon sign (Rashi) — the sign the Moon was in when you were born. It is often different from your Western sun sign. Your Kundali shows your Moon sign; pick that here for the most accurate reading.';

  @override
  String get horoOpenKundali => 'See my Moon sign in Kundali';

  @override
  String get horoCtaTitle => 'Want a reading just for you?';

  @override
  String horoCtaBody(String sign) {
    return 'This forecast is for everyone born under $sign. An astrologer can read your personal chart.';
  }

  @override
  String get horoCtaButton => 'Talk to an astrologer';

  @override
  String get horoShare => 'Share';

  @override
  String get horoEditorialBadge => 'Written by our astrologers';

  @override
  String get horoError => 'We couldn\'t load the horoscope';

  @override
  String get horoSourceNote =>
      'Based on live planetary transits from your Moon sign. For guidance, not certainty.';

  @override
  String get matchTitle => 'Kundali Milan';

  @override
  String get matchHeroTitle => 'Match two kundalis';

  @override
  String get matchHeroBody => 'Guna Milan, Manglik and dosha check in seconds.';

  @override
  String get matchBoy => 'Boy';

  @override
  String get matchGirl => 'Girl';

  @override
  String get matchSwap => 'Swap';

  @override
  String get matchChoosePerson => 'Choose person';

  @override
  String get matchTapToSelect => 'Tap to select';

  @override
  String get matchRunCta => 'Check compatibility';

  @override
  String get matchPickBothHint => 'Pick both people to see your match score.';

  @override
  String get matchPickBoyTitle => 'Choose the boy\'s birth details';

  @override
  String get matchPickGirlTitle => 'Choose the girl\'s birth details';

  @override
  String get matchAddPerson => 'Add a new person';

  @override
  String get matchAddPersonHint => 'Birth date, time and place';

  @override
  String get matchNoProfiles =>
      'No saved birth details yet. Add a person to get started.';

  @override
  String get matchHowTitle => 'How it works';

  @override
  String get matchStep1Title => 'Choose two people';

  @override
  String get matchStep1Body =>
      'Use saved birth details or add new ones — time and place make it accurate.';

  @override
  String get matchStep2Title => 'We compare both Moon charts';

  @override
  String get matchStep2Body =>
      'Eight kootas — from temperament to health — are scored the traditional Ashtakoota way.';

  @override
  String get matchStep3Title => 'Get your score and dosha check';

  @override
  String get matchStep3Body =>
      'A score out of 36, Manglik compatibility and what each part means.';

  @override
  String get matchHistoryTitle => 'Your matches';

  @override
  String get matchHistoryEmpty =>
      'Your matches will appear here so you can revisit them anytime.';

  @override
  String get matchRetry => 'Retry';

  @override
  String matchPairNames(String boy, String girl) {
    return '$boy & $girl';
  }

  @override
  String get matchResultTitle => 'Match result';

  @override
  String get matchOutOf36 => 'out of 36';

  @override
  String matchShareScore(String score, String verdict) {
    return 'Guna Milan: $score/36 · $verdict';
  }

  @override
  String get matchVerdictExcellent => 'Excellent match';

  @override
  String get matchVerdictGood => 'Good match';

  @override
  String get matchVerdictAverage => 'Average match';

  @override
  String get matchVerdictLow => 'Needs a closer look';

  @override
  String get matchVerdictExcellentBody =>
      'Most kootas align — traditionally a sign of a harmonious, supportive marriage.';

  @override
  String get matchVerdictGoodBody =>
      '18 or more gunas is considered suitable for marriage. Check the low-scoring kootas below.';

  @override
  String get matchVerdictAverageBody =>
      'Below 18 gunas, astrologers usually suggest a full chart review before deciding.';

  @override
  String get matchVerdictLowBody =>
      'Don\'t decide on this score alone — a full kundali review often changes the picture.';

  @override
  String get matchManglikShort => 'Manglik';

  @override
  String get matchManglikTitle => 'Manglik (Mangal dosha) check';

  @override
  String get matchManglikNone =>
      'Neither of you is Manglik — no Mangal dosha concern.';

  @override
  String get matchManglikBoth =>
      'Both of you are Manglik — traditionally the dosha cancels out.';

  @override
  String get matchManglikCancelled =>
      'Mangal dosha is present but cancelled by other placements in the chart.';

  @override
  String get matchManglikMismatch =>
      'Only one of you is Manglik. Talk to an astrologer about remedies and a full chart review.';

  @override
  String get matchIsManglik => 'Manglik';

  @override
  String get matchNotManglik => 'Not Manglik';

  @override
  String get matchManglikCancelledShort => 'Manglik (cancelled)';

  @override
  String matchCheckClear(String name) {
    return '$name: clear';
  }

  @override
  String matchCheckPresent(String name) {
    return '$name: present';
  }

  @override
  String get matchDoshaNadi => 'Nadi dosha';

  @override
  String get matchDoshaBhakoot => 'Bhakoot dosha';

  @override
  String get matchDoshaGana => 'Gana dosha';

  @override
  String get matchDoshaTag => 'Dosha';

  @override
  String get matchBreakdownTitle => 'Guna breakdown';

  @override
  String get matchBreakdownSub => 'Tap any koota to see what it means.';

  @override
  String get matchKootaVarna => 'Varna';

  @override
  String get matchKootaVashya => 'Vashya';

  @override
  String get matchKootaTara => 'Tara';

  @override
  String get matchKootaYoni => 'Yoni';

  @override
  String get matchKootaMaitri => 'Graha Maitri';

  @override
  String get matchKootaGana => 'Gana';

  @override
  String get matchKootaBhakoot => 'Bhakoot';

  @override
  String get matchKootaNadi => 'Nadi';

  @override
  String get matchKootaVarnaMeaning => 'Values & ego';

  @override
  String get matchKootaVashyaMeaning => 'Mutual attraction';

  @override
  String get matchKootaTaraMeaning => 'Destiny & well-being';

  @override
  String get matchKootaYoniMeaning => 'Physical harmony';

  @override
  String get matchKootaMaitriMeaning => 'Mental wavelength';

  @override
  String get matchKootaGanaMeaning => 'Temperament';

  @override
  String get matchKootaBhakootMeaning => 'Love, family & finances';

  @override
  String get matchKootaNadiMeaning => 'Health & children';

  @override
  String get matchKootaVarnaDetail =>
      'Compares the spiritual temperament of both Moon signs — how naturally your values and sense of duty line up. Worth 1 point.';

  @override
  String get matchKootaVashyaDetail =>
      'Shows the natural pull and influence between partners — who leads, who adapts, and how easily you agree. Worth 2 points.';

  @override
  String get matchKootaTaraDetail =>
      'Counts the nakshatras between you to judge fortune, health and longevity of the bond. Worth 3 points.';

  @override
  String get matchKootaYoniDetail =>
      'Each nakshatra has an animal nature; this koota compares them for intimacy and physical compatibility. Worth 4 points.';

  @override
  String get matchKootaMaitriDetail =>
      'Compares the lords of your Moon signs — friendship between them means you think alike and resolve issues easily. Worth 5 points.';

  @override
  String get matchKootaGanaDetail =>
      'Groups nakshatras into Deva, Manushya and Rakshasa temperaments. A mismatch can mean frequent friction. Worth 6 points.';

  @override
  String get matchKootaBhakootDetail =>
      'Looks at the distance between your Moon signs, which traditionally affects love, family growth and shared finances. Worth 7 points.';

  @override
  String get matchKootaNadiDetail =>
      'The most weighted koota. Same Nadi (0 points) is traditionally linked to health and progeny concerns and has well-known exceptions. Worth 8 points.';

  @override
  String get matchChartsTitle => 'Birth chart details';

  @override
  String get matchRowRasi => 'Moon sign';

  @override
  String get matchRowNakshatra => 'Nakshatra';

  @override
  String get matchRowGana => 'Gana';

  @override
  String get matchRowYoni => 'Yoni';

  @override
  String get matchAskTitle => 'Talk it through with an astrologer';

  @override
  String get matchAskBody =>
      'Doshas often have cancellations and remedies. Get a full reading of both charts.';

  @override
  String get matchDisclaimer =>
      'Guna Milan is a traditional guide, not a guarantee. Consider the full charts and your own judgement.';

  @override
  String get matchRelSelf => 'Myself';

  @override
  String get matchRelPartner => 'Partner';

  @override
  String get matchRelChild => 'Child';

  @override
  String get matchRelParent => 'Parent';

  @override
  String get matchRelSibling => 'Sibling';

  @override
  String get matchRelFriend => 'Friend';

  @override
  String get kAdvTitle => 'Advanced reports';

  @override
  String get kAdvIntro =>
      'The technical layers astrologers use for depth and timing. Skim them for interest, or open one during a consultation.';

  @override
  String get kAdvAshtakavarga => 'Ashtakavarga';

  @override
  String get kAdvAshtakavargaSub =>
      'Point-strength of every sign. Higher = the sky supports transits there.';

  @override
  String get kAdvShadbala => 'Shadbala';

  @override
  String get kAdvShadbalaSub =>
      'The six-fold strength of each planet, measured against what it needs.';

  @override
  String get kAdvKp => 'KP System';

  @override
  String get kAdvKpSub =>
      'Krishnamurti Paddhati — cuspal sub-lords and ruling planets for timing.';

  @override
  String get kAdvJaimini => 'Jaimini';

  @override
  String get kAdvJaiminiSub =>
      'Chara Karakas, Arudha Lagna and the Jaimini way of reading a chart.';

  @override
  String get kAdvDownloadPdf => 'Download the full PDF report';

  @override
  String get kAdvFooter =>
      'These are technical. For a reading in plain words, talk to an astrologer.';

  @override
  String get kAdvReport => 'Report';

  @override
  String get kAdvLoadError => 'Could not load this report.';

  @override
  String get kAdvKpIntro =>
      'KP divides the zodiac into 249 sub-parts. The sub-lord of a house cusp decides whether that area of life delivers; the ruling planets are used for on-the-spot timing.';

  @override
  String get kAdvJaiminiIntro =>
      'Jaimini reads the chart through the Chara Karakas (planets ranked by degree, each signifying a life area) and the Arudha padas — how things appear to the world.';

  @override
  String get kAdvAvIntro =>
      'Sarvashtakavarga adds every planet’s contribution to each house — the total is always 337. A house scoring 28+ supports planets transiting through it; below 25 is a weaker patch.';

  @override
  String kAdvHouseN(Object n) {
    return 'House $n';
  }

  @override
  String get kAdvBhinnaTotals => 'Per-planet totals (Bhinnashtakavarga)';

  @override
  String get kAdvShadbalaIntro =>
      'Shadbala scores each planet’s strength in rupas against the minimum it needs. A ratio above 1.0 means the planet can deliver its results reliably.';

  @override
  String kAdvStrongest(Object planet) {
    return 'Strongest: $planet';
  }

  @override
  String kAdvWeakest(Object planet) {
    return 'Weakest: $planet';
  }

  @override
  String get kAdvReadWithAstrologer =>
      'This report is meant to be read with an astrologer.';

  @override
  String get kAdvSecCuspalSublords => 'Cuspal sub-lords';

  @override
  String get kAdvSecRulingPlanets => 'Ruling planets';

  @override
  String get kAdvSecHouseSignificators => 'House significators';

  @override
  String get kAdvSecCharaKarakas => 'Chara karakas';

  @override
  String get kAdvSecArudhaPadas => 'Arudha padas';

  @override
  String get kAdvSecKarakamsa => 'Karakamsa';

  @override
  String get kAdvSecCharaDasha => 'Chara dasha';

  @override
  String get kBhavaTitle => 'Houses · Bhava';

  @override
  String get kBhavaIntro =>
      'Each of the 12 houses, its natural significations, and how its lord and occupants shape it.';

  @override
  String get kBhavaMoreBenefic => 'More benefic than malefic influence';

  @override
  String get kBhavaMoreMalefic => 'More malefic than benefic influence';

  @override
  String kBhavaOccupiedBy(Object planets) {
    return 'Occupied by $planets';
  }

  @override
  String kBhavaAspectedBy(Object planets) {
    return 'Aspected by $planets';
  }

  @override
  String kBhavaBeneficCount(Object count) {
    return '$count benefic';
  }

  @override
  String kBhavaMaleficCount(Object count) {
    return '$count malefic';
  }

  @override
  String get kBhavaNeedsTime => 'House analysis needs a birth time';

  @override
  String get kBhavaNeedsTimeBody =>
      'Add an exact time of birth to this profile to see how each house is shaped.';

  @override
  String get kDashaIntroVimshottari =>
      'Vimshottari is a 120-year cycle of planetary periods, timed from where the Moon sat at your birth.';

  @override
  String get kDashaIntroYogini =>
      'Yogini is a 36-year cycle of eight yoginis, from the Moon’s nakshatra.';

  @override
  String get kDashaIntroAshtottari =>
      'Ashtottari is a 108-year cycle counted from Ardra.';

  @override
  String kDashaBalance(Object lord, Object years) {
    return 'Balance of $lord dasha at birth: $years yrs';
  }

  @override
  String get kDashaVimshottari => 'Vimshottari';

  @override
  String get kDashaYogini => 'Yogini';

  @override
  String get kDashaAshtottari => 'Ashtottari';

  @override
  String get kDashaNowRunning => 'Now running';

  @override
  String get kDashaNow => 'NOW';

  @override
  String kDashaYears(Object count) {
    return '$count yrs';
  }

  @override
  String get kPlanetsIntro =>
      'Where each planet sits, how strong it is, and what it tends to bring. Tap to read more. Positions are sidereal (Lahiri).';

  @override
  String get kTrTitle => 'Transits';

  @override
  String get kTrSadeSatiCalendar =>
      'See the full Sade Sati calendar (with dates)';

  @override
  String get kTrSkyNow => 'The sky right now — against your chart';

  @override
  String get kTrSadeSati => 'Sade Sati';

  @override
  String kTrPhaseOf(Object n) {
    return 'Phase $n of 3';
  }

  @override
  String get kTrPhaseHintRising => 'Saturn in the 12th';

  @override
  String get kTrPhaseHintPeak => 'over the Moon';

  @override
  String get kTrPhaseHintSetting => 'Saturn in the 2nd';

  @override
  String get kTrHowToWork => 'How to work with it';

  @override
  String get kTrTip1 =>
      'Cut what isn’t working — Saturn rewards honesty about it';

  @override
  String get kTrTip2 => 'Build routines and finish what you start';

  @override
  String get kTrTip3 => 'Care for your sleep, knees, teeth and older relatives';

  @override
  String get kTrTip4 =>
      'It is a rebuild, not a punishment. Results show after it ends.';

  @override
  String get kTrPanotiBody =>
      'A shorter (~2½ year) Saturn phase. Expect friction with health, daily effort and obstacles — meet it with patience and routine.';

  @override
  String kTrPlanetInSign(Object planet, Object sign) {
    return '$planet in $sign';
  }

  @override
  String get kTrJupiterGood =>
      'Jupiter’s transit is favourable — supportive for growth, learning, money and family right now.';

  @override
  String get kTrJupiterNeutral =>
      'Jupiter’s transit is neutral for you at the moment.';

  @override
  String get kTrCloseContacts => 'Close contacts now';

  @override
  String kTrCloseContactLine(Object natal, Object planet) {
    return 'Transiting $planet is within 3° of your natal $natal — that area of life is active this week.';
  }

  @override
  String kMuChoghadiya(String key, Object raw) {
    String _temp0 = intl.Intl.selectLogic(key, {'other': '$raw'});
    return '$_temp0';
  }

  @override
  String kUpOr(Object name) {
    return 'or $name';
  }

  @override
  String kUpFinger(Object finger) {
    return '$finger finger';
  }

  @override
  String get kYdPartial => 'partial';

  @override
  String get moodTitle => 'Today\'s mood';

  @override
  String get moodMeter => 'Mood meter';

  @override
  String get moodWhyTitle => 'Why today feels this way';

  @override
  String get moodTipTitle => 'One small thing for today';

  @override
  String get moodLockedTitle => 'Your astrologer can tell you';

  @override
  String get moodLockedSub =>
      'The full picture needs your whole chart, not just the Moon.';

  @override
  String get moodTalkCta => 'Talk to an astrologer now';

  @override
  String moodNextChange(Object when) {
    return 'Your mood shifts next on $when';
  }

  @override
  String get kOvExMood => 'Today\'s mood';

  @override
  String get kOvExMoodSub => 'How the Moon is shaping your mind today';

  @override
  String get prefsMoodAlerts => 'Daily mood alerts';

  @override
  String get prefsMoodAlertsDesc =>
      'About three mornings a week, when the Moon changes sign in your chart.';

  @override
  String get callCalling => 'Calling…';

  @override
  String get callRinging => 'Ringing…';

  @override
  String get callConnecting => 'Connecting…';

  @override
  String get callReconnecting => 'Reconnecting…';

  @override
  String get callEnded => 'Call ended';

  @override
  String get callPoorConnection => 'Weak connection';

  @override
  String get callMute => 'Mute';

  @override
  String get callSpeaker => 'Speaker';

  @override
  String get callEnd => 'End';

  @override
  String get callEncrypted => 'Encrypted call';

  @override
  String get callMicTitle => 'Microphone needed';

  @override
  String get callMicBody =>
      'Allow microphone access so the astrologer can hear you.';

  @override
  String get callMicBlockedBody =>
      'Microphone access is turned off for TalkAcharya. Turn it on in Settings.';

  @override
  String get callOpenSettings => 'Open settings';

  @override
  String get callTryAgain => 'Try again';

  @override
  String get callFailedTitle => 'Couldn\'t start the call';

  @override
  String get callEndConfirmTitle => 'End this call?';

  @override
  String get callEndConfirmBody => 'Billing stops as soon as the call ends.';

  @override
  String get callEndConfirmYes => 'End call';

  @override
  String get callEndConfirmNo => 'Keep talking';

  @override
  String callWaitingAccept(String name) {
    return 'Waiting for $name to accept…';
  }

  @override
  String callBookTitle(String name) {
    return 'Call $name';
  }

  @override
  String get callBookBilling => 'Voice call · billed per minute once connected';

  @override
  String callBookCta(String price) {
    return 'Start call · $price/min';
  }

  @override
  String get callUnavailable =>
      'This astrologer is not taking calls right now.';

  @override
  String get giftAction => 'Send a gift';

  @override
  String giftSheetTitle(String name) {
    return 'Send a gift to $name';
  }

  @override
  String get giftSheetSubtitle =>
      'A small token of gratitude — they see it instantly.';

  @override
  String get giftQuantity => 'Quantity';

  @override
  String get giftAddNote => 'Add a note';

  @override
  String get giftNoteHint => 'Write a short message (optional)';

  @override
  String get giftChoose => 'Choose a gift';

  @override
  String giftSendCta(String gift, String price) {
    return 'Send $gift · $price';
  }

  @override
  String giftWalletBalance(String amount) {
    return 'Balance $amount';
  }

  @override
  String get giftAddMoney => 'Add money';

  @override
  String get giftLowBalanceTitle => 'Not enough balance';

  @override
  String get giftLowBalanceBody =>
      'Add money to your wallet to send this gift.';

  @override
  String giftSentTitle(String gift, String name) {
    return '$gift sent to $name';
  }

  @override
  String get giftSentBody =>
      'They\'ll see it right away. Thank you for your kindness!';

  @override
  String get giftSendAnother => 'Send another';

  @override
  String get giftLoadError => 'Couldn\'t load gifts';

  @override
  String get giftThankYouTitle => 'Say thanks with a gift';

  @override
  String giftThankYouBody(String name) {
    return 'Loved the session? Send $name a small token of gratitude.';
  }

  @override
  String get giftThankYouSentTitle => 'Thank you for your gift';

  @override
  String get helpTitle => 'Help & support';

  @override
  String get helpHeroTitle => 'How can we help?';

  @override
  String get helpHeroBody =>
      'Report a problem with a session, track your reports or reach our team.';

  @override
  String get helpReportSection => 'Report a problem with a session';

  @override
  String get helpReportEmpty => 'Your completed sessions will appear here.';

  @override
  String get helpReportAction => 'Report';

  @override
  String get helpYourReports => 'Your reports';

  @override
  String get helpContactSection => 'Contact us';

  @override
  String get helpWhatsapp => 'Chat on WhatsApp';

  @override
  String get helpEmailUs => 'Email us';

  @override
  String get helpCentre => 'Help centre';

  @override
  String get helpFaqSection => 'Frequently asked questions';

  @override
  String get helpLoadError => 'Couldn\'t load your sessions.';

  @override
  String get helpFaqChargesQ => 'How am I charged for a consultation?';

  @override
  String get helpFaqChargesA =>
      'You pay per minute, only while the session is live. Billing starts once the astrologer joins and stops the moment either of you ends it.';

  @override
  String get helpFaqNoResponseQ => 'What if the astrologer doesn\'t respond?';

  @override
  String get helpFaqNoResponseA =>
      'If your request isn\'t accepted, you aren\'t charged — any amount held for the session goes back to your wallet.';

  @override
  String get helpFaqRefundQ => 'Can I get a refund?';

  @override
  String get helpFaqRefundA =>
      'If something went wrong — wrong charges, a technical problem or an unhelpful session — report it from that session. Our team reviews every report and refunds to your wallet when it\'s warranted.';

  @override
  String get helpFaqBalanceQ =>
      'My balance ran out during a session. What now?';

  @override
  String get helpFaqBalanceA =>
      'The session ends automatically when your balance runs out. Recharge your wallet and start again with the same astrologer from the session summary.';

  @override
  String get helpFaqPrivacyQ => 'Are my conversations private?';

  @override
  String get helpFaqPrivacyA =>
      'Your consultations are between you and your astrologer. Our support team looks at a session only to resolve a report or keep the platform safe.';

  @override
  String get helpFaqLanguageQ => 'How do I change the app language?';

  @override
  String get helpFaqLanguageA =>
      'Go to Profile → Language and choose the language you\'re most comfortable in.';

  @override
  String get reportTitle => 'Report a problem';

  @override
  String reportSessionWith(String name) {
    return 'Session with $name';
  }

  @override
  String get reportWhatHappened => 'What went wrong?';

  @override
  String get reportTypeBilling => 'Wrong charges';

  @override
  String get reportTypeBillingHint =>
      'I was charged more than I should have been';

  @override
  String get reportTypeQuality => 'Unhelpful session';

  @override
  String get reportTypeQualityHint => 'The guidance wasn\'t what was promised';

  @override
  String get reportTypeConduct => 'Inappropriate behaviour';

  @override
  String get reportTypeConductHint =>
      'The astrologer was rude or unprofessional';

  @override
  String get reportTypeNoShow => 'Astrologer didn\'t respond';

  @override
  String get reportTypeNoShowHint => 'They accepted but never really joined';

  @override
  String get reportTypeTechnical => 'Technical problem';

  @override
  String get reportTypeTechnicalHint => 'The chat or call kept failing';

  @override
  String get reportDescribe => 'Tell us more';

  @override
  String get reportDescribeHint =>
      'Share what happened — the more detail, the faster we can help.';

  @override
  String reportMinChars(String count) {
    return 'At least $count characters';
  }

  @override
  String get reportPrivacyNote =>
      'To look into your report, our support team will review this session.';

  @override
  String get reportSubmit => 'Submit report';

  @override
  String get reportSubmittedTitle => 'Report submitted';

  @override
  String get reportSubmittedBody =>
      'We\'ll look into it and notify you as soon as there\'s an update.';

  @override
  String get reportAlreadyTitle => 'You\'ve already reported this session';

  @override
  String get reportAlreadyBody =>
      'Our team is looking into it. You\'ll be notified when there\'s an update.';

  @override
  String get reportViewStatus => 'View report status';

  @override
  String get disputeTitle => 'Report details';

  @override
  String get disputeStatusOpen => 'Received';

  @override
  String get disputeStatusInvestigating => 'Under review';

  @override
  String get disputeStatusResolved => 'Resolved';

  @override
  String get disputeStatusRejected => 'Closed';

  @override
  String get disputeHeadlineOpen => 'We\'ve received your report';

  @override
  String get disputeHeadlineInvestigating =>
      'Our team is reviewing your report';

  @override
  String get disputeHeadlineResolved => 'Your report is resolved';

  @override
  String get disputeHeadlineRejected => 'We\'ve reviewed your report';

  @override
  String get disputeOpenBody =>
      'We\'ll notify you as soon as there\'s an update.';

  @override
  String disputeReportedOn(String date) {
    return 'Reported on $date';
  }

  @override
  String disputeRefundedTitle(String amount) {
    return '$amount refunded to your wallet';
  }

  @override
  String get disputeOpenWallet => 'Wallet';

  @override
  String get disputeOutcome => 'Outcome';

  @override
  String get disputeOutcomeNoRefund => 'No refund was issued for this session.';

  @override
  String get disputeTimeline => 'Progress';

  @override
  String get disputeStepRaised => 'Report submitted';

  @override
  String get disputeStepReviewing => 'Under review';

  @override
  String get disputeStepResolved => 'Resolved';

  @override
  String get disputeStepRejected => 'Closed';

  @override
  String get disputeYourReport => 'Your report';

  @override
  String get roomReportProblem => 'Report a problem';

  @override
  String get articlesTitle => 'Read & learn';

  @override
  String get articlesRailSubtitle => 'Guides, remedies and festivals';

  @override
  String get articlesAll => 'All';

  @override
  String get articlesEmptyTitle => 'Nothing to read here yet';

  @override
  String get articlesEmptyBody =>
      'New articles are on their way — check back soon.';

  @override
  String get articleCatAstrology => 'Astrology';

  @override
  String get articleCatHoroscope => 'Horoscope';

  @override
  String get articleCatFestivals => 'Festivals';

  @override
  String get articleCatRemedies => 'Remedies';

  @override
  String get articleCatGuides => 'Guides';

  @override
  String get articleCatNews => 'News';

  @override
  String articleMinRead(int minutes) {
    return '$minutes min read';
  }

  @override
  String get articleShare => 'Share';

  @override
  String get articleMoreToRead => 'More to read';

  @override
  String get articleAskTitle => 'Want guidance for your own chart?';

  @override
  String get articleAskBody => 'Talk to a verified astrologer in minutes.';

  @override
  String get articleAskCta => 'Ask now';

  @override
  String get panchangTitle => 'Panchang';

  @override
  String get panchangToday => 'Today';

  @override
  String get panchangPickDate => 'Pick a date';

  @override
  String panchangMoonIn(String sign) {
    return 'Moon in $sign';
  }

  @override
  String panchangTill(String time) {
    return 'till $time';
  }

  @override
  String get panchangRightNow => 'Right now';

  @override
  String panchangNowChoghadiya(String name, String time) {
    return '$name Choghadiya until $time';
  }

  @override
  String panchangRahuNow(String time) {
    return 'Rahu Kaal is on until $time — hold off on new beginnings.';
  }

  @override
  String get panchangLimbs => 'Today\'s Panchang';

  @override
  String get panchangAuspicious => 'Auspicious timings';

  @override
  String get panchangInauspicious => 'Avoid starting new work';

  @override
  String get panchangBrahma => 'Brahma Muhurta';

  @override
  String get panchangAbhijit => 'Abhijit Muhurta';

  @override
  String get panchangNoAbhijit =>
      'Abhijit Muhurta isn\'t observed on Wednesdays.';

  @override
  String get panchangRahuKaal => 'Rahu Kaal';

  @override
  String get panchangYamaganda => 'Yamaganda';

  @override
  String get panchangGulika => 'Gulika Kaal';

  @override
  String get panchangChoghadiya => 'Choghadiya';

  @override
  String get panchangDay => 'Day';

  @override
  String get panchangNight => 'Night';

  @override
  String get panchangNotes => 'Notes from our astrologers';

  @override
  String get panchangPersonalTitle => 'Timings for your chart';

  @override
  String get panchangPersonalBody =>
      'See the hours that suit you best, worked out from your kundali.';

  @override
  String panchangFooter(String place, String timezone) {
    return 'Calculated for $place · $timezone · from local sunrise';
  }

  @override
  String get panchangChoosePlaceTitle => 'Choose your city';

  @override
  String get panchangChoosePlaceBody =>
      'Panchang timings depend on where you are — pick the city you want them for.';

  @override
  String get panchangChoosePlaceCta => 'Choose city';

  @override
  String panchangUsePlace(String place) {
    return 'Use $place';
  }

  @override
  String get panchangCity => 'City';

  @override
  String get panchangCityHint => 'Search a city or town';

  @override
  String get kPdfTitle => 'Kundali report (PDF)';

  @override
  String get kPdfFull => 'Full report';

  @override
  String get kPdfFullSub =>
      'Charts, planets, avakahada, dasha timeline, yogas and doshas';

  @override
  String get kPdfBasic => 'One-page summary';

  @override
  String get kPdfBasicSub => 'Lagna and Navamsa charts with planet positions';

  @override
  String get kPdfChartStyle => 'Chart style';

  @override
  String get kPdfEastIndian => 'East Indian';

  @override
  String get kPdfShareCta => 'Download & share';

  @override
  String get kPdfPreparing => 'Preparing your PDF…';

  @override
  String get kPdfNote =>
      'The PDF is in English. Save it to your phone or send it on WhatsApp.';

  @override
  String get kPdfUnavailable =>
      'PDF reports aren\'t available right now. Please try again later.';
}
