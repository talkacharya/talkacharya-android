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
  String get astroExpertiseTitle => 'Expertise';

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
  String get profileOrders => 'Orders';

  @override
  String profileOrdersUnread(int count) {
    return '$count new';
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
