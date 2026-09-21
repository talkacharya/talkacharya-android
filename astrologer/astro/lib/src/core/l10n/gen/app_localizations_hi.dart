// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get navHome => 'होम';

  @override
  String get navRequests => 'अनुरोध';

  @override
  String get navEarnings => 'कमाई';

  @override
  String get navChats => 'चैट';

  @override
  String get navProfile => 'प्रोफ़ाइल';

  @override
  String get commonOffline => 'आप ऑफ़लाइन हैं';

  @override
  String get commonRetry => 'फिर से कोशिश करें';

  @override
  String get commonSeeAll => 'सभी देखें';

  @override
  String get commonNotifications => 'सूचनाएँ';

  @override
  String get dashGreeting => 'नमस्ते,';

  @override
  String get presenceOnline => 'आप ऑनलाइन हैं';

  @override
  String get presenceBusy => 'आप सत्र में हैं';

  @override
  String get presenceAway => 'आप दूर हैं';

  @override
  String get presenceOffline => 'आप ऑफ़लाइन हैं';

  @override
  String get presenceOnlineHint => 'ग्राहक अभी आपसे जुड़ सकते हैं';

  @override
  String get presenceOfflineHint => 'अनुरोध पाने के लिए ऑनलाइन हों';

  @override
  String presenceFollowersHint(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ऑनलाइन होने पर $count फ़ॉलोअर्स को सूचना मिलती है',
      one: 'ऑनलाइन होने पर 1 फ़ॉलोअर को सूचना मिलती है',
    );
    return '$_temp0';
  }

  @override
  String get presenceGoOnline => 'ऑनलाइन हों';

  @override
  String get presenceGoOffline => 'ऑफ़लाइन हों';

  @override
  String dashRequestsWaiting(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count अनुरोध प्रतीक्षा में',
      one: '1 अनुरोध प्रतीक्षा में',
    );
    return '$_temp0';
  }

  @override
  String get dashRequestsHint => 'जल्दी जवाब दें — अनुरोध समाप्त हो जाते हैं';

  @override
  String get dashReview => 'देखें';

  @override
  String get channelChat => 'चैट';

  @override
  String get channelCall => 'वॉइस कॉल';

  @override
  String get channelVideo => 'वीडियो कॉल';

  @override
  String get dashActiveTitle => 'चल रहे सत्र';

  @override
  String get dashResume => 'जारी रखें';

  @override
  String get dashEarningsTitle => 'शुद्ध कमाई';

  @override
  String dashLastDays(int days) {
    return 'पिछले $days दिन';
  }

  @override
  String dashPeriodChip(int days) {
    return '$days दिन';
  }

  @override
  String dashGross(String amount) {
    return 'कुल $amount';
  }

  @override
  String dashFee(String amount) {
    return 'प्लेटफ़ॉर्म शुल्क $amount';
  }

  @override
  String get dashAvailable => 'भुगतान के लिए उपलब्ध';

  @override
  String dashPending(String amount) {
    return '$amount क्लियर हो रहे हैं';
  }

  @override
  String get dashNoTrend => 'पहले सत्रों के बाद आपका कमाई चार्ट यहाँ दिखेगा';

  @override
  String get dashPerformance => 'प्रदर्शन';

  @override
  String get dashStatSessions => 'सत्र';

  @override
  String dashStatSessionsSub(int count) {
    return '$count अनुरोधित';
  }

  @override
  String get dashStatMinutes => 'मिनट';

  @override
  String get dashStatMinutesSub => 'बिल किया गया समय';

  @override
  String get dashStatAcceptance => 'स्वीकृति';

  @override
  String get dashStatAcceptanceSub => 'जवाब दिए गए अनुरोध';

  @override
  String get dashStatRating => 'रेटिंग';

  @override
  String dashStatRatingSub(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count समीक्षाएँ',
      one: '1 समीक्षा',
    );
    return '$_temp0';
  }

  @override
  String get dashStatRepeat => 'दोबारा आए ग्राहक';

  @override
  String get dashStatRepeatSub => 'फिर से परामर्श लिया';

  @override
  String get dashStatFollowers => 'फ़ॉलोअर्स';

  @override
  String get dashStatFollowersSub => 'लाइव होने पर सूचित';

  @override
  String get dashQuickActions => 'त्वरित कार्य';

  @override
  String get dashActionGoLive => 'लाइव जाएँ';

  @override
  String get dashActionPredictions => 'भविष्यवाणियाँ';

  @override
  String get dashActionRates => 'मेरी दरें';

  @override
  String get dashActionHours => 'कार्य समय';

  @override
  String get dashActionReviews => 'समीक्षाएँ';

  @override
  String get dashActionPayouts => 'भुगतान';

  @override
  String get dashProfileTitle => 'प्रोफ़ाइल की मज़बूती';

  @override
  String get dashProfileHint => 'पूरी प्रोफ़ाइल को ज़्यादा परामर्श मिलते हैं';

  @override
  String get dashTipHeadline => 'एक शीर्षक जोड़ें';

  @override
  String get dashTipBio => 'विस्तृत परिचय लिखें';

  @override
  String get dashTipBanner => 'कवर इमेज जोड़ें';

  @override
  String get dashTipRates => 'अपनी प्रति-मिनट दरें तय करें';

  @override
  String get dashTipLanguages => 'अपनी भाषाएँ जोड़ें';

  @override
  String get dashTipSkills => 'कम से कम 3 विशेषज्ञताएँ जोड़ें';

  @override
  String get dashLoadFailed => 'यह भाग लोड नहीं हो सका';

  @override
  String dashPerMin(String amount) {
    return '$amount/मिनट';
  }

  @override
  String get requestsSubtitle => 'अनुरोध समाप्त होने से पहले जवाब दें';

  @override
  String get requestsTabIncoming => 'नए';

  @override
  String get requestsTabActive => 'चालू';

  @override
  String get requestsTabHistory => 'इतिहास';

  @override
  String get requestsAccept => 'स्वीकारें';

  @override
  String get requestsDecline => 'अस्वीकारें';

  @override
  String requestsExpiresIn(int seconds) {
    return '$seconds सेकंड में समाप्त';
  }

  @override
  String get requestsExpired => 'समाप्त';

  @override
  String get requestsEmptyOnlineTitle => 'अनुरोधों की प्रतीक्षा';

  @override
  String get requestsEmptyOnlineBody =>
      'आप ऑनलाइन हैं। नए अनुरोध यहाँ दिखेंगे और आपकी स्क्रीन पर भी आएँगे।';

  @override
  String get requestsActiveEmptyTitle => 'कोई चालू सत्र नहीं';

  @override
  String get requestsActiveEmptyBody =>
      'स्वीकार किए गए अनुरोध सत्र ख़त्म होने तक यहाँ रहते हैं।';

  @override
  String get requestsHistoryEmptyTitle => 'अभी तक कोई पूरा सत्र नहीं';

  @override
  String get requestsHistoryEmptyBody =>
      'पूरे हुए परामर्श और आपकी कमाई यहाँ दिखेगी।';

  @override
  String requestsEarned(String amount) {
    return 'कमाई $amount';
  }

  @override
  String requestsMinutes(int count) {
    return '$count मिनट';
  }

  @override
  String get requestsLiveNow => 'अभी लाइव';

  @override
  String get requestsDeclineTitle => 'आप अस्वीकार क्यों कर रहे हैं?';

  @override
  String get requestsDeclineBusy => 'अभी व्यस्त हूँ';

  @override
  String get requestsDeclineUnavailable => 'उपलब्ध नहीं';

  @override
  String get requestsDeclineExpertise => 'मेरी विशेषज्ञता से बाहर';

  @override
  String get requestsActionFailed =>
      'यह पूरा नहीं हो सका। कृपया फिर कोशिश करें।';

  @override
  String requestsNewTitle(String channel) {
    return 'नया $channel अनुरोध';
  }

  @override
  String get requestsCustomerFallback => 'एक ग्राहक';

  @override
  String get requestsLoadError => 'आपके अनुरोध लोड नहीं हो सके';

  @override
  String get timeJustNow => 'अभी';

  @override
  String timeMinutesAgo(int n) {
    return '$n मिनट पहले';
  }

  @override
  String timeHoursAgo(int n) {
    return '$n घंटे पहले';
  }

  @override
  String get timeToday => 'आज';

  @override
  String get timeYesterday => 'कल';

  @override
  String get statusRequested => 'प्रतीक्षा में';

  @override
  String get statusAccepted => 'जुड़ रहा है';

  @override
  String get statusActive => 'लाइव';

  @override
  String get statusEnded => 'पूरा हुआ';

  @override
  String get statusRejected => 'अस्वीकृत';

  @override
  String get statusCancelled => 'रद्द';

  @override
  String get statusExpired => 'छूट गया';

  @override
  String get statusNoShow => 'ग्राहक नहीं आया';

  @override
  String get statusFailed => 'विफल';

  @override
  String get detailTitle => 'परामर्श';

  @override
  String get detailLoadError => 'यह परामर्श लोड नहीं हो सका।';

  @override
  String get detailQuestion => 'उनका प्रश्न';

  @override
  String get detailSession => 'सत्र';

  @override
  String get detailRequestedAt => 'अनुरोध समय';

  @override
  String get detailDuration => 'बिल किया गया समय';

  @override
  String get detailRate => 'आपकी दर';

  @override
  String get detailCustomerPaid => 'ग्राहक ने चुकाया';

  @override
  String get detailYouEarned => 'आपकी कमाई';

  @override
  String get detailRating => 'ग्राहक रेटिंग';

  @override
  String get detailKundali => 'ग्राहक की कुंडली';

  @override
  String get detailOpenChat => 'बातचीत खोलें';

  @override
  String get chatsSearch => 'नाम से खोजें';

  @override
  String chatsSubtitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count नए संदेश',
      one: '1 नया संदेश',
      zero: 'कोई नया संदेश नहीं',
    );
    return '$_temp0';
  }

  @override
  String get chatsRecent => 'हाल के';

  @override
  String get chatsEmptyTitle => 'अभी कोई बातचीत नहीं';

  @override
  String get chatsEmptyBody =>
      'अनुरोध स्वीकार करने के बाद ग्राहकों से बातचीत यहाँ दिखेगी।';

  @override
  String chatsNoMatch(String query) {
    return '“$query” से कोई चैट नहीं मिली';
  }

  @override
  String get chatsLoadError => 'आपकी चैट लोड नहीं हो सकीं';

  @override
  String get earnClearing => 'क्लियर हो रहा';

  @override
  String get earnLifetime => 'अब तक कुल';

  @override
  String earnCycle(int days, String fee) {
    return 'हर $days दिन में भुगतान · $fee% प्लेटफ़ॉर्म शुल्क';
  }

  @override
  String get earnTabLedger => 'खाता';

  @override
  String get earnTabPayouts => 'भुगतान';

  @override
  String get earnTabDocuments => 'दस्तावेज़';

  @override
  String get earnKindAll => 'सभी';

  @override
  String get earnKindConsultation => 'परामर्श';

  @override
  String get earnKindGift => 'उपहार';

  @override
  String get earnKindPrediction => 'भविष्यवाणियाँ';

  @override
  String get earnKindStore => 'स्टोर बिक्री';

  @override
  String get earnKindAffiliate => 'रेफ़रल कमीशन';

  @override
  String get earnKindBonus => 'बोनस';

  @override
  String get earnKindAdjustment => 'समायोजन';

  @override
  String earnEntryFee(String percent, String amount) {
    return '$amount पर $percent% शुल्क';
  }

  @override
  String earnEntryClears(String date) {
    return '$date को क्लियर होगा';
  }

  @override
  String get earnEntryReady => 'भुगतान के लिए तैयार';

  @override
  String get earnEntryPaid => 'भुगतान हो चुका';

  @override
  String get earnLedgerEmptyTitle => 'अभी कोई कमाई नहीं';

  @override
  String get earnLedgerEmptyBody =>
      'आपके हर परामर्श, उपहार और भविष्यवाणी की कमाई यहाँ दर्ज होती है।';

  @override
  String get earnLedgerFilteredEmpty => 'इस श्रेणी में अभी कुछ नहीं';

  @override
  String get earnPayoutsEmptyTitle => 'अभी कोई भुगतान नहीं';

  @override
  String get earnPayoutsEmptyBody =>
      'क्लियर हुई कमाई हर भुगतान चक्र में आपके बैंक खाते में भेजी जाती है।';

  @override
  String get earnDocsEmptyTitle => 'अभी कोई दस्तावेज़ नहीं';

  @override
  String get earnDocsEmptyBody =>
      'भुगतान के बाद कमाई विवरण और TDS प्रमाणपत्र यहाँ दिखेंगे।';

  @override
  String get earnLoadError => 'यह सूची लोड नहीं हो सकी';

  @override
  String get payoutStatusPending => 'निर्धारित';

  @override
  String get payoutStatusProcessing => 'प्रक्रिया में';

  @override
  String get payoutStatusPaid => 'भुगतान हुआ';

  @override
  String get payoutStatusFailed => 'विफल';

  @override
  String get payoutStatusOnHold => 'रोका गया';

  @override
  String get payoutStatusCancelled => 'रद्द';

  @override
  String payoutEntries(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count कमाई',
      one: '1 कमाई',
    );
    return '$_temp0';
  }

  @override
  String payoutPaidOn(String date) {
    return '$date को भुगतान';
  }

  @override
  String get docKindCustomerInvoice => 'ग्राहक चालान';

  @override
  String get docKindAstrologerInvoice => 'कमाई विवरण';

  @override
  String get docKindTds => 'TDS प्रमाणपत्र';

  @override
  String get docKindGst => 'GST चालान';

  @override
  String get docKindCreditNote => 'क्रेडिट नोट';

  @override
  String get docKindStore => 'स्टोर टैक्स चालान';

  @override
  String docTax(String amount) {
    return 'कर $amount';
  }

  @override
  String get docDownloadFailed => 'यह दस्तावेज़ डाउनलोड नहीं हो सका';

  @override
  String get payoutTitle => 'भुगतान';

  @override
  String get payoutLoadError => 'यह भुगतान लोड नहीं हो सका।';

  @override
  String get payoutBreakdown => 'विवरण';

  @override
  String get payoutGross => 'आपकी कमाई';

  @override
  String get payoutTds => 'काटा गया TDS';

  @override
  String get payoutOther => 'अन्य कटौती';

  @override
  String get payoutNet => 'आपके बैंक में भेजा गया';

  @override
  String get payoutTimeline => 'स्थिति';

  @override
  String get payoutStepScheduled => 'भुगतान निर्धारित';

  @override
  String get payoutStepInitiated => 'बैंक ट्रांसफ़र शुरू';

  @override
  String get payoutStepPaid => 'आपके बैंक में जमा';

  @override
  String get payoutStepFailed => 'ट्रांसफ़र विफल';

  @override
  String get payoutStepOnHold => 'रोका गया — हमारी टीम समीक्षा कर रही है';

  @override
  String get payoutStepCancelled => 'भुगतान रद्द';

  @override
  String get payoutUtr => 'बैंक संदर्भ (UTR)';

  @override
  String get payoutCopied => 'कॉपी हो गया';

  @override
  String get payoutIncluded => 'शामिल कमाई';

  @override
  String get payoutCopy => 'कॉपी करें';

  @override
  String get commonSave => 'सहेजें';

  @override
  String get commonSaved => 'सहेज लिया';

  @override
  String get commonSaveFailed => 'सहेजा नहीं जा सका। कृपया फिर कोशिश करें।';

  @override
  String get commonCancel => 'रद्द करें';

  @override
  String get commonRequired => 'आवश्यक';

  @override
  String get commonLoadFailed => 'यह पेज लोड नहीं हो सका';

  @override
  String get verifUnverified => 'असत्यापित';

  @override
  String get verifSubmitted => 'समीक्षा में';

  @override
  String get verifVerified => 'सत्यापित';

  @override
  String get verifFeatured => 'फ़ीचर्ड';

  @override
  String get verifUnverifiedHint =>
      'सत्यापित बैज पाने के लिए अपने दस्तावेज़ जमा करें।';

  @override
  String get verifSubmittedHint =>
      'हमारी टीम आपके दस्तावेज़ों की समीक्षा कर रही है। इसमें आमतौर पर 1–2 दिन लगते हैं।';

  @override
  String get verifVerifiedHint =>
      'आपकी पहचान सत्यापित है। ग्राहकों को आपकी प्रोफ़ाइल पर सत्यापित बैज दिखता है।';

  @override
  String get profileStatYears => 'वर्ष';

  @override
  String get profileChangePhoto => 'फ़ोटो बदलें';

  @override
  String get profilePhotoUpdated => 'फ़ोटो अपडेट हो गई';

  @override
  String get profilePhotoFailed => 'आपकी फ़ोटो अपडेट नहीं हो सकी';

  @override
  String get profileGroupPractice => 'आपकी सेवा';

  @override
  String get profileGroupGrowth => 'आगे बढ़ें';

  @override
  String get profileGroupAccount => 'खाता';

  @override
  String get profileGroupSupport => 'सहायता और नियम';

  @override
  String get profileEdit => 'प्रोफ़ाइल संपादित करें';

  @override
  String get profileEditSub => 'कवर, परिचय, विशेषज्ञता और भाषाएँ';

  @override
  String get profileRates => 'दरें';

  @override
  String get profileRatesSub => 'ग्राहक प्रति मिनट कितना चुकाते हैं';

  @override
  String get profileHours => 'उपलब्धता और समय';

  @override
  String get profileHoursSub => 'परामर्श के प्रकार और साप्ताहिक समय';

  @override
  String get profileGoLiveSub => 'अपने फ़ॉलोअर्स के लिए लाइव प्रसारण';

  @override
  String get profilePredictionsSub =>
      'ग्राहकों द्वारा मंगाई गई भविष्यवाणियाँ लिखें';

  @override
  String get profileFeatured => 'फ़ीचर्ड स्लॉट';

  @override
  String get profileFeaturedSub => 'ग्राहक ऐप में प्रमोशन पाएँ';

  @override
  String get profileKyc => 'KYC और बैंक';

  @override
  String get profileKycSub => 'सत्यापन दस्तावेज़ और भुगतान खाता';

  @override
  String get profileLanguage => 'ऐप की भाषा';

  @override
  String get profileHelp => 'सहायता केंद्र';

  @override
  String get profileContact => 'सहायता से संपर्क करें';

  @override
  String get profileTerms => 'सेवा की शर्तें';

  @override
  String get profilePrivacy => 'गोपनीयता नीति';

  @override
  String get profileLogout => 'लॉग आउट';

  @override
  String get profileLogoutTitle => 'लॉग आउट करें?';

  @override
  String get profileLogoutBody =>
      'आपको अपने फ़ोन नंबर से फिर से साइन इन करना होगा।';

  @override
  String profileVersion(String version) {
    return 'संस्करण $version';
  }

  @override
  String get editCover => 'प्रोफ़ाइल कवर';

  @override
  String get editCoverHint =>
      'आपकी सार्वजनिक प्रोफ़ाइल पर फ़ोटो के पीछे दिखता है। चौड़ी तस्वीरें (लगभग 3:1) सबसे अच्छी लगती हैं।';

  @override
  String get editCoverChange => 'कवर बदलें';

  @override
  String get editCoverRemove => 'हटाएँ';

  @override
  String get editCoverFailed =>
      'कवर अपलोड नहीं हो सका। 5 MB से छोटी JPG या PNG इस्तेमाल करें।';

  @override
  String get editAbout => 'आपके बारे में';

  @override
  String get editDisplayName => 'प्रदर्शित नाम';

  @override
  String get editHeadline => 'शीर्षक';

  @override
  String get editHeadlineHint => 'जैसे वैदिक ज्योतिषी · करियर और विवाह';

  @override
  String get editBio => 'परिचय';

  @override
  String get editBioHint => 'ग्राहकों को अपने तरीके और अनुभव के बारे में बताएँ';

  @override
  String editBioShort(int count) {
    return 'मज़बूत परिचय के लिए $count और अक्षर लिखें';
  }

  @override
  String get editYears => 'अनुभव के वर्ष';

  @override
  String get editExpertise => 'विशेषज्ञता';

  @override
  String get editExpertiseHint =>
      'चुनने के लिए टैप करें। मुख्य बनाने के लिए चुनी गई विशेषज्ञता को देर तक दबाएँ।';

  @override
  String get editPrimary => 'मुख्य';

  @override
  String get editLanguages => 'आप कौन सी भाषाएँ बोलते हैं';

  @override
  String get editDiscardTitle => 'बदलाव छोड़ें?';

  @override
  String get editDiscard => 'छोड़ें';

  @override
  String get editKeepEditing => 'संपादन जारी रखें';

  @override
  String get ratesSubtitle =>
      'ग्राहक प्रति मिनट कितना चुकाते हैं। बदलाव नए सत्रों पर लागू होंगे।';

  @override
  String ratesAllowed(String min, String max) {
    return 'अनुमत $min – $max';
  }

  @override
  String ratesYouEarn(String amount, String fee) {
    return '$fee% प्लेटफ़ॉर्म शुल्क के बाद आपकी कमाई लगभग $amount/मिनट';
  }

  @override
  String ratesSuggested(String amount) {
    return 'सुझाव $amount';
  }

  @override
  String get ratesNotOffered => 'प्लेटफ़ॉर्म पर अभी उपलब्ध नहीं';

  @override
  String ratesSaveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count बदलाव सहेजें',
      one: '1 बदलाव सहेजें',
    );
    return '$_temp0';
  }

  @override
  String get ratesUpdated => 'दरें अपडेट हो गईं';

  @override
  String get hoursChannels => 'परामर्श के प्रकार';

  @override
  String get hoursChannelsHint =>
      'ग्राहक केवल वही प्रकार चुन सकते हैं जो आप स्वीकार करते हैं।';

  @override
  String get hoursNeedChannel => 'कम से कम एक प्रकार चालू रखें';

  @override
  String get hoursConcurrent => 'एक साथ चैट';

  @override
  String get hoursConcurrentHint => 'आप एक साथ कितने चैट सत्र संभाल सकते हैं';

  @override
  String get hoursSchedule => 'साप्ताहिक समय';

  @override
  String get hoursScheduleHint =>
      'ग्राहकों को आपके सामान्य समय के रूप में दिखता है। ऑनलाइन आपको खुद होना होगा।';

  @override
  String get hoursOff => 'बंद';

  @override
  String get hoursCopyToAll => 'सभी दिनों पर लागू करें';

  @override
  String get hoursInvalid => 'समाप्ति समय शुरू होने के समय के बाद होना चाहिए';

  @override
  String reviewsBasedOn(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count समीक्षाओं के आधार पर',
      one: '1 समीक्षा के आधार पर',
    );
    return '$_temp0';
  }

  @override
  String get reviewsFilterUnreplied => 'जवाब बाकी';

  @override
  String get reviewsFilterLow => '3★ और कम';

  @override
  String get reviewsFilterTop => '5★';

  @override
  String get reviewsReply => 'जवाब दें';

  @override
  String get reviewsYourReply => 'आपका जवाब';

  @override
  String get reviewsReplyHint =>
      'धन्यवाद दें या उनकी प्रतिक्रिया का जवाब दें। जवाब सार्वजनिक होते हैं।';

  @override
  String get reviewsPost => 'जवाब पोस्ट करें';

  @override
  String get reviewsReplyFailed => 'आपका जवाब पोस्ट नहीं हो सका';

  @override
  String get reviewsPending => 'मॉडरेशन की प्रतीक्षा';

  @override
  String get reviewsHidden => 'छिपाया गया';

  @override
  String get reviewsAnonymous => 'ग्राहक';

  @override
  String get reviewsEmptyTitle => 'अभी कोई समीक्षा नहीं';

  @override
  String get reviewsEmptyBody =>
      'ग्राहक हर परामर्श के बाद आपको रेटिंग दे सकते हैं।';

  @override
  String get reviewsNoMatch => 'इस फ़िल्टर में कोई समीक्षा नहीं';

  @override
  String reviewsHelpful(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count लोगों को यह उपयोगी लगा',
      one: '1 व्यक्ति को यह उपयोगी लगा',
    );
    return '$_temp0';
  }

  @override
  String get kycStatus => 'सत्यापन';

  @override
  String get kycPan => 'पैन कार्ड';

  @override
  String get kycPanHint =>
      'अगर आपका पैन बदला है या चिह्नित हुआ है तो दोबारा जमा करें।';

  @override
  String get kycPanLabel => 'पैन नंबर';

  @override
  String get kycPanInvalid => 'सही पैन डालें, जैसे ABCDE1234F';

  @override
  String get kycSubmit => 'जमा करें';

  @override
  String get kycSubmitted => 'सत्यापन के लिए जमा किया गया';

  @override
  String get kycPhoto => 'पहचान फ़ोटो';

  @override
  String get kycPhotoHint => 'आपके चेहरे की साफ़, हाल की फ़ोटो।';

  @override
  String get kycUploadPhoto => 'फ़ोटो अपलोड करें';

  @override
  String get kycCertificate => 'प्रमाणपत्र';

  @override
  String get kycCertificateHint =>
      'ज्योतिष योग्यता भरोसा बढ़ाती है और फ़ीचर्ड होने में मदद करती है।';

  @override
  String get kycUploadCertificate => 'प्रमाणपत्र अपलोड करें';

  @override
  String get kycBank => 'भुगतान बैंक खाता';

  @override
  String get kycBankHint =>
      'आपकी कमाई इसी खाते में भेजी जाती है। बदलाव अगले भुगतान से पहले सत्यापित होते हैं।';

  @override
  String get kycHolder => 'खाताधारक का नाम';

  @override
  String get kycAccount => 'खाता संख्या';

  @override
  String get kycAccountConfirm => 'खाता संख्या दोबारा लिखें';

  @override
  String get kycAccountMismatch => 'खाता संख्या मेल नहीं खाती';

  @override
  String get kycIfsc => 'IFSC कोड';

  @override
  String get kycIfscInvalid => 'सही IFSC डालें, जैसे HDFC0001234';

  @override
  String get kycBankName => 'बैंक का नाम (वैकल्पिक)';

  @override
  String get kycBankSave => 'बैंक खाता अपडेट करें';

  @override
  String get kycBankSaved => 'बैंक खाता अपडेट हो गया';

  @override
  String get featIntro =>
      'ग्राहक ऐप की प्रमुख जगहों पर दिखें। हमारी टीम हर अनुरोध की समीक्षा करती है; मंज़ूरी के बाद शुल्क आपकी कमाई से काटा जाता है।';

  @override
  String get featHomeHero => 'होम स्पॉटलाइट';

  @override
  String get featHomeHeroSub => 'ग्राहक होम स्क्रीन पर सबसे ऊपर';

  @override
  String get featCategoryTop => 'श्रेणी में सबसे ऊपर';

  @override
  String get featCategoryTopSub => 'एक विशेषज्ञता की सूची में पहला स्थान';

  @override
  String get featSearchBoost => 'खोज बूस्ट';

  @override
  String get featSearchBoostSub => 'खोज और ज्योतिषी सूचियों में ऊपर';

  @override
  String featPerDay(String amount) {
    return '$amount/दिन';
  }

  @override
  String get featRequest => 'स्लॉट का अनुरोध करें';

  @override
  String get featDates => 'तारीखें';

  @override
  String get featPickDates => 'तारीखें चुनें';

  @override
  String featMaxDays(int days) {
    return 'एक स्लॉट अधिकतम $days दिन';
  }

  @override
  String get featCategory => 'श्रेणी';

  @override
  String featTotal(String amount, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days दिन',
      one: '1 दिन',
    );
    return '$_temp0 के लिए $amount';
  }

  @override
  String get featSend => 'अनुरोध भेजें';

  @override
  String get featSent =>
      'अनुरोध भेज दिया गया। समीक्षा के बाद हम आपको सूचित करेंगे।';

  @override
  String get featMine => 'आपके स्लॉट';

  @override
  String get featEmpty => 'आपने अभी तक कोई स्लॉट नहीं मांगा है';

  @override
  String get featStatusRequested => 'समीक्षा में';

  @override
  String get featStatusScheduled => 'निर्धारित';

  @override
  String get featStatusExpired => 'समाप्त';

  @override
  String get notifMarkAll => 'सभी को पढ़ा हुआ करें';

  @override
  String get notifMarkRead => 'पढ़ा हुआ करें';

  @override
  String get notifFilterUnread => 'अपठित';

  @override
  String get notifEmptyTitle => 'सब देख लिया';

  @override
  String get notifEmptyBody => 'अनुरोध, भुगतान और समीक्षाएँ यहाँ दिखेंगी।';

  @override
  String get notifUnreadEmpty => 'कोई अपठित सूचना नहीं';

  @override
  String get notifLoadError => 'सूचनाएँ लोड नहीं हो सकीं';

  @override
  String get obTitle => 'TalkAcharya ज्योतिषी बनें';

  @override
  String obWelcome(String name) {
    return 'स्वागत है, $name';
  }

  @override
  String get obWelcomeBody =>
      'ये चरण पूरे करें और अपनी प्रोफ़ाइल जमा करें। ज़्यादातर ज्योतिषी लगभग 10 मिनट में पूरा कर लेते हैं।';

  @override
  String get obStepProfile => 'आपकी प्रोफ़ाइल';

  @override
  String get obStepProfileSub => 'शीर्षक, परिचय और अनुभव';

  @override
  String get obStepExpertise => 'विशेषज्ञता और भाषाएँ';

  @override
  String get obStepExpertiseSub => 'आप क्या करते हैं और कौन सी भाषा बोलते हैं';

  @override
  String get obStepIdentity => 'पहचान सत्यापन';

  @override
  String get obStepIdentitySub => 'पैन और एक साफ़ फ़ोटो';

  @override
  String get obStepBank => 'भुगतान खाता';

  @override
  String get obStepBankSub => 'जहाँ हम आपकी कमाई भेजेंगे';

  @override
  String get obStepReview => 'जाँचें और जमा करें';

  @override
  String get obStepReviewSub => 'अपनी प्रोफ़ाइल हमारी टीम को भेजें';

  @override
  String obProgress(int done, int total) {
    return '$total में से $done पूरे';
  }

  @override
  String get obStart => 'शुरू करें';

  @override
  String get obContinue => 'जारी रखें';

  @override
  String get obRejectedTitle => 'आपके आवेदन में बदलाव ज़रूरी हैं';

  @override
  String get obRejectedHint => 'अपनी प्रोफ़ाइल अपडेट करें और फिर से जमा करें।';

  @override
  String get obReviewTitle => 'आवेदन की समीक्षा हो रही है';

  @override
  String get obReviewBody =>
      'हमारी टीम आपकी प्रोफ़ाइल और दस्तावेज़ों की जाँच कर रही है। मंज़ूरी मिलते ही आपको सूचना मिलेगी — आमतौर पर 1–2 कार्य दिवसों में।';

  @override
  String get obReviewSubmitted => 'आवेदन जमा किया गया';

  @override
  String get obReviewChecking => 'प्रोफ़ाइल और दस्तावेज़ जाँच';

  @override
  String get obReviewLive => 'TalkAcharya पर परामर्श शुरू करें';

  @override
  String get obCheckStatus => 'स्थिति देखें';

  @override
  String get obSuspendedTitle => 'खाता निलंबित';

  @override
  String get obSuspendedBody =>
      'आपका ज्योतिषी खाता निलंबित है। कारण और दोबारा शुरू करने का तरीका जानने के लिए सहायता से संपर्क करें।';

  @override
  String get obNotAstroTitle => 'यह ज्योतिषी खाता नहीं है';

  @override
  String get obNotAstroBody =>
      'यह फ़ोन नंबर ज्योतिषी के रूप में पंजीकृत नहीं है। अगर यह गलती है तो सहायता से संपर्क करें।';

  @override
  String get wizTitle => 'अपनी प्रोफ़ाइल बनाएँ';

  @override
  String wizStepOf(int step, int total) {
    return 'चरण $step / $total';
  }

  @override
  String get wizNext => 'सहेजें और आगे बढ़ें';

  @override
  String get wizBack => 'पीछे';

  @override
  String get wizProfileIntro => 'परामर्श से पहले ग्राहक यही पढ़ते हैं।';

  @override
  String get wizBioRequired => 'ग्राहकों को अपने बारे में कुछ बताएँ';

  @override
  String get wizExpertiseIntro =>
      'वे विषय चुनें जिन पर आप परामर्श देते हैं और जो भाषाएँ आप बोलते हैं।';

  @override
  String get wizPickSkill => 'कम से कम एक विशेषज्ञता चुनें';

  @override
  String get wizPickLanguage => 'कम से कम एक भाषा चुनें';

  @override
  String get wizIdentityIntro =>
      'ग्राहकों की सुरक्षा के लिए हम हर ज्योतिषी का सत्यापन करते हैं। आपके दस्तावेज़ कभी सार्वजनिक नहीं होते।';

  @override
  String get wizPanDone => 'पैन जमा हो गया';

  @override
  String get wizPhotoDone => 'फ़ोटो जमा हो गई';

  @override
  String get wizReplace => 'बदलें';

  @override
  String get wizPhotoRequired => 'आगे बढ़ने के लिए फ़ोटो अपलोड करें';

  @override
  String get wizBankIntro =>
      'हर भुगतान चक्र के बाद आपकी कमाई इसी खाते में भेजी जाती है।';

  @override
  String get wizBankDone => 'बैंक खाता जोड़ा गया';

  @override
  String get wizBankUpdate => 'विवरण बदलें';

  @override
  String get wizReviewIntro =>
      'जाँच लें कि सब पूरा है, फिर जमा करें। हमारी टीम आमतौर पर 1–2 कार्य दिवसों में समीक्षा करती है।';

  @override
  String get wizSubmit => 'समीक्षा के लिए जमा करें';

  @override
  String get wizGapBank => 'बैंक खाता';

  @override
  String get wizStillMissing => 'पहले चिह्नित चीज़ें पूरी करें';

  @override
  String get wizFix => 'ठीक करें';

  @override
  String get wizSubmitted => 'प्रोफ़ाइल जमा हो गई!';

  @override
  String roomWaiting(String name) {
    return '$name के जुड़ने की प्रतीक्षा…';
  }

  @override
  String get roomEnd => 'समाप्त करें';

  @override
  String get roomEndTitle => 'यह परामर्श समाप्त करें?';

  @override
  String get roomEndBody => 'ग्राहक की बिलिंग रुक जाएगी और चैट बंद हो जाएगी।';

  @override
  String get roomCallEndBody => 'कॉल खत्म होते ही ग्राहक की बिलिंग रुक जाएगी।';

  @override
  String get roomEndFailed => 'परामर्श समाप्त नहीं हो सका';

  @override
  String get roomLowBalance => 'ग्राहक का बैलेंस कम है — जल्दी समाप्त करें';

  @override
  String roomRunway(int minutes) {
    return '≈$minutes मिनट बाकी';
  }

  @override
  String get roomTranslate => 'स्वतः अनुवाद';

  @override
  String get roomComposerHint => 'अपना जवाब लिखें';

  @override
  String get roomLoadError => 'यह परामर्श खुल नहीं सका';

  @override
  String get roomEndedTitle => 'परामर्श पूरा हुआ';

  @override
  String roomEndedBody(String name) {
    return '$name का मार्गदर्शन करने के लिए धन्यवाद।';
  }

  @override
  String get roomNotHeldBody =>
      'यह परामर्श नहीं हो पाया, इसलिए कोई बिलिंग नहीं हुई।';

  @override
  String get roomBackToRequests => 'अनुरोधों पर वापस जाएँ';

  @override
  String get sharedTitle => 'ग्राहक द्वारा साझा किया गया';

  @override
  String get sharedNone => 'कोई जन्म विवरण साझा नहीं';

  @override
  String get sharedNoneHint =>
      'कुंडली देखने के लिए ग्राहक से जन्म विवरण साझा करने को कहें।';

  @override
  String get sharedTimeUnknown => 'जन्म समय ज्ञात नहीं';

  @override
  String get sharedViewMatch => 'मिलान रिपोर्ट देखें';

  @override
  String get sharedMatchTitle => 'कुंडली मिलान';

  @override
  String sharedPoints(String points, String max) {
    return '$max में से $points गुण';
  }

  @override
  String get sharedNew => 'ग्राहक ने नए विवरण साझा किए';

  @override
  String get sharedAvailable => 'जन्म विवरण साझा';

  @override
  String get matchReportTitle => 'मिलान रिपोर्ट';

  @override
  String get matchKootas => 'गुण तालिका';

  @override
  String get matchDoshas => 'दोष';

  @override
  String get matchDoshaNadi => 'नाड़ी दोष';

  @override
  String get matchDoshaBhakoot => 'भकूट दोष';

  @override
  String get matchDoshaGana => 'गण दोष';

  @override
  String get matchNoDoshas => 'कोई बड़ा दोष नहीं';

  @override
  String get matchLoadError => 'मिलान रिपोर्ट लोड नहीं हो सकी';

  @override
  String sessionLiveBanner(String name) {
    return '$name के साथ लाइव';
  }

  @override
  String get sessionReturn => 'वापस जाएँ';

  @override
  String get liveSendPhoto => 'फ़ोटो भेजें';

  @override
  String get livePhotoFailed => 'फ़ोटो नहीं भेजी जा सकी';

  @override
  String get livePhotoLabel => 'फ़ोटो';

  @override
  String get errGeneric => 'कुछ गड़बड़ हो गई। कृपया फिर कोशिश करें।';

  @override
  String get errNetwork => 'सर्वर से संपर्क नहीं हो सका। अपना कनेक्शन जाँचें।';

  @override
  String get errTimeout => 'सर्वर ने जवाब देने में बहुत समय लिया।';

  @override
  String get errSession =>
      'आपका सत्र समाप्त हो गया। कृपया फिर से साइन इन करें।';

  @override
  String get errForbidden => 'आपके पास इसकी अनुमति नहीं है।';

  @override
  String get errNotFound => 'यह नहीं मिला — शायद हटा दिया गया है।';

  @override
  String get errServer =>
      'हमारे सर्वर में समस्या आ गई। कृपया थोड़ी देर बाद कोशिश करें।';

  @override
  String get errRateLimited =>
      'बहुत अधिक प्रयास। कृपया थोड़ा रुककर फिर कोशिश करें।';

  @override
  String get errOtpInvalid => 'कोड गलत है या समय समाप्त हो गया है।';

  @override
  String get errOtpMaxAttempts => 'बहुत बार गलत कोड। नया कोड मंगाएँ।';

  @override
  String get errAuthWrongApp =>
      'यह नंबर दूसरे TalkAcharya ऐप के लिए पंजीकृत है।';

  @override
  String get callMinimize => 'छोटा करें';

  @override
  String get callTapToReturn => 'कॉल पर लौटने के लिए टैप करें';

  @override
  String get callWaiting => 'प्रतीक्षा…';

  @override
  String get profileSounds => 'ध्वनि';

  @override
  String get profileSoundsDesc => 'रिंगटोन, कॉल और चैट की आवाज़ें';

  @override
  String get profileHapticFeedback => 'कंपन';

  @override
  String get profileHapticFeedbackDesc => 'बटन और अलर्ट पर कंपन';

  @override
  String get profileSoundVibration => 'ध्वनि और कंपन';

  @override
  String get profileSoundVibrationSub => 'रिंगटोन, आवाज़ें और कंपन';

  @override
  String get roomViewSummary => 'सारांश';
}
