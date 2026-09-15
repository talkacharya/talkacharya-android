// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Tamil (`ta`).
class AppLocalizationsTa extends AppLocalizations {
  AppLocalizationsTa([String locale = 'ta']) : super(locale);

  @override
  String get appName => 'TalkAcharya';

  @override
  String get commonOk => 'சரி';

  @override
  String get commonCancel => 'ரத்துசெய்';

  @override
  String get commonDone => 'முடிந்தது';

  @override
  String get commonNext => 'அடுத்து';

  @override
  String get commonBack => 'பின்செல்';

  @override
  String get commonRetry => 'மீண்டும் முயல்க';

  @override
  String get commonSave => 'சேமி';

  @override
  String get commonEdit => 'திருத்து';

  @override
  String get commonDelete => 'நீக்கு';

  @override
  String get commonClose => 'மூடு';

  @override
  String get commonContinue => 'தொடர்க';

  @override
  String get commonConfirm => 'உறுதிப்படுத்து';

  @override
  String get commonSeeAll => 'அனைத்தையும் காண்க';

  @override
  String get commonViewAll => 'அனைத்தையும் காண்க';

  @override
  String get commonShare => 'பகிர்';

  @override
  String get commonCopy => 'நகலெடு';

  @override
  String get commonCopied => 'நகலெடுக்கப்பட்டது';

  @override
  String get commonApply => 'பயன்படுத்து';

  @override
  String get commonSearch => 'தேடுக';

  @override
  String get commonYes => 'ஆம்';

  @override
  String get commonNo => 'இல்லை';

  @override
  String get commonLoading => 'பதிவேற்றப்படுகிறது…';

  @override
  String get commonSomethingWentWrong => 'ஏதோ தவறு நடந்துவிட்டது';

  @override
  String get commonCheckConnection =>
      'உங்கள் இணைய இணைப்பைச் சரிபார்த்து மீண்டும் முயலவும்';

  @override
  String get commonComingSoon => 'விரைவில் வருகிறது';

  @override
  String get commonToday => 'இன்று';

  @override
  String get commonYesterday => 'நேற்று';

  @override
  String commonMinutesShort(int count) {
    return '$count நிமிடம்';
  }

  @override
  String get commonOffline => 'நீங்கள் ஆஃப்லைனில் உள்ளீர்கள்';

  @override
  String get navHome => 'முகப்பு';

  @override
  String get navAstrologers => 'ஜோதிடர்கள்';

  @override
  String get navLive => 'நேரலை';

  @override
  String get navWallet => 'வாலட்';

  @override
  String get navProfile => 'சுயவிவரம்';

  @override
  String get authWelcomeTitle => 'நம்பகமான ஜோதிடர்களுடன் பேசுங்கள்';

  @override
  String get authWelcomeSubtitle =>
      'காதல், தொழில், பணம் மற்றும் பலவற்றிற்கான வழிகாட்டலுக்கு அரட்டை அடிக்கவும் அல்லது அழைக்கவும்';

  @override
  String get authPhoneTitle => 'உங்கள் மொபைல் எண்ணை உள்ளிடவும்';

  @override
  String get authPhoneSubtitle =>
      'உங்கள் மொபைல் எண்ணை உள்ளிடவும், நாங்கள் உங்களுக்கு ஒரு முறை பயன்படுத்தும் குறியீட்டை (OTP) அனுப்புவோம்.';

  @override
  String authOtpSubtitle(String phone) {
    return '$phone எண்ணிற்கு 6 இலக்க குறியீட்டை அனுப்பியுள்ளோம்.';
  }

  @override
  String authTestModeCode(String code) {
    return 'சோதனை முறை — உங்கள் குறியீடு $code';
  }

  @override
  String get authPhoneHint => 'மொபைல் எண்';

  @override
  String get authPhoneHelper =>
      'நாங்கள் SMS மூலம் ஒரு முறை பயன்படுத்தும் குறியீட்டை அனுப்புவோம்';

  @override
  String get authGetOtp => 'OTP பெறுக';

  @override
  String get authOtpTitle => '6 இலக்க குறியீட்டை உள்ளிடவும்';

  @override
  String authOtpSentTo(String phone) {
    return '$phone எண்ணிற்கு அனுப்பப்பட்டது';
  }

  @override
  String get authOtpResend => 'குறியீட்டை மீண்டும் அனுப்பு';

  @override
  String authOtpResendIn(int seconds) {
    return '$seconds வினாடிகளில் மீண்டும் அனுப்பு';
  }

  @override
  String get authVerify => 'சரிபார்க்கவும்';

  @override
  String get authChangeNumber => 'எண்ணை மாற்றவும்';

  @override
  String get authInvalidPhone => 'சரியான மொபைல் எண்ணை உள்ளிடவும்';

  @override
  String get authInvalidOtp => '6 இலக்க குறியீட்டை உள்ளிடவும்';

  @override
  String get authWrongApp =>
      'இந்த எண் ஜோதிடர் செயலிக்காக பதிவு செய்யப்பட்டுள்ளது';

  @override
  String authDevCode(String code) {
    return 'தேவ் குறியீடு: $code';
  }

  @override
  String get authTermsNotice =>
      'தொடர்வதன் மூலம் எங்களது விதிமுறைகள் மற்றும் தனியுரிமைக் கொள்கையை ஏற்கிறீர்கள்';

  @override
  String get authLogout => 'வெளியேறு';

  @override
  String get authLogoutConfirm =>
      'TalkAcharya-விலிருந்து வெளியேறவா? நீங்கள் மீண்டும் உள்நுழைய வேண்டும்.';

  @override
  String homeGreeting(String name) {
    return 'நமஸ்தே, $name';
  }

  @override
  String get homeGuidanceTagline =>
      'வழிகாட்டல், உங்களுக்குத் தேவைப்படும் போதெல்லாம்';

  @override
  String get homeGreetingFallbackName => 'அன்பரே';

  @override
  String get walletAddShort => 'சேர்';

  @override
  String get homeChatNow => 'இப்போதே அரட்டை செய்க';

  @override
  String get homeCallNow => 'இப்போதே அழைக்கவும்';

  @override
  String homeFromPerMin(String price) {
    return '$price/நிமிடத்திலிருந்து';
  }

  @override
  String homeOnlineCount(int count) {
    return '$count பேர் ஆன்லைனில்';
  }

  @override
  String get homeOnlineNow => 'இப்போது ஆன்லைனில்';

  @override
  String get homeTalkToAstrologer => 'ஜோதிடரிடம் பேசுங்கள்';

  @override
  String get homeLiveNow => 'இப்போது நேரலையில்';

  @override
  String get homeWhatsOnYourMind => 'உங்கள் மனதில் என்ன இருக்கிறது?';

  @override
  String get homeTodaysHoroscope => 'இன்றைய ராசிபலன்';

  @override
  String get homeChooseYourSign => 'உங்கள் ராசியைத் தேர்ந்தெடுக்கவும்';

  @override
  String get homeReadMore => 'மேலும் படிக்க';

  @override
  String get homeShowLess => 'குறைவாகக் காட்டு';

  @override
  String homeLuckToday(String rating) {
    return 'இன்றைய அதிர்ஷ்டம் · $rating';
  }

  @override
  String get homeTodaysPanchang => 'இன்றைய பஞ்சாங்கம்';

  @override
  String get homePanchangAddProfile =>
      'உங்கள் இருப்பிடத்திற்கு ஏற்ப பஞ்சாங்கம் பெற பிறப்பு விவரங்களைச் சேர்க்கவும்';

  @override
  String get homeFreeTools => 'இலவச கருவிகள்';

  @override
  String get homeTalkAgain => 'மீண்டும் பேசுங்கள்';

  @override
  String get homeAddMoneyGetBonus => 'பணம் சேர்க்கவும், போனஸ் பெறவும்';

  @override
  String get homeReferAFriend =>
      'நண்பரைப் பரிந்துரைக்கவும், இருவரும் சம்பாதிக்கவும்';

  @override
  String get homeReferShort =>
      'உங்கள் குறியீட்டைப் பகிரவும் — இருவருக்கும் வாலட் கிரெடிட் கிடைக்கும்';

  @override
  String homeReferYourCode(String code) {
    return 'உங்கள் குறியீடு: $code';
  }

  @override
  String get homeInvite => 'அழைப்பு விடுக்கவும்';

  @override
  String homeResumeInProgress(String channel) {
    return '$channel · செயல்பாட்டில் உள்ளது';
  }

  @override
  String homeResumePaused(String channel) {
    return '$channel · இடைநிறுத்தப்பட்டது';
  }

  @override
  String get homeResume => 'தொடரவும்';

  @override
  String get homeTrustVerified =>
      'ஒவ்வொரு ஜோதிடரும் நேரலைக்குச் செல்லும் முன் அடையாளச் சரிபார்ப்பு செய்யப்படுகிறார்கள்';

  @override
  String get homeTrustPrivate => '100% தனிப்பட்ட மற்றும் ரகசிய ஆலோசனைகள்';

  @override
  String get homeTrustVolume => 'ஒவ்வொரு வாரமும் ஆயிரக்கணக்கான ஆலோசனைகள்';

  @override
  String get homeCouldntLoadAstrologers => 'ஜோதிடர்களை ஏற்ற முடியவில்லை';

  @override
  String get homeCouldntLoadReading => 'இன்றைய பலனைப் பெற முடியவில்லை';

  @override
  String get homeCouldntLoadPanchang => 'பஞ்சாங்கத்தை ஏற்ற முடியவில்லை';

  @override
  String get homeNoAstrologersFilter =>
      'இந்த வடிகட்டிக்கு ஏற்ற ஜோதிடர்கள் தற்போது யாரும் இல்லை';

  @override
  String get concernLove => 'காதல்';

  @override
  String get concernMarriage => 'திருமணம்';

  @override
  String get concernCareer => 'தொழில்';

  @override
  String get concernFinance => 'நிதி';

  @override
  String get concernHealth => 'ஆரோக்கியம்';

  @override
  String get concernEducation => 'கல்வி';

  @override
  String get concernBusiness => 'வணிகம்';

  @override
  String get concernLegal => 'சட்டம்';

  @override
  String get channelChat => 'அரட்டை';

  @override
  String get channelCall => 'அழைப்பு';

  @override
  String get channelVoice => 'குரல் அழைப்பு';

  @override
  String get channelVideo => 'வீடியோ அழைப்பு';

  @override
  String get channelAll => 'அனைத்தும்';

  @override
  String get astroFilterAll => 'அனைத்தும்';

  @override
  String get astroSortRecommended => 'பரிந்துரைக்கப்பட்டவை';

  @override
  String get astroSortTopRated => 'சிறந்த மதிப்பீடு';

  @override
  String get astroSortExperienced => 'அதிக அனுபவம் வாய்ந்தவர்கள்';

  @override
  String get astroSortConsulted => 'அதிகம் ஆலோசிக்கப்பட்டவர்கள்';

  @override
  String get astroSortNew => 'புதியவர்கள்';

  @override
  String get astroOnline => 'ஆன்லைன்';

  @override
  String get astroBusy => 'பிஸியாக உள்ளார்';

  @override
  String get astroNotifyMe => 'எனக்குத் தெரிவிக்கவும்';

  @override
  String astroWaitMinutes(int count) {
    return '~$count நிமி காத்திருப்பு';
  }

  @override
  String astroPerMinute(String price) {
    return '$price/நிமிடம்';
  }

  @override
  String astroYearsExp(int count) {
    return '$count வருட அனுபவம்';
  }

  @override
  String get astroRatingNew => 'புதியது';

  @override
  String astroSessionsCount(String count) {
    return '$count அமர்வுகள்';
  }

  @override
  String get astroSearchHint => 'பெயர், திறன் அல்லது மொழி மூலம் தேடுக';

  @override
  String get astroNoneFound => 'ஜோதிடர்கள் யாரும் காணப்படவில்லை';

  @override
  String get astroNoneFoundHint =>
      'வடிகட்டியை அகற்றவும் அல்லது வேறு எதையாவது தேடவும்';

  @override
  String get astroThatsEveryone => 'தற்போதைக்கு இவ்வளவுதான்';

  @override
  String get astroRateOnRequest => 'கோரிக்கையின் பேரில் கட்டணம்';

  @override
  String get astroCouldntLoad => 'ஜோதிடர்களை ஏற்ற முடியவில்லை';

  @override
  String get astroSortBy => 'வரிசைப்படுத்து';

  @override
  String get astroLoadMoreFailed => 'மேலும் ஏற்ற முடியவில்லை';

  @override
  String get astroDefaultSkill => 'வேத ஜோதிடம்';

  @override
  String astroYears(int count) {
    return '$count ஆண்டுகள்';
  }

  @override
  String astroSessions(String count) {
    return '$count அமர்வுகள்';
  }

  @override
  String get astroChat => 'அரட்டை';

  @override
  String get astroCall => 'அழைப்பு';

  @override
  String get astroVideo => 'வீடியோ';

  @override
  String get astroProfileTitle => 'ஜோதிடர்';

  @override
  String get astroExpertiseTitle => 'Expertise';

  @override
  String get astroAboutTitle => 'பற்றி';

  @override
  String get astroRatesTitle => 'ஆலோசனை கட்டணங்கள்';

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
  String get astroStatRating => 'மதிப்பீடு';

  @override
  String get astroStatExperience => 'அனுபவம்';

  @override
  String get astroStatSessions => 'அமர்வுகள்';

  @override
  String get astroStatRepeatClients => 'மீண்டும் வரும் வாடிக்கையாளர்கள்';

  @override
  String astroSpeaks(String languages) {
    return '$languages பேசுகிறார்';
  }

  @override
  String astroRepliesIn(String time) {
    return 'பதில்கள் ~ $time';
  }

  @override
  String get astroOnlineNow => 'இப்போது ஆன்லைனில்';

