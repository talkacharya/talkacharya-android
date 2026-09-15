// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Telugu (`te`).
class AppLocalizationsTe extends AppLocalizations {
  AppLocalizationsTe([String locale = 'te']) : super(locale);

  @override
  String get appName => 'TalkAcharya';

  @override
  String get commonOk => 'సరే';

  @override
  String get commonCancel => 'రద్దు చేయి';

  @override
  String get commonDone => 'పూర్తయింది';

  @override
  String get commonNext => 'తరువాత';

  @override
  String get commonBack => 'వెనక్కి';

  @override
  String get commonRetry => 'మళ్ళీ ప్రయత్నించు';

  @override
  String get commonSave => 'సేవ్ చేయి';

  @override
  String get commonEdit => 'సవరించు';

  @override
  String get commonDelete => 'తొలగించు';

  @override
  String get commonClose => 'మూసివేయి';

  @override
  String get commonContinue => 'కొనసాగించు';

  @override
  String get commonConfirm => 'ధృవీకరించు';

  @override
  String get commonSeeAll => 'అన్నీ చూడు';

  @override
  String get commonViewAll => 'అన్నీ చూడు';

  @override
  String get commonShare => 'షేర్ చేయి';

  @override
  String get commonCopy => 'కాపీ చేయి';

  @override
  String get commonCopied => 'కాపీ అయింది';

  @override
  String get commonApply => 'వర్తింపజేయి';

  @override
  String get commonSearch => 'వెతుకు';

  @override
  String get commonYes => 'అవును';

  @override
  String get commonNo => 'కాదు';

  @override
  String get commonLoading => 'లోడ్ అవుతోంది…';

  @override
  String get commonSomethingWentWrong => 'ఏదో తప్పు జరిగింది';

  @override
  String get commonCheckConnection =>
      'మీ ఇంటర్నెట్ కనెక్షన్ తనిఖీ చేసి మళ్ళీ ప్రయత్నించండి';

  @override
  String get commonComingSoon => 'త్వరలో వస్తుంది';

  @override
  String get commonToday => 'ఈరోజు';

  @override
  String get commonYesterday => 'నిన్న';

  @override
  String commonMinutesShort(int count) {
    return '$count నిమిషాలు';
  }

  @override
  String get commonOffline => 'మీరు ఆఫ్‌లైన్‌లో ఉన్నారు';

  @override
  String get navHome => 'హోమ్';

  @override
  String get navAstrologers => 'జ్యోతిష్యులు';

  @override
  String get navLive => 'లైవ్';

  @override
  String get navWallet => 'వాలెట్';

  @override
  String get navProfile => 'ప్రొఫైల్';

  @override
  String get authWelcomeTitle => 'నమ్మకమైన జ్యోతిష్యులతో మాట్లాడండి';

  @override
  String get authWelcomeSubtitle =>
      'ప్రేమ, కెరీర్, డబ్బు మరియు మరిన్ని విషయాలపై మార్గదర్శనం కోసం చాట్ లేదా కాల్ చేయండి';

  @override
  String get authPhoneTitle => 'మీ మొబైల్ నంబర్ నమోదు చేయండి';

  @override
  String get authPhoneSubtitle =>
      'మీ మొబైల్ నంబర్ నమోదు చేయండి, మేము మీకు ఒక వన్-టైమ్ కోడ్ పంపుతాము.';

  @override
  String authOtpSubtitle(String phone) {
    return 'మేము $phone కు 6-అంకెల కోడ్ పంపాము.';
  }

  @override
  String authTestModeCode(String code) {
    return 'టెస్ట్ మోడ్ — మీ కోడ్ $code';
  }

  @override
  String get authPhoneHint => 'మొబైల్ నంబర్';

  @override
  String get authPhoneHelper => 'మేము SMS ద్వారా వన్-టైమ్ కోడ్ పంపుతాము';

  @override
  String get authGetOtp => 'OTP పొందు';

  @override
  String get authOtpTitle => '6-అంకెల కోడ్ నమోదు చేయండి';

  @override
  String authOtpSentTo(String phone) {
    return '$phone కు పంపబడింది';
  }

  @override
  String get authOtpResend => 'కోడ్ మళ్ళీ పంపు';

  @override
  String authOtpResendIn(int seconds) {
    return '$seconds సెకన్లలో మళ్ళీ పంపు';
  }

  @override
  String get authVerify => 'ధృవీకరించు';

  @override
  String get authChangeNumber => 'నంబర్ మార్చు';

  @override
  String get authInvalidPhone => 'సరైన మొబైల్ నంబర్ నమోదు చేయండి';

  @override
  String get authInvalidOtp => '6-అంకెల కోడ్ నమోదు చేయండి';

  @override
  String get authWrongApp =>
      'ఈ నంబర్ జ్యోతిష్యుల యాప్ కోసం రిజిస్టర్ చేయబడింది';

  @override
  String authDevCode(String code) {
    return 'దేవ్ కోడ్: $code';
  }

  @override
  String get authTermsNotice =>
      'కొనసాగించడం ద్వారా మీరు మా నిబంధనలు మరియు గోప్యతా విధానానికి అంగీకరిస్తున్నారు';

  @override
  String get authLogout => 'లాగ్ అవుట్';

  @override
  String get authLogoutConfirm =>
      'TalkAcharya నుండి లాగ్ అవుట్ చేయాలా? మీరు మళ్ళీ సైన్ ఇన్ చేయాల్సి ఉంటుంది.';

  @override
  String homeGreeting(String name) {
    return 'నమస్తే, $name';
  }

  @override
  String get homeGuidanceTagline => 'మీకు అవసరమైనప్పుడు మార్గదర్శనం';

  @override
  String get homeGreetingFallbackName => 'అక్కడ';

  @override
  String get walletAddShort => 'జత చేయి';

  @override
  String get homeChatNow => 'ఇప్పుడే చాట్ చేయి';

  @override
  String get homeCallNow => 'ఇప్పుడే కాల్ చేయి';

  @override
  String homeFromPerMin(String price) {
    return '$price/నిమిషం నుండి';
  }

  @override
  String homeOnlineCount(int count) {
    return '$count మంది ఆన్‌లైన్‌లో ఉన్నారు';
  }

  @override
  String get homeOnlineNow => 'ఇప్పుడు ఆన్‌లైన్‌లో';

  @override
  String get homeTalkToAstrologer => 'జ్యోతిష్యుడితో మాట్లాడండి';

  @override
  String get homeLiveNow => 'ఇప్పుడు లైవ్';

  @override
  String get homeWhatsOnYourMind => 'మీ మనసులో ఏముంది?';

  @override
  String get homeTodaysHoroscope => 'ఈరోజు రాశిఫలం';

  @override
  String get homeChooseYourSign => 'మీ రాశిని ఎంచుకోండి';

  @override
  String get homeReadMore => 'మరింత చదువు';

  @override
  String get homeShowLess => 'తక్కువగా చూడు';

  @override
  String homeLuckToday(String rating) {
    return 'ఈరోజు అదృష్టం · $rating';
  }

  @override
  String get homeTodaysPanchang => 'ఈరోజు పంచాంగం';

  @override
  String get homePanchangAddProfile =>
      'మీ ప్రాంతానికి అనుగుణంగా పంచాంగం పొందడానికి పుట్టిన వివరాలను జత చేయండి';

  @override
  String get homeFreeTools => 'ఉచిత సాధనాలు';

  @override
  String get homeTalkAgain => 'మళ్ళీ మాట్లాడండి';

  @override
  String get homeAddMoneyGetBonus => 'డబ్బు జత చేయండి, బోనస్ పొందండి';

  @override
  String get homeReferAFriend =>
      'స్నేహితుడిని రిఫర్ చేయండి, ఇద్దరూ సంపాదించండి';

  @override
  String get homeReferShort =>
      'మీ కోడ్‌ను షేర్ చేయండి — మీ ఇద్దరికీ వాలెట్ క్రెడిట్ లభిస్తుంది';

  @override
  String homeReferYourCode(String code) {
    return 'మీ కోడ్: $code';
  }

  @override
  String get homeInvite => 'ఆహ్వానించు';

  @override
  String homeResumeInProgress(String channel) {
    return '$channel · కొనసాగుతోంది';
  }

  @override
  String homeResumePaused(String channel) {
    return '$channel · నిలిపివేయబడింది';
  }

  @override
  String get homeResume => 'తిరిగి ప్రారంభించు';

  @override
  String get homeTrustVerified =>
      'ప్రతి జ్యోతిష్యుడు లైవ్ వెళ్లే ముందు ఐడి-వెరిఫై చేయబడతారు';

  @override
  String get homeTrustPrivate => '100% ప్రైవేట్ మరియు గోప్యమైన సంప్రదింపులు';

  @override
  String get homeTrustVolume => 'ప్రతి వారం వేల సంఖ్యలో సంప్రదింపులు';

  @override
  String get homeCouldntLoadAstrologers => 'జ్యోతిష్యులను లోడ్ చేయలేకపోయాము';

  @override
  String get homeCouldntLoadReading => 'ఈరోజు రాశిఫలం పొందలేకపోయాము';

  @override
  String get homeCouldntLoadPanchang => 'పంచాంగం లోడ్ చేయలేకపోయాము';

  @override
  String get homeNoAstrologersFilter =>
      'ప్రస్తుతం ఈ ఫిల్టర్‌కు సరిపోయే జ్యోతిష్యులు ఎవరూ లేరు';

  @override
  String get concernLove => 'ప్రేమ';

  @override
  String get concernMarriage => 'వివాహం';

  @override
  String get concernCareer => 'కెరీర్';

  @override
  String get concernFinance => 'ఆర్థికం';

  @override
  String get concernHealth => 'ఆరోగ్యం';

  @override
  String get concernEducation => 'విద్య';

  @override
  String get concernBusiness => 'వ్యాపారం';

  @override
  String get concernLegal => 'చట్టపరమైన';

  @override
  String get channelChat => 'చాట్';

  @override
  String get channelCall => 'కాల్';

  @override
  String get channelVoice => 'వాయిస్ కాల్';

  @override
  String get channelVideo => 'వీడియో కాల్';

  @override
  String get channelAll => 'అన్నీ';

  @override
  String get astroFilterAll => 'అన్నీ';

  @override
  String get astroSortRecommended => 'సిఫార్సు చేయబడినవి';

  @override
  String get astroSortTopRated => 'టాప్ రేటెడ్';

  @override
  String get astroSortExperienced => 'అత్యంత అనుభవజ్ఞులు';

  @override
  String get astroSortConsulted => 'ఎక్కువ మంది సంప్రదించిన వారు';

  @override
  String get astroSortNew => 'కొత్త వారు';

  @override
  String get astroOnline => 'ఆన్‌లైన్';

  @override
  String get astroBusy => 'బిజీగా ఉన్నారు';

  @override
  String get astroNotifyMe => 'నాకు తెలియజేయండి';

  @override
  String astroWaitMinutes(int count) {
    return '~$count నిమి వేచి ఉండాలి';
  }

  @override
  String astroPerMinute(String price) {
    return '$price/నిమిషం';
  }

  @override
  String astroYearsExp(int count) {
    return '$count ఏళ్ళ అనుభవం';
  }

  @override
  String get astroRatingNew => 'కొత్తది';

  @override
  String astroSessionsCount(String count) {
    return '$count సెషన్లు';
  }

  @override
  String get astroSearchHint => 'పేరు, నైపుణ్యం లేదా భాష ద్వారా వెతకండి';

  @override
  String get astroNoneFound => 'జ్యోతిష్యులు ఎవరూ దొరకలేదు';

  @override
  String get astroNoneFoundHint =>
      'ఫిల్టర్‌ను తొలగించి లేదా మరొకటి వెతికి ప్రయత్నించండి';

  @override
  String get astroThatsEveryone => 'ప్రస్తుతానికి ఇంతే';

  @override
  String get astroRateOnRequest => 'అభ్యర్థనపై రేటు';

  @override
  String get astroCouldntLoad => 'జ్యోతిష్యులను లోడ్ చేయలేకపోయారు';

  @override
  String get astroSortBy => 'క్రమబద్ధీకరించు';

  @override
  String get astroLoadMoreFailed => 'మరిన్ని లోడ్ చేయలేకపోయింది';

  @override
  String get astroDefaultSkill => 'వేద జ్యోతిష్యం';

  @override
  String astroYears(int count) {
    return '$count సంవత్సరాలు';
  }

  @override
  String astroSessions(String count) {
    return '$count సెషన్‌లు';
  }

  @override
  String get astroChat => 'చాట్';

  @override
  String get astroCall => 'కాల్';

  @override
  String get astroVideo => 'వీడియో';

  @override
  String get astroProfileTitle => 'జ్యోతిష్యుడు';

  @override
  String get astroExpertiseTitle => 'Expertise';

  @override
  String get astroAboutTitle => 'గురించి';

  @override
  String get astroRatesTitle => 'సంప్రదింపుల ధరలు';

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
  String get astroStatRating => 'రేటింగ్';

  @override
  String get astroStatExperience => 'అనుభవం';

  @override
  String get astroStatSessions => 'సెషన్‌లు';

  @override
  String get astroStatRepeatClients => 'పునరావృత క్లయింట్లు';

