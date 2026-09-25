// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get appName => 'TalkAcharya';

  @override
  String get commonOk => 'ঠিক আছে';

  @override
  String get commonCancel => 'বাতিল';

  @override
  String get commonDone => 'সম্পন্ন';

  @override
  String get commonNext => 'পরবর্তী';

  @override
  String get commonBack => 'ফিরে যান';

  @override
  String get commonRetry => 'আবার চেষ্টা করুন';

  @override
  String get commonSave => 'সংরক্ষণ';

  @override
  String get commonEdit => 'সম্পাদনা';

  @override
  String get commonDelete => 'মুছে ফেলুন';

  @override
  String get commonClose => 'বন্ধ করুন';

  @override
  String get commonContinue => 'চালিয়ে যান';

  @override
  String get commonConfirm => 'নিশ্চিত করুন';

  @override
  String get commonSeeAll => 'সব দেখুন';

  @override
  String get commonViewAll => 'সব দেখুন';

  @override
  String get commonShare => 'শেয়ার করুন';

  @override
  String get commonCopy => 'কপি করুন';

  @override
  String get commonCopied => 'কপি করা হয়েছে';

  @override
  String get commonApply => 'প্রয়োগ করুন';

  @override
  String get commonSearch => 'অনুসন্ধান';

  @override
  String get commonYes => 'হ্যাঁ';

  @override
  String get commonNo => 'না';

  @override
  String get commonLoading => 'লোড হচ্ছে…';

  @override
  String get commonSomethingWentWrong => 'কিছু ভুল হয়েছে';

  @override
  String get commonCheckConnection =>
      'ইন্টারনেট সংযোগ পরীক্ষা করে আবার চেষ্টা করুন';

  @override
  String get commonComingSoon => 'শীঘ্রই আসছে';

  @override
  String get commonToday => 'আজ';

  @override
  String get commonYesterday => 'গতকাল';

  @override
  String commonMinutesShort(int count) {
    return '$count মিনিট';
  }

  @override
  String get commonOffline => 'আপনি অফলাইনে আছেন';

  @override
  String get navHome => 'হোম';

  @override
  String get navAstrologers => 'জ্যোতিষী';

  @override
  String get navLive => 'লাইভ';

  @override
  String get navWallet => 'ওয়ালেট';

  @override
  String get navProfile => 'প্রোফাইল';

  @override
  String get authWelcomeTitle => 'বিশ্বস্ত জ্যোতিষীদের সাথে কথা বলুন';

  @override
  String get authWelcomeSubtitle =>
      'প্রেম, ক্যারিয়ার, অর্থ এবং আরও অনেক কিছুর নির্দেশনার জন্য চ্যাট বা কল করুন';

  @override
  String get authPhoneTitle => 'আপনার মোবাইল নম্বর লিখুন';

  @override
  String get authPhoneSubtitle =>
      'আপনার মোবাইল নম্বর লিখুন এবং আমরা আপনাকে একটি ওয়ান-টাইম কোড পাঠাব।';

  @override
  String authOtpSubtitle(String phone) {
    return 'আমরা $phone নম্বরে একটি ৬-সংখ্যার কোড পাঠিয়েছি।';
  }

  @override
  String authTestModeCode(String code) {
    return 'টেস্ট মোড — আপনার কোড হল $code';
  }

  @override
  String get authPhoneHint => 'মোবাইল নম্বর';

  @override
  String get authPhoneHelper =>
      'আমরা এসএমএসের মাধ্যমে একটি ওয়ান-টাইম কোড পাঠাব';

  @override
  String get authGetOtp => 'OTP পান';

  @override
  String get authOtpTitle => '৬-সংখ্যার কোডটি লিখুন';

  @override
  String authOtpSentTo(String phone) {
    return '$phone নম্বরে পাঠানো হয়েছে';
  }

  @override
  String get authOtpResend => 'কোড আবার পাঠান';

  @override
  String authOtpResendIn(int seconds) {
    return '$seconds সেকেন্ডের মধ্যে আবার পাঠান';
  }

  @override
  String get authVerify => 'যাচাই করুন';

  @override
  String get authChangeNumber => 'নম্বর পরিবর্তন করুন';

  @override
  String get authInvalidPhone => 'একটি সঠিক মোবাইল নম্বর লিখুন';

  @override
  String get authInvalidOtp => '৬-সংখ্যার কোডটি লিখুন';

  @override
  String get authWrongApp => 'এই নম্বরটি জ্যোতিষী অ্যাপের জন্য নিবন্ধিত';

  @override
  String authDevCode(String code) {
    return 'ডেভ কোড: $code';
  }

  @override
  String get authTermsNotice =>
      'চালিয়ে যাওয়ার মাধ্যমে আপনি আমাদের শর্তাবলী এবং গোপনীয়তা নীতির সাথে একমত হন';

  @override
  String get authLogout => 'লগ আউট';

  @override
  String get authLogoutConfirm =>
      'TalkAcharya থেকে লগ আউট করবেন? আপনাকে আবার সাইন ইন করতে হবে।';

  @override
  String homeGreeting(String name) {
    return 'নমস্তে, $name';
  }

  @override
  String get homeGuidanceTagline => 'নির্দেশনা, যখনই আপনার প্রয়োজন';

  @override
  String get homeGreetingFallbackName => 'সুধী';

  @override
  String get walletAddShort => 'যোগ করুন';

  @override
  String get homeChatNow => 'এখনই চ্যাট করুন';

  @override
  String get homeCallNow => 'এখনই কল করুন';

  @override
  String homeFromPerMin(String price) {
    return '$price/মিনিট থেকে';
  }

  @override
  String homeOnlineCount(int count) {
    return '$count জন অনলাইনে';
  }

  @override
  String get homeOnlineNow => 'এখন অনলাইনে';

  @override
  String get homeTalkToAstrologer => 'জ্যোতিষীর সাথে কথা বলুন';

  @override
  String get homeLiveNow => 'এখন লাইভ';

  @override
  String get homeWhatsOnYourMind => 'আপনার মনে কি চলছে?';

  @override
  String get homeTodaysHoroscope => 'আজকের রাশিফল';

  @override
  String get homeChooseYourSign => 'আপনার রাশি বেছে নিন';

  @override
  String get homeReadMore => 'আরও পড়ুন';

  @override
  String get homeShowLess => 'কম দেখান';

  @override
  String homeLuckToday(String rating) {
    return 'আজকের ভাগ্য · $rating';
  }

  @override
  String get homeTodaysPanchang => 'আজকের পঞ্চাঙ্গ';

  @override
  String get homePanchangAddProfile =>
      'আপনার এলাকার জন্য সঠিক পঞ্চাঙ্গ পেতে জন্মের বিবরণ যোগ করুন';

  @override
  String get homeFreeTools => 'ফ্রি টুলস';

  @override
  String get homeTalkAgain => 'আবার কথা বলুন';

  @override
  String get homeAddMoneyGetBonus => 'টাকা যোগ করুন, বোনাস পান';

  @override
  String get homeReferAFriend => 'বন্ধুকে রেফার করুন, দুজনেই আয় করুন';

  @override
  String get homeReferShort =>
      'আপনার কোড শেয়ার করুন — আপনারা দুজনেই ওয়ালেট ক্রেডিট পাবেন';

  @override
  String homeReferYourCode(String code) {
    return 'আপনার কোড: $code';
  }

  @override
  String get homeInvite => 'আমন্ত্রণ জানান';

  @override
  String homeResumeInProgress(String channel) {
    return '$channel · চলছে';
  }

  @override
  String homeResumePaused(String channel) {
    return '$channel · স্থগিত';
  }

  @override
  String get homeResume => 'পুনরায় শুরু করুন';

  @override
  String get homeTrustVerified =>
      'লাইভ হওয়ার আগে প্রতিটি জ্যোতিষীর আইডি যাচাই করা হয়';

  @override
  String get homeTrustPrivate => '১০০% ব্যক্তিগত এবং গোপনীয় পরামর্শ';

  @override
  String get homeTrustVolume => 'প্রতি সপ্তাহে হাজার হাজার পরামর্শ';

  @override
  String get homeCouldntLoadAstrologers => 'জ্যোতিষীদের লোড করা যায়নি';

  @override
  String get homeCouldntLoadReading => 'আজকের রিডিং আনা যায়নি';

  @override
  String get homeCouldntLoadPanchang => 'পঞ্চাঙ্গ লোড করা যায়নি';

  @override
  String get homeNoAstrologersFilter =>
      'এই মুহূর্তে এই ফিল্টারের সাথে কোনো জ্যোতিষী মেলেনি';

  @override
  String get concernLove => 'প্রেম';

  @override
  String get concernMarriage => 'বিবাহ';

  @override
  String get concernCareer => 'ক্যারিয়ার';

  @override
  String get concernFinance => 'অর্থ';

  @override
  String get concernHealth => 'স্বাস্থ্য';

  @override
  String get concernEducation => 'শিক্ষা';

  @override
  String get concernBusiness => 'ব্যবসা';

  @override
  String get concernLegal => 'আইনি';

  @override
  String get channelChat => 'চ্যাট';

  @override
  String get channelCall => 'কল';

  @override
  String get channelVoice => 'ভয়েস কল';

  @override
  String get channelVideo => 'ভিডিও কল';

  @override
  String get channelAll => 'সব';

  @override
  String get astroFilterAll => 'সব';

  @override
  String get astroSortRecommended => 'প্রস্তাবিত';

  @override
  String get astroSortTopRated => 'সেরা রেটেড';

  @override
  String get astroSortExperienced => 'সবচেয়ে অভিজ্ঞ';

  @override
  String get astroSortConsulted => 'সবচেয়ে বেশি পরামর্শ করা';

  @override
  String get astroSortNew => 'এখানে নতুন';

  @override
  String get astroOnline => 'অনলাইন';

  @override
  String get astroBusy => 'ব্যস্ত';

  @override
  String get astroNotifyMe => 'আমাকে জানান';

  @override
  String astroWaitMinutes(int count) {
    return '~$count মিনিট অপেক্ষা';
  }

  @override
  String astroPerMinute(String price) {
    return '$price/মিনিট';
  }

  @override
  String astroYearsExp(int count) {
    return '$count বছরের অভিজ্ঞতা';
  }

  @override
  String get astroRatingNew => 'নতুন';

  @override
  String astroSessionsCount(String count) {
    return '$count সেশন';
  }

  @override
  String get astroSearchHint => 'নাম, দক্ষতা বা ভাষা অনুযায়ী খুঁজুন';

  @override
  String get astroNoneFound => 'কোনো জ্যোতিষী পাওয়া যায়নি';

  @override
  String get astroNoneFoundHint =>
      'একটি ফিল্টার সরিয়ে বা অন্য কিছু লিখে চেষ্টা করুন';

  @override
  String get astroThatsEveryone => 'আপাতত এই পর্যন্তই';

  @override
  String get astroRateOnRequest => 'অনুরোধে রেট';

  @override
  String get astroCouldntLoad => 'জ্যোতিষীদের লোড করা যায়নি';

  @override
  String get astroSortBy => 'অনুসারে সাজান';

  @override
  String get astroLoadMoreFailed => 'আরও লোড করা সম্ভব হয়নি';

  @override
  String get astroDefaultSkill => 'বৈদিক জ্যোতিষশাস্ত্র';

  @override
  String astroYears(int count) {
    return '$count বছর';
  }

  @override
  String astroSessions(String count) {
    return '$count সেশন';
  }

  @override
  String get astroChat => 'চ্যাট';

  @override
  String get astroCall => 'কল করুন';

  @override
  String get astroVideo => 'ভিডিও';

  @override
  String get astroProfileTitle => 'জ্যোতিষী';

  @override
  String get astroExpertiseTitle => 'দক্ষতা';

  @override
  String get astroAboutTitle => 'সম্পর্কে';

  @override
  String get astroRatesTitle => 'পরামর্শের হার';

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
  String get astroStatRating => 'রেটিং';

  @override
  String get astroStatExperience => 'অভিজ্ঞতা';

  @override
  String get astroStatSessions => 'অধিবেশন';

  @override
  String get astroStatRepeatClients => 'পুনরাবৃত্ত গ্রাহক';

  @override
  String astroSpeaks(String languages) {
    return '$languages বলতে পারে';
  }

  @override
  String astroRepliesIn(String time) {
    return 'উত্তর আসতে ~ $time লাগবে।';
  }

  @override
  String get astroOnlineNow => 'এখন অনলাইনে';

  @override
  String get astroOfflineTitle => 'বর্তমানে অফলাইন';

  @override
  String get astroNotifyWhenOnline => 'অনলাইনে থাকলে আমাকে জানান';

  @override
  String get astroReadMore => 'আরও পড়ুন';

  @override
  String get astroReadLess => 'কম দেখান';

  @override
  String get astroCouldntLoadOne => 'এই জ্যোতিষীকে লোড করা যায়নি।';

  @override
  String get astroCallsComingSoon => 'ভয়েস ও ভিডিও কল শীঘ্রই আসছে';

  @override
  String get astroTrustLine =>
      'পরিচয়পত্র যাচাইকৃত · ব্যক্তিগত ও গোপনীয় · মিনিট অনুযায়ী মূল্য পরিশোধ করুন';

  @override
  String get walletTitle => 'ওয়ালেট';

  @override
  String get walletAvailableBalance => 'উপলব্ধ ব্যালেন্স';

  @override
  String walletOnHold(String amount) {
    return '$amount হোল্ড করা আছে';
  }

  @override
  String walletOnHoldReason(String amount) {
    return '$amount হোল্ড করা আছে · একটি কল চলছে';
  }

  @override
  String get walletAddMoney => 'টাকা যোগ করুন';

  @override
  String get walletRecentActivity => 'সাম্প্রতিক অ্যাক্টিভিটি';

  @override
  String get walletTransactions => 'লেনদেন';

  @override
  String get walletHowItWorksTitle => 'ওয়ালেট কীভাবে কাজ করে';

  @override
  String get walletHowItWorksBody =>
      'ওয়ালেট ব্যালেন্স শুধুমাত্র পরামর্শের জন্য ব্যবহৃত হয় এবং কখনও মেয়াদ শেষ হয় না। অব্যবহৃত ব্যালেন্স ফেরতযোগ্য — আমাদের রিফান্ড পলিসি দেখুন।';

  @override
  String get walletRefundPolicy => 'রিফান্ড পলিসি';

  @override
  String get walletHaveCoupon => 'কুপন কোড আছে?';

  @override
  String get walletCouponHint => 'কোড লিখুন';

  @override
  String walletCouponApplied(String amount) {
    return 'আপনার ওয়ালেটে $amount যোগ করা হয়েছে';
  }

  @override
  String get walletSecuredBy =>
      'Razorpay · UPI · কার্ড · নেটব্যাঙ্কিং দ্বারা সুরক্ষিত';

  @override
  String get walletGstInvoices => 'জিএসটি ইনভয়েস';

  @override
  String get walletInvoicesSubtitle => 'আপনার রিচার্জের জন্য ইনভয়েস এবং রসিদ';

  @override
  String get walletNoTransactions => 'এখনও কোনো লেনদেন হয়নি';

  @override
  String get walletNoTransactionsHint =>
      'শুরু করতে আপনার ওয়ালেটে টাকা যোগ করুন';

  @override
  String walletBalanceAfter(String amount) {
    return 'ব্যালেন্স $amount';
  }

  @override
  String get walletFilterAll => 'সব';

  @override
  String get walletFilterRecharge => 'যোগ করা হয়েছে';

  @override
  String get walletFilterConsultation => 'পরামর্শ';

  @override
  String get walletFilterRefund => 'ফেরত';

  @override
  String get walletFilterBonus => 'বোনাস';

  @override
  String get kindRecharge => 'টাকা যোগ করা হয়েছে';

  @override
  String get kindConsultationCharge => 'পরামর্শ';

  @override
  String get kindConsultationRefund => 'ফেরত';

  @override
  String get kindPromoCredit => 'প্রোমো ক্রেডিট';

  @override
  String get kindCouponDiscount => 'কুপন ডিসকাউন্ট';

  @override
  String get kindSignupBonus => 'সাইনআপ বোনাস';

  @override
  String get kindReferralBonus => 'রেফারেল বোনাস';

  @override
  String get kindAdjustment => 'সমন্বয়';

  @override
  String get kindGiftSpend => 'উপহার পাঠানো হয়েছে';

  @override
  String get kindHold => 'কলের জন্য সংরক্ষিত';

  @override
  String get kindChargeback => 'চার্জব্যাক';

  @override
  String get rechargeChooseAmount => 'ওয়ালেটে টাকা যোগ করুন';

  @override
  String get rechargeAmountLabel => 'পরিমাণ';

  @override
  String rechargePayAmount(String amount) {
    return '$amount প্রদান করুন';
  }

  @override
  String get rechargeAddCoupon => 'একটি কুপন কোড যোগ করুন';

  @override
  String rechargeBonusBadge(String amount) {
    return '+$amount';
  }

  @override
  String get rechargeStarterPack => 'স্টার্টার';

  @override
  String rechargeMinAmount(String amount) {
    return 'সর্বনিম্ন $amount';
  }

  @override
  String rechargeMaxAmount(String amount) {
    return 'সর্বোচ্চ $amount';
  }

  @override
  String get rechargeOpeningCheckout => 'সুরক্ষিত পেমেন্ট গেটওয়ে খোলা হচ্ছে…';

  @override
  String get rechargeConfirming =>
      'পেমেন্ট পাওয়া গেছে — আপনার ব্যালেন্স আপডেট করা হচ্ছে…';

  @override
  String rechargeSuccessTitle(String amount) {
    return '$amount যোগ করা হয়েছে';
  }

  @override
  String rechargeNewBalance(String amount) {
    return 'নতুন ব্যালেন্স $amount';
  }

  @override
  String get rechargeViewTransaction => 'লেনদেন দেখুন';

  @override
  String get rechargeFailedTitle => 'পেমেন্ট সফল হয়নি';

  @override
  String get rechargeNotCharged => 'আপনার কাছ থেকে কোনো টাকা নেওয়া হয়নি।';

  @override
  String get rechargeAutoRefund =>
      'যদি কোনো টাকা কাটা হয়ে থাকে, তবে তা ৩-৫ কার্যদিবসের মধ্যে ফেরত দেওয়া হবে।';

  @override
  String get rechargeTryAgain => 'আবার চেষ্টা করুন';

  @override
  String get rechargeChangeAmount => 'পরিমাণ পরিবর্তন করুন';

  @override
  String get rechargeCreditedSoon =>
      'পেমেন্ট পাওয়া গেছে। আমরা কিছুক্ষণের মধ্যেই আপনার ওয়ালেটে এটি যোগ করব।';

  @override
  String rechargeOfferAutoApplied(String amount, String bonus) {
    return '$amount যোগ করুন, $bonus অতিরিক্ত পান — স্বয়ংক্রিয়ভাবে প্রয়োগ করা হয়েছে';
  }

  @override
  String get profileTitle => 'প্রোফাইল';

  @override
  String get profileEditProfile => 'প্রোফাইল সম্পাদনা করুন';

  @override
  String profilePhoneMasked(String last4) {
    return '+৯১ ●●●●● $last4';
  }

  @override
  String get profileCompleteAddEmail =>
      'প্রোফাইল সম্পন্ন করতে আপনার ইমেল যোগ করুন';

  @override
  String get profileCompleteAddBirth =>
      'ব্যক্তিগত রিডিংয়ের জন্য আপনার জন্মের বিবরণ যোগ করুন';

  @override
  String get profileRoleCustomer => 'গ্রাহক';

  @override
  String get profileWallet => 'ওয়ালেট';

  @override
  String get profileBirthProfiles => 'বার্থ প্রোফাইল';

  @override
  String profileBirthProfilesCount(int count) {
    return '$count টি চার্ট';
  }

  @override
  String get profileGroupAccount => 'অ্যাকাউন্ট';

  @override
  String get profileGroupMoney => 'টাকা';

  @override
  String get profileGroupPreferences => 'পছন্দসমূহ';

  @override
  String get profileGroupSupport => 'সহায়তা';

  @override
  String get profileGroupLegal => 'আইনি';

  @override
  String get profileNotifications => 'নোটিফিকেশন';

  @override
  String get profileNotificationPrefs => 'নোটিফিকেশন পছন্দসমূহ';

  @override
  String get profileHapticFeedback => 'স্পর্শজনিত প্রতিক্রিয়া';

  @override
  String get profileHapticFeedbackDesc => 'বোতাম এবং ইন্টারঅ্যাকশনগুলিতে কম্পন';

  @override
  String get profileWalletAndTransactions => 'ওয়ালেট এবং লেনদেন';

  @override
  String get profileOrders => 'আদেশ';

  @override
  String profileOrdersUnread(int count) {
    return '$count নতুন';
  }

  @override
  String get profileReferAndEarn => 'রেফার করুন এবং আয় করুন';

  @override
  String get profileLanguage => 'ভাষা';

  @override
  String get profileCurrency => 'কারেন্সি';

  @override
  String get profileHelpCentre => 'হেল্প সেন্টার';

  @override
  String get profileContactWhatsapp => 'আমাদের সাথে হোয়াটসঅ্যাপে যোগাযোগ করুন';

  @override
  String get profileRateApp => 'TalkAcharya রেট করুন';

  @override
  String get profileShareApp => 'অ্যাপটি শেয়ার করুন';

  @override
  String profileShareMessage(String link) {
    return 'আমি জ্যোতিষীদের সাথে কথা বলার জন্য TalkAcharya ব্যবহার করছি। আপনিও চেষ্টা করুন: $link';
  }

  @override
  String get profileTerms => 'পরিষেবার শর্তাবলী';

  @override
  String get profilePrivacy => 'গোপনীয়তা নীতি';

  @override
  String get profileLicenses => 'ওপেন-সোর্স লাইসেন্স';

  @override
  String get profileDeleteAccount => 'অ্যাকাউন্ট মুছে ফেলুন';

  @override
  String profileVersion(String version, String build) {
    return 'TalkAcharya · v$version ($build)';
  }

  @override
  String get editFullName => 'পুরো নাম';

  @override
  String get editDisplayName => 'ডিসপ্লে নাম';

  @override
  String get editDateOfBirth => 'জন্ম তারিখ';

  @override
  String get editGender => 'লিঙ্গ';

  @override
  String get editGenderMale => 'পুরুষ';

  @override
  String get editGenderFemale => 'মহিলা';

  @override
  String get editGenderOther => 'অন্যান্য';

  @override
  String get editEmail => 'ইমেল';

  @override
  String get editEmailUnverified => 'যাচাই করা হয়নি';

  @override
  String get editChangePhoto => 'ছবি পরিবর্তন করুন';

  @override
  String get editProfileSaved => 'প্রোফাইল আপডেট করা হয়েছে';

  @override
  String get editProfileSaveError => 'আপনার পরিবর্তনগুলো সংরক্ষণ করা যায়নি';

  @override
  String get editGenderUndisclosed => 'না বলতে পছন্দ করেন';

  @override
  String get editNameInvalid => 'আপনার নাম লিখুন (কমপক্ষে 2 অক্ষর)';

  @override
  String get editEmailInvalid => 'একটি বৈধ ইমেল ঠিকানা লিখুন';

  @override
  String get editPhone => 'মোবাইল নম্বর';

  @override
  String get editPhoneLocked => 'আপনার লগইন নম্বর পরিবর্তন করা যাবে না';

  @override
  String get editSectionPersonal => 'ব্যক্তিগত বিবরণ';

  @override
  String get editSectionContact => 'যোগাযোগ';

  @override
  String get editDobPlaceholder => 'আপনার জন্ম তারিখ যোগ করুন';

  @override
  String get editPhotoUpdated => 'ফটো আপডেট করা হয়েছে';

  @override
  String get editCountry => 'দেশ';

  @override
  String get chooseLanguage => 'ভাষা চয়ন করুন';

  @override
  String get chooseCurrency => 'কারেন্সি চয়ন করুন';

  @override
  String get deleteAccountTitle => 'আপনার অ্যাকাউন্ট মুছে ফেলুন';

  @override
  String get deleteAccountBody =>
      'এটি স্থায়ীভাবে আপনার প্রোফাইল, বার্থ চার্ট এবং চ্যাটের ইতিহাস মুছে ফেলবে। আপনার ওয়ালেট ব্যালেন্স থাকলে তা আসল পেমেন্ট পদ্ধতিতে ফেরত দেওয়া হবে। আইনের প্রয়োজনে পরামর্শের রেকর্ড রাখা হয়।';

  @override
  String get deleteAccountHold =>
      'আপনার অ্যাকাউন্ট অবিলম্বে নিষ্ক্রিয় করা হবে এবং ৩০ দিন পরে সম্পূর্ণ মুছে ফেলা হবে। বাতিল করতে ৩০ দিনের মধ্যে আবার সাইন ইন করুন।';

  @override
  String get deleteAccountConfirm => 'হ্যাঁ, আমার অ্যাকাউন্ট মুছে ফেলুন';

  @override
  String get deleteAccountRequested =>
      'অ্যাকাউন্ট মুছে ফেলার অনুরোধ করা হয়েছে';

  @override
  String get referTitle => 'রেফার করুন এবং আয় করুন';

  @override
  String referHeroTitle(String friendAmount, String youAmount) {
    return '$friendAmount দিন, $youAmount পান';
  }

  @override
  String referHeroBody(String friendAmount, String youAmount) {
    return 'আপনার বন্ধু তাদের প্রথম পরামর্শে $friendAmount ছাড় পাবেন। তারা সেটি গ্রহণ করলে আপনি আপনার ওয়ালেটে $youAmount পাবেন।';
  }

  @override
  String get referYourCode => 'আপনার রেফারেল কোড';

  @override
  String get referShareLink => 'আমন্ত্রণ লিঙ্ক শেয়ার করুন';

  @override
  String get referInvited => 'আমন্ত্রিত';

  @override
  String get referJoined => 'যোগ দিয়েছেন';

  @override
  String get referEarned => 'আয় করেছেন';

  @override
  String get referHowItWorks => 'এটি কীভাবে কাজ করে';

  @override
  String get referStep1 =>
      'আপনার কোড বা লিঙ্ক শেয়ার করুন। আপনার বন্ধু সাইন আপ করার সময় এটি লিখবে।';

  @override
  String referStep2(String amount) {
    return 'তারা তাদের প্রথম অর্থপ্রদান পরামর্শে $amount ছাড় পাবে।';
  }

  @override
  String referStep3(String amount) {
    return 'সেই পরামর্শের বিল হওয়ার সাথে সাথেই $amount আপনার ওয়ালেটে চলে আসবে।';
  }

  @override
  String get referYourReferrals => 'আপনার রেফারেল';

  @override
  String get referStatusPending => 'পেন্ডিং';

  @override
  String get referStatusJoined => 'যোগ দিয়েছেন';

  @override
  String get referStatusRewarded => 'পুরস্কৃত';

  @override
  String referJoinedOn(String date) {
    return 'যোগ দিয়েছেন $date';
  }

  @override
  String get referFirstCallDone => 'প্রথম কল সম্পন্ন';

  @override
  String referShareText(String code, String amount, String link) {
    return 'TalkAcharya-তে আমার কোড $code ব্যবহার করুন এবং আপনার প্রথম জ্যোতিষ পরামর্শে $amount ছাড় পান। $link';
  }

  @override
  String get kundaliYogasDoshasTitle => 'যোগ ও দোষ';

  @override
  String get kundaliTabDoshas => 'দোষ';

  @override
  String get kundaliTabYogas => 'যোগ';

  @override
  String get doshaIntro =>
      'দোষ হলো জন্মছকের সংবেদনশীল বিন্দু। সময়ের সাথে সাথে, সহায়ক দশা বা প্রচলিত প্রতিকারের মাধ্যমে বেশিরভাগই প্রশমিত হয় — একজন জ্যোতিষী নিশ্চিত করেন যে আপনার জন্য আসলে কোনটি গুরুত্বপূর্ণ।';

  @override
  String get doshaDisclaimer =>
      'এগুলো শুধুমাত্র কাঠামোগত ইঙ্গিত, কোনো ভবিষ্যদ্বাণী নয়। কোনো রত্নপাথর পরার আগে বা কোনো গুরুতর প্রতিকার শুরু করার আগে একজন জ্যোতিষীর সাথে কথা বলুন।';

  @override
  String get doshaPresent => 'বর্তমান';

  @override
  String get doshaNotPresent => 'উপস্থিত নেই';

  @override
  String get doshaCancelled => 'কার্যকরভাবে বাতিল করা হয়েছে';

  @override
  String get doshaSeverityClear => 'পরিষ্কার';

  @override
  String get doshaSeverityMild => 'মৃদু';

  @override
  String get doshaSeverityModerate => 'মাঝারি';

  @override
  String get doshaSeverityStrong => 'শক্তিশালী';

  @override
  String get doshaWhy => 'কেন এটি চিহ্নিত করা হয়েছে';

  @override
  String get doshaWhatReduces => 'কী এটিকে হ্রাস করে';

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
  String get doshaClearSectionTitle => 'পরিষ্কার — আপনার চার্টে নেই';

  @override
  String get doshaAllClear => 'আপনার জন্মছকে কোনো সাধারণ দোষই উপস্থিত নেই।';

  @override
  String get doshaAskCta =>
      'একজন জ্যোতিষীকে জিজ্ঞাসা করুন এর অর্থ আপনার জন্য কী।';

  @override
  String get insightsTitle => 'ব্যক্তিত্ব ও জীবন পর্যালোচনা';

  @override
  String get insightsIntro =>
      'আপনার জন্ম (D1) চার্টের একটি বিনামূল্যে পাঠ — জীবনের প্রধান ক্ষেত্রগুলিতে এটি কোন প্রবণতাগুলির দিকে ঝুঁকে আছে। এটি আত্ম-প্রতিফলনের জন্য একটি রূপরেখা, কোনো ঘটনা বা তারিখের পূর্বাভাস নয়।';

  @override
  String get insightsDisclaimer =>
      'আপনার জন্মছক থেকে প্রাপ্ত সাধারণ নির্দেশনা, কোনো ভবিষ্যদ্বাণী নয়। এতে কোনো তারিখ উল্লেখ করা হয়নি এবং স্বাস্থ্য, আয়ু বা সম্পর্ক বিষয়ে কোনো দাবি করা হয়নি। কোনো নির্দিষ্ট বিষয়ের জন্য একজন জ্যোতিষীর সাথে কথা বলুন।';

  @override
  String get insightsAskCta =>
      'আপনার জন্মছক সম্পর্কে একজন জ্যোতিষীকে জিজ্ঞাসা করুন।';

  @override
  String get insightsWhatItReadsFrom => 'এটা থেকে যা বোঝা যায়';

  @override
  String get insightsToneSupportive => 'সহায়ক';

  @override
  String get insightsToneBalanced => 'ভারসাম্যপূর্ণ';

  @override
  String get insightsToneChallenging => 'যত্ন প্রয়োজন';

  @override
  String get insightsToneMixed => 'মিশ্র';

  @override
  String get insightsAreaPersonality => 'ব্যক্তিত্ব ও প্রকৃতি';

  @override
  String get insightsAreaAppearance => 'শারীরিক চেহারা';

  @override
  String get insightsAreaMind => 'মন ও আবেগ';

  @override
  String get insightsAreaCareer => 'কর্মজীবন ও পেশা';

  @override
  String get insightsAreaWealth => 'সম্পদ ও অর্থব্যবস্থা';

  @override
  String get insightsAreaEducation => 'শিক্ষা ও বুদ্ধিমত্তা';

  @override
  String get insightsAreaMarriage => 'বিবাহ ও জীবনসঙ্গী';

  @override
  String get insightsAreaFamily => 'পরিবার ও সম্পর্ক';

  @override
  String get insightsAreaHealth => 'স্বাস্থ্য ও জীবনীশক্তি';

  @override
  String get insightsAreaFortune => 'ভাগ্য ও ধর্ম';

  @override
  String get insightsAreaStrengths => 'শক্তি ও চ্যালেঞ্জ';

  @override
  String get predTitle => 'ভবিষ্যদ্বাণী';

  @override
  String get predReadingTitle => 'আপনার পূর্বাভাস';

  @override
  String get predRequestTitle => 'পূর্বাভাসের জন্য অনুরোধ করুন';

  @override
  String get predHeroTitle => 'আপনার জন্য লেখা একটি পূর্বাভাস';

  @override
  String get predHeroBody =>
      'একজন জ্যোতিষী আপনার জন্মছক, দশা ও বর্তমান গ্রহের গোচর বিশ্লেষণ করে জীবনের একটি নির্দিষ্ট ক্ষেত্রের জন্য পূর্বাভাস লিখে দেন। এটি সাধারণত ৩ দিনের মধ্যে আপনার ভাষায় পৌঁছে দেওয়া হয়।';

  @override
  String get predChooseArea => 'একটি এলাকা নির্বাচন করুন';

  @override
  String get predMyReadings => 'আপনার পূর্বাভাস';

  @override
  String get predNoReadings =>
      'এখনো কোনো পূর্বাভাস নেই। একটির জন্য অনুরোধ করতে ওপরে একটি এলাকা বেছে নিন।';

  @override
  String get predSeePacks => 'প্যাকগুলি দেখুন';

  @override
  String get predSubscribed => 'সাবস্ক্রাইব করা হয়েছে';

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
  String get predBuyTitle => 'ভবিষ্যদ্বাণীর কৃতিত্ব';

  @override
  String get predBuyBody =>
      'এক ক্রেডিট = একটি লিখিত পূর্বাভাস। একটি প্যাক কিনুন এবং যখনই আপনার রিডিং প্রয়োজন হবে, তা প্রস্তুত থাকবে।';

  @override
  String get predBuyWalletNote =>
      'আপনার ওয়ালেট ব্যালেন্স থেকে পরিশোধ করা হয়েছে।';

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
    return 'প্রতি ক্রেডিটে $price';
  }

  @override
  String predBuySuccess(int count) {
    return 'যোগ করা হয়েছে। এখন আপনার $count টি ক্রেডিট আছে।';
  }

  @override
  String get predForProfile => 'কোন জন্ম প্রোফাইলের জন্য';

  @override
  String get predAddProfile => 'জন্ম প্রোফাইল যোগ করুন';

  @override
  String get predPickProfile => 'প্রথমে একটি জন্ম প্রোফাইল বেছে নিন।';

  @override
  String get predArea => 'জীবনের ক্ষেত্র';

  @override
  String get predPeriod => 'সময়কাল';

  @override
  String predCostsOne(int count) {
    return 'আপনার $count ক্রেডিটের মধ্যে ১টি ব্যবহার করে।';
  }

  @override
  String get predNoCreditYet =>
      'আপনার একটি ক্রেডিট লাগবে — আমরা এরপর প্যাকগুলো দেখাবো।';

  @override
  String get predRequestCta => 'পূর্বাভাস অনুরোধ করুন';

  @override
  String get predRequestDisclaimer =>
      'জ্যোতিষী আপনার জন্মছক, দশা এবং গোচরের উপর ভিত্তি করে ভবিষ্যদ্বাণী করেন। জ্যোতিষশাস্ত্র হলো আত্মচিন্তা ও পরিকল্পনার জন্য একটি পথনির্দেশনা, কোনো নিশ্চয়তা নয়।';

  @override
  String get predAreaCareer => 'পেশা ও কাজ';

  @override
  String get predAreaMarriage => 'বিবাহ ও ভালোবাসা';

  @override
  String get predAreaFinance => 'অর্থ ও অর্থায়ন';

  @override
  String get predAreaHealth => 'স্বাস্থ্য ও শক্তি';

  @override
  String get predAreaEducation => 'অধ্যয়ন ও শিক্ষা';

  @override
  String get predAreaGeneral => 'জীবনের সংক্ষিপ্ত বিবরণ';

  @override
  String get predPeriodMonth => 'সামনের মাস';

  @override
  String get predPeriodQuarter => 'পরবর্তী ৩ মাস';

  @override
  String get predPeriodYear => 'আগামী বছর';

  @override
  String get predStatusWriting => 'লেখা হচ্ছে';

  @override
  String get predStatusReview => 'পর্যালোচনাধীন';

  @override
  String get predStatusReady => 'পড়ার জন্য প্রস্তুত';

  @override
  String get predStatusUnavailable => 'উপলব্ধ নয়';

  @override
  String get predStatusRefunded => 'ফেরত দেওয়া হয়েছে';

  @override
  String predDeliveredOn(String date) {
    return '$date -এ বিতরণ করা হয়েছে';
  }

  @override
  String predEta(String date) {
    return '$date এর মধ্যে প্রত্যাশিত।';
  }

  @override
  String get predWritingTitle => 'একজন জ্যোতিষী এটি লিখছেন।';

  @override
  String get predWritingBody =>
      'প্রস্তুত হওয়া মাত্রই আমরা আপনাকে একটি বিজ্ঞপ্তি পাঠিয়ে দেব।';

  @override
  String predWritingEta(String date) {
    return '$date মধ্যে পাওয়ার আশা করা হচ্ছে। প্রস্তুত হয়ে গেলে আমরা আপনাকে জানিয়ে দেব।';
  }

  @override
  String get predRefundedTitle => 'ক্রেডিট ফেরত দেওয়া হয়েছে';

  @override
  String get predRefundedBody =>
      'আমরা সময়মতো এটি সরবরাহ করতে পারিনি, তাই আপনার ক্রেডিট আপনার অ্যাকাউন্টে ফেরত দেওয়া হয়েছে।';

  @override
  String get predDisclaimer =>
      'আপনার জন্মছক, দশা এবং বর্তমান গোচরের উপর ভিত্তি করে একজন জ্যোতিষী এটি আপনার জন্য লিখেছেন। জ্যোতিষশাস্ত্র হলো আত্ম-প্রতিফলন এবং পরিকল্পনার জন্য একটি পথনির্দেশনা — সিদ্ধান্ত এবং তার ফলাফল আপনারই থাকবে।';

  @override
  String get predAskFollowUp => 'একটি ফলো-আপ প্রশ্ন জিজ্ঞাসা করুন';

  @override
  String get remediesTitle => 'প্রতিকার';

  @override
  String get remediesIntro =>
      'আপনার জন্মছকে যা দেখা যায়—অর্থাৎ এর সক্রিয় দোষ, দুর্বল গ্রহ, চলমান দশা এবং পীড়িত ভাব—তার সাথে মিলিয়ে প্রচলিত প্রতিকার। এগুলি হলো শৃঙ্খলা ও ভক্তির অনুশীলন, যা আপনার বিশ্বাস, স্বাস্থ্য এবং সামর্থ্য অনুযায়ী বেছে নেওয়া হয়।';

  @override
  String get remediesNone =>
      'আপনার চার্টে এমন কিছু বিশেষভাবে লক্ষণীয় নয় যার জন্য এখনই কোনো নির্দিষ্ট প্রতিকারের প্রয়োজন। অল্প পরিমাণে এবং নিয়মিতভাবে প্রতিদিনের অভ্যাস বজায় রাখা সর্বদা ফলপ্রসূ।';

  @override
  String get remediesDisclaimer =>
      'কেবল তাই করুন যা আপনার বিশ্বাস, স্বাস্থ্য এবং সামর্থ্যের সাথে সামঞ্জস্যপূর্ণ। যদি আপনার জন্য অনিরাপদ হয় তবে রোজা রাখা থেকে বিরত থাকুন এবং দান করার জন্য কখনো ঋণ নেবেন না।';

  @override
  String get remediesAskCta =>
      'আপনার প্রতিকার সম্পর্কে একজন জ্যোতিষীর সাথে কথা বলুন।';

  @override
  String get remediesConfirmCta =>
      'প্রথমে একজন জ্যোতিষীর সাথে নিশ্চিত হয়ে নিন।';

  @override
  String remediesSource(String source) {
    return 'উৎস: $source';
  }

  @override
  String get doshaSeeRemedies => 'আপনার চার্টের প্রতিকারগুলো দেখুন';

  @override
  String get remedyCatMantra => 'মন্ত্র ও জপ';

  @override
  String get remedyCatStotra => 'স্তোত্র ও আবৃত্তি';

  @override
  String get remedyCatPuja => 'পূজা ও আচার-অনুষ্ঠান';

  @override
  String get remedyCatVrat => 'ব্রত ও উপবাস';

  @override
  String get remedyCatDaan => 'দান ও দাতব্য';

  @override
  String get remedyCatLifestyle => 'জীবনধারা';

  @override
  String get remedyCatYantra => 'যন্ত্র';

  @override
  String get remedyCatGemstone => 'রত্নপাথর';

  @override
  String get remedyCatRudraksha => 'রুদ্রাক্ষ';

  @override
  String get prashnaTitle => 'একটি প্রশ্ন জিজ্ঞাসা করুন';

  @override
  String get prashnaHeroTitle => 'এই মুহূর্তে হ্যাঁ বা না';

  @override
  String get prashnaHeroBody =>
      'কেপি হোরারি (প্রশ্ন) আপনার প্রশ্ন করার সঠিক মুহূর্তটি পড়ে, যা যুক্তিসহকারে একটি ঝোঁক—হ্যাঁ, না বা মিশ্র—প্রদান করে। এটি একটি প্রচলিত পদ্ধতির ইঙ্গিত, কোনো প্রতিশ্রুতি নয়।';

  @override
  String get prashnaAbout => 'প্রশ্নটি কী বিষয়ে?';

  @override
  String get prashnaHint => 'যেমন, আমি কি এই চাকরির প্রস্তাবটি পাব?';

  @override
  String prashnaAskCta(String price) {
    return 'জিজ্ঞাসা করুন ( $price )';
  }

  @override
  String get prashnaDisclaimer =>
      'আপনার জিজ্ঞাসার মুহূর্তের একটি কেপি হোরালি রিডিং। এটি একটি প্রচলিত পদ্ধতির নির্দেশক — কোনো প্রতিশ্রুতি নয়, এবং এটি পূর্ণাঙ্গ পরামর্শের বিকল্পও নয়।';

  @override
  String get prashnaNeedQuestion =>
      'প্রথমে একটি বিষয় বেছে নিন এবং আপনার প্রশ্নটি টাইপ করুন।';

  @override
  String get prashnaLowBalance =>
      'আপনার ওয়ালেট ব্যালেন্স খুব কম। অনুরোধ করতে টাকা যোগ করুন।';

  @override
  String get prashnaHistory => 'আপনার প্রশ্নগুলি';

  @override
  String get prashnaNoHistory => 'আপনি এখনো কোনো প্রশ্ন করেননি।';

  @override
  String get prashnaAnswerTitle => 'পড়া';

  @override
  String get prashnaAskAstrologer =>
      'একজন জ্যোতিষীর সাথে বিষয়টি নিয়ে আলোচনা করুন';

  @override
  String get prashnaHowRead => 'এটি কীভাবে পড়া হয়েছিল';

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
  String get prashnaVerdictYes => 'হ্যাঁ-এর দিকে ঝুঁকছি';

  @override
  String get prashnaVerdictNo => 'ঝুঁকে না';

  @override
  String get prashnaVerdictMixed => 'মিশ্র সংকেত';

  @override
  String get prashnaVerdictUnclear => 'সিদ্ধান্তহীন';

  @override
  String get prashnaCatMarriage => 'বিবাহ';

  @override
  String get prashnaCatJob => 'একটি চাকরি';

  @override
  String get prashnaCatPromotion => 'পদোন্নতি';

  @override
  String get prashnaCatBusiness => 'ব্যবসা';

  @override
  String get prashnaCatProperty => 'সম্পত্তি';

  @override
  String get prashnaCatMoney => 'একটি ঋণ বা টাকা';

  @override
  String get prashnaCatChild => 'শিশুরা';

  @override
  String get prashnaCatTravel => 'বিদেশ ভ্রমণ';

  @override
  String get prashnaCatLitigation => 'আদালতের একটি বিষয়';

  @override
  String get prashnaCatHealth => 'স্বাস্থ্য ও পুনরুদ্ধার';

  @override
  String get prashnaCatLost => 'একটি হারানো জিনিস';

  @override
  String get prashnaCatReunion => 'একটি পুনর্মিলন';

  @override
  String get prashnaCatGeneral => 'অন্য কিছু';

  @override
  String get yogaIntro =>
      'যোগ হলো প্রবণতা, নিশ্চয়তা নয় — সংশ্লিষ্ট গ্রহগুলি শুভ অবস্থানে থাকলে এবং তাদের দশা চললে এগুলি আরও শক্তিশালী হয়।';

  @override
  String get yogaNoneTitle => 'কোন শাস্ত্রীয় যোগ সনাক্ত করা যায়নি';

  @override
  String get yogaNoneBody =>
      'এটা সাধারণ এবং কোনো খারাপ লক্ষণ নয় — জন্মছকটি এখনও এর ভাব ও দশার মাধ্যমেই পাঠ করা হয়।';

  @override
  String get kundaliTalkToAstrologer => 'একজন জ্যোতিষীর সাথে কথা বলুন';

  @override
  String get kundaliHowItPlaysOut =>
      'জানতে চান এগুলো আপনার জীবনে ও সময়ে কীভাবে প্রভাব ফেলে?';

  @override
  String get yogaGajakesariName => 'গজকেশরী যোগ';

  @override
  String get yogaGajakesariMeaning =>
      'চন্দ্রের কেন্দ্রস্থানে বৃহস্পতি — স্থিরতা, সুবিবেচনা এবং একটি প্রভাবশালী নাম।';

  @override
  String get yogaBudhadityaName => 'বুধাদিত্য যোগ';

  @override
  String get yogaBudhadityaMeaning =>
      'সূর্য ও বুধের সংযোগ — তীক্ষ্ণ ও ভাবপ্রকাশক মন; অধ্যয়ন, লেখা ও বিশ্লেষণে শক্তিশালী।';

  @override
  String get yogaChandraMangalaName => 'চন্দ্র-মঙ্গল যোগ';

  @override
  String get yogaChandraMangalaMeaning =>
      'চন্দ্র ও মঙ্গল — অর্থ ও উদ্যোগকে কেন্দ্র করে চালিকাশক্তি; প্রচেষ্টা ও উদ্যোগের মাধ্যমে উপার্জন।';

  @override
  String get yogaRajaName => 'রাজা যোগ';

  @override
  String get yogaRajaMeaning =>
      'কেন্দ্র অধিপতির সঙ্গে ত্রিকোণ অধিপতির সংযোগ থাকলে, এই দশা চলাকালীন মর্যাদা, কর্তৃত্ব এবং সুযোগের উন্নতি ঘটে।';

  @override
  String get yogaDhanaName => 'ধন যোগ';

  @override
  String get yogaDhanaMeaning =>
      'সম্পদ ও লাভের সংযুক্তি — যা সঞ্চয় এবং স্থিতিশীল আর্থিক বৃদ্ধিকে সমর্থন করে।';

  @override
  String get yogaNeechabhangaName => 'নীচভঙ্গ রাজ যোগ';

  @override
  String get yogaNeechabhangaMeaning =>
      'একটি দুর্বল গ্রহ যার দুর্বলতা দূর হয়ে যায় — এক প্রাথমিক সংগ্রাম যা শক্তিতে রূপান্তরিত হয়।';

  @override
  String get yogaKaalSarpaName => 'কাল সর্প যোগ';

  @override
  String get yogaKaalSarpaMeaning =>
      'রাহু-কেতু অক্ষের এক দিকে সাতটি গ্রহের অবস্থান — একটি স্পষ্ট দিকনির্দেশনা না পাওয়া পর্যন্ত জীবন আবদ্ধ মনে হতে পারে।';

  @override
  String get yogaAdhiName => 'আধি যোগ';

  @override
  String get yogaAdhiMeaning =>
      'চন্দ্র থেকে ষষ্ঠ, সপ্তম ও অষ্টম ঘরে শুভ গ্রহ — সুরক্ষা, দক্ষ সহায়ক এবং স্থিতিশীল অবস্থান।';

  @override
  String get yogaShakataName => 'শাকাতা যোগ';

  @override
  String get yogaShakataMeaning =>
      'বৃহস্পতি থেকে ৬ষ্ঠ, ৮ম বা ১২তম স্থানে চন্দ্র — ভাগ্যের উত্থান-পতন; চন্দ্র শক্তিশালী হলে তা আরও স্থিতিশীল থাকে।';

  @override
  String get yogaVishName => 'বিশ যোগ';

  @override
  String get yogaVishMeaning =>
      'চন্দ্র ও শনি — মনের গুরুত্ব অপরিসীম; ফলাফল সাধারণত দেরিতে, পরিপক্কতার সাথে আসে।';

  @override
  String get yogaKahalaName => 'কাহালা যোগ';

  @override
  String get yogaKahalaMeaning =>
      'শক্তিশালী লগ্ন অধিপতির সাথে পারস্পরিক কেন্দ্রে চতুর্থ ও নবম অধিপতি — সাহসী, উদ্যোগী, ঝুঁকি নিতে ইচ্ছুক।';

  @override
  String get yogaPushkalaName => 'পুষ্কল যোগ';

  @override
  String get yogaPushkalaMeaning =>
      'কেন্দ্রে লগ্নপতির সাথে চন্দ্রপতির অবস্থান — সম্মান, সুখ্যাতি এবং প্ররোচনামূলক বক্তৃতা।';

  @override
  String get yogaDaridraName => 'দারিদ্রা যোগ';

  @override
  String get yogaDaridraMeaning =>
      'একাদশ (লাভ) ভাবের অধিপতি একটি প্রতিকূল ঘরে অবস্থান করলে লাভ ধীরে ধীরে আসে; একটি শক্তিশালী দশা পরিস্থিতি পাল্টে দেয়।';

  @override
  String get yogaAmalaName => 'আমলা যোগ';

  @override
  String get yogaAmalaMeaning =>
      'লগ্ন বা চন্দ্র থেকে দশম ঘরে কেবল শুভ গ্রহ থাকলে — নির্মল খ্যাতি এবং দীর্ঘস্থায়ী সদিচ্ছা লাভ হয়।';

  @override
  String get yogaSaraswatiName => 'সরস্বতী যোগ';

  @override
  String get yogaSaraswatiMeaning =>
      'বুধ, শুক্র এবং শক্তিশালী বৃহস্পতির শুভ অবস্থান — জ্ঞান, শিল্পকলা এবং বাগ্মিতা।';

  @override
  String get yogaLakshmiName => 'লক্ষ্মী যোগ';

  @override
  String get yogaLakshmiMeaning =>
      'কেন্দ্র বা ত্রিকোণে শক্তিশালী নবম অধিপতি এবং শক্তিশালী লগ্ন অধিপতির অবস্থান — সৌভাগ্য, স্বস্তি এবং কৃপা।';

  @override
  String get yogaRuchakaName => 'রুচক যোগ';

  @override
  String get yogaRuchakaMeaning =>
      'কেন্দ্রে মঙ্গল শক্তিশালী হলে — সাহস, শারীরিক তেজ এবং চাপের মুখে নেতৃত্ব দেওয়ার ক্ষমতা।';

  @override
  String get yogaBhadraName => 'ভদ্র যোগ';

  @override
  String get yogaBhadraMeaning =>
      'কেন্দ্রে বুধ শক্তিশালী হলে বুদ্ধিমত্তা, স্পষ্ট বাচনভঙ্গি এবং ব্যবসা ও যোগাযোগে দক্ষতা প্রকাশ পায়।';

  @override
  String get yogaHamsaName => 'হামসা যোগ';

  @override
  String get yogaHamsaMeaning =>
      'কেন্দ্রে বৃহস্পতি শক্তিশালী হলে — প্রজ্ঞা, নৈতিকতা, শিক্ষাদান বা পরামর্শ দেওয়ার স্বভাব এবং সার্বিক সৌভাগ্য নির্দেশ করে।';

  @override
  String get yogaMalavyaName => 'মালব্য যোগ';

  @override
  String get yogaMalavyaMeaning =>
      'কেন্দ্রে শুক্র শক্তিশালী হলে — আকর্ষণ, স্বাচ্ছন্দ্য, সৌন্দর্যবোধ এবং একটি সুখকর পারিবারিক জীবন।';

  @override
  String get yogaSasaName => 'সাসা যোগ';

  @override
  String get yogaSasaMeaning =>
      'কেন্দ্রে শনি শক্তিশালী হলে — শৃঙ্খলা, সহনশীলতা এবং কর্তৃত্ব ধীরে ধীরে গড়ে ওঠে এবং বজায় থাকে।';

  @override
  String get yogaUbhayachariName => 'উভয়চারী যোগ';

  @override
  String get yogaUbhayachariMeaning =>
      'সূর্যের উভয় পাশে গ্রহ — একটি সুপ্রতিষ্ঠিত ও দৃশ্যমান জীবন এবং সার্বিকভাবে ভালো অবস্থান।';

  @override
  String get yogaVesiName => 'ভেসি যোগ';

  @override
  String get yogaVesiMeaning =>
      'সূর্য থেকে ২য় ঘরে অবস্থিত গ্রহ — স্থির বাচনভঙ্গি, ভারসাম্যপূর্ণ দৃষ্টিভঙ্গি এবং একটি সুন্দর নাম।';

  @override
  String get yogaVasiName => 'ভাসি যোগ';

  @override
  String get yogaVasiMeaning =>
      'সূর্য থেকে দ্বাদশ ঘরে গ্রহ — সক্ষমতা, প্রভাব এবং উদারতা।';

  @override
  String get yogaShubhaKartariName => 'শুভ কর্তারি যোগ';

  @override
  String get yogaShubhaKartariMeaning =>
      'লগ্নের উভয় পাশের শুভ গ্রহ — সুরক্ষা, একটি সহজতর পথ এবং সহায়ক পরিস্থিতি।';

  @override
  String get yogaPapaKartariName => 'পাপা কারতারি যোগ';

  @override
  String get yogaPapaKartariMeaning =>
      'লগ্নের উভয় পাশে অশুভ গ্রহের অবস্থান — আত্মপরিচয় ও স্বাস্থ্যের উপর চাপ; আপনার শক্তি ও সীমানা রক্ষা করুন।';

  @override
  String get yogaDurudharaName => 'দুরুধারা যোগ';

  @override
  String get yogaDurudharaMeaning =>
      '২য় এবং ১২শ ঘরে গ্রহগুলো চন্দ্রকে ঘিরে রয়েছে — যা আপনার চারপাশে সম্পদ, স্বস্তি এবং অবিচল সমর্থন নির্দেশ করে।';

  @override
  String get yogaSunaphaName => 'সুনাফা যোগ';

  @override
  String get yogaSunaphaMeaning =>
      'চন্দ্র থেকে দ্বিতীয় ঘরে গ্রহ — স্বনির্ভরতা, বুদ্ধিমত্তা এবং সুখ্যাতি।';

  @override
  String get yogaAnaphaName => 'আনফা যোগ';

  @override
  String get yogaAnaphaMeaning =>
      'চন্দ্র থেকে দ্বাদশ ঘরে গ্রহ — সহজ স্বভাব, সুস্থতা এবং অভাবমুক্তি।';

  @override
  String get yogaKemadrumaYogaName => 'কেমাদ্রুমা যোগ';

  @override
  String get yogaKemadrumaYogaMeaning =>
      'চাঁদ একা, অবলম্বনহীন — এক অভ্যন্তরীণ অস্থিরতা যা চাঁদ শক্তিশালী হলে বা কোনো কেন্দ্র অধিষ্ঠিত থাকলে প্রশমিত হয়।';

  @override
  String get yogaVasumatiName => 'বসুমতি যোগ';

  @override
  String get yogaVasumatiMeaning =>
      'লগ্ন বা চন্দ্র থেকে বৃদ্ধির ঘরে শুভ গ্রহের অবস্থান — সম্পদ সঞ্চয় এবং সমৃদ্ধির ইঙ্গিত দেয়।';

  @override
  String get yogaKalanidhiName => 'কালানিধি যোগ';

  @override
  String get yogaKalanidhiMeaning =>
      'দ্বিতীয় বা পঞ্চম ঘরে বুধ বা শুক্রের সাথে বৃহস্পতির সংযোগ — জ্ঞান, শিল্পকলা, পরিশীলতা এবং সম্মান।';

  @override
  String get yogaChamaraName => 'চামারা যোগ';

  @override
  String get yogaChamaraMeaning =>
      'কেন্দ্রে অবস্থিত এবং বৃহস্পতি দ্বারা দৃষ্ট উচ্চস্থ লগ্নপতি — বাগ্মিতা, দীর্ঘ জীবন এবং সম্মানিত অবস্থান।';

  @override
  String get yogaShankhaName => 'শঙ্খ যোগ';

  @override
  String get yogaShankhaMeaning =>
      'পঞ্চম ও ষষ্ঠ অধিপতি শক্তিশালী লগ্ন অধিপতির সাথে যুক্ত থাকলে — ভালো জীবন, দয়ালু স্বভাব এবং পরবর্তী জীবনে স্বাচ্ছন্দ্য আসে।';

  @override
  String get yogaParvataName => 'পর্বতা যোগ';

  @override
  String get yogaParvataMeaning =>
      'কেন্দ্রস্থানে শুভ গ্রহের অবস্থান এবং ষষ্ঠ ও অষ্টম ভাব নির্মল থাকলে — সৌভাগ্য, উদারতা এবং খ্যাতি লাভ হয়।';

  @override
  String get yogaHarshaName => 'হর্ষ যোগ';

  @override
  String get yogaHarshaMeaning =>
      'কঠিন ঘরে ষষ্ঠ অধিপতি — শত্রু, ঋণ এবং অসুস্থতার প্রভাব কমে যায়; প্রতিযোগিতামূলক শক্তি বৃদ্ধি পায়।';

  @override
  String get yogaSaralaName => 'সরলা যোগ';

  @override
  String get yogaSaralaMeaning =>
      'প্রতিকূল ঘরে অষ্টম অধিপতি — সংকটকালে সহনশীলতা, দীর্ঘায়ু এবং নির্ভীকতা।';

  @override
  String get yogaVimalaName => 'বিমলা যোগ';

  @override
  String get yogaVimalaMeaning =>
      'কঠিন ঘরে দ্বাদশ অধিপতি — নিয়ন্ত্রিত ব্যয়, নির্মল বিবেক এবং স্বাধীন জীবন।';

  @override
  String get yogaMahaParivartanaName => 'মহা পরিবর্তন যোগ';

  @override
  String get yogaMahaParivartanaMeaning =>
      'দুটি ভালো ঘরের অধিপতিরা চিহ্ন বিনিময় করেন — সময়ের সাথে সাথে উভয় ঘরের বিষয়াবলী একে অপরকে উন্নত করে।';

  @override
  String get yogaKhalaParivartanaName => 'খালা পরিবর্তন যোগ';

  @override
  String get yogaKhalaParivartanaMeaning =>
      'তৃতীয় ভাব সম্পর্কিত আদানপ্রদান — মিশ্র ফলাফল, উত্থান-পতন, প্রচেষ্টা ও সাহসের মাধ্যমে লাভ।';

  @override
  String get yogaDainyaParivartanaName => 'দৈন্য পরিবর্তন যোগ';

  @override
  String get yogaDainyaParivartanaMeaning =>
      'একটি কঠিন ঘর সংক্রান্ত বিনিময় — এমন বাধা যার জন্য ধৈর্যের প্রয়োজন; একটি শক্তিশালী দশা পরিস্থিতি পাল্টে দেয়।';

  @override
  String get kSignAries => 'সাহসী, সরাসরি, দ্রুত শুরু করুন';

  @override
  String get kSignTaurus => 'স্থির, সংবেদনশীল, আরাম ও নিরাপত্তাকে গুরুত্ব দেয়';

  @override
  String get kSignGemini => 'কৌতূহলী, বাকপটু, দ্রুত চিন্তাশীল';

  @override
  String get kSignCancer => 'যত্নশীল, রক্ষাকারী, অনুভূতি দ্বারা চালিত';

  @override
  String get kSignLeo => 'গর্বিত, আন্তরিক, সবার নজরে আসতে চায়';

  @override
  String get kSignVirgo => 'সুনির্দিষ্ট, দরকারী, উন্নতিমুখী';

  @override
  String get kSignLibra => 'ন্যায্য, সম্পর্কযুক্ত, ভারসাম্য খোঁজে';

  @override
  String get kSignScorpio => 'তীব্র, একান্ত, হয়-না হয় কিছুই না';

  @override
  String get kSignSagittarius => 'মুক্ত, বিশ্বাসী, বৃহত্তর প্রেক্ষাপট';

  @override
  String get kSignCapricorn =>
      'শৃঙ্খলাপরায়ণ, উচ্চাকাঙ্ক্ষী, দীর্ঘমেয়াদী পরিকল্পনা করে';

  @override
  String get kSignAquarius => 'স্বাধীন, ব্যবস্থা-মনস্ক, অপ্রচলিত';

  @override
  String get kSignPisces => 'কল্পনাপ্রবণ, সহানুভূতিশীল, সীমাহীন';

  @override
  String get kPlanetNameSun => 'সূর্য';

  @override
  String get kPlanetNameMoon => 'চাঁদ';

  @override
  String get kPlanetNameMars => 'মঙ্গল';

  @override
  String get kPlanetNameMercury => 'বুধ';

  @override
  String get kPlanetNameJupiter => 'বৃহস্পতি';

  @override
  String get kPlanetNameVenus => 'শুক্র';

  @override
  String get kPlanetNameSaturn => 'শনি';

  @override
  String get kPlanetNameRahu => 'রাহু';

  @override
  String get kPlanetNameKetu => 'কেতু';

  @override
  String get kPlanetSun => 'আত্মা, আত্মবিশ্বাস, পিতা, কর্তৃত্ব';

  @override
  String get kPlanetMoon => 'মন, আবেগ, মা, আরাম';

  @override
  String get kPlanetMars => 'চালিকাশক্তি, সাহস, রাগ, ভাইবোন';

  @override
  String get kPlanetMercury => 'বুদ্ধি, বক্তৃতা, বাণিজ্য, দক্ষতা';

  @override
  String get kPlanetJupiter => 'জ্ঞান, বৃদ্ধি, ভাগ্য, শিক্ষক, শিশু';

  @override
  String get kPlanetVenus => 'ভালোবাসা, সৌন্দর্য, আরাম, অংশীদারিত্ব, শিল্প';

  @override
  String get kPlanetSaturn => 'শৃঙ্খলা, সময়, সীমা, কষ্টার্জিত পুরস্কার';

  @override
  String get kPlanetRahu => 'উচ্চাকাঙ্ক্ষা, মোহ, বিদেশী এবং নতুন';

  @override
  String get kPlanetKetu => 'অনাসক্তি, আয়ত্ত, মুক্তি, আধ্যাত্মিকতা';

  @override
  String get kHouse1 => 'আত্মা, শরীর, জীবনীশক্তি';

  @override
  String get kHouse2 => 'সম্পদ, পরিবার, কথা, খাবার';

  @override
  String get kHouse3 => 'সাহস, ভাইবোন, প্রচেষ্টা, স্বল্প ভ্রমণ';

  @override
  String get kHouse4 => 'ঘর, মা, ভূমি, অন্তরের শান্তি';

  @override
  String get kHouse5 => 'শিশু, শিক্ষা, সৃজনশীলতা, প্রেম';

  @override
  String get kHouse6 => 'স্বাস্থ্য, ঋণ, শত্রু, দৈনন্দিন কাজ';

  @override
  String get kHouse7 => 'বিবাহ, অংশীদারিত্ব, ব্যবসা';

  @override
  String get kHouse8 => 'দীর্ঘায়ু, আকস্মিক পরিবর্তন, গোপন, উত্তরাধিকার';

  @override
  String get kHouse9 => 'ভাগ্য, ধর্ম, পিতা, উচ্চশিক্ষা, দীর্ঘ ভ্রমণ';

  @override
  String get kHouse10 => 'পেশা, মর্যাদা, জনজীবন';

  @override
  String get kHouse11 => 'আয়, লাভ, নেটওয়ার্ক, বড় ভাইবোন';

  @override
  String get kHouse12 => 'ক্ষতি, ব্যয়, বিদেশ, ঘুম, মুক্তি';

  @override
  String get kDignityExalted => 'মহিমান্বিত — খুব শক্তিশালী';

  @override
  String get kDignityDebilitated => 'দুর্বল — এখানে চাপের মধ্যে';

  @override
  String get kDignityMoolatrikona => 'মূলাত্রিকোণ — আরামদায়ক এবং শক্তিশালী';

  @override
  String get kDignityOwn => 'নিজস্ব চিহ্ন — স্থিতিশীল এবং কার্যকর';

  @override
  String get kDignityGreatFriend => 'এক মহান বন্ধুর চিহ্নে — সমর্থিত';

  @override
  String get kDignityFriend => 'বন্ধুর ইশারায় — সমর্থিত';

  @override
  String get kDignityNeutral => 'নিরপেক্ষ চিহ্ন';

  @override
  String get kDignityEnemy => 'শত্রুর রাশিতে — আরও কঠোর পরিশ্রম করে';

  @override
  String get kDignityGreatEnemy => 'এক বড় শত্রুর ইঙ্গিতে — চাপের মধ্যে';

  @override
  String get kDashaSun =>
      'পরিচয়, কর্তৃত্ব ও স্বীকৃতির একটি সময়। অহং এবং চোখ ও হৃদয়ের স্বাস্থ্য স্পষ্ট হয়ে ওঠে।';

  @override
  String get kDashaMoon =>
      'একটি কোমল ও আবেগঘন অধ্যায় — ঘর, মা, মেজাজ ও জনজীবন।';

  @override
  String get kDashaMars =>
      'শক্তি, প্রতিযোগিতা ও উদ্যোগ বৃদ্ধি পায়। মেজাজ, দুর্ঘটনা ও সম্পত্তি সংক্রান্ত বিষয়ে সতর্ক থাকুন।';

  @override
  String get kDashaMercury =>
      'শেখা, ব্যবসা, লেখা ও যোগাযোগ। পড়াশোনা ও ব্যবসার জন্য ভালো, স্থিরতার জন্য অস্থির।';

  @override
  String get kDashaJupiter =>
      'বেড়ে ওঠা, শিক্ষক, পরিবার, জীবনের অর্থ। প্রায়শই এক সৌভাগ্যপূর্ণ ও প্রসারময় পর্যায়।';

  @override
  String get kDashaVenus =>
      'সম্পর্ক, স্বাচ্ছন্দ্য, শিল্প, অর্থ এবং আনন্দ। সাধারণত সময়গুলোর মধ্যে এটিই সবচেয়ে সহজ।';

  @override
  String get kDashaSaturn =>
      'কঠোর পরিশ্রম, দায়িত্ববোধ এবং ধীর ও দীর্ঘস্থায়ী ফলাফল। ধৈর্যের পুরস্কার মেলে; সহজ পথের শাস্তি হয়।';

  @override
  String get kDashaRahu =>
      'সীমাহীন উচ্চাকাঙ্ক্ষা — বিদেশ, প্রযুক্তি, আকস্মিক উত্থান আর বিভ্রান্তি।';

  @override
  String get kDashaKetu =>
      'অনাসক্তি, সমাপ্তি এবং আধ্যাত্মিক অন্তর্মুখীতা। জাগতিক জিনিসপত্র অন্তঃসারশূন্য মনে হয়; দক্ষতা গভীর হয়।';

  @override
  String get kNakAshwini => 'দ্রুত, অগ্রণী, নিরাময়';

  @override
  String get kNakBharani => 'উদ্যমী, পরিবর্তনের সুযোগ রাখেন, শৃঙ্খলাপরায়ণ';

  @override
  String get kNakKrittika => 'ধারালো, ভেদকারী, প্রতিরক্ষামূলক';

  @override
  String get kNakRohini => 'সৃজনশীল, সংবেদনশীল, যত্নশীল, চৌম্বকীয়';

  @override
  String get kNakMrigashira => 'অনুসন্ধিৎসু, কৌতূহলী, কোমল';

  @override
  String get kNakArdra => 'ঝঞ্ঝাময়, রূপান্তরকারী, চাপের মুখেও অসাধারণ';

  @override
  String get kNakPunarvasu => 'নবায়নযোগ্য, উদার, সুরক্ষায় প্রত্যাবর্তন';

  @override
  String get kNakPushya => 'পুষ্টিকর, কর্তব্যপরায়ণ, গভীরভাবে সহায়ক';

  @override
  String get kNakAshlesha => 'অন্তর্দৃষ্টিসম্পন্ন, কৌশলগত, সম্মোহক';

  @override
  String get kNakMagha => 'রাজকীয়, ঐতিহ্য-আবদ্ধ, পৈতৃক';

  @override
  String get kNakPurvaPhalguni => 'কৌতুকপ্রিয়, রোমান্টিক, অবসরকে মূল্য দেয়';

  @override
  String get kNakUttaraPhalguni => 'নির্ভরযোগ্য, চুক্তিভিত্তিক, সহায়ক';

  @override
  String get kNakHasta => 'হাতে দক্ষ, চতুর, নিরাময়কারী';

  @override
  String get kNakChitra => 'শৈল্পিক, আকর্ষণীয়, সুন্দর জিনিস তৈরি করে';

  @override
  String get kNakSwati => 'স্বাধীন, অভিযোজনযোগ্য, মুক্তিপ্রিয়';

  @override
  String get kNakVishakha => 'লক্ষ্য-চালিত, দৃঢ়প্রতিজ্ঞ, দ্বৈত স্বভাবের';

  @override
  String get kNakAnuradha => 'একনিষ্ঠ, বন্ধুত্বপূর্ণ, বিদেশে উন্নতি করে';

  @override
  String get kNakJyeshtha => 'জ্যেষ্ঠ, দায়িত্বশীল, বোঝা বহন করে';

  @override
  String get kNakMula => 'মূল অনুসন্ধানী, আমূল পরিবর্তনকারী, মর্মস্থলে পৌঁছায়';

  @override
  String get kNakPurvaAshadha => 'অদম্য মনোবল, প্ররোচনামূলক';

  @override
  String get kNakUttaraAshadha => 'নীতিগত, স্থায়ী, পরবর্তী সাফল্য';

  @override
  String get kNakShravana => 'শোনা, শেখা, মানুষের সাথে সংযোগ স্থাপন করা';

  @override
  String get kNakDhanishta => 'ছন্দময়, সমৃদ্ধ, সঙ্গীতময়, অভিযোজনযোগ্য';

  @override
  String get kNakShatabhisha => 'ব্যক্তিগত, নিরাময়মূলক, ব্যবস্থা-ভিত্তিক';

  @override
  String get kNakPurvaBhadrapada => 'আদর্শবাদী, তীব্র, রূপান্তরমূলক';

  @override
  String get kNakUttaraBhadrapada => 'গভীর, শান্ত, প্রজ্ঞাপূর্ণ পরামর্শ';

  @override
  String get kNakRevati => 'দয়ালু, ভ্রমণকারীদের প্রতি যত্নশীল, কল্পনাপ্রবণ';

  @override
  String get kSadeSatiRising =>
      'উদীয়মান পর্যায় — শনি আপনার চন্দ্র থেকে দ্বাদশ রাশিতে অবস্থান করছে। সমাপ্তি, ক্লান্তি এবং সবকিছু গুটিয়ে আসার অনুভূতি। যা আর কার্যকর নয়, তা পরিষ্কার করা শুরু করুন।';

  @override
  String get kSadeSatiPeak =>
      'চূড়ান্ত পর্যায় — শনি আপনার চন্দ্র রাশির উপরে অবস্থান করছে। সবচেয়ে কঠিন সময়: দায়িত্ব, চাপ এবং ধীর অগ্রগতি। দৈনন্দিন রুটিন বজায় রাখুন, স্বাস্থ্যের যত্ন নিন।';

  @override
  String get kSadeSatiSetting =>
      'সূচনা পর্ব — শনি আপনার চন্দ্র থেকে দ্বিতীয় রাশিতে অবস্থান করছে। মনের ভার কমে যায়। অর্থ ও পরিবার স্থিতিশীল হয়; বিগত বছরগুলোর শিক্ষা ফল দিতে শুরু করে।';

  @override
  String get kSadeSatiGeneric =>
      'শনি আপনার চন্দ্রের চারপাশের রাশিগুলোতে পরিভ্রমণ করছে।';

  @override
  String kPlanetInSignHouse(
    Object planet,
    Object sign,
    Object signTrait,
    Object house,
    Object houseTheme,
  ) {
    return 'আপনার $sign থাকা $planet আপনাকে $signTrait প্রদান করে। $house -এ এটি $houseTheme -কে স্পর্শ করে।';
  }

  @override
  String kPlanetInSign(Object planet, Object sign, Object signTrait) {
    return 'Your $planet in $sign makes you $signTrait.';
  }

  @override
  String get kHouseSans1 => 'তনু ভাব';

  @override
  String get kHouseSans2 => 'ধন ভাব';

  @override
  String get kHouseSans3 => 'সহজ ভাব';

  @override
  String get kHouseSans4 => 'সুখ ভাব';

  @override
  String get kHouseSans5 => 'পুত্র ভাব';

  @override
  String get kHouseSans6 => 'রিপু ভাবা';

  @override
  String get kHouseSans7 => 'যুবতী ভাব';

  @override
  String get kHouseSans8 => 'আয়ু / রন্ধ্র ভাব';

  @override
  String get kHouseSans9 => 'ধর্ম ভাব';

  @override
  String get kHouseSans10 => 'কর্ম ভাব';

  @override
  String get kHouseSans11 => 'লাভ ভাব';

  @override
  String get kHouseSans12 => 'ব্যবহার ভাব';

  @override
  String kHouseTitleWithSign(Object sign, Object theme) {
    return '$sign · $theme';
  }

  @override
  String kHouseSheetTitle(Object ordinal, Object sign) {
    return '$ordinal ঘর · $sign';
  }

  @override
  String kHouseSheetSubtitle(Object sanskrit, Object theme) {
    return '$sanskrit — $theme';
  }

  @override
  String kHouseChipLord(Object lord) {
    return 'গৃহকর্তা · $lord';
  }

  @override
  String kHouseChipLordIn(Object nthHouse) {
    return '$nthHouse গৃহে প্রভু';
  }

  @override
  String kHouseNoPlanets(Object lord, Object lordWhere) {
    return 'এই ঘরে কোনো গ্রহ অবস্থান করে না। এর কাহিনী প্রধানত এর অধিপতি দ্বারা বর্ণিত হয়, $lord $lordWhere ।';
  }

  @override
  String kHouseLordWhere(Object nthHouse) {
    return 'এখন $nthHouse এ';
  }

  @override
  String get kHousePlanetsHeader => 'এই ঘরে গ্রহগুলি';

  @override
  String kHouseAskCta(Object ordinal) {
    return 'আপনার $ordinal ভাব সম্পর্কে একজন জ্যোতিষীকে জিজ্ঞাসা করুন।';
  }

  @override
  String kHouseReadingLord(
    Object ordinal,
    Object lord,
    Object nthHouse,
    Object theme,
    Object lordTheme,
  ) {
    return 'আপনার $ordinal ঘরের অধিপতি $lord $nthHouse এ বসে আছেন, তাই $theme $lordTheme এর সাথে সংযুক্ত।';
  }

  @override
  String kHouseReadingOccupant(
    Object planet,
    Object planetTheme,
    Object theme,
  ) {
    return 'এখানে $planet তার থিমগুলো — $planetTheme — $theme এর মধ্যে নিয়ে আসে।';
  }

  @override
  String get kHouseReadingEmpty =>
      'এই ভাবটি এর অধিপতি এবং যে গ্রহগুলি একে দৃষ্টি দেয়, তাদের মাধ্যমে পড়া হয়। একজন জ্যোতিষী আপনাকে এটি বুঝিয়ে দিতে পারেন।';

  @override
  String kBhavaSubheadKaraka(Object karaka) {
    return 'কারাকা $karaka';
  }

  @override
  String kBhavaSubheadLord(Object lord, Object nthHouse) {
    return 'প্রভু $lord , $nthHouse';
  }

  @override
  String kBhavaSubheadLordOnly(Object lord) {
    return 'প্রভু $lord';
  }

  @override
  String kBhavaReadingGoverns(Object theme) {
    return 'এই ভবনটি $theme পরিচালনা করে।';
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
    return 'এর অধিপতি $lord $nthHouse এ আছেন, তাই $theme $lordTheme এর সাথে সংযুক্ত। $dignity $occupants';
  }

  @override
  String kBhavaReadingDignity(Object dignity) {
    return ' প্রভু হলেন $dignity ।';
  }

  @override
  String kBhavaReadingOccupants(Object planets, Object themes) {
    return ' $planets এখানে বসে $themes যোগ করছে।';
  }

  @override
  String kTransitHouseLine(Object nthHouse, Object theme) {
    return 'আপনার $nthHouse · $theme';
  }

  @override
  String kPlanetRowMeta(Object sign, Object nthHouse, Object degree) {
    return '$sign · $nthHouse · $degree °';
  }

  @override
  String kLagnaLordIn(Object nthHouse) {
    return '$nthHouse -এ';
  }

  @override
  String get kDignityShortExalted => 'মহিমান্বিত';

  @override
  String get kDignityShortMoolatrikona => 'মূলাত্রিকোণ';

  @override
  String get kDignityShortOwn => 'নিজের';

  @override
  String get kDignityShortDebilitated => 'দুর্বল';

  @override
  String get kDignityShortEnemy => 'শত্রু চিহ্ন';

  @override
  String get kDignityShortGreatEnemy => 'বড় শত্রু';

  @override
  String get kCombustNote =>
      'দহন — সূর্যের খুব কাছে, তাই এর স্বতন্ত্র কণ্ঠস্বর ম্লান হয়ে যায়।';

  @override
  String get kWhatThisMeans => 'এর মানে আপনার জন্য কী';

  @override
  String get ovStrengthStrong => 'শক্তিশালী';

  @override
  String get ovStrengthSteady => 'স্থির';

  @override
  String get ovStrengthStrain => 'চাপের মধ্যে';

  @override
  String get ovStrengthWeak => 'দুর্বল';

  @override
  String get ovRoleSpouse => 'স্বামী/স্ত্রী নির্দেশক';

  @override
  String get ovRoleDarakaraka => 'দারকারক (জৈমিনি)';

  @override
  String get ovRoleWealth => 'সম্পদ নির্দেশক';

  @override
  String get ovRoleIntellect => 'বুদ্ধি নির্দেশক';

  @override
  String get ovRoleWisdom => 'প্রজ্ঞা নির্দেশক';

  @override
  String get ovRoleFortune => 'ভাগ্য নির্দেশক';

  @override
  String get ovRoleFather => 'পিতা নির্দেশক';

  @override
  String get ovRoleMother => 'মাদার সিগনিফিকেটর';

  @override
  String get ovRoleGeneric => 'সংকেতকারী';

  @override
  String ovfPada(int pada) {
    return 'পদ $pada';
  }

  @override
  String ovfLagnaSign(Object sign) {
    return 'উদীয়মান রাশি $sign';
  }

  @override
  String ovfLagnaLord(Object planet, Object nthHouse, Object dignity) {
    return 'লগ্নপতি $planet $nthHouse $dignity';
  }

  @override
  String ovfHouseLord(Object ordinal, Object planet, Object nthHouse) {
    return '$ordinal -ভাব অধিপতি $planet $nthHouse';
  }

  @override
  String ovfHouseStrength(Object ordinal, Object strength) {
    return '$ordinal ঘর — $strength';
  }

  @override
  String ovfMoonSign(Object sign) {
    return '$sign তে চাঁদ';
  }

  @override
  String ovfMoonHouse(Object nthHouse) {
    return '$nthHouse চাঁদ';
  }

  @override
  String ovfMoonNakshatra(Object nakshatra) {
    return 'চন্দ্র নক্ষত্র $nakshatra';
  }

  @override
  String ovfMoonDignity(Object dignity) {
    return 'চাঁদ $dignity';
  }

  @override
  String ovfSunSign(Object sign) {
    return '$sign রাশিতে সূর্য';
  }

  @override
  String ovfSeventhSign(Object sign) {
    return '$sign তে ৭ম ভাব';
  }

  @override
  String ovfPlanetInHouse(Object planet, Object nthHouse) {
    return '$planet in the $nthHouse';
  }

  @override
  String ovfPlanetWithMoon(Object planet) {
    return 'চাঁদের সাথে $planet';
  }

  @override
  String ovfAppearanceIn(Object planet) {
    return 'প্রথম ঘরে $planet';
  }

  @override
  String ovfAppearanceAspect(Object planet) {
    return 'প্রথম ভাবের উপর $planet র দৃষ্টি';
  }

  @override
  String ovfMaleficOnLagna(Object planet) {
    return 'লগ্নের উপর $planet চাপ দিচ্ছে';
  }

  @override
  String ovfKaraka(Object role, Object planet) {
    return '$role : $planet';
  }

  @override
  String ovfYoga(Object name) {
    return 'যোগ — $name';
  }

  @override
  String ovfDosha(Object name) {
    return 'দোষ — $name';
  }

  @override
  String get doshaMangalName => 'মঙ্গল দোষ';

  @override
  String get doshaMangalMeaning =>
      'সংবেদনশীল ঘরে মঙ্গল — ঐতিহ্যগতভাবে বিবাহের আগে এর গুরুত্ব বিচার করা হয়। প্রায়শই ভারসাম্যপূর্ণ হয় যখন উভয় সঙ্গী মাঙ্গলিক হন অথবা বৃহস্পতি মঙ্গলকে প্রভাবিত করে।';

  @override
  String get doshaKaalSarpaName => 'কাল সর্প দোষ';

  @override
  String get doshaKaalSarpaMeaning =>
      'পুরো জন্মছকটি রাহু ও কেতুর মধ্যে সীমাবদ্ধ থাকলে—একটি স্পষ্ট দিকনির্দেশনা না পাওয়া পর্যন্ত জীবন আবদ্ধ মনে হতে পারে, এরপর মনোযোগ তীব্র হয়ে ওঠে।';

  @override
  String get doshaPitraName => 'পিতৃ দোষ';

  @override
  String get doshaPitraMeaning =>
      'সূর্য এবং নবম ভাব পৈতৃক কর্মফলের ছায়া বহন করে — যা প্রায়শই পিতার নামে শ্রদ্ধা ও দানের মাধ্যমে উদ্বুদ্ধ করা হয়।';

  @override
  String get doshaGandmoolName => 'গণ্ডমূল দোষ';

  @override
  String get doshaGandmoolMeaning =>
      'চন্দ্র একটি সংযোগ নক্ষত্রে অবস্থান করছে। এর ঐতিহ্যগত প্রতিষেধক হলো ২৭তম দিনে শান্তি পূজা করা।';

  @override
  String get doshaGrahanName => 'গ্রহণ দোষ';

  @override
  String get doshaGrahanMeaning =>
      'একটি জ্যোতিষ্ক (সূর্য বা চন্দ্র) কোনো নোডের সাথে অবস্থান করলে, সেই গ্রহের তাৎপর্য ম্লান হয়ে যায়, যতক্ষণ না সেটির উপর কাজ করা হয়।';

  @override
  String get doshaShrapitName => 'শ্রাপিত দোষ';

  @override
  String get doshaShrapitMeaning =>
      'রাহুর সাথে শনির সংযোগ — শুরুতে বিলম্ব এবং বিভ্রান্তি; অবিচল ও ধৈর্যশীল প্রচেষ্টাই এই পরিস্থিতি থেকে উত্তরণের পথ।';

  @override
  String get doshaGuruChandalName => 'গুরু চণ্ডাল দোষ';

  @override
  String get doshaGuruChandalMeaning =>
      'নোডের সাথে বৃহস্পতি — প্রজ্ঞার সাথে অপ্রচলিত ধারণার মিশ্রণ; আপনার শিক্ষক ও বিশ্বাস সাবধানে বেছে নিন।';

  @override
  String get doshaAngarakName => 'অঙ্গারক দোষ';

  @override
  String get doshaAngarakMeaning =>
      'নোডের সাথে মঙ্গল — আবেগপ্রবণতা; রাগ, দুর্ঘটনা এবং সম্পত্তি সংক্রান্ত বিবাদের ক্ষেত্রে সতর্কতা প্রয়োজন।';

  @override
  String get doshaKemadrumaName => 'কেমদ্রুম দোষ';

  @override
  String get doshaKemadrumaMeaning =>
      'চন্দ্র একা, চারপাশে কোনো অবলম্বন ছাড়াই দাঁড়িয়ে থাকে — কোনো কেন্দ্র অধিষ্ঠিত থাকলে বা চন্দ্র শক্তিশালী হলে এই অবস্থা সহজ হয়।';

  @override
  String get doshaDaridraName => 'দামিদ্রা দোষ';

  @override
  String get doshaDaridraMeaning =>
      'অর্থের ঘরগুলো চাপের মধ্যে থাকে — নিয়মতান্ত্রিক সঞ্চয় এবং একটি শক্তিশালী দশা পরিস্থিতিকে পাল্টে দেয়।';

  @override
  String get birthDetailsCta => 'জন্মের সম্পূর্ণ বিবরণ';

  @override
  String get birthDetailsTitle => 'জন্মের বিবরণ';

  @override
  String get birthDetailsAyanamsa => 'আয়ানামশা';

  @override
  String get birthDetailsPanchangTitle => 'জন্মের সময় পঞ্চাঙ্গ';

  @override
  String get birthDetailsChakraTitle => 'অবকাহাদা চক্র';

  @override
  String get birthDetailsWeekday => 'সপ্তাহের দিন';

  @override
  String get birthDetailsTithi => 'তিথি';

  @override
  String get birthDetailsNakshatra => 'নক্ষত্র';

  @override
  String get birthDetailsYoga => 'যোগ';

  @override
  String get birthDetailsKarana => 'করানা';

  @override
  String get birthDetailsMoonSign => 'চন্দ্র রাশি';

  @override
  String get birthDetailsSunSign => 'সূর্য রাশি';

  @override
  String get birthDetailsSuryaNakshatra => 'সূর্যের নক্ষত্র';

  @override
  String get birthDetailsSunrise => 'সূর্যোদয়';

  @override
  String get birthDetailsSunset => 'সূর্যাস্ত';

  @override
  String get birthDetailsIshtaKala => 'ইষ্টা কলা';

  @override
  String birthDetailsPada(int count) {
    return 'পাদা $count';
  }

  @override
  String birthDetailsGhatiPala(int ghati, int pala, int vipala) {
    return '$ghati ঘাটি $pala পাল $vipala বিপলা';
  }

  @override
  String get birthDetailsNakshatraLord => 'নক্ষত্রের অধিপতি';

  @override
  String get birthDetailsRashiLord => 'রাশি প্রভু';

  @override
  String get birthDetailsVarna => 'বর্ণ';

  @override
  String get birthDetailsVashya => 'বশ্য';

  @override
  String get birthDetailsYoni => 'ইয়োনি';

  @override
  String get birthDetailsGana => 'গানা';

  @override
  String get birthDetailsNadi => 'নদী';

  @override
  String get birthDetailsTara => 'তারা';

  @override
  String get birthDetailsTattva => 'তত্ত্ব';

  @override
  String get birthDetailsYunja => 'ইউনজা';

  @override
  String get birthDetailsRashiPaya => 'রাশি পায়া';

  @override
  String get birthDetailsNakshatraPaya => 'নক্ষত্র পায়া';

  @override
  String get birthDetailsDisclaimer =>
      'চিরায়ত শ্রেণিবিন্যাসগত বৈশিষ্ট্য — যা প্রধানত মুহূর্ত ও ঘটকালি করতে ব্যবহৃত হয়, ভবিষ্যদ্বাণী করতে নয়।';

  @override
  String get vaaraMonday => 'সোমবার';

  @override
  String get vaaraTuesday => 'মঙ্গলবরা (মঙ্গলবার)';

  @override
  String get vaaraWednesday => 'বুধবার (বুধবার)';

  @override
  String get vaaraThursday => 'গুরুবার (বৃহস্পতিবার)';

  @override
  String get vaaraFriday => 'শুক্রবার';

  @override
  String get vaaraSaturday => 'শনিভারা (শনিবার)';

  @override
  String get vaaraSunday => 'রবিভারা (রবিবার)';

  @override
  String get tattvaFire => 'অগ্নি (আগুন)';

  @override
  String get tattvaEarth => 'পৃথিবী (ভূমি)';

  @override
  String get tattvaAir => 'বায়ু (বাতাস)';

  @override
  String get tattvaWater => 'জল (পানি)';

  @override
  String get payaGold => 'সোনা';

  @override
  String get payaSilver => 'রূপা';

  @override
  String get payaCopper => 'তামা';

  @override
  String get payaIron => 'লোহা';

  @override
  String get roomAppBarTitle => 'পরামর্শ';

  @override
  String get roomOpenError => 'আমরা এই পরামর্শটি খুলতে পারিনি।';

  @override
  String roomWaitingTitle(String name) {
    return '$name এর গ্রহণের জন্য অপেক্ষা করা হচ্ছে।';
  }

  @override
  String get roomWaitingBody =>
      'সাধারণত এক মিনিটেরও কম সময় লাগে। তারা যোগ দেওয়ার সাথে সাথেই আমরা চ্যাটটি খুলে দেব।';

  @override
  String get roomCancelRequest => 'অনুরোধ বাতিল করুন';

  @override
  String get roomEndConfirmTitle => 'এই পরামর্শ শেষ করবেন?';

  @override
  String get roomEndConfirmBody => 'সেশন শেষ হলে বিলিং বন্ধ হয়ে যায়।';

  @override
  String get roomKeepTalking => 'কথা বলতে থাকুন';

  @override
  String get roomEnd => 'শেষ';

  @override
  String get roomAutoTranslateOn => 'স্বয়ংক্রিয় অনুবাদ চালু';

  @override
  String get roomAutoTranslateOff => 'স্বয়ংক্রিয় অনুবাদ বন্ধ';

  @override
  String get roomEndedTitle => 'পরামর্শ শেষ হয়েছে';

  @override
  String get roomBalanceOutTitle => 'আপনার ব্যালেন্স শেষ হয়ে গেছে';

  @override
  String roomBalanceOutBody(String name) {
    return 'আপনার ওয়ালেট ব্যালেন্স শেষ হয়ে যাওয়ায় চ্যাটটি শেষ হয়ে গেছে। $name এর সাথে চালিয়ে যেতে রিচার্জ করুন এবং আবার শুরু করুন।';
  }

  @override
  String get roomRechargeWallet => 'রিচার্জ ওয়ালেট';

  @override
  String roomStartAgain(String name) {
    return '$name দিয়ে আবার শুরু করুন।';
  }

  @override
  String get roomRowAstrologer => 'জ্যোতিষী';

  @override
  String get roomRowDuration => 'সময়কাল';

  @override
  String get roomRowAmount => 'পরিমাণ';

  @override
  String get roomRowRate => 'রেট';

  @override
  String roomMinutes(int minutes) {
    return '$minutes মিনিট';
  }

  @override
  String roomRatePerMinute(String currency, String amount) {
    return '$currency $amount /মিনিট';
  }

  @override
  String get roomRateQuestion => 'আপনার পরামর্শ কেমন ছিল?';

  @override
  String get roomSubmitRating => 'রেটিং জমা দিন';

  @override
  String get roomRatingThanks => 'মতামতের জন্য ধন্যবাদ!';

  @override
  String get roomBackHome => 'হোমপেজে ফিরে যান';

  @override
  String get roomStatusRejected => 'জ্যোতিষী এই অনুরোধটি গ্রহণ করতে পারেননি।';

  @override
  String get roomStatusCancelled => 'অনুরোধ বাতিল করা হয়েছে';

  @override
  String get roomStatusExpired =>
      'অনুরোধের মেয়াদ শেষ হয়ে গেছে — সময়মতো কোনো উত্তর পাওয়া যায়নি';

  @override
  String get roomStatusNoShow => 'কলটি সংযুক্ত হয়নি।';

  @override
  String get roomStatusClosed => 'পরামর্শ বন্ধ।';

  @override
  String get roomBalanceRunningOut => 'ব্যালেন্স ফুরিয়ে আসছে';

  @override
  String roomMinLeftRecharge(int minutes) {
    return '~ $minutes মিনিট বাকি · কথা বলতে থাকলে রিচার্জ করুন';
  }

  @override
  String roomSpentMinLeft(String currency, String amount, int minutes) {
    return '$currency $amount ব্যয়িত · ~ $minutes মিনিট বাকি';
  }

  @override
  String get roomAddMoney => 'টাকা যোগ করুন';

  @override
  String get roomClientBalanceLow =>
      'ক্লায়েন্টের ব্যালেন্স কম — শীঘ্রই শেষ করুন।';

  @override
  String get navChats => 'চ্যাট';

  @override
  String get chatsTitle => 'চ্যাট';

  @override
  String get chatsLoadError => 'আমরা আপনার চ্যাটগুলো লোড করতে পারিনি।';

  @override
  String get chatsEmptyTitle => 'এখনো কোনো চ্যাট হয়নি';

  @override
  String get chatsEmptyBody =>
      'একজন জ্যোতিষীর সাথে পরামর্শ শুরু করুন এবং তা এখানে দেখা যাবে।';

  @override
  String get chatsSectionActive => 'সক্রিয়';

  @override
  String get chatsSectionRecent => 'সাম্প্রতিক';

  @override
  String get chatsAstrologerFallback => 'জ্যোতিষী';

  @override
  String get chatsStatusWaiting => 'জ্যোতিষীর অনুমোদনের অপেক্ষায়।';

  @override
  String get chatsStatusLive => 'এখন লাইভ · খুলতে ট্যাপ করুন';

  @override
  String chatsStatusEnded(int minutes) {
    return '$minutes মিনিটের পরামর্শ';
  }

  @override
  String get chatsStatusCancelled => 'বাতিল করা হয়েছে';

  @override
  String get chatsStatusRejected => 'গ্রহণযোগ্য নয়';

  @override
  String get chatsStatusExpired => 'অনুরোধের মেয়াদ শেষ হয়ে গেছে';

  @override
  String get chatsStatusGeneric => 'পরামর্শ';

  @override
  String get numerologyTitle => 'সংখ্যাতত্ত্ব ও লো শু গ্রিড';

  @override
  String get numerologyIntro =>
      'আপনার জন্মতারিখ (এবং নাম) থেকে প্রাপ্ত একটি ঐতিহ্যবাহী সংখ্যা গণনা — প্রতিটি সংখ্যার প্রবণতা, শুভ দিন ও রং এবং আপনার লো শু জন্ম ছক। এটি মননের জন্য, কোনো নির্দিষ্ট তারিখের ভবিষ্যদ্বাণী নয়।';

  @override
  String get numMoolank => 'মুল্যাঙ্ক · মানসিক সংখ্যা';

  @override
  String get numBhagyank => 'ভাগ্যঙ্ক · নিয়তি সংখ্যা';

  @override
  String get numNaamank => 'নামাঙ্ক · নাম নম্বর';

  @override
  String numRuledBy(String planet) {
    return '$planet দ্বারা শাসিত';
  }

  @override
  String get numFriendly => 'বন্ধুত্বপূর্ণ';

  @override
  String get numNeutral => 'নিরপেক্ষ';

  @override
  String get numUnfriendly => 'সংঘর্ষ';

  @override
  String get numFavDays => 'অনুকূল দিনগুলি';

  @override
  String get numFavColours => 'অনুকূল রং';

  @override
  String get numDirection => 'দিকনির্দেশনা';

  @override
  String get numDeity => 'দেবতা';

  @override
  String get numGemstone => 'ঐতিহ্যবাহী রত্নপাথর';

  @override
  String get numLoShuTitle => 'লো শু জন্ম গ্রিড';

  @override
  String numLoShuMissing(String nums) {
    return 'আপনার গ্রিডে নেই: $nums';
  }

  @override
  String numLoShuRepeated(String nums) {
    return 'জোর দেওয়া হয়েছে: $nums';
  }

  @override
  String get numArrowStrength => 'সম্পূর্ণ লাইন';

  @override
  String get numArrowAbsence => 'অনুপস্থিত লাইন';

  @override
  String get numAskCta => 'এই বিষয়ে একজন জ্যোতিষীর সাথে কথা বলুন।';

  @override
  String get sadeSatiTitle => 'সাদে সাতি ও ধাইয়া ক্যালেন্ডার';

  @override
  String sadeSatiIntro(String sign) {
    return 'আপনার চন্দ্র রাশি থেকে গণনা করা, আপনার জীবনের উপর শনির কালানুক্রমিক প্রভাব $sign সাড়ে সাতি হলো চন্দ্র থেকে দ্বাদশ, প্রথম ও দ্বিতীয় ঘরে শনির অবস্থান (প্রায় সাড়ে ৭ বছর); ধাইয়া হলো চতুর্থ বা অষ্টম ঘরে অবস্থান (প্রায় আড়াই বছর)।';
  }

  @override
  String get sadeSatiRunningNow => 'এখন চলছে';

  @override
  String get sadeSatiPast => 'অতীত';

  @override
  String get sadeSatiUpcoming => 'আসন্ন';

  @override
  String get sadeSatiPhaseRising => 'উদীয়মান · দ্বাদশ ঘরে শনি';

  @override
  String get sadeSatiPhasePeak => 'চূড়া · চাঁদের উপর শনি';

  @override
  String get sadeSatiPhaseSetting => 'অস্তগামী · দ্বিতীয় ঘরে শনি';

  @override
  String get sadeSatiPhaseKantaka => 'কান্তকা · চতুর্থ ঘরে শনি';

  @override
  String get sadeSatiPhaseAshtama => 'অষ্টমা · অষ্টম ঘরে শনি';

  @override
  String get sadeSatiDhaiyaHeading => 'ধাইয়া (ছোট পানোটি) সময়কাল';

  @override
  String sadeSatiRange(String start, String end) {
    return '$start → $end';
  }

  @override
  String get avTransitHeading => 'আজকের গ্রহগুলির অষ্টক বর্গ শক্তি';

  @override
  String get avTransitIntro =>
      'আপনার জন্মবিন্দু স্কোর অনুযায়ী, প্রতিটি গ্রহের গোচর কতটা অবাধে ফল দেয়। ৮-এর মধ্যে ৫ বা তার বেশি হলে সহায়ক, ৪ হলে মিশ্র এবং এর চেয়ে কম হলে দুর্বল।';

  @override
  String avTransitBindus(int bindus) {
    return '$bindus /৮ বিন্দু';
  }

  @override
  String get avTransitUpcoming => 'আসছে';

  @override
  String avTransitInHouse(String planet, String house) {
    return '$planet in your $house house';
  }

  @override
  String get muhurtaTitle => 'আজকের টাইমিং';

  @override
  String get muhurtaIntro =>
      'আজকের জন্য চোঘদিয়া এবং হোরা, আপনার জন্ম শহরের জন্য কাজ করেছেন এবং আপনার চার্টের সহায়ক গ্রহগুলিতে ব্যক্তিগতকৃত করেছেন। জিনিসগুলি শুরু করার জন্য আরও ভাল এবং দুর্বল উইন্ডোগুলির জন্য একটি নির্দেশিকা - একটি নিয়ম নয়।';

  @override
  String muhurtaSunTimes(
    String sunrise,
    String sunset,
    String weekday,
    String lord,
  ) {
    return '$sunrise সূর্যোদয় · $sunset সূর্যাস্ত · $weekday ( $lord )';
  }

  @override
  String get muhurtaBestWindows => 'আজ আপনার জন্য সেরা উইন্ডোজ';

  @override
  String get muhurtaNoBest =>
      'আজ কোন স্ট্যান্ড-আউট উইন্ডো নেই — নীচে থেকে একটি ভাল চোঘদিয়া বেছে নিন।';

  @override
  String get muhurtaDayChoghadiya => 'দিন চোৰাদিয়া';

  @override
  String get muhurtaNightChoghadiya => 'রাত চোঘদিয়া';

  @override
  String get muhurtaHora => 'গ্রহের হোরা';

  @override
  String get muhurtaNow => 'এখন';

  @override
  String get muhurtaChoGood => 'ভাল';

  @override
  String get muhurtaChoBad => 'এড়িয়ে চলুন';

  @override
  String get muhurtaChoNeutral => 'নিরপেক্ষ';

  @override
  String get muhurtaHoraFavourable => 'আপনার জন্য ভাল';

  @override
  String get muhurtaHoraCaution => 'হালকা রাখুন';

  @override
  String get upayaTitle => 'রত্নপাথর ও উপয়া';

  @override
  String upayaIntro(String sign) {
    return 'আপনার আরোহণের জন্য শাস্ত্রীয় প্রতিকারের সারণী ( $sign ) — অনুকূল রং, দিন, দেবতা, মন্ত্র এবং দাতব্য আপনি অবাধে গ্রহণ করতে পারেন, এছাড়াও প্রতিটি গ্রহের জন্য ঐতিহ্যবাহী রত্নপাথর এবং রুদ্রাক্ষ।';
  }

  @override
  String get upayaLagnaFavourable => 'আপনার আরোহণের জন্য অনুকূল';

  @override
  String get upayaColours => 'রং';

  @override
  String get upayaDirection => 'দিকনির্দেশনা';

  @override
  String get upayaDay => 'দিন';

  @override
  String get upayaDeity => 'দেবতা';

  @override
  String get upayaStrengthen => 'সমর্থন';

  @override
  String get upayaPacify => 'শান্ত করা';

  @override
  String get upayaMixed => 'মিশ্র';

  @override
  String get upayaNeutral => 'নিরপেক্ষ';

  @override
  String get upayaFreeMeasures => 'বিনামূল্যে ব্যবস্থা';

  @override
  String get upayaMantra => 'মন্ত্র';

  @override
  String get upayaCharity => 'দাতব্য (দান)';

  @override
  String get upayaGemstone => 'রত্নপাথর';

  @override
  String get upayaRudraksha => 'রুদ্রাক্ষ';

  @override
  String get upayaGatedCta => 'আগে একজন জ্যোতিষীর সাথে কনফার্ম করুন';

  @override
  String get upayaPriority => 'অগ্রাধিকার';

  @override
  String get lalKitabTitle => 'লাল কিতাব - ঋণ এবং প্রতিকার';

  @override
  String get lalKitabIntro =>
      'লাল কিতাব আপনার চার্ট থেকে কিছু উত্তরাধিকারসূত্রে প্রাপ্ত ঋণ (রিন) পড়ে এবং প্রতিটি সহজ, বিনামূল্যে পারিবারিক কাজ (টোটকে) দিয়ে পরিষ্কার করে। রত্নপাথর নেই, খরচ নেই।';

  @override
  String get lalKitabActiveDebts => 'সক্রিয় ঋণ';

  @override
  String get lalKitabNoDebts =>
      'কোন দৃঢ়ভাবে সক্রিয় রিন - দৈনন্দিন দায়িত্ব পালন করুন এবং কিছুই তৈরি হয় না।';

  @override
  String get lalKitabWhyFlagged => 'কেন এটা পতাকাঙ্কিত';

  @override
  String get lalKitabRemedy => 'প্রতিকার (টোটকা)';

  @override
  String get lalKitabWeakPlanets => 'দুর্বল গ্রহ বসানো';

  @override
  String get lalKitabAllRemedies => 'আপনার প্রতিকার';

  @override
  String lalKitabPakkaGhar(String planet, String house) {
    return '$planet এর বাড়ির বাড়ি হল $house';
  }

  @override
  String get varshphalTitle => 'বর্ষফল—এই বছরের চার্ট';

  @override
  String varshphalIntro(String age) {
    return 'আপনার $age -বছরের জন্য তাজিকা বার্ষিক চার্ট, সূর্য তার জন্ম অবস্থানে ফিরে আসার মুহুর্তের জন্য কাস্ট। থিমগুলির সাথে কাজ করতে হবে — নির্দিষ্ট ইভেন্ট নয়৷';
  }

  @override
  String varshphalWindow(String start, String end) {
    return '$start → $end';
  }

  @override
  String get varshphalLagna => 'বর্ষা লগ্ন';

  @override
  String get varshphalMuntha => 'মুনথা';

  @override
  String get varshphalYearLord => 'বছরের অধিপতি (বর্ষেশ্বর)';

  @override
  String get varshphalTajika => 'তাজিকা দিক';

  @override
  String varshphalMunthaLine(String house, String theme) {
    return '$house ঘরে মুনথা — $theme';
  }

  @override
  String get varshphalChart => 'বার্ষিক চার্ট গ্রহ';

  @override
  String get prefsTransitAlerts => 'ট্রানজিট সতর্কতা';

  @override
  String get prefsTransitAlertsDesc =>
      'যখন একটি ধীর গ্রহ (বৃহস্পতি, শনি) আপনার চার্টে একটি নতুন বাড়িতে সাইন পরিবর্তন করতে চলেছে তখন একটি সতর্কতা।';

  @override
  String get errNetwork => 'সার্ভারে পৌঁছানো যায়নি। আপনার সংযোগ পরীক্ষা করুন।';

  @override
  String get errTimeout => 'সার্ভার প্রতিক্রিয়া জানাতে অনেক সময় নিচ্ছে।';

  @override
  String get errSession =>
      'আপনার সেশনের মেয়াদ শেষ হয়ে গেছে। অনুগ্রহ করে আবার সাইন ইন করুন।';

  @override
  String get errWalletInsufficient =>
      'এটির জন্য আপনার ওয়ালেট ব্যালেন্স খুব কম।';

  @override
  String get errRateLimited =>
      'অনেকবার চেষ্টা করা হয়েছে। অনুগ্রহ করে কিছুক্ষণ অপেক্ষা করে আবার চেষ্টা করুন।';

  @override
  String get errOtpInvalid => 'কোডটি ভুল বা এর মেয়াদ শেষ হয়ে গেছে।';

  @override
  String get errOtpMaxAttempts =>
      'অনেকবার ভুল চেষ্টা করা হয়েছে। একটি নতুন কোড অনুরোধ করুন।';

  @override
  String get errPromoNotRedeemable => 'এই কুপন কোডটি ব্যবহার করা যাবে না।';

  @override
  String get errRechargeInvalidAmount =>
      'অনুমোদিত সীমার মধ্যে একটি পরিমাণ লিখুন।';

  @override
  String get errAuthWrongApp =>
      'এই নম্বরটি অন্য TalkAcharya অ্যাপের জন্য নিবন্ধিত।';

  @override
  String get errGeneric => 'কিছু ভুল হয়েছে। অনুগ্রহ করে আবার চেষ্টা করুন।';

  @override
  String get homePanchangTitle => 'আজকের পঞ্চাঙ্গ';

  @override
  String get homeLiveNowTitle => 'এখন সরাসরি সম্প্রচারিত হচ্ছে';

  @override
  String get homeFreeToolsTitle => 'বিনামূল্যে সরঞ্জাম';

  @override
  String get homeResumeBtn => 'জীবনবৃত্তান্ত';

  @override
  String get homeAddBtn => 'যোগ করুন';

  @override
  String get homeNotifyMeBtn => 'আমাকে অবহিত করুন';

  @override
  String get homeKundaliAction => 'কুন্ডলী';

  @override
  String get homeMatchingAction => 'মিলানো';

  @override
  String get homeHoroscopeAction => 'রাশিফল';

  @override
  String get homeVastuAction => 'বাস্তু';

  @override
  String get homeRetryBtn => 'পুনরায় চেষ্টা করুন';

  @override
  String get homeChooseSignTitle => 'আপনার রাশি বেছে নিন';

  @override
  String get homeChooseLanguageTitle => 'ভাষা নির্বাচন করুন';

  @override
  String get homeLanguageTooltip => 'ভাষা';

  @override
  String homeLanguageSwitchError(String error) {
    return 'পরিবর্তন করা যায়নি: $error';
  }

  @override
  String get homeComingSoonSnackbar => 'শীঘ্রই আসছে!';

  @override
  String get homeTalkAgainTitle => 'আবার কথা বলুন';

  @override
  String get homeRechargeWalletTitle => 'আপনার ওয়ালেট রিচার্জ করুন';

  @override
  String get homeTalkToAstrologerTitle => 'একজন জ্যোতিষীর সাথে কথা বলুন';

  @override
  String get kSignNameAries => 'মেষ রাশি';

  @override
  String get kSignNameTaurus => 'বৃষ';

  @override
  String get kSignNameGemini => 'মিথুন';

  @override
  String get kSignNameCancer => 'ক্যান্সার';

  @override
  String get kSignNameLeo => 'লিও';

  @override
  String get kSignNameVirgo => 'কুমারী';

  @override
  String get kSignNameLibra => 'তুলা রাশি';

  @override
  String get kSignNameScorpio => 'বৃশ্চিক';

  @override
  String get kSignNameSagittarius => 'ধনু';

  @override
  String get kSignNameCapricorn => 'মকর রাশি';

  @override
  String get kSignNameAquarius => 'কুম্ভ';

  @override
  String get kSignNamePisces => 'মীন';

  @override
  String get kNakNameAshwini => 'অশ্বিনী';

  @override
  String get kNakNameBharani => 'ভরণী';

  @override
  String get kNakNameKrittika => 'কৃত্তিকা';

  @override
  String get kNakNameRohini => 'রোহিণী';

  @override
  String get kNakNameMrigashira => 'মৃগাশিরা';

  @override
  String get kNakNameArdra => 'আরদ্রা';

  @override
  String get kNakNamePunarvasu => 'পুনর্বাসু';

  @override
  String get kNakNamePushya => 'পুষ্যা';

  @override
  String get kNakNameAshlesha => 'আশলেশা';

  @override
  String get kNakNameMagha => 'মাঘা';

  @override
  String get kNakNamePurvaPhalguni => 'পূর্বা ফাল্গুনী';

  @override
  String get kNakNameUttaraPhalguni => 'উত্তরা ফাল্গুনী';

  @override
  String get kNakNameHasta => 'হস্ত';

  @override
  String get kNakNameChitra => 'চিত্রা';

  @override
  String get kNakNameSwati => 'স্বাতী';

  @override
  String get kNakNameVishakha => 'বিশাখা';

  @override
  String get kNakNameAnuradha => 'অনুরাধা';

  @override
  String get kNakNameJyeshtha => 'জ্যেষ্ঠ';

  @override
  String get kNakNameMula => 'মুলা';

  @override
  String get kNakNamePurvaAshadha => 'পুর্ব আষাঢ়';

  @override
  String get kNakNameUttaraAshadha => 'উত্তরা আষাঢ়';

  @override
  String get kNakNameShravana => 'শ্রাবণ';

  @override
  String get kNakNameDhanishta => 'ধনিষ্ট';

  @override
  String get kNakNameShatabhisha => 'শতভীষা';

  @override
  String get kNakNamePurvaBhadrapada => 'পূর্বা ভাদ্রপদ';

  @override
  String get kNakNameUttaraBhadrapada => 'উত্তরা ভাদ্রপদ';

  @override
  String get kNakNameRevati => 'রেবতী';

  @override
  String get kChartNameD1 => 'রাশি';

  @override
  String get kChartSigD1 => 'শারীরিক শরীর, সামগ্রিক জীবন, সবকিছু';

  @override
  String get kChartNameD2 => 'হোরা';

  @override
  String get kChartSigD2 => 'সম্পদ, আর্থিক সমৃদ্ধি';

  @override
  String get kChartNameD3 => 'ড্রেক্কানা';

  @override
  String get kChartSigD3 => 'ভাইবোন, সাহস, উদ্যোগ';

  @override
  String get kChartNameD4 => 'চতুর্থাংশ';

  @override
  String get kChartSigD4 => 'ভাগ্য, সম্পত্তি, স্থায়ী সম্পদ, বাড়ি';

  @override
  String get kChartNameD5 => 'পঞ্চমশা';

  @override
  String get kChartSigD5 => 'খ্যাতি, কর্তৃত্ব, আধ্যাত্মিক যোগ্যতা (পুণ্য)';

  @override
  String get kChartNameD6 => 'ষষ্ঠমশা';

  @override
  String get kChartSigD6 => 'স্বাস্থ্য, রোগ, ঋণ, শত্রু';

  @override
  String get kChartNameD7 => 'সপ্তমশা';

  @override
  String get kChartSigD7 => 'শিশু, বংশধর, সৃজনশীলতা';

  @override
  String get kChartNameD8 => 'অষ্টমশা';

  @override
  String get kChartSigD8 => 'আকস্মিক ঘটনা, দীর্ঘায়ু সমস্যা, বাধা';

  @override
  String get kChartNameD9 => 'নবমশা';

  @override
  String get kChartSigD9 =>
      'পত্নী, ধর্ম, অভ্যন্তরীণ স্ব - প্রাথমিক সমর্থন চার্ট';

  @override
  String get kChartNameD10 => 'দশমশা';

  @override
  String get kChartSigD10 => 'কর্মজীবন, পেশা, মর্যাদা, অর্জন';

  @override
  String get kChartNameD11 => 'রুদ্রমশা';

  @override
  String get kChartSigD11 => 'মৃত্যু, ধ্বংস, প্রতিকূলতা থেকে লাভ (লাভা)';

  @override
  String get kChartNameD12 => 'দ্বাদশমশা';

  @override
  String get kChartSigD12 => 'পিতা-মাতা, বংশ, উত্তরাধিকারসূত্রে প্রাপ্ত কর্ম';

  @override
  String get kChartNameD16 => 'শোদশমশা';

  @override
  String get kChartSigD16 => 'যানবাহন, আরাম, বিলাসিতা, সুখ';

  @override
  String get kChartNameD20 => 'বিমশামশা';

  @override
  String get kChartSigD20 => 'আধ্যাত্মিক অনুশীলন, উপাসনা, ভক্তি';

  @override
  String get kChartNameD24 => 'চতুর্ভিমাংশ';

  @override
  String get kChartSigD24 => 'শিক্ষা, শিক্ষা, জ্ঞান';

  @override
  String get kChartNameD27 => 'সপ্তভীমাংশ';

  @override
  String get kChartSigD27 => 'শক্তি এবং দুর্বলতা, সহনশীলতা';

  @override
  String get kChartNameD30 => 'ত্রিমশামশা';

  @override
  String get kChartSigD30 => 'দুর্ভাগ্য, মন্দ, নৈতিক চরিত্র';

  @override
  String get kChartNameD40 => 'চাটভারীমশামশা';

  @override
  String get kChartSigD40 => 'মাতৃ উত্তরাধিকার, শুভ/অশুভ প্রভাব';

  @override
  String get kChartNameD45 => 'অক্ষবেদমশা';

  @override
  String get kChartSigD45 => 'পৈতৃক উত্তরাধিকার, সামগ্রিক চরিত্র এবং আচরণ';

  @override
  String get kChartNameD60 => 'ষষ্ঠীমশা';

  @override
  String get kChartSigD60 => 'অতীত জীবনের কর্ম, সর্বোত্তম স্তর — সামগ্রিকভাবে';

  @override
  String get kChartNameMoon => 'চাঁদের তালিকা (চন্দ্র)';

  @override
  String get kChartSigMoon => 'মন এবং আবেগ - চাঁদ থেকে পড়া রাশি চার্ট';

  @override
  String get kChartNameChalit => 'ভাব চলিত';

  @override
  String get kChartSigChalit =>
      'প্রকৃত ভব কুপস (শ্রীপতি) দ্বারা ঘরের ফলাফল, সম্পূর্ণ চিহ্ন নয়';

  @override
  String get kChartNameTransit => 'ট্রানজিট (গোচর)';

  @override
  String get kChartSigTransit => 'গর্ভগৃহের উপর বর্তমান গ্রহ';

  @override
  String get kChartShortMoon => 'চাঁদ';

  @override
  String get kChartShortChalit => 'চলিত';

  @override
  String get kChartShortTransit => 'ট্রানজিট';

  @override
  String get kChAscendant => 'আরোহী';

  @override
  String get kChLagnaVargottama => 'লগ্ন ভার্গোত্তমা';

  @override
  String kChAsOf(Object when) {
    return '$when হিসাবে';
  }

  @override
  String get kChUnverified =>
      'দৃকপঞ্চং-এর বিরুদ্ধে এই বিভাগটি এখনও যাচাই করা হয়নি — প্লেসমেন্টগুলিকে পরীক্ষামূলক হিসাবে বিবেচনা করুন।';

  @override
  String kChChalitShiftedOne(Object planets) {
    return '$planets পুরো-সাইন হাউসের চেয়ে ভিন্ন ভবতে বসে।';
  }

  @override
  String kChChalitShiftedMany(Object planets) {
    return '$planets পুরো-সাইন হাউসের চেয়ে আলাদা ভাবে বসে।';
  }

  @override
  String get kChColPlanet => 'গ্রহ';

  @override
  String get kChColSign => 'সাইন করুন';

  @override
  String get kChColDegree => 'ডিইজি';

  @override
  String get kChColHouse => 'হাউস';

  @override
  String get kChColBhava => 'ভব';

  @override
  String get kChColFromMoon => 'চাঁদ';

  @override
  String get kChLegend => 'কিংবদন্তি';

  @override
  String get kChLegendNote =>
      '℞ বিপরীতমুখী ⬦ ভার্গোত্তমা ← স্থানান্তরিত ভব (চলিত)\nউত্তর: ঘর সংখ্যা = রাশি (1 মেষ … 12 মীন), 1ম ঘর শীর্ষ-কেন্দ্র।';

  @override
  String get kChNorthIndian => 'উত্তর ভারতীয়';

  @override
  String get kChSouthIndian => 'দক্ষিণ ভারতীয়';

  @override
  String get kChPickerCharts => 'চার্ট';

  @override
  String get kChPickerDivisional => 'বিভাগীয় তালিকা (ভার্গ)';

  @override
  String get kOvTitle => 'কুন্ডলী';

  @override
  String kOvTitleNamed(Object name) {
    return '$name এর কুন্ডলি';
  }

  @override
  String get kOvDownloadPdf => 'PDF ডাউনলোড করুন';

  @override
  String get kOvShare => 'শেয়ার করুন';

  @override
  String get kOvMoonSignLabel => 'চাঁদের চিহ্ন · রাশি';

  @override
  String kOvLagnaChip(Object sign) {
    return 'লগনা · $sign';
  }

  @override
  String kOvNakshatraChip(Object name) {
    return 'নক্ষত্র · $name';
  }

  @override
  String get kOvTimeApprox => 'জন্ম সময় আনুমানিক';

  @override
  String get kOvEdit => 'সম্পাদনা করুন';

  @override
  String get kOvLagnaChart => 'লগ্ন চার্ট';

  @override
  String get kOvD1Rasi => 'ডি 1 রাসি';

  @override
  String get kOvOpenFullChart => 'সম্পূর্ণ চার্ট খুলুন';

  @override
  String get kOvDashaUnavailable => 'Dasha এই মুহূর্তে অনুপলব্ধ.';

  @override
  String get kOvDashaRunning => 'আপনি বর্তমানে চলমান';

  @override
  String kOvMahadasha(Object planet) {
    return '$planet মহাদশা';
  }

  @override
  String kOvSubPeriods(Object antar, Object pratyantar) {
    return '$antar সাব-পিরিয়ড · $pratyantar প্রত্যন্তর';
  }

  @override
  String kOvDashaProgress(Object end, Object percent, Object start) {
    return '$start → $end · $percent % এর মাধ্যমে';
  }

  @override
  String get kOvSeeTimeline => 'সম্পূর্ণ টাইমলাইন দেখুন';

  @override
  String get kOvAtAGlance => 'এক নজরে';

  @override
  String get kOvMangalDosha => 'মঙ্গল দোষ';

  @override
  String get kOvManglik => 'মাঙ্গলিক';

  @override
  String get kOvNotManglik => 'মাঙ্গলিক নয়';

  @override
  String kOvMangalFrom(Object refs) {
    return '$refs থেকে';
  }

  @override
  String get kOvMarsClear => 'মঙ্গল পরিষ্কার';

  @override
  String get kOvMangalCancelled =>
      'বর্তমান, কিন্তু আপনার চার্টে বাতিল করা হয়েছে';

  @override
  String kOvMangalLevelFrom(Object level, Object refs) {
    return '$level · $refs থেকে';
  }

  @override
  String get kOvRefLagna => 'লগনা';

  @override
  String get kOvYogas => 'যোগাস';

  @override
  String kOvYogasFound(Object count) {
    return '$count পাওয়া গেছে';
  }

  @override
  String get kOvNakshatra => 'নক্ষত্র';

  @override
  String get kOvLagnaLord => 'লগ্ন প্রভু';

  @override
  String get kOvExInsights => 'ব্যক্তিত্ব এবং জীবন ওভারভিউ';

  @override
  String get kOvExInsightsSub =>
      'আপনার চার্টের একটি বিনামূল্যে পড়া — প্রকৃতি, কাজ, বিবাহ এবং আরও অনেক কিছু';

  @override
  String get kOvExForecast => 'লিখিত পূর্বাভাস';

  @override
  String get kOvExForecastSub =>
      'একটি জ্যোতিষী দ্বারা লিখিত জীবনের একটি ক্ষেত্রের জন্য একটি অর্থ প্রদানের পূর্বাভাস';

  @override
  String get kOvExPlanets => 'গ্রহ এবং অবস্থান';

  @override
  String get kOvExPlanetsSub => 'প্রতিটি গ্রহ কোথায় বসে এবং এটি কী করে';

  @override
  String get kOvExDasha => 'দশা পিরিয়ড';

  @override
  String get kOvExDashaSub => 'তোমার জীবনের সময়রেখা — বিমশোত্তরি';

  @override
  String get kOvExVarshphal => 'বর্ষফল (বার্ষিক চার্ট)';

  @override
  String get kOvExVarshphalSub =>
      'এই সৌর-প্রত্যাবর্তন বছর — মুনথা, বছরের প্রভু এবং তাজিকা দিক';

  @override
  String get kOvExYogas => 'যোগ এবং দোষ';

  @override
  String get kOvExYogasSub => 'আপনার চার্টে বিশেষ সমন্বয়';

  @override
  String get kOvExRemedies => 'প্রতিকার';

  @override
  String get kOvExRemediesSub =>
      'আপনার চার্টের জন্য ঐতিহ্যবাহী মন্ত্র, দান এবং অনুশীলন';

  @override
  String get kOvExUpaya => 'রত্নপাথর ও উপয়া';

  @override
  String get kOvExUpayaSub =>
      'প্রতি-গ্রহ রত্নপাথর, রঙ, দিন এবং মন্ত্র — রত্ন পাথর গেটেড';

  @override
  String get kOvExLalKitab => 'লাল কিতাব';

  @override
  String get kOvExLalKitabSub =>
      'উত্তরাধিকারসূত্রে প্রাপ্ত ঋণ (রিন) এবং তাদের সহজ, বিনামূল্যের টোটকা প্রতিকার';

  @override
  String get kOvExTransits => 'ট্রানজিট এবং সাদে সতী';

  @override
  String get kOvExTransitsSub => 'আকাশ এখন কি করছে';

  @override
  String get kOvExSadeSati => 'সাদে সতী ও ধাইয়া ক্যালেন্ডার';

  @override
  String get kOvExSadeSatiSub => 'আপনার জীবনের প্রতিটি শনি উইন্ডো, তারিখ সহ';

  @override
  String get kOvExMuhurta => 'আজকের টাইমিং';

  @override
  String get kOvExMuhurtaSub =>
      'চোঘদিয়া এবং হোরা, আপনার সেরা উইন্ডোগুলি চিহ্নিত করে৷';

  @override
  String get kOvExHouses => 'ঘর (ভাব)';

  @override
  String get kOvExHousesSub => '12টি বাড়ির প্রতিটির জন্য একটি পাঠ';

  @override
  String get kOvExNumerology => 'সংখ্যাতত্ত্ব এবং লো শু গ্রিড';

  @override
  String get kOvExNumerologySub =>
      'জন্ম তারিখ থেকে আপনার সংখ্যা — দিন, রং, জন্ম গ্রিড';

  @override
  String get kOvExAdvanced => 'উন্নত প্রতিবেদন';

  @override
  String get kOvExAdvancedSub => 'অষ্টকবর্গ, শব্দবালা, কেপি, জৈমিনী';

  @override
  String get kOvAskAstrologer =>
      'আপনার কুন্ডলি সম্পর্কে একজন জ্যোতিষীকে জিজ্ঞাসা করুন';

  @override
  String get kReadingCardTitle => 'এর মানে কি';

  @override
  String kSsTitle(Object phase) {
    return 'সাদে সতী · $phase পর্ব';
  }

  @override
  String get kSsPhaseRising => 'রাইজিং (3 এর মধ্যে 1)';

  @override
  String get kSsPhasePeak => 'পিক (৩টির মধ্যে ২)';

  @override
  String get kSsPhaseSetting => 'সেটিং (৩টির মধ্যে ৩)';

  @override
  String get kSsRising => 'উঠছে';

  @override
  String get kSsPeak => 'পিক';

  @override
  String get kSsSetting => 'সেটিং';

  @override
  String get kSsNotCurse =>
      'সাদে সতী কঠোর পরিশ্রম এবং পরিপক্কতার সময়কাল - অভিশাপ নয়। অবিচলিত, সৎ প্রচেষ্টা পুরস্কৃত হয়।';

  @override
  String get kSsWhatForMe => 'এই আমার জন্য মানে কি';

  @override
  String kSsPanotiTitle(Object type) {
    return 'ছোট পানোতি — $type';
  }

  @override
  String get kSsPanotiBody =>
      'একটি ছোট শনির পর্যায় (প্রায় 2½ বছর) যা স্বাস্থ্য, প্রচেষ্টা এবং দৈনন্দিন বাধাগুলির সাথে ধৈর্যের জন্য জিজ্ঞাসা করে।';

  @override
  String get kSsSeeTransits => 'ট্রানজিট দেখুন';

  @override
  String get kSsSkyNow => 'এই মুহূর্তে আকাশে';

  @override
  String get kSsJupiterGood =>
      'বৃহস্পতি আপনার জন্য অনুকূলভাবে স্থানান্তর করছে — বৃদ্ধি, শিক্ষা এবং অর্থের জন্য একটি সহায়ক উইন্ডো।';

  @override
  String get kSsJupiterNeutral =>
      'কোন Sade Sati বা প্রধান শনি পর্যায় সক্রিয় নেই। বৃহস্পতির ট্রানজিট এখন আপনার জন্য নিরপেক্ষ।';

  @override
  String get kSsSeeAllTransits => 'সমস্ত ট্রানজিট দেখুন';

  @override
  String get kFcTitle => 'জন্ম তালিকা';

  @override
  String get kFcTransitingGrahas => 'ট্রানজিটিং গ্রহ';

  @override
  String get kFcPlanets => 'গ্রহ';

  @override
  String get kFcAllHouses => 'সব 12 ঘর এবং পড়া';

  @override
  String get kFcAllCharts => 'সমস্ত চার্ট — D1 থেকে D60';

  @override
  String get kFcAllChartsTooltip => 'সমস্ত চার্ট';

  @override
  String get kFcLoadError => 'এই চার্ট লোড করা যায়নি';

  @override
  String get kFcTwelveHouses => '12টি ঘর';

  @override
  String get kFcNoPlanets => 'গ্রহ নেই';

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
  String get horoTitle => 'রাশিফল';

  @override
  String get horoReadFull => 'সম্পূর্ণ রাশিফল ​​পড়ুন';

  @override
  String get horoSpanYesterday => 'গতকাল';

  @override
  String get horoSpanToday => 'আজ';

  @override
  String get horoSpanTomorrow => 'কাল';

  @override
  String get horoSpanWeek => 'এই সপ্তাহে';

  @override
  String get horoSpanMonth => 'এই মাসে';

  @override
  String get horoAreaLove => 'প্রেম';

  @override
  String get horoAreaCareer => 'কর্মজীবন';

  @override
  String get horoAreaMoney => 'টাকা';

  @override
  String get horoAreaHealth => 'স্বাস্থ্য';

  @override
  String get horoOverall => 'সামগ্রিকভাবে';

  @override
  String get horoOutOfFive => '5 এর মধ্যে';

  @override
  String get horoToneSupportive => 'সহায়ক';

  @override
  String get horoToneBalanced => 'সুষম';

  @override
  String get horoToneChallenging => 'যত্ন প্রয়োজন';

  @override
  String get horoLuckyColour => 'ভাগ্যবান রঙ';

  @override
  String get horoLuckyNumber => 'ভাগ্যবান সংখ্যা';

  @override
  String get horoLuckyPlanet => 'শক্তিশালী গ্রহ';

  @override
  String get horoBestDays => 'আপনার সেরা দিন';

  @override
  String get horoTipTitle => 'প্রতিকার ও টিপ';

  @override
  String horoTipFor(String planet) {
    return '$planet এর প্রতিকার';
  }

  @override
  String get horoWhyTitle => 'তারকারা কেন এ কথা বলেন';

  @override
  String get horoWhyBody =>
      'বৈদিক রাশিফল ​​পড়া হয় যেখানে প্রতিটি গ্রহ স্থানান্তর করছে, আপনার চন্দ্র রাশি থেকে গণনা করা হয়। তীরগুলি দেখায় যে কোনও স্থান আপনাকে সমর্থন করে বা যত্নের জন্য জিজ্ঞাসা করে।';

  @override
  String horoMoonLine(String sign, String nakshatra, String house) {
    return '$sign · $nakshatra · বাড়ি $house এ চাঁদ৷';
  }

  @override
  String horoHouseN(String n) {
    return 'বাড়ি $n';
  }

  @override
  String horoAboutSign(String sign) {
    return 'প্রায় $sign';
  }

  @override
  String get horoElement => 'উপাদান';

  @override
  String get horoRuler => 'শাসক গ্রহ';

  @override
  String get horoQuality => 'প্রকৃতি';

  @override
  String get horoElementFire => 'আগুন';

  @override
  String get horoElementEarth => 'পৃথিবী';

  @override
  String get horoElementAir => 'বায়ু';

  @override
  String get horoElementWater => 'জল';

  @override
  String get horoQualityMovable => 'চলমান';

  @override
  String get horoQualityFixed => 'স্থির';

  @override
  String get horoQualityDual => 'দ্বৈত';

  @override
  String get horoChangeSign => 'চিহ্ন পরিবর্তন করুন';

  @override
  String get horoChooseSign => 'আপনার চিহ্ন চয়ন করুন';

  @override
  String get horoWhichSignTitle => 'আমি কোন সাইন বাছাই করা উচিত?';

  @override
  String get horoWhichSignBody =>
      'বৈদিক রাশিফলগুলি আপনার চন্দ্র রাশি (রাশি) থেকে পড়া হয় - আপনার জন্মের সময় চন্দ্র যে চিহ্নে ছিল। এটি প্রায়ই আপনার পশ্চিম সূর্য চিহ্ন থেকে ভিন্ন হয়। আপনার কুন্ডলী আপনার চন্দ্র চিহ্ন দেখায়; সবচেয়ে সঠিক পড়ার জন্য এখানে বাছাই করুন.';

  @override
  String get horoOpenKundali => 'কুন্ডলীতে আমার চন্দ্র রাশি দেখুন';

  @override
  String get horoCtaTitle => 'শুধু আপনার জন্য একটি পড়া চান?';

  @override
  String horoCtaBody(String sign) {
    return 'এই পূর্বাভাস $sign এর নিচে জন্মগ্রহণকারী প্রত্যেকের জন্য। একজন জ্যোতিষী আপনার ব্যক্তিগত চার্ট পড়তে পারেন।';
  }

  @override
  String get horoCtaButton => 'একজন জ্যোতিষীর সাথে কথা বলুন';

  @override
  String get horoShare => 'শেয়ার করুন';

  @override
  String get horoEditorialBadge => 'আমাদের জ্যোতিষীরা লিখেছেন';

  @override
  String get horoError => 'আমরা রাশিফল ​​লোড করতে পারিনি';

  @override
  String get horoSourceNote =>
      'আপনার চন্দ্র চিহ্ন থেকে লাইভ গ্রহের ট্রানজিটের উপর ভিত্তি করে। নির্দেশনার জন্য, নিশ্চিততা নয়।';

  @override
  String get matchTitle => 'কুন্ডলী মিলন';

  @override
  String get matchHeroTitle => 'দুটি কুন্ডলী মেলান';

  @override
  String get matchHeroBody => 'গুনা মিলন, মাঙ্গলিক এবং দোষ সেকেন্ডে চেক করুন।';

  @override
  String get matchBoy => 'ছেলে';

  @override
  String get matchGirl => 'মেয়ে';

  @override
  String get matchSwap => 'অদলবদল';

  @override
  String get matchChoosePerson => 'ব্যক্তি নির্বাচন করুন';

  @override
  String get matchTapToSelect => 'নির্বাচন করতে আলতো চাপুন';

  @override
  String get matchRunCta => 'সামঞ্জস্য পরীক্ষা করুন';

  @override
  String get matchPickBothHint => 'আপনার ম্যাচের স্কোর দেখতে দুজনকেই বেছে নিন।';

  @override
  String get matchPickBoyTitle => 'ছেলের জন্মের বিবরণ বেছে নিন';

  @override
  String get matchPickGirlTitle => 'মেয়ের জন্মের বিশদ নির্বাচন করুন';

  @override
  String get matchAddPerson => 'একটি নতুন ব্যক্তি যোগ করুন';

  @override
  String get matchAddPersonHint => 'জন্ম তারিখ, সময় এবং স্থান';

  @override
  String get matchNoProfiles =>
      'এখনও কোন সংরক্ষিত জন্ম বিবরণ. শুরু করতে একজন ব্যক্তি যোগ করুন।';

  @override
  String get matchHowTitle => 'এটা কিভাবে কাজ করে';

  @override
  String get matchStep1Title => 'দুইজনকে বেছে নিন';

  @override
  String get matchStep1Body =>
      'সংরক্ষিত জন্মের বিবরণ ব্যবহার করুন বা নতুন যোগ করুন — সময় এবং স্থান এটিকে সঠিক করে তোলে।';

  @override
  String get matchStep2Title => 'আমরা উভয় চাঁদের চার্ট তুলনা করি';

  @override
  String get matchStep2Body =>
      'আটটি কুট - স্বভাব থেকে স্বাস্থ্য - ঐতিহ্যগত অষ্টকূট পদ্ধতিতে স্কোর করা হয়।';

  @override
  String get matchStep3Title => 'আপনার স্কোর এবং dosha চেক পান';

  @override
  String get matchStep3Body =>
      '36 এর মধ্যে একটি স্কোর, মাঙ্গলিক সামঞ্জস্য এবং প্রতিটি অংশের অর্থ কী।';

  @override
  String get matchHistoryTitle => 'আপনার মিল';

  @override
  String get matchHistoryEmpty =>
      'আপনার মিলগুলি এখানে প্রদর্শিত হবে যাতে আপনি যে কোনো সময় সেগুলিকে পুনরায় দেখতে পারেন৷';

  @override
  String get matchRetry => 'আবার চেষ্টা করুন';

  @override
  String matchPairNames(String boy, String girl) {
    return '$boy এবং $girl';
  }

  @override
  String get matchResultTitle => 'ম্যাচের ফলাফল';

  @override
  String get matchOutOf36 => '36 এর মধ্যে';

  @override
  String matchShareScore(String score, String verdict) {
    return 'গুনা মিলান: $score /36 · $verdict';
  }

  @override
  String get matchVerdictExcellent => 'চমৎকার ম্যাচ';

  @override
  String get matchVerdictGood => 'ভালো মিল';

  @override
  String get matchVerdictAverage => 'গড় ম্যাচ';

  @override
  String get matchVerdictLow => 'একটি ঘনিষ্ঠ চেহারা প্রয়োজন';

  @override
  String get matchVerdictExcellentBody =>
      'বেশিরভাগ কুট সারিবদ্ধ - ঐতিহ্যগতভাবে একটি সুরেলা, সহায়ক বিবাহের চিহ্ন।';

  @override
  String get matchVerdictGoodBody =>
      '18 বা ততোধিক গুন বিবাহের জন্য উপযুক্ত বলে বিবেচিত হয়। নীচের কম স্কোরিং kootas চেক করুন.';

  @override
  String get matchVerdictAverageBody =>
      '18 গুণের নিচে, জ্যোতিষীরা সাধারণত সিদ্ধান্ত নেওয়ার আগে একটি সম্পূর্ণ চার্ট পর্যালোচনার পরামর্শ দেন।';

  @override
  String get matchVerdictLowBody =>
      'একা এই স্কোর নিয়ে সিদ্ধান্ত নেবেন না — একটি সম্পূর্ণ কুন্ডলি পর্যালোচনা প্রায়ই ছবি পরিবর্তন করে।';

  @override
  String get matchManglikShort => 'মাঙ্গলিক';

  @override
  String get matchManglikTitle => 'মাঙ্গলিক (মঙ্গল দোষ) চেক';

  @override
  String get matchManglikNone =>
      'আপনারা কেউই মাঙ্গলিক নন—মঙ্গল দোষের চিন্তা নেই।';

  @override
  String get matchManglikBoth =>
      'তোমরা দুজনেই মাঙ্গলিক — ঐতিহ্যগতভাবে দোষ বাতিল হয়ে যায়।';

  @override
  String get matchManglikCancelled =>
      'মঙ্গল দোষ উপস্থিত আছে কিন্তু চার্টের অন্যান্য স্থাপনা দ্বারা বাতিল করা হয়েছে।';

  @override
  String get matchManglikMismatch =>
      'তোমাদের মধ্যে একজনই মাঙ্গলিক। প্রতিকার এবং একটি সম্পূর্ণ চার্ট পর্যালোচনা সম্পর্কে একজন জ্যোতিষীর সাথে কথা বলুন।';

  @override
  String get matchIsManglik => 'মাঙ্গলিক';

  @override
  String get matchNotManglik => 'মাঙ্গলিক নয়';

  @override
  String get matchManglikCancelledShort => 'মাঙ্গলিক (বাতিল)';

  @override
  String matchCheckClear(String name) {
    return '$name : পরিষ্কার';
  }

  @override
  String matchCheckPresent(String name) {
    return '$name : বর্তমান';
  }

  @override
  String get matchDoshaNadi => 'নদী দোষ';

  @override
  String get matchDoshaBhakoot => 'ভকূট দোষ';

  @override
  String get matchDoshaGana => 'গণ দোষ';

  @override
  String get matchDoshaTag => 'দোশা';

  @override
  String get matchBreakdownTitle => 'গুনা ভাঙ্গন';

  @override
  String get matchBreakdownSub =>
      'এটির অর্থ কী তা দেখতে যে কোনও কুটাতে ট্যাপ করুন।';

  @override
  String get matchKootaVarna => 'বর্ণ';

  @override
  String get matchKootaVashya => 'বশ্যা';

  @override
  String get matchKootaTara => 'তারা';

  @override
  String get matchKootaYoni => 'ইয়োনি';

  @override
  String get matchKootaMaitri => 'গ্রহ মৈত্রী';

  @override
  String get matchKootaGana => 'গণ';

  @override
  String get matchKootaBhakoot => 'ভাকূট';

  @override
  String get matchKootaNadi => 'নদী';

  @override
  String get matchKootaVarnaMeaning => 'মূল্যবোধ ও অহংকার';

  @override
  String get matchKootaVashyaMeaning => 'পারস্পরিক আকর্ষণ';

  @override
  String get matchKootaTaraMeaning => 'ভাগ্য ও মঙ্গল';

  @override
  String get matchKootaYoniMeaning => 'শারীরিক সামঞ্জস্য';

  @override
  String get matchKootaMaitriMeaning => 'মানসিক তরঙ্গদৈর্ঘ্য';

  @override
  String get matchKootaGanaMeaning => 'মেজাজ';

  @override
  String get matchKootaBhakootMeaning => 'প্রেম, পরিবার এবং আর্থিক';

  @override
  String get matchKootaNadiMeaning => 'স্বাস্থ্য এবং শিশু';

  @override
  String get matchKootaVarnaDetail =>
      'উভয় চন্দ্র চিহ্নের আধ্যাত্মিক মেজাজের তুলনা করে — আপনার মূল্যবোধ এবং কর্তব্যবোধ কতটা স্বাভাবিকভাবেই আপ হয়। মূল্য 1 পয়েন্ট।';

  @override
  String get matchKootaVashyaDetail =>
      'অংশীদারদের মধ্যে স্বাভাবিক টান এবং প্রভাব দেখায় — কে নেতৃত্ব দেয়, কে মানিয়ে নেয় এবং আপনি কত সহজে সম্মত হন। মূল্য 2 পয়েন্ট.';

  @override
  String get matchKootaTaraDetail =>
      'ভাগ্য, স্বাস্থ্য এবং বন্ধনের দীর্ঘায়ু বিচার করতে আপনার মধ্যে নক্ষত্র গণনা করে। মূল্য 3 পয়েন্ট।';

  @override
  String get matchKootaYoniDetail =>
      'প্রতিটি নক্ষত্রের একটি পশু প্রকৃতি আছে; এই কুটা ঘনিষ্ঠতা এবং শারীরিক সামঞ্জস্যের জন্য তাদের তুলনা করে। মূল্য 4 পয়েন্ট.';

  @override
  String get matchKootaMaitriDetail =>
      'আপনার চন্দ্র রাশির অধিপতিদের সাথে তুলনা করুন - তাদের মধ্যে বন্ধুত্ব মানে আপনি একইভাবে চিন্তা করেন এবং সহজেই সমস্যাগুলি সমাধান করেন। মূল্য 5 পয়েন্ট।';

  @override
  String get matchKootaGanaDetail =>
      'নক্ষত্রকে দেব, মনুষ্য এবং রাক্ষস স্বভাবের মধ্যে গোষ্ঠীভুক্ত করে। একটি অমিল মানে ঘন ঘন ঘর্ষণ হতে পারে। মূল্য 6 পয়েন্ট।';

  @override
  String get matchKootaBhakootDetail =>
      'আপনার চাঁদের চিহ্নগুলির মধ্যে দূরত্ব দেখে, যা ঐতিহ্যগতভাবে প্রেম, পারিবারিক বৃদ্ধি এবং ভাগ করা অর্থকে প্রভাবিত করে। মূল্য 7 পয়েন্ট.';

  @override
  String get matchKootaNadiDetail =>
      'সবচেয়ে ওজনের কুটা। একই নদী (0 পয়েন্ট) ঐতিহ্যগতভাবে স্বাস্থ্য এবং বংশধরদের উদ্বেগের সাথে যুক্ত এবং সুপরিচিত ব্যতিক্রম রয়েছে। মূল্য 8 পয়েন্ট.';

  @override
  String get matchChartsTitle => 'জন্ম তালিকার বিশদ বিবরণ';

  @override
  String get matchRowRasi => 'চাঁদের চিহ্ন';

  @override
  String get matchRowNakshatra => 'নক্ষত্র';

  @override
  String get matchRowGana => 'গণ';

  @override
  String get matchRowYoni => 'ইয়োনি';

  @override
  String get matchAskTitle => 'একজন জ্যোতিষীর সাথে কথা বলুন';

  @override
  String get matchAskBody =>
      'দোষের প্রায়ই বাতিল এবং প্রতিকার আছে। উভয় চার্ট একটি সম্পূর্ণ পড়া পান.';

  @override
  String get matchDisclaimer =>
      'গুনা মিলান একটি ঐতিহ্যগত গাইড, গ্যারান্টি নয়। সম্পূর্ণ চার্ট এবং আপনার নিজের রায় বিবেচনা করুন.';

  @override
  String get matchRelSelf => 'আমি নিজেই';

  @override
  String get matchRelPartner => 'অংশীদার';

  @override
  String get matchRelChild => 'শিশু';

  @override
  String get matchRelParent => 'অভিভাবক';

  @override
  String get matchRelSibling => 'ভাইবোন';

  @override
  String get matchRelFriend => 'বন্ধু';

  @override
  String get kAdvTitle => 'উন্নত প্রতিবেদন';

  @override
  String get kAdvIntro =>
      'প্রযুক্তিগত স্তরগুলি জ্যোতিষীরা গভীরতা এবং সময়ের জন্য ব্যবহার করে। আগ্রহের জন্য এগুলি স্কিম করুন বা পরামর্শের সময় একটি খুলুন।';

  @override
  String get kAdvAshtakavarga => 'অষ্টকবর্গা';

  @override
  String get kAdvAshtakavargaSub =>
      'প্রতিটি চিহ্নের বিন্দু-শক্তি। উচ্চতর = আকাশ সেখানে ট্রানজিট সমর্থন করে।';

  @override
  String get kAdvShadbala => 'শাদবালা';

  @override
  String get kAdvShadbalaSub =>
      'প্রতিটি গ্রহের ছয়গুণ শক্তি, যা প্রয়োজন তার বিপরীতে পরিমাপ করা হয়।';

  @override
  String get kAdvKp => 'কেপি সিস্টেম';

  @override
  String get kAdvKpSub =>
      'কৃষ্ণমূর্তি পদধতি — cuspal উপ-প্রভু এবং সময়ের জন্য শাসক গ্রহ।';

  @override
  String get kAdvJaimini => 'জৈমিনী';

  @override
  String get kAdvJaiminiSub =>
      'চারা কারাকস, অরুধা লগ্ন এবং জৈমিনি একটি চার্ট পড়ার উপায়।';

  @override
  String get kAdvDownloadPdf => 'সম্পূর্ণ পিডিএফ রিপোর্ট ডাউনলোড করুন';

  @override
  String get kAdvFooter =>
      'এগুলো প্রযুক্তিগত। সহজ কথায় পড়ার জন্য, একজন জ্যোতিষীর সাথে কথা বলুন।';

  @override
  String get kAdvReport => 'রিপোর্ট';

  @override
  String get kAdvLoadError => 'এই রিপোর্ট লোড করা যায়নি.';

  @override
  String get kAdvKpIntro =>
      'কেপি রাশিচক্রকে 249টি উপ-অংশে বিভক্ত করেছে। একটি বাড়ির উপ-প্রভু সিদ্ধান্ত নেয় যে জীবনের সেই ক্ষেত্রটি সরবরাহ করে কিনা; শাসক গ্রহগুলি অন-দ্য-স্পট টাইমিংয়ের জন্য ব্যবহৃত হয়।';

  @override
  String get kAdvJaiminiIntro =>
      'জৈমিনি চর কারাকাস (ডিগ্রী অনুসারে গ্রহগুলি, প্রতিটি একটি জীবন ক্ষেত্র নির্দেশ করে) এবং অরুধা পদগুলির মাধ্যমে চার্টটি পড়েন — কীভাবে জিনিসগুলি বিশ্বের কাছে উপস্থিত হয়।';

  @override
  String get kAdvAvIntro =>
      'সর্বাষ্টকবর্গা প্রতিটি গৃহে প্রতিটি গ্রহের অবদান যোগ করে — মোট সর্বদা 337টি। একটি ঘর 28+ স্কোর করে গ্রহগুলিকে এর মধ্য দিয়ে স্থানান্তরিত করতে সহায়তা করে; 25 এর নিচে একটি দুর্বল প্যাচ।';

  @override
  String kAdvHouseN(Object n) {
    return 'বাড়ি $n';
  }

  @override
  String get kAdvBhinnaTotals => 'গ্রহ প্রতি মোট (ভিন্নাষ্টকবর্গা)';

  @override
  String get kAdvShadbalaIntro =>
      'শাদবালা প্রতিটি গ্রহের শক্তিকে ন্যূনতম প্রয়োজনের বিপরীতে রূপসে স্কোর করে। 1.0 এর উপরে অনুপাত মানে গ্রহটি তার ফলাফল নির্ভরযোগ্যভাবে সরবরাহ করতে পারে।';

  @override
  String kAdvStrongest(Object planet) {
    return 'সবচেয়ে শক্তিশালী: $planet';
  }

  @override
  String kAdvWeakest(Object planet) {
    return 'সবচেয়ে দুর্বল: $planet';
  }

  @override
  String get kAdvReadWithAstrologer =>
      'এই প্রতিবেদনটি একজন জ্যোতিষীর কাছে পড়ার জন্য।';

  @override
  String get kAdvSecCuspalSublords => 'কুসপাল সাব-লর্ডস';

  @override
  String get kAdvSecRulingPlanets => 'শাসক গ্রহ';

  @override
  String get kAdvSecHouseSignificators => 'হাউস সিগনিকেটর';

  @override
  String get kAdvSecCharaKarakas => 'চরা করকস';

  @override
  String get kAdvSecArudhaPadas => 'অরুধা পদস';

  @override
  String get kAdvSecKarakamsa => 'কারাকামসা';

  @override
  String get kAdvSecCharaDasha => 'চরা দশা';

  @override
  String get kBhavaTitle => 'বাড়ি · ভাব';

  @override
  String get kBhavaIntro =>
      '12টি ঘরের প্রতিটি, এর প্রাকৃতিক তাৎপর্য এবং কীভাবে এর প্রভু এবং বাসিন্দারা এটিকে আকৃতি দেয়।';

  @override
  String get kBhavaMoreBenefic => 'ক্ষতিকর প্রভাবের চেয়ে বেশি উপকারী';

  @override
  String get kBhavaMoreMalefic => 'উপকারী প্রভাবের চেয়ে বেশি ক্ষতিকর';

  @override
  String kBhavaOccupiedBy(Object planets) {
    return '$planets দ্বারা দখল করা হয়েছে৷';
  }

  @override
  String kBhavaAspectedBy(Object planets) {
    return '$planets দ্বারা দৃষ্টিভঙ্গি';
  }

  @override
  String kBhavaBeneficCount(Object count) {
    return '$count উপকারী';
  }

  @override
  String kBhavaMaleficCount(Object count) {
    return '$count ক্ষতিকর';
  }

  @override
  String get kBhavaNeedsTime => 'ঘর বিশ্লেষণ একটি জন্ম সময় প্রয়োজন';

  @override
  String get kBhavaNeedsTimeBody =>
      'প্রতিটি বাড়ির আকৃতি কেমন তা দেখতে এই প্রোফাইলে জন্মের সঠিক সময় যোগ করুন।';

  @override
  String get kDashaIntroVimshottari =>
      'ভিমশোত্তরি হল গ্রহের সময়কালের একটি 120 বছরের চক্র, যেখানে চাঁদ আপনার জন্মের সময় বসেছিল।';

  @override
  String get kDashaIntroYogini =>
      'যোগিনী হল চাঁদের নক্ষত্র থেকে আট যোগিনীর একটি 36 বছরের চক্র।';

  @override
  String get kDashaIntroAshtottari =>
      'অষ্টোত্তরী হল Ardra থেকে গণনা করা একটি 108 বছরের চক্র।';

  @override
  String kDashaBalance(Object lord, Object years) {
    return 'জন্মের সময় $lord দশার ব্যালেন্স: $years বছর';
  }

  @override
  String get kDashaVimshottari => 'বিমশোত্তরী';

  @override
  String get kDashaYogini => 'যোগিনী';

  @override
  String get kDashaAshtottari => 'অষ্টোত্তরী';

  @override
  String get kDashaNowRunning => 'এখন চলছে';

  @override
  String get kDashaNow => 'এখন';

  @override
  String kDashaYears(Object count) {
    return '$count বছর';
  }

  @override
  String get kPlanetsIntro =>
      'প্রতিটি গ্রহ কোথায় বসে, এটি কতটা শক্তিশালী এবং এটি কী নিয়ে আসে। আরও পড়তে আলতো চাপুন। পজিশনগুলো সাইডরিয়াল (লাহিড়ী)।';

  @override
  String get kTrTitle => 'ট্রানজিট';

  @override
  String get kTrSadeSatiCalendar =>
      'সম্পূর্ণ সাদে সতী ক্যালেন্ডার দেখুন (তারিখ সহ)';

  @override
  String get kTrSkyNow => 'এই মুহূর্তে আকাশ — আপনার চার্টের বিপরীতে';

  @override
  String get kTrSadeSati => 'সাদে সতী';

  @override
  String kTrPhaseOf(Object n) {
    return '৩টির ​​মধ্যে $n ফেজ';
  }

  @override
  String get kTrPhaseHintRising => 'শনি দ্বাদশে';

  @override
  String get kTrPhaseHintPeak => 'চাঁদের উপরে';

  @override
  String get kTrPhaseHintSetting => 'শনি ২য়';

  @override
  String get kTrHowToWork => 'এটা দিয়ে কিভাবে কাজ করবেন';

  @override
  String get kTrTip1 =>
      'যা কাজ করছে না তা কাটুন - শনি এটি সম্পর্কে সততাকে পুরস্কৃত করে';

  @override
  String get kTrTip2 => 'রুটিন তৈরি করুন এবং আপনি যা শুরু করেন তা শেষ করুন';

  @override
  String get kTrTip3 => 'আপনার ঘুম, হাঁটু, দাঁত এবং বয়স্ক আত্মীয়দের যত্ন নিন';

  @override
  String get kTrTip4 =>
      'এটি একটি পুনর্নির্মাণ, শাস্তি নয়। এটি শেষ হওয়ার পরে ফলাফল দেখায়।';

  @override
  String get kTrPanotiBody =>
      'একটি ছোট (~2½ বছর) শনি পর্ব। স্বাস্থ্য, দৈনন্দিন প্রচেষ্টা এবং বাধাগুলির সাথে ঘর্ষণ আশা করুন - ধৈর্য এবং রুটিনের সাথে এটি পূরণ করুন।';

  @override
  String kTrPlanetInSign(Object planet, Object sign) {
    return '$sign-এ $planet';
  }

  @override
  String get kTrJupiterGood =>
      'বৃহস্পতির ট্রানজিট অনুকূল - এই মুহূর্তে বৃদ্ধি, শিক্ষা, অর্থ এবং পরিবারের জন্য সহায়ক।';

  @override
  String get kTrJupiterNeutral =>
      'বৃহস্পতির ট্রানজিট এই মুহূর্তে আপনার জন্য নিরপেক্ষ।';

  @override
  String get kTrCloseContacts => 'এখন পরিচিতি বন্ধ করুন';

  @override
  String kTrCloseContactLine(Object natal, Object planet) {
    return '$planet ট্রানজিট করা আপনার জন্মগত $natal এর 3° এর মধ্যে — জীবনের সেই ক্ষেত্রটি এই সপ্তাহে সক্রিয়।';
  }

  @override
  String kMuChoghadiya(String key, Object raw) {
    String _temp0 = intl.Intl.selectLogic(key, {'other': '$raw'});
    return '$_temp0';
  }

  @override
  String kUpOr(Object name) {
    return 'অথবা $name';
  }

  @override
  String kUpFinger(Object finger) {
    return '$finger আঙুল';
  }

  @override
  String get kYdPartial => 'আংশিক';

  @override
  String get moodTitle => 'আজকের মেজাজ';

  @override
  String get moodMeter => 'মুড মিটার';

  @override
  String get moodWhyTitle => 'আজ কেন এমন লাগছে';

  @override
  String get moodTipTitle => 'আজকের জন্য একটি ছোট জিনিস';

  @override
  String get moodLockedTitle => 'আপনার জ্যোতিষী আপনাকে বলতে পারেন';

  @override
  String get moodLockedSub =>
      'সম্পূর্ণ ছবির জন্য আপনার পুরো চার্ট প্রয়োজন, শুধু চাঁদ নয়।';

  @override
  String get moodTalkCta => 'এখন একজন জ্যোতিষীর সাথে কথা বলুন';

  @override
  String moodNextChange(Object when) {
    return '$when-এ আপনার মেজাজ পরিবর্তন হবে';
  }

  @override
  String get kOvExMood => 'আজকের মেজাজ';

  @override
  String get kOvExMoodSub => 'আজ চাঁদ কীভাবে আপনার মনকে রূপ দিচ্ছে';

  @override
  String get prefsMoodAlerts => 'দৈনিক মেজাজ সতর্কতা';

  @override
  String get prefsMoodAlertsDesc =>
      'সপ্তাহে প্রায় তিন সকালে, যখন চাঁদ আপনার চার্টে সাইন পরিবর্তন করে।';

  @override
  String get callCalling => 'কল করা হচ্ছে...';

  @override
  String get callRinging => 'রিং হচ্ছে...';

  @override
  String get callConnecting => 'সংযোগ করা হচ্ছে...';

  @override
  String get callReconnecting => 'পুনরায় সংযোগ করা হচ্ছে...';

  @override
  String get callEnded => 'কল শেষ';

  @override
  String get callPoorConnection => 'দুর্বল সংযোগ';

  @override
  String get callMute => 'নিঃশব্দ';

  @override
  String get callSpeaker => 'স্পিকার';

  @override
  String get callEnd => 'শেষ';

  @override
  String get callEncrypted => 'এনক্রিপ্ট করা কল';

  @override
  String get callMicTitle => 'মাইক্রোফোন প্রয়োজন';

  @override
  String get callMicBody =>
      'মাইক্রোফোন অ্যাক্সেস করার অনুমতি দিন যাতে জ্যোতিষী আপনাকে শুনতে পারে।';

  @override
  String get callMicBlockedBody =>
      'TalkAcharya-এর জন্য মাইক্রোফোন অ্যাক্সেস বন্ধ করা হয়েছে। সেটিংসে এটি চালু করুন।';

  @override
  String get callOpenSettings => 'সেটিংস খুলুন';

  @override
  String get callTryAgain => 'আবার চেষ্টা করুন';

  @override
  String get callFailedTitle => 'কল শুরু করা যায়নি';

  @override
  String get callEndConfirmTitle => 'এই কল শেষ?';

  @override
  String get callEndConfirmBody =>
      'কল শেষ হওয়ার সাথে সাথে বিলিং বন্ধ হয়ে যায়।';

  @override
  String get callEndConfirmYes => 'কল শেষ করুন';

  @override
  String get callEndConfirmNo => 'কথা বলতে থাকুন';

  @override
  String callWaitingAccept(String name) {
    return '$name গ্রহণ করার জন্য অপেক্ষা করা হচ্ছে...';
  }

  @override
  String callBookTitle(String name) {
    return '$name কল করুন';
  }

  @override
  String get callBookBilling =>
      'ভয়েস কল · একবার সংযুক্ত হলে প্রতি মিনিটে বিল করা হয়';

  @override
  String callBookCta(String price) {
    return 'কল শুরু করুন · $price /মিনিট';
  }

  @override
  String get callCamera => 'Camera';

  @override
  String get callFlipCamera => 'Flip';

  @override
  String get callCameraOff => 'Camera off';

  @override
  String get callVideoPausedWeak => 'Video paused — weak connection';

  @override
  String get callPeerCameraOff => 'Their camera is off';

  @override
  String get callCameraBody =>
      'Allow camera access so the astrologer can see you.';

  @override
  String get callCameraBlockedBody =>
      'Camera access is turned off for TalkAcharya. Turn it on in Settings.';

  @override
  String callVideoBookTitle(String name) {
    return 'Video call $name';
  }

  @override
  String get callVideoBookBilling =>
      'Video call · billed per minute once connected';

  @override
  String get callVideoUnavailable =>
      'This astrologer is not taking video calls right now.';

  @override
  String get callUnavailable => 'এই জ্যোতিষী এখন কল নিচ্ছেন না।';

  @override
  String get liveTabTitle => 'Live';

  @override
  String get liveBadge => 'Live';

  @override
  String get liveNowTitle => 'Live now';

  @override
  String get liveUpcomingTitle => 'Coming up';

  @override
  String get liveWatch => 'Watch';

  @override
  String get liveLeave => 'Leave';

  @override
  String get liveSend => 'Send';

  @override
  String get liveEmptyTitle => 'No live sessions right now';

  @override
  String get liveEmptyBody =>
      'Astrologers going live will show up here to watch and join.';

  @override
  String liveWatchingCount(int count) {
    return '$count watching';
  }

  @override
  String get liveConnecting => 'Joining the stream…';

  @override
  String get liveReconnecting => 'Reconnecting…';

  @override
  String get liveHostCameraOff => 'The astrologer\'s camera is off';

  @override
  String get liveChatHint => 'Say something…';

  @override
  String liveSlowModeHint(int seconds) {
    return 'Slow mode · one message every ${seconds}s';
  }

  @override
  String liveGiftSent(String name, String gift) {
    return '$name sent $gift';
  }

  @override
  String get liveEndedTitle => 'The stream has ended';

  @override
  String get liveEndedBody =>
      'Thanks for watching. Catch the next one from the Live tab.';

  @override
  String liveEndedByHost(String name) {
    return '$name ended the session. Catch the next one from the Live tab.';
  }

  @override
  String get liveRemovedTitle => 'You were removed';

  @override
  String get liveRemovedBody => 'The host removed you from this stream.';

  @override
  String get liveCannotJoinTitle => 'Couldn\'t join';

  @override
  String get liveCannotJoinBody =>
      'The stream may have ended. Try another one from the Live tab.';

  @override
  String get liveBackToList => 'Back to Live';

  @override
  String get giftAction => 'একটি উপহার পাঠান';

  @override
  String giftSheetTitle(String name) {
    return '$name এ একটি উপহার পাঠান৷';
  }

  @override
  String get giftSheetSubtitle =>
      'কৃতজ্ঞতার একটি ছোট চিহ্ন - তারা তাৎক্ষণিকভাবে এটি দেখতে পায়।';

  @override
  String get giftQuantity => 'পরিমাণ';

  @override
  String get giftAddNote => 'একটি নোট যোগ করুন';

  @override
  String get giftNoteHint => 'একটি ছোট বার্তা লিখুন (ঐচ্ছিক)';

  @override
  String get giftChoose => 'একটি উপহার চয়ন করুন';

  @override
  String giftSendCta(String gift, String price) {
    return '$gift · $price পাঠান';
  }

  @override
  String giftWalletBalance(String amount) {
    return 'ব্যালেন্স $amount';
  }

  @override
  String get giftAddMoney => 'টাকা যোগ করুন';

  @override
  String get giftLowBalanceTitle => 'পর্যাপ্ত ভারসাম্য নেই';

  @override
  String get giftLowBalanceBody =>
      'এই উপহারটি পাঠাতে আপনার ওয়ালেটে টাকা যোগ করুন।';

  @override
  String giftSentTitle(String gift, String name) {
    return '$name এ $gift পাঠানো হয়েছে';
  }

  @override
  String get giftSentBody =>
      'তারা এখুনি দেখবে। আপনার দয়ার জন্য আপনাকে ধন্যবাদ!';

  @override
  String get giftSendAnother => 'আরেকটা পাঠাও';

  @override
  String get giftLoadError => 'উপহার লোড করা যায়নি';

  @override
  String get giftThankYouTitle => 'একটি উপহার সঙ্গে ধন্যবাদ বলুন';

  @override
  String giftThankYouBody(String name) {
    return 'অধিবেশন পছন্দ করেন? $name কে কৃতজ্ঞতার একটি ছোট টোকেন পাঠান৷';
  }

  @override
  String get giftThankYouSentTitle => 'আপনার উপহারের জন্য আপনাকে ধন্যবাদ';

  @override
  String get helpTitle => 'সাহায্য এবং সমর্থন';

  @override
  String get helpHeroTitle => 'আমরা কিভাবে সাহায্য করতে পারি?';

  @override
  String get helpHeroBody =>
      'একটি সেশনের সাথে একটি সমস্যা রিপোর্ট করুন, আপনার প্রতিবেদনগুলি ট্র্যাক করুন বা আমাদের টিমের সাথে যোগাযোগ করুন৷';

  @override
  String get helpReportSection => 'একটি সেশনের সাথে একটি সমস্যা রিপোর্ট করুন';

  @override
  String get helpReportEmpty => 'আপনার সম্পূর্ণ সেশন এখানে প্রদর্শিত হবে.';

  @override
  String get helpReportAction => 'রিপোর্ট';

  @override
  String get helpYourReports => 'আপনার রিপোর্ট';

  @override
  String get helpContactSection => 'আমাদের সাথে যোগাযোগ করুন';

  @override
  String get helpWhatsapp => 'হোয়াটসঅ্যাপে চ্যাট করুন';

  @override
  String get helpEmailUs => 'আমাদের ইমেইল করুন';

  @override
  String get helpCentre => 'সাহায্য কেন্দ্র';

  @override
  String get helpFaqSection => 'প্রায়শই জিজ্ঞাসিত প্রশ্ন';

  @override
  String get helpLoadError => 'আপনার সেশনগুলি লোড করা যায়নি৷';

  @override
  String get helpFaqChargesQ => 'আমি কিভাবে একটি পরামর্শ জন্য চার্জ করা হয়?';

  @override
  String get helpFaqChargesA =>
      'আপনি প্রতি মিনিটে অর্থ প্রদান করেন, শুধুমাত্র সেশনটি লাইভ থাকাকালীন। জ্যোতিষী যোগদান করার পরে বিলিং শুরু হয় এবং আপনি যে কেউ এটি শেষ করার মুহুর্ত বন্ধ করে দেন।';

  @override
  String get helpFaqNoResponseQ => 'জ্যোতিষী সাড়া না দিলে কি হবে?';

  @override
  String get helpFaqNoResponseA =>
      'আপনার অনুরোধ গৃহীত না হলে, আপনাকে চার্জ করা হবে না — সেশনের জন্য রাখা যেকোন পরিমাণ আপনার ওয়ালেটে ফেরত যায়।';

  @override
  String get helpFaqRefundQ => 'আমি কি ফেরত পেতে পারি?';

  @override
  String get helpFaqRefundA =>
      'যদি কিছু ভুল হয়ে থাকে - ভুল চার্জ, একটি প্রযুক্তিগত সমস্যা বা একটি অসহায় সেশন - সেই সেশন থেকে রিপোর্ট করুন। আমাদের দল প্রতিটি রিপোর্ট পর্যালোচনা করে এবং আপনার ওয়ালেটে ফেরত দেয় যখন এটি নিশ্চিত হয়।';

  @override
  String get helpFaqBalanceQ =>
      'একটি অধিবেশন চলাকালীন আমার ব্যালেন্স ফুরিয়ে গেছে। এখন কি?';

  @override
  String get helpFaqBalanceA =>
      'আপনার ব্যালেন্স শেষ হয়ে গেলে সেশন স্বয়ংক্রিয়ভাবে শেষ হয়ে যায়। আপনার ওয়ালেট রিচার্জ করুন এবং সেশন সারাংশ থেকে একই জ্যোতিষীর সাথে আবার শুরু করুন।';

  @override
  String get helpFaqPrivacyQ => 'আমার কথোপকথন কি ব্যক্তিগত?';

  @override
  String get helpFaqPrivacyA =>
      'আপনার পরামর্শ আপনার এবং আপনার জ্যোতিষী মধ্যে হয়. আমাদের সহায়তা দল শুধুমাত্র একটি প্রতিবেদনের সমাধান করতে বা প্ল্যাটফর্মটিকে সুরক্ষিত রাখতে একটি সেশন দেখে।';

  @override
  String get helpFaqLanguageQ => 'আমি কিভাবে অ্যাপের ভাষা পরিবর্তন করব?';

  @override
  String get helpFaqLanguageA =>
      'প্রোফাইল → ল্যাঙ্গুয়েজ এ যান এবং আপনি যে ভাষাতে সবচেয়ে বেশি স্বাচ্ছন্দ্য বোধ করেন সেটি বেছে নিন।';

  @override
  String get reportTitle => 'একটি সমস্যা রিপোর্ট করুন';

  @override
  String reportSessionWith(String name) {
    return '$name এর সাথে সেশন';
  }

  @override
  String get reportWhatHappened => 'কি ভুল হয়েছে?';

  @override
  String get reportTypeBilling => 'ভুল অভিযোগ';

  @override
  String get reportTypeBillingHint =>
      'আমার যা হওয়া উচিত ছিল তার চেয়ে বেশি চার্জ করা হয়েছে';

  @override
  String get reportTypeQuality => 'অসহায় সেশন';

  @override
  String get reportTypeQualityHint => 'নির্দেশিকা কি প্রতিশ্রুতি ছিল না';

  @override
  String get reportTypeConduct => 'অনুপযুক্ত আচরণ';

  @override
  String get reportTypeConductHint => 'জ্যোতিষী ছিল অভদ্র বা অপেশাদার';

  @override
  String get reportTypeNoShow => 'জ্যোতিষী সাড়া দেননি';

  @override
  String get reportTypeNoShowHint =>
      'তারা গ্রহণ করেছে কিন্তু সত্যিই যোগদান করেনি';

  @override
  String get reportTypeTechnical => 'প্রযুক্তিগত সমস্যা';

  @override
  String get reportTypeTechnicalHint => 'চ্যাট বা কল ব্যর্থ রাখা';

  @override
  String get reportDescribe => 'আমাদের আরো বলুন';

  @override
  String get reportDescribeHint =>
      'কী ঘটেছে তা শেয়ার করুন — যত বেশি বিশদ, তত দ্রুত আমরা সাহায্য করতে পারি।';

  @override
  String reportMinChars(String count) {
    return 'অন্তত $count অক্ষর';
  }

  @override
  String get reportPrivacyNote =>
      'আপনার রিপোর্ট দেখার জন্য, আমাদের সহায়তা দল এই অধিবেশন পর্যালোচনা করবে।';

  @override
  String get reportSubmit => 'রিপোর্ট জমা দিন';

  @override
  String get reportSubmittedTitle => 'প্রতিবেদন জমা দেওয়া হয়েছে';

  @override
  String get reportSubmittedBody =>
      'আমরা এটি দেখব এবং আপডেট হওয়ার সাথে সাথে আপনাকে অবহিত করব৷';

  @override
  String get reportAlreadyTitle => 'আপনি ইতিমধ্যে এই অধিবেশন রিপোর্ট করেছেন';

  @override
  String get reportAlreadyBody =>
      'আমাদের দল এটা খতিয়ে দেখছে। একটি আপডেট হলে আপনাকে জানানো হবে।';

  @override
  String get reportViewStatus => 'প্রতিবেদনের অবস্থা দেখুন';

  @override
  String get disputeTitle => 'রিপোর্ট বিবরণ';

  @override
  String get disputeStatusOpen => 'গৃহীত';

  @override
  String get disputeStatusInvestigating => 'পর্যালোচনা অধীনে';

  @override
  String get disputeStatusResolved => 'সমাধান করা হয়েছে';

  @override
  String get disputeStatusRejected => 'বন্ধ';

  @override
  String get disputeHeadlineOpen => 'আমরা আপনার রিপোর্ট পেয়েছি';

  @override
  String get disputeHeadlineInvestigating =>
      'আমাদের দল আপনার রিপোর্ট পর্যালোচনা করছে';

  @override
  String get disputeHeadlineResolved => 'আপনার রিপোর্ট সমাধান করা হয়েছে';

  @override
  String get disputeHeadlineRejected => 'আমরা আপনার প্রতিবেদন পর্যালোচনা করেছি';

  @override
  String get disputeOpenBody =>
      'একটি আপডেট পাওয়া মাত্রই আমরা আপনাকে অবহিত করব৷';

  @override
  String disputeReportedOn(String date) {
    return '$date এ রিপোর্ট করা হয়েছে';
  }

  @override
  String disputeRefundedTitle(String amount) {
    return '$amount আপনার ওয়ালেটে ফেরত দেওয়া হয়েছে';
  }

  @override
  String get disputeOpenWallet => 'ওয়ালেট';

  @override
  String get disputeOutcome => 'ফলাফল';

  @override
  String get disputeOutcomeNoRefund =>
      'এই সেশনের জন্য কোনো ফেরত জারি করা হয়নি।';

  @override
  String get disputeTimeline => 'অগ্রগতি';

  @override
  String get disputeStepRaised => 'প্রতিবেদন জমা দেওয়া হয়েছে';

  @override
  String get disputeStepReviewing => 'পর্যালোচনা অধীনে';

  @override
  String get disputeStepResolved => 'সমাধান করা হয়েছে';

  @override
  String get disputeStepRejected => 'বন্ধ';

  @override
  String get disputeYourReport => 'আপনার রিপোর্ট';

  @override
  String get roomReportProblem => 'একটি সমস্যা রিপোর্ট করুন';

  @override
  String get articlesTitle => 'পড়ুন এবং শিখুন';

  @override
  String get articlesRailSubtitle => 'গাইড, প্রতিকার এবং উত্সব';

  @override
  String get articlesAll => 'সব';

  @override
  String get articlesEmptyTitle => 'এখানে এখনো পড়ার কিছু নেই';

  @override
  String get articlesEmptyBody =>
      'নতুন নিবন্ধগুলি তাদের পথে রয়েছে — শীঘ্রই আবার দেখুন।';

  @override
  String get articleCatAstrology => 'জ্যোতিষশাস্ত্র';

  @override
  String get articleCatHoroscope => 'রাশিফল';

  @override
  String get articleCatFestivals => 'উৎসব';

  @override
  String get articleCatRemedies => 'প্রতিকার';

  @override
  String get articleCatGuides => 'গাইড';

  @override
  String get articleCatNews => 'খবর';

  @override
  String articleMinRead(int minutes) {
    return '$minutes মিনিট পড়া';
  }

  @override
  String get articleShare => 'শেয়ার করুন';

  @override
  String get articleMoreToRead => 'আরো পড়তে';

  @override
  String get articleAskTitle => 'আপনার নিজের চার্টের জন্য নির্দেশিকা চান?';

  @override
  String get articleAskBody =>
      'কয়েক মিনিটের মধ্যে একজন যাচাইকৃত জ্যোতিষীর সাথে কথা বলুন।';

  @override
  String get articleAskCta => 'এখন জিজ্ঞাসা করুন';

  @override
  String get panchangTitle => 'পঞ্চং';

  @override
  String get panchangToday => 'আজ';

  @override
  String get panchangPickDate => 'একটি তারিখ চয়ন করুন';

  @override
  String panchangMoonIn(String sign) {
    return '$sign এ চাঁদ';
  }

  @override
  String panchangTill(String time) {
    return '$time পর্যন্ত';
  }

  @override
  String get panchangRightNow => 'এখনই';

  @override
  String panchangNowChoghadiya(String name, String time) {
    return '$name চোঘদিয়া $time পর্যন্ত';
  }

  @override
  String panchangRahuNow(String time) {
    return 'রাহু কাল $time পর্যন্ত চালু আছে — নতুন শুরুতে অপেক্ষা করুন।';
  }

  @override
  String get panchangLimbs => 'আজকের পঞ্চাং';

  @override
  String get panchangAuspicious => 'শুভ সময়';

  @override
  String get panchangInauspicious => 'নতুন কাজ শুরু করা থেকে বিরত থাকুন';

  @override
  String get panchangBrahma => 'ব্রাহ্ম মুহুর্ত';

  @override
  String get panchangAbhijit => 'অভিজিৎ মুহুর্তা';

  @override
  String get panchangNoAbhijit => 'বুধবার অভিজিৎ মুহুর্তা পালন করা হয় না।';

  @override
  String get panchangRahuKaal => 'রাহু কাল';

  @override
  String get panchangYamaganda => 'ইয়ামাগান্ডা';

  @override
  String get panchangGulika => 'গুলিকা কাল';

  @override
  String get panchangChoghadiya => 'চোগাদিয়া';

  @override
  String get panchangDay => 'দিন';

  @override
  String get panchangNight => 'রাত্রি';

  @override
  String get panchangNotes => 'আমাদের জ্যোতিষীদের কাছ থেকে নোট';

  @override
  String get panchangPersonalTitle => 'আপনার চার্টের জন্য সময়';

  @override
  String get panchangPersonalBody =>
      'আপনার কুন্ডলি থেকে কাজ করা ঘন্টাগুলি দেখুন যা আপনার জন্য সবচেয়ে উপযুক্ত।';

  @override
  String panchangFooter(String place, String timezone) {
    return 'স্থানীয় সূর্যোদয় থেকে $place · $timezone · গণনা করা হয়েছে';
  }

  @override
  String get panchangChoosePlaceTitle => 'আপনার শহর চয়ন করুন';

  @override
  String get panchangChoosePlaceBody =>
      'পঞ্চং সময় নির্ভর করে আপনি কোথায় আছেন - আপনি যে শহরটির জন্য চান সেটি বেছে নিন।';

  @override
  String get panchangChoosePlaceCta => 'শহর বেছে নিন';

  @override
  String panchangUsePlace(String place) {
    return '$place ব্যবহার করুন';
  }

  @override
  String get panchangCity => 'শহর';

  @override
  String get panchangCityHint => 'একটি শহর বা শহর অনুসন্ধান করুন';

  @override
  String get kPdfTitle => 'কুন্ডলি রিপোর্ট (পিডিএফ)';

  @override
  String get kPdfFull => 'সম্পূর্ণ প্রতিবেদন';

  @override
  String get kPdfFullSub => 'চার্ট, গ্রহ, অবকাহদ, দশা সময়রেখা, যোগ এবং দোষ';

  @override
  String get kPdfBasic => 'এক পৃষ্ঠার সারাংশ';

  @override
  String get kPdfBasicSub => 'গ্রহ অবস্থান সহ Lagna এবং Navamsa চার্ট';

  @override
  String get kPdfChartStyle => 'চার্ট শৈলী';

  @override
  String get kPdfEastIndian => 'পূর্ব ভারতীয়';

  @override
  String get kPdfShareCta => 'ডাউনলোড করুন এবং শেয়ার করুন';

  @override
  String get kPdfPreparing => 'আপনার পিডিএফ প্রস্তুত করা হচ্ছে...';

  @override
  String get kPdfNote =>
      'পিডিএফ ইংরেজিতে আছে। এটি আপনার ফোনে সেভ করুন বা WhatsApp এ পাঠান।';

  @override
  String get kPdfUnavailable =>
      'PDF রিপোর্ট এই মুহূর্তে উপলব্ধ নেই. পরে আবার চেষ্টা করুন.';

  @override
  String get kOvEyebrow => 'জনম কুণ্ডলী';

  @override
  String kOvMoonChip(String sign) {
    return 'চাঁদ · $sign';
  }

  @override
  String get kOvTapHouseHint =>
      'আপনার সম্পর্কে কী বলে তা পড়তে যে কোনও বাড়িতে আলতো চাপুন৷';

  @override
  String get kOvBirthDetailsSub => 'অবকাহদা, জন্মে পঞ্চাং এবং ড';

  @override
  String get kOvGroupCharts => 'চার্ট এবং গ্রহ';

  @override
  String get kOvGroupTiming => 'সময় এবং সময়কাল';

  @override
  String get kOvGroupGuidance => 'নির্দেশনা ও প্রতিকার';

  @override
  String get kOvLoadError => 'আমরা এই কুন্ডলী খুলতে পারিনি';

  @override
  String get kKitAskTitle => 'আপনার চার্ট সম্পর্কে একটি প্রশ্ন আছে?';

  @override
  String get kKitAskBody =>
      'একজন যাচাইকৃত জ্যোতিষী এটি আপনার সাথে পড়তে পারেন — ব্যক্তিগতভাবে, মিনিটের মধ্যে।';

  @override
  String get kFcExploreMore => 'গভীরে যান';

  @override
  String get kFcAllHousesSub =>
      'আপনার লগনা চার্টের বারোটি ঘর, প্রতিটিতে একটি করে ট্যাপ করুন';

  @override
  String get kFcAllChartsSub => 'D1 থেকে D60 পর্যন্ত প্রতিটি বিভাগীয় চার্ট';

  @override
  String get kPlanetsHeroSub =>
      'নয়টি গ্রহ, কোথায় বসে তারা কত শক্তিশালী। এটি পড়তে যেকোনো গ্রহে ট্যাপ করুন।';

  @override
  String kPlanetsStrongCount(int count) {
    return '$count শক্তিশালী';
  }

  @override
  String kPlanetsRetroCount(int count) {
    return '$count বিপরীতমুখী';
  }

  @override
  String get kPlanetRetrograde => 'বিপরীতমুখী';

  @override
  String get kPlanetCombust => 'দহন';

  @override
  String get kDashaTimelineTitle => 'আপনার জীবন টাইমলাইন';

  @override
  String kDashaProgressPct(String pct) {
    return '$pct % সম্পূর্ণ';
  }

  @override
  String get kBhavaHeroSub =>
      'বারোটি ঘর, জীবনের বারোটি ক্ষেত্র — কী প্রতিটিকে সমর্থন করে এবং কী চাপ দেয়।';

  @override
  String kBhavaSupportedCount(int count) {
    return '$count সমর্থিত';
  }

  @override
  String kBhavaStrainedCount(int count) {
    return '$count স্ট্রেনের অধীনে';
  }

  @override
  String get kYdDoshaHeroSub =>
      'প্রথাগত দোষগুলি আপনার চার্টে চেক করা হয়েছে, প্রতিটি আসলে কতটা শক্তিশালী।';

  @override
  String get kYdYogaHeroSub =>
      'গ্রহের সংমিশ্রণ যা আপনার উপহার এবং সুযোগকে আকার দেয়।';

  @override
  String kYdDoshaCount(int count) {
    return '$count বর্তমান';
  }

  @override
  String kYdYogaCount(int count) {
    return '$count যোগাসন';
  }

  @override
  String get kYdClear => 'পরিষ্কার';

  @override
  String get kYdRemediesSub =>
      'মৃদু, ঐতিহ্যগত প্রতিকার আপনার চার্টের জন্য উপযুক্ত';

  @override
  String get kSsLifetimeTitle => 'আপনার জীবনকাল জুড়ে';

  @override
  String get kSsNotRunning => 'এখন চলছে না';

  @override
  String kTrHeroSub(String sign) {
    return 'আজকের গ্রহগুলি আপনার চাঁদ থেকে $sign এ পড়েছে৷';
  }

  @override
  String kTrJupiterChip(String house) {
    return 'চাঁদ থেকে বৃহস্পতি $house';
  }

  @override
  String get kTrSadeSatiCalendarSub =>
      'শনির চক্রের প্রতিটি পর্যায়, অতীত এবং আসন্ন';

  @override
  String get kSsEyebrow => 'শনির চক্র';

  @override
  String get kAdvHeroSub => 'টেকনিক্যাল লেয়ার জ্যোতিষীদের কাছ থেকে পড়ে';

  @override
  String kAdvReportCount(int count) {
    return '$count প্রতিবেদন';
  }

  @override
  String get kAdvPdfChip => 'পিডিএফ ডাউনলোড';

  @override
  String get kAdvReportsTitle => 'প্রযুক্তিগত প্রতিবেদন';

  @override
  String get kAdvAvHousesTitle => 'বাড়ির দ্বারা পয়েন্ট';

  @override
  String kAdvSarvaTotal(int total) {
    return 'সব মিলিয়ে $total পয়েন্ট';
  }

  @override
  String get kInHeroSub =>
      'আপনার জন্ম তালিকা থেকে আঁকা একটি চরিত্র এবং জীবন স্কেচ';

  @override
  String kInSupportiveCount(int count) {
    return '$count সহায়ক';
  }

  @override
  String kInChallengingCount(int count) {
    return '$count যত্ন প্রয়োজন';
  }

  @override
  String get kInGlanceTitle => 'এক নজরে';

  @override
  String get kInAreasTitle => 'এলাকা অনুযায়ী এলাকা';

  @override
  String get kLkHeroSub =>
      'আপনার চার্টে উত্তরাধিকারসূত্রে প্রাপ্ত ঋণ এবং তাদের সহজ ঘরোয়া প্রতিকার';

  @override
  String kLkDebtCount(int count) {
    return '$count সক্রিয় ঋণ';
  }

  @override
  String kLkWeakCount(int count) {
    return '$count দুর্বল গ্রহ';
  }

  @override
  String get kMuHeroSub => 'আজকের ভালো ঘন্টা, আপনার চার্টের জন্য পড়ুন';

  @override
  String get kMuTimingsTitle => 'আজকের সময়';

  @override
  String get kMuTabDay => 'দিন';

  @override
  String get kMuTabNight => 'রাত্রি';

  @override
  String kMuHoraOf(String planet) {
    return '$planet হোরা';
  }

  @override
  String get kMuAbhijit => 'অভিজিৎ মুহুর্তা';

  @override
  String get kNumHeroSub => 'আপনার মূল সংখ্যা এবং লো শু জন্ম গ্রিড';

  @override
  String get kNumYourNumbers => 'আপনার নম্বর';

  @override
  String get kNumMissing => 'অনুপস্থিত সংখ্যা';

  @override
  String get kNumRepeated => 'বারবার সংখ্যা';

  @override
  String get kRmHeroSub =>
      'মৃদু, ঐতিহ্যগত অনুশীলনগুলি আপনার চার্টের সাথে মিলেছে';

  @override
  String kRmCount(int count) {
    return '$count প্রতিকার';
  }

  @override
  String get kRmGatedChip => 'কিছু একজন জ্যোতিষী প্রয়োজন';

  @override
  String get kRmCaution => 'মনে রাখবেন';

  @override
  String get kUpHeroSub => 'প্রতিটি গ্রহের জন্য রং, দিন, মন্ত্র এবং দাতব্য';

  @override
  String kUpStrengthenCount(int count) {
    return '$count শক্তিশালী করতে';
  }

  @override
  String kUpPacifyCount(int count) {
    return '$count শান্ত করতে';
  }

  @override
  String get kUpGateTitle => 'আগে একজন জ্যোতিষীর সাথে কনফার্ম করুন';

  @override
  String get kUpPlanetsTitle => 'গ্রহ দ্বারা গ্রহ';

  @override
  String kVpHeadline(String year) {
    return 'আপনার বছর $year';
  }

  @override
  String get kVpMarkersTitle => 'বছরের মূল চিহ্নিতকারী';

  @override
  String get kVpTajikaTitle => 'তাজিকা দিক';

  @override
  String get kVpIthasala => 'ইথাশালা · প্রয়োগ করা';

  @override
  String get kVpIshrafa => 'ইশরাফা · আলাদা করা';

  @override
  String get followFollow => 'অনুসরণ করুন';

  @override
  String get followFollowing => 'অনুসরণ করছে';

  @override
  String get followNotifying => 'অবহিত করা হচ্ছে';

  @override
  String get followNotifyingWhenOnline => 'অনলাইন হলে আমরা আপনাকে অবহিত করব';

  @override
  String followedToast(String name) {
    return '$name অনুসরণ করছে — তারা অনলাইনে বা লাইভ হলে আমরা আপনাকে জানাব';
  }

  @override
  String unfollowedToast(String name) {
    return '$name অনুসরণ করা বন্ধ';
  }

  @override
  String get followFailed => 'অনুসরণ আপডেট করা যায়নি. আবার চেষ্টা করুন.';

  @override
  String followPromptTitle(String name) {
    return '$name অনুসরণ করবেন?';
  }

  @override
  String get followPromptBody =>
      'তারা অনলাইনে থাকলে বা লাইভ হলে একটি বিজ্ঞপ্তি পান।';

  @override
  String get followPromptDoneTitle => 'আপনি অনুসরণ করছেন';

  @override
  String followPromptDoneBody(String name) {
    return '$name অনলাইনে বা লাইভ হলে আমরা আপনাকে জানাব৷';
  }

  @override
  String get followingTitle => 'অনুসরণ করছে';

  @override
  String get followingHint =>
      'এই জ্যোতিষীরা অনলাইনে এলে বা লাইভ হলে আপনি একটি বিজ্ঞপ্তি পাবেন। আনফলো করতে হার্টে ট্যাপ করুন।';

  @override
  String get followingEmptyTitle => 'এখনও কাউকে অনুসরণ করছি না';

  @override
  String get followingEmptyBody =>
      'জ্যোতিষীদের অনুসরণ করুন আপনি জানতে চান তারা কখন অনলাইনে থাকে বা লাইভ থাকে।';

  @override
  String get followingExplore => 'জ্যোতিষীদের সন্ধান করুন';

  @override
  String get followingLoadError =>
      'আপনার অনুসরণ করা জ্যোতিষীদের লোড করা যায়নি।';

  @override
  String get followingFilter => 'অনুসরণ করছে';

  @override
  String get followingFilterEmpty =>
      'তাদের অনুসরণ করতে একজন জ্যোতিষীর হার্টে ট্যাপ করুন — তারা এখানে দেখাবে।';

  @override
  String get astroStatFollowers => 'অনুসারী';

  @override
  String get prefsFollowAlerts => 'আপনি অনুসরণ করেন জ্যোতিষী';

  @override
  String get prefsFollowAlertsDesc => 'যখন তারা অনলাইনে আসে বা লাইভে যায়';

  @override
  String get storeTitle => 'প্রতিকারের দোকান';

  @override
  String get storeHeroSubtitle =>
      'খাঁটি রুদ্রাক্ষ, রত্নপাথর, যন্ত্র এবং পূজা — জ্যোতিষীদের দ্বারা পরিচালিত';

  @override
  String get storeSearchHint => 'রুদ্রাক্ষ, রত্নপাথর, পূজা অনুসন্ধান করুন...';

  @override
  String get storeVerdictToast =>
      'একজন জ্যোতিষী আপনার পণ্য সম্পর্কে পরামর্শ শেয়ার করেছেন';

  @override
  String get storeView => 'দেখুন';

  @override
  String get storeUnavailable => 'অনুপলব্ধ';

  @override
  String storePriceFrom(String price) {
    return '$price থেকে';
  }

  @override
  String storeOff(int percent) {
    return '$percent % ছাড়';
  }

  @override
  String get storeBadgePooja => 'পুজো';

  @override
  String get storeBadgeAskAstrologer => 'জ্যোতিষীকে জিজ্ঞাসা করুন';

  @override
  String get storeCartTitle => 'কার্ট';

  @override
  String get storeTrustCertified => 'ল্যাব প্রত্যয়িত';

  @override
  String get storeTrustGuided => 'নির্দেশিত জ্যোতিষী';

  @override
  String get storeTrustSecure => 'নিরাপদ পেমেন্ট';

  @override
  String get storeCategories => 'বিভাগ অনুসারে কেনাকাটা করুন';

  @override
  String get storeFeatured => 'হ্যান্ডপিকড প্রতিকার';

  @override
  String get storeFeaturedSub => 'আমাদের জ্যোতিষীদের দ্বারা নির্বাচিত';

  @override
  String get storeCollections => 'প্রতিকার সংগ্রহ';

  @override
  String get storePoojas => 'একটি পুজো বুক করুন';

  @override
  String get storePoojasSub => 'পবিত্র মন্দিরে তোমার নামে অনুষ্ঠান করা হয়';

  @override
  String get storeConsultBannerTitle => 'আপনার জন্য উপযুক্ত কি নিশ্চিত না?';

  @override
  String get storeConsultBannerBody =>
      'আপনি কেনার আগে একজন জ্যোতিষীকে ভিডিও কল করুন — তারা আপনার চার্ট পরীক্ষা করে সঠিক প্রতিকারের পরামর্শ দেয়।';

  @override
  String get storeConsultBannerCta => 'একজন জ্যোতিষীর সাথে কথা বলুন';

  @override
  String get storeMyAdvice => 'আপনার জ্যোতিষীদের কাছ থেকে পরামর্শ';

  @override
  String get storeDisclaimerFooter =>
      'প্রতিকার হল ঐতিহ্যগত অভ্যাস। ফলাফল নিশ্চিত নয় এবং তারা চিকিৎসা, আইনি বা আর্থিক পরামর্শ প্রতিস্থাপন করে না।';

  @override
  String get storeEmptyTitle => 'দোকান তৈরি হচ্ছে';

  @override
  String get storeEmptyBody => 'প্রতিকার এবং পূজা শীঘ্রই এখানে প্রদর্শিত হবে.';

  @override
  String get storeLoadError => 'দোকান লোড করা যায়নি';

  @override
  String get storeMyOrders => 'আমার আদেশ';

  @override
  String get storeVerdictSuitable => 'উপযুক্ত - এগিয়ে যান';

  @override
  String get storeVerdictNotSuitable => 'আপনার জন্য উপযুক্ত নয়';

  @override
  String get storeVerdictAlternative => 'অন্য কিছু সাজেস্ট করে';

  @override
  String get storeConsultCancelled => 'কল হয়নি';

  @override
  String get storeConsultExpired => 'কোন পরামর্শ শেয়ার করা হয়নি';

  @override
  String get storeConsultCallLive => 'আপনার কল চলছে';

  @override
  String get storeConsultAwaiting => 'জ্যোতিষীর পরামর্শের জন্য অপেক্ষা করছি';

  @override
  String storeConsultWith(String name) {
    return '$name এর সাথে';
  }

  @override
  String storeVerdictFrom(String name) {
    return '$name এর পরামর্শ';
  }

  @override
  String get storeBuyRecommended => 'প্রস্তাবিত বিকল্প কিনুন';

  @override
  String get storeSuggestedInstead => 'পরিবর্তে প্রস্তাবিত';

  @override
  String get storeConsultPromptTitle => 'নিশ্চিত না এটা আপনার জন্য উপযুক্ত?';

  @override
  String get storeConsultPromptBody =>
      'একজন জ্যোতিষীকে ভিডিও কল করুন - আপনি কেনার আগে তারা আপনার চার্ট পরীক্ষা করবে।';

  @override
  String get storeConsultRequiredTitle =>
      'প্রথমে একজন জ্যোতিষীর সাথে পরামর্শ করুন';

  @override
  String get storeConsultRequiredBody =>
      'একজন জ্যোতিষী নিশ্চিত করার পরেই এই প্রতিকারটি বিক্রি করা হয় এটি আপনার চার্টের জন্য উপযুক্ত।';

  @override
  String get storeNoResults => 'কিছুই মেলে না';

  @override
  String get storeNoResultsBody =>
      'অন্য শব্দ চেষ্টা করুন বা কিছু ফিল্টার সাফ করুন.';

  @override
  String get storeClearFilters => 'ফিল্টার সাফ করুন';

  @override
  String storeResultCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count আইটেম',
      one: '1টি আইটেম',
    );
    return '$_temp0';
  }

  @override
  String get storeFilters => 'ফিল্টার';

  @override
  String get storeNoFilters => 'এই নির্বাচনের জন্য এখনো কোনো ফিল্টার নেই।';

  @override
  String get storeSortBy => 'অনুসারে সাজান';

  @override
  String get storeSortRecommended => 'প্রস্তাবিত';

  @override
  String get storeSortPopular => 'সবচেয়ে জনপ্রিয়';

  @override
  String get storeSortNew => 'সবথেকে নতুন';

  @override
  String get storeSortRating => 'শীর্ষ রেট';

  @override
  String get storeKindProducts => 'পণ্য';

  @override
  String get storeKindPoojas => 'পুজো';

  @override
  String get storeKindDigital => 'রিপোর্ট';

  @override
  String storeRemedyFor(String key) {
    return 'প্রতিকার: $key';
  }

  @override
  String get storeChoosePackage => 'একটি প্যাকেজ চয়ন করুন';

  @override
  String get storeChooseOption => 'একটি বিকল্প চয়ন করুন';

  @override
  String get storePickDate => 'একটি তারিখ চয়ন করুন';

  @override
  String get storeSankalpDetails => 'সংকল্প বিস্তারিত';

  @override
  String get storeYourDetails => 'আপনার বিবরণ';

  @override
  String get storeSankalpHint =>
      'পূজার সময় পুরোহিত এই নামে সংকল্প গ্রহণ করেন।';

  @override
  String get storeCertificate => 'সত্যতা সার্টিফিকেট';

  @override
  String storeCertificateNo(String number) {
    return 'সার্টিফিকেট নং।  $number';
  }

  @override
  String get storeVerify => 'যাচাই করুন';

  @override
  String get storeHighlights => 'হাইলাইট';

  @override
  String get storeAbout => 'সম্পর্কে';

  @override
  String get storeSignificance => 'ঐতিহ্যগত তাৎপর্য';

  @override
  String get storeHowToUse => 'কিভাবে পরবেন/ব্যবহার করবেন';

  @override
  String get storeHowItWorks => 'এটা কিভাবে কাজ করে';

  @override
  String get storeReadMore => 'আরও পড়ুন';

  @override
  String get storeReadLess => 'কম দেখান';

  @override
  String get storeRecommendedForYou => 'আপনার জন্য প্রস্তাবিত';

  @override
  String get storeTaxInclusive => 'সমস্ত ট্যাক্স সহ';

  @override
  String get storeOutOfStock => 'স্টক শেষ';

  @override
  String storeOnlyLeft(int count) {
    return 'শুধুমাত্র $count বাকি';
  }

  @override
  String get storeAskAnother => 'অন্য একজন জ্যোতিষীকে জিজ্ঞাসা করুন';

  @override
  String get storeNoDates => 'শীঘ্রই তারিখ ঘোষণা করা হবে.';

  @override
  String get storeOpenForBooking => 'বুকিং এর জন্য খোলা';

  @override
  String storeSeatsLeft(int count) {
    return '$count স্লট বাকি';
  }

  @override
  String storeReturnableDays(int days) {
    return 'প্রসবের $days দিনের মধ্যে সহজে ফেরত';
  }

  @override
  String get storeNotReturnable => 'একবার বিতরণ করা হলে ফেরত দেওয়া যায় না';

  @override
  String get storeCancellable => 'এটি পাঠানোর আগে বিনামূল্যে বাতিল করুন';

  @override
  String get storeNotCancellable => 'একবার অর্ডার দিলে বাতিল করা যাবে না';

  @override
  String storeMadeToOrder(int days) {
    return 'অর্ডার করার জন্য তৈরি · প্রায় $days দিনের মধ্যে প্রস্তুত';
  }

  @override
  String get storeShipsIndia => 'ভারত জুড়ে বীমাকৃত শিপিং';

  @override
  String get storeVideoProof => 'পুজোর ভিডিও আপনাদের সাথে শেয়ার করলাম';

  @override
  String get storeInstantDownload =>
      'অর্থ প্রদানের পরে তাত্ক্ষণিক ডাউনলোড করুন';

  @override
  String storeSoldBy(String name) {
    return '$name দ্বারা বিক্রি';
  }

  @override
  String get storeSellerInfo => 'বিক্রেতা এবং অভিযোগ বিবরণ';

  @override
  String storeCountryOfOrigin(String country) {
    return 'উৎপত্তি দেশ: $country';
  }

  @override
  String get storeGrievanceOfficer => 'অভিযোগ কর্মকর্তা';

  @override
  String storeFieldRequired(String label) {
    return '$label প্রয়োজন';
  }

  @override
  String storeFieldParticipants(String label, int count) {
    return '$count $label লিখুন';
  }

  @override
  String get storePickDateError => 'পুজোর জন্য একটি তারিখ বেছে নিন';

  @override
  String get storeAddedToCart => 'কার্টে যোগ করা হয়েছে';

  @override
  String get storeViewCart => 'কার্ট দেখুন';

  @override
  String get storeFixDetails => 'হাইলাইট বিবরণ চেক করুন';

  @override
  String get storeAddToCart => 'কার্টে যোগ করুন';

  @override
  String get storeBuyNow => 'এখন কিনুন';

  @override
  String get storeBookPooja => 'পুজোর বই';

  @override
  String get storeConsultFirst => 'প্রথমে পরামর্শ করুন';

  @override
  String storePersonN(int n) {
    return 'ব্যক্তি $n';
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

  @override
  String get shareTitle => 'Share with your astrologer';

  @override
  String get shareSubtitle =>
      'They can open the kundali of anything you share.';

  @override
  String get shareTabProfiles => 'Birth details';

  @override
  String get shareTabMatches => 'Kundali matches';

  @override
  String get shareAction => 'Share';

  @override
  String get shareShared => 'Shared';

  @override
  String shareDone(String name) {
    return 'Shared with $name';
  }

  @override
  String get shareFailed => 'Couldn\'t share. Please try again.';

  @override
  String get shareNoProfiles => 'No birth details saved yet';

  @override
  String get shareAddProfile => 'Add birth details';

  @override
  String get shareNoMatches => 'No kundali matches yet';

  @override
  String get shareWithAstrologer => 'Share with astrologer';

  @override
  String get shareConsultAbout => 'Consult an astrologer';

  @override
  String get sharePickConsultation => 'Choose a consultation';

  @override
  String shareMatchPoints(String points, String max) {
    return '$points of $max points';
  }

  @override
  String get shareTimeUnknown => 'Birth time not known';

  @override
  String get shareSharedWithAstrologer => 'Shared with your astrologer';

  @override
  String sessionLiveBanner(String name) {
    return 'Live consultation with $name';
  }

  @override
  String get sessionReturn => 'Return';

  @override
  String get callLeaveTitle => 'Leave the call?';

  @override
  String get callLeaveBody => 'The call ends if you leave this screen.';

  @override
  String get callLeaveStay => 'Stay on the call';

  @override
  String get callLeaveEnd => 'End call';

  @override
  String get liveSendPhoto => 'Send a photo';

  @override
  String get livePhotoFailed => 'Couldn\'t send the photo';

  @override
  String get livePhotoLabel => 'Photo';

  @override
  String get errForbidden => 'You don\'t have access to this.';

  @override
  String get errNotFound =>
      'We couldn\'t find this — it may have been removed.';

  @override
  String get errServer =>
      'Our server ran into a problem. Please try again shortly.';

  @override
  String walletHeldBreakdown(Object total, Object held) {
    return 'Balance $total · $held on hold';
  }

  @override
  String get walletHeldExplainerTitle => 'Why is some money on hold?';

  @override
  String get walletHeldExplainerBody =>
      'While a consultation is running we reserve a few minutes of balance so the session can\'t stop mid-sentence. Whatever isn\'t used comes back the moment the session ends.';

  @override
  String get bookLowBalanceTitle => 'Add money to start';

  @override
  String bookLowBalanceBody(Object required, Object available) {
    return 'This consultation needs at least $required to begin. You have $available to spend right now.';
  }

  @override
  String bookLowBalanceHeld(Object held) {
    return '$held of your balance is reserved for a session that is still running.';
  }

  @override
  String get commonNotNow => 'Not now';

  @override
  String get callMinimize => 'Minimize';

  @override
  String get callTapToReturn => 'Tap to return to the call';

  @override
  String get callWaiting => 'Waiting…';

  @override
  String get profileSounds => 'Sounds';

  @override
  String get profileSoundsDesc => 'Ringtone, call and chat tones';

  @override
  String get profileSoundVibration => 'Sound & vibration';

  @override
  String get profileSoundVibrationSub => 'Ringtone, tones and vibration';

  @override
  String roomEndedSummaryLine(Object minutes, Object currency, Object amount) {
    return '$minutes min · $currency $amount';
  }

  @override
  String get roomViewSummary => 'Summary';

  @override
  String roomYouRated(Object rating) {
    return 'You rated this session $rating/5';
  }
}