  @override
  String get astroOfflineTitle => 'தற்போது ஆஃப்லைனில் உள்ளது';

  @override
  String get astroNotifyWhenOnline =>
      'ஆன்லைனில் இருக்கும்போது எனக்குத் தெரிவிக்கவும்';

  @override
  String get astroReadMore => 'மேலும் படிக்கவும்';

  @override
  String get astroReadLess => 'குறைவாகக் காட்டு';

  @override
  String get astroCouldntLoadOne => 'இந்த ஜோதிடரை ஏற்ற முடியவில்லை';

  @override
  String get astroCallsComingSoon =>
      'குரல் மற்றும் காணொளி அழைப்புகள் விரைவில் வரவிருக்கின்றன.';

  @override
  String get astroTrustLine =>
      'அடையாளம் சரிபார்க்கப்பட்டது · தனிப்பட்டது மற்றும் இரகசியமானது · நிமிடக் கட்டணம்';

  @override
  String get walletTitle => 'வாலட்';

  @override
  String get walletAvailableBalance => 'கிடைக்கக்கூடிய இருப்பு';

  @override
  String walletOnHold(String amount) {
    return '$amount நிறுத்தி வைக்கப்பட்டுள்ளது';
  }

  @override
  String walletOnHoldReason(String amount) {
    return '$amount நிறுத்தி வைக்கப்பட்டுள்ளது · அழைப்பு செயல்பாட்டில் உள்ளது';
  }

  @override
  String get walletAddMoney => 'பணம் சேர்க்கவும்';

  @override
  String get walletRecentActivity => 'சமீபத்திய செயல்பாடுகள்';

  @override
  String get walletTransactions => 'பரிவர்த்தனைகள்';

  @override
  String get walletHowItWorksTitle => 'வாலட் எவ்வாறு செயல்படுகிறது';

  @override
  String get walletHowItWorksBody =>
      'வாலட் இருப்பு ஆலோசனைகளுக்கு மட்டுமே பயன்படுத்தப்படும் மற்றும் காலாவதியாகாது. பயன்படுத்தப்படாத இருப்பைத் திரும்பப் பெறலாம் — எங்களது பணத்தைத் திரும்பப் பெறும் கொள்கையைப் பார்க்கவும்.';

  @override
  String get walletRefundPolicy => 'பணத்தைத் திரும்பப் பெறும் கொள்கை';

  @override
  String get walletHaveCoupon => 'கூப்பன் குறியீடு உள்ளதா?';

  @override
  String get walletCouponHint => 'குறியீட்டை உள்ளிடவும்';

  @override
  String walletCouponApplied(String amount) {
    return '$amount உங்கள் வாலட்டில் சேர்க்கப்பட்டது';
  }

  @override
  String get walletSecuredBy =>
      'Razorpay · UPI · கார்டுகள் · நெட்பேங்கிங் மூலம் பாதுகாக்கப்பட்டது';

  @override
  String get walletGstInvoices => 'GST இன்வாய்ஸ்கள்';

  @override
  String get walletInvoicesSubtitle =>
      'உங்கள் ரீசார்ஜ்களுக்கான இன்வாய்ஸ்கள் மற்றும் ரசீதுகள்';

  @override
  String get walletNoTransactions => 'பரிவர்த்தனைகள் எதுவும் இல்லை';

  @override
  String get walletNoTransactionsHint =>
      'தொடங்குவதற்கு உங்கள் வாலட்டில் பணம் சேர்க்கவும்';

  @override
  String walletBalanceAfter(String amount) {
    return 'இருப்பு $amount';
  }

  @override
  String get walletFilterAll => 'அனைத்தும்';

  @override
  String get walletFilterRecharge => 'சேர்க்கப்பட்டவை';

  @override
  String get walletFilterConsultation => 'ஆலோசனைகள்';

  @override
  String get walletFilterRefund => 'திரும்பப் பெற்றவை';

  @override
  String get walletFilterBonus => 'போனஸ்';

  @override
  String get kindRecharge => 'பணம் சேர்க்கப்பட்டது';

  @override
  String get kindConsultationCharge => 'ஆலோசனை';

  @override
  String get kindConsultationRefund => 'திரும்பப் பெறப்பட்டது';

  @override
  String get kindPromoCredit => 'புரோமோ கிரெடிட்';

  @override
  String get kindCouponDiscount => 'கூப்பன் தள்ளுபடி';

  @override
  String get kindSignupBonus => 'பதிவு போனஸ்';

  @override
  String get kindReferralBonus => 'பரிந்துரை போனஸ்';

  @override
  String get kindAdjustment => 'சரிசெய்தல்';

  @override
  String get kindGiftSpend => 'பரிசு அனுப்பப்பட்டது';

  @override
  String get kindHold => 'அழைப்பிற்காக ஒதுக்கப்பட்டது';

  @override
  String get kindChargeback => 'சார்ஜ்பேக்';

  @override
  String get rechargeChooseAmount => 'வாலட்டில் பணம் சேர்க்கவும்';

  @override
  String get rechargeAmountLabel => 'தொகை';

  @override
  String rechargePayAmount(String amount) {
    return '$amount செலுத்துக';
  }

  @override
  String get rechargeAddCoupon => 'கூப்பன் குறியீட்டைச் சேர்க்கவும்';

  @override
  String rechargeBonusBadge(String amount) {
    return '+$amount';
  }

  @override
  String get rechargeStarterPack => 'ஸ்டார்ட்டர்';

  @override
  String rechargeMinAmount(String amount) {
    return 'குறைந்தபட்சம் $amount';
  }

  @override
  String rechargeMaxAmount(String amount) {
    return 'அதிகபட்சம் $amount';
  }

  @override
  String get rechargeOpeningCheckout =>
      'பாதுகாப்பான கட்டணப் பக்கத்தைத் திறக்கிறது…';

  @override
  String get rechargeConfirming =>
      'பணம் பெறப்பட்டது — உங்கள் இருப்பைப் புதுப்பிக்கிறோம்…';

  @override
  String rechargeSuccessTitle(String amount) {
    return '$amount சேர்க்கப்பட்டது';
  }

  @override
  String rechargeNewBalance(String amount) {
    return 'புதிய இருப்பு $amount';
  }

  @override
  String get rechargeViewTransaction => 'பரிவர்த்தனையைக் காண்க';

  @override
  String get rechargeFailedTitle => 'பணம் செலுத்துதல் தோல்வியடைந்தது';

  @override
  String get rechargeNotCharged =>
      'உங்களிடம் கட்டணம் எதுவும் வசூலிக்கப்படவில்லை.';

  @override
  String get rechargeAutoRefund =>
      'ஏதேனும் தொகை கழிக்கப்பட்டிருந்தால், அது 3-5 வேலை நாட்களில் திரும்பப் பெறப்படும்.';

  @override
  String get rechargeTryAgain => 'மீண்டும் முயல்க';

  @override
  String get rechargeChangeAmount => 'தொகையை மாற்றவும்';

  @override
  String get rechargeCreditedSoon =>
      'பணம் பெறப்பட்டது. சிறிது நேரத்தில் உங்கள் வாலட்டில் சேர்ப்போம்.';

  @override
  String rechargeOfferAutoApplied(String amount, String bonus) {
    return '$amount சேர்க்கவும், $bonus கூடுதலாகப் பெறவும் — தானாகப் பயன்படுத்தப்பட்டது';
  }

  @override
  String get profileTitle => 'சுயவிவரம்';

  @override
  String get profileEditProfile => 'சுயவிவரத்தைத் திருத்து';

  @override
  String profilePhoneMasked(String last4) {
    return '+91 ●●●●● $last4';
  }

  @override
  String get profileCompleteAddEmail =>
      'சுயவிவரத்தை முடிக்க மின்னஞ்சலைச் சேர்க்கவும்';

  @override
  String get profileCompleteAddBirth =>
      'தனிப்பயனாக்கப்பட்ட பலன்களுக்குப் பிறப்பு விவரங்களைச் சேர்க்கவும்';

  @override
  String get profileRoleCustomer => 'வாடிக்கையாளர்';

  @override
  String get profileWallet => 'வாலட்';

  @override
  String get profileBirthProfiles => 'பிறப்பு சுயவிவரங்கள்';

  @override
  String profileBirthProfilesCount(int count) {
    return '$count ஜாதகங்கள்';
  }

  @override
  String get profileGroupAccount => 'கணக்கு';

  @override
  String get profileGroupMoney => 'பணம்';

  @override
  String get profileGroupPreferences => 'விருப்பத்தேர்வுகள்';

  @override
  String get profileGroupSupport => 'ஆதரவு';

  @override
  String get profileGroupLegal => 'சட்டம்';

  @override
  String get profileNotifications => 'அறிவிப்புகள்';

  @override
  String get profileNotificationPrefs => 'அறிவிப்பு விருப்பத்தேர்வுகள்';

  @override
  String get profileHapticFeedback => 'தொட்டுணரக்கூடிய பின்னூட்டம்';

  @override
  String get profileHapticFeedbackDesc =>
      'பொத்தான்கள் மற்றும் ஊடாடல்களில் அதிர்வு';

  @override
  String get profileWalletAndTransactions => 'வாலட் மற்றும் பரிவர்த்தனைகள்';

  @override
  String get profileOrders => 'Orders';

  @override
  String profileOrdersUnread(int count) {
    return '$count new';
  }

  @override
  String get profileReferAndEarn => 'பரிந்துரைத்து சம்பாதி';

  @override
  String get profileLanguage => 'மொழி';

  @override
  String get profileCurrency => 'நாணயம்';

  @override
  String get profileHelpCentre => 'உதவி மையம்';

  @override
  String get profileContactWhatsapp => 'WhatsApp-ல் எங்களைத் தொடர்பு கொள்ளவும்';

  @override
  String get profileRateApp => 'TalkAcharya-வை மதிப்பிடவும்';

  @override
  String get profileShareApp => 'செயலியைப் பகிரவும்';

  @override
  String profileShareMessage(String link) {
    return 'ஜோதிடர்களிடம் பேச நான் TalkAcharya-வை பயன்படுத்துகிறேன். நீங்களும் முயன்று பாருங்கள்: $link';
  }

  @override
  String get profileTerms => 'சேவை விதிமுறைகள்';

  @override
  String get profilePrivacy => 'தனியுரிமைக் கொள்கை';

  @override
  String get profileLicenses => 'திறந்த மூல உரிமங்கள்';

  @override
  String get profileDeleteAccount => 'கணக்கை நீக்கு';

  @override
  String profileVersion(String version, String build) {
    return 'TalkAcharya · v$version ($build)';
  }

  @override
  String get editFullName => 'முழு பெயர்';

  @override
  String get editDisplayName => 'திரைப் பெயர்';

  @override
  String get editDateOfBirth => 'பிறந்த தேதி';

  @override
  String get editGender => 'பாலினம்';

  @override
  String get editGenderMale => 'ஆண்';

  @override
  String get editGenderFemale => 'பெண்';

  @override
  String get editGenderOther => 'இதர';

  @override
  String get editEmail => 'மின்னஞ்சல்';

  @override
  String get editEmailUnverified => 'சரிபார்க்கப்படவில்லை';

  @override
  String get editChangePhoto => 'புகைப்படத்தை மாற்றவும்';

  @override
  String get editProfileSaved => 'சுயவிவரம் புதுப்பிக்கப்பட்டது';

  @override
  String get editProfileSaveError => 'உங்கள் மாற்றங்களைச் சேமிக்க முடியவில்லை';

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
  String get editCountry => 'நாடு';

  @override
  String get chooseLanguage => 'மொழியைத் தேர்ந்தெடு';

  @override
  String get chooseCurrency => 'நாணயத்தைத் தேர்ந்தெடு';

  @override
  String get deleteAccountTitle => 'உங்கள் கணக்கை நீக்கு';

  @override
  String get deleteAccountBody =>
      'இது உங்கள் சுயவிவரம், பிறப்பு ஜாதகங்கள் மற்றும் அரட்டை வரலாற்றை நிரந்தரமாக நீக்கும். உங்கள் வாலட் இருப்பு ஏதேனும் இருந்தால், அது அசல் கட்டண முறைக்குத் திரும்பப் பெறப்படும். சட்டப்படி ஆலோசனை பதிவுகள் வைக்கப்படும்.';

  @override
  String get deleteAccountHold =>
      'உங்கள் கணக்கு உடனடியாக முடக்கப்பட்டு 30 நாட்களுக்குப் பிறகு முழுமையாக நீக்கப்படும். ரத்து செய்ய 30 நாட்களுக்குள் மீண்டும் உள்நுழையவும்.';

  @override
  String get deleteAccountConfirm => 'ஆம், எனது கணக்கை நீக்கவும்';

  @override
  String get deleteAccountRequested => 'கணக்கு நீக்கக் கோரப்பட்டது';

  @override
  String get referTitle => 'பரிந்துரைத்து சம்பாதி';

  @override
  String referHeroTitle(String friendAmount, String youAmount) {
    return '$friendAmount கொடுங்கள், $youAmount பெறுங்கள்';
  }

  @override
  String referHeroBody(String friendAmount, String youAmount) {
    return 'உங்கள் நண்பருக்கு அவர்களின் முதல் ஆலோசனையில் $friendAmount தள்ளுபடி கிடைக்கும். அவர்கள் அதை எடுக்கும்போது உங்கள் வாலட்டில் $youAmount கிடைக்கும்.';
  }

  @override
  String get referYourCode => 'உங்கள் பரிந்துரை குறியீடு';

  @override
  String get referShareLink => 'அழைப்பு இணைப்பைப் பகிரவும்';

  @override
  String get referInvited => 'அழைக்கப்பட்டவர்கள்';

  @override
  String get referJoined => 'சேர்ந்தவர்கள்';

  @override
  String get referEarned => 'சம்பாதித்தது';