  @override
  String astroSpeaks(String languages) {
    return '$languages మాట్లాడతారు';
  }

  @override
  String astroRepliesIn(String time) {
    return 'ప్రత్యుత్తరాలు ~ $time లో';
  }

  @override
  String get astroOnlineNow => 'ఇప్పుడు ఆన్‌లైన్‌లో';

  @override
  String get astroOfflineTitle => 'ప్రస్తుతం ఆఫ్‌లైన్‌లో ఉన్నారు';

  @override
  String get astroNotifyWhenOnline => 'ఆన్‌లైన్‌లో ఉన్నప్పుడు నాకు తెలియజేయండి';

  @override
  String get astroReadMore => 'మరింత చదవండి';

  @override
  String get astroReadLess => 'తక్కువ చూపించు';

  @override
  String get astroCouldntLoadOne => 'ఈ జ్యోతిష్యుడిని లోడ్ చేయలేకపోయాను';

  @override
  String get astroCallsComingSoon =>
      'వాయిస్ మరియు వీడియో కాల్స్ త్వరలో రానున్నాయి';

  @override
  String get astroTrustLine =>
      'గుర్తింపు ధృవీకరించబడింది · గోప్యమైనది & రహస్యమైనది · నిమిషానికి చెల్లించండి';

  @override
  String get walletTitle => 'వాలెట్';

  @override
  String get walletAvailableBalance => 'అందుబాటులో ఉన్న బ్యాలెన్స్';

  @override
  String walletOnHold(String amount) {
    return '$amount హోల్డ్‌లో ఉంది';
  }

  @override
  String walletOnHoldReason(String amount) {
    return '$amount హోల్డ్‌లో ఉంది · కాల్ జరుగుతోంది';
  }

  @override
  String get walletAddMoney => 'డబ్బు జత చేయండి';

  @override
  String get walletRecentActivity => 'ఇటీవలి కార్యకలాపాలు';

  @override
  String get walletTransactions => 'లావాదేవీలు';

  @override
  String get walletHowItWorksTitle => 'వాలెట్ ఎలా పనిచేస్తుంది';

  @override
  String get walletHowItWorksBody =>
      'వాలెట్ బ్యాలెన్స్ కేవలం సంప్రదింపుల కోసం మాత్రమే ఉపయోగించబడుతుంది మరియు ఎప్పటికీ గడువు ముగియదు. ఉపయోగించని బ్యాలెన్స్ తిరిగి పొందవచ్చు — మా రిఫండ్ విధానాన్ని చూడండి.';

  @override
  String get walletRefundPolicy => 'రిఫండ్ విధానం';

  @override
  String get walletHaveCoupon => 'కూపన్ కోడ్ ఉందా?';

  @override
  String get walletCouponHint => 'కోడ్ నమోదు చేయండి';

  @override
  String walletCouponApplied(String amount) {
    return '$amount మీ వాలెట్‌కు జత చేయబడింది';
  }

  @override
  String get walletSecuredBy =>
      'Razorpay · UPI · కార్డ్స్ · నెట్ బ్యాంకింగ్ ద్వారా సురక్షితం';

  @override
  String get walletGstInvoices => 'GST ఇన్‌వాయిస్‌లు';

  @override
  String get walletInvoicesSubtitle =>
      'మీ రీఛార్జ్‌ల ఇన్‌వాయిస్‌లు మరియు రసీదులు';

  @override
  String get walletNoTransactions => 'ఇంకా లావాదేవీలు లేవు';

  @override
  String get walletNoTransactionsHint =>
      'ప్రారంభించడానికి మీ వాలెట్‌కు డబ్బు జత చేయండి';

  @override
  String walletBalanceAfter(String amount) {
    return 'బ్యాలెన్స్ $amount';
  }

  @override
  String get walletFilterAll => 'అన్నీ';

  @override
  String get walletFilterRecharge => 'జత చేసినవి';

  @override
  String get walletFilterConsultation => 'సంప్రదింపులు';

  @override
  String get walletFilterRefund => 'రిఫండ్‌లు';

  @override
  String get walletFilterBonus => 'బోనస్';

  @override
  String get kindRecharge => 'డబ్బు జత చేయబడింది';

  @override
  String get kindConsultationCharge => 'సంప్రదింపులు';

  @override
  String get kindConsultationRefund => 'రిఫండ్';

  @override
  String get kindPromoCredit => 'ప్రోమో క్రెడిట్';

  @override
  String get kindCouponDiscount => 'కూపన్ డిస్కౌంట్';

  @override
  String get kindSignupBonus => 'సైన్అప్ బోనస్';

  @override
  String get kindReferralBonus => 'రిఫరల్ బోనస్';

  @override
  String get kindAdjustment => 'సర్దుబాటు';

  @override
  String get kindGiftSpend => 'గిఫ్ట్ పంపబడింది';

  @override
  String get kindHold => 'కాల్ కోసం రిజర్వ్ చేయబడింది';

  @override
  String get kindChargeback => 'చార్జ్‌బ్యాక్';

  @override
  String get rechargeChooseAmount => 'వాలెట్‌కు డబ్బు జత చేయండి';

  @override
  String get rechargeAmountLabel => 'మొత్తం';

  @override
  String rechargePayAmount(String amount) {
    return '$amount చెల్లించండి';
  }

  @override
  String get rechargeAddCoupon => 'కూపన్ కోడ్ జత చేయండి';

  @override
  String rechargeBonusBadge(String amount) {
    return '+$amount';
  }

  @override
  String get rechargeStarterPack => 'స్టార్టర్';

  @override
  String rechargeMinAmount(String amount) {
    return 'కనిష్టంగా $amount';
  }

  @override
  String rechargeMaxAmount(String amount) {
    return 'గరిష్టంగా $amount';
  }

  @override
  String get rechargeOpeningCheckout => 'సురక్షిత చెక్అవుట్ తెరుచుకుంటోంది…';

  @override
  String get rechargeConfirming =>
      'చెల్లింపు అందింది — మీ బ్యాలెన్స్ అప్‌డేట్ చేస్తున్నాము…';

  @override
  String rechargeSuccessTitle(String amount) {
    return '$amount జత చేయబడింది';
  }

  @override
  String rechargeNewBalance(String amount) {
    return 'కొత్త బ్యాలెన్స్ $amount';
  }

  @override
  String get rechargeViewTransaction => 'లావాదేవీ చూడు';

  @override
  String get rechargeFailedTitle => 'చెల్లింపు విఫలమైంది';

  @override
  String get rechargeNotCharged =>
      'మీ వద్ద నుండి ఎటువంటి ఛార్జీ వసూలు చేయబడలేదు.';

  @override
  String get rechargeAutoRefund =>
      'ఏదైనా మొత్తం డెబిట్ అయితే, అది 3-5 పని దినాలలో రిఫండ్ చేయబడుతుంది.';

  @override
  String get rechargeTryAgain => 'మళ్ళీ ప్రయత్నించు';

  @override
  String get rechargeChangeAmount => 'మొత్తం మార్చు';

  @override
  String get rechargeCreditedSoon =>
      'చెల్లింపు అందింది. మేము కాసేపట్లో మీ వాలెట్‌లో క్రెడిట్ చేస్తాము.';

  @override
  String rechargeOfferAutoApplied(String amount, String bonus) {
    return '$amount జత చేయండి, $bonus అదనంగా పొందండి — ఆటో-అప్లై అయింది';
  }

  @override
  String get profileTitle => 'ప్రొఫైల్';

  @override
  String get profileEditProfile => 'ప్రొఫైల్ సవరించు';

  @override
  String profilePhoneMasked(String last4) {
    return '+91 ●●●●● $last4';
  }

  @override
  String get profileCompleteAddEmail =>
      'మీ ప్రొఫైల్ పూర్తి చేయడానికి ఈమెయిల్ జత చేయండి';

  @override
  String get profileCompleteAddBirth =>
      'వ్యక్తిగత రాశిఫలాల కోసం మీ పుట్టిన వివరాలను జత చేయండి';

  @override
  String get profileRoleCustomer => 'కస్టమర్';

  @override
  String get profileWallet => 'వాలెట్';

  @override
  String get profileBirthProfiles => 'పుట్టిన వివరాలు';

  @override
  String profileBirthProfilesCount(int count) {
    return '$count చార్టులు';
  }

  @override
  String get profileGroupAccount => 'ఖాతా';

  @override
  String get profileGroupMoney => 'డబ్బు';

  @override
  String get profileGroupPreferences => 'ప్రాధాన్యతలు';

  @override
  String get profileGroupSupport => 'మద్దతు';

  @override
  String get profileGroupLegal => 'చట్టపరమైన';

  @override
  String get profileNotifications => 'నోటిఫికేషన్లు';

  @override
  String get profileNotificationPrefs => 'నోటిఫికేషన్ ప్రాధాన్యతలు';

  @override
  String get profileHapticFeedback => 'హాప్టిక్ ఫీడ్‌బ్యాక్';

  @override
  String get profileHapticFeedbackDesc =>
      'బటన్లు మరియు పరస్పర చర్యలపై వైబ్రేట్ చేయండి';

  @override
  String get profileWalletAndTransactions => 'వాలెట్ మరియు లావాదేవీలు';

  @override
  String get profileOrders => 'Orders';

  @override
  String profileOrdersUnread(int count) {
    return '$count new';
  }

  @override
  String get profileReferAndEarn => 'రిఫర్ చేయండి మరియు సంపాదించండి';

  @override
  String get profileLanguage => 'భాష';

  @override
  String get profileCurrency => 'కరెన్సీ';

  @override
  String get profileHelpCentre => 'సహాయ కేంద్రం';

  @override
  String get profileContactWhatsapp => 'మమ్మల్ని WhatsApp లో సంప్రదించండి';

  @override
  String get profileRateApp => 'TalkAcharya కు రేటింగ్ ఇవ్వండి';

  @override
  String get profileShareApp => 'యాప్ షేర్ చేయండి';

  @override
  String profileShareMessage(String link) {
    return 'నేను జ్యోతిష్యులతో మాట్లాడటానికి TalkAcharya ఉపయోగిస్తున్నాను. మీరు కూడా ప్రయత్నించండి: $link';
  }

  @override
  String get profileTerms => 'సేవా నిబంధనలు';

  @override
  String get profilePrivacy => 'గోప్యతా విధానం';

  @override
  String get profileLicenses => 'ఓపెన్ సోర్స్ లైసెన్స్‌లు';

  @override
  String get profileDeleteAccount => 'ఖాతా తొలగించు';

  @override
  String profileVersion(String version, String build) {
    return 'TalkAcharya · v$version ($build)';
  }

  @override
  String get editFullName => 'పూర్తి పేరు';

  @override
  String get editDisplayName => 'డిస్ప్లే పేరు';

  @override
  String get editDateOfBirth => 'పుట్టిన తేదీ';

  @override
  String get editGender => 'లింగం';

  @override
  String get editGenderMale => 'పురుషుడు';

  @override
  String get editGenderFemale => 'స్త్రీ';

  @override
  String get editGenderOther => 'ఇతర';

  @override
  String get editEmail => 'ఈమెయిల్';

  @override
  String get editEmailUnverified => 'ధృవీకరించబడలేదు';

  @override
  String get editChangePhoto => 'ఫోటో మార్చు';

  @override
  String get editProfileSaved => 'ప్రొఫైల్ అప్‌డేట్ అయింది';

  @override
  String get editProfileSaveError => 'మీ మార్పులను సేవ్ చేయలేకపోయాము';

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
  String get editCountry => 'దేశం';

  @override
  String get chooseLanguage => 'భాష ఎంచుకోండి';

  @override
  String get chooseCurrency => 'కరెన్సీ ఎంచుకోండి';

  @override
  String get deleteAccountTitle => 'మీ ఖాతా తొలగించండి';

  @override
  String get deleteAccountBody =>
      'ఇది మీ ప్రొఫైల్, పుట్టిన చార్టులు మరియు చాట్ చరిత్రను శాశ్వతంగా తొలగిస్తుంది. మీ వాలెట్ బ్యాలెన్స్ ఏదైనా ఉంటే, అది అసలు చెల్లింపు పద్ధతికి రిఫండ్ చేయబడుతుంది. చట్టం ప్రకారం సంప్రదింపుల రికార్డులు ఉంచబడతాయి.';

  @override
  String get deleteAccountHold =>
      'మీ ఖాతా వెంటనే నిష్క్రియం చేయబడుతుంది మరియు 30 రోజుల తర్వాత పూర్తిగా తొలగించబడుతుంది. రద్దు చేయడానికి 30 రోజులలోపు మళ్ళీ సైన్ ఇన్ చేయండి.';

  @override
  String get deleteAccountConfirm => 'అవును, నా ఖాతా తొలగించు';

  @override
  String get deleteAccountRequested => 'ఖాతా తొలగింపు అభ్యర్థించబడింది';

  @override
  String get referTitle => 'రిఫర్ చేయండి మరియు సంపాదించండి';

  @override
  String referHeroTitle(String friendAmount, String youAmount) {
    return '$friendAmount ఇవ్వండి, $youAmount పొందండి';
  }

