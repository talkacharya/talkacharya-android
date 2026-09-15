// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Marathi (`mr`).
class AppLocalizationsMr extends AppLocalizations {
  AppLocalizationsMr([String locale = 'mr']) : super(locale);

  @override
  String get appName => 'TalkAcharya';

  @override
  String get commonOk => 'ठोक आहे';

  @override
  String get commonCancel => 'रद्द करा';

  @override
  String get commonDone => 'झाले';

  @override
  String get commonNext => 'पुढील';

  @override
  String get commonBack => 'मागे';

  @override
  String get commonRetry => 'पुन्हा प्रयत्न करा';

  @override
  String get commonSave => 'साठवा';

  @override
  String get commonEdit => 'संपादन';

  @override
  String get commonDelete => 'हटवा';

  @override
  String get commonClose => 'बंद करा';

  @override
  String get commonContinue => 'सुरू ठेवा';

  @override
  String get commonConfirm => 'निश्चित करा';

  @override
  String get commonSeeAll => 'सर्व पहा';

  @override
  String get commonViewAll => 'सर्व पहा';

  @override
  String get commonShare => 'शेअर करा';

  @override
  String get commonCopy => 'कॉपी करा';

  @override
  String get commonCopied => 'कॉपी झाले';

  @override
  String get commonApply => 'लागू करा';

  @override
  String get commonSearch => 'शोधा';

  @override
  String get commonYes => 'हो';

  @override
  String get commonNo => 'नाही';

  @override
  String get commonLoading => 'लोड होत आहे…';

  @override
  String get commonSomethingWentWrong => 'काहीतरी चूक झाली आहे';

  @override
  String get commonCheckConnection =>
      'तुमचे इंटरनेट कनेक्शन तपासा आणि पुन्हा प्रयत्न करा';

  @override
  String get commonComingSoon => 'लवकरच येत आहे';

  @override
  String get commonToday => 'आज';

  @override
  String get commonYesterday => 'काल';

  @override
  String commonMinutesShort(int count) {
    return '$count मि';
  }

  @override
  String get commonOffline => 'तुम्ही ऑफलाइन आहात';

  @override
  String get navHome => 'होम';

  @override
  String get navAstrologers => 'ज्योतिषी';

  @override
  String get navLive => 'लाईव्ह';

  @override
  String get navWallet => 'वॉलेट';

  @override
  String get navProfile => 'प्रोफाईल';

  @override
  String get authWelcomeTitle => 'विश्वासार्ह ज्योतिषांशी बोला';

  @override
  String get authWelcomeSubtitle =>
      'प्रेम, करिअर, पैसा आणि अधिक विषयांवरील मार्गदर्शनासाठी चॅट किंवा कॉल करा';

  @override
  String get authPhoneTitle => 'तुमचा मोबाईल नंबर टाका';

  @override
  String get authPhoneSubtitle =>
      'तुमचा मोबाईल नंबर टाका आणि आम्ही तुम्हाला एक वन-टाइम कोड पाठवू.';

  @override
  String authOtpSubtitle(String phone) {
    return 'आम्ही $phone वर ६-अंकी कोड पाठवला आहे.';
  }

  @override
  String authTestModeCode(String code) {
    return 'टेस्ट मोड — तुमचा कोड $code आहे';
  }

  @override
  String get authPhoneHint => 'मोबाईल नंबर';

  @override
  String get authPhoneHelper => 'आम्ही SMS द्वारे वन-टाइम कोड पाठवू';

  @override
  String get authGetOtp => 'OTP मिळवा';

  @override
  String get authOtpTitle => '६-अंकी कोड टाका';

  @override
  String authOtpSentTo(String phone) {
    return '$phone वर पाठवला';
  }

  @override
  String get authOtpResend => 'कोड पुन्हा पाठवा';

  @override
  String authOtpResendIn(int seconds) {
    return '$seconds सेकंदात पुन्हा पाठवा';
  }

  @override
  String get authVerify => 'पडताळणी करा';

  @override
  String get authChangeNumber => 'नंबर बदला';

  @override
  String get authInvalidPhone => 'वैध मोबाईल नंबर टाका';

  @override
  String get authInvalidOtp => '६-अंकी कोड टाका';

  @override
  String get authWrongApp => 'हा नंबर ज्योतिषी अॅपसाठी नोंदणीकृत आहे';

  @override
  String authDevCode(String code) {
    return 'देव कोड: $code';
  }

  @override
  String get authTermsNotice =>
      'पुढे चालू ठेवून तुम्ही आमच्या अटी आणि गोपनीयता धोरणाशी सहमत आहात';

  @override
  String get authLogout => 'लॉग आऊट';

  @override
  String get authLogoutConfirm =>
      'TalkAcharya मधून लॉग आऊट करायचे? तुम्हाला पुन्हा साईन इन करावे लागेल.';

  @override
  String homeGreeting(String name) {
    return 'नमस्ते, $name';
  }

  @override
  String get homeGuidanceTagline => 'मार्गदर्शन, जेव्हाही तुम्हाला हवे असेल';

  @override
  String get homeGreetingFallbackName => 'मित्रा';

  @override
  String get walletAddShort => 'जोडा';

  @override
  String get homeChatNow => 'आत्ता चॅट करा';

  @override
  String get homeCallNow => 'आत्ता कॉल करा';

  @override
  String homeFromPerMin(String price) {
    return '$price/मि पासून';
  }

  @override
  String homeOnlineCount(int count) {
    return '$count ऑनलाइन';
  }

  @override
  String get homeOnlineNow => 'आता ऑनलाइन';

  @override
  String get homeTalkToAstrologer => 'ज्योतिषाशी बोला';

  @override
  String get homeLiveNow => 'आत्ता लाईव्ह';

  @override
  String get homeWhatsOnYourMind => 'तुमच्या मनात काय आहे?';

  @override
  String get homeTodaysHoroscope => 'आजचे राशीभविष्य';

  @override
  String get homeChooseYourSign => 'तुमची रास निवडा';

  @override
  String get homeReadMore => 'अधिक वाचा';

  @override
  String get homeShowLess => 'कमी दाखवा';

  @override
  String homeLuckToday(String rating) {
    return 'आजचे नशीब · $rating';
  }

  @override
  String get homeTodaysPanchang => 'आजचे पंचांग';

  @override
  String get homePanchangAddProfile =>
      'तुमच्या ठिकाणानुसार पंचांग मिळवण्यासाठी जन्म तपशील जोडा';

  @override
  String get homeFreeTools => 'मोफत साधने';

  @override
  String get homeTalkAgain => 'पुन्हा बोला';

  @override
  String get homeAddMoneyGetBonus => 'पैसे जोडा, बोनस मिळवा';

  @override
  String get homeReferAFriend => 'मित्राला रेफर करा, दोघेही कमवा';

  @override
  String get homeReferShort =>
      'तुमचा कोड शेअर करा — तुम्हा दोघांना वॉलेट क्रेडिट मिळेल';

  @override
  String homeReferYourCode(String code) {
    return 'तुमचा कोड: $code';
  }

  @override
  String get homeInvite => 'आमंत्रित करा';

  @override
  String homeResumeInProgress(String channel) {
    return '$channel · प्रगतीपथावर';
  }

  @override
  String homeResumePaused(String channel) {
    return '$channel · थांबवले';
  }

  @override
  String get homeResume => 'पुन्हा सुरू करा';

  @override
  String get homeTrustVerified =>
      'प्रत्येक ज्योतिषाची लाईव्ह जाण्यापूर्वी आयडी-व्हेरिफिकेशन केली जाते';

  @override
  String get homeTrustPrivate => '१००% खाजगी आणि गोपनीय सल्लामसलत';

  @override
  String get homeTrustVolume => 'दर आठवड्याला हजारो सल्लामसलत';

  @override
  String get homeCouldntLoadAstrologers => 'ज्योतिषी लोड होऊ शकले नाहीत';

  @override
  String get homeCouldntLoadReading => 'आजचे राशीभविष्य मिळू शकले नाही';

  @override
  String get homeCouldntLoadPanchang => 'पंचांग लोड होऊ शकले नाही';

  @override
  String get homeNoAstrologersFilter =>
      'या फिल्टरशी जुळणारे कोणतेही ज्योतिषी सध्या उपलब्ध नाहीत';

  @override
  String get concernLove => 'प्रेम';

  @override
  String get concernMarriage => 'लग्न';

  @override
  String get concernCareer => 'करिअर';

  @override
  String get concernFinance => 'आर्थिक';

  @override
  String get concernHealth => 'आरोग्य';

  @override
  String get concernEducation => 'शिक्षण';

  @override
  String get concernBusiness => 'व्यवसाय';

  @override
  String get concernLegal => 'कायदेशीर';

  @override
  String get channelChat => 'चॅट';

  @override
  String get channelCall => 'कॉल';

  @override
  String get channelVoice => 'व्हॉइस कॉल';

  @override
  String get channelVideo => 'व्हिडिओ कॉल';

  @override
  String get channelAll => 'सर्व';

  @override
  String get astroFilterAll => 'सर्व';

  @override
  String get astroSortRecommended => 'शिफारस केलेले';

  @override
  String get astroSortTopRated => 'टॉप रेटेड';

  @override
  String get astroSortExperienced => 'सर्वात अनुभवी';

  @override
  String get astroSortConsulted => 'सर्वाधिक सल्ला घेतलेले';

  @override
  String get astroSortNew => 'येथे नवीन';

  @override
  String get astroOnline => 'ऑनलाइन';

  @override
  String get astroBusy => 'व्यस्त';

  @override
  String get astroNotifyMe => 'मला कळवा';

  @override
  String astroWaitMinutes(int count) {
    return '~$count मि प्रतीक्षा';
  }

  @override
  String astroPerMinute(String price) {
    return '$price/मि';
  }

  @override
  String astroYearsExp(int count) {
    return '$count वर्षे अनुभव';
  }

  @override
  String get astroRatingNew => 'नवीन';

  @override
  String astroSessionsCount(String count) {
    return '$count सत्रे';
  }

  @override
  String get astroSearchHint => 'नाव, कौशल्य किंवा भाषेनुसार शोधा';

  @override
  String get astroNoneFound => 'कोणताही ज्योतिषी आढळला नाही';

  @override
  String get astroNoneFoundHint => 'फिल्टर काढून टाका किंवा काहीतरी वेगळे शोधा';

  @override
  String get astroThatsEveryone => 'सध्या इतकेच';

  @override
  String get astroRateOnRequest => 'विनंतीनुसार दर';

  @override
  String get astroCouldntLoad => 'ज्योतिषी लोड होऊ शकले नाहीत.';

  @override
  String get astroSortBy => 'यानुसार क्रमवारी लावा';

  @override
  String get astroLoadMoreFailed => 'अधिक लोड करता आले नाही';

  @override
  String get astroDefaultSkill => 'वैदिक ज्योतिष';

  @override
  String astroYears(int count) {
    return '$count वर्षे';
  }

  @override
  String astroSessions(String count) {
    return '$count सत्रे';
  }

  @override
  String get astroChat => 'चॅट';

  @override
  String get astroCall => 'कॉल करा';

  @override
  String get astroVideo => 'व्हिडिओ';

  @override
  String get astroProfileTitle => 'ज्योतिषी';

  @override
  String get astroExpertiseTitle => 'Expertise';

  @override
  String get astroAboutTitle => 'बद्दल';

  @override
  String get astroRatesTitle => 'सल्लामसलतीचे दर';

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
  String get astroStatSessions => 'सत्रे';

  @override
  String get astroStatRepeatClients => 'पुन्हा येणारे ग्राहक';

  @override
  String astroSpeaks(String languages) {
    return '$languages बोलतात';
  }

  @override
  String astroRepliesIn(String time) {
    return 'अंदाजे $time प्रतिसाद';
  }

  @override
  String get astroOnlineNow => 'आता ऑनलाइन';

  @override
  String get astroOfflineTitle => 'सध्या ऑफलाइन';

  @override
  String get astroNotifyWhenOnline => 'मी ऑनलाइन झाल्यावर मला कळवा';

  @override
  String get astroReadMore => 'अधिक वाचा';

  @override
  String get astroReadLess => 'कमी दाखवा';

  @override
  String get astroCouldntLoadOne => 'या ज्योतिषाला लोड करता आले नाही.';

  @override
  String get astroCallsComingSoon => 'व्हॉइस आणि व्हिडिओ कॉल लवकरच येत आहेत.';

  @override
  String get astroTrustLine =>
      'ओळख पडताळणीसह · खाजगी आणि गोपनीय · मिनिटानुसार पैसे भरा';

  @override
  String get walletTitle => 'वॉलेट';

  @override
  String get walletAvailableBalance => 'उपलब्ध शिल्लक';

  @override
  String walletOnHold(String amount) {
    return '$amount होल्डवर';
  }

  @override
  String walletOnHoldReason(String amount) {
    return '$amount होल्डवर · कॉल सुरू आहे';
  }

  @override
  String get walletAddMoney => 'पैसे जोडा';

  @override
  String get walletRecentActivity => 'अलीकडील क्रियाकलाप';

  @override
  String get walletTransactions => 'व्यवहार';

  @override
  String get walletHowItWorksTitle => 'वॉलेट कसे कार्य करते';

  @override
  String get walletHowItWorksBody =>
      'वॉलेट शिल्लक केवळ सल्लामसलत करण्यासाठी वापरली जाते आणि ती कधीही कालबाह्य होत नाही. न वापरलेली शिल्लक रिफंडेबल आहे — आमचे रिफंड धोरण पहा.';

  @override
  String get walletRefundPolicy => 'रिफंड धोरण';

  @override
  String get walletHaveCoupon => 'कूपन कोड आहे का?';

  @override
  String get walletCouponHint => 'कोड टाका';

  @override
  String walletCouponApplied(String amount) {
    return '$amount तुमच्या वॉलेटमध्ये जोडले गेले';
  }

  @override
  String get walletSecuredBy =>
      'Razorpay · UPI · कार्ड्स · नेटबँकिंगद्वारे सुरक्षित';

  @override
  String get walletGstInvoices => 'GST इनव्हॉइस';

  @override
  String get walletInvoicesSubtitle =>
      'तुमच्या रिचार्जसाठी इनव्हॉइस आणि पावत्या';

  @override
  String get walletNoTransactions => 'अद्याप कोणतेही व्यवहार नाहीत';

  @override
  String get walletNoTransactionsHint =>
      'सुरू करण्यासाठी तुमच्या वॉलेटमध्ये पैसे जोडा';

  @override
  String walletBalanceAfter(String amount) {
    return 'शिल्लक $amount';
  }

  @override
  String get walletFilterAll => 'सर्व';

  @override
  String get walletFilterRecharge => 'जोडलेले';

  @override
  String get walletFilterConsultation => 'सल्लामसलत';

  @override
  String get walletFilterRefund => 'रिफंड';

  @override
  String get walletFilterBonus => 'बोनस';

  @override
  String get kindRecharge => 'पैसे जोडले';