  @override
  String get referHowItWorks => 'இது எவ்வாறு செயல்படுகிறது';

  @override
  String get referStep1 =>
      'உங்கள் குறியீடு அல்லது இணைப்பைப் பகிரவும். உங்கள் நண்பர் பதிவு செய்யும் போது அதை உள்ளிடுவார்.';

  @override
  String referStep2(String amount) {
    return 'அவர்களின் முதல் கட்டண ஆலோசனையில் அவர்களுக்கு $amount தள்ளுபடி கிடைக்கும்.';
  }

  @override
  String referStep3(String amount) {
    return 'அந்த ஆலோசனைக் கட்டணம் செலுத்தப்பட்டவுடன், $amount உங்கள் வாலட்டில் வந்து சேரும்.';
  }

  @override
  String get referYourReferrals => 'உங்கள் பரிந்துரைகள்';

  @override
  String get referStatusPending => 'நிலுவையில் உள்ளது';

  @override
  String get referStatusJoined => 'சேர்ந்தவர்கள்';

  @override
  String get referStatusRewarded => 'வெகுமதி அளிக்கப்பட்டது';

  @override
  String referJoinedOn(String date) {
    return '$date அன்று சேர்ந்தார்';
  }

  @override
  String get referFirstCallDone => 'முதல் அழைப்பு முடிந்தது';

  @override
  String referShareText(String code, String amount, String link) {
    return 'TalkAcharya-வில் எனது குறியீடு $code-ஐப் பயன்படுத்தி உங்கள் முதல் ஜோதிட ஆலோசனையில் $amount தள்ளுபடி பெறுங்கள். $link';
  }

  @override
  String get kundaliYogasDoshasTitle => 'யோகங்கள் மற்றும் தோஷங்கள்';

  @override
  String get kundaliTabDoshas => 'தோஷங்கள்';

  @override
  String get kundaliTabYogas => 'யோகாக்கள்';

  @override
  String get doshaIntro =>
      'தோஷங்கள் என்பவை ஜாதகத்தில் உள்ள உணர்திறன் மிக்க புள்ளிகள். பெரும்பாலானவை காலப்போக்கில், ஆதரவான தசா அல்லது பாரம்பரிய பரிகாரத்தின் மூலம் மென்மையாகும் — உங்களுக்கு உண்மையில் எது முக்கியம் என்பதை ஒரு ஜோதிடர் உறுதி செய்வார்.';

  @override
  String get doshaDisclaimer =>
      'இவை அமைப்பு சார்ந்த குறிப்புகள் மட்டுமே, முன்கணிப்புகள் அல்ல. இரத்தினக்கல் அணிவதற்கு முன்போ அல்லது தீவிரமான பரிகாரத்தைத் தொடங்குவதற்கு முன்போ ஒரு ஜோதிடரிடம் பேசுங்கள்.';

  @override
  String get doshaPresent => 'தற்போது';

  @override
  String get doshaNotPresent => 'இல்லை';

  @override
  String get doshaCancelled => 'திறம்பட ரத்துசெய்';

  @override
  String get doshaSeverityClear => 'தெளிவான';

  @override
  String get doshaSeverityMild => 'மிதமான';

  @override
  String get doshaSeverityModerate => 'மிதமான';

  @override
  String get doshaSeverityStrong => 'வலுவான';

  @override
  String get doshaWhy => 'ஏன் அது கொடியிடப்பட்டுள்ளது';

  @override
  String get doshaWhatReduces => 'அதை எது குறைக்கிறது';

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
  String get doshaClearSectionTitle => 'தெளிவு — உங்கள் அட்டவணையில் இல்லை';

  @override
  String get doshaAllClear =>
      'உங்கள் ஜாதகத்தில் பொதுவான தோஷங்கள் எதுவும் இல்லை.';

  @override
  String get doshaAskCta =>
      'இது உங்களுக்கு என்ன அர்த்தம் என்பதை ஒரு ஜோதிடரிடம் கேளுங்கள்.';

  @override
  String get insightsTitle => 'ஆளுமை மற்றும் வாழ்க்கை கண்ணோட்டம்';

  @override
  String get insightsIntro =>
      'உங்கள் பிறப்பு (D1) ஜாதகத்தின் ஒரு இலவசப் பலன் — வாழ்க்கையின் முக்கியப் பகுதிகளில் அது சார்ந்திருக்கும் போக்குகள். இது சுயசிந்தனைக்கான ஒரு வரைபடமே தவிர, நிகழ்வுகள் அல்லது தேதிகளின் முன்னறிவிப்பு அல்ல.';

  @override
  String get insightsDisclaimer =>
      'உங்கள் ஜாதகத்திலிருந்து கிடைக்கும் பொதுவான வழிகாட்டுதலே தவிர, இது ஒரு முன்கணிப்பு அல்ல. இதில் எந்தத் தேதிகளும் குறிப்பிடப்படவில்லை, மேலும் உடல்நலம், ஆயுட்காலம் அல்லது உறவுகள் குறித்து எந்தக் கூற்றுகளும் கூறப்படவில்லை. குறிப்பிட்ட எதற்கேனும், ஒரு ஜோதிடரிடம் பேசுங்கள்.';

  @override
  String get insightsAskCta =>
      'உங்கள் ஜாதகத்தைப் பற்றி ஒரு ஜோதிடரிடம் கேளுங்கள்.';

  @override
  String get insightsWhatItReadsFrom => 'இதிலிருந்து என்ன படிக்கப்படுகிறது';

  @override
  String get insightsToneSupportive => 'ஆதரவான';

  @override
  String get insightsToneBalanced => 'சமநிலையான';

  @override
  String get insightsToneChallenging => 'கவனிப்பு தேவைப்படுகிறது';

  @override
  String get insightsToneMixed => 'கலப்பு';

  @override
  String get insightsAreaPersonality => 'ஆளுமை மற்றும் இயல்பு';

  @override
  String get insightsAreaAppearance => 'உடல் தோற்றம்';

  @override
  String get insightsAreaMind => 'மனம் மற்றும் உணர்ச்சிகள்';

  @override
  String get insightsAreaCareer => 'தொழில் மற்றும் பணி';

  @override
  String get insightsAreaWealth => 'செல்வம் மற்றும் நிதி';

  @override
  String get insightsAreaEducation => 'கல்வி மற்றும் அறிவுத்திறன்';

  @override
  String get insightsAreaMarriage => 'திருமணம் மற்றும் துணைவர்';

  @override
  String get insightsAreaFamily => 'குடும்பம் மற்றும் உறவுகள்';

  @override
  String get insightsAreaHealth => 'ஆரோக்கியம் மற்றும் உயிர்சக்தி';

  @override
  String get insightsAreaFortune => 'அதிர்ஷ்டம் மற்றும் தர்மம்';

  @override
  String get insightsAreaStrengths => 'பலங்கள் மற்றும் சவால்கள்';

  @override
  String get predTitle => 'கணிப்புகள்';

  @override
  String get predReadingTitle => 'உங்கள் முன்னறிவிப்பு';

  @override
  String get predRequestTitle => 'முன்னறிவிப்பைக் கோருங்கள்';

  @override
  String get predHeroTitle => 'உங்களுக்காக எழுதப்பட்ட ஒரு முன்னறிவிப்பு';

  @override
  String get predHeroBody =>
      'ஒரு ஜோதிடர் உங்கள் பிறப்பு ஜாதகம், தசா காலம் மற்றும் தற்போதைய கோச்சாரங்களைப் படித்து, உங்கள் வாழ்க்கையின் ஒரு குறிப்பிட்ட பகுதிக்கான பலனை எழுதித் தருவார். இது பொதுவாக 3 நாட்களுக்குள், உங்கள் மொழியிலேயே வழங்கப்படும்.';

  @override
  String get predChooseArea => 'ஒரு பகுதியைத் தேர்ந்தெடுக்கவும்';

  @override
  String get predMyReadings => 'உங்கள் கணிப்புகள்';

  @override
  String get predNoReadings =>
      'இன்னும் முன்னறிவிப்புகள் இல்லை. முன்னறிவிப்பைக் கோருவதற்கு மேலே உள்ள பகுதிகளில் ஒன்றைத் தேர்ந்தெடுக்கவும்.';

  @override
  String get predSeePacks => 'தொகுப்புகளைப் பார்க்கவும்';

  @override
  String get predSubscribed => 'சந்தா செலுத்தப்பட்டது';

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
  String get predBuyTitle => 'கணிப்பு வரவுகள்';

  @override
  String get predBuyBody =>
      'ஒரு கிரெடிட் = ஒரு எழுத்துப்பூர்வமான வானிலை முன்னறிவிப்பு. ஒரு பேக்கை வாங்குங்கள், உங்களுக்கு எப்போது பலன் பார்க்க வேண்டுமோ அப்போது அது தயாராக இருக்கும்.';

