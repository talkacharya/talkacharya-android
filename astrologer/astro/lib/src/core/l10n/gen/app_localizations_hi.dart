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

  @override
  String get callVideoPausedWeak => 'वीडियो रुका — नेटवर्क कमज़ोर है';

  @override
  String get roomFollowUpOpen => 'निःशुल्क फ़ॉलो-अप — उत्तर के लिए शुल्क नहीं';

  @override
  String roomFollowUpHours(int hours) {
    return 'निःशुल्क फ़ॉलो-अप और $hours घंटे खुला';
  }

  @override
  String roomFollowUpMinutes(int minutes) {
    return 'निःशुल्क फ़ॉलो-अप और $minutes मिनट खुला';
  }

  @override
  String get roomFollowUpHint => 'उत्तर दें (निःशुल्क फ़ॉलो-अप)';

  @override
  String get chatsFollowUpOpen => 'निःशुल्क फ़ॉलो-अप खुला';

  @override
  String chatsYouPrefix(String body) {
    return 'आप: $body';
  }

  @override
  String get quickReplies => 'त्वरित उत्तर';

  @override
  String get quickRepliesHint => 'टैप करें, संदेश बॉक्स में आ जाएगा';

  @override
  String get quickRepliesAdd => 'नया त्वरित उत्तर';

  @override
  String get quickRepliesNewHint => 'जो आप अक्सर लिखते हैं';

  @override
  String get quickRepliesDelete => 'हटाएं';

  @override
  String get quickRepliesSaveFailed => 'उत्तर सहेजा नहीं जा सका।';

  @override
  String get commonClose => 'बंद करें';

  @override
  String get roomCustomerToppingUp =>
      'ग्राहक पैसे जोड़ रहे हैं — सत्र रुका है, शुल्क नहीं लग रहा';

  @override
  String liveWaitingCount(int count) {
    return '$count प्रतीक्षा में';
  }

  @override
  String get liveWaitingTooltip =>
      'निजी परामर्श चाहने वाले दर्शक — वे आपकी कतार में हैं';

  @override
  String get callPoorConnection => 'नेटवर्क कमज़ोर है';

  @override
  String get callPeerPoorConnection => 'ग्राहक का नेटवर्क कमज़ोर है';

  @override
  String get callBothPoorConnection => 'दोनों ओर नेटवर्क कमज़ोर है';

  @override
  String get callShowChart => 'कुंडली';

  @override
  String get callHideChart => 'कुंडली छिपाएं';

  @override
  String get roomSearch => 'खोजें';

  @override
  String get roomSearchHint => 'इस बातचीत में खोजें';

  @override
  String get roomSearchEmpty => 'कुछ नहीं मिला';

  @override
  String get earnTabGifts => 'उपहार';

  @override
  String get earnGiftsEmptyTitle => 'अभी कोई उपहार नहीं';

  @override
  String get earnGiftsEmptyBody =>
      'आपके लाइव सत्र और परामर्श में मिले उपहार यहाँ दिखेंगे।';

  @override
  String get earnGiftFromLive => 'लाइव सत्र';

  @override
  String get earnGiftFromConsultation => 'परामर्श';

  @override
  String get roomDownloadTranscript => 'यह बातचीत सहेजें';

  @override
  String get predQueueTitle => 'भविष्यवाणी कतार';

  @override
  String get predQueueSubtitle => 'लिखे जाने की प्रतीक्षा में';

  @override
  String get predQueueEmptyTitle => 'कुछ भी प्रतीक्षा में नहीं';

  @override
  String get predQueueEmptyBody => 'नई भविष्यवाणी के अनुरोध यहाँ दिखेंगे।';

  @override
  String get predWorkTitle => 'भविष्यवाणी लिखें';

  @override
  String get predWorkTitleField => 'शीर्षक';

  @override
  String get predWorkBodyField => 'भविष्यवाणी';

  @override
  String predWorkWords(int count) {
    return '$count शब्द';
  }

  @override
  String get predWorkSaving => 'सहेजा जा रहा है…';

  @override
  String get predWorkSaved => 'सहेजा गया';

  @override
  String get predWorkClaim => 'लें';

  @override
  String get predWorkRelease => 'छोड़ें';

  @override
  String get predWorkDelivered => 'भेजा गया';

  @override
  String get predWorkDeliver => 'भविष्यवाणी भेजें';

  @override
  String get goLiveTitle => 'लाइव जाएं';

  @override
  String get goLiveSubtitle => 'लाइव टैब देख रहे सभी लोगों तक प्रसारण करें';

  @override
  String get goLiveStillLive => 'अभी भी लाइव — जारी रखने के लिए दोबारा जुड़ें';

  @override
  String get goLiveScheduled => 'निर्धारित — तैयार हों तो शुरू करें';

  @override
  String get goLiveRejoin => 'दोबारा जुड़ें';

  @override
  String get goLiveStart => 'शुरू करें';

  @override
  String get goLiveNewSession => 'नया सत्र शुरू करें';

  @override
  String get goLiveTitleField => 'यह सत्र किस बारे में है?';

  @override
  String get goLiveTitleHint => 'जैसे शाम का प्रश्नोत्तर — करियर';

  @override
  String get goLiveHelp =>
      'दर्शकों को यही शीर्षक दिखेगा। लाइव जाते ही आपका कैमरा और माइक चालू हो जाएंगे।';

  @override
  String get goLiveStarting => 'शुरू हो रहा है…';

  @override
  String get goLivePast => 'पिछले सत्र';

  @override
  String goLivePeak(int count) {
    return 'अधिकतम $count';
  }

  @override
  String goLiveJoined(int count) {
    return '$count जुड़े';
  }

  @override
  String goLiveGifts(String currency, String amount) {
    return '$currency $amount उपहार';
  }

  @override
  String get kundaliTitle => 'कुंडली';

  @override
  String kundaliTitleFor(String name) {
    return '$name की कुंडली';
  }

  @override
  String get kundaliTabCharts => 'चार्ट';

  @override
  String get kundaliTabPlanets => 'ग्रह';

  @override
  String get kundaliTabDasha => 'दशा';

  @override
  String get kundaliTabYogas => 'योग';

  @override
  String get kundaliTabDoshas => 'दोष';

  @override
  String get kundaliTabOverview => 'सारांश';

  @override
  String get kundaliTabRemedies => 'उपाय';

  @override
  String get kundaliTabBhava => 'भाव';

  @override
  String get kundaliTabGochar => 'गोचर';

  @override
  String get kundaliTabNumbers => 'अंक';

  @override
  String get kundaliTabAdvanced => 'विस्तृत';

  @override
  String get hostEndTitle => 'सत्र समाप्त करें?';

  @override
  String get hostStayLive => 'लाइव रहें';

  @override
  String get hostEndSession => 'सत्र समाप्त करें';

  @override
  String get hostEnd => 'समाप्त';

  @override
  String get hostChatHint => 'दर्शकों को उत्तर दें…';

  @override
  String get hostSlowMode => 'धीमा मोड';

  @override
  String get hostSlowModeBody =>
      'दो संदेशों के बीच दर्शक को कितनी देर रुकना होगा';

  @override
  String get hostPin => 'इस संदेश को पिन करें';

  @override
  String get hostHide => 'इस संदेश को छिपाएं';

  @override
  String get hostRemove => 'इस दर्शक को हटाएं';

  @override
  String get hostRemoveBody => 'वे इस स्ट्रीम में दोबारा नहीं जुड़ पाएंगे';

  @override
  String get otpResend => 'कोड दोबारा भेजें';

  @override
  String get kundaliAllCharts => 'सभी चार्ट — D1 से D60';

  @override
  String get kundaliNoYogas => 'कोई उल्लेखनीय योग नहीं मिला।';

  @override
  String get kundaliNoData => 'कोई डेटा नहीं';

  @override
  String predWorkTooShort(int min, int count) {
    return 'कम से कम $min शब्द चाहिए (अभी $count)।';
  }

  @override
  String get authTitle => 'स्वागत है, आचार्य जी';

  @override
  String get authSubtitle =>
      'अपने मोबाइल नंबर से साइन इन करें और उन लोगों तक पहुँचें जो आपके मार्गदर्शन की प्रतीक्षा कर रहे हैं।';

  @override
  String get authPhoneLabel => 'मोबाइल नंबर';

  @override
  String get authPhoneHint => '10 अंकों का नंबर';

  @override
  String get authContinue => 'आगे बढ़ें';

  @override
  String get authLegalBefore => 'मैं ';

  @override
  String get authLegalTerms => 'सेवा की शर्तों';

  @override
  String get authLegalBetween => ' और ';

  @override
  String get authLegalPrivacy => 'गोपनीयता नीति';

  @override
  String get authLegalAfter => ' से सहमत हूँ।';

  @override
  String get authLegalUnavailable => 'यह पेज अभी नहीं खुल पाया।';

  @override
  String get otpTitle => 'कोड दर्ज करें';

  @override
  String otpSentTo(String phone) {
    return '$phone पर भेजा गया';
  }

  @override
  String get otpChangeNumber => 'बदलें';

  @override
  String get otpVerify => 'सत्यापित करें';

  @override
  String otpResendIn(int seconds) {
    return '$seconds सेकंड में दोबारा भेजें';
  }

  @override
  String otpDevMode(String code) {
    return 'डेव मोड — कोड है $code';
  }

  @override
  String get callAudio => 'ऑडियो';

  @override
  String get callEarpiece => 'फ़ोन';

  @override
  String get callWiredHeadset => 'हेडसेट';

  @override
  String get callBluetooth => 'ब्लूटूथ';

  @override
  String get chatMute => 'सूचनाएँ बंद करें';

  @override
  String get chatUnmute => 'सूचनाएँ चालू करें';

  @override
  String get chatArchive => 'चैट संग्रहित करें';

  @override
  String get chatUnarchive => 'संग्रह से निकालें';

  @override
  String get chatArchivedTitle => 'संग्रहित';

  @override
  String chatArchivedRow(int count) {
    return 'संग्रहित ($count)';
  }

  @override
  String chatBlock(String name) {
    return '$name को ब्लॉक करें';
  }

  @override
  String chatUnblock(String name) {
    return '$name को अनब्लॉक करें';
  }

  @override
  String chatBlockConfirmTitle(String name) {
    return '$name को ब्लॉक करें?';
  }

  @override
  String get chatBlockConfirmYes => 'ब्लॉक करें';

  @override
  String chatBlockedByMe(String name) {
    return 'आपने $name को ब्लॉक किया है।';
  }

  @override
  String get chatBlockedByThem => 'इस बातचीत में संदेश बंद हैं।';

  @override
  String get chatMoreOptions => 'और विकल्प';

  @override
  String chatBlockConfirmBody(String name) {
    return 'यहाँ आप दोनों संदेश नहीं भेज पाएँगे, और अनब्लॉक करने तक $name आपसे परामर्श बुक नहीं कर पाएँगे।';
  }

  @override
  String get sessionChat => 'चैट';

  @override
  String get sessionVoice => 'वॉइस कॉल';

  @override
  String get sessionVideo => 'वीडियो कॉल';

  @override
  String roomLiveNow(String session) {
    return '$session चल रही है';
  }

  @override
  String astroEarnedSoFar(String amount) {
    return 'अब तक $amount कमाए';
  }

  @override
  String astroEndedEarned(String amount, int minutes) {
    return 'आपने $amount कमाए · $minutes मिनट';
  }

  @override
  String astroCustomerRated(String name, int rating) {
    return '$name ने इस सत्र को $rating/5 रेटिंग दी';
  }

  @override
  String get astroNotRatedYet => 'अभी रेटिंग नहीं मिली';

  @override
  String astroRequestInRoom(String name, String session) {
    return '$name $session के लिए अनुरोध कर रहे हैं';
  }

  @override
  String astroThreadClosed(String name) {
    return 'परामर्श समाप्त। $name कभी भी नया परामर्श शुरू कर सकते हैं।';
  }

  @override
  String sysRequested(String session) {
    return '$session का अनुरोध';
  }

  @override
  String get sysAccepted => 'आपने कॉल उठाई · कनेक्ट हो रहा है';

  @override
  String sysStarted(String session) {
    return '$session शुरू हुई';
  }

  @override
  String sysEnded(String session, int minutes) {
    return '$session समाप्त · $minutes मिनट';
  }

  @override
  String sysEndedPlain(String session) {
    return '$session समाप्त';
  }

  @override
  String get sysRejected => 'आपने अनुरोध अस्वीकार किया';

  @override
  String sysCancelled(String name) {
    return '$name ने अनुरोध रद्द किया';
  }

  @override
  String get sysExpired => 'समय पर जवाब नहीं दिया गया';

  @override
  String sysNoShow(String session) {
    return '$session कनेक्ट नहीं हुई';
  }

  @override
  String sysEndingSoon(String name) {
    return '$name का बैलेंस कम हो रहा है';
  }

  @override
  String get presenceOnBreak => 'ब्रेक पर हैं';

  @override
  String get presenceOnBreakHint =>
      'ब्रेक खत्म होते ही आप अपने आप ऑनलाइन हो जाएँगे';

  @override
  String clubTitle(String club) {
    return 'आप $club क्लब में हैं';
  }

  @override
  String get clubTitleNone => 'आपका पहला क्लब बस पास ही है';

  @override
  String clubProjection(String amount) {
    return 'इस रफ़्तार से इस महीने $amount';
  }

  @override
  String clubNeedToday(String amount, String club) {
    return '$club क्लब की रफ़्तार बनाए रखने के लिए आज $amount और कमाएँ।';
  }

  @override
  String clubOnTrack(String club) {
    return 'आज का लक्ष्य पूरा — अगला $club क्लब है। ऐसे ही चलते रहें।';
  }

  @override
  String get clubTop => 'आप सबसे ऊँचे क्लब में हैं। शानदार!';

  @override
  String get todayTitle => 'आज की कमाई';

  @override
  String get todaySub => 'प्लेटफ़ॉर्म शुल्क के बाद';

  @override
  String get todayHide => 'राशि छिपाएँ';

  @override
  String get todayShow => 'राशि दिखाएँ';

  @override
  String get todayViewEarnings => 'कमाई देखें';

  @override
  String get todaySessions => 'सेशन';

  @override
  String get todayTalkTime => 'बातचीत';

  @override
  String get todayOnline => 'ऑनलाइन';

  @override
  String scoreTitle(int days) {
    return 'पिछले $days दिन';
  }

  @override
  String scoreUpdated(String time) {
    return 'अपडेट $time';
  }

  @override
  String get scoreOpen => 'परफ़ॉर्मेंस डैशबोर्ड खोलें';

  @override
  String get perfOnlineShort => 'रोज़\nऑनलाइन';

  @override
  String get perfSessionShort => 'औसत\nसेशन';

  @override
  String get perfFirstRepeatShort => 'नए ग्राहक\nलौटे';

  @override
  String get perfLoyalShort => 'वफ़ादार\nग्राहक';

  @override
  String perfHoursMinutes(int h, int m) {
    return '$h घं $m मि';
  }

  @override
  String perfMinutesSeconds(int m, int s) {
    return '$m मि $s से';
  }

  @override
  String perfSeconds(int s) {
    return '$s से';
  }

  @override
  String perfHours(int h) {
    return '$h घं';
  }

  @override
  String perfMinutes(int m) {
    return '$m मि';
  }

  @override
  String get breakTitle => 'ब्रेक लें';

  @override
  String breakLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'आज $count ब्रेक बचे हैं',
      one: 'आज 1 ब्रेक बचा है',
    );
    return '$_temp0';
  }

  @override
  String get breakNoneLeft => 'आज के ब्रेक खत्म हो गए';

  @override
  String get breakButton => 'ब्रेक लें';

  @override
  String get breakSheetTitle => 'कितनी देर चाहिए?';

  @override
  String get breakInfo =>
      'ब्रेक के दौरान ग्राहक आपसे संपर्क नहीं कर पाएँगे। ब्रेक खत्म होते ही आप अपने आप ऑनलाइन हो जाएँगे — कुछ चालू करने की ज़रूरत नहीं।';

  @override
  String breakMinutes(int minutes) {
    return '$minutes मिनट';
  }

  @override
  String get breakStart => 'ब्रेक शुरू करें';

  @override
  String get breakOnTitle => 'ब्रेक पर हैं';

  @override
  String breakBackIn(String time) {
    return '$time में वापस ऑनलाइन';
  }

  @override
  String get breakResume => 'मैं वापस हूँ';

  @override
  String get loyalTitle => 'वफ़ादार ग्राहक';

  @override
  String loyalBody(int days, int minutes) {
    return 'वे ग्राहक जो पिछले $days दिनों में लौटे और आपके साथ $minutes+ मिनट बिताए।';
  }

  @override
  String get loyalWinBack => 'देखें कौन लौटकर नहीं आया';

  @override
  String get dashTools => 'टूल्स';

  @override
  String get dashActionPerformance => 'परफ़ॉर्मेंस';

  @override
  String get dashActionWinBack => 'ग्राहक वापसी';

  @override
  String get dashActionChats => 'चैट हिस्ट्री';

  @override
  String get dashActionRequests => 'अनुरोध';

  @override
  String get dashActionBoost => 'प्रोफ़ाइल बूस्ट';

  @override
  String get dashActionAlerts => 'सूचनाएँ';

  @override
  String get perfTitle => 'परफ़ॉर्मेंस';

  @override
  String perfSubtitle(int days) {
    return 'पिछले $days दिन, उससे पहले के $days दिनों की तुलना में।';
  }

  @override
  String get perfFocusTitle => 'किस पर ध्यान दें';

  @override
  String get perfLegendLow => 'सुधार चाहिए';

  @override
  String get perfLegendMid => 'ठीक-ठाक';

  @override
  String get perfLegendGood => 'अच्छा';

  @override
  String get perfVerdictLow => 'सुधार चाहिए';

  @override
  String get perfVerdictMid => 'बस थोड़ा और';

  @override
  String get perfVerdictGood => 'बढ़िया चल रहा है';

  @override
  String get perfVerdictNone => 'अभी पर्याप्त डेटा नहीं';

  @override
  String get perfFirstRepeat => 'नए ग्राहकों की वापसी';

  @override
  String get perfTotalRepeat => 'कुल वापसी';

  @override
  String get perfAvgSession => 'औसत सेशन';

  @override
  String get perfOnlineTime => 'औसत ऑनलाइन समय';

  @override
  String get perfMissed => 'छूटे हुए अनुरोध';

  @override
  String get perfFirstRepeatAbout =>
      'इस अवधि में पहली बार आपसे परामर्श लेने वाले ग्राहकों में से कितने दोबारा सेशन के लिए लौटे।\n\nउदाहरण: 10 नए ग्राहक, उनमें से 4 लौटे — यानी 40%।';

  @override
  String get perfTotalRepeatAbout =>
      'इस अवधि में आपने जिन भी ग्राहकों से बात की — नए हों या पुराने — उनमें से कितने आपसे एक से ज़्यादा बार परामर्श ले चुके हैं।\n\nउदाहरण: 20 ग्राहक, उनमें से 9 पहले भी आए थे या लौटे — यानी 45%।';

  @override
  String get perfAvgSessionAbout =>
      'इस अवधि का कुल बिल किया गया समय, सेशन की संख्या से भाग देकर। लंबे सेशन का मतलब अक्सर यह होता है कि ग्राहक को लगा उसकी बात सुनी गई।\n\nउदाहरण: 10 सेशन में 120 मिनट — हर सेशन 12 मिनट।';

  @override
  String get perfOnlineTimeAbout =>
      'आप रोज़ औसतन कितनी देर उपलब्ध रहे — ऑनलाइन या सेशन में। ब्रेक और ऑफ़लाइन समय नहीं गिना जाता। हम रोज़ कम से कम छह घंटे की सलाह देते हैं: ग्राहक उन्हीं ज्योतिषियों के पास लौटते हैं जो उन्हें मिल जाते हैं।';

  @override
  String get perfMissedAbout =>
      'वे अनुरोध जिनका जवाब देने से पहले समय खत्म हो गया, और वे जिन्हें आपने अस्वीकार किया। ग्राहक द्वारा रद्द किए गए अनुरोध नहीं गिने जाते। अगर थोड़ी देर हटना हो, तो अनुरोध बजते छोड़ने के बजाय ब्रेक लें।';

  @override
  String get perfHowCalculated => 'यह कैसे गिना जाता है';

  @override
  String get perfShowLess => 'कम दिखाएँ';

  @override
  String get perfNoChange => 'पिछली अवधि जैसा ही';

  @override
  String perfDeltaUp(String amount) {
    return 'पिछली अवधि से $amount ज़्यादा';
  }

  @override
  String perfDeltaDown(String amount) {
    return 'पिछली अवधि से $amount कम';
  }

  @override
  String get perfOnlineChart => 'रोज़ के ऑनलाइन घंटे';

  @override
  String perfGoalLine(int hours) {
    return '$hours घं लक्ष्य';
  }

  @override
  String perfMissedUnanswered(int count) {
    return 'समय खत्म · $count';
  }

  @override
  String perfMissedDeclined(int count) {
    return 'अस्वीकार · $count';
  }

  @override
  String get perfRatings => 'रेटिंग';

  @override
  String get perfRatingsAbout =>
      'आपसे परामर्श लेने वाले ग्राहकों की प्रकाशित रेटिंग का अब तक का औसत।';

  @override
  String get perfRatingOverall => 'कुल मिलाकर';

  @override
  String perfRatingCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count रेटिंग',
      one: '1 रेटिंग',
    );
    return '$_temp0';
  }

  @override
  String get perfNoRatings => 'अभी कोई रेटिंग नहीं';

  @override
  String get perfTipOnline =>
      'ज़्यादा देर ऑनलाइन रहना सबसे तेज़ असर करेगा — ग्राहक उसी के पास लौटते हैं जो उन्हें मिल जाए।';

  @override
  String get perfTipSession =>
      'सेशन थोड़े लंबे करें: समाप्त करने से पहले एक और सवाल पूछ लें।';

  @override
  String get perfTipFirstRepeat =>
      'पहली बार आए ग्राहकों को लौटने की वजह दें — बताएँ कि अगली बार क्या देखेंगे।';

  @override
  String get perfTipTotalRepeat =>
      'आपके पुराने ग्राहक कम हो रहे हैं। देखें कौन नहीं लौटा और उनके आने के समय ऑनलाइन रहें।';

  @override
  String get perfTipMissed =>
      'बहुत से अनुरोध छूट रहे हैं। समय खत्म होने से पहले जवाब दें, या हटना हो तो ब्रेक लें।';

  @override
  String get winBackTitle => 'ग्राहक वापसी';

  @override
  String winBackSubtitle(int days) {
    return 'वे लौटने वाले ग्राहक जिनसे $days+ दिनों से बात नहीं हुई। थ्रेड खोलकर देखें कि बात कहाँ रुकी थी।';
  }

  @override
  String winBackTile(int sessions, int minutes) {
    return '$sessions सेशन · साथ में $minutes मिनट';
  }

  @override
  String winBackLast(String time) {
    return 'पिछला सेशन $time';
  }

  @override
  String get winBackCustomer => 'ग्राहक';

  @override
  String get winBackEmptyTitle => 'कोई ग्राहक दूर नहीं हुआ';

  @override
  String get winBackEmptyBody =>
      'जो लौटने वाले ग्राहक आना बंद कर देंगे, वे यहाँ दिखेंगे।';

  @override
  String get dashActionWaitlist => 'वेटलिस्ट';

  @override
  String get dashActionCalls => 'कॉल हिस्ट्री';

  @override
  String get dashActionRemedies => 'उपाय';

  @override
  String get dashActionSounds => 'ध्वनि';

  @override
  String get waitlistTitle => 'वेटलिस्ट';

  @override
  String get waitlistSubtitle =>
      'आपका इंतज़ार कर रहे ग्राहक, सबसे पहले आने वाले ऊपर। सेशन खत्म होते ही अगले व्यक्ति को बताया जाता है कि उनकी बारी है — या आप खुद किसी को बुला सकते हैं।';

  @override
  String get waitlistEmptyTitle => 'कोई इंतज़ार में नहीं है';

  @override
  String get waitlistEmptyBody =>
      'जब आप सेशन में हों और ग्राहक आपसे जुड़ना चाहें, तो वे आपकी वेटलिस्ट में शामिल हो सकते हैं। वे यहाँ दिखेंगे।';

  @override
  String get waitlistInvite => 'बुलाएँ';

  @override
  String waitlistInvited(String name) {
    return '$name को बता दिया गया है कि उनकी बारी है';
  }

  @override
  String waitlistInvitedLeft(String time) {
    return 'बुलाया गया · जुड़ने के लिए $time';
  }

  @override
  String waitlistWaiting(String time) {
    return '$time से इंतज़ार में';
  }

  @override
  String get waitlistNew => 'नए ग्राहक';

  @override
  String waitlistRegular(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'आपके साथ $count सेशन',
      one: 'आपके साथ 1 सेशन',
    );
    return '$_temp0';
  }

  @override
  String get waitlistRemove => 'वेटलिस्ट से हटाएँ';

  @override
  String waitlistRemoveTitle(String name) {
    return '$name को हटाएँ?';
  }

  @override
  String get waitlistRemoveBody =>
      'उनकी बारी चली जाएगी और उन्हें बताया जाएगा कि आप अभी उन्हें नहीं ले सकते।';

  @override
  String get callsTitle => 'कॉल हिस्ट्री';

  @override
  String get callsFilterAll => 'सभी';

  @override
  String get callsFilterCompleted => 'पूरी हुईं';

  @override
  String get callsFilterMissed => 'छूटी हुईं';

  @override
  String get callsStatCompleted => 'पूरी हुईं';

  @override
  String get callsStatTalkTime => 'बातचीत';

  @override
  String get callsStatMissed => 'छूटी हुईं';

  @override
  String get callsEmptyTitle => 'अभी कोई कॉल नहीं';

  @override
  String get callsEmptyBody =>
      'ग्राहकों के साथ आपकी वॉइस और वीडियो कॉल यहाँ दिखेंगी।';

  @override
  String get callsEmptyFilter => 'यहाँ कुछ नहीं है';

  @override
  String get remediesTitle => 'उपाय';

  @override
  String get remediesSubtitle =>
      'स्टोर से रत्न, रुद्राक्ष, पूजा और अन्य चीज़ें, जो आपने अपने ग्राहकों को सुझाई हैं।';

  @override
  String get remediesSuggest => 'उपाय सुझाएँ';

  @override
  String remediesSummary(int sent, int bought) {
    return '$sent सुझाए · $bought खरीदे गए';
  }

  @override
  String remediesCommission(String percent) {
    return 'जब ग्राहक आपका सुझाया उपाय खरीदता है, तो आपको $percent मिलता है।';
  }

  @override
  String get remediesEmptyTitle => 'अभी तक कोई उपाय नहीं सुझाया';

  @override
  String get remediesEmptyBody =>
      'परामर्श के बाद स्टोर से कोई प्रोडक्ट सुझाएँ। ग्राहक को वह उनके ऐप में मिलता है, और खरीदने पर आपको कमीशन मिलता है।';

  @override
  String get remedyStatusSent => 'भेजा गया';

  @override
  String get remedyStatusViewed => 'देखा गया';

  @override
  String get remedyStatusPurchased => 'खरीदा गया';

  @override
  String get remedyStatusExpired => 'समाप्त';

  @override
  String remedyFor(String name, String time) {
    return '$name के लिए · $time';
  }

  @override
  String get remedySuggestTitle => 'उपाय सुझाएँ';

  @override
  String remedySuggestFor(String name) {
    return '$name के लिए';
  }

  @override
  String get remedyStepCustomer => 'किसके लिए?';

  @override
  String get remedyStepProduct => 'उपाय चुनें';

  @override
  String get remedyStepNote => 'इसे कैसे इस्तेमाल करें?';

  @override
  String get remedySearchHint => 'रत्न, रुद्राक्ष, पूजा खोजें…';

  @override
  String get remedyNoteHint => 'उदाहरण: शनिवार सुबह अनामिका उँगली में पहनें।';

  @override
  String get remedyNoProducts => 'इस खोज से कोई प्रोडक्ट नहीं मिला।';

  @override
  String get remedyNoCustomers =>
      'आप उन्हीं ग्राहकों को उपाय सुझा सकते हैं जिनसे परामर्श हुआ है। अभी कोई नहीं।';

  @override
  String get remedySend => 'सुझाव भेजें';

  @override
  String get remedySent => 'सुझाव भेज दिया गया';

  @override
  String get remedyDisclosure =>
      'ग्राहक इसे आपकी सलाह के रूप में देखता है और फ़ैसला खुद करता है। वही सुझाएँ जो कुंडली के हिसाब से ज़रूरी हो।';

  @override
  String get toolsTitle => 'सभी टूल्स';

  @override
  String get toolsGroupWork => 'आपका काम';

  @override
  String get toolsGroupCustomers => 'आपके ग्राहक';

  @override
  String get toolsGroupGrow => 'आगे बढ़ें';

  @override
  String get toolsGroupSchedule => 'समय और कमाई';

  @override
  String get toolsGroupHelp => 'अपडेट और सहायता';

  @override
  String get wsCantOpen => 'इस फ़ोन पर यह नहीं खुल सका';

  @override
  String get wsRemove => 'हटाएँ';

  @override
  String get wsNew => 'नया';

  @override
  String get wsReadMore => 'और पढ़ें';

  @override
  String get wsAnnouncements => 'घोषणाएँ';

  @override
  String get wsAnnouncementsEmpty => 'अभी कोई नई घोषणा नहीं';

  @override
  String get wsAnnouncementsEmptyBody =>
      'TalkAcharya की नीति में बदलाव, त्योहारों का समय और नई सुविधाएँ यहाँ दिखेंगी।';

  @override
  String get wsTraining => 'ट्रेनिंग';

  @override
  String get wsTrainingSubtitle =>
      'ऐप से ज़्यादा फ़ायदा उठाने के छोटे वीडियो। ये आपके वीडियो ऐप में खुलते हैं।';

  @override
  String get wsTrainingEmpty => 'अभी कोई वीडियो नहीं';

  @override
  String get wsTrainingEmptyBody => 'ट्रेनिंग वीडियो जुड़ते ही यहाँ दिखेंगे।';

  @override
  String get wsFavourites => 'पसंदीदा';

  @override
  String get wsFavouritesSubtitle =>
      'आपके चुने हुए ग्राहक, और उनके बारे में नोट जो सिर्फ़ आप देख सकते हैं।';

  @override
  String get wsFavouritesEmpty => 'अभी कोई पसंदीदा नहीं';

  @override
  String get wsFavouritesEmptyBody =>
      'किसी ग्राहक की चैट खोलें और मेनू से \"पसंदीदा में जोड़ें\" चुनें।';

  @override
  String get wsAddFavourite => 'पसंदीदा में जोड़ें';

  @override
  String wsFavouriteAdded(String name) {
    return '$name पसंदीदा में जुड़ गए';
  }

  @override
  String get wsUnfavourite => 'पसंदीदा से हटाएँ';

  @override
  String get wsEditNote => 'नोट बदलें';

  @override
  String wsNoteTitle(String name) {
    return '$name के बारे में नोट';
  }

  @override
  String get wsNoteHint =>
      'यह सिर्फ़ आपको दिखता है। उदाहरण: करियर का सवाल, दिवाली के बाद फिर बात करनी है।';

  @override
  String get wsCommunity => 'मेरी कम्युनिटी';

  @override
  String get wsCommunitySubtitle =>
      'आपको फ़ॉलो करने वाले लोग। आपके ऑनलाइन या लाइव आने पर इन्हें सूचना मिलती है।';

  @override
  String get wsFollowers => 'फ़ॉलोअर';

  @override
  String get wsNewThisWeek => 'इस हफ़्ते नए';

  @override
  String wsFollowingSince(String time) {
    return '$time जुड़े';
  }

  @override
  String get wsCommunityEmpty => 'अभी कोई फ़ॉलोअर नहीं';

  @override
  String get wsCommunityEmptyBody =>
      'ग्राहक आपकी प्रोफ़ाइल से या सेशन के बाद आपको फ़ॉलो कर सकते हैं। लाइव जाना सबसे तेज़ तरीका है।';

  @override
  String get wsReferral => 'रेफ़र करें, कमाएँ';

  @override
  String wsReferralPitch(String reward, String gift) {
    return 'आपके कोड से जुड़ने वाले हर नए ग्राहक पर $reward कमाएँ। उन्हें $gift मिलते हैं।';
  }

  @override
  String get wsCodeCopied => 'कोड कॉपी हो गया';

  @override
  String get wsShareInvite => 'निमंत्रण भेजें';

  @override
  String wsReferralShare(String code, String gift, String link) {
    return 'TalkAcharya पर मुझसे परामर्श लें। साइन अप करते समय मेरा कोड $code डालें और अपने वॉलेट में $gift पाएँ। $link';
  }

  @override
  String get wsReferralJoined => 'आपके कोड से जुड़े';

  @override
  String get wsReferralEarned => 'कमाए';

  @override
  String get wsReferralHow =>
      'जिसे आपने बुलाया, उसका पहला भुगतान वाला परामर्श पूरा होते ही इनाम आपके पेआउट में जुड़ जाता है।';

  @override
  String get wsReferralPending => 'जुड़ गए';

  @override
  String get wsReferralRewarded => 'इनाम मिला';

  @override
  String get wsReferralVoid => 'गिना नहीं गया';

  @override
  String get wsGallery => 'फ़ोटो';

  @override
  String get wsGallerySubtitle =>
      'वे तस्वीरें जो ग्राहक आपकी प्रोफ़ाइल पर देखते हैं।';

  @override
  String wsGalleryCount(int count, int max) {
    return '$max में से $count फ़ोटो';
  }

  @override
  String get wsAddPhoto => 'फ़ोटो जोड़ें';

  @override
  String get wsPhotoRemoveTitle => 'यह फ़ोटो हटाएँ?';

  @override
  String get wsGalleryRules =>
      'अपनी ही तस्वीरें लगाएँ: काम करते हुए, आपके प्रमाणपत्र, आपकी करवाई पूजाएँ। तस्वीर में फ़ोन नंबर या कोई संपर्क जानकारी न हो।';

  @override
  String get wsFeedback => 'फ़ीडबैक';

  @override
  String get wsFeedbackSubtitle =>
      'बताइए क्या ठीक नहीं चल रहा या किससे मदद मिलेगी। हम हर संदेश पढ़ते हैं।';

  @override
  String get wsFeedbackBug => 'कुछ ठीक नहीं चल रहा';

  @override
  String get wsFeedbackSuggestion => 'सुझाव';

  @override
  String get wsFeedbackPayments => 'भुगतान';

  @override
  String get wsFeedbackCustomers => 'ग्राहक';

  @override
  String get wsFeedbackOther => 'अन्य';

  @override
  String get wsFeedbackHint => 'क्या हुआ, और आप क्या चाहते थे?';

  @override
  String get wsFeedbackSend => 'फ़ीडबैक भेजें';

  @override
  String get wsFeedbackTooShort => 'कृपया थोड़ा और लिखें ताकि हम मदद कर सकें।';

  @override
  String get wsFeedbackSent => 'धन्यवाद — भेज दिया गया';

  @override
  String get wsFeedbackEarlier => 'आपने जो भेजा';

  @override
  String get wsFeedbackReply => 'TalkAcharya का जवाब';

  @override
  String get wsReplies => 'त्वरित उत्तर';

  @override
  String get wsRepliesSubtitle =>
      'वे संदेश जो आप अक्सर भेजते हैं, हर चैट में एक टैप पर। सबसे ज़्यादा इस्तेमाल वाले ऊपर आते हैं।';

  @override
  String get wsRepliesEmpty => 'अभी कोई त्वरित उत्तर नहीं';

  @override
  String get wsReplyNew => 'नया त्वरित उत्तर';

  @override
  String get wsReplyHint => 'नमस्ते! कृपया अपनी जन्म तिथि, समय और स्थान बताएँ।';

  @override
  String wsReplyUsed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count बार इस्तेमाल',
      one: '1 बार इस्तेमाल',
    );
    return '$_temp0';
  }

  @override
  String get wsCalendar => 'कैलेंडर';

  @override
  String get wsCalendarSubtitle =>
      'अगले दो हफ़्तों के आपके काम के घंटे और तय किए गए लाइव।';

  @override
  String get wsCalendarWorking => 'काम के घंटे';

  @override
  String wsCalendarLiveAt(String time) {
    return '$time बजे लाइव';
  }

  @override
  String get wsCalendarDayOff => 'छुट्टी';

  @override
  String get wsCalendarDayOffBody => 'इस दिन के लिए काम के घंटे तय नहीं हैं।';

  @override
  String get wsCalendarNoHours => 'कोई तय समय नहीं';

  @override
  String get wsCalendarNoHoursBody =>
      'आपने काम के घंटे तय नहीं किए हैं, इसलिए आप जब भी ऑनलाइन हों ग्राहक आपसे जुड़ सकते हैं।';

  @override
  String get wsCalendarEdit => 'काम के घंटे बदलें';

  @override
  String get wsCalendarNote =>
      'काम के घंटों के बाहर, ऐप खुला होने पर भी आप \'दूर\' दिखते हैं।';

  @override
  String get wsHelpline => 'हेल्पलाइन';

  @override
  String get wsHelpWhatsapp => 'WhatsApp करें';

  @override
  String get wsHelpEmail => 'ईमेल करें';

  @override
  String get wsHelpCentre => 'सहायता केंद्र';

  @override
  String get wsHelpCentreSub => 'आम सवालों के जवाब';

  @override
  String get wsHelpNone => 'सहायता की संपर्क जानकारी अभी उपलब्ध नहीं है।';

  @override
  String get wsPhotoPending => 'समीक्षा में';

  @override
  String get wsPhotoRejected => 'स्वीकृत नहीं\nकारण के लिए टैप करें';

  @override
  String get wsGalleryReviewed =>
      'नई फ़ोटो ग्राहकों को दिखने से पहले जाँची जाती हैं। इसमें आमतौर पर एक दिन लगता है।';

  @override
  String get ccTool => 'कुंडली';

  @override
  String get ccTitle => 'कुंडली';

  @override
  String get ccSubtitle =>
      'वे कुंडलियाँ जो आप खुद बनाते हैं — कोई मिलने आया, फ़ोन का ग्राहक, परिवार। ये सिर्फ़ आपको दिखती हैं।';

  @override
  String get ccNew => 'नई कुंडली';

  @override
  String get ccEmpty => 'अभी कोई कुंडली नहीं';

  @override
  String get ccEmptyBody =>
      'किसी के जन्म का विवरण जोड़ें और उनकी पूरी कुंडली देखें: चार्ट, दशा, योग, दोष और बहुत कुछ।';

  @override
  String ccMoonSign(String sign) {
    return 'चंद्र राशि $sign';
  }

  @override
  String ccDeleteTitle(String name) {
    return '$name को हटाएँ?';
  }

  @override
  String get ccDeleteBody =>
      'उनकी कुंडली आपकी सूची से हट जाएगी। इससे किए गए मिलान भी हट जाएँगे।';

  @override
  String get ccName => 'नाम';

  @override
  String get ccMale => 'पुरुष';

  @override
  String get ccFemale => 'महिला';

  @override
  String get ccOther => 'अन्य';

  @override
  String get ccBirthDate => 'जन्म तिथि';

  @override
  String get ccBirthTime => 'जन्म समय';

  @override
  String get ccTimeUnknown => 'जन्म समय पता नहीं';

  @override
  String get ccTimeUnknownHint =>
      'इसके बिना लग्न और भावों पर भरोसा नहीं किया जा सकता; ग्रह और चंद्र राशि फिर भी सही रहते हैं।';

  @override
  String get ccBirthPlace => 'जन्म स्थान';

  @override
  String get ccSave => 'कुंडली बनाएँ';

  @override
  String get mmTitle => 'कुंडली मिलान';

  @override
  String get mmSubtitle => 'आपकी सहेजी हुई दो कुंडलियों के बीच गुण मिलान।';

  @override
  String get mmBoy => 'वर';

  @override
  String get mmGirl => 'कन्या';

  @override
  String get mmRun => 'कुंडली मिलाएँ';

  @override
  String get mmRecent => 'हाल के मिलान';

  @override
  String get mmNeedTwo => 'पहले दो कुंडलियाँ जोड़ें';

  @override
  String get mmNeedTwoBody =>
      'मिलान दो सहेजी हुई कुंडलियों की तुलना करता है। शुरू करने के लिए वर और कन्या का जन्म विवरण जोड़ें।';

  @override
  String get remediesTabStore => 'स्टोर से';

  @override
  String get remediesTabFree => 'मुफ़्त उपाय';

  @override
  String get adviceTitle => 'मुफ़्त उपाय बताएँ';

  @override
  String get adviceSubtitle =>
      'कोई मंत्र, व्रत, दान — ऐसा उपाय जिसे करने में उनका कुछ खर्च न हो।';

  @override
  String get adviceListSubtitle =>
      'आपके बताए वे उपाय जिन्हें करने में कुछ खर्च नहीं होता। हर उपाय ग्राहक को उनकी चैट में भेजा गया।';

  @override
  String get adviceEmptyTitle => 'अभी कोई मुफ़्त उपाय नहीं';

  @override
  String get adviceEmptyBody =>
      'परामर्श के बाद कोई मंत्र, व्रत या दान बताएँ। यह ग्राहक को संदेश के रूप में मिलता है जिसे वे रख सकते हैं।';

  @override
  String get adviceStepLibrary => 'लाइब्रेरी से चुनें';

  @override
  String get adviceStepWrite => 'या खुद लिखें';

  @override
  String get adviceLibraryEmpty =>
      'इसके लिए लाइब्रेरी में अभी कुछ नहीं है — नीचे खुद लिखें।';

  @override
  String get adviceFieldTitle => 'उपाय';

  @override
  String get adviceFieldBody => 'कैसे करना है';

  @override
  String get adviceHowSent =>
      'यह ग्राहक को आपकी चैट में संदेश के रूप में जाता है, इसलिए चैट खुली होनी चाहिए: सेशन के दौरान, या उसके बाद के फ़ॉलो-अप समय में।';

  @override
  String get adviceSend => 'उपाय भेजें';

  @override
  String get adviceSent => 'उपाय भेज दिया गया';

  @override
  String get adviceCatMantra => 'मंत्र';

  @override
  String get adviceCatStotra => 'स्तोत्र';

  @override
  String get adviceCatDaan => 'दान';

  @override
  String get adviceCatVrat => 'व्रत';

  @override
  String get adviceCatPuja => 'पूजा';

  @override
  String get adviceCatLifestyle => 'जीवनशैली';

  @override
  String get poojaTool => 'मंदिर पूजा';

  @override
  String get poojaBookingsTool => 'मेरी बुकिंग';

  @override
  String get poojaCalendarTitle => 'मंदिर पूजा';

  @override
  String get poojaCalendarSubtitle =>
      'बुकिंग के लिए खुली पूजाएँ, सबसे नज़दीकी पहले। किसी ग्राहक को सुझाएँ — उनके बुक करने पर आपको कमीशन मिलता है।';

  @override
  String get poojaCalendarEmpty => 'अभी कोई पूजा तय नहीं';

  @override
  String get poojaCalendarEmptyBody =>
      'जब साझेदार मंदिर बुकिंग के लिए तारीखें खोलेंगे, वे यहाँ दिखेंगी।';

  @override
  String poojaFrom(String price) {
    return '$price से';
  }

  @override
  String poojaSeatsLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count जगहें बचीं',
      one: '1 जगह बची',
    );
    return '$_temp0';
  }

  @override
  String get poojaSuggest => 'ग्राहक को सुझाएँ';

  @override
  String get poojaBookingsTitle => 'मेरी बुकिंग';

  @override
  String get poojaBookingsSubtitle =>
      'आपके सुझाव पर ग्राहकों की बुक की हुई पूजाएँ, और हर एक की स्थिति।';

  @override
  String get poojaBookingsEmpty => 'अभी कोई बुकिंग नहीं';

  @override
  String get poojaBookingsEmptyBody =>
      'जब कोई ग्राहक आपकी सुझाई पूजा बुक करेगा, वह यहाँ दिखेगी।';

  @override
  String get poojaStatusPending => 'भुगतान बाकी';

  @override
  String get poojaStatusConfirmed => 'बुक हो गई';

  @override
  String get poojaStatusPerformed => 'संपन्न';

  @override
  String get poojaStatusDone => 'वीडियो भेजा गया';

  @override
  String get poojaStatusCancelled => 'रद्द';

  @override
  String get poojaNextDate => 'अगली उपलब्ध तारीख';

  @override
  String get offerTitle => 'ऑफ़र';

  @override
  String get offerSubtitle =>
      'ग्राहकों को लाने के लिए कुछ समय के लिए अपने रेट पर छूट दें।';

  @override
  String get offerPickPercent => 'छूट';

  @override
  String get offerPickDuration => 'कितनी देर चलेगा';

  @override
  String get offerPickAudience => 'किसे मिलेगा';

  @override
  String get offerPickChannels => 'किन सेशन पर';

  @override
  String get offerChannelsHint =>
      'कुछ न चुनें तो चैट, वॉइस और वीडियो तीनों पर लागू होगा।';

  @override
  String offerPercentOff(int percent) {
    return '$percent% छूट';
  }

  @override
  String offerHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count घंटे',
      one: '1 घंटा',
    );
    return '$_temp0';
  }

  @override
  String offerDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count दिन',
      one: '1 दिन',
    );
    return '$_temp0';
  }

  @override
  String get offerAudienceAll => 'सभी';

  @override
  String get offerAudienceNew => 'नए ग्राहक';

  @override
  String get offerAllChannels => 'सभी सेशन';

  @override
  String get offerChannelChat => 'चैट';

  @override
  String get offerChannelVoice => 'वॉइस';

  @override
  String get offerChannelVideo => 'वीडियो';

  @override
  String get offerWhoPays =>
      'छूट आपके रेट से जाती है: ऑफ़र चलने तक सेशन कम कीमत पर बिल होते हैं और आपकी कमाई उसी हिसाब से होती है। ग्राहकों को ऑफ़र आपकी प्रोफ़ाइल पर दिखता है।';

  @override
  String get offerStart => 'ऑफ़र शुरू करें';

  @override
  String get offerStarted => 'आपका ऑफ़र चालू हो गया';

  @override
  String get offerLiveBadge => 'अभी चालू';

  @override
  String offerEndsAt(String when) {
    return '$when को खत्म';
  }

  @override
  String get offerSessions => 'सेशन';

  @override
  String get offerEarned => 'कमाई';

  @override
  String offerSessionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count सेशन',
      one: '1 सेशन',
    );
    return '$_temp0';
  }

  @override
  String get offerEnd => 'ऑफ़र बंद करें';

  @override
  String get offerEndTitle => 'यह ऑफ़र अभी बंद करें?';

  @override
  String get offerEndBody =>
      'नए सेशन आपके सामान्य रेट पर होंगे। पहले से बुक हुए सेशन ऑफ़र की कीमत पर ही रहेंगे।';

  @override
  String get offerEarlier => 'पिछले ऑफ़र';

  @override
  String get offerOffTitle => 'ऑफ़र अभी बंद हैं';

  @override
  String get offerOffBody => 'ऑफ़र फ़िलहाल बंद हैं। बाद में देखें।';

  @override
  String get perfPromoTitle => 'वेलकम ऑफ़र वाले ग्राहक';

  @override
  String get perfPromoBody =>
      'प्लेटफ़ॉर्म के वेलकम ऑफ़र पर आए नए ग्राहक। इन सेशन के लिए आपको पूरा रेट मिलता है।';

  @override
  String get perfPromoSessions => 'सेशन';

  @override
  String get perfPromoRating => 'उनकी रेटिंग';

  @override
  String perfPromoRepeat(int returned, int customers) {
    return 'वापस आए ($customers में से $returned)';
  }
}
