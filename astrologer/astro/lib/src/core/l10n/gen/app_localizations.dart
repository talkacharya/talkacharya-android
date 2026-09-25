import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';

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
    Locale('en'),
    Locale('hi'),
  ];

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navRequests.
  ///
  /// In en, this message translates to:
  /// **'Requests'**
  String get navRequests;

  /// No description provided for @navEarnings.
  ///
  /// In en, this message translates to:
  /// **'Earnings'**
  String get navEarnings;

  /// No description provided for @navChats.
  ///
  /// In en, this message translates to:
  /// **'Chats'**
  String get navChats;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @commonOffline.
  ///
  /// In en, this message translates to:
  /// **'You are offline'**
  String get commonOffline;

  /// No description provided for @commonRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get commonRetry;

  /// No description provided for @commonSeeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get commonSeeAll;

  /// No description provided for @commonNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get commonNotifications;

  /// No description provided for @dashGreeting.
  ///
  /// In en, this message translates to:
  /// **'Namaste,'**
  String get dashGreeting;

  /// No description provided for @presenceOnline.
  ///
  /// In en, this message translates to:
  /// **'You\'re online'**
  String get presenceOnline;

  /// No description provided for @presenceBusy.
  ///
  /// In en, this message translates to:
  /// **'You\'re in a session'**
  String get presenceBusy;

  /// No description provided for @presenceAway.
  ///
  /// In en, this message translates to:
  /// **'You\'re away'**
  String get presenceAway;

  /// No description provided for @presenceOffline.
  ///
  /// In en, this message translates to:
  /// **'You\'re offline'**
  String get presenceOffline;

  /// No description provided for @presenceOnlineHint.
  ///
  /// In en, this message translates to:
  /// **'Customers can reach you now'**
  String get presenceOnlineHint;

  /// No description provided for @presenceOfflineHint.
  ///
  /// In en, this message translates to:
  /// **'Go online to start receiving requests'**
  String get presenceOfflineHint;

  /// No description provided for @presenceFollowersHint.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 follower is notified when you go online} other{{count} followers are notified when you go online}}'**
  String presenceFollowersHint(int count);

  /// No description provided for @presenceGoOnline.
  ///
  /// In en, this message translates to:
  /// **'Go online'**
  String get presenceGoOnline;

  /// No description provided for @presenceGoOffline.
  ///
  /// In en, this message translates to:
  /// **'Go offline'**
  String get presenceGoOffline;

  /// No description provided for @dashRequestsWaiting.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 request waiting} other{{count} requests waiting}}'**
  String dashRequestsWaiting(int count);

  /// No description provided for @dashRequestsHint.
  ///
  /// In en, this message translates to:
  /// **'Respond quickly — requests expire'**
  String get dashRequestsHint;

  /// No description provided for @dashReview.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get dashReview;

  /// No description provided for @channelChat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get channelChat;

  /// No description provided for @channelCall.
  ///
  /// In en, this message translates to:
  /// **'Voice call'**
  String get channelCall;

  /// No description provided for @channelVideo.
  ///
  /// In en, this message translates to:
  /// **'Video call'**
  String get channelVideo;

  /// No description provided for @dashActiveTitle.
  ///
  /// In en, this message translates to:
  /// **'Ongoing sessions'**
  String get dashActiveTitle;

  /// No description provided for @dashResume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get dashResume;

  /// No description provided for @dashEarningsTitle.
  ///
  /// In en, this message translates to:
  /// **'Net earnings'**
  String get dashEarningsTitle;

  /// No description provided for @dashLastDays.
  ///
  /// In en, this message translates to:
  /// **'Last {days} days'**
  String dashLastDays(int days);

  /// No description provided for @dashPeriodChip.
  ///
  /// In en, this message translates to:
  /// **'{days}D'**
  String dashPeriodChip(int days);

  /// No description provided for @dashGross.
  ///
  /// In en, this message translates to:
  /// **'Gross {amount}'**
  String dashGross(String amount);

  /// No description provided for @dashFee.
  ///
  /// In en, this message translates to:
  /// **'Platform fee {amount}'**
  String dashFee(String amount);

  /// No description provided for @dashAvailable.
  ///
  /// In en, this message translates to:
  /// **'Available to pay out'**
  String get dashAvailable;

  /// No description provided for @dashPending.
  ///
  /// In en, this message translates to:
  /// **'{amount} clearing'**
  String dashPending(String amount);

  /// No description provided for @dashNoTrend.
  ///
  /// In en, this message translates to:
  /// **'Your earnings chart appears after your first sessions'**
  String get dashNoTrend;

  /// No description provided for @dashPerformance.
  ///
  /// In en, this message translates to:
  /// **'Performance'**
  String get dashPerformance;

  /// No description provided for @dashStatSessions.
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get dashStatSessions;

  /// No description provided for @dashStatSessionsSub.
  ///
  /// In en, this message translates to:
  /// **'{count} requested'**
  String dashStatSessionsSub(int count);

  /// No description provided for @dashStatMinutes.
  ///
  /// In en, this message translates to:
  /// **'Minutes'**
  String get dashStatMinutes;

  /// No description provided for @dashStatMinutesSub.
  ///
  /// In en, this message translates to:
  /// **'Billed talk time'**
  String get dashStatMinutesSub;

  /// No description provided for @dashStatAcceptance.
  ///
  /// In en, this message translates to:
  /// **'Acceptance'**
  String get dashStatAcceptance;

  /// No description provided for @dashStatAcceptanceSub.
  ///
  /// In en, this message translates to:
  /// **'Requests answered'**
  String get dashStatAcceptanceSub;

  /// No description provided for @dashStatRating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get dashStatRating;

  /// No description provided for @dashStatRatingSub.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 review} other{{count} reviews}}'**
  String dashStatRatingSub(int count);

  /// No description provided for @dashStatRepeat.
  ///
  /// In en, this message translates to:
  /// **'Repeat clients'**
  String get dashStatRepeat;

  /// No description provided for @dashStatRepeatSub.
  ///
  /// In en, this message translates to:
  /// **'Came back for more'**
  String get dashStatRepeatSub;

  /// No description provided for @dashStatFollowers.
  ///
  /// In en, this message translates to:
  /// **'Followers'**
  String get dashStatFollowers;

  /// No description provided for @dashStatFollowersSub.
  ///
  /// In en, this message translates to:
  /// **'Notified when you\'re live'**
  String get dashStatFollowersSub;

  /// No description provided for @dashQuickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick actions'**
  String get dashQuickActions;

  /// No description provided for @dashActionGoLive.
  ///
  /// In en, this message translates to:
  /// **'Go live'**
  String get dashActionGoLive;

  /// No description provided for @dashActionPredictions.
  ///
  /// In en, this message translates to:
  /// **'Predictions'**
  String get dashActionPredictions;

  /// No description provided for @dashActionRates.
  ///
  /// In en, this message translates to:
  /// **'My rates'**
  String get dashActionRates;

  /// No description provided for @dashActionHours.
  ///
  /// In en, this message translates to:
  /// **'Working hours'**
  String get dashActionHours;

  /// No description provided for @dashActionReviews.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get dashActionReviews;

  /// No description provided for @dashActionPayouts.
  ///
  /// In en, this message translates to:
  /// **'Payouts'**
  String get dashActionPayouts;

  /// No description provided for @dashProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile strength'**
  String get dashProfileTitle;

  /// No description provided for @dashProfileHint.
  ///
  /// In en, this message translates to:
  /// **'Complete profiles get more consultations'**
  String get dashProfileHint;

  /// No description provided for @dashTipHeadline.
  ///
  /// In en, this message translates to:
  /// **'Add a headline'**
  String get dashTipHeadline;

  /// No description provided for @dashTipBio.
  ///
  /// In en, this message translates to:
  /// **'Write a detailed bio'**
  String get dashTipBio;

  /// No description provided for @dashTipBanner.
  ///
  /// In en, this message translates to:
  /// **'Add a cover image'**
  String get dashTipBanner;

  /// No description provided for @dashTipRates.
  ///
  /// In en, this message translates to:
  /// **'Set your per-minute rates'**
  String get dashTipRates;

  /// No description provided for @dashTipLanguages.
  ///
  /// In en, this message translates to:
  /// **'Add the languages you speak'**
  String get dashTipLanguages;

  /// No description provided for @dashTipSkills.
  ///
  /// In en, this message translates to:
  /// **'Add at least 3 skills'**
  String get dashTipSkills;

  /// No description provided for @dashLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load this section'**
  String get dashLoadFailed;

  /// No description provided for @dashPerMin.
  ///
  /// In en, this message translates to:
  /// **'{amount}/min'**
  String dashPerMin(String amount);

  /// No description provided for @requestsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Respond before a request expires'**
  String get requestsSubtitle;

  /// No description provided for @requestsTabIncoming.
  ///
  /// In en, this message translates to:
  /// **'Incoming'**
  String get requestsTabIncoming;

  /// No description provided for @requestsTabActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get requestsTabActive;

  /// No description provided for @requestsTabHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get requestsTabHistory;

  /// No description provided for @requestsAccept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get requestsAccept;

  /// No description provided for @requestsDecline.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get requestsDecline;

  /// No description provided for @requestsExpiresIn.
  ///
  /// In en, this message translates to:
  /// **'Expires in {seconds}s'**
  String requestsExpiresIn(int seconds);

  /// No description provided for @requestsExpired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get requestsExpired;

  /// No description provided for @requestsEmptyOnlineTitle.
  ///
  /// In en, this message translates to:
  /// **'Waiting for requests'**
  String get requestsEmptyOnlineTitle;

  /// No description provided for @requestsEmptyOnlineBody.
  ///
  /// In en, this message translates to:
  /// **'You\'re online. New requests will appear here and pop up on your screen.'**
  String get requestsEmptyOnlineBody;

  /// No description provided for @requestsActiveEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No live sessions'**
  String get requestsActiveEmptyTitle;

  /// No description provided for @requestsActiveEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Accepted requests stay here until the session ends.'**
  String get requestsActiveEmptyBody;

  /// No description provided for @requestsHistoryEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No completed sessions yet'**
  String get requestsHistoryEmptyTitle;

  /// No description provided for @requestsHistoryEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Finished consultations and what you earned will show up here.'**
  String get requestsHistoryEmptyBody;

  /// No description provided for @requestsEarned.
  ///
  /// In en, this message translates to:
  /// **'Earned {amount}'**
  String requestsEarned(String amount);

  /// No description provided for @requestsMinutes.
  ///
  /// In en, this message translates to:
  /// **'{count} min'**
  String requestsMinutes(int count);

  /// No description provided for @requestsLiveNow.
  ///
  /// In en, this message translates to:
  /// **'Live now'**
  String get requestsLiveNow;

  /// No description provided for @requestsDeclineTitle.
  ///
  /// In en, this message translates to:
  /// **'Why are you declining?'**
  String get requestsDeclineTitle;

  /// No description provided for @requestsDeclineBusy.
  ///
  /// In en, this message translates to:
  /// **'Busy right now'**
  String get requestsDeclineBusy;

  /// No description provided for @requestsDeclineUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Not available'**
  String get requestsDeclineUnavailable;

  /// No description provided for @requestsDeclineExpertise.
  ///
  /// In en, this message translates to:
  /// **'Outside my expertise'**
  String get requestsDeclineExpertise;

  /// No description provided for @requestsActionFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t complete that. Please try again.'**
  String get requestsActionFailed;

  /// No description provided for @requestsNewTitle.
  ///
  /// In en, this message translates to:
  /// **'New {channel} request'**
  String requestsNewTitle(String channel);

  /// No description provided for @requestsCustomerFallback.
  ///
  /// In en, this message translates to:
  /// **'A customer'**
  String get requestsCustomerFallback;

  /// No description provided for @requestsLoadError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load your requests'**
  String get requestsLoadError;

  /// No description provided for @timeJustNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get timeJustNow;

  /// No description provided for @timeMinutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{n}m ago'**
  String timeMinutesAgo(int n);

  /// No description provided for @timeHoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{n}h ago'**
  String timeHoursAgo(int n);

  /// No description provided for @timeToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get timeToday;

  /// No description provided for @timeYesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get timeYesterday;

  /// No description provided for @statusRequested.
  ///
  /// In en, this message translates to:
  /// **'Waiting'**
  String get statusRequested;

  /// No description provided for @statusAccepted.
  ///
  /// In en, this message translates to:
  /// **'Connecting'**
  String get statusAccepted;

  /// No description provided for @statusActive.
  ///
  /// In en, this message translates to:
  /// **'Live'**
  String get statusActive;

  /// No description provided for @statusEnded.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get statusEnded;

  /// No description provided for @statusRejected.
  ///
  /// In en, this message translates to:
  /// **'Declined'**
  String get statusRejected;

  /// No description provided for @statusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get statusCancelled;

  /// No description provided for @statusExpired.
  ///
  /// In en, this message translates to:
  /// **'Missed'**
  String get statusExpired;

  /// No description provided for @statusNoShow.
  ///
  /// In en, this message translates to:
  /// **'No-show'**
  String get statusNoShow;

  /// No description provided for @statusFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get statusFailed;

  /// No description provided for @detailTitle.
  ///
  /// In en, this message translates to:
  /// **'Consultation'**
  String get detailTitle;

  /// No description provided for @detailLoadError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load this consultation.'**
  String get detailLoadError;

  /// No description provided for @detailQuestion.
  ///
  /// In en, this message translates to:
  /// **'Their question'**
  String get detailQuestion;

  /// No description provided for @detailSession.
  ///
  /// In en, this message translates to:
  /// **'Session'**
  String get detailSession;

  /// No description provided for @detailRequestedAt.
  ///
  /// In en, this message translates to:
  /// **'Requested'**
  String get detailRequestedAt;

  /// No description provided for @detailDuration.
  ///
  /// In en, this message translates to:
  /// **'Billed time'**
  String get detailDuration;

  /// No description provided for @detailRate.
  ///
  /// In en, this message translates to:
  /// **'Your rate'**
  String get detailRate;

  /// No description provided for @detailCustomerPaid.
  ///
  /// In en, this message translates to:
  /// **'Customer paid'**
  String get detailCustomerPaid;

  /// No description provided for @detailYouEarned.
  ///
  /// In en, this message translates to:
  /// **'You earned'**
  String get detailYouEarned;

  /// No description provided for @detailRating.
  ///
  /// In en, this message translates to:
  /// **'Customer rating'**
  String get detailRating;

  /// No description provided for @detailKundali.
  ///
  /// In en, this message translates to:
  /// **'Customer\'s kundali'**
  String get detailKundali;

  /// No description provided for @detailOpenChat.
  ///
  /// In en, this message translates to:
  /// **'Open conversation'**
  String get detailOpenChat;

  /// No description provided for @chatsSearch.
  ///
  /// In en, this message translates to:
  /// **'Search by name'**
  String get chatsSearch;

  /// No description provided for @chatsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No unread messages} =1{1 unread message} other{{count} unread messages}}'**
  String chatsSubtitle(int count);

  /// No description provided for @chatsRecent.
  ///
  /// In en, this message translates to:
  /// **'Recent'**
  String get chatsRecent;

  /// No description provided for @chatsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No conversations yet'**
  String get chatsEmptyTitle;

  /// No description provided for @chatsEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Chats with your customers appear here once you accept a request.'**
  String get chatsEmptyBody;

  /// No description provided for @chatsNoMatch.
  ///
  /// In en, this message translates to:
  /// **'No chats match “{query}”'**
  String chatsNoMatch(String query);

  /// No description provided for @chatsLoadError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load your chats'**
  String get chatsLoadError;

  /// No description provided for @earnClearing.
  ///
  /// In en, this message translates to:
  /// **'Clearing'**
  String get earnClearing;

  /// No description provided for @earnLifetime.
  ///
  /// In en, this message translates to:
  /// **'Lifetime'**
  String get earnLifetime;

  /// No description provided for @earnCycle.
  ///
  /// In en, this message translates to:
  /// **'Paid every {days} days · {fee}% platform fee'**
  String earnCycle(int days, String fee);

  /// No description provided for @earnTabLedger.
  ///
  /// In en, this message translates to:
  /// **'Ledger'**
  String get earnTabLedger;

  /// No description provided for @earnTabPayouts.
  ///
  /// In en, this message translates to:
  /// **'Payouts'**
  String get earnTabPayouts;

  /// No description provided for @earnTabDocuments.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get earnTabDocuments;

  /// No description provided for @earnKindAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get earnKindAll;

  /// No description provided for @earnKindConsultation.
  ///
  /// In en, this message translates to:
  /// **'Consultations'**
  String get earnKindConsultation;

  /// No description provided for @earnKindGift.
  ///
  /// In en, this message translates to:
  /// **'Gifts'**
  String get earnKindGift;

  /// No description provided for @earnKindPrediction.
  ///
  /// In en, this message translates to:
  /// **'Predictions'**
  String get earnKindPrediction;

  /// No description provided for @earnKindStore.
  ///
  /// In en, this message translates to:
  /// **'Store sales'**
  String get earnKindStore;

  /// No description provided for @earnKindAffiliate.
  ///
  /// In en, this message translates to:
  /// **'Referral commission'**
  String get earnKindAffiliate;

  /// No description provided for @earnKindBonus.
  ///
  /// In en, this message translates to:
  /// **'Bonus'**
  String get earnKindBonus;

  /// No description provided for @earnKindAdjustment.
  ///
  /// In en, this message translates to:
  /// **'Adjustment'**
  String get earnKindAdjustment;

  /// No description provided for @earnEntryFee.
  ///
  /// In en, this message translates to:
  /// **'{percent}% fee on {amount}'**
  String earnEntryFee(String percent, String amount);

  /// No description provided for @earnEntryClears.
  ///
  /// In en, this message translates to:
  /// **'Clears {date}'**
  String earnEntryClears(String date);

  /// No description provided for @earnEntryReady.
  ///
  /// In en, this message translates to:
  /// **'Ready for payout'**
  String get earnEntryReady;

  /// No description provided for @earnEntryPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid out'**
  String get earnEntryPaid;

  /// No description provided for @earnLedgerEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No earnings yet'**
  String get earnLedgerEmptyTitle;

  /// No description provided for @earnLedgerEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Every consultation, gift and prediction you complete is recorded here.'**
  String get earnLedgerEmptyBody;

  /// No description provided for @earnLedgerFilteredEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing in this category yet'**
  String get earnLedgerFilteredEmpty;

  /// No description provided for @earnPayoutsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No payouts yet'**
  String get earnPayoutsEmptyTitle;

  /// No description provided for @earnPayoutsEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Cleared earnings are sent to your bank account every payout cycle.'**
  String get earnPayoutsEmptyBody;

  /// No description provided for @earnDocsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No documents yet'**
  String get earnDocsEmptyTitle;

  /// No description provided for @earnDocsEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Earnings statements and TDS certificates appear here after your payouts.'**
  String get earnDocsEmptyBody;

  /// No description provided for @earnLoadError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load this list'**
  String get earnLoadError;

  /// No description provided for @payoutStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Scheduled'**
  String get payoutStatusPending;

  /// No description provided for @payoutStatusProcessing.
  ///
  /// In en, this message translates to:
  /// **'Processing'**
  String get payoutStatusProcessing;

  /// No description provided for @payoutStatusPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get payoutStatusPaid;

  /// No description provided for @payoutStatusFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get payoutStatusFailed;

  /// No description provided for @payoutStatusOnHold.
  ///
  /// In en, this message translates to:
  /// **'On hold'**
  String get payoutStatusOnHold;

  /// No description provided for @payoutStatusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get payoutStatusCancelled;

  /// No description provided for @payoutEntries.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 earning} other{{count} earnings}}'**
  String payoutEntries(int count);

  /// No description provided for @payoutPaidOn.
  ///
  /// In en, this message translates to:
  /// **'Paid {date}'**
  String payoutPaidOn(String date);

  /// No description provided for @docKindCustomerInvoice.
  ///
  /// In en, this message translates to:
  /// **'Customer invoice'**
  String get docKindCustomerInvoice;

  /// No description provided for @docKindAstrologerInvoice.
  ///
  /// In en, this message translates to:
  /// **'Earnings statement'**
  String get docKindAstrologerInvoice;

  /// No description provided for @docKindTds.
  ///
  /// In en, this message translates to:
  /// **'TDS certificate'**
  String get docKindTds;

  /// No description provided for @docKindGst.
  ///
  /// In en, this message translates to:
  /// **'GST invoice'**
  String get docKindGst;

  /// No description provided for @docKindCreditNote.
  ///
  /// In en, this message translates to:
  /// **'Credit note'**
  String get docKindCreditNote;

  /// No description provided for @docKindStore.
  ///
  /// In en, this message translates to:
  /// **'Store tax invoice'**
  String get docKindStore;

  /// No description provided for @docTax.
  ///
  /// In en, this message translates to:
  /// **'Tax {amount}'**
  String docTax(String amount);

  /// No description provided for @docDownloadFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t download this document'**
  String get docDownloadFailed;

  /// No description provided for @payoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Payout'**
  String get payoutTitle;

  /// No description provided for @payoutLoadError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load this payout.'**
  String get payoutLoadError;

  /// No description provided for @payoutBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Breakdown'**
  String get payoutBreakdown;

  /// No description provided for @payoutGross.
  ///
  /// In en, this message translates to:
  /// **'Your earnings'**
  String get payoutGross;

  /// No description provided for @payoutTds.
  ///
  /// In en, this message translates to:
  /// **'TDS deducted'**
  String get payoutTds;

  /// No description provided for @payoutOther.
  ///
  /// In en, this message translates to:
  /// **'Other deductions'**
  String get payoutOther;

  /// No description provided for @payoutNet.
  ///
  /// In en, this message translates to:
  /// **'Sent to your bank'**
  String get payoutNet;

  /// No description provided for @payoutTimeline.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get payoutTimeline;

  /// No description provided for @payoutStepScheduled.
  ///
  /// In en, this message translates to:
  /// **'Payout scheduled'**
  String get payoutStepScheduled;

  /// No description provided for @payoutStepInitiated.
  ///
  /// In en, this message translates to:
  /// **'Bank transfer started'**
  String get payoutStepInitiated;

  /// No description provided for @payoutStepPaid.
  ///
  /// In en, this message translates to:
  /// **'Credited to your bank'**
  String get payoutStepPaid;

  /// No description provided for @payoutStepFailed.
  ///
  /// In en, this message translates to:
  /// **'Transfer failed'**
  String get payoutStepFailed;

  /// No description provided for @payoutStepOnHold.
  ///
  /// In en, this message translates to:
  /// **'On hold — our team is reviewing it'**
  String get payoutStepOnHold;

  /// No description provided for @payoutStepCancelled.
  ///
  /// In en, this message translates to:
  /// **'Payout cancelled'**
  String get payoutStepCancelled;

  /// No description provided for @payoutUtr.
  ///
  /// In en, this message translates to:
  /// **'Bank reference (UTR)'**
  String get payoutUtr;

  /// No description provided for @payoutCopied.
  ///
  /// In en, this message translates to:
  /// **'Copied'**
  String get payoutCopied;

  /// No description provided for @payoutIncluded.
  ///
  /// In en, this message translates to:
  /// **'Included earnings'**
  String get payoutIncluded;

  /// No description provided for @payoutCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get payoutCopy;

  /// No description provided for @commonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonSave;

  /// No description provided for @commonSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get commonSaved;

  /// No description provided for @commonSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t save. Please try again.'**
  String get commonSaveFailed;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonRequired.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get commonRequired;

  /// No description provided for @commonLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load this page'**
  String get commonLoadFailed;

  /// No description provided for @verifUnverified.
  ///
  /// In en, this message translates to:
  /// **'Not verified'**
  String get verifUnverified;

  /// No description provided for @verifSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Under review'**
  String get verifSubmitted;

  /// No description provided for @verifVerified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get verifVerified;

  /// No description provided for @verifFeatured.
  ///
  /// In en, this message translates to:
  /// **'Featured'**
  String get verifFeatured;

  /// No description provided for @verifUnverifiedHint.
  ///
  /// In en, this message translates to:
  /// **'Submit your documents to earn the verified badge.'**
  String get verifUnverifiedHint;

  /// No description provided for @verifSubmittedHint.
  ///
  /// In en, this message translates to:
  /// **'Our team is reviewing your documents. This usually takes 1–2 days.'**
  String get verifSubmittedHint;

  /// No description provided for @verifVerifiedHint.
  ///
  /// In en, this message translates to:
  /// **'Your identity is verified. Customers see a verified badge on your profile.'**
  String get verifVerifiedHint;

  /// No description provided for @profileStatYears.
  ///
  /// In en, this message translates to:
  /// **'Years'**
  String get profileStatYears;

  /// No description provided for @profileChangePhoto.
  ///
  /// In en, this message translates to:
  /// **'Change photo'**
  String get profileChangePhoto;

  /// No description provided for @profilePhotoUpdated.
  ///
  /// In en, this message translates to:
  /// **'Photo updated'**
  String get profilePhotoUpdated;

  /// No description provided for @profilePhotoFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t update your photo'**
  String get profilePhotoFailed;

  /// No description provided for @profileGroupPractice.
  ///
  /// In en, this message translates to:
  /// **'Your practice'**
  String get profileGroupPractice;

  /// No description provided for @profileGroupGrowth.
  ///
  /// In en, this message translates to:
  /// **'Grow'**
  String get profileGroupGrowth;

  /// No description provided for @profileGroupAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get profileGroupAccount;

  /// No description provided for @profileGroupSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & legal'**
  String get profileGroupSupport;

  /// No description provided for @profileEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get profileEdit;

  /// No description provided for @profileEditSub.
  ///
  /// In en, this message translates to:
  /// **'Cover, bio, expertise and languages'**
  String get profileEditSub;

  /// No description provided for @profileRates.
  ///
  /// In en, this message translates to:
  /// **'Rates'**
  String get profileRates;

  /// No description provided for @profileRatesSub.
  ///
  /// In en, this message translates to:
  /// **'What customers pay per minute'**
  String get profileRatesSub;

  /// No description provided for @profileHours.
  ///
  /// In en, this message translates to:
  /// **'Availability & hours'**
  String get profileHours;

  /// No description provided for @profileHoursSub.
  ///
  /// In en, this message translates to:
  /// **'Consultation types and weekly schedule'**
  String get profileHoursSub;

  /// No description provided for @profileGoLiveSub.
  ///
  /// In en, this message translates to:
  /// **'Broadcast to your followers'**
  String get profileGoLiveSub;

  /// No description provided for @profilePredictionsSub.
  ///
  /// In en, this message translates to:
  /// **'Write the forecasts customers ordered'**
  String get profilePredictionsSub;

  /// No description provided for @profileFeatured.
  ///
  /// In en, this message translates to:
  /// **'Featured slots'**
  String get profileFeatured;

  /// No description provided for @profileFeaturedSub.
  ///
  /// In en, this message translates to:
  /// **'Get promoted in the customer app'**
  String get profileFeaturedSub;

  /// No description provided for @profileKyc.
  ///
  /// In en, this message translates to:
  /// **'KYC & bank'**
  String get profileKyc;

  /// No description provided for @profileKycSub.
  ///
  /// In en, this message translates to:
  /// **'Verification documents and payout account'**
  String get profileKycSub;

  /// No description provided for @profileLanguage.
  ///
  /// In en, this message translates to:
  /// **'App language'**
  String get profileLanguage;

  /// No description provided for @profileHelp.
  ///
  /// In en, this message translates to:
  /// **'Help centre'**
  String get profileHelp;

  /// No description provided for @profileContact.
  ///
  /// In en, this message translates to:
  /// **'Contact support'**
  String get profileContact;

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

  /// No description provided for @profileLogout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get profileLogout;

  /// No description provided for @profileLogoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Log out?'**
  String get profileLogoutTitle;

  /// No description provided for @profileLogoutBody.
  ///
  /// In en, this message translates to:
  /// **'You\'ll need to sign in again with your phone number.'**
  String get profileLogoutBody;

  /// No description provided for @profileVersion.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String profileVersion(String version);

  /// No description provided for @editCover.
  ///
  /// In en, this message translates to:
  /// **'Profile cover'**
  String get editCover;

  /// No description provided for @editCoverHint.
  ///
  /// In en, this message translates to:
  /// **'Shown behind your photo on your public profile. Wide images (about 3:1) work best.'**
  String get editCoverHint;

  /// No description provided for @editCoverChange.
  ///
  /// In en, this message translates to:
  /// **'Change cover'**
  String get editCoverChange;

  /// No description provided for @editCoverRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get editCoverRemove;

  /// No description provided for @editCoverFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t upload the cover. Use a JPG or PNG under 5 MB.'**
  String get editCoverFailed;

  /// No description provided for @editAbout.
  ///
  /// In en, this message translates to:
  /// **'About you'**
  String get editAbout;

  /// No description provided for @editDisplayName.
  ///
  /// In en, this message translates to:
  /// **'Display name'**
  String get editDisplayName;

  /// No description provided for @editHeadline.
  ///
  /// In en, this message translates to:
  /// **'Headline'**
  String get editHeadline;

  /// No description provided for @editHeadlineHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Vedic astrologer · Career & marriage'**
  String get editHeadlineHint;

  /// No description provided for @editBio.
  ///
  /// In en, this message translates to:
  /// **'Bio'**
  String get editBio;

  /// No description provided for @editBioHint.
  ///
  /// In en, this message translates to:
  /// **'Tell customers about your approach and experience'**
  String get editBioHint;

  /// No description provided for @editBioShort.
  ///
  /// In en, this message translates to:
  /// **'{count} more characters for a strong bio'**
  String editBioShort(int count);

  /// No description provided for @editYears.
  ///
  /// In en, this message translates to:
  /// **'Years of experience'**
  String get editYears;

  /// No description provided for @editExpertise.
  ///
  /// In en, this message translates to:
  /// **'Expertise'**
  String get editExpertise;

  /// No description provided for @editExpertiseHint.
  ///
  /// In en, this message translates to:
  /// **'Tap to select. Long-press a selected skill to make it primary.'**
  String get editExpertiseHint;

  /// No description provided for @editPrimary.
  ///
  /// In en, this message translates to:
  /// **'Primary'**
  String get editPrimary;

  /// No description provided for @editLanguages.
  ///
  /// In en, this message translates to:
  /// **'Languages you speak'**
  String get editLanguages;

  /// No description provided for @editDiscardTitle.
  ///
  /// In en, this message translates to:
  /// **'Discard changes?'**
  String get editDiscardTitle;

  /// No description provided for @editDiscard.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get editDiscard;

  /// No description provided for @editKeepEditing.
  ///
  /// In en, this message translates to:
  /// **'Keep editing'**
  String get editKeepEditing;

  /// No description provided for @ratesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'What customers pay per minute. Changes apply to new sessions.'**
  String get ratesSubtitle;

  /// No description provided for @ratesAllowed.
  ///
  /// In en, this message translates to:
  /// **'Allowed {min} – {max}'**
  String ratesAllowed(String min, String max);

  /// No description provided for @ratesYouEarn.
  ///
  /// In en, this message translates to:
  /// **'You earn about {amount}/min after the {fee}% platform fee'**
  String ratesYouEarn(String amount, String fee);

  /// No description provided for @ratesSuggested.
  ///
  /// In en, this message translates to:
  /// **'Suggested {amount}'**
  String ratesSuggested(String amount);

  /// No description provided for @ratesNotOffered.
  ///
  /// In en, this message translates to:
  /// **'Not offered on the platform yet'**
  String get ratesNotOffered;

  /// No description provided for @ratesSaveCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Save 1 change} other{Save {count} changes}}'**
  String ratesSaveCount(int count);

  /// No description provided for @ratesUpdated.
  ///
  /// In en, this message translates to:
  /// **'Rates updated'**
  String get ratesUpdated;

  /// No description provided for @hoursChannels.
  ///
  /// In en, this message translates to:
  /// **'Consultation types'**
  String get hoursChannels;

  /// No description provided for @hoursChannelsHint.
  ///
  /// In en, this message translates to:
  /// **'Customers can only request the types you accept.'**
  String get hoursChannelsHint;

  /// No description provided for @hoursNeedChannel.
  ///
  /// In en, this message translates to:
  /// **'Keep at least one consultation type on'**
  String get hoursNeedChannel;

  /// No description provided for @hoursConcurrent.
  ///
  /// In en, this message translates to:
  /// **'Chats at the same time'**
  String get hoursConcurrent;

  /// No description provided for @hoursConcurrentHint.
  ///
  /// In en, this message translates to:
  /// **'How many chat sessions you can handle at once'**
  String get hoursConcurrentHint;

  /// No description provided for @hoursSchedule.
  ///
  /// In en, this message translates to:
  /// **'Weekly schedule'**
  String get hoursSchedule;

  /// No description provided for @hoursScheduleHint.
  ///
  /// In en, this message translates to:
  /// **'Shown to customers as your usual hours. You still go online yourself.'**
  String get hoursScheduleHint;

  /// No description provided for @hoursOff.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get hoursOff;

  /// No description provided for @hoursCopyToAll.
  ///
  /// In en, this message translates to:
  /// **'Copy to all days'**
  String get hoursCopyToAll;

  /// No description provided for @hoursInvalid.
  ///
  /// In en, this message translates to:
  /// **'End time must be after start time'**
  String get hoursInvalid;

  /// No description provided for @reviewsBasedOn.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Based on 1 review} other{Based on {count} reviews}}'**
  String reviewsBasedOn(int count);

  /// No description provided for @reviewsFilterUnreplied.
  ///
  /// In en, this message translates to:
  /// **'Needs reply'**
  String get reviewsFilterUnreplied;

  /// No description provided for @reviewsFilterLow.
  ///
  /// In en, this message translates to:
  /// **'3★ and below'**
  String get reviewsFilterLow;

  /// No description provided for @reviewsFilterTop.
  ///
  /// In en, this message translates to:
  /// **'5★'**
  String get reviewsFilterTop;

  /// No description provided for @reviewsReply.
  ///
  /// In en, this message translates to:
  /// **'Reply'**
  String get reviewsReply;

  /// No description provided for @reviewsYourReply.
  ///
  /// In en, this message translates to:
  /// **'Your reply'**
  String get reviewsYourReply;

  /// No description provided for @reviewsReplyHint.
  ///
  /// In en, this message translates to:
  /// **'Thank them or respond to their feedback. Replies are public.'**
  String get reviewsReplyHint;

  /// No description provided for @reviewsPost.
  ///
  /// In en, this message translates to:
  /// **'Post reply'**
  String get reviewsPost;

  /// No description provided for @reviewsReplyFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t post your reply'**
  String get reviewsReplyFailed;

  /// No description provided for @reviewsPending.
  ///
  /// In en, this message translates to:
  /// **'Awaiting moderation'**
  String get reviewsPending;

  /// No description provided for @reviewsHidden.
  ///
  /// In en, this message translates to:
  /// **'Hidden'**
  String get reviewsHidden;

  /// No description provided for @reviewsAnonymous.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get reviewsAnonymous;

  /// No description provided for @reviewsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No reviews yet'**
  String get reviewsEmptyTitle;

  /// No description provided for @reviewsEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Customers can rate you after each consultation.'**
  String get reviewsEmptyBody;

  /// No description provided for @reviewsNoMatch.
  ///
  /// In en, this message translates to:
  /// **'No reviews match this filter'**
  String get reviewsNoMatch;

  /// No description provided for @reviewsHelpful.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 person found this helpful} other{{count} people found this helpful}}'**
  String reviewsHelpful(int count);

  /// No description provided for @kycStatus.
  ///
  /// In en, this message translates to:
  /// **'Verification'**
  String get kycStatus;

  /// No description provided for @kycPan.
  ///
  /// In en, this message translates to:
  /// **'PAN card'**
  String get kycPan;

  /// No description provided for @kycPanHint.
  ///
  /// In en, this message translates to:
  /// **'Re-submit if your PAN changed or was flagged.'**
  String get kycPanHint;

  /// No description provided for @kycPanLabel.
  ///
  /// In en, this message translates to:
  /// **'PAN number'**
  String get kycPanLabel;

  /// No description provided for @kycPanInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid PAN, e.g. ABCDE1234F'**
  String get kycPanInvalid;

  /// No description provided for @kycSubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get kycSubmit;

  /// No description provided for @kycSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Submitted for verification'**
  String get kycSubmitted;

  /// No description provided for @kycPhoto.
  ///
  /// In en, this message translates to:
  /// **'Identity photo'**
  String get kycPhoto;

  /// No description provided for @kycPhotoHint.
  ///
  /// In en, this message translates to:
  /// **'A clear, recent photo of your face.'**
  String get kycPhotoHint;

  /// No description provided for @kycUploadPhoto.
  ///
  /// In en, this message translates to:
  /// **'Upload photo'**
  String get kycUploadPhoto;

  /// No description provided for @kycCertificate.
  ///
  /// In en, this message translates to:
  /// **'Certificates'**
  String get kycCertificate;

  /// No description provided for @kycCertificateHint.
  ///
  /// In en, this message translates to:
  /// **'Astrology qualifications build trust and help you get featured.'**
  String get kycCertificateHint;

  /// No description provided for @kycUploadCertificate.
  ///
  /// In en, this message translates to:
  /// **'Upload certificate'**
  String get kycUploadCertificate;

  /// No description provided for @kycBank.
  ///
  /// In en, this message translates to:
  /// **'Payout bank account'**
  String get kycBank;

  /// No description provided for @kycBankHint.
  ///
  /// In en, this message translates to:
  /// **'Your earnings are paid to this account. Changes are verified before your next payout.'**
  String get kycBankHint;

  /// No description provided for @kycHolder.
  ///
  /// In en, this message translates to:
  /// **'Account holder name'**
  String get kycHolder;

  /// No description provided for @kycAccount.
  ///
  /// In en, this message translates to:
  /// **'Account number'**
  String get kycAccount;

  /// No description provided for @kycAccountConfirm.
  ///
  /// In en, this message translates to:
  /// **'Re-enter account number'**
  String get kycAccountConfirm;

  /// No description provided for @kycAccountMismatch.
  ///
  /// In en, this message translates to:
  /// **'Account numbers don\'t match'**
  String get kycAccountMismatch;

  /// No description provided for @kycIfsc.
  ///
  /// In en, this message translates to:
  /// **'IFSC code'**
  String get kycIfsc;

  /// No description provided for @kycIfscInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid IFSC, e.g. HDFC0001234'**
  String get kycIfscInvalid;

  /// No description provided for @kycBankName.
  ///
  /// In en, this message translates to:
  /// **'Bank name (optional)'**
  String get kycBankName;

  /// No description provided for @kycBankSave.
  ///
  /// In en, this message translates to:
  /// **'Update bank account'**
  String get kycBankSave;

  /// No description provided for @kycBankSaved.
  ///
  /// In en, this message translates to:
  /// **'Bank account updated'**
  String get kycBankSaved;

  /// No description provided for @featIntro.
  ///
  /// In en, this message translates to:
  /// **'Appear in prime spots of the customer app. Our team reviews each request; the fee is deducted from your earnings once it\'s approved.'**
  String get featIntro;

  /// No description provided for @featHomeHero.
  ///
  /// In en, this message translates to:
  /// **'Home spotlight'**
  String get featHomeHero;

  /// No description provided for @featHomeHeroSub.
  ///
  /// In en, this message translates to:
  /// **'Top of the customer home screen'**
  String get featHomeHeroSub;

  /// No description provided for @featCategoryTop.
  ///
  /// In en, this message translates to:
  /// **'Top of a category'**
  String get featCategoryTop;

  /// No description provided for @featCategoryTopSub.
  ///
  /// In en, this message translates to:
  /// **'First in one expertise\'s list'**
  String get featCategoryTopSub;

  /// No description provided for @featSearchBoost.
  ///
  /// In en, this message translates to:
  /// **'Search boost'**
  String get featSearchBoost;

  /// No description provided for @featSearchBoostSub.
  ///
  /// In en, this message translates to:
  /// **'Higher in search and astrologer lists'**
  String get featSearchBoostSub;

  /// No description provided for @featPerDay.
  ///
  /// In en, this message translates to:
  /// **'{amount}/day'**
  String featPerDay(String amount);

  /// No description provided for @featRequest.
  ///
  /// In en, this message translates to:
  /// **'Request a slot'**
  String get featRequest;

  /// No description provided for @featDates.
  ///
  /// In en, this message translates to:
  /// **'Dates'**
  String get featDates;

  /// No description provided for @featPickDates.
  ///
  /// In en, this message translates to:
  /// **'Choose dates'**
  String get featPickDates;

  /// No description provided for @featMaxDays.
  ///
  /// In en, this message translates to:
  /// **'Up to {days} days per slot'**
  String featMaxDays(int days);

  /// No description provided for @featCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get featCategory;

  /// No description provided for @featTotal.
  ///
  /// In en, this message translates to:
  /// **'{amount} for {days, plural, =1{1 day} other{{days} days}}'**
  String featTotal(String amount, int days);

  /// No description provided for @featSend.
  ///
  /// In en, this message translates to:
  /// **'Send request'**
  String get featSend;

  /// No description provided for @featSent.
  ///
  /// In en, this message translates to:
  /// **'Request sent. We\'ll notify you once it\'s reviewed.'**
  String get featSent;

  /// No description provided for @featMine.
  ///
  /// In en, this message translates to:
  /// **'Your slots'**
  String get featMine;

  /// No description provided for @featEmpty.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t requested any slots yet'**
  String get featEmpty;

  /// No description provided for @featStatusRequested.
  ///
  /// In en, this message translates to:
  /// **'Under review'**
  String get featStatusRequested;

  /// No description provided for @featStatusScheduled.
  ///
  /// In en, this message translates to:
  /// **'Scheduled'**
  String get featStatusScheduled;

  /// No description provided for @featStatusExpired.
  ///
  /// In en, this message translates to:
  /// **'Ended'**
  String get featStatusExpired;

  /// No description provided for @notifMarkAll.
  ///
  /// In en, this message translates to:
  /// **'Mark all read'**
  String get notifMarkAll;

  /// No description provided for @notifMarkRead.
  ///
  /// In en, this message translates to:
  /// **'Mark read'**
  String get notifMarkRead;

  /// No description provided for @notifFilterUnread.
  ///
  /// In en, this message translates to:
  /// **'Unread'**
  String get notifFilterUnread;

  /// No description provided for @notifEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'You\'re all caught up'**
  String get notifEmptyTitle;

  /// No description provided for @notifEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Requests, payouts and reviews will show up here.'**
  String get notifEmptyBody;

  /// No description provided for @notifUnreadEmpty.
  ///
  /// In en, this message translates to:
  /// **'No unread notifications'**
  String get notifUnreadEmpty;

  /// No description provided for @notifLoadError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load notifications'**
  String get notifLoadError;

  /// No description provided for @obTitle.
  ///
  /// In en, this message translates to:
  /// **'Become a TalkAcharya astrologer'**
  String get obTitle;

  /// No description provided for @obWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome, {name}'**
  String obWelcome(String name);

  /// No description provided for @obWelcomeBody.
  ///
  /// In en, this message translates to:
  /// **'Complete these steps and submit your profile. Most astrologers finish in about 10 minutes.'**
  String get obWelcomeBody;

  /// No description provided for @obStepProfile.
  ///
  /// In en, this message translates to:
  /// **'Your profile'**
  String get obStepProfile;

  /// No description provided for @obStepProfileSub.
  ///
  /// In en, this message translates to:
  /// **'Headline, bio and experience'**
  String get obStepProfileSub;

  /// No description provided for @obStepExpertise.
  ///
  /// In en, this message translates to:
  /// **'Expertise & languages'**
  String get obStepExpertise;

  /// No description provided for @obStepExpertiseSub.
  ///
  /// In en, this message translates to:
  /// **'What you practise and speak'**
  String get obStepExpertiseSub;

  /// No description provided for @obStepIdentity.
  ///
  /// In en, this message translates to:
  /// **'Identity verification'**
  String get obStepIdentity;

  /// No description provided for @obStepIdentitySub.
  ///
  /// In en, this message translates to:
  /// **'PAN and a clear photo'**
  String get obStepIdentitySub;

  /// No description provided for @obStepBank.
  ///
  /// In en, this message translates to:
  /// **'Payout account'**
  String get obStepBank;

  /// No description provided for @obStepBankSub.
  ///
  /// In en, this message translates to:
  /// **'Where we send your earnings'**
  String get obStepBankSub;

  /// No description provided for @obStepReview.
  ///
  /// In en, this message translates to:
  /// **'Review & submit'**
  String get obStepReview;

  /// No description provided for @obStepReviewSub.
  ///
  /// In en, this message translates to:
  /// **'Send your profile to our team'**
  String get obStepReviewSub;

  /// No description provided for @obProgress.
  ///
  /// In en, this message translates to:
  /// **'{done} of {total} done'**
  String obProgress(int done, int total);

  /// No description provided for @obStart.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get obStart;

  /// No description provided for @obContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get obContinue;

  /// No description provided for @obRejectedTitle.
  ///
  /// In en, this message translates to:
  /// **'Your application needs changes'**
  String get obRejectedTitle;

  /// No description provided for @obRejectedHint.
  ///
  /// In en, this message translates to:
  /// **'Update your profile and submit again.'**
  String get obRejectedHint;

  /// No description provided for @obReviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Application under review'**
  String get obReviewTitle;

  /// No description provided for @obReviewBody.
  ///
  /// In en, this message translates to:
  /// **'Our team is verifying your profile and documents. You\'ll get a notification as soon as it\'s approved — usually within 1–2 business days.'**
  String get obReviewBody;

  /// No description provided for @obReviewSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Application submitted'**
  String get obReviewSubmitted;

  /// No description provided for @obReviewChecking.
  ///
  /// In en, this message translates to:
  /// **'Profile & document check'**
  String get obReviewChecking;

  /// No description provided for @obReviewLive.
  ///
  /// In en, this message translates to:
  /// **'Start consulting on TalkAcharya'**
  String get obReviewLive;

  /// No description provided for @obCheckStatus.
  ///
  /// In en, this message translates to:
  /// **'Check status'**
  String get obCheckStatus;

  /// No description provided for @obSuspendedTitle.
  ///
  /// In en, this message translates to:
  /// **'Account suspended'**
  String get obSuspendedTitle;

  /// No description provided for @obSuspendedBody.
  ///
  /// In en, this message translates to:
  /// **'Your astrologer account is suspended. Contact support to understand why and how to reinstate it.'**
  String get obSuspendedBody;

  /// No description provided for @obNotAstroTitle.
  ///
  /// In en, this message translates to:
  /// **'Not an astrologer account'**
  String get obNotAstroTitle;

  /// No description provided for @obNotAstroBody.
  ///
  /// In en, this message translates to:
  /// **'This phone number isn\'t registered as an astrologer. If you think this is a mistake, contact support.'**
  String get obNotAstroBody;

  /// No description provided for @wizTitle.
  ///
  /// In en, this message translates to:
  /// **'Set up your profile'**
  String get wizTitle;

  /// No description provided for @wizStepOf.
  ///
  /// In en, this message translates to:
  /// **'Step {step} of {total}'**
  String wizStepOf(int step, int total);

  /// No description provided for @wizNext.
  ///
  /// In en, this message translates to:
  /// **'Save & continue'**
  String get wizNext;

  /// No description provided for @wizBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get wizBack;

  /// No description provided for @wizProfileIntro.
  ///
  /// In en, this message translates to:
  /// **'This is what customers read before they consult you.'**
  String get wizProfileIntro;

  /// No description provided for @wizBioRequired.
  ///
  /// In en, this message translates to:
  /// **'Tell customers a little about yourself'**
  String get wizBioRequired;

  /// No description provided for @wizExpertiseIntro.
  ///
  /// In en, this message translates to:
  /// **'Pick the areas you consult on and the languages you speak.'**
  String get wizExpertiseIntro;

  /// No description provided for @wizPickSkill.
  ///
  /// In en, this message translates to:
  /// **'Choose at least one expertise'**
  String get wizPickSkill;

  /// No description provided for @wizPickLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose at least one language'**
  String get wizPickLanguage;

  /// No description provided for @wizIdentityIntro.
  ///
  /// In en, this message translates to:
  /// **'We verify every astrologer to keep customers safe. Your documents are never shown publicly.'**
  String get wizIdentityIntro;

  /// No description provided for @wizPanDone.
  ///
  /// In en, this message translates to:
  /// **'PAN submitted'**
  String get wizPanDone;

  /// No description provided for @wizPhotoDone.
  ///
  /// In en, this message translates to:
  /// **'Photo submitted'**
  String get wizPhotoDone;

  /// No description provided for @wizReplace.
  ///
  /// In en, this message translates to:
  /// **'Replace'**
  String get wizReplace;

  /// No description provided for @wizPhotoRequired.
  ///
  /// In en, this message translates to:
  /// **'Upload a photo to continue'**
  String get wizPhotoRequired;

  /// No description provided for @wizBankIntro.
  ///
  /// In en, this message translates to:
  /// **'Your earnings are paid to this account after each payout cycle.'**
  String get wizBankIntro;

  /// No description provided for @wizBankDone.
  ///
  /// In en, this message translates to:
  /// **'Bank account added'**
  String get wizBankDone;

  /// No description provided for @wizBankUpdate.
  ///
  /// In en, this message translates to:
  /// **'Update details'**
  String get wizBankUpdate;

  /// No description provided for @wizReviewIntro.
  ///
  /// In en, this message translates to:
  /// **'Check that everything is complete, then submit. Our team usually reviews within 1–2 business days.'**
  String get wizReviewIntro;

  /// No description provided for @wizSubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit for review'**
  String get wizSubmit;

  /// No description provided for @wizGapBank.
  ///
  /// In en, this message translates to:
  /// **'Bank account'**
  String get wizGapBank;

  /// No description provided for @wizStillMissing.
  ///
  /// In en, this message translates to:
  /// **'Complete the highlighted items first'**
  String get wizStillMissing;

  /// No description provided for @wizFix.
  ///
  /// In en, this message translates to:
  /// **'Fix'**
  String get wizFix;

  /// No description provided for @wizSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Profile submitted!'**
  String get wizSubmitted;

  /// No description provided for @roomWaiting.
  ///
  /// In en, this message translates to:
  /// **'Waiting for {name} to join…'**
  String roomWaiting(String name);

  /// No description provided for @roomEnd.
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get roomEnd;

  /// No description provided for @roomEndTitle.
  ///
  /// In en, this message translates to:
  /// **'End this consultation?'**
  String get roomEndTitle;

  /// No description provided for @roomEndBody.
  ///
  /// In en, this message translates to:
  /// **'The customer stops being billed and the chat closes.'**
  String get roomEndBody;

  /// No description provided for @roomCallEndBody.
  ///
  /// In en, this message translates to:
  /// **'The customer stops being billed when the call ends.'**
  String get roomCallEndBody;

  /// No description provided for @roomEndFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t end the consultation'**
  String get roomEndFailed;

  /// No description provided for @roomLowBalance.
  ///
  /// In en, this message translates to:
  /// **'Customer\'s balance is low — wrap up soon'**
  String get roomLowBalance;

  /// No description provided for @roomRunway.
  ///
  /// In en, this message translates to:
  /// **'≈{minutes} min left'**
  String roomRunway(int minutes);

  /// No description provided for @roomTranslate.
  ///
  /// In en, this message translates to:
  /// **'Auto-translate'**
  String get roomTranslate;

  /// No description provided for @roomComposerHint.
  ///
  /// In en, this message translates to:
  /// **'Type your reply'**
  String get roomComposerHint;

  /// No description provided for @roomLoadError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t open this consultation'**
  String get roomLoadError;

  /// No description provided for @roomEndedTitle.
  ///
  /// In en, this message translates to:
  /// **'Consultation complete'**
  String get roomEndedTitle;

  /// No description provided for @roomEndedBody.
  ///
  /// In en, this message translates to:
  /// **'Thank you for guiding {name}.'**
  String roomEndedBody(String name);

  /// No description provided for @roomNotHeldBody.
  ///
  /// In en, this message translates to:
  /// **'This consultation didn\'t take place, so nothing was billed.'**
  String get roomNotHeldBody;

  /// No description provided for @roomBackToRequests.
  ///
  /// In en, this message translates to:
  /// **'Back to requests'**
  String get roomBackToRequests;

  /// No description provided for @sharedTitle.
  ///
  /// In en, this message translates to:
  /// **'Shared by the customer'**
  String get sharedTitle;

  /// No description provided for @sharedNone.
  ///
  /// In en, this message translates to:
  /// **'No birth details shared'**
  String get sharedNone;

  /// No description provided for @sharedNoneHint.
  ///
  /// In en, this message translates to:
  /// **'Ask the customer to share their birth details to read the chart.'**
  String get sharedNoneHint;

  /// No description provided for @sharedTimeUnknown.
  ///
  /// In en, this message translates to:
  /// **'Birth time not known'**
  String get sharedTimeUnknown;

  /// No description provided for @sharedViewMatch.
  ///
  /// In en, this message translates to:
  /// **'View match report'**
  String get sharedViewMatch;

  /// No description provided for @sharedMatchTitle.
  ///
  /// In en, this message translates to:
  /// **'Kundali match'**
  String get sharedMatchTitle;

  /// No description provided for @sharedPoints.
  ///
  /// In en, this message translates to:
  /// **'{points} of {max} guna'**
  String sharedPoints(String points, String max);

  /// No description provided for @sharedNew.
  ///
  /// In en, this message translates to:
  /// **'The customer shared new details'**
  String get sharedNew;

  /// No description provided for @sharedAvailable.
  ///
  /// In en, this message translates to:
  /// **'Birth details shared'**
  String get sharedAvailable;

  /// No description provided for @matchReportTitle.
  ///
  /// In en, this message translates to:
  /// **'Match report'**
  String get matchReportTitle;

  /// No description provided for @matchKootas.
  ///
  /// In en, this message translates to:
  /// **'Guna table'**
  String get matchKootas;

  /// No description provided for @matchDoshas.
  ///
  /// In en, this message translates to:
  /// **'Doshas'**
  String get matchDoshas;

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

  /// No description provided for @matchNoDoshas.
  ///
  /// In en, this message translates to:
  /// **'No major doshas'**
  String get matchNoDoshas;

  /// No description provided for @matchLoadError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load the match report'**
  String get matchLoadError;

  /// No description provided for @sessionLiveBanner.
  ///
  /// In en, this message translates to:
  /// **'Live with {name}'**
  String sessionLiveBanner(String name);

  /// No description provided for @sessionReturn.
  ///
  /// In en, this message translates to:
  /// **'Return'**
  String get sessionReturn;

  /// No description provided for @liveSendPhoto.
  ///
  /// In en, this message translates to:
  /// **'Send a photo'**
  String get liveSendPhoto;

  /// No description provided for @livePhotoFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t send the photo'**
  String get livePhotoFailed;

  /// No description provided for @livePhotoLabel.
  ///
  /// In en, this message translates to:
  /// **'Photo'**
  String get livePhotoLabel;

  /// No description provided for @errGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get errGeneric;

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

  /// No description provided for @errForbidden.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have access to this.'**
  String get errForbidden;

  /// No description provided for @errNotFound.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t find this — it may have been removed.'**
  String get errNotFound;

  /// No description provided for @errServer.
  ///
  /// In en, this message translates to:
  /// **'Our server ran into a problem. Please try again shortly.'**
  String get errServer;

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

  /// No description provided for @errAuthWrongApp.
  ///
  /// In en, this message translates to:
  /// **'This number is registered for the other TalkAcharya app.'**
  String get errAuthWrongApp;

  /// No description provided for @callMinimize.
  ///
  /// In en, this message translates to:
  /// **'Minimize'**
  String get callMinimize;

  /// No description provided for @callTapToReturn.
  ///
  /// In en, this message translates to:
  /// **'Tap to return to the call'**
  String get callTapToReturn;

  /// No description provided for @callWaiting.
  ///
  /// In en, this message translates to:
  /// **'Waiting…'**
  String get callWaiting;

  /// No description provided for @profileSounds.
  ///
  /// In en, this message translates to:
  /// **'Sounds'**
  String get profileSounds;

  /// No description provided for @profileSoundsDesc.
  ///
  /// In en, this message translates to:
  /// **'Ringtone, call and chat tones'**
  String get profileSoundsDesc;

  /// No description provided for @profileHapticFeedback.
  ///
  /// In en, this message translates to:
  /// **'Vibration'**
  String get profileHapticFeedback;

  /// No description provided for @profileHapticFeedbackDesc.
  ///
  /// In en, this message translates to:
  /// **'Vibrate on buttons and alerts'**
  String get profileHapticFeedbackDesc;

  /// No description provided for @profileSoundVibration.
  ///
  /// In en, this message translates to:
  /// **'Sound & vibration'**
  String get profileSoundVibration;

  /// No description provided for @profileSoundVibrationSub.
  ///
  /// In en, this message translates to:
  /// **'Ringtone, tones and vibration'**
  String get profileSoundVibrationSub;

  /// No description provided for @roomViewSummary.
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get roomViewSummary;

  /// Self-view label when the network, not the user, paused the camera
  ///
  /// In en, this message translates to:
  /// **'Video paused — weak connection'**
  String get callVideoPausedWeak;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