  @override
  String referHeroBody(String friendAmount, String youAmount) {
    return 'మీ స్నేహితుడికి వారి మొదటి సంప్రదింపుపై $friendAmount తగ్గింపు లభిస్తుంది. వారు దాన్ని తీసుకున్నప్పుడు మీకు మీ వాలెట్‌లో $youAmount లభిస్తుంది.';
  }

  @override
  String get referYourCode => 'మీ రిఫరల్ కోడ్';

  @override
  String get referShareLink => 'ఆహ్వాన లింక్ షేర్ చేయండి';

  @override
  String get referInvited => 'ఆహ్వానించబడిన వారు';

  @override
  String get referJoined => 'చేరిన వారు';

  @override
  String get referEarned => 'సంపాదించినది';

  @override
  String get referHowItWorks => 'ఇది ఎలా పనిచేస్తుంది';

  @override
  String get referStep1 =>
      'మీ కోడ్ లేదా లింక్ షేర్ చేయండి. మీ స్నేహితుడు సైన్ అప్ చేసేటప్పుడు దాన్ని నమోదు చేస్తారు.';

  @override
  String referStep2(String amount) {
    return 'వారి మొదటి పెయిడ్ సంప్రదింపుపై వారికి $amount తగ్గింపు లభిస్తుంది.';
  }

  @override
  String referStep3(String amount) {
    return 'ఆ సంప్రదింపు బిల్ అయిన వెంటనే, $amount మీ వాలెట్‌లో చేరుతుంది.';
  }

  @override
  String get referYourReferrals => 'మీ రిఫరల్స్';

  @override
  String get referStatusPending => 'పెండింగ్‌లో ఉంది';

  @override
  String get referStatusJoined => 'చేరిన వారు';

  @override
  String get referStatusRewarded => 'బహుమతి పొందిన వారు';

  @override
  String referJoinedOn(String date) {
    return '$date న చేరారు';
  }

  @override
  String get referFirstCallDone => 'మొదటి కాల్ పూర్తయింది';

  @override
  String referShareText(String code, String amount, String link) {
    return 'TalkAcharya లో నా కోడ్ $code ఉపయోగించండి మరియు మీ మొదటి జ్యోతిష్య సంప్రదింపుపై $amount తగ్గింపు పొందండి. $link';
  }

  @override
  String get kundaliYogasDoshasTitle => 'యోగాలు & దోషాలు';

  @override
  String get kundaliTabDoshas => 'దోషాలు';

  @override
  String get kundaliTabYogas => 'యోగాలు';

  @override
  String get doshaIntro =>
      'దోషాలు అనేవి జాతకంలోని సున్నితమైన అంశాలు. కాలక్రమేణా, ఒక అనుకూలమైన దశ ద్వారా, లేదా ఒక సాంప్రదాయిక పరిహారం ద్వారా చాలా వరకు ఇవి తగ్గుతాయి — మీకు వాస్తవంగా ఏది ముఖ్యమో జ్యోతిష్యుడు నిర్ధారిస్తాడు.';

  @override
  String get doshaDisclaimer =>
      'ఇవి కేవలం నిర్మాణాత్మక సూచనలు మాత్రమే, భవిష్యవాణి కాదు. రత్నం ధరించే ముందు లేదా ఏదైనా గంభీరమైన పరిహారం ప్రారంభించే ముందు జ్యోతిష్యునితో మాట్లాడండి.';

  @override
  String get doshaPresent => 'ప్రస్తుతం';

  @override
  String get doshaNotPresent => 'హాజరు కాలేదు';

  @override
  String get doshaCancelled => 'వాస్తవంగా రద్దు చేయబడింది';

  @override
  String get doshaSeverityClear => 'స్పష్టం';

  @override
  String get doshaSeverityMild => 'తేలికపాటి';

  @override
  String get doshaSeverityModerate => 'మితమైన';

  @override
  String get doshaSeverityStrong => 'బలమైన';

  @override
  String get doshaWhy => 'ఎందుకు ఫ్లాగ్ చేయబడింది';

  @override
  String get doshaWhatReduces => 'దాన్ని తగ్గించేది ఏమిటి';

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
  String get doshaClearSectionTitle => 'స్పష్టం — మీ చార్టులో లేదు';

  @override
  String get doshaAllClear => 'మీ జాతకంలో సాధారణ దోషాలు ఏవీ లేవు.';

  @override
  String get doshaAskCta => 'మీకు దీని అర్థం ఏమిటో జ్యోతిష్యుడిని అడగండి.';

  @override
  String get insightsTitle => 'వ్యక్తిత్వం మరియు జీవిత అవలోకనం';

  @override
  String get insightsIntro =>
      'మీ జన్మ (D1) చార్ట్ యొక్క ఉచిత విశ్లేషణ — జీవితంలోని ప్రధాన రంగాలలో అది ఏ ధోరణుల వైపు మొగ్గు చూపుతుందో తెలియజేస్తుంది. ఇది ఆత్మపరిశీలన కోసం ఒక రూపురేఖ మాత్రమే, అంతేగానీ సంఘటనలు లేదా తేదీల గురించిన సూచన కాదు.';

  @override
  String get insightsDisclaimer =>
      'మీ జాతకం నుండి సాధారణ మార్గదర్శనం మాత్రమే, భవిష్యవాణి కాదు. ఇది తేదీలను పేర్కొనదు మరియు ఆరోగ్యం, ఆయుర్దాయం లేదా సంబంధాల గురించి ఎలాంటి హామీలు ఇవ్వదు. ఏదైనా నిర్దిష్ట విషయం కోసం, జ్యోతిష్యుడిని సంప్రదించండి.';

  @override
  String get insightsAskCta => 'మీ జాతకం గురించి జ్యోతిష్యుడిని అడగండి';

  @override
  String get insightsWhatItReadsFrom => 'ఇది దేని నుండి చదవబడుతుంది';

  @override
  String get insightsToneSupportive => 'సహాయక';

  @override
  String get insightsToneBalanced => 'సమతుల్యమైన';

  @override
  String get insightsToneChallenging => 'సంరక్షణ అవసరం';

  @override
  String get insightsToneMixed => 'మిశ్రమ';

  @override
  String get insightsAreaPersonality => 'వ్యక్తిత్వం & స్వభావం';

  @override
  String get insightsAreaAppearance => 'శారీరక స్వరూపం';

  @override
  String get insightsAreaMind => 'మనస్సు మరియు భావోద్వేగాలు';

  @override
  String get insightsAreaCareer => 'కెరీర్ & వృత్తి';

  @override
  String get insightsAreaWealth => 'సంపద మరియు ఆర్థిక వ్యవహారాలు';

  @override
  String get insightsAreaEducation => 'విద్య మరియు మేధస్సు';

  @override
  String get insightsAreaMarriage => 'వివాహం & జీవిత భాగస్వామి';

  @override
  String get insightsAreaFamily => 'కుటుంబం మరియు సంబంధాలు';

  @override
  String get insightsAreaHealth => 'ఆరోగ్యం & జీవశక్తి';

  @override
  String get insightsAreaFortune => 'అదృష్టం & ధర్మం';

  @override
  String get insightsAreaStrengths => 'బలాలు మరియు సవాళ్లు';

  @override
  String get predTitle => 'అంచనాలు';

  @override
  String get predReadingTitle => 'మీ అంచనా';

  @override
  String get predRequestTitle => 'వాతావరణ సూచనను అభ్యర్థించండి';

  @override
  String get predHeroTitle => 'మీ కోసం వ్రాసిన అంచనా';

  @override
  String get predHeroBody =>
      'ఒక జ్యోతిష్యుడు మీ జన్మ చార్ట్, దశ మరియు ప్రస్తుత గోచారాలను పరిశీలించి, జీవితంలోని ఒక రంగానికి సంబంధించిన భవిష్యవాణిని రాస్తారు. ఇది సాధారణంగా 3 రోజుల్లోగా, మీరు కోరుకున్న భాషలో అందించబడుతుంది.';

  @override
  String get predChooseArea => 'ఒక ప్రాంతాన్ని ఎంచుకోండి';

  @override
  String get predMyReadings => 'మీ అంచనాలు';

  @override
  String get predNoReadings =>
      'ఇంకా అంచనాలు లేవు. అంచనాను అభ్యర్థించడానికి పైన ఒక ప్రాంతాన్ని ఎంచుకోండి.';

  @override
  String get predSeePacks => 'ప్యాక్‌లను చూడండి';

  @override
  String get predSubscribed => 'సభ్యత్వం పొందారు';

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
  String get predBuyTitle => 'అంచనా క్రెడిట్‌లు';

  @override
  String get predBuyBody =>
      'ఒక క్రెడిట్ అంటే ఒక రాతపూర్వక సూచన. ఒక ప్యాక్ కొనుగోలు చేస్తే, మీకు రీడింగ్ కావలసినప్పుడల్లా అది సిద్ధంగా ఉంటుంది.';