  @override
  String get kindConsultationCharge => 'सल्लामसलत';

  @override
  String get kindConsultationRefund => 'रिफंड';

  @override
  String get kindPromoCredit => 'प्रोमो क्रेडिट';

  @override
  String get kindCouponDiscount => 'कूपन सवलत';

  @override
  String get kindSignupBonus => 'साइनअप बोनस';

  @override
  String get kindReferralBonus => 'रेफरल बोनस';

  @override
  String get kindAdjustment => 'समायोजन';

  @override
  String get kindGiftSpend => 'भेट पाठवली';

  @override
  String get kindHold => 'कॉलसाठी राखीव';

  @override
  String get kindChargeback => 'चार्जबॅक';

  @override
  String get rechargeChooseAmount => 'वॉलेटमध्ये पैसे जोडा';

  @override
  String get rechargeAmountLabel => 'रक्कम';

  @override
  String rechargePayAmount(String amount) {
    return '$amount भरा';
  }

  @override
  String get rechargeAddCoupon => 'कूपन कोड जोडा';

  @override
  String rechargeBonusBadge(String amount) {
    return '+$amount';
  }

  @override
  String get rechargeStarterPack => 'स्टार्टर';

  @override
  String rechargeMinAmount(String amount) {
    return 'किमान $amount';
  }

  @override
  String rechargeMaxAmount(String amount) {
    return 'कमाल $amount';
  }

  @override
  String get rechargeOpeningCheckout => 'सुरक्षित चेकआउट उघडत आहे…';

  @override
  String get rechargeConfirming =>
      'पेमेंट मिळाले आहे — तुमची शिल्लक अपडेट होत आहे…';

  @override
  String rechargeSuccessTitle(String amount) {
    return '$amount जोडले';
  }

  @override
  String rechargeNewBalance(String amount) {
    return 'नवीन शिल्लक $amount';
  }

  @override
  String get rechargeViewTransaction => 'व्यवहार पहा';

  @override
  String get rechargeFailedTitle => 'पेमेंट यशस्वी झाले नाही';

  @override
  String get rechargeNotCharged =>
      'तुमच्याकडून कोणतेही शुल्क आकारले गेले नाही.';

  @override
  String get rechargeAutoRefund =>
      'जर कोणतीही रक्कम वजा झाली असेल, तर ती ३-५ कार्यदिवसांत रिफंड केली जाईल.';

  @override
  String get rechargeTryAgain => 'पुन्हा प्रयत्न करा';

  @override
  String get rechargeChangeAmount => 'रक्कम बदला';

  @override
  String get rechargeCreditedSoon =>
      'पेमेंट मिळाले आहे. आम्ही काही वेळात ते तुमच्या वॉलेटमध्ये जमा करू.';

  @override
  String rechargeOfferAutoApplied(String amount, String bonus) {
    return '$amount जोडा, $bonus अतिरिक्त मिळवा — ऑटो-अप्लाइड';
  }

  @override
  String get profileTitle => 'प्रोफाईल';

  @override
  String get profileEditProfile => 'प्रोफाईल संपादित करा';

  @override
  String profilePhoneMasked(String last4) {
    return '+91 ●●●●● $last4';
  }

  @override
  String get profileCompleteAddEmail =>
      'तुमचे प्रोफाईल पूर्ण करण्यासाठी ईमेल जोडा';

  @override
  String get profileCompleteAddBirth =>
      'वैयक्तिकृत राशीभविष्यासाठी जन्म तपशील जोडा';

  @override
  String get profileRoleCustomer => 'ग्राहक';

  @override
  String get profileWallet => 'वॉलेट';

  @override
  String get profileBirthProfiles => 'जन्म कुंडल्या';

  @override
  String profileBirthProfilesCount(int count) {
    return '$count चार्ट्स';
  }

  @override
  String get profileGroupAccount => 'खाते';

  @override
  String get profileGroupMoney => 'पैसे';

  @override
  String get profileGroupPreferences => 'प्राधान्ये';

  @override
  String get profileGroupSupport => 'सपोर्ट';

  @override
  String get profileGroupLegal => 'कायदेशीर';

  @override
  String get profileNotifications => 'सूचना';

  @override
  String get profileNotificationPrefs => 'सूचना प्राधान्ये';

  @override
  String get profileHapticFeedback => 'स्पर्शजन्य प्रतिसाद';

  @override
  String get profileHapticFeedbackDesc => 'बटणे आणि परस्परसंवादांवर कंपन';

  @override
  String get profileWalletAndTransactions => 'वॉलेट आणि व्यवहार';

  @override
  String get profileOrders => 'Orders';

  @override
  String profileOrdersUnread(int count) {
    return '$count new';
  }

  @override
  String get profileReferAndEarn => 'रेफर करा आणि कमवा';

  @override
  String get profileLanguage => 'भाषा';

  @override
  String get profileCurrency => 'चलन';

  @override
  String get profileHelpCentre => 'हेल्प सेंटर';

  @override
  String get profileContactWhatsapp => 'आमच्याशी WhatsApp वर संपर्क साधा';

  @override
  String get profileRateApp => 'TalkAcharya ला रेटिंग द्या';

  @override
  String get profileShareApp => 'अॅप शेअर करा';

  @override
  String profileShareMessage(String link) {
    return 'मी ज्योतिषांशी बोलण्यासाठी TalkAcharya वापरत आहे. तुम्हीही प्रयत्न करा: $link';
  }

  @override
  String get profileTerms => 'सेवा अटी';

  @override
  String get profilePrivacy => 'गोपनीयता धोरण';

  @override
  String get profileLicenses => 'ओपन-सोर्स परवाने';

  @override
  String get profileDeleteAccount => 'खाते हटवा';

  @override
  String profileVersion(String version, String build) {
    return 'TalkAcharya · v$version ($build)';
  }

  @override
  String get editFullName => 'पूर्ण नाव';

  @override
  String get editDisplayName => 'डिस्प्ले नाव';

  @override
  String get editDateOfBirth => 'जन्म तारीख';

  @override
  String get editGender => 'लिंग';

  @override
  String get editGenderMale => 'पुरुष';

  @override
  String get editGenderFemale => 'स्त्री';

  @override
  String get editGenderOther => 'इतर';

  @override
  String get editEmail => 'ईमेल';

  @override
  String get editEmailUnverified => 'व्हेरिफाईड नाही';

  @override
  String get editChangePhoto => 'फोटो बदला';

  @override
  String get editProfileSaved => 'प्रोफाईल अपडेट झाले';

  @override
  String get editProfileSaveError => 'तुमचे बदल साठवता आले नाहीत';

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
  String get editCountry => 'देश';

  @override
  String get chooseLanguage => 'भाषा निवडा';

  @override
  String get chooseCurrency => 'चलन निवडा';

  @override
  String get deleteAccountTitle => 'तुमचे खाते हटवा';

  @override
  String get deleteAccountBody =>
      'यामुळे तुमचे प्रोफाईल, जन्म कुंडल्या आणि चॅट इतिहास कायमचा काढून टाकला जाईल. तुमच्या वॉलेटमधील शिल्लक, असल्यास, मूळ पेमेंट पद्धतीवर रिफंड केली जाईल. कायद्यानुसार सल्लामसलत रेकॉर्ड ठेवले जातात.';

  @override
  String get deleteAccountHold =>
      'तुमचे खाते लगेच निष्क्रिय केले जाते आणि ३० दिवसांनंतर पूर्णपणे हटवले जाते. रद्द करण्यासाठी ३० दिवसांच्या आत पुन्हा साईन इन करा.';

  @override
  String get deleteAccountConfirm => 'हो, माझे खाते हटवा';

  @override
  String get deleteAccountRequested => 'खाते हटवण्याची विनंती केली आहे';

  @override
  String get referTitle => 'रेफर करा आणि कमवा';

  @override
  String referHeroTitle(String friendAmount, String youAmount) {
    return '$friendAmount द्या, $youAmount मिळवा';
  }

  @override
  String referHeroBody(String friendAmount, String youAmount) {
    return 'तुमच्या मित्राला त्यांच्या पहिल्या सल्लामसलतीवर $friendAmount सवलत मिळते. जेव्हा ते सल्ला घेतील तेव्हा तुम्हाला तुमच्या वॉलेटमध्ये $youAmount मिळतील.';
  }

  @override
  String get referYourCode => 'तुमचा रेफरल कोड';

  @override
  String get referShareLink => 'आमंत्रण लिंक शेअर करा';

  @override
  String get referInvited => 'आमंत्रित';

  @override
  String get referJoined => 'सामील झाले';

  @override
  String get referEarned => 'मिळवले';

  @override
  String get referHowItWorks => 'हे कसे कार्य करते';

  @override
  String get referStep1 =>
      'तुमचा कोड किंवा लिंक शेअर करा. तुमचा मित्र साईन अप करताना तो टाकेल.';

  @override
  String referStep2(String amount) {
    return 'त्यांना त्यांच्या पहिल्या सशुल्क सल्लामसलतीवर $amount सवलत मिळते.';
  }

  @override
  String referStep3(String amount) {
    return 'ज्या क्षणी त्या सल्लामसलतीचे बिल तयार होईल, $amount तुमच्या वॉलेटमध्ये येतील.';
  }

  @override
  String get referYourReferrals => 'तुमचे रेफरल्स';

  @override
  String get referStatusPending => 'प्रलंबित';

  @override
  String get referStatusJoined => 'सामील झाले';

  @override
  String get referStatusRewarded => 'पुरस्कृत';

  @override
  String referJoinedOn(String date) {
    return '$date रोजी सामील झाले';
  }

  @override
  String get referFirstCallDone => 'पहिले कॉल झाले';

  @override
  String referShareText(String code, String amount, String link) {
    return 'TalkAcharya वर माझा कोड $code वापरा आणि तुमच्या पहिल्या ज्योतिष सल्लामसलतीवर $amount सवलत मिळवा. $link';
  }

  @override
  String get kundaliYogasDoshasTitle => 'योग आणि दोष';

  @override
  String get kundaliTabDoshas => 'दोष';

  @override
  String get kundaliTabYogas => 'योग';

  @override
  String get doshaIntro =>
      'दोष हे कुंडलीतील संवेदनशील बिंदू आहेत. बहुतेक दोष कालांतराने, अनुकूल दशेने किंवा पारंपरिक उपायाने सौम्य होतात — तुमच्यासाठी नेमके काय महत्त्वाचे आहे, हे ज्योतिषी निश्चित करतात.';

  @override
  String get doshaDisclaimer =>
      'हे केवळ संरचनात्मक संकेत आहेत, भविष्यवाण्या नाहीत. रत्न धारण करण्यापूर्वी किंवा कोणताही गंभीर उपाय सुरू करण्यापूर्वी ज्योतिषाचा सल्ला घ्या.';

  @override
  String get doshaPresent => 'वर्तमान';

  @override
  String get doshaNotPresent => 'उपस्थित नाही';

  @override
  String get doshaCancelled => 'प्रभावीपणे रद्द केले';

  @override
  String get doshaSeverityClear => 'स्पष्ट';

  @override
  String get doshaSeverityMild => 'सौम्य';

  @override
  String get doshaSeverityModerate => 'मध्यम';

  @override
  String get doshaSeverityStrong => 'मजबूत';

  @override
  String get doshaWhy => 'हे का ध्वजांकित केले आहे';

  @override
  String get doshaWhatReduces => 'ते कशामुळे कमी होते';

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
  String get doshaClearSectionTitle => 'स्पष्ट — तुमच्या चार्टमध्ये नाही';

  @override
  String get doshaAllClear => 'तुमच्या कुंडलीत कोणताही सामान्य दोष नाही.';

  @override
  String get doshaAskCta =>
      'याचा तुमच्यासाठी काय अर्थ आहे, हे ज्योतिषाला विचारा.';

  @override
  String get insightsTitle => 'व्यक्तिमत्व आणि जीवनाचा आढावा';

  @override
  String get insightsIntro =>
      'तुमच्या जन्मपत्रिकेचे (D1) मोफत वाचन — जीवनाच्या मुख्य क्षेत्रांमध्ये तुमचा कल कोणत्या दिशेने आहे, हे यातून कळते. हा आत्मचिंतनासाठी एक आराखडा आहे, घटना किंवा तारखांचे भाकीत नाही.';

  @override
  String get insightsDisclaimer =>
      'तुमच्या कुंडलीनुसार हे एक सर्वसाधारण मार्गदर्शन आहे, भविष्यवाण्या नाहीत. यात कोणत्याही तारखा नमूद केलेल्या नाहीत आणि आरोग्य, आयुर्मान किंवा नातेसंबंधांबद्दल कोणताही दावा केलेला नाही. कोणत्याही विशिष्ट गोष्टीसाठी ज्योतिषाशी बोला.';

  @override
  String get insightsAskCta => 'तुमच्या कुंडलीबद्दल ज्योतिषाला विचारा.';

  @override
  String get insightsWhatItReadsFrom => 'याचा अर्थ असा आहे';

  @override
  String get insightsToneSupportive => 'सहाय्यक';

  @override
  String get insightsToneBalanced => 'संतुलित';

  @override
  String get insightsToneChallenging => 'काळजीची गरज आहे';

  @override
  String get insightsToneMixed => 'मिश्रित';

  @override
  String get insightsAreaPersonality => 'व्यक्तिमत्व आणि स्वभाव';

  @override
  String get insightsAreaAppearance => 'शारीरिक स्वरूप';

  @override
  String get insightsAreaMind => 'मन आणि भावना';

  @override
  String get insightsAreaCareer => 'करिअर आणि पेशा';

  @override
  String get insightsAreaWealth => 'संपत्ती आणि वित्त';

  @override
  String get insightsAreaEducation => 'शिक्षण आणि बुद्धिमत्ता';

  @override
  String get insightsAreaMarriage => 'विवाह आणि जोडीदार';

  @override
  String get insightsAreaFamily => 'कुटुंब आणि नातेसंबंध';

  @override
  String get insightsAreaHealth => 'आरोग्य आणि चैतन्य';

  @override
  String get insightsAreaFortune => 'भाग्य आणि धर्म';

  @override
  String get insightsAreaStrengths => 'सामर्थ्ये आणि आव्हाने';

  @override
  String get predTitle => 'अंदाज';

  @override
  String get predReadingTitle => 'तुमचा अंदाज';

  @override
  String get predRequestTitle => 'हवामान अंदाजाची विनंती करा';

  @override
  String get predHeroTitle => 'तुमच्यासाठी लिहिलेला हवामान अंदाज';

  @override
  String get predHeroBody =>
      'ज्योतिषी तुमची जन्मकुंडली, दशा आणि सध्याचे गोचर वाचून जीवनाच्या एका क्षेत्रासाठी भविष्य लिहून देतात. हे तुमच्या भाषेत, साधारणपणे ३ दिवसांच्या आत दिले जाते.';

  @override
  String get predChooseArea => 'क्षेत्र निवडा';

  @override
  String get predMyReadings => 'तुमचे अंदाज';