  @override
  String get predBuyWalletNote =>
      'உங்கள் வாலட் இருப்பிலிருந்து பணம் செலுத்தப்பட்டது.';

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
    return 'ஒரு கிரெடிட்டுக்கான $price';
  }

  @override
  String predBuySuccess(int count) {
    return 'சேர்க்கப்பட்டது. இப்போது உங்களிடம் $count கிரெடிட்கள் உள்ளன.';
  }

  @override
  String get predForProfile => 'எந்த பிறப்பு சுயவிவரத்திற்காக';

  @override
  String get predAddProfile => 'பிறப்பு சுயவிவரத்தைச் சேர்க்கவும்';

  @override
  String get predPickProfile => 'முதலில் பிறப்பு விவரத்தைத் தேர்ந்தெடுக்கவும்.';

  @override
  String get predArea => 'வாழ்க்கை பகுதி';

  @override
  String get predPeriod => 'காலம்';

  @override
  String predCostsOne(int count) {
    return 'உங்கள் $count கிரெடிட்களில் 1-ஐப் பயன்படுத்துகிறது.';
  }

  @override
  String get predNoCreditYet =>
      'உங்களுக்கு ஒரு கிரெடிட் தேவைப்படும் — அடுத்து பேக்குகளைக் காண்பிப்போம்.';

  @override
  String get predRequestCta => 'முன்னறிவிப்பைக் கோருங்கள்';

  @override
  String get predRequestDisclaimer =>
      'ஜோதிடர் உங்கள் ஜாதகம், தசா காலம் மற்றும் கோச்சாரங்களை அடிப்படையாகக் கொண்டு எழுதுகிறார். ஜோதிடம் என்பது சிந்திப்பதற்கும் திட்டமிடுவதற்குமான ஒரு வழிகாட்டுதலே தவிர, அது ஒரு உத்தரவாதம் அல்ல.';

  @override
  String get predAreaCareer => 'தொழில் மற்றும் வேலை';

  @override
  String get predAreaMarriage => 'திருமணம் மற்றும் காதல்';

  @override
  String get predAreaFinance => 'பணம் மற்றும் நிதி';

  @override
  String get predAreaHealth => 'ஆரோக்கியம் மற்றும் ஆற்றல்';

  @override
  String get predAreaEducation => 'படிப்பு மற்றும் கற்றல்';

  @override
  String get predAreaGeneral => 'வாழ்க்கை குறிப்புகள்';

  @override
  String get predPeriodMonth => 'வரவிருக்கும் மாதம்';

  @override
  String get predPeriodQuarter => 'அடுத்த 3 மாதங்கள்';

  @override
  String get predPeriodYear => 'வரவிருக்கும் ஆண்டு';

  @override
  String get predStatusWriting => 'எழுதப்பட்டு வருகிறது';

  @override
  String get predStatusReview => 'மதிப்பாய்வில்';

  @override
  String get predStatusReady => 'படிக்கத் தயார்';

  @override
  String get predStatusUnavailable => 'கிடைக்கவில்லை';

  @override
  String get predStatusRefunded => 'பணம் திரும்ப அளிக்கப்பட்டது';

  @override
  String predDeliveredOn(String date) {
    return 'வழங்கப்பட்டது $date';
  }

  @override
  String predEta(String date) {
    return '$date க்குள் எதிர்பார்க்கப்படுகிறது';
  }

  @override
  String get predWritingTitle => 'ஒரு ஜோதிடர் இதை எழுதுகிறார்';

  @override
  String get predWritingBody =>
      'அது தயாரானவுடன் உங்களுக்கு அறிவிப்பு அனுப்புவோம்.';

  @override
  String predWritingEta(String date) {
    return '$date க்குள் எதிர்பார்க்கப்படுகிறது. தயாரானதும் உங்களுக்குத் தெரிவிப்போம்.';
  }

  @override
  String get predRefundedTitle => 'வரவு வைக்கப்பட்டது';

  @override
  String get predRefundedBody =>
      'எங்களால் இதை உரிய நேரத்தில் வழங்க முடியவில்லை, எனவே உங்களுக்கான பணம் உங்கள் கணக்கிற்குத் திரும்பச் செலுத்தப்பட்டுவிட்டது.';

  @override
  String get predDisclaimer =>
      'உங்கள் பிறப்பு ஜாதகம், தசா காலம் மற்றும் தற்போதைய கோச்சாரங்களின் அடிப்படையில் ஒரு ஜோதிடரால் உங்களுக்காக எழுதப்பட்டது. ஜோதிடம் என்பது ஆழ்ந்து சிந்திப்பதற்கும் திட்டமிடுவதற்குமான ஒரு வழிகாட்டுதலாகும் — உங்கள் தேர்வுகளும் அதன் விளைவுகளும் உங்களுக்கே உரியவை.';

  @override
  String get predAskFollowUp => 'தொடர் கேள்வி கேளுங்கள்';

  @override
  String get remediesTitle => 'தீர்வுகள்';

  @override
  String get remediesIntro =>
      'உங்கள் ஜாதகத்தில் காணப்படும் தீவிரமாகச் செயல்படும் தோஷங்கள், பலவீனமான கிரகங்கள், நடப்பு தசா காலம் மற்றும் இறுக்கமான பாவங்கள் ஆகியவற்றுக்குப் பொருத்தமான பாரம்பரிய பரிகாரங்கள். அவை உங்கள் நம்பிக்கை, உடல்நலம் மற்றும் வசதிக்கு ஏற்றவாறு தேர்ந்தெடுக்கப்பட்ட, ஒழுக்கம் மற்றும் பக்தியின் செயல்களாகும்.';

  @override
  String get remediesNone =>
      'உங்கள் ஜாதகத்தில், தற்சமயம் ஒரு குறிப்பிட்ட பரிகாரம் தேவைப்படும்படியான எதுவும் இல்லை. ஒரு சிறிய, சீரான தினசரிப் பழக்கத்தைக் கடைப்பிடிப்பது எப்போதுமே பயனுள்ளது.';

  @override
  String get remediesDisclaimer =>
      'உங்கள் நம்பிக்கை, உடல்நிலை மற்றும் வசதிக்கு ஏற்றதை மட்டும் செய்யுங்கள். நோன்பு இருப்பது உங்களுக்குப் பாதுகாப்பற்றதாக இருந்தால் அதைத் தவிர்த்துவிடுங்கள், மேலும் தர்மம் செய்ய ஒருபோதும் கடன் வாங்காதீர்கள்.';

  @override
  String get remediesAskCta =>
      'உங்கள் பரிகாரங்கள் குறித்து ஒரு ஜோதிடரிடம் பேசுங்கள்.';

  @override
  String get remediesConfirmCta =>
      'முதலில் ஒரு ஜோதிடரிடம் உறுதிப்படுத்திக் கொள்ளுங்கள்.';

  @override
  String remediesSource(String source) {
    return 'ஆதாரம்: $source';
  }

  @override
  String get doshaSeeRemedies => 'உங்கள் ஜாதகத்திற்கான பரிகாரங்களைக் காண்க';

  @override
  String get remedyCatMantra => 'மந்திரம் மற்றும் ஜபம்';

  @override
  String get remedyCatStotra => 'ஸ்தோத்திரம் மற்றும் பாராயணம்';

  @override
  String get remedyCatPuja => 'பூஜை மற்றும் சடங்கு';

  @override
  String get remedyCatVrat => 'விரதம் மற்றும் உண்ணாவிரதம்';

  @override
  String get remedyCatDaan => 'தான் மற்றும் தொண்டு';

  @override
  String get remedyCatLifestyle => 'வாழ்க்கை முறை';

  @override
  String get remedyCatYantra => 'யந்திரம்';

  @override
  String get remedyCatGemstone => 'ரத்தினக்கல்';

  @override
  String get remedyCatRudraksha => 'ருத்ராட்சம்';

  @override
  String get prashnaTitle => 'ஒரு கேள்வி கேளுங்கள்';

  @override
  String get prashnaHeroTitle => 'அந்தத் தருணத்தில் ஆம் அல்லது இல்லை';

  @override
  String get prashnaHeroBody =>
      'கே.பி. பிரசன்னம் (கே.பி. ஹோரரி), நீங்கள் ஒரு கேள்வியைக் கேட்கும் சரியான கணத்தில், அதற்கான காரணத்துடன் ஆம், இல்லை அல்லது கலவையான ஒரு நிலைப்பாட்டைக் கூறுகிறது. இது ஒரு பாரம்பரிய முறையின் வழிகாட்டியே தவிர, ஒரு வாக்குறுதி அல்ல.';

  @override
  String get prashnaAbout => 'கேள்வி எதைப் பற்றியது?';

  @override
  String get prashnaHint => 'உதாரணமாக, எனக்கு இந்த வேலை வாய்ப்பு கிடைக்குமா?';

  @override
  String prashnaAskCta(String price) {
    return '( $price ) கேளுங்கள்';
  }

  @override
  String get prashnaDisclaimer =>
      'நீங்கள் கேட்ட தருணத்திற்கான ஒரு கே.பி. நேரக் கணிப்பு. இது ஒரு பாரம்பரிய முறையின் சுட்டிக்காட்டி மட்டுமே — ஒரு வாக்குறுதியல்ல, முழுமையான கலந்தாலோசனைக்கு மாற்றானதும் அல்ல.';

  @override
  String get prashnaNeedQuestion =>
      'ஒரு தலைப்பைத் தேர்ந்தெடுத்து, முதலில் உங்கள் கேள்வியைத் தட்டச்சு செய்யவும்.';

  @override
  String get prashnaLowBalance =>
      'உங்கள் பணப்பையில் இருப்பு மிகவும் குறைவாக உள்ளது. கேட்கும் அளவிற்குப் பணத்தைச் சேர்க்கவும்.';

  @override
  String get prashnaHistory => 'உங்கள் கேள்விகள்';

  @override
  String get prashnaNoHistory => 'நீங்கள் இன்னும் கேள்வி கேட்கவில்லை.';

  @override
  String get prashnaAnswerTitle => 'வாசிப்பு';

  @override
  String get prashnaAskAstrologer => 'ஒரு ஜோதிடரிடம் இதுபற்றிப் பேசுங்கள்.';

  @override
  String get prashnaHowRead => 'இது எவ்வாறு வாசிக்கப்பட்டது';

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
  String get prashnaVerdictYes => 'ஆம் எனச் சாய்கிறேன்';

  @override
  String get prashnaVerdictNo => 'சாய்வு இல்லை';

  @override
  String get prashnaVerdictMixed => 'கலவையான சமிக்ஞைகள்';

  @override
  String get prashnaVerdictUnclear => 'தீர்மானமற்றது';

  @override
  String get prashnaCatMarriage => 'திருமணம்';

  @override
  String get prashnaCatJob => 'ஒரு வேலை';

  @override
  String get prashnaCatPromotion => 'விளம்பரம்';

  @override
  String get prashnaCatBusiness => 'வணிகம்';

  @override
  String get prashnaCatProperty => 'சொத்து';

  @override
  String get prashnaCatMoney => 'ஒரு கடன் அல்லது பணம்';

  @override
  String get prashnaCatChild => 'குழந்தைகள்';

  @override
  String get prashnaCatTravel => 'வெளிநாட்டுப் பயணம்';

  @override
  String get prashnaCatLitigation => 'ஒரு நீதிமன்ற வழக்கு';

  @override
  String get prashnaCatHealth => 'உடல்நலம் மற்றும் மீட்பு';

  @override
  String get prashnaCatLost => 'தொலைந்த பொருள்';

  @override
  String get prashnaCatReunion => 'ஒரு சந்திப்பு';

  @override
  String get prashnaCatGeneral => 'வேறு ஏதோ';

  @override
  String get yogaIntro =>
      'யோகங்கள் என்பவை போக்குகளே தவிர, உத்தரவாதங்கள் அல்ல — சம்பந்தப்பட்ட கிரகங்கள் நல்ல நிலையில் அமைந்து, தசா காலத்தில் இயங்கும்போது அவை வலுப்பெறுகின்றன.';

  @override
  String get yogaNoneTitle => 'பாரம்பரிய யோகாக்கள் எதுவும் கண்டறியப்படவில்லை';

  @override
  String get yogaNoneBody =>
      'அது பொதுவானதுதான், கெட்ட அறிகுறியும் அல்ல — ஜாதகம் இன்னமும் அதன் வீடுகள் மற்றும் தசா மூலமாகவே படிக்கப்படுகிறது.';

  @override
  String get kundaliTalkToAstrologer => 'ஒரு ஜோதிடரிடம் பேசுங்கள்';

  @override
  String get kundaliHowItPlaysOut =>
      'இவை உங்கள் வாழ்க்கையிலும் நேரத்திலும் எவ்வாறு வெளிப்படுகின்றன என்பதைத் தெரிந்துகொள்ள விரும்புகிறீர்களா?';

  @override
  String get yogaGajakesariName => 'கஜகேசரி யோகா';

  @override
  String get yogaGajakesariMeaning =>
      'சந்திரனிலிருந்து கேந்திரத்தில் வியாழன் — நிதானம், சிறந்த முடிவெடுக்கும் திறன் மற்றும் மதிப்புமிக்க பெயர்.';

  @override
  String get yogaBudhadityaName => 'புத்தாதித்ய யோகா';

  @override
  String get yogaBudhadityaMeaning =>
      'சூரியனும் புதனும் இணைந்தால் — கூர்மையான, வெளிப்படுத்தும் திறன் கொண்ட மனம்; படிப்பதற்கும், எழுதுவதற்கும், பகுப்பாய்வு செய்வதற்கும் வலிமையானது.';

  @override
  String get yogaChandraMangalaName => 'சந்திர-மங்கள யோகா';

  @override
  String get yogaChandraMangalaMeaning =>
      'சந்திரன் செவ்வாயுடன் — பணம் மற்றும் தொழில்முனைப்பைச் சார்ந்த இயக்கம்; முயற்சி மற்றும் முன்முயற்சியின் மூலம் சம்பாதித்தல்.';

  @override
  String get yogaRajaName => 'ராஜ யோகம்';

  @override
  String get yogaRajaMeaning =>
      'கேந்திர அதிபதி திரிகோண அதிபதியுடன் தொடர்புடையவர் என்றால், அந்தக் காலம் தொடரும்போது அந்தஸ்து, அதிகாரம் மற்றும் வாய்ப்புகளில் உயர்வு ஏற்படும்.';

  @override
  String get yogaDhanaName => 'தன யோகா';

  @override
  String get yogaDhanaMeaning =>
      'செல்வமும் ஆதாயங்களும் ஒன்றோடொன்று இணைந்திருப்பது, சேமிப்பையும் நிலையான நிதி வளர்ச்சியையும் ஆதரிக்கிறது.';

  @override
  String get yogaNeechabhangaName => 'நீச்சபங்க ராஜ யோகம்';

  @override
  String get yogaNeechabhangaMeaning =>
      'பலவீனமடைந்த ஒரு கிரகத்தின் பலவீனம் ரத்து செய்யப்படுகிறது — ஆரம்பகாலப் போராட்டம் வலிமையாக மாறுகிறது.';

  @override
  String get yogaKaalSarpaName => 'கால சர்ப்ப யோகா';

  @override
  String get yogaKaalSarpaMeaning =>
      'ராகு-கேது அச்சின் ஒரு பக்கத்தில் ஏழு கிரகங்களும் இருப்பதால், ஒரு தெளிவான திசை கிடைக்கும் வரை வாழ்க்கை நெருக்கடிக்குள்ளானது போல் உணரலாம்.';

  @override
  String get yogaAdhiName => 'அதி யோகா';

  @override
  String get yogaAdhiMeaning =>
      'சந்திரனிலிருந்து 6, 7 மற்றும் 8 ஆம் வீடுகளில் உள்ள சுப கிரகங்கள் — பாதுகாப்பு, திறமையான உதவியாளர்கள் மற்றும் ஒரு நிலையான நிலை.';

  @override
  String get yogaShakataName => 'ஷகத யோகா';

  @override
  String get yogaShakataMeaning =>
      'வியாழனிலிருந்து 6, 8 அல்லது 12 ஆம் வீட்டில் சந்திரன் — ஏற்ற இறக்கமுள்ள அதிர்ஷ்டம்; சந்திரன் வலுவாக இருக்கும்போது நிலையானது.';

  @override
  String get yogaVishName => 'விஷ் யோகா';

  @override
  String get yogaVishMeaning =>
      'சந்திரன் சனியுடன் சேரும்போது — மனம் பாரமாகக் காணப்படும்; பக்குவமடையும்போதுதான் பலன்கள் தாமதமாகக் கிடைக்கும்.';

  @override
  String get yogaKahalaName => 'கஹலா யோகா';

  @override
  String get yogaKahalaMeaning =>
      'பலமான லக்னாதிபதியுடன் 4 மற்றும் 9 ஆம் அதிபதிகள் பரஸ்பர கேந்திரத்தில் இருப்பது — துணிச்சலான, முயற்சிமிக்க, இடர் எடுக்கத் தயாராக இருப்பவர்.';

  @override
  String get yogaPushkalaName => 'புஷ்கலா யோகா';

  @override
  String get yogaPushkalaMeaning =>
      'கேந்திரத்தில் சந்திர அதிபதியும் லக்னாதிபதியும் — மரியாதை, நற்பெயர் மற்றும் வசியப்படுத்தும் பேச்சுத்திறன்.';

  @override
  String get yogaDaridraName => 'தரித்ரா யோகா';

  @override
  String get yogaDaridraMeaning =>
      '11-ஆம் அதிபதி (லாபம்) கடினமான வீட்டில் வீழ்ந்துள்ளார் — லாபங்கள் மெதுவாக வரும்; ஒரு பலமான தசா நிலைமையை மாற்றிவிடும்.';

  @override
  String get yogaAmalaName => 'அமலா யோகா';

  @override
  String get yogaAmalaMeaning =>
      'லக்னம் அல்லது சந்திரனிலிருந்து பத்தாம் வீட்டில் உள்ள சுப கிரகம் மட்டுமே — களங்கமற்ற நற்பெயரையும் நீடித்த நல்லெண்ணத்தையும் தரும்.';

  @override
  String get yogaSaraswatiName => 'சரஸ்வதி யோகா';

  @override
  String get yogaSaraswatiMeaning =>
      'புதன், சுக்கிரன் மற்றும் வலிமையான வியாழன் நல்ல நிலையில் அமைந்தால் — கல்வி, கலை மற்றும் சொல்லாற்றல் மேம்படும்.';

  @override
  String get yogaLakshmiName => 'லட்சுமி யோகா';

  @override
  String get yogaLakshmiMeaning =>
      'கேந்திரத்திலோ அல்லது திரிகோணத்திலோ பலமான லக்னாதிபதியுடன் பலமான 9-ஆம் அதிபதி — செல்வம், சுகம் மற்றும் அருள்.';

  @override
  String get yogaRuchakaName => 'ருச்சக யோகம்';

  @override
  String get yogaRuchakaMeaning =>
      'கேந்திரத்தில் செவ்வாய் வலுவாக உள்ளது — தைரியம், உடல் வலிமை மற்றும் நெருக்கடியான சூழ்நிலைகளில் தலைமைப் பண்பு.';

  @override
  String get yogaBhadraName => 'பத்ரா யோகா';

  @override
  String get yogaBhadraMeaning =>
      'கேந்திரத்தில் புதன் வலுவாக இருந்தால் — நுண்ணறிவு, தெளிவான பேச்சு மற்றும் வர்த்தகம், தகவல் தொடர்பில் திறமை.';

  @override
  String get yogaHamsaName => 'ஹம்சா யோகா';

  @override
  String get yogaHamsaMeaning =>
      'கேந்திரத்தில் வியாழன் வலுவாக இருந்தால் — ஞானம், நன்னெறி, போதிக்கும் அல்லது அறிவுரை வழங்கும் குணம் மற்றும் பொதுவான நல்ல அதிர்ஷ்டம் கிடைக்கும்.';

  @override
  String get yogaMalavyaName => 'மாலவ்ய யோகா';

  @override
  String get yogaMalavyaMeaning =>
      'கேந்திரத்தில் சுக்கிரன் வலுவாக இருந்தால் — வசீகரம், சுகம், அழகை ரசிக்கும் பார்வை மற்றும் இனிமையான இல்லற வாழ்க்கை.';

  @override
  String get yogaSasaName => 'சசா யோகா';

  @override
  String get yogaSasaMeaning =>
      'கேந்திரத்தில் சனி வலுவாக இருந்தால் — ஒழுக்கம், சகிப்புத்தன்மை மற்றும் அதிகாரம் ஆகியவை மெதுவாகக் கட்டமைக்கப்பட்டுப் பாதுகாக்கப்படும்.';

  @override
  String get yogaUbhayachariName => 'உபயாச்சாரி யோகா';

  @override
  String get yogaUbhayachariMeaning =>
      'சூரியனின் இருபுறமும் கோள்கள் — நன்கு ஆதரிக்கப்படும், புலப்படும் வாழ்க்கை மற்றும் அனைத்து வகையிலும் நல்ல நிலை.';

  @override
  String get yogaVesiName => 'வேசி யோகா';

  @override
  String get yogaVesiMeaning =>
      'சூரியனிலிருந்து இரண்டாம் வீட்டில் உள்ள ஒரு கிரகம் — நிலையான பேச்சு, சமநிலையான கண்ணோட்டம் மற்றும் அழகான பெயர்.';

  @override
  String get yogaVasiName => 'வாசி யோகா';

  @override
  String get yogaVasiMeaning =>
      'சூரியனிலிருந்து 12-ஆம் வீட்டில் உள்ள ஒரு கிரகம் — ஆற்றல், செல்வாக்கு மற்றும் தாராள குணம்.';

  @override
  String get yogaShubhaKartariName => 'சுப கர்த்தாரி யோகா';

  @override
  String get yogaShubhaKartariMeaning =>
      'லக்னத்தின் இருபுறமும் உள்ள சுப காரியங்கள் — பாதுகாப்பு, மென்மையான பாதை மற்றும் சாதகமான சூழ்நிலைகள்.';

  @override
  String get yogaPapaKartariName => 'பாப்பா கர்த்தாரி யோகா';

  @override
  String get yogaPapaKartariMeaning =>
      'லக்னத்தின் இருபுறமும் உள்ள அசுப கிரகங்கள் — சுயத்திற்கும் உடல்நலத்திற்கும் அழுத்தம்; உங்கள் ஆற்றலையும் எல்லைகளையும் பாதுகாத்துக் கொள்ளுங்கள்.';

  @override
  String get yogaDurudharaName => 'துரூதார யோகா';

  @override
  String get yogaDurudharaMeaning =>
      '2-ஆம் மற்றும் 12-ஆம் வீடுகளில் கிரகங்கள் சந்திரனுக்கு இருபுறமும் அமைந்துள்ளன — இது உங்களைச் சுற்றியுள்ள வளங்கள், ஆறுதல் மற்றும் நிலையான ஆதரவைக் குறிக்கிறது.';

  @override
  String get yogaSunaphaName => 'சுனபா யோகா';

  @override
  String get yogaSunaphaMeaning =>
      'சந்திரனிலிருந்து இரண்டாம் வீட்டில் உள்ள கிரகம் — சுயமுயற்சியால் முன்னேறிய செல்வம், நுண்ணறிவு மற்றும் நற்பெயர்.';

  @override
  String get yogaAnaphaName => 'அனபா புகைப்படம்';

  @override
  String get yogaAnaphaMeaning =>
      'சந்திரனிலிருந்து 12-ஆம் வீட்டில் ஒரு கிரகம் — எளிமையான குணம், நல்வாழ்வு மற்றும் தேவைகளிலிருந்து விடுதலை.';

  @override
  String get yogaKemadrumaYogaName => 'கெமத்ருமா யோகா';

  @override
  String get yogaKemadrumaYogaMeaning =>
      'சந்திரன் ஆதரவின்றித் தனித்து நிற்கிறது — சந்திரன் வலிமையாக இருக்கும்போதோ அல்லது கேந்திரம் செயல்படும்போதோ தணியும் ஒரு உள்ளார்ந்த அமைதியின்மை இது.';

  @override
  String get yogaVasumatiName => 'வாசுமதி யோகா';

  @override
  String get yogaVasumatiMeaning =>
      'லக்னம் அல்லது சந்திரனிலிருந்து வளர்ச்சி வீடுகளில் உள்ள சுப கிரகங்கள் — செல்வம் குவிதல் மற்றும் வளங்கள் பெருகுதல்.';

  @override
  String get yogaKalanidhiName => 'கலநிதி யோகா';

  @override
  String get yogaKalanidhiMeaning =>
      '2ஆம் அல்லது 5ஆம் வீட்டில் புதன் அல்லது சுக்கிரனுடன் இணைந்த வியாழன் — கல்வி, கலைகள், பண்பாடு மற்றும் கௌரவம்.';

  @override
  String get yogaChamaraName => 'சாமரா யோகா';

  @override
  String get yogaChamaraMeaning =>
      'கேந்திரத்தில் உச்சம் பெற்ற லக்னாதிபதி, குருவின் பார்வை பெற்றால் — நாவன்மை, நீண்ட ஆயுள் மற்றும் மரியாதைக்குரிய அந்தஸ்து.';

  @override
  String get yogaShankhaName => 'சங்க யோகா';

  @override
  String get yogaShankhaMeaning =>
      '5 மற்றும் 6 ஆம் அதிபதிகள் பலமான லக்னாதிபதியுடன் இணைந்தால் — நல்ல வாழ்க்கை, கனிவான குணம் மற்றும் பிற்காலத்தில் சுகம் கிடைக்கும்.';

  @override
  String get yogaParvataName => 'பர்வத யோகா';

  @override
  String get yogaParvataMeaning =>
      'கேந்திரங்களில் 6 மற்றும் 8 ஆம் வீடுகள் தூய்மையாக இருந்தால் சுப கிரகங்கள் — அதிர்ஷ்டம், தாராள குணம் மற்றும் புகழ்பெற்ற பெயர்.';

  @override
  String get yogaHarshaName => 'ஹர்ஷா யோகா';

  @override
  String get yogaHarshaMeaning =>
      'சவாலான வீட்டில் ஆறாம் அதிபதி — எதிரிகள், கடன்கள் மற்றும் நோய் ஆகியவற்றின் பிடி தளர்ந்துவிடும்; போட்டித்திறன் அதிகரிக்கும்.';

  @override
  String get yogaSaralaName => 'சரளா யோகா';

  @override
  String get yogaSaralaMeaning =>
      'கடினமான வீட்டில் எட்டாம் அதிபதி — நெருக்கடிகளைத் தாங்கும் ஆற்றல், நீண்ட ஆயுள் மற்றும் அச்சமின்மை.';

  @override
  String get yogaVimalaName => 'விமலா யோகா';

  @override
  String get yogaVimalaMeaning =>
      'சவாலான வீட்டில் பன்னிரண்டாம் அதிபதி — கட்டுப்படுத்தப்பட்ட செலவு, தூய்மையான மனசாட்சி மற்றும் சுதந்திரமான வாழ்க்கை.';

  @override
  String get yogaMahaParivartanaName => 'மகா பரிவர்த்தன யோகா';

  @override
  String get yogaMahaParivartanaMeaning =>
      'நல்ல வீடுகளின் இரு அதிபதிகள் ராசிகளைப் பரிமாறிக் கொள்கிறார்கள் — காலப்போக்கில் இரு வீடுகளின் விவகாரங்களும் ஒன்றையொன்று மேம்படுத்துகின்றன.';

  @override
  String get yogaKhalaParivartanaName => 'கால பரிவர்தன யோகா';

  @override
  String get yogaKhalaParivartanaMeaning =>
      'மூன்றாம் வீடு சம்பந்தப்பட்ட ஒரு பரிமாற்றம் — கலவையான பலன்கள், ஏற்ற இறக்கங்கள், முயற்சி மற்றும் தைரியத்தின் மூலம் ஆதாயங்கள்.';

  @override
  String get yogaDainyaParivartanaName => 'தைன்ய பரிவர்தன யோகா';

  @override
  String get yogaDainyaParivartanaMeaning =>
      'கடினமான ஒரு வீட்டை உள்ளடக்கிய பரிமாற்றம் — பொறுமை தேவைப்படும் தடைகள்; ஒரு வலிமையான தசா அதை மாற்றிவிடும்.';

  @override
  String get kSignAries => 'துணிச்சலான, நேரடியான, விரைவாகத் தொடங்கும்';

  @override
  String get kSignTaurus =>
      'நிலையான, சிற்றின்ப உணர்வுள்ள, சுகம் மற்றும் பாதுகாப்பிற்கு மதிப்பளிப்பவர்';

  @override
  String get kSignGemini =>
      'ஆர்வமுள்ள, பேச்சுத் திறன் கொண்ட, விரைவாகச் சிந்திக்கும்';

  @override
  String get kSignCancer =>
      'அக்கறையுள்ள, பாதுகாப்பான, உணர்வால் வழிநடத்தப்படும்';

  @override
  String get kSignLeo => 'பெருமிதம், அன்பு, பிறரால் பார்க்கப்பட விரும்புகிறார்';

  @override
  String get kSignVirgo => 'துல்லியமான, பயனுள்ள, மேம்படுத்தும் நோக்கம் கொண்ட';

  @override
  String get kSignLibra => 'நியாயமான, உறவுகளைப் பேணும், சமநிலையை நாடும்';

  @override
  String get kSignScorpio =>
      'தீவிரமான, தனிப்பட்ட, எல்லாமே அல்லது ஒன்றுமே இல்லை';

  @override
  String get kSignSagittarius =>
      'சுதந்திரமான, நம்பிக்கையுள்ள, பரந்த கண்ணோட்டம்';

  @override
  String get kSignCapricorn =>
      'ஒழுக்கமான, லட்சியம் மிக்க, நீண்ட காலத் திட்டத்துடன் செயல்படுபவர்';

  @override
  String get kSignAquarius => 'சுதந்திரமான, அமைப்பு சார்ந்த, மரபுசாரா';

  @override
  String get kSignPisces => 'கற்பனைத்திறன் மிக்க, இரக்கமுள்ள, எல்லையற்ற';

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
  String get kPlanetSun => 'ஆன்மா, நம்பிக்கை, தந்தை, அதிகாரம்';

  @override
  String get kPlanetMoon => 'மனம், உணர்ச்சிகள், தாய், ஆறுதல்';

  @override
  String get kPlanetMars => 'உந்துதல், தைரியம், கோபம், உடன்பிறப்புகள்';

  @override
  String get kPlanetMercury => 'அறிவுத்திறன், பேச்சு, தொழில், திறமை';

  @override
  String get kPlanetJupiter =>
      'ஞானம், வளர்ச்சி, அதிர்ஷ்டம், ஆசிரியர்கள், குழந்தைகள்';

  @override
  String get kPlanetVenus => 'அன்பு, அழகு, ஆறுதல், கூட்டுறவு, கலை';

  @override
  String get kPlanetSaturn =>
      'ஒழுக்கம், நேரம், வரம்புகள், கடினமாகப் பெற்ற வெகுமதி';

  @override
  String get kPlanetRahu => 'லட்சியம், மோகம், அந்நிய மற்றும் புதிய';

  @override
  String get kPlanetKetu => 'பற்றின்மை, தேர்ச்சி, விட்டுக்கொடுத்தல், ஆன்மீகம்';

  @override
  String get kHouse1 => 'சுயம், உடல், உயிர்சக்தி';

  @override
  String get kHouse2 => 'செல்வம், குடும்பம், பேச்சு, உணவு';

  @override
  String get kHouse3 => 'தைரியம், உடன்பிறப்புகள், முயற்சி, குறுகிய பயணம்';

  @override
  String get kHouse4 => 'வீடு, தாய், நிலம், மன அமைதி';

  @override
  String get kHouse5 => 'குழந்தைகள், கல்வி, படைப்பாற்றல், காதல்';

  @override
  String get kHouse6 => 'உடல்நலம், கடன், எதிரிகள், அன்றாட வேலை';

  @override
  String get kHouse7 => 'திருமணம், கூட்டாண்மை, வணிகம்';

  @override
  String get kHouse8 =>
      'நீண்ட ஆயுள், திடீர் மாற்றம், மறைக்கப்பட்டவை, வாரிசுரிமை';

  @override
  String get kHouse9 => 'செல்வம், தர்மம், தந்தை, உயர் கல்வி, நீண்ட பயணம்';

  @override
  String get kHouse10 => 'தொழில், அந்தஸ்து, பொது வாழ்க்கை';

  @override
  String get kHouse11 =>
      'வருமானம், ஆதாயங்கள், தொடர்பு வட்டம், மூத்த உடன்பிறப்புகள்';

  @override
  String get kHouse12 => 'இழப்பு, செலவுகள், அயல்நாடுகள், உறக்கம், விடுதலை';

  @override
  String get kDignityExalted => 'மேன்மைப்படுத்தப்பட்ட — மிகவும் வலிமையான';

  @override
  String get kDignityDebilitated =>
      'பலவீனமடைந்துள்ளது — இங்கே அழுத்தத்தில் உள்ளது';

  @override
  String get kDignityMoolatrikona => 'மூலத்திரிகோனா — வசதியான மற்றும் வலிமையான';

  @override
  String get kDignityOwn => 'சொந்த ராசி — நிலையான மற்றும் பயனுள்ள';

  @override
  String get kDignityGreatFriend =>
      'ஒரு சிறந்த நண்பரின் அடையாளத்தில் — ஆதரிக்கப்பட்டது';

  @override
  String get kDignityFriend => 'நண்பரின் அடையாளத்தில் — ஆதரவு';

  @override
  String get kDignityNeutral => 'நடுநிலை அடையாளம்';

  @override
  String get kDignityEnemy =>
      'எதிரியின் ராசியில் இருந்தால் — கடினமாக உழைப்பார்.';

  @override
  String get kDignityGreatEnemy =>
      'பெரும் எதிரியின் அடையாளத்தில் — அழுத்தத்தின் கீழ்';

  @override
  String get kDashaSun =>
      'அடையாளம், அதிகாரம் மற்றும் அங்கீகாரத்திற்கான காலகட்டம். அகங்காரமும், கண்கள்/இதயத்தின் நலனும் கவனத்தில் கொள்ளப்படுகின்றன.';

  @override
  String get kDashaMoon =>
      'மென்மையான, அதிக உணர்ச்சிப்பூர்வமான ஒரு அத்தியாயம் — வீடு, தாய், மனநிலைகள் மற்றும் பொது வாழ்க்கை.';

  @override
  String get kDashaMars =>
      'ஆற்றல், போட்டி மற்றும் முன்முயற்சி அதிகரிக்கும். கோபம், விபத்துகள் மற்றும் சொத்து விஷயங்களைக் கவனியுங்கள்.';

  @override
  String get kDashaMercury =>
      'கற்றல், வர்த்தகம், எழுதுதல் மற்றும் தகவல் தொடர்பு. படிப்புக்கும் வணிகத்திற்கும் உகந்தது, அமைதியை விரும்பும் அமைதியற்றவர்.';

  @override
  String get kDashaJupiter =>
      'வளர்ச்சி, ஆசிரியர்கள், குடும்பம், வாழ்வின் அர்த்தம். பெரும்பாலும் ஒரு அதிர்ஷ்டமான, விரிவான காலகட்டம்.';

  @override
  String get kDashaVenus =>
      'உறவுகள், சுகம், கலை, பணம் மற்றும் இன்பம். பொதுவாக, காலகட்டங்களிலேயே இதுதான் மிகவும் எளிமையானது.';

  @override
  String get kDashaSaturn =>
      'கடின உழைப்பு, பொறுப்பு மற்றும் மெதுவான, நீடித்த பலன்கள். பொறுமைக்கு வெகுமதி அளிக்கிறது; குறுக்குவழிகளைத் தண்டிக்கிறது.';

  @override
  String get kDashaRahu =>
      'எல்லையற்ற லட்சியம் — அயல்நாடுகள், தொழில்நுட்பம், திடீர் உயர்வுகள் மற்றும் குழப்பம்.';

  @override
  String get kDashaKetu =>
      'பற்றின்மை, முடிவுகள் மற்றும் ஆன்மீக உள்நோக்கல். பௌதிகப் பொருட்கள் உள்ளீடற்றதாகத் தோன்றுகின்றன; திறமை ஆழமாகிறது.';

  @override
  String get kNakAshwini => 'விரைவான, முன்னோடியான, குணப்படுத்தும்';

  @override
  String get kNakBharani => 'தீவிரமான, மாற்றத்திற்கான இடமளிக்கும், ஒழுக்கமான';

  @override
  String get kNakKrittika => 'கூர்மையான, ஊடுருவிச் செல்லும், பாதுகாப்பான';

  @override
  String get kNakRohini =>
      'படைப்பாற்றல் மிக்க, சிற்றின்ப உணர்வுள்ள, அரவணைக்கும், காந்த சக்தி கொண்ட';

  @override
  String get kNakMrigashira => 'தேடும், ஆர்வமுள்ள, மென்மையான';

  @override
  String get kNakArdra =>
      'புயல் போன்ற, உருமாற்றும், நெருக்கடியான சூழ்நிலையிலும் அபாரமான திறமை';

  @override
  String get kNakPunarvasu =>
      'புதுப்பித்தல், தாராளமான, பாதுகாப்பிற்குத் திரும்புதல்';

  @override
  String get kNakPushya => 'ஊட்டமளிக்கும், கடமையுணர்வுள்ள, ஆழ்ந்த ஆதரவளிக்கும்';

  @override
  String get kNakAshlesha => 'கூர்மையான, வியூகமிக்க, மயக்கும்';

  @override
  String get kNakMagha => 'கம்பீரமான, மரபு சார்ந்த, மூதாதையர்';

  @override
  String get kNakPurvaPhalguni =>
      'விளையாட்டுத்தனமான, காதல் உணர்வுள்ள, ஓய்வை மதிக்கும்';

  @override
  String get kNakUttaraPhalguni => 'நம்பகமான, ஒப்பந்த அடிப்படையிலான, உதவிகரமான';

  @override
  String get kNakHasta =>
      'கைகளால் திறமையாக வேலை செய்பவர், புத்திசாலி, குணப்படுத்துபவர்';

  @override
  String get kNakChitra =>
      'கலைநயம் மிக்க, பிரமிக்க வைக்கும், அழகான பொருட்களை உருவாக்குகிறார்';

  @override
  String get kNakSwati =>
      'சுதந்திரமான, சூழ்நிலைக்கேற்ப தன்னை மாற்றிக்கொள்ளும், சுதந்திரத்தை விரும்பும்';

  @override
  String get kNakVishakha => 'குறிக்கோள் சார்ந்த, உறுதியான, இரட்டை இயல்புடைய';

  @override
  String get kNakAnuradha =>
      'அர்ப்பணிப்புள்ள, நட்பான, வெளிநாடுகளில் சிறந்து விளங்கும்';

  @override
  String get kNakJyeshtha => 'மூத்த, பொறுப்புள்ள, சுமைகளைச் சுமக்கிறார்';

  @override
  String get kNakMula => 'மூலத்தைத் தேடும், தீவிரமான, மையத்தை ஊடுருவும்';

  @override
  String get kNakPurvaAshadha => 'வெல்ல முடியாத மன உறுதி, இணங்க வைக்கும் திறன்';

  @override
  String get kNakUttaraAshadha =>
      'கொள்கைப்பிடிப்புள்ள, நீடித்த, பிற்கால வெற்றி';

  @override
  String get kNakShravana => 'கவனித்தல், கற்றல், மக்களை இணைத்தல்';

  @override
  String get kNakDhanishta =>
      'தாளம் சார்ந்த, செல்வந்த, இசை சார்ந்த, தகவமைத்துக் கொள்ளக்கூடிய';

  @override
  String get kNakShatabhisha => 'தனிப்பட்ட, குணப்படுத்தும், அமைப்பு சார்ந்த';

  @override
  String get kNakPurvaBhadrapada =>
      'இலட்சியவாத, தீவிரமான, மாற்றத்தை உண்டாக்கும்';

  @override
  String get kNakUttaraBhadrapada => 'ஆழ்ந்த, அமைதியான, ஞானமான ஆலோசனை';

  @override
  String get kNakRevati =>
      'அன்பான, பயணிகளைப் பாதுகாக்கும், கற்பனைத்திறன் மிக்க';

  @override
  String get kSadeSatiRising =>
      'உதயமாகும் பருவம் — உங்கள் சந்திரனிலிருந்து 12-வது ராசியில் சனி உள்ளது. முடிவுகள், சோர்வு மற்றும் காரியங்கள் முடிவுக்கு வரும் உணர்வு. இனி பயனளிக்காதவற்றை அகற்றத் தொடங்குங்கள்.';

  @override
  String get kSadeSatiPeak =>
      'உச்சக்கட்டம் — சனி உங்கள் சந்திர ராசிக்கு நேர் மேலே உள்ளது. மிகக் கடுமையான காலகட்டம்: பொறுப்பு, அழுத்தம் மற்றும் மெதுவான முன்னேற்றம். வழக்கமான நடைமுறைகளைப் பின்பற்றுங்கள், உங்கள் ஆரோக்கியத்தைப் பாதுகாத்துக் கொள்ளுங்கள்.';

  @override
  String get kSadeSatiSetting =>
      'அஸ்தமன காலம் — உங்கள் சந்திரனிலிருந்து இரண்டாவது ராசியில் சனி உள்ளது. மனச்சுமை நீங்கும். பணமும் குடும்பமும் நிலைபெறும்; கடந்த ஆண்டுகளின் பாடங்கள் பலனளிக்கத் தொடங்கும்.';

  @override
  String get kSadeSatiGeneric =>
      'சனி உங்கள் சந்திரனைச் சுற்றி ராசிகளில் சஞ்சரிக்கிறது.';

  @override
  String kPlanetInSignHouse(
    Object planet,
    Object sign,
    Object signTrait,
    Object house,
    Object houseTheme,
  ) {
    return '$sign உள்ள உங்கள் $planet உங்களை $signTrait ஆக்குகிறது. $house வீட்டில் அது $houseTheme ஐத் தொடுகிறது.';
  }

  @override
  String kPlanetInSign(Object planet, Object sign, Object signTrait) {
    return 'Your $planet in $sign makes you $signTrait.';
  }

  @override
  String get kHouseSans1 => 'தனுபாவ';

  @override
  String get kHouseSans2 => 'தன பாவம்';

  @override
  String get kHouseSans3 => 'சஹஜபாவ';

  @override
  String get kHouseSans4 => 'சுக பாவம்';

  @override
  String get kHouseSans5 => 'புத்ர பாவம்';

  @override
  String get kHouseSans6 => 'ரிபுபாவ';

  @override
  String get kHouseSans7 => 'யுவதி பாவ';

  @override
  String get kHouseSans8 => 'ஆயு / ரந்திர பாவம்';

  @override
  String get kHouseSans9 => 'தர்ம பாவம்';

  @override
  String get kHouseSans10 => 'கர்ம பாவம்';

  @override
  String get kHouseSans11 => 'லாப பாவம்';

  @override
  String get kHouseSans12 => 'வ்யாய பாவம்';

  @override
  String kHouseTitleWithSign(Object sign, Object theme) {
    return '$sign · $theme';
  }

  @override
  String kHouseSheetTitle(Object ordinal, Object sign) {
    return '$ordinal வீடு · $sign';
  }

  @override
  String kHouseSheetSubtitle(Object sanskrit, Object theme) {
    return '$sanskrit — $theme';
  }

  @override
  String kHouseChipLord(Object lord) {
    return 'வீட்டு பிரபு · $lord';
  }

  @override
  String kHouseChipLordIn(Object nthHouse) {
    return '$nthHouse உள்ள பிரபு';
  }

  @override
  String kHouseNoPlanets(Object lord, Object lordWhere) {
    return 'இந்த வீட்டில் கிரகங்கள் எதுவும் இல்லை. இதன் கதை முக்கியமாக இதன் அதிபதியான $lord $lordWhere என்பவரால் சொல்லப்படுகிறது.';
  }

  @override
  String kHouseLordWhere(Object nthHouse) {
    return ', இப்போது $nthHouse இல்';
  }

  @override
  String get kHousePlanetsHeader => 'இந்த வீட்டில் உள்ள கிரகங்கள்';

  @override
  String kHouseAskCta(Object ordinal) {
    return 'உங்கள் $ordinal வீட்டைப் பற்றி ஒரு ஜோதிடரிடம் கேளுங்கள்.';
  }

  @override
  String kHouseReadingLord(
    Object ordinal,
    Object lord,
    Object nthHouse,
    Object theme,
    Object lordTheme,
  ) {
    return 'உங்கள் $ordinal -வீட்டின் அதிபதி $lord , $nthHouse -இல் அமர்ந்திருப்பதால், $theme ஆனது $lordTheme -உடன் இணைகிறது.';
  }

  @override
  String kHouseReadingOccupant(
    Object planet,
    Object planetTheme,
    Object theme,
  ) {
    return '$planet இங்கே அதன் கருப்பொருள்களான $planetTheme -ஐ $theme க்குள் கொண்டுவருகிறது.';
  }

  @override
  String get kHouseReadingEmpty =>
      'இந்த வீடு, அதன் அதிபதி மற்றும் அதைப் பார்க்கும் கிரகங்களைக் கொண்டு கணிக்கப்படுகிறது. ஒரு ஜோதிடர் உங்களுக்கு இதை விளக்கிக் காட்டுவார்.';

  @override
  String kBhavaSubheadKaraka(Object karaka) {
    return 'கரகா $karaka';
  }

  @override
  String kBhavaSubheadLord(Object lord, Object nthHouse) {
    return 'பிரபு $lord , $nthHouse';
  }

  @override
  String kBhavaSubheadLordOnly(Object lord) {
    return 'பிரபு $lord';
  }

  @override
  String kBhavaReadingGoverns(Object theme) {
    return 'இந்த இல்லம் $theme ஐ நிர்வகிக்கிறது.';
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
    return 'அதன் அதிபதி $lord $nthHouse இல் இருக்கிறார், எனவே $theme $lordTheme உடன் இணைகிறது. $dignity $occupants';
  }

  @override
  String kBhavaReadingDignity(Object dignity) {
    return ' இறைவன் $dignity .';
  }

  @override
  String kBhavaReadingOccupants(Object planets, Object themes) {
    return ' $planets இங்கே அமர்ந்து, $themes சேர்க்கின்றன.';
  }

  @override
  String kTransitHouseLine(Object nthHouse, Object theme) {
    return 'உங்கள் $nthHouse · $theme';
  }

  @override
  String kPlanetRowMeta(Object sign, Object nthHouse, Object degree) {
    return '$sign · $nthHouse · $degree °';
  }

  @override
  String kLagnaLordIn(Object nthHouse) {
    return '$nthHouse';
  }

  @override
  String get kDignityShortExalted => 'மேன்மைப்படுத்தப்பட்ட';

  @override
  String get kDignityShortMoolatrikona => 'மூலத்ரிகோனா';

  @override
  String get kDignityShortOwn => 'சொந்தம்';

  @override
  String get kDignityShortDebilitated => 'பலவீனமான';

  @override
  String get kDignityShortEnemy => 'எதிரி அடையாளம்';

  @override
  String get kDignityShortGreatEnemy => 'பெரும் எதிரி';

  @override
  String get kCombustNote =>
      'எரிதல் — சூரியனுக்கு மிக அருகில் இருப்பதால், அதன் தனித்துவமான ஒலி மங்கிவிடுகிறது.';

  @override
  String get kWhatThisMeans => 'இது உங்களுக்கு என்ன அர்த்தம்';

  @override
  String get ovStrengthStrong => 'வலுவான';

  @override
  String get ovStrengthSteady => 'நிலையான';

  @override
  String get ovStrengthStrain => 'அழுத்தத்தின் கீழ்';

  @override
  String get ovStrengthWeak => 'பலவீனமான';

  @override
  String get ovRoleSpouse => 'துணைவர் குறிப்பான்';

  @override
  String get ovRoleDarakaraka => 'தாரகாரகா (ஜெய்மினி)';

  @override
  String get ovRoleWealth => 'செல்வக் குறிப்பான்';

  @override
  String get ovRoleIntellect => 'அறிவுத்திறன் குறிப்பான்';

  @override
  String get ovRoleWisdom => 'ஞானக் குறிப்பான்';

  @override
  String get ovRoleFortune => 'அதிர்ஷ்டக் குறிப்பான்';

  @override
  String get ovRoleFather => 'தந்தை குறிப்பான்';

  @override
  String get ovRoleMother => 'தாய் குறிப்பான்';

  @override
  String get ovRoleGeneric => 'அடையாளங்காட்டி';

  @override
  String ovfPada(int pada) {
    return 'pada $pada';
  }

  @override
  String ovfLagnaSign(Object sign) {
    return 'உயரும் அடையாளம் $sign';
  }

  @override
  String ovfLagnaLord(Object planet, Object nthHouse, Object dignity) {
    return 'லக்னாதிபதி $planet $nthHouse $dignity';
  }

  @override
  String ovfHouseLord(Object ordinal, Object planet, Object nthHouse) {
    return '$ordinal -வீட்டு அதிபதி $planet $nthHouse';
  }

  @override
  String ovfHouseStrength(Object ordinal, Object strength) {
    return '$ordinal வீடு — $strength';
  }

  @override
  String ovfMoonSign(Object sign) {
    return 'சந்திரன் $sign';
  }

  @override
  String ovfMoonHouse(Object nthHouse) {
    return 'சந்திரன் $nthHouse';
  }

  @override
  String ovfMoonNakshatra(Object nakshatra) {
    return 'சந்திர நட்சத்திரம் $nakshatra';
  }

  @override
  String ovfMoonDignity(Object dignity) {
    return 'சந்திரன் $dignity';
  }

  @override
  String ovfSunSign(Object sign) {
    return 'சூரியன் $sign';
  }

  @override
  String ovfSeventhSign(Object sign) {
    return '$sign இல் 7வது வீடு';
  }

  @override
  String ovfPlanetInHouse(Object planet, Object nthHouse) {
    return '$planet in the $nthHouse';
  }

  @override
  String ovfPlanetWithMoon(Object planet) {
    return 'சந்திரன் உள்ள $planet';
  }

  @override
  String ovfAppearanceIn(Object planet) {
    return 'முதல் வீட்டில் $planet';
  }

  @override
  String ovfAppearanceAspect(Object planet) {
    return 'முதல் வீட்டைப் பார்க்கும் $planet';
  }

  @override
  String ovfMaleficOnLagna(Object planet) {
    return 'லக்னத்தின் மீது அழுத்தம் கொடுக்கும் $planet';
  }

  @override
  String ovfKaraka(Object role, Object planet) {
    return '$role : $planet';
  }

  @override
  String ovfYoga(Object name) {
    return 'யோகா — $name';
  }

  @override
  String ovfDosha(Object name) {
    return 'தோஷம் — $name';
  }

  @override
  String get doshaMangalName => 'மங்கள தோஷம்';

  @override
  String get doshaMangalMeaning =>
      'செவ்வாய் ஒரு உணர்திறன் மிக்க வீட்டில் இருப்பது — பாரம்பரியமாக திருமணத்திற்கு முன் இதன் பலன் ஆராயப்படுகிறது. இரு துணைவர்களும் மாங்கல்ய குணம் கொண்டவர்களாகவோ அல்லது வியாழன் செவ்வாயின் மீது செல்வாக்கு செலுத்தும்போதோ இது பெரும்பாலும் சமநிலையில் இருக்கும்.';

  @override
  String get doshaKaalSarpaName => 'கால சர்ப்ப தோஷம்';

  @override
  String get doshaKaalSarpaMeaning =>
      'முழு ஜாதகமும் ராகுவுக்கும் கேதுவுக்கும் இடையில் அமைந்திருந்தது — ஒரு தெளிவான திசை கிடைக்கும் வரை வாழ்க்கை நெருக்கடியில் இருப்பது போல் உணரலாம், அதன் பிறகு கவனம் தீவிரமாகும்.';

  @override
  String get doshaPitraName => 'பித்ர தோஷம்';

  @override
  String get doshaPitraMeaning =>
      'சூரியனும் ஒன்பதாம் வீடும் முன்னோர்களின் கர்மவினையின் நிழலைத் தாங்கி நிற்கின்றன — இவை பெரும்பாலும் தந்தையின் பெயரால் செய்யப்படும் சிரார்த்தம் மற்றும் தானத்தின் மூலம் கையாளப்படுகின்றன.';

  @override
  String get doshaGandmoolName => 'கந்தமூல் தோஷா';

  @override
  String get doshaGandmoolMeaning =>
      'சந்திரன் ஒரு சந்திப்பு நட்சத்திரத்தில் அமர்ந்திருக்கிறது. இதற்குப் பதிலளிக்கும் விதமாக, 27-ஆம் நாளில் சாந்தி பூஜை செய்வது பாரம்பரியமானதாகும்.';

  @override
  String get doshaGrahanName => 'கிரக தோஷம்';

  @override
  String get doshaGrahanMeaning =>
      'ஒரு ஒளிக்கோள் (சூரியன் அல்லது சந்திரன்) ஒரு ராகுவுடன் அமர்ந்திருப்பதால், அதன் மீது கவனம் செலுத்தப்படும் வரை அந்தக் கோளின் முக்கியத்துவங்கள் மங்கிவிடுகின்றன.';

  @override
  String get doshaShrapitName => 'ஸ்ராபித் தோஷா';

  @override
  String get doshaShrapitMeaning =>
      'சனி ராகுவுடன் சேரும்போது — ஆரம்பத்தில் தாமதமும் குழப்பமும் ஏற்படும்; சீரான, பொறுமையான முயற்சியே இதனை வெற்றிகரமாகக் கடந்து செல்ல உதவும்.';

  @override
  String get doshaGuruChandalName => 'குரு சந்தல் தோஷம்';

  @override
  String get doshaGuruChandalMeaning =>
      'கேதுவுடன் கூடிய வியாழன் — ஞானமும் மரபுக்கு மாறான கருத்துக்களும் கலந்த நிலை; உங்கள் ஆசிரியர்களையும் நம்பிக்கைகளையும் கவனமாகத் தேர்ந்தெடுங்கள்.';

  @override
  String get doshaAngarakName => 'அங்காரக தோஷம்';

  @override
  String get doshaAngarakMeaning =>
      'கேதுவுடன் செவ்வாய் — ஒரு தூண்டுதல் ஆற்றல்; கோபம், விபத்துகள் மற்றும் சொத்து தகராறுகளுக்கு கவனம் தேவை.';

  @override
  String get doshaKemadrumaName => 'கேமத்ருமா தோஷம்';

  @override
  String get doshaKemadrumaMeaning =>
      'சந்திரன் தன்னைச் சுற்றி எந்த ஆதரவும் இல்லாமல் தனித்து நிற்கிறது — கேந்திரம் இருக்கும்போதோ அல்லது சந்திரன் வலிமையாக இருக்கும்போதோ அது தளர்வடைகிறது.';

  @override
  String get doshaDaridraName => 'தரித்ரா தோஷம்';

  @override
  String get doshaDaridraMeaning =>
      'பண ராசிகள் நெருக்கடியில் உள்ளன — கட்டுக்கோப்பான சேமிப்பும் வலுவான தசா காலமும் அதைச் சரிசெய்துவிடும்.';

  @override
  String get birthDetailsCta => 'முழுமையான பிறப்பு விவரங்கள்';

  @override
  String get birthDetailsTitle => 'பிறப்பு விவரங்கள்';

  @override
  String get birthDetailsAyanamsa => 'அயனாம்ஷா';

  @override
  String get birthDetailsPanchangTitle => 'பிறப்பின் போது பஞ்சாங்கம்';

  @override
  String get birthDetailsChakraTitle => 'அவகஹத சக்கரம்';

  @override
  String get birthDetailsWeekday => 'வாரநாள்';

  @override
  String get birthDetailsTithi => 'திதி';

  @override
  String get birthDetailsNakshatra => 'நட்சத்திரம்';

  @override
  String get birthDetailsYoga => 'யோகா';

  @override
  String get birthDetailsKarana => 'கரணா';

  @override
  String get birthDetailsMoonSign => 'சந்திர ராசி';

  @override
  String get birthDetailsSunSign => 'சூரிய ராசி';

  @override
  String get birthDetailsSuryaNakshatra => 'சூரியனின் நட்சத்திரம்';

  @override
  String get birthDetailsSunrise => 'சூரிய உதயம்';

  @override
  String get birthDetailsSunset => 'சூரிய அஸ்தமனம்';

  @override
  String get birthDetailsIshtaKala => 'இஷ்ட கலா';

  @override
  String birthDetailsPada(int count) {
    return 'படா $count';
  }

  @override
  String birthDetailsGhatiPala(int ghati, int pala, int vipala) {
    return '$ghati காதி $pala பாலா $vipala விபாலா';
  }

  @override
  String get birthDetailsNakshatraLord => 'நட்சத்திர அதிபதி';

  @override
  String get birthDetailsRashiLord => 'ராசி அதிபதி';

  @override
  String get birthDetailsVarna => 'வர்ணா';

  @override
  String get birthDetailsVashya => 'வாஷ்யா';

  @override
  String get birthDetailsYoni => 'யோனி';

  @override
  String get birthDetailsGana => 'கானா';

  @override
  String get birthDetailsNadi => 'நாடி';

  @override
  String get birthDetailsTara => 'தாரா';

  @override
  String get birthDetailsTattva => 'தத்துவம்';

  @override
  String get birthDetailsYunja => 'யுன்ஜா';

  @override
  String get birthDetailsRashiPaya => 'ராஷி பாயா';

  @override
  String get birthDetailsNakshatraPaya => 'நக்ஷத்ரா பாயா';

  @override
  String get birthDetailsDisclaimer =>
      'பாரம்பரிய வகைப்பாட்டுப் பண்புகள் — இவை முக்கியமாக முகூர்த்தம் மற்றும் திருமணப் பொருத்தம் பார்ப்பதில் பயன்படுத்தப்படுகின்றன, கணிப்புகளில் அல்ல.';

  @override
  String get vaaraMonday => 'சோமவரா (திங்கட்கிழமை)';

  @override
  String get vaaraTuesday => 'மங்களவரா (செவ்வாய்க்கிழமை)';

  @override
  String get vaaraWednesday => 'புத்வரா (புதன்கிழமை)';

  @override
  String get vaaraThursday => 'குருவரா (வியாழக்கிழமை)';

  @override
  String get vaaraFriday => 'சுக்ரவரம் (வெள்ளிக்கிழமை)';

  @override
  String get vaaraSaturday => 'சனிவாரம் (சனிக்கிழமை)';

  @override
  String get vaaraSunday => 'ரவிவரா (ஞாயிற்றுக்கிழமை)';

  @override
  String get tattvaFire => 'அக்னி (நெருப்பு)';

  @override
  String get tattvaEarth => 'பிருத்வி (பூமி)';

  @override
  String get tattvaAir => 'வாயு (காற்று)';

  @override
  String get tattvaWater => 'ஜல (நீர்)';

  @override
  String get payaGold => 'தங்கம்';

  @override
  String get payaSilver => 'வெள்ளி';

  @override
  String get payaCopper => 'செம்பு';

  @override
  String get payaIron => 'இரும்பு';

  @override
  String get roomAppBarTitle => 'ஆலோசனை';

  @override
  String get roomOpenError =>
      'எங்களால் இந்தக் கலந்தாய்வைத் தொடங்க முடியவில்லை.';

  @override
  String roomWaitingTitle(String name) {
    return '$name ஏற்றுக்கொள்வதற்காகக் காத்திருக்கிறது';
  }

  @override
  String get roomWaitingBody =>
      'பொதுவாக ஒரு நிமிடத்திற்குள். அவர்கள் இணைந்த உடனேயே நாங்கள் உரையாடலைத் திறப்போம்.';

  @override
  String get roomCancelRequest => 'கோரிக்கையை ரத்துசெய்';

  @override
  String get roomEndConfirmTitle => 'இந்த ஆலோசனையை முடித்துக்கொள்ளலாமா?';

  @override
  String get roomEndConfirmBody =>
      'அமர்வு முடிவடையும்போது கட்டணம் வசூலிப்பது நிறுத்தப்படும்.';

  @override
  String get roomKeepTalking => 'தொடர்ந்து பேசுங்கள்';

  @override
  String get roomEnd => 'முடிவு';

  @override
  String get roomAutoTranslateOn => 'தானியங்கு மொழிபெயர்ப்பை இயக்கு';

  @override
  String get roomAutoTranslateOff => 'தானியங்கு மொழிபெயர்ப்பு முடக்கம்';

  @override
  String get roomEndedTitle => 'ஆலோசனை நிறைவடைந்தது';

  @override
  String get roomBalanceOutTitle => 'உங்கள் இருப்புத் தொகை தீர்ந்துவிட்டது';

  @override
  String roomBalanceOutBody(String name) {
    return 'உங்கள் வாலட் இருப்பு தீர்ந்துவிட்டதால் உரையாடல் முடிவடைந்தது. $name உடன் தொடர, ரீசார்ஜ் செய்து மீண்டும் தொடங்கவும்.';
  }

  @override
  String get roomRechargeWallet => 'ரீசார்ஜ் வாலட்';

  @override
  String roomStartAgain(String name) {
    return '$name உடன் மீண்டும் தொடங்கவும்';
  }

  @override
  String get roomRowAstrologer => 'ஜோதிடர்';

  @override
  String get roomRowDuration => 'கால அளவு';

  @override
  String get roomRowAmount => 'தொகை';

  @override
  String get roomRowRate => 'விகிதம்';

  @override
  String roomMinutes(int minutes) {
    return '$minutes நிமிடம்';
  }

  @override
  String roomRatePerMinute(String currency, String amount) {
    return '$currency $amount /நிமிடம்';
  }

  @override
  String get roomRateQuestion => 'உங்கள் கலந்தாய்வு எப்படி இருந்தது?';

  @override
  String get roomSubmitRating => 'மதிப்பீட்டைச் சமர்ப்பிக்கவும்';

  @override
  String get roomRatingThanks => 'உங்கள் கருத்துகளுக்கு நன்றி!';

  @override
  String get roomBackHome => 'முகப்புக்குத் திரும்பு';

  @override
  String get roomStatusRejected =>
      'ஜோதிடரால் இந்தக் கோரிக்கையை ஏற்க முடியவில்லை.';

  @override
  String get roomStatusCancelled => 'கோரிக்கையை ரத்துசெய்';

  @override
  String get roomStatusExpired =>
      'கோரிக்கை காலாவதியானது — உரிய நேரத்தில் பதில் அளிக்கப்படவில்லை.';

  @override
  String get roomStatusNoShow => 'அழைப்பு இணைக்கப்படவில்லை.';

  @override
  String get roomStatusClosed => 'கலந்தாய்வு நிறைவடைந்தது';

  @override
  String get roomBalanceRunningOut => 'இருப்பு தீர்ந்து கொண்டிருக்கிறது';

  @override
  String roomMinLeftRecharge(int minutes) {
    return '~ $minutes மீதம் · தொடர்ந்து பேச ரீசார்ஜ் செய்யவும்';
  }

  @override
  String roomSpentMinLeft(String currency, String amount, int minutes) {
    return '$amount $currency $minutes';
  }

  @override
  String get roomAddMoney => 'பணத்தைச் சேர்க்கவும்';

  @override
  String get roomClientBalanceLow =>
      'வாடிக்கையாளரின் நிலுவைத் தொகை குறைவாக உள்ளது — விரைவில் முடித்துவிடவும்';

  @override
  String get navChats => 'அரட்டைகள்';

  @override
  String get chatsTitle => 'அரட்டைகள்';

  @override
  String get chatsLoadError => 'உங்கள் உரையாடல்களை எங்களால் ஏற்ற முடியவில்லை.';

  @override
  String get chatsEmptyTitle => 'இன்னும் உரையாடல்கள் இல்லை';

  @override
  String get chatsEmptyBody =>
      'ஜோதிடருடன் ஆலோசனையைத் தொடங்குங்கள், அது இங்கே காட்டப்படும்.';

  @override
  String get chatsSectionActive => 'செயலில்';

  @override
  String get chatsSectionRecent => 'ஞாபகம்';

  @override
  String get chatsAstrologerFallback => 'ஜோதிடர்';

  @override
  String get chatsStatusWaiting =>
      'ஜோதிடர் ஏற்றுக்கொள்வதற்காகக் காத்திருக்கிறேன்';

  @override
  String get chatsStatusLive => 'தற்போது நேரலையில் · திறக்கத் தட்டவும்';

  @override
  String chatsStatusEnded(int minutes) {
    return '$minutes நிமிட ஆலோசனை';
  }

  @override
  String get chatsStatusCancelled => 'ரத்து செய்யப்பட்டது';

  @override
  String get chatsStatusRejected => 'ஏற்றுக்கொள்ளவில்லை';

  @override
  String get chatsStatusExpired => 'கோரிக்கை காலாவதியானது';

  @override
  String get chatsStatusGeneric => 'ஆலோசனை';

  @override
  String get numerologyTitle => 'எண் கணிதம் மற்றும் லோ ஷு கட்டம்';

  @override
  String get numerologyIntro =>
      'உங்கள் பிறந்த தேதி (மற்றும் பெயர்) அடிப்படையிலான ஒரு பாரம்பரிய எண் கணிப்பு — ஒவ்வொரு எண்ணும் சார்ந்திருக்கும் போக்குகள், உகந்த நாட்கள் மற்றும் நிறங்கள், மற்றும் உங்கள் லோ ஷு பிறப்புக் கட்டம். இது சுயபரிசோதனைக்கானது, தேதி குறிப்பிடப்பட்ட கணிப்பு அல்ல.';

  @override
  String get numMoolank => 'மூலங்க் · ஜோதிட எண்';

  @override
  String get numBhagyank => 'பாக்யங்க் · விதி எண்';

  @override
  String get numNaamank => 'நாமங்க் · பெயர் எண்';

  @override
  String numRuledBy(String planet) {
    return '$planet ஆல் ஆளப்படுகிறது';
  }

  @override
  String get numFriendly => 'நட்பான';

  @override
  String get numNeutral => 'நடுநிலை';

  @override
  String get numUnfriendly => 'மோதல்';

  @override
  String get numFavDays => 'சாதகமான நாட்கள்';

  @override
  String get numFavColours => 'சாதகமான நிறங்கள்';

  @override
  String get numDirection => 'திசை';

  @override
  String get numDeity => 'தெய்வம்';

  @override
  String get numGemstone => 'பாரம்பரிய ரத்தினக்கல்';

  @override
  String get numLoShuTitle => 'லோ ஷுபர்த் கட்டம்';

  @override
  String numLoShuMissing(String nums) {
    return 'உங்கள் கட்டத்தில் இல்லை: $nums';
  }

  @override
  String numLoShuRepeated(String nums) {
    return 'வலியுறுத்தப்பட்டது: $nums';
  }

  @override
  String get numArrowStrength => 'முழுமையான வரி';

  @override
  String get numArrowAbsence => 'இல்லாத வரி';

  @override
  String get numAskCta => 'இதுபற்றி ஒரு ஜோதிடரிடம் பேசுங்கள்';

  @override
  String get sadeSatiTitle => 'சடே சதி & தையா நாட்காட்டி';

  @override
  String sadeSatiIntro(String sign) {
    return 'உங்கள் சந்திர ராசியிலிருந்து கணக்கிடப்படும், உங்கள் வாழ்க்கையின் மீதான சனியின் கால அளவுகள் $sign ஏழரைச் சதி என்பது சந்திரனிலிருந்து 12, 1 மற்றும் 2 ஆம் வீடுகளில் சனி இருப்பது (~7½ ஆண்டுகள்); தையா என்பது 4 அல்லது 8 ஆம் வீடு இருப்பது (~2½ ஆண்டுகள்).';
  }

  @override
  String get sadeSatiRunningNow => 'தற்போது இயங்குகிறது';

  @override
  String get sadeSatiPast => 'கடந்த';

  @override
  String get sadeSatiUpcoming => 'வரவிருக்கும்';

  @override
  String get sadeSatiPhaseRising => 'உதயம் · 12 ஆம் வீட்டில் சனி';

  @override
  String get sadeSatiPhasePeak => 'சிகரம் · நிலவின் மேல் சனி';

  @override
  String get sadeSatiPhaseSetting => 'அஸ்தமனம் · 2 ஆம் வீட்டில் சனி';

  @override
  String get sadeSatiPhaseKantaka => 'கண்டகம் · 4 ஆம் வீட்டில் சனி';

  @override
  String get sadeSatiPhaseAshtama => 'அஷ்டம · 8 ஆம் வீட்டில் சனி';

  @override
  String get sadeSatiDhaiyaHeading => 'தையா (சிறிய பனோதி) காலங்கள்';

  @override
  String sadeSatiRange(String start, String end) {
    return '$start → $end';
  }

  @override
  String get avTransitHeading => 'இன்றைய கோச்சாரங்களின் அஷ்டகவர்க்க வலிமை';

  @override
  String get avTransitIntro =>
      'உங்கள் பிறப்பு பிந்து மதிப்பெண்களிலிருந்து, ஒவ்வொரு கிரகத்தின் பெயர்ச்சியும் அதன் பலன்களை எவ்வளவு தாராளமாக அளிக்கிறது. 8-க்கு 5 அல்லது அதற்கு மேல் இருப்பது ஆதரவானது, 4 என்பது கலவையான பலன், அதற்குக் குறைவாக இருப்பது பலவீனமானது.';

  @override
  String avTransitBindus(int bindus) {
    return '$bindus /8 பிண்டஸ்';
  }

  @override
  String get avTransitUpcoming => 'அடுத்து வரவிருப்பது';

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
      'சர்வரைத் தொடர்பு கொள்ள முடியவில்லை. உங்கள் இணைப்பைச் சரிபார்க்கவும்.';

  @override
  String get errTimeout => 'சர்வர் பதிலளிக்க அதிக நேரம் எடுக்கிறது.';

  @override
  String get errSession => 'உங்கள் அமர்வு காலாவதியானது. மீண்டும் உள்நுழையவும்.';

  @override
  String get errWalletInsufficient =>
      'இதற்கு உங்கள் வாலட் இருப்பு மிகவும் குறைவாக உள்ளது.';

  @override
  String get errRateLimited =>
      'அதிகப்படியான முயற்சிகள். சிறிது நேரம் காத்திருந்து மீண்டும் முயலவும்.';

  @override
  String get errOtpInvalid => 'குறியீடு தவறானது அல்லது காலாவதியானது.';

  @override
  String get errOtpMaxAttempts =>
      'அதிகப்படியான தவறான முயற்சிகள். புதிய குறியீட்டைக் கோரவும்.';

  @override
  String get errPromoNotRedeemable =>
      'இந்த கூப்பன் குறியீட்டைப் பயன்படுத்த முடியாது.';

  @override
  String get errRechargeInvalidAmount =>
      'அனுமதிக்கப்பட்ட வரம்பிற்குள் தொகையை உள்ளிடவும்.';

  @override
  String get errAuthWrongApp =>
      'இந்த எண் மற்ற TalkAcharya செயலியில் பதிவு செய்யப்பட்டுள்ளது.';

  @override
  String get errGeneric => 'ஏதோ தவறு நடந்துவிட்டது. மீண்டும் முயலவும்.';

  @override
  String get homePanchangTitle => 'இன்றைய பஞ்சாங்கம்';

  @override
  String get homeLiveNowTitle => 'இப்போது நேரலையில்';

  @override
  String get homeFreeToolsTitle => 'இலவச கருவிகள்';

  @override
  String get homeResumeBtn => 'சுயவிவரம்';

  @override
  String get homeAddBtn => 'சேர்';

  @override
  String get homeNotifyMeBtn => 'எனக்குத் தெரிவிக்கவும்';

  @override
  String get homeKundaliAction => 'குண்டலி';

  @override
  String get homeMatchingAction => 'பொருத்தம்';

  @override
  String get homeHoroscopeAction => 'ஜாதகம்';

  @override
  String get homeVastuAction => 'வாஸ்து';

  @override
  String get homeRetryBtn => 'மீண்டும் முயற்சி';

  @override
  String get homeChooseSignTitle => 'உங்கள் ராசியைத் தேர்ந்தெடுக்கவும்';

  @override
  String get homeChooseLanguageTitle => 'மொழிகளைத் தேர்ந்தெடுக்கவும்';

  @override
  String get homeLanguageTooltip => 'மொழி';

  @override
  String homeLanguageSwitchError(String error) {
    return 'மாற்ற முடியவில்லை: $error';
  }

  @override
  String get homeComingSoonSnackbar => 'விரைவில் வருகிறது!';

  @override
  String get homeTalkAgainTitle => 'மீண்டும் பேசு';

  @override
  String get homeRechargeWalletTitle => 'உங்கள் பணப்பையை ரீசார்ஜ் செய்யுங்கள்';

  @override
  String get homeTalkToAstrologerTitle => 'ஒரு ஜோதிடரிடம் பேசுங்கள்';

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