  @override
  String get predBuyWalletNote =>
      'మీ వాలెట్ బ్యాలెన్స్ నుండి చెల్లించబడుతుంది.';

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
    return 'ప్రతి క్రెడిట్‌కు $price';
  }

  @override
  String predBuySuccess(int count) {
    return 'జోడించబడింది. మీకు ఇప్పుడు $count క్రెడిట్‌లు ఉన్నాయి.';
  }

  @override
  String get predForProfile => 'ఏ జనన ప్రొఫైల్ కోసం';

  @override
  String get predAddProfile => 'జనన ప్రొఫైల్‌ను జోడించండి';

  @override
  String get predPickProfile => 'ముందుగా జనన ప్రొఫైల్‌ను ఎంచుకోండి.';

  @override
  String get predArea => 'జీవిత రంగం';

  @override
  String get predPeriod => 'కాలం';

  @override
  String predCostsOne(int count) {
    return 'మీ $count క్రెడిట్‌లలో 1ని ఉపయోగిస్తుంది.';
  }

  @override
  String get predNoCreditYet =>
      'మీకు క్రెడిట్ అవసరం అవుతుంది — మేము ప్యాక్‌లను తర్వాత చూపిస్తాము.';

  @override
  String get predRequestCta => 'వాతావరణ సూచనను అభ్యర్థించండి';

  @override
  String get predRequestDisclaimer =>
      'జ్యోతిష్కుడు మీ జాతకం, దశ మరియు గోచారాల ఆధారంగా జాతకం రాస్తాడు. జ్యోతిష్యం అనేది ఆలోచనకు, ప్రణాళికకు ఒక మార్గదర్శనం మాత్రమే, హామీ కాదు.';

  @override
  String get predAreaCareer => 'కెరీర్ & పని';

  @override
  String get predAreaMarriage => 'వివాహం మరియు ప్రేమ';

  @override
  String get predAreaFinance => 'డబ్బు మరియు ఆర్థికం';

  @override
  String get predAreaHealth => 'ఆరోగ్యం & శక్తి';

  @override
  String get predAreaEducation => 'అధ్యయనం మరియు అభ్యాసం';

  @override
  String get predAreaGeneral => 'జీవిత అవలోకనం';

  @override
  String get predPeriodMonth => 'రాబోయే నెల';

  @override
  String get predPeriodQuarter => 'తదుపరి 3 నెలలు';

  @override
  String get predPeriodYear => 'రాబోయే సంవత్సరం';

  @override
  String get predStatusWriting => 'వ్రాయబడుతోంది';

  @override
  String get predStatusReview => 'సమీక్షలో';

  @override
  String get predStatusReady => 'చదవడానికి సిద్ధంగా ఉంది';

  @override
  String get predStatusUnavailable => 'అందుబాటులో లేదు';

  @override
  String get predStatusRefunded => 'వాపసు చేయబడింది';

  @override
  String predDeliveredOn(String date) {
    return 'పంపిణీ చేయబడింది $date';
  }

  @override
  String predEta(String date) {
    return '$date నాటికి ఆశించబడుతోంది';
  }

  @override
  String get predWritingTitle => 'ఒక జ్యోతిష్కుడు ఇది వ్రాస్తున్నాడు';

  @override
  String get predWritingBody =>
      'అది సిద్ధమైన వెంటనే మేము మీకు నోటిఫికేషన్ పంపుతాము.';

  @override
  String predWritingEta(String date) {
    return '$date నాటికి అందుతుందని ఆశిస్తున్నాము. సిద్ధమైనప్పుడు మీకు తెలియజేస్తాము.';
  }

  @override
  String get predRefundedTitle => 'క్రెడిట్ వాపసు చేయబడింది';

  @override
  String get predRefundedBody =>
      'మేము దీనిని సమయానికి అందించలేకపోయాము, కాబట్టి మీ క్రెడిట్ మీ ఖాతాలోకి తిరిగి జమ చేయబడింది.';

  @override
  String get predDisclaimer =>
      'మీ జన్మ చార్ట్, దశ మరియు ప్రస్తుత గోచారాల ఆధారంగా ఒక జ్యోతిష్యుడు మీ కోసం దీనిని వ్రాసారు. జ్యోతిష్యం అనేది ఆత్మపరిశీలన మరియు ప్రణాళిక కోసం ఒక మార్గదర్శనం — ఎంపికలు మరియు ఫలితం మీవే.';

  @override
  String get predAskFollowUp => 'తదుపరి ప్రశ్న అడగండి';

  @override
  String get remediesTitle => 'నివారణలు';

  @override
  String get remediesIntro =>
      'మీ జాతకంలో ఉన్న క్రియాశీల దోషాలు, బలహీన గ్రహాలు, నడుస్తున్న దశ మరియు ఒత్తిడికి గురైన భావాలకు అనుగుణంగా ఉండే సాంప్రదాయ పరిహారాలు. అవి మీ విశ్వాసం, ఆరోగ్యం మరియు ఆర్థిక స్థోమతకు తగినట్లుగా ఎంచుకోబడిన క్రమశిక్షణ మరియు భక్తితో కూడిన చర్యలు.';

  @override
  String get remediesNone =>
      'మీ జాతకంలో ప్రస్తుతం ఒక నిర్దిష్ట పరిహారం అవసరమయ్యేలా ఏదీ ప్రత్యేకంగా కనిపించడం లేదు. ప్రతిరోజూ చిన్నగా, క్రమం తప్పకుండా సాధన చేయడం ఎల్లప్పుడూ ప్రయోజనకరమే.';

  @override
  String get remediesDisclaimer =>
      'మీ విశ్వాసానికి, ఆరోగ్యానికి, స్థోమతకు తగినది మాత్రమే చేయండి. ఉపవాసం మీకు సురక్షితం కాకపోతే దానిని మానుకోండి, మరియు దానధర్మాల కోసం ఎప్పుడూ రుణం తీసుకోకండి.';

  @override
  String get remediesAskCta => 'మీ పరిహారాల గురించి జ్యోతిష్యునితో మాట్లాడండి';

  @override
  String get remediesConfirmCta => 'ముందుగా జ్యోతిష్యునితో నిర్ధారించుకోండి';

  @override
  String remediesSource(String source) {
    return 'మూలం: $source';
  }

  @override
  String get doshaSeeRemedies => 'మీ చార్ట్ కోసం నివారణలను చూడండి';

  @override
  String get remedyCatMantra => 'మంత్రం & జపం';

  @override
  String get remedyCatStotra => 'స్తోత్రం మరియు పఠనం';

  @override
  String get remedyCatPuja => 'పూజ మరియు ఆచారాలు';

  @override
  String get remedyCatVrat => 'వ్రతం & ఉపవాసం';

  @override
  String get remedyCatDaan => 'దానం & స్వచ్ఛంద సంస్థ';

  @override
  String get remedyCatLifestyle => 'జీవనశైలి';

  @override
  String get remedyCatYantra => 'యంత్రం';

  @override
  String get remedyCatGemstone => 'రత్నం';

  @override
  String get remedyCatRudraksha => 'రుద్రాక్ష';

  @override
  String get prashnaTitle => 'ఒక ప్రశ్న అడగండి';

  @override
  String get prashnaHeroTitle => 'ఆ క్షణంలో అవునని లేదా కాదని చెప్పడం';

  @override
  String get prashnaHeroBody =>
      'KP హోరరీ (ప్రశ్న) మీరు ప్రశ్న అడిగిన కచ్చితమైన క్షణాన్ని చదివి, దానికి గల కారణంతో పాటు అవును, కాదు లేదా మిశ్రమంగా అనే ఒక మొగ్గును ఇస్తుంది. ఇది ఒక సాంప్రదాయ పద్ధతి యొక్క సూచిక మాత్రమే, హామీ కాదు.';

  @override
  String get prashnaAbout => 'ప్రశ్న దేని గురించి?';

  @override
  String get prashnaHint => 'ఉదాహరణకు: నాకు ఈ ఉద్యోగ ఆఫర్ వస్తుందా?';

  @override
  String prashnaAskCta(String price) {
    return 'అడగండి ( $price )';
  }

  @override
  String get prashnaDisclaimer =>
      'మీరు అడిగిన క్షణంలోని KP హోరరీ రీడింగ్ ఇది. ఇది ఒక సాంప్రదాయ పద్ధతి యొక్క సూచన మాత్రమే — హామీ కాదు, పూర్తి సంప్రదింపులకు ప్రత్యామ్నాయం కూడా కాదు.';

  @override
  String get prashnaNeedQuestion =>
      'ఒక అంశాన్ని ఎంచుకుని, ముందుగా మీ ప్రశ్నను టైప్ చేయండి.';

  @override
  String get prashnaLowBalance =>
      'మీ వాలెట్ బ్యాలెన్స్ చాలా తక్కువగా ఉంది. దయచేసి డబ్బు జోడించండి.';

  @override
  String get prashnaHistory => 'మీ ప్రశ్నలు';

  @override
  String get prashnaNoHistory => 'మీరు ఇంకా ప్రశ్న అడగలేదు.';

  @override
  String get prashnaAnswerTitle => 'చదవడం';

  @override
  String get prashnaAskAstrologer => 'జ్యోతిష్యుడితో మాట్లాడండి';

  @override
  String get prashnaHowRead => 'దీన్ని ఎలా చదివారు';

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
  String get prashnaVerdictYes => 'అవును అని మొగ్గు చూపుతున్నాను';

  @override
  String get prashnaVerdictNo => 'వంగడం లేదు';

  @override
  String get prashnaVerdictMixed => 'మిశ్రమ సంకేతాలు';

  @override
  String get prashnaVerdictUnclear => 'నిర్ణయాత్మకం కాదు';

  @override
  String get prashnaCatMarriage => 'వివాహం';

  @override
  String get prashnaCatJob => 'ఒక ఉద్యోగం';

  @override
  String get prashnaCatPromotion => 'ప్రమోషన్';

  @override
  String get prashnaCatBusiness => 'వ్యాపారం';

  @override
  String get prashnaCatProperty => 'ఆస్తి';

  @override
  String get prashnaCatMoney => 'రుణం లేదా డబ్బు';

  @override
  String get prashnaCatChild => 'పిల్లలు';

  @override
  String get prashnaCatTravel => 'విదేశీ ప్రయాణం';

  @override
  String get prashnaCatLitigation => 'కోర్టు వ్యవహారం';

  @override
  String get prashnaCatHealth => 'ఆరోగ్యం మరియు కోలుకోవడం';

  @override
  String get prashnaCatLost => 'పోగొట్టుకున్న వస్తువు';

  @override
  String get prashnaCatReunion => 'పునఃకలయిక';

  @override
  String get prashnaCatGeneral => 'వేరే విషయం';

  @override
  String get yogaIntro =>
      'యోగాలు అనేవి ప్రవృత్తులే కానీ హామీలు కావు — వాటిలో భాగమైన గ్రహాలు మంచి స్థానంలో ఉండి, తమ దశను నడుపుతున్నప్పుడు అవి బలపడతాయి.';

  @override
  String get yogaNoneTitle => 'శాస్త్రీయ యోగాలు ఏవీ కనుగొనబడలేదు';

  @override
  String get yogaNoneBody =>
      'అది సాధారణమే మరియు చెడ్డ సంకేతం కాదు — జాతకాన్ని ఇప్పటికీ దాని భావాలు మరియు దశల ద్వారానే చదువుతారు.';

  @override
  String get kundaliTalkToAstrologer => 'జ్యోతిష్యుడితో మాట్లాడండి';

  @override
  String get kundaliHowItPlaysOut =>
      'మీ జీవితంలో మరియు సమయానుసారంగా ఇవి ఎలా జరుగుతాయో తెలుసుకోవాలనుకుంటున్నారా?';

  @override
  String get yogaGajakesariName => 'గజకేసరి యోగా';

  @override
  String get yogaGajakesariMeaning =>
      'చంద్రుడి నుండి కేంద్రంలో బృహస్పతి — నిబ్బరం, మంచి విచక్షణ మరియు గౌరవప్రదమైన పేరు.';

  @override
  String get yogaBudhadityaName => 'బుధాదిత్య యోగా';

  @override
  String get yogaBudhadityaMeaning =>
      'సూర్యుడు, బుధుడు కలిసి ఉండటం — చురుకైన, భావవ్యక్తీకరణ గల మనస్సు; అధ్యయనం, రచన మరియు విశ్లేషణకు బలమైనది.';

  @override
  String get yogaChandraMangalaName => 'చంద్ర-మంగళ యోగం';

  @override
  String get yogaChandraMangalaMeaning =>
      'చంద్రుడు మరియు అంగారకుడు — డబ్బు మరియు వ్యాపారం విషయంలో చొరవ; కృషి మరియు చొరవతో సంపాదించడం.';

  @override
  String get yogaRajaName => 'రాజ యోగం';

  @override
  String get yogaRajaMeaning =>
      'కేంద్రాధిపతి త్రికోణాధిపతితో ముడిపడి ఉన్నప్పుడు — ఆ కాలం నడిచినప్పుడు హోదా, అధికారం మరియు అవకాశాలలో ఉన్నతి లభిస్తుంది.';

  @override
  String get yogaDhanaName => 'ధన యోగం';

  @override
  String get yogaDhanaMeaning =>
      'సంపద మరియు లాభాల గృహాలు అనుసంధానించబడి ఉంటాయి — ఇవి పొదుపు మరియు స్థిరమైన ఆర్థిక వృద్ధికి మద్దతు ఇస్తాయి.';

  @override
  String get yogaNeechabhangaName => 'నీచభంగ రాజ యోగం';

  @override
  String get yogaNeechabhangaMeaning =>
      'బలహీనత రద్దు చేయబడిన ఒక బలహీనమైన గ్రహం — ఆరంభంలో జరిగే పోరాటం బలంగా మారుతుంది.';

  @override
  String get yogaKaalSarpaName => 'కాల సర్ప యోగం';

  @override
  String get yogaKaalSarpaMeaning =>
      'రాహు-కేతు అక్షానికి ఒక వైపున ఏడు గ్రహాలూ ఉన్నప్పుడు — ఒక స్పష్టమైన దిశ దొరికే వరకు జీవితం కుంచించుకుపోయినట్లు అనిపించవచ్చు.';

  @override
  String get yogaAdhiName => 'అధి యోగా';

  @override
  String get yogaAdhiMeaning =>
      'చంద్రుని నుండి 6, 7, 8 స్థానాలలో శుభగ్రహాలు — రక్షణ, సమర్థులైన సహాయకులు మరియు స్థిరమైన స్థానం.';

  @override
  String get yogaShakataName => 'శకట యోగా';

  @override
  String get yogaShakataMeaning =>
      'బృహస్పతి నుండి 6వ, 8వ లేదా 12వ స్థానంలో చంద్రుడు ఉండటం — అదృష్టం హెచ్చుతగ్గులకు లోనవుతుంది; చంద్రుడు బలంగా ఉన్నప్పుడు మరింత స్థిరంగా ఉంటుంది.';

  @override
  String get yogaVishName => 'విష్ యోగా';

  @override
  String get yogaVishMeaning =>
      'చంద్రుడు శనితో ఉన్నప్పుడు — మనసుకు ప్రాధాన్యత ఉంటుంది; ఫలితాలు పరిపక్వతతో, ఆలస్యంగా వస్తాయి.';

  @override
  String get yogaKahalaName => 'కహల యోగా';

  @override
  String get yogaKahalaMeaning =>
      'బలమైన లగ్నాధిపతితో పాటు 4వ, 9వ అధిపతులు పరస్పర కేంద్రంలో ఉండటం — ధైర్యవంతులు, సాహసవంతులు, రిస్క్ తీసుకోవడానికి సిద్ధంగా ఉంటారు.';

  @override
  String get yogaPushkalaName => 'పుష్కల యోగా';

  @override
  String get yogaPushkalaMeaning =>
      'చంద్రుని అధిపతి లగ్నాధిపతితో కలిసి కేంద్రంలో ఉండటం — గౌరవం, మంచి పేరు మరియు ఒప్పించే వాక్చాతుర్యం.';

  @override
  String get yogaDaridraName => 'దరిద్ర యోగా';

  @override
  String get yogaDaridraMeaning =>
      'పదకొండవ (లాభాల) అధిపతి కష్టమైన ఇంట్లో పడితే — లాభాలు నెమ్మదిగా వస్తాయి; ఒక బలమైన దశ దానిని మార్చివేస్తుంది.';

  @override
  String get yogaAmalaName => 'అమల యోగా';

  @override
  String get yogaAmalaMeaning =>
      'లగ్నం లేదా చంద్రుని నుండి 10వ స్థానంలో శుభగ్రహం మాత్రమే ఉంటే — స్వచ్ఛమైన కీర్తి మరియు శాశ్వతమైన సద్భావన లభిస్తాయి.';

  @override
  String get yogaSaraswatiName => 'సరస్వతి యోగా';

  @override
  String get yogaSaraswatiMeaning =>
      'బుధుడు, శుక్రుడు మరియు బలమైన గురుడు మంచి స్థానంలో ఉన్నారు — విద్య, కళ మరియు వాక్చాతుర్యం.';

  @override
  String get yogaLakshmiName => 'లక్ష్మీ యోగా';

  @override
  String get yogaLakshmiMeaning =>
      'బలమైన లగ్నాధిపతితో కలిసి కేంద్రంలో లేదా త్రికోణంలో బలమైన 9వ అధిపతి ఉండటం — అదృష్టం, సౌకర్యం మరియు అనుగ్రహం.';

  @override
  String get yogaRuchakaName => 'రుచక యోగము';

  @override
  String get yogaRuchakaMeaning =>
      'కేంద్రంలో కుజుడు బలంగా ఉండటం — ధైర్యం, శారీరక శక్తి మరియు ఒత్తిడిలో నాయకత్వ లక్షణాలు.';

  @override
  String get yogaBhadraName => 'భద్ర యోగా';

  @override
  String get yogaBhadraMeaning =>
      'కేంద్రంలో బుధుడు బలంగా ఉండటం — తెలివితేటలు, స్పష్టమైన వాక్చాతుర్యం మరియు వ్యాపారం, సంభాషణలో నైపుణ్యం.';

  @override
  String get yogaHamsaName => 'హంస యోగా';

  @override
  String get yogaHamsaMeaning =>
      'కేంద్రంలో గురుడు బలంగా ఉండటం — జ్ఞానం, నీతి, బోధన లేదా సలహా ఇచ్చే స్వభావం మరియు సాధారణ అదృష్టం.';

  @override
  String get yogaMalavyaName => 'మాలవ్య యోగా';

  @override
  String get yogaMalavyaMeaning =>
      'కేంద్రంలో శుక్రుడు బలంగా ఉండటం — ఆకర్షణ, సౌకర్యం, సౌందర్య దృష్టి మరియు ఆహ్లాదకరమైన గృహ జీవితం.';

  @override
  String get yogaSasaName => 'సాసా యోగా';

  @override
  String get yogaSasaMeaning =>
      'కేంద్రంలో శని బలంగా ఉన్నప్పుడు — క్రమశిక్షణ, ఓర్పు మరియు అధికారం నెమ్మదిగా పెంపొందించబడి, నిలబెట్టుకోబడతాయి.';

  @override
  String get yogaUbhayachariName => 'ఉభయచారి యోగా';

  @override
  String get yogaUbhayachariMeaning =>
      'సూర్యునికి ఇరువైపులా గ్రహాలు ఉండటం — వాటికి చక్కగా మద్దతు లభించడం, అవి కంటికి కనిపించడం మరియు అన్ని విధాలా మంచి స్థితిలో ఉండటం.';

  @override
  String get yogaVesiName => 'వెసి యోగా';

  @override
  String get yogaVesiMeaning =>
      'సూర్యుడి నుండి రెండవ స్థానంలో గ్రహం — స్థిరమైన మాటతీరు, సమతుల్య దృక్పథం మరియు మంచి పేరు.';

  @override
  String get yogaVasiName => 'వాసి యోగా';

  @override
  String get yogaVasiMeaning =>
      'సూర్యుడి నుండి 12వ స్థానంలో గ్రహం — సామర్థ్యం, ప్రభావం మరియు ఉదార స్వభావం.';

  @override
  String get yogaShubhaKartariName => 'శుభా కర్తారి యోగా';

  @override
  String get yogaShubhaKartariMeaning =>
      'లగ్నానికి ఇరువైపులా ఉన్న శుభగ్రహాలు — రక్షణ, సులభమైన మార్గం మరియు అనుకూలమైన పరిస్థితులు.';

  @override
  String get yogaPapaKartariName => 'పాపా కర్తారి యోగా';

  @override
  String get yogaPapaKartariMeaning =>
      'లగ్నానికి ఇరువైపులా పాపగ్రహాలు — ఆత్మ మరియు ఆరోగ్యంపై ఒత్తిడి; మీ శక్తిని, హద్దులను కాపాడుకోండి.';

  @override
  String get yogaDurudharaName => 'దురుధర యోగా';

  @override
  String get yogaDurudharaMeaning =>
      '2వ మరియు 12వ స్థానాలలో చంద్రుడికి ఇరువైపులా గ్రహాలు ఉన్నాయి — మీకు వనరులు, సౌకర్యం మరియు స్థిరమైన మద్దతు లభిస్తాయి.';

  @override
  String get yogaSunaphaName => 'సునాఫా యోగా';

  @override
  String get yogaSunaphaMeaning =>
      'చంద్రుడి నుండి రెండవ స్థానంలో గ్రహం — స్వయంకృషి, తెలివితేటలు మరియు మంచి పేరు.';

  @override
  String get yogaAnaphaName => 'అనఫా యోగా';

  @override
  String get yogaAnaphaMeaning =>
      'చంద్రుడి నుండి 12వ స్థానంలో గ్రహం — సులువైన స్వభావం, శ్రేయస్సు మరియు కోరికల నుండి విముక్తి.';

  @override
  String get yogaKemadrumaYogaName => 'కెమద్రుమ యోగా';

  @override
  String get yogaKemadrumaYogaMeaning =>
      'చంద్రుడు ఒంటరిగా, ఎటువంటి ఆధారం లేకుండా ఉంటాడు — ఈ అంతర్గత అశాంతి, చంద్రుడు బలంగా ఉన్నప్పుడు లేదా ఒక కేంద్రం ఆక్రమించబడినప్పుడు తగ్గుతుంది.';

  @override
  String get yogaVasumatiName => 'వసుమతి యోగా';

  @override
  String get yogaVasumatiMeaning =>
      'లగ్నం లేదా చంద్రుని నుండి వృద్ధి స్థానాలలో శుభగ్రహాలు ఉండటం — సంపదను కూడబెట్టడం మరియు వనరులను పెంచడం.';

  @override
  String get yogaKalanidhiName => 'కలనిధి యోగా';

  @override
  String get yogaKalanidhiMeaning =>
      '2వ లేదా 5వ స్థానంలో ఉన్న బృహస్పతి, బుధుడు లేదా శుక్రుడితో కలిసి ఉంటే — విద్యాభ్యాసం, కళలు, సంస్కారం మరియు గౌరవం.';

  @override
  String get yogaChamaraName => 'చామర యోగా';

  @override
  String get yogaChamaraMeaning =>
      'కేంద్రంలో ఉన్న ఉచ్చ లగ్నాధిపతిని గురుడు చూడటం — వాక్చాతుర్యం, దీర్ఘాయువు మరియు గౌరవప్రదమైన స్థానం.';

  @override
  String get yogaShankhaName => 'శంఖ యోగా';

  @override
  String get yogaShankhaMeaning =>
      'బలమైన లగ్నాధిపతితో ముడిపడి ఉన్న 5వ, 6వ అధిపతులు — మంచి జీవితం, దయగల స్వభావం మరియు తరువాతి సంవత్సరాలలో సౌకర్యాన్ని అందిస్తారు.';

  @override
  String get yogaParvataName => 'పర్వత యోగం';

  @override
  String get yogaParvataMeaning =>
      'కేంద్రాలలో 6వ మరియు 8వ స్థానాలు శుభ్రంగా ఉన్న శుభగ్రహాలు — అదృష్టం, ఉదారత మరియు గొప్ప పేరు.';

  @override
  String get yogaHarshaName => 'హర్ష యోగా';

  @override
  String get yogaHarshaMeaning =>
      'ఆరవ అధిపతి కష్టమైన ఇంట్లో ఉంటే — శత్రువులు, అప్పులు మరియు అనారోగ్యం తమ పట్టును కోల్పోతాయి; పోటీతత్వ బలం లభిస్తుంది.';

  @override
  String get yogaSaralaName => 'సరళ యోగా';

  @override
  String get yogaSaralaMeaning =>
      'కష్టమైన ఇంట్లో 8వ అధిపతి — సంక్షోభ సమయాల్లో స్థైర్యం, దీర్ఘాయువు మరియు నిర్భయత్వం.';

  @override
  String get yogaVimalaName => 'విమల యోగా';

  @override
  String get yogaVimalaMeaning =>
      '12వ అధిపతి కష్టమైన ఇంట్లో ఉంటే — నియంత్రిత ఖర్చు, నిర్మలమైన మనస్సాక్షి మరియు స్వతంత్ర జీవితం లభిస్తాయి.';

  @override
  String get yogaMahaParivartanaName => 'మహా పరివర్తన యోగం';

  @override
  String get yogaMahaParivartanaMeaning =>
      'ఇద్దరు శుభ భామల అధిపతులు రాశులను మార్చుకుంటారు — కాలక్రమేణా ఆ రెండు భావాల వ్యవహారాలు ఒకదానికొకటి మేలు చేస్తాయి.';

  @override
  String get yogaKhalaParivartanaName => 'ఖల పరివర్తన యోగ';

  @override
  String get yogaKhalaParivartanaMeaning =>
      '3వ భావానికి సంబంధించిన మార్పిడి — మిశ్రమ ఫలితాలు, హెచ్చు తగ్గులు, కృషి మరియు ధైర్యం ద్వారా లాభాలు.';

  @override
  String get yogaDainyaParivartanaName => 'దైన్య పరివర్తన యోగం';

  @override
  String get yogaDainyaParivartanaMeaning =>
      'కష్టమైన భావానికి సంబంధించిన మార్పిడి — సహనం అవసరమయ్యే అడ్డంకులు; బలమైన దశ దానిని మారుస్తుంది.';

  @override
  String get kSignAries => 'ధైర్యమైన, సూటిగా మాట్లాడే, త్వరగా ప్రారంభించే';

  @override
  String get kSignTaurus =>
      'స్థిరమైన, ఇంద్రియపరమైన, సౌకర్యం మరియు భద్రతకు విలువనిచ్చే';

  @override
  String get kSignGemini => 'జిజ్ఞాస, వాచాలత్వం, శీఘ్ర ఆలోచన';

  @override
  String get kSignCancer => 'శ్రద్ధ, రక్షణ, భావనలచే నడిపించబడే';

  @override
  String get kSignLeo => 'గర్వంగా, ఆప్యాయంగా, కనిపించాలని కోరుకుంటుంది';

  @override
  String get kSignVirgo => 'ఖచ్చితమైన, ఉపయోగకరమైన, అభివృద్ధి దృక్పథం గల';

  @override
  String get kSignLibra => 'న్యాయమైన, సంబంధిత, సమతుల్యతను కోరుకుంటుంది';

  @override
  String get kSignScorpio => 'తీవ్రమైన, వ్యక్తిగతమైన, అంతా లేదా ఏమీ లేదు';

  @override
  String get kSignSagittarius => 'స్వేచ్ఛగా, నమ్మకంతో, విస్తృత దృక్పథంతో';

  @override
  String get kSignCapricorn => 'క్రమశిక్షణ, ఆశయం, దీర్ఘకాలిక ప్రణాళిక';

  @override
  String get kSignAquarius => 'స్వతంత్ర, వ్యవస్థల-ఆధారిత, అసాధారణమైన';

  @override
  String get kSignPisces => 'కల్పనాత్మక, కరుణామయ, హద్దులు లేని';

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
  String get kPlanetSun => 'ఆత్మ, విశ్వాసం, తండ్రి, అధికారం';

  @override
  String get kPlanetMoon => 'మనస్సు, భావోద్వేగాలు, తల్లి, ఓదార్పు';

  @override
  String get kPlanetMars => 'డ్రైవ్, ధైర్యం, కోపం, తోబుట్టువులు';

  @override
  String get kPlanetMercury => 'మేధస్సు, ప్రసంగం, వ్యాపారం, నైపుణ్యం';

  @override
  String get kPlanetJupiter => 'జ్ఞానం, ఎదుగుదల, అదృష్టం, ఉపాధ్యాయులు, పిల్లలు';

  @override
  String get kPlanetVenus => 'ప్రేమ, అందం, సౌకర్యం, భాగస్వామ్యం, కళ';

  @override
  String get kPlanetSaturn =>
      'క్రమశిక్షణ, సమయం, పరిమితులు, కష్టపడి సాధించిన ప్రతిఫలం';

  @override
  String get kPlanetRahu => 'ఆశయం, వ్యామోహం, విదేశీ మరియు కొత్త';

  @override
  String get kPlanetKetu => 'నిర్లిప్తత, ప్రావీణ్యం, వదిలివేయడం, ఆధ్యాత్మికత';

  @override
  String get kHouse1 => 'స్వీయ, శరీరం, జీవశక్తి';

  @override
  String get kHouse2 => 'సంపద, కుటుంబం, ప్రసంగం, ఆహారం';

  @override
  String get kHouse3 => 'ధైర్యం, తోబుట్టువులు, ప్రయత్నం, చిన్న ప్రయాణం';

  @override
  String get kHouse4 => 'ఇల్లు, తల్లి, భూమి, అంతర్గత శాంతి';

  @override
  String get kHouse5 => 'పిల్లలు, విద్య, సృజనాత్మకత, ప్రేమ';

  @override
  String get kHouse6 => 'ఆరోగ్యం, అప్పు, శత్రువులు, రోజువారీ పని';

  @override
  String get kHouse7 => 'వివాహం, భాగస్వామ్యం, వ్యాపారం';

  @override
  String get kHouse8 => 'దీర్ఘాయువు, ఆకస్మిక మార్పు, దాగి ఉన్నది, వారసత్వం';

  @override
  String get kHouse9 => 'అదృష్టం, ధర్మం, తండ్రి, ఉన్నత విద్య, సుదీర్ఘ ప్రయాణం';

  @override
  String get kHouse10 => 'వృత్తి, హోదా, ప్రజా జీవితం';

  @override
  String get kHouse11 => 'ఆదాయం, లాభాలు, నెట్‌వర్క్, అన్నదమ్ములు';

  @override
  String get kHouse12 => 'నష్టం, ఖర్చులు, విదేశీ భూములు, నిద్ర, విముక్తి';

  @override
  String get kDignityExalted => 'ఉన్నతమైనది — చాలా బలమైనది';

  @override
  String get kDignityDebilitated => 'బలహీనపడి — ఇక్కడ ఒత్తిడికి లోనవుతున్నారు';

  @override
  String get kDignityMoolatrikona => 'మూలత్రికోణ — సౌకర్యవంతమైన మరియు బలమైన';

  @override
  String get kDignityOwn => 'స్వంత సంకేతం — స్థిరమైనది మరియు ప్రభావవంతమైనది';

  @override
  String get kDignityGreatFriend => 'గొప్ప స్నేహితుని సంకేతంలో — మద్దతు';

  @override
  String get kDignityFriend => 'స్నేహితుని సంకేతంలో — మద్దతు';

  @override
  String get kDignityNeutral => 'తటస్థ సంకేతం';

  @override
  String get kDignityEnemy => 'శత్రువు సంకేతంలో — మరింత కష్టపడి పనిచేస్తుంది';

  @override
  String get kDignityGreatEnemy => 'గొప్ప శత్రువు సంకేతంలో — ఒత్తిడిలో';

  @override
  String get kDashaSun =>
      'గుర్తింపు, అధికారం మరియు ఆదరణకు సంబంధించిన కాలం. అహం మరియు కంటి/హృదయ ఆరోగ్యంపై దృష్టి కేంద్రీకృతమవుతుంది.';

  @override
  String get kDashaMoon =>
      'మరింత సున్నితమైన, భావోద్వేగభరితమైన అధ్యాయం — ఇల్లు, తల్లి, మానసిక స్థితులు మరియు ప్రజా జీవితం.';

  @override
  String get kDashaMars =>
      'శక్తి, పోటీ మరియు చొరవ పెరుగుతాయి. కోపం, ప్రమాదాలు మరియు ఆస్తి విషయాల పట్ల జాగ్రత్త వహించండి.';

  @override
  String get kDashaMercury =>
      'నేర్చుకోవడం, వ్యాపారం చేయడం, రాయడం మరియు సంభాషణ. చదువుకు, వ్యాపారానికి మంచిది, నిశ్చలత కోసం ఆరాటపడుతుంది.';

  @override
  String get kDashaJupiter =>
      'ఎదుగుదల, ఉపాధ్యాయులు, కుటుంబం, అర్థం. తరచుగా ఇది ఒక అదృష్టకరమైన, విస్తృతమైన దశ.';

  @override
  String get kDashaVenus =>
      'సంబంధాలు, సౌకర్యం, కళ, డబ్బు మరియు ఆనందం. సాధారణంగా అన్ని కాలాలలోకెల్లా ఇది అత్యంత సులభమైనది.';

  @override
  String get kDashaSaturn =>
      'కఠోర శ్రమ, బాధ్యత మరియు నెమ్మదైన, శాశ్వత ఫలితాలు. సహనానికి ప్రతిఫలం లభిస్తుంది; సులభ మార్గాలకు శిక్ష పడుతుంది.';

  @override
  String get kDashaRahu =>
      'అపరిమితమైన ఆశయం — విదేశాలు, సాంకేతికత, ఆకస్మిక ఉన్నతి మరియు గందరగోళం.';

  @override
  String get kDashaKetu =>
      'వైరాగ్యం, ముగింపులు మరియు ఆధ్యాత్మికంగా అంతర్ముఖం కావడం. భౌతిక వస్తువులు నిస్సారంగా అనిపిస్తాయి; నైపుణ్యం గాఢమవుతుంది.';

  @override
  String get kNakAshwini => 'త్వరిత, మార్గదర్శక, స్వస్థత';

  @override
  String get kNakBharani =>
      'తీవ్రమైన, మార్పుకు ఆస్కారం కల్పించే, క్రమశిక్షణ కలిగిన';

  @override
  String get kNakKrittika => 'పదునైన, కోసే, రక్షణాత్మకమైన';

  @override
  String get kNakRohini => 'సృజనాత్మక, ఇంద్రియ, పోషించే, అయస్కాంత';

  @override
  String get kNakMrigashira => 'అన్వేషించే, ఆసక్తిగల, సున్నితమైన';

  @override
  String get kNakArdra => 'తుఫానులాంటి, పరివర్తనాత్మకమైన, ఒత్తిడిలో అద్భుతమైన';

  @override
  String get kNakPunarvasu =>
      'పునరుద్ధరించడం, ఉదారమైనది, భద్రతకు తిరిగి వస్తుంది';

  @override
  String get kNakPushya => 'పోషించే, బాధ్యతాయుతమైన, లోతైన మద్దతునిచ్చే';

  @override
  String get kNakAshlesha => 'గ్రహణశక్తి గల, వ్యూహాత్మక, సమ్మోహనపరిచే';

  @override
  String get kNakMagha => 'రాజసం, సంప్రదాయబద్ధమైన, వంశపారంపర్య';

  @override
  String get kNakPurvaPhalguni =>
      'సరదాగా ఉండే, శృంగారభరితమైన, విశ్రాంతికి విలువనిచ్చే';

  @override
  String get kNakUttaraPhalguni => 'విశ్వసనీయమైన, ఒప్పందపూర్వకమైన, సహాయకరమైన';

  @override
  String get kNakHasta => 'చేతిపనిలో నైపుణ్యం, తెలివైన, స్వస్థపరిచే';

  @override
  String get kNakChitra =>
      'కళాత్మకమైన, ఆకట్టుకునే, అందమైన వస్తువులను నిర్మిస్తాడు';

  @override
  String get kNakSwati => 'స్వతంత్ర, అనుకూలత గల, స్వేచ్ఛను ప్రేమించే';

  @override
  String get kNakVishakha => 'లక్ష్య-ఆధారిత, దృఢసంకల్పం గల, ద్వంద్వ స్వభావం';

  @override
  String get kNakAnuradha => 'అంకితభావం, స్నేహశీలి, విదేశాలలో రాణిస్తారు';

  @override
  String get kNakJyeshtha => 'సీనియర్, బాధ్యతగల, భారాలు మోసే';

  @override
  String get kNakMula => 'మూలాలను అన్వేషించే, విప్లవాత్మకమైన, సారాంశానికి చేరే';

  @override
  String get kNakPurvaAshadha => 'అజేయమైన స్ఫూర్తి, ఒప్పించే';

  @override
  String get kNakUttaraAshadha => 'సూత్రబద్ధమైన, నిలకడైన, తరువాతి విజయం';

  @override
  String get kNakShravana => 'వినడం, నేర్చుకోవడం, ప్రజలను అనుసంధానించడం';

  @override
  String get kNakDhanishta => 'లయబద్ధమైన, సంపన్నమైన, సంగీత సంబంధమైన, అనుకూలమైన';

  @override
  String get kNakShatabhisha => 'వ్యక్తిగత, స్వస్థత చేకూర్చే, వ్యవస్థల-ఆధారిత';

  @override
  String get kNakPurvaBhadrapada => 'ఆదర్శవాద, తీవ్రమైన, పరివర్తనాత్మక';

  @override
  String get kNakUttaraBhadrapada => 'లోతైన, ప్రశాంతమైన, వివేకవంతమైన సలహా';

  @override
  String get kNakRevati => 'దయగల, ప్రయాణికులను రక్షించే, ఊహాశక్తిగల';

  @override
  String get kSadeSatiRising =>
      'ఉదయ దశ — మీ చంద్రుడి నుండి 12వ రాశిలో శని ఉన్నాడు. ముగింపులు, అలసట మరియు పనులు నెమ్మదిస్తున్నాయనే భావన. ఇకపై పనికిరాని వాటిని తొలగించడం ప్రారంభించండి.';

  @override
  String get kSadeSatiPeak =>
      'శిఖర దశ — శని మీ చంద్ర రాశిపైనే ఉంది. అత్యంత కఠినమైన దశ: బాధ్యత, ఒత్తిడి మరియు నెమ్మదైన పురోగతి. దినచర్యలను పాటించండి, మీ ఆరోగ్యాన్ని కాపాడుకోండి.';

  @override
  String get kSadeSatiSetting =>
      'అస్తమయ దశ — మీ చంద్రుడి నుండి రెండవ రాశిలో శని ఉన్నాడు. భారం తొలగిపోతుంది. డబ్బు, కుటుంబం స్థిరపడతాయి; గత సంవత్సరాల పాఠాలు ఫలించడం ప్రారంభిస్తాయి.';

  @override
  String get kSadeSatiGeneric =>
      'శని మీ చంద్రుని చుట్టూ ఉన్న రాశులలో సంచరిస్తోంది.';

  @override
  String kPlanetInSignHouse(
    Object planet,
    Object sign,
    Object signTrait,
    Object house,
    Object houseTheme,
  ) {
    return 'మీ $planet $sign లో ఉండటం వలన మీకు $signTrait వస్తుంది. $house గృహంలో అది $houseTheme తాకుతుంది.';
  }

  @override
  String kPlanetInSign(Object planet, Object sign, Object signTrait) {
    return 'Your $planet in $sign makes you $signTrait.';
  }

  @override
  String get kHouseSans1 => 'తను భవ';

  @override
  String get kHouseSans2 => 'ధన భవ';

  @override
  String get kHouseSans3 => 'సహజ భవ';

  @override
  String get kHouseSans4 => 'సుఖ భావ';

  @override
  String get kHouseSans5 => 'పుత్ర భవ';

  @override
  String get kHouseSans6 => 'రిపు భవ';

  @override
  String get kHouseSans7 => 'యువతి భవ';

  @override
  String get kHouseSans8 => 'ఆయు / రంధ్ర భవ';

  @override
  String get kHouseSans9 => 'ధర్మ భవ';

  @override
  String get kHouseSans10 => 'కర్మ భవ';

  @override
  String get kHouseSans11 => 'లాభ భావ';

  @override
  String get kHouseSans12 => 'వ్యయ భవ';

  @override
  String kHouseTitleWithSign(Object sign, Object theme) {
    return '$sign · $theme';
  }

  @override
  String kHouseSheetTitle(Object ordinal, Object sign) {
    return '$ordinal హౌస్ · $sign';
  }

  @override
  String kHouseSheetSubtitle(Object sanskrit, Object theme) {
    return '$sanskrit — $theme';
  }

  @override
  String kHouseChipLord(Object lord) {
    return 'గృహ ప్రభువు · $lord';
  }

  @override
  String kHouseChipLordIn(Object nthHouse) {
    return 'ప్రభువు $nthHouse లో';
  }

  @override
  String kHouseNoPlanets(Object lord, Object lordWhere) {
    return 'ఈ భావంలో ఏ గ్రహాలూ ఉండవు. దీని కథను ప్రధానంగా దీని అధిపతి అయిన $lord $lordWhere చెబుతాడు.';
  }

  @override
  String kHouseLordWhere(Object nthHouse) {
    return ', ఇప్పుడు $nthHouse లో';
  }

  @override
  String get kHousePlanetsHeader => 'ఈ ఇంట్లో గ్రహాలు';

  @override
  String kHouseAskCta(Object ordinal) {
    return 'మీ $ordinal ఇంటి గురించి జ్యోతిష్యుడిని అడగండి';
  }

  @override
  String kHouseReadingLord(
    Object ordinal,
    Object lord,
    Object nthHouse,
    Object theme,
    Object lordTheme,
  ) {
    return 'మీ $ordinal భావానికి అధిపతి అయిన $lord $nthHouse లో ఉంటారు, కాబట్టి $theme అనేది $lordTheme కు అనుసంధానించబడి ఉంటుంది.';
  }

  @override
  String kHouseReadingOccupant(
    Object planet,
    Object planetTheme,
    Object theme,
  ) {
    return '$planet ఇక్కడ దాని థీమ్‌లను — $planetTheme — $theme లోకి తీసుకువస్తుంది.';
  }

  @override
  String get kHouseReadingEmpty =>
      'ఈ భావాన్ని దాని అధిపతి మరియు దానిని చూసే గ్రహాల ద్వారా చదువుతారు. ఒక జ్యోతిష్యుడు మీకు దీనిని వివరించగలరు.';

  @override
  String kBhavaSubheadKaraka(Object karaka) {
    return 'కరక $karaka';
  }

  @override
  String kBhavaSubheadLord(Object lord, Object nthHouse) {
    return 'ప్రభువు $lord , $nthHouse';
  }

  @override
  String kBhavaSubheadLordOnly(Object lord) {
    return 'ప్రభువు $lord';
  }

  @override
  String kBhavaReadingGoverns(Object theme) {
    return 'ఈ సభ $theme ను పాలిస్తుంది.';
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
    return 'దీని అధిపతి $lord $nthHouse లో ఉన్నారు, కాబట్టి $theme అనేది $lordTheme కు అనుసంధానించబడింది. $dignity $occupants';
  }

  @override
  String kBhavaReadingDignity(Object dignity) {
    return ' ప్రభువు $dignity .';
  }

  @override
  String kBhavaReadingOccupants(Object planets, Object themes) {
    return ' $planets ఇక్కడ ఉండి, $themes జోడిస్తున్నాయి.';
  }

  @override
  String kTransitHouseLine(Object nthHouse, Object theme) {
    return 'మీ $nthHouse · $theme';
  }

  @override
  String kPlanetRowMeta(Object sign, Object nthHouse, Object degree) {
    return '$sign · $nthHouse · $degree °';
  }

  @override
  String kLagnaLordIn(Object nthHouse) {
    return '$nthHouse లో';
  }

  @override
  String get kDignityShortExalted => 'ఉన్నతమైన';

  @override
  String get kDignityShortMoolatrikona => 'మూలత్రికోణ';

  @override
  String get kDignityShortOwn => 'సొంతం';

  @override
  String get kDignityShortDebilitated => 'బలహీనపడిన';

  @override
  String get kDignityShortEnemy => 'శత్రువు చిహ్నం';

  @override
  String get kDignityShortGreatEnemy => 'గొప్ప శత్రువు';

  @override
  String get kCombustNote =>
      'దహనం — సూర్యునికి చాలా దగ్గరగా ఉండటం వల్ల, దాని స్వతంత్ర స్వరం మసకబారుతుంది.';

  @override
  String get kWhatThisMeans => 'మీకు దీని అర్థం ఏమిటంటే';

  @override
  String get ovStrengthStrong => 'బలమైన';

  @override
  String get ovStrengthSteady => 'స్థిరమైన';

  @override
  String get ovStrengthStrain => 'ఒత్తిడిలో';

  @override
  String get ovStrengthWeak => 'బలహీనమైన';

  @override
  String get ovRoleSpouse => 'జీవిత భాగస్వామి సూచిక';

  @override
  String get ovRoleDarakaraka => 'దారకారక (జైమిని)';

  @override
  String get ovRoleWealth => 'సంపద సూచిక';

  @override
  String get ovRoleIntellect => 'మేధస్సు సూచిక';

  @override
  String get ovRoleWisdom => 'జ్ఞాన సూచిక';

  @override
  String get ovRoleFortune => 'అదృష్ట సూచిక';

  @override
  String get ovRoleFather => 'తండ్రి సూచిక';

  @override
  String get ovRoleMother => 'తల్లి సూచిక';

  @override
  String get ovRoleGeneric => 'సిగ్నిఫికేటర్';

  @override
  String ovfPada(int pada) {
    return 'పద $pada';
  }

  @override
  String ovfLagnaSign(Object sign) {
    return 'ఉదయించే రాశి $sign';
  }

  @override
  String ovfLagnaLord(Object planet, Object nthHouse, Object dignity) {
    return 'లగ్నాధిపతి $planet $nthHouse $dignity';
  }

  @override
  String ovfHouseLord(Object ordinal, Object planet, Object nthHouse) {
    return '$ordinal - భావ అధిపతి $planet $nthHouse';
  }

  @override
  String ovfHouseStrength(Object ordinal, Object strength) {
    return '$ordinal ఇల్లు — $strength';
  }

  @override
  String ovfMoonSign(Object sign) {
    return '$sign లో చంద్రుడు';
  }

  @override
  String ovfMoonHouse(Object nthHouse) {
    return '$nthHouse చంద్రుడు';
  }

  @override
  String ovfMoonNakshatra(Object nakshatra) {
    return 'చంద్ర నక్షత్రం $nakshatra';
  }

  @override
  String ovfMoonDignity(Object dignity) {
    return 'చంద్రుని $dignity';
  }

  @override
  String ovfSunSign(Object sign) {
    return 'సూర్యుడు $sign లో';
  }

  @override
  String ovfSeventhSign(Object sign) {
    return '7వ ఇల్లు $sign లో';
  }

  @override
  String ovfPlanetInHouse(Object planet, Object nthHouse) {
    return '$planet in the $nthHouse';
  }

  @override
  String ovfPlanetWithMoon(Object planet) {
    return 'చంద్రుడితో ఉన్న $planet';
  }

  @override
  String ovfAppearanceIn(Object planet) {
    return 'మొదటి ఇంట్లో $planet';
  }

  @override
  String ovfAppearanceAspect(Object planet) {
    return 'మొదటి ఇంటిని చూస్తున్న $planet';
  }

  @override
  String ovfMaleficOnLagna(Object planet) {
    return '$planet ఆరోహణ దిశగా ముందుకు సాగుతోంది';
  }

  @override
  String ovfKaraka(Object role, Object planet) {
    return '$role : $planet';
  }

  @override
  String ovfYoga(Object name) {
    return 'యోగా — $name';
  }

  @override
  String ovfDosha(Object name) {
    return 'దోష — $name';
  }

  @override
  String get doshaMangalName => 'మంగళ దోషం';

  @override
  String get doshaMangalMeaning =>
      'కుజుడు సున్నితమైన స్థానంలో ఉన్నప్పుడు — సాంప్రదాయకంగా వివాహానికి ముందు దీనిని బేరీజు వేస్తారు. భాగస్వాములిద్దరూ మంగళిక స్వభావం కలిగి ఉన్నప్పుడు లేదా గురు గ్రహం కుజుడిపై ప్రభావం చూపినప్పుడు ఇది తరచుగా సమతుల్యంగా ఉంటుంది.';

  @override
  String get doshaKaalSarpaName => 'కాల సర్ప దోష';

  @override
  String get doshaKaalSarpaMeaning =>
      'జాతకం మొత్తం రాహు కేతువుల మధ్య ఉన్నప్పుడు — ఒక స్పష్టమైన దిశ దొరికే వరకు జీవితం కుంచించుకుపోయినట్లు అనిపించవచ్చు, ఆ తర్వాత ఏకాగ్రత తీవ్రమవుతుంది.';

  @override
  String get doshaPitraName => 'పితృ దోషం';

  @override
  String get doshaPitraMeaning =>
      'సూర్యుడు మరియు 9వ ఇల్లు పితృ కర్మ ఛాయను కలిగి ఉంటాయి — దీనిని తరచుగా తండ్రి పేరు మీద శ్రద్ధ మరియు దానధర్మాలతో పరిష్కరిస్తారు.';

  @override
  String get doshaGandmoolName => 'గండమూల దోషం';

  @override
  String get doshaGandmoolMeaning =>
      'చంద్రుడు సంధి నక్షత్రంలో ఉన్నాడు. 27వ రోజున శాంతి పూజ చేయడం సాంప్రదాయబద్ధమైన స్పందన.';

  @override
  String get doshaGrahanName => 'గ్రహణ దోషం';

  @override
  String get doshaGrahanMeaning =>
      'ఒక ప్రకాశవంతమైన గ్రహం (సూర్యుడు లేదా చంద్రుడు) రాహువుతో కలిసి ఉన్నప్పుడు, దానిపై దృష్టి సారించే వరకు ఆ గ్రహం యొక్క సూచనలు మసకబారతాయి.';

  @override
  String get doshaShrapitName => 'శ్రాపిత్ దోష';

  @override
  String get doshaShrapitMeaning =>
      'శని రాహువుతో కలిస్తే — ప్రారంభంలో ఆలస్యం, గందరగోళం ఉంటాయి; స్థిరమైన, ఓపికతో కూడిన ప్రయత్నమే దీనిని అధిగమించే మార్గం.';

  @override
  String get doshaGuruChandalName => 'గురు చండాల్ దోషం';

  @override
  String get doshaGuruChandalMeaning =>
      'రాహువుతో కూడిన బృహస్పతి — అసాధారణమైన ఆలోచనలతో కూడిన జ్ఞానం; మీ గురువులను, నమ్మకాలను జాగ్రత్తగా ఎంచుకోండి.';

  @override
  String get doshaAngarakName => 'అంగరక్ దోష';

  @override
  String get doshaAngarakMeaning =>
      'రాహువుతో కూడిన కుజుడు — ఆవేశపూరిత స్వభావం; కోపం, ప్రమాదాలు మరియు ఆస్తి తగాదాల విషయంలో జాగ్రత్త అవసరం.';

  @override
  String get doshaKemadrumaName => 'కెమద్రుమ దోష';

  @override
  String get doshaKemadrumaMeaning =>
      'చుట్టూ ఎలాంటి ఆధారం లేకుండా చంద్రుడు ఒంటరిగా ఉంటాడు — ఒక కేంద్రం ఆక్రమించబడినప్పుడు లేదా చంద్రుడు బలంగా ఉన్నప్పుడు అది తగ్గుతుంది.';

  @override
  String get doshaDaridraName => 'దరిద్ర దోష';

  @override
  String get doshaDaridraMeaning =>
      'ధన స్థానాలు ఒత్తిడికి గురవుతున్నాయి — క్రమశిక్షణతో కూడిన పొదుపు మరియు బలమైన దశ దానిని చక్కదిద్దుతాయి.';

  @override
  String get birthDetailsCta => 'పూర్తి జనన వివరాలు';

  @override
  String get birthDetailsTitle => 'జనన వివరాలు';

  @override
  String get birthDetailsAyanamsa => 'అయనాంశం';

  @override
  String get birthDetailsPanchangTitle => 'పుట్టినప్పుడు పంచాంగం';

  @override
  String get birthDetailsChakraTitle => 'అవకాహద చక్ర';

  @override
  String get birthDetailsWeekday => 'వారపు రోజు';

  @override
  String get birthDetailsTithi => 'తిథి';

  @override
  String get birthDetailsNakshatra => 'నక్షత్రం';

  @override
  String get birthDetailsYoga => 'యోగా';

  @override
  String get birthDetailsKarana => 'కరణ';

  @override
  String get birthDetailsMoonSign => 'చంద్ర రాశి';

  @override
  String get birthDetailsSunSign => 'సూర్య రాశి';

  @override
  String get birthDetailsSuryaNakshatra => 'సూర్యుని నక్షత్రం';

  @override
  String get birthDetailsSunrise => 'సూర్యోదయం';

  @override
  String get birthDetailsSunset => 'సూర్యాస్తమయం';

  @override
  String get birthDetailsIshtaKala => 'ఇష్ట కళ';

  @override
  String birthDetailsPada(int count) {
    return 'పదా $count';
  }

  @override
  String birthDetailsGhatiPala(int ghati, int pala, int vipala) {
    return '$ghati ఘటి $pala పాల $vipala విపలా';
  }

  @override
  String get birthDetailsNakshatraLord => 'నక్షత్ర అధిపతి';

  @override
  String get birthDetailsRashiLord => 'రాశి అధిపతి';

  @override
  String get birthDetailsVarna => 'వర్ణ';

  @override
  String get birthDetailsVashya => 'వశ్య';

  @override
  String get birthDetailsYoni => 'యోని';

  @override
  String get birthDetailsGana => 'గణ';

  @override
  String get birthDetailsNadi => 'నాడి';

  @override
  String get birthDetailsTara => 'తార';

  @override
  String get birthDetailsTattva => 'తత్త్వం';

  @override
  String get birthDetailsYunja => 'యుంజా';

  @override
  String get birthDetailsRashiPaya => 'రాశి పాయ';

  @override
  String get birthDetailsNakshatraPaya => 'నక్షత్ర పాయ';

  @override
  String get birthDetailsDisclaimer =>
      'సాంప్రదాయ వర్గీకరణ లక్షణాలు — ప్రధానంగా ముహూర్తం మరియు వివాహ సంబంధాల ఏర్పాటులో ఉపయోగిస్తారు, భవిష్యవాణిలో కాదు.';

  @override
  String get vaaraMonday => 'సోమవారం';

  @override
  String get vaaraTuesday => 'మంగళవారం';

  @override
  String get vaaraWednesday => 'బుధవార (బుధవారం)';

  @override
  String get vaaraThursday => 'గురువార (గురువారం)';

  @override
  String get vaaraFriday => 'శుక్రవారము';

  @override
  String get vaaraSaturday => 'శనివార (శనివారం)';

  @override
  String get vaaraSunday => 'రవివార (ఆదివారం)';

  @override
  String get tattvaFire => 'అగ్ని (అగ్ని)';

  @override
  String get tattvaEarth => 'పృథ్వీ (భూమి)';

  @override
  String get tattvaAir => 'వాయు (గాలి)';

  @override
  String get tattvaWater => 'జల (నీరు)';

  @override
  String get payaGold => 'బంగారం';

  @override
  String get payaSilver => 'వెండి';

  @override
  String get payaCopper => 'రాగి';

  @override
  String get payaIron => 'ఇనుము';

  @override
  String get roomAppBarTitle => 'సంప్రదింపులు';

  @override
  String get roomOpenError => 'మేము ఈ సంప్రదింపును ప్రారంభించలేకపోయాము.';

  @override
  String roomWaitingTitle(String name) {
    return '$name అంగీకరించే వరకు వేచి ఉన్నాను';
  }

  @override
  String get roomWaitingBody =>
      'సాధారణంగా ఒక నిమిషంలోపే. వారు చేరిన వెంటనే మేము చాట్‌ను తెరుస్తాము.';

  @override
  String get roomCancelRequest => 'అభ్యర్థనను రద్దు చేయండి';

  @override
  String get roomEndConfirmTitle => 'ఈ సంప్రదింపును ముగించాలా?';

  @override
  String get roomEndConfirmBody => 'సెషన్ ముగిసినప్పుడు బిల్లింగ్ ఆగిపోతుంది.';

  @override
  String get roomKeepTalking => 'మాట్లాడుతూనే ఉండండి';

  @override
  String get roomEnd => 'ముగింపు';

  @override
  String get roomAutoTranslateOn => 'ఆటో-ట్రాన్స్‌లేట్ ఆన్';

  @override
  String get roomAutoTranslateOff => 'ఆటో-ట్రాన్స్‌లేట్ ఆఫ్';

  @override
  String get roomEndedTitle => 'సంప్రదింపులు ముగిశాయి';

  @override
  String get roomBalanceOutTitle => 'మీ బ్యాలెన్స్ అయిపోయింది';

  @override
  String roomBalanceOutBody(String name) {
    return 'మీ వాలెట్ బ్యాలెన్స్ అయిపోవడం వల్ల చాట్ ముగిసింది. $name తో కొనసాగించడానికి రీఛార్జ్ చేసి మళ్లీ ప్రారంభించండి.';
  }

  @override
  String get roomRechargeWallet => 'రీఛార్జ్ వాలెట్';

  @override
  String roomStartAgain(String name) {
    return '$name తో మళ్ళీ ప్రారంభించండి';
  }

  @override
  String get roomRowAstrologer => 'జ్యోతిష్యుడు';

  @override
  String get roomRowDuration => 'వ్యవధి';

  @override
  String get roomRowAmount => 'మొత్తం';

  @override
  String get roomRowRate => 'రేటు';

  @override
  String roomMinutes(int minutes) {
    return '$minutes నిమిషాలు';
  }

  @override
  String roomRatePerMinute(String currency, String amount) {
    return '$currency $amount /నిమిషం';
  }

  @override
  String get roomRateQuestion => 'మీ సంప్రదింపు ఎలా జరిగింది?';

  @override
  String get roomSubmitRating => 'రేటింగ్ సమర్పించండి';

  @override
  String get roomRatingThanks => 'మీ అభిప్రాయానికి ధన్యవాదాలు!';

  @override
  String get roomBackHome => 'ఇంటికి తిరిగి వెళ్లండి';

  @override
  String get roomStatusRejected =>
      'జ్యోతిష్యుడు ఈ అభ్యర్థనను స్వీకరించలేకపోయాడు';

  @override
  String get roomStatusCancelled => 'అభ్యర్థన రద్దు చేయబడింది';

  @override
  String get roomStatusExpired =>
      'అభ్యర్థన గడువు ముగిసింది — సమయానికి స్పందన రాలేదు';

  @override
  String get roomStatusNoShow => 'కాల్ కనెక్ట్ కాలేదు';

  @override
  String get roomStatusClosed => 'సంప్రదింపులు ముగిశాయి';

  @override
  String get roomBalanceRunningOut => 'బ్యాలెన్స్ అయిపోతోంది';

  @override
  String roomMinLeftRecharge(int minutes) {
    return '~ $minutes నిమిషాలు మిగిలి ఉన్నాయి · మాట్లాడటం కొనసాగించడానికి రీఛార్జ్ చేయండి';
  }

  @override
  String roomSpentMinLeft(String currency, String amount, int minutes) {
    return 'ఖర్చు చేసిన $currency $amount · ~ మిగిలి ఉన్న $minutes నిమిషాలు';
  }

  @override
  String get roomAddMoney => 'డబ్బును జోడించండి';

  @override
  String get roomClientBalanceLow =>
      'క్లయింట్ బ్యాలెన్స్ తక్కువగా ఉంది — త్వరగా ముగించండి';

  @override
  String get navChats => 'చాట్‌లు';

  @override
  String get chatsTitle => 'చాట్‌లు';

  @override
  String get chatsLoadError => 'మేము మీ చాట్‌లను లోడ్ చేయలేకపోయాము.';

  @override
  String get chatsEmptyTitle => 'ఇంకా చాట్‌లు లేవు';

  @override
  String get chatsEmptyBody =>
      'జ్యోతిష్యునితో సంప్రదింపులు ప్రారంభించండి, అది ఇక్కడ కనిపిస్తుంది.';

  @override
  String get chatsSectionActive => 'యాక్టివ్';

  @override
  String get chatsSectionRecent => 'ఇటీవలి';

  @override
  String get chatsAstrologerFallback => 'జ్యోతిష్యుడు';

  @override
  String get chatsStatusWaiting =>
      'జ్యోతిష్యుడు అంగీకరించడం కోసం ఎదురుచూస్తున్నాను';

  @override
  String get chatsStatusLive =>
      'ఇప్పుడు ప్రత్యక్ష ప్రసారం · తెరవడానికి నొక్కండి';

  @override
  String chatsStatusEnded(int minutes) {
    return '$minutes నిమిషాల సంప్రదింపులు';
  }

  @override
  String get chatsStatusCancelled => 'రద్దు చేయబడింది';

  @override
  String get chatsStatusRejected => 'అంగీకరించబడలేదు';

  @override
  String get chatsStatusExpired => 'అభ్యర్థన గడువు ముగిసింది';

  @override
  String get chatsStatusGeneric => 'సంప్రదింపులు';

  @override
  String get numerologyTitle => 'సంఖ్యాశాస్త్రం & లో షు గ్రిడ్';

  @override
  String get numerologyIntro =>
      'మీ పుట్టిన తేదీ (మరియు పేరు) ఆధారంగా సాంప్రదాయ సంఖ్యా పఠనం — ప్రతి సంఖ్య మొగ్గు చూపే లక్షణాలు, అనుకూలమైన రోజులు మరియు రంగులు, మరియు మీ లో షు జన్మ గ్రిడ్. ఇది కేవలం మననం చేసుకోవడం కోసం మాత్రమే, కచ్చితమైన భవిష్యత్ సూచన కోసం కాదు.';

  @override
  String get numMoolank => 'మూలాంక్ · మానసిక సంఖ్య';

  @override
  String get numBhagyank => 'భాగ్యంక్ · విధి సంఖ్య';

  @override
  String get numNaamank => 'నామంక్ · పేరు సంఖ్య';

  @override
  String numRuledBy(String planet) {
    return 'పాలించేది $planet';
  }

  @override
  String get numFriendly => 'స్నేహపూర్వక';

  @override
  String get numNeutral => 'తటస్థ';

  @override
  String get numUnfriendly => 'ఘర్షణ';

  @override
  String get numFavDays => 'అనుకూలమైన రోజులు';

  @override
  String get numFavColours => 'అనుకూలమైన రంగులు';

  @override
  String get numDirection => 'దిశ';

  @override
  String get numDeity => 'దేవత';

  @override
  String get numGemstone => 'సాంప్రదాయ రత్నం';

  @override
  String get numLoShuTitle => 'లో షు జనన గ్రిడ్';

  @override
  String numLoShuMissing(String nums) {
    return 'మీ గ్రిడ్‌లో లేదు: $nums';
  }

  @override
  String numLoShuRepeated(String nums) {
    return 'నొక్కి చెప్పబడింది: $nums';
  }

  @override
  String get numArrowStrength => 'పూర్తి లైన్';

  @override
  String get numArrowAbsence => 'గైర్హాజరైన లైన్';

  @override
  String get numAskCta => 'దీని గురించి జ్యోతిష్యుడితో మాట్లాడండి';

  @override
  String get sadeSatiTitle => 'సాడే సతి & ధైయా క్యాలెండర్';

  @override
  String sadeSatiIntro(String sign) {
    return 'మీ చంద్ర రాశి $sign నుండి లెక్కించబడిన, మీ జీవితకాలంలోని శని దశలు. సడే సతి అంటే చంద్రుని నుండి 12వ, 1వ మరియు 2వ స్థానాల వరకు శని (~7½ సంవత్సరాలు); ధైయా అంటే 4వ లేదా 8వ స్థానం (~2½ సంవత్సరాలు).';
  }

  @override
  String get sadeSatiRunningNow => 'ప్రస్తుతం నడుస్తోంది';

  @override
  String get sadeSatiPast => 'గతం';

  @override
  String get sadeSatiUpcoming => 'రాబోయే';

  @override
  String get sadeSatiPhaseRising => 'ఉదయ రాశి · 12వ ఇంట్లో శని';

  @override
  String get sadeSatiPhasePeak => 'శిఖరం · చంద్రునిపై శని';

  @override
  String get sadeSatiPhaseSetting => 'అస్తమిస్తున్న శని 2వ ఇంట్లో';

  @override
  String get sadeSatiPhaseKantaka => 'కంటక · 4వ ఇంట్లో శని';

  @override
  String get sadeSatiPhaseAshtama => 'అష్టమ · 8వ ఇంట్లో శని';

  @override
  String get sadeSatiDhaiyaHeading => 'ధైయా (చిన్న పనోటి) కాలాలు';

  @override
  String sadeSatiRange(String start, String end) {
    return '$start → $end';
  }

  @override
  String get avTransitHeading => 'నేటి గోచారాల అష్టకవర్గ బలం';

  @override
  String get avTransitIntro =>
      'మీ జన్మ బిందువు స్కోర్‌ల నుండి ప్రతి గ్రహ సంచారం దాని ఫలితాలను ఎంత స్వేచ్ఛగా ఇస్తుందో తెలుసుకోండి. 8లో 5 లేదా అంతకంటే ఎక్కువ ఉంటే సహాయక సంకేతం, 4 ఉంటే మిశ్రమంగా, తక్కువ ఉంటే బలహీనంగా ఉంటుంది.';

  @override
  String avTransitBindus(int bindus) {
    return '$bindus /8 బిండస్';
  }

  @override
  String get avTransitUpcoming => 'రాబోయే';

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
      'సర్వర్‌ను సంప్రదించలేకపోయాము. మీ కనెక్షన్ తనిఖీ చేయండి.';

  @override
  String get errTimeout => 'సర్వర్ ప్రతిస్పందించడానికి చాలా సమయం తీసుకుంటోంది.';

  @override
  String get errSession =>
      'మీ సెషన్ గడువు ముగిసింది. దయచేసి మళ్ళీ సైన్ ఇన్ చేయండి.';

  @override
  String get errWalletInsufficient =>
      'దీని కోసం మీ వాలెట్ బ్యాలెన్స్ చాలా తక్కువగా ఉంది.';

  @override
  String get errRateLimited =>
      'చాలా ప్రయత్నాలు జరిగాయి. దయచేసి కాసేపు వేచి ఉండి మళ్ళీ ప్రయత్నించండి.';

  @override
  String get errOtpInvalid => 'కోడ్ తప్పు లేదా గడువు ముగిసింది.';

  @override
  String get errOtpMaxAttempts =>
      'చాలా సార్లు తప్పు ప్రయత్నాలు జరిగాయి. కొత్త కోడ్ కోసం అభ్యర్థించండి.';

  @override
  String get errPromoNotRedeemable => 'ఈ కూపన్ కోడ్ ఉపయోగించడానికి వీలుపడదు.';

  @override
  String get errRechargeInvalidAmount =>
      'అనుమతించబడిన పరిమితిలో మొత్తాన్ని నమోదు చేయండి.';

  @override
  String get errAuthWrongApp =>
      'ఈ నంబర్ మరొక TalkAcharya యాప్ కోసం రిజిస్టర్ చేయబడింది.';

  @override
  String get errGeneric => 'ఏదో తప్పు జరిగింది. మళ్ళీ ప్రయత్నించండి.';

  @override
  String get homePanchangTitle => 'నేటి పంచాంగం';

  @override
  String get homeLiveNowTitle => 'ఇప్పుడు ప్రత్యక్ష ప్రసారం';

  @override
  String get homeFreeToolsTitle => 'ఉచిత సాధనాలు';

  @override
  String get homeResumeBtn => 'పునఃప్రారంభం';

  @override
  String get homeAddBtn => 'జోడించండి';

  @override
  String get homeNotifyMeBtn => 'నాకు తెలియజేయండి';

  @override
  String get homeKundaliAction => 'కుండలి';

  @override
  String get homeMatchingAction => 'సరిపోల్చడం';

  @override
  String get homeHoroscopeAction => 'జాతకం';

  @override
  String get homeVastuAction => 'వాస్తు';

  @override
  String get homeRetryBtn => 'మళ్ళీ ప్రయత్నించండి';

  @override
  String get homeChooseSignTitle => 'మీ రాశిని ఎంచుకోండి';

  @override
  String get homeChooseLanguageTitle => 'భాషను ఎంచుకోండి';

  @override
  String get homeLanguageTooltip => 'భాష';

  @override
  String homeLanguageSwitchError(String error) {
    return 'మార్చలేకపోయింది: $error';
  }

  @override
  String get homeComingSoonSnackbar => 'త్వరలో వస్తుంది!';

  @override
  String get homeTalkAgainTitle => 'మళ్ళీ మాట్లాడండి';

  @override
  String get homeRechargeWalletTitle => 'మీ వాలెట్‌ను రీఛార్జ్ చేసుకోండి';

  @override
  String get homeTalkToAstrologerTitle => 'జ్యోతిష్యుడితో మాట్లాడండి';

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