  @override
  String get predNoReadings =>
      'अद्याप कोणताही अंदाज उपलब्ध नाही. अंदाजाची विनंती करण्यासाठी वर दिलेल्या क्षेत्रांपैकी एक निवडा.';

  @override
  String get predSeePacks => 'पॅक पहा';

  @override
  String get predSubscribed => 'सदस्यता घेतली';

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
  String get predBuyTitle => 'अंदाज क्रेडिट्स';

  @override
  String get predBuyBody =>
      'एक क्रेडिट = एक लिखित भविष्यवाचन. एक पॅक खरेदी करा आणि जेव्हा तुम्हाला भविष्यवाचन हवे असेल तेव्हा ते तयार असेल.';

  @override
  String get predBuyWalletNote => 'तुमच्या वॉलेट बॅलन्समधून पैसे दिले जातील.';

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
    return 'प्रति क्रेडिट $price';
  }

  @override
  String predBuySuccess(int count) {
    return 'जोडले. आता तुमच्याकडे $count क्रेडिट्स आहेत.';
  }

  @override
  String get predForProfile => 'कोणत्या जन्म प्रोफाइलसाठी';

  @override
  String get predAddProfile => 'जन्म प्रोफाइल जोडा';

  @override
  String get predPickProfile => 'सर्वप्रथम जन्म प्रोफाइल निवडा.';

  @override
  String get predArea => 'जीवनाचे क्षेत्र';

  @override
  String get predPeriod => 'कालावधी';

  @override
  String predCostsOne(int count) {
    return 'तुमच्या $count क्रेडिट्सपैकी 1 वापरला जातो.';
  }

  @override
  String get predNoCreditYet =>
      'तुम्हाला क्रेडिट लागेल — आम्ही आता पॅक्स दाखवू.';

  @override
  String get predRequestCta => 'अंदाजाची विनंती करा';

  @override
  String get predRequestDisclaimer =>
      'ज्योतिषी तुमची कुंडली, दशा आणि गोचर यांवरून निष्कर्ष काढतात. ज्योतिष हे चिंतन आणि नियोजनासाठीचे मार्गदर्शन आहे, कोणतीही हमी नाही.';

  @override
  String get predAreaCareer => 'करिअर आणि काम';

  @override
  String get predAreaMarriage => 'लग्न आणि प्रेम';

  @override
  String get predAreaFinance => 'पैसा आणि वित्त';

  @override
  String get predAreaHealth => 'आरोग्य आणि ऊर्जा';

  @override
  String get predAreaEducation => 'अभ्यास आणि शिक्षण';

  @override
  String get predAreaGeneral => 'जीवनाचा आढावा';

  @override
  String get predPeriodMonth => 'पुढील महिना';

  @override
  String get predPeriodQuarter => 'पुढील ३ महिने';

  @override
  String get predPeriodYear => 'पुढील वर्ष';

  @override
  String get predStatusWriting => 'लिहिले जात आहे';

  @override
  String get predStatusReview => 'पुनरावलोकनात';

  @override
  String get predStatusReady => 'वाचायला तयार';

  @override
  String get predStatusUnavailable => 'उपलब्ध नाही';

  @override
  String get predStatusRefunded => 'परतावा दिला';

  @override
  String predDeliveredOn(String date) {
    return '$date रोजी वितरित केले.';
  }

  @override
  String predEta(String date) {
    return '$date पर्यंत अपेक्षित';
  }

  @override
  String get predWritingTitle => 'एक ज्योतिषी हे लिहित आहे.';

  @override
  String get predWritingBody => 'ते तयार होताच आम्ही तुम्हाला सूचना पाठवू.';

  @override
  String predWritingEta(String date) {
    return '$date पर्यंत अपेक्षित. तयार झाल्यावर आम्ही तुम्हाला कळवू.';
  }

  @override
  String get predRefundedTitle => 'क्रेडिट परत केले';

  @override
  String get predRefundedBody =>
      'आम्ही हे वेळेवर पोहोचवू शकलो नाही, त्यामुळे तुमची रक्कम तुमच्या खात्यात परत जमा झाली आहे.';

  @override
  String get predDisclaimer =>
      'तुमच्या जन्मकुंडली, दशा आणि सध्याच्या गोचरांच्या आधारे एका ज्योतिषाने तुमच्यासाठी लिहिलेले. ज्योतिष हे चिंतन आणि नियोजनासाठीचे मार्गदर्शन आहे — निवड आणि त्याचे परिणाम तुमचेच राहतील.';

  @override
  String get predAskFollowUp => 'पुढील प्रश्न विचारा';

  @override
  String get remediesTitle => 'उपाय';

  @override
  String get remediesIntro =>
      'तुमच्या कुंडलीतील सक्रिय दोष, दुर्बळ ग्रह, चालू दशा आणि तणावपूर्ण स्थाने यांनुसार निवडलेले पारंपरिक उपाय. हे उपाय म्हणजे शिस्त आणि भक्तीची कृत्ये असून, ते तुमची श्रद्धा, आरोग्य आणि आर्थिक परिस्थिती यांनुसार निवडलेले असतात.';

  @override
  String get remediesNone =>
      'तुमच्या कुंडलीत असे काहीही विशेष दिसून येत नाही, ज्यासाठी आत्ताच एखाद्या विशिष्ट उपायाची गरज आहे. दररोज एक छोटा आणि नियमित सराव करणे नेहमीच फायदेशीर ठरते.';

  @override
  String get remediesDisclaimer =>
      'जे तुमच्या श्रद्धेला, आरोग्याला आणि ऐपतीला अनुकूल असेल तेच करा. उपवास करणे तुमच्यासाठी असुरक्षित असल्यास ते टाळा आणि दान देण्यासाठी कधीही कर्ज घेऊ नका.';

  @override
  String get remediesAskCta => 'तुमच्या उपायांबद्दल ज्योतिषाशी बोला.';

  @override
  String get remediesConfirmCta => 'प्रथम ज्योतिषाकडून खात्री करून घ्या.';

  @override
  String remediesSource(String source) {
    return 'स्रोत: $source';
  }

  @override
  String get doshaSeeRemedies => 'तुमच्या चार्टसाठी उपाय पहा';

  @override
  String get remedyCatMantra => 'मंत्र आणि जप';

  @override
  String get remedyCatStotra => 'स्तोत्र आणि पठण';

  @override
  String get remedyCatPuja => 'पूजा आणि विधी';

  @override
  String get remedyCatVrat => 'व्रत आणि उपवास';

  @override
  String get remedyCatDaan => 'दान आणि दान';

  @override
  String get remedyCatLifestyle => 'जीवनशैली';

  @override
  String get remedyCatYantra => 'यंत्र';

  @override
  String get remedyCatGemstone => 'रत्न';

  @override
  String get remedyCatRudraksha => 'रुद्राक्ष';

  @override
  String get prashnaTitle => 'एक प्रश्न विचारा';

  @override
  String get prashnaHeroTitle => 'सध्या हो किंवा नाही';

  @override
  String get prashnaHeroBody =>
      'केपी होरारी (प्रश्न) तुम्ही प्रश्न विचारल्याच्या नेमक्या क्षणीच त्याचे उत्तर (होय, नाही किंवा मिश्र) आणि त्यामागील कारणमीमांसा देते. ही एका पारंपरिक पद्धतीची केवळ एक सूचना आहे, वचन नव्हे.';

  @override
  String get prashnaAbout => 'प्रश्न कशाबद्दल आहे?';

  @override
  String get prashnaHint => 'उदा. मला ही नोकरीची संधी मिळेल का?';

  @override
  String prashnaAskCta(String price) {
    return 'विचारा ( $price )';
  }

  @override
  String get prashnaDisclaimer =>
      'तुम्ही विचारलेल्या क्षणाचे केपी होरारी वाचन. ही एका पारंपरिक पद्धतीची सूचना आहे — वचन नाही, आणि संपूर्ण सल्लामसलतीचा पर्यायही नाही.';

  @override
  String get prashnaNeedQuestion =>
      'आधी एक विषय निवडा आणि तुमचा प्रश्न टाईप करा.';

  @override
  String get prashnaLowBalance =>
      'तुमच्या वॉलेटमधील शिल्लक रक्कम खूप कमी आहे. पैसे जमा करा.';

  @override
  String get prashnaHistory => 'तुमचे प्रश्न';

  @override
  String get prashnaNoHistory => 'तुम्ही अजून प्रश्न विचारलेला नाही.';

  @override
  String get prashnaAnswerTitle => 'वाचन';

  @override
  String get prashnaAskAstrologer => 'ज्योतिषाशी चर्चा करा.';

  @override
  String get prashnaHowRead => 'हे कसे वाचले गेले';

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
  String get prashnaVerdictYes => 'होकारार्थी झुकणे';

  @override
  String get prashnaVerdictNo => 'झुकणे नाही';

  @override
  String get prashnaVerdictMixed => 'मिश्र संकेत';

  @override
  String get prashnaVerdictUnclear => 'निर्णायक नाही';

  @override
  String get prashnaCatMarriage => 'विवाह';

  @override
  String get prashnaCatJob => 'नोकरी';

  @override
  String get prashnaCatPromotion => 'प्रमोशन';

  @override
  String get prashnaCatBusiness => 'व्यवसाय';

  @override
  String get prashnaCatProperty => 'मालमत्ता';

  @override
  String get prashnaCatMoney => 'कर्ज किंवा पैसे';

  @override
  String get prashnaCatChild => 'मुले';

  @override
  String get prashnaCatTravel => 'परदेश प्रवास';

  @override
  String get prashnaCatLitigation => 'न्यायालयीन प्रकरण';

  @override
  String get prashnaCatHealth => 'आरोग्य आणि पुनर्प्राप्ती';

  @override
  String get prashnaCatLost => 'हरवलेली वस्तू';

  @override
  String get prashnaCatReunion => 'पुनर्भेट';

  @override
  String get prashnaCatGeneral => 'दुसरे काहीतरी';

  @override
  String get yogaIntro =>
      'योग म्हणजे प्रवृत्ती, हमी नव्हे — जेव्हा संबंधित ग्रह शुभ स्थितीत असतात आणि त्यांची दशा चालू असते, तेव्हा ते अधिक बलवान होतात.';

  @override
  String get yogaNoneTitle => 'कोणतेही पारंपरिक योग आढळले नाहीत';

  @override
  String get yogaNoneBody =>
      'हे सामान्य आहे आणि वाईट लक्षण नाही — कुंडलीचे वाचन अजूनही तिच्या भावांनुसार आणि दशांनुसारच केले जाते.';

  @override
  String get kundaliTalkToAstrologer => 'ज्योतिषाशी बोला';

  @override
  String get kundaliHowItPlaysOut =>
      'तुमच्या आयुष्यात आणि वेळेनुसार या गोष्टी कशा घडतात हे जाणून घ्यायचे आहे का?';

  @override
  String get yogaGajakesariName => 'गजकेसरी योग';

  @override
  String get yogaGajakesariMeaning =>
      'चंद्रापासून केंद्र स्थानातील गुरू — म्हणजेच संयम, चांगला विवेक आणि वजनदार नाव.';

  @override
  String get yogaBudhadityaName => 'बुद्धादित्य योग';

  @override
  String get yogaBudhadityaMeaning =>
      'सूर्य आणि बुध यांचा संयोग — तीक्ष्ण, अभिव्यक्त बुद्धी; अभ्यास, लेखन आणि विश्लेषणासाठी प्रबळ.';

  @override
  String get yogaChandraMangalaName => 'चंद्र-मंगळ योग';

  @override
  String get yogaChandraMangalaMeaning =>
      'चंद्र आणि मंगळ — पैसा आणि उद्योगाच्या क्षेत्रात कार्यरत; प्रयत्न आणि पुढाकाराने कमाई करणे.';

  @override
  String get yogaRajaName => 'राजयोग';

  @override
  String get yogaRajaMeaning =>
      'केंद्र स्वामी आणि त्रिकोण स्वामी यांचा संयोग झाल्यास, हा काळ संपल्यावर दर्जा, अधिकार आणि संधींमध्ये वाढ होते.';

  @override
  String get yogaDhanaName => 'धन योग';

  @override
  String get yogaDhanaMeaning =>
      'घरांशी निगडित संपत्ती आणि नफा — बचतीला आणि स्थिर आर्थिक वाढीला आधार देतो.';

  @override
  String get yogaNeechabhangaName => 'नीचभंग राजयोग';

  @override
  String get yogaNeechabhangaMeaning =>
      'एक दुर्बळ ग्रह, ज्याची दुर्बलता नाहीशी होते — एक प्रारंभिक संघर्ष जो पुढे शक्तीत रूपांतरित होतो.';

  @override
  String get yogaKaalSarpaName => 'काल सर्प योग';

  @override
  String get yogaKaalSarpaMeaning =>
      'राहू-केतू अक्षाच्या एकाच बाजूला सातही ग्रह असताना, जोपर्यंत स्पष्ट दिशा मिळत नाही तोपर्यंत आयुष्य कोंडल्यासारखे वाटू शकते.';

  @override
  String get yogaAdhiName => 'आधि योग';

  @override
  String get yogaAdhiMeaning =>
      'चंद्रापासून सहाव्या, सातव्या आणि आठव्या स्थानातील शुभ ग्रह — संरक्षण, सक्षम मदतनीस आणि स्थिर स्थिती.';

  @override
  String get yogaShakataName => 'शकात योग';

  @override
  String get yogaShakataMeaning =>
      'गुरूपासून सहाव्या, आठव्या किंवा बाराव्या स्थानात चंद्र असल्यास भाग्यामध्ये चढ-उतार होतात; चंद्र बलवान असताना भाग्य अधिक स्थिर राहते.';

  @override
  String get yogaVishName => 'विश योग';

  @override
  String get yogaVishMeaning =>
      'चंद्र आणि शनी युती — मनाला महत्त्व प्राप्त होते; परिणाम परिपक्वतेनंतर उशिरा मिळण्याची शक्यता असते.';

  @override
  String get yogaKahalaName => 'काहला योग';

  @override
  String get yogaKahalaMeaning =>
      'चतुर्थ आणि नवम स्थानाचे स्वामी परस्पर केंद्रात असून त्यांच्यासोबत बलवान लग्न स्वामी असेल तर — हे धाडसी, उपक्रमशील आणि जोखीम पत्करण्यास तयार असतात.';

  @override
  String get yogaPushkalaName => 'पुष्कला योग';

  @override
  String get yogaPushkalaMeaning =>
      'चंद्रस्वामी आणि लग्नस्वामी यांचा केंद्र स्थानातील योग — आदर, चांगली कीर्ती आणि प्रभावी वाणी.';

  @override
  String get yogaDaridraName => 'दरिद्रा योग';

  @override
  String get yogaDaridraMeaning =>
      'अकराव्या (लाभ) भावाचा स्वामी कठीण घरात उतरला आहे — लाभ हळूहळू मिळतो; एक बलवान दशा परिस्थितीला कलाटणी देते.';

  @override
  String get yogaAmalaName => 'अमला योग';

  @override
  String get yogaAmalaMeaning =>
      'लग्न किंवा चंद्रापासून दहाव्या स्थानातील शुभ ग्रह असल्यासच स्वच्छ प्रतिष्ठा आणि चिरस्थायी सद्भावना मिळते.';

  @override
  String get yogaSaraswatiName => 'सरस्वती योग';

  @override
  String get yogaSaraswatiMeaning =>
      'बुध, शुक्र आणि बलवान गुरू शुभ स्थितीत असल्यामुळे विद्या, कला आणि वक्तृत्व प्राप्त होते.';

  @override
  String get yogaLakshmiName => 'लक्ष्मी योग';

  @override
  String get yogaLakshmiMeaning =>
      'केंद्र किंवा त्रिकोण स्थानातील बलवान नवमेश आणि बलवान लग्नेश — भाग्य, सुख आणि कृपा.';

  @override
  String get yogaRuchakaName => 'रुचक योग';

  @override
  String get yogaRuchakaMeaning =>
      'केंद्र राशीत मंगळ बलवान — धैर्य, शारीरिक शक्ती आणि दबावाखाली नेतृत्व करण्याची क्षमता.';

  @override
  String get yogaBhadraName => 'भद्र योग';

  @override
  String get yogaBhadraMeaning =>
      'केंद्र स्थानातील बलवान बुध — बुद्धिमत्ता, स्पष्ट वाणी आणि व्यापार व संवाद कौशल्य.';

  @override
  String get yogaHamsaName => 'हम्सा योग';

  @override
  String get yogaHamsaMeaning =>
      'केंद्र स्थानात बलवान गुरू — ज्ञान, नीतिमत्ता, शिकवण्याचा किंवा सल्ला देण्याचा स्वभाव आणि सर्वसाधारणपणे चांगले नशीब.';

  @override
  String get yogaMalavyaName => 'मालव्य योग';

  @override
  String get yogaMalavyaMeaning =>
      'केंद्र स्थानात बलवान शुक्र — आकर्षण, आराम, सौंदर्यदृष्टी आणि सुखद कौटुंबिक जीवन.';

  @override
  String get yogaSasaName => 'सासा योग';

  @override
  String get yogaSasaMeaning =>
      'केंद्र स्थानात बलवान शनी — शिस्त, सहनशक्ती आणि अधिकार हळूहळू निर्माण करून टिकवून ठेवले जातात.';

  @override
  String get yogaUbhayachariName => 'उभयाचारी योग';

  @override
  String get yogaUbhayachariMeaning =>
      'सूर्याच्या दोन्ही बाजूंना असलेले ग्रह — त्यांना चांगला आधार, दृश्यमान जीवन आणि सर्वसमावेशक चांगली स्थिती लाभली आहे.';

  @override
  String get yogaVesiName => 'वेसी योग';

  @override
  String get yogaVesiMeaning =>
      'सूर्यापासून दुसऱ्या स्थानातील ग्रह — स्थिर वाणी, संतुलित दृष्टिकोन आणि चांगले नाव.';

  @override
  String get yogaVasiName => 'वासी योग';

  @override
  String get yogaVasiMeaning =>
      'सूर्यापासून बाराव्या स्थानातील ग्रह — क्षमता, प्रभाव आणि उदार वृत्ती.';

  @override
  String get yogaShubhaKartariName => 'शुभा कर्तारी योग';

  @override
  String get yogaShubhaKartariMeaning =>
      'लग्नाच्या दोन्ही बाजूंचे शुभ ग्रह — संरक्षण, अधिक सोपा मार्ग आणि अनुकूल परिस्थिती.';

  @override
  String get yogaPapaKartariName => 'पापा कर्तारी योग';

  @override
  String get yogaPapaKartariMeaning =>
      'लग्नाच्या दोन्ही बाजूंना अशुभ ग्रह असणे — स्वतःवर आणि आरोग्यावर दबाव; आपली ऊर्जा आणि मर्यादा जपा.';

  @override
  String get yogaDurudharaName => 'दुरुधारा योग';

  @override
  String get yogaDurudharaMeaning =>
      'दुसऱ्या आणि बाराव्या स्थानात चंद्राच्या दोन्ही बाजूंना ग्रह आहेत — तुमच्या सभोवताली संसाधने, दिलासा आणि स्थिर आधार असेल.';

  @override
  String get yogaSunaphaName => 'सुनाफा योग';

  @override
  String get yogaSunaphaMeaning =>
      'चंद्रापासून दुसऱ्या स्थानातील ग्रह — स्वबळ, बुद्धिमत्ता आणि चांगली प्रतिष्ठा.';

  @override
  String get yogaAnaphaName => 'अनाफा योग';

  @override
  String get yogaAnaphaMeaning =>
      'चंद्रापासून बाराव्या स्थानातील ग्रह — सहज स्वभाव, कल्याण आणि गरजांपासून मुक्ती.';

  @override
  String get yogaKemadrumaYogaName => 'केमद्रुमा योग';

  @override
  String get yogaKemadrumaYogaMeaning =>
      'चंद्र एकटा, आधाराशिवाय उभा आहे — ही एक आंतरिक अस्वस्थता आहे जी चंद्र बलवान झाल्यावर किंवा एखादे केंद्र व्यापलेले असताना कमी होते.';

  @override
  String get yogaVasumatiName => 'वसुमती योग';

  @override
  String get yogaVasumatiMeaning =>
      'लग्न किंवा चंद्रापासून विकास स्थानांमधील शुभ ग्रह — संपत्तीचा संचय आणि साधनसंपत्तीत वाढ करतात.';

  @override
  String get yogaKalanidhiName => 'कलानिधी योग';

  @override
  String get yogaKalanidhiMeaning =>
      'दुसऱ्या किंवा पाचव्या स्थानातील गुरू, बुध किंवा शुक्राशी युग्मित असल्यास — ज्ञान, कला, सुसंस्कृतपणा आणि सन्मान.';

  @override
  String get yogaChamaraName => 'चामरा योग';

  @override
  String get yogaChamaraMeaning =>
      'केंद्र स्थानातील उच्च लग्न स्वामीवर गुरूची दृष्टी असल्यास — वाक्पटुता, दीर्घायुष्य आणि प्रतिष्ठित स्थान.';

  @override
  String get yogaShankhaName => 'शंख योग';

  @override
  String get yogaShankhaMeaning =>
      'बलवान लग्न स्वामीशी संबंधित पंचम आणि षष्ठ स्थानाचे स्वामी — सुखी आयुष्य, दयाळू स्वभाव आणि उत्तर आयुष्यात आराम.';

  @override
  String get yogaParvataName => 'पर्वत योग';

  @override
  String get yogaParvataMeaning =>
      'केंद्रांमध्ये ६ वे आणि ८ वे स्थान स्वच्छ असलेले शुभ ग्रह — भाग्य, औदार्य आणि एक प्रतिष्ठित नाव.';

  @override
  String get yogaHarshaName => 'हर्ष योग';

  @override
  String get yogaHarshaMeaning =>
      'सहाव्या भावाचा स्वामी कठीण घरात असल्यास — शत्रू, कर्ज आणि आजारपण यांची पकड सैल होते; स्पर्धात्मक शक्ती वाढते.';

  @override
  String get yogaSaralaName => 'सरला योग';

  @override
  String get yogaSaralaMeaning =>
      'अष्टमेश कठीण घरात असणे — संकटातून टिकून राहण्याची क्षमता, दीर्घायुष्य आणि निर्भयता.';

  @override
  String get yogaVimalaName => 'विमला योग';

  @override
  String get yogaVimalaMeaning =>
      'बाराव्या भावाचा स्वामी कठीण घरात असणे — नियंत्रित खर्च, स्वच्छ सद्सद्विवेकबुद्धी आणि स्वतंत्र जीवन.';

  @override
  String get yogaMahaParivartanaName => 'महा परिवर्तन योग';

  @override
  String get yogaMahaParivartanaMeaning =>
      'दोन शुभ घरांचे स्वामी राशींची अदलाबदल करतात — कालांतराने दोन्ही घरांमधील घडामोडी एकमेकांना उन्नत करतात.';

  @override
  String get yogaKhalaParivartanaName => 'खाला परिवर्तन योग';

  @override
  String get yogaKhalaParivartanaMeaning =>
      'तिसऱ्या घराशी संबंधित देवाणघेवाण — मिश्र परिणाम, चढ-उतार, प्रयत्न आणि धैर्याने मिळणारा लाभ.';

  @override
  String get yogaDainyaParivartanaName => 'दैन्य परिवर्तन योग';

  @override
  String get yogaDainyaParivartanaMeaning =>
      'एका अवघड घराशी संबंधित विनिमय — संयमाची गरज असलेले अडथळे; एक प्रबळ दशा त्याला वळवते.';

  @override
  String get kSignAries => 'धाडसी, थेट, लवकर सुरुवात करणारा';

  @override
  String get kSignTaurus =>
      'स्थिर, कामुक, आराम आणि सुरक्षिततेला महत्त्व देणारी';

  @override
  String get kSignGemini => 'जिज्ञासू, बोलका, शीघ्र विचार करणारा';

  @override
  String get kSignCancer => 'काळजी घेणारा, संरक्षक, भावनेने प्रेरित';

  @override
  String get kSignLeo => 'अभिमान, प्रेमळ, दिसण्याची इच्छा';

  @override
  String get kSignVirgo => 'अचूक, उपयुक्त, सुधारणावादी';

  @override
  String get kSignLibra => 'न्याय्य, नातेसंबंध जपणारा, संतुलन साधणारा';

  @override
  String get kSignScorpio => 'तीव्र, खाजगी, सर्वस्व पणाला लावणारे';

  @override
  String get kSignSagittarius => 'मुक्त, विश्वास ठेवणारे, व्यापक दृष्टिकोन';

  @override
  String get kSignCapricorn =>
      'शिस्तप्रिय, महत्त्वाकांक्षी, दूरदृष्टीने विचार करणारा';

  @override
  String get kSignAquarius => 'स्वतंत्र, प्रणालीवादी, अपारंपरिक';

  @override
  String get kSignPisces => 'कल्पक, करुणाशील, सीमारहित';

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
  String get kPlanetSun => 'आत्मा, आत्मविश्वास, वडील, अधिकार';

  @override
  String get kPlanetMoon => 'मन, भावना, आई, दिलासा';

  @override
  String get kPlanetMars => 'प्रेरणा, धैर्य, राग, भावंडे';

  @override
  String get kPlanetMercury => 'बुद्धी, वाणी, व्यापार, कौशल्य';

  @override
  String get kPlanetJupiter => 'शहाणपण, वाढ, नशीब, शिक्षक, मुले';

  @override
  String get kPlanetVenus => 'प्रेम, सौंदर्य, आराम, भागीदारी, कला';

  @override
  String get kPlanetSaturn => 'शिस्त, वेळ, मर्यादा, कष्टाने मिळवलेले बक्षीस';

  @override
  String get kPlanetRahu => 'महत्त्वाकांक्षा, ध्यास, परदेशी आणि नवीन';

  @override
  String get kPlanetKetu => 'अलिप्तता, प्रभुत्व, सोडून देणे, अध्यात्म';

  @override
  String get kHouse1 => 'स्व, शरीर, चैतन्य';

  @override
  String get kHouse2 => 'संपत्ती, कुटुंब, भाषण, अन्न';

  @override
  String get kHouse3 => 'धैर्य, भावंडे, प्रयत्न, छोटा प्रवास';

  @override
  String get kHouse4 => 'घर, आई, जमीन, मनःशांती';

  @override
  String get kHouse5 => 'मुले, शिक्षण, सर्जनशीलता, प्रणय';

  @override
  String get kHouse6 => 'आरोग्य, कर्ज, शत्रू, रोजचे काम';

  @override
  String get kHouse7 => 'लग्न, भागीदारी, व्यवसाय';

  @override
  String get kHouse8 => 'दीर्घायुष्य, आकस्मिक बदल, लपलेले, वारसा';

  @override
  String get kHouse9 => 'भाग्य, धर्म, वडील, उच्च शिक्षण, लांबचा प्रवास';

  @override
  String get kHouse10 => 'कारकीर्द, दर्जा, सार्वजनिक जीवन';

  @override
  String get kHouse11 => 'उत्पन्न, लाभ, नेटवर्क, मोठी भावंडे';

  @override
  String get kHouse12 => 'नुकसान, खर्च, परदेश, झोप, मुक्ती';

  @override
  String get kDignityExalted => 'उन्नत — अतिशय शक्तिशाली';

  @override
  String get kDignityDebilitated => 'दुर्बळ — येथे तणावाखाली';

  @override
  String get kDignityMoolatrikona => 'मूलत्रिकोण — आरामदायक आणि मजबूत';

  @override
  String get kDignityOwn => 'स्वतःचे चिन्ह — स्थिर आणि प्रभावी';

  @override
  String get kDignityGreatFriend => 'एका जिवलग मित्राच्या फलकावर — समर्थित';

  @override
  String get kDignityFriend => 'मित्राच्या पाटीवर — समर्थित';

  @override
  String get kDignityNeutral => 'तटस्थ चिन्ह';

  @override
  String get kDignityEnemy => 'शत्रूच्या राशीत — अधिक मेहनत करतो';

  @override
  String get kDignityGreatEnemy => 'मोठ्या शत्रूच्या चिन्हात — दबावाखाली';

  @override
  String get kDashaSun =>
      'ओळख, अधिकार आणि मान्यतेचा काळ. अहंकार आणि डोळे/हृदयाचे आरोग्य यावर लक्ष केंद्रित होते.';

  @override
  String get kDashaMoon =>
      'एक अधिक हळवा, भावनिक अध्याय — घर, आई, मनःस्थिती आणि सार्वजनिक जीवन.';

  @override
  String get kDashaMars =>
      'उत्साह, स्पर्धा आणि पुढाकार वाढतात. संताप, अपघात आणि मालमत्तेच्या बाबींवर लक्ष ठेवा.';

  @override
  String get kDashaMercury =>
      'शिकणे, व्यापार, लेखन आणि संवाद. अभ्यास आणि व्यवसायासाठी उत्तम, पण शांततेसाठी अस्वस्थ.';

  @override
  String get kDashaJupiter =>
      'वाढ, शिक्षक, कुटुंब, अर्थ. अनेकदा हा एक भाग्यवान आणि विस्तारणारा टप्पा असतो.';

  @override
  String get kDashaVenus =>
      'नातेसंबंध, सुखसोय, कला, पैसा आणि आनंद. सहसा हा सर्वात सोपा काळ असतो.';

  @override
  String get kDashaSaturn =>
      'कठोर परिश्रम, जबाबदारी आणि हळूहळू मिळणारे, पण दीर्घकाळ टिकणारे परिणाम. संयमाला फळ मिळते; शॉर्टकटला शिक्षा.';

  @override
  String get kDashaRahu =>
      'अमर्याद महत्त्वाकांक्षा — परदेश, तंत्रज्ञान, आकस्मिक प्रगती आणि गोंधळ.';

  @override
  String get kDashaKetu =>
      'अलिप्तता, समाप्ती आणि आध्यात्मिक अंतर्मुखता. भौतिक गोष्टी पोकळ वाटतात; कौशल्य अधिक सखोल होते.';

  @override
  String get kNakAshwini => 'जलद, अग्रगण्य, उपचार';

  @override
  String get kNakBharani => 'तीव्र, बदलासाठी वाव देणारा, शिस्तबद्ध';

  @override
  String get kNakKrittika => 'धारदार, भेदक, संरक्षक';

  @override
  String get kNakRohini => 'सर्जनशील, कामुक, मायाळू, चुंबकीय';

  @override
  String get kNakMrigashira => 'शोधक, जिज्ञासू, सौम्य';

  @override
  String get kNakArdra => 'वादळी, परिवर्तन घडवणारे, दबावाखालीही उत्कृष्ट';

  @override
  String get kNakPunarvasu => 'नूतनीकरण करणारा, उदार, सुरक्षिततेकडे परततो';

  @override
  String get kNakPushya => 'पोषण करणारे, कर्तव्यदक्ष, अत्यंत आधार देणारे';

  @override
  String get kNakAshlesha => 'सूक्ष्म निरीक्षण, धोरणात्मक, संमोहन';

  @override
  String get kNakMagha => 'राजेशाही, परंपरावादी, पूर्वजांशी संबंधित';

  @override
  String get kNakPurvaPhalguni =>
      'खेळकर, रोमँटिक, फावल्या वेळेला महत्त्व देणारा';

  @override
  String get kNakUttaraPhalguni => 'विश्वसनीय, करारबद्ध, उपयुक्त';

  @override
  String get kNakHasta => 'हातांनी कुशल, हुशार, उपचार करणारा';

  @override
  String get kNakChitra => 'कलात्मक, आकर्षक, सुंदर वस्तू बनवणारा';

  @override
  String get kNakSwati => 'स्वतंत्र, जुळवून घेणारा, स्वातंत्र्यप्रेमी';

  @override
  String get kNakVishakha => 'ध्येयनिष्ठ, दृढनिश्चयी, दुहेरी स्वभावाची';

  @override
  String get kNakAnuradha => 'समर्पित, मैत्रीपूर्ण, परदेशात यशस्वी';

  @override
  String get kNakJyeshtha => 'वरिष्ठ, जबाबदार, जबाबदाऱ्या सांभाळणारा';

  @override
  String get kNakMula =>
      'मूळाचा शोध घेणारा, मूलगामी, थेट गाभ्यापर्यंत पोहोचणारा';

  @override
  String get kNakPurvaAshadha => 'अजेय आत्मा, मन वळवणारा';

  @override
  String get kNakUttaraAshadha => 'तत्त्वनिष्ठ, टिकाऊ, नंतरचे यश';

  @override
  String get kNakShravana => 'ऐकणे, शिकणे, लोकांना जोडणे';

  @override
  String get kNakDhanishta => 'लयबद्ध, समृद्ध, संगीतमय, जुळवून घेणारा';

  @override
  String get kNakShatabhisha => 'खाजगी, आरोग्यदायी, प्रणाली-केंद्रित';

  @override
  String get kNakPurvaBhadrapada => 'आदर्शवादी, तीव्र, परिवर्तनकारी';

  @override
  String get kNakUttaraBhadrapada => 'सखोल, शांत, शहाणा सल्ला';

  @override
  String get kNakRevati => 'दयाळू, प्रवाशांचे रक्षण करणारा, कल्पक';

  @override
  String get kSadeSatiRising =>
      'उदय अवस्था — शनी तुमच्या चंद्रापासून १२व्या राशीत आहे. गोष्टींचा शेवट, थकवा आणि सर्व काही हळूहळू संपत असल्याची भावना. ज्या गोष्टी आता उपयोगी नाहीत, त्या दूर करण्यास सुरुवात करा.';

  @override
  String get kSadeSatiPeak =>
      'परमोच्च टप्पा — शनी तुमच्या चंद्र राशीवरच आहे. सर्वात कठीण काळ: जबाबदारी, दबाव आणि मंद प्रगती. दिनचर्या पाळा, आपल्या आरोग्याचे रक्षण करा.';

  @override
  String get kSadeSatiSetting =>
      'स्थित्यंतर — शनी तुमच्या चंद्रापासून दुसऱ्या राशीत आहे. मनावरचे ओझे हलके होईल. धन आणि कौटुंबिक स्थिती स्थिर होईल; गेल्या काही वर्षांतील धड्यांचे फळ मिळू लागेल.';

  @override
  String get kSadeSatiGeneric =>
      'शनी तुमच्या चंद्राभोवतीच्या राशींमधून भ्रमण करत आहे.';

  @override
  String kPlanetInSignHouse(
    Object planet,
    Object sign,
    Object signTrait,
    Object house,
    Object houseTheme,
  ) {
    return '$sign मध्ये तुमचा $planet तुम्हाला $signTrait देतो. $house मध्ये तो $houseTheme ला स्पर्श करतो.';
  }

  @override
  String kPlanetInSign(Object planet, Object sign, Object signTrait) {
    return 'Your $planet in $sign makes you $signTrait.';
  }

  @override
  String get kHouseSans1 => 'तनु भव';

  @override
  String get kHouseSans2 => 'धन भव';

  @override
  String get kHouseSans3 => 'सहज भव';

  @override
  String get kHouseSans4 => 'सुख भव';

  @override
  String get kHouseSans5 => 'पुत्र भव';

  @override
  String get kHouseSans6 => 'रिपू भव';

  @override
  String get kHouseSans7 => 'युवती भव';

  @override
  String get kHouseSans8 => 'आयु / रणध्र भव';

  @override
  String get kHouseSans9 => 'धर्म भव';

  @override
  String get kHouseSans10 => 'कर्म भव';

  @override
  String get kHouseSans11 => 'लाभ भव';

  @override
  String get kHouseSans12 => 'व्यय भव';

  @override
  String kHouseTitleWithSign(Object sign, Object theme) {
    return '$sign · $theme';
  }

  @override
  String kHouseSheetTitle(Object ordinal, Object sign) {
    return '$ordinal घर · $sign';
  }

  @override
  String kHouseSheetSubtitle(Object sanskrit, Object theme) {
    return '$sanskrit — $theme';
  }

  @override
  String kHouseChipLord(Object lord) {
    return 'सभागृह स्वामी · $lord';
  }

  @override
  String kHouseChipLordIn(Object nthHouse) {
    return '$nthHouse प्रभू';
  }

  @override
  String kHouseNoPlanets(Object lord, Object lordWhere) {
    return 'या घरात कोणताही ग्रह नाही. याची कथा मुख्यत्वेकरून याचा स्वामी, $lord $lordWhere सांगतो.';
  }

  @override
  String kHouseLordWhere(Object nthHouse) {
    return 'आता $nthHouse';
  }

  @override
  String get kHousePlanetsHeader => 'या घरातले ग्रह';

  @override
  String kHouseAskCta(Object ordinal) {
    return 'तुमच्या $ordinal घराविषयी ज्योतिषाला विचारा.';
  }

  @override
  String kHouseReadingLord(
    Object ordinal,
    Object lord,
    Object nthHouse,
    Object theme,
    Object lordTheme,
  ) {
    return 'तुमचे $ordinal -घराचे स्वामी $lord हे $nthHouse मध्ये बसतात, म्हणून $theme हे $lordTheme शी जोडले जाते.';
  }

  @override
  String kHouseReadingOccupant(
    Object planet,
    Object planetTheme,
    Object theme,
  ) {
    return '$planet येथे त्याच्या थीम्स — $planetTheme — $theme मध्ये आणतो.';
  }

  @override
  String get kHouseReadingEmpty =>
      'या घराचा अभ्यास त्याच्या स्वामी आणि त्यावर दृष्टी टाकणाऱ्या ग्रहांच्या आधारे केला जातो. एक ज्योतिषी तुम्हाला हे समजून घेण्यास मदत करू शकतो.';

  @override
  String kBhavaSubheadKaraka(Object karaka) {
    return 'कराक $karaka';
  }

  @override
  String kBhavaSubheadLord(Object lord, Object nthHouse) {
    return 'लॉर्ड $lord , $nthHouse';
  }

  @override
  String kBhavaSubheadLordOnly(Object lord) {
    return 'प्रभू $lord';
  }

  @override
  String kBhavaReadingGoverns(Object theme) {
    return 'हे घर $theme नियंत्रित करते.';
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
    return 'त्याचा स्वामी $lord हा $nthHouse मध्ये आहे, म्हणून $theme हा $lordTheme शी जोडला जातो. $dignity $occupants';
  }

  @override
  String kBhavaReadingDignity(Object dignity) {
    return ' प्रभू म्हणजे $dignity .';
  }

  @override
  String kBhavaReadingOccupants(Object planets, Object themes) {
    return ' $planets येथे बसून $themes जोडत आहेत.';
  }

  @override
  String kTransitHouseLine(Object nthHouse, Object theme) {
    return 'तुमचे $nthHouse · $theme';
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
  String get kDignityShortExalted => 'उन्नत';

  @override
  String get kDignityShortMoolatrikona => 'मूलत्रिकोना';

  @override
  String get kDignityShortOwn => 'स्वतःचे';

  @override
  String get kDignityShortDebilitated => 'दुर्बळ';

  @override
  String get kDignityShortEnemy => 'शत्रूचे चिन्ह';

  @override
  String get kDignityShortGreatEnemy => 'महान शत्रू';

  @override
  String get kCombustNote =>
      'दहन — सूर्याच्या अगदी जवळ असल्यामुळे त्याचा स्वतंत्र आवाज मंदावतो.';

  @override
  String get kWhatThisMeans => 'याचा तुमच्यासाठी काय अर्थ आहे';

  @override
  String get ovStrengthStrong => 'मजबूत';

  @override
  String get ovStrengthSteady => 'स्थिर';

  @override
  String get ovStrengthStrain => 'तणावाखाली';

  @override
  String get ovStrengthWeak => 'कमजोर';

  @override
  String get ovRoleSpouse => 'जोडीदार सूचक';

  @override
  String get ovRoleDarakaraka => 'दराकारक (जैमिनी)';

  @override
  String get ovRoleWealth => 'संपत्ती सूचक';

  @override
  String get ovRoleIntellect => 'बुद्धिमत्ता सूचक';

  @override
  String get ovRoleWisdom => 'ज्ञान सूचक';

  @override
  String get ovRoleFortune => 'भाग्य सूचक';

  @override
  String get ovRoleFather => 'पिता सूचक';

  @override
  String get ovRoleMother => 'आई सूचक';

  @override
  String get ovRoleGeneric => 'सिग्निफिकेटर';

  @override
  String ovfPada(int pada) {
    return 'pada $pada';
  }

  @override
  String ovfLagnaSign(Object sign) {
    return 'उदय राशी $sign';
  }

  @override
  String ovfLagnaLord(Object planet, Object nthHouse, Object dignity) {
    return '$nthHouse $dignity असलेला लग्नस्वामी $planet ';
  }

  @override
  String ovfHouseLord(Object ordinal, Object planet, Object nthHouse) {
    return '$ordinal $nthHouse असलेला $planet हा घराचा स्वामी आहे.';
  }

  @override
  String ovfHouseStrength(Object ordinal, Object strength) {
    return '$ordinal घर — $strength';
  }

  @override
  String ovfMoonSign(Object sign) {
    return '$sign मधील चंद्र';
  }

  @override
  String ovfMoonHouse(Object nthHouse) {
    return '$nthHouse चंद्र';
  }

  @override
  String ovfMoonNakshatra(Object nakshatra) {
    return 'चंद्र नक्षत्र $nakshatra';
  }

  @override
  String ovfMoonDignity(Object dignity) {
    return 'चंद्र $dignity';
  }

  @override
  String ovfSunSign(Object sign) {
    return '$sign मध्ये सूर्य';
  }

  @override
  String ovfSeventhSign(Object sign) {
    return '$sign मधील सातवे घर';
  }

  @override
  String ovfPlanetInHouse(Object planet, Object nthHouse) {
    return '$planet in the $nthHouse';
  }

  @override
  String ovfPlanetWithMoon(Object planet) {
    return 'चंद्रासह $planet';
  }

  @override
  String ovfAppearanceIn(Object planet) {
    return 'पहिल्या घरात $planet';
  }

  @override
  String ovfAppearanceAspect(Object planet) {
    return '$planet पहिल्या घरावर दृष्टी टाकत आहे';
  }

  @override
  String ovfMaleficOnLagna(Object planet) {
    return '$planet लग्नस्थानावर दाब देत आहे';
  }

  @override
  String ovfKaraka(Object role, Object planet) {
    return '$role : $planet';
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
  String get doshaMangalName => 'मंगळ दोष';

  @override
  String get doshaMangalMeaning =>
      'संवेदनशील घरात असलेला मंगळ — पारंपरिकरित्या लग्नापूर्वी त्याचे वजन केले जाते. जेव्हा दोन्ही जोडीदार मंगलिक असतात किंवा गुरूचा मंगळावर प्रभाव असतो, तेव्हा तो अनेकदा संतुलित असतो.';

  @override
  String get doshaKaalSarpaName => 'काल सर्प दोष';

  @override
  String get doshaKaalSarpaMeaning =>
      'संपूर्ण कुंडली राहू आणि केतूच्या दरम्यान सामावलेली असते — जोपर्यंत स्पष्ट दिशा मिळत नाही तोपर्यंत आयुष्य कोंडल्यासारखे वाटू शकते, त्यानंतर लक्ष अधिक केंद्रित होते.';

  @override
  String get doshaPitraName => 'पितृ दोष';

  @override
  String get doshaPitraMeaning =>
      'सूर्य आणि नववे घर पूर्वजांच्या कर्माची छाया धारण करतात — ज्याचा उल्लेख अनेकदा वडिलांच्या नावाने श्रद्धा आणि दानाने केला जातो.';

  @override
  String get doshaGandmoolName => 'गंडमूळ दोष';

  @override
  String get doshaGandmoolMeaning =>
      'चंद्र एका संयोग नक्षत्रात स्थित आहे. सत्ताविसाव्या दिवशी शांती पूजा करणे ही एक पारंपरिक कृती आहे.';

  @override
  String get doshaGrahanName => 'ग्रहण दोष';

  @override
  String get doshaGrahanMeaning =>
      'एखादा तेजस्वी ग्रह (सूर्य किंवा चंद्र) नोडसोबत स्थित असतो, त्यामुळे जोपर्यंत त्यावर कार्य केले जात नाही तोपर्यंत ग्रहांचे कारकत्व मंदावते.';

  @override
  String get doshaShrapitName => 'श्रापित दोष';

  @override
  String get doshaShrapitMeaning =>
      'शनी आणि राहू — सुरुवातीला विलंब आणि गोंधळ; स्थिर, संयमी प्रयत्न हाच यातून मार्ग आहे.';

  @override
  String get doshaGuruChandalName => 'गुरु चांडाळ दोष';

  @override
  String get doshaGuruChandalMeaning =>
      'नोड ग्रहासह गुरू — अपारंपरिक विचारांनी युक्त शहाणपण; आपले शिक्षक आणि श्रद्धा काळजीपूर्वक निवडा.';

  @override
  String get doshaAngarakName => 'अंगारक दोष';

  @override
  String get doshaAngarakMeaning =>
      'नोडमध्ये मंगळ — एक आवेगपूर्ण ऊर्जा; राग, अपघात आणि मालमत्तेच्या वादांमध्ये सावधगिरी बाळगणे आवश्यक आहे.';

  @override
  String get doshaKemadrumaName => 'केमाद्रुमा दोष';

  @override
  String get doshaKemadrumaMeaning =>
      'चंद्र सभोवताली कोणत्याही आधाराशिवाय एकटा असतो — जेव्हा एखादे केंद्र ग्रह व्यापलेले असते किंवा चंद्र बलवान असतो, तेव्हा त्याला आराम मिळतो.';

  @override
  String get doshaDaridraName => 'दरिद्रा दोष';

  @override
  String get doshaDaridraMeaning =>
      'धनस्थानांवर ताण आहे — शिस्तबद्ध बचत आणि एक मजबूत दशा परिस्थिती सुधारू शकते.';

  @override
  String get birthDetailsCta => 'जन्माचा संपूर्ण तपशील';

  @override
  String get birthDetailsTitle => 'जन्म तपशील';

  @override
  String get birthDetailsAyanamsa => 'अयनांश';

  @override
  String get birthDetailsPanchangTitle => 'जन्मावेळी पंचांग';

  @override
  String get birthDetailsChakraTitle => 'अवकाहद चक्र';

  @override
  String get birthDetailsWeekday => 'आठवड्याचा दिवस';

  @override
  String get birthDetailsTithi => 'तिथी';

  @override
  String get birthDetailsNakshatra => 'नक्षत्र';

  @override
  String get birthDetailsYoga => 'योग';

  @override
  String get birthDetailsKarana => 'करणा';

  @override
  String get birthDetailsMoonSign => 'चंद्र राशी';

  @override
  String get birthDetailsSunSign => 'सूर्य राशी';

  @override
  String get birthDetailsSuryaNakshatra => 'सूर्याचे नक्षत्र';

  @override
  String get birthDetailsSunrise => 'सूर्योदय';

  @override
  String get birthDetailsSunset => 'सूर्यास्त';

  @override
  String get birthDetailsIshtaKala => 'इष्टा कला';

  @override
  String birthDetailsPada(int count) {
    return 'पडा $count';
  }

  @override
  String birthDetailsGhatiPala(int ghati, int pala, int vipala) {
    return '$ghati घाटी $pala पला $vipala विपला';
  }

  @override
  String get birthDetailsNakshatraLord => 'नक्षत्र स्वामी';

  @override
  String get birthDetailsRashiLord => 'राशी स्वामी';

  @override
  String get birthDetailsVarna => 'वर्णा';

  @override
  String get birthDetailsVashya => 'वश्य';

  @override
  String get birthDetailsYoni => 'योनी';

  @override
  String get birthDetailsGana => 'गाना';

  @override
  String get birthDetailsNadi => 'नाडी';

  @override
  String get birthDetailsTara => 'तारा';

  @override
  String get birthDetailsTattva => 'तत्त्व';

  @override
  String get birthDetailsYunja => 'युंजा';

  @override
  String get birthDetailsRashiPaya => 'राशी पाया';

  @override
  String get birthDetailsNakshatraPaya => 'नक्षत्र पाया';

  @override
  String get birthDetailsDisclaimer =>
      'पारंपरिक वर्गीकरणात्मक गुणधर्म — यांचा वापर प्रामुख्याने मुहूर्त आणि जोड्या जुळवण्यासाठी केला जातो, भाकितांसाठी नाही.';

  @override
  String get vaaraMonday => 'सोमवार';

  @override
  String get vaaraTuesday => 'मंगळवार';

  @override
  String get vaaraWednesday => 'बुधवार';

  @override
  String get vaaraThursday => 'गुरुवरा (गुरुवार)';

  @override
  String get vaaraFriday => 'शुक्रवार';

  @override
  String get vaaraSaturday => 'शनिवार';

  @override
  String get vaaraSunday => 'रविवारा (रविवार)';

  @override
  String get tattvaFire => 'अग्नी';

  @override
  String get tattvaEarth => 'पृथ्वी';

  @override
  String get tattvaAir => 'वायू (हवा)';

  @override
  String get tattvaWater => 'जल (पाणी)';

  @override
  String get payaGold => 'सोने';

  @override
  String get payaSilver => 'चांदी';

  @override
  String get payaCopper => 'तांबे';

  @override
  String get payaIron => 'लोखंड';

  @override
  String get roomAppBarTitle => 'सल्लामसलत';

  @override
  String get roomOpenError => 'आम्ही ही चर्चा सुरू करू शकलो नाही.';

  @override
  String roomWaitingTitle(String name) {
    return '$name यांच्या स्वीकृतीची प्रतीक्षा करत आहे';
  }

  @override
  String get roomWaitingBody =>
      'साधारणपणे एका मिनिटापेक्षा कमी वेळात. ते सामील होताच आम्ही चॅट सुरू करू.';

  @override
  String get roomCancelRequest => 'विनंती रद्द करा';

  @override
  String get roomEndConfirmTitle => 'ही चर्चा संपवायची का?';

  @override
  String get roomEndConfirmBody => 'सेशन संपल्यावर बिलिंग थांबते.';

  @override
  String get roomKeepTalking => 'बोलत रहा';

  @override
  String get roomEnd => 'शेवट';

  @override
  String get roomAutoTranslateOn => 'स्वयंचलित भाषांतर चालू';

  @override
  String get roomAutoTranslateOff => 'स्वयंचलित भाषांतर बंद करा';

  @override
  String get roomEndedTitle => 'चर्चा संपली.';

  @override
  String get roomBalanceOutTitle => 'तुमची शिल्लक संपली.';

  @override
  String roomBalanceOutBody(String name) {
    return 'तुमच्या वॉलेटमधील शिल्लक संपल्यामुळे चॅट समाप्त झाले आहे. $name सोबत पुढे सुरू ठेवण्यासाठी रिचार्ज करा आणि पुन्हा सुरू करा.';
  }

  @override
  String get roomRechargeWallet => 'रिचार्ज वॉलेट';

  @override
  String roomStartAgain(String name) {
    return '$name सह पुन्हा सुरू करा';
  }

  @override
  String get roomRowAstrologer => 'ज्योतिषी';

  @override
  String get roomRowDuration => 'कालावधी';

  @override
  String get roomRowAmount => 'रक्कम';

  @override
  String get roomRowRate => 'दर';

  @override
  String roomMinutes(int minutes) {
    return '$minutes मिनिटे';
  }

  @override
  String roomRatePerMinute(String currency, String amount) {
    return '$currency $amount /मिनिट';
  }

  @override
  String get roomRateQuestion => 'तुमची सल्लामसलत कशी झाली?';

  @override
  String get roomSubmitRating => 'रेटिंग सबमिट करा';

  @override
  String get roomRatingThanks => 'अभिप्रायाबद्दल धन्यवाद!';

  @override
  String get roomBackHome => 'घरी परत जा';

  @override
  String get roomStatusRejected => 'ज्योतिषी ही विनंती स्वीकारू शकले नाहीत.';

  @override
  String get roomStatusCancelled => 'विनंती रद्द केली';

  @override
  String get roomStatusExpired =>
      'विनंतीची मुदत संपली — वेळेत प्रतिसाद मिळाला नाही';

  @override
  String get roomStatusNoShow => 'कॉल लागला नाही.';

  @override
  String get roomStatusClosed => 'चर्चा बंद झाली.';

  @override
  String get roomBalanceRunningOut => 'शिल्लक संपत आहे';

  @override
  String roomMinLeftRecharge(int minutes) {
    return '~ $minutes मिनिटे शिल्लक · बोलणे सुरू ठेवण्यासाठी रिचार्ज करा';
  }

  @override
  String roomSpentMinLeft(String currency, String amount, int minutes) {
    return '$currency $amount खर्च केली · ~ $minutes मिनिटे शिल्लक';
  }

  @override
  String get roomAddMoney => 'पैसे जोडा';

  @override
  String get roomClientBalanceLow =>
      'ग्राहकाची शिल्लक कमी आहे — लवकरच व्यवहार पूर्ण करा';

  @override
  String get navChats => 'गप्पा';

  @override
  String get chatsTitle => 'गप्पा';

  @override
  String get chatsLoadError => 'आम्ही तुमचे चॅट्स लोड करू शकलो नाही.';

  @override
  String get chatsEmptyTitle => 'अद्याप एकही चॅट नाही';

  @override
  String get chatsEmptyBody =>
      'ज्योतिषाशी सल्लामसलत सुरू करा आणि ते येथे दिसून येते.';

  @override
  String get chatsSectionActive => 'सक्रिय';

  @override
  String get chatsSectionRecent => 'अलीकडील';

  @override
  String get chatsAstrologerFallback => 'ज्योतिषी';

  @override
  String get chatsStatusWaiting => 'ज्योतिषी स्वीकारेल याची वाट पाहत आहे';

  @override
  String get chatsStatusLive => 'आता थेट प्रक्षेपण · उघडण्यासाठी टॅप करा';

  @override
  String chatsStatusEnded(int minutes) {
    return '$minutes मिनिटांचा सल्लामसलत';
  }

  @override
  String get chatsStatusCancelled => 'रद्द केले';

  @override
  String get chatsStatusRejected => 'स्वीकारले नाही';

  @override
  String get chatsStatusExpired => 'विनंतीची मुदत संपली आहे';

  @override
  String get chatsStatusGeneric => 'सल्लामसलत';

  @override
  String get numerologyTitle => 'अंकशास्त्र आणि लो शू ग्रिड';

  @override
  String get numerologyIntro =>
      'तुमच्या जन्मतारखेवरून (आणि नावावरून) अंकांचे पारंपरिक वाचन — प्रत्येक अंकाचा कल कोणत्या प्रवृत्तीकडे असतो, अनुकूल दिवस व रंग, आणि तुमची लो शू जन्म रचना. हे चिंतनासाठी आहे, तारखेनुसार भविष्यकथनासाठी नाही.';

  @override
  String get numMoolank => 'मूलांक · मानसिक क्रमांक';

  @override
  String get numBhagyank => 'भाग्यंक · नियती क्रमांक';

  @override
  String get numNaamank => 'नामंक · नाव क्रमांक';

  @override
  String numRuledBy(String planet) {
    return '$planet द्वारे शासित';
  }

  @override
  String get numFriendly => 'मैत्रीपूर्ण';

  @override
  String get numNeutral => 'तटस्थ';

  @override
  String get numUnfriendly => 'टक्कर';

  @override
  String get numFavDays => 'अनुकूल दिवस';

  @override
  String get numFavColours => 'अनुकूल रंग';

  @override
  String get numDirection => 'दिशा';

  @override
  String get numDeity => 'देवता';

  @override
  String get numGemstone => 'पारंपारिक रत्न';

  @override
  String get numLoShuTitle => 'लो शू जन्म ग्रिड';

  @override
  String numLoShuMissing(String nums) {
    return 'तुमच्या ग्रिडमध्ये नाही: $nums';
  }

  @override
  String numLoShuRepeated(String nums) {
    return 'जोर दिला: $nums';
  }

  @override
  String get numArrowStrength => 'पूर्ण ओळ';

  @override
  String get numArrowAbsence => 'अनुपस्थित ओळ';

  @override
  String get numAskCta => 'याबद्दल ज्योतिषाशी बोला.';

  @override
  String get sadeSatiTitle => 'साडेसाती आणि ढैया कॅलेंडर';

  @override
  String sadeSatiIntro(String sign) {
    return 'तुमच्या चंद्र $sign मोजल्यास, तुमच्या आयुष्यावरील शनीच्या कालखंडातील दर्शने. साडेसाती म्हणजे चंद्रापासून १२व्या, १ल्या आणि २ऱ्या स्थानातून जाणारा शनी (~७½ वर्षे); ढैया म्हणजे ४थे किंवा ८वे स्थान (~२½ वर्षे).';
  }

  @override
  String get sadeSatiRunningNow => 'सध्या चालू आहे';

  @override
  String get sadeSatiPast => 'भूतकाळ';

  @override
  String get sadeSatiUpcoming => 'आगामी';

  @override
  String get sadeSatiPhaseRising => 'उदय · १२व्या स्थानातील शनी';

  @override
  String get sadeSatiPhasePeak => 'शिखर · चंद्रावर शनी';

  @override
  String get sadeSatiPhaseSetting => 'अस्त · दुसऱ्या स्थानातील शनी';

  @override
  String get sadeSatiPhaseKantaka => 'कंटक · चौथ्या स्थानातील शनी';

  @override
  String get sadeSatiPhaseAshtama => 'अष्टम · आठव्या स्थानातील शनी';

  @override
  String get sadeSatiDhaiyaHeading => 'धैया (लहान पानोटी) कालावधी';

  @override
  String sadeSatiRange(String start, String end) {
    return '$start → $end';
  }

  @override
  String get avTransitHeading => 'आजच्या गोचरांची अष्टकवर्ग शक्ती';

  @override
  String get avTransitIntro =>
      'तुमच्या जन्मबिंदू गुणांवरून, प्रत्येक ग्रहाचे गोचर किती मुक्तपणे आपले परिणाम देते हे ठरते. ८ पैकी ५ पेक्षा जास्त गुण शुभ मानले जातात, ४ मिश्र, तर त्यापेक्षा कमी गुण दुर्बळ मानले जातात.';

  @override
  String avTransitBindus(int bindus) {
    return '$bindus /8 बिंदू';
  }

  @override
  String get avTransitUpcoming => 'आगामी';

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
      'सर्व्हरशी संपर्क होऊ शकला नाही. तुमचे कनेक्शन तपासा.';

  @override
  String get errTimeout => 'सर्व्हरने प्रतिसाद देण्यास खूप वेळ घेतला.';

  @override
  String get errSession => 'तुमचे सत्र संपले आहे. कृपया पुन्हा साईन इन करा.';

  @override
  String get errWalletInsufficient => 'तुमची वॉलेट शिल्लक यासाठी खूप कमी आहे.';

  @override
  String get errRateLimited =>
      'खूप प्रयत्न झाले आहेत. कृपया थोडा वेळ थांबा आणि पुन्हा प्रयत्न करा.';

  @override
  String get errOtpInvalid => 'कोड चुकीचा आहे किंवा कालबाह्य झाला आहे.';

  @override
  String get errOtpMaxAttempts => 'खूप चुकीचे प्रयत्न. नवीन कोडची विनंती करा.';

  @override
  String get errPromoNotRedeemable => 'हा कूपन कोड वापरता येणार नाही.';

  @override
  String get errRechargeInvalidAmount => 'अनुमत मर्यादेत रक्कम टाका.';

  @override
  String get errAuthWrongApp =>
      'हा नंबर दुसऱ्या TalkAcharya अॅपसाठी नोंदणीकृत आहे.';

  @override
  String get errGeneric => 'काहीतरी चूक झाली आहे. कृपया पुन्हा प्रयत्न करा.';

  @override
  String get homePanchangTitle => 'आजचे पंचांग';

  @override
  String get homeLiveNowTitle => 'आता थेट प्रक्षेपण';

  @override
  String get homeFreeToolsTitle => 'मोफत साधने';

  @override
  String get homeResumeBtn => 'सारांश';

  @override
  String get homeAddBtn => 'जोडा';

  @override
  String get homeNotifyMeBtn => 'मला सूचित करा';

  @override
  String get homeKundaliAction => 'कुंडली';

  @override
  String get homeMatchingAction => 'जुळणारे';

  @override
  String get homeHoroscopeAction => 'राशिभविष्य';

  @override
  String get homeVastuAction => 'वास्तु';

  @override
  String get homeRetryBtn => 'पुन्हा प्रयत्न करा';

  @override
  String get homeChooseSignTitle => 'तुमची रास निवडा';

  @override
  String get homeChooseLanguageTitle => 'भाषा निवडा';

  @override
  String get homeLanguageTooltip => 'भाषा';

  @override
  String homeLanguageSwitchError(String error) {
    return 'स्विच करता आले नाही: $error';
  }

  @override
  String get homeComingSoonSnackbar => 'लवकरच येत आहे!';

  @override
  String get homeTalkAgainTitle => 'पुन्हा बोलूया';

  @override
  String get homeRechargeWalletTitle => 'तुमचे वॉलेट रिचार्ज करा';

  @override
  String get homeTalkToAstrologerTitle => 'ज्योतिषाशी बोला';

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

  @override
  String get kOvEyebrow => 'Janam Kundali';

  @override
  String kOvMoonChip(String sign) {
    return 'Moon · $sign';
  }

  @override
  String get kOvTapHouseHint => 'Tap any house to read what it says about you';

  @override
  String get kOvBirthDetailsSub => 'Avakahada, panchang at birth and more';

  @override
  String get kOvGroupCharts => 'Chart & planets';

  @override
  String get kOvGroupTiming => 'Timing & periods';

  @override
  String get kOvGroupGuidance => 'Guidance & remedies';

  @override
  String get kOvLoadError => 'We couldn\'t open this kundali';

  @override
  String get kKitAskTitle => 'Have a question about your chart?';

  @override
  String get kKitAskBody =>
      'A verified astrologer can read it with you — personally, in minutes.';

  @override
  String get kFcExploreMore => 'Go deeper';

  @override
  String get kFcAllHousesSub =>
      'All twelve houses of your Lagna chart, one tap each';

  @override
  String get kFcAllChartsSub => 'Every divisional chart from D1 to D60';

  @override
  String get kPlanetsHeroSub =>
      'Nine grahas, where they sit and how strong they are. Tap any planet to read it.';

  @override
  String kPlanetsStrongCount(int count) {
    return '$count strong';
  }

  @override
  String kPlanetsRetroCount(int count) {
    return '$count retrograde';
  }

  @override
  String get kPlanetRetrograde => 'Retrograde';

  @override
  String get kPlanetCombust => 'Combust';

  @override
  String get kDashaTimelineTitle => 'Your life timeline';

  @override
  String kDashaProgressPct(String pct) {
    return '$pct% complete';
  }

  @override
  String get kBhavaHeroSub =>
      'Twelve houses, twelve areas of life — what supports each one and what strains it.';

  @override
  String kBhavaSupportedCount(int count) {
    return '$count supported';
  }

  @override
  String kBhavaStrainedCount(int count) {
    return '$count under strain';
  }

  @override
  String get kYdDoshaHeroSub =>
      'Traditional doshas checked in your chart, with how strong each one really is.';

  @override
  String get kYdYogaHeroSub =>
      'Planetary combinations that shape your gifts and opportunities.';

  @override
  String kYdDoshaCount(int count) {
    return '$count present';
  }

  @override
  String kYdYogaCount(int count) {
    return '$count yogas';
  }

  @override
  String get kYdClear => 'Clear';

  @override
  String get kYdRemediesSub =>
      'Gentle, traditional remedies suited to your chart';

  @override
  String get kSsLifetimeTitle => 'Across your lifetime';

  @override
  String get kSsNotRunning => 'Not running now';

  @override
  String kTrHeroSub(String sign) {
    return 'Today\'s planets read from your Moon in $sign';
  }

  @override
  String kTrJupiterChip(String house) {
    return 'Jupiter $house from Moon';
  }

  @override
  String get kTrSadeSatiCalendarSub =>
      'Every phase of Saturn\'s cycle, past and upcoming';

  @override
  String get kSsEyebrow => 'Saturn\'s cycle';

  @override
  String get kAdvHeroSub => 'The technical layer astrologers read from';

  @override
  String kAdvReportCount(int count) {
    return '$count reports';
  }

  @override
  String get kAdvPdfChip => 'PDF download';

  @override
  String get kAdvReportsTitle => 'Technical reports';

  @override
  String get kAdvAvHousesTitle => 'Points by house';

  @override
  String kAdvSarvaTotal(int total) {
    return '$total points in all';
  }

  @override
  String get kInHeroSub =>
      'A character and life sketch drawn from your birth chart';

  @override
  String kInSupportiveCount(int count) {
    return '$count supportive';
  }

  @override
  String kInChallengingCount(int count) {
    return '$count need care';
  }

  @override
  String get kInGlanceTitle => 'At a glance';

  @override
  String get kInAreasTitle => 'Area by area';

  @override
  String get kLkHeroSub =>
      'Inherited debts in your chart and their simple household remedies';

  @override
  String kLkDebtCount(int count) {
    return '$count active debts';
  }

  @override
  String kLkWeakCount(int count) {
    return '$count weak planets';
  }

  @override
  String get kMuHeroSub => 'Today\'s good hours, read for your chart';

  @override
  String get kMuTimingsTitle => 'Today\'s timings';

  @override
  String get kMuTabDay => 'Day';

  @override
  String get kMuTabNight => 'Night';

  @override
  String kMuHoraOf(String planet) {
    return '$planet hora';
  }

  @override
  String get kMuAbhijit => 'Abhijit muhurta';

  @override
  String get kNumHeroSub => 'Your core numbers and Lo Shu birth grid';

  @override
  String get kNumYourNumbers => 'Your numbers';

  @override
  String get kNumMissing => 'Missing numbers';

  @override
  String get kNumRepeated => 'Repeated numbers';

  @override
  String get kRmHeroSub =>
      'Gentle, traditional practices matched to your chart';

  @override
  String kRmCount(int count) {
    return '$count remedies';
  }

  @override
  String get kRmGatedChip => 'Some need an astrologer';

  @override
  String get kRmCaution => 'Keep in mind';

  @override
  String get kUpHeroSub => 'Colours, days, mantras and charity for each planet';

  @override
  String kUpStrengthenCount(int count) {
    return '$count to strengthen';
  }

  @override
  String kUpPacifyCount(int count) {
    return '$count to pacify';
  }

  @override
  String get kUpGateTitle => 'Confirm with an astrologer first';

  @override
  String get kUpPlanetsTitle => 'Planet by planet';

  @override
  String kVpHeadline(String year) {
    return 'Your year $year';
  }

  @override
  String get kVpMarkersTitle => 'Key markers of the year';

  @override
  String get kVpTajikaTitle => 'Tajika aspect';

  @override
  String get kVpIthasala => 'Ithasala · applying';

  @override
  String get kVpIshrafa => 'Ishrafa · separating';

  @override
  String get followFollow => 'Follow';

  @override
  String get followFollowing => 'Following';

  @override
  String get followNotifying => 'Notifying';

  @override
  String get followNotifyingWhenOnline => 'We\'ll notify you when online';

  @override
  String followedToast(String name) {
    return 'Following $name — we\'ll let you know when they\'re online or live';
  }

  @override
  String unfollowedToast(String name) {
    return 'Unfollowed $name';
  }

  @override
  String get followFailed => 'Couldn\'t update follow. Please try again.';

  @override
  String followPromptTitle(String name) {
    return 'Follow $name?';
  }

  @override
  String get followPromptBody =>
      'Get a notification when they\'re online or go live.';

  @override
  String get followPromptDoneTitle => 'You\'re following';

  @override
  String followPromptDoneBody(String name) {
    return 'We\'ll tell you when $name is online or live.';
  }

  @override
  String get followingTitle => 'Following';

  @override
  String get followingHint =>
      'You\'ll get a notification when these astrologers come online or go live. Tap the heart to unfollow.';

  @override
  String get followingEmptyTitle => 'Not following anyone yet';

  @override
  String get followingEmptyBody =>
      'Follow astrologers you like to know when they\'re online or live.';

  @override
  String get followingExplore => 'Find astrologers';

  @override
  String get followingLoadError => 'Couldn\'t load the astrologers you follow.';

  @override
  String get followingFilter => 'Following';

  @override
  String get followingFilterEmpty =>
      'Tap the heart on an astrologer to follow them — they\'ll show up here.';

  @override
  String get astroStatFollowers => 'Followers';

  @override
  String get prefsFollowAlerts => 'Astrologers you follow';

  @override
  String get prefsFollowAlertsDesc => 'When they come online or go live';

  @override
  String get storeTitle => 'Remedy Store';

  @override
  String get storeHeroSubtitle =>
      'Authentic rudraksha, gemstones, yantras and poojas — guided by astrologers';

  @override
  String get storeSearchHint => 'Search rudraksha, gemstones, poojas…';

  @override
  String get storeVerdictToast => 'An astrologer shared advice on your product';

  @override
  String get storeView => 'View';

  @override
  String get storeUnavailable => 'Unavailable';

  @override
  String storePriceFrom(String price) {
    return 'from $price';
  }

  @override
  String storeOff(int percent) {
    return '$percent% off';
  }

  @override
  String get storeBadgePooja => 'Pooja';

  @override
  String get storeBadgeAskAstrologer => 'Ask astrologer';

  @override
  String get storeCartTitle => 'Cart';

  @override
  String get storeTrustCertified => 'Lab certified';

  @override
  String get storeTrustGuided => 'Astrologer guided';

  @override
  String get storeTrustSecure => 'Secure payments';

  @override
  String get storeCategories => 'Shop by category';

  @override
  String get storeFeatured => 'Handpicked remedies';

  @override
  String get storeFeaturedSub => 'Chosen by our astrologers';

  @override
  String get storeCollections => 'Remedy collections';

  @override
  String get storePoojas => 'Book a pooja';

  @override
  String get storePoojasSub => 'Performed in your name at sacred temples';

  @override
  String get storeConsultBannerTitle => 'Not sure what suits you?';

  @override
  String get storeConsultBannerBody =>
      'Video call an astrologer before you buy — they check your chart and recommend the right remedy.';

  @override
  String get storeConsultBannerCta => 'Talk to an astrologer';

  @override
  String get storeMyAdvice => 'Advice from your astrologers';

  @override
  String get storeDisclaimerFooter =>
      'Remedies are traditional practices. Results are not guaranteed and they don\'t replace medical, legal or financial advice.';

  @override
  String get storeEmptyTitle => 'The store is getting ready';

  @override
  String get storeEmptyBody => 'Remedies and poojas will appear here soon.';

  @override
  String get storeLoadError => 'Couldn\'t load the store';

  @override
  String get storeMyOrders => 'My orders';

  @override
  String get storeVerdictSuitable => 'Suitable — go ahead';

  @override
  String get storeVerdictNotSuitable => 'Not suitable for you';

  @override
  String get storeVerdictAlternative => 'Suggests something else';

  @override
  String get storeConsultCancelled => 'Call didn\'t happen';

  @override
  String get storeConsultExpired => 'No advice was shared';

  @override
  String get storeConsultCallLive => 'Your call is in progress';

  @override
  String get storeConsultAwaiting => 'Waiting for the astrologer\'s advice';

  @override
  String storeConsultWith(String name) {
    return 'with $name';
  }

  @override
  String storeVerdictFrom(String name) {
    return '$name\'s advice';
  }

  @override
  String get storeBuyRecommended => 'Buy the recommended option';

  @override
  String get storeSuggestedInstead => 'Suggested instead';

  @override
  String get storeConsultPromptTitle => 'Not sure it suits you?';

  @override
  String get storeConsultPromptBody =>
      'Video call an astrologer — they\'ll check your chart before you buy.';

  @override
  String get storeConsultRequiredTitle => 'Consult an astrologer first';

  @override
  String get storeConsultRequiredBody =>
      'This remedy is sold only after an astrologer confirms it suits your chart.';

  @override
  String get storeNoResults => 'Nothing matches';

  @override
  String get storeNoResultsBody => 'Try another word or clear some filters.';

  @override
  String get storeClearFilters => 'Clear filters';

  @override
  String storeResultCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
    );
    return '$_temp0';
  }

  @override
  String get storeFilters => 'Filters';

  @override
  String get storeNoFilters => 'No filters for this selection yet.';

  @override
  String get storeSortBy => 'Sort by';

  @override
  String get storeSortRecommended => 'Recommended';

  @override
  String get storeSortPopular => 'Most popular';

  @override
  String get storeSortNew => 'Newest';

  @override
  String get storeSortRating => 'Top rated';

  @override
  String get storeKindProducts => 'Products';

  @override
  String get storeKindPoojas => 'Poojas';

  @override
  String get storeKindDigital => 'Reports';

  @override
  String storeRemedyFor(String key) {
    return 'Remedy: $key';
  }

  @override
  String get storeChoosePackage => 'Choose a package';

  @override
  String get storeChooseOption => 'Choose an option';

  @override
  String get storePickDate => 'Pick a date';

  @override
  String get storeSankalpDetails => 'Sankalp details';

  @override
  String get storeYourDetails => 'Your details';

  @override
  String get storeSankalpHint =>
      'The priest takes the sankalp in these names during the pooja.';

  @override
  String get storeCertificate => 'Certificate of authenticity';

  @override
  String storeCertificateNo(String number) {
    return 'Certificate no. $number';
  }

  @override
  String get storeVerify => 'Verify';

  @override
  String get storeHighlights => 'Highlights';

  @override
  String get storeAbout => 'About';

  @override
  String get storeSignificance => 'Traditional significance';

  @override
  String get storeHowToUse => 'How to wear / use';

  @override
  String get storeHowItWorks => 'How it works';

  @override
  String get storeReadMore => 'Read more';

  @override
  String get storeReadLess => 'Show less';

  @override
  String get storeRecommendedForYou => 'Recommended for you';

  @override
  String get storeTaxInclusive => 'Inclusive of all taxes';

  @override
  String get storeOutOfStock => 'Out of stock';

  @override
  String storeOnlyLeft(int count) {
    return 'Only $count left';
  }

  @override
  String get storeAskAnother => 'Ask another astrologer';

  @override
  String get storeNoDates => 'Dates will be announced soon.';

  @override
  String get storeOpenForBooking => 'Open for booking';

  @override
  String storeSeatsLeft(int count) {
    return '$count slots left';
  }

  @override
  String storeReturnableDays(int days) {
    return 'Easy returns within $days days of delivery';
  }

  @override
  String get storeNotReturnable => 'Not returnable once delivered';

  @override
  String get storeCancellable => 'Cancel free before it\'s dispatched';

  @override
  String get storeNotCancellable => 'Can\'t be cancelled once ordered';

  @override
  String storeMadeToOrder(int days) {
    return 'Made to order · ready in about $days days';
  }

  @override
  String get storeShipsIndia => 'Insured shipping across India';

  @override
  String get storeVideoProof => 'Video of the pooja shared with you';

  @override
  String get storeInstantDownload => 'Instant download after payment';

  @override
  String storeSoldBy(String name) {
    return 'Sold by $name';
  }

  @override
  String get storeSellerInfo => 'Seller & grievance details';

  @override
  String storeCountryOfOrigin(String country) {
    return 'Country of origin: $country';
  }

  @override
  String get storeGrievanceOfficer => 'Grievance officer';

  @override
  String storeFieldRequired(String label) {
    return '$label is required';
  }

  @override
  String storeFieldParticipants(String label, int count) {
    return 'Enter $count $label';
  }

  @override
  String get storePickDateError => 'Pick a date for the pooja';

  @override
  String get storeAddedToCart => 'Added to cart';

  @override
  String get storeViewCart => 'View cart';

  @override
  String get storeFixDetails => 'Please check the highlighted details';

  @override
  String get storeAddToCart => 'Add to cart';

  @override
  String get storeBuyNow => 'Buy now';

  @override
  String get storeBookPooja => 'Book pooja';

  @override
  String get storeConsultFirst => 'Consult first';

  @override
  String storePersonN(int n) {
    return 'Person $n';
  }

  @override
  String get storeConsultTitle => 'Talk before you buy';

  @override
  String get storeConsultPick => 'Choose an astrologer';

  @override
  String get storeConsultNoneTitle => 'No one\'s available right now';

  @override
  String get storeConsultNoneBody =>
      'Astrologers who take video calls will show up here. Try again in a little while.';

  @override
  String get storeConsultBrowseAll => 'Browse all astrologers';

  @override
  String get storeConsultAbout => 'Consultation about';

  @override
  String get storeConsultVideoPerMinute => 'Video call · billed per minute';

  @override
  String get storeConsultOffer => 'Offer applied';

  @override
  String get storeConsultStep1 => 'Video call an astrologer';

  @override
  String get storeConsultStep2 => 'They check your chart and advise';

  @override
  String get storeConsultStep3 => 'Buy what\'s right for you';

  @override
  String get storePresenceOnline => 'Online';

  @override
  String get storePresenceBusy => 'In a call';

  @override
  String get storePresenceOffline => 'Offline';

  @override
  String get storeSpecialist => 'Specialist';

  @override
  String storeYearsExp(int years) {
    return '$years yrs';
  }

  @override
  String storePerMinute(String price) {
    return '$price/min';
  }

  @override
  String get storeCall => 'Call';

  @override
  String storeConsultConfirmTitle(String name) {
    return 'Video call $name';
  }

  @override
  String get storeConsultQuestion => 'What would you like to ask?';

  @override
  String storeConsultSharingChart(String name) {
    return 'Sharing $name\'s birth chart with the astrologer';
  }

  @override
  String storeConsultHoldNote(String rate, String hold) {
    return '$rate per minute from your wallet. $hold is held when the call starts; you only pay for the minutes you talk.';
  }

  @override
  String get storeConsultStartCall => 'Start video call';

  @override
  String get storeConsultLowBalance =>
      'Add money to your wallet to start the call';

  @override
  String storeConsultBusy(String name) {
    return '$name just got busy — try another astrologer';
  }

  @override
  String storeConsultOffline(String name) {
    return '$name went offline';
  }

  @override
  String get storeAdviceTitle => 'Astrologer advice';

  @override
  String get storeAdviceEmptyTitle => 'No advice yet';

  @override
  String get storeAdviceEmptyBody =>
      'Ask an astrologer about a remedy from any product page.';

  @override
  String get storeExplore => 'Explore the store';

  @override
  String get storeOpenCall => 'Open call';

  @override
  String get storeYourQuestion => 'Your question';

  @override
  String get storeVideoCall => 'Video call';

  @override
  String get storeRequired => 'Required';

  @override
  String get storeAddAddress => 'Add address';

  @override
  String get storeEditAddress => 'Edit address';

  @override
  String get storeAddressesTitle => 'Saved addresses';

  @override
  String get storeNoAddressesTitle => 'No saved addresses';

  @override
  String get storeNoAddressesBody =>
      'Add a delivery address to get products shipped to you.';

  @override
  String get storeDefault => 'Default';

  @override
  String get storeEdit => 'Edit';

  @override
  String get storeDelete => 'Delete';

  @override
  String get storeMakeDefault => 'Make default';

  @override
  String get storeChange => 'Change';

  @override
  String get storeLabelHome => 'Home';

  @override
  String get storeLabelWork => 'Work';

  @override
  String get storeLabelOther => 'Other';

  @override
  String get storeFullName => 'Full name';

  @override
  String get storePhone => 'Mobile number';

  @override
  String get storePhoneInvalid => 'Enter a valid 10-digit mobile number';

  @override
  String get storeLine1 => 'House no., building, street';

  @override
  String get storeLine2 => 'Area, colony (optional)';

  @override
  String get storeLandmark => 'Landmark (optional)';

  @override
  String get storeCity => 'City';

  @override
  String get storePincode => 'PIN code';

  @override
  String get storePincodeInvalid => 'Enter a valid 6-digit PIN';

  @override
  String get storeState => 'State';

  @override
  String get storeGstinOptional => 'GSTIN (optional)';

  @override
  String get storeGstinHelp =>
      'Add it to claim input tax credit on the invoice';

  @override
  String get storeGstinInvalid => 'GSTIN has 15 characters';

  @override
  String get storeSaveAddress => 'Save address';

  @override
  String get storeCheckout => 'Checkout';

  @override
  String get storeCartEmptyTitle => 'Your cart is empty';

  @override
  String get storeCartEmptyBody =>
      'Rudraksha, gemstones, yantras and poojas — find what your chart needs.';

  @override
  String get storeCartTaxNote =>
      'Prices include GST. Shipping is calculated at checkout.';

  @override
  String storeItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
    );
    return '$_temp0';
  }

  @override
  String get storeRemove => 'Remove';

  @override
  String get storeDeliverTo => 'Deliver to';

  @override
  String get storeOrderSummary => 'Order summary';

  @override
  String get storeBillDetails => 'Bill details';

  @override
  String get storeSubtotal => 'Item total';

  @override
  String get storeShipping => 'Shipping';

  @override
  String storeShippingAmount(String amount) {
    return 'Shipping $amount';
  }

  @override
  String get storeFree => 'Free';

  @override
  String get storeGrandTotal => 'Total';

  @override
  String storeTaxIncluded(String amount) {
    return 'Includes $amount GST';
  }

  @override
  String get storePaidFromWallet => 'From wallet';

  @override
  String get storePaidOnline => 'Paid online';

  @override
  String get storeToPayNow => 'To pay';

  @override
  String get storeUseWallet => 'Use wallet balance';

  @override
  String storeWalletAvailable(String amount) {
    return '$amount available';
  }

  @override
  String get storeOrderNote => 'Note for the seller (optional)';

  @override
  String get storeCheckoutTrust =>
      'Secure payment. Certified products. Returns on damaged or wrong items.';

  @override
  String get storePlaceOrder => 'Place order';

  @override
  String get storePayNow => 'Pay now';

  @override
  String storePayAmount(String amount) {
    return 'Pay $amount';
  }

  @override
  String get storePayDescription => 'Remedies store order';

  @override
  String storeDeliveryDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'In $days days',
      one: 'In 1 day',
    );
    return '$_temp0';
  }

  @override
  String storeDeliveryDaysRange(int min, int max) {
    return '$min–$max days';
  }

  @override
  String get storePaymentCancelled =>
      'Payment cancelled. Your order is saved — pay before it expires.';

  @override
  String get storePaymentFailed => 'Payment didn\'t go through. Try again.';

  @override
  String get storePaymentDone => 'Payment received';

  @override
  String get storePaymentConfirming =>
      'We\'re confirming your payment. This can take a minute.';

  @override
  String get storePaymentPendingTitle => 'Payment pending';

  @override
  String get storePaymentPendingBody =>
      'Items are held for you until the timer runs out. Any wallet amount is refunded if the order expires.';

  @override
  String get storeOrdersTitle => 'My orders';

  @override
  String get storeOrderTitle => 'Order';

  @override
  String storeOrderNumber(String number) {
    return 'Order #$number';
  }

  @override
  String storeItemAndMore(String title, int count) {
    return '$title + $count more';
  }

  @override
  String get storeTabAll => 'All orders';

  @override
  String get storeTabPoojas => 'Poojas';

  @override
  String get storeNoOrdersTitle => 'No orders yet';

  @override
  String get storeNoOrdersBody =>
      'Products and poojas you buy will show up here.';

  @override
  String get storeNoPoojasTitle => 'No poojas booked';

  @override
  String get storeNoPoojasBody =>
      'Book a pooja at a temple in your name — you\'ll get the video once it\'s done.';

  @override
  String get storeBrowsePoojas => 'Browse poojas';

  @override
  String get storeDateToBeAnnounced => 'Date to be announced';

  @override
  String get storeVideoReady => 'Video ready';

  @override
  String get storeWatchPooja => 'Watch pooja';

  @override
  String get storeOrderPendingPayment => 'Payment pending';

  @override
  String get storeOrderPaid => 'Confirmed';

  @override
  String get storeOrderCompleted => 'Completed';

  @override
  String get storeOrderCancelled => 'Cancelled';

  @override
  String get storeOrderExpired => 'Expired';

  @override
  String get storeOrderRefunded => 'Refunded';

  @override
  String get storeStagePending => 'Pending';

  @override
  String get storeStageAwaitingApproval => 'Awaiting seller';

  @override
  String get storeStageConfirmed => 'Confirmed';

  @override
  String get storeStageProcessing => 'Packing';

  @override
  String get storeStageShipped => 'Shipped';

  @override
  String get storeStageDelivered => 'Delivered';

  @override
  String get storeStageCompleted => 'Completed';

  @override
  String get storeStageCancelled => 'Cancelled';

  @override
  String get storeStageReturned => 'Returned';

  @override
  String get storeBookingConfirmed => 'Booked';

  @override
  String get storeBookingPerformed => 'Performed';

  @override
  String get storeBookingProofReady => 'Video shared';

  @override
  String get storeShipCreated => 'Ready to ship';

  @override
  String get storeShipPickedUp => 'Picked up';

  @override
  String get storeShipInTransit => 'In transit';

  @override
  String get storeShipOutForDelivery => 'Out for delivery';

  @override
  String get storeShipAttemptFailed => 'Delivery attempt failed';

  @override
  String get storeShipReturning => 'Returning to seller';

  @override
  String get storeShipLost => 'Shipment issue — we\'re on it';

  @override
  String storeAwb(String awb) {
    return 'AWB $awb';
  }

  @override
  String get storeTrack => 'Track';

  @override
  String storeQty(int count) {
    return 'Qty $count';
  }

  @override
  String storePlacedOn(String date) {
    return 'Placed $date';
  }

  @override
  String get storeOrderPlacedTitle => 'Order placed!';

  @override
  String get storeOrderPlacedBody =>
      'We\'ll keep you posted as it\'s packed and shipped.';

  @override
  String get storeOrderPlacedPooja =>
      'Your pooja is booked. You\'ll get the video once it\'s performed.';

  @override
  String get storeCancelOrder => 'Cancel order';

  @override
  String get storeCancelThisPart => 'Cancel these items';

  @override
  String get storeCancelOrderQ => 'Cancel this order?';

  @override
  String storeCancelPartQ(String seller) {
    return 'Cancel items from $seller?';
  }

  @override
  String get storeCancelReasonHint => 'Tell us why (optional)';

  @override
  String get storeCancel => 'Cancel';

  @override
  String get storeKeep => 'Keep';

  @override
  String get storeCancelled => 'Cancelled. Any refund goes back automatically.';

  @override
  String get storeRefunds => 'Refunds';

  @override
  String get storeRefunded => 'Refunded';

  @override
  String storeRefundedAmount(String amount) {
    return '$amount refunded';
  }

  @override
  String storeRefundToWallet(String amount) {
    return '$amount to wallet';
  }

  @override
  String storeRefundToSource(String amount) {
    return '$amount to your bank / card';
  }

  @override
  String get storeInvoices => 'Invoices';

  @override
  String storeTaxInvoice(String number) {
    return 'Tax invoice $number';
  }

  @override
  String storeCreditNote(String number) {
    return 'Credit note $number';
  }

  @override
  String get storeDownload => 'Download';

  @override
  String get storeDownloadFailed => 'Couldn\'t open the file. Try again.';

  @override
  String get storeNoProducts => 'Nothing here yet';

  @override
  String get storeReturnItem => 'Return item';

  @override
  String storeReturnUntil(String date) {
    return 'Return by $date';
  }

  @override
  String get storeReturnWhy => 'Why are you returning it?';

  @override
  String get storeReturnDetails => 'Details (helps us resolve it faster)';

  @override
  String get storeReturnNote =>
      'Keep the item and its certificate in original packaging. Pickup is arranged once the seller approves.';

  @override
  String get storeReturnSubmit => 'Request return';

  @override
  String get storeReturnPickReason => 'Pick a reason';

  @override
  String get storeReturnRequested =>
      'Return requested. We\'ll update you soon.';

  @override
  String get storeReasonDamaged => 'Arrived damaged';

  @override
  String get storeReasonWrongItem => 'Wrong item';

  @override
  String get storeReasonNotAsDescribed => 'Not as described';

  @override
  String get storeReasonAuthenticity => 'Doubt about authenticity';

  @override
  String get storeReasonSize => 'Size doesn\'t fit';

  @override
  String get storeReasonChangedMind => 'Changed my mind';

  @override
  String get storeReasonOther => 'Other';

  @override
  String get storeProfileOrders => 'Store orders';

  @override
  String get storeProfileOrdersSub => 'Products, poojas and downloads';

  @override
  String get storeProfileAdviceSub => 'What astrologers said about products';

  @override
  String get storeProfileAddressesSub => 'Delivery addresses';

  @override
  String get storeHomeRailTitle => 'Remedies store';

  @override
  String get storeHomeRailSub =>
      'Certified rudraksha, gemstones and temple poojas';

  @override
  String get storeSeeAll => 'See all';
}
