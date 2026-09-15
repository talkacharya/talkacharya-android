// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appName => 'टॉकआचार्य';

  @override
  String get commonOk => 'ठीक है';

  @override
  String get commonCancel => 'रद्द करें';

  @override
  String get commonDone => 'हो गया';

  @override
  String get commonNext => 'आगे';

  @override
  String get commonBack => 'पीछे';

  @override
  String get commonRetry => 'फिर कोशिश करें';

  @override
  String get commonSave => 'सेव करें';

  @override
  String get commonEdit => 'बदलें';

  @override
  String get commonDelete => 'हटाएँ';

  @override
  String get commonClose => 'बंद करें';

  @override
  String get commonContinue => 'आगे बढ़ें';

  @override
  String get commonConfirm => 'पक्का करें';

  @override
  String get commonSeeAll => 'सभी देखें';

  @override
  String get commonViewAll => 'सभी देखें';

  @override
  String get commonShare => 'शेयर करें';

  @override
  String get commonCopy => 'कॉपी करें';

  @override
  String get commonCopied => 'कॉपी हो गया';

  @override
  String get commonApply => 'लगाएँ';

  @override
  String get commonSearch => 'खोजें';

  @override
  String get commonYes => 'हाँ';

  @override
  String get commonNo => 'नहीं';

  @override
  String get commonLoading => 'लोड हो रहा है…';

  @override
  String get commonSomethingWentWrong => 'कुछ गड़बड़ हो गई';

  @override
  String get commonCheckConnection =>
      'अपना इंटरनेट कनेक्शन जाँचें और फिर कोशिश करें';

  @override
  String get commonComingSoon => 'जल्द आ रहा है';

  @override
  String get commonToday => 'आज';

  @override
  String get commonYesterday => 'कल';

  @override
  String commonMinutesShort(int count) {
    return '$count मिनट';
  }

  @override
  String get commonOffline => 'आप ऑफ़लाइन हैं';

  @override
  String get navHome => 'होम';

  @override
  String get navAstrologers => 'ज्योतिषी';

  @override
  String get navLive => 'लाइव';

  @override
  String get navWallet => 'वॉलेट';

  @override
  String get navProfile => 'प्रोफ़ाइल';

  @override
  String get authWelcomeTitle => 'भरोसेमंद ज्योतिषियों से बात करें';

  @override
  String get authWelcomeSubtitle =>
      'प्रेम, करियर, पैसे और अन्य विषयों पर मार्गदर्शन के लिए चैट या कॉल करें';

  @override
  String get authPhoneTitle => 'अपना मोबाइल नंबर डालें';

  @override
  String get authPhoneSubtitle =>
      'अपना मोबाइल नंबर डालें, हम आपको एक बार का कोड भेजेंगे।';

  @override
  String authOtpSubtitle(String phone) {
    return 'हमने $phone पर 6 अंकों का कोड भेजा है।';
  }

  @override
  String authTestModeCode(String code) {
    return 'टेस्ट मोड — आपका कोड है $code';
  }

  @override
  String get authPhoneHint => 'मोबाइल नंबर';

  @override
  String get authPhoneHelper => 'हम SMS से एक बार का कोड भेजेंगे';

  @override
  String get authGetOtp => 'OTP पाएँ';

  @override
  String get authOtpTitle => '6 अंकों का कोड डालें';

  @override
  String authOtpSentTo(String phone) {
    return '$phone पर भेजा गया';
  }

  @override
  String get authOtpResend => 'कोड दोबारा भेजें';

  @override
  String authOtpResendIn(int seconds) {
    return '$seconds सेकंड में दोबारा भेजें';
  }

  @override
  String get authVerify => 'पुष्टि करें';

  @override
  String get authChangeNumber => 'नंबर बदलें';

  @override
  String get authInvalidPhone => 'सही मोबाइल नंबर डालें';

  @override
  String get authInvalidOtp => '6 अंकों का कोड डालें';

  @override
  String get authWrongApp => 'यह नंबर ज्योतिषी ऐप के लिए रजिस्टर्ड है';

  @override
  String authDevCode(String code) {
    return 'डेव कोड: $code';
  }

  @override
  String get authTermsNotice =>
      'आगे बढ़ने का मतलब है कि आप हमारी शर्तें और गोपनीयता नीति मानते हैं';

  @override
  String get authLogout => 'लॉग आउट';

  @override
  String get authLogoutConfirm =>
      'टॉकआचार्य से लॉग आउट करें? आपको दोबारा साइन इन करना होगा।';

  @override
  String homeGreeting(String name) {
    return 'नमस्ते, $name';
  }

  @override
  String get homeGuidanceTagline => 'मार्गदर्शन, जब भी आपको ज़रूरत हो';

  @override
  String get homeGreetingFallbackName => 'आप';

  @override
  String get walletAddShort => 'जोड़ें';

  @override
  String get homeChatNow => 'अभी चैट करें';

  @override
  String get homeCallNow => 'अभी कॉल करें';

  @override
  String homeFromPerMin(String price) {
    return '$price/मिनट से';
  }

  @override
  String homeOnlineCount(int count) {
    return '$count ऑनलाइन';
  }

  @override
  String get homeOnlineNow => 'अभी ऑनलाइन';

  @override
  String get homeTalkToAstrologer => 'किसी ज्योतिषी से बात करें';

  @override
  String get homeLiveNow => 'अभी लाइव';

  @override
  String get homeWhatsOnYourMind => 'आपके मन में क्या है?';

  @override
  String get homeTodaysHoroscope => 'आज का राशिफल';

  @override
  String get homeChooseYourSign => 'अपनी राशि चुनें';

  @override
  String get homeReadMore => 'और पढ़ें';

  @override
  String get homeShowLess => 'कम दिखाएँ';

  @override
  String homeLuckToday(String rating) {
    return 'आज का भाग्य · $rating';
  }

  @override
  String get homeTodaysPanchang => 'आज का पंचांग';

  @override
  String get homePanchangAddProfile =>
      'अपनी जगह के अनुसार पंचांग के लिए अपनी जन्म जानकारी जोड़ें';

  @override
  String get homeFreeTools => 'मुफ़्त टूल';

  @override
  String get homeTalkAgain => 'फिर बात करें';

  @override
  String get homeAddMoneyGetBonus => 'पैसे जोड़ें, बोनस पाएँ';

  @override
  String get homeReferAFriend => 'दोस्त को बुलाएँ, दोनों कमाएँ';

  @override
  String get homeReferShort =>
      'अपना कोड शेयर करें — आप दोनों को वॉलेट क्रेडिट मिलेगा';

  @override
  String homeReferYourCode(String code) {
    return 'आपका कोड: $code';
  }

  @override
  String get homeInvite => 'बुलाएँ';

  @override
  String homeResumeInProgress(String channel) {
    return '$channel · चल रहा है';
  }

  @override
  String homeResumePaused(String channel) {
    return '$channel · रुका हुआ';
  }

  @override
  String get homeResume => 'जारी रखें';

  @override
  String get homeTrustVerified =>
      'हर ज्योतिषी लाइव आने से पहले ID-सत्यापित होता है';

  @override
  String get homeTrustPrivate => '100% निजी और गोपनीय परामर्श';

  @override
  String get homeTrustVolume => 'हर हफ़्ते हज़ारों परामर्श';

  @override
  String get homeCouldntLoadAstrologers => 'ज्योतिषी लोड नहीं हो सके';

  @override
  String get homeCouldntLoadReading => 'आज का राशिफल नहीं मिल सका';

  @override
  String get homeCouldntLoadPanchang => 'पंचांग लोड नहीं हो सका';

  @override
  String get homeNoAstrologersFilter =>
      'अभी इस फ़िल्टर से कोई ज्योतिषी नहीं मिला';

  @override
  String get concernLove => 'प्रेम';

  @override
  String get concernMarriage => 'विवाह';

  @override
  String get concernCareer => 'करियर';

  @override
  String get concernFinance => 'पैसा';

  @override
  String get concernHealth => 'स्वास्थ्य';

  @override
  String get concernEducation => 'शिक्षा';

  @override
  String get concernBusiness => 'व्यापार';

  @override
  String get concernLegal => 'कानूनी';

  @override
  String get channelChat => 'चैट';

  @override
  String get channelCall => 'कॉल';

  @override
  String get channelVoice => 'वॉइस कॉल';

  @override
  String get channelVideo => 'वीडियो कॉल';

  @override
  String get channelAll => 'सभी';

  @override
  String get astroFilterAll => 'सभी';

  @override
  String get astroSortRecommended => 'सुझाए गए';

  @override
  String get astroSortTopRated => 'सबसे ज़्यादा रेटेड';

  @override
  String get astroSortExperienced => 'सबसे अनुभवी';

  @override
  String get astroSortConsulted => 'सबसे ज़्यादा परामर्श';

  @override
  String get astroSortNew => 'नए';

  @override
  String get astroOnline => 'ऑनलाइन';

  @override
  String get astroBusy => 'व्यस्त';

  @override
  String get astroNotifyMe => 'मुझे बताएँ';

  @override
  String astroWaitMinutes(int count) {
    return '~$count मिनट इंतज़ार';
  }

  @override
  String astroPerMinute(String price) {
    return '$price/मिनट';
  }

  @override
  String astroYearsExp(int count) {
    return '$count साल का अनुभव';
  }

  @override
  String get astroRatingNew => 'नया';

  @override
  String astroSessionsCount(String count) {
    return '$count परामर्श';
  }

  @override
  String get astroSearchHint => 'नाम, विद्या या भाषा से खोजें';

  @override
  String get astroNoneFound => 'कोई ज्योतिषी नहीं मिला';

  @override
  String get astroNoneFoundHint => 'कोई फ़िल्टर हटाकर या कुछ और खोजकर देखें';

  @override
  String get astroThatsEveryone => 'अभी के लिए बस इतने ही';

  @override
  String get astroRateOnRequest => 'दर पूछने पर';

  @override
  String get astroCouldntLoad => 'ज्योतिषी लोड नहीं हो सके';

  @override
  String get astroSortBy => 'क्रमबद्ध करें';

  @override
  String get astroLoadMoreFailed => 'और लोड नहीं हो सका';

  @override
  String get astroDefaultSkill => 'वैदिक ज्योतिष';

  @override
  String astroYears(int count) {
    return '$count वर्ष';
  }

  @override
  String astroSessions(String count) {
    return '$count सत्र';
  }

  @override
  String get astroChat => 'चैट';

  @override
  String get astroCall => 'कॉल';

  @override
  String get astroVideo => 'वीडियो';

  @override
  String get astroProfileTitle => 'ज्योतिषी';

  @override
  String get astroExpertiseTitle => 'विशेषज्ञता';

  @override
  String get astroAboutTitle => 'परिचय';

  @override
  String get astroRatesTitle => 'परामर्श दरें';

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
  String get astroStatRating => 'रेटिंग';

  @override
  String get astroStatExperience => 'अनुभव';

  @override
  String get astroStatSessions => 'सत्र';

  @override
  String get astroStatRepeatClients => 'दोबारा आने वाले';

  @override
  String astroSpeaks(String languages) {
    return 'बोलते हैं: $languages';
  }

  @override
  String astroRepliesIn(String time) {
    return 'लगभग $time में जवाब';
  }

  @override
  String get astroOnlineNow => 'अभी ऑनलाइन';

  @override
  String get astroOfflineTitle => 'अभी ऑफ़लाइन';

  @override
  String get astroNotifyWhenOnline => 'ऑनलाइन आने पर सूचित करें';

  @override
  String get astroReadMore => 'और पढ़ें';

  @override
  String get astroReadLess => 'कम दिखाएँ';

  @override
  String get astroCouldntLoadOne => 'यह ज्योतिषी लोड नहीं हो सका';

  @override
  String get astroCallsComingSoon => 'वॉइस और वीडियो कॉल जल्द आ रहे हैं';

  @override
  String get astroTrustLine =>
      'आईडी-सत्यापित · निजी और गोपनीय · प्रति मिनट भुगतान';

  @override
  String get walletTitle => 'वॉलेट';

  @override
  String get walletAvailableBalance => 'उपलब्ध राशि';

  @override
  String walletOnHold(String amount) {
    return '$amount रोकी गई';
  }

  @override
  String walletOnHoldReason(String amount) {
    return '$amount रोकी गई · एक कॉल चल रही है';
  }

  @override
  String get walletAddMoney => 'पैसे जोड़ें';

  @override
  String get walletRecentActivity => 'हाल की गतिविधि';

  @override
  String get walletTransactions => 'लेन-देन';

  @override
  String get walletHowItWorksTitle => 'वॉलेट कैसे काम करता है';

  @override
  String get walletHowItWorksBody =>
      'वॉलेट की राशि सिर्फ़ परामर्श के लिए इस्तेमाल होती है और कभी समाप्त नहीं होती। बची हुई राशि वापस की जा सकती है — रिफ़ंड नीति देखें।';

  @override
  String get walletRefundPolicy => 'रिफ़ंड नीति';

  @override
  String get walletHaveCoupon => 'कोई कूपन कोड है?';

  @override
  String get walletCouponHint => 'कोड डालें';

  @override
  String walletCouponApplied(String amount) {
    return 'आपके वॉलेट में $amount जोड़े गए';
  }

  @override
  String get walletSecuredBy =>
      'Razorpay द्वारा सुरक्षित · UPI · कार्ड · नेटबैंकिंग';

  @override
  String get walletGstInvoices => 'GST इनवॉइस';

  @override
  String get walletInvoicesSubtitle => 'आपके रिचार्ज की इनवॉइस और रसीदें';

  @override
  String get walletNoTransactions => 'अभी कोई लेन-देन नहीं';

  @override
  String get walletNoTransactionsHint =>
      'शुरू करने के लिए अपने वॉलेट में पैसे जोड़ें';

  @override
  String walletBalanceAfter(String amount) {
    return 'शेष $amount';
  }

  @override
  String get walletFilterAll => 'सभी';

  @override
  String get walletFilterRecharge => 'जोड़े गए';

  @override
  String get walletFilterConsultation => 'परामर्श';

  @override
  String get walletFilterRefund => 'रिफ़ंड';

  @override
  String get walletFilterBonus => 'बोनस';

  @override
  String get kindRecharge => 'पैसे जोड़े गए';

  @override
  String get kindConsultationCharge => 'परामर्श';

  @override
  String get kindConsultationRefund => 'रिफ़ंड';

  @override
  String get kindPromoCredit => 'प्रोमो क्रेडिट';

  @override
  String get kindCouponDiscount => 'कूपन छूट';

  @override
  String get kindSignupBonus => 'साइनअप बोनस';

  @override
  String get kindReferralBonus => 'रेफ़रल बोनस';

  @override
  String get kindAdjustment => 'समायोजन';

  @override
  String get kindGiftSpend => 'उपहार भेजा';

  @override
  String get kindHold => 'कॉल के लिए रोकी गई';

  @override
  String get kindChargeback => 'चार्जबैक';

  @override
  String get rechargeChooseAmount => 'वॉलेट में पैसे जोड़ें';

  @override
  String get rechargeAmountLabel => 'राशि';

  @override
  String rechargePayAmount(String amount) {
    return '$amount चुकाएँ';
  }

  @override
  String get rechargeAddCoupon => 'कूपन कोड जोड़ें';

  @override
  String rechargeBonusBadge(String amount) {
    return '+$amount';
  }

  @override
  String get rechargeStarterPack => 'शुरुआती';

  @override
  String rechargeMinAmount(String amount) {
    return 'कम से कम $amount';
  }

  @override
  String rechargeMaxAmount(String amount) {
    return 'ज़्यादा से ज़्यादा $amount';
  }

  @override
  String get rechargeOpeningCheckout => 'सुरक्षित चेकआउट खुल रहा है…';

  @override
  String get rechargeConfirming =>
      'भुगतान मिल गया — आपकी राशि अपडेट हो रही है…';

  @override
  String rechargeSuccessTitle(String amount) {
    return '$amount जोड़े गए';
  }

  @override
  String rechargeNewBalance(String amount) {
    return 'नई राशि $amount';
  }

  @override
  String get rechargeViewTransaction => 'लेन-देन देखें';

  @override
  String get rechargeFailedTitle => 'भुगतान नहीं हुआ';

  @override
  String get rechargeNotCharged => 'आपसे कोई पैसा नहीं लिया गया।';

  @override
  String get rechargeAutoRefund =>
      'अगर कोई राशि कटी है, तो वह 3–5 कार्यदिवसों में वापस कर दी जाएगी।';

  @override
  String get rechargeTryAgain => 'फिर कोशिश करें';

  @override
  String get rechargeChangeAmount => 'राशि बदलें';

  @override
  String get rechargeCreditedSoon =>
      'भुगतान मिल गया। हम इसे थोड़ी देर में आपके वॉलेट में जोड़ देंगे।';

  @override
  String rechargeOfferAutoApplied(String amount, String bonus) {
    return '$amount जोड़ें, $bonus अतिरिक्त पाएँ — अपने आप लागू';
  }

  @override
  String get profileTitle => 'प्रोफ़ाइल';

  @override
  String get profileEditProfile => 'प्रोफ़ाइल बदलें';

  @override
  String profilePhoneMasked(String last4) {
    return '+91 ●●●●● $last4';
  }

  @override
  String get profileCompleteAddEmail =>
      'अपनी प्रोफ़ाइल पूरी करने के लिए ईमेल जोड़ें';

  @override
  String get profileCompleteAddBirth =>
      'बेहतर भविष्यफल के लिए अपनी जन्म जानकारी जोड़ें';

  @override
  String get profileRoleCustomer => 'ग्राहक';

  @override
  String get profileWallet => 'वॉलेट';

  @override
  String get profileBirthProfiles => 'जन्म प्रोफ़ाइल';

  @override
  String profileBirthProfilesCount(int count) {
    return '$count कुंडली';
  }

  @override
  String get profileGroupAccount => 'खाता';

  @override
  String get profileGroupMoney => 'पैसा';

  @override
  String get profileGroupPreferences => 'सेटिंग';

  @override
  String get profileGroupSupport => 'सहायता';

  @override
  String get profileGroupLegal => 'कानूनी';

  @override
  String get profileNotifications => 'सूचनाएँ';

  @override
  String get profileNotificationPrefs => 'सूचना सेटिंग';

  @override
  String get profileHapticFeedback => 'हैप्टिक राय';

  @override
  String get profileHapticFeedbackDesc =>
      'बटन दबाने और अन्य गतिविधियों पर कंपन करें';

  @override
  String get profileWalletAndTransactions => 'वॉलेट और लेन-देन';

  @override
  String get profileOrders => 'ऑर्डर';

  @override
  String profileOrdersUnread(int count) {
    return '$count नए';
  }

  @override
  String get profileReferAndEarn => 'रेफ़र करें और कमाएँ';

  @override
  String get profileLanguage => 'भाषा';

  @override
  String get profileCurrency => 'मुद्रा';

  @override
  String get profileHelpCentre => 'सहायता केंद्र';

  @override
  String get profileContactWhatsapp => 'WhatsApp पर संपर्क करें';

  @override
  String get profileRateApp => 'टॉकआचार्य को रेट करें';

  @override
  String get profileShareApp => 'ऐप शेयर करें';

  @override
  String profileShareMessage(String link) {
    return 'मैं ज्योतिषियों से बात करने के लिए टॉकआचार्य इस्तेमाल करता हूँ। आज़माएँ: $link';
  }

  @override
  String get profileTerms => 'सेवा की शर्तें';

  @override
  String get profilePrivacy => 'गोपनीयता नीति';

  @override
  String get profileLicenses => 'ओपन-सोर्स लाइसेंस';

  @override
  String get profileDeleteAccount => 'खाता हटाएँ';

  @override
  String profileVersion(String version, String build) {
    return 'टॉकआचार्य · v$version ($build)';
  }

  @override
  String get editFullName => 'पूरा नाम';

  @override
  String get editDisplayName => 'दिखने वाला नाम';

  @override
  String get editDateOfBirth => 'जन्म तिथि';

  @override
  String get editGender => 'लिंग';

  @override
  String get editGenderMale => 'पुरुष';

  @override
  String get editGenderFemale => 'महिला';

  @override
  String get editGenderOther => 'अन्य';

  @override
  String get editEmail => 'ईमेल';

  @override
  String get editEmailUnverified => 'सत्यापित नहीं';

  @override
  String get editChangePhoto => 'फ़ोटो बदलें';

  @override
  String get editProfileSaved => 'प्रोफ़ाइल अपडेट हो गई';

  @override
  String get editProfileSaveError => 'आपके बदलाव सेव नहीं हो सके';

  @override
  String get editGenderUndisclosed => 'नहीं बताना चाहते';

  @override
  String get editNameInvalid => 'अपना नाम लिखें (कम से कम 2 अक्षर)';

  @override
  String get editEmailInvalid => 'सही ईमेल पता लिखें';

  @override
  String get editPhone => 'मोबाइल नंबर';

  @override
  String get editPhoneLocked => 'लॉगिन नंबर बदला नहीं जा सकता';

  @override
  String get editSectionPersonal => 'व्यक्तिगत जानकारी';

  @override
  String get editSectionContact => 'संपर्क';

  @override
  String get editDobPlaceholder => 'जन्म तिथि जोड़ें';

  @override
  String get editPhotoUpdated => 'फ़ोटो अपडेट हो गई';

  @override
  String get editCountry => 'देश';

  @override
  String get chooseLanguage => 'भाषा चुनें';

  @override
  String get chooseCurrency => 'मुद्रा चुनें';

  @override
  String get deleteAccountTitle => 'अपना खाता हटाएँ';

  @override
  String get deleteAccountBody =>
      'इससे आपकी प्रोफ़ाइल, कुंडलियाँ और चैट इतिहास हमेशा के लिए हट जाते हैं। आपके वॉलेट में बची राशि, यदि कोई हो, मूल भुगतान माध्यम में वापस कर दी जाती है। कानून के अनुसार परामर्श रिकॉर्ड रखे जाते हैं।';

  @override
  String get deleteAccountHold =>
      'आपका खाता तुरंत निष्क्रिय हो जाता है और 30 दिनों के बाद पूरी तरह हट जाता है। रद्द करने के लिए 30 दिनों के भीतर दोबारा साइन इन करें।';

  @override
  String get deleteAccountConfirm => 'हाँ, मेरा खाता हटाएँ';

  @override
  String get deleteAccountRequested => 'खाता हटाने का अनुरोध दर्ज किया गया';

  @override
  String get referTitle => 'रेफ़र करें और कमाएँ';

  @override
  String referHeroTitle(String friendAmount, String youAmount) {
    return '$friendAmount दें, $youAmount पाएँ';
  }

  @override
  String referHeroBody(String friendAmount, String youAmount) {
    return 'आपके दोस्त को पहले परामर्श पर $friendAmount की छूट मिलती है। जब वे परामर्श लेते हैं, आपके वॉलेट में $youAmount आते हैं।';
  }

  @override
  String get referYourCode => 'आपका रेफ़रल कोड';

  @override
  String get referShareLink => 'इनवाइट लिंक शेयर करें';

  @override
  String get referInvited => 'बुलाए गए';

  @override
  String get referJoined => 'जुड़े';

  @override
  String get referEarned => 'कमाए';

  @override
  String get referHowItWorks => 'यह कैसे काम करता है';

  @override
  String get referStep1 =>
      'अपना कोड या लिंक शेयर करें। आपका दोस्त साइन अप करते समय उसे डालता है।';

  @override
  String referStep2(String amount) {
    return 'उन्हें पहले भुगतान वाले परामर्श पर $amount की छूट मिलती है।';
  }

  @override
  String referStep3(String amount) {
    return 'जैसे ही उस परामर्श का बिल बनता है, $amount आपके वॉलेट में आ जाते हैं।';
  }

  @override
  String get referYourReferrals => 'आपके रेफ़रल';

  @override
  String get referStatusPending => 'बाकी';

  @override
  String get referStatusJoined => 'जुड़ा';

  @override
  String get referStatusRewarded => 'इनाम मिला';

  @override
  String referJoinedOn(String date) {
    return '$date को जुड़े';
  }

  @override
  String get referFirstCallDone => 'पहली कॉल पूरी';

  @override
  String referShareText(String code, String amount, String link) {
    return 'टॉकआचार्य पर मेरा कोड $code इस्तेमाल करें और अपने पहले ज्योतिष परामर्श पर $amount की छूट पाएँ। $link';
  }

  @override
  String get kundaliYogasDoshasTitle => 'योग और दोष';

  @override
  String get kundaliTabDoshas => 'दोष';

  @override
  String get kundaliTabYogas => 'योग';

  @override
  String get doshaIntro =>
      'दोष कुंडली के संवेदनशील बिंदु हैं। अधिकांश समय के साथ, अनुकूल दशा या किसी शास्त्रीय उपाय से कम हो जाते हैं — असल में क्या महत्वपूर्ण है, यह ज्योतिषी बताते हैं।';

  @override
  String get doshaDisclaimer =>
      'यह केवल संरचनात्मक संकेत हैं, भविष्यवाणी नहीं। रत्न पहनने या कोई बड़ा उपाय शुरू करने से पहले ज्योतिषी से बात करें।';

  @override
  String get doshaPresent => 'मौजूद';

  @override
  String get doshaNotPresent => 'मौजूद नहीं';

  @override
  String get doshaCancelled => 'लगभग निष्प्रभावी';

  @override
  String get doshaSeverityClear => 'स्पष्ट';

  @override
  String get doshaSeverityMild => 'हल्का';

  @override
  String get doshaSeverityModerate => 'मध्यम';

  @override
  String get doshaSeverityStrong => 'प्रबल';

  @override
  String get doshaWhy => 'क्यों चिह्नित हुआ';

  @override
  String get doshaWhatReduces => 'क्या इसे कम करता है';

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
  String get doshaClearSectionTitle => 'स्पष्ट — आपकी कुंडली में नहीं';

  @override
  String get doshaAllClear => 'आपकी कुंडली में कोई सामान्य दोष मौजूद नहीं है।';

  @override
  String get doshaAskCta => 'पूछें कि इसका आपके लिए क्या अर्थ है';

  @override
  String get insightsTitle => 'व्यक्तित्व एवं जीवन का सार';

  @override
  String get insightsIntro =>
      'आपकी जन्म (D1) कुंडली का एक निःशुल्क विश्लेषण — जीवन के मुख्य क्षेत्रों में आपकी प्रवृत्तियाँ। यह आत्म-चिंतन के लिए एक रेखाचित्र है, घटनाओं या तिथियों की भविष्यवाणी नहीं।';

  @override
  String get insightsDisclaimer =>
      'यह आपकी कुंडली से सामान्य मार्गदर्शन है, कोई भविष्यवाणी नहीं। इसमें कोई तिथि नहीं बताई जाती और स्वास्थ्य, आयु या संबंधों के बारे में कोई दावा नहीं किया जाता। किसी भी विशेष बात के लिए ज्योतिषी से बात करें।';

  @override
  String get insightsAskCta => 'अपनी कुंडली के बारे में ज्योतिषी से पूछें';

  @override
  String get insightsWhatItReadsFrom => 'यह किस आधार पर है';

  @override
  String get insightsToneSupportive => 'अनुकूल';

  @override
  String get insightsToneBalanced => 'संतुलित';

  @override
  String get insightsToneChallenging => 'ध्यान देने योग्य';

  @override
  String get insightsToneMixed => 'मिश्रित';

  @override
  String get insightsAreaPersonality => 'व्यक्तित्व एवं स्वभाव';

  @override
  String get insightsAreaAppearance => 'शारीरिक रूप-रंग';

  @override
  String get insightsAreaMind => 'मन एवं भावनाएँ';

  @override
  String get insightsAreaCareer => 'करियर एवं व्यवसाय';

  @override
  String get insightsAreaWealth => 'धन एवं वित्त';

  @override
  String get insightsAreaEducation => 'शिक्षा एवं बुद्धि';

  @override
  String get insightsAreaMarriage => 'विवाह एवं जीवनसाथी';

  @override
  String get insightsAreaFamily => 'परिवार एवं संबंध';

  @override
  String get insightsAreaHealth => 'स्वास्थ्य एवं जीवनशक्ति';

  @override
  String get insightsAreaFortune => 'भाग्य एवं धर्म';

  @override
  String get insightsAreaStrengths => 'शक्तियाँ एवं चुनौतियाँ';

  @override
  String get predTitle => 'भविष्यवाणियाँ';

  @override
  String get predReadingTitle => 'आपकी भविष्यवाणी';

  @override
  String get predRequestTitle => 'भविष्यवाणी का अनुरोध करें';

  @override
  String get predHeroTitle => 'आपके लिए लिखी गई भविष्यवाणी';

  @override
  String get predHeroBody =>
      'ज्योतिषी आपकी जन्म कुंडली, दशा और वर्तमान गोचर देखकर जीवन के किसी एक क्षेत्र की भविष्यवाणी लिखते हैं। आपकी भाषा में, आमतौर पर 3 दिनों के भीतर।';

  @override
  String get predChooseArea => 'क्षेत्र चुनें';

  @override
  String get predMyReadings => 'आपकी भविष्यवाणियाँ';

  @override
  String get predNoReadings =>
      'अभी कोई भविष्यवाणी नहीं। अनुरोध करने के लिए ऊपर से एक क्षेत्र चुनें।';

  @override
  String get predSeePacks => 'पैक देखें';

  @override
  String get predSubscribed => 'सदस्यता ली गई';

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
  String get predBuyTitle => 'भविष्यवाणी क्रेडिट';

  @override
  String get predBuyBody =>
      'एक क्रेडिट = एक लिखित भविष्यवाणी। एक पैक खरीदें और जब चाहें पढ़ने के लिए तैयार।';

  @override
  String get predBuyWalletNote => 'आपके वॉलेट बैलेंस से भुगतान।';

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
    return '$price प्रति क्रेडिट';
  }

  @override
  String predBuySuccess(int count) {
    return 'जुड़ गया। अब आपके पास $count क्रेडिट हैं।';
  }

  @override
  String get predForProfile => 'किस जन्म प्रोफ़ाइल के लिए';

  @override
  String get predAddProfile => 'जन्म प्रोफ़ाइल जोड़ें';

  @override
  String get predPickProfile => 'पहले एक जन्म प्रोफ़ाइल चुनें।';

  @override
  String get predArea => 'जीवन का क्षेत्र';

  @override
  String get predPeriod => 'अवधि';

  @override
  String predCostsOne(int count) {
    return 'आपके $count क्रेडिट में से 1 का उपयोग होगा।';
  }

  @override
  String get predNoCreditYet => 'आपको एक क्रेडिट चाहिए — हम आगे पैक दिखाएँगे।';

  @override
  String get predRequestCta => 'भविष्यवाणी का अनुरोध करें';

  @override
  String get predRequestDisclaimer =>
      'ज्योतिषी आपकी कुंडली, दशा और गोचर से लिखते हैं। ज्योतिष चिंतन और योजना के लिए मार्गदर्शन है, गारंटी नहीं।';

  @override
  String get predAreaCareer => 'करियर एवं कार्य';

  @override
  String get predAreaMarriage => 'विवाह एवं प्रेम';

  @override
  String get predAreaFinance => 'धन एवं वित्त';

  @override
  String get predAreaHealth => 'स्वास्थ्य एवं ऊर्जा';

  @override
  String get predAreaEducation => 'अध्ययन एवं शिक्षा';

  @override
  String get predAreaGeneral => 'जीवन का सार';

  @override
  String get predPeriodMonth => 'आने वाला महीना';

  @override
  String get predPeriodQuarter => 'अगले 3 महीने';

  @override
  String get predPeriodYear => 'आने वाला वर्ष';

  @override
  String get predStatusWriting => 'लिखी जा रही है';

  @override
  String get predStatusReview => 'समीक्षा में';

  @override
  String get predStatusReady => 'पढ़ने के लिए तैयार';

  @override
  String get predStatusUnavailable => 'उपलब्ध नहीं';

  @override
  String get predStatusRefunded => 'वापस किया गया';

  @override
  String predDeliveredOn(String date) {
    return '$date को दी गई';
  }

  @override
  String predEta(String date) {
    return '$date तक अपेक्षित';
  }

  @override
  String get predWritingTitle => 'एक ज्योतिषी इसे लिख रहे हैं';

  @override
  String get predWritingBody => 'तैयार होते ही हम आपको सूचना भेजेंगे।';

  @override
  String predWritingEta(String date) {
    return '$date तक अपेक्षित। तैयार होने पर हम आपको सूचित करेंगे।';
  }

  @override
  String get predRefundedTitle => 'क्रेडिट वापस किया गया';

  @override
  String get predRefundedBody =>
      'हम इसे समय पर नहीं दे सके, इसलिए आपका क्रेडिट वापस आपके खाते में है।';

  @override
  String get predDisclaimer =>
      'आपकी जन्म कुंडली, दशा और वर्तमान गोचर से ज्योतिषी द्वारा आपके लिए लिखी गई। ज्योतिष चिंतन और योजना के लिए मार्गदर्शन है — चुनाव और परिणाम आपके अपने रहते हैं।';

  @override
  String get predAskFollowUp => 'अनुवर्ती प्रश्न पूछें';

  @override
  String get remediesTitle => 'उपाय';

  @override
  String get remediesIntro =>
      'आपकी कुंडली के अनुसार पारंपरिक उपाय — इसके सक्रिय दोष, कमज़ोर ग्रह, चल रही दशा और पीड़ित भाव। ये अनुशासन और भक्ति के कार्य हैं, जो आपकी आस्था, स्वास्थ्य और सामर्थ्य के अनुसार चुने गए हैं।';

  @override
  String get remediesNone =>
      'अभी आपकी कुंडली में ऐसा कुछ प्रमुख नहीं जिसके लिए कोई विशेष उपाय आवश्यक हो। एक छोटा, नियमित दैनिक अभ्यास हमेशा लाभकारी है।';

  @override
  String get remediesDisclaimer =>
      'केवल वही करें जो आपकी आस्था, स्वास्थ्य और सामर्थ्य के अनुकूल हो। यदि उपवास आपके लिए असुरक्षित है तो न करें, और दान देने के लिए कभी ऋण न लें।';

  @override
  String get remediesAskCta => 'अपने उपायों के बारे में ज्योतिषी से बात करें';

  @override
  String get remediesConfirmCta => 'पहले ज्योतिषी से पुष्टि करें';

  @override
  String remediesSource(String source) {
    return 'स्रोत: $source';
  }

  @override
  String get doshaSeeRemedies => 'अपनी कुंडली के लिए उपाय देखें';

  @override
  String get remedyCatMantra => 'मंत्र एवं जप';

  @override
  String get remedyCatStotra => 'स्तोत्र एवं पाठ';

  @override
  String get remedyCatPuja => 'पूजा एवं अनुष्ठान';

  @override
  String get remedyCatVrat => 'व्रत एवं उपवास';

  @override
  String get remedyCatDaan => 'दान एवं परोपकार';

  @override
  String get remedyCatLifestyle => 'जीवनशैली';

  @override
  String get remedyCatYantra => 'यंत्र';

  @override
  String get remedyCatGemstone => 'रत्न';

  @override
  String get remedyCatRudraksha => 'रुद्राक्ष';

  @override
  String get prashnaTitle => 'एक प्रश्न पूछें';

  @override
  String get prashnaHeroTitle => 'इस क्षण पर हाँ-या-ना';

  @override
  String get prashnaHeroBody =>
      'KP प्रश्न (होररी) उस ठीक क्षण को पढ़ता है जब आप प्रश्न पूछते हैं और एक झुकाव देता है — हाँ, ना या मिश्रित — कारण सहित। यह एक पारंपरिक विधि का संकेत है, वादा नहीं।';

  @override
  String get prashnaAbout => 'प्रश्न किस बारे में है?';

  @override
  String get prashnaHint => 'जैसे: क्या मुझे यह नौकरी मिलेगी?';

  @override
  String prashnaAskCta(String price) {
    return 'पूछें ($price)';
  }

  @override
  String get prashnaDisclaimer =>
      'आपके पूछे गए क्षण का KP प्रश्न विश्लेषण। यह एक पारंपरिक विधि का संकेत है — वादा नहीं, और पूर्ण परामर्श का विकल्प नहीं।';

  @override
  String get prashnaNeedQuestion => 'पहले एक विषय चुनें और अपना प्रश्न लिखें।';

  @override
  String get prashnaLowBalance =>
      'आपका वॉलेट बैलेंस बहुत कम है। पूछने के लिए पैसे जोड़ें।';

  @override
  String get prashnaHistory => 'आपके प्रश्न';

  @override
  String get prashnaNoHistory => 'आपने अभी तक कोई प्रश्न नहीं पूछा।';

  @override
  String get prashnaAnswerTitle => 'विश्लेषण';

  @override
  String get prashnaAskAstrologer => 'किसी ज्योतिषी से इस पर चर्चा करें';

  @override
  String get prashnaHowRead => 'यह कैसे पढ़ा गया';

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
  String get prashnaVerdictYes => 'हाँ की ओर';

  @override
  String get prashnaVerdictNo => 'ना की ओर';

  @override
  String get prashnaVerdictMixed => 'मिश्रित संकेत';

  @override
  String get prashnaVerdictUnclear => 'अनिर्णायक';

  @override
  String get prashnaCatMarriage => 'विवाह';

  @override
  String get prashnaCatJob => 'नौकरी';

  @override
  String get prashnaCatPromotion => 'पदोन्नति';

  @override
  String get prashnaCatBusiness => 'व्यवसाय';

  @override
  String get prashnaCatProperty => 'संपत्ति';

  @override
  String get prashnaCatMoney => 'ऋण या धन';

  @override
  String get prashnaCatChild => 'संतान';

  @override
  String get prashnaCatTravel => 'विदेश यात्रा';

  @override
  String get prashnaCatLitigation => 'न्यायालय का मामला';

  @override
  String get prashnaCatHealth => 'स्वास्थ्य एवं स्वास्थ्य-लाभ';

  @override
  String get prashnaCatLost => 'खोई हुई वस्तु';

  @override
  String get prashnaCatReunion => 'पुनर्मिलन';

  @override
  String get prashnaCatGeneral => 'कुछ और';

  @override
  String get yogaIntro =>
      'योग प्रवृत्तियाँ हैं, गारंटी नहीं — ये तब मज़बूत होते हैं जब संबंधित ग्रह अच्छी स्थिति में हों और उनकी दशा चल रही हो।';

  @override
  String get yogaNoneTitle => 'कोई शास्त्रीय योग नहीं मिला';

  @override
  String get yogaNoneBody =>
      'यह आम बात है और बुरा संकेत नहीं — कुंडली फिर भी भावों और दशा से पढ़ी जाती है।';

  @override
  String get kundaliTalkToAstrologer => 'ज्योतिषी से बात करें';

  @override
  String get kundaliHowItPlaysOut =>
      'जानना चाहते हैं कि ये आपके जीवन और समय में कैसे प्रकट होते हैं?';

  @override
  String get yogaGajakesariName => 'गजकेसरी योग';

  @override
  String get yogaGajakesariMeaning =>
      'चंद्रमा से केंद्र में बृहस्पति — संतुलन, अच्छा निर्णय और प्रतिष्ठा।';

  @override
  String get yogaBudhadityaName => 'बुधादित्य योग';

  @override
  String get yogaBudhadityaMeaning =>
      'सूर्य और बुध साथ — तीव्र, अभिव्यक्तिशील बुद्धि; अध्ययन, लेखन और विश्लेषण में बल।';

  @override
  String get yogaChandraMangalaName => 'चंद्र-मंगल योग';

  @override
  String get yogaChandraMangalaMeaning =>
      'चंद्रमा के साथ मंगल — धन और उद्यम के प्रति प्रेरणा; परिश्रम और पहल से अर्जन।';

  @override
  String get yogaRajaName => 'राज योग';

  @override
  String get yogaRajaMeaning =>
      'केंद्र स्वामी का त्रिकोण स्वामी से संबंध — दशा चलने पर पद, अधिकार और अवसर में वृद्धि।';

  @override
  String get yogaDhanaName => 'धन योग';

  @override
  String get yogaDhanaMeaning =>
      'धन और लाभ भाव जुड़े हुए — बचत और स्थिर आर्थिक वृद्धि का समर्थन।';

  @override
  String get yogaNeechabhangaName => 'नीचभंग राज योग';

  @override
  String get yogaNeechabhangaMeaning =>
      'नीच ग्रह जिसकी दुर्बलता रद्द हो जाती है — आरंभिक संघर्ष जो आगे शक्ति बन जाता है।';

  @override
  String get yogaKaalSarpaName => 'काल सर्प योग';

  @override
  String get yogaKaalSarpaMeaning =>
      'सातों ग्रह राहु-केतु अक्ष के एक ओर — स्पष्ट दिशा मिलने तक जीवन बँधा-सा लग सकता है।';

  @override
  String get yogaAdhiName => 'अधि योग';

  @override
  String get yogaAdhiMeaning =>
      'चंद्रमा से 6वें, 7वें और 8वें में शुभ ग्रह — सुरक्षा, सक्षम सहयोगी और स्थिर स्थिति।';

  @override
  String get yogaShakataName => 'शकट योग';

  @override
  String get yogaShakataMeaning =>
      'बृहस्पति से 6वें, 8वें या 12वें में चंद्रमा — भाग्य में उतार-चढ़ाव; चंद्रमा बलवान हो तो अधिक स्थिर।';

  @override
  String get yogaVishName => 'विष योग';

  @override
  String get yogaVishMeaning =>
      'चंद्रमा के साथ शनि — मन पर भार; फल प्रायः बाद में, परिपक्वता के साथ आते हैं।';

  @override
  String get yogaKahalaName => 'कहल योग';

  @override
  String get yogaKahalaMeaning =>
      '4थे और 9वें स्वामी परस्पर केंद्र में और लग्नेश बलवान — साहसी, उद्यमी, जोखिम लेने को तैयार।';

  @override
  String get yogaPushkalaName => 'पुष्कल योग';

  @override
  String get yogaPushkalaMeaning =>
      'चंद्रमा का स्वामी लग्नेश के साथ केंद्र में — सम्मान, अच्छा नाम और प्रभावशाली वाणी।';

  @override
  String get yogaDaridraName => 'दरिद्र योग';

  @override
  String get yogaDaridraMeaning =>
      '11वें (लाभ) भाव का स्वामी कठिन भाव में — लाभ धीरे आते हैं; बलवान दशा इसे बदल देती है।';

  @override
  String get yogaAmalaName => 'अमल योग';

  @override
  String get yogaAmalaMeaning =>
      'लग्न या चंद्रमा से 10वें में केवल शुभ ग्रह — स्वच्छ प्रतिष्ठा और स्थायी सद्भावना।';

  @override
  String get yogaSaraswatiName => 'सरस्वती योग';

  @override
  String get yogaSaraswatiMeaning =>
      'बुध, शुक्र और बलवान बृहस्पति अच्छी स्थिति में — विद्या, कला और वाक्पटुता।';

  @override
  String get yogaLakshmiName => 'लक्ष्मी योग';

  @override
  String get yogaLakshmiMeaning =>
      'बलवान नवमेश केंद्र/त्रिकोण में और लग्नेश बलवान — भाग्य, सुख और शालीनता।';

  @override
  String get yogaRuchakaName => 'रुचक योग';

  @override
  String get yogaRuchakaMeaning =>
      'केंद्र में बलवान मंगल — साहस, शारीरिक बल और दबाव में नेतृत्व।';

  @override
  String get yogaBhadraName => 'भद्र योग';

  @override
  String get yogaBhadraMeaning =>
      'केंद्र में बलवान बुध — बुद्धि, स्पष्ट वाणी और व्यापार व संवाद में कुशलता।';

  @override
  String get yogaHamsaName => 'हंस योग';

  @override
  String get yogaHamsaMeaning =>
      'केंद्र में बलवान बृहस्पति — ज्ञान, नैतिकता, शिक्षक या सलाहकार स्वभाव और सामान्य सौभाग्य।';

  @override
  String get yogaMalavyaName => 'मालव्य योग';

  @override
  String get yogaMalavyaMeaning =>
      'केंद्र में बलवान शुक्र — आकर्षण, सुख, सौंदर्यबोध और सुखद गृहस्थ जीवन।';

  @override
  String get yogaSasaName => 'शश योग';

  @override
  String get yogaSasaMeaning =>
      'केंद्र में बलवान शनि — अनुशासन, सहनशक्ति और धीरे-धीरे अर्जित एवं टिकाऊ अधिकार।';

  @override
  String get yogaUbhayachariName => 'उभयचरी योग';

  @override
  String get yogaUbhayachariMeaning =>
      'सूर्य के दोनों ओर ग्रह — भली-भाँति समर्थित, प्रत्यक्ष जीवन और अच्छी समग्र प्रतिष्ठा।';

  @override
  String get yogaVesiName => 'वेसि योग';

  @override
  String get yogaVesiMeaning =>
      'सूर्य से दूसरे भाव में ग्रह — स्थिर वाणी, संतुलित दृष्टिकोण और अच्छा नाम।';

  @override
  String get yogaVasiName => 'वासि योग';

  @override
  String get yogaVasiMeaning =>
      'सूर्य से 12वें भाव में ग्रह — सामर्थ्य, प्रभाव और उदारता।';

  @override
  String get yogaShubhaKartariName => 'शुभ कर्तरी योग';

  @override
  String get yogaShubhaKartariMeaning =>
      'लग्न के दोनों ओर शुभ ग्रह — सुरक्षा, सहज मार्ग और अनुकूल परिस्थितियाँ।';

  @override
  String get yogaPapaKartariName => 'पाप कर्तरी योग';

  @override
  String get yogaPapaKartariMeaning =>
      'लग्न के दोनों ओर पाप ग्रह — स्वयं और स्वास्थ्य पर दबाव; अपनी ऊर्जा और सीमाओं की रक्षा करें।';

  @override
  String get yogaDurudharaName => 'दुरुधरा योग';

  @override
  String get yogaDurudharaMeaning =>
      'चंद्रमा के दूसरे और 12वें भाव में ग्रह — साधन, सुख और आसपास स्थिर सहयोग।';

  @override
  String get yogaSunaphaName => 'सुनफा योग';

  @override
  String get yogaSunaphaMeaning =>
      'चंद्रमा से दूसरे भाव में ग्रह — स्वअर्जित साधन, बुद्धि और अच्छी प्रतिष्ठा।';

  @override
  String get yogaAnaphaName => 'अनफा योग';

  @override
  String get yogaAnaphaMeaning =>
      'चंद्रमा से 12वें भाव में ग्रह — सरल स्वभाव, कुशलता और अभाव से मुक्ति।';

  @override
  String get yogaKemadrumaYogaName => 'केमद्रुम योग';

  @override
  String get yogaKemadrumaYogaMeaning =>
      'चंद्रमा अकेला, असमर्थित — भीतरी बेचैनी जो चंद्रमा के बलवान होने या केंद्र भरने पर कम होती है।';

  @override
  String get yogaVasumatiName => 'वसुमति योग';

  @override
  String get yogaVasumatiMeaning =>
      'लग्न या चंद्रमा से वृद्धि भावों में शुभ ग्रह — बढ़ता धन और साधन।';

  @override
  String get yogaKalanidhiName => 'कलानिधि योग';

  @override
  String get yogaKalanidhiMeaning =>
      'दूसरे या पाँचवें में बृहस्पति का बुध या शुक्र से संबंध — विद्या, कला, परिष्कार और सम्मान।';

  @override
  String get yogaChamaraName => 'चामर योग';

  @override
  String get yogaChamaraMeaning =>
      'केंद्र में उच्च का लग्नेश, बृहस्पति की दृष्टि — वाक्पटुता, दीर्घायु और सम्मानित स्थिति।';

  @override
  String get yogaShankhaName => 'शंख योग';

  @override
  String get yogaShankhaMeaning =>
      '5वें और 6वें भाव के स्वामी बलवान लग्नेश से जुड़े — अच्छा जीवन, दयालु स्वभाव और उत्तरार्ध में सुख।';

  @override
  String get yogaParvataName => 'पर्वत योग';

  @override
  String get yogaParvataMeaning =>
      'केंद्रों में शुभ ग्रह और 6ठा-8वाँ स्वच्छ — भाग्य, उदारता और प्रतिष्ठित नाम।';

  @override
  String get yogaHarshaName => 'हर्ष योग';

  @override
  String get yogaHarshaMeaning =>
      '6ठे भाव का स्वामी कठिन भाव में — शत्रु, ऋण और रोग की पकड़ ढीली; प्रतिस्पर्धी बल।';

  @override
  String get yogaSaralaName => 'सरल योग';

  @override
  String get yogaSaralaMeaning =>
      '8वें भाव का स्वामी कठिन भाव में — संकटों में दृढ़ता, दीर्घायु और निर्भयता।';

  @override
  String get yogaVimalaName => 'विमल योग';

  @override
  String get yogaVimalaMeaning =>
      '12वें भाव का स्वामी कठिन भाव में — संयमित व्यय, स्वच्छ अंतःकरण और स्वतंत्र जीवन।';

  @override
  String get yogaMahaParivartanaName => 'महा परिवर्तन योग';

  @override
  String get yogaMahaParivartanaMeaning =>
      'दो शुभ भावों के स्वामी राशि बदलते हैं — समय के साथ दोनों भावों के फल एक-दूसरे को उठाते हैं।';

  @override
  String get yogaKhalaParivartanaName => 'खल परिवर्तन योग';

  @override
  String get yogaKhalaParivartanaMeaning =>
      '3रे भाव से जुड़ा परिवर्तन — मिश्रित फल, उतार-चढ़ाव, परिश्रम और साहस से लाभ।';

  @override
  String get yogaDainyaParivartanaName => 'दैन्य परिवर्तन योग';

  @override
  String get yogaDainyaParivartanaMeaning =>
      'कठिन भाव से जुड़ा परिवर्तन — बाधाएँ जिनमें धैर्य चाहिए; बलवान दशा इसे बदल देती है।';

  @override
  String get kSignAries => 'साहसी, सीधा, जल्दी शुरुआत करने वाला';

  @override
  String get kSignTaurus =>
      'स्थिर, भोग-प्रिय, सुख और सुरक्षा को महत्व देने वाला';

  @override
  String get kSignGemini => 'जिज्ञासु, बातूनी, तेज़ सोच वाला';

  @override
  String get kSignCancer => 'देखभाल करने वाला, रक्षात्मक, भावनाओं से चलने वाला';

  @override
  String get kSignLeo => 'स्वाभिमानी, गर्मजोश, पहचाना जाना चाहने वाला';

  @override
  String get kSignVirgo => 'सटीक, उपयोगी, सुधार-केंद्रित';

  @override
  String get kSignLibra => 'न्यायप्रिय, संबंध-केंद्रित, संतुलन खोजने वाला';

  @override
  String get kSignScorpio => 'गहन, निजी, सब-कुछ-या-कुछ-नहीं';

  @override
  String get kSignSagittarius => 'स्वतंत्र, आस्थावान, बड़ी तस्वीर देखने वाला';

  @override
  String get kSignCapricorn => 'अनुशासित, महत्वाकांक्षी, लंबी दौड़ खेलने वाला';

  @override
  String get kSignAquarius => 'स्वतंत्र, प्रणाली-केंद्रित, अपरंपरागत';

  @override
  String get kSignPisces => 'कल्पनाशील, करुणामय, सीमाओं से परे';

  @override
  String get kPlanetNameSun => 'सूर्य';

  @override
  String get kPlanetNameMoon => 'चंद्र';

  @override
  String get kPlanetNameMars => 'मंगल';

  @override
  String get kPlanetNameMercury => 'बुध';

  @override
  String get kPlanetNameJupiter => 'गुरु';

  @override
  String get kPlanetNameVenus => 'शुक्र';

  @override
  String get kPlanetNameSaturn => 'शनि';

  @override
  String get kPlanetNameRahu => 'राहु';

  @override
  String get kPlanetNameKetu => 'केतु';

  @override
  String get kPlanetSun => 'आत्मा, आत्मविश्वास, पिता, अधिकार';

  @override
  String get kPlanetMoon => 'मन, भावनाएँ, माता, सुख';

  @override
  String get kPlanetMars => 'प्रेरणा, साहस, क्रोध, भाई-बहन';

  @override
  String get kPlanetMercury => 'बुद्धि, वाणी, व्यापार, कौशल';

  @override
  String get kPlanetJupiter => 'ज्ञान, वृद्धि, भाग्य, गुरु, संतान';

  @override
  String get kPlanetVenus => 'प्रेम, सौंदर्य, सुख, साझेदारी, कला';

  @override
  String get kPlanetSaturn => 'अनुशासन, समय, सीमाएँ, कठिन-अर्जित फल';

  @override
  String get kPlanetRahu => 'महत्वाकांक्षा, जुनून, विदेशी और नया';

  @override
  String get kPlanetKetu => 'वैराग्य, निपुणता, त्याग, आध्यात्म';

  @override
  String get kHouse1 => 'स्वयं, शरीर, जीवनशक्ति';

  @override
  String get kHouse2 => 'धन, परिवार, वाणी, भोजन';

  @override
  String get kHouse3 => 'साहस, भाई-बहन, प्रयास, छोटी यात्रा';

  @override
  String get kHouse4 => 'घर, माता, भूमि, आंतरिक शांति';

  @override
  String get kHouse5 => 'संतान, शिक्षा, रचनात्मकता, प्रेम';

  @override
  String get kHouse6 => 'स्वास्थ्य, ऋण, शत्रु, दैनिक कार्य';

  @override
  String get kHouse7 => 'विवाह, साझेदारी, व्यवसाय';

  @override
  String get kHouse8 => 'आयु, अचानक परिवर्तन, गुप्त, विरासत';

  @override
  String get kHouse9 => 'भाग्य, धर्म, पिता, उच्च शिक्षा, लंबी यात्रा';

  @override
  String get kHouse10 => 'करियर, प्रतिष्ठा, सार्वजनिक जीवन';

  @override
  String get kHouse11 => 'आय, लाभ, नेटवर्क, बड़े भाई-बहन';

  @override
  String get kHouse12 => 'हानि, व्यय, विदेश, नींद, मोक्ष';

  @override
  String get kDignityExalted => 'उच्च का — बहुत बलवान';

  @override
  String get kDignityDebilitated => 'नीच का — यहाँ दबाव में';

  @override
  String get kDignityMoolatrikona => 'मूलत्रिकोण — सहज और बलवान';

  @override
  String get kDignityOwn => 'स्वराशि — स्थिर और प्रभावी';

  @override
  String get kDignityGreatFriend => 'परम मित्र की राशि में — समर्थित';

  @override
  String get kDignityFriend => 'मित्र की राशि में — समर्थित';

  @override
  String get kDignityNeutral => 'सम राशि';

  @override
  String get kDignityEnemy => 'शत्रु की राशि में — अधिक परिश्रम';

  @override
  String get kDignityGreatEnemy => 'परम शत्रु की राशि में — दबाव में';

  @override
  String get kDashaSun =>
      'पहचान, अधिकार और मान्यता का काल। अहंकार तथा आँख/हृदय के स्वास्थ्य पर ध्यान।';

  @override
  String get kDashaMoon =>
      'एक कोमल, अधिक भावनात्मक अध्याय — घर, माता, मनोदशा और सार्वजनिक जीवन।';

  @override
  String get kDashaMars =>
      'ऊर्जा, प्रतिस्पर्धा और पहल बढ़ती है। क्रोध, दुर्घटना और संपत्ति के मामलों में सावधानी।';

  @override
  String get kDashaMercury =>
      'अध्ययन, व्यापार, लेखन और संवाद। पढ़ाई और व्यवसाय के लिए अच्छा, ठहराव में बेचैन।';

  @override
  String get kDashaJupiter =>
      'वृद्धि, गुरु, परिवार, अर्थ। प्रायः भाग्यशाली, विस्तृत काल।';

  @override
  String get kDashaVenus =>
      'संबंध, सुख, कला, धन और आनंद। आमतौर पर सबसे सहज काल।';

  @override
  String get kDashaSaturn =>
      'कठिन परिश्रम, ज़िम्मेदारी और धीमे, स्थायी फल। धैर्य को पुरस्कार, शॉर्टकट को दंड।';

  @override
  String get kDashaRahu =>
      'असीम महत्वाकांक्षा — विदेश, तकनीक, अचानक उत्थान और भ्रम।';

  @override
  String get kDashaKetu =>
      'वैराग्य, अंत और भीतर की ओर आध्यात्मिक मोड़। भौतिक वस्तुएँ खोखली लगती हैं; कौशल गहराता है।';

  @override
  String get kNakAshwini => 'तेज़, अग्रणी, उपचारक';

  @override
  String get kNakBharani => 'गहन, परिवर्तन के लिए स्थान देने वाला, अनुशासित';

  @override
  String get kNakKrittika => 'तीक्ष्ण, भेदने वाला, रक्षात्मक';

  @override
  String get kNakRohini => 'रचनात्मक, भोग-प्रिय, पोषक, आकर्षक';

  @override
  String get kNakMrigashira => 'खोजी, जिज्ञासु, कोमल';

  @override
  String get kNakArdra => 'तूफ़ानी, रूपांतरकारी, दबाव में प्रतिभाशाली';

  @override
  String get kNakPunarvasu =>
      'नवीकरण करने वाला, उदार, सुरक्षा की ओर लौटने वाला';

  @override
  String get kNakPushya => 'पोषक, कर्तव्यनिष्ठ, गहराई से सहायक';

  @override
  String get kNakAshlesha => 'सूक्ष्मदर्शी, रणनीतिक, सम्मोहक';

  @override
  String get kNakMagha => 'राजसी, परंपरा-बद्ध, पैतृक';

  @override
  String get kNakPurvaPhalguni =>
      'क्रीड़ाप्रिय, रोमांटिक, विश्राम को महत्व देने वाला';

  @override
  String get kNakUttaraPhalguni => 'विश्वसनीय, अनुबंधप्रिय, सहायक';

  @override
  String get kNakHasta => 'हस्तकुशल, चतुर, उपचारक';

  @override
  String get kNakChitra => 'कलात्मक, आकर्षक, सुंदर वस्तुएँ बनाने वाला';

  @override
  String get kNakSwati => 'स्वतंत्र, अनुकूलनशील, स्वतंत्रता-प्रेमी';

  @override
  String get kNakVishakha => 'लक्ष्य-केंद्रित, दृढ़, द्वि-स्वभावी';

  @override
  String get kNakAnuradha => 'समर्पित, मित्रवत, विदेश में फलने-फूलने वाला';

  @override
  String get kNakJyeshtha => 'वरिष्ठ, ज़िम्मेदार, बोझ उठाने वाला';

  @override
  String get kNakMula => 'मूल तक जाने वाला, आमूल, गहराई तक पहुँचने वाला';

  @override
  String get kNakPurvaAshadha => 'अजेय भावना, प्रभावशाली';

  @override
  String get kNakUttaraAshadha => 'सिद्धांतवादी, टिकाऊ, बाद में सफलता';

  @override
  String get kNakShravana => 'सुनने वाला, सीखने वाला, लोगों को जोड़ने वाला';

  @override
  String get kNakDhanishta => 'लयबद्ध, धनवान, संगीतमय, अनुकूलनशील';

  @override
  String get kNakShatabhisha => 'निजी, उपचारक, प्रणाली-केंद्रित';

  @override
  String get kNakPurvaBhadrapada => 'आदर्शवादी, गहन, रूपांतरकारी';

  @override
  String get kNakUttaraBhadrapada => 'गहरा, शांत, विवेकपूर्ण सलाह';

  @override
  String get kNakRevati => 'दयालु, यात्रियों का रक्षक, कल्पनाशील';

  @override
  String get kSadeSatiRising =>
      'आरोहण चरण — शनि आपके चंद्रमा से 12वीं राशि में। अंत, थकान और चीज़ों के समेटने का भाव। जो अब काम नहीं करता उसे हटाना शुरू करें।';

  @override
  String get kSadeSatiPeak =>
      'शिखर चरण — शनि आपकी चंद्र राशि पर ही। सबसे भारी दौर: ज़िम्मेदारी, दबाव और धीमी प्रगति। दिनचर्या बनाए रखें, स्वास्थ्य की रक्षा करें।';

  @override
  String get kSadeSatiSetting =>
      'अवरोहण चरण — शनि आपके चंद्रमा से दूसरी राशि में। भार हल्का होता है। धन और परिवार स्थिर होते हैं; पिछले वर्षों के सबक फल देने लगते हैं।';

  @override
  String get kSadeSatiGeneric =>
      'शनि आपके चंद्रमा के आसपास की राशियों से गोचर कर रहा है।';

  @override
  String kPlanetInSignHouse(
    Object planet,
    Object sign,
    Object signTrait,
    Object house,
    Object houseTheme,
  ) {
    return '$sign में आपका $planet आपको $signTrait बनाता है। $house भाव में यह $houseTheme को छूता है।';
  }

  @override
  String kPlanetInSign(Object planet, Object sign, Object signTrait) {
    return '$sign में आपका $planet आपको $signTrait बनाता है।';
  }

  @override
  String get kHouseSans1 => 'तनु भाव';

  @override
  String get kHouseSans2 => 'धन भाव';

  @override
  String get kHouseSans3 => 'सहज भाव';

  @override
  String get kHouseSans4 => 'सुख भाव';

  @override
  String get kHouseSans5 => 'पुत्र भाव';

  @override
  String get kHouseSans6 => 'रिपु भाव';

  @override
  String get kHouseSans7 => 'युवती भाव';

  @override
  String get kHouseSans8 => 'आयु / रंध्र भाव';

  @override
  String get kHouseSans9 => 'धर्म भाव';

  @override
  String get kHouseSans10 => 'कर्म भाव';

  @override
  String get kHouseSans11 => 'लाभ भाव';

  @override
  String get kHouseSans12 => 'व्यय भाव';

  @override
  String kHouseTitleWithSign(Object sign, Object theme) {
    return '$sign · $theme';
  }

  @override
  String kHouseSheetTitle(Object ordinal, Object sign) {
    return '$ordinal भाव · $sign';
  }

  @override
  String kHouseSheetSubtitle(Object sanskrit, Object theme) {
    return '$sanskrit — $theme';
  }

  @override
  String kHouseChipLord(Object lord) {
    return 'भावेश · $lord';
  }

  @override
  String kHouseChipLordIn(Object nthHouse) {
    return 'स्वामी $nthHouse में';
  }

  @override
  String kHouseNoPlanets(Object lord, Object lordWhere) {
    return 'इस भाव में कोई ग्रह नहीं। इसकी कथा मुख्यतः इसके स्वामी $lord$lordWhere से कही जाती है।';
  }

  @override
  String kHouseLordWhere(Object nthHouse) {
    return ', जो अब $nthHouse में है';
  }

  @override
  String get kHousePlanetsHeader => 'इस भाव में ग्रह';

  @override
  String kHouseAskCta(Object ordinal) {
    return 'अपने $ordinal भाव के बारे में ज्योतिषी से पूछें';
  }

  @override
  String kHouseReadingLord(
    Object ordinal,
    Object lord,
    Object nthHouse,
    Object theme,
    Object lordTheme,
  ) {
    return 'आपका $ordinal-भाव स्वामी $lord $nthHouse में है, इसलिए $theme का संबंध $lordTheme से जुड़ता है।';
  }

  @override
  String kHouseReadingOccupant(
    Object planet,
    Object planetTheme,
    Object theme,
  ) {
    return '$planet यहाँ अपने विषय — $planetTheme — $theme में लाता है।';
  }

  @override
  String get kHouseReadingEmpty =>
      'यह भाव इसके स्वामी और इस पर दृष्टि डालने वाले ग्रहों से पढ़ा जाता है। ज्योतिषी आपको विस्तार से समझा सकते हैं।';

  @override
  String kBhavaSubheadKaraka(Object karaka) {
    return 'कारक $karaka';
  }

  @override
  String kBhavaSubheadLord(Object lord, Object nthHouse) {
    return 'स्वामी $lord, $nthHouse';
  }

  @override
  String kBhavaSubheadLordOnly(Object lord) {
    return 'स्वामी $lord';
  }

  @override
  String kBhavaReadingGoverns(Object theme) {
    return 'यह भाव $theme का शासक है।';
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
    return 'इसका स्वामी $lord $nthHouse में है, इसलिए $theme का संबंध $lordTheme से जुड़ता है।$dignity$occupants';
  }

  @override
  String kBhavaReadingDignity(Object dignity) {
    return ' स्वामी $dignity।';
  }

  @override
  String kBhavaReadingOccupants(Object planets, Object themes) {
    return ' यहाँ $planets स्थित हैं, जो $themes जोड़ते हैं।';
  }

  @override
  String kTransitHouseLine(Object nthHouse, Object theme) {
    return 'आपका $nthHouse · $theme';
  }

  @override
  String kPlanetRowMeta(Object sign, Object nthHouse, Object degree) {
    return '$sign · $nthHouse · $degree°';
  }

  @override
  String kLagnaLordIn(Object nthHouse) {
    return '$nthHouse में';
  }

  @override
  String get kDignityShortExalted => 'उच्च';

  @override
  String get kDignityShortMoolatrikona => 'मूलत्रिकोण';

  @override
  String get kDignityShortOwn => 'स्वग्रही';

  @override
  String get kDignityShortDebilitated => 'नीच';

  @override
  String get kDignityShortEnemy => 'शत्रु राशि';

  @override
  String get kDignityShortGreatEnemy => 'परम शत्रु';

  @override
  String get kCombustNote =>
      'अस्त — सूर्य के बहुत निकट, इसलिए इसका स्वतंत्र स्वर मंद हो जाता है।';

  @override
  String get kWhatThisMeans => 'इसका आपके लिए क्या अर्थ है';

  @override
  String get ovStrengthStrong => 'बलवान';

  @override
  String get ovStrengthSteady => 'स्थिर';

  @override
  String get ovStrengthStrain => 'दबाव में';

  @override
  String get ovStrengthWeak => 'दुर्बल';

  @override
  String get ovRoleSpouse => 'जीवनसाथी कारक';

  @override
  String get ovRoleDarakaraka => 'दाराकारक (जैमिनी)';

  @override
  String get ovRoleWealth => 'धन कारक';

  @override
  String get ovRoleIntellect => 'बुद्धि कारक';

  @override
  String get ovRoleWisdom => 'ज्ञान कारक';

  @override
  String get ovRoleFortune => 'भाग्य कारक';

  @override
  String get ovRoleFather => 'पिता कारक';

  @override
  String get ovRoleMother => 'माता कारक';

  @override
  String get ovRoleGeneric => 'कारक';

  @override
  String ovfPada(int pada) {
    return 'पाद $pada';
  }

  @override
  String ovfLagnaSign(Object sign) {
    return 'लग्न राशि $sign';
  }

  @override
  String ovfLagnaLord(Object planet, Object nthHouse, Object dignity) {
    return 'लग्नेश $planet $nthHouse में$dignity';
  }

  @override
  String ovfHouseLord(Object ordinal, Object planet, Object nthHouse) {
    return '$ordinal-भाव स्वामी $planet $nthHouse में';
  }

  @override
  String ovfHouseStrength(Object ordinal, Object strength) {
    return '$ordinal भाव — $strength';
  }

  @override
  String ovfMoonSign(Object sign) {
    return 'चंद्रमा $sign में';
  }

  @override
  String ovfMoonHouse(Object nthHouse) {
    return 'चंद्रमा $nthHouse में';
  }

  @override
  String ovfMoonNakshatra(Object nakshatra) {
    return 'चंद्र नक्षत्र $nakshatra';
  }

  @override
  String ovfMoonDignity(Object dignity) {
    return 'चंद्रमा $dignity';
  }

  @override
  String ovfSunSign(Object sign) {
    return 'सूर्य $sign में';
  }

  @override
  String ovfSeventhSign(Object sign) {
    return '7वाँ भाव $sign में';
  }

  @override
  String ovfPlanetInHouse(Object planet, Object nthHouse) {
    return '$planet in the $nthHouse';
  }

  @override
  String ovfPlanetWithMoon(Object planet) {
    return '$planet चंद्रमा के साथ';
  }

  @override
  String ovfAppearanceIn(Object planet) {
    return '$planet पहले भाव में';
  }

  @override
  String ovfAppearanceAspect(Object planet) {
    return '$planet की पहले भाव पर दृष्टि';
  }

  @override
  String ovfMaleficOnLagna(Object planet) {
    return '$planet का लग्न पर दबाव';
  }

  @override
  String ovfKaraka(Object role, Object planet) {
    return '$role: $planet';
  }

  @override
  String ovfYoga(Object name) {
    return 'योग — $name';
  }

  @override
  String ovfDosha(Object name) {
    return 'दोष — $name';
  }

  @override
  String get doshaMangalName => 'मंगल दोष';

  @override
  String get doshaMangalMeaning =>
      'मंगल संवेदनशील भाव में — विवाह से पहले परंपरागत रूप से विचार किया जाता है। अक्सर तब संतुलित होता है जब दोनों साथी मांगलिक हों या गुरु मंगल को प्रभावित करे।';

  @override
  String get doshaKaalSarpaName => 'काल सर्प दोष';

  @override
  String get doshaKaalSarpaMeaning =>
      'पूरी कुंडली राहु और केतु के बीच — दिशा मिलने तक जीवन बँधा-बँधा लग सकता है, फिर एकाग्रता तीव्र हो जाती है।';

  @override
  String get doshaPitraName => 'पितृ दोष';

  @override
  String get doshaPitraMeaning =>
      'सूर्य और नवम भाव पर पूर्वजों के कर्म की छाया — प्रायः पिता के नाम पर श्राद्ध और दान से इसका समाधान किया जाता है।';

  @override
  String get doshaGandmoolName => 'गंडमूल दोष';

  @override
  String get doshaGandmoolMeaning =>
      'चंद्रमा संधि नक्षत्र में है। 27वें दिन शांति पूजा परंपरागत उपाय है।';

  @override
  String get doshaGrahanName => 'ग्रहण दोष';

  @override
  String get doshaGrahanMeaning =>
      'सूर्य या चंद्र किसी छाया ग्रह के साथ — उस ग्रह के फल तब तक मंद रहते हैं जब तक उन पर काम न हो।';

  @override
  String get doshaShrapitName => 'शापित दोष';

  @override
  String get doshaShrapitMeaning =>
      'शनि के साथ राहु — शुरुआत में देरी और उलझन; धैर्य और लगातार प्रयास ही रास्ता है।';

  @override
  String get doshaGuruChandalName => 'गुरु चांडाल दोष';

  @override
  String get doshaGuruChandalMeaning =>
      'गुरु के साथ छाया ग्रह — ज्ञान के साथ अपरंपरागत विचार; गुरु और मान्यताएँ सोच-समझकर चुनें।';

  @override
  String get doshaAngarakName => 'अंगारक दोष';

  @override
  String get doshaAngarakMeaning =>
      'मंगल के साथ छाया ग्रह — आवेगपूर्ण ऊर्जा; क्रोध, दुर्घटना और संपत्ति विवाद में सावधानी ज़रूरी।';

  @override
  String get doshaKemadrumaName => 'केमद्रुम दोष';

  @override
  String get doshaKemadrumaMeaning =>
      'चंद्रमा अकेला, आसपास कोई सहारा नहीं — केंद्र भाव भरा हो या चंद्रमा बलवान हो तो कम हो जाता है।';

  @override
  String get doshaDaridraName => 'दरिद्र दोष';

  @override
  String get doshaDaridraMeaning =>
      'धन भाव दबाव में — अनुशासित बचत और बलवान दशा इसे बदल देती है।';

  @override
  String get birthDetailsCta => 'पूरा जन्म विवरण';

  @override
  String get birthDetailsTitle => 'जन्म विवरण';

  @override
  String get birthDetailsAyanamsa => 'अयनांश';

  @override
  String get birthDetailsPanchangTitle => 'जन्म समय का पंचांग';

  @override
  String get birthDetailsChakraTitle => 'अवकहड़ा चक्र';

  @override
  String get birthDetailsWeekday => 'वार';

  @override
  String get birthDetailsTithi => 'तिथि';

  @override
  String get birthDetailsNakshatra => 'नक्षत्र';

  @override
  String get birthDetailsYoga => 'योग';

  @override
  String get birthDetailsKarana => 'करण';

  @override
  String get birthDetailsMoonSign => 'चंद्र राशि';

  @override
  String get birthDetailsSunSign => 'सूर्य राशि';

  @override
  String get birthDetailsSuryaNakshatra => 'सूर्य नक्षत्र';

  @override
  String get birthDetailsSunrise => 'सूर्योदय';

  @override
  String get birthDetailsSunset => 'सूर्यास्त';

  @override
  String get birthDetailsIshtaKala => 'इष्ट काल';

  @override
  String birthDetailsPada(int count) {
    return 'पाद $count';
  }

  @override
  String birthDetailsGhatiPala(int ghati, int pala, int vipala) {
    return '$ghati घटी $pala पल $vipala विपल';
  }

  @override
  String get birthDetailsNakshatraLord => 'नक्षत्र स्वामी';

  @override
  String get birthDetailsRashiLord => 'राशि स्वामी';

  @override
  String get birthDetailsVarna => 'वर्ण';

  @override
  String get birthDetailsVashya => 'वश्य';

  @override
  String get birthDetailsYoni => 'योनि';

  @override
  String get birthDetailsGana => 'गण';

  @override
  String get birthDetailsNadi => 'नाड़ी';

  @override
  String get birthDetailsTara => 'तारा';

  @override
  String get birthDetailsTattva => 'तत्त्व';

  @override
  String get birthDetailsYunja => 'युंजा';

  @override
  String get birthDetailsRashiPaya => 'राशि पाया';

  @override
  String get birthDetailsNakshatraPaya => 'नक्षत्र पाया';

  @override
  String get birthDetailsDisclaimer =>
      'पारंपरिक वर्गीकरण गुण — मुख्यतः मुहूर्त और गुण मिलान में प्रयुक्त, भविष्यवाणी नहीं।';

  @override
  String get vaaraMonday => 'सोमवार';

  @override
  String get vaaraTuesday => 'मंगलवार';

  @override
  String get vaaraWednesday => 'बुधवार';

  @override
  String get vaaraThursday => 'गुरुवार';

  @override
  String get vaaraFriday => 'शुक्रवार';

  @override
  String get vaaraSaturday => 'शनिवार';

  @override
  String get vaaraSunday => 'रविवार';

  @override
  String get tattvaFire => 'अग्नि';

  @override
  String get tattvaEarth => 'पृथ्वी';

  @override
  String get tattvaAir => 'वायु';

  @override
  String get tattvaWater => 'जल';

  @override
  String get payaGold => 'स्वर्ण';

  @override
  String get payaSilver => 'रजत';

  @override
  String get payaCopper => 'ताम्र';

  @override
  String get payaIron => 'लौह';

  @override
  String get roomAppBarTitle => 'परामर्श';

  @override
  String get roomOpenError => 'यह परामर्श नहीं खुल पाया।';

  @override
  String roomWaitingTitle(String name) {
    return '$name के स्वीकार करने का इंतज़ार';
  }

  @override
  String get roomWaitingBody =>
      'आमतौर पर एक मिनट से कम। वे जुड़ते ही चैट खुल जाएगी।';

  @override
  String get roomCancelRequest => 'अनुरोध रद्द करें';

  @override
  String get roomEndConfirmTitle => 'यह परामर्श समाप्त करें?';

  @override
  String get roomEndConfirmBody => 'सत्र समाप्त होते ही बिलिंग रुक जाती है।';

  @override
  String get roomKeepTalking => 'बात जारी रखें';

  @override
  String get roomEnd => 'समाप्त';

  @override
  String get roomAutoTranslateOn => 'ऑटो-अनुवाद चालू';

  @override
  String get roomAutoTranslateOff => 'ऑटो-अनुवाद बंद';

  @override
  String get roomEndedTitle => 'परामर्श समाप्त';

  @override
  String get roomBalanceOutTitle => 'आपका बैलेंस खत्म हो गया';

  @override
  String roomBalanceOutBody(String name) {
    return 'आपके वॉलेट का बैलेंस खत्म होने से चैट समाप्त हुई। $name के साथ जारी रखने के लिए रिचार्ज करके फिर शुरू करें।';
  }

  @override
  String get roomRechargeWallet => 'वॉलेट रिचार्ज करें';

  @override
  String roomStartAgain(String name) {
    return '$name के साथ फिर शुरू करें';
  }

  @override
  String get roomRowAstrologer => 'ज्योतिषी';

  @override
  String get roomRowDuration => 'अवधि';

  @override
  String get roomRowAmount => 'राशि';

  @override
  String get roomRowRate => 'दर';

  @override
  String roomMinutes(int minutes) {
    return '$minutes मिनट';
  }

  @override
  String roomRatePerMinute(String currency, String amount) {
    return '$currency $amount/मिनट';
  }

  @override
  String get roomRateQuestion => 'आपका परामर्श कैसा रहा?';

  @override
  String get roomSubmitRating => 'रेटिंग दें';

  @override
  String get roomRatingThanks => 'आपकी राय के लिए धन्यवाद!';

  @override
  String get roomBackHome => 'होम पर वापस';

  @override
  String get roomStatusRejected => 'ज्योतिषी यह अनुरोध नहीं ले सके';

  @override
  String get roomStatusCancelled => 'अनुरोध रद्द';

  @override
  String get roomStatusExpired => 'अनुरोध समाप्त — समय पर कोई जवाब नहीं';

  @override
  String get roomStatusNoShow => 'कॉल कनेक्ट नहीं हुई';

  @override
  String get roomStatusClosed => 'परामर्श बंद';

  @override
  String get roomBalanceRunningOut => 'बैलेंस खत्म हो रहा है';

  @override
  String roomMinLeftRecharge(int minutes) {
    return '~$minutes मिनट बचे · बात जारी रखने के लिए रिचार्ज करें';
  }

  @override
  String roomSpentMinLeft(String currency, String amount, int minutes) {
    return '$currency $amount खर्च · ~$minutes मिनट बचे';
  }

  @override
  String get roomAddMoney => 'पैसे जोड़ें';

  @override
  String get roomClientBalanceLow => 'ग्राहक का बैलेंस कम है — जल्दी समेटें';

  @override
  String get navChats => 'चैट';

  @override
  String get chatsTitle => 'चैट';

  @override
  String get chatsLoadError => 'आपकी चैट लोड नहीं हो पाईं।';

  @override
  String get chatsEmptyTitle => 'अभी कोई चैट नहीं';

  @override
  String get chatsEmptyBody =>
      'किसी ज्योतिषी से परामर्श शुरू करें, वह यहाँ दिखेगा।';

  @override
  String get chatsSectionActive => 'चालू';

  @override
  String get chatsSectionRecent => 'हाल की';

  @override
  String get chatsAstrologerFallback => 'ज्योतिषी';

  @override
  String get chatsStatusWaiting => 'ज्योतिषी के स्वीकार करने का इंतज़ार';

  @override
  String get chatsStatusLive => 'अभी लाइव · खोलने के लिए टैप करें';

  @override
  String chatsStatusEnded(int minutes) {
    return '$minutes मिनट का परामर्श';
  }

  @override
  String get chatsStatusCancelled => 'रद्द';

  @override
  String get chatsStatusRejected => 'स्वीकार नहीं हुआ';

  @override
  String get chatsStatusExpired => 'अनुरोध समाप्त';

  @override
  String get chatsStatusGeneric => 'परामर्श';

  @override
  String get numerologyTitle => 'अंक ज्योतिष और लो शु ग्रिड';

  @override
  String get numerologyIntro =>
      'आपकी जन्म तिथि (और नाम) से एक पारंपरिक अंक विश्लेषण — प्रत्येक अंक की प्रवृत्तियाँ, शुभ दिन और रंग, और आपका लो शु जन्म ग्रिड। यह चिंतन के लिए है, तिथिबद्ध भविष्यवाणी के लिए नहीं।';

  @override
  String get numMoolank => 'मूलांक · मानसिक अंक';

  @override
  String get numBhagyank => 'भाग्यांक · भाग्य अंक';

  @override
  String get numNaamank => 'नामांक · नाम अंक';

  @override
  String numRuledBy(String planet) {
    return '$planet द्वारा शासित';
  }

  @override
  String get numFriendly => 'मित्र';

  @override
  String get numNeutral => 'सम';

  @override
  String get numUnfriendly => 'शत्रु';

  @override
  String get numFavDays => 'शुभ दिन';

  @override
  String get numFavColours => 'शुभ रंग';

  @override
  String get numDirection => 'दिशा';

  @override
  String get numDeity => 'देवता';

  @override
  String get numGemstone => 'पारंपरिक रत्न';

  @override
  String get numLoShuTitle => 'लो शु जन्म ग्रिड';

  @override
  String numLoShuMissing(String nums) {
    return 'आपके ग्रिड में नहीं: $nums';
  }

  @override
  String numLoShuRepeated(String nums) {
    return 'प्रबल: $nums';
  }

  @override
  String get numArrowStrength => 'पूर्ण रेखा';

  @override
  String get numArrowAbsence => 'अनुपस्थित रेखा';

  @override
  String get numAskCta => 'इस बारे में ज्योतिषी से बात करें';

  @override
  String get sadeSatiTitle => 'साढ़े साती और ढैया कैलेंडर';

  @override
  String sadeSatiIntro(String sign) {
    return 'आपके जीवन में शनि की तिथिबद्ध अवधियाँ, आपकी चंद्र राशि $sign से गणना की गई। साढ़े साती शनि का चंद्रमा से 12वें, 1ले और 2रे में गोचर है (~7½ वर्ष); ढैया 4थे या 8वें में है (~2½ वर्ष)।';
  }

  @override
  String get sadeSatiRunningNow => 'अभी चल रही';

  @override
  String get sadeSatiPast => 'बीत चुकी';

  @override
  String get sadeSatiUpcoming => 'आगामी';

  @override
  String get sadeSatiPhaseRising => 'आरोही · शनि 12वें में';

  @override
  String get sadeSatiPhasePeak => 'शिखर · शनि चंद्रमा पर';

  @override
  String get sadeSatiPhaseSetting => 'अवरोही · शनि 2रे में';

  @override
  String get sadeSatiPhaseKantaka => 'कंटक · शनि 4थे में';

  @override
  String get sadeSatiPhaseAshtama => 'अष्टम · शनि 8वें में';

  @override
  String get sadeSatiDhaiyaHeading => 'ढैया (छोटी पनोती) अवधियाँ';

  @override
  String sadeSatiRange(String start, String end) {
    return '$start → $end';
  }

  @override
  String get avTransitHeading => 'आज के गोचर की अष्टकवर्ग शक्ति';

  @override
  String get avTransitIntro =>
      'आपकी जन्म बिंदु संख्याओं के अनुसार प्रत्येक ग्रह का गोचर कितनी सहजता से फल देता है। 8 में से 5+ अनुकूल, 4 मिश्रित, इससे कम कमज़ोर।';

  @override
  String avTransitBindus(int bindus) {
    return '$bindus/8 बिंदु';
  }

  @override
  String get avTransitUpcoming => 'आगे';

  @override
  String avTransitInHouse(String planet, String house) {
    return '$planet in your $house house';
  }

  @override
  String get muhurtaTitle => 'आज का मुहूर्त';

  @override
  String get muhurtaIntro =>
      'आज की चौघड़िया और होरा, आपके जन्म शहर के अनुसार और आपकी कुंडली के सहायक ग्रहों के अनुसार वैयक्तिकृत। काम शुरू करने के बेहतर और कमज़ोर समय का मार्गदर्शन — नियम नहीं।';

  @override
  String muhurtaSunTimes(
    String sunrise,
    String sunset,
    String weekday,
    String lord,
  ) {
    return '$sunrise सूर्योदय · $sunset सूर्यास्त · $weekday ($lord)';
  }

  @override
  String get muhurtaBestWindows => 'आज आपके लिए सर्वोत्तम समय';

  @override
  String get muhurtaNoBest =>
      'आज कोई विशेष समय नहीं — नीचे एक अच्छी चौघड़िया चुनें।';

  @override
  String get muhurtaDayChoghadiya => 'दिन की चौघड़िया';

  @override
  String get muhurtaNightChoghadiya => 'रात की चौघड़िया';

  @override
  String get muhurtaHora => 'ग्रह होरा';

  @override
  String get muhurtaNow => 'अभी';

  @override
  String get muhurtaChoGood => 'शुभ';

  @override
  String get muhurtaChoBad => 'त्यागें';

  @override
  String get muhurtaChoNeutral => 'सम';

  @override
  String get muhurtaHoraFavourable => 'आपके लिए अच्छा';

  @override
  String get muhurtaHoraCaution => 'हल्का रखें';

  @override
  String get upayaTitle => 'रत्न और उपाय';

  @override
  String upayaIntro(String sign) {
    return 'आपके लग्न ($sign) के लिए पारंपरिक उपाय तालिका — शुभ रंग, दिन, देवता, मंत्र और दान जिन्हें आप स्वतंत्र रूप से अपना सकते हैं, साथ ही प्रत्येक ग्रह का पारंपरिक रत्न और रुद्राक्ष।';
  }

  @override
  String get upayaLagnaFavourable => 'आपके लग्न के लिए शुभ';

  @override
  String get upayaColours => 'रंग';

  @override
  String get upayaDirection => 'दिशा';

  @override
  String get upayaDay => 'दिन';

  @override
  String get upayaDeity => 'देवता';

  @override
  String get upayaStrengthen => 'बल दें';

  @override
  String get upayaPacify => 'शांत करें';

  @override
  String get upayaMixed => 'मिश्रित';

  @override
  String get upayaNeutral => 'सम';

  @override
  String get upayaFreeMeasures => 'निःशुल्क उपाय';

  @override
  String get upayaMantra => 'मंत्र';

  @override
  String get upayaCharity => 'दान';

  @override
  String get upayaGemstone => 'रत्न';

  @override
  String get upayaRudraksha => 'रुद्राक्ष';

  @override
  String get upayaGatedCta => 'पहले ज्योतिषी से पुष्टि करें';

  @override
  String get upayaPriority => 'प्राथमिकता';

  @override
  String get lalKitabTitle => 'लाल किताब — ऋण और उपाय';

  @override
  String get lalKitabIntro =>
      'लाल किताब आपकी कुंडली से कुछ विरासत में मिले ऋण (रिन) पढ़ती है और प्रत्येक को सरल, निःशुल्क घरेलू टोटकों से दूर करती है। कोई रत्न नहीं, कोई खर्च नहीं।';

  @override
  String get lalKitabActiveDebts => 'सक्रिय ऋण';

  @override
  String get lalKitabNoDebts =>
      'कोई प्रबल सक्रिय रिन नहीं — रोज़मर्रा के कर्तव्य निभाते रहें और कुछ नहीं बढ़ता।';

  @override
  String get lalKitabWhyFlagged => 'क्यों चिह्नित';

  @override
  String get lalKitabRemedy => 'उपाय (टोटका)';

  @override
  String get lalKitabWeakPlanets => 'कमज़ोर ग्रह स्थिति';

  @override
  String get lalKitabAllRemedies => 'आपके उपाय';

  @override
  String lalKitabPakkaGhar(String planet, String house) {
    return '$planet का पक्का घर $house है';
  }

  @override
  String get varshphalTitle => 'वर्षफल — इस वर्ष की कुंडली';

  @override
  String varshphalIntro(String age) {
    return 'आपके $ageवें वर्ष के लिए ताजिक वार्षिक कुंडली, उस क्षण के लिए बनाई गई जब सूर्य अपनी जन्म स्थिति में लौटता है। ये कार्य करने योग्य विषय हैं — निश्चित घटनाएँ नहीं।';
  }

  @override
  String varshphalWindow(String start, String end) {
    return '$start → $end';
  }

  @override
  String get varshphalLagna => 'वर्ष लग्न';

  @override
  String get varshphalMuntha => 'मुंथा';

  @override
  String get varshphalYearLord => 'वर्षेश्वर (वर्ष स्वामी)';

  @override
  String get varshphalTajika => 'ताजिक दृष्टि';

  @override
  String varshphalMunthaLine(String house, String theme) {
    return 'मुंथा $house भाव में — $theme';
  }

  @override
  String get varshphalChart => 'वार्षिक कुंडली के ग्रह';

  @override
  String get prefsTransitAlerts => 'गोचर सूचनाएँ';

  @override
  String get prefsTransitAlertsDesc =>
      'जब कोई धीमा ग्रह (बृहस्पति, शनि) आपकी कुंडली में एक नए भाव में राशि बदलने वाला हो, तब एक सूचना।';

  @override
  String get errNetwork => 'सर्वर तक नहीं पहुँच सके। अपना कनेक्शन जाँचें।';

  @override
  String get errTimeout => 'सर्वर ने जवाब देने में बहुत समय लिया।';

  @override
  String get errSession =>
      'आपका सत्र समाप्त हो गया। कृपया दोबारा साइन इन करें।';

  @override
  String get errWalletInsufficient =>
      'इसके लिए आपके वॉलेट में पर्याप्त राशि नहीं है।';

  @override
  String get errRateLimited =>
      'बहुत ज़्यादा कोशिशें। थोड़ी देर रुककर फिर कोशिश करें।';

  @override
  String get errOtpInvalid => 'कोड गलत है या उसकी समय-सीमा समाप्त हो गई है।';

  @override
  String get errOtpMaxAttempts => 'बहुत ज़्यादा गलत कोशिशें। नया कोड मँगाएँ।';

  @override
  String get errPromoNotRedeemable => 'यह कूपन कोड इस्तेमाल नहीं हो सकता।';

  @override
  String get errRechargeInvalidAmount => 'अनुमत सीमा के भीतर राशि डालें।';

  @override
  String get errAuthWrongApp =>
      'यह नंबर दूसरे टॉकआचार्य ऐप के लिए रजिस्टर्ड है।';

  @override
  String get errGeneric => 'कुछ गड़बड़ हो गई। कृपया फिर कोशिश करें।';

  @override
  String get homePanchangTitle => 'आज का पंचांग';

  @override
  String get homeLiveNowTitle => 'अब सीधा प्रसारण हो रहा है';

  @override
  String get homeFreeToolsTitle => 'निःशुल्क उपकरण';

  @override
  String get homeResumeBtn => 'फिर शुरू करना';

  @override
  String get homeAddBtn => 'जोड़ना';

  @override
  String get homeNotifyMeBtn => 'मुझे सूचित करें';

  @override
  String get homeKundaliAction => 'कुण्डली';

  @override
  String get homeMatchingAction => 'मेल मिलाना';

  @override
  String get homeHoroscopeAction => 'राशिफल';

  @override
  String get homeVastuAction => 'वास्तु';

  @override
  String get homeRetryBtn => 'पुन: प्रयास करें';

  @override
  String get homeChooseSignTitle => 'अपनी राशि चुनें';

  @override
  String get homeChooseLanguageTitle => 'भाषा चुनें';

  @override
  String get homeLanguageTooltip => 'भाषा';

  @override
  String homeLanguageSwitchError(String error) {
    return 'स्विच नहीं हो सका: $error';
  }

  @override
  String get homeComingSoonSnackbar => 'जल्द आ रहा है!';

  @override
  String get homeTalkAgainTitle => 'फिर से बात करें';

  @override
  String get homeRechargeWalletTitle => 'अपने बटुए को फिर से भर लें';

  @override
  String get homeTalkToAstrologerTitle => 'किसी ज्योतिषी से बात करें';

  @override
  String get kSignNameAries => 'मेष';

  @override
  String get kSignNameTaurus => 'वृषभ';

  @override
  String get kSignNameGemini => 'मिथुन';

  @override
  String get kSignNameCancer => 'कर्क';

  @override
  String get kSignNameLeo => 'सिंह';

  @override
  String get kSignNameVirgo => 'कन्या';

  @override
  String get kSignNameLibra => 'तुला';

  @override
  String get kSignNameScorpio => 'वृश्चिक';

  @override
  String get kSignNameSagittarius => 'धनु';

  @override
  String get kSignNameCapricorn => 'मकर';

  @override
  String get kSignNameAquarius => 'कुंभ';

  @override
  String get kSignNamePisces => 'मीन';

  @override
  String get kNakNameAshwini => 'अश्विनी';

  @override
  String get kNakNameBharani => 'भरणी';

  @override
  String get kNakNameKrittika => 'कृत्तिका';

  @override
  String get kNakNameRohini => 'रोहिणी';

  @override
  String get kNakNameMrigashira => 'मृगशिरा';

  @override
  String get kNakNameArdra => 'आर्द्रा';

  @override
  String get kNakNamePunarvasu => 'पुनर्वसु';

  @override
  String get kNakNamePushya => 'पुष्य';

  @override
  String get kNakNameAshlesha => 'आश्लेषा';

  @override
  String get kNakNameMagha => 'मघा';

  @override
  String get kNakNamePurvaPhalguni => 'पूर्व फाल्गुनी';

  @override
  String get kNakNameUttaraPhalguni => 'उत्तर फाल्गुनी';

  @override
  String get kNakNameHasta => 'हस्त';

  @override
  String get kNakNameChitra => 'चित्रा';

  @override
  String get kNakNameSwati => 'स्वाति';

  @override
  String get kNakNameVishakha => 'विशाखा';

  @override
  String get kNakNameAnuradha => 'अनुराधा';

  @override
  String get kNakNameJyeshtha => 'ज्येष्ठा';

  @override
  String get kNakNameMula => 'मूल';

  @override
  String get kNakNamePurvaAshadha => 'पूर्वाषाढ़ा';

  @override
  String get kNakNameUttaraAshadha => 'उत्तराषाढ़ा';

  @override
  String get kNakNameShravana => 'श्रवण';

  @override
  String get kNakNameDhanishta => 'धनिष्ठा';

  @override
  String get kNakNameShatabhisha => 'शतभिषा';

  @override
  String get kNakNamePurvaBhadrapada => 'पूर्व भाद्रपद';

  @override
  String get kNakNameUttaraBhadrapada => 'उत्तर भाद्रपद';

  @override
  String get kNakNameRevati => 'रेवती';

  @override
  String get kChartNameD1 => 'राशि';

  @override
  String get kChartSigD1 => 'शरीर, संपूर्ण जीवन, सब कुछ';

  @override
  String get kChartNameD2 => 'होरा';

  @override
  String get kChartSigD2 => 'धन, आर्थिक समृद्धि';

  @override
  String get kChartNameD3 => 'द्रेष्काण';

  @override
  String get kChartSigD3 => 'भाई-बहन, साहस, पहल';

  @override
  String get kChartNameD4 => 'चतुर्थांश';

  @override
  String get kChartSigD4 => 'भाग्य, संपत्ति, अचल संपत्ति, घर';

  @override
  String get kChartNameD5 => 'पंचमांश';

  @override
  String get kChartSigD5 => 'यश, अधिकार, आध्यात्मिक पुण्य';

  @override
  String get kChartNameD6 => 'षष्ठांश';

  @override
  String get kChartSigD6 => 'स्वास्थ्य, रोग, ऋण, शत्रु';

  @override
  String get kChartNameD7 => 'सप्तमांश';

  @override
  String get kChartSigD7 => 'संतान, वंश, रचनात्मकता';

  @override
  String get kChartNameD8 => 'अष्टमांश';

  @override
  String get kChartSigD8 => 'आकस्मिक घटनाएँ, आयु संबंधी कष्ट, बाधाएँ';

  @override
  String get kChartNameD9 => 'नवमांश';

  @override
  String get kChartSigD9 => 'जीवनसाथी, धर्म, अंतर्मन — मुख्य सहायक कुंडली';

  @override
  String get kChartNameD10 => 'दशमांश';

  @override
  String get kChartSigD10 => 'करियर, व्यवसाय, प्रतिष्ठा, उपलब्धि';

  @override
  String get kChartNameD11 => 'रुद्रांश';

  @override
  String get kChartSigD11 => 'मृत्यु, विनाश, विपत्ति से लाभ';

  @override
  String get kChartNameD12 => 'द्वादशांश';

  @override
  String get kChartSigD12 => 'माता-पिता, पूर्वज, विरासत में मिला कर्म';

  @override
  String get kChartNameD16 => 'षोडशांश';

  @override
  String get kChartSigD16 => 'वाहन, सुख-सुविधाएँ, विलासिता, प्रसन्नता';

  @override
  String get kChartNameD20 => 'विंशांश';

  @override
  String get kChartSigD20 => 'आध्यात्मिक साधना, पूजा, भक्ति';

  @override
  String get kChartNameD24 => 'चतुर्विंशांश';

  @override
  String get kChartSigD24 => 'शिक्षा, विद्या, ज्ञान';

  @override
  String get kChartNameD27 => 'सप्तविंशांश';

  @override
  String get kChartSigD27 => 'शक्ति और दुर्बलता, सहनशक्ति';

  @override
  String get kChartNameD30 => 'त्रिंशांश';

  @override
  String get kChartSigD30 => 'दुर्भाग्य, अनिष्ट, नैतिक चरित्र';

  @override
  String get kChartNameD40 => 'चत्वारिंशांश';

  @override
  String get kChartSigD40 => 'मातृ विरासत, शुभ/अशुभ प्रभाव';

  @override
  String get kChartNameD45 => 'अक्षवेदांश';

  @override
  String get kChartSigD45 => 'पितृ विरासत, समग्र चरित्र और आचरण';

  @override
  String get kChartNameD60 => 'षष्ट्यंश';

  @override
  String get kChartSigD60 => 'पूर्व जन्म के कर्म, सबसे सूक्ष्म स्तर — समग्र';

  @override
  String get kChartNameMoon => 'चंद्र कुंडली';

  @override
  String get kChartSigMoon => 'मन और भावनाएँ — चंद्रमा से पढ़ी गई राशि कुंडली';

  @override
  String get kChartNameChalit => 'भाव चलित';

  @override
  String get kChartSigChalit =>
      'वास्तविक भाव संधियों (श्रीपति) के अनुसार भाव फल, पूर्ण राशि नहीं';

  @override
  String get kChartNameTransit => 'गोचर';

  @override
  String get kChartSigTransit => 'जन्म कुंडली के भावों पर वर्तमान ग्रह';

  @override
  String get kChartShortMoon => 'चंद्र';

  @override
  String get kChartShortChalit => 'चलित';

  @override
  String get kChartShortTransit => 'गोचर';

  @override
  String get kChAscendant => 'लग्न';

  @override
  String get kChLagnaVargottama => 'लग्न वर्गोत्तम';

  @override
  String kChAsOf(Object when) {
    return '$when तक';
  }

  @override
  String get kChUnverified =>
      'यह वर्ग अभी DrikPanchang से सत्यापित नहीं है — ग्रह स्थितियों को प्रायोगिक मानें।';

  @override
  String kChChalitShiftedOne(Object planets) {
    return '$planets पूर्ण-राशि भाव से अलग भाव में है।';
  }

  @override
  String kChChalitShiftedMany(Object planets) {
    return '$planets पूर्ण-राशि भाव से अलग भाव में हैं।';
  }

  @override
  String get kChColPlanet => 'ग्रह';

  @override
  String get kChColSign => 'राशि';

  @override
  String get kChColDegree => 'अंश';

  @override
  String get kChColHouse => 'भाव';

  @override
  String get kChColBhava => 'चलित भाव';

  @override
  String get kChColFromMoon => 'चंद्र से';

  @override
  String get kChLegend => 'संकेत';

  @override
  String get kChLegendNote =>
      '℞ वक्री   ⬦ वर्गोत्तम   ← बदला हुआ भाव (चलित)\nउत्तर भारतीय: खाने की संख्या = राशि (1 मेष … 12 मीन), पहला भाव ऊपर बीच में।';

  @override
  String get kChNorthIndian => 'उत्तर भारतीय';

  @override
  String get kChSouthIndian => 'दक्षिण भारतीय';

  @override
  String get kChPickerCharts => 'कुंडलियाँ';

  @override
  String get kChPickerDivisional => 'वर्ग कुंडलियाँ';

  @override
  String get kOvTitle => 'कुंडली';

  @override
  String kOvTitleNamed(Object name) {
    return '$name की कुंडली';
  }

  @override
  String get kOvDownloadPdf => 'PDF डाउनलोड करें';

  @override
  String get kOvShare => 'शेयर करें';

  @override
  String get kOvMoonSignLabel => 'चंद्र राशि';

  @override
  String kOvLagnaChip(Object sign) {
    return 'लग्न · $sign';
  }

  @override
  String kOvNakshatraChip(Object name) {
    return 'नक्षत्र · $name';
  }

  @override
  String get kOvTimeApprox => 'जन्म समय अनुमानित';

  @override
  String get kOvEdit => 'बदलें';

  @override
  String get kOvLagnaChart => 'लग्न कुंडली';

  @override
  String get kOvD1Rasi => 'D1 राशि';

  @override
  String get kOvOpenFullChart => 'पूरी कुंडली देखें';

  @override
  String get kOvDashaUnavailable => 'दशा अभी उपलब्ध नहीं है।';

  @override
  String get kOvDashaRunning => 'अभी आपकी चल रही दशा';

  @override
  String kOvMahadasha(Object planet) {
    return '$planet महादशा';
  }

  @override
  String kOvSubPeriods(Object antar, Object pratyantar) {
    return '$antar अंतर्दशा · $pratyantar प्रत्यंतर्दशा';
  }

  @override
  String kOvDashaProgress(Object end, Object percent, Object start) {
    return '$start → $end  ·  $percent% पूर्ण';
  }

  @override
  String get kOvSeeTimeline => 'पूरी समयरेखा देखें';

  @override
  String get kOvAtAGlance => 'एक नज़र में';

  @override
  String get kOvMangalDosha => 'मंगल दोष';

  @override
  String get kOvManglik => 'मांगलिक';

  @override
  String get kOvNotManglik => 'मांगलिक नहीं';

  @override
  String kOvMangalFrom(Object refs) {
    return '$refs से';
  }

  @override
  String get kOvMarsClear => 'मंगल शुद्ध है';

  @override
  String get kOvMangalCancelled => 'दोष बनता है, पर आपकी कुंडली में निरस्त है';

  @override
  String kOvMangalLevelFrom(Object level, Object refs) {
    return '$level · $refs से';
  }

  @override
  String get kOvRefLagna => 'लग्न';

  @override
  String get kOvYogas => 'योग';

  @override
  String kOvYogasFound(Object count) {
    return '$count मिले';
  }

  @override
  String get kOvNakshatra => 'नक्षत्र';

  @override
  String get kOvLagnaLord => 'लग्नेश';

  @override
  String get kOvExInsights => 'व्यक्तित्व और जीवन सार';

  @override
  String get kOvExInsightsSub =>
      'आपकी कुंडली का मुफ़्त विश्लेषण — स्वभाव, काम, विवाह और बहुत कुछ';

  @override
  String get kOvExForecast => 'लिखित भविष्यफल';

  @override
  String get kOvExForecastSub =>
      'जीवन के किसी एक क्षेत्र का सशुल्क भविष्यफल, ज्योतिषी द्वारा लिखित';

  @override
  String get kOvExPlanets => 'ग्रह और स्थितियाँ';

  @override
  String get kOvExPlanetsSub => 'हर ग्रह कहाँ बैठा है और क्या करता है';

  @override
  String get kOvExDasha => 'दशा काल';

  @override
  String get kOvExDashaSub => 'आपके जीवन की समयरेखा — विंशोत्तरी';

  @override
  String get kOvExVarshphal => 'वर्षफल (वार्षिक कुंडली)';

  @override
  String get kOvExVarshphalSub =>
      'इस सौर वर्ष का फल — मुंथा, वर्षेश और ताजिक दृष्टि';

  @override
  String get kOvExYogas => 'योग और दोष';

  @override
  String get kOvExYogasSub => 'आपकी कुंडली के विशेष योग';

  @override
  String get kOvExRemedies => 'उपाय';

  @override
  String get kOvExRemediesSub =>
      'आपकी कुंडली के लिए पारंपरिक मंत्र, दान और साधनाएँ';

  @override
  String get kOvExUpaya => 'रत्न और उपाय';

  @override
  String get kOvExUpayaSub =>
      'हर ग्रह का रत्न, रंग, दिन और मंत्र — रत्न परामर्श के बाद';

  @override
  String get kOvExLalKitab => 'लाल किताब';

  @override
  String get kOvExLalKitabSub => 'पैतृक ऋण और उनके आसान, मुफ़्त टोटके';

  @override
  String get kOvExTransits => 'गोचर और साढ़े साती';

  @override
  String get kOvExTransitsSub => 'अभी आकाश में क्या चल रहा है';

  @override
  String get kOvExSadeSati => 'साढ़े साती और ढैया कैलेंडर';

  @override
  String get kOvExSadeSatiSub => 'जीवन भर शनि के सभी चरण, तारीखों के साथ';

  @override
  String get kOvExMuhurta => 'आज का समय';

  @override
  String get kOvExMuhurtaSub => 'चौघड़िया और होरा, आपके सबसे अच्छे समय चिह्नित';

  @override
  String get kOvExHouses => 'भाव';

  @override
  String get kOvExHousesSub => 'सभी 12 भावों का फल';

  @override
  String get kOvExNumerology => 'अंक ज्योतिष और लो शू ग्रिड';

  @override
  String get kOvExNumerologySub =>
      'जन्म तिथि से आपके अंक — दिन, रंग, जन्म ग्रिड';

  @override
  String get kOvExAdvanced => 'उन्नत रिपोर्ट';

  @override
  String get kOvExAdvancedSub => 'अष्टकवर्ग, षड्बल, केपी, जैमिनी';

  @override
  String get kOvAskAstrologer => 'अपनी कुंडली के बारे में ज्योतिषी से पूछें';

  @override
  String get kReadingCardTitle => 'इसका अर्थ';

  @override
  String kSsTitle(Object phase) {
    return 'साढ़े साती · $phase चरण';
  }

  @override
  String get kSsPhaseRising => 'आरंभ (3 में से 1)';

  @override
  String get kSsPhasePeak => 'चरम (3 में से 2)';

  @override
  String get kSsPhaseSetting => 'उतार (3 में से 3)';

  @override
  String get kSsRising => 'आरंभ';

  @override
  String get kSsPeak => 'चरम';

  @override
  String get kSsSetting => 'उतार';

  @override
  String get kSsNotCurse =>
      'साढ़े साती मेहनत और परिपक्वता का समय है — कोई श्राप नहीं। निरंतर, ईमानदार प्रयास का फल मिलता है।';

  @override
  String get kSsWhatForMe => 'मेरे लिए इसका क्या अर्थ है';

  @override
  String kSsPanotiTitle(Object type) {
    return 'लघु पनौती — $type';
  }

  @override
  String get kSsPanotiBody =>
      'शनि का छोटा चरण (लगभग ढाई वर्ष) जो स्वास्थ्य, प्रयास और रोज़ की बाधाओं में धैर्य माँगता है।';

  @override
  String get kSsSeeTransits => 'गोचर देखें';

  @override
  String get kSsSkyNow => 'अभी आकाश में';

  @override
  String get kSsJupiterGood =>
      'गुरु का गोचर आपके लिए अनुकूल है — विकास, शिक्षा और धन के लिए सहायक समय।';

  @override
  String get kSsJupiterNeutral =>
      'कोई साढ़े साती या शनि का बड़ा चरण सक्रिय नहीं है। गुरु का गोचर अभी आपके लिए सामान्य है।';

  @override
  String get kSsSeeAllTransits => 'सभी गोचर देखें';

  @override
  String get kFcTitle => 'जन्म कुंडली';

  @override
  String get kFcTransitingGrahas => 'गोचर ग्रह';

  @override
  String get kFcPlanets => 'ग्रह';

  @override
  String get kFcAllHouses => 'सभी 12 भाव और फल';

  @override
  String get kFcAllCharts => 'सभी कुंडलियाँ — D1 से D60';

  @override
  String get kFcAllChartsTooltip => 'सभी कुंडलियाँ';

  @override
  String get kFcLoadError => 'यह कुंडली लोड नहीं हो सकी';

  @override
  String get kFcTwelveHouses => '12 भाव';

  @override
  String get kFcNoPlanets => 'कोई ग्रह नहीं';

  @override
  String kBdTithi(String key, Object raw) {
    String _temp0 = intl.Intl.selectLogic(key, {
      'Pratipada': 'प्रतिपदा',
      'Dwitiya': 'द्वितीया',
      'Tritiya': 'तृतीया',
      'Chaturthi': 'चतुर्थी',
      'Panchami': 'पंचमी',
      'Shashthi': 'षष्ठी',
      'Saptami': 'सप्तमी',
      'Ashtami': 'अष्टमी',
      'Navami': 'नवमी',
      'Dashami': 'दशमी',
      'Ekadashi': 'एकादशी',
      'Dwadashi': 'द्वादशी',
      'Trayodashi': 'त्रयोदशी',
      'Chaturdashi': 'चतुर्दशी',
      'Purnima': 'पूर्णिमा',
      'Amavasya': 'अमावस्या',
      'other': '$raw',
    });
    return '$_temp0';
  }

  @override
  String kBdPaksha(String key, Object raw) {
    String _temp0 = intl.Intl.selectLogic(key, {
      'Shukla': 'शुक्ल',
      'Krishna': 'कृष्ण',
      'other': '$raw',
    });
    return '$_temp0';
  }

  @override
  String kBdYoga(String key, Object raw) {
    String _temp0 = intl.Intl.selectLogic(key, {
      'Vishkambha': 'विष्कम्भ',
      'Priti': 'प्रीति',
      'Ayushman': 'आयुष्मान',
      'Saubhagya': 'सौभाग्य',
      'Shobhana': 'शोभन',
      'Atiganda': 'अतिगण्ड',
      'Sukarman': 'सुकर्मा',
      'Dhriti': 'धृति',
      'Shula': 'शूल',
      'Ganda': 'गण्ड',
      'Vriddhi': 'वृद्धि',
      'Dhruva': 'ध्रुव',
      'Vyaghata': 'व्याघात',
      'Harshana': 'हर्षण',
      'Vajra': 'वज्र',
      'Siddhi': 'सिद्धि',
      'Vyatipata': 'व्यतीपात',
      'Variyana': 'वरीयान',
      'Parigha': 'परिघ',
      'Shiva': 'शिव',
      'Siddha': 'सिद्ध',
      'Sadhya': 'साध्य',
      'Shubha': 'शुभ',
      'Shukla': 'शुक्ल',
      'Brahma': 'ब्रह्म',
      'Indra': 'इन्द्र',
      'Vaidhriti': 'वैधृति',
      'other': '$raw',
    });
    return '$_temp0';
  }

  @override
  String kBdKarana(String key, Object raw) {
    String _temp0 = intl.Intl.selectLogic(key, {
      'Bava': 'बव',
      'Balava': 'बालव',
      'Kaulava': 'कौलव',
      'Taitila': 'तैतिल',
      'Gara': 'गर',
      'Vanija': 'वणिज',
      'Vishti': 'विष्टि',
      'Kimstughna': 'किंस्तुघ्न',
      'Shakuni': 'शकुनि',
      'Chatushpada': 'चतुष्पाद',
      'Naga': 'नाग',
      'other': '$raw',
    });
    return '$_temp0';
  }

  @override
  String kBdVarna(String key, Object raw) {
    String _temp0 = intl.Intl.selectLogic(key, {
      'Kshatriya': 'क्षत्रिय',
      'Vaishya': 'वैश्य',
      'Shudra': 'शूद्र',
      'Brahmin': 'ब्राह्मण',
      'other': '$raw',
    });
    return '$_temp0';
  }

  @override
  String kBdVashya(String key, Object raw) {
    String _temp0 = intl.Intl.selectLogic(key, {
      'Chatushpada': 'चतुष्पद',
      'Manava': 'मानव',
      'Jalachara': 'जलचर',
      'Vanachara': 'वनचर',
      'Keeta': 'कीट',
      'other': '$raw',
    });
    return '$_temp0';
  }

  @override
  String kBdYoni(String key, Object raw) {
    String _temp0 = intl.Intl.selectLogic(key, {
      'Horse': 'अश्व',
      'Elephant': 'गज',
      'Sheep': 'मेष',
      'Serpent': 'सर्प',
      'Dog': 'श्वान',
      'Cat': 'मार्जार',
      'Rat': 'मूषक',
      'Cow': 'गौ',
      'Buffalo': 'महिष',
      'Tiger': 'व्याघ्र',
      'Deer': 'मृग',
      'Monkey': 'वानर',
      'Mongoose': 'नकुल',
      'Lion': 'सिंह',
      'other': '$raw',
    });
    return '$_temp0';
  }

  @override
  String kBdGana(String key, Object raw) {
    String _temp0 = intl.Intl.selectLogic(key, {
      'Deva': 'देव',
      'Manushya': 'मनुष्य',
      'Rakshasa': 'राक्षस',
      'other': '$raw',
    });
    return '$_temp0';
  }

  @override
  String kBdNadi(String key, Object raw) {
    String _temp0 = intl.Intl.selectLogic(key, {
      'Aadi': 'आदि',
      'Madhya': 'मध्य',
      'Antya': 'अंत्य',
      'other': '$raw',
    });
    return '$_temp0';
  }

  @override
  String kBdTara(String key, Object raw) {
    String _temp0 = intl.Intl.selectLogic(key, {
      'Janma': 'जन्म',
      'Sampat': 'सम्पत',
      'Vipat': 'विपत',
      'Kshema': 'क्षेम',
      'Pratyari': 'प्रत्यरि',
      'Sadhaka': 'साधक',
      'Vadha': 'वध',
      'Mitra': 'मित्र',
      'AtiMitra': 'अति मित्र',
      'other': '$raw',
    });
    return '$_temp0';
  }

  @override
  String kBdYunja(String key, Object raw) {
    String _temp0 = intl.Intl.selectLogic(key, {
      'Purva': 'पूर्व',
      'Madhya': 'मध्य',
      'Uttara': 'उत्तर',
      'other': '$raw',
    });
    return '$_temp0';
  }

  @override
  String get horoTitle => 'राशिफल';

  @override
  String get horoReadFull => 'पूरा राशिफल पढ़ें';

  @override
  String get horoSpanYesterday => 'बीता कल';

  @override
  String get horoSpanToday => 'आज';

  @override
  String get horoSpanTomorrow => 'आने वाला कल';

  @override
  String get horoSpanWeek => 'इस सप्ताह';

  @override
  String get horoSpanMonth => 'इस महीने';

  @override
  String get horoAreaLove => 'प्रेम';

  @override
  String get horoAreaCareer => 'करियर';

  @override
  String get horoAreaMoney => 'धन';

  @override
  String get horoAreaHealth => 'स्वास्थ्य';

  @override
  String get horoOverall => 'कुल मिलाकर';

  @override
  String get horoOutOfFive => '5 में से';

  @override
  String get horoToneSupportive => 'अनुकूल';

  @override
  String get horoToneBalanced => 'संतुलित';

  @override
  String get horoToneChallenging => 'सावधानी रखें';

  @override
  String get horoLuckyColour => 'शुभ रंग';

  @override
  String get horoLuckyNumber => 'शुभ अंक';

  @override
  String get horoLuckyPlanet => 'सबसे बलवान ग्रह';

  @override
  String get horoBestDays => 'आपके शुभ दिन';

  @override
  String get horoTipTitle => 'उपाय और सुझाव';

  @override
  String horoTipFor(String planet) {
    return '$planet के लिए उपाय';
  }

  @override
  String get horoWhyTitle => 'ग्रह ऐसा क्यों कहते हैं';

  @override
  String get horoWhyBody =>
      'वैदिक राशिफल आपकी चंद्र राशि से गिनकर ग्रहों के गोचर से पढ़ा जाता है। तीर बताते हैं कि कोई स्थिति आपके अनुकूल है या सावधानी माँगती है।';

  @override
  String horoMoonLine(String sign, String nakshatra, String house) {
    return 'चंद्र $sign में · $nakshatra · भाव $house';
  }

  @override
  String horoHouseN(String n) {
    return 'भाव $n';
  }

  @override
  String horoAboutSign(String sign) {
    return '$sign राशि के बारे में';
  }

  @override
  String get horoElement => 'तत्व';

  @override
  String get horoRuler => 'स्वामी ग्रह';

  @override
  String get horoQuality => 'स्वभाव';

  @override
  String get horoElementFire => 'अग्नि';

  @override
  String get horoElementEarth => 'पृथ्वी';

  @override
  String get horoElementAir => 'वायु';

  @override
  String get horoElementWater => 'जल';

  @override
  String get horoQualityMovable => 'चर';

  @override
  String get horoQualityFixed => 'स्थिर';

  @override
  String get horoQualityDual => 'द्विस्वभाव';

  @override
  String get horoChangeSign => 'राशि बदलें';

  @override
  String get horoChooseSign => 'अपनी राशि चुनें';

  @override
  String get horoWhichSignTitle => 'मुझे कौन-सी राशि चुननी चाहिए?';

  @override
  String get horoWhichSignBody =>
      'वैदिक राशिफल आपकी चंद्र राशि से पढ़ा जाता है — जन्म के समय चंद्रमा जिस राशि में था। यह अक्सर पश्चिमी सूर्य राशि से अलग होती है। आपकी कुंडली में चंद्र राशि दिखती है; सबसे सटीक राशिफल के लिए वही चुनें।';

  @override
  String get horoOpenKundali => 'कुंडली में मेरी चंद्र राशि देखें';

  @override
  String get horoCtaTitle => 'सिर्फ़ आपके लिए भविष्यफल चाहिए?';

  @override
  String horoCtaBody(String sign) {
    return 'यह भविष्यफल $sign राशि वाले सभी लोगों के लिए है। ज्योतिषी आपकी व्यक्तिगत कुंडली देख सकते हैं।';
  }

  @override
  String get horoCtaButton => 'ज्योतिषी से बात करें';

  @override
  String get horoShare => 'शेयर करें';

  @override
  String get horoEditorialBadge => 'हमारे ज्योतिषियों द्वारा लिखा गया';

  @override
  String get horoError => 'राशिफल लोड नहीं हो सका';

  @override
  String get horoSourceNote =>
      'आपकी चंद्र राशि से वर्तमान ग्रह-गोचर पर आधारित। यह मार्गदर्शन है, निश्चितता नहीं।';

  @override
  String get matchTitle => 'कुंडली मिलान';

  @override
  String get matchHeroTitle => 'दो कुंडलियाँ मिलाएँ';

  @override
  String get matchHeroBody =>
      'गुण मिलान, मांगलिक और दोष जाँच — कुछ ही पलों में।';

  @override
  String get matchBoy => 'वर';

  @override
  String get matchGirl => 'वधू';

  @override
  String get matchSwap => 'अदला-बदली';

  @override
  String get matchChoosePerson => 'व्यक्ति चुनें';

  @override
  String get matchTapToSelect => 'चुनने के लिए टैप करें';

  @override
  String get matchRunCta => 'मिलान देखें';

  @override
  String get matchPickBothHint => 'मिलान अंक देखने के लिए दोनों व्यक्ति चुनें।';

  @override
  String get matchPickBoyTitle => 'वर का जन्म विवरण चुनें';

  @override
  String get matchPickGirlTitle => 'वधू का जन्म विवरण चुनें';

  @override
  String get matchAddPerson => 'नया व्यक्ति जोड़ें';

  @override
  String get matchAddPersonHint => 'जन्म तिथि, समय और स्थान';

  @override
  String get matchNoProfiles =>
      'अभी कोई जन्म विवरण सहेजा नहीं गया। शुरू करने के लिए व्यक्ति जोड़ें।';

  @override
  String get matchHowTitle => 'यह कैसे काम करता है';

  @override
  String get matchStep1Title => 'दो व्यक्ति चुनें';

  @override
  String get matchStep1Body =>
      'सहेजे गए विवरण चुनें या नए जोड़ें — समय और स्थान से सटीकता बढ़ती है।';

  @override
  String get matchStep2Title => 'दोनों की चंद्र कुंडली मिलाई जाती है';

  @override
  String get matchStep2Body =>
      'स्वभाव से स्वास्थ्य तक, आठ कूटों को पारंपरिक अष्टकूट पद्धति से अंक दिए जाते हैं।';

  @override
  String get matchStep3Title => 'अंक और दोष जाँच पाएँ';

  @override
  String get matchStep3Body =>
      '36 में से अंक, मांगलिक मिलान और हर भाग का अर्थ।';

  @override
  String get matchHistoryTitle => 'आपके मिलान';

  @override
  String get matchHistoryEmpty =>
      'आपके मिलान यहाँ दिखेंगे ताकि आप कभी भी दोबारा देख सकें।';

  @override
  String get matchRetry => 'फिर कोशिश करें';

  @override
  String matchPairNames(String boy, String girl) {
    return '$boy और $girl';
  }

  @override
  String get matchResultTitle => 'मिलान परिणाम';

  @override
  String get matchOutOf36 => '36 में से';

  @override
  String matchShareScore(String score, String verdict) {
    return 'गुण मिलान: $score/36 · $verdict';
  }

  @override
  String get matchVerdictExcellent => 'उत्तम मिलान';

  @override
  String get matchVerdictGood => 'अच्छा मिलान';

  @override
  String get matchVerdictAverage => 'सामान्य मिलान';

  @override
  String get matchVerdictLow => 'विस्तृत जाँच ज़रूरी';

  @override
  String get matchVerdictExcellentBody =>
      'अधिकांश कूट मेल खाते हैं — परंपरागत रूप से सुखद और सहयोगी विवाह का संकेत।';

  @override
  String get matchVerdictGoodBody =>
      '18 या अधिक गुण विवाह के लिए उपयुक्त माने जाते हैं। नीचे कम अंक वाले कूट देखें।';

  @override
  String get matchVerdictAverageBody =>
      '18 से कम गुण होने पर ज्योतिषी निर्णय से पहले पूरी कुंडली देखने की सलाह देते हैं।';

  @override
  String get matchVerdictLowBody =>
      'सिर्फ़ इस अंक पर निर्णय न लें — पूरी कुंडली देखने से अक्सर तस्वीर बदल जाती है।';

  @override
  String get matchManglikShort => 'मांगलिक';

  @override
  String get matchManglikTitle => 'मांगलिक (मंगल दोष) जाँच';

  @override
  String get matchManglikNone =>
      'आप दोनों में से कोई मांगलिक नहीं है — मंगल दोष की चिंता नहीं।';

  @override
  String get matchManglikBoth =>
      'आप दोनों मांगलिक हैं — परंपरा के अनुसार दोष निरस्त हो जाता है।';

  @override
  String get matchManglikCancelled =>
      'मंगल दोष है, पर कुंडली की अन्य स्थितियों से निरस्त हो जाता है।';

  @override
  String get matchManglikMismatch =>
      'आप में से केवल एक मांगलिक है। उपाय और पूरी कुंडली के लिए ज्योतिषी से बात करें।';

  @override
  String get matchIsManglik => 'मांगलिक';

  @override
  String get matchNotManglik => 'मांगलिक नहीं';

  @override
  String get matchManglikCancelledShort => 'मांगलिक (निरस्त)';

  @override
  String matchCheckClear(String name) {
    return '$name: नहीं है';
  }

  @override
  String matchCheckPresent(String name) {
    return '$name: है';
  }

  @override
  String get matchDoshaNadi => 'नाड़ी दोष';

  @override
  String get matchDoshaBhakoot => 'भकूट दोष';

  @override
  String get matchDoshaGana => 'गण दोष';

  @override
  String get matchDoshaTag => 'दोष';

  @override
  String get matchBreakdownTitle => 'गुण विवरण';

  @override
  String get matchBreakdownSub => 'किसी भी कूट का अर्थ जानने के लिए टैप करें।';

  @override
  String get matchKootaVarna => 'वर्ण';

  @override
  String get matchKootaVashya => 'वश्य';

  @override
  String get matchKootaTara => 'तारा';

  @override
  String get matchKootaYoni => 'योनि';

  @override
  String get matchKootaMaitri => 'ग्रह मैत्री';

  @override
  String get matchKootaGana => 'गण';

  @override
  String get matchKootaBhakoot => 'भकूट';

  @override
  String get matchKootaNadi => 'नाड़ी';

  @override
  String get matchKootaVarnaMeaning => 'मूल्य और अहं';

  @override
  String get matchKootaVashyaMeaning => 'आपसी आकर्षण';

  @override
  String get matchKootaTaraMeaning => 'भाग्य और कुशलता';

  @override
  String get matchKootaYoniMeaning => 'शारीरिक अनुकूलता';

  @override
  String get matchKootaMaitriMeaning => 'मानसिक मेल';

  @override
  String get matchKootaGanaMeaning => 'स्वभाव';

  @override
  String get matchKootaBhakootMeaning => 'प्रेम, परिवार और धन';

  @override
  String get matchKootaNadiMeaning => 'स्वास्थ्य और संतान';

  @override
  String get matchKootaVarnaDetail =>
      'दोनों चंद्र राशियों के आध्यात्मिक स्वभाव की तुलना — आपके मूल्य और कर्तव्य-बोध कितने सहज रूप से मेल खाते हैं। 1 अंक।';

  @override
  String get matchKootaVashyaDetail =>
      'साथियों के बीच स्वाभाविक खिंचाव और प्रभाव — कौन नेतृत्व करता है, कौन ढलता है और सहमति कितनी आसानी से बनती है। 2 अंक।';

  @override
  String get matchKootaTaraDetail =>
      'आपके नक्षत्रों के बीच की दूरी से रिश्ते के भाग्य, स्वास्थ्य और स्थायित्व का आकलन। 3 अंक।';

  @override
  String get matchKootaYoniDetail =>
      'हर नक्षत्र का एक पशु स्वभाव होता है; यह कूट अंतरंगता और शारीरिक अनुकूलता के लिए उनकी तुलना करता है। 4 अंक।';

  @override
  String get matchKootaMaitriDetail =>
      'दोनों चंद्र राशियों के स्वामियों की तुलना — उनकी मित्रता का अर्थ है आप एक जैसा सोचते हैं और मतभेद आसानी से सुलझाते हैं। 5 अंक।';

  @override
  String get matchKootaGanaDetail =>
      'नक्षत्रों को देव, मनुष्य और राक्षस गण में बाँटता है। बेमेल होने पर बार-बार टकराव हो सकता है। 6 अंक।';

  @override
  String get matchKootaBhakootDetail =>
      'दोनों चंद्र राशियों की दूरी देखता है, जो परंपरा से प्रेम, परिवार की वृद्धि और साझा धन को प्रभावित करती है। 7 अंक।';

  @override
  String get matchKootaNadiDetail =>
      'सबसे अधिक महत्व वाला कूट। एक ही नाड़ी (0 अंक) परंपरा से स्वास्थ्य और संतान संबंधी चिंता से जुड़ी है, और इसके प्रसिद्ध अपवाद भी हैं। 8 अंक।';

  @override
  String get matchChartsTitle => 'जन्म कुंडली विवरण';

  @override
  String get matchRowRasi => 'चंद्र राशि';

  @override
  String get matchRowNakshatra => 'नक्षत्र';

  @override
  String get matchRowGana => 'गण';

  @override
  String get matchRowYoni => 'योनि';

  @override
  String get matchAskTitle => 'ज्योतिषी से विस्तार से बात करें';

  @override
  String get matchAskBody =>
      'दोषों के अक्सर परिहार और उपाय होते हैं। दोनों कुंडलियों का पूरा विश्लेषण पाएँ।';

  @override
  String get matchDisclaimer =>
      'गुण मिलान एक पारंपरिक मार्गदर्शक है, गारंटी नहीं। पूरी कुंडली और अपने विवेक पर भी विचार करें।';

  @override
  String get matchRelSelf => 'स्वयं';

  @override
  String get matchRelPartner => 'साथी';

  @override
  String get matchRelChild => 'संतान';

  @override
  String get matchRelParent => 'माता-पिता';

  @override
  String get matchRelSibling => 'भाई-बहन';

  @override
  String get matchRelFriend => 'मित्र';

  @override
  String get kAdvTitle => 'उन्नत रिपोर्ट';

  @override
  String get kAdvIntro =>
      'गहराई और समय निर्धारण के लिए ज्योतिषी जिन तकनीकी परतों का उपयोग करते हैं। रुचि के लिए देखें, या परामर्श के दौरान खोलें।';

  @override
  String get kAdvAshtakavarga => 'अष्टकवर्ग';

  @override
  String get kAdvAshtakavargaSub =>
      'हर राशि की अंक-शक्ति। अधिक अंक = वहाँ के गोचर को आकाश का समर्थन।';

  @override
  String get kAdvShadbala => 'षड्बल';

  @override
  String get kAdvShadbalaSub =>
      'हर ग्रह का छह प्रकार का बल, उसकी आवश्यकता की तुलना में।';

  @override
  String get kAdvKp => 'केपी पद्धति';

  @override
  String get kAdvKpSub =>
      'कृष्णमूर्ति पद्धति — समय निर्धारण के लिए भाव-संधि उप-स्वामी और शासक ग्रह।';

  @override
  String get kAdvJaimini => 'जैमिनी';

  @override
  String get kAdvJaiminiSub =>
      'चर कारक, आरूढ़ लग्न और कुंडली पढ़ने की जैमिनी पद्धति।';

  @override
  String get kAdvDownloadPdf => 'पूरी PDF रिपोर्ट डाउनलोड करें';

  @override
  String get kAdvFooter =>
      'ये तकनीकी हैं। सरल शब्दों में फल के लिए ज्योतिषी से बात करें।';

  @override
  String get kAdvReport => 'रिपोर्ट';

  @override
  String get kAdvLoadError => 'यह रिपोर्ट लोड नहीं हो सकी।';

  @override
  String get kAdvKpIntro =>
      'केपी राशिचक्र को 249 उप-भागों में बाँटता है। किसी भाव-संधि का उप-स्वामी तय करता है कि जीवन का वह क्षेत्र फल देगा या नहीं; शासक ग्रहों का उपयोग तत्काल समय निर्धारण के लिए होता है।';

  @override
  String get kAdvJaiminiIntro =>
      'जैमिनी कुंडली को चर कारकों (अंश के क्रम में ग्रह, हर एक जीवन के किसी क्षेत्र का सूचक) और आरूढ़ पदों — दुनिया को चीज़ें कैसी दिखती हैं — के माध्यम से पढ़ता है।';

  @override
  String get kAdvAvIntro =>
      'सर्वाष्टकवर्ग हर भाव में सभी ग्रहों का योगदान जोड़ता है — कुल योग हमेशा 337 होता है। 28+ अंक वाला भाव वहाँ से गुज़रने वाले ग्रहों का समर्थन करता है; 25 से कम कमज़ोर स्थान है।';

  @override
  String kAdvHouseN(Object n) {
    return 'भाव $n';
  }

  @override
  String get kAdvBhinnaTotals => 'ग्रहवार योग (भिन्नाष्टकवर्ग)';

  @override
  String get kAdvShadbalaIntro =>
      'षड्बल हर ग्रह की शक्ति को रूपों में, उसकी न्यूनतम आवश्यकता की तुलना में मापता है। 1.0 से अधिक अनुपात का अर्थ है कि ग्रह भरोसे से अपना फल दे सकता है।';

  @override
  String kAdvStrongest(Object planet) {
    return 'सबसे बली: $planet';
  }

  @override
  String kAdvWeakest(Object planet) {
    return 'सबसे निर्बल: $planet';
  }

  @override
  String get kAdvReadWithAstrologer =>
      'यह रिपोर्ट ज्योतिषी के साथ पढ़ने के लिए है।';

  @override
  String get kAdvSecCuspalSublords => 'भाव-संधि उप-स्वामी';

  @override
  String get kAdvSecRulingPlanets => 'शासक ग्रह';

  @override
  String get kAdvSecHouseSignificators => 'भाव कारक ग्रह';

  @override
  String get kAdvSecCharaKarakas => 'चर कारक';

  @override
  String get kAdvSecArudhaPadas => 'आरूढ़ पद';

  @override
  String get kAdvSecKarakamsa => 'कारकांश';

  @override
  String get kAdvSecCharaDasha => 'चर दशा';

  @override
  String get kBhavaTitle => 'भाव';

  @override
  String get kBhavaIntro =>
      'सभी 12 भाव, उनके स्वाभाविक कारकत्व, और उनके स्वामी व स्थित ग्रह उन्हें कैसे आकार देते हैं।';

  @override
  String get kBhavaMoreBenefic => 'अशुभ से अधिक शुभ प्रभाव';

  @override
  String get kBhavaMoreMalefic => 'शुभ से अधिक अशुभ प्रभाव';

  @override
  String kBhavaOccupiedBy(Object planets) {
    return 'स्थित ग्रह: $planets';
  }

  @override
  String kBhavaAspectedBy(Object planets) {
    return 'दृष्टि: $planets';
  }

  @override
  String kBhavaBeneficCount(Object count) {
    return '$count शुभ';
  }

  @override
  String kBhavaMaleficCount(Object count) {
    return '$count अशुभ';
  }

  @override
  String get kBhavaNeedsTime => 'भाव विश्लेषण के लिए जन्म समय आवश्यक है';

  @override
  String get kBhavaNeedsTimeBody =>
      'हर भाव का स्वरूप देखने के लिए इस प्रोफ़ाइल में जन्म का सटीक समय जोड़ें।';

  @override
  String get kDashaIntroVimshottari =>
      'विंशोत्तरी ग्रहों की दशाओं का 120 वर्ष का चक्र है, जो जन्म के समय चंद्रमा की स्थिति से गिना जाता है।';

  @override
  String get kDashaIntroYogini =>
      'योगिनी आठ योगिनियों का 36 वर्ष का चक्र है, जो चंद्रमा के नक्षत्र से गिना जाता है।';

  @override
  String get kDashaIntroAshtottari =>
      'अष्टोत्तरी 108 वर्ष का चक्र है, जो आर्द्रा से गिना जाता है।';

  @override
  String kDashaBalance(Object lord, Object years) {
    return 'जन्म के समय $lord दशा का शेष: $years वर्ष';
  }

  @override
  String get kDashaVimshottari => 'विंशोत्तरी';

  @override
  String get kDashaYogini => 'योगिनी';

  @override
  String get kDashaAshtottari => 'अष्टोत्तरी';

  @override
  String get kDashaNowRunning => 'अभी चल रही दशा';

  @override
  String get kDashaNow => 'अभी';

  @override
  String kDashaYears(Object count) {
    return '$count वर्ष';
  }

  @override
  String get kPlanetsIntro =>
      'हर ग्रह कहाँ बैठा है, कितना बली है, और क्या फल देता है। अधिक पढ़ने के लिए टैप करें। स्थितियाँ निरयण (लाहिड़ी) हैं।';

  @override
  String get kTrTitle => 'गोचर';

  @override
  String get kTrSadeSatiCalendar =>
      'पूरा साढ़े साती कैलेंडर देखें (तारीखों के साथ)';

  @override
  String get kTrSkyNow => 'अभी का आकाश — आपकी कुंडली के सापेक्ष';

  @override
  String get kTrSadeSati => 'साढ़े साती';

  @override
  String kTrPhaseOf(Object n) {
    return 'चरण $n / 3';
  }

  @override
  String get kTrPhaseHintRising => 'शनि 12वें में';

  @override
  String get kTrPhaseHintPeak => 'चंद्रमा के ऊपर';

  @override
  String get kTrPhaseHintSetting => 'शनि दूसरे में';

  @override
  String get kTrHowToWork => 'इसके साथ कैसे चलें';

  @override
  String get kTrTip1 =>
      'जो काम नहीं कर रहा उसे छोड़ें — शनि इस ईमानदारी का फल देता है';

  @override
  String get kTrTip2 => 'दिनचर्या बनाएँ और जो शुरू करें उसे पूरा करें';

  @override
  String get kTrTip3 =>
      'नींद, घुटनों, दाँतों और बुज़ुर्ग रिश्तेदारों का ध्यान रखें';

  @override
  String get kTrTip4 =>
      'यह पुनर्निर्माण है, दंड नहीं। परिणाम इसके समाप्त होने के बाद दिखते हैं।';

  @override
  String get kTrPanotiBody =>
      'शनि का छोटा (लगभग ढाई वर्ष) चरण। स्वास्थ्य, रोज़ के प्रयास और बाधाओं में घर्षण की अपेक्षा करें — धैर्य और दिनचर्या से इसका सामना करें।';

  @override
  String kTrPlanetInSign(Object planet, Object sign) {
    return '$sign में $planet';
  }

  @override
  String get kTrJupiterGood =>
      'गुरु का गोचर अनुकूल है — अभी विकास, शिक्षा, धन और परिवार के लिए सहायक।';

  @override
  String get kTrJupiterNeutral => 'गुरु का गोचर अभी आपके लिए सामान्य है।';

  @override
  String get kTrCloseContacts => 'अभी के निकट संपर्क';

  @override
  String kTrCloseContactLine(Object natal, Object planet) {
    return 'गोचर का $planet आपके जन्म के $natal से 3° के भीतर है — जीवन का वह क्षेत्र इस सप्ताह सक्रिय है।';
  }

  @override
  String kMuChoghadiya(String key, Object raw) {
    String _temp0 = intl.Intl.selectLogic(key, {
      'udveg': 'उद्वेग',
      'char': 'चर',
      'labh': 'लाभ',
      'amrit': 'अमृत',
      'kaal': 'काल',
      'shubh': 'शुभ',
      'rog': 'रोग',
      'abhijit': 'अभिजित',
      'other': '$raw',
    });
    return '$_temp0';
  }

  @override
  String kUpOr(Object name) {
    return 'या $name';
  }

  @override
  String kUpFinger(Object finger) {
    return '$finger उँगली';
  }

  @override
  String get kYdPartial => 'आंशिक';

  @override
  String get moodTitle => 'आज का मन';

  @override
  String get moodMeter => 'मन का मीटर';

  @override
  String get moodWhyTitle => 'आज ऐसा क्यों लग रहा है';

  @override
  String get moodTipTitle => 'आज के लिए एक छोटा सुझाव';

  @override
  String get moodLockedTitle => 'आपके ज्योतिषी आपको बताएंगे';

  @override
  String get moodLockedSub =>
      'पूरी तस्वीर के लिए सिर्फ़ चंद्रमा नहीं, आपकी पूरी कुंडली देखनी होती है।';

  @override
  String get moodTalkCta => 'अभी ज्योतिषी से बात करें';

  @override
  String moodNextChange(Object when) {
    return 'आपका मन अगली बार $when को बदलेगा';
  }

  @override
  String get kOvExMood => 'आज का मन';

  @override
  String get kOvExMoodSub => 'आज चंद्रमा आपके मन पर कैसा असर डाल रहा है';

  @override
  String get prefsMoodAlerts => 'दैनिक मन सूचनाएँ';

  @override
  String get prefsMoodAlertsDesc =>
      'हफ़्ते में लगभग तीन सुबह, जब आपकी कुंडली में चंद्रमा राशि बदलता है।';

  @override
  String get callCalling => 'कॉल की जा रही है…';

  @override
  String get callRinging => 'घंटी बज रही है…';

  @override
  String get callConnecting => 'कनेक्ट हो रहा है…';

  @override
  String get callReconnecting => 'फिर से कनेक्ट हो रहा है…';

  @override
  String get callEnded => 'कॉल समाप्त';

  @override
  String get callPoorConnection => 'कमज़ोर नेटवर्क';

  @override
  String get callMute => 'म्यूट';

  @override
  String get callSpeaker => 'स्पीकर';

  @override
  String get callEnd => 'समाप्त';

  @override
  String get callEncrypted => 'एन्क्रिप्टेड कॉल';

  @override
  String get callMicTitle => 'माइक्रोफ़ोन की अनुमति चाहिए';

  @override
  String get callMicBody =>
      'माइक्रोफ़ोन की अनुमति दें ताकि ज्योतिषी आपको सुन सकें।';

  @override
  String get callMicBlockedBody =>
      'TalkAcharya के लिए माइक्रोफ़ोन बंद है। सेटिंग्स में इसे चालू करें।';

  @override
  String get callOpenSettings => 'सेटिंग्स खोलें';

  @override
  String get callTryAgain => 'फिर कोशिश करें';

  @override
  String get callFailedTitle => 'कॉल शुरू नहीं हो सकी';

  @override
  String get callEndConfirmTitle => 'क्या कॉल समाप्त करें?';

  @override
  String get callEndConfirmBody => 'कॉल समाप्त होते ही शुल्क रुक जाएगा।';

  @override
  String get callEndConfirmYes => 'कॉल समाप्त करें';

  @override
  String get callEndConfirmNo => 'बात जारी रखें';

  @override
  String callWaitingAccept(String name) {
    return '$name के स्वीकार करने की प्रतीक्षा…';
  }

  @override
  String callBookTitle(String name) {
    return '$name को कॉल करें';
  }

  @override
  String get callBookBilling =>
      'वॉइस कॉल · कनेक्ट होने के बाद प्रति मिनट शुल्क';

  @override
  String callBookCta(String price) {
    return 'कॉल शुरू करें · $price/मिनट';
  }

  @override
  String get callUnavailable => 'यह ज्योतिषी अभी कॉल नहीं ले रहे हैं।';

  @override
  String get giftAction => 'उपहार भेजें';

  @override
  String giftSheetTitle(String name) {
    return '$name को उपहार भेजें';
  }

  @override
  String get giftSheetSubtitle =>
      'आभार का एक छोटा-सा प्रतीक — उन्हें तुरंत दिखेगा।';

  @override
  String get giftQuantity => 'संख्या';

  @override
  String get giftAddNote => 'संदेश जोड़ें';

  @override
  String get giftNoteHint => 'छोटा-सा संदेश लिखें (वैकल्पिक)';

  @override
  String get giftChoose => 'उपहार चुनें';

  @override
  String giftSendCta(String gift, String price) {
    return '$gift भेजें · $price';
  }

  @override
  String giftWalletBalance(String amount) {
    return 'बैलेंस $amount';
  }

  @override
  String get giftAddMoney => 'पैसे जोड़ें';

  @override
  String get giftLowBalanceTitle => 'बैलेंस पर्याप्त नहीं है';

  @override
  String get giftLowBalanceBody =>
      'यह उपहार भेजने के लिए वॉलेट में पैसे जोड़ें।';

  @override
  String giftSentTitle(String gift, String name) {
    return '$gift $name को भेजा गया';
  }

  @override
  String get giftSentBody =>
      'उन्हें यह तुरंत दिखेगा। आपकी सद्भावना के लिए धन्यवाद!';

  @override
  String get giftSendAnother => 'एक और भेजें';

  @override
  String get giftLoadError => 'उपहार लोड नहीं हो सके';

  @override
  String get giftThankYouTitle => 'उपहार देकर धन्यवाद कहें';

  @override
  String giftThankYouBody(String name) {
    return 'सत्र अच्छा लगा? $name को आभार का एक छोटा-सा प्रतीक भेजें।';
  }

  @override
  String get giftThankYouSentTitle => 'आपके उपहार के लिए धन्यवाद';

  @override
  String get helpTitle => 'सहायता और समर्थन';

  @override
  String get helpHeroTitle => 'हम आपकी क्या मदद करें?';

  @override
  String get helpHeroBody =>
      'किसी सत्र की समस्या बताएँ, अपनी शिकायतों की स्थिति देखें या हमारी टीम से संपर्क करें।';

  @override
  String get helpReportSection => 'सत्र की समस्या बताएँ';

  @override
  String get helpReportEmpty => 'आपके पूरे हुए सत्र यहाँ दिखेंगे।';

  @override
  String get helpReportAction => 'बताएँ';

  @override
  String get helpYourReports => 'आपकी शिकायतें';

  @override
  String get helpContactSection => 'हमसे संपर्क करें';

  @override
  String get helpWhatsapp => 'WhatsApp पर बात करें';

  @override
  String get helpEmailUs => 'हमें ईमेल करें';

  @override
  String get helpCentre => 'सहायता केंद्र';

  @override
  String get helpFaqSection => 'अक्सर पूछे जाने वाले सवाल';

  @override
  String get helpLoadError => 'आपके सत्र लोड नहीं हो सके।';

  @override
  String get helpFaqChargesQ => 'परामर्श का शुल्क कैसे लगता है?';

  @override
  String get helpFaqChargesA =>
      'आप प्रति मिनट भुगतान करते हैं, केवल तब तक जब तक सत्र चल रहा हो। ज्योतिषी के जुड़ते ही बिलिंग शुरू होती है और किसी के भी सत्र समाप्त करते ही रुक जाती है।';

  @override
  String get helpFaqNoResponseQ => 'अगर ज्योतिषी जवाब न दें तो?';

  @override
  String get helpFaqNoResponseA =>
      'अगर आपका अनुरोध स्वीकार नहीं होता, तो कोई शुल्क नहीं लगता — सत्र के लिए रोकी गई राशि आपके वॉलेट में लौट जाती है।';

  @override
  String get helpFaqRefundQ => 'क्या मुझे रिफ़ंड मिल सकता है?';

  @override
  String get helpFaqRefundA =>
      'अगर कुछ गलत हुआ — गलत शुल्क, तकनीकी समस्या या सत्र से मदद न मिलना — तो उसी सत्र से शिकायत करें। हमारी टीम हर शिकायत की जाँच करती है और उचित होने पर आपके वॉलेट में रिफ़ंड करती है।';

  @override
  String get helpFaqBalanceQ =>
      'सत्र के दौरान मेरा बैलेंस खत्म हो गया। अब क्या करें?';

  @override
  String get helpFaqBalanceA =>
      'बैलेंस खत्म होने पर सत्र अपने-आप समाप्त हो जाता है। वॉलेट रिचार्ज करें और सत्र सारांश से उन्हीं ज्योतिषी के साथ फिर शुरू करें।';

  @override
  String get helpFaqPrivacyQ => 'क्या मेरी बातचीत निजी रहती है?';

  @override
  String get helpFaqPrivacyA =>
      'आपका परामर्श आपके और आपके ज्योतिषी के बीच रहता है। हमारी सहायता टीम किसी सत्र को केवल शिकायत सुलझाने या प्लेटफ़ॉर्म को सुरक्षित रखने के लिए देखती है।';

  @override
  String get helpFaqLanguageQ => 'ऐप की भाषा कैसे बदलें?';

  @override
  String get helpFaqLanguageA =>
      'प्रोफ़ाइल → भाषा में जाएँ और अपनी पसंद की भाषा चुनें।';

  @override
  String get reportTitle => 'समस्या बताएँ';

  @override
  String reportSessionWith(String name) {
    return '$name के साथ सत्र';
  }

  @override
  String get reportWhatHappened => 'क्या गलत हुआ?';

  @override
  String get reportTypeBilling => 'गलत शुल्क';

  @override
  String get reportTypeBillingHint => 'मुझसे ज़्यादा शुल्क लिया गया';

  @override
  String get reportTypeQuality => 'सत्र से मदद नहीं मिली';

  @override
  String get reportTypeQualityHint =>
      'जैसा बताया गया था, वैसा मार्गदर्शन नहीं मिला';

  @override
  String get reportTypeConduct => 'अनुचित व्यवहार';

  @override
  String get reportTypeConductHint =>
      'ज्योतिषी का व्यवहार रूखा या अव्यावसायिक था';

  @override
  String get reportTypeNoShow => 'ज्योतिषी ने जवाब नहीं दिया';

  @override
  String get reportTypeNoShowHint => 'स्वीकार किया, पर असल में जुड़े ही नहीं';

  @override
  String get reportTypeTechnical => 'तकनीकी समस्या';

  @override
  String get reportTypeTechnicalHint => 'चैट या कॉल बार-बार रुकती रही';

  @override
  String get reportDescribe => 'हमें विस्तार से बताएँ';

  @override
  String get reportDescribeHint =>
      'बताएँ क्या हुआ — जितनी ज़्यादा जानकारी, उतनी जल्दी मदद।';

  @override
  String reportMinChars(String count) {
    return 'कम से कम $count अक्षर';
  }

  @override
  String get reportPrivacyNote =>
      'आपकी शिकायत की जाँच के लिए हमारी सहायता टीम इस सत्र को देखेगी।';

  @override
  String get reportSubmit => 'शिकायत भेजें';

  @override
  String get reportSubmittedTitle => 'शिकायत भेज दी गई';

  @override
  String get reportSubmittedBody =>
      'हम इसकी जाँच करेंगे और कोई भी अपडेट होते ही आपको सूचित करेंगे।';

  @override
  String get reportAlreadyTitle => 'आप इस सत्र की शिकायत पहले ही कर चुके हैं';

  @override
  String get reportAlreadyBody =>
      'हमारी टीम इसकी जाँच कर रही है। अपडेट होते ही आपको सूचित किया जाएगा।';

  @override
  String get reportViewStatus => 'शिकायत की स्थिति देखें';

  @override
  String get disputeTitle => 'शिकायत का विवरण';

  @override
  String get disputeStatusOpen => 'प्राप्त';

  @override
  String get disputeStatusInvestigating => 'जाँच जारी';

  @override
  String get disputeStatusResolved => 'सुलझाई गई';

  @override
  String get disputeStatusRejected => 'बंद';

  @override
  String get disputeHeadlineOpen => 'आपकी शिकायत हमें मिल गई है';

  @override
  String get disputeHeadlineInvestigating =>
      'हमारी टीम आपकी शिकायत की जाँच कर रही है';

  @override
  String get disputeHeadlineResolved => 'आपकी शिकायत सुलझा दी गई है';

  @override
  String get disputeHeadlineRejected => 'हमने आपकी शिकायत की जाँच कर ली है';

  @override
  String get disputeOpenBody => 'कोई भी अपडेट होते ही हम आपको सूचित करेंगे।';

  @override
  String disputeReportedOn(String date) {
    return '$date को शिकायत की गई';
  }

  @override
  String disputeRefundedTitle(String amount) {
    return '$amount आपके वॉलेट में लौटाए गए';
  }

  @override
  String get disputeOpenWallet => 'वॉलेट';

  @override
  String get disputeOutcome => 'नतीजा';

  @override
  String get disputeOutcomeNoRefund =>
      'इस सत्र के लिए कोई रिफ़ंड जारी नहीं किया गया।';

  @override
  String get disputeTimeline => 'प्रगति';

  @override
  String get disputeStepRaised => 'शिकायत भेजी गई';

  @override
  String get disputeStepReviewing => 'जाँच जारी';

  @override
  String get disputeStepResolved => 'सुलझाई गई';

  @override
  String get disputeStepRejected => 'बंद';

  @override
  String get disputeYourReport => 'आपकी शिकायत';

  @override
  String get roomReportProblem => 'समस्या बताएँ';

  @override
  String get articlesTitle => 'पढ़ें और जानें';

  @override
  String get articlesRailSubtitle => 'मार्गदर्शन, उपाय और त्योहार';

  @override
  String get articlesAll => 'सभी';

  @override
  String get articlesEmptyTitle => 'यहाँ अभी पढ़ने को कुछ नहीं है';

  @override
  String get articlesEmptyBody =>
      'नए लेख जल्द आ रहे हैं — थोड़ी देर बाद फिर देखें।';

  @override
  String get articleCatAstrology => 'ज्योतिष';

  @override
  String get articleCatHoroscope => 'राशिफल';

  @override
  String get articleCatFestivals => 'त्योहार';

  @override
  String get articleCatRemedies => 'उपाय';

  @override
  String get articleCatGuides => 'मार्गदर्शिका';

  @override
  String get articleCatNews => 'समाचार';

  @override
  String articleMinRead(int minutes) {
    return '$minutes मिनट का पाठ';
  }

  @override
  String get articleShare => 'साझा करें';

  @override
  String get articleMoreToRead => 'और पढ़ें';

  @override
  String get articleAskTitle => 'अपनी कुंडली के लिए मार्गदर्शन चाहिए?';

  @override
  String get articleAskBody =>
      'कुछ ही मिनटों में सत्यापित ज्योतिषी से बात करें।';

  @override
  String get articleAskCta => 'अभी पूछें';

  @override
  String get panchangTitle => 'पंचांग';

  @override
  String get panchangToday => 'आज';

  @override
  String get panchangPickDate => 'तारीख चुनें';

  @override
  String panchangMoonIn(String sign) {
    return 'चंद्र $sign में';
  }

  @override
  String panchangTill(String time) {
    return '$time तक';
  }

  @override
  String get panchangRightNow => 'अभी';

  @override
  String panchangNowChoghadiya(String name, String time) {
    return '$name चौघड़िया $time तक';
  }

  @override
  String panchangRahuNow(String time) {
    return 'राहु काल $time तक है — नए काम की शुरुआत टालें।';
  }

  @override
  String get panchangLimbs => 'आज का पंचांग';

  @override
  String get panchangAuspicious => 'शुभ मुहूर्त';

  @override
  String get panchangInauspicious => 'नए काम शुरू करने से बचें';

  @override
  String get panchangBrahma => 'ब्रह्म मुहूर्त';

  @override
  String get panchangAbhijit => 'अभिजित मुहूर्त';

  @override
  String get panchangNoAbhijit => 'बुधवार को अभिजित मुहूर्त नहीं माना जाता।';

  @override
  String get panchangRahuKaal => 'राहु काल';

  @override
  String get panchangYamaganda => 'यमगंड';

  @override
  String get panchangGulika => 'गुलिक काल';

  @override
  String get panchangChoghadiya => 'चौघड़िया';

  @override
  String get panchangDay => 'दिन';

  @override
  String get panchangNight => 'रात';

  @override
  String get panchangNotes => 'हमारे ज्योतिषियों की टिप्पणी';

  @override
  String get panchangPersonalTitle => 'आपकी कुंडली के अनुसार समय';

  @override
  String get panchangPersonalBody =>
      'आपकी कुंडली से निकाले गए, आपके लिए सबसे अच्छे समय देखें।';

  @override
  String panchangFooter(String place, String timezone) {
    return '$place · $timezone के लिए · स्थानीय सूर्योदय से गणना';
  }

  @override
  String get panchangChoosePlaceTitle => 'अपना शहर चुनें';

  @override
  String get panchangChoosePlaceBody =>
      'पंचांग का समय स्थान पर निर्भर करता है — जिस शहर के लिए चाहिए, उसे चुनें।';

  @override
  String get panchangChoosePlaceCta => 'शहर चुनें';

  @override
  String panchangUsePlace(String place) {
    return '$place चुनें';
  }

  @override
  String get panchangCity => 'शहर';

  @override
  String get panchangCityHint => 'शहर या कस्बा खोजें';

  @override
  String get kPdfTitle => 'कुंडली रिपोर्ट (PDF)';

  @override
  String get kPdfFull => 'पूरी रिपोर्ट';

  @override
  String get kPdfFullSub => 'चार्ट, ग्रह, अवकहड़ा, दशा समय-रेखा, योग और दोष';

  @override
  String get kPdfBasic => 'एक पेज का सारांश';

  @override
  String get kPdfBasicSub => 'लग्न और नवांश चार्ट के साथ ग्रह स्थिति';

  @override
  String get kPdfChartStyle => 'चार्ट शैली';

  @override
  String get kPdfEastIndian => 'पूर्वी भारतीय';

  @override
  String get kPdfShareCta => 'डाउनलोड करें और साझा करें';

  @override
  String get kPdfPreparing => 'आपकी PDF तैयार हो रही है…';

  @override
  String get kPdfNote =>
      'PDF अंग्रेज़ी में है। इसे फ़ोन में सेव करें या WhatsApp पर भेजें।';

  @override
  String get kPdfUnavailable =>
      'PDF रिपोर्ट अभी उपलब्ध नहीं है। कृपया बाद में कोशिश करें।';
}
