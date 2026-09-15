import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_bn.dart';
import 'app_localizations_en.dart';
import 'app_localizations_gu.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_kn.dart';
import 'app_localizations_mr.dart';
import 'app_localizations_ta.dart';
import 'app_localizations_te.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('bn'),
    Locale('en'),
    Locale('gu'),
    Locale('hi'),
    Locale('kn'),
    Locale('mr'),
    Locale('ta'),
    Locale('te'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'TalkAcharya'**
  String get appName;

  /// No description provided for @commonOk.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get commonOk;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get commonDone;

  /// No description provided for @commonNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get commonNext;

  /// No description provided for @commonBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get commonBack;

  /// No description provided for @commonRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get commonRetry;

  /// No description provided for @commonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonSave;

  /// No description provided for @commonEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get commonEdit;

  /// No description provided for @commonDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get commonDelete;

  /// No description provided for @commonClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get commonClose;

  /// No description provided for @commonContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get commonContinue;

  /// No description provided for @commonConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get commonConfirm;

  /// No description provided for @commonSeeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get commonSeeAll;

  /// No description provided for @commonViewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get commonViewAll;

  /// No description provided for @commonShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get commonShare;

  /// No description provided for @commonCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get commonCopy;

  /// No description provided for @commonCopied.
  ///
  /// In en, this message translates to:
  /// **'Copied'**
  String get commonCopied;

  /// No description provided for @commonApply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get commonApply;

  /// No description provided for @commonSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get commonSearch;

  /// No description provided for @commonYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get commonYes;

  /// No description provided for @commonNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get commonNo;

  /// No description provided for @commonLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading…'**
  String get commonLoading;

  /// No description provided for @commonSomethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get commonSomethingWentWrong;

  /// No description provided for @commonCheckConnection.
  ///
  /// In en, this message translates to:
  /// **'Check your internet connection and try again'**
  String get commonCheckConnection;

  /// No description provided for @commonComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get commonComingSoon;

  /// No description provided for @commonToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get commonToday;

  /// No description provided for @commonYesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get commonYesterday;

  /// No description provided for @commonMinutesShort.
  ///
  /// In en, this message translates to:
  /// **'{count} min'**
  String commonMinutesShort(int count);

  /// No description provided for @commonOffline.
  ///
  /// In en, this message translates to:
  /// **'You are offline'**
  String get commonOffline;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navAstrologers.
  ///
  /// In en, this message translates to:
  /// **'Astrologers'**
  String get navAstrologers;

  /// No description provided for @navLive.
  ///
  /// In en, this message translates to:
  /// **'Live'**
  String get navLive;

  /// No description provided for @navWallet.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get navWallet;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @authWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Talk to trusted astrologers'**
  String get authWelcomeTitle;

  /// No description provided for @authWelcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Chat or call for guidance on love, career, money and more'**
  String get authWelcomeSubtitle;

  /// No description provided for @authPhoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your mobile number'**
  String get authPhoneTitle;

  /// No description provided for @authPhoneSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your mobile number and we\'ll send you a one-time code.'**
  String get authPhoneSubtitle;

  /// No description provided for @authOtpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We sent a 6-digit code to {phone}.'**
  String authOtpSubtitle(String phone);

  /// No description provided for @authTestModeCode.
  ///
  /// In en, this message translates to:
  /// **'Test mode — your code is {code}'**
  String authTestModeCode(String code);

  /// No description provided for @authPhoneHint.
  ///
  /// In en, this message translates to:
  /// **'Mobile number'**
  String get authPhoneHint;

  /// No description provided for @authPhoneHelper.
  ///
  /// In en, this message translates to:
  /// **'We will send a one-time code by SMS'**
  String get authPhoneHelper;

  /// No description provided for @authGetOtp.
  ///
  /// In en, this message translates to:
  /// **'Get OTP'**
  String get authGetOtp;

  /// No description provided for @authOtpTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit code'**
  String get authOtpTitle;

  /// No description provided for @authOtpSentTo.
  ///
  /// In en, this message translates to:
  /// **'Sent to {phone}'**
  String authOtpSentTo(String phone);

  /// No description provided for @authOtpResend.
  ///
  /// In en, this message translates to:
  /// **'Resend code'**
  String get authOtpResend;

  /// No description provided for @authOtpResendIn.
  ///
  /// In en, this message translates to:
  /// **'Resend in {seconds}s'**
  String authOtpResendIn(int seconds);

  /// No description provided for @authVerify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get authVerify;

  /// No description provided for @authChangeNumber.
  ///
  /// In en, this message translates to:
  /// **'Change number'**
  String get authChangeNumber;

  /// No description provided for @authInvalidPhone.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid mobile number'**
  String get authInvalidPhone;

  /// No description provided for @authInvalidOtp.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit code'**
  String get authInvalidOtp;

  /// No description provided for @authWrongApp.
  ///
  /// In en, this message translates to:
  /// **'This number is registered for the astrologer app'**
  String get authWrongApp;

  /// No description provided for @authDevCode.
  ///
  /// In en, this message translates to:
  /// **'Dev code: {code}'**
  String authDevCode(String code);

  /// No description provided for @authTermsNotice.
  ///
  /// In en, this message translates to:
  /// **'By continuing you agree to our Terms and Privacy Policy'**
  String get authTermsNotice;

  /// No description provided for @authLogout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get authLogout;

  /// No description provided for @authLogoutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Log out of TalkAcharya? You will need to sign in again.'**
  String get authLogoutConfirm;

  /// No description provided for @homeGreeting.
  ///
  /// In en, this message translates to:
  /// **'Namaste, {name}'**
  String homeGreeting(String name);

  /// No description provided for @homeGuidanceTagline.
  ///
  /// In en, this message translates to:
  /// **'Guidance, whenever you need it'**
  String get homeGuidanceTagline;

  /// No description provided for @homeGreetingFallbackName.
  ///
  /// In en, this message translates to:
  /// **'there'**
  String get homeGreetingFallbackName;

  /// No description provided for @walletAddShort.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get walletAddShort;

  /// No description provided for @homeChatNow.
  ///
  /// In en, this message translates to:
  /// **'Chat now'**
  String get homeChatNow;

  /// No description provided for @homeCallNow.
  ///
  /// In en, this message translates to:
  /// **'Call now'**
  String get homeCallNow;

  /// No description provided for @homeFromPerMin.
  ///
  /// In en, this message translates to:
  /// **'from {price}/min'**
  String homeFromPerMin(String price);

  /// No description provided for @homeOnlineCount.
  ///
  /// In en, this message translates to:
  /// **'{count} online'**
  String homeOnlineCount(int count);

  /// No description provided for @homeOnlineNow.
  ///
  /// In en, this message translates to:
  /// **'Online now'**
  String get homeOnlineNow;

  /// No description provided for @homeTalkToAstrologer.
  ///
  /// In en, this message translates to:
  /// **'Talk to an astrologer'**
  String get homeTalkToAstrologer;

  /// No description provided for @homeLiveNow.
  ///
  /// In en, this message translates to:
  /// **'Live now'**
  String get homeLiveNow;

  /// No description provided for @homeWhatsOnYourMind.
  ///
  /// In en, this message translates to:
  /// **'What\'s on your mind?'**
  String get homeWhatsOnYourMind;

  /// No description provided for @homeTodaysHoroscope.
  ///
  /// In en, this message translates to:
  /// **'Today\'s horoscope'**
  String get homeTodaysHoroscope;

  /// No description provided for @homeChooseYourSign.
  ///
  /// In en, this message translates to:
  /// **'Choose your sign'**
  String get homeChooseYourSign;

  /// No description provided for @homeReadMore.
  ///
  /// In en, this message translates to:
  /// **'Read more'**
  String get homeReadMore;

  /// No description provided for @homeShowLess.
  ///
  /// In en, this message translates to:
  /// **'Show less'**
  String get homeShowLess;

  /// No description provided for @homeLuckToday.
  ///
  /// In en, this message translates to:
  /// **'Luck today · {rating}'**
  String homeLuckToday(String rating);

  /// No description provided for @homeTodaysPanchang.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Panchang'**
  String get homeTodaysPanchang;

  /// No description provided for @homePanchangAddProfile.
  ///
  /// In en, this message translates to:
  /// **'Add your birth details for a Panchang tuned to your place'**
  String get homePanchangAddProfile;

  /// No description provided for @homeFreeTools.
  ///
  /// In en, this message translates to:
  /// **'Free tools'**
  String get homeFreeTools;

  /// No description provided for @homeTalkAgain.
  ///
  /// In en, this message translates to:
  /// **'Talk again'**
  String get homeTalkAgain;

  /// No description provided for @homeAddMoneyGetBonus.
  ///
  /// In en, this message translates to:
  /// **'Add money, get bonus'**
  String get homeAddMoneyGetBonus;

  /// No description provided for @homeReferAFriend.
  ///
  /// In en, this message translates to:
  /// **'Refer a friend, both earn'**
  String get homeReferAFriend;

  /// No description provided for @homeReferShort.
  ///
  /// In en, this message translates to:
  /// **'Share your code — you both get wallet credit'**
  String get homeReferShort;

  /// No description provided for @homeReferYourCode.
  ///
  /// In en, this message translates to:
  /// **'Your code: {code}'**
  String homeReferYourCode(String code);

  /// No description provided for @homeInvite.
  ///
  /// In en, this message translates to:
  /// **'Invite'**
  String get homeInvite;

  /// No description provided for @homeResumeInProgress.
  ///
  /// In en, this message translates to:
  /// **'{channel} · in progress'**
  String homeResumeInProgress(String channel);

  /// No description provided for @homeResumePaused.
  ///
  /// In en, this message translates to:
  /// **'{channel} · paused'**
  String homeResumePaused(String channel);

  /// No description provided for @homeResume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get homeResume;

  /// No description provided for @homeTrustVerified.
  ///
  /// In en, this message translates to:
  /// **'Every astrologer is ID-verified before they go live'**
  String get homeTrustVerified;

  /// No description provided for @homeTrustPrivate.
  ///
  /// In en, this message translates to:
  /// **'100% private and confidential consultations'**
  String get homeTrustPrivate;

  /// No description provided for @homeTrustVolume.
  ///
  /// In en, this message translates to:
  /// **'Thousands of consultations every week'**
  String get homeTrustVolume;

  /// No description provided for @homeCouldntLoadAstrologers.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load astrologers'**
  String get homeCouldntLoadAstrologers;

  /// No description provided for @homeCouldntLoadReading.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t fetch today\'s reading'**
  String get homeCouldntLoadReading;

  /// No description provided for @homeCouldntLoadPanchang.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load the Panchang'**
  String get homeCouldntLoadPanchang;

  /// No description provided for @homeNoAstrologersFilter.
  ///
  /// In en, this message translates to:
  /// **'No astrologers match this filter right now'**
  String get homeNoAstrologersFilter;

  /// No description provided for @concernLove.
  ///
  /// In en, this message translates to:
  /// **'Love'**
  String get concernLove;

  /// No description provided for @concernMarriage.
  ///
  /// In en, this message translates to:
  /// **'Marriage'**
  String get concernMarriage;

  /// No description provided for @concernCareer.
  ///
  /// In en, this message translates to:
  /// **'Career'**
  String get concernCareer;

  /// No description provided for @concernFinance.
  ///
  /// In en, this message translates to:
  /// **'Finance'**
  String get concernFinance;

  /// No description provided for @concernHealth.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get concernHealth;

  /// No description provided for @concernEducation.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get concernEducation;

  /// No description provided for @concernBusiness.
  ///
  /// In en, this message translates to:
  /// **'Business'**
  String get concernBusiness;

  /// No description provided for @concernLegal.
  ///
  /// In en, this message translates to:
  /// **'Legal'**
  String get concernLegal;

  /// No description provided for @channelChat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get channelChat;

  /// No description provided for @channelCall.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get channelCall;

  /// No description provided for @channelVoice.
  ///
  /// In en, this message translates to:
  /// **'Voice call'**
  String get channelVoice;

  /// No description provided for @channelVideo.
  ///
  /// In en, this message translates to:
  /// **'Video call'**
  String get channelVideo;

  /// No description provided for @channelAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get channelAll;

  /// No description provided for @astroFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get astroFilterAll;

  /// No description provided for @astroSortRecommended.
  ///
  /// In en, this message translates to:
  /// **'Recommended'**
  String get astroSortRecommended;

  /// No description provided for @astroSortTopRated.
  ///
  /// In en, this message translates to:
  /// **'Top rated'**
  String get astroSortTopRated;

  /// No description provided for @astroSortExperienced.
  ///
  /// In en, this message translates to:
  /// **'Most experienced'**
  String get astroSortExperienced;

  /// No description provided for @astroSortConsulted.
  ///
  /// In en, this message translates to:
  /// **'Most consulted'**
  String get astroSortConsulted;

  /// No description provided for @astroSortNew.
  ///
  /// In en, this message translates to:
  /// **'New here'**
  String get astroSortNew;

  /// No description provided for @astroOnline.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get astroOnline;

  /// No description provided for @astroBusy.
  ///
  /// In en, this message translates to:
  /// **'Busy'**
  String get astroBusy;

  /// No description provided for @astroNotifyMe.
  ///
  /// In en, this message translates to:
  /// **'Notify me'**
  String get astroNotifyMe;

  /// No description provided for @astroWaitMinutes.
  ///
  /// In en, this message translates to:
  /// **'~{count} min wait'**
  String astroWaitMinutes(int count);

  /// No description provided for @astroPerMinute.
  ///
  /// In en, this message translates to:
  /// **'{price}/min'**
  String astroPerMinute(String price);

  /// No description provided for @astroYearsExp.
  ///
  /// In en, this message translates to:
  /// **'{count} yrs exp'**
  String astroYearsExp(int count);

  /// No description provided for @astroRatingNew.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get astroRatingNew;

  /// No description provided for @astroSessionsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} sessions'**
  String astroSessionsCount(String count);

  /// No description provided for @astroSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search by name, skill or language'**
  String get astroSearchHint;

  /// No description provided for @astroNoneFound.
  ///
  /// In en, this message translates to:
  /// **'No astrologers found'**
  String get astroNoneFound;

  /// No description provided for @astroNoneFoundHint.
  ///
  /// In en, this message translates to:
  /// **'Try removing a filter or searching for something else'**
  String get astroNoneFoundHint;

  /// No description provided for @astroThatsEveryone.
  ///
  /// In en, this message translates to:
  /// **'That\'s everyone for now'**
  String get astroThatsEveryone;

  /// No description provided for @astroRateOnRequest.
  ///
  /// In en, this message translates to:
  /// **'Rate on request'**
  String get astroRateOnRequest;

  /// No description provided for @astroCouldntLoad.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load astrologers'**
  String get astroCouldntLoad;

  /// No description provided for @astroSortBy.
  ///
  /// In en, this message translates to:
  /// **'Sort by'**
  String get astroSortBy;

  /// No description provided for @astroLoadMoreFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load more'**
  String get astroLoadMoreFailed;

  /// No description provided for @astroDefaultSkill.
  ///
  /// In en, this message translates to:
  /// **'Vedic astrology'**
  String get astroDefaultSkill;

  /// No description provided for @astroYears.
  ///
  /// In en, this message translates to:
  /// **'{count} yrs'**
  String astroYears(int count);

  /// No description provided for @astroSessions.
  ///
  /// In en, this message translates to:
  /// **'{count} sessions'**
  String astroSessions(String count);

  /// No description provided for @astroChat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get astroChat;

  /// No description provided for @astroCall.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get astroCall;

  /// No description provided for @astroVideo.
  ///
  /// In en, this message translates to:
  /// **'Video'**
  String get astroVideo;

  /// No description provided for @astroProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Astrologer'**
  String get astroProfileTitle;

  /// No description provided for @astroExpertiseTitle.
  ///
  /// In en, this message translates to:
  /// **'Expertise'**
  String get astroExpertiseTitle;

  /// No description provided for @astroAboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get astroAboutTitle;

  /// No description provided for @astroRatesTitle.
  ///
  /// In en, this message translates to:
  /// **'Consultation rates'**
  String get astroRatesTitle;

  /// No description provided for @astroReviewsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No reviews yet} one{1 review} other{{count} reviews}}'**
  String astroReviewsCount(int count);

  /// No description provided for @astroStatRating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get astroStatRating;

  /// No description provided for @astroStatExperience.
  ///
  /// In en, this message translates to:
  /// **'Experience'**
  String get astroStatExperience;

  /// No description provided for @astroStatSessions.
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get astroStatSessions;

  /// No description provided for @astroStatRepeatClients.
  ///
  /// In en, this message translates to:
  /// **'Repeat clients'**
  String get astroStatRepeatClients;

  /// No description provided for @astroSpeaks.
  ///
  /// In en, this message translates to:
  /// **'Speaks {languages}'**
  String astroSpeaks(String languages);

  /// No description provided for @astroRepliesIn.
  ///
  /// In en, this message translates to:
  /// **'Replies in ~{time}'**
  String astroRepliesIn(String time);

  /// No description provided for @astroOnlineNow.
  ///
  /// In en, this message translates to:
  /// **'Online now'**
  String get astroOnlineNow;

  /// No description provided for @astroOfflineTitle.
  ///
  /// In en, this message translates to:
  /// **'Currently offline'**
  String get astroOfflineTitle;

  /// No description provided for @astroNotifyWhenOnline.
  ///
  /// In en, this message translates to:
  /// **'Notify me when online'**
  String get astroNotifyWhenOnline;

  /// No description provided for @astroReadMore.
  ///
  /// In en, this message translates to:
  /// **'Read more'**
  String get astroReadMore;

  /// No description provided for @astroReadLess.
  ///
  /// In en, this message translates to:
  /// **'Show less'**
  String get astroReadLess;

  /// No description provided for @astroCouldntLoadOne.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load this astrologer'**
  String get astroCouldntLoadOne;

  /// No description provided for @astroCallsComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Voice & video calls are coming soon'**
  String get astroCallsComingSoon;

  /// No description provided for @astroTrustLine.
  ///
  /// In en, this message translates to:
  /// **'ID-verified · Private & confidential · Pay by the minute'**
  String get astroTrustLine;

  /// No description provided for @walletTitle.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get walletTitle;

  /// No description provided for @walletAvailableBalance.
  ///
  /// In en, this message translates to:
  /// **'Available balance'**
  String get walletAvailableBalance;

  /// No description provided for @walletOnHold.
  ///
  /// In en, this message translates to:
  /// **'{amount} on hold'**
  String walletOnHold(String amount);

  /// No description provided for @walletOnHoldReason.
  ///
  /// In en, this message translates to:
  /// **'{amount} on hold · a call is running'**
  String walletOnHoldReason(String amount);

  /// No description provided for @walletAddMoney.
  ///
  /// In en, this message translates to:
  /// **'Add money'**
  String get walletAddMoney;

  /// No description provided for @walletRecentActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent activity'**
  String get walletRecentActivity;

  /// No description provided for @walletTransactions.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get walletTransactions;

  /// No description provided for @walletHowItWorksTitle.
  ///
  /// In en, this message translates to:
  /// **'How the wallet works'**
  String get walletHowItWorksTitle;

  /// No description provided for @walletHowItWorksBody.
  ///
  /// In en, this message translates to:
  /// **'Wallet balance is used only for consultations and never expires. Unused balance is refundable — see our refund policy.'**
  String get walletHowItWorksBody;

  /// No description provided for @walletRefundPolicy.
  ///
  /// In en, this message translates to:
  /// **'Refund policy'**
  String get walletRefundPolicy;

  /// No description provided for @walletHaveCoupon.
  ///
  /// In en, this message translates to:
  /// **'Have a coupon code?'**
  String get walletHaveCoupon;

  /// No description provided for @walletCouponHint.
  ///
  /// In en, this message translates to:
  /// **'Enter code'**
  String get walletCouponHint;

  /// No description provided for @walletCouponApplied.
  ///
  /// In en, this message translates to:
  /// **'{amount} added to your wallet'**
  String walletCouponApplied(String amount);

  /// No description provided for @walletSecuredBy.
  ///
  /// In en, this message translates to:
  /// **'Secured by Razorpay · UPI · Cards · Netbanking'**
  String get walletSecuredBy;

  /// No description provided for @walletGstInvoices.
  ///
  /// In en, this message translates to:
  /// **'GST invoices'**
  String get walletGstInvoices;

  /// No description provided for @walletInvoicesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Invoices and receipts for your recharges'**
  String get walletInvoicesSubtitle;

  /// No description provided for @walletNoTransactions.
  ///
  /// In en, this message translates to:
  /// **'No transactions yet'**
  String get walletNoTransactions;

  /// No description provided for @walletNoTransactionsHint.
  ///
  /// In en, this message translates to:
  /// **'Add money to your wallet to get started'**
  String get walletNoTransactionsHint;

  /// No description provided for @walletBalanceAfter.
  ///
  /// In en, this message translates to:
  /// **'Bal {amount}'**
  String walletBalanceAfter(String amount);

  /// No description provided for @walletFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get walletFilterAll;

  /// No description provided for @walletFilterRecharge.
  ///
  /// In en, this message translates to:
  /// **'Added'**
  String get walletFilterRecharge;

  /// No description provided for @walletFilterConsultation.
  ///
  /// In en, this message translates to:
  /// **'Consultations'**
  String get walletFilterConsultation;

  /// No description provided for @walletFilterRefund.
  ///
  /// In en, this message translates to:
  /// **'Refunds'**
  String get walletFilterRefund;

  /// No description provided for @walletFilterBonus.
  ///
  /// In en, this message translates to:
  /// **'Bonus'**
  String get walletFilterBonus;

  /// No description provided for @kindRecharge.
  ///
  /// In en, this message translates to:
  /// **'Money added'**
  String get kindRecharge;

  /// No description provided for @kindConsultationCharge.
  ///
  /// In en, this message translates to:
  /// **'Consultation'**
  String get kindConsultationCharge;

  /// No description provided for @kindConsultationRefund.
  ///
  /// In en, this message translates to:
  /// **'Refund'**
  String get kindConsultationRefund;

  /// No description provided for @kindPromoCredit.
  ///
  /// In en, this message translates to:
  /// **'Promo credit'**
  String get kindPromoCredit;

  /// No description provided for @kindCouponDiscount.
  ///
  /// In en, this message translates to:
  /// **'Coupon discount'**
  String get kindCouponDiscount;

  /// No description provided for @kindSignupBonus.
  ///
  /// In en, this message translates to:
  /// **'Signup bonus'**
  String get kindSignupBonus;

  /// No description provided for @kindReferralBonus.
  ///
  /// In en, this message translates to:
  /// **'Referral bonus'**
  String get kindReferralBonus;

  /// No description provided for @kindAdjustment.
  ///
  /// In en, this message translates to:
  /// **'Adjustment'**
  String get kindAdjustment;

  /// No description provided for @kindGiftSpend.
  ///
  /// In en, this message translates to:
  /// **'Gift sent'**
  String get kindGiftSpend;

  /// No description provided for @kindHold.
  ///
  /// In en, this message translates to:
  /// **'Reserved for a call'**
  String get kindHold;

  /// No description provided for @kindChargeback.
  ///
  /// In en, this message translates to:
  /// **'Chargeback'**
  String get kindChargeback;

  /// No description provided for @rechargeChooseAmount.
  ///
  /// In en, this message translates to:
  /// **'Add money to wallet'**
  String get rechargeChooseAmount;

  /// No description provided for @rechargeAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get rechargeAmountLabel;

  /// No description provided for @rechargePayAmount.
  ///
  /// In en, this message translates to:
  /// **'Pay {amount}'**
  String rechargePayAmount(String amount);

  /// No description provided for @rechargeAddCoupon.
  ///
  /// In en, this message translates to:
  /// **'Add a coupon code'**
  String get rechargeAddCoupon;

  /// No description provided for @rechargeBonusBadge.
  ///
  /// In en, this message translates to:
  /// **'+{amount}'**
  String rechargeBonusBadge(String amount);

  /// No description provided for @rechargeStarterPack.
  ///
  /// In en, this message translates to:
  /// **'Starter'**
  String get rechargeStarterPack;

  /// No description provided for @rechargeMinAmount.
  ///
  /// In en, this message translates to:
  /// **'Minimum {amount}'**
  String rechargeMinAmount(String amount);

  /// No description provided for @rechargeMaxAmount.
  ///
  /// In en, this message translates to:
  /// **'Maximum {amount}'**
  String rechargeMaxAmount(String amount);

  /// No description provided for @rechargeOpeningCheckout.
  ///
  /// In en, this message translates to:
  /// **'Opening secure checkout…'**
  String get rechargeOpeningCheckout;

  /// No description provided for @rechargeConfirming.
  ///
  /// In en, this message translates to:
  /// **'Payment received — updating your balance…'**
  String get rechargeConfirming;

  /// No description provided for @rechargeSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'{amount} added'**
  String rechargeSuccessTitle(String amount);

  /// No description provided for @rechargeNewBalance.
  ///
  /// In en, this message translates to:
  /// **'New balance {amount}'**
  String rechargeNewBalance(String amount);

  /// No description provided for @rechargeViewTransaction.
  ///
  /// In en, this message translates to:
  /// **'View transaction'**
  String get rechargeViewTransaction;

  /// No description provided for @rechargeFailedTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment didn\'t go through'**
  String get rechargeFailedTitle;

  /// No description provided for @rechargeNotCharged.
  ///
  /// In en, this message translates to:
  /// **'You have not been charged.'**
  String get rechargeNotCharged;

  /// No description provided for @rechargeAutoRefund.
  ///
  /// In en, this message translates to:
  /// **'If any amount was debited, it will be refunded in 3–5 working days.'**
  String get rechargeAutoRefund;

  /// No description provided for @rechargeTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get rechargeTryAgain;

  /// No description provided for @rechargeChangeAmount.
  ///
  /// In en, this message translates to:
  /// **'Change amount'**
  String get rechargeChangeAmount;

  /// No description provided for @rechargeCreditedSoon.
  ///
  /// In en, this message translates to:
  /// **'Payment received. We\'ll credit it to your wallet in a moment.'**
  String get rechargeCreditedSoon;

  /// No description provided for @rechargeOfferAutoApplied.
  ///
  /// In en, this message translates to:
  /// **'Add {amount}, get {bonus} extra — auto-applied'**
  String rechargeOfferAutoApplied(String amount, String bonus);

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @profileEditProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get profileEditProfile;

  /// No description provided for @profilePhoneMasked.
  ///
  /// In en, this message translates to:
  /// **'+91 ●●●●● {last4}'**
  String profilePhoneMasked(String last4);

  /// No description provided for @profileCompleteAddEmail.
  ///
  /// In en, this message translates to:
  /// **'Add your email to finish your profile'**
  String get profileCompleteAddEmail;

  /// No description provided for @profileCompleteAddBirth.
  ///
  /// In en, this message translates to:
  /// **'Add your birth details for personalised readings'**
  String get profileCompleteAddBirth;

  /// No description provided for @profileRoleCustomer.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get profileRoleCustomer;

  /// No description provided for @profileWallet.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get profileWallet;

  /// No description provided for @profileBirthProfiles.
  ///
  /// In en, this message translates to:
  /// **'Birth profiles'**
  String get profileBirthProfiles;

  /// No description provided for @profileBirthProfilesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} charts'**
  String profileBirthProfilesCount(int count);

  /// No description provided for @profileGroupAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get profileGroupAccount;

  /// No description provided for @profileGroupMoney.
  ///
  /// In en, this message translates to:
  /// **'Money'**
  String get profileGroupMoney;

  /// No description provided for @profileGroupPreferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get profileGroupPreferences;

  /// No description provided for @profileGroupSupport.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get profileGroupSupport;

  /// No description provided for @profileGroupLegal.
  ///
  /// In en, this message translates to:
  /// **'Legal'**
  String get profileGroupLegal;

  /// No description provided for @profileNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get profileNotifications;

  /// No description provided for @profileNotificationPrefs.
  ///
  /// In en, this message translates to:
  /// **'Notification preferences'**
  String get profileNotificationPrefs;

  /// No description provided for @profileHapticFeedback.
  ///
  /// In en, this message translates to:
  /// **'Haptic feedback'**
  String get profileHapticFeedback;

  /// No description provided for @profileHapticFeedbackDesc.
  ///
  /// In en, this message translates to:
  /// **'Vibrate on buttons and interactions'**
  String get profileHapticFeedbackDesc;

  /// No description provided for @profileWalletAndTransactions.
  ///
  /// In en, this message translates to:
  /// **'Wallet and transactions'**
  String get profileWalletAndTransactions;

  /// No description provided for @profileOrders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get profileOrders;

  /// No description provided for @profileOrdersUnread.
  ///
  /// In en, this message translates to:
  /// **'{count} new'**
  String profileOrdersUnread(int count);

  /// No description provided for @profileReferAndEarn.
  ///
  /// In en, this message translates to:
  /// **'Refer and earn'**
  String get profileReferAndEarn;

  /// No description provided for @profileLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get profileLanguage;

  /// No description provided for @profileCurrency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get profileCurrency;

  /// No description provided for @profileHelpCentre.
  ///
  /// In en, this message translates to:
  /// **'Help centre'**
  String get profileHelpCentre;

  /// No description provided for @profileContactWhatsapp.
  ///
  /// In en, this message translates to:
  /// **'Contact us on WhatsApp'**
  String get profileContactWhatsapp;

  /// No description provided for @profileRateApp.
  ///
  /// In en, this message translates to:
  /// **'Rate TalkAcharya'**
  String get profileRateApp;

  /// No description provided for @profileShareApp.
  ///
  /// In en, this message translates to:
  /// **'Share the app'**
  String get profileShareApp;

  /// No description provided for @profileShareMessage.
  ///
  /// In en, this message translates to:
  /// **'I\'m using TalkAcharya to talk to astrologers. Try it: {link}'**
  String profileShareMessage(String link);

  /// No description provided for @profileTerms.
  ///
  /// In en, this message translates to:
  /// **'Terms of service'**
  String get profileTerms;

  /// No description provided for @profilePrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get profilePrivacy;

  /// No description provided for @profileLicenses.
  ///
  /// In en, this message translates to:
  /// **'Open-source licences'**
  String get profileLicenses;

  /// No description provided for @profileDeleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get profileDeleteAccount;

  /// No description provided for @profileVersion.
  ///
  /// In en, this message translates to:
  /// **'TalkAcharya · v{version} ({build})'**
  String profileVersion(String version, String build);

  /// No description provided for @editFullName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get editFullName;

  /// No description provided for @editDisplayName.
  ///
  /// In en, this message translates to:
  /// **'Display name'**
  String get editDisplayName;

  /// No description provided for @editDateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Date of birth'**
  String get editDateOfBirth;

  /// No description provided for @editGender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get editGender;

  /// No description provided for @editGenderMale.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get editGenderMale;

  /// No description provided for @editGenderFemale.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get editGenderFemale;

  /// No description provided for @editGenderOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get editGenderOther;

  /// No description provided for @editEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get editEmail;

  /// No description provided for @editEmailUnverified.
  ///
  /// In en, this message translates to:
  /// **'Not verified'**
  String get editEmailUnverified;

  /// No description provided for @editChangePhoto.
  ///
  /// In en, this message translates to:
  /// **'Change photo'**
  String get editChangePhoto;

  /// No description provided for @editProfileSaved.
  ///
  /// In en, this message translates to:
  /// **'Profile updated'**
  String get editProfileSaved;

  /// No description provided for @editProfileSaveError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t save your changes'**
  String get editProfileSaveError;

  /// No description provided for @editGenderUndisclosed.
  ///
  /// In en, this message translates to:
  /// **'Prefer not to say'**
  String get editGenderUndisclosed;

  /// No description provided for @editNameInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter your name (at least 2 letters)'**
  String get editNameInvalid;

  /// No description provided for @editEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address'**
  String get editEmailInvalid;

  /// No description provided for @editPhone.
  ///
  /// In en, this message translates to:
  /// **'Mobile number'**
  String get editPhone;

  /// No description provided for @editPhoneLocked.
  ///
  /// In en, this message translates to:
  /// **'Your login number can\'t be changed'**
  String get editPhoneLocked;

  /// No description provided for @editSectionPersonal.
  ///
  /// In en, this message translates to:
  /// **'Personal details'**
  String get editSectionPersonal;

  /// No description provided for @editSectionContact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get editSectionContact;

  /// No description provided for @editDobPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Add your date of birth'**
  String get editDobPlaceholder;

  /// No description provided for @editPhotoUpdated.
  ///
  /// In en, this message translates to:
  /// **'Photo updated'**
  String get editPhotoUpdated;

  /// No description provided for @editCountry.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get editCountry;

  /// No description provided for @chooseLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose language'**
  String get chooseLanguage;

  /// No description provided for @chooseCurrency.
  ///
  /// In en, this message translates to:
  /// **'Choose currency'**
  String get chooseCurrency;

  /// No description provided for @deleteAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete your account'**
  String get deleteAccountTitle;

  /// No description provided for @deleteAccountBody.
  ///
  /// In en, this message translates to:
  /// **'This permanently removes your profile, birth charts and chat history. Your wallet balance, if any, is refunded to the original payment method. Consultation records are kept as required by law.'**
  String get deleteAccountBody;

  /// No description provided for @deleteAccountHold.
  ///
  /// In en, this message translates to:
  /// **'Your account is deactivated immediately and fully deleted after 30 days. Sign in again within 30 days to cancel.'**
  String get deleteAccountHold;

  /// No description provided for @deleteAccountConfirm.
  ///
  /// In en, this message translates to:
  /// **'Yes, delete my account'**
  String get deleteAccountConfirm;

  /// No description provided for @deleteAccountRequested.
  ///
  /// In en, this message translates to:
  /// **'Account deletion requested'**
  String get deleteAccountRequested;

  /// No description provided for @referTitle.
  ///
  /// In en, this message translates to:
  /// **'Refer and earn'**
  String get referTitle;

  /// No description provided for @referHeroTitle.
  ///
  /// In en, this message translates to:
  /// **'Give {friendAmount}, get {youAmount}'**
  String referHeroTitle(String friendAmount, String youAmount);

  /// No description provided for @referHeroBody.
  ///
  /// In en, this message translates to:
  /// **'Your friend gets {friendAmount} off their first consultation. You get {youAmount} in your wallet when they take it.'**
  String referHeroBody(String friendAmount, String youAmount);

  /// No description provided for @referYourCode.
  ///
  /// In en, this message translates to:
  /// **'Your referral code'**
  String get referYourCode;

  /// No description provided for @referShareLink.
  ///
  /// In en, this message translates to:
  /// **'Share invite link'**
  String get referShareLink;

  /// No description provided for @referInvited.
  ///
  /// In en, this message translates to:
  /// **'Invited'**
  String get referInvited;

  /// No description provided for @referJoined.
  ///
  /// In en, this message translates to:
  /// **'Joined'**
  String get referJoined;

  /// No description provided for @referEarned.
  ///
  /// In en, this message translates to:
  /// **'Earned'**
  String get referEarned;

  /// No description provided for @referHowItWorks.
  ///
  /// In en, this message translates to:
  /// **'How it works'**
  String get referHowItWorks;

  /// No description provided for @referStep1.
  ///
  /// In en, this message translates to:
  /// **'Share your code or link. Your friend enters it while signing up.'**
  String get referStep1;

  /// No description provided for @referStep2.
  ///
  /// In en, this message translates to:
  /// **'They get {amount} off their first paid consultation.'**
  String referStep2(String amount);

  /// No description provided for @referStep3.
  ///
  /// In en, this message translates to:
  /// **'The moment that consultation is billed, {amount} lands in your wallet.'**
  String referStep3(String amount);

  /// No description provided for @referYourReferrals.
  ///
  /// In en, this message translates to:
  /// **'Your referrals'**
  String get referYourReferrals;

  /// No description provided for @referStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get referStatusPending;

  /// No description provided for @referStatusJoined.
  ///
  /// In en, this message translates to:
  /// **'Joined'**
  String get referStatusJoined;

  /// No description provided for @referStatusRewarded.
  ///
  /// In en, this message translates to:
  /// **'Rewarded'**
  String get referStatusRewarded;

  /// No description provided for @referJoinedOn.
  ///
  /// In en, this message translates to:
  /// **'Joined {date}'**
  String referJoinedOn(String date);

  /// No description provided for @referFirstCallDone.
  ///
  /// In en, this message translates to:
  /// **'first call done'**
  String get referFirstCallDone;

  /// No description provided for @referShareText.
  ///
  /// In en, this message translates to:
  /// **'Use my code {code} on TalkAcharya and get {amount} off your first astrology consultation. {link}'**
  String referShareText(String code, String amount, String link);

  /// No description provided for @kundaliYogasDoshasTitle.
  ///
  /// In en, this message translates to:
  /// **'Yogas & Doshas'**
  String get kundaliYogasDoshasTitle;

  /// No description provided for @kundaliTabDoshas.
  ///
  /// In en, this message translates to:
  /// **'Doshas'**
  String get kundaliTabDoshas;

  /// No description provided for @kundaliTabYogas.
  ///
  /// In en, this message translates to:
  /// **'Yogas'**
  String get kundaliTabYogas;

  /// No description provided for @doshaIntro.
  ///
  /// In en, this message translates to:
  /// **'Doshas are sensitive points in the chart. Most soften with time, a supportive dasha, or a classical remedy — an astrologer confirms what actually matters for you.'**
  String get doshaIntro;

  /// No description provided for @doshaDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Structural indications only, not predictions. Talk to an astrologer before wearing a gemstone or starting a serious remedy.'**
  String get doshaDisclaimer;

  /// No description provided for @doshaPresent.
  ///
  /// In en, this message translates to:
  /// **'Present'**
  String get doshaPresent;

  /// No description provided for @doshaNotPresent.
  ///
  /// In en, this message translates to:
  /// **'Not present'**
  String get doshaNotPresent;

  /// No description provided for @doshaCancelled.
  ///
  /// In en, this message translates to:
  /// **'Effectively cancelled'**
  String get doshaCancelled;

  /// No description provided for @doshaSeverityClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get doshaSeverityClear;

  /// No description provided for @doshaSeverityMild.
  ///
  /// In en, this message translates to:
  /// **'Mild'**
  String get doshaSeverityMild;

  /// No description provided for @doshaSeverityModerate.
  ///
  /// In en, this message translates to:
  /// **'Moderate'**
  String get doshaSeverityModerate;

  /// No description provided for @doshaSeverityStrong.
  ///
  /// In en, this message translates to:
  /// **'Strong'**
  String get doshaSeverityStrong;

  /// No description provided for @doshaWhy.
  ///
  /// In en, this message translates to:
  /// **'Why it\'s flagged'**
  String get doshaWhy;

  /// No description provided for @doshaWhatReduces.
  ///
  /// In en, this message translates to:
  /// **'What reduces it'**
  String get doshaWhatReduces;

  /// No description provided for @doshaReducedNote.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{One classical factor} other{{count} classical factors}} in your chart ease this.'**
  String doshaReducedNote(int count);

  /// No description provided for @doshaClearSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear — not in your chart'**
  String get doshaClearSectionTitle;

  /// No description provided for @doshaAllClear.
  ///
  /// In en, this message translates to:
  /// **'None of the common doshas are present in your chart.'**
  String get doshaAllClear;

  /// No description provided for @doshaAskCta.
  ///
  /// In en, this message translates to:
  /// **'Ask an astrologer what this means for you'**
  String get doshaAskCta;

  /// No description provided for @insightsTitle.
  ///
  /// In en, this message translates to:
  /// **'Personality & life overview'**
  String get insightsTitle;

  /// No description provided for @insightsIntro.
  ///
  /// In en, this message translates to:
  /// **'A free reading of your birth (D1) chart — the tendencies it leans towards across the main areas of life. It\'s a sketch for self-reflection, not a forecast of events or dates.'**
  String get insightsIntro;

  /// No description provided for @insightsDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'General guidance from your chart, not a prediction. It names no dates and makes no claims about health, lifespan or relationships. For anything specific, talk to an astrologer.'**
  String get insightsDisclaimer;

  /// No description provided for @insightsAskCta.
  ///
  /// In en, this message translates to:
  /// **'Ask an astrologer about your chart'**
  String get insightsAskCta;

  /// No description provided for @insightsWhatItReadsFrom.
  ///
  /// In en, this message translates to:
  /// **'What this reads from'**
  String get insightsWhatItReadsFrom;

  /// No description provided for @insightsToneSupportive.
  ///
  /// In en, this message translates to:
  /// **'Supportive'**
  String get insightsToneSupportive;

  /// No description provided for @insightsToneBalanced.
  ///
  /// In en, this message translates to:
  /// **'Balanced'**
  String get insightsToneBalanced;

  /// No description provided for @insightsToneChallenging.
  ///
  /// In en, this message translates to:
  /// **'Needs care'**
  String get insightsToneChallenging;

  /// No description provided for @insightsToneMixed.
  ///
  /// In en, this message translates to:
  /// **'Mixed'**
  String get insightsToneMixed;

  /// No description provided for @insightsAreaPersonality.
  ///
  /// In en, this message translates to:
  /// **'Personality & Nature'**
  String get insightsAreaPersonality;

  /// No description provided for @insightsAreaAppearance.
  ///
  /// In en, this message translates to:
  /// **'Physical Appearance'**
  String get insightsAreaAppearance;

  /// No description provided for @insightsAreaMind.
  ///
  /// In en, this message translates to:
  /// **'Mind & Emotions'**
  String get insightsAreaMind;

  /// No description provided for @insightsAreaCareer.
  ///
  /// In en, this message translates to:
  /// **'Career & Profession'**
  String get insightsAreaCareer;

  /// No description provided for @insightsAreaWealth.
  ///
  /// In en, this message translates to:
  /// **'Wealth & Finances'**
  String get insightsAreaWealth;

  /// No description provided for @insightsAreaEducation.
  ///
  /// In en, this message translates to:
  /// **'Education & Intellect'**
  String get insightsAreaEducation;

  /// No description provided for @insightsAreaMarriage.
  ///
  /// In en, this message translates to:
  /// **'Marriage & Spouse'**
  String get insightsAreaMarriage;

  /// No description provided for @insightsAreaFamily.
  ///
  /// In en, this message translates to:
  /// **'Family & Relationships'**
  String get insightsAreaFamily;

  /// No description provided for @insightsAreaHealth.
  ///
  /// In en, this message translates to:
  /// **'Health & Vitality'**
  String get insightsAreaHealth;

  /// No description provided for @insightsAreaFortune.
  ///
  /// In en, this message translates to:
  /// **'Fortune & Dharma'**
  String get insightsAreaFortune;

  /// No description provided for @insightsAreaStrengths.
  ///
  /// In en, this message translates to:
  /// **'Strengths & Challenges'**
  String get insightsAreaStrengths;

  /// No description provided for @predTitle.
  ///
  /// In en, this message translates to:
  /// **'Predictions'**
  String get predTitle;

  /// No description provided for @predReadingTitle.
  ///
  /// In en, this message translates to:
  /// **'Your forecast'**
  String get predReadingTitle;

  /// No description provided for @predRequestTitle.
  ///
  /// In en, this message translates to:
  /// **'Request a forecast'**
  String get predRequestTitle;

  /// No description provided for @predHeroTitle.
  ///
  /// In en, this message translates to:
  /// **'A forecast written for you'**
  String get predHeroTitle;

  /// No description provided for @predHeroBody.
  ///
  /// In en, this message translates to:
  /// **'An astrologer reads your birth chart, dasha and current transits and writes a forecast for one area of life. Delivered in your language, usually within 3 days.'**
  String get predHeroBody;

  /// No description provided for @predChooseArea.
  ///
  /// In en, this message translates to:
  /// **'Choose an area'**
  String get predChooseArea;

  /// No description provided for @predMyReadings.
  ///
  /// In en, this message translates to:
  /// **'Your forecasts'**
  String get predMyReadings;

  /// No description provided for @predNoReadings.
  ///
  /// In en, this message translates to:
  /// **'No forecasts yet. Pick an area above to request one.'**
  String get predNoReadings;

  /// No description provided for @predSeePacks.
  ///
  /// In en, this message translates to:
  /// **'See packs'**
  String get predSeePacks;

  /// No description provided for @predSubscribed.
  ///
  /// In en, this message translates to:
  /// **'Subscribed'**
  String get predSubscribed;

  /// No description provided for @predCredits.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 credit} other{{count} credits}}'**
  String predCredits(int count);

  /// No description provided for @predBuyTitle.
  ///
  /// In en, this message translates to:
  /// **'Prediction credits'**
  String get predBuyTitle;

  /// No description provided for @predBuyBody.
  ///
  /// In en, this message translates to:
  /// **'One credit = one written forecast. Buy a pack and it\'s ready whenever you want a reading.'**
  String get predBuyBody;

  /// No description provided for @predBuyWalletNote.
  ///
  /// In en, this message translates to:
  /// **'Paid from your wallet balance.'**
  String get predBuyWalletNote;

  /// No description provided for @predPackName.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 credit} other{Pack of {count}}}'**
  String predPackName(int count);

  /// No description provided for @predPackPer.
  ///
  /// In en, this message translates to:
  /// **'{price} per credit'**
  String predPackPer(String price);

  /// No description provided for @predBuySuccess.
  ///
  /// In en, this message translates to:
  /// **'Added. You now have {count} credits.'**
  String predBuySuccess(int count);

  /// No description provided for @predForProfile.
  ///
  /// In en, this message translates to:
  /// **'For which birth profile'**
  String get predForProfile;

  /// No description provided for @predAddProfile.
  ///
  /// In en, this message translates to:
  /// **'Add a birth profile'**
  String get predAddProfile;

  /// No description provided for @predPickProfile.
  ///
  /// In en, this message translates to:
  /// **'Choose a birth profile first.'**
  String get predPickProfile;

  /// No description provided for @predArea.
  ///
  /// In en, this message translates to:
  /// **'Area of life'**
  String get predArea;

  /// No description provided for @predPeriod.
  ///
  /// In en, this message translates to:
  /// **'Period'**
  String get predPeriod;

  /// No description provided for @predCostsOne.
  ///
  /// In en, this message translates to:
  /// **'Uses 1 of your {count} credits.'**
  String predCostsOne(int count);

  /// No description provided for @predNoCreditYet.
  ///
  /// In en, this message translates to:
  /// **'You\'ll need a credit — we\'ll show the packs next.'**
  String get predNoCreditYet;

  /// No description provided for @predRequestCta.
  ///
  /// In en, this message translates to:
  /// **'Request forecast'**
  String get predRequestCta;

  /// No description provided for @predRequestDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'The astrologer writes from your chart, dasha and transits. Astrology is guidance for reflection and planning, not a guarantee.'**
  String get predRequestDisclaimer;

  /// No description provided for @predAreaCareer.
  ///
  /// In en, this message translates to:
  /// **'Career & work'**
  String get predAreaCareer;

  /// No description provided for @predAreaMarriage.
  ///
  /// In en, this message translates to:
  /// **'Marriage & love'**
  String get predAreaMarriage;

  /// No description provided for @predAreaFinance.
  ///
  /// In en, this message translates to:
  /// **'Money & finance'**
  String get predAreaFinance;

  /// No description provided for @predAreaHealth.
  ///
  /// In en, this message translates to:
  /// **'Health & energy'**
  String get predAreaHealth;

  /// No description provided for @predAreaEducation.
  ///
  /// In en, this message translates to:
  /// **'Study & learning'**
  String get predAreaEducation;

  /// No description provided for @predAreaGeneral.
  ///
  /// In en, this message translates to:
  /// **'Life overview'**
  String get predAreaGeneral;

  /// No description provided for @predPeriodMonth.
  ///
  /// In en, this message translates to:
  /// **'The month ahead'**
  String get predPeriodMonth;

  /// No description provided for @predPeriodQuarter.
  ///
  /// In en, this message translates to:
  /// **'The next 3 months'**
  String get predPeriodQuarter;

  /// No description provided for @predPeriodYear.
  ///
  /// In en, this message translates to:
  /// **'The year ahead'**
  String get predPeriodYear;

  /// No description provided for @predStatusWriting.
  ///
  /// In en, this message translates to:
  /// **'Being written'**
  String get predStatusWriting;

  /// No description provided for @predStatusReview.
  ///
  /// In en, this message translates to:
  /// **'In review'**
  String get predStatusReview;

  /// No description provided for @predStatusReady.
  ///
  /// In en, this message translates to:
  /// **'Ready to read'**
  String get predStatusReady;

  /// No description provided for @predStatusUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Not available'**
  String get predStatusUnavailable;

  /// No description provided for @predStatusRefunded.
  ///
  /// In en, this message translates to:
  /// **'Refunded'**
  String get predStatusRefunded;

  /// No description provided for @predDeliveredOn.
  ///
  /// In en, this message translates to:
  /// **'Delivered {date}'**
  String predDeliveredOn(String date);

  /// No description provided for @predEta.
  ///
  /// In en, this message translates to:
  /// **'Expected by {date}'**
  String predEta(String date);

  /// No description provided for @predWritingTitle.
  ///
  /// In en, this message translates to:
  /// **'An astrologer is writing this'**
  String get predWritingTitle;

  /// No description provided for @predWritingBody.
  ///
  /// In en, this message translates to:
  /// **'We\'ll send you a notification the moment it\'s ready.'**
  String get predWritingBody;

  /// No description provided for @predWritingEta.
  ///
  /// In en, this message translates to:
  /// **'Expected by {date}. We\'ll notify you when it\'s ready.'**
  String predWritingEta(String date);

  /// No description provided for @predRefundedTitle.
  ///
  /// In en, this message translates to:
  /// **'Credit refunded'**
  String get predRefundedTitle;

  /// No description provided for @predRefundedBody.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t deliver this in time, so your credit is back in your account.'**
  String get predRefundedBody;

  /// No description provided for @predDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Written for you by an astrologer from your birth chart, dasha and current transits. Astrology is guidance for reflection and planning — the choices and the outcome stay yours.'**
  String get predDisclaimer;

  /// No description provided for @predAskFollowUp.
  ///
  /// In en, this message translates to:
  /// **'Ask a follow-up question'**
  String get predAskFollowUp;

  /// No description provided for @remediesTitle.
  ///
  /// In en, this message translates to:
  /// **'Remedies'**
  String get remediesTitle;

  /// No description provided for @remediesIntro.
  ///
  /// In en, this message translates to:
  /// **'Traditional remedies matched to what your chart shows — its active doshas, weaker planets, the running dasha and strained houses. They are acts of discipline and devotion, chosen to fit your faith, health and means.'**
  String get remediesIntro;

  /// No description provided for @remediesNone.
  ///
  /// In en, this message translates to:
  /// **'Nothing stands out in your chart that calls for a specific remedy right now. Keeping a small, steady daily practice is always worthwhile.'**
  String get remediesNone;

  /// No description provided for @remediesDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Do only what fits your faith, health and means. Skip fasting if it is unsafe for you, and never take a loan to give charity.'**
  String get remediesDisclaimer;

  /// No description provided for @remediesAskCta.
  ///
  /// In en, this message translates to:
  /// **'Talk to an astrologer about your remedies'**
  String get remediesAskCta;

  /// No description provided for @remediesConfirmCta.
  ///
  /// In en, this message translates to:
  /// **'Confirm with an astrologer first'**
  String get remediesConfirmCta;

  /// No description provided for @remediesSource.
  ///
  /// In en, this message translates to:
  /// **'Source: {source}'**
  String remediesSource(String source);

  /// No description provided for @doshaSeeRemedies.
  ///
  /// In en, this message translates to:
  /// **'See remedies for your chart'**
  String get doshaSeeRemedies;

  /// No description provided for @remedyCatMantra.
  ///
  /// In en, this message translates to:
  /// **'Mantra & japa'**
  String get remedyCatMantra;

  /// No description provided for @remedyCatStotra.
  ///
  /// In en, this message translates to:
  /// **'Stotra & recitation'**
  String get remedyCatStotra;

  /// No description provided for @remedyCatPuja.
  ///
  /// In en, this message translates to:
  /// **'Puja & ritual'**
  String get remedyCatPuja;

  /// No description provided for @remedyCatVrat.
  ///
  /// In en, this message translates to:
  /// **'Vrat & fasting'**
  String get remedyCatVrat;

  /// No description provided for @remedyCatDaan.
  ///
  /// In en, this message translates to:
  /// **'Daan & charity'**
  String get remedyCatDaan;

  /// No description provided for @remedyCatLifestyle.
  ///
  /// In en, this message translates to:
  /// **'Lifestyle'**
  String get remedyCatLifestyle;

  /// No description provided for @remedyCatYantra.
  ///
  /// In en, this message translates to:
  /// **'Yantra'**
  String get remedyCatYantra;

  /// No description provided for @remedyCatGemstone.
  ///
  /// In en, this message translates to:
  /// **'Gemstone'**
  String get remedyCatGemstone;

  /// No description provided for @remedyCatRudraksha.
  ///
  /// In en, this message translates to:
  /// **'Rudraksha'**
  String get remedyCatRudraksha;

  /// No description provided for @prashnaTitle.
  ///
  /// In en, this message translates to:
  /// **'Ask one question'**
  String get prashnaTitle;

  /// No description provided for @prashnaHeroTitle.
  ///
  /// In en, this message translates to:
  /// **'A yes-or-no on the moment'**
  String get prashnaHeroTitle;

  /// No description provided for @prashnaHeroBody.
  ///
  /// In en, this message translates to:
  /// **'KP horary (Prashna) reads the exact moment you ask a question to give a leaning — yes, no or mixed — with the reasoning. One traditional method\'s pointer, not a promise.'**
  String get prashnaHeroBody;

  /// No description provided for @prashnaAbout.
  ///
  /// In en, this message translates to:
  /// **'What is the question about?'**
  String get prashnaAbout;

  /// No description provided for @prashnaHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Will I get this job offer?'**
  String get prashnaHint;

  /// No description provided for @prashnaAskCta.
  ///
  /// In en, this message translates to:
  /// **'Ask ({price})'**
  String prashnaAskCta(String price);

  /// No description provided for @prashnaDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'A KP horary reading of the moment you asked. It is one traditional method\'s pointer — not a promise, and not a substitute for a full consultation.'**
  String get prashnaDisclaimer;

  /// No description provided for @prashnaNeedQuestion.
  ///
  /// In en, this message translates to:
  /// **'Pick a topic and type your question first.'**
  String get prashnaNeedQuestion;

  /// No description provided for @prashnaLowBalance.
  ///
  /// In en, this message translates to:
  /// **'Your wallet balance is too low. Add money to ask.'**
  String get prashnaLowBalance;

  /// No description provided for @prashnaHistory.
  ///
  /// In en, this message translates to:
  /// **'Your questions'**
  String get prashnaHistory;

  /// No description provided for @prashnaNoHistory.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t asked a question yet.'**
  String get prashnaNoHistory;

  /// No description provided for @prashnaAnswerTitle.
  ///
  /// In en, this message translates to:
  /// **'The reading'**
  String get prashnaAnswerTitle;

  /// No description provided for @prashnaAskAstrologer.
  ///
  /// In en, this message translates to:
  /// **'Talk it through with an astrologer'**
  String get prashnaAskAstrologer;

  /// No description provided for @prashnaHowRead.
  ///
  /// In en, this message translates to:
  /// **'How this was read'**
  String get prashnaHowRead;

  /// No description provided for @prashnaConfidence.
  ///
  /// In en, this message translates to:
  /// **'{level, plural, =0{unclear} =1{weak} =2{moderate} other{clear}} indication'**
  String prashnaConfidence(int level);

  /// No description provided for @prashnaVerdictYes.
  ///
  /// In en, this message translates to:
  /// **'Leaning yes'**
  String get prashnaVerdictYes;

  /// No description provided for @prashnaVerdictNo.
  ///
  /// In en, this message translates to:
  /// **'Leaning no'**
  String get prashnaVerdictNo;

  /// No description provided for @prashnaVerdictMixed.
  ///
  /// In en, this message translates to:
  /// **'Mixed signals'**
  String get prashnaVerdictMixed;

  /// No description provided for @prashnaVerdictUnclear.
  ///
  /// In en, this message translates to:
  /// **'Not decisive'**
  String get prashnaVerdictUnclear;

  /// No description provided for @prashnaCatMarriage.
  ///
  /// In en, this message translates to:
  /// **'Marriage'**
  String get prashnaCatMarriage;

  /// No description provided for @prashnaCatJob.
  ///
  /// In en, this message translates to:
  /// **'A job'**
  String get prashnaCatJob;

  /// No description provided for @prashnaCatPromotion.
  ///
  /// In en, this message translates to:
  /// **'Promotion'**
  String get prashnaCatPromotion;

  /// No description provided for @prashnaCatBusiness.
  ///
  /// In en, this message translates to:
  /// **'Business'**
  String get prashnaCatBusiness;

  /// No description provided for @prashnaCatProperty.
  ///
  /// In en, this message translates to:
  /// **'Property'**
  String get prashnaCatProperty;

  /// No description provided for @prashnaCatMoney.
  ///
  /// In en, this message translates to:
  /// **'A loan or money'**
  String get prashnaCatMoney;

  /// No description provided for @prashnaCatChild.
  ///
  /// In en, this message translates to:
  /// **'Children'**
  String get prashnaCatChild;

  /// No description provided for @prashnaCatTravel.
  ///
  /// In en, this message translates to:
  /// **'Foreign travel'**
  String get prashnaCatTravel;

  /// No description provided for @prashnaCatLitigation.
  ///
  /// In en, this message translates to:
  /// **'A court matter'**
  String get prashnaCatLitigation;

  /// No description provided for @prashnaCatHealth.
  ///
  /// In en, this message translates to:
  /// **'Health & recovery'**
  String get prashnaCatHealth;

  /// No description provided for @prashnaCatLost.
  ///
  /// In en, this message translates to:
  /// **'A lost item'**
  String get prashnaCatLost;

  /// No description provided for @prashnaCatReunion.
  ///
  /// In en, this message translates to:
  /// **'A reunion'**
  String get prashnaCatReunion;

  /// No description provided for @prashnaCatGeneral.
  ///
  /// In en, this message translates to:
  /// **'Something else'**
  String get prashnaCatGeneral;

  /// No description provided for @yogaIntro.
  ///
  /// In en, this message translates to:
  /// **'Yogas are tendencies, not guarantees — they strengthen when the planets involved are well placed and running their dasha.'**
  String get yogaIntro;

  /// No description provided for @yogaNoneTitle.
  ///
  /// In en, this message translates to:
  /// **'No classical yogas detected'**
  String get yogaNoneTitle;

  /// No description provided for @yogaNoneBody.
  ///
  /// In en, this message translates to:
  /// **'That\'s common and not a bad sign — the chart is still read through its houses and dasha.'**
  String get yogaNoneBody;

  /// No description provided for @kundaliTalkToAstrologer.
  ///
  /// In en, this message translates to:
  /// **'Talk to an astrologer'**
  String get kundaliTalkToAstrologer;

  /// No description provided for @kundaliHowItPlaysOut.
  ///
  /// In en, this message translates to:
  /// **'Want to know how these play out in your life and timing?'**
  String get kundaliHowItPlaysOut;

  /// No description provided for @yogaGajakesariName.
  ///
  /// In en, this message translates to:
  /// **'Gajakesari Yoga'**
  String get yogaGajakesariName;

  /// No description provided for @yogaGajakesariMeaning.
  ///
  /// In en, this message translates to:
  /// **'Jupiter in a kendra from the Moon — poise, good judgement and a name that carries weight.'**
  String get yogaGajakesariMeaning;

  /// No description provided for @yogaBudhadityaName.
  ///
  /// In en, this message translates to:
  /// **'Budhaditya Yoga'**
  String get yogaBudhadityaName;

  /// No description provided for @yogaBudhadityaMeaning.
  ///
  /// In en, this message translates to:
  /// **'Sun and Mercury together — a sharp, expressive mind; strong for study, writing and analysis.'**
  String get yogaBudhadityaMeaning;

  /// No description provided for @yogaChandraMangalaName.
  ///
  /// In en, this message translates to:
  /// **'Chandra-Mangala Yoga'**
  String get yogaChandraMangalaName;

  /// No description provided for @yogaChandraMangalaMeaning.
  ///
  /// In en, this message translates to:
  /// **'Moon with Mars — drive around money and enterprise; earning through effort and initiative.'**
  String get yogaChandraMangalaMeaning;

  /// No description provided for @yogaRajaName.
  ///
  /// In en, this message translates to:
  /// **'Raja Yoga'**
  String get yogaRajaName;

  /// No description provided for @yogaRajaMeaning.
  ///
  /// In en, this message translates to:
  /// **'A kendra lord tied to a trikona lord — a lift in status, authority and opportunity when the period runs.'**
  String get yogaRajaMeaning;

  /// No description provided for @yogaDhanaName.
  ///
  /// In en, this message translates to:
  /// **'Dhana Yoga'**
  String get yogaDhanaName;

  /// No description provided for @yogaDhanaMeaning.
  ///
  /// In en, this message translates to:
  /// **'The wealth and gains houses linked — supports savings and steady financial growth.'**
  String get yogaDhanaMeaning;

  /// No description provided for @yogaNeechabhangaName.
  ///
  /// In en, this message translates to:
  /// **'Neechabhanga Raja Yoga'**
  String get yogaNeechabhangaName;

  /// No description provided for @yogaNeechabhangaMeaning.
  ///
  /// In en, this message translates to:
  /// **'A debilitated planet whose weakness is cancelled — an early struggle that turns into strength.'**
  String get yogaNeechabhangaMeaning;

  /// No description provided for @yogaKaalSarpaName.
  ///
  /// In en, this message translates to:
  /// **'Kaal Sarpa Yoga'**
  String get yogaKaalSarpaName;

  /// No description provided for @yogaKaalSarpaMeaning.
  ///
  /// In en, this message translates to:
  /// **'All seven planets on one side of the Rahu-Ketu axis — life can feel hemmed in until a clear direction is found.'**
  String get yogaKaalSarpaMeaning;

  /// No description provided for @yogaAdhiName.
  ///
  /// In en, this message translates to:
  /// **'Adhi Yoga'**
  String get yogaAdhiName;

  /// No description provided for @yogaAdhiMeaning.
  ///
  /// In en, this message translates to:
  /// **'Benefics in the 6th, 7th and 8th from the Moon — protection, capable helpers and a settled position.'**
  String get yogaAdhiMeaning;

  /// No description provided for @yogaShakataName.
  ///
  /// In en, this message translates to:
  /// **'Shakata Yoga'**
  String get yogaShakataName;

  /// No description provided for @yogaShakataMeaning.
  ///
  /// In en, this message translates to:
  /// **'Moon in the 6th, 8th or 12th from Jupiter — fortunes that rise and fall; steadier when the Moon is strong.'**
  String get yogaShakataMeaning;

  /// No description provided for @yogaVishName.
  ///
  /// In en, this message translates to:
  /// **'Vish Yoga'**
  String get yogaVishName;

  /// No description provided for @yogaVishMeaning.
  ///
  /// In en, this message translates to:
  /// **'Moon with Saturn — the mind carries weight; results tend to come later, with maturity.'**
  String get yogaVishMeaning;

  /// No description provided for @yogaKahalaName.
  ///
  /// In en, this message translates to:
  /// **'Kahala Yoga'**
  String get yogaKahalaName;

  /// No description provided for @yogaKahalaMeaning.
  ///
  /// In en, this message translates to:
  /// **'The 4th and 9th lords in mutual kendra with a strong Lagna lord — bold, enterprising, willing to take a risk.'**
  String get yogaKahalaMeaning;

  /// No description provided for @yogaPushkalaName.
  ///
  /// In en, this message translates to:
  /// **'Pushkala Yoga'**
  String get yogaPushkalaName;

  /// No description provided for @yogaPushkalaMeaning.
  ///
  /// In en, this message translates to:
  /// **'The Moon\'s lord with the Lagna lord in a kendra — respect, a good name and persuasive speech.'**
  String get yogaPushkalaMeaning;

  /// No description provided for @yogaDaridraName.
  ///
  /// In en, this message translates to:
  /// **'Daridra Yoga'**
  String get yogaDaridraName;

  /// No description provided for @yogaDaridraMeaning.
  ///
  /// In en, this message translates to:
  /// **'The 11th (gains) lord fallen into a difficult house — gains come slowly; a strong dasha turns it around.'**
  String get yogaDaridraMeaning;

  /// No description provided for @yogaAmalaName.
  ///
  /// In en, this message translates to:
  /// **'Amala Yoga'**
  String get yogaAmalaName;

  /// No description provided for @yogaAmalaMeaning.
  ///
  /// In en, this message translates to:
  /// **'Only a benefic in the 10th from the Lagna or Moon — a clean reputation and lasting goodwill.'**
  String get yogaAmalaMeaning;

  /// No description provided for @yogaSaraswatiName.
  ///
  /// In en, this message translates to:
  /// **'Saraswati Yoga'**
  String get yogaSaraswatiName;

  /// No description provided for @yogaSaraswatiMeaning.
  ///
  /// In en, this message translates to:
  /// **'Mercury, Venus and a strong Jupiter well placed — learning, art and eloquence.'**
  String get yogaSaraswatiMeaning;

  /// No description provided for @yogaLakshmiName.
  ///
  /// In en, this message translates to:
  /// **'Lakshmi Yoga'**
  String get yogaLakshmiName;

  /// No description provided for @yogaLakshmiMeaning.
  ///
  /// In en, this message translates to:
  /// **'A strong 9th lord in a kendra or trikona with a strong Lagna lord — fortune, comfort and grace.'**
  String get yogaLakshmiMeaning;

  /// No description provided for @yogaRuchakaName.
  ///
  /// In en, this message translates to:
  /// **'Ruchaka Yoga'**
  String get yogaRuchakaName;

  /// No description provided for @yogaRuchakaMeaning.
  ///
  /// In en, this message translates to:
  /// **'Mars strong in a kendra — courage, physical vigour and leadership under pressure.'**
  String get yogaRuchakaMeaning;

  /// No description provided for @yogaBhadraName.
  ///
  /// In en, this message translates to:
  /// **'Bhadra Yoga'**
  String get yogaBhadraName;

  /// No description provided for @yogaBhadraMeaning.
  ///
  /// In en, this message translates to:
  /// **'Mercury strong in a kendra — intelligence, clear speech and skill in trade and communication.'**
  String get yogaBhadraMeaning;

  /// No description provided for @yogaHamsaName.
  ///
  /// In en, this message translates to:
  /// **'Hamsa Yoga'**
  String get yogaHamsaName;

  /// No description provided for @yogaHamsaMeaning.
  ///
  /// In en, this message translates to:
  /// **'Jupiter strong in a kendra — wisdom, ethics, a teaching or advisory nature and general good fortune.'**
  String get yogaHamsaMeaning;

  /// No description provided for @yogaMalavyaName.
  ///
  /// In en, this message translates to:
  /// **'Malavya Yoga'**
  String get yogaMalavyaName;

  /// No description provided for @yogaMalavyaMeaning.
  ///
  /// In en, this message translates to:
  /// **'Venus strong in a kendra — charm, comfort, an eye for beauty and a pleasant home life.'**
  String get yogaMalavyaMeaning;

  /// No description provided for @yogaSasaName.
  ///
  /// In en, this message translates to:
  /// **'Sasa Yoga'**
  String get yogaSasaName;

  /// No description provided for @yogaSasaMeaning.
  ///
  /// In en, this message translates to:
  /// **'Saturn strong in a kendra — discipline, endurance and authority built slowly and kept.'**
  String get yogaSasaMeaning;

  /// No description provided for @yogaUbhayachariName.
  ///
  /// In en, this message translates to:
  /// **'Ubhayachari Yoga'**
  String get yogaUbhayachariName;

  /// No description provided for @yogaUbhayachariMeaning.
  ///
  /// In en, this message translates to:
  /// **'Planets on both sides of the Sun — a well-supported, visible life and good all-round standing.'**
  String get yogaUbhayachariMeaning;

  /// No description provided for @yogaVesiName.
  ///
  /// In en, this message translates to:
  /// **'Vesi Yoga'**
  String get yogaVesiName;

  /// No description provided for @yogaVesiMeaning.
  ///
  /// In en, this message translates to:
  /// **'A planet in the 2nd from the Sun — steady speech, a balanced outlook and a fair name.'**
  String get yogaVesiMeaning;

  /// No description provided for @yogaVasiName.
  ///
  /// In en, this message translates to:
  /// **'Vasi Yoga'**
  String get yogaVasiName;

  /// No description provided for @yogaVasiMeaning.
  ///
  /// In en, this message translates to:
  /// **'A planet in the 12th from the Sun — capability, influence and a generous streak.'**
  String get yogaVasiMeaning;

  /// No description provided for @yogaShubhaKartariName.
  ///
  /// In en, this message translates to:
  /// **'Shubha Kartari Yoga'**
  String get yogaShubhaKartariName;

  /// No description provided for @yogaShubhaKartariMeaning.
  ///
  /// In en, this message translates to:
  /// **'Benefics on either side of the Lagna — protection, a gentler path and helpful circumstances.'**
  String get yogaShubhaKartariMeaning;

  /// No description provided for @yogaPapaKartariName.
  ///
  /// In en, this message translates to:
  /// **'Papa Kartari Yoga'**
  String get yogaPapaKartariName;

  /// No description provided for @yogaPapaKartariMeaning.
  ///
  /// In en, this message translates to:
  /// **'Malefics on either side of the Lagna — pressure on the self and health; guard your energy and boundaries.'**
  String get yogaPapaKartariMeaning;

  /// No description provided for @yogaDurudharaName.
  ///
  /// In en, this message translates to:
  /// **'Durudhara Yoga'**
  String get yogaDurudharaName;

  /// No description provided for @yogaDurudharaMeaning.
  ///
  /// In en, this message translates to:
  /// **'Planets flank the Moon in the 2nd and 12th — resources, comfort and steady support around you.'**
  String get yogaDurudharaMeaning;

  /// No description provided for @yogaSunaphaName.
  ///
  /// In en, this message translates to:
  /// **'Sunapha Yoga'**
  String get yogaSunaphaName;

  /// No description provided for @yogaSunaphaMeaning.
  ///
  /// In en, this message translates to:
  /// **'A planet in the 2nd from the Moon — self-made means, intelligence and a good reputation.'**
  String get yogaSunaphaMeaning;

  /// No description provided for @yogaAnaphaName.
  ///
  /// In en, this message translates to:
  /// **'Anapha Yoga'**
  String get yogaAnaphaName;

  /// No description provided for @yogaAnaphaMeaning.
  ///
  /// In en, this message translates to:
  /// **'A planet in the 12th from the Moon — an easy nature, well-being and freedom from want.'**
  String get yogaAnaphaMeaning;

  /// No description provided for @yogaKemadrumaYogaName.
  ///
  /// In en, this message translates to:
  /// **'Kemadruma Yoga'**
  String get yogaKemadrumaYogaName;

  /// No description provided for @yogaKemadrumaYogaMeaning.
  ///
  /// In en, this message translates to:
  /// **'The Moon stands alone, unsupported — an inner restlessness that eases when the Moon is strong or a kendra is occupied.'**
  String get yogaKemadrumaYogaMeaning;

  /// No description provided for @yogaVasumatiName.
  ///
  /// In en, this message translates to:
  /// **'Vasumati Yoga'**
  String get yogaVasumatiName;

  /// No description provided for @yogaVasumatiMeaning.
  ///
  /// In en, this message translates to:
  /// **'Benefics in the growth houses from the Lagna or Moon — accumulating wealth and rising resources.'**
  String get yogaVasumatiMeaning;

  /// No description provided for @yogaKalanidhiName.
  ///
  /// In en, this message translates to:
  /// **'Kalanidhi Yoga'**
  String get yogaKalanidhiName;

  /// No description provided for @yogaKalanidhiMeaning.
  ///
  /// In en, this message translates to:
  /// **'Jupiter in the 2nd or 5th tied to Mercury or Venus — learning, the arts, refinement and honour.'**
  String get yogaKalanidhiMeaning;

  /// No description provided for @yogaChamaraName.
  ///
  /// In en, this message translates to:
  /// **'Chamara Yoga'**
  String get yogaChamaraName;

  /// No description provided for @yogaChamaraMeaning.
  ///
  /// In en, this message translates to:
  /// **'An exalted Lagna lord in a kendra aspected by Jupiter — eloquence, long life and respected standing.'**
  String get yogaChamaraMeaning;

  /// No description provided for @yogaShankhaName.
  ///
  /// In en, this message translates to:
  /// **'Shankha Yoga'**
  String get yogaShankhaName;

  /// No description provided for @yogaShankhaMeaning.
  ///
  /// In en, this message translates to:
  /// **'The 5th and 6th lords linked with a strong Lagna lord — a good life, kind nature and comfort in later years.'**
  String get yogaShankhaMeaning;

  /// No description provided for @yogaParvataName.
  ///
  /// In en, this message translates to:
  /// **'Parvata Yoga'**
  String get yogaParvataName;

  /// No description provided for @yogaParvataMeaning.
  ///
  /// In en, this message translates to:
  /// **'Benefics in the kendras with the 6th and 8th clean — fortune, generosity and an eminent name.'**
  String get yogaParvataMeaning;

  /// No description provided for @yogaHarshaName.
  ///
  /// In en, this message translates to:
  /// **'Harsha Yoga'**
  String get yogaHarshaName;

  /// No description provided for @yogaHarshaMeaning.
  ///
  /// In en, this message translates to:
  /// **'The 6th lord in a difficult house — enemies, debts and illness lose their grip; competitive strength.'**
  String get yogaHarshaMeaning;

  /// No description provided for @yogaSaralaName.
  ///
  /// In en, this message translates to:
  /// **'Sarala Yoga'**
  String get yogaSaralaName;

  /// No description provided for @yogaSaralaMeaning.
  ///
  /// In en, this message translates to:
  /// **'The 8th lord in a difficult house — resilience through crises, longevity and fearlessness.'**
  String get yogaSaralaMeaning;

  /// No description provided for @yogaVimalaName.
  ///
  /// In en, this message translates to:
  /// **'Vimala Yoga'**
  String get yogaVimalaName;

  /// No description provided for @yogaVimalaMeaning.
  ///
  /// In en, this message translates to:
  /// **'The 12th lord in a difficult house — controlled spending, a clean conscience and an independent life.'**
  String get yogaVimalaMeaning;

  /// No description provided for @yogaMahaParivartanaName.
  ///
  /// In en, this message translates to:
  /// **'Maha Parivartana Yoga'**
  String get yogaMahaParivartanaName;

  /// No description provided for @yogaMahaParivartanaMeaning.
  ///
  /// In en, this message translates to:
  /// **'Two lords of good houses exchange signs — the affairs of both houses lift each other over time.'**
  String get yogaMahaParivartanaMeaning;

  /// No description provided for @yogaKhalaParivartanaName.
  ///
  /// In en, this message translates to:
  /// **'Khala Parivartana Yoga'**
  String get yogaKhalaParivartanaName;

  /// No description provided for @yogaKhalaParivartanaMeaning.
  ///
  /// In en, this message translates to:
  /// **'An exchange involving the 3rd house — mixed results, ups and downs, gains through effort and courage.'**
  String get yogaKhalaParivartanaMeaning;

  /// No description provided for @yogaDainyaParivartanaName.
  ///
  /// In en, this message translates to:
  /// **'Dainya Parivartana Yoga'**
  String get yogaDainyaParivartanaName;

  /// No description provided for @yogaDainyaParivartanaMeaning.
  ///
  /// In en, this message translates to:
  /// **'An exchange involving a difficult house — obstacles that need patience; a strong dasha turns it.'**
  String get yogaDainyaParivartanaMeaning;

  /// No description provided for @kSignAries.
  ///
  /// In en, this message translates to:
  /// **'bold, direct, quick to start'**
  String get kSignAries;

  /// No description provided for @kSignTaurus.
  ///
  /// In en, this message translates to:
  /// **'steady, sensual, values comfort and security'**
  String get kSignTaurus;

  /// No description provided for @kSignGemini.
  ///
  /// In en, this message translates to:
  /// **'curious, verbal, quick-thinking'**
  String get kSignGemini;

  /// No description provided for @kSignCancer.
  ///
  /// In en, this message translates to:
  /// **'caring, protective, led by feeling'**
  String get kSignCancer;

  /// No description provided for @kSignLeo.
  ///
  /// In en, this message translates to:
  /// **'proud, warm, wants to be seen'**
  String get kSignLeo;

  /// No description provided for @kSignVirgo.
  ///
  /// In en, this message translates to:
  /// **'precise, useful, improvement-minded'**
  String get kSignVirgo;

  /// No description provided for @kSignLibra.
  ///
  /// In en, this message translates to:
  /// **'fair, relational, seeks balance'**
  String get kSignLibra;

  /// No description provided for @kSignScorpio.
  ///
  /// In en, this message translates to:
  /// **'intense, private, all-or-nothing'**
  String get kSignScorpio;

  /// No description provided for @kSignSagittarius.
  ///
  /// In en, this message translates to:
  /// **'free, believing, big-picture'**
  String get kSignSagittarius;

  /// No description provided for @kSignCapricorn.
  ///
  /// In en, this message translates to:
  /// **'disciplined, ambitious, plays the long game'**
  String get kSignCapricorn;

  /// No description provided for @kSignAquarius.
  ///
  /// In en, this message translates to:
  /// **'independent, systems-minded, unconventional'**
  String get kSignAquarius;

  /// No description provided for @kSignPisces.
  ///
  /// In en, this message translates to:
  /// **'imaginative, compassionate, boundary-less'**
  String get kSignPisces;

  /// No description provided for @kPlanetNameSun.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get kPlanetNameSun;

  /// No description provided for @kPlanetNameMoon.
  ///
  /// In en, this message translates to:
  /// **'Moon'**
  String get kPlanetNameMoon;

  /// No description provided for @kPlanetNameMars.
  ///
  /// In en, this message translates to:
  /// **'Mars'**
  String get kPlanetNameMars;

  /// No description provided for @kPlanetNameMercury.
  ///
  /// In en, this message translates to:
  /// **'Mercury'**
  String get kPlanetNameMercury;

  /// No description provided for @kPlanetNameJupiter.
  ///
  /// In en, this message translates to:
  /// **'Jupiter'**
  String get kPlanetNameJupiter;

  /// No description provided for @kPlanetNameVenus.
  ///
  /// In en, this message translates to:
  /// **'Venus'**
  String get kPlanetNameVenus;

  /// No description provided for @kPlanetNameSaturn.
  ///
  /// In en, this message translates to:
  /// **'Saturn'**
  String get kPlanetNameSaturn;

  /// No description provided for @kPlanetNameRahu.
  ///
  /// In en, this message translates to:
  /// **'Rahu'**
  String get kPlanetNameRahu;

  /// No description provided for @kPlanetNameKetu.
  ///
  /// In en, this message translates to:
  /// **'Ketu'**
  String get kPlanetNameKetu;

  /// No description provided for @kPlanetSun.
  ///
  /// In en, this message translates to:
  /// **'soul, confidence, father, authority'**
  String get kPlanetSun;

  /// No description provided for @kPlanetMoon.
  ///
  /// In en, this message translates to:
  /// **'mind, emotions, mother, comfort'**
  String get kPlanetMoon;

  /// No description provided for @kPlanetMars.
  ///
  /// In en, this message translates to:
  /// **'drive, courage, anger, siblings'**
  String get kPlanetMars;

  /// No description provided for @kPlanetMercury.
  ///
  /// In en, this message translates to:
  /// **'intellect, speech, trade, skill'**
  String get kPlanetMercury;

  /// No description provided for @kPlanetJupiter.
  ///
  /// In en, this message translates to:
  /// **'wisdom, growth, luck, teachers, children'**
  String get kPlanetJupiter;

  /// No description provided for @kPlanetVenus.
  ///
  /// In en, this message translates to:
  /// **'love, beauty, comfort, partnership, art'**
  String get kPlanetVenus;

  /// No description provided for @kPlanetSaturn.
  ///
  /// In en, this message translates to:
  /// **'discipline, time, limits, hard-won reward'**
  String get kPlanetSaturn;

  /// No description provided for @kPlanetRahu.
  ///
  /// In en, this message translates to:
  /// **'ambition, obsession, the foreign and new'**
  String get kPlanetRahu;

  /// No description provided for @kPlanetKetu.
  ///
  /// In en, this message translates to:
  /// **'detachment, mastery, letting go, spirituality'**
  String get kPlanetKetu;

  /// No description provided for @kHouse1.
  ///
  /// In en, this message translates to:
  /// **'Self, body, vitality'**
  String get kHouse1;

  /// No description provided for @kHouse2.
  ///
  /// In en, this message translates to:
  /// **'Wealth, family, speech, food'**
  String get kHouse2;

  /// No description provided for @kHouse3.
  ///
  /// In en, this message translates to:
  /// **'Courage, siblings, effort, short travel'**
  String get kHouse3;

  /// No description provided for @kHouse4.
  ///
  /// In en, this message translates to:
  /// **'Home, mother, land, inner peace'**
  String get kHouse4;

  /// No description provided for @kHouse5.
  ///
  /// In en, this message translates to:
  /// **'Children, education, creativity, romance'**
  String get kHouse5;

  /// No description provided for @kHouse6.
  ///
  /// In en, this message translates to:
  /// **'Health, debt, enemies, daily work'**
  String get kHouse6;

  /// No description provided for @kHouse7.
  ///
  /// In en, this message translates to:
  /// **'Marriage, partnership, business'**
  String get kHouse7;

  /// No description provided for @kHouse8.
  ///
  /// In en, this message translates to:
  /// **'Longevity, sudden change, the hidden, inheritance'**
  String get kHouse8;

  /// No description provided for @kHouse9.
  ///
  /// In en, this message translates to:
  /// **'Fortune, dharma, father, higher learning, long travel'**
  String get kHouse9;

  /// No description provided for @kHouse10.
  ///
  /// In en, this message translates to:
  /// **'Career, status, public life'**
  String get kHouse10;

  /// No description provided for @kHouse11.
  ///
  /// In en, this message translates to:
  /// **'Income, gains, network, elder siblings'**
  String get kHouse11;

  /// No description provided for @kHouse12.
  ///
  /// In en, this message translates to:
  /// **'Loss, expenses, foreign lands, sleep, liberation'**
  String get kHouse12;

  /// No description provided for @kDignityExalted.
  ///
  /// In en, this message translates to:
  /// **'Exalted — very strong'**
  String get kDignityExalted;

  /// No description provided for @kDignityDebilitated.
  ///
  /// In en, this message translates to:
  /// **'Debilitated — under strain here'**
  String get kDignityDebilitated;

  /// No description provided for @kDignityMoolatrikona.
  ///
  /// In en, this message translates to:
  /// **'Moolatrikona — comfortable and strong'**
  String get kDignityMoolatrikona;

  /// No description provided for @kDignityOwn.
  ///
  /// In en, this message translates to:
  /// **'Own sign — stable and effective'**
  String get kDignityOwn;

  /// No description provided for @kDignityGreatFriend.
  ///
  /// In en, this message translates to:
  /// **'In a great friend\'s sign — supported'**
  String get kDignityGreatFriend;

  /// No description provided for @kDignityFriend.
  ///
  /// In en, this message translates to:
  /// **'In a friend\'s sign — supported'**
  String get kDignityFriend;

  /// No description provided for @kDignityNeutral.
  ///
  /// In en, this message translates to:
  /// **'Neutral sign'**
  String get kDignityNeutral;

  /// No description provided for @kDignityEnemy.
  ///
  /// In en, this message translates to:
  /// **'In an enemy\'s sign — works harder'**
  String get kDignityEnemy;

  /// No description provided for @kDignityGreatEnemy.
  ///
  /// In en, this message translates to:
  /// **'In a great enemy\'s sign — under pressure'**
  String get kDignityGreatEnemy;

  /// No description provided for @kDashaSun.
  ///
  /// In en, this message translates to:
  /// **'A period for identity, authority and recognition. Ego and health of the eyes/heart come into focus.'**
  String get kDashaSun;

  /// No description provided for @kDashaMoon.
  ///
  /// In en, this message translates to:
  /// **'A softer, more emotional chapter — home, mother, moods and public life.'**
  String get kDashaMoon;

  /// No description provided for @kDashaMars.
  ///
  /// In en, this message translates to:
  /// **'Energy, competition and initiative rise. Watch temper, accidents and property matters.'**
  String get kDashaMars;

  /// No description provided for @kDashaMercury.
  ///
  /// In en, this message translates to:
  /// **'Learning, trading, writing and communication. Good for study and business, restless for stillness.'**
  String get kDashaMercury;

  /// No description provided for @kDashaJupiter.
  ///
  /// In en, this message translates to:
  /// **'Growth, teachers, family, meaning. Often a fortunate, expansive phase.'**
  String get kDashaJupiter;

  /// No description provided for @kDashaVenus.
  ///
  /// In en, this message translates to:
  /// **'Relationships, comfort, art, money and pleasure. Usually the easiest of the periods.'**
  String get kDashaVenus;

  /// No description provided for @kDashaSaturn.
  ///
  /// In en, this message translates to:
  /// **'Hard work, responsibility and slow, lasting results. Rewards patience; punishes shortcuts.'**
  String get kDashaSaturn;

  /// No description provided for @kDashaRahu.
  ///
  /// In en, this message translates to:
  /// **'Ambition without limits — foreign lands, technology, sudden rises and confusion.'**
  String get kDashaRahu;

  /// No description provided for @kDashaKetu.
  ///
  /// In en, this message translates to:
  /// **'Detachment, endings and spiritual turning inward. Material things feel hollow; skill deepens.'**
  String get kDashaKetu;

  /// No description provided for @kNakAshwini.
  ///
  /// In en, this message translates to:
  /// **'quick, pioneering, healing'**
  String get kNakAshwini;

  /// No description provided for @kNakBharani.
  ///
  /// In en, this message translates to:
  /// **'intense, holds space for change, disciplined'**
  String get kNakBharani;

  /// No description provided for @kNakKrittika.
  ///
  /// In en, this message translates to:
  /// **'sharp, cutting through, protective'**
  String get kNakKrittika;

  /// No description provided for @kNakRohini.
  ///
  /// In en, this message translates to:
  /// **'creative, sensual, nurturing, magnetic'**
  String get kNakRohini;

  /// No description provided for @kNakMrigashira.
  ///
  /// In en, this message translates to:
  /// **'searching, curious, gentle'**
  String get kNakMrigashira;

  /// No description provided for @kNakArdra.
  ///
  /// In en, this message translates to:
  /// **'stormy, transformative, brilliant under pressure'**
  String get kNakArdra;

  /// No description provided for @kNakPunarvasu.
  ///
  /// In en, this message translates to:
  /// **'renewing, generous, returns to safety'**
  String get kNakPunarvasu;

  /// No description provided for @kNakPushya.
  ///
  /// In en, this message translates to:
  /// **'nourishing, dutiful, deeply supportive'**
  String get kNakPushya;

  /// No description provided for @kNakAshlesha.
  ///
  /// In en, this message translates to:
  /// **'perceptive, strategic, hypnotic'**
  String get kNakAshlesha;

  /// No description provided for @kNakMagha.
  ///
  /// In en, this message translates to:
  /// **'regal, tradition-bound, ancestral'**
  String get kNakMagha;

  /// No description provided for @kNakPurvaPhalguni.
  ///
  /// In en, this message translates to:
  /// **'playful, romantic, values leisure'**
  String get kNakPurvaPhalguni;

  /// No description provided for @kNakUttaraPhalguni.
  ///
  /// In en, this message translates to:
  /// **'reliable, contractual, helpful'**
  String get kNakUttaraPhalguni;

  /// No description provided for @kNakHasta.
  ///
  /// In en, this message translates to:
  /// **'skilled with the hands, clever, healing'**
  String get kNakHasta;

  /// No description provided for @kNakChitra.
  ///
  /// In en, this message translates to:
  /// **'artistic, striking, builds beautiful things'**
  String get kNakChitra;

  /// No description provided for @kNakSwati.
  ///
  /// In en, this message translates to:
  /// **'independent, adaptable, freedom-loving'**
  String get kNakSwati;

  /// No description provided for @kNakVishakha.
  ///
  /// In en, this message translates to:
  /// **'goal-driven, determined, dual-natured'**
  String get kNakVishakha;

  /// No description provided for @kNakAnuradha.
  ///
  /// In en, this message translates to:
  /// **'devoted, friendly, thrives abroad'**
  String get kNakAnuradha;

  /// No description provided for @kNakJyeshtha.
  ///
  /// In en, this message translates to:
  /// **'senior, responsible, carries burdens'**
  String get kNakJyeshtha;

  /// No description provided for @kNakMula.
  ///
  /// In en, this message translates to:
  /// **'root-seeking, radical, gets to the core'**
  String get kNakMula;

  /// No description provided for @kNakPurvaAshadha.
  ///
  /// In en, this message translates to:
  /// **'invincible spirit, persuasive'**
  String get kNakPurvaAshadha;

  /// No description provided for @kNakUttaraAshadha.
  ///
  /// In en, this message translates to:
  /// **'principled, enduring, later success'**
  String get kNakUttaraAshadha;

  /// No description provided for @kNakShravana.
  ///
  /// In en, this message translates to:
  /// **'listening, learning, connecting people'**
  String get kNakShravana;

  /// No description provided for @kNakDhanishta.
  ///
  /// In en, this message translates to:
  /// **'rhythmic, wealthy, musical, adaptable'**
  String get kNakDhanishta;

  /// No description provided for @kNakShatabhisha.
  ///
  /// In en, this message translates to:
  /// **'private, healing, systems-minded'**
  String get kNakShatabhisha;

  /// No description provided for @kNakPurvaBhadrapada.
  ///
  /// In en, this message translates to:
  /// **'idealistic, intense, transformative'**
  String get kNakPurvaBhadrapada;

  /// No description provided for @kNakUttaraBhadrapada.
  ///
  /// In en, this message translates to:
  /// **'deep, calm, wise counsel'**
  String get kNakUttaraBhadrapada;

  /// No description provided for @kNakRevati.
  ///
  /// In en, this message translates to:
  /// **'kind, protective of travellers, imaginative'**
  String get kNakRevati;

  /// No description provided for @kSadeSatiRising.
  ///
  /// In en, this message translates to:
  /// **'Rising phase — Saturn is in the 12th sign from your Moon. Endings, tiredness and a sense of things winding down. Start clearing what no longer works.'**
  String get kSadeSatiRising;

  /// No description provided for @kSadeSatiPeak.
  ///
  /// In en, this message translates to:
  /// **'Peak phase — Saturn is over your Moon sign itself. The heaviest stretch: responsibility, pressure and slow progress. Keep routines, protect your health.'**
  String get kSadeSatiPeak;

  /// No description provided for @kSadeSatiSetting.
  ///
  /// In en, this message translates to:
  /// **'Setting phase — Saturn is in the 2nd sign from your Moon. The weight lifts. Money and family stabilise; the lessons of the last years start paying off.'**
  String get kSadeSatiSetting;

  /// No description provided for @kSadeSatiGeneric.
  ///
  /// In en, this message translates to:
  /// **'Saturn is transiting the signs around your Moon.'**
  String get kSadeSatiGeneric;

  /// No description provided for @kPlanetInSignHouse.
  ///
  /// In en, this message translates to:
  /// **'Your {planet} in {sign} makes you {signTrait}. In the {house} house it touches {houseTheme}.'**
  String kPlanetInSignHouse(
    Object planet,
    Object sign,
    Object signTrait,
    Object house,
    Object houseTheme,
  );

  /// No description provided for @kPlanetInSign.
  ///
  /// In en, this message translates to:
  /// **'Your {planet} in {sign} makes you {signTrait}.'**
  String kPlanetInSign(Object planet, Object sign, Object signTrait);

  /// No description provided for @kHouseSans1.
  ///
  /// In en, this message translates to:
  /// **'Tanu Bhava'**
  String get kHouseSans1;

  /// No description provided for @kHouseSans2.
  ///
  /// In en, this message translates to:
  /// **'Dhana Bhava'**
  String get kHouseSans2;

  /// No description provided for @kHouseSans3.
  ///
  /// In en, this message translates to:
  /// **'Sahaja Bhava'**
  String get kHouseSans3;

  /// No description provided for @kHouseSans4.
  ///
  /// In en, this message translates to:
  /// **'Sukha Bhava'**
  String get kHouseSans4;

  /// No description provided for @kHouseSans5.
  ///
  /// In en, this message translates to:
  /// **'Putra Bhava'**
  String get kHouseSans5;

  /// No description provided for @kHouseSans6.
  ///
  /// In en, this message translates to:
  /// **'Ripu Bhava'**
  String get kHouseSans6;

  /// No description provided for @kHouseSans7.
  ///
  /// In en, this message translates to:
  /// **'Yuvati Bhava'**
  String get kHouseSans7;

  /// No description provided for @kHouseSans8.
  ///
  /// In en, this message translates to:
  /// **'Ayu / Randhra Bhava'**
  String get kHouseSans8;

  /// No description provided for @kHouseSans9.
  ///
  /// In en, this message translates to:
  /// **'Dharma Bhava'**
  String get kHouseSans9;

  /// No description provided for @kHouseSans10.
  ///
  /// In en, this message translates to:
  /// **'Karma Bhava'**
  String get kHouseSans10;

  /// No description provided for @kHouseSans11.
  ///
  /// In en, this message translates to:
  /// **'Labha Bhava'**
  String get kHouseSans11;

  /// No description provided for @kHouseSans12.
  ///
  /// In en, this message translates to:
  /// **'Vyaya Bhava'**
  String get kHouseSans12;

  /// No description provided for @kHouseTitleWithSign.
  ///
  /// In en, this message translates to:
  /// **'{sign} · {theme}'**
  String kHouseTitleWithSign(Object sign, Object theme);

  /// No description provided for @kHouseSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'{ordinal} House · {sign}'**
  String kHouseSheetTitle(Object ordinal, Object sign);

  /// No description provided for @kHouseSheetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{sanskrit} — {theme}'**
  String kHouseSheetSubtitle(Object sanskrit, Object theme);

  /// No description provided for @kHouseChipLord.
  ///
  /// In en, this message translates to:
  /// **'House lord · {lord}'**
  String kHouseChipLord(Object lord);

  /// No description provided for @kHouseChipLordIn.
  ///
  /// In en, this message translates to:
  /// **'Lord in the {nthHouse}'**
  String kHouseChipLordIn(Object nthHouse);

  /// No description provided for @kHouseNoPlanets.
  ///
  /// In en, this message translates to:
  /// **'No planets sit in this house. Its story is told mainly by its lord, {lord}{lordWhere}.'**
  String kHouseNoPlanets(Object lord, Object lordWhere);

  /// No description provided for @kHouseLordWhere.
  ///
  /// In en, this message translates to:
  /// **', now in the {nthHouse}'**
  String kHouseLordWhere(Object nthHouse);

  /// No description provided for @kHousePlanetsHeader.
  ///
  /// In en, this message translates to:
  /// **'Planets in this house'**
  String get kHousePlanetsHeader;

  /// No description provided for @kHouseAskCta.
  ///
  /// In en, this message translates to:
  /// **'Ask an astrologer about your {ordinal} house'**
  String kHouseAskCta(Object ordinal);

  /// No description provided for @kHouseReadingLord.
  ///
  /// In en, this message translates to:
  /// **'Your {ordinal}-house lord {lord} sits in the {nthHouse}, so {theme} connects to {lordTheme}.'**
  String kHouseReadingLord(
    Object ordinal,
    Object lord,
    Object nthHouse,
    Object theme,
    Object lordTheme,
  );

  /// No description provided for @kHouseReadingOccupant.
  ///
  /// In en, this message translates to:
  /// **'{planet} here brings its themes — {planetTheme} — into {theme}.'**
  String kHouseReadingOccupant(Object planet, Object planetTheme, Object theme);

  /// No description provided for @kHouseReadingEmpty.
  ///
  /// In en, this message translates to:
  /// **'This house is read through its lord and the planets that aspect it. An astrologer can walk you through it.'**
  String get kHouseReadingEmpty;

  /// No description provided for @kBhavaSubheadKaraka.
  ///
  /// In en, this message translates to:
  /// **'Karaka {karaka}'**
  String kBhavaSubheadKaraka(Object karaka);

  /// No description provided for @kBhavaSubheadLord.
  ///
  /// In en, this message translates to:
  /// **'lord {lord}, {nthHouse}'**
  String kBhavaSubheadLord(Object lord, Object nthHouse);

  /// No description provided for @kBhavaSubheadLordOnly.
  ///
  /// In en, this message translates to:
  /// **'lord {lord}'**
  String kBhavaSubheadLordOnly(Object lord);

  /// No description provided for @kBhavaReadingGoverns.
  ///
  /// In en, this message translates to:
  /// **'This house governs {theme}.'**
  String kBhavaReadingGoverns(Object theme);

  /// No description provided for @kBhavaReadingLord.
  ///
  /// In en, this message translates to:
  /// **'Its lord {lord} is in the {nthHouse}, so {theme} connects to {lordTheme}.{dignity}{occupants}'**
  String kBhavaReadingLord(
    Object lord,
    Object nthHouse,
    Object theme,
    Object lordTheme,
    Object dignity,
    Object occupants,
  );

  /// No description provided for @kBhavaReadingDignity.
  ///
  /// In en, this message translates to:
  /// **' The lord is {dignity}.'**
  String kBhavaReadingDignity(Object dignity);

  /// No description provided for @kBhavaReadingOccupants.
  ///
  /// In en, this message translates to:
  /// **' {planets} sit here, adding {themes}.'**
  String kBhavaReadingOccupants(Object planets, Object themes);

  /// No description provided for @kTransitHouseLine.
  ///
  /// In en, this message translates to:
  /// **'Your {nthHouse} · {theme}'**
  String kTransitHouseLine(Object nthHouse, Object theme);

  /// No description provided for @kPlanetRowMeta.
  ///
  /// In en, this message translates to:
  /// **'{sign} · {nthHouse} · {degree}°'**
  String kPlanetRowMeta(Object sign, Object nthHouse, Object degree);

  /// No description provided for @kLagnaLordIn.
  ///
  /// In en, this message translates to:
  /// **'in the {nthHouse}'**
  String kLagnaLordIn(Object nthHouse);

  /// No description provided for @kDignityShortExalted.
  ///
  /// In en, this message translates to:
  /// **'Exalted'**
  String get kDignityShortExalted;

  /// No description provided for @kDignityShortMoolatrikona.
  ///
  /// In en, this message translates to:
  /// **'Moolatrikona'**
  String get kDignityShortMoolatrikona;

  /// No description provided for @kDignityShortOwn.
  ///
  /// In en, this message translates to:
  /// **'Own'**
  String get kDignityShortOwn;

  /// No description provided for @kDignityShortDebilitated.
  ///
  /// In en, this message translates to:
  /// **'Debilitated'**
  String get kDignityShortDebilitated;

  /// No description provided for @kDignityShortEnemy.
  ///
  /// In en, this message translates to:
  /// **'Enemy sign'**
  String get kDignityShortEnemy;

  /// No description provided for @kDignityShortGreatEnemy.
  ///
  /// In en, this message translates to:
  /// **'Great enemy'**
  String get kDignityShortGreatEnemy;

  /// No description provided for @kCombustNote.
  ///
  /// In en, this message translates to:
  /// **'Combust — very close to the Sun, so its independent voice is dimmed.'**
  String get kCombustNote;

  /// No description provided for @kWhatThisMeans.
  ///
  /// In en, this message translates to:
  /// **'What this means for you'**
  String get kWhatThisMeans;

  /// No description provided for @ovStrengthStrong.
  ///
  /// In en, this message translates to:
  /// **'strong'**
  String get ovStrengthStrong;

  /// No description provided for @ovStrengthSteady.
  ///
  /// In en, this message translates to:
  /// **'steady'**
  String get ovStrengthSteady;

  /// No description provided for @ovStrengthStrain.
  ///
  /// In en, this message translates to:
  /// **'under strain'**
  String get ovStrengthStrain;

  /// No description provided for @ovStrengthWeak.
  ///
  /// In en, this message translates to:
  /// **'weak'**
  String get ovStrengthWeak;

  /// No description provided for @ovRoleSpouse.
  ///
  /// In en, this message translates to:
  /// **'Spouse significator'**
  String get ovRoleSpouse;

  /// No description provided for @ovRoleDarakaraka.
  ///
  /// In en, this message translates to:
  /// **'Darakaraka (Jaimini)'**
  String get ovRoleDarakaraka;

  /// No description provided for @ovRoleWealth.
  ///
  /// In en, this message translates to:
  /// **'Wealth significator'**
  String get ovRoleWealth;

  /// No description provided for @ovRoleIntellect.
  ///
  /// In en, this message translates to:
  /// **'Intellect significator'**
  String get ovRoleIntellect;

  /// No description provided for @ovRoleWisdom.
  ///
  /// In en, this message translates to:
  /// **'Wisdom significator'**
  String get ovRoleWisdom;

  /// No description provided for @ovRoleFortune.
  ///
  /// In en, this message translates to:
  /// **'Fortune significator'**
  String get ovRoleFortune;

  /// No description provided for @ovRoleFather.
  ///
  /// In en, this message translates to:
  /// **'Father significator'**
  String get ovRoleFather;

  /// No description provided for @ovRoleMother.
  ///
  /// In en, this message translates to:
  /// **'Mother significator'**
  String get ovRoleMother;

  /// No description provided for @ovRoleGeneric.
  ///
  /// In en, this message translates to:
  /// **'Significator'**
  String get ovRoleGeneric;

  /// No description provided for @ovfPada.
  ///
  /// In en, this message translates to:
  /// **'pada {pada}'**
  String ovfPada(int pada);

  /// No description provided for @ovfLagnaSign.
  ///
  /// In en, this message translates to:
  /// **'Rising sign {sign}'**
  String ovfLagnaSign(Object sign);

  /// No description provided for @ovfLagnaLord.
  ///
  /// In en, this message translates to:
  /// **'Ascendant lord {planet} in the {nthHouse}{dignity}'**
  String ovfLagnaLord(Object planet, Object nthHouse, Object dignity);

  /// No description provided for @ovfHouseLord.
  ///
  /// In en, this message translates to:
  /// **'{ordinal}-house lord {planet} in the {nthHouse}'**
  String ovfHouseLord(Object ordinal, Object planet, Object nthHouse);

  /// No description provided for @ovfHouseStrength.
  ///
  /// In en, this message translates to:
  /// **'{ordinal} house — {strength}'**
  String ovfHouseStrength(Object ordinal, Object strength);

  /// No description provided for @ovfMoonSign.
  ///
  /// In en, this message translates to:
  /// **'Moon in {sign}'**
  String ovfMoonSign(Object sign);

  /// No description provided for @ovfMoonHouse.
  ///
  /// In en, this message translates to:
  /// **'Moon in the {nthHouse}'**
  String ovfMoonHouse(Object nthHouse);

  /// No description provided for @ovfMoonNakshatra.
  ///
  /// In en, this message translates to:
  /// **'Moon nakshatra {nakshatra}'**
  String ovfMoonNakshatra(Object nakshatra);

  /// No description provided for @ovfMoonDignity.
  ///
  /// In en, this message translates to:
  /// **'Moon {dignity}'**
  String ovfMoonDignity(Object dignity);

  /// No description provided for @ovfSunSign.
  ///
  /// In en, this message translates to:
  /// **'Sun in {sign}'**
  String ovfSunSign(Object sign);

  /// No description provided for @ovfSeventhSign.
  ///
  /// In en, this message translates to:
  /// **'7th house in {sign}'**
  String ovfSeventhSign(Object sign);

  /// No description provided for @ovfPlanetInHouse.
  ///
  /// In en, this message translates to:
  /// **'{planet} in the {nthHouse}'**
  String ovfPlanetInHouse(Object planet, Object nthHouse);

  /// No description provided for @ovfPlanetWithMoon.
  ///
  /// In en, this message translates to:
  /// **'{planet} with the Moon'**
  String ovfPlanetWithMoon(Object planet);

  /// No description provided for @ovfAppearanceIn.
  ///
  /// In en, this message translates to:
  /// **'{planet} in the 1st house'**
  String ovfAppearanceIn(Object planet);

  /// No description provided for @ovfAppearanceAspect.
  ///
  /// In en, this message translates to:
  /// **'{planet} aspecting the 1st house'**
  String ovfAppearanceAspect(Object planet);

  /// No description provided for @ovfMaleficOnLagna.
  ///
  /// In en, this message translates to:
  /// **'{planet} pressing on the ascendant'**
  String ovfMaleficOnLagna(Object planet);

  /// No description provided for @ovfKaraka.
  ///
  /// In en, this message translates to:
  /// **'{role}: {planet}'**
  String ovfKaraka(Object role, Object planet);

  /// No description provided for @ovfYoga.
  ///
  /// In en, this message translates to:
  /// **'Yoga — {name}'**
  String ovfYoga(Object name);

  /// No description provided for @ovfDosha.
  ///
  /// In en, this message translates to:
  /// **'Dosha — {name}'**
  String ovfDosha(Object name);

  /// No description provided for @doshaMangalName.
  ///
  /// In en, this message translates to:
  /// **'Mangal Dosha'**
  String get doshaMangalName;

  /// No description provided for @doshaMangalMeaning.
  ///
  /// In en, this message translates to:
  /// **'Mars in a sensitive house — traditionally weighed before marriage. Often balanced when both partners are Manglik or Jupiter influences Mars.'**
  String get doshaMangalMeaning;

  /// No description provided for @doshaKaalSarpaName.
  ///
  /// In en, this message translates to:
  /// **'Kaal Sarpa Dosha'**
  String get doshaKaalSarpaName;

  /// No description provided for @doshaKaalSarpaMeaning.
  ///
  /// In en, this message translates to:
  /// **'The whole chart held between Rahu and Ketu — life can feel hemmed in until a clear direction is found, then focus becomes intense.'**
  String get doshaKaalSarpaMeaning;

  /// No description provided for @doshaPitraName.
  ///
  /// In en, this message translates to:
  /// **'Pitra Dosha'**
  String get doshaPitraName;

  /// No description provided for @doshaPitraMeaning.
  ///
  /// In en, this message translates to:
  /// **'The Sun and 9th house carry a shadow of ancestral karma — often addressed with shraddha and charity in the father\'s name.'**
  String get doshaPitraMeaning;

  /// No description provided for @doshaGandmoolName.
  ///
  /// In en, this message translates to:
  /// **'Gandmool Dosha'**
  String get doshaGandmoolName;

  /// No description provided for @doshaGandmoolMeaning.
  ///
  /// In en, this message translates to:
  /// **'The Moon sits at a junction nakshatra. A Shanti puja on the 27th day is the traditional response.'**
  String get doshaGandmoolMeaning;

  /// No description provided for @doshaGrahanName.
  ///
  /// In en, this message translates to:
  /// **'Grahan Dosha'**
  String get doshaGrahanName;

  /// No description provided for @doshaGrahanMeaning.
  ///
  /// In en, this message translates to:
  /// **'A luminary (Sun or Moon) sits with a node, so that planet\'s significations dim until worked on.'**
  String get doshaGrahanMeaning;

  /// No description provided for @doshaShrapitName.
  ///
  /// In en, this message translates to:
  /// **'Shrapit Dosha'**
  String get doshaShrapitName;

  /// No description provided for @doshaShrapitMeaning.
  ///
  /// In en, this message translates to:
  /// **'Saturn with Rahu — delay and confusion early on; steady, patient effort is the way through.'**
  String get doshaShrapitMeaning;

  /// No description provided for @doshaGuruChandalName.
  ///
  /// In en, this message translates to:
  /// **'Guru Chandal Dosha'**
  String get doshaGuruChandalName;

  /// No description provided for @doshaGuruChandalMeaning.
  ///
  /// In en, this message translates to:
  /// **'Jupiter with a node — wisdom mixed with unorthodox ideas; choose your teachers and beliefs with care.'**
  String get doshaGuruChandalMeaning;

  /// No description provided for @doshaAngarakName.
  ///
  /// In en, this message translates to:
  /// **'Angarak Dosha'**
  String get doshaAngarakName;

  /// No description provided for @doshaAngarakMeaning.
  ///
  /// In en, this message translates to:
  /// **'Mars with a node — an impulsive charge; anger, accidents and property disputes need care.'**
  String get doshaAngarakMeaning;

  /// No description provided for @doshaKemadrumaName.
  ///
  /// In en, this message translates to:
  /// **'Kemadruma Dosha'**
  String get doshaKemadrumaName;

  /// No description provided for @doshaKemadrumaMeaning.
  ///
  /// In en, this message translates to:
  /// **'The Moon stands alone with no support around it — it eases when a kendra is occupied or the Moon is strong.'**
  String get doshaKemadrumaMeaning;

  /// No description provided for @doshaDaridraName.
  ///
  /// In en, this message translates to:
  /// **'Daridra Dosha'**
  String get doshaDaridraName;

  /// No description provided for @doshaDaridraMeaning.
  ///
  /// In en, this message translates to:
  /// **'The money houses are strained — disciplined saving and a strong dasha turn it around.'**
  String get doshaDaridraMeaning;

  /// No description provided for @birthDetailsCta.
  ///
  /// In en, this message translates to:
  /// **'Full birth details'**
  String get birthDetailsCta;

  /// No description provided for @birthDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Birth details'**
  String get birthDetailsTitle;

  /// No description provided for @birthDetailsAyanamsa.
  ///
  /// In en, this message translates to:
  /// **'Ayanamsha'**
  String get birthDetailsAyanamsa;

  /// No description provided for @birthDetailsPanchangTitle.
  ///
  /// In en, this message translates to:
  /// **'Panchang at birth'**
  String get birthDetailsPanchangTitle;

  /// No description provided for @birthDetailsChakraTitle.
  ///
  /// In en, this message translates to:
  /// **'Avakahada Chakra'**
  String get birthDetailsChakraTitle;

  /// No description provided for @birthDetailsWeekday.
  ///
  /// In en, this message translates to:
  /// **'Weekday'**
  String get birthDetailsWeekday;

  /// No description provided for @birthDetailsTithi.
  ///
  /// In en, this message translates to:
  /// **'Tithi'**
  String get birthDetailsTithi;

  /// No description provided for @birthDetailsNakshatra.
  ///
  /// In en, this message translates to:
  /// **'Nakshatra'**
  String get birthDetailsNakshatra;

  /// No description provided for @birthDetailsYoga.
  ///
  /// In en, this message translates to:
  /// **'Yoga'**
  String get birthDetailsYoga;

  /// No description provided for @birthDetailsKarana.
  ///
  /// In en, this message translates to:
  /// **'Karana'**
  String get birthDetailsKarana;

  /// No description provided for @birthDetailsMoonSign.
  ///
  /// In en, this message translates to:
  /// **'Moon sign'**
  String get birthDetailsMoonSign;

  /// No description provided for @birthDetailsSunSign.
  ///
  /// In en, this message translates to:
  /// **'Sun sign'**
  String get birthDetailsSunSign;

  /// No description provided for @birthDetailsSuryaNakshatra.
  ///
  /// In en, this message translates to:
  /// **'Sun\'s nakshatra'**
  String get birthDetailsSuryaNakshatra;

  /// No description provided for @birthDetailsSunrise.
  ///
  /// In en, this message translates to:
  /// **'Sunrise'**
  String get birthDetailsSunrise;

  /// No description provided for @birthDetailsSunset.
  ///
  /// In en, this message translates to:
  /// **'Sunset'**
  String get birthDetailsSunset;

  /// No description provided for @birthDetailsIshtaKala.
  ///
  /// In en, this message translates to:
  /// **'Ishta Kala'**
  String get birthDetailsIshtaKala;

  /// No description provided for @birthDetailsPada.
  ///
  /// In en, this message translates to:
  /// **'Pada {count}'**
  String birthDetailsPada(int count);

  /// No description provided for @birthDetailsGhatiPala.
  ///
  /// In en, this message translates to:
  /// **'{ghati} ghati {pala} pala {vipala} vipala'**
  String birthDetailsGhatiPala(int ghati, int pala, int vipala);

  /// No description provided for @birthDetailsNakshatraLord.
  ///
  /// In en, this message translates to:
  /// **'Nakshatra lord'**
  String get birthDetailsNakshatraLord;

  /// No description provided for @birthDetailsRashiLord.
  ///
  /// In en, this message translates to:
  /// **'Rashi lord'**
  String get birthDetailsRashiLord;

  /// No description provided for @birthDetailsVarna.
  ///
  /// In en, this message translates to:
  /// **'Varna'**
  String get birthDetailsVarna;

  /// No description provided for @birthDetailsVashya.
  ///
  /// In en, this message translates to:
  /// **'Vashya'**
  String get birthDetailsVashya;

  /// No description provided for @birthDetailsYoni.
  ///
  /// In en, this message translates to:
  /// **'Yoni'**
  String get birthDetailsYoni;

  /// No description provided for @birthDetailsGana.
  ///
  /// In en, this message translates to:
  /// **'Gana'**
  String get birthDetailsGana;

  /// No description provided for @birthDetailsNadi.
  ///
  /// In en, this message translates to:
  /// **'Nadi'**
  String get birthDetailsNadi;

  /// No description provided for @birthDetailsTara.
  ///
  /// In en, this message translates to:
  /// **'Tara'**
  String get birthDetailsTara;

  /// No description provided for @birthDetailsTattva.
  ///
  /// In en, this message translates to:
  /// **'Tattva'**
  String get birthDetailsTattva;

  /// No description provided for @birthDetailsYunja.
  ///
  /// In en, this message translates to:
  /// **'Yunja'**
  String get birthDetailsYunja;

  /// No description provided for @birthDetailsRashiPaya.
  ///
  /// In en, this message translates to:
  /// **'Rashi Paya'**
  String get birthDetailsRashiPaya;

  /// No description provided for @birthDetailsNakshatraPaya.
  ///
  /// In en, this message translates to:
  /// **'Nakshatra Paya'**
  String get birthDetailsNakshatraPaya;

  /// No description provided for @birthDetailsDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Classical classificatory attributes — used mainly in muhurta and matchmaking, not predictions.'**
  String get birthDetailsDisclaimer;

  /// No description provided for @vaaraMonday.
  ///
  /// In en, this message translates to:
  /// **'Somvara (Monday)'**
  String get vaaraMonday;

  /// No description provided for @vaaraTuesday.
  ///
  /// In en, this message translates to:
  /// **'Mangalvara (Tuesday)'**
  String get vaaraTuesday;

  /// No description provided for @vaaraWednesday.
  ///
  /// In en, this message translates to:
  /// **'Budhvara (Wednesday)'**
  String get vaaraWednesday;

  /// No description provided for @vaaraThursday.
  ///
  /// In en, this message translates to:
  /// **'Guruvara (Thursday)'**
  String get vaaraThursday;

  /// No description provided for @vaaraFriday.
  ///
  /// In en, this message translates to:
  /// **'Shukravara (Friday)'**
  String get vaaraFriday;

  /// No description provided for @vaaraSaturday.
  ///
  /// In en, this message translates to:
  /// **'Shanivara (Saturday)'**
  String get vaaraSaturday;

  /// No description provided for @vaaraSunday.
  ///
  /// In en, this message translates to:
  /// **'Ravivara (Sunday)'**
  String get vaaraSunday;

  /// No description provided for @tattvaFire.
  ///
  /// In en, this message translates to:
  /// **'Agni (Fire)'**
  String get tattvaFire;

  /// No description provided for @tattvaEarth.
  ///
  /// In en, this message translates to:
  /// **'Prithvi (Earth)'**
  String get tattvaEarth;

  /// No description provided for @tattvaAir.
  ///
  /// In en, this message translates to:
  /// **'Vayu (Air)'**
  String get tattvaAir;

  /// No description provided for @tattvaWater.
  ///
  /// In en, this message translates to:
  /// **'Jala (Water)'**
  String get tattvaWater;

  /// No description provided for @payaGold.
  ///
  /// In en, this message translates to:
  /// **'Gold'**
  String get payaGold;

  /// No description provided for @payaSilver.
  ///
  /// In en, this message translates to:
  /// **'Silver'**
  String get payaSilver;

  /// No description provided for @payaCopper.
  ///
  /// In en, this message translates to:
  /// **'Copper'**
  String get payaCopper;

  /// No description provided for @payaIron.
  ///
  /// In en, this message translates to:
  /// **'Iron'**
  String get payaIron;

  /// No description provided for @roomAppBarTitle.
  ///
  /// In en, this message translates to:
  /// **'Consultation'**
  String get roomAppBarTitle;

  /// No description provided for @roomOpenError.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t open this consultation.'**
  String get roomOpenError;

  /// No description provided for @roomWaitingTitle.
  ///
  /// In en, this message translates to:
  /// **'Waiting for {name} to accept'**
  String roomWaitingTitle(String name);

  /// No description provided for @roomWaitingBody.
  ///
  /// In en, this message translates to:
  /// **'Usually under a minute. We\'ll open the chat the moment they join.'**
  String get roomWaitingBody;

  /// No description provided for @roomCancelRequest.
  ///
  /// In en, this message translates to:
  /// **'Cancel request'**
  String get roomCancelRequest;

  /// No description provided for @roomEndConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'End this consultation?'**
  String get roomEndConfirmTitle;

  /// No description provided for @roomEndConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'Billing stops when the session ends.'**
  String get roomEndConfirmBody;

  /// No description provided for @roomKeepTalking.
  ///
  /// In en, this message translates to:
  /// **'Keep talking'**
  String get roomKeepTalking;

  /// No description provided for @roomEnd.
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get roomEnd;

  /// No description provided for @roomAutoTranslateOn.
  ///
  /// In en, this message translates to:
  /// **'Auto-translate on'**
  String get roomAutoTranslateOn;

  /// No description provided for @roomAutoTranslateOff.
  ///
  /// In en, this message translates to:
  /// **'Auto-translate off'**
  String get roomAutoTranslateOff;

  /// No description provided for @roomEndedTitle.
  ///
  /// In en, this message translates to:
  /// **'Consultation ended'**
  String get roomEndedTitle;

  /// No description provided for @roomBalanceOutTitle.
  ///
  /// In en, this message translates to:
  /// **'Your balance ran out'**
  String get roomBalanceOutTitle;

  /// No description provided for @roomBalanceOutBody.
  ///
  /// In en, this message translates to:
  /// **'The chat ended because your wallet balance finished. Recharge and start again to continue with {name}.'**
  String roomBalanceOutBody(String name);

  /// No description provided for @roomRechargeWallet.
  ///
  /// In en, this message translates to:
  /// **'Recharge wallet'**
  String get roomRechargeWallet;

  /// No description provided for @roomStartAgain.
  ///
  /// In en, this message translates to:
  /// **'Start again with {name}'**
  String roomStartAgain(String name);

  /// No description provided for @roomRowAstrologer.
  ///
  /// In en, this message translates to:
  /// **'Astrologer'**
  String get roomRowAstrologer;

  /// No description provided for @roomRowDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get roomRowDuration;

  /// No description provided for @roomRowAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get roomRowAmount;

  /// No description provided for @roomRowRate.
  ///
  /// In en, this message translates to:
  /// **'Rate'**
  String get roomRowRate;

  /// No description provided for @roomMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String roomMinutes(int minutes);

  /// No description provided for @roomRatePerMinute.
  ///
  /// In en, this message translates to:
  /// **'{currency} {amount}/min'**
  String roomRatePerMinute(String currency, String amount);

  /// No description provided for @roomRateQuestion.
  ///
  /// In en, this message translates to:
  /// **'How was your consultation?'**
  String get roomRateQuestion;

  /// No description provided for @roomSubmitRating.
  ///
  /// In en, this message translates to:
  /// **'Submit rating'**
  String get roomSubmitRating;

  /// No description provided for @roomRatingThanks.
  ///
  /// In en, this message translates to:
  /// **'Thanks for the feedback!'**
  String get roomRatingThanks;

  /// No description provided for @roomBackHome.
  ///
  /// In en, this message translates to:
  /// **'Back to home'**
  String get roomBackHome;

  /// No description provided for @roomStatusRejected.
  ///
  /// In en, this message translates to:
  /// **'The astrologer couldn\'t take this request'**
  String get roomStatusRejected;

  /// No description provided for @roomStatusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Request cancelled'**
  String get roomStatusCancelled;

  /// No description provided for @roomStatusExpired.
  ///
  /// In en, this message translates to:
  /// **'Request expired — no response in time'**
  String get roomStatusExpired;

  /// No description provided for @roomStatusNoShow.
  ///
  /// In en, this message translates to:
  /// **'The call did not connect'**
  String get roomStatusNoShow;

  /// No description provided for @roomStatusClosed.
  ///
  /// In en, this message translates to:
  /// **'Consultation closed'**
  String get roomStatusClosed;

  /// No description provided for @roomBalanceRunningOut.
  ///
  /// In en, this message translates to:
  /// **'Balance is running out'**
  String get roomBalanceRunningOut;

  /// No description provided for @roomMinLeftRecharge.
  ///
  /// In en, this message translates to:
  /// **'~{minutes} min left · recharge to keep talking'**
  String roomMinLeftRecharge(int minutes);

  /// No description provided for @roomSpentMinLeft.
  ///
  /// In en, this message translates to:
  /// **'{currency} {amount} spent · ~{minutes} min left'**
  String roomSpentMinLeft(String currency, String amount, int minutes);

  /// No description provided for @roomAddMoney.
  ///
  /// In en, this message translates to:
  /// **'Add money'**
  String get roomAddMoney;

  /// No description provided for @roomClientBalanceLow.
  ///
  /// In en, this message translates to:
  /// **'Client\'s balance is low — wrap up soon'**
  String get roomClientBalanceLow;

  /// No description provided for @navChats.
  ///
  /// In en, this message translates to:
  /// **'Chats'**
  String get navChats;

  /// No description provided for @chatsTitle.
  ///
  /// In en, this message translates to:
  /// **'Chats'**
  String get chatsTitle;

  /// No description provided for @chatsLoadError.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t load your chats.'**
  String get chatsLoadError;

  /// No description provided for @chatsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No chats yet'**
  String get chatsEmptyTitle;

  /// No description provided for @chatsEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Start a consultation with an astrologer and it shows up here.'**
  String get chatsEmptyBody;

  /// No description provided for @chatsSectionActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get chatsSectionActive;

  /// No description provided for @chatsSectionRecent.
  ///
  /// In en, this message translates to:
  /// **'Recent'**
  String get chatsSectionRecent;

  /// No description provided for @chatsAstrologerFallback.
  ///
  /// In en, this message translates to:
  /// **'Astrologer'**
  String get chatsAstrologerFallback;

  /// No description provided for @chatsStatusWaiting.
  ///
  /// In en, this message translates to:
  /// **'Waiting for the astrologer to accept'**
  String get chatsStatusWaiting;

  /// No description provided for @chatsStatusLive.
  ///
  /// In en, this message translates to:
  /// **'Live now · tap to open'**
  String get chatsStatusLive;

  /// No description provided for @chatsStatusEnded.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min consultation'**
  String chatsStatusEnded(int minutes);

  /// No description provided for @chatsStatusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get chatsStatusCancelled;

  /// No description provided for @chatsStatusRejected.
  ///
  /// In en, this message translates to:
  /// **'Not accepted'**
  String get chatsStatusRejected;

  /// No description provided for @chatsStatusExpired.
  ///
  /// In en, this message translates to:
  /// **'Request expired'**
  String get chatsStatusExpired;

  /// No description provided for @chatsStatusGeneric.
  ///
  /// In en, this message translates to:
  /// **'Consultation'**
  String get chatsStatusGeneric;

  /// No description provided for @numerologyTitle.
  ///
  /// In en, this message translates to:
  /// **'Numerology & Lo Shu grid'**
  String get numerologyTitle;

  /// No description provided for @numerologyIntro.
  ///
  /// In en, this message translates to:
  /// **'A traditional numbers reading from your date of birth (and name) — the tendencies each number leans towards, favourable days and colours, and your Lo Shu birth grid. For reflection, not dated prediction.'**
  String get numerologyIntro;

  /// No description provided for @numMoolank.
  ///
  /// In en, this message translates to:
  /// **'Moolank · psychic number'**
  String get numMoolank;

  /// No description provided for @numBhagyank.
  ///
  /// In en, this message translates to:
  /// **'Bhagyank · destiny number'**
  String get numBhagyank;

  /// No description provided for @numNaamank.
  ///
  /// In en, this message translates to:
  /// **'Naamank · name number'**
  String get numNaamank;

  /// No description provided for @numRuledBy.
  ///
  /// In en, this message translates to:
  /// **'Ruled by {planet}'**
  String numRuledBy(String planet);

  /// No description provided for @numFriendly.
  ///
  /// In en, this message translates to:
  /// **'Friendly'**
  String get numFriendly;

  /// No description provided for @numNeutral.
  ///
  /// In en, this message translates to:
  /// **'Neutral'**
  String get numNeutral;

  /// No description provided for @numUnfriendly.
  ///
  /// In en, this message translates to:
  /// **'Clashing'**
  String get numUnfriendly;

  /// No description provided for @numFavDays.
  ///
  /// In en, this message translates to:
  /// **'Favourable days'**
  String get numFavDays;

  /// No description provided for @numFavColours.
  ///
  /// In en, this message translates to:
  /// **'Favourable colours'**
  String get numFavColours;

  /// No description provided for @numDirection.
  ///
  /// In en, this message translates to:
  /// **'Direction'**
  String get numDirection;

  /// No description provided for @numDeity.
  ///
  /// In en, this message translates to:
  /// **'Deity'**
  String get numDeity;

  /// No description provided for @numGemstone.
  ///
  /// In en, this message translates to:
  /// **'Traditional gemstone'**
  String get numGemstone;

  /// No description provided for @numLoShuTitle.
  ///
  /// In en, this message translates to:
  /// **'Lo Shu birth grid'**
  String get numLoShuTitle;

  /// No description provided for @numLoShuMissing.
  ///
  /// In en, this message translates to:
  /// **'Not in your grid: {nums}'**
  String numLoShuMissing(String nums);

  /// No description provided for @numLoShuRepeated.
  ///
  /// In en, this message translates to:
  /// **'Emphasised: {nums}'**
  String numLoShuRepeated(String nums);

  /// No description provided for @numArrowStrength.
  ///
  /// In en, this message translates to:
  /// **'Complete line'**
  String get numArrowStrength;

  /// No description provided for @numArrowAbsence.
  ///
  /// In en, this message translates to:
  /// **'Absent line'**
  String get numArrowAbsence;

  /// No description provided for @numAskCta.
  ///
  /// In en, this message translates to:
  /// **'Talk to an astrologer about this'**
  String get numAskCta;

  /// No description provided for @sadeSatiTitle.
  ///
  /// In en, this message translates to:
  /// **'Sade Sati & Dhaiya calendar'**
  String get sadeSatiTitle;

  /// No description provided for @sadeSatiIntro.
  ///
  /// In en, this message translates to:
  /// **'The dated Saturn windows over your life, reckoned from your Moon sign {sign}. Sade Sati is Saturn through the 12th, 1st and 2nd from the Moon (~7½ years); Dhaiya is the 4th or 8th (~2½ years).'**
  String sadeSatiIntro(String sign);

  /// No description provided for @sadeSatiRunningNow.
  ///
  /// In en, this message translates to:
  /// **'Running now'**
  String get sadeSatiRunningNow;

  /// No description provided for @sadeSatiPast.
  ///
  /// In en, this message translates to:
  /// **'Past'**
  String get sadeSatiPast;

  /// No description provided for @sadeSatiUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get sadeSatiUpcoming;

  /// No description provided for @sadeSatiPhaseRising.
  ///
  /// In en, this message translates to:
  /// **'Rising · Saturn in the 12th'**
  String get sadeSatiPhaseRising;

  /// No description provided for @sadeSatiPhasePeak.
  ///
  /// In en, this message translates to:
  /// **'Peak · Saturn over the Moon'**
  String get sadeSatiPhasePeak;

  /// No description provided for @sadeSatiPhaseSetting.
  ///
  /// In en, this message translates to:
  /// **'Setting · Saturn in the 2nd'**
  String get sadeSatiPhaseSetting;

  /// No description provided for @sadeSatiPhaseKantaka.
  ///
  /// In en, this message translates to:
  /// **'Kantaka · Saturn in the 4th'**
  String get sadeSatiPhaseKantaka;

  /// No description provided for @sadeSatiPhaseAshtama.
  ///
  /// In en, this message translates to:
  /// **'Ashtama · Saturn in the 8th'**
  String get sadeSatiPhaseAshtama;

  /// No description provided for @sadeSatiDhaiyaHeading.
  ///
  /// In en, this message translates to:
  /// **'Dhaiya (small panoti) periods'**
  String get sadeSatiDhaiyaHeading;

  /// No description provided for @sadeSatiRange.
  ///
  /// In en, this message translates to:
  /// **'{start} → {end}'**
  String sadeSatiRange(String start, String end);

  /// No description provided for @avTransitHeading.
  ///
  /// In en, this message translates to:
  /// **'Ashtakavarga strength of today\'s transits'**
  String get avTransitHeading;

  /// No description provided for @avTransitIntro.
  ///
  /// In en, this message translates to:
  /// **'How freely each planet\'s transit gives its results, from your natal bindu scores. 5+ of 8 is supportive, 4 mixed, less is weak.'**
  String get avTransitIntro;

  /// No description provided for @avTransitBindus.
  ///
  /// In en, this message translates to:
  /// **'{bindus}/8 bindus'**
  String avTransitBindus(int bindus);

  /// No description provided for @avTransitUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Coming up'**
  String get avTransitUpcoming;

  /// No description provided for @avTransitInHouse.
  ///
  /// In en, this message translates to:
  /// **'{planet} in your {house} house'**
  String avTransitInHouse(String planet, String house);

  /// No description provided for @muhurtaTitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'s timing'**
  String get muhurtaTitle;

  /// No description provided for @muhurtaIntro.
  ///
  /// In en, this message translates to:
  /// **'Choghadiya and Hora for today, worked out for your birth city and personalised to your chart\'s helpful planets. A guide to better and weaker windows for starting things — not a rule.'**
  String get muhurtaIntro;

  /// No description provided for @muhurtaSunTimes.
  ///
  /// In en, this message translates to:
  /// **'{sunrise} sunrise · {sunset} sunset · {weekday} ({lord})'**
  String muhurtaSunTimes(
    String sunrise,
    String sunset,
    String weekday,
    String lord,
  );

  /// No description provided for @muhurtaBestWindows.
  ///
  /// In en, this message translates to:
  /// **'Best windows for you today'**
  String get muhurtaBestWindows;

  /// No description provided for @muhurtaNoBest.
  ///
  /// In en, this message translates to:
  /// **'No stand-out window today — pick a good Choghadiya below.'**
  String get muhurtaNoBest;

  /// No description provided for @muhurtaDayChoghadiya.
  ///
  /// In en, this message translates to:
  /// **'Day Choghadiya'**
  String get muhurtaDayChoghadiya;

  /// No description provided for @muhurtaNightChoghadiya.
  ///
  /// In en, this message translates to:
  /// **'Night Choghadiya'**
  String get muhurtaNightChoghadiya;

  /// No description provided for @muhurtaHora.
  ///
  /// In en, this message translates to:
  /// **'Planetary Hora'**
  String get muhurtaHora;

  /// No description provided for @muhurtaNow.
  ///
  /// In en, this message translates to:
  /// **'Now'**
  String get muhurtaNow;

  /// No description provided for @muhurtaChoGood.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get muhurtaChoGood;

  /// No description provided for @muhurtaChoBad.
  ///
  /// In en, this message translates to:
  /// **'Avoid'**
  String get muhurtaChoBad;

  /// No description provided for @muhurtaChoNeutral.
  ///
  /// In en, this message translates to:
  /// **'Neutral'**
  String get muhurtaChoNeutral;

  /// No description provided for @muhurtaHoraFavourable.
  ///
  /// In en, this message translates to:
  /// **'Good for you'**
  String get muhurtaHoraFavourable;

  /// No description provided for @muhurtaHoraCaution.
  ///
  /// In en, this message translates to:
  /// **'Keep light'**
  String get muhurtaHoraCaution;

  /// No description provided for @upayaTitle.
  ///
  /// In en, this message translates to:
  /// **'Gemstones & upaya'**
  String get upayaTitle;

  /// No description provided for @upayaIntro.
  ///
  /// In en, this message translates to:
  /// **'The classical remedy table for your ascendant ({sign}) — favourable colours, days, deities, mantras and charity you can adopt freely, plus the traditional gemstone and rudraksha for each planet.'**
  String upayaIntro(String sign);

  /// No description provided for @upayaLagnaFavourable.
  ///
  /// In en, this message translates to:
  /// **'Favourable for your ascendant'**
  String get upayaLagnaFavourable;

  /// No description provided for @upayaColours.
  ///
  /// In en, this message translates to:
  /// **'Colours'**
  String get upayaColours;

  /// No description provided for @upayaDirection.
  ///
  /// In en, this message translates to:
  /// **'Direction'**
  String get upayaDirection;

  /// No description provided for @upayaDay.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get upayaDay;

  /// No description provided for @upayaDeity.
  ///
  /// In en, this message translates to:
  /// **'Deity'**
  String get upayaDeity;

  /// No description provided for @upayaStrengthen.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get upayaStrengthen;

  /// No description provided for @upayaPacify.
  ///
  /// In en, this message translates to:
  /// **'Pacify'**
  String get upayaPacify;

  /// No description provided for @upayaMixed.
  ///
  /// In en, this message translates to:
  /// **'Mixed'**
  String get upayaMixed;

  /// No description provided for @upayaNeutral.
  ///
  /// In en, this message translates to:
  /// **'Neutral'**
  String get upayaNeutral;

  /// No description provided for @upayaFreeMeasures.
  ///
  /// In en, this message translates to:
  /// **'Free measures'**
  String get upayaFreeMeasures;

  /// No description provided for @upayaMantra.
  ///
  /// In en, this message translates to:
  /// **'Mantra'**
  String get upayaMantra;

  /// No description provided for @upayaCharity.
  ///
  /// In en, this message translates to:
  /// **'Charity (daan)'**
  String get upayaCharity;

  /// No description provided for @upayaGemstone.
  ///
  /// In en, this message translates to:
  /// **'Gemstone'**
  String get upayaGemstone;

  /// No description provided for @upayaRudraksha.
  ///
  /// In en, this message translates to:
  /// **'Rudraksha'**
  String get upayaRudraksha;

  /// No description provided for @upayaGatedCta.
  ///
  /// In en, this message translates to:
  /// **'Confirm with an astrologer first'**
  String get upayaGatedCta;

  /// No description provided for @upayaPriority.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get upayaPriority;

  /// No description provided for @lalKitabTitle.
  ///
  /// In en, this message translates to:
  /// **'Lal Kitab — debts & remedies'**
  String get lalKitabTitle;

  /// No description provided for @lalKitabIntro.
  ///
  /// In en, this message translates to:
  /// **'Lal Kitab reads a few inherited debts (rin) from your chart and clears each with simple, free household acts (totke). No gemstones, no cost.'**
  String get lalKitabIntro;

  /// No description provided for @lalKitabActiveDebts.
  ///
  /// In en, this message translates to:
  /// **'Active debts'**
  String get lalKitabActiveDebts;

  /// No description provided for @lalKitabNoDebts.
  ///
  /// In en, this message translates to:
  /// **'No strongly active rin — keep the everyday duties and nothing builds up.'**
  String get lalKitabNoDebts;

  /// No description provided for @lalKitabWhyFlagged.
  ///
  /// In en, this message translates to:
  /// **'Why it\'s flagged'**
  String get lalKitabWhyFlagged;

  /// No description provided for @lalKitabRemedy.
  ///
  /// In en, this message translates to:
  /// **'Remedy (totka)'**
  String get lalKitabRemedy;

  /// No description provided for @lalKitabWeakPlanets.
  ///
  /// In en, this message translates to:
  /// **'Weak planet placements'**
  String get lalKitabWeakPlanets;

  /// No description provided for @lalKitabAllRemedies.
  ///
  /// In en, this message translates to:
  /// **'Your remedies'**
  String get lalKitabAllRemedies;

  /// No description provided for @lalKitabPakkaGhar.
  ///
  /// In en, this message translates to:
  /// **'{planet}\'s home house is the {house}'**
  String lalKitabPakkaGhar(String planet, String house);

  /// No description provided for @varshphalTitle.
  ///
  /// In en, this message translates to:
  /// **'Varshphal — this year\'s chart'**
  String get varshphalTitle;

  /// No description provided for @varshphalIntro.
  ///
  /// In en, this message translates to:
  /// **'The Tajika annual chart for your {age}-year, cast for the moment the Sun returns to its birth position. Themes to work with — not fixed events.'**
  String varshphalIntro(String age);

  /// No description provided for @varshphalWindow.
  ///
  /// In en, this message translates to:
  /// **'{start} → {end}'**
  String varshphalWindow(String start, String end);

  /// No description provided for @varshphalLagna.
  ///
  /// In en, this message translates to:
  /// **'Varsha Lagna'**
  String get varshphalLagna;

  /// No description provided for @varshphalMuntha.
  ///
  /// In en, this message translates to:
  /// **'Muntha'**
  String get varshphalMuntha;

  /// No description provided for @varshphalYearLord.
  ///
  /// In en, this message translates to:
  /// **'Year lord (Varsheshwara)'**
  String get varshphalYearLord;

  /// No description provided for @varshphalTajika.
  ///
  /// In en, this message translates to:
  /// **'Tajika aspect'**
  String get varshphalTajika;

  /// No description provided for @varshphalMunthaLine.
  ///
  /// In en, this message translates to:
  /// **'Muntha in the {house} house — {theme}'**
  String varshphalMunthaLine(String house, String theme);

  /// No description provided for @varshphalChart.
  ///
  /// In en, this message translates to:
  /// **'Annual chart planets'**
  String get varshphalChart;

  /// No description provided for @prefsTransitAlerts.
  ///
  /// In en, this message translates to:
  /// **'Transit alerts'**
  String get prefsTransitAlerts;

  /// No description provided for @prefsTransitAlertsDesc.
  ///
  /// In en, this message translates to:
  /// **'A heads-up when a slow planet (Jupiter, Saturn) is about to change sign into a new house in your chart.'**
  String get prefsTransitAlertsDesc;

  /// No description provided for @errNetwork.
  ///
  /// In en, this message translates to:
  /// **'Could not reach the server. Check your connection.'**
  String get errNetwork;

  /// No description provided for @errTimeout.
  ///
  /// In en, this message translates to:
  /// **'The server took too long to respond.'**
  String get errTimeout;

  /// No description provided for @errSession.
  ///
  /// In en, this message translates to:
  /// **'Your session expired. Please sign in again.'**
  String get errSession;

  /// No description provided for @errWalletInsufficient.
  ///
  /// In en, this message translates to:
  /// **'Your wallet balance is too low for this.'**
  String get errWalletInsufficient;

  /// No description provided for @errRateLimited.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Please wait a little and try again.'**
  String get errRateLimited;

  /// No description provided for @errOtpInvalid.
  ///
  /// In en, this message translates to:
  /// **'The code is incorrect or has expired.'**
  String get errOtpInvalid;

  /// No description provided for @errOtpMaxAttempts.
  ///
  /// In en, this message translates to:
  /// **'Too many wrong attempts. Request a new code.'**
  String get errOtpMaxAttempts;

  /// No description provided for @errPromoNotRedeemable.
  ///
  /// In en, this message translates to:
  /// **'This coupon code can\'t be used.'**
  String get errPromoNotRedeemable;

  /// No description provided for @errRechargeInvalidAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter an amount within the allowed range.'**
  String get errRechargeInvalidAmount;

  /// No description provided for @errAuthWrongApp.
  ///
  /// In en, this message translates to:
  /// **'This number is registered for the other TalkAcharya app.'**
  String get errAuthWrongApp;

  /// No description provided for @errGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get errGeneric;

  /// No description provided for @homePanchangTitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Panchang'**
  String get homePanchangTitle;

  /// No description provided for @homeLiveNowTitle.
  ///
  /// In en, this message translates to:
  /// **'Live now'**
  String get homeLiveNowTitle;

  /// No description provided for @homeFreeToolsTitle.
  ///
  /// In en, this message translates to:
  /// **'Free tools'**
  String get homeFreeToolsTitle;

  /// No description provided for @homeResumeBtn.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get homeResumeBtn;

  /// No description provided for @homeAddBtn.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get homeAddBtn;

  /// No description provided for @homeNotifyMeBtn.
  ///
  /// In en, this message translates to:
  /// **'Notify me'**
  String get homeNotifyMeBtn;

  /// No description provided for @homeKundaliAction.
  ///
  /// In en, this message translates to:
  /// **'Kundali'**
  String get homeKundaliAction;

  /// No description provided for @homeMatchingAction.
  ///
  /// In en, this message translates to:
  /// **'Matching'**
  String get homeMatchingAction;

  /// No description provided for @homeHoroscopeAction.
  ///
  /// In en, this message translates to:
  /// **'Horoscope'**
  String get homeHoroscopeAction;

  /// No description provided for @homeVastuAction.
  ///
  /// In en, this message translates to:
  /// **'Vastu'**
  String get homeVastuAction;

  /// No description provided for @homeRetryBtn.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get homeRetryBtn;

  /// No description provided for @homeChooseSignTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your sign'**
  String get homeChooseSignTitle;

  /// No description provided for @homeChooseLanguageTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose language'**
  String get homeChooseLanguageTitle;

  /// No description provided for @homeLanguageTooltip.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get homeLanguageTooltip;

  /// No description provided for @homeLanguageSwitchError.
  ///
  /// In en, this message translates to:
  /// **'Could not switch: {error}'**
  String homeLanguageSwitchError(String error);

  /// No description provided for @homeComingSoonSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Coming soon!'**
  String get homeComingSoonSnackbar;

  /// No description provided for @homeTalkAgainTitle.
  ///
  /// In en, this message translates to:
  /// **'Talk again'**
  String get homeTalkAgainTitle;

  /// No description provided for @homeRechargeWalletTitle.
  ///
  /// In en, this message translates to:
  /// **'Recharge your wallet'**
  String get homeRechargeWalletTitle;

  /// No description provided for @homeTalkToAstrologerTitle.
  ///
  /// In en, this message translates to:
  /// **'Talk to an astrologer'**
  String get homeTalkToAstrologerTitle;

  /// No description provided for @kSignNameAries.
  ///
  /// In en, this message translates to:
  /// **'Aries'**
  String get kSignNameAries;

  /// No description provided for @kSignNameTaurus.
  ///
  /// In en, this message translates to:
  /// **'Taurus'**
  String get kSignNameTaurus;

  /// No description provided for @kSignNameGemini.
  ///
  /// In en, this message translates to:
  /// **'Gemini'**
  String get kSignNameGemini;

  /// No description provided for @kSignNameCancer.
  ///
  /// In en, this message translates to:
  /// **'Cancer'**
  String get kSignNameCancer;

  /// No description provided for @kSignNameLeo.
  ///
  /// In en, this message translates to:
  /// **'Leo'**
  String get kSignNameLeo;

  /// No description provided for @kSignNameVirgo.
  ///
  /// In en, this message translates to:
  /// **'Virgo'**
  String get kSignNameVirgo;

  /// No description provided for @kSignNameLibra.
  ///
  /// In en, this message translates to:
  /// **'Libra'**
  String get kSignNameLibra;

  /// No description provided for @kSignNameScorpio.
  ///
  /// In en, this message translates to:
  /// **'Scorpio'**
  String get kSignNameScorpio;

  /// No description provided for @kSignNameSagittarius.
  ///
  /// In en, this message translates to:
  /// **'Sagittarius'**
  String get kSignNameSagittarius;

  /// No description provided for @kSignNameCapricorn.
  ///
  /// In en, this message translates to:
  /// **'Capricorn'**
  String get kSignNameCapricorn;

  /// No description provided for @kSignNameAquarius.
  ///
  /// In en, this message translates to:
  /// **'Aquarius'**
  String get kSignNameAquarius;

  /// No description provided for @kSignNamePisces.
  ///
  /// In en, this message translates to:
  /// **'Pisces'**
  String get kSignNamePisces;

  /// No description provided for @kNakNameAshwini.
  ///
  /// In en, this message translates to:
  /// **'Ashwini'**
  String get kNakNameAshwini;

  /// No description provided for @kNakNameBharani.
  ///
  /// In en, this message translates to:
  /// **'Bharani'**
  String get kNakNameBharani;

  /// No description provided for @kNakNameKrittika.
  ///
  /// In en, this message translates to:
  /// **'Krittika'**
  String get kNakNameKrittika;

  /// No description provided for @kNakNameRohini.
  ///
  /// In en, this message translates to:
  /// **'Rohini'**
  String get kNakNameRohini;

  /// No description provided for @kNakNameMrigashira.
  ///
  /// In en, this message translates to:
  /// **'Mrigashira'**
  String get kNakNameMrigashira;

  /// No description provided for @kNakNameArdra.
  ///
  /// In en, this message translates to:
  /// **'Ardra'**
  String get kNakNameArdra;

  /// No description provided for @kNakNamePunarvasu.
  ///
  /// In en, this message translates to:
  /// **'Punarvasu'**
  String get kNakNamePunarvasu;

  /// No description provided for @kNakNamePushya.
  ///
  /// In en, this message translates to:
  /// **'Pushya'**
  String get kNakNamePushya;

  /// No description provided for @kNakNameAshlesha.
  ///
  /// In en, this message translates to:
  /// **'Ashlesha'**
  String get kNakNameAshlesha;

  /// No description provided for @kNakNameMagha.
  ///
  /// In en, this message translates to:
  /// **'Magha'**
  String get kNakNameMagha;

  /// No description provided for @kNakNamePurvaPhalguni.
  ///
  /// In en, this message translates to:
  /// **'Purva Phalguni'**
  String get kNakNamePurvaPhalguni;

  /// No description provided for @kNakNameUttaraPhalguni.
  ///
  /// In en, this message translates to:
  /// **'Uttara Phalguni'**
  String get kNakNameUttaraPhalguni;

  /// No description provided for @kNakNameHasta.
  ///
  /// In en, this message translates to:
  /// **'Hasta'**
  String get kNakNameHasta;

  /// No description provided for @kNakNameChitra.
  ///
  /// In en, this message translates to:
  /// **'Chitra'**
  String get kNakNameChitra;

  /// No description provided for @kNakNameSwati.
  ///
  /// In en, this message translates to:
  /// **'Swati'**
  String get kNakNameSwati;

  /// No description provided for @kNakNameVishakha.
  ///
  /// In en, this message translates to:
  /// **'Vishakha'**
  String get kNakNameVishakha;

  /// No description provided for @kNakNameAnuradha.
  ///
  /// In en, this message translates to:
  /// **'Anuradha'**
  String get kNakNameAnuradha;

  /// No description provided for @kNakNameJyeshtha.
  ///
  /// In en, this message translates to:
  /// **'Jyeshtha'**
  String get kNakNameJyeshtha;

  /// No description provided for @kNakNameMula.
  ///
  /// In en, this message translates to:
  /// **'Mula'**
  String get kNakNameMula;

  /// No description provided for @kNakNamePurvaAshadha.
  ///
  /// In en, this message translates to:
  /// **'Purva Ashadha'**
  String get kNakNamePurvaAshadha;

  /// No description provided for @kNakNameUttaraAshadha.
  ///
  /// In en, this message translates to:
  /// **'Uttara Ashadha'**
  String get kNakNameUttaraAshadha;

  /// No description provided for @kNakNameShravana.
  ///
  /// In en, this message translates to:
  /// **'Shravana'**
  String get kNakNameShravana;

  /// No description provided for @kNakNameDhanishta.
  ///
  /// In en, this message translates to:
  /// **'Dhanishta'**
  String get kNakNameDhanishta;

  /// No description provided for @kNakNameShatabhisha.
  ///
  /// In en, this message translates to:
  /// **'Shatabhisha'**
  String get kNakNameShatabhisha;

  /// No description provided for @kNakNamePurvaBhadrapada.
  ///
  /// In en, this message translates to:
  /// **'Purva Bhadrapada'**
  String get kNakNamePurvaBhadrapada;

  /// No description provided for @kNakNameUttaraBhadrapada.
  ///
  /// In en, this message translates to:
  /// **'Uttara Bhadrapada'**
  String get kNakNameUttaraBhadrapada;

  /// No description provided for @kNakNameRevati.
  ///
  /// In en, this message translates to:
  /// **'Revati'**
  String get kNakNameRevati;

  /// No description provided for @kChartNameD1.
  ///
  /// In en, this message translates to:
  /// **'Rashi'**
  String get kChartNameD1;

  /// No description provided for @kChartSigD1.
  ///
  /// In en, this message translates to:
  /// **'Physical body, overall life, everything'**
  String get kChartSigD1;

  /// No description provided for @kChartNameD2.
  ///
  /// In en, this message translates to:
  /// **'Hora'**
  String get kChartNameD2;

  /// No description provided for @kChartSigD2.
  ///
  /// In en, this message translates to:
  /// **'Wealth, financial prosperity'**
  String get kChartSigD2;

  /// No description provided for @kChartNameD3.
  ///
  /// In en, this message translates to:
  /// **'Drekkana'**
  String get kChartNameD3;

  /// No description provided for @kChartSigD3.
  ///
  /// In en, this message translates to:
  /// **'Siblings, courage, initiative'**
  String get kChartSigD3;

  /// No description provided for @kChartNameD4.
  ///
  /// In en, this message translates to:
  /// **'Chaturthamsha'**
  String get kChartNameD4;

  /// No description provided for @kChartSigD4.
  ///
  /// In en, this message translates to:
  /// **'Fortune, property, fixed assets, home'**
  String get kChartSigD4;

  /// No description provided for @kChartNameD5.
  ///
  /// In en, this message translates to:
  /// **'Panchamsha'**
  String get kChartNameD5;

  /// No description provided for @kChartSigD5.
  ///
  /// In en, this message translates to:
  /// **'Fame, authority, spiritual merit (punya)'**
  String get kChartSigD5;

  /// No description provided for @kChartNameD6.
  ///
  /// In en, this message translates to:
  /// **'Shashthamsha'**
  String get kChartNameD6;

  /// No description provided for @kChartSigD6.
  ///
  /// In en, this message translates to:
  /// **'Health, disease, debts, enemies'**
  String get kChartSigD6;

  /// No description provided for @kChartNameD7.
  ///
  /// In en, this message translates to:
  /// **'Saptamsha'**
  String get kChartNameD7;

  /// No description provided for @kChartSigD7.
  ///
  /// In en, this message translates to:
  /// **'Children, progeny, creativity'**
  String get kChartSigD7;

  /// No description provided for @kChartNameD8.
  ///
  /// In en, this message translates to:
  /// **'Ashtamsha'**
  String get kChartNameD8;

  /// No description provided for @kChartSigD8.
  ///
  /// In en, this message translates to:
  /// **'Sudden events, longevity troubles, obstacles'**
  String get kChartSigD8;

  /// No description provided for @kChartNameD9.
  ///
  /// In en, this message translates to:
  /// **'Navamsha'**
  String get kChartNameD9;

  /// No description provided for @kChartSigD9.
  ///
  /// In en, this message translates to:
  /// **'Spouse, dharma, inner self — the primary support chart'**
  String get kChartSigD9;

  /// No description provided for @kChartNameD10.
  ///
  /// In en, this message translates to:
  /// **'Dashamsha'**
  String get kChartNameD10;

  /// No description provided for @kChartSigD10.
  ///
  /// In en, this message translates to:
  /// **'Career, profession, status, achievement'**
  String get kChartSigD10;

  /// No description provided for @kChartNameD11.
  ///
  /// In en, this message translates to:
  /// **'Rudramsha'**
  String get kChartNameD11;

  /// No description provided for @kChartSigD11.
  ///
  /// In en, this message translates to:
  /// **'Death, destruction, gains from adversity (Labha)'**
  String get kChartSigD11;

  /// No description provided for @kChartNameD12.
  ///
  /// In en, this message translates to:
  /// **'Dvadashamsha'**
  String get kChartNameD12;

  /// No description provided for @kChartSigD12.
  ///
  /// In en, this message translates to:
  /// **'Parents, ancestry, inherited karma'**
  String get kChartSigD12;

  /// No description provided for @kChartNameD16.
  ///
  /// In en, this message translates to:
  /// **'Shodashamsha'**
  String get kChartNameD16;

  /// No description provided for @kChartSigD16.
  ///
  /// In en, this message translates to:
  /// **'Vehicles, comforts, luxuries, happiness'**
  String get kChartSigD16;

  /// No description provided for @kChartNameD20.
  ///
  /// In en, this message translates to:
  /// **'Vimshamsha'**
  String get kChartNameD20;

  /// No description provided for @kChartSigD20.
  ///
  /// In en, this message translates to:
  /// **'Spiritual practice, worship, devotion'**
  String get kChartSigD20;

  /// No description provided for @kChartNameD24.
  ///
  /// In en, this message translates to:
  /// **'Chaturvimshamsha'**
  String get kChartNameD24;

  /// No description provided for @kChartSigD24.
  ///
  /// In en, this message translates to:
  /// **'Education, learning, knowledge'**
  String get kChartSigD24;

  /// No description provided for @kChartNameD27.
  ///
  /// In en, this message translates to:
  /// **'Saptavimshamsha'**
  String get kChartNameD27;

  /// No description provided for @kChartSigD27.
  ///
  /// In en, this message translates to:
  /// **'Strength and weakness, stamina'**
  String get kChartSigD27;

  /// No description provided for @kChartNameD30.
  ///
  /// In en, this message translates to:
  /// **'Trimshamsha'**
  String get kChartNameD30;

  /// No description provided for @kChartSigD30.
  ///
  /// In en, this message translates to:
  /// **'Misfortunes, evils, moral character'**
  String get kChartSigD30;

  /// No description provided for @kChartNameD40.
  ///
  /// In en, this message translates to:
  /// **'Chatvarimshamsha'**
  String get kChartNameD40;

  /// No description provided for @kChartSigD40.
  ///
  /// In en, this message translates to:
  /// **'Maternal legacy, auspicious/inauspicious effects'**
  String get kChartSigD40;

  /// No description provided for @kChartNameD45.
  ///
  /// In en, this message translates to:
  /// **'Akshavedamsha'**
  String get kChartNameD45;

  /// No description provided for @kChartSigD45.
  ///
  /// In en, this message translates to:
  /// **'Paternal legacy, overall character and conduct'**
  String get kChartSigD45;

  /// No description provided for @kChartNameD60.
  ///
  /// In en, this message translates to:
  /// **'Shashtiamsha'**
  String get kChartNameD60;

  /// No description provided for @kChartSigD60.
  ///
  /// In en, this message translates to:
  /// **'Past-life karma, the finest layer — overall'**
  String get kChartSigD60;

  /// No description provided for @kChartNameMoon.
  ///
  /// In en, this message translates to:
  /// **'Moon chart (Chandra)'**
  String get kChartNameMoon;

  /// No description provided for @kChartSigMoon.
  ///
  /// In en, this message translates to:
  /// **'The mind and emotions — the rasi chart read from the Moon'**
  String get kChartSigMoon;

  /// No description provided for @kChartNameChalit.
  ///
  /// In en, this message translates to:
  /// **'Bhava Chalit'**
  String get kChartNameChalit;

  /// No description provided for @kChartSigChalit.
  ///
  /// In en, this message translates to:
  /// **'House results by the actual bhava cusps (Sripati), not whole sign'**
  String get kChartSigChalit;

  /// No description provided for @kChartNameTransit.
  ///
  /// In en, this message translates to:
  /// **'Transit (Gochar)'**
  String get kChartNameTransit;

  /// No description provided for @kChartSigTransit.
  ///
  /// In en, this message translates to:
  /// **'Current grahas over the natal houses'**
  String get kChartSigTransit;

  /// No description provided for @kChartShortMoon.
  ///
  /// In en, this message translates to:
  /// **'Moon'**
  String get kChartShortMoon;

  /// No description provided for @kChartShortChalit.
  ///
  /// In en, this message translates to:
  /// **'Chalit'**
  String get kChartShortChalit;

  /// No description provided for @kChartShortTransit.
  ///
  /// In en, this message translates to:
  /// **'Transit'**
  String get kChartShortTransit;

  /// No description provided for @kChAscendant.
  ///
  /// In en, this message translates to:
  /// **'Ascendant'**
  String get kChAscendant;

  /// No description provided for @kChLagnaVargottama.
  ///
  /// In en, this message translates to:
  /// **'Lagna vargottama'**
  String get kChLagnaVargottama;

  /// No description provided for @kChAsOf.
  ///
  /// In en, this message translates to:
  /// **'As of {when}'**
  String kChAsOf(Object when);

  /// No description provided for @kChUnverified.
  ///
  /// In en, this message translates to:
  /// **'This division is not yet verified against DrikPanchang — treat the placements as experimental.'**
  String get kChUnverified;

  /// No description provided for @kChChalitShiftedOne.
  ///
  /// In en, this message translates to:
  /// **'{planets} sits in a different bhava than the whole-sign house.'**
  String kChChalitShiftedOne(Object planets);

  /// No description provided for @kChChalitShiftedMany.
  ///
  /// In en, this message translates to:
  /// **'{planets} sit in a different bhava than the whole-sign house.'**
  String kChChalitShiftedMany(Object planets);

  /// No description provided for @kChColPlanet.
  ///
  /// In en, this message translates to:
  /// **'PLANET'**
  String get kChColPlanet;

  /// No description provided for @kChColSign.
  ///
  /// In en, this message translates to:
  /// **'SIGN'**
  String get kChColSign;

  /// No description provided for @kChColDegree.
  ///
  /// In en, this message translates to:
  /// **'DEG'**
  String get kChColDegree;

  /// No description provided for @kChColHouse.
  ///
  /// In en, this message translates to:
  /// **'HOUSE'**
  String get kChColHouse;

  /// No description provided for @kChColBhava.
  ///
  /// In en, this message translates to:
  /// **'BHAVA'**
  String get kChColBhava;

  /// No description provided for @kChColFromMoon.
  ///
  /// In en, this message translates to:
  /// **'MOON'**
  String get kChColFromMoon;

  /// No description provided for @kChLegend.
  ///
  /// In en, this message translates to:
  /// **'Legend'**
  String get kChLegend;

  /// No description provided for @kChLegendNote.
  ///
  /// In en, this message translates to:
  /// **'℞ retrograde   ⬦ vargottama   ← moved bhava (chalit)\nNorth: cell number = rasi (1 Aries … 12 Pisces), 1st house is top-centre.'**
  String get kChLegendNote;

  /// No description provided for @kChNorthIndian.
  ///
  /// In en, this message translates to:
  /// **'North Indian'**
  String get kChNorthIndian;

  /// No description provided for @kChSouthIndian.
  ///
  /// In en, this message translates to:
  /// **'South Indian'**
  String get kChSouthIndian;

  /// No description provided for @kChPickerCharts.
  ///
  /// In en, this message translates to:
  /// **'Charts'**
  String get kChPickerCharts;

  /// No description provided for @kChPickerDivisional.
  ///
  /// In en, this message translates to:
  /// **'Divisional charts (Varga)'**
  String get kChPickerDivisional;

  /// No description provided for @kOvTitle.
  ///
  /// In en, this message translates to:
  /// **'Kundali'**
  String get kOvTitle;

  /// No description provided for @kOvTitleNamed.
  ///
  /// In en, this message translates to:
  /// **'{name}’s Kundali'**
  String kOvTitleNamed(Object name);

  /// No description provided for @kOvDownloadPdf.
  ///
  /// In en, this message translates to:
  /// **'Download PDF'**
  String get kOvDownloadPdf;

  /// No description provided for @kOvShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get kOvShare;

  /// No description provided for @kOvMoonSignLabel.
  ///
  /// In en, this message translates to:
  /// **'Moon sign · Rashi'**
  String get kOvMoonSignLabel;

  /// No description provided for @kOvLagnaChip.
  ///
  /// In en, this message translates to:
  /// **'Lagna · {sign}'**
  String kOvLagnaChip(Object sign);

  /// No description provided for @kOvNakshatraChip.
  ///
  /// In en, this message translates to:
  /// **'Nakshatra · {name}'**
  String kOvNakshatraChip(Object name);

  /// No description provided for @kOvTimeApprox.
  ///
  /// In en, this message translates to:
  /// **'Birth time approximate'**
  String get kOvTimeApprox;

  /// No description provided for @kOvEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get kOvEdit;

  /// No description provided for @kOvLagnaChart.
  ///
  /// In en, this message translates to:
  /// **'Lagna chart'**
  String get kOvLagnaChart;

  /// No description provided for @kOvD1Rasi.
  ///
  /// In en, this message translates to:
  /// **'D1 Rasi'**
  String get kOvD1Rasi;

  /// No description provided for @kOvOpenFullChart.
  ///
  /// In en, this message translates to:
  /// **'Open full chart'**
  String get kOvOpenFullChart;

  /// No description provided for @kOvDashaUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Dasha unavailable right now.'**
  String get kOvDashaUnavailable;

  /// No description provided for @kOvDashaRunning.
  ///
  /// In en, this message translates to:
  /// **'You are currently running'**
  String get kOvDashaRunning;

  /// No description provided for @kOvMahadasha.
  ///
  /// In en, this message translates to:
  /// **'{planet} Mahadasha'**
  String kOvMahadasha(Object planet);

  /// No description provided for @kOvSubPeriods.
  ///
  /// In en, this message translates to:
  /// **'{antar} sub-period · {pratyantar} pratyantar'**
  String kOvSubPeriods(Object antar, Object pratyantar);

  /// No description provided for @kOvDashaProgress.
  ///
  /// In en, this message translates to:
  /// **'{start} → {end}  ·  {percent}% through'**
  String kOvDashaProgress(Object end, Object percent, Object start);

  /// No description provided for @kOvSeeTimeline.
  ///
  /// In en, this message translates to:
  /// **'See full timeline'**
  String get kOvSeeTimeline;

  /// No description provided for @kOvAtAGlance.
  ///
  /// In en, this message translates to:
  /// **'At a glance'**
  String get kOvAtAGlance;

  /// No description provided for @kOvMangalDosha.
  ///
  /// In en, this message translates to:
  /// **'Mangal Dosha'**
  String get kOvMangalDosha;

  /// No description provided for @kOvManglik.
  ///
  /// In en, this message translates to:
  /// **'Manglik'**
  String get kOvManglik;

  /// No description provided for @kOvNotManglik.
  ///
  /// In en, this message translates to:
  /// **'Not Manglik'**
  String get kOvNotManglik;

  /// No description provided for @kOvMangalFrom.
  ///
  /// In en, this message translates to:
  /// **'From {refs}'**
  String kOvMangalFrom(Object refs);

  /// No description provided for @kOvMarsClear.
  ///
  /// In en, this message translates to:
  /// **'Mars is clear'**
  String get kOvMarsClear;

  /// No description provided for @kOvMangalCancelled.
  ///
  /// In en, this message translates to:
  /// **'Present, but cancelled in your chart'**
  String get kOvMangalCancelled;

  /// No description provided for @kOvMangalLevelFrom.
  ///
  /// In en, this message translates to:
  /// **'{level} · from {refs}'**
  String kOvMangalLevelFrom(Object level, Object refs);

  /// No description provided for @kOvRefLagna.
  ///
  /// In en, this message translates to:
  /// **'Lagna'**
  String get kOvRefLagna;

  /// No description provided for @kOvYogas.
  ///
  /// In en, this message translates to:
  /// **'Yogas'**
  String get kOvYogas;

  /// No description provided for @kOvYogasFound.
  ///
  /// In en, this message translates to:
  /// **'{count} found'**
  String kOvYogasFound(Object count);

  /// No description provided for @kOvNakshatra.
  ///
  /// In en, this message translates to:
  /// **'Nakshatra'**
  String get kOvNakshatra;

  /// No description provided for @kOvLagnaLord.
  ///
  /// In en, this message translates to:
  /// **'Lagna lord'**
  String get kOvLagnaLord;

  /// No description provided for @kOvExInsights.
  ///
  /// In en, this message translates to:
  /// **'Personality & life overview'**
  String get kOvExInsights;

  /// No description provided for @kOvExInsightsSub.
  ///
  /// In en, this message translates to:
  /// **'A free reading of your chart — nature, work, marriage & more'**
  String get kOvExInsightsSub;

  /// No description provided for @kOvExForecast.
  ///
  /// In en, this message translates to:
  /// **'Written forecast'**
  String get kOvExForecast;

  /// No description provided for @kOvExForecastSub.
  ///
  /// In en, this message translates to:
  /// **'A paid forecast for one area of life, written by an astrologer'**
  String get kOvExForecastSub;

  /// No description provided for @kOvExPlanets.
  ///
  /// In en, this message translates to:
  /// **'Planets & positions'**
  String get kOvExPlanets;

  /// No description provided for @kOvExPlanetsSub.
  ///
  /// In en, this message translates to:
  /// **'Where each planet sits and what it does'**
  String get kOvExPlanetsSub;

  /// No description provided for @kOvExDasha.
  ///
  /// In en, this message translates to:
  /// **'Dasha periods'**
  String get kOvExDasha;

  /// No description provided for @kOvExDashaSub.
  ///
  /// In en, this message translates to:
  /// **'Your life timeline — Vimshottari'**
  String get kOvExDashaSub;

  /// No description provided for @kOvExVarshphal.
  ///
  /// In en, this message translates to:
  /// **'Varshphal (annual chart)'**
  String get kOvExVarshphal;

  /// No description provided for @kOvExVarshphalSub.
  ///
  /// In en, this message translates to:
  /// **'This solar-return year — Muntha, year lord & Tajika aspect'**
  String get kOvExVarshphalSub;

  /// No description provided for @kOvExYogas.
  ///
  /// In en, this message translates to:
  /// **'Yogas & Doshas'**
  String get kOvExYogas;

  /// No description provided for @kOvExYogasSub.
  ///
  /// In en, this message translates to:
  /// **'Special combinations in your chart'**
  String get kOvExYogasSub;

  /// No description provided for @kOvExRemedies.
  ///
  /// In en, this message translates to:
  /// **'Remedies'**
  String get kOvExRemedies;

  /// No description provided for @kOvExRemediesSub.
  ///
  /// In en, this message translates to:
  /// **'Traditional mantras, daan and practices for your chart'**
  String get kOvExRemediesSub;

  /// No description provided for @kOvExUpaya.
  ///
  /// In en, this message translates to:
  /// **'Gemstones & upaya'**
  String get kOvExUpaya;

  /// No description provided for @kOvExUpayaSub.
  ///
  /// In en, this message translates to:
  /// **'Per-planet gemstone, colour, day & mantra — gemstones gated'**
  String get kOvExUpayaSub;

  /// No description provided for @kOvExLalKitab.
  ///
  /// In en, this message translates to:
  /// **'Lal Kitab'**
  String get kOvExLalKitab;

  /// No description provided for @kOvExLalKitabSub.
  ///
  /// In en, this message translates to:
  /// **'Inherited debts (rin) and their simple, free totka remedies'**
  String get kOvExLalKitabSub;

  /// No description provided for @kOvExTransits.
  ///
  /// In en, this message translates to:
  /// **'Transits & Sade Sati'**
  String get kOvExTransits;

  /// No description provided for @kOvExTransitsSub.
  ///
  /// In en, this message translates to:
  /// **'What the sky is doing right now'**
  String get kOvExTransitsSub;

  /// No description provided for @kOvExSadeSati.
  ///
  /// In en, this message translates to:
  /// **'Sade Sati & Dhaiya calendar'**
  String get kOvExSadeSati;

  /// No description provided for @kOvExSadeSatiSub.
  ///
  /// In en, this message translates to:
  /// **'Every Saturn window over your life, with dates'**
  String get kOvExSadeSatiSub;

  /// No description provided for @kOvExMuhurta.
  ///
  /// In en, this message translates to:
  /// **'Today\'s timing'**
  String get kOvExMuhurta;

  /// No description provided for @kOvExMuhurtaSub.
  ///
  /// In en, this message translates to:
  /// **'Choghadiya & Hora, with your best windows marked'**
  String get kOvExMuhurtaSub;

  /// No description provided for @kOvExHouses.
  ///
  /// In en, this message translates to:
  /// **'Houses (Bhava)'**
  String get kOvExHouses;

  /// No description provided for @kOvExHousesSub.
  ///
  /// In en, this message translates to:
  /// **'A reading for each of the 12 houses'**
  String get kOvExHousesSub;

  /// No description provided for @kOvExNumerology.
  ///
  /// In en, this message translates to:
  /// **'Numerology & Lo Shu grid'**
  String get kOvExNumerology;

  /// No description provided for @kOvExNumerologySub.
  ///
  /// In en, this message translates to:
  /// **'Your numbers from date of birth — days, colours, birth grid'**
  String get kOvExNumerologySub;

  /// No description provided for @kOvExAdvanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced reports'**
  String get kOvExAdvanced;

  /// No description provided for @kOvExAdvancedSub.
  ///
  /// In en, this message translates to:
  /// **'Ashtakavarga, Shadbala, KP, Jaimini'**
  String get kOvExAdvancedSub;

  /// No description provided for @kOvAskAstrologer.
  ///
  /// In en, this message translates to:
  /// **'Ask an astrologer about your kundali'**
  String get kOvAskAstrologer;

  /// No description provided for @kReadingCardTitle.
  ///
  /// In en, this message translates to:
  /// **'What this means'**
  String get kReadingCardTitle;

  /// No description provided for @kSsTitle.
  ///
  /// In en, this message translates to:
  /// **'Sade Sati · {phase} phase'**
  String kSsTitle(Object phase);

  /// No description provided for @kSsPhaseRising.
  ///
  /// In en, this message translates to:
  /// **'Rising (1 of 3)'**
  String get kSsPhaseRising;

  /// No description provided for @kSsPhasePeak.
  ///
  /// In en, this message translates to:
  /// **'Peak (2 of 3)'**
  String get kSsPhasePeak;

  /// No description provided for @kSsPhaseSetting.
  ///
  /// In en, this message translates to:
  /// **'Setting (3 of 3)'**
  String get kSsPhaseSetting;

  /// No description provided for @kSsRising.
  ///
  /// In en, this message translates to:
  /// **'Rising'**
  String get kSsRising;

  /// No description provided for @kSsPeak.
  ///
  /// In en, this message translates to:
  /// **'Peak'**
  String get kSsPeak;

  /// No description provided for @kSsSetting.
  ///
  /// In en, this message translates to:
  /// **'Setting'**
  String get kSsSetting;

  /// No description provided for @kSsNotCurse.
  ///
  /// In en, this message translates to:
  /// **'Sade Sati is a period of hard work and maturing — not a curse. Steady, honest effort is rewarded.'**
  String get kSsNotCurse;

  /// No description provided for @kSsWhatForMe.
  ///
  /// In en, this message translates to:
  /// **'What this means for me'**
  String get kSsWhatForMe;

  /// No description provided for @kSsPanotiTitle.
  ///
  /// In en, this message translates to:
  /// **'Small Panoti — {type}'**
  String kSsPanotiTitle(Object type);

  /// No description provided for @kSsPanotiBody.
  ///
  /// In en, this message translates to:
  /// **'A shorter Saturn phase (about 2½ years) that asks for patience with health, effort and daily obstacles.'**
  String get kSsPanotiBody;

  /// No description provided for @kSsSeeTransits.
  ///
  /// In en, this message translates to:
  /// **'See transits'**
  String get kSsSeeTransits;

  /// No description provided for @kSsSkyNow.
  ///
  /// In en, this message translates to:
  /// **'Right now in the sky'**
  String get kSsSkyNow;

  /// No description provided for @kSsJupiterGood.
  ///
  /// In en, this message translates to:
  /// **'Jupiter is transiting favourably for you — a supportive window for growth, learning and money.'**
  String get kSsJupiterGood;

  /// No description provided for @kSsJupiterNeutral.
  ///
  /// In en, this message translates to:
  /// **'No Sade Sati or major Saturn phase is active. Jupiter’s transit is neutral for you right now.'**
  String get kSsJupiterNeutral;

  /// No description provided for @kSsSeeAllTransits.
  ///
  /// In en, this message translates to:
  /// **'See all transits'**
  String get kSsSeeAllTransits;

  /// No description provided for @kFcTitle.
  ///
  /// In en, this message translates to:
  /// **'Birth chart'**
  String get kFcTitle;

  /// No description provided for @kFcTransitingGrahas.
  ///
  /// In en, this message translates to:
  /// **'Transiting grahas'**
  String get kFcTransitingGrahas;

  /// No description provided for @kFcPlanets.
  ///
  /// In en, this message translates to:
  /// **'Planets'**
  String get kFcPlanets;

  /// No description provided for @kFcAllHouses.
  ///
  /// In en, this message translates to:
  /// **'All 12 houses & readings'**
  String get kFcAllHouses;

  /// No description provided for @kFcAllCharts.
  ///
  /// In en, this message translates to:
  /// **'All charts — D1 to D60'**
  String get kFcAllCharts;

  /// No description provided for @kFcAllChartsTooltip.
  ///
  /// In en, this message translates to:
  /// **'All charts'**
  String get kFcAllChartsTooltip;

  /// No description provided for @kFcLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load this chart'**
  String get kFcLoadError;

  /// No description provided for @kFcTwelveHouses.
  ///
  /// In en, this message translates to:
  /// **'The 12 houses'**
  String get kFcTwelveHouses;

  /// No description provided for @kFcNoPlanets.
  ///
  /// In en, this message translates to:
  /// **'No planets'**
  String get kFcNoPlanets;

  /// No description provided for @kBdTithi.
  ///
  /// In en, this message translates to:
  /// **'{key, select, other{{raw}}}'**
  String kBdTithi(String key, Object raw);

  /// No description provided for @kBdPaksha.
  ///
  /// In en, this message translates to:
  /// **'{key, select, other{{raw}}}'**
  String kBdPaksha(String key, Object raw);

  /// No description provided for @kBdYoga.
  ///
  /// In en, this message translates to:
  /// **'{key, select, other{{raw}}}'**
  String kBdYoga(String key, Object raw);

  /// No description provided for @kBdKarana.
  ///
  /// In en, this message translates to:
  /// **'{key, select, other{{raw}}}'**
  String kBdKarana(String key, Object raw);

  /// No description provided for @kBdVarna.
  ///
  /// In en, this message translates to:
  /// **'{key, select, other{{raw}}}'**
  String kBdVarna(String key, Object raw);

  /// No description provided for @kBdVashya.
  ///
  /// In en, this message translates to:
  /// **'{key, select, other{{raw}}}'**
  String kBdVashya(String key, Object raw);

  /// No description provided for @kBdYoni.
  ///
  /// In en, this message translates to:
  /// **'{key, select, other{{raw}}}'**
  String kBdYoni(String key, Object raw);

  /// No description provided for @kBdGana.
  ///
  /// In en, this message translates to:
  /// **'{key, select, other{{raw}}}'**
  String kBdGana(String key, Object raw);

  /// No description provided for @kBdNadi.
  ///
  /// In en, this message translates to:
  /// **'{key, select, other{{raw}}}'**
  String kBdNadi(String key, Object raw);

  /// No description provided for @kBdTara.
  ///
  /// In en, this message translates to:
  /// **'{key, select, other{{raw}}}'**
  String kBdTara(String key, Object raw);

  /// No description provided for @kBdYunja.
  ///
  /// In en, this message translates to:
  /// **'{key, select, other{{raw}}}'**
  String kBdYunja(String key, Object raw);

  /// No description provided for @horoTitle.
  ///
  /// In en, this message translates to:
  /// **'Horoscope'**
  String get horoTitle;

  /// No description provided for @horoReadFull.
  ///
  /// In en, this message translates to:
  /// **'Read full horoscope'**
  String get horoReadFull;

  /// No description provided for @horoSpanYesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get horoSpanYesterday;

  /// No description provided for @horoSpanToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get horoSpanToday;

  /// No description provided for @horoSpanTomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get horoSpanTomorrow;

  /// No description provided for @horoSpanWeek.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get horoSpanWeek;

  /// No description provided for @horoSpanMonth.
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get horoSpanMonth;

  /// No description provided for @horoAreaLove.
  ///
  /// In en, this message translates to:
  /// **'Love'**
  String get horoAreaLove;

  /// No description provided for @horoAreaCareer.
  ///
  /// In en, this message translates to:
  /// **'Career'**
  String get horoAreaCareer;

  /// No description provided for @horoAreaMoney.
  ///
  /// In en, this message translates to:
  /// **'Money'**
  String get horoAreaMoney;

  /// No description provided for @horoAreaHealth.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get horoAreaHealth;

  /// No description provided for @horoOverall.
  ///
  /// In en, this message translates to:
  /// **'Overall'**
  String get horoOverall;

  /// No description provided for @horoOutOfFive.
  ///
  /// In en, this message translates to:
  /// **'out of 5'**
  String get horoOutOfFive;

  /// No description provided for @horoToneSupportive.
  ///
  /// In en, this message translates to:
  /// **'Supportive'**
  String get horoToneSupportive;

  /// No description provided for @horoToneBalanced.
  ///
  /// In en, this message translates to:
  /// **'Balanced'**
  String get horoToneBalanced;

  /// No description provided for @horoToneChallenging.
  ///
  /// In en, this message translates to:
  /// **'Needs care'**
  String get horoToneChallenging;

  /// No description provided for @horoLuckyColour.
  ///
  /// In en, this message translates to:
  /// **'Lucky colour'**
  String get horoLuckyColour;

  /// No description provided for @horoLuckyNumber.
  ///
  /// In en, this message translates to:
  /// **'Lucky number'**
  String get horoLuckyNumber;

  /// No description provided for @horoLuckyPlanet.
  ///
  /// In en, this message translates to:
  /// **'Strongest planet'**
  String get horoLuckyPlanet;

  /// No description provided for @horoBestDays.
  ///
  /// In en, this message translates to:
  /// **'Your best days'**
  String get horoBestDays;

  /// No description provided for @horoTipTitle.
  ///
  /// In en, this message translates to:
  /// **'Remedy & tip'**
  String get horoTipTitle;

  /// No description provided for @horoTipFor.
  ///
  /// In en, this message translates to:
  /// **'Remedy for {planet}'**
  String horoTipFor(String planet);

  /// No description provided for @horoWhyTitle.
  ///
  /// In en, this message translates to:
  /// **'Why the stars say this'**
  String get horoWhyTitle;

  /// No description provided for @horoWhyBody.
  ///
  /// In en, this message translates to:
  /// **'Vedic horoscopes are read from where each planet is transiting, counted from your Moon sign. Arrows show whether a placement supports you or asks for care.'**
  String get horoWhyBody;

  /// No description provided for @horoMoonLine.
  ///
  /// In en, this message translates to:
  /// **'Moon in {sign} · {nakshatra} · house {house}'**
  String horoMoonLine(String sign, String nakshatra, String house);

  /// No description provided for @horoHouseN.
  ///
  /// In en, this message translates to:
  /// **'House {n}'**
  String horoHouseN(String n);

  /// No description provided for @horoAboutSign.
  ///
  /// In en, this message translates to:
  /// **'About {sign}'**
  String horoAboutSign(String sign);

  /// No description provided for @horoElement.
  ///
  /// In en, this message translates to:
  /// **'Element'**
  String get horoElement;

  /// No description provided for @horoRuler.
  ///
  /// In en, this message translates to:
  /// **'Ruling planet'**
  String get horoRuler;

  /// No description provided for @horoQuality.
  ///
  /// In en, this message translates to:
  /// **'Nature'**
  String get horoQuality;

  /// No description provided for @horoElementFire.
  ///
  /// In en, this message translates to:
  /// **'Fire'**
  String get horoElementFire;

  /// No description provided for @horoElementEarth.
  ///
  /// In en, this message translates to:
  /// **'Earth'**
  String get horoElementEarth;

  /// No description provided for @horoElementAir.
  ///
  /// In en, this message translates to:
  /// **'Air'**
  String get horoElementAir;

  /// No description provided for @horoElementWater.
  ///
  /// In en, this message translates to:
  /// **'Water'**
  String get horoElementWater;

  /// No description provided for @horoQualityMovable.
  ///
  /// In en, this message translates to:
  /// **'Movable'**
  String get horoQualityMovable;

  /// No description provided for @horoQualityFixed.
  ///
  /// In en, this message translates to:
  /// **'Fixed'**
  String get horoQualityFixed;

  /// No description provided for @horoQualityDual.
  ///
  /// In en, this message translates to:
  /// **'Dual'**
  String get horoQualityDual;

  /// No description provided for @horoChangeSign.
  ///
  /// In en, this message translates to:
  /// **'Change sign'**
  String get horoChangeSign;

  /// No description provided for @horoChooseSign.
  ///
  /// In en, this message translates to:
  /// **'Choose your sign'**
  String get horoChooseSign;

  /// No description provided for @horoWhichSignTitle.
  ///
  /// In en, this message translates to:
  /// **'Which sign should I pick?'**
  String get horoWhichSignTitle;

  /// No description provided for @horoWhichSignBody.
  ///
  /// In en, this message translates to:
  /// **'Vedic horoscopes are read from your Moon sign (Rashi) — the sign the Moon was in when you were born. It is often different from your Western sun sign. Your Kundali shows your Moon sign; pick that here for the most accurate reading.'**
  String get horoWhichSignBody;

  /// No description provided for @horoOpenKundali.
  ///
  /// In en, this message translates to:
  /// **'See my Moon sign in Kundali'**
  String get horoOpenKundali;

  /// No description provided for @horoCtaTitle.
  ///
  /// In en, this message translates to:
  /// **'Want a reading just for you?'**
  String get horoCtaTitle;

  /// No description provided for @horoCtaBody.
  ///
  /// In en, this message translates to:
  /// **'This forecast is for everyone born under {sign}. An astrologer can read your personal chart.'**
  String horoCtaBody(String sign);

  /// No description provided for @horoCtaButton.
  ///
  /// In en, this message translates to:
  /// **'Talk to an astrologer'**
  String get horoCtaButton;

  /// No description provided for @horoShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get horoShare;

  /// No description provided for @horoEditorialBadge.
  ///
  /// In en, this message translates to:
  /// **'Written by our astrologers'**
  String get horoEditorialBadge;

  /// No description provided for @horoError.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t load the horoscope'**
  String get horoError;

  /// No description provided for @horoSourceNote.
  ///
  /// In en, this message translates to:
  /// **'Based on live planetary transits from your Moon sign. For guidance, not certainty.'**
  String get horoSourceNote;

  /// No description provided for @matchTitle.
  ///
  /// In en, this message translates to:
  /// **'Kundali Milan'**
  String get matchTitle;

  /// No description provided for @matchHeroTitle.
  ///
  /// In en, this message translates to:
  /// **'Match two kundalis'**
  String get matchHeroTitle;

  /// No description provided for @matchHeroBody.
  ///
  /// In en, this message translates to:
  /// **'Guna Milan, Manglik and dosha check in seconds.'**
  String get matchHeroBody;

  /// No description provided for @matchBoy.
  ///
  /// In en, this message translates to:
  /// **'Boy'**
  String get matchBoy;

  /// No description provided for @matchGirl.
  ///
  /// In en, this message translates to:
  /// **'Girl'**
  String get matchGirl;

  /// No description provided for @matchSwap.
  ///
  /// In en, this message translates to:
  /// **'Swap'**
  String get matchSwap;

  /// No description provided for @matchChoosePerson.
  ///
  /// In en, this message translates to:
  /// **'Choose person'**
  String get matchChoosePerson;

  /// No description provided for @matchTapToSelect.
  ///
  /// In en, this message translates to:
  /// **'Tap to select'**
  String get matchTapToSelect;

  /// No description provided for @matchRunCta.
  ///
  /// In en, this message translates to:
  /// **'Check compatibility'**
  String get matchRunCta;

  /// No description provided for @matchPickBothHint.
  ///
  /// In en, this message translates to:
  /// **'Pick both people to see your match score.'**
  String get matchPickBothHint;

  /// No description provided for @matchPickBoyTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose the boy\'s birth details'**
  String get matchPickBoyTitle;

  /// No description provided for @matchPickGirlTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose the girl\'s birth details'**
  String get matchPickGirlTitle;

  /// No description provided for @matchAddPerson.
  ///
  /// In en, this message translates to:
  /// **'Add a new person'**
  String get matchAddPerson;

  /// No description provided for @matchAddPersonHint.
  ///
  /// In en, this message translates to:
  /// **'Birth date, time and place'**
  String get matchAddPersonHint;

  /// No description provided for @matchNoProfiles.
  ///
  /// In en, this message translates to:
  /// **'No saved birth details yet. Add a person to get started.'**
  String get matchNoProfiles;

  /// No description provided for @matchHowTitle.
  ///
  /// In en, this message translates to:
  /// **'How it works'**
  String get matchHowTitle;

  /// No description provided for @matchStep1Title.
  ///
  /// In en, this message translates to:
  /// **'Choose two people'**
  String get matchStep1Title;

  /// No description provided for @matchStep1Body.
  ///
  /// In en, this message translates to:
  /// **'Use saved birth details or add new ones — time and place make it accurate.'**
  String get matchStep1Body;

  /// No description provided for @matchStep2Title.
  ///
  /// In en, this message translates to:
  /// **'We compare both Moon charts'**
  String get matchStep2Title;

  /// No description provided for @matchStep2Body.
  ///
  /// In en, this message translates to:
  /// **'Eight kootas — from temperament to health — are scored the traditional Ashtakoota way.'**
  String get matchStep2Body;

  /// No description provided for @matchStep3Title.
  ///
  /// In en, this message translates to:
  /// **'Get your score and dosha check'**
  String get matchStep3Title;

  /// No description provided for @matchStep3Body.
  ///
  /// In en, this message translates to:
  /// **'A score out of 36, Manglik compatibility and what each part means.'**
  String get matchStep3Body;

  /// No description provided for @matchHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Your matches'**
  String get matchHistoryTitle;

  /// No description provided for @matchHistoryEmpty.
  ///
  /// In en, this message translates to:
  /// **'Your matches will appear here so you can revisit them anytime.'**
  String get matchHistoryEmpty;

  /// No description provided for @matchRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get matchRetry;

  /// No description provided for @matchPairNames.
  ///
  /// In en, this message translates to:
  /// **'{boy} & {girl}'**
  String matchPairNames(String boy, String girl);

  /// No description provided for @matchResultTitle.
  ///
  /// In en, this message translates to:
  /// **'Match result'**
  String get matchResultTitle;

  /// No description provided for @matchOutOf36.
  ///
  /// In en, this message translates to:
  /// **'out of 36'**
  String get matchOutOf36;

  /// No description provided for @matchShareScore.
  ///
  /// In en, this message translates to:
  /// **'Guna Milan: {score}/36 · {verdict}'**
  String matchShareScore(String score, String verdict);

  /// No description provided for @matchVerdictExcellent.
  ///
  /// In en, this message translates to:
  /// **'Excellent match'**
  String get matchVerdictExcellent;

  /// No description provided for @matchVerdictGood.
  ///
  /// In en, this message translates to:
  /// **'Good match'**
  String get matchVerdictGood;

  /// No description provided for @matchVerdictAverage.
  ///
  /// In en, this message translates to:
  /// **'Average match'**
  String get matchVerdictAverage;

  /// No description provided for @matchVerdictLow.
  ///
  /// In en, this message translates to:
  /// **'Needs a closer look'**
  String get matchVerdictLow;

  /// No description provided for @matchVerdictExcellentBody.
  ///
  /// In en, this message translates to:
  /// **'Most kootas align — traditionally a sign of a harmonious, supportive marriage.'**
  String get matchVerdictExcellentBody;

  /// No description provided for @matchVerdictGoodBody.
  ///
  /// In en, this message translates to:
  /// **'18 or more gunas is considered suitable for marriage. Check the low-scoring kootas below.'**
  String get matchVerdictGoodBody;

  /// No description provided for @matchVerdictAverageBody.
  ///
  /// In en, this message translates to:
  /// **'Below 18 gunas, astrologers usually suggest a full chart review before deciding.'**
  String get matchVerdictAverageBody;

  /// No description provided for @matchVerdictLowBody.
  ///
  /// In en, this message translates to:
  /// **'Don\'t decide on this score alone — a full kundali review often changes the picture.'**
  String get matchVerdictLowBody;

  /// No description provided for @matchManglikShort.
  ///
  /// In en, this message translates to:
  /// **'Manglik'**
  String get matchManglikShort;

  /// No description provided for @matchManglikTitle.
  ///
  /// In en, this message translates to:
  /// **'Manglik (Mangal dosha) check'**
  String get matchManglikTitle;

  /// No description provided for @matchManglikNone.
  ///
  /// In en, this message translates to:
  /// **'Neither of you is Manglik — no Mangal dosha concern.'**
  String get matchManglikNone;

  /// No description provided for @matchManglikBoth.
  ///
  /// In en, this message translates to:
  /// **'Both of you are Manglik — traditionally the dosha cancels out.'**
  String get matchManglikBoth;

  /// No description provided for @matchManglikCancelled.
  ///
  /// In en, this message translates to:
  /// **'Mangal dosha is present but cancelled by other placements in the chart.'**
  String get matchManglikCancelled;

  /// No description provided for @matchManglikMismatch.
  ///
  /// In en, this message translates to:
  /// **'Only one of you is Manglik. Talk to an astrologer about remedies and a full chart review.'**
  String get matchManglikMismatch;

  /// No description provided for @matchIsManglik.
  ///
  /// In en, this message translates to:
  /// **'Manglik'**
  String get matchIsManglik;

  /// No description provided for @matchNotManglik.
  ///
  /// In en, this message translates to:
  /// **'Not Manglik'**
  String get matchNotManglik;

  /// No description provided for @matchManglikCancelledShort.
  ///
  /// In en, this message translates to:
  /// **'Manglik (cancelled)'**
  String get matchManglikCancelledShort;

  /// No description provided for @matchCheckClear.
  ///
  /// In en, this message translates to:
  /// **'{name}: clear'**
  String matchCheckClear(String name);

  /// No description provided for @matchCheckPresent.
  ///
  /// In en, this message translates to:
  /// **'{name}: present'**
  String matchCheckPresent(String name);

  /// No description provided for @matchDoshaNadi.
  ///
  /// In en, this message translates to:
  /// **'Nadi dosha'**
  String get matchDoshaNadi;

  /// No description provided for @matchDoshaBhakoot.
  ///
  /// In en, this message translates to:
  /// **'Bhakoot dosha'**
  String get matchDoshaBhakoot;

  /// No description provided for @matchDoshaGana.
  ///
  /// In en, this message translates to:
  /// **'Gana dosha'**
  String get matchDoshaGana;

  /// No description provided for @matchDoshaTag.
  ///
  /// In en, this message translates to:
  /// **'Dosha'**
  String get matchDoshaTag;

  /// No description provided for @matchBreakdownTitle.
  ///
  /// In en, this message translates to:
  /// **'Guna breakdown'**
  String get matchBreakdownTitle;

  /// No description provided for @matchBreakdownSub.
  ///
  /// In en, this message translates to:
  /// **'Tap any koota to see what it means.'**
  String get matchBreakdownSub;

  /// No description provided for @matchKootaVarna.
  ///
  /// In en, this message translates to:
  /// **'Varna'**
  String get matchKootaVarna;

  /// No description provided for @matchKootaVashya.
  ///
  /// In en, this message translates to:
  /// **'Vashya'**
  String get matchKootaVashya;

  /// No description provided for @matchKootaTara.
  ///
  /// In en, this message translates to:
  /// **'Tara'**
  String get matchKootaTara;

  /// No description provided for @matchKootaYoni.
  ///
  /// In en, this message translates to:
  /// **'Yoni'**
  String get matchKootaYoni;

  /// No description provided for @matchKootaMaitri.
  ///
  /// In en, this message translates to:
  /// **'Graha Maitri'**
  String get matchKootaMaitri;

  /// No description provided for @matchKootaGana.
  ///
  /// In en, this message translates to:
  /// **'Gana'**
  String get matchKootaGana;

  /// No description provided for @matchKootaBhakoot.
  ///
  /// In en, this message translates to:
  /// **'Bhakoot'**
  String get matchKootaBhakoot;

  /// No description provided for @matchKootaNadi.
  ///
  /// In en, this message translates to:
  /// **'Nadi'**
  String get matchKootaNadi;

  /// No description provided for @matchKootaVarnaMeaning.
  ///
  /// In en, this message translates to:
  /// **'Values & ego'**
  String get matchKootaVarnaMeaning;

  /// No description provided for @matchKootaVashyaMeaning.
  ///
  /// In en, this message translates to:
  /// **'Mutual attraction'**
  String get matchKootaVashyaMeaning;

  /// No description provided for @matchKootaTaraMeaning.
  ///
  /// In en, this message translates to:
  /// **'Destiny & well-being'**
  String get matchKootaTaraMeaning;

  /// No description provided for @matchKootaYoniMeaning.
  ///
  /// In en, this message translates to:
  /// **'Physical harmony'**
  String get matchKootaYoniMeaning;

  /// No description provided for @matchKootaMaitriMeaning.
  ///
  /// In en, this message translates to:
  /// **'Mental wavelength'**
  String get matchKootaMaitriMeaning;

  /// No description provided for @matchKootaGanaMeaning.
  ///
  /// In en, this message translates to:
  /// **'Temperament'**
  String get matchKootaGanaMeaning;

  /// No description provided for @matchKootaBhakootMeaning.
  ///
  /// In en, this message translates to:
  /// **'Love, family & finances'**
  String get matchKootaBhakootMeaning;

  /// No description provided for @matchKootaNadiMeaning.
  ///
  /// In en, this message translates to:
  /// **'Health & children'**
  String get matchKootaNadiMeaning;

  /// No description provided for @matchKootaVarnaDetail.
  ///
  /// In en, this message translates to:
  /// **'Compares the spiritual temperament of both Moon signs — how naturally your values and sense of duty line up. Worth 1 point.'**
  String get matchKootaVarnaDetail;

  /// No description provided for @matchKootaVashyaDetail.
  ///
  /// In en, this message translates to:
  /// **'Shows the natural pull and influence between partners — who leads, who adapts, and how easily you agree. Worth 2 points.'**
  String get matchKootaVashyaDetail;

  /// No description provided for @matchKootaTaraDetail.
  ///
  /// In en, this message translates to:
  /// **'Counts the nakshatras between you to judge fortune, health and longevity of the bond. Worth 3 points.'**
  String get matchKootaTaraDetail;

  /// No description provided for @matchKootaYoniDetail.
  ///
  /// In en, this message translates to:
  /// **'Each nakshatra has an animal nature; this koota compares them for intimacy and physical compatibility. Worth 4 points.'**
  String get matchKootaYoniDetail;

  /// No description provided for @matchKootaMaitriDetail.
  ///
  /// In en, this message translates to:
  /// **'Compares the lords of your Moon signs — friendship between them means you think alike and resolve issues easily. Worth 5 points.'**
  String get matchKootaMaitriDetail;

  /// No description provided for @matchKootaGanaDetail.
  ///
  /// In en, this message translates to:
  /// **'Groups nakshatras into Deva, Manushya and Rakshasa temperaments. A mismatch can mean frequent friction. Worth 6 points.'**
  String get matchKootaGanaDetail;

  /// No description provided for @matchKootaBhakootDetail.
  ///
  /// In en, this message translates to:
  /// **'Looks at the distance between your Moon signs, which traditionally affects love, family growth and shared finances. Worth 7 points.'**
  String get matchKootaBhakootDetail;

  /// No description provided for @matchKootaNadiDetail.
  ///
  /// In en, this message translates to:
  /// **'The most weighted koota. Same Nadi (0 points) is traditionally linked to health and progeny concerns and has well-known exceptions. Worth 8 points.'**
  String get matchKootaNadiDetail;

  /// No description provided for @matchChartsTitle.
  ///
  /// In en, this message translates to:
  /// **'Birth chart details'**
  String get matchChartsTitle;

  /// No description provided for @matchRowRasi.
  ///
  /// In en, this message translates to:
  /// **'Moon sign'**
  String get matchRowRasi;

  /// No description provided for @matchRowNakshatra.
  ///
  /// In en, this message translates to:
  /// **'Nakshatra'**
  String get matchRowNakshatra;

  /// No description provided for @matchRowGana.
  ///
  /// In en, this message translates to:
  /// **'Gana'**
  String get matchRowGana;

  /// No description provided for @matchRowYoni.
  ///
  /// In en, this message translates to:
  /// **'Yoni'**
  String get matchRowYoni;

  /// No description provided for @matchAskTitle.
  ///
  /// In en, this message translates to:
  /// **'Talk it through with an astrologer'**
  String get matchAskTitle;

  /// No description provided for @matchAskBody.
  ///
  /// In en, this message translates to:
  /// **'Doshas often have cancellations and remedies. Get a full reading of both charts.'**
  String get matchAskBody;

  /// No description provided for @matchDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Guna Milan is a traditional guide, not a guarantee. Consider the full charts and your own judgement.'**
  String get matchDisclaimer;

  /// No description provided for @matchRelSelf.
  ///
  /// In en, this message translates to:
  /// **'Myself'**
  String get matchRelSelf;

  /// No description provided for @matchRelPartner.
  ///
  /// In en, this message translates to:
  /// **'Partner'**
  String get matchRelPartner;

  /// No description provided for @matchRelChild.
  ///
  /// In en, this message translates to:
  /// **'Child'**
  String get matchRelChild;

  /// No description provided for @matchRelParent.
  ///
  /// In en, this message translates to:
  /// **'Parent'**
  String get matchRelParent;

  /// No description provided for @matchRelSibling.
  ///
  /// In en, this message translates to:
  /// **'Sibling'**
  String get matchRelSibling;

  /// No description provided for @matchRelFriend.
  ///
  /// In en, this message translates to:
  /// **'Friend'**
  String get matchRelFriend;

  /// No description provided for @kAdvTitle.
  ///
  /// In en, this message translates to:
  /// **'Advanced reports'**
  String get kAdvTitle;

  /// No description provided for @kAdvIntro.
  ///
  /// In en, this message translates to:
  /// **'The technical layers astrologers use for depth and timing. Skim them for interest, or open one during a consultation.'**
  String get kAdvIntro;

  /// No description provided for @kAdvAshtakavarga.
  ///
  /// In en, this message translates to:
  /// **'Ashtakavarga'**
  String get kAdvAshtakavarga;

  /// No description provided for @kAdvAshtakavargaSub.
  ///
  /// In en, this message translates to:
  /// **'Point-strength of every sign. Higher = the sky supports transits there.'**
  String get kAdvAshtakavargaSub;

  /// No description provided for @kAdvShadbala.
  ///
  /// In en, this message translates to:
  /// **'Shadbala'**
  String get kAdvShadbala;

  /// No description provided for @kAdvShadbalaSub.
  ///
  /// In en, this message translates to:
  /// **'The six-fold strength of each planet, measured against what it needs.'**
  String get kAdvShadbalaSub;

  /// No description provided for @kAdvKp.
  ///
  /// In en, this message translates to:
  /// **'KP System'**
  String get kAdvKp;

  /// No description provided for @kAdvKpSub.
  ///
  /// In en, this message translates to:
  /// **'Krishnamurti Paddhati — cuspal sub-lords and ruling planets for timing.'**
  String get kAdvKpSub;

  /// No description provided for @kAdvJaimini.
  ///
  /// In en, this message translates to:
  /// **'Jaimini'**
  String get kAdvJaimini;

  /// No description provided for @kAdvJaiminiSub.
  ///
  /// In en, this message translates to:
  /// **'Chara Karakas, Arudha Lagna and the Jaimini way of reading a chart.'**
  String get kAdvJaiminiSub;

  /// No description provided for @kAdvDownloadPdf.
  ///
  /// In en, this message translates to:
  /// **'Download the full PDF report'**
  String get kAdvDownloadPdf;

  /// No description provided for @kAdvFooter.
  ///
  /// In en, this message translates to:
  /// **'These are technical. For a reading in plain words, talk to an astrologer.'**
  String get kAdvFooter;

  /// No description provided for @kAdvReport.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get kAdvReport;

  /// No description provided for @kAdvLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load this report.'**
  String get kAdvLoadError;

  /// No description provided for @kAdvKpIntro.
  ///
  /// In en, this message translates to:
  /// **'KP divides the zodiac into 249 sub-parts. The sub-lord of a house cusp decides whether that area of life delivers; the ruling planets are used for on-the-spot timing.'**
  String get kAdvKpIntro;

  /// No description provided for @kAdvJaiminiIntro.
  ///
  /// In en, this message translates to:
  /// **'Jaimini reads the chart through the Chara Karakas (planets ranked by degree, each signifying a life area) and the Arudha padas — how things appear to the world.'**
  String get kAdvJaiminiIntro;

  /// No description provided for @kAdvAvIntro.
  ///
  /// In en, this message translates to:
  /// **'Sarvashtakavarga adds every planet’s contribution to each house — the total is always 337. A house scoring 28+ supports planets transiting through it; below 25 is a weaker patch.'**
  String get kAdvAvIntro;

  /// No description provided for @kAdvHouseN.
  ///
  /// In en, this message translates to:
  /// **'House {n}'**
  String kAdvHouseN(Object n);

  /// No description provided for @kAdvBhinnaTotals.
  ///
  /// In en, this message translates to:
  /// **'Per-planet totals (Bhinnashtakavarga)'**
  String get kAdvBhinnaTotals;

  /// No description provided for @kAdvShadbalaIntro.
  ///
  /// In en, this message translates to:
  /// **'Shadbala scores each planet’s strength in rupas against the minimum it needs. A ratio above 1.0 means the planet can deliver its results reliably.'**
  String get kAdvShadbalaIntro;

  /// No description provided for @kAdvStrongest.
  ///
  /// In en, this message translates to:
  /// **'Strongest: {planet}'**
  String kAdvStrongest(Object planet);

  /// No description provided for @kAdvWeakest.
  ///
  /// In en, this message translates to:
  /// **'Weakest: {planet}'**
  String kAdvWeakest(Object planet);

  /// No description provided for @kAdvReadWithAstrologer.
  ///
  /// In en, this message translates to:
  /// **'This report is meant to be read with an astrologer.'**
  String get kAdvReadWithAstrologer;

  /// No description provided for @kAdvSecCuspalSublords.
  ///
  /// In en, this message translates to:
  /// **'Cuspal sub-lords'**
  String get kAdvSecCuspalSublords;

  /// No description provided for @kAdvSecRulingPlanets.
  ///
  /// In en, this message translates to:
  /// **'Ruling planets'**
  String get kAdvSecRulingPlanets;

  /// No description provided for @kAdvSecHouseSignificators.
  ///
  /// In en, this message translates to:
  /// **'House significators'**
  String get kAdvSecHouseSignificators;

  /// No description provided for @kAdvSecCharaKarakas.
  ///
  /// In en, this message translates to:
  /// **'Chara karakas'**
  String get kAdvSecCharaKarakas;

  /// No description provided for @kAdvSecArudhaPadas.
  ///
  /// In en, this message translates to:
  /// **'Arudha padas'**
  String get kAdvSecArudhaPadas;

  /// No description provided for @kAdvSecKarakamsa.
  ///
  /// In en, this message translates to:
  /// **'Karakamsa'**
  String get kAdvSecKarakamsa;

  /// No description provided for @kAdvSecCharaDasha.
  ///
  /// In en, this message translates to:
  /// **'Chara dasha'**
  String get kAdvSecCharaDasha;

  /// No description provided for @kBhavaTitle.
  ///
  /// In en, this message translates to:
  /// **'Houses · Bhava'**
  String get kBhavaTitle;

  /// No description provided for @kBhavaIntro.
  ///
  /// In en, this message translates to:
  /// **'Each of the 12 houses, its natural significations, and how its lord and occupants shape it.'**
  String get kBhavaIntro;

  /// No description provided for @kBhavaMoreBenefic.
  ///
  /// In en, this message translates to:
  /// **'More benefic than malefic influence'**
  String get kBhavaMoreBenefic;

  /// No description provided for @kBhavaMoreMalefic.
  ///
  /// In en, this message translates to:
  /// **'More malefic than benefic influence'**
  String get kBhavaMoreMalefic;

  /// No description provided for @kBhavaOccupiedBy.
  ///
  /// In en, this message translates to:
  /// **'Occupied by {planets}'**
  String kBhavaOccupiedBy(Object planets);

  /// No description provided for @kBhavaAspectedBy.
  ///
  /// In en, this message translates to:
  /// **'Aspected by {planets}'**
  String kBhavaAspectedBy(Object planets);

  /// No description provided for @kBhavaBeneficCount.
  ///
  /// In en, this message translates to:
  /// **'{count} benefic'**
  String kBhavaBeneficCount(Object count);

  /// No description provided for @kBhavaMaleficCount.
  ///
  /// In en, this message translates to:
  /// **'{count} malefic'**
  String kBhavaMaleficCount(Object count);

  /// No description provided for @kBhavaNeedsTime.
  ///
  /// In en, this message translates to:
  /// **'House analysis needs a birth time'**
  String get kBhavaNeedsTime;

  /// No description provided for @kBhavaNeedsTimeBody.
  ///
  /// In en, this message translates to:
  /// **'Add an exact time of birth to this profile to see how each house is shaped.'**
  String get kBhavaNeedsTimeBody;

  /// No description provided for @kDashaIntroVimshottari.
  ///
  /// In en, this message translates to:
  /// **'Vimshottari is a 120-year cycle of planetary periods, timed from where the Moon sat at your birth.'**
  String get kDashaIntroVimshottari;

  /// No description provided for @kDashaIntroYogini.
  ///
  /// In en, this message translates to:
  /// **'Yogini is a 36-year cycle of eight yoginis, from the Moon’s nakshatra.'**
  String get kDashaIntroYogini;

  /// No description provided for @kDashaIntroAshtottari.
  ///
  /// In en, this message translates to:
  /// **'Ashtottari is a 108-year cycle counted from Ardra.'**
  String get kDashaIntroAshtottari;

  /// No description provided for @kDashaBalance.
  ///
  /// In en, this message translates to:
  /// **'Balance of {lord} dasha at birth: {years} yrs'**
  String kDashaBalance(Object lord, Object years);

  /// No description provided for @kDashaVimshottari.
  ///
  /// In en, this message translates to:
  /// **'Vimshottari'**
  String get kDashaVimshottari;

  /// No description provided for @kDashaYogini.
  ///
  /// In en, this message translates to:
  /// **'Yogini'**
  String get kDashaYogini;

  /// No description provided for @kDashaAshtottari.
  ///
  /// In en, this message translates to:
  /// **'Ashtottari'**
  String get kDashaAshtottari;

  /// No description provided for @kDashaNowRunning.
  ///
  /// In en, this message translates to:
  /// **'Now running'**
  String get kDashaNowRunning;

  /// No description provided for @kDashaNow.
  ///
  /// In en, this message translates to:
  /// **'NOW'**
  String get kDashaNow;

  /// No description provided for @kDashaYears.
  ///
  /// In en, this message translates to:
  /// **'{count} yrs'**
  String kDashaYears(Object count);

  /// No description provided for @kPlanetsIntro.
  ///
  /// In en, this message translates to:
  /// **'Where each planet sits, how strong it is, and what it tends to bring. Tap to read more. Positions are sidereal (Lahiri).'**
  String get kPlanetsIntro;

  /// No description provided for @kTrTitle.
  ///
  /// In en, this message translates to:
  /// **'Transits'**
  String get kTrTitle;

  /// No description provided for @kTrSadeSatiCalendar.
  ///
  /// In en, this message translates to:
  /// **'See the full Sade Sati calendar (with dates)'**
  String get kTrSadeSatiCalendar;

  /// No description provided for @kTrSkyNow.
  ///
  /// In en, this message translates to:
  /// **'The sky right now — against your chart'**
  String get kTrSkyNow;

  /// No description provided for @kTrSadeSati.
  ///
  /// In en, this message translates to:
  /// **'Sade Sati'**
  String get kTrSadeSati;

  /// No description provided for @kTrPhaseOf.
  ///
  /// In en, this message translates to:
  /// **'Phase {n} of 3'**
  String kTrPhaseOf(Object n);

  /// No description provided for @kTrPhaseHintRising.
  ///
  /// In en, this message translates to:
  /// **'Saturn in the 12th'**
  String get kTrPhaseHintRising;

  /// No description provided for @kTrPhaseHintPeak.
  ///
  /// In en, this message translates to:
  /// **'over the Moon'**
  String get kTrPhaseHintPeak;

  /// No description provided for @kTrPhaseHintSetting.
  ///
  /// In en, this message translates to:
  /// **'Saturn in the 2nd'**
  String get kTrPhaseHintSetting;

  /// No description provided for @kTrHowToWork.
  ///
  /// In en, this message translates to:
  /// **'How to work with it'**
  String get kTrHowToWork;

  /// No description provided for @kTrTip1.
  ///
  /// In en, this message translates to:
  /// **'Cut what isn’t working — Saturn rewards honesty about it'**
  String get kTrTip1;

  /// No description provided for @kTrTip2.
  ///
  /// In en, this message translates to:
  /// **'Build routines and finish what you start'**
  String get kTrTip2;

  /// No description provided for @kTrTip3.
  ///
  /// In en, this message translates to:
  /// **'Care for your sleep, knees, teeth and older relatives'**
  String get kTrTip3;

  /// No description provided for @kTrTip4.
  ///
  /// In en, this message translates to:
  /// **'It is a rebuild, not a punishment. Results show after it ends.'**
  String get kTrTip4;

  /// No description provided for @kTrPanotiBody.
  ///
  /// In en, this message translates to:
  /// **'A shorter (~2½ year) Saturn phase. Expect friction with health, daily effort and obstacles — meet it with patience and routine.'**
  String get kTrPanotiBody;

  /// No description provided for @kTrPlanetInSign.
  ///
  /// In en, this message translates to:
  /// **'{planet} in {sign}'**
  String kTrPlanetInSign(Object planet, Object sign);

  /// No description provided for @kTrJupiterGood.
  ///
  /// In en, this message translates to:
  /// **'Jupiter’s transit is favourable — supportive for growth, learning, money and family right now.'**
  String get kTrJupiterGood;

  /// No description provided for @kTrJupiterNeutral.
  ///
  /// In en, this message translates to:
  /// **'Jupiter’s transit is neutral for you at the moment.'**
  String get kTrJupiterNeutral;

  /// No description provided for @kTrCloseContacts.
  ///
  /// In en, this message translates to:
  /// **'Close contacts now'**
  String get kTrCloseContacts;

  /// No description provided for @kTrCloseContactLine.
  ///
  /// In en, this message translates to:
  /// **'Transiting {planet} is within 3° of your natal {natal} — that area of life is active this week.'**
  String kTrCloseContactLine(Object natal, Object planet);

  /// No description provided for @kMuChoghadiya.
  ///
  /// In en, this message translates to:
  /// **'{key, select, other{{raw}}}'**
  String kMuChoghadiya(String key, Object raw);

  /// No description provided for @kUpOr.
  ///
  /// In en, this message translates to:
  /// **'or {name}'**
  String kUpOr(Object name);

  /// No description provided for @kUpFinger.
  ///
  /// In en, this message translates to:
  /// **'{finger} finger'**
  String kUpFinger(Object finger);

  /// No description provided for @kYdPartial.
  ///
  /// In en, this message translates to:
  /// **'partial'**
  String get kYdPartial;

  /// No description provided for @moodTitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'s mood'**
  String get moodTitle;

  /// No description provided for @moodMeter.
  ///
  /// In en, this message translates to:
  /// **'Mood meter'**
  String get moodMeter;

  /// No description provided for @moodWhyTitle.
  ///
  /// In en, this message translates to:
  /// **'Why today feels this way'**
  String get moodWhyTitle;

  /// No description provided for @moodTipTitle.
  ///
  /// In en, this message translates to:
  /// **'One small thing for today'**
  String get moodTipTitle;

  /// No description provided for @moodLockedTitle.
  ///
  /// In en, this message translates to:
  /// **'Your astrologer can tell you'**
  String get moodLockedTitle;

  /// No description provided for @moodLockedSub.
  ///
  /// In en, this message translates to:
  /// **'The full picture needs your whole chart, not just the Moon.'**
  String get moodLockedSub;

  /// No description provided for @moodTalkCta.
  ///
  /// In en, this message translates to:
  /// **'Talk to an astrologer now'**
  String get moodTalkCta;

  /// No description provided for @moodNextChange.
  ///
  /// In en, this message translates to:
  /// **'Your mood shifts next on {when}'**
  String moodNextChange(Object when);

  /// No description provided for @kOvExMood.
  ///
  /// In en, this message translates to:
  /// **'Today\'s mood'**
  String get kOvExMood;

  /// No description provided for @kOvExMoodSub.
  ///
  /// In en, this message translates to:
  /// **'How the Moon is shaping your mind today'**
  String get kOvExMoodSub;

  /// No description provided for @prefsMoodAlerts.
  ///
  /// In en, this message translates to:
  /// **'Daily mood alerts'**
  String get prefsMoodAlerts;

  /// No description provided for @prefsMoodAlertsDesc.
  ///
  /// In en, this message translates to:
  /// **'About three mornings a week, when the Moon changes sign in your chart.'**
  String get prefsMoodAlertsDesc;

  /// No description provided for @callCalling.
  ///
  /// In en, this message translates to:
  /// **'Calling…'**
  String get callCalling;

  /// No description provided for @callRinging.
  ///
  /// In en, this message translates to:
  /// **'Ringing…'**
  String get callRinging;

  /// No description provided for @callConnecting.
  ///
  /// In en, this message translates to:
  /// **'Connecting…'**
  String get callConnecting;

  /// No description provided for @callReconnecting.
  ///
  /// In en, this message translates to:
  /// **'Reconnecting…'**
  String get callReconnecting;

  /// No description provided for @callEnded.
  ///
  /// In en, this message translates to:
  /// **'Call ended'**
  String get callEnded;

  /// No description provided for @callPoorConnection.
  ///
  /// In en, this message translates to:
  /// **'Weak connection'**
  String get callPoorConnection;

  /// No description provided for @callMute.
  ///
  /// In en, this message translates to:
  /// **'Mute'**
  String get callMute;

  /// No description provided for @callSpeaker.
  ///
  /// In en, this message translates to:
  /// **'Speaker'**
  String get callSpeaker;

  /// No description provided for @callEnd.
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get callEnd;

  /// No description provided for @callEncrypted.
  ///
  /// In en, this message translates to:
  /// **'Encrypted call'**
  String get callEncrypted;

  /// No description provided for @callMicTitle.
  ///
  /// In en, this message translates to:
  /// **'Microphone needed'**
  String get callMicTitle;

  /// No description provided for @callMicBody.
  ///
  /// In en, this message translates to:
  /// **'Allow microphone access so the astrologer can hear you.'**
  String get callMicBody;

  /// No description provided for @callMicBlockedBody.
  ///
  /// In en, this message translates to:
  /// **'Microphone access is turned off for TalkAcharya. Turn it on in Settings.'**
  String get callMicBlockedBody;

  /// No description provided for @callOpenSettings.
  ///
  /// In en, this message translates to:
  /// **'Open settings'**
  String get callOpenSettings;

  /// No description provided for @callTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get callTryAgain;

  /// No description provided for @callFailedTitle.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t start the call'**
  String get callFailedTitle;

  /// No description provided for @callEndConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'End this call?'**
  String get callEndConfirmTitle;

  /// No description provided for @callEndConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'Billing stops as soon as the call ends.'**
  String get callEndConfirmBody;

  /// No description provided for @callEndConfirmYes.
  ///
  /// In en, this message translates to:
  /// **'End call'**
  String get callEndConfirmYes;

  /// No description provided for @callEndConfirmNo.
  ///
  /// In en, this message translates to:
  /// **'Keep talking'**
  String get callEndConfirmNo;

  /// No description provided for @callWaitingAccept.
  ///
  /// In en, this message translates to:
  /// **'Waiting for {name} to accept…'**
  String callWaitingAccept(String name);

  /// No description provided for @callBookTitle.
  ///
  /// In en, this message translates to:
  /// **'Call {name}'**
  String callBookTitle(String name);

  /// No description provided for @callBookBilling.
  ///
  /// In en, this message translates to:
  /// **'Voice call · billed per minute once connected'**
  String get callBookBilling;

  /// No description provided for @callBookCta.
  ///
  /// In en, this message translates to:
  /// **'Start call · {price}/min'**
  String callBookCta(String price);

  /// No description provided for @callUnavailable.
  ///
  /// In en, this message translates to:
  /// **'This astrologer is not taking calls right now.'**
  String get callUnavailable;

  /// No description provided for @giftAction.
  ///
  /// In en, this message translates to:
  /// **'Send a gift'**
  String get giftAction;

  /// No description provided for @giftSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Send a gift to {name}'**
  String giftSheetTitle(String name);

  /// No description provided for @giftSheetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A small token of gratitude — they see it instantly.'**
  String get giftSheetSubtitle;

  /// No description provided for @giftQuantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get giftQuantity;

  /// No description provided for @giftAddNote.
  ///
  /// In en, this message translates to:
  /// **'Add a note'**
  String get giftAddNote;

  /// No description provided for @giftNoteHint.
  ///
  /// In en, this message translates to:
  /// **'Write a short message (optional)'**
  String get giftNoteHint;

  /// No description provided for @giftChoose.
  ///
  /// In en, this message translates to:
  /// **'Choose a gift'**
  String get giftChoose;

  /// No description provided for @giftSendCta.
  ///
  /// In en, this message translates to:
  /// **'Send {gift} · {price}'**
  String giftSendCta(String gift, String price);

  /// No description provided for @giftWalletBalance.
  ///
  /// In en, this message translates to:
  /// **'Balance {amount}'**
  String giftWalletBalance(String amount);

  /// No description provided for @giftAddMoney.
  ///
  /// In en, this message translates to:
  /// **'Add money'**
  String get giftAddMoney;

  /// No description provided for @giftLowBalanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Not enough balance'**
  String get giftLowBalanceTitle;

  /// No description provided for @giftLowBalanceBody.
  ///
  /// In en, this message translates to:
  /// **'Add money to your wallet to send this gift.'**
  String get giftLowBalanceBody;

  /// No description provided for @giftSentTitle.
  ///
  /// In en, this message translates to:
  /// **'{gift} sent to {name}'**
  String giftSentTitle(String gift, String name);

  /// No description provided for @giftSentBody.
  ///
  /// In en, this message translates to:
  /// **'They\'ll see it right away. Thank you for your kindness!'**
  String get giftSentBody;

  /// No description provided for @giftSendAnother.
  ///
  /// In en, this message translates to:
  /// **'Send another'**
  String get giftSendAnother;

  /// No description provided for @giftLoadError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load gifts'**
  String get giftLoadError;

  /// No description provided for @giftThankYouTitle.
  ///
  /// In en, this message translates to:
  /// **'Say thanks with a gift'**
  String get giftThankYouTitle;

  /// No description provided for @giftThankYouBody.
  ///
  /// In en, this message translates to:
  /// **'Loved the session? Send {name} a small token of gratitude.'**
  String giftThankYouBody(String name);

  /// No description provided for @giftThankYouSentTitle.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your gift'**
  String get giftThankYouSentTitle;

  /// No description provided for @helpTitle.
  ///
  /// In en, this message translates to:
  /// **'Help & support'**
  String get helpTitle;

  /// No description provided for @helpHeroTitle.
  ///
  /// In en, this message translates to:
  /// **'How can we help?'**
  String get helpHeroTitle;

  /// No description provided for @helpHeroBody.
  ///
  /// In en, this message translates to:
  /// **'Report a problem with a session, track your reports or reach our team.'**
  String get helpHeroBody;

  /// No description provided for @helpReportSection.
  ///
  /// In en, this message translates to:
  /// **'Report a problem with a session'**
  String get helpReportSection;

  /// No description provided for @helpReportEmpty.
  ///
  /// In en, this message translates to:
  /// **'Your completed sessions will appear here.'**
  String get helpReportEmpty;

  /// No description provided for @helpReportAction.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get helpReportAction;

  /// No description provided for @helpYourReports.
  ///
  /// In en, this message translates to:
  /// **'Your reports'**
  String get helpYourReports;

  /// No description provided for @helpContactSection.
  ///
  /// In en, this message translates to:
  /// **'Contact us'**
  String get helpContactSection;

  /// No description provided for @helpWhatsapp.
  ///
  /// In en, this message translates to:
  /// **'Chat on WhatsApp'**
  String get helpWhatsapp;

  /// No description provided for @helpEmailUs.
  ///
  /// In en, this message translates to:
  /// **'Email us'**
  String get helpEmailUs;

  /// No description provided for @helpCentre.
  ///
  /// In en, this message translates to:
  /// **'Help centre'**
  String get helpCentre;

  /// No description provided for @helpFaqSection.
  ///
  /// In en, this message translates to:
  /// **'Frequently asked questions'**
  String get helpFaqSection;

  /// No description provided for @helpLoadError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load your sessions.'**
  String get helpLoadError;

  /// No description provided for @helpFaqChargesQ.
  ///
  /// In en, this message translates to:
  /// **'How am I charged for a consultation?'**
  String get helpFaqChargesQ;

  /// No description provided for @helpFaqChargesA.
  ///
  /// In en, this message translates to:
  /// **'You pay per minute, only while the session is live. Billing starts once the astrologer joins and stops the moment either of you ends it.'**
  String get helpFaqChargesA;

  /// No description provided for @helpFaqNoResponseQ.
  ///
  /// In en, this message translates to:
  /// **'What if the astrologer doesn\'t respond?'**
  String get helpFaqNoResponseQ;

  /// No description provided for @helpFaqNoResponseA.
  ///
  /// In en, this message translates to:
  /// **'If your request isn\'t accepted, you aren\'t charged — any amount held for the session goes back to your wallet.'**
  String get helpFaqNoResponseA;

  /// No description provided for @helpFaqRefundQ.
  ///
  /// In en, this message translates to:
  /// **'Can I get a refund?'**
  String get helpFaqRefundQ;

  /// No description provided for @helpFaqRefundA.
  ///
  /// In en, this message translates to:
  /// **'If something went wrong — wrong charges, a technical problem or an unhelpful session — report it from that session. Our team reviews every report and refunds to your wallet when it\'s warranted.'**
  String get helpFaqRefundA;

  /// No description provided for @helpFaqBalanceQ.
  ///
  /// In en, this message translates to:
  /// **'My balance ran out during a session. What now?'**
  String get helpFaqBalanceQ;

  /// No description provided for @helpFaqBalanceA.
  ///
  /// In en, this message translates to:
  /// **'The session ends automatically when your balance runs out. Recharge your wallet and start again with the same astrologer from the session summary.'**
  String get helpFaqBalanceA;

  /// No description provided for @helpFaqPrivacyQ.
  ///
  /// In en, this message translates to:
  /// **'Are my conversations private?'**
  String get helpFaqPrivacyQ;

  /// No description provided for @helpFaqPrivacyA.
  ///
  /// In en, this message translates to:
  /// **'Your consultations are between you and your astrologer. Our support team looks at a session only to resolve a report or keep the platform safe.'**
  String get helpFaqPrivacyA;

  /// No description provided for @helpFaqLanguageQ.
  ///
  /// In en, this message translates to:
  /// **'How do I change the app language?'**
  String get helpFaqLanguageQ;

  /// No description provided for @helpFaqLanguageA.
  ///
  /// In en, this message translates to:
  /// **'Go to Profile → Language and choose the language you\'re most comfortable in.'**
  String get helpFaqLanguageA;

  /// No description provided for @reportTitle.
  ///
  /// In en, this message translates to:
  /// **'Report a problem'**
  String get reportTitle;

  /// No description provided for @reportSessionWith.
  ///
  /// In en, this message translates to:
  /// **'Session with {name}'**
  String reportSessionWith(String name);

  /// No description provided for @reportWhatHappened.
  ///
  /// In en, this message translates to:
  /// **'What went wrong?'**
  String get reportWhatHappened;

  /// No description provided for @reportTypeBilling.
  ///
  /// In en, this message translates to:
  /// **'Wrong charges'**
  String get reportTypeBilling;

  /// No description provided for @reportTypeBillingHint.
  ///
  /// In en, this message translates to:
  /// **'I was charged more than I should have been'**
  String get reportTypeBillingHint;

  /// No description provided for @reportTypeQuality.
  ///
  /// In en, this message translates to:
  /// **'Unhelpful session'**
  String get reportTypeQuality;

  /// No description provided for @reportTypeQualityHint.
  ///
  /// In en, this message translates to:
  /// **'The guidance wasn\'t what was promised'**
  String get reportTypeQualityHint;

  /// No description provided for @reportTypeConduct.
  ///
  /// In en, this message translates to:
  /// **'Inappropriate behaviour'**
  String get reportTypeConduct;

  /// No description provided for @reportTypeConductHint.
  ///
  /// In en, this message translates to:
  /// **'The astrologer was rude or unprofessional'**
  String get reportTypeConductHint;

  /// No description provided for @reportTypeNoShow.
  ///
  /// In en, this message translates to:
  /// **'Astrologer didn\'t respond'**
  String get reportTypeNoShow;

  /// No description provided for @reportTypeNoShowHint.
  ///
  /// In en, this message translates to:
  /// **'They accepted but never really joined'**
  String get reportTypeNoShowHint;

  /// No description provided for @reportTypeTechnical.
  ///
  /// In en, this message translates to:
  /// **'Technical problem'**
  String get reportTypeTechnical;

  /// No description provided for @reportTypeTechnicalHint.
  ///
  /// In en, this message translates to:
  /// **'The chat or call kept failing'**
  String get reportTypeTechnicalHint;

  /// No description provided for @reportDescribe.
  ///
  /// In en, this message translates to:
  /// **'Tell us more'**
  String get reportDescribe;

  /// No description provided for @reportDescribeHint.
  ///
  /// In en, this message translates to:
  /// **'Share what happened — the more detail, the faster we can help.'**
  String get reportDescribeHint;

  /// No description provided for @reportMinChars.
  ///
  /// In en, this message translates to:
  /// **'At least {count} characters'**
  String reportMinChars(String count);

  /// No description provided for @reportPrivacyNote.
  ///
  /// In en, this message translates to:
  /// **'To look into your report, our support team will review this session.'**
  String get reportPrivacyNote;

  /// No description provided for @reportSubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit report'**
  String get reportSubmit;

  /// No description provided for @reportSubmittedTitle.
  ///
  /// In en, this message translates to:
  /// **'Report submitted'**
  String get reportSubmittedTitle;

  /// No description provided for @reportSubmittedBody.
  ///
  /// In en, this message translates to:
  /// **'We\'ll look into it and notify you as soon as there\'s an update.'**
  String get reportSubmittedBody;

  /// No description provided for @reportAlreadyTitle.
  ///
  /// In en, this message translates to:
  /// **'You\'ve already reported this session'**
  String get reportAlreadyTitle;

  /// No description provided for @reportAlreadyBody.
  ///
  /// In en, this message translates to:
  /// **'Our team is looking into it. You\'ll be notified when there\'s an update.'**
  String get reportAlreadyBody;

  /// No description provided for @reportViewStatus.
  ///
  /// In en, this message translates to:
  /// **'View report status'**
  String get reportViewStatus;

  /// No description provided for @disputeTitle.
  ///
  /// In en, this message translates to:
  /// **'Report details'**
  String get disputeTitle;

  /// No description provided for @disputeStatusOpen.
  ///
  /// In en, this message translates to:
  /// **'Received'**
  String get disputeStatusOpen;

  /// No description provided for @disputeStatusInvestigating.
  ///
  /// In en, this message translates to:
  /// **'Under review'**
  String get disputeStatusInvestigating;

  /// No description provided for @disputeStatusResolved.
  ///
  /// In en, this message translates to:
  /// **'Resolved'**
  String get disputeStatusResolved;

  /// No description provided for @disputeStatusRejected.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get disputeStatusRejected;

  /// No description provided for @disputeHeadlineOpen.
  ///
  /// In en, this message translates to:
  /// **'We\'ve received your report'**
  String get disputeHeadlineOpen;

  /// No description provided for @disputeHeadlineInvestigating.
  ///
  /// In en, this message translates to:
  /// **'Our team is reviewing your report'**
  String get disputeHeadlineInvestigating;

  /// No description provided for @disputeHeadlineResolved.
  ///
  /// In en, this message translates to:
  /// **'Your report is resolved'**
  String get disputeHeadlineResolved;

  /// No description provided for @disputeHeadlineRejected.
  ///
  /// In en, this message translates to:
  /// **'We\'ve reviewed your report'**
  String get disputeHeadlineRejected;

  /// No description provided for @disputeOpenBody.
  ///
  /// In en, this message translates to:
  /// **'We\'ll notify you as soon as there\'s an update.'**
  String get disputeOpenBody;

  /// No description provided for @disputeReportedOn.
  ///
  /// In en, this message translates to:
  /// **'Reported on {date}'**
  String disputeReportedOn(String date);

  /// No description provided for @disputeRefundedTitle.
  ///
  /// In en, this message translates to:
  /// **'{amount} refunded to your wallet'**
  String disputeRefundedTitle(String amount);

  /// No description provided for @disputeOpenWallet.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get disputeOpenWallet;

  /// No description provided for @disputeOutcome.
  ///
  /// In en, this message translates to:
  /// **'Outcome'**
  String get disputeOutcome;

  /// No description provided for @disputeOutcomeNoRefund.
  ///
  /// In en, this message translates to:
  /// **'No refund was issued for this session.'**
  String get disputeOutcomeNoRefund;

  /// No description provided for @disputeTimeline.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get disputeTimeline;

  /// No description provided for @disputeStepRaised.
  ///
  /// In en, this message translates to:
  /// **'Report submitted'**
  String get disputeStepRaised;

  /// No description provided for @disputeStepReviewing.
  ///
  /// In en, this message translates to:
  /// **'Under review'**
  String get disputeStepReviewing;

  /// No description provided for @disputeStepResolved.
  ///
  /// In en, this message translates to:
  /// **'Resolved'**
  String get disputeStepResolved;

  /// No description provided for @disputeStepRejected.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get disputeStepRejected;

  /// No description provided for @disputeYourReport.
  ///
  /// In en, this message translates to:
  /// **'Your report'**
  String get disputeYourReport;

  /// No description provided for @roomReportProblem.
  ///
  /// In en, this message translates to:
  /// **'Report a problem'**
  String get roomReportProblem;

  /// No description provided for @articlesTitle.
  ///
  /// In en, this message translates to:
  /// **'Read & learn'**
  String get articlesTitle;

  /// No description provided for @articlesRailSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Guides, remedies and festivals'**
  String get articlesRailSubtitle;

  /// No description provided for @articlesAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get articlesAll;

  /// No description provided for @articlesEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing to read here yet'**
  String get articlesEmptyTitle;

  /// No description provided for @articlesEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'New articles are on their way — check back soon.'**
  String get articlesEmptyBody;

  /// No description provided for @articleCatAstrology.
  ///
  /// In en, this message translates to:
  /// **'Astrology'**
  String get articleCatAstrology;

  /// No description provided for @articleCatHoroscope.
  ///
  /// In en, this message translates to:
  /// **'Horoscope'**
  String get articleCatHoroscope;

  /// No description provided for @articleCatFestivals.
  ///
  /// In en, this message translates to:
  /// **'Festivals'**
  String get articleCatFestivals;

  /// No description provided for @articleCatRemedies.
  ///
  /// In en, this message translates to:
  /// **'Remedies'**
  String get articleCatRemedies;

  /// No description provided for @articleCatGuides.
  ///
  /// In en, this message translates to:
  /// **'Guides'**
  String get articleCatGuides;

  /// No description provided for @articleCatNews.
  ///
  /// In en, this message translates to:
  /// **'News'**
  String get articleCatNews;

  /// No description provided for @articleMinRead.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min read'**
  String articleMinRead(int minutes);

  /// No description provided for @articleShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get articleShare;

  /// No description provided for @articleMoreToRead.
  ///
  /// In en, this message translates to:
  /// **'More to read'**
  String get articleMoreToRead;

  /// No description provided for @articleAskTitle.
  ///
  /// In en, this message translates to:
  /// **'Want guidance for your own chart?'**
  String get articleAskTitle;

  /// No description provided for @articleAskBody.
  ///
  /// In en, this message translates to:
  /// **'Talk to a verified astrologer in minutes.'**
  String get articleAskBody;

  /// No description provided for @articleAskCta.
  ///
  /// In en, this message translates to:
  /// **'Ask now'**
  String get articleAskCta;

  /// No description provided for @panchangTitle.
  ///
  /// In en, this message translates to:
  /// **'Panchang'**
  String get panchangTitle;

  /// No description provided for @panchangToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get panchangToday;

  /// No description provided for @panchangPickDate.
  ///
  /// In en, this message translates to:
  /// **'Pick a date'**
  String get panchangPickDate;

  /// No description provided for @panchangMoonIn.
  ///
  /// In en, this message translates to:
  /// **'Moon in {sign}'**
  String panchangMoonIn(String sign);

  /// No description provided for @panchangTill.
  ///
  /// In en, this message translates to:
  /// **'till {time}'**
  String panchangTill(String time);

  /// No description provided for @panchangRightNow.
  ///
  /// In en, this message translates to:
  /// **'Right now'**
  String get panchangRightNow;

  /// No description provided for @panchangNowChoghadiya.
  ///
  /// In en, this message translates to:
  /// **'{name} Choghadiya until {time}'**
  String panchangNowChoghadiya(String name, String time);

  /// No description provided for @panchangRahuNow.
  ///
  /// In en, this message translates to:
  /// **'Rahu Kaal is on until {time} — hold off on new beginnings.'**
  String panchangRahuNow(String time);

  /// No description provided for @panchangLimbs.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Panchang'**
  String get panchangLimbs;

  /// No description provided for @panchangAuspicious.
  ///
  /// In en, this message translates to:
  /// **'Auspicious timings'**
  String get panchangAuspicious;

  /// No description provided for @panchangInauspicious.
  ///
  /// In en, this message translates to:
  /// **'Avoid starting new work'**
  String get panchangInauspicious;

  /// No description provided for @panchangBrahma.
  ///
  /// In en, this message translates to:
  /// **'Brahma Muhurta'**
  String get panchangBrahma;

  /// No description provided for @panchangAbhijit.
  ///
  /// In en, this message translates to:
  /// **'Abhijit Muhurta'**
  String get panchangAbhijit;

  /// No description provided for @panchangNoAbhijit.
  ///
  /// In en, this message translates to:
  /// **'Abhijit Muhurta isn\'t observed on Wednesdays.'**
  String get panchangNoAbhijit;

  /// No description provided for @panchangRahuKaal.
  ///
  /// In en, this message translates to:
  /// **'Rahu Kaal'**
  String get panchangRahuKaal;

  /// No description provided for @panchangYamaganda.
  ///
  /// In en, this message translates to:
  /// **'Yamaganda'**
  String get panchangYamaganda;

  /// No description provided for @panchangGulika.
  ///
  /// In en, this message translates to:
  /// **'Gulika Kaal'**
  String get panchangGulika;

  /// No description provided for @panchangChoghadiya.
  ///
  /// In en, this message translates to:
  /// **'Choghadiya'**
  String get panchangChoghadiya;

  /// No description provided for @panchangDay.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get panchangDay;

  /// No description provided for @panchangNight.
  ///
  /// In en, this message translates to:
  /// **'Night'**
  String get panchangNight;

  /// No description provided for @panchangNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes from our astrologers'**
  String get panchangNotes;

  /// No description provided for @panchangPersonalTitle.
  ///
  /// In en, this message translates to:
  /// **'Timings for your chart'**
  String get panchangPersonalTitle;

  /// No description provided for @panchangPersonalBody.
  ///
  /// In en, this message translates to:
  /// **'See the hours that suit you best, worked out from your kundali.'**
  String get panchangPersonalBody;

  /// No description provided for @panchangFooter.
  ///
  /// In en, this message translates to:
  /// **'Calculated for {place} · {timezone} · from local sunrise'**
  String panchangFooter(String place, String timezone);

  /// No description provided for @panchangChoosePlaceTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your city'**
  String get panchangChoosePlaceTitle;

  /// No description provided for @panchangChoosePlaceBody.
  ///
  /// In en, this message translates to:
  /// **'Panchang timings depend on where you are — pick the city you want them for.'**
  String get panchangChoosePlaceBody;

  /// No description provided for @panchangChoosePlaceCta.
  ///
  /// In en, this message translates to:
  /// **'Choose city'**
  String get panchangChoosePlaceCta;

  /// No description provided for @panchangUsePlace.
  ///
  /// In en, this message translates to:
  /// **'Use {place}'**
  String panchangUsePlace(String place);

  /// No description provided for @panchangCity.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get panchangCity;

  /// No description provided for @panchangCityHint.
  ///
  /// In en, this message translates to:
  /// **'Search a city or town'**
  String get panchangCityHint;

  /// No description provided for @kPdfTitle.
  ///
  /// In en, this message translates to:
  /// **'Kundali report (PDF)'**
  String get kPdfTitle;

  /// No description provided for @kPdfFull.
  ///
  /// In en, this message translates to:
  /// **'Full report'**
  String get kPdfFull;

  /// No description provided for @kPdfFullSub.
  ///
  /// In en, this message translates to:
  /// **'Charts, planets, avakahada, dasha timeline, yogas and doshas'**
  String get kPdfFullSub;

  /// No description provided for @kPdfBasic.
  ///
  /// In en, this message translates to:
  /// **'One-page summary'**
  String get kPdfBasic;

  /// No description provided for @kPdfBasicSub.
  ///
  /// In en, this message translates to:
  /// **'Lagna and Navamsa charts with planet positions'**
  String get kPdfBasicSub;

  /// No description provided for @kPdfChartStyle.
  ///
  /// In en, this message translates to:
  /// **'Chart style'**
  String get kPdfChartStyle;

  /// No description provided for @kPdfEastIndian.
  ///
  /// In en, this message translates to:
  /// **'East Indian'**
  String get kPdfEastIndian;

  /// No description provided for @kPdfShareCta.
  ///
  /// In en, this message translates to:
  /// **'Download & share'**
  String get kPdfShareCta;

  /// No description provided for @kPdfPreparing.
  ///
  /// In en, this message translates to:
  /// **'Preparing your PDF…'**
  String get kPdfPreparing;

  /// No description provided for @kPdfNote.
  ///
  /// In en, this message translates to:
  /// **'The PDF is in English. Save it to your phone or send it on WhatsApp.'**
  String get kPdfNote;

  /// No description provided for @kPdfUnavailable.
  ///
  /// In en, this message translates to:
  /// **'PDF reports aren\'t available right now. Please try again later.'**
  String get kPdfUnavailable;

  /// No description provided for @kOvEyebrow.
  ///
  /// In en, this message translates to:
  /// **'Janam Kundali'**
  String get kOvEyebrow;

  /// No description provided for @kOvMoonChip.
  ///
  /// In en, this message translates to:
  /// **'Moon · {sign}'**
  String kOvMoonChip(String sign);

  /// No description provided for @kOvTapHouseHint.
  ///
  /// In en, this message translates to:
  /// **'Tap any house to read what it says about you'**
  String get kOvTapHouseHint;

  /// No description provided for @kOvBirthDetailsSub.
  ///
  /// In en, this message translates to:
  /// **'Avakahada, panchang at birth and more'**
  String get kOvBirthDetailsSub;

  /// No description provided for @kOvGroupCharts.
  ///
  /// In en, this message translates to:
  /// **'Chart & planets'**
  String get kOvGroupCharts;

  /// No description provided for @kOvGroupTiming.
  ///
  /// In en, this message translates to:
  /// **'Timing & periods'**
  String get kOvGroupTiming;

  /// No description provided for @kOvGroupGuidance.
  ///
  /// In en, this message translates to:
  /// **'Guidance & remedies'**
  String get kOvGroupGuidance;

  /// No description provided for @kOvLoadError.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t open this kundali'**
  String get kOvLoadError;

  /// No description provided for @kKitAskTitle.
  ///
  /// In en, this message translates to:
  /// **'Have a question about your chart?'**
  String get kKitAskTitle;

  /// No description provided for @kKitAskBody.
  ///
  /// In en, this message translates to:
  /// **'A verified astrologer can read it with you — personally, in minutes.'**
  String get kKitAskBody;

  /// No description provided for @kFcExploreMore.
  ///
  /// In en, this message translates to:
  /// **'Go deeper'**
  String get kFcExploreMore;

  /// No description provided for @kFcAllHousesSub.
  ///
  /// In en, this message translates to:
  /// **'All twelve houses of your Lagna chart, one tap each'**
  String get kFcAllHousesSub;

  /// No description provided for @kFcAllChartsSub.
  ///
  /// In en, this message translates to:
  /// **'Every divisional chart from D1 to D60'**
  String get kFcAllChartsSub;

  /// No description provided for @kPlanetsHeroSub.
  ///
  /// In en, this message translates to:
  /// **'Nine grahas, where they sit and how strong they are. Tap any planet to read it.'**
  String get kPlanetsHeroSub;

  /// No description provided for @kPlanetsStrongCount.
  ///
  /// In en, this message translates to:
  /// **'{count} strong'**
  String kPlanetsStrongCount(int count);

  /// No description provided for @kPlanetsRetroCount.
  ///
  /// In en, this message translates to:
  /// **'{count} retrograde'**
  String kPlanetsRetroCount(int count);

  /// No description provided for @kPlanetRetrograde.
  ///
  /// In en, this message translates to:
  /// **'Retrograde'**
  String get kPlanetRetrograde;

  /// No description provided for @kPlanetCombust.
  ///
  /// In en, this message translates to:
  /// **'Combust'**
  String get kPlanetCombust;

  /// No description provided for @kDashaTimelineTitle.
  ///
  /// In en, this message translates to:
  /// **'Your life timeline'**
  String get kDashaTimelineTitle;

  /// No description provided for @kDashaProgressPct.
  ///
  /// In en, this message translates to:
  /// **'{pct}% complete'**
  String kDashaProgressPct(String pct);

  /// No description provided for @kBhavaHeroSub.
  ///
  /// In en, this message translates to:
  /// **'Twelve houses, twelve areas of life — what supports each one and what strains it.'**
  String get kBhavaHeroSub;

  /// No description provided for @kBhavaSupportedCount.
  ///
  /// In en, this message translates to:
  /// **'{count} supported'**
  String kBhavaSupportedCount(int count);

  /// No description provided for @kBhavaStrainedCount.
  ///
  /// In en, this message translates to:
  /// **'{count} under strain'**
  String kBhavaStrainedCount(int count);

  /// No description provided for @kYdDoshaHeroSub.
  ///
  /// In en, this message translates to:
  /// **'Traditional doshas checked in your chart, with how strong each one really is.'**
  String get kYdDoshaHeroSub;

  /// No description provided for @kYdYogaHeroSub.
  ///
  /// In en, this message translates to:
  /// **'Planetary combinations that shape your gifts and opportunities.'**
  String get kYdYogaHeroSub;

  /// No description provided for @kYdDoshaCount.
  ///
  /// In en, this message translates to:
  /// **'{count} present'**
  String kYdDoshaCount(int count);

  /// No description provided for @kYdYogaCount.
  ///
  /// In en, this message translates to:
  /// **'{count} yogas'**
  String kYdYogaCount(int count);

  /// No description provided for @kYdClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get kYdClear;

  /// No description provided for @kYdRemediesSub.
  ///
  /// In en, this message translates to:
  /// **'Gentle, traditional remedies suited to your chart'**
  String get kYdRemediesSub;

  /// No description provided for @kSsLifetimeTitle.
  ///
  /// In en, this message translates to:
  /// **'Across your lifetime'**
  String get kSsLifetimeTitle;

  /// No description provided for @kSsNotRunning.
  ///
  /// In en, this message translates to:
  /// **'Not running now'**
  String get kSsNotRunning;

  /// No description provided for @kTrHeroSub.
  ///
  /// In en, this message translates to:
  /// **'Today\'s planets read from your Moon in {sign}'**
  String kTrHeroSub(String sign);

  /// No description provided for @kTrJupiterChip.
  ///
  /// In en, this message translates to:
  /// **'Jupiter {house} from Moon'**
  String kTrJupiterChip(String house);

  /// No description provided for @kTrSadeSatiCalendarSub.
  ///
  /// In en, this message translates to:
  /// **'Every phase of Saturn\'s cycle, past and upcoming'**
  String get kTrSadeSatiCalendarSub;

  /// No description provided for @kSsEyebrow.
  ///
  /// In en, this message translates to:
  /// **'Saturn\'s cycle'**
  String get kSsEyebrow;

  /// No description provided for @kAdvHeroSub.
  ///
  /// In en, this message translates to:
  /// **'The technical layer astrologers read from'**
  String get kAdvHeroSub;

  /// No description provided for @kAdvReportCount.
  ///
  /// In en, this message translates to:
  /// **'{count} reports'**
  String kAdvReportCount(int count);

  /// No description provided for @kAdvPdfChip.
  ///
  /// In en, this message translates to:
  /// **'PDF download'**
  String get kAdvPdfChip;

  /// No description provided for @kAdvReportsTitle.
  ///
  /// In en, this message translates to:
  /// **'Technical reports'**
  String get kAdvReportsTitle;

  /// No description provided for @kAdvAvHousesTitle.
  ///
  /// In en, this message translates to:
  /// **'Points by house'**
  String get kAdvAvHousesTitle;

  /// No description provided for @kAdvSarvaTotal.
  ///
  /// In en, this message translates to:
  /// **'{total} points in all'**
  String kAdvSarvaTotal(int total);

  /// No description provided for @kInHeroSub.
  ///
  /// In en, this message translates to:
  /// **'A character and life sketch drawn from your birth chart'**
  String get kInHeroSub;

  /// No description provided for @kInSupportiveCount.
  ///
  /// In en, this message translates to:
  /// **'{count} supportive'**
  String kInSupportiveCount(int count);

  /// No description provided for @kInChallengingCount.
  ///
  /// In en, this message translates to:
  /// **'{count} need care'**
  String kInChallengingCount(int count);

  /// No description provided for @kInGlanceTitle.
  ///
  /// In en, this message translates to:
  /// **'At a glance'**
  String get kInGlanceTitle;

  /// No description provided for @kInAreasTitle.
  ///
  /// In en, this message translates to:
  /// **'Area by area'**
  String get kInAreasTitle;

  /// No description provided for @kLkHeroSub.
  ///
  /// In en, this message translates to:
  /// **'Inherited debts in your chart and their simple household remedies'**
  String get kLkHeroSub;

  /// No description provided for @kLkDebtCount.
  ///
  /// In en, this message translates to:
  /// **'{count} active debts'**
  String kLkDebtCount(int count);

  /// No description provided for @kLkWeakCount.
  ///
  /// In en, this message translates to:
  /// **'{count} weak planets'**
  String kLkWeakCount(int count);

  /// No description provided for @kMuHeroSub.
  ///
  /// In en, this message translates to:
  /// **'Today\'s good hours, read for your chart'**
  String get kMuHeroSub;

  /// No description provided for @kMuTimingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'s timings'**
  String get kMuTimingsTitle;

  /// No description provided for @kMuTabDay.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get kMuTabDay;

  /// No description provided for @kMuTabNight.
  ///
  /// In en, this message translates to:
  /// **'Night'**
  String get kMuTabNight;

  /// No description provided for @kMuHoraOf.
  ///
  /// In en, this message translates to:
  /// **'{planet} hora'**
  String kMuHoraOf(String planet);

  /// No description provided for @kMuAbhijit.
  ///
  /// In en, this message translates to:
  /// **'Abhijit muhurta'**
  String get kMuAbhijit;

  /// No description provided for @kNumHeroSub.
  ///
  /// In en, this message translates to:
  /// **'Your core numbers and Lo Shu birth grid'**
  String get kNumHeroSub;

  /// No description provided for @kNumYourNumbers.
  ///
  /// In en, this message translates to:
  /// **'Your numbers'**
  String get kNumYourNumbers;

  /// No description provided for @kNumMissing.
  ///
  /// In en, this message translates to:
  /// **'Missing numbers'**
  String get kNumMissing;

  /// No description provided for @kNumRepeated.
  ///
  /// In en, this message translates to:
  /// **'Repeated numbers'**
  String get kNumRepeated;

  /// No description provided for @kRmHeroSub.
  ///
  /// In en, this message translates to:
  /// **'Gentle, traditional practices matched to your chart'**
  String get kRmHeroSub;

  /// No description provided for @kRmCount.
  ///
  /// In en, this message translates to:
  /// **'{count} remedies'**
  String kRmCount(int count);

  /// No description provided for @kRmGatedChip.
  ///
  /// In en, this message translates to:
  /// **'Some need an astrologer'**
  String get kRmGatedChip;

  /// No description provided for @kRmCaution.
  ///
  /// In en, this message translates to:
  /// **'Keep in mind'**
  String get kRmCaution;

  /// No description provided for @kUpHeroSub.
  ///
  /// In en, this message translates to:
  /// **'Colours, days, mantras and charity for each planet'**
  String get kUpHeroSub;

  /// No description provided for @kUpStrengthenCount.
  ///
  /// In en, this message translates to:
  /// **'{count} to strengthen'**
  String kUpStrengthenCount(int count);

  /// No description provided for @kUpPacifyCount.
  ///
  /// In en, this message translates to:
  /// **'{count} to pacify'**
  String kUpPacifyCount(int count);

  /// No description provided for @kUpGateTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm with an astrologer first'**
  String get kUpGateTitle;

  /// No description provided for @kUpPlanetsTitle.
  ///
  /// In en, this message translates to:
  /// **'Planet by planet'**
  String get kUpPlanetsTitle;

  /// No description provided for @kVpHeadline.
  ///
  /// In en, this message translates to:
  /// **'Your year {year}'**
  String kVpHeadline(String year);

  /// No description provided for @kVpMarkersTitle.
  ///
  /// In en, this message translates to:
  /// **'Key markers of the year'**
  String get kVpMarkersTitle;

  /// No description provided for @kVpTajikaTitle.
  ///
  /// In en, this message translates to:
  /// **'Tajika aspect'**
  String get kVpTajikaTitle;

  /// No description provided for @kVpIthasala.
  ///
  /// In en, this message translates to:
  /// **'Ithasala · applying'**
  String get kVpIthasala;

  /// No description provided for @kVpIshrafa.
  ///
  /// In en, this message translates to:
  /// **'Ishrafa · separating'**
  String get kVpIshrafa;

  /// No description provided for @followFollow.
  ///
  /// In en, this message translates to:
  /// **'Follow'**
  String get followFollow;

  /// No description provided for @followFollowing.
  ///
  /// In en, this message translates to:
  /// **'Following'**
  String get followFollowing;

  /// No description provided for @followNotifying.
  ///
  /// In en, this message translates to:
  /// **'Notifying'**
  String get followNotifying;

  /// No description provided for @followNotifyingWhenOnline.
  ///
  /// In en, this message translates to:
  /// **'We\'ll notify you when online'**
  String get followNotifyingWhenOnline;

  /// No description provided for @followedToast.
  ///
  /// In en, this message translates to:
  /// **'Following {name} — we\'ll let you know when they\'re online or live'**
  String followedToast(String name);

  /// No description provided for @unfollowedToast.
  ///
  /// In en, this message translates to:
  /// **'Unfollowed {name}'**
  String unfollowedToast(String name);

  /// No description provided for @followFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t update follow. Please try again.'**
  String get followFailed;

  /// No description provided for @followPromptTitle.
  ///
  /// In en, this message translates to:
  /// **'Follow {name}?'**
  String followPromptTitle(String name);

  /// No description provided for @followPromptBody.
  ///
  /// In en, this message translates to:
  /// **'Get a notification when they\'re online or go live.'**
  String get followPromptBody;

  /// No description provided for @followPromptDoneTitle.
  ///
  /// In en, this message translates to:
  /// **'You\'re following'**
  String get followPromptDoneTitle;

  /// No description provided for @followPromptDoneBody.
  ///
  /// In en, this message translates to:
  /// **'We\'ll tell you when {name} is online or live.'**
  String followPromptDoneBody(String name);

  /// No description provided for @followingTitle.
  ///
  /// In en, this message translates to:
  /// **'Following'**
  String get followingTitle;

  /// No description provided for @followingHint.
  ///
  /// In en, this message translates to:
  /// **'You\'ll get a notification when these astrologers come online or go live. Tap the heart to unfollow.'**
  String get followingHint;

  /// No description provided for @followingEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Not following anyone yet'**
  String get followingEmptyTitle;

  /// No description provided for @followingEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Follow astrologers you like to know when they\'re online or live.'**
  String get followingEmptyBody;

  /// No description provided for @followingExplore.
  ///
  /// In en, this message translates to:
  /// **'Find astrologers'**
  String get followingExplore;

  /// No description provided for @followingLoadError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load the astrologers you follow.'**
  String get followingLoadError;

  /// No description provided for @followingFilter.
  ///
  /// In en, this message translates to:
  /// **'Following'**
  String get followingFilter;

  /// No description provided for @followingFilterEmpty.
  ///
  /// In en, this message translates to:
  /// **'Tap the heart on an astrologer to follow them — they\'ll show up here.'**
  String get followingFilterEmpty;

  /// No description provided for @astroStatFollowers.
  ///
  /// In en, this message translates to:
  /// **'Followers'**
  String get astroStatFollowers;

  /// No description provided for @prefsFollowAlerts.
  ///
  /// In en, this message translates to:
  /// **'Astrologers you follow'**
  String get prefsFollowAlerts;

  /// No description provided for @prefsFollowAlertsDesc.
  ///
  /// In en, this message translates to:
  /// **'When they come online or go live'**
  String get prefsFollowAlertsDesc;

  /// No description provided for @storeTitle.
  ///
  /// In en, this message translates to:
  /// **'Remedy Store'**
  String get storeTitle;

  /// No description provided for @storeHeroSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Authentic rudraksha, gemstones, yantras and poojas — guided by astrologers'**
  String get storeHeroSubtitle;

  /// No description provided for @storeSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search rudraksha, gemstones, poojas…'**
  String get storeSearchHint;

  /// No description provided for @storeVerdictToast.
  ///
  /// In en, this message translates to:
  /// **'An astrologer shared advice on your product'**
  String get storeVerdictToast;

  /// No description provided for @storeView.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get storeView;

  /// No description provided for @storeUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get storeUnavailable;

  /// No description provided for @storePriceFrom.
  ///
  /// In en, this message translates to:
  /// **'from {price}'**
  String storePriceFrom(String price);

  /// No description provided for @storeOff.
  ///
  /// In en, this message translates to:
  /// **'{percent}% off'**
  String storeOff(int percent);

  /// No description provided for @storeBadgePooja.
  ///
  /// In en, this message translates to:
  /// **'Pooja'**
  String get storeBadgePooja;

  /// No description provided for @storeBadgeAskAstrologer.
  ///
  /// In en, this message translates to:
  /// **'Ask astrologer'**
  String get storeBadgeAskAstrologer;

  /// No description provided for @storeCartTitle.
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get storeCartTitle;

  /// No description provided for @storeTrustCertified.
  ///
  /// In en, this message translates to:
  /// **'Lab certified'**
  String get storeTrustCertified;

  /// No description provided for @storeTrustGuided.
  ///
  /// In en, this message translates to:
  /// **'Astrologer guided'**
  String get storeTrustGuided;

  /// No description provided for @storeTrustSecure.
  ///
  /// In en, this message translates to:
  /// **'Secure payments'**
  String get storeTrustSecure;

  /// No description provided for @storeCategories.
  ///
  /// In en, this message translates to:
  /// **'Shop by category'**
  String get storeCategories;

  /// No description provided for @storeFeatured.
  ///
  /// In en, this message translates to:
  /// **'Handpicked remedies'**
  String get storeFeatured;

  /// No description provided for @storeFeaturedSub.
  ///
  /// In en, this message translates to:
  /// **'Chosen by our astrologers'**
  String get storeFeaturedSub;

  /// No description provided for @storeCollections.
  ///
  /// In en, this message translates to:
  /// **'Remedy collections'**
  String get storeCollections;

  /// No description provided for @storePoojas.
  ///
  /// In en, this message translates to:
  /// **'Book a pooja'**
  String get storePoojas;

  /// No description provided for @storePoojasSub.
  ///
  /// In en, this message translates to:
  /// **'Performed in your name at sacred temples'**
  String get storePoojasSub;

  /// No description provided for @storeConsultBannerTitle.
  ///
  /// In en, this message translates to:
  /// **'Not sure what suits you?'**
  String get storeConsultBannerTitle;

  /// No description provided for @storeConsultBannerBody.
  ///
  /// In en, this message translates to:
  /// **'Video call an astrologer before you buy — they check your chart and recommend the right remedy.'**
  String get storeConsultBannerBody;

  /// No description provided for @storeConsultBannerCta.
  ///
  /// In en, this message translates to:
  /// **'Talk to an astrologer'**
  String get storeConsultBannerCta;

  /// No description provided for @storeMyAdvice.
  ///
  /// In en, this message translates to:
  /// **'Advice from your astrologers'**
  String get storeMyAdvice;

  /// No description provided for @storeDisclaimerFooter.
  ///
  /// In en, this message translates to:
  /// **'Remedies are traditional practices. Results are not guaranteed and they don\'t replace medical, legal or financial advice.'**
  String get storeDisclaimerFooter;

  /// No description provided for @storeEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'The store is getting ready'**
  String get storeEmptyTitle;

  /// No description provided for @storeEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Remedies and poojas will appear here soon.'**
  String get storeEmptyBody;

  /// No description provided for @storeLoadError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load the store'**
  String get storeLoadError;

  /// No description provided for @storeMyOrders.
  ///
  /// In en, this message translates to:
  /// **'My orders'**
  String get storeMyOrders;

  /// No description provided for @storeVerdictSuitable.
  ///
  /// In en, this message translates to:
  /// **'Suitable — go ahead'**
  String get storeVerdictSuitable;

  /// No description provided for @storeVerdictNotSuitable.
  ///
  /// In en, this message translates to:
  /// **'Not suitable for you'**
  String get storeVerdictNotSuitable;

  /// No description provided for @storeVerdictAlternative.
  ///
  /// In en, this message translates to:
  /// **'Suggests something else'**
  String get storeVerdictAlternative;

  /// No description provided for @storeConsultCancelled.
  ///
  /// In en, this message translates to:
  /// **'Call didn\'t happen'**
  String get storeConsultCancelled;

  /// No description provided for @storeConsultExpired.
  ///
  /// In en, this message translates to:
  /// **'No advice was shared'**
  String get storeConsultExpired;

  /// No description provided for @storeConsultCallLive.
  ///
  /// In en, this message translates to:
  /// **'Your call is in progress'**
  String get storeConsultCallLive;

  /// No description provided for @storeConsultAwaiting.
  ///
  /// In en, this message translates to:
  /// **'Waiting for the astrologer\'s advice'**
  String get storeConsultAwaiting;

  /// No description provided for @storeConsultWith.
  ///
  /// In en, this message translates to:
  /// **'with {name}'**
  String storeConsultWith(String name);

  /// No description provided for @storeVerdictFrom.
  ///
  /// In en, this message translates to:
  /// **'{name}\'s advice'**
  String storeVerdictFrom(String name);

  /// No description provided for @storeBuyRecommended.
  ///
  /// In en, this message translates to:
  /// **'Buy the recommended option'**
  String get storeBuyRecommended;

  /// No description provided for @storeSuggestedInstead.
  ///
  /// In en, this message translates to:
  /// **'Suggested instead'**
  String get storeSuggestedInstead;

  /// No description provided for @storeConsultPromptTitle.
  ///
  /// In en, this message translates to:
  /// **'Not sure it suits you?'**
  String get storeConsultPromptTitle;

  /// No description provided for @storeConsultPromptBody.
  ///
  /// In en, this message translates to:
  /// **'Video call an astrologer — they\'ll check your chart before you buy.'**
  String get storeConsultPromptBody;

  /// No description provided for @storeConsultRequiredTitle.
  ///
  /// In en, this message translates to:
  /// **'Consult an astrologer first'**
  String get storeConsultRequiredTitle;

  /// No description provided for @storeConsultRequiredBody.
  ///
  /// In en, this message translates to:
  /// **'This remedy is sold only after an astrologer confirms it suits your chart.'**
  String get storeConsultRequiredBody;

  /// No description provided for @storeNoResults.
  ///
  /// In en, this message translates to:
  /// **'Nothing matches'**
  String get storeNoResults;

  /// No description provided for @storeNoResultsBody.
  ///
  /// In en, this message translates to:
  /// **'Try another word or clear some filters.'**
  String get storeNoResultsBody;

  /// No description provided for @storeClearFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear filters'**
  String get storeClearFilters;

  /// No description provided for @storeResultCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 item} other{{count} items}}'**
  String storeResultCount(int count);

  /// No description provided for @storeFilters.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get storeFilters;

  /// No description provided for @storeNoFilters.
  ///
  /// In en, this message translates to:
  /// **'No filters for this selection yet.'**
  String get storeNoFilters;

  /// No description provided for @storeSortBy.
  ///
  /// In en, this message translates to:
  /// **'Sort by'**
  String get storeSortBy;

  /// No description provided for @storeSortRecommended.
  ///
  /// In en, this message translates to:
  /// **'Recommended'**
  String get storeSortRecommended;

  /// No description provided for @storeSortPopular.
  ///
  /// In en, this message translates to:
  /// **'Most popular'**
  String get storeSortPopular;

  /// No description provided for @storeSortNew.
  ///
  /// In en, this message translates to:
  /// **'Newest'**
  String get storeSortNew;

  /// No description provided for @storeSortRating.
  ///
  /// In en, this message translates to:
  /// **'Top rated'**
  String get storeSortRating;

  /// No description provided for @storeKindProducts.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get storeKindProducts;

  /// No description provided for @storeKindPoojas.
  ///
  /// In en, this message translates to:
  /// **'Poojas'**
  String get storeKindPoojas;

  /// No description provided for @storeKindDigital.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get storeKindDigital;

  /// No description provided for @storeRemedyFor.
  ///
  /// In en, this message translates to:
  /// **'Remedy: {key}'**
  String storeRemedyFor(String key);

  /// No description provided for @storeChoosePackage.
  ///
  /// In en, this message translates to:
  /// **'Choose a package'**
  String get storeChoosePackage;

  /// No description provided for @storeChooseOption.
  ///
  /// In en, this message translates to:
  /// **'Choose an option'**
  String get storeChooseOption;

  /// No description provided for @storePickDate.
  ///
  /// In en, this message translates to:
  /// **'Pick a date'**
  String get storePickDate;

  /// No description provided for @storeSankalpDetails.
  ///
  /// In en, this message translates to:
  /// **'Sankalp details'**
  String get storeSankalpDetails;

  /// No description provided for @storeYourDetails.
  ///
  /// In en, this message translates to:
  /// **'Your details'**
  String get storeYourDetails;

  /// No description provided for @storeSankalpHint.
  ///
  /// In en, this message translates to:
  /// **'The priest takes the sankalp in these names during the pooja.'**
  String get storeSankalpHint;

  /// No description provided for @storeCertificate.
  ///
  /// In en, this message translates to:
  /// **'Certificate of authenticity'**
  String get storeCertificate;

  /// No description provided for @storeCertificateNo.
  ///
  /// In en, this message translates to:
  /// **'Certificate no. {number}'**
  String storeCertificateNo(String number);

  /// No description provided for @storeVerify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get storeVerify;

  /// No description provided for @storeHighlights.
  ///
  /// In en, this message translates to:
  /// **'Highlights'**
  String get storeHighlights;

  /// No description provided for @storeAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get storeAbout;

  /// No description provided for @storeSignificance.
  ///
  /// In en, this message translates to:
  /// **'Traditional significance'**
  String get storeSignificance;

  /// No description provided for @storeHowToUse.
  ///
  /// In en, this message translates to:
  /// **'How to wear / use'**
  String get storeHowToUse;

  /// No description provided for @storeHowItWorks.
  ///
  /// In en, this message translates to:
  /// **'How it works'**
  String get storeHowItWorks;

  /// No description provided for @storeReadMore.
  ///
  /// In en, this message translates to:
  /// **'Read more'**
  String get storeReadMore;

  /// No description provided for @storeReadLess.
  ///
  /// In en, this message translates to:
  /// **'Show less'**
  String get storeReadLess;

  /// No description provided for @storeRecommendedForYou.
  ///
  /// In en, this message translates to:
  /// **'Recommended for you'**
  String get storeRecommendedForYou;

  /// No description provided for @storeTaxInclusive.
  ///
  /// In en, this message translates to:
  /// **'Inclusive of all taxes'**
  String get storeTaxInclusive;

  /// No description provided for @storeOutOfStock.
  ///
  /// In en, this message translates to:
  /// **'Out of stock'**
  String get storeOutOfStock;

  /// No description provided for @storeOnlyLeft.
  ///
  /// In en, this message translates to:
  /// **'Only {count} left'**
  String storeOnlyLeft(int count);

  /// No description provided for @storeAskAnother.
  ///
  /// In en, this message translates to:
  /// **'Ask another astrologer'**
  String get storeAskAnother;

  /// No description provided for @storeNoDates.
  ///
  /// In en, this message translates to:
  /// **'Dates will be announced soon.'**
  String get storeNoDates;

  /// No description provided for @storeOpenForBooking.
  ///
  /// In en, this message translates to:
  /// **'Open for booking'**
  String get storeOpenForBooking;

  /// No description provided for @storeSeatsLeft.
  ///
  /// In en, this message translates to:
  /// **'{count} slots left'**
  String storeSeatsLeft(int count);

  /// No description provided for @storeReturnableDays.
  ///
  /// In en, this message translates to:
  /// **'Easy returns within {days} days of delivery'**
  String storeReturnableDays(int days);

  /// No description provided for @storeNotReturnable.
  ///
  /// In en, this message translates to:
  /// **'Not returnable once delivered'**
  String get storeNotReturnable;

  /// No description provided for @storeCancellable.
  ///
  /// In en, this message translates to:
  /// **'Cancel free before it\'s dispatched'**
  String get storeCancellable;

  /// No description provided for @storeNotCancellable.
  ///
  /// In en, this message translates to:
  /// **'Can\'t be cancelled once ordered'**
  String get storeNotCancellable;

  /// No description provided for @storeMadeToOrder.
  ///
  /// In en, this message translates to:
  /// **'Made to order · ready in about {days} days'**
  String storeMadeToOrder(int days);

  /// No description provided for @storeShipsIndia.
  ///
  /// In en, this message translates to:
  /// **'Insured shipping across India'**
  String get storeShipsIndia;

  /// No description provided for @storeVideoProof.
  ///
  /// In en, this message translates to:
  /// **'Video of the pooja shared with you'**
  String get storeVideoProof;

  /// No description provided for @storeInstantDownload.
  ///
  /// In en, this message translates to:
  /// **'Instant download after payment'**
  String get storeInstantDownload;

  /// No description provided for @storeSoldBy.
  ///
  /// In en, this message translates to:
  /// **'Sold by {name}'**
  String storeSoldBy(String name);

  /// No description provided for @storeSellerInfo.
  ///
  /// In en, this message translates to:
  /// **'Seller & grievance details'**
  String get storeSellerInfo;

  /// No description provided for @storeCountryOfOrigin.
  ///
  /// In en, this message translates to:
  /// **'Country of origin: {country}'**
  String storeCountryOfOrigin(String country);

  /// No description provided for @storeGrievanceOfficer.
  ///
  /// In en, this message translates to:
  /// **'Grievance officer'**
  String get storeGrievanceOfficer;

  /// No description provided for @storeFieldRequired.
  ///
  /// In en, this message translates to:
  /// **'{label} is required'**
  String storeFieldRequired(String label);

  /// No description provided for @storeFieldParticipants.
  ///
  /// In en, this message translates to:
  /// **'Enter {count} {label}'**
  String storeFieldParticipants(String label, int count);

  /// No description provided for @storePickDateError.
  ///
  /// In en, this message translates to:
  /// **'Pick a date for the pooja'**
  String get storePickDateError;

  /// No description provided for @storeAddedToCart.
  ///
  /// In en, this message translates to:
  /// **'Added to cart'**
  String get storeAddedToCart;

  /// No description provided for @storeViewCart.
  ///
  /// In en, this message translates to:
  /// **'View cart'**
  String get storeViewCart;

  /// No description provided for @storeFixDetails.
  ///
  /// In en, this message translates to:
  /// **'Please check the highlighted details'**
  String get storeFixDetails;

  /// No description provided for @storeAddToCart.
  ///
  /// In en, this message translates to:
  /// **'Add to cart'**
  String get storeAddToCart;

  /// No description provided for @storeBuyNow.
  ///
  /// In en, this message translates to:
  /// **'Buy now'**
  String get storeBuyNow;

  /// No description provided for @storeBookPooja.
  ///
  /// In en, this message translates to:
  /// **'Book pooja'**
  String get storeBookPooja;

  /// No description provided for @storeConsultFirst.
  ///
  /// In en, this message translates to:
  /// **'Consult first'**
  String get storeConsultFirst;

  /// No description provided for @storePersonN.
  ///
  /// In en, this message translates to:
  /// **'Person {n}'**
  String storePersonN(int n);

  /// No description provided for @storeConsultTitle.
  ///
  /// In en, this message translates to:
  /// **'Talk before you buy'**
  String get storeConsultTitle;

  /// No description provided for @storeConsultPick.
  ///
  /// In en, this message translates to:
  /// **'Choose an astrologer'**
  String get storeConsultPick;

  /// No description provided for @storeConsultNoneTitle.
  ///
  /// In en, this message translates to:
  /// **'No one\'s available right now'**
  String get storeConsultNoneTitle;

  /// No description provided for @storeConsultNoneBody.
  ///
  /// In en, this message translates to:
  /// **'Astrologers who take video calls will show up here. Try again in a little while.'**
  String get storeConsultNoneBody;

  /// No description provided for @storeConsultBrowseAll.
  ///
  /// In en, this message translates to:
  /// **'Browse all astrologers'**
  String get storeConsultBrowseAll;

  /// No description provided for @storeConsultAbout.
  ///
  /// In en, this message translates to:
  /// **'Consultation about'**
  String get storeConsultAbout;

  /// No description provided for @storeConsultVideoPerMinute.
  ///
  /// In en, this message translates to:
  /// **'Video call · billed per minute'**
  String get storeConsultVideoPerMinute;

  /// No description provided for @storeConsultOffer.
  ///
  /// In en, this message translates to:
  /// **'Offer applied'**
  String get storeConsultOffer;

  /// No description provided for @storeConsultStep1.
  ///
  /// In en, this message translates to:
  /// **'Video call an astrologer'**
  String get storeConsultStep1;

  /// No description provided for @storeConsultStep2.
  ///
  /// In en, this message translates to:
  /// **'They check your chart and advise'**
  String get storeConsultStep2;

  /// No description provided for @storeConsultStep3.
  ///
  /// In en, this message translates to:
  /// **'Buy what\'s right for you'**
  String get storeConsultStep3;

  /// No description provided for @storePresenceOnline.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get storePresenceOnline;

  /// No description provided for @storePresenceBusy.
  ///
  /// In en, this message translates to:
  /// **'In a call'**
  String get storePresenceBusy;

  /// No description provided for @storePresenceOffline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get storePresenceOffline;

  /// No description provided for @storeSpecialist.
  ///
  /// In en, this message translates to:
  /// **'Specialist'**
  String get storeSpecialist;

  /// No description provided for @storeYearsExp.
  ///
  /// In en, this message translates to:
  /// **'{years} yrs'**
  String storeYearsExp(int years);

  /// No description provided for @storePerMinute.
  ///
  /// In en, this message translates to:
  /// **'{price}/min'**
  String storePerMinute(String price);

  /// No description provided for @storeCall.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get storeCall;

  /// No description provided for @storeConsultConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Video call {name}'**
  String storeConsultConfirmTitle(String name);

  /// No description provided for @storeConsultQuestion.
  ///
  /// In en, this message translates to:
  /// **'What would you like to ask?'**
  String get storeConsultQuestion;

  /// No description provided for @storeConsultSharingChart.
  ///
  /// In en, this message translates to:
  /// **'Sharing {name}\'s birth chart with the astrologer'**
  String storeConsultSharingChart(String name);

  /// No description provided for @storeConsultHoldNote.
  ///
  /// In en, this message translates to:
  /// **'{rate} per minute from your wallet. {hold} is held when the call starts; you only pay for the minutes you talk.'**
  String storeConsultHoldNote(String rate, String hold);

  /// No description provided for @storeConsultStartCall.
  ///
  /// In en, this message translates to:
  /// **'Start video call'**
  String get storeConsultStartCall;

  /// No description provided for @storeConsultLowBalance.
  ///
  /// In en, this message translates to:
  /// **'Add money to your wallet to start the call'**
  String get storeConsultLowBalance;

  /// No description provided for @storeConsultBusy.
  ///
  /// In en, this message translates to:
  /// **'{name} just got busy — try another astrologer'**
  String storeConsultBusy(String name);

  /// No description provided for @storeConsultOffline.
  ///
  /// In en, this message translates to:
  /// **'{name} went offline'**
  String storeConsultOffline(String name);

  /// No description provided for @storeAdviceTitle.
  ///
  /// In en, this message translates to:
  /// **'Astrologer advice'**
  String get storeAdviceTitle;

  /// No description provided for @storeAdviceEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No advice yet'**
  String get storeAdviceEmptyTitle;

  /// No description provided for @storeAdviceEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Ask an astrologer about a remedy from any product page.'**
  String get storeAdviceEmptyBody;

  /// No description provided for @storeExplore.
  ///
  /// In en, this message translates to:
  /// **'Explore the store'**
  String get storeExplore;

  /// No description provided for @storeOpenCall.
  ///
  /// In en, this message translates to:
  /// **'Open call'**
  String get storeOpenCall;

  /// No description provided for @storeYourQuestion.
  ///
  /// In en, this message translates to:
  /// **'Your question'**
  String get storeYourQuestion;

  /// No description provided for @storeVideoCall.
  ///
  /// In en, this message translates to:
  /// **'Video call'**
  String get storeVideoCall;

  /// No description provided for @storeRequired.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get storeRequired;

  /// No description provided for @storeAddAddress.
  ///
  /// In en, this message translates to:
  /// **'Add address'**
  String get storeAddAddress;

  /// No description provided for @storeEditAddress.
  ///
  /// In en, this message translates to:
  /// **'Edit address'**
  String get storeEditAddress;

  /// No description provided for @storeAddressesTitle.
  ///
  /// In en, this message translates to:
  /// **'Saved addresses'**
  String get storeAddressesTitle;

  /// No description provided for @storeNoAddressesTitle.
  ///
  /// In en, this message translates to:
  /// **'No saved addresses'**
  String get storeNoAddressesTitle;

  /// No description provided for @storeNoAddressesBody.
  ///
  /// In en, this message translates to:
  /// **'Add a delivery address to get products shipped to you.'**
  String get storeNoAddressesBody;

  /// No description provided for @storeDefault.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get storeDefault;

  /// No description provided for @storeEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get storeEdit;

  /// No description provided for @storeDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get storeDelete;

  /// No description provided for @storeMakeDefault.
  ///
  /// In en, this message translates to:
  /// **'Make default'**
  String get storeMakeDefault;

  /// No description provided for @storeChange.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get storeChange;

  /// No description provided for @storeLabelHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get storeLabelHome;

  /// No description provided for @storeLabelWork.
  ///
  /// In en, this message translates to:
  /// **'Work'**
  String get storeLabelWork;

  /// No description provided for @storeLabelOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get storeLabelOther;

  /// No description provided for @storeFullName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get storeFullName;

  /// No description provided for @storePhone.
  ///
  /// In en, this message translates to:
  /// **'Mobile number'**
  String get storePhone;

  /// No description provided for @storePhoneInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid 10-digit mobile number'**
  String get storePhoneInvalid;

  /// No description provided for @storeLine1.
  ///
  /// In en, this message translates to:
  /// **'House no., building, street'**
  String get storeLine1;

  /// No description provided for @storeLine2.
  ///
  /// In en, this message translates to:
  /// **'Area, colony (optional)'**
  String get storeLine2;

  /// No description provided for @storeLandmark.
  ///
  /// In en, this message translates to:
  /// **'Landmark (optional)'**
  String get storeLandmark;

  /// No description provided for @storeCity.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get storeCity;

  /// No description provided for @storePincode.
  ///
  /// In en, this message translates to:
  /// **'PIN code'**
  String get storePincode;

  /// No description provided for @storePincodeInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid 6-digit PIN'**
  String get storePincodeInvalid;

  /// No description provided for @storeState.
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get storeState;

  /// No description provided for @storeGstinOptional.
  ///
  /// In en, this message translates to:
  /// **'GSTIN (optional)'**
  String get storeGstinOptional;

  /// No description provided for @storeGstinHelp.
  ///
  /// In en, this message translates to:
  /// **'Add it to claim input tax credit on the invoice'**
  String get storeGstinHelp;

  /// No description provided for @storeGstinInvalid.
  ///
  /// In en, this message translates to:
  /// **'GSTIN has 15 characters'**
  String get storeGstinInvalid;

  /// No description provided for @storeSaveAddress.
  ///
  /// In en, this message translates to:
  /// **'Save address'**
  String get storeSaveAddress;

  /// No description provided for @storeCheckout.
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get storeCheckout;

  /// No description provided for @storeCartEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Your cart is empty'**
  String get storeCartEmptyTitle;

  /// No description provided for @storeCartEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Rudraksha, gemstones, yantras and poojas — find what your chart needs.'**
  String get storeCartEmptyBody;

  /// No description provided for @storeCartTaxNote.
  ///
  /// In en, this message translates to:
  /// **'Prices include GST. Shipping is calculated at checkout.'**
  String get storeCartTaxNote;

  /// No description provided for @storeItemsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 item} other{{count} items}}'**
  String storeItemsCount(int count);

  /// No description provided for @storeRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get storeRemove;

  /// No description provided for @storeDeliverTo.
  ///
  /// In en, this message translates to:
  /// **'Deliver to'**
  String get storeDeliverTo;

  /// No description provided for @storeOrderSummary.
  ///
  /// In en, this message translates to:
  /// **'Order summary'**
  String get storeOrderSummary;

  /// No description provided for @storeBillDetails.
  ///
  /// In en, this message translates to:
  /// **'Bill details'**
  String get storeBillDetails;

  /// No description provided for @storeSubtotal.
  ///
  /// In en, this message translates to:
  /// **'Item total'**
  String get storeSubtotal;

  /// No description provided for @storeShipping.
  ///
  /// In en, this message translates to:
  /// **'Shipping'**
  String get storeShipping;

  /// No description provided for @storeShippingAmount.
  ///
  /// In en, this message translates to:
  /// **'Shipping {amount}'**
  String storeShippingAmount(String amount);

  /// No description provided for @storeFree.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get storeFree;

  /// No description provided for @storeGrandTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get storeGrandTotal;

  /// No description provided for @storeTaxIncluded.
  ///
  /// In en, this message translates to:
  /// **'Includes {amount} GST'**
  String storeTaxIncluded(String amount);

  /// No description provided for @storePaidFromWallet.
  ///
  /// In en, this message translates to:
  /// **'From wallet'**
  String get storePaidFromWallet;

  /// No description provided for @storePaidOnline.
  ///
  /// In en, this message translates to:
  /// **'Paid online'**
  String get storePaidOnline;

  /// No description provided for @storeToPayNow.
  ///
  /// In en, this message translates to:
  /// **'To pay'**
  String get storeToPayNow;

  /// No description provided for @storeUseWallet.
  ///
  /// In en, this message translates to:
  /// **'Use wallet balance'**
  String get storeUseWallet;

  /// No description provided for @storeWalletAvailable.
  ///
  /// In en, this message translates to:
  /// **'{amount} available'**
  String storeWalletAvailable(String amount);

  /// No description provided for @storeOrderNote.
  ///
  /// In en, this message translates to:
  /// **'Note for the seller (optional)'**
  String get storeOrderNote;

  /// No description provided for @storeCheckoutTrust.
  ///
  /// In en, this message translates to:
  /// **'Secure payment. Certified products. Returns on damaged or wrong items.'**
  String get storeCheckoutTrust;

  /// No description provided for @storePlaceOrder.
  ///
  /// In en, this message translates to:
  /// **'Place order'**
  String get storePlaceOrder;

  /// No description provided for @storePayNow.
  ///
  /// In en, this message translates to:
  /// **'Pay now'**
  String get storePayNow;

  /// No description provided for @storePayAmount.
  ///
  /// In en, this message translates to:
  /// **'Pay {amount}'**
  String storePayAmount(String amount);

  /// No description provided for @storePayDescription.
  ///
  /// In en, this message translates to:
  /// **'Remedies store order'**
  String get storePayDescription;

  /// No description provided for @storeDeliveryDays.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, =1{In 1 day} other{In {days} days}}'**
  String storeDeliveryDays(int days);

  /// No description provided for @storeDeliveryDaysRange.
  ///
  /// In en, this message translates to:
  /// **'{min}–{max} days'**
  String storeDeliveryDaysRange(int min, int max);

  /// No description provided for @storePaymentCancelled.
  ///
  /// In en, this message translates to:
  /// **'Payment cancelled. Your order is saved — pay before it expires.'**
  String get storePaymentCancelled;

  /// No description provided for @storePaymentFailed.
  ///
  /// In en, this message translates to:
  /// **'Payment didn\'t go through. Try again.'**
  String get storePaymentFailed;

  /// No description provided for @storePaymentDone.
  ///
  /// In en, this message translates to:
  /// **'Payment received'**
  String get storePaymentDone;

  /// No description provided for @storePaymentConfirming.
  ///
  /// In en, this message translates to:
  /// **'We\'re confirming your payment. This can take a minute.'**
  String get storePaymentConfirming;

  /// No description provided for @storePaymentPendingTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment pending'**
  String get storePaymentPendingTitle;

  /// No description provided for @storePaymentPendingBody.
  ///
  /// In en, this message translates to:
  /// **'Items are held for you until the timer runs out. Any wallet amount is refunded if the order expires.'**
  String get storePaymentPendingBody;

  /// No description provided for @storeOrdersTitle.
  ///
  /// In en, this message translates to:
  /// **'My orders'**
  String get storeOrdersTitle;

  /// No description provided for @storeOrderTitle.
  ///
  /// In en, this message translates to:
  /// **'Order'**
  String get storeOrderTitle;

  /// No description provided for @storeOrderNumber.
  ///
  /// In en, this message translates to:
  /// **'Order #{number}'**
  String storeOrderNumber(String number);

  /// No description provided for @storeItemAndMore.
  ///
  /// In en, this message translates to:
  /// **'{title} + {count} more'**
  String storeItemAndMore(String title, int count);

  /// No description provided for @storeTabAll.
  ///
  /// In en, this message translates to:
  /// **'All orders'**
  String get storeTabAll;

  /// No description provided for @storeTabPoojas.
  ///
  /// In en, this message translates to:
  /// **'Poojas'**
  String get storeTabPoojas;

  /// No description provided for @storeNoOrdersTitle.
  ///
  /// In en, this message translates to:
  /// **'No orders yet'**
  String get storeNoOrdersTitle;

  /// No description provided for @storeNoOrdersBody.
  ///
  /// In en, this message translates to:
  /// **'Products and poojas you buy will show up here.'**
  String get storeNoOrdersBody;

  /// No description provided for @storeNoPoojasTitle.
  ///
  /// In en, this message translates to:
  /// **'No poojas booked'**
  String get storeNoPoojasTitle;

  /// No description provided for @storeNoPoojasBody.
  ///
  /// In en, this message translates to:
  /// **'Book a pooja at a temple in your name — you\'ll get the video once it\'s done.'**
  String get storeNoPoojasBody;

  /// No description provided for @storeBrowsePoojas.
  ///
  /// In en, this message translates to:
  /// **'Browse poojas'**
  String get storeBrowsePoojas;

  /// No description provided for @storeDateToBeAnnounced.
  ///
  /// In en, this message translates to:
  /// **'Date to be announced'**
  String get storeDateToBeAnnounced;

  /// No description provided for @storeVideoReady.
  ///
  /// In en, this message translates to:
  /// **'Video ready'**
  String get storeVideoReady;

  /// No description provided for @storeWatchPooja.
  ///
  /// In en, this message translates to:
  /// **'Watch pooja'**
  String get storeWatchPooja;

  /// No description provided for @storeOrderPendingPayment.
  ///
  /// In en, this message translates to:
  /// **'Payment pending'**
  String get storeOrderPendingPayment;

  /// No description provided for @storeOrderPaid.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get storeOrderPaid;

  /// No description provided for @storeOrderCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get storeOrderCompleted;

  /// No description provided for @storeOrderCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get storeOrderCancelled;

  /// No description provided for @storeOrderExpired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get storeOrderExpired;

  /// No description provided for @storeOrderRefunded.
  ///
  /// In en, this message translates to:
  /// **'Refunded'**
  String get storeOrderRefunded;

  /// No description provided for @storeStagePending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get storeStagePending;

  /// No description provided for @storeStageAwaitingApproval.
  ///
  /// In en, this message translates to:
  /// **'Awaiting seller'**
  String get storeStageAwaitingApproval;

  /// No description provided for @storeStageConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get storeStageConfirmed;

  /// No description provided for @storeStageProcessing.
  ///
  /// In en, this message translates to:
  /// **'Packing'**
  String get storeStageProcessing;

  /// No description provided for @storeStageShipped.
  ///
  /// In en, this message translates to:
  /// **'Shipped'**
  String get storeStageShipped;

  /// No description provided for @storeStageDelivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get storeStageDelivered;

  /// No description provided for @storeStageCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get storeStageCompleted;

  /// No description provided for @storeStageCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get storeStageCancelled;

  /// No description provided for @storeStageReturned.
  ///
  /// In en, this message translates to:
  /// **'Returned'**
  String get storeStageReturned;

  /// No description provided for @storeBookingConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Booked'**
  String get storeBookingConfirmed;

  /// No description provided for @storeBookingPerformed.
  ///
  /// In en, this message translates to:
  /// **'Performed'**
  String get storeBookingPerformed;

  /// No description provided for @storeBookingProofReady.
  ///
  /// In en, this message translates to:
  /// **'Video shared'**
  String get storeBookingProofReady;

  /// No description provided for @storeShipCreated.
  ///
  /// In en, this message translates to:
  /// **'Ready to ship'**
  String get storeShipCreated;

  /// No description provided for @storeShipPickedUp.
  ///
  /// In en, this message translates to:
  /// **'Picked up'**
  String get storeShipPickedUp;

  /// No description provided for @storeShipInTransit.
  ///
  /// In en, this message translates to:
  /// **'In transit'**
  String get storeShipInTransit;

  /// No description provided for @storeShipOutForDelivery.
  ///
  /// In en, this message translates to:
  /// **'Out for delivery'**
  String get storeShipOutForDelivery;

  /// No description provided for @storeShipAttemptFailed.
  ///
  /// In en, this message translates to:
  /// **'Delivery attempt failed'**
  String get storeShipAttemptFailed;

  /// No description provided for @storeShipReturning.
  ///
  /// In en, this message translates to:
  /// **'Returning to seller'**
  String get storeShipReturning;

  /// No description provided for @storeShipLost.
  ///
  /// In en, this message translates to:
  /// **'Shipment issue — we\'re on it'**
  String get storeShipLost;

  /// No description provided for @storeAwb.
  ///
  /// In en, this message translates to:
  /// **'AWB {awb}'**
  String storeAwb(String awb);

  /// No description provided for @storeTrack.
  ///
  /// In en, this message translates to:
  /// **'Track'**
  String get storeTrack;

  /// No description provided for @storeQty.
  ///
  /// In en, this message translates to:
  /// **'Qty {count}'**
  String storeQty(int count);

  /// No description provided for @storePlacedOn.
  ///
  /// In en, this message translates to:
  /// **'Placed {date}'**
  String storePlacedOn(String date);

  /// No description provided for @storeOrderPlacedTitle.
  ///
  /// In en, this message translates to:
  /// **'Order placed!'**
  String get storeOrderPlacedTitle;

  /// No description provided for @storeOrderPlacedBody.
  ///
  /// In en, this message translates to:
  /// **'We\'ll keep you posted as it\'s packed and shipped.'**
  String get storeOrderPlacedBody;

  /// No description provided for @storeOrderPlacedPooja.
  ///
  /// In en, this message translates to:
  /// **'Your pooja is booked. You\'ll get the video once it\'s performed.'**
  String get storeOrderPlacedPooja;

  /// No description provided for @storeCancelOrder.
  ///
  /// In en, this message translates to:
  /// **'Cancel order'**
  String get storeCancelOrder;

  /// No description provided for @storeCancelThisPart.
  ///
  /// In en, this message translates to:
  /// **'Cancel these items'**
  String get storeCancelThisPart;

  /// No description provided for @storeCancelOrderQ.
  ///
  /// In en, this message translates to:
  /// **'Cancel this order?'**
  String get storeCancelOrderQ;

  /// No description provided for @storeCancelPartQ.
  ///
  /// In en, this message translates to:
  /// **'Cancel items from {seller}?'**
  String storeCancelPartQ(String seller);

  /// No description provided for @storeCancelReasonHint.
  ///
  /// In en, this message translates to:
  /// **'Tell us why (optional)'**
  String get storeCancelReasonHint;

  /// No description provided for @storeCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get storeCancel;

  /// No description provided for @storeKeep.
  ///
  /// In en, this message translates to:
  /// **'Keep'**
  String get storeKeep;

  /// No description provided for @storeCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled. Any refund goes back automatically.'**
  String get storeCancelled;

  /// No description provided for @storeRefunds.
  ///
  /// In en, this message translates to:
  /// **'Refunds'**
  String get storeRefunds;

  /// No description provided for @storeRefunded.
  ///
  /// In en, this message translates to:
  /// **'Refunded'**
  String get storeRefunded;

  /// No description provided for @storeRefundedAmount.
  ///
  /// In en, this message translates to:
  /// **'{amount} refunded'**
  String storeRefundedAmount(String amount);

  /// No description provided for @storeRefundToWallet.
  ///
  /// In en, this message translates to:
  /// **'{amount} to wallet'**
  String storeRefundToWallet(String amount);

  /// No description provided for @storeRefundToSource.
  ///
  /// In en, this message translates to:
  /// **'{amount} to your bank / card'**
  String storeRefundToSource(String amount);

  /// No description provided for @storeInvoices.
  ///
  /// In en, this message translates to:
  /// **'Invoices'**
  String get storeInvoices;

  /// No description provided for @storeTaxInvoice.
  ///
  /// In en, this message translates to:
  /// **'Tax invoice {number}'**
  String storeTaxInvoice(String number);

  /// No description provided for @storeCreditNote.
  ///
  /// In en, this message translates to:
  /// **'Credit note {number}'**
  String storeCreditNote(String number);

  /// No description provided for @storeDownload.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get storeDownload;

  /// No description provided for @storeDownloadFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t open the file. Try again.'**
  String get storeDownloadFailed;

  /// No description provided for @storeNoProducts.
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet'**
  String get storeNoProducts;

  /// No description provided for @storeReturnItem.
  ///
  /// In en, this message translates to:
  /// **'Return item'**
  String get storeReturnItem;

  /// No description provided for @storeReturnUntil.
  ///
  /// In en, this message translates to:
  /// **'Return by {date}'**
  String storeReturnUntil(String date);

  /// No description provided for @storeReturnWhy.
  ///
  /// In en, this message translates to:
  /// **'Why are you returning it?'**
  String get storeReturnWhy;

  /// No description provided for @storeReturnDetails.
  ///
  /// In en, this message translates to:
  /// **'Details (helps us resolve it faster)'**
  String get storeReturnDetails;

  /// No description provided for @storeReturnNote.
  ///
  /// In en, this message translates to:
  /// **'Keep the item and its certificate in original packaging. Pickup is arranged once the seller approves.'**
  String get storeReturnNote;

  /// No description provided for @storeReturnSubmit.
  ///
  /// In en, this message translates to:
  /// **'Request return'**
  String get storeReturnSubmit;

  /// No description provided for @storeReturnPickReason.
  ///
  /// In en, this message translates to:
  /// **'Pick a reason'**
  String get storeReturnPickReason;

  /// No description provided for @storeReturnRequested.
  ///
  /// In en, this message translates to:
  /// **'Return requested. We\'ll update you soon.'**
  String get storeReturnRequested;

  /// No description provided for @storeReasonDamaged.
  ///
  /// In en, this message translates to:
  /// **'Arrived damaged'**
  String get storeReasonDamaged;

  /// No description provided for @storeReasonWrongItem.
  ///
  /// In en, this message translates to:
  /// **'Wrong item'**
  String get storeReasonWrongItem;

  /// No description provided for @storeReasonNotAsDescribed.
  ///
  /// In en, this message translates to:
  /// **'Not as described'**
  String get storeReasonNotAsDescribed;

  /// No description provided for @storeReasonAuthenticity.
  ///
  /// In en, this message translates to:
  /// **'Doubt about authenticity'**
  String get storeReasonAuthenticity;

  /// No description provided for @storeReasonSize.
  ///
  /// In en, this message translates to:
  /// **'Size doesn\'t fit'**
  String get storeReasonSize;

  /// No description provided for @storeReasonChangedMind.
  ///
  /// In en, this message translates to:
  /// **'Changed my mind'**
  String get storeReasonChangedMind;

  /// No description provided for @storeReasonOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get storeReasonOther;

  /// No description provided for @storeProfileOrders.
  ///
  /// In en, this message translates to:
  /// **'Store orders'**
  String get storeProfileOrders;

  /// No description provided for @storeProfileOrdersSub.
  ///
  /// In en, this message translates to:
  /// **'Products, poojas and downloads'**
  String get storeProfileOrdersSub;

  /// No description provided for @storeProfileAdviceSub.
  ///
  /// In en, this message translates to:
  /// **'What astrologers said about products'**
  String get storeProfileAdviceSub;

  /// No description provided for @storeProfileAddressesSub.
  ///
  /// In en, this message translates to:
  /// **'Delivery addresses'**
  String get storeProfileAddressesSub;

  /// No description provided for @storeHomeRailTitle.
  ///
  /// In en, this message translates to:
  /// **'Remedies store'**
  String get storeHomeRailTitle;

  /// No description provided for @storeHomeRailSub.
  ///
  /// In en, this message translates to:
  /// **'Certified rudraksha, gemstones and temple poojas'**
  String get storeHomeRailSub;

  /// No description provided for @storeSeeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get storeSeeAll;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'bn',
    'en',
    'gu',
    'hi',
    'kn',
    'mr',
    'ta',
    'te',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'bn':
      return AppLocalizationsBn();
    case 'en':
      return AppLocalizationsEn();
    case 'gu':
      return AppLocalizationsGu();
    case 'hi':
      return AppLocalizationsHi();
    case 'kn':
      return AppLocalizationsKn();
    case 'mr':
      return AppLocalizationsMr();
    case 'ta':
      return AppLocalizationsTa();
    case 'te':
      return AppLocalizationsTe();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
