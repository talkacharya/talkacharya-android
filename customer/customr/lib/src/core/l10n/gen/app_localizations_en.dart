// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'TalkAcharya';

  @override
  String get commonOk => 'OK';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonDone => 'Done';

  @override
  String get commonNext => 'Next';

  @override
  String get commonBack => 'Back';

  @override
  String get commonRetry => 'Retry';

  @override
  String get commonSave => 'Save';

  @override
  String get commonEdit => 'Edit';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonClose => 'Close';

  @override
  String get commonContinue => 'Continue';

  @override
  String get commonConfirm => 'Confirm';

  @override
  String get commonSeeAll => 'See all';

  @override
  String get commonViewAll => 'View all';

  @override
  String get commonShare => 'Share';

  @override
  String get commonCopy => 'Copy';

  @override
  String get commonCopied => 'Copied';

  @override
  String get commonApply => 'Apply';

  @override
  String get commonSearch => 'Search';

  @override
  String get commonYes => 'Yes';

  @override
  String get commonNo => 'No';

  @override
  String get commonLoading => 'Loading…';

  @override
  String get commonSomethingWentWrong => 'Something went wrong';

  @override
  String get commonCheckConnection =>
      'Check your internet connection and try again';

  @override
  String get commonComingSoon => 'Coming soon';

  @override
  String get commonToday => 'Today';

  @override
  String get commonYesterday => 'Yesterday';

  @override
  String commonMinutesShort(int count) {
    return '$count min';
  }

  @override
  String get commonOffline => 'You are offline';

  @override
  String get navHome => 'Home';

  @override
  String get navAstrologers => 'Astrologers';

  @override
  String get navLive => 'Live';

  @override
  String get navWallet => 'Wallet';

  @override
  String get navProfile => 'Profile';

  @override
  String get authWelcomeTitle => 'Talk to trusted astrologers';

  @override
  String get authWelcomeSubtitle =>
      'Chat or call for guidance on love, career, money and more';

  @override
  String get authPhoneTitle => 'Enter your mobile number';

  @override
  String get authPhoneSubtitle =>
      'Enter your mobile number and we\'ll send you a one-time code.';

  @override
  String authOtpSubtitle(String phone) {
    return 'We sent a 6-digit code to $phone.';
  }

  @override
  String authTestModeCode(String code) {
    return 'Test mode — your code is $code';
  }

  @override
  String get authPhoneHint => 'Mobile number';

  @override
  String get authPhoneHelper => 'We will send a one-time code by SMS';

  @override
  String get authGetOtp => 'Get OTP';

  @override
  String get authOtpTitle => 'Enter the 6-digit code';

  @override
  String authOtpSentTo(String phone) {
    return 'Sent to $phone';
  }

  @override
  String get authOtpResend => 'Resend code';

  @override
  String authOtpResendIn(int seconds) {
    return 'Resend in ${seconds}s';
  }

  @override
  String get authVerify => 'Verify';

  @override
  String get authChangeNumber => 'Change number';

  @override
  String get authInvalidPhone => 'Enter a valid mobile number';

  @override
  String get authInvalidOtp => 'Enter the 6-digit code';

  @override
  String get authWrongApp => 'This number is registered for the astrologer app';

  @override
  String authDevCode(String code) {
    return 'Dev code: $code';
  }

  @override
  String get authTermsNotice =>
      'By continuing you agree to our Terms and Privacy Policy';

  @override
  String get authLogout => 'Log out';

  @override
  String get authLogoutConfirm =>
      'Log out of TalkAcharya? You will need to sign in again.';

  @override
  String homeGreeting(String name) {
    return 'Namaste, $name';
  }

  @override
  String get homeGuidanceTagline => 'Guidance, whenever you need it';

  @override
  String get homeGreetingFallbackName => 'there';

  @override
  String get walletAddShort => 'Add';

  @override
  String get homeChatNow => 'Chat now';

  @override
  String get homeCallNow => 'Call now';

  @override
  String homeFromPerMin(String price) {
    return 'from $price/min';
  }

  @override
  String homeOnlineCount(int count) {
    return '$count online';
  }

  @override
  String get homeOnlineNow => 'Online now';

  @override
  String get homeTalkToAstrologer => 'Talk to an astrologer';

  @override
  String get homeLiveNow => 'Live now';

  @override
  String get homeWhatsOnYourMind => 'What\'s on your mind?';

  @override
  String get homeTodaysHoroscope => 'Today\'s horoscope';

  @override
  String get homeChooseYourSign => 'Choose your sign';

  @override
  String get homeReadMore => 'Read more';

  @override
  String get homeShowLess => 'Show less';

  @override
  String homeLuckToday(String rating) {
    return 'Luck today · $rating';
  }

  @override
  String get homeTodaysPanchang => 'Today\'s Panchang';

  @override
  String get homePanchangAddProfile =>
      'Add your birth details for a Panchang tuned to your place';

  @override
  String get homeFreeTools => 'Free tools';

  @override
  String get homeTalkAgain => 'Talk again';

  @override
  String get homeAddMoneyGetBonus => 'Add money, get bonus';

  @override
  String get homeReferAFriend => 'Refer a friend, both earn';

  @override
  String get homeReferShort => 'Share your code — you both get wallet credit';

  @override
  String homeReferYourCode(String code) {
    return 'Your code: $code';
  }

  @override
  String get homeInvite => 'Invite';

  @override
  String homeResumeInProgress(String channel) {
    return '$channel · in progress';
  }

  @override
  String homeResumePaused(String channel) {
    return '$channel · paused';
  }

  @override
  String get homeResume => 'Resume';

  @override
  String get homeTrustVerified =>
      'Every astrologer is ID-verified before they go live';

  @override
  String get homeTrustPrivate => '100% private and confidential consultations';

  @override
  String get homeTrustVolume => 'Thousands of consultations every week';

  @override
  String get homeCouldntLoadAstrologers => 'Couldn\'t load astrologers';

  @override
  String get homeCouldntLoadReading => 'Couldn\'t fetch today\'s reading';

  @override
  String get homeCouldntLoadPanchang => 'Couldn\'t load the Panchang';

  @override
  String get homeNoAstrologersFilter =>
      'No astrologers match this filter right now';

  @override
  String get concernLove => 'Love';

  @override
  String get concernMarriage => 'Marriage';

  @override
  String get concernCareer => 'Career';

  @override
  String get concernFinance => 'Finance';

  @override
  String get concernHealth => 'Health';

  @override
  String get concernEducation => 'Education';

  @override
  String get concernBusiness => 'Business';

  @override
  String get concernLegal => 'Legal';

  @override
  String get channelChat => 'Chat';

  @override
  String get channelCall => 'Call';

  @override
  String get channelVoice => 'Voice call';

  @override
  String get channelVideo => 'Video call';

  @override
  String get channelAll => 'All';

  @override
  String get astroFilterAll => 'All';

  @override
  String get astroSortRecommended => 'Recommended';

  @override
  String get astroSortTopRated => 'Top rated';

  @override
  String get astroSortExperienced => 'Most experienced';

  @override
  String get astroSortConsulted => 'Most consulted';

  @override
  String get astroSortNew => 'New here';

  @override
  String get astroOnline => 'Online';

  @override
  String get astroBusy => 'Busy';

  @override
  String get astroNotifyMe => 'Notify me';

  @override
  String astroWaitMinutes(int count) {
    return '~$count min wait';
  }

  @override
  String astroPerMinute(String price) {
    return '$price/min';
  }

  @override
  String astroYearsExp(int count) {
    return '$count yrs exp';
  }

  @override
  String get astroRatingNew => 'New';

  @override
  String astroSessionsCount(String count) {
    return '$count sessions';
  }

  @override
  String get astroSearchHint => 'Search by name, skill or language';

  @override
  String get astroNoneFound => 'No astrologers found';

  @override
  String get astroNoneFoundHint =>
      'Try removing a filter or searching for something else';

  @override
  String get astroThatsEveryone => 'That\'s everyone for now';

  @override
  String get astroRateOnRequest => 'Rate on request';

  @override
  String get astroCouldntLoad => 'Couldn\'t load astrologers';

  @override
  String get astroSortBy => 'Sort by';

  @override
  String get astroLoadMoreFailed => 'Couldn\'t load more';

  @override
  String get astroDefaultSkill => 'Vedic astrology';

  @override
  String astroYears(int count) {
    return '$count yrs';
  }

  @override
  String astroSessions(String count) {
    return '$count sessions';
  }

  @override
  String get astroChat => 'Chat';

  @override
  String get astroCall => 'Call';

  @override
  String get astroVideo => 'Video';

  @override
  String get astroProfileTitle => 'Astrologer';

  @override
  String get astroExpertiseTitle => 'Expertise';

  @override
  String get astroAboutTitle => 'About';

  @override
  String get astroRatesTitle => 'Consultation rates';

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
  String get astroStatRating => 'Rating';

  @override
  String get astroStatExperience => 'Experience';

  @override
  String get astroStatSessions => 'Sessions';

  @override
  String get astroStatRepeatClients => 'Repeat clients';

  @override
  String astroSpeaks(String languages) {
    return 'Speaks $languages';
  }

  @override
  String astroRepliesIn(String time) {
    return 'Replies in ~$time';
  }

  @override
  String get astroOnlineNow => 'Online now';

  @override
  String get astroOfflineTitle => 'Currently offline';

  @override
  String get astroNotifyWhenOnline => 'Notify me when online';

  @override
  String get astroReadMore => 'Read more';

  @override
  String get astroReadLess => 'Show less';

  @override
  String get astroCouldntLoadOne => 'Couldn\'t load this astrologer';

  @override
  String get astroCallsComingSoon => 'Voice & video calls are coming soon';

  @override
  String get astroTrustLine =>
      'ID-verified · Private & confidential · Pay by the minute';

  @override
  String get walletTitle => 'Wallet';

  @override
  String get walletAvailableBalance => 'Available balance';

  @override
  String walletOnHold(String amount) {
    return '$amount on hold';
  }

  @override
  String walletOnHoldReason(String amount) {
    return '$amount on hold · a call is running';
  }

  @override
  String get walletAddMoney => 'Add money';

  @override
  String get walletRecentActivity => 'Recent activity';

  @override
  String get walletTransactions => 'Transactions';

  @override
  String get walletHowItWorksTitle => 'How the wallet works';

  @override
  String get walletHowItWorksBody =>
      'Wallet balance is used only for consultations and never expires. Unused balance is refundable — see our refund policy.';

  @override
  String get walletRefundPolicy => 'Refund policy';

  @override
  String get walletHaveCoupon => 'Have a coupon code?';

  @override
  String get walletCouponHint => 'Enter code';

  @override
  String walletCouponApplied(String amount) {
    return '$amount added to your wallet';
  }

  @override
  String get walletSecuredBy =>
      'Secured by Razorpay · UPI · Cards · Netbanking';

  @override
  String get walletGstInvoices => 'GST invoices';

  @override
  String get walletInvoicesSubtitle =>
      'Invoices and receipts for your recharges';

  @override
  String get walletNoTransactions => 'No transactions yet';

  @override
  String get walletNoTransactionsHint =>
      'Add money to your wallet to get started';

  @override
  String walletBalanceAfter(String amount) {
    return 'Bal $amount';
  }

  @override
  String get walletFilterAll => 'All';

  @override
  String get walletFilterRecharge => 'Added';

  @override
  String get walletFilterConsultation => 'Consultations';

  @override
  String get walletFilterRefund => 'Refunds';

  @override
  String get walletFilterBonus => 'Bonus';

  @override
  String get kindRecharge => 'Money added';

  @override
  String get kindConsultationCharge => 'Consultation';

  @override
  String get kindConsultationRefund => 'Refund';

  @override
  String get kindPromoCredit => 'Promo credit';

  @override
  String get kindCouponDiscount => 'Coupon discount';

  @override
  String get kindSignupBonus => 'Signup bonus';

  @override
  String get kindReferralBonus => 'Referral bonus';

  @override
  String get kindAdjustment => 'Adjustment';

  @override
  String get kindGiftSpend => 'Gift sent';

  @override
  String get kindHold => 'Reserved for a call';

  @override
  String get kindChargeback => 'Chargeback';

  @override
  String get rechargeChooseAmount => 'Add money to wallet';

  @override
  String get rechargeAmountLabel => 'Amount';

  @override
  String rechargePayAmount(String amount) {
    return 'Pay $amount';
  }

  @override
  String get rechargeAddCoupon => 'Add a coupon code';

  @override
  String rechargeBonusBadge(String amount) {
    return '+$amount';
  }

  @override
  String get rechargeStarterPack => 'Starter';

  @override
  String rechargeMinAmount(String amount) {
    return 'Minimum $amount';
  }

  @override
  String rechargeMaxAmount(String amount) {
    return 'Maximum $amount';
  }

  @override
  String get rechargeOpeningCheckout => 'Opening secure checkout…';

  @override
  String get rechargeConfirming => 'Payment received — updating your balance…';

  @override
  String rechargeSuccessTitle(String amount) {
    return '$amount added';
  }

  @override
  String rechargeNewBalance(String amount) {
    return 'New balance $amount';
  }

  @override
  String get rechargeViewTransaction => 'View transaction';

  @override
  String get rechargeFailedTitle => 'Payment didn\'t go through';

  @override
  String get rechargeNotCharged => 'You have not been charged.';

  @override
  String get rechargeAutoRefund =>
      'If any amount was debited, it will be refunded in 3–5 working days.';

  @override
  String get rechargeTryAgain => 'Try again';

  @override
  String get rechargeChangeAmount => 'Change amount';

  @override
  String get rechargeCreditedSoon =>
      'Payment received. We\'ll credit it to your wallet in a moment.';

  @override
  String rechargeOfferAutoApplied(String amount, String bonus) {
    return 'Add $amount, get $bonus extra — auto-applied';
  }

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileEditProfile => 'Edit profile';

  @override
  String profilePhoneMasked(String last4) {
    return '+91 ●●●●● $last4';
  }

  @override
  String get profileCompleteAddEmail => 'Add your email to finish your profile';

  @override
  String get profileCompleteAddBirth =>
      'Add your birth details for personalised readings';

  @override
  String get profileRoleCustomer => 'Customer';

  @override
  String get profileWallet => 'Wallet';

  @override
  String get profileBirthProfiles => 'Birth profiles';

  @override
  String profileBirthProfilesCount(int count) {
    return '$count charts';
  }

  @override
  String get profileGroupAccount => 'Account';

  @override
  String get profileGroupMoney => 'Money';

  @override
  String get profileGroupPreferences => 'Preferences';

  @override
  String get profileGroupSupport => 'Support';

  @override
  String get profileGroupLegal => 'Legal';

  @override
  String get profileNotifications => 'Notifications';

  @override
  String get profileNotificationPrefs => 'Notification preferences';

  @override
  String get profileHapticFeedback => 'Haptic feedback';

  @override
  String get profileHapticFeedbackDesc => 'Vibrate on buttons and interactions';

  @override
  String get profileWalletAndTransactions => 'Wallet and transactions';

  @override
  String get profileOrders => 'Orders';

  @override
  String profileOrdersUnread(int count) {
    return '$count new';
  }

  @override
  String get profileReferAndEarn => 'Refer and earn';

  @override
  String get profileLanguage => 'Language';

  @override
  String get profileCurrency => 'Currency';

  @override
  String get profileHelpCentre => 'Help centre';

  @override
  String get profileContactWhatsapp => 'Contact us on WhatsApp';

  @override
  String get profileRateApp => 'Rate TalkAcharya';

  @override
  String get profileShareApp => 'Share the app';

  @override
  String profileShareMessage(String link) {
    return 'I\'m using TalkAcharya to talk to astrologers. Try it: $link';
  }

  @override
  String get profileTerms => 'Terms of service';

  @override
  String get profilePrivacy => 'Privacy policy';

  @override
  String get profileLicenses => 'Open-source licences';

  @override
  String get profileDeleteAccount => 'Delete account';

  @override
  String profileVersion(String version, String build) {
    return 'TalkAcharya · v$version ($build)';
  }

  @override
  String get editFullName => 'Full name';

  @override
  String get editDisplayName => 'Display name';

  @override
  String get editDateOfBirth => 'Date of birth';

  @override
  String get editGender => 'Gender';

  @override
  String get editGenderMale => 'Male';

  @override
  String get editGenderFemale => 'Female';

  @override
  String get editGenderOther => 'Other';

  @override
  String get editEmail => 'Email';

  @override
  String get editEmailUnverified => 'Not verified';

  @override
  String get editChangePhoto => 'Change photo';

  @override
  String get editProfileSaved => 'Profile updated';

  @override
  String get editProfileSaveError => 'Couldn\'t save your changes';

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
  String get editCountry => 'Country';

  @override
  String get chooseLanguage => 'Choose language';

  @override
  String get chooseCurrency => 'Choose currency';

  @override
  String get deleteAccountTitle => 'Delete your account';

  @override
  String get deleteAccountBody =>
      'This permanently removes your profile, birth charts and chat history. Your wallet balance, if any, is refunded to the original payment method. Consultation records are kept as required by law.';

  @override
  String get deleteAccountHold =>
      'Your account is deactivated immediately and fully deleted after 30 days. Sign in again within 30 days to cancel.';

  @override
  String get deleteAccountConfirm => 'Yes, delete my account';

  @override
  String get deleteAccountRequested => 'Account deletion requested';

  @override
  String get referTitle => 'Refer and earn';

  @override
  String referHeroTitle(String friendAmount, String youAmount) {
    return 'Give $friendAmount, get $youAmount';
  }

  @override
  String referHeroBody(String friendAmount, String youAmount) {
    return 'Your friend gets $friendAmount off their first consultation. You get $youAmount in your wallet when they take it.';
  }

  @override
  String get referYourCode => 'Your referral code';

  @override
  String get referShareLink => 'Share invite link';

  @override
  String get referInvited => 'Invited';

  @override
  String get referJoined => 'Joined';

  @override
  String get referEarned => 'Earned';

  @override
  String get referHowItWorks => 'How it works';

  @override
  String get referStep1 =>
      'Share your code or link. Your friend enters it while signing up.';

  @override
  String referStep2(String amount) {
    return 'They get $amount off their first paid consultation.';
  }

  @override
  String referStep3(String amount) {
    return 'The moment that consultation is billed, $amount lands in your wallet.';
  }

  @override
  String get referYourReferrals => 'Your referrals';

  @override
  String get referStatusPending => 'Pending';

  @override
  String get referStatusJoined => 'Joined';

  @override
  String get referStatusRewarded => 'Rewarded';

  @override
  String referJoinedOn(String date) {
    return 'Joined $date';
  }

  @override
  String get referFirstCallDone => 'first call done';

  @override
  String referShareText(String code, String amount, String link) {
    return 'Use my code $code on TalkAcharya and get $amount off your first astrology consultation. $link';
  }

  @override
  String get kundaliYogasDoshasTitle => 'Yogas & Doshas';

  @override
  String get kundaliTabDoshas => 'Doshas';

  @override
  String get kundaliTabYogas => 'Yogas';

  @override
  String get doshaIntro =>
      'Doshas are sensitive points in the chart. Most soften with time, a supportive dasha, or a classical remedy — an astrologer confirms what actually matters for you.';

  @override
  String get doshaDisclaimer =>
      'Structural indications only, not predictions. Talk to an astrologer before wearing a gemstone or starting a serious remedy.';

  @override
  String get doshaPresent => 'Present';

  @override
  String get doshaNotPresent => 'Not present';

  @override
  String get doshaCancelled => 'Effectively cancelled';

  @override
  String get doshaSeverityClear => 'Clear';

  @override
  String get doshaSeverityMild => 'Mild';

  @override
  String get doshaSeverityModerate => 'Moderate';

  @override
  String get doshaSeverityStrong => 'Strong';

  @override
  String get doshaWhy => 'Why it\'s flagged';

  @override
  String get doshaWhatReduces => 'What reduces it';

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
  String get doshaClearSectionTitle => 'Clear — not in your chart';

  @override
  String get doshaAllClear =>
      'None of the common doshas are present in your chart.';

  @override
  String get doshaAskCta => 'Ask an astrologer what this means for you';

  @override
  String get insightsTitle => 'Personality & life overview';

  @override
  String get insightsIntro =>
      'A free reading of your birth (D1) chart — the tendencies it leans towards across the main areas of life. It\'s a sketch for self-reflection, not a forecast of events or dates.';

  @override
  String get insightsDisclaimer =>
      'General guidance from your chart, not a prediction. It names no dates and makes no claims about health, lifespan or relationships. For anything specific, talk to an astrologer.';

  @override
  String get insightsAskCta => 'Ask an astrologer about your chart';

  @override
  String get insightsWhatItReadsFrom => 'What this reads from';

  @override
  String get insightsToneSupportive => 'Supportive';

  @override
  String get insightsToneBalanced => 'Balanced';

  @override
  String get insightsToneChallenging => 'Needs care';

  @override
  String get insightsToneMixed => 'Mixed';

  @override
  String get insightsAreaPersonality => 'Personality & Nature';

  @override
  String get insightsAreaAppearance => 'Physical Appearance';

  @override
  String get insightsAreaMind => 'Mind & Emotions';

  @override
  String get insightsAreaCareer => 'Career & Profession';

  @override
  String get insightsAreaWealth => 'Wealth & Finances';

  @override
  String get insightsAreaEducation => 'Education & Intellect';

  @override
  String get insightsAreaMarriage => 'Marriage & Spouse';

  @override
  String get insightsAreaFamily => 'Family & Relationships';

  @override
  String get insightsAreaHealth => 'Health & Vitality';

  @override
  String get insightsAreaFortune => 'Fortune & Dharma';

  @override
  String get insightsAreaStrengths => 'Strengths & Challenges';

  @override
  String get predTitle => 'Predictions';

  @override
  String get predReadingTitle => 'Your forecast';

  @override
  String get predRequestTitle => 'Request a forecast';

  @override
  String get predHeroTitle => 'A forecast written for you';

  @override
  String get predHeroBody =>
      'An astrologer reads your birth chart, dasha and current transits and writes a forecast for one area of life. Delivered in your language, usually within 3 days.';

  @override
  String get predChooseArea => 'Choose an area';

  @override
  String get predMyReadings => 'Your forecasts';

  @override
  String get predNoReadings =>
      'No forecasts yet. Pick an area above to request one.';

  @override
  String get predSeePacks => 'See packs';

  @override
  String get predSubscribed => 'Subscribed';

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
  String get predBuyTitle => 'Prediction credits';

  @override
  String get predBuyBody =>
      'One credit = one written forecast. Buy a pack and it\'s ready whenever you want a reading.';

  @override
  String get predBuyWalletNote => 'Paid from your wallet balance.';

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
    return '$price per credit';
  }

  @override
  String predBuySuccess(int count) {
    return 'Added. You now have $count credits.';
  }

  @override
  String get predForProfile => 'For which birth profile';

  @override
  String get predAddProfile => 'Add a birth profile';

  @override
  String get predPickProfile => 'Choose a birth profile first.';

  @override
  String get predArea => 'Area of life';

  @override
  String get predPeriod => 'Period';

  @override
  String predCostsOne(int count) {
    return 'Uses 1 of your $count credits.';
  }

  @override
  String get predNoCreditYet =>
      'You\'ll need a credit — we\'ll show the packs next.';

  @override
  String get predRequestCta => 'Request forecast';

  @override
  String get predRequestDisclaimer =>
      'The astrologer writes from your chart, dasha and transits. Astrology is guidance for reflection and planning, not a guarantee.';

  @override
  String get predAreaCareer => 'Career & work';

  @override
  String get predAreaMarriage => 'Marriage & love';

  @override
  String get predAreaFinance => 'Money & finance';

  @override
  String get predAreaHealth => 'Health & energy';

  @override
  String get predAreaEducation => 'Study & learning';

  @override
  String get predAreaGeneral => 'Life overview';

  @override
  String get predPeriodMonth => 'The month ahead';

  @override
  String get predPeriodQuarter => 'The next 3 months';

  @override
  String get predPeriodYear => 'The year ahead';

  @override
  String get predStatusWriting => 'Being written';

  @override
  String get predStatusReview => 'In review';

  @override
  String get predStatusReady => 'Ready to read';

  @override
  String get predStatusUnavailable => 'Not available';

  @override
  String get predStatusRefunded => 'Refunded';

  @override
  String predDeliveredOn(String date) {
    return 'Delivered $date';
  }

  @override
  String predEta(String date) {
    return 'Expected by $date';
  }

  @override
  String get predWritingTitle => 'An astrologer is writing this';

  @override
  String get predWritingBody =>
      'We\'ll send you a notification the moment it\'s ready.';

  @override
  String predWritingEta(String date) {
    return 'Expected by $date. We\'ll notify you when it\'s ready.';
  }

  @override
  String get predRefundedTitle => 'Credit refunded';

  @override
  String get predRefundedBody =>
      'We couldn\'t deliver this in time, so your credit is back in your account.';

  @override
  String get predDisclaimer =>
      'Written for you by an astrologer from your birth chart, dasha and current transits. Astrology is guidance for reflection and planning — the choices and the outcome stay yours.';

  @override
  String get predAskFollowUp => 'Ask a follow-up question';

  @override
  String get remediesTitle => 'Remedies';

  @override
  String get remediesIntro =>
      'Traditional remedies matched to what your chart shows — its active doshas, weaker planets, the running dasha and strained houses. They are acts of discipline and devotion, chosen to fit your faith, health and means.';

  @override
  String get remediesNone =>
      'Nothing stands out in your chart that calls for a specific remedy right now. Keeping a small, steady daily practice is always worthwhile.';

  @override
  String get remediesDisclaimer =>
      'Do only what fits your faith, health and means. Skip fasting if it is unsafe for you, and never take a loan to give charity.';

  @override
  String get remediesAskCta => 'Talk to an astrologer about your remedies';

  @override
  String get remediesConfirmCta => 'Confirm with an astrologer first';

  @override
  String remediesSource(String source) {
    return 'Source: $source';
  }

  @override
  String get doshaSeeRemedies => 'See remedies for your chart';

  @override
  String get remedyCatMantra => 'Mantra & japa';

  @override
  String get remedyCatStotra => 'Stotra & recitation';

  @override
  String get remedyCatPuja => 'Puja & ritual';

  @override
  String get remedyCatVrat => 'Vrat & fasting';

  @override
  String get remedyCatDaan => 'Daan & charity';

  @override
  String get remedyCatLifestyle => 'Lifestyle';

  @override
  String get remedyCatYantra => 'Yantra';

  @override
  String get remedyCatGemstone => 'Gemstone';

  @override
  String get remedyCatRudraksha => 'Rudraksha';

  @override
  String get prashnaTitle => 'Ask one question';

  @override
  String get prashnaHeroTitle => 'A yes-or-no on the moment';

  @override
  String get prashnaHeroBody =>
      'KP horary (Prashna) reads the exact moment you ask a question to give a leaning — yes, no or mixed — with the reasoning. One traditional method\'s pointer, not a promise.';

  @override
  String get prashnaAbout => 'What is the question about?';

  @override
  String get prashnaHint => 'e.g. Will I get this job offer?';

  @override
  String prashnaAskCta(String price) {
    return 'Ask ($price)';
  }

  @override
  String get prashnaDisclaimer =>
      'A KP horary reading of the moment you asked. It is one traditional method\'s pointer — not a promise, and not a substitute for a full consultation.';

  @override
  String get prashnaNeedQuestion =>
      'Pick a topic and type your question first.';

  @override
  String get prashnaLowBalance =>
      'Your wallet balance is too low. Add money to ask.';

  @override
  String get prashnaHistory => 'Your questions';

  @override
  String get prashnaNoHistory => 'You haven\'t asked a question yet.';

  @override
  String get prashnaAnswerTitle => 'The reading';

  @override
  String get prashnaAskAstrologer => 'Talk it through with an astrologer';

  @override
  String get prashnaHowRead => 'How this was read';

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
  String get prashnaVerdictYes => 'Leaning yes';

  @override
  String get prashnaVerdictNo => 'Leaning no';

  @override
  String get prashnaVerdictMixed => 'Mixed signals';

  @override
  String get prashnaVerdictUnclear => 'Not decisive';

  @override
  String get prashnaCatMarriage => 'Marriage';

  @override
  String get prashnaCatJob => 'A job';

  @override
  String get prashnaCatPromotion => 'Promotion';

  @override
  String get prashnaCatBusiness => 'Business';

  @override
  String get prashnaCatProperty => 'Property';

  @override
  String get prashnaCatMoney => 'A loan or money';

  @override
  String get prashnaCatChild => 'Children';

  @override
  String get prashnaCatTravel => 'Foreign travel';

  @override
  String get prashnaCatLitigation => 'A court matter';

  @override
  String get prashnaCatHealth => 'Health & recovery';

  @override
  String get prashnaCatLost => 'A lost item';

  @override
  String get prashnaCatReunion => 'A reunion';

  @override
  String get prashnaCatGeneral => 'Something else';

  @override
  String get yogaIntro =>
      'Yogas are tendencies, not guarantees — they strengthen when the planets involved are well placed and running their dasha.';

  @override
  String get yogaNoneTitle => 'No classical yogas detected';

  @override
  String get yogaNoneBody =>
      'That\'s common and not a bad sign — the chart is still read through its houses and dasha.';

  @override
  String get kundaliTalkToAstrologer => 'Talk to an astrologer';

  @override
  String get kundaliHowItPlaysOut =>
      'Want to know how these play out in your life and timing?';

  @override
  String get yogaGajakesariName => 'Gajakesari Yoga';

  @override
  String get yogaGajakesariMeaning =>
      'Jupiter in a kendra from the Moon — poise, good judgement and a name that carries weight.';

  @override
  String get yogaBudhadityaName => 'Budhaditya Yoga';

  @override
  String get yogaBudhadityaMeaning =>
      'Sun and Mercury together — a sharp, expressive mind; strong for study, writing and analysis.';

  @override
  String get yogaChandraMangalaName => 'Chandra-Mangala Yoga';

  @override
  String get yogaChandraMangalaMeaning =>
      'Moon with Mars — drive around money and enterprise; earning through effort and initiative.';

  @override
  String get yogaRajaName => 'Raja Yoga';

  @override
  String get yogaRajaMeaning =>
      'A kendra lord tied to a trikona lord — a lift in status, authority and opportunity when the period runs.';

  @override
  String get yogaDhanaName => 'Dhana Yoga';

  @override
  String get yogaDhanaMeaning =>
      'The wealth and gains houses linked — supports savings and steady financial growth.';

  @override
  String get yogaNeechabhangaName => 'Neechabhanga Raja Yoga';

  @override
  String get yogaNeechabhangaMeaning =>
      'A debilitated planet whose weakness is cancelled — an early struggle that turns into strength.';

  @override
  String get yogaKaalSarpaName => 'Kaal Sarpa Yoga';

  @override
  String get yogaKaalSarpaMeaning =>
      'All seven planets on one side of the Rahu-Ketu axis — life can feel hemmed in until a clear direction is found.';

  @override
  String get yogaAdhiName => 'Adhi Yoga';

  @override
  String get yogaAdhiMeaning =>
      'Benefics in the 6th, 7th and 8th from the Moon — protection, capable helpers and a settled position.';

  @override
  String get yogaShakataName => 'Shakata Yoga';

  @override
  String get yogaShakataMeaning =>
      'Moon in the 6th, 8th or 12th from Jupiter — fortunes that rise and fall; steadier when the Moon is strong.';

  @override
  String get yogaVishName => 'Vish Yoga';

  @override
  String get yogaVishMeaning =>
      'Moon with Saturn — the mind carries weight; results tend to come later, with maturity.';

  @override
  String get yogaKahalaName => 'Kahala Yoga';

  @override
  String get yogaKahalaMeaning =>
      'The 4th and 9th lords in mutual kendra with a strong Lagna lord — bold, enterprising, willing to take a risk.';

  @override
  String get yogaPushkalaName => 'Pushkala Yoga';

  @override
  String get yogaPushkalaMeaning =>
      'The Moon\'s lord with the Lagna lord in a kendra — respect, a good name and persuasive speech.';

  @override
  String get yogaDaridraName => 'Daridra Yoga';

  @override
  String get yogaDaridraMeaning =>
      'The 11th (gains) lord fallen into a difficult house — gains come slowly; a strong dasha turns it around.';

  @override
  String get yogaAmalaName => 'Amala Yoga';

  @override
  String get yogaAmalaMeaning =>
      'Only a benefic in the 10th from the Lagna or Moon — a clean reputation and lasting goodwill.';

  @override
  String get yogaSaraswatiName => 'Saraswati Yoga';

  @override
  String get yogaSaraswatiMeaning =>
      'Mercury, Venus and a strong Jupiter well placed — learning, art and eloquence.';

  @override
  String get yogaLakshmiName => 'Lakshmi Yoga';

  @override
  String get yogaLakshmiMeaning =>
      'A strong 9th lord in a kendra or trikona with a strong Lagna lord — fortune, comfort and grace.';

  @override
  String get yogaRuchakaName => 'Ruchaka Yoga';

  @override
  String get yogaRuchakaMeaning =>
      'Mars strong in a kendra — courage, physical vigour and leadership under pressure.';

  @override
  String get yogaBhadraName => 'Bhadra Yoga';

  @override
  String get yogaBhadraMeaning =>
      'Mercury strong in a kendra — intelligence, clear speech and skill in trade and communication.';

  @override
  String get yogaHamsaName => 'Hamsa Yoga';

  @override
  String get yogaHamsaMeaning =>
      'Jupiter strong in a kendra — wisdom, ethics, a teaching or advisory nature and general good fortune.';

  @override
  String get yogaMalavyaName => 'Malavya Yoga';

  @override
  String get yogaMalavyaMeaning =>
      'Venus strong in a kendra — charm, comfort, an eye for beauty and a pleasant home life.';

  @override
  String get yogaSasaName => 'Sasa Yoga';

  @override
  String get yogaSasaMeaning =>
      'Saturn strong in a kendra — discipline, endurance and authority built slowly and kept.';

  @override
  String get yogaUbhayachariName => 'Ubhayachari Yoga';

  @override
  String get yogaUbhayachariMeaning =>
      'Planets on both sides of the Sun — a well-supported, visible life and good all-round standing.';

  @override
  String get yogaVesiName => 'Vesi Yoga';

  @override
  String get yogaVesiMeaning =>
      'A planet in the 2nd from the Sun — steady speech, a balanced outlook and a fair name.';

  @override
  String get yogaVasiName => 'Vasi Yoga';

  @override
  String get yogaVasiMeaning =>
      'A planet in the 12th from the Sun — capability, influence and a generous streak.';

  @override
  String get yogaShubhaKartariName => 'Shubha Kartari Yoga';

  @override
  String get yogaShubhaKartariMeaning =>
      'Benefics on either side of the Lagna — protection, a gentler path and helpful circumstances.';

  @override
  String get yogaPapaKartariName => 'Papa Kartari Yoga';

  @override
  String get yogaPapaKartariMeaning =>
      'Malefics on either side of the Lagna — pressure on the self and health; guard your energy and boundaries.';

  @override
  String get yogaDurudharaName => 'Durudhara Yoga';

  @override
  String get yogaDurudharaMeaning =>
      'Planets flank the Moon in the 2nd and 12th — resources, comfort and steady support around you.';

  @override
  String get yogaSunaphaName => 'Sunapha Yoga';

  @override
  String get yogaSunaphaMeaning =>
      'A planet in the 2nd from the Moon — self-made means, intelligence and a good reputation.';

  @override
  String get yogaAnaphaName => 'Anapha Yoga';

  @override
  String get yogaAnaphaMeaning =>
      'A planet in the 12th from the Moon — an easy nature, well-being and freedom from want.';

  @override
  String get yogaKemadrumaYogaName => 'Kemadruma Yoga';

  @override
  String get yogaKemadrumaYogaMeaning =>
      'The Moon stands alone, unsupported — an inner restlessness that eases when the Moon is strong or a kendra is occupied.';

  @override
  String get yogaVasumatiName => 'Vasumati Yoga';

  @override
  String get yogaVasumatiMeaning =>
      'Benefics in the growth houses from the Lagna or Moon — accumulating wealth and rising resources.';

  @override
  String get yogaKalanidhiName => 'Kalanidhi Yoga';

  @override
  String get yogaKalanidhiMeaning =>
      'Jupiter in the 2nd or 5th tied to Mercury or Venus — learning, the arts, refinement and honour.';

  @override
  String get yogaChamaraName => 'Chamara Yoga';

  @override
  String get yogaChamaraMeaning =>
      'An exalted Lagna lord in a kendra aspected by Jupiter — eloquence, long life and respected standing.';

  @override
  String get yogaShankhaName => 'Shankha Yoga';

  @override
  String get yogaShankhaMeaning =>
      'The 5th and 6th lords linked with a strong Lagna lord — a good life, kind nature and comfort in later years.';

  @override
  String get yogaParvataName => 'Parvata Yoga';

  @override
  String get yogaParvataMeaning =>
      'Benefics in the kendras with the 6th and 8th clean — fortune, generosity and an eminent name.';

  @override
  String get yogaHarshaName => 'Harsha Yoga';

  @override
  String get yogaHarshaMeaning =>
      'The 6th lord in a difficult house — enemies, debts and illness lose their grip; competitive strength.';

  @override
  String get yogaSaralaName => 'Sarala Yoga';

  @override
  String get yogaSaralaMeaning =>
      'The 8th lord in a difficult house — resilience through crises, longevity and fearlessness.';

  @override
  String get yogaVimalaName => 'Vimala Yoga';

  @override
  String get yogaVimalaMeaning =>
      'The 12th lord in a difficult house — controlled spending, a clean conscience and an independent life.';

  @override
  String get yogaMahaParivartanaName => 'Maha Parivartana Yoga';

  @override
  String get yogaMahaParivartanaMeaning =>
      'Two lords of good houses exchange signs — the affairs of both houses lift each other over time.';

  @override
  String get yogaKhalaParivartanaName => 'Khala Parivartana Yoga';

  @override
  String get yogaKhalaParivartanaMeaning =>
      'An exchange involving the 3rd house — mixed results, ups and downs, gains through effort and courage.';

  @override
  String get yogaDainyaParivartanaName => 'Dainya Parivartana Yoga';

  @override
  String get yogaDainyaParivartanaMeaning =>
      'An exchange involving a difficult house — obstacles that need patience; a strong dasha turns it.';

  @override
  String get kSignAries => 'bold, direct, quick to start';

  @override
  String get kSignTaurus => 'steady, sensual, values comfort and security';

  @override
  String get kSignGemini => 'curious, verbal, quick-thinking';

  @override
  String get kSignCancer => 'caring, protective, led by feeling';

  @override
  String get kSignLeo => 'proud, warm, wants to be seen';

  @override
  String get kSignVirgo => 'precise, useful, improvement-minded';

  @override
  String get kSignLibra => 'fair, relational, seeks balance';

  @override
  String get kSignScorpio => 'intense, private, all-or-nothing';

  @override
  String get kSignSagittarius => 'free, believing, big-picture';

  @override
  String get kSignCapricorn => 'disciplined, ambitious, plays the long game';

  @override
  String get kSignAquarius => 'independent, systems-minded, unconventional';

  @override
  String get kSignPisces => 'imaginative, compassionate, boundary-less';

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
  String get kPlanetSun => 'soul, confidence, father, authority';

  @override
  String get kPlanetMoon => 'mind, emotions, mother, comfort';

  @override
  String get kPlanetMars => 'drive, courage, anger, siblings';

  @override
  String get kPlanetMercury => 'intellect, speech, trade, skill';

  @override
  String get kPlanetJupiter => 'wisdom, growth, luck, teachers, children';

  @override
  String get kPlanetVenus => 'love, beauty, comfort, partnership, art';

  @override
  String get kPlanetSaturn => 'discipline, time, limits, hard-won reward';

  @override
  String get kPlanetRahu => 'ambition, obsession, the foreign and new';

  @override
  String get kPlanetKetu => 'detachment, mastery, letting go, spirituality';

  @override
  String get kHouse1 => 'Self, body, vitality';

  @override
  String get kHouse2 => 'Wealth, family, speech, food';

  @override
  String get kHouse3 => 'Courage, siblings, effort, short travel';

  @override
  String get kHouse4 => 'Home, mother, land, inner peace';

  @override
  String get kHouse5 => 'Children, education, creativity, romance';

  @override
  String get kHouse6 => 'Health, debt, enemies, daily work';

  @override
  String get kHouse7 => 'Marriage, partnership, business';

  @override
  String get kHouse8 => 'Longevity, sudden change, the hidden, inheritance';

  @override
  String get kHouse9 => 'Fortune, dharma, father, higher learning, long travel';

  @override
  String get kHouse10 => 'Career, status, public life';

  @override
  String get kHouse11 => 'Income, gains, network, elder siblings';

  @override
  String get kHouse12 => 'Loss, expenses, foreign lands, sleep, liberation';

  @override
  String get kDignityExalted => 'Exalted — very strong';

  @override
  String get kDignityDebilitated => 'Debilitated — under strain here';

  @override
  String get kDignityMoolatrikona => 'Moolatrikona — comfortable and strong';

  @override
  String get kDignityOwn => 'Own sign — stable and effective';

  @override
  String get kDignityGreatFriend => 'In a great friend\'s sign — supported';

  @override
  String get kDignityFriend => 'In a friend\'s sign — supported';

  @override
  String get kDignityNeutral => 'Neutral sign';

  @override
  String get kDignityEnemy => 'In an enemy\'s sign — works harder';

  @override
  String get kDignityGreatEnemy => 'In a great enemy\'s sign — under pressure';

  @override
  String get kDashaSun =>
      'A period for identity, authority and recognition. Ego and health of the eyes/heart come into focus.';

  @override
  String get kDashaMoon =>
      'A softer, more emotional chapter — home, mother, moods and public life.';

  @override
  String get kDashaMars =>
      'Energy, competition and initiative rise. Watch temper, accidents and property matters.';

  @override
  String get kDashaMercury =>
      'Learning, trading, writing and communication. Good for study and business, restless for stillness.';

  @override
  String get kDashaJupiter =>
      'Growth, teachers, family, meaning. Often a fortunate, expansive phase.';

  @override
  String get kDashaVenus =>
      'Relationships, comfort, art, money and pleasure. Usually the easiest of the periods.';

  @override
  String get kDashaSaturn =>
      'Hard work, responsibility and slow, lasting results. Rewards patience; punishes shortcuts.';

  @override
  String get kDashaRahu =>
      'Ambition without limits — foreign lands, technology, sudden rises and confusion.';

  @override
  String get kDashaKetu =>
      'Detachment, endings and spiritual turning inward. Material things feel hollow; skill deepens.';

  @override
  String get kNakAshwini => 'quick, pioneering, healing';

  @override
  String get kNakBharani => 'intense, holds space for change, disciplined';

  @override
  String get kNakKrittika => 'sharp, cutting through, protective';

  @override
  String get kNakRohini => 'creative, sensual, nurturing, magnetic';

  @override
  String get kNakMrigashira => 'searching, curious, gentle';

  @override
  String get kNakArdra => 'stormy, transformative, brilliant under pressure';

  @override
  String get kNakPunarvasu => 'renewing, generous, returns to safety';

  @override
  String get kNakPushya => 'nourishing, dutiful, deeply supportive';

  @override
  String get kNakAshlesha => 'perceptive, strategic, hypnotic';

  @override
  String get kNakMagha => 'regal, tradition-bound, ancestral';

  @override
  String get kNakPurvaPhalguni => 'playful, romantic, values leisure';

  @override
  String get kNakUttaraPhalguni => 'reliable, contractual, helpful';

  @override
  String get kNakHasta => 'skilled with the hands, clever, healing';

  @override
  String get kNakChitra => 'artistic, striking, builds beautiful things';

  @override
  String get kNakSwati => 'independent, adaptable, freedom-loving';

  @override
  String get kNakVishakha => 'goal-driven, determined, dual-natured';

  @override
  String get kNakAnuradha => 'devoted, friendly, thrives abroad';

  @override
  String get kNakJyeshtha => 'senior, responsible, carries burdens';

  @override
  String get kNakMula => 'root-seeking, radical, gets to the core';

  @override
  String get kNakPurvaAshadha => 'invincible spirit, persuasive';

  @override
  String get kNakUttaraAshadha => 'principled, enduring, later success';

  @override
  String get kNakShravana => 'listening, learning, connecting people';

  @override
  String get kNakDhanishta => 'rhythmic, wealthy, musical, adaptable';

  @override
  String get kNakShatabhisha => 'private, healing, systems-minded';

  @override
  String get kNakPurvaBhadrapada => 'idealistic, intense, transformative';

  @override
  String get kNakUttaraBhadrapada => 'deep, calm, wise counsel';

  @override
  String get kNakRevati => 'kind, protective of travellers, imaginative';

  @override
  String get kSadeSatiRising =>
      'Rising phase — Saturn is in the 12th sign from your Moon. Endings, tiredness and a sense of things winding down. Start clearing what no longer works.';

  @override
  String get kSadeSatiPeak =>
      'Peak phase — Saturn is over your Moon sign itself. The heaviest stretch: responsibility, pressure and slow progress. Keep routines, protect your health.';

  @override
  String get kSadeSatiSetting =>
      'Setting phase — Saturn is in the 2nd sign from your Moon. The weight lifts. Money and family stabilise; the lessons of the last years start paying off.';

  @override
  String get kSadeSatiGeneric =>
      'Saturn is transiting the signs around your Moon.';

  @override
  String kPlanetInSignHouse(
    Object planet,
    Object sign,
    Object signTrait,
    Object house,
    Object houseTheme,
  ) {
    return 'Your $planet in $sign makes you $signTrait. In the $house house it touches $houseTheme.';
  }

  @override
  String kPlanetInSign(Object planet, Object sign, Object signTrait) {
    return 'Your $planet in $sign makes you $signTrait.';
  }

  @override
  String get kHouseSans1 => 'Tanu Bhava';

  @override
  String get kHouseSans2 => 'Dhana Bhava';

  @override
  String get kHouseSans3 => 'Sahaja Bhava';

  @override
  String get kHouseSans4 => 'Sukha Bhava';

  @override
  String get kHouseSans5 => 'Putra Bhava';

  @override
  String get kHouseSans6 => 'Ripu Bhava';

  @override
  String get kHouseSans7 => 'Yuvati Bhava';

  @override
  String get kHouseSans8 => 'Ayu / Randhra Bhava';

  @override
  String get kHouseSans9 => 'Dharma Bhava';

  @override
  String get kHouseSans10 => 'Karma Bhava';

  @override
  String get kHouseSans11 => 'Labha Bhava';

  @override
  String get kHouseSans12 => 'Vyaya Bhava';

  @override
  String kHouseTitleWithSign(Object sign, Object theme) {
    return '$sign · $theme';
  }

  @override
  String kHouseSheetTitle(Object ordinal, Object sign) {
    return '$ordinal House · $sign';
  }

  @override
  String kHouseSheetSubtitle(Object sanskrit, Object theme) {
    return '$sanskrit — $theme';
  }

  @override
  String kHouseChipLord(Object lord) {
    return 'House lord · $lord';
  }

  @override
  String kHouseChipLordIn(Object nthHouse) {
    return 'Lord in the $nthHouse';
  }

  @override
  String kHouseNoPlanets(Object lord, Object lordWhere) {
    return 'No planets sit in this house. Its story is told mainly by its lord, $lord$lordWhere.';
  }

  @override
  String kHouseLordWhere(Object nthHouse) {
    return ', now in the $nthHouse';
  }

  @override
  String get kHousePlanetsHeader => 'Planets in this house';

  @override
  String kHouseAskCta(Object ordinal) {
    return 'Ask an astrologer about your $ordinal house';
  }

  @override
  String kHouseReadingLord(
    Object ordinal,
    Object lord,
    Object nthHouse,
    Object theme,
    Object lordTheme,
  ) {
    return 'Your $ordinal-house lord $lord sits in the $nthHouse, so $theme connects to $lordTheme.';
  }

  @override
  String kHouseReadingOccupant(
    Object planet,
    Object planetTheme,
    Object theme,
  ) {
    return '$planet here brings its themes — $planetTheme — into $theme.';
  }

  @override
  String get kHouseReadingEmpty =>
      'This house is read through its lord and the planets that aspect it. An astrologer can walk you through it.';

  @override
  String kBhavaSubheadKaraka(Object karaka) {
    return 'Karaka $karaka';
  }

  @override
  String kBhavaSubheadLord(Object lord, Object nthHouse) {
    return 'lord $lord, $nthHouse';
  }

  @override
  String kBhavaSubheadLordOnly(Object lord) {
    return 'lord $lord';
  }

  @override
  String kBhavaReadingGoverns(Object theme) {
    return 'This house governs $theme.';
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
    return 'Its lord $lord is in the $nthHouse, so $theme connects to $lordTheme.$dignity$occupants';
  }

  @override
  String kBhavaReadingDignity(Object dignity) {
    return ' The lord is $dignity.';
  }

  @override
  String kBhavaReadingOccupants(Object planets, Object themes) {
    return ' $planets sit here, adding $themes.';
  }

  @override
  String kTransitHouseLine(Object nthHouse, Object theme) {
    return 'Your $nthHouse · $theme';
  }

  @override
  String kPlanetRowMeta(Object sign, Object nthHouse, Object degree) {
    return '$sign · $nthHouse · $degree°';
  }

  @override
  String kLagnaLordIn(Object nthHouse) {
    return 'in the $nthHouse';
  }

  @override
  String get kDignityShortExalted => 'Exalted';

  @override
  String get kDignityShortMoolatrikona => 'Moolatrikona';

  @override
  String get kDignityShortOwn => 'Own';

  @override
  String get kDignityShortDebilitated => 'Debilitated';

  @override
  String get kDignityShortEnemy => 'Enemy sign';

  @override
  String get kDignityShortGreatEnemy => 'Great enemy';

  @override
  String get kCombustNote =>
      'Combust — very close to the Sun, so its independent voice is dimmed.';

  @override
  String get kWhatThisMeans => 'What this means for you';

  @override
  String get ovStrengthStrong => 'strong';

  @override
  String get ovStrengthSteady => 'steady';

  @override
  String get ovStrengthStrain => 'under strain';

  @override
  String get ovStrengthWeak => 'weak';

  @override
  String get ovRoleSpouse => 'Spouse significator';

  @override
  String get ovRoleDarakaraka => 'Darakaraka (Jaimini)';

  @override
  String get ovRoleWealth => 'Wealth significator';

  @override
  String get ovRoleIntellect => 'Intellect significator';

  @override
  String get ovRoleWisdom => 'Wisdom significator';

  @override
  String get ovRoleFortune => 'Fortune significator';

  @override
  String get ovRoleFather => 'Father significator';

  @override
  String get ovRoleMother => 'Mother significator';

  @override
  String get ovRoleGeneric => 'Significator';

  @override
  String ovfPada(int pada) {
    return 'pada $pada';
  }

  @override
  String ovfLagnaSign(Object sign) {
    return 'Rising sign $sign';
  }

  @override
  String ovfLagnaLord(Object planet, Object nthHouse, Object dignity) {
    return 'Ascendant lord $planet in the $nthHouse$dignity';
  }

  @override
  String ovfHouseLord(Object ordinal, Object planet, Object nthHouse) {
    return '$ordinal-house lord $planet in the $nthHouse';
  }

  @override
  String ovfHouseStrength(Object ordinal, Object strength) {
    return '$ordinal house — $strength';
  }

  @override
  String ovfMoonSign(Object sign) {
    return 'Moon in $sign';
  }

  @override
  String ovfMoonHouse(Object nthHouse) {
    return 'Moon in the $nthHouse';
  }

  @override
  String ovfMoonNakshatra(Object nakshatra) {
    return 'Moon nakshatra $nakshatra';
  }

  @override
  String ovfMoonDignity(Object dignity) {
    return 'Moon $dignity';
  }

  @override
  String ovfSunSign(Object sign) {
    return 'Sun in $sign';
  }

  @override
  String ovfSeventhSign(Object sign) {
    return '7th house in $sign';
  }

  @override
  String ovfPlanetInHouse(Object planet, Object nthHouse) {
    return '$planet in the $nthHouse';
  }

  @override
  String ovfPlanetWithMoon(Object planet) {
    return '$planet with the Moon';
  }

  @override
  String ovfAppearanceIn(Object planet) {
    return '$planet in the 1st house';
  }

  @override
  String ovfAppearanceAspect(Object planet) {
    return '$planet aspecting the 1st house';
  }

  @override
  String ovfMaleficOnLagna(Object planet) {
    return '$planet pressing on the ascendant';
  }

  @override
  String ovfKaraka(Object role, Object planet) {
    return '$role: $planet';
  }

  @override
  String ovfYoga(Object name) {
    return 'Yoga — $name';
  }

  @override
  String ovfDosha(Object name) {
    return 'Dosha — $name';
  }

  @override
  String get doshaMangalName => 'Mangal Dosha';

  @override
  String get doshaMangalMeaning =>
      'Mars in a sensitive house — traditionally weighed before marriage. Often balanced when both partners are Manglik or Jupiter influences Mars.';

  @override
  String get doshaKaalSarpaName => 'Kaal Sarpa Dosha';

  @override
  String get doshaKaalSarpaMeaning =>
      'The whole chart held between Rahu and Ketu — life can feel hemmed in until a clear direction is found, then focus becomes intense.';

  @override
  String get doshaPitraName => 'Pitra Dosha';

  @override
  String get doshaPitraMeaning =>
      'The Sun and 9th house carry a shadow of ancestral karma — often addressed with shraddha and charity in the father\'s name.';

  @override
  String get doshaGandmoolName => 'Gandmool Dosha';

  @override
  String get doshaGandmoolMeaning =>
      'The Moon sits at a junction nakshatra. A Shanti puja on the 27th day is the traditional response.';

  @override
  String get doshaGrahanName => 'Grahan Dosha';

  @override
  String get doshaGrahanMeaning =>
      'A luminary (Sun or Moon) sits with a node, so that planet\'s significations dim until worked on.';

  @override
  String get doshaShrapitName => 'Shrapit Dosha';

  @override
  String get doshaShrapitMeaning =>
      'Saturn with Rahu — delay and confusion early on; steady, patient effort is the way through.';

  @override
  String get doshaGuruChandalName => 'Guru Chandal Dosha';

  @override
  String get doshaGuruChandalMeaning =>
      'Jupiter with a node — wisdom mixed with unorthodox ideas; choose your teachers and beliefs with care.';

  @override
  String get doshaAngarakName => 'Angarak Dosha';

  @override
  String get doshaAngarakMeaning =>
      'Mars with a node — an impulsive charge; anger, accidents and property disputes need care.';

  @override
  String get doshaKemadrumaName => 'Kemadruma Dosha';

  @override
  String get doshaKemadrumaMeaning =>
      'The Moon stands alone with no support around it — it eases when a kendra is occupied or the Moon is strong.';

  @override
  String get doshaDaridraName => 'Daridra Dosha';

  @override
  String get doshaDaridraMeaning =>
      'The money houses are strained — disciplined saving and a strong dasha turn it around.';

  @override
  String get birthDetailsCta => 'Full birth details';

  @override
  String get birthDetailsTitle => 'Birth details';

  @override
  String get birthDetailsAyanamsa => 'Ayanamsha';

  @override
  String get birthDetailsPanchangTitle => 'Panchang at birth';

  @override
  String get birthDetailsChakraTitle => 'Avakahada Chakra';

  @override
  String get birthDetailsWeekday => 'Weekday';

  @override
  String get birthDetailsTithi => 'Tithi';

  @override
  String get birthDetailsNakshatra => 'Nakshatra';

  @override
  String get birthDetailsYoga => 'Yoga';

  @override
  String get birthDetailsKarana => 'Karana';

  @override
  String get birthDetailsMoonSign => 'Moon sign';

  @override
  String get birthDetailsSunSign => 'Sun sign';

  @override
  String get birthDetailsSuryaNakshatra => 'Sun\'s nakshatra';

  @override
  String get birthDetailsSunrise => 'Sunrise';

  @override
  String get birthDetailsSunset => 'Sunset';

  @override
  String get birthDetailsIshtaKala => 'Ishta Kala';

  @override
  String birthDetailsPada(int count) {
    return 'Pada $count';
  }

  @override
  String birthDetailsGhatiPala(int ghati, int pala, int vipala) {
    return '$ghati ghati $pala pala $vipala vipala';
  }

  @override
  String get birthDetailsNakshatraLord => 'Nakshatra lord';

  @override
  String get birthDetailsRashiLord => 'Rashi lord';

  @override
  String get birthDetailsVarna => 'Varna';

  @override
  String get birthDetailsVashya => 'Vashya';

  @override
  String get birthDetailsYoni => 'Yoni';

  @override
  String get birthDetailsGana => 'Gana';

  @override
  String get birthDetailsNadi => 'Nadi';

  @override
  String get birthDetailsTara => 'Tara';

  @override
  String get birthDetailsTattva => 'Tattva';

  @override
  String get birthDetailsYunja => 'Yunja';

  @override
  String get birthDetailsRashiPaya => 'Rashi Paya';

  @override
  String get birthDetailsNakshatraPaya => 'Nakshatra Paya';

  @override
  String get birthDetailsDisclaimer =>
      'Classical classificatory attributes — used mainly in muhurta and matchmaking, not predictions.';

  @override
  String get vaaraMonday => 'Somvara (Monday)';

  @override
  String get vaaraTuesday => 'Mangalvara (Tuesday)';

  @override
  String get vaaraWednesday => 'Budhvara (Wednesday)';

  @override
  String get vaaraThursday => 'Guruvara (Thursday)';

  @override
  String get vaaraFriday => 'Shukravara (Friday)';

  @override
  String get vaaraSaturday => 'Shanivara (Saturday)';

  @override
  String get vaaraSunday => 'Ravivara (Sunday)';

  @override
  String get tattvaFire => 'Agni (Fire)';

  @override
  String get tattvaEarth => 'Prithvi (Earth)';

  @override
  String get tattvaAir => 'Vayu (Air)';

  @override
  String get tattvaWater => 'Jala (Water)';

  @override
  String get payaGold => 'Gold';

  @override
  String get payaSilver => 'Silver';

  @override
  String get payaCopper => 'Copper';

  @override
  String get payaIron => 'Iron';

  @override
  String get roomAppBarTitle => 'Consultation';

  @override
  String get roomOpenError => 'We couldn\'t open this consultation.';

  @override
  String roomWaitingTitle(String name) {
    return 'Waiting for $name to accept';
  }

  @override
  String get roomWaitingBody =>
      'Usually under a minute. We\'ll open the chat the moment they join.';

  @override
  String get roomCancelRequest => 'Cancel request';

  @override
  String get roomEndConfirmTitle => 'End this consultation?';

  @override
  String get roomEndConfirmBody => 'Billing stops when the session ends.';

  @override
  String get roomKeepTalking => 'Keep talking';

  @override
  String get roomEnd => 'End';

  @override
  String get roomAutoTranslateOn => 'Auto-translate on';

  @override
  String get roomAutoTranslateOff => 'Auto-translate off';

  @override
  String get roomEndedTitle => 'Consultation ended';

  @override
  String get roomBalanceOutTitle => 'Your balance ran out';

  @override
  String roomBalanceOutBody(String name) {
    return 'The chat ended because your wallet balance finished. Recharge and start again to continue with $name.';
  }

  @override
  String get roomRechargeWallet => 'Recharge wallet';

  @override
  String roomStartAgain(String name) {
    return 'Start again with $name';
  }

  @override
  String get roomRowAstrologer => 'Astrologer';

  @override
  String get roomRowDuration => 'Duration';

  @override
  String get roomRowAmount => 'Amount';

  @override
  String get roomRowRate => 'Rate';

  @override
  String roomMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String roomRatePerMinute(String currency, String amount) {
    return '$currency $amount/min';
  }

  @override
  String get roomRateQuestion => 'How was your consultation?';

  @override
  String get roomSubmitRating => 'Submit rating';

  @override
  String get roomRatingThanks => 'Thanks for the feedback!';

  @override
  String get roomBackHome => 'Back to home';

  @override
  String get roomStatusRejected => 'The astrologer couldn\'t take this request';

  @override
  String get roomStatusCancelled => 'Request cancelled';

  @override
  String get roomStatusExpired => 'Request expired — no response in time';

  @override
  String get roomStatusNoShow => 'The call did not connect';

  @override
  String get roomStatusClosed => 'Consultation closed';

  @override
  String get roomBalanceRunningOut => 'Balance is running out';

  @override
  String roomMinLeftRecharge(int minutes) {
    return '~$minutes min left · recharge to keep talking';
  }

  @override
  String roomSpentMinLeft(String currency, String amount, int minutes) {
    return '$currency $amount spent · ~$minutes min left';
  }

  @override
  String get roomAddMoney => 'Add money';

  @override
  String get roomClientBalanceLow => 'Client\'s balance is low — wrap up soon';

  @override
  String get navChats => 'Chats';

  @override
  String get chatsTitle => 'Chats';

  @override
  String get chatsLoadError => 'We couldn\'t load your chats.';

  @override
  String get chatsEmptyTitle => 'No chats yet';

  @override
  String get chatsEmptyBody =>
      'Start a consultation with an astrologer and it shows up here.';

  @override
  String get chatsSectionActive => 'Active';

  @override
  String get chatsSectionRecent => 'Recent';

  @override
  String get chatsAstrologerFallback => 'Astrologer';

  @override
  String get chatsStatusWaiting => 'Waiting for the astrologer to accept';

  @override
  String get chatsStatusLive => 'Live now · tap to open';

  @override
  String chatsStatusEnded(int minutes) {
    return '$minutes min consultation';
  }

  @override
  String get chatsStatusCancelled => 'Cancelled';

  @override
  String get chatsStatusRejected => 'Not accepted';

  @override
  String get chatsStatusExpired => 'Request expired';

  @override
  String get chatsStatusGeneric => 'Consultation';

  @override
  String get numerologyTitle => 'Numerology & Lo Shu grid';

  @override
  String get numerologyIntro =>
      'A traditional numbers reading from your date of birth (and name) — the tendencies each number leans towards, favourable days and colours, and your Lo Shu birth grid. For reflection, not dated prediction.';

  @override
  String get numMoolank => 'Moolank · psychic number';

  @override
  String get numBhagyank => 'Bhagyank · destiny number';

  @override
  String get numNaamank => 'Naamank · name number';

  @override
  String numRuledBy(String planet) {
    return 'Ruled by $planet';
  }

  @override
  String get numFriendly => 'Friendly';

  @override
  String get numNeutral => 'Neutral';

  @override
  String get numUnfriendly => 'Clashing';

  @override
  String get numFavDays => 'Favourable days';

  @override
  String get numFavColours => 'Favourable colours';

  @override
  String get numDirection => 'Direction';

  @override
  String get numDeity => 'Deity';

  @override
  String get numGemstone => 'Traditional gemstone';

  @override
  String get numLoShuTitle => 'Lo Shu birth grid';

  @override
  String numLoShuMissing(String nums) {
    return 'Not in your grid: $nums';
  }

  @override
  String numLoShuRepeated(String nums) {
    return 'Emphasised: $nums';
  }

  @override
  String get numArrowStrength => 'Complete line';

  @override
  String get numArrowAbsence => 'Absent line';

  @override
  String get numAskCta => 'Talk to an astrologer about this';

  @override
  String get sadeSatiTitle => 'Sade Sati & Dhaiya calendar';

  @override
  String sadeSatiIntro(String sign) {
    return 'The dated Saturn windows over your life, reckoned from your Moon sign $sign. Sade Sati is Saturn through the 12th, 1st and 2nd from the Moon (~7½ years); Dhaiya is the 4th or 8th (~2½ years).';
  }

  @override
  String get sadeSatiRunningNow => 'Running now';

  @override
  String get sadeSatiPast => 'Past';

  @override
  String get sadeSatiUpcoming => 'Upcoming';

  @override
  String get sadeSatiPhaseRising => 'Rising · Saturn in the 12th';

  @override
  String get sadeSatiPhasePeak => 'Peak · Saturn over the Moon';

  @override
  String get sadeSatiPhaseSetting => 'Setting · Saturn in the 2nd';

  @override
  String get sadeSatiPhaseKantaka => 'Kantaka · Saturn in the 4th';

  @override
  String get sadeSatiPhaseAshtama => 'Ashtama · Saturn in the 8th';

  @override
  String get sadeSatiDhaiyaHeading => 'Dhaiya (small panoti) periods';

  @override
  String sadeSatiRange(String start, String end) {
    return '$start → $end';
  }

  @override
  String get avTransitHeading => 'Ashtakavarga strength of today\'s transits';

  @override
  String get avTransitIntro =>
      'How freely each planet\'s transit gives its results, from your natal bindu scores. 5+ of 8 is supportive, 4 mixed, less is weak.';

  @override
  String avTransitBindus(int bindus) {
    return '$bindus/8 bindus';
  }

  @override
  String get avTransitUpcoming => 'Coming up';

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
  String get errNetwork => 'Could not reach the server. Check your connection.';

  @override
  String get errTimeout => 'The server took too long to respond.';

  @override
  String get errSession => 'Your session expired. Please sign in again.';

  @override
  String get errWalletInsufficient =>
      'Your wallet balance is too low for this.';

  @override
  String get errRateLimited =>
      'Too many attempts. Please wait a little and try again.';

  @override
  String get errOtpInvalid => 'The code is incorrect or has expired.';

  @override
  String get errOtpMaxAttempts =>
      'Too many wrong attempts. Request a new code.';

  @override
  String get errPromoNotRedeemable => 'This coupon code can\'t be used.';

  @override
  String get errRechargeInvalidAmount =>
      'Enter an amount within the allowed range.';

  @override
  String get errAuthWrongApp =>
      'This number is registered for the other TalkAcharya app.';

  @override
  String get errGeneric => 'Something went wrong. Please try again.';

  @override
  String get homePanchangTitle => 'Today\'s Panchang';

  @override
  String get homeLiveNowTitle => 'Live now';

  @override
  String get homeFreeToolsTitle => 'Free tools';

  @override
  String get homeResumeBtn => 'Resume';

  @override
  String get homeAddBtn => 'Add';

  @override
  String get homeNotifyMeBtn => 'Notify me';

  @override
  String get homeKundaliAction => 'Kundali';

  @override
  String get homeMatchingAction => 'Matching';

  @override
  String get homeHoroscopeAction => 'Horoscope';

  @override
  String get homeVastuAction => 'Vastu';

  @override
  String get homeRetryBtn => 'Retry';

  @override
  String get homeChooseSignTitle => 'Choose your sign';

  @override
  String get homeChooseLanguageTitle => 'Choose language';

  @override
  String get homeLanguageTooltip => 'Language';

  @override
  String homeLanguageSwitchError(String error) {
    return 'Could not switch: $error';
  }

  @override
  String get homeComingSoonSnackbar => 'Coming soon!';

  @override
  String get homeTalkAgainTitle => 'Talk again';

  @override
  String get homeRechargeWalletTitle => 'Recharge your wallet';

  @override
  String get homeTalkToAstrologerTitle => 'Talk to an astrologer';

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
