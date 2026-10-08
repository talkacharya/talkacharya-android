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

  /// Free follow-up window after a session ends
  ///
  /// In en, this message translates to:
  /// **'Free follow-up — replies are not charged'**
  String get roomFollowUpOpen;

  /// Free follow-up window after a session ends
  ///
  /// In en, this message translates to:
  /// **'Free follow-up open for {hours}h more'**
  String roomFollowUpHours(int hours);

  /// Free follow-up window after a session ends
  ///
  /// In en, this message translates to:
  /// **'Free follow-up open for {minutes} min more'**
  String roomFollowUpMinutes(int minutes);

  /// Free follow-up window after a session ends
  ///
  /// In en, this message translates to:
  /// **'Reply (free follow-up)'**
  String get roomFollowUpHint;

  /// Chats tab thread rows
  ///
  /// In en, this message translates to:
  /// **'Free follow-up open'**
  String get chatsFollowUpOpen;

  /// Chats tab thread rows
  ///
  /// In en, this message translates to:
  /// **'You: {body}'**
  String chatsYouPrefix(String body);

  /// Astrologer quick replies
  ///
  /// In en, this message translates to:
  /// **'Quick replies'**
  String get quickReplies;

  /// Astrologer quick replies
  ///
  /// In en, this message translates to:
  /// **'Tap to put one in the box'**
  String get quickRepliesHint;

  /// Astrologer quick replies
  ///
  /// In en, this message translates to:
  /// **'New quick reply'**
  String get quickRepliesAdd;

  /// Astrologer quick replies
  ///
  /// In en, this message translates to:
  /// **'Something you type often'**
  String get quickRepliesNewHint;

  /// Astrologer quick replies
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get quickRepliesDelete;

  /// Astrologer quick replies
  ///
  /// In en, this message translates to:
  /// **'Could not save that reply.'**
  String get quickRepliesSaveFailed;

  /// Dismiss a panel
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get commonClose;

  /// Customer is mid-recharge; the session is held
  ///
  /// In en, this message translates to:
  /// **'Customer is adding money — session held, not billing'**
  String get roomCustomerToppingUp;

  /// Private-reading queue while live
  ///
  /// In en, this message translates to:
  /// **'{count} waiting'**
  String liveWaitingCount(int count);

  /// Private-reading queue while live
  ///
  /// In en, this message translates to:
  /// **'Viewers who want a private reading — they\'re in your queue'**
  String get liveWaitingTooltip;

  /// Whose line is weak during a call
  ///
  /// In en, this message translates to:
  /// **'Weak connection'**
  String get callPoorConnection;

  /// Whose line is weak during a call
  ///
  /// In en, this message translates to:
  /// **'Customer\'s connection is weak'**
  String get callPeerPoorConnection;

  /// Whose line is weak during a call
  ///
  /// In en, this message translates to:
  /// **'Weak connection on both sides'**
  String get callBothPoorConnection;

  /// Chart overlay during a video call
  ///
  /// In en, this message translates to:
  /// **'Chart'**
  String get callShowChart;

  /// Chart overlay during a video call
  ///
  /// In en, this message translates to:
  /// **'Hide chart'**
  String get callHideChart;

  /// Search within a conversation
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get roomSearch;

  /// Search within a conversation
  ///
  /// In en, this message translates to:
  /// **'Search this conversation'**
  String get roomSearchHint;

  /// Search within a conversation
  ///
  /// In en, this message translates to:
  /// **'Nothing found'**
  String get roomSearchEmpty;

  /// Gifts an astrologer received
  ///
  /// In en, this message translates to:
  /// **'Gifts'**
  String get earnTabGifts;

  /// Gifts an astrologer received
  ///
  /// In en, this message translates to:
  /// **'No gifts yet'**
  String get earnGiftsEmptyTitle;

  /// Gifts an astrologer received
  ///
  /// In en, this message translates to:
  /// **'Gifts sent during your live streams and consultations show up here.'**
  String get earnGiftsEmptyBody;

  /// Gifts an astrologer received
  ///
  /// In en, this message translates to:
  /// **'Live stream'**
  String get earnGiftFromLive;

  /// Gifts an astrologer received
  ///
  /// In en, this message translates to:
  /// **'Consultation'**
  String get earnGiftFromConsultation;

  /// Download a transcript of the session
  ///
  /// In en, this message translates to:
  /// **'Save this conversation'**
  String get roomDownloadTranscript;

  /// Prediction work queue
  ///
  /// In en, this message translates to:
  /// **'Prediction queue'**
  String get predQueueTitle;

  /// Prediction work queue
  ///
  /// In en, this message translates to:
  /// **'Forecasts waiting to be written'**
  String get predQueueSubtitle;

  /// Prediction work queue
  ///
  /// In en, this message translates to:
  /// **'Nothing waiting'**
  String get predQueueEmptyTitle;

  /// Prediction work queue
  ///
  /// In en, this message translates to:
  /// **'New prediction requests will show up here.'**
  String get predQueueEmptyBody;

  /// Prediction editor
  ///
  /// In en, this message translates to:
  /// **'Write forecast'**
  String get predWorkTitle;

  /// Prediction editor
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get predWorkTitleField;

  /// Prediction editor
  ///
  /// In en, this message translates to:
  /// **'Forecast'**
  String get predWorkBodyField;

  /// Prediction editor
  ///
  /// In en, this message translates to:
  /// **'{count} words'**
  String predWorkWords(int count);

  /// Prediction editor
  ///
  /// In en, this message translates to:
  /// **'Saving…'**
  String get predWorkSaving;

  /// Prediction editor
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get predWorkSaved;

  /// Prediction editor
  ///
  /// In en, this message translates to:
  /// **'Claim'**
  String get predWorkClaim;

  /// Prediction editor
  ///
  /// In en, this message translates to:
  /// **'Release'**
  String get predWorkRelease;

  /// Prediction editor
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get predWorkDelivered;

  /// Prediction editor
  ///
  /// In en, this message translates to:
  /// **'Deliver forecast'**
  String get predWorkDeliver;

  /// Going live
  ///
  /// In en, this message translates to:
  /// **'Go live'**
  String get goLiveTitle;

  /// Going live
  ///
  /// In en, this message translates to:
  /// **'Broadcast to anyone browsing the Live tab'**
  String get goLiveSubtitle;

  /// Going live
  ///
  /// In en, this message translates to:
  /// **'Still live — rejoin to keep broadcasting'**
  String get goLiveStillLive;

  /// Going live
  ///
  /// In en, this message translates to:
  /// **'Scheduled — start when you are ready'**
  String get goLiveScheduled;

  /// Going live
  ///
  /// In en, this message translates to:
  /// **'Rejoin'**
  String get goLiveRejoin;

  /// Going live
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get goLiveStart;

  /// Going live
  ///
  /// In en, this message translates to:
  /// **'Start a new session'**
  String get goLiveNewSession;

  /// Going live
  ///
  /// In en, this message translates to:
  /// **'What is this session about?'**
  String get goLiveTitleField;

  /// Going live
  ///
  /// In en, this message translates to:
  /// **'e.g. Evening Q&A — career questions'**
  String get goLiveTitleHint;

  /// Going live
  ///
  /// In en, this message translates to:
  /// **'Viewers see this title in the app. Your camera and microphone turn on as soon as you go live.'**
  String get goLiveHelp;

  /// Going live
  ///
  /// In en, this message translates to:
  /// **'Starting…'**
  String get goLiveStarting;

  /// Going live
  ///
  /// In en, this message translates to:
  /// **'Past sessions'**
  String get goLivePast;

  /// Going live
  ///
  /// In en, this message translates to:
  /// **'{count} peak'**
  String goLivePeak(int count);

  /// Going live
  ///
  /// In en, this message translates to:
  /// **'{count} joined'**
  String goLiveJoined(int count);

  /// Going live
  ///
  /// In en, this message translates to:
  /// **'{currency} {amount} in gifts'**
  String goLiveGifts(String currency, String amount);

  /// The client's kundali screen
  ///
  /// In en, this message translates to:
  /// **'Kundali'**
  String get kundaliTitle;

  /// The client's kundali screen
  ///
  /// In en, this message translates to:
  /// **'{name}\'s kundali'**
  String kundaliTitleFor(String name);

  /// The client's kundali screen
  ///
  /// In en, this message translates to:
  /// **'Charts'**
  String get kundaliTabCharts;

  /// The client's kundali screen
  ///
  /// In en, this message translates to:
  /// **'Planets'**
  String get kundaliTabPlanets;

  /// The client's kundali screen
  ///
  /// In en, this message translates to:
  /// **'Dasha'**
  String get kundaliTabDasha;

  /// The client's kundali screen
  ///
  /// In en, this message translates to:
  /// **'Yogas'**
  String get kundaliTabYogas;

  /// The client's kundali screen
  ///
  /// In en, this message translates to:
  /// **'Doshas'**
  String get kundaliTabDoshas;

  /// The client's kundali screen
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get kundaliTabOverview;

  /// The client's kundali screen
  ///
  /// In en, this message translates to:
  /// **'Remedies'**
  String get kundaliTabRemedies;

  /// The client's kundali screen
  ///
  /// In en, this message translates to:
  /// **'Bhava'**
  String get kundaliTabBhava;

  /// The client's kundali screen
  ///
  /// In en, this message translates to:
  /// **'Gochar'**
  String get kundaliTabGochar;

  /// The client's kundali screen
  ///
  /// In en, this message translates to:
  /// **'Numbers'**
  String get kundaliTabNumbers;

  /// The client's kundali screen
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get kundaliTabAdvanced;

  /// Hosting a live stream
  ///
  /// In en, this message translates to:
  /// **'End the session?'**
  String get hostEndTitle;

  /// Hosting a live stream
  ///
  /// In en, this message translates to:
  /// **'Stay live'**
  String get hostStayLive;

  /// Hosting a live stream
  ///
  /// In en, this message translates to:
  /// **'End session'**
  String get hostEndSession;

  /// Hosting a live stream
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get hostEnd;

  /// Hosting a live stream
  ///
  /// In en, this message translates to:
  /// **'Answer your viewers…'**
  String get hostChatHint;

  /// Hosting a live stream
  ///
  /// In en, this message translates to:
  /// **'Slow mode'**
  String get hostSlowMode;

  /// Hosting a live stream
  ///
  /// In en, this message translates to:
  /// **'How long a viewer must wait between messages'**
  String get hostSlowModeBody;

  /// Hosting a live stream
  ///
  /// In en, this message translates to:
  /// **'Pin this message'**
  String get hostPin;

  /// Hosting a live stream
  ///
  /// In en, this message translates to:
  /// **'Hide this message'**
  String get hostHide;

  /// Hosting a live stream
  ///
  /// In en, this message translates to:
  /// **'Remove this viewer'**
  String get hostRemove;

  /// Hosting a live stream
  ///
  /// In en, this message translates to:
  /// **'They cannot rejoin or chat on this stream'**
  String get hostRemoveBody;

  /// Astrologer app strings
  ///
  /// In en, this message translates to:
  /// **'Resend code'**
  String get otpResend;

  /// Astrologer app strings
  ///
  /// In en, this message translates to:
  /// **'All charts — D1 to D60'**
  String get kundaliAllCharts;

  /// Astrologer app strings
  ///
  /// In en, this message translates to:
  /// **'No notable yogas found.'**
  String get kundaliNoYogas;

  /// Astrologer app strings
  ///
  /// In en, this message translates to:
  /// **'No data'**
  String get kundaliNoData;

  /// Astrologer app strings
  ///
  /// In en, this message translates to:
  /// **'Needs at least {min} words ({count} so far).'**
  String predWorkTooShort(int min, int count);

  /// Signing in
  ///
  /// In en, this message translates to:
  /// **'Welcome, Acharya'**
  String get authTitle;

  /// Signing in
  ///
  /// In en, this message translates to:
  /// **'Sign in with your mobile number to reach the people waiting for your guidance.'**
  String get authSubtitle;

  /// Signing in
  ///
  /// In en, this message translates to:
  /// **'MOBILE NUMBER'**
  String get authPhoneLabel;

  /// Signing in
  ///
  /// In en, this message translates to:
  /// **'10-digit number'**
  String get authPhoneHint;

  /// Signing in
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get authContinue;

  /// Signing in
  ///
  /// In en, this message translates to:
  /// **'I agree to the '**
  String get authLegalBefore;

  /// Signing in
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get authLegalTerms;

  /// Signing in
  ///
  /// In en, this message translates to:
  /// **' and the '**
  String get authLegalBetween;

  /// Signing in
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get authLegalPrivacy;

  /// Signing in
  ///
  /// In en, this message translates to:
  /// **'.'**
  String get authLegalAfter;

  /// Signing in
  ///
  /// In en, this message translates to:
  /// **'Could not open that page right now.'**
  String get authLegalUnavailable;

  /// Signing in
  ///
  /// In en, this message translates to:
  /// **'Enter the code'**
  String get otpTitle;

  /// Signing in
  ///
  /// In en, this message translates to:
  /// **'Sent to {phone}'**
  String otpSentTo(String phone);

  /// Signing in
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get otpChangeNumber;

  /// Signing in
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get otpVerify;

  /// Signing in
  ///
  /// In en, this message translates to:
  /// **'Resend in {seconds}s'**
  String otpResendIn(int seconds);

  /// Signing in
  ///
  /// In en, this message translates to:
  /// **'Dev mode — the code is {code}'**
  String otpDevMode(String code);

  /// Call screen audio-output picker
  ///
  /// In en, this message translates to:
  /// **'Audio'**
  String get callAudio;

  /// Call screen audio-output picker
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get callEarpiece;

  /// Call screen audio-output picker
  ///
  /// In en, this message translates to:
  /// **'Headset'**
  String get callWiredHeadset;

  /// Call screen audio-output picker
  ///
  /// In en, this message translates to:
  /// **'Bluetooth'**
  String get callBluetooth;

  /// Chat room / chats list
  ///
  /// In en, this message translates to:
  /// **'Mute notifications'**
  String get chatMute;

  /// Chat room / chats list
  ///
  /// In en, this message translates to:
  /// **'Unmute notifications'**
  String get chatUnmute;

  /// Chat room / chats list
  ///
  /// In en, this message translates to:
  /// **'Archive chat'**
  String get chatArchive;

  /// Chat room / chats list
  ///
  /// In en, this message translates to:
  /// **'Move out of archive'**
  String get chatUnarchive;

  /// Chat room / chats list
  ///
  /// In en, this message translates to:
  /// **'Archived'**
  String get chatArchivedTitle;

  /// Chat room / chats list
  ///
  /// In en, this message translates to:
  /// **'Archived ({count})'**
  String chatArchivedRow(int count);

  /// Chat room / chats list
  ///
  /// In en, this message translates to:
  /// **'Block {name}'**
  String chatBlock(String name);

  /// Chat room / chats list
  ///
  /// In en, this message translates to:
  /// **'Unblock {name}'**
  String chatUnblock(String name);

  /// Chat room / chats list
  ///
  /// In en, this message translates to:
  /// **'Block {name}?'**
  String chatBlockConfirmTitle(String name);

  /// Chat room / chats list
  ///
  /// In en, this message translates to:
  /// **'Block'**
  String get chatBlockConfirmYes;

  /// Chat room / chats list
  ///
  /// In en, this message translates to:
  /// **'You blocked {name}.'**
  String chatBlockedByMe(String name);

  /// Chat room / chats list
  ///
  /// In en, this message translates to:
  /// **'Messages are turned off in this conversation.'**
  String get chatBlockedByThem;

  /// Chat room / chats list
  ///
  /// In en, this message translates to:
  /// **'More options'**
  String get chatMoreOptions;

  /// Chat room / chats list
  ///
  /// In en, this message translates to:
  /// **'Neither of you will be able to send messages here, and {name} won\'t be able to book you until you unblock them.'**
  String chatBlockConfirmBody(String name);

  /// Chat room / chats list
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get sessionChat;

  /// Chat room / chats list
  ///
  /// In en, this message translates to:
  /// **'Voice call'**
  String get sessionVoice;

  /// Chat room / chats list
  ///
  /// In en, this message translates to:
  /// **'Video call'**
  String get sessionVideo;

  /// Chat room / chats list
  ///
  /// In en, this message translates to:
  /// **'{session} in progress'**
  String roomLiveNow(String session);

  /// Chat room / chats list
  ///
  /// In en, this message translates to:
  /// **'{amount} earned so far'**
  String astroEarnedSoFar(String amount);

  /// Chat room / chats list
  ///
  /// In en, this message translates to:
  /// **'You earned {amount} · {minutes} min'**
  String astroEndedEarned(String amount, int minutes);

  /// Chat room / chats list
  ///
  /// In en, this message translates to:
  /// **'{name} rated this session {rating}/5'**
  String astroCustomerRated(String name, int rating);

  /// Chat room / chats list
  ///
  /// In en, this message translates to:
  /// **'Not rated yet'**
  String get astroNotRatedYet;

  /// In-chat request card, shown instead of the request sheet when the astrologer is already in that customer's room
  ///
  /// In en, this message translates to:
  /// **'{name} is asking for a {session}'**
  String astroRequestInRoom(String name, String session);

  /// Chat room / chats list
  ///
  /// In en, this message translates to:
  /// **'Consultation ended. {name} can start a new one any time.'**
  String astroThreadClosed(String name);

  /// Chat room / chats list
  ///
  /// In en, this message translates to:
  /// **'{session} requested'**
  String sysRequested(String session);

  /// Chat room / chats list
  ///
  /// In en, this message translates to:
  /// **'You picked up · connecting'**
  String get sysAccepted;

  /// Chat room / chats list
  ///
  /// In en, this message translates to:
  /// **'{session} started'**
  String sysStarted(String session);

  /// Chat room / chats list
  ///
  /// In en, this message translates to:
  /// **'{session} ended · {minutes} min'**
  String sysEnded(String session, int minutes);

  /// Chat room / chats list
  ///
  /// In en, this message translates to:
  /// **'{session} ended'**
  String sysEndedPlain(String session);

  /// Chat room / chats list
  ///
  /// In en, this message translates to:
  /// **'You declined the request'**
  String get sysRejected;

  /// Chat room / chats list
  ///
  /// In en, this message translates to:
  /// **'{name} cancelled the request'**
  String sysCancelled(String name);

  /// Chat room / chats list
  ///
  /// In en, this message translates to:
  /// **'Request not answered in time'**
  String get sysExpired;

  /// Chat room / chats list
  ///
  /// In en, this message translates to:
  /// **'{session} didn\'t connect'**
  String sysNoShow(String session);

  /// Chat room / chats list
  ///
  /// In en, this message translates to:
  /// **'{name}\'s balance is running low'**
  String sysEndingSoon(String name);

  /// No description provided for @presenceOnBreak.
  ///
  /// In en, this message translates to:
  /// **'On a break'**
  String get presenceOnBreak;

  /// No description provided for @presenceOnBreakHint.
  ///
  /// In en, this message translates to:
  /// **'You\'ll be back online by yourself when it ends'**
  String get presenceOnBreakHint;

  /// No description provided for @clubTitle.
  ///
  /// In en, this message translates to:
  /// **'You\'re in the {club} club'**
  String clubTitle(String club);

  /// No description provided for @clubTitleNone.
  ///
  /// In en, this message translates to:
  /// **'Your first club is within reach'**
  String get clubTitleNone;

  /// No description provided for @clubProjection.
  ///
  /// In en, this message translates to:
  /// **'On pace for {amount} this month'**
  String clubProjection(String amount);

  /// No description provided for @clubNeedToday.
  ///
  /// In en, this message translates to:
  /// **'Earn {amount} more today to stay on pace for the {club} club.'**
  String clubNeedToday(String amount, String club);

  /// No description provided for @clubOnTrack.
  ///
  /// In en, this message translates to:
  /// **'Today\'s target is met — the {club} club is next. Keep going.'**
  String clubOnTrack(String club);

  /// No description provided for @clubTop.
  ///
  /// In en, this message translates to:
  /// **'You\'re in the top club. Outstanding work.'**
  String get clubTop;

  /// No description provided for @todayTitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'s earnings'**
  String get todayTitle;

  /// No description provided for @todaySub.
  ///
  /// In en, this message translates to:
  /// **'After platform fee'**
  String get todaySub;

  /// No description provided for @todayHide.
  ///
  /// In en, this message translates to:
  /// **'Hide amounts'**
  String get todayHide;

  /// No description provided for @todayShow.
  ///
  /// In en, this message translates to:
  /// **'Show amounts'**
  String get todayShow;

  /// No description provided for @todayViewEarnings.
  ///
  /// In en, this message translates to:
  /// **'View earnings'**
  String get todayViewEarnings;

  /// No description provided for @todaySessions.
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get todaySessions;

  /// No description provided for @todayTalkTime.
  ///
  /// In en, this message translates to:
  /// **'Talk time'**
  String get todayTalkTime;

  /// No description provided for @todayOnline.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get todayOnline;

  /// No description provided for @scoreTitle.
  ///
  /// In en, this message translates to:
  /// **'Last {days} days'**
  String scoreTitle(int days);

  /// No description provided for @scoreUpdated.
  ///
  /// In en, this message translates to:
  /// **'Updated {time}'**
  String scoreUpdated(String time);

  /// No description provided for @scoreOpen.
  ///
  /// In en, this message translates to:
  /// **'Open performance dashboard'**
  String get scoreOpen;

  /// No description provided for @perfOnlineShort.
  ///
  /// In en, this message translates to:
  /// **'Online\nper day'**
  String get perfOnlineShort;

  /// No description provided for @perfSessionShort.
  ///
  /// In en, this message translates to:
  /// **'Average\nsession'**
  String get perfSessionShort;

  /// No description provided for @perfFirstRepeatShort.
  ///
  /// In en, this message translates to:
  /// **'First-time\nrepeat'**
  String get perfFirstRepeatShort;

  /// No description provided for @perfLoyalShort.
  ///
  /// In en, this message translates to:
  /// **'Loyal\ncustomers'**
  String get perfLoyalShort;

  /// No description provided for @perfHoursMinutes.
  ///
  /// In en, this message translates to:
  /// **'{h}h {m}m'**
  String perfHoursMinutes(int h, int m);

  /// No description provided for @perfMinutesSeconds.
  ///
  /// In en, this message translates to:
  /// **'{m}m {s}s'**
  String perfMinutesSeconds(int m, int s);

  /// No description provided for @perfSeconds.
  ///
  /// In en, this message translates to:
  /// **'{s}s'**
  String perfSeconds(int s);

  /// No description provided for @perfHours.
  ///
  /// In en, this message translates to:
  /// **'{h}h'**
  String perfHours(int h);

  /// No description provided for @perfMinutes.
  ///
  /// In en, this message translates to:
  /// **'{m}m'**
  String perfMinutes(int m);

  /// No description provided for @breakTitle.
  ///
  /// In en, this message translates to:
  /// **'Take a break'**
  String get breakTitle;

  /// No description provided for @breakLeft.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 break left today} other{{count} breaks left today}}'**
  String breakLeft(int count);

  /// No description provided for @breakNoneLeft.
  ///
  /// In en, this message translates to:
  /// **'No breaks left today'**
  String get breakNoneLeft;

  /// No description provided for @breakButton.
  ///
  /// In en, this message translates to:
  /// **'Take a break'**
  String get breakButton;

  /// No description provided for @breakSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'How long do you need?'**
  String get breakSheetTitle;

  /// No description provided for @breakInfo.
  ///
  /// In en, this message translates to:
  /// **'Customers won\'t be able to reach you during the break. You come back online by yourself when it ends — no need to switch anything on.'**
  String get breakInfo;

  /// No description provided for @breakMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String breakMinutes(int minutes);

  /// No description provided for @breakStart.
  ///
  /// In en, this message translates to:
  /// **'Start break'**
  String get breakStart;

  /// No description provided for @breakOnTitle.
  ///
  /// In en, this message translates to:
  /// **'On a break'**
  String get breakOnTitle;

  /// No description provided for @breakBackIn.
  ///
  /// In en, this message translates to:
  /// **'Back online in {time}'**
  String breakBackIn(String time);

  /// No description provided for @breakResume.
  ///
  /// In en, this message translates to:
  /// **'I\'m back'**
  String get breakResume;

  /// No description provided for @loyalTitle.
  ///
  /// In en, this message translates to:
  /// **'Loyal customers'**
  String get loyalTitle;

  /// No description provided for @loyalBody.
  ///
  /// In en, this message translates to:
  /// **'Customers who came back in the last {days} days and spent {minutes}+ minutes with you.'**
  String loyalBody(int days, int minutes);

  /// No description provided for @loyalWinBack.
  ///
  /// In en, this message translates to:
  /// **'See who\'s gone quiet'**
  String get loyalWinBack;

  /// No description provided for @dashTools.
  ///
  /// In en, this message translates to:
  /// **'Tools'**
  String get dashTools;

  /// No description provided for @dashActionPerformance.
  ///
  /// In en, this message translates to:
  /// **'Performance'**
  String get dashActionPerformance;

  /// No description provided for @dashActionWinBack.
  ///
  /// In en, this message translates to:
  /// **'Win back'**
  String get dashActionWinBack;

  /// No description provided for @dashActionChats.
  ///
  /// In en, this message translates to:
  /// **'Chat history'**
  String get dashActionChats;

  /// No description provided for @dashActionRequests.
  ///
  /// In en, this message translates to:
  /// **'Requests'**
  String get dashActionRequests;

  /// No description provided for @dashActionBoost.
  ///
  /// In en, this message translates to:
  /// **'Boost profile'**
  String get dashActionBoost;

  /// No description provided for @dashActionAlerts.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get dashActionAlerts;

  /// No description provided for @perfTitle.
  ///
  /// In en, this message translates to:
  /// **'Performance'**
  String get perfTitle;

  /// No description provided for @perfSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Last {days} days, compared with the {days} before.'**
  String perfSubtitle(int days);

  /// No description provided for @perfFocusTitle.
  ///
  /// In en, this message translates to:
  /// **'Where to focus'**
  String get perfFocusTitle;

  /// No description provided for @perfLegendLow.
  ///
  /// In en, this message translates to:
  /// **'Needs work'**
  String get perfLegendLow;

  /// No description provided for @perfLegendMid.
  ///
  /// In en, this message translates to:
  /// **'Moderate'**
  String get perfLegendMid;

  /// No description provided for @perfLegendGood.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get perfLegendGood;

  /// No description provided for @perfVerdictLow.
  ///
  /// In en, this message translates to:
  /// **'Needs work'**
  String get perfVerdictLow;

  /// No description provided for @perfVerdictMid.
  ///
  /// In en, this message translates to:
  /// **'Almost there'**
  String get perfVerdictMid;

  /// No description provided for @perfVerdictGood.
  ///
  /// In en, this message translates to:
  /// **'Doing well'**
  String get perfVerdictGood;

  /// No description provided for @perfVerdictNone.
  ///
  /// In en, this message translates to:
  /// **'Not enough data yet'**
  String get perfVerdictNone;

  /// No description provided for @perfFirstRepeat.
  ///
  /// In en, this message translates to:
  /// **'First-time repeat'**
  String get perfFirstRepeat;

  /// No description provided for @perfTotalRepeat.
  ///
  /// In en, this message translates to:
  /// **'Total repeat'**
  String get perfTotalRepeat;

  /// No description provided for @perfAvgSession.
  ///
  /// In en, this message translates to:
  /// **'Average session'**
  String get perfAvgSession;

  /// No description provided for @perfOnlineTime.
  ///
  /// In en, this message translates to:
  /// **'Average online time'**
  String get perfOnlineTime;

  /// No description provided for @perfMissed.
  ///
  /// In en, this message translates to:
  /// **'Missed requests'**
  String get perfMissed;

  /// No description provided for @perfFirstRepeatAbout.
  ///
  /// In en, this message translates to:
  /// **'Of the customers who consulted you for the first time in this period, the share who came back for another session.\n\nExample: 10 new customers, 4 of them returned — that is 40%.'**
  String get perfFirstRepeatAbout;

  /// No description provided for @perfTotalRepeatAbout.
  ///
  /// In en, this message translates to:
  /// **'Of everyone you consulted in this period, new or not, the share who have consulted you more than once.\n\nExample: 20 customers, 9 of them have been with you before or came back — that is 45%.'**
  String get perfTotalRepeatAbout;

  /// No description provided for @perfAvgSessionAbout.
  ///
  /// In en, this message translates to:
  /// **'Total billed time in this period divided by the number of sessions. Longer sessions usually mean the customer felt heard.\n\nExample: 120 minutes across 10 sessions — 12 minutes each.'**
  String get perfAvgSessionAbout;

  /// No description provided for @perfOnlineTimeAbout.
  ///
  /// In en, this message translates to:
  /// **'How long you were reachable each day on average — online or in a session. Breaks and time offline are not counted. We recommend at least six hours a day: customers return to astrologers they can find.'**
  String get perfOnlineTimeAbout;

  /// No description provided for @perfMissedAbout.
  ///
  /// In en, this message translates to:
  /// **'Requests that timed out before you answered, plus the ones you declined. Requests the customer cancelled are not counted. If you need to step away, take a break instead of leaving requests to ring out.'**
  String get perfMissedAbout;

  /// No description provided for @perfHowCalculated.
  ///
  /// In en, this message translates to:
  /// **'How it\'s calculated'**
  String get perfHowCalculated;

  /// No description provided for @perfShowLess.
  ///
  /// In en, this message translates to:
  /// **'Show less'**
  String get perfShowLess;

  /// No description provided for @perfNoChange.
  ///
  /// In en, this message translates to:
  /// **'Same as the period before'**
  String get perfNoChange;

  /// No description provided for @perfDeltaUp.
  ///
  /// In en, this message translates to:
  /// **'Up {amount} on the period before'**
  String perfDeltaUp(String amount);

  /// No description provided for @perfDeltaDown.
  ///
  /// In en, this message translates to:
  /// **'Down {amount} on the period before'**
  String perfDeltaDown(String amount);

  /// No description provided for @perfOnlineChart.
  ///
  /// In en, this message translates to:
  /// **'Hours online, day by day'**
  String get perfOnlineChart;

  /// No description provided for @perfGoalLine.
  ///
  /// In en, this message translates to:
  /// **'{hours}h goal'**
  String perfGoalLine(int hours);

  /// No description provided for @perfMissedUnanswered.
  ///
  /// In en, this message translates to:
  /// **'Timed out · {count}'**
  String perfMissedUnanswered(int count);

  /// No description provided for @perfMissedDeclined.
  ///
  /// In en, this message translates to:
  /// **'Declined · {count}'**
  String perfMissedDeclined(int count);

  /// No description provided for @perfRatings.
  ///
  /// In en, this message translates to:
  /// **'Ratings'**
  String get perfRatings;

  /// No description provided for @perfRatingsAbout.
  ///
  /// In en, this message translates to:
  /// **'Lifetime average of published ratings from customers you\'ve consulted.'**
  String get perfRatingsAbout;

  /// No description provided for @perfRatingOverall.
  ///
  /// In en, this message translates to:
  /// **'Overall'**
  String get perfRatingOverall;

  /// No description provided for @perfRatingCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 rating} other{{count} ratings}}'**
  String perfRatingCount(int count);

  /// No description provided for @perfNoRatings.
  ///
  /// In en, this message translates to:
  /// **'No ratings yet'**
  String get perfNoRatings;

  /// No description provided for @perfTipOnline.
  ///
  /// In en, this message translates to:
  /// **'More hours online is your quickest win — customers can only return to someone they can find.'**
  String get perfTipOnline;

  /// No description provided for @perfTipSession.
  ///
  /// In en, this message translates to:
  /// **'Aim for longer sessions: ask a follow-up question before you wrap up.'**
  String get perfTipSession;

  /// No description provided for @perfTipFirstRepeat.
  ///
  /// In en, this message translates to:
  /// **'Give first-time customers a reason to return — tell them what to look at next time.'**
  String get perfTipFirstRepeat;

  /// No description provided for @perfTipTotalRepeat.
  ///
  /// In en, this message translates to:
  /// **'Your regulars are slipping away. See who\'s gone quiet and be online when they usually come.'**
  String get perfTipTotalRepeat;

  /// No description provided for @perfTipMissed.
  ///
  /// In en, this message translates to:
  /// **'Too many requests are getting away. Answer before they time out, or take a break when you step away.'**
  String get perfTipMissed;

  /// No description provided for @winBackTitle.
  ///
  /// In en, this message translates to:
  /// **'Win back'**
  String get winBackTitle;

  /// No description provided for @winBackSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Returning customers you haven\'t spoken to in {days}+ days. Open a thread to see where you left off.'**
  String winBackSubtitle(int days);

  /// No description provided for @winBackTile.
  ///
  /// In en, this message translates to:
  /// **'{sessions} sessions · {minutes} min together'**
  String winBackTile(int sessions, int minutes);

  /// No description provided for @winBackLast.
  ///
  /// In en, this message translates to:
  /// **'Last session {time}'**
  String winBackLast(String time);

  /// No description provided for @winBackCustomer.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get winBackCustomer;

  /// No description provided for @winBackEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No one\'s gone quiet'**
  String get winBackEmptyTitle;

  /// No description provided for @winBackEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Returning customers who stop coming back will show up here.'**
  String get winBackEmptyBody;

  /// No description provided for @dashActionWaitlist.
  ///
  /// In en, this message translates to:
  /// **'Waitlist'**
  String get dashActionWaitlist;

  /// No description provided for @dashActionCalls.
  ///
  /// In en, this message translates to:
  /// **'Call history'**
  String get dashActionCalls;

  /// No description provided for @dashActionRemedies.
  ///
  /// In en, this message translates to:
  /// **'Remedies'**
  String get dashActionRemedies;

  /// No description provided for @dashActionSounds.
  ///
  /// In en, this message translates to:
  /// **'Sounds'**
  String get dashActionSounds;

  /// No description provided for @waitlistTitle.
  ///
  /// In en, this message translates to:
  /// **'Waitlist'**
  String get waitlistTitle;

  /// No description provided for @waitlistSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Customers waiting for you, longest first. When a session ends the next person is told it\'s their turn — or call someone in yourself.'**
  String get waitlistSubtitle;

  /// No description provided for @waitlistEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No one is waiting'**
  String get waitlistEmptyTitle;

  /// No description provided for @waitlistEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Customers who try to reach you while you\'re in a session can join your waitlist. They\'ll show up here.'**
  String get waitlistEmptyBody;

  /// No description provided for @waitlistInvite.
  ///
  /// In en, this message translates to:
  /// **'Call in'**
  String get waitlistInvite;

  /// No description provided for @waitlistInvited.
  ///
  /// In en, this message translates to:
  /// **'{name} has been told it\'s their turn'**
  String waitlistInvited(String name);

  /// No description provided for @waitlistInvitedLeft.
  ///
  /// In en, this message translates to:
  /// **'Invited · {time} to join'**
  String waitlistInvitedLeft(String time);

  /// No description provided for @waitlistWaiting.
  ///
  /// In en, this message translates to:
  /// **'Waiting {time}'**
  String waitlistWaiting(String time);

  /// No description provided for @waitlistNew.
  ///
  /// In en, this message translates to:
  /// **'New customer'**
  String get waitlistNew;

  /// No description provided for @waitlistRegular.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 session with you} other{{count} sessions with you}}'**
  String waitlistRegular(int count);

  /// No description provided for @waitlistRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove from waitlist'**
  String get waitlistRemove;

  /// No description provided for @waitlistRemoveTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove {name}?'**
  String waitlistRemoveTitle(String name);

  /// No description provided for @waitlistRemoveBody.
  ///
  /// In en, this message translates to:
  /// **'They lose their place in line and are told you can\'t take them right now.'**
  String get waitlistRemoveBody;

  /// No description provided for @callsTitle.
  ///
  /// In en, this message translates to:
  /// **'Call history'**
  String get callsTitle;

  /// No description provided for @callsFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get callsFilterAll;

  /// No description provided for @callsFilterCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get callsFilterCompleted;

  /// No description provided for @callsFilterMissed.
  ///
  /// In en, this message translates to:
  /// **'Missed'**
  String get callsFilterMissed;

  /// No description provided for @callsStatCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get callsStatCompleted;

  /// No description provided for @callsStatTalkTime.
  ///
  /// In en, this message translates to:
  /// **'Talk time'**
  String get callsStatTalkTime;

  /// No description provided for @callsStatMissed.
  ///
  /// In en, this message translates to:
  /// **'Missed'**
  String get callsStatMissed;

  /// No description provided for @callsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No calls yet'**
  String get callsEmptyTitle;

  /// No description provided for @callsEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Voice and video calls with your customers will be listed here.'**
  String get callsEmptyBody;

  /// No description provided for @callsEmptyFilter.
  ///
  /// In en, this message translates to:
  /// **'Nothing here'**
  String get callsEmptyFilter;

  /// No description provided for @remediesTitle.
  ///
  /// In en, this message translates to:
  /// **'Remedies'**
  String get remediesTitle;

  /// No description provided for @remediesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Gemstones, rudraksha, poojas and more from the store that you\'ve suggested to your customers.'**
  String get remediesSubtitle;

  /// No description provided for @remediesSuggest.
  ///
  /// In en, this message translates to:
  /// **'Suggest a remedy'**
  String get remediesSuggest;

  /// No description provided for @remediesSummary.
  ///
  /// In en, this message translates to:
  /// **'{sent} suggested · {bought} bought'**
  String remediesSummary(int sent, int bought);

  /// No description provided for @remediesCommission.
  ///
  /// In en, this message translates to:
  /// **'You earn {percent} when a customer buys what you suggested.'**
  String remediesCommission(String percent);

  /// No description provided for @remediesEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No remedies suggested yet'**
  String get remediesEmptyTitle;

  /// No description provided for @remediesEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Suggest a product from the store after a reading. The customer gets it in their app, and you earn a commission if they buy.'**
  String get remediesEmptyBody;

  /// No description provided for @remedyStatusSent.
  ///
  /// In en, this message translates to:
  /// **'Sent'**
  String get remedyStatusSent;

  /// No description provided for @remedyStatusViewed.
  ///
  /// In en, this message translates to:
  /// **'Seen'**
  String get remedyStatusViewed;

  /// No description provided for @remedyStatusPurchased.
  ///
  /// In en, this message translates to:
  /// **'Bought'**
  String get remedyStatusPurchased;

  /// No description provided for @remedyStatusExpired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get remedyStatusExpired;

  /// No description provided for @remedyFor.
  ///
  /// In en, this message translates to:
  /// **'For {name} · {time}'**
  String remedyFor(String name, String time);

  /// No description provided for @remedySuggestTitle.
  ///
  /// In en, this message translates to:
  /// **'Suggest a remedy'**
  String get remedySuggestTitle;

  /// No description provided for @remedySuggestFor.
  ///
  /// In en, this message translates to:
  /// **'For {name}'**
  String remedySuggestFor(String name);

  /// No description provided for @remedyStepCustomer.
  ///
  /// In en, this message translates to:
  /// **'Who is it for?'**
  String get remedyStepCustomer;

  /// No description provided for @remedyStepProduct.
  ///
  /// In en, this message translates to:
  /// **'Choose the remedy'**
  String get remedyStepProduct;

  /// No description provided for @remedyStepNote.
  ///
  /// In en, this message translates to:
  /// **'How should they use it?'**
  String get remedyStepNote;

  /// No description provided for @remedySearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search gemstones, rudraksha, poojas…'**
  String get remedySearchHint;

  /// No description provided for @remedyNoteHint.
  ///
  /// In en, this message translates to:
  /// **'For example: wear it on the ring finger on a Saturday morning.'**
  String get remedyNoteHint;

  /// No description provided for @remedyNoProducts.
  ///
  /// In en, this message translates to:
  /// **'No products match that search.'**
  String get remedyNoProducts;

  /// No description provided for @remedyNoCustomers.
  ///
  /// In en, this message translates to:
  /// **'You can suggest remedies to customers you\'ve consulted. None yet.'**
  String get remedyNoCustomers;

  /// No description provided for @remedySend.
  ///
  /// In en, this message translates to:
  /// **'Send suggestion'**
  String get remedySend;

  /// No description provided for @remedySent.
  ///
  /// In en, this message translates to:
  /// **'Suggestion sent'**
  String get remedySent;

  /// No description provided for @remedyDisclosure.
  ///
  /// In en, this message translates to:
  /// **'The customer sees this as your recommendation and decides for themselves. Suggest only what the chart calls for.'**
  String get remedyDisclosure;

  /// No description provided for @toolsTitle.
  ///
  /// In en, this message translates to:
  /// **'All tools'**
  String get toolsTitle;

  /// No description provided for @toolsGroupWork.
  ///
  /// In en, this message translates to:
  /// **'Your work'**
  String get toolsGroupWork;

  /// No description provided for @toolsGroupCustomers.
  ///
  /// In en, this message translates to:
  /// **'Your customers'**
  String get toolsGroupCustomers;

  /// No description provided for @toolsGroupGrow.
  ///
  /// In en, this message translates to:
  /// **'Grow'**
  String get toolsGroupGrow;

  /// No description provided for @toolsGroupSchedule.
  ///
  /// In en, this message translates to:
  /// **'Schedule & money'**
  String get toolsGroupSchedule;

  /// No description provided for @toolsGroupHelp.
  ///
  /// In en, this message translates to:
  /// **'Updates & help'**
  String get toolsGroupHelp;

  /// No description provided for @wsCantOpen.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t open that on this phone'**
  String get wsCantOpen;

  /// No description provided for @wsRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get wsRemove;

  /// No description provided for @wsNew.
  ///
  /// In en, this message translates to:
  /// **'NEW'**
  String get wsNew;

  /// No description provided for @wsReadMore.
  ///
  /// In en, this message translates to:
  /// **'Read more'**
  String get wsReadMore;

  /// No description provided for @wsAnnouncements.
  ///
  /// In en, this message translates to:
  /// **'Announcements'**
  String get wsAnnouncements;

  /// No description provided for @wsAnnouncementsEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing new right now'**
  String get wsAnnouncementsEmpty;

  /// No description provided for @wsAnnouncementsEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Policy changes, festival timings and new features from TalkAcharya will show up here.'**
  String get wsAnnouncementsEmptyBody;

  /// No description provided for @wsTraining.
  ///
  /// In en, this message translates to:
  /// **'Training'**
  String get wsTraining;

  /// No description provided for @wsTrainingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Short videos on getting more from the app. They open in your video app.'**
  String get wsTrainingSubtitle;

  /// No description provided for @wsTrainingEmpty.
  ///
  /// In en, this message translates to:
  /// **'No videos yet'**
  String get wsTrainingEmpty;

  /// No description provided for @wsTrainingEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Training videos will appear here as they are added.'**
  String get wsTrainingEmptyBody;

  /// No description provided for @wsFavourites.
  ///
  /// In en, this message translates to:
  /// **'Favourites'**
  String get wsFavourites;

  /// No description provided for @wsFavouritesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Customers you\'ve marked, with notes only you can see.'**
  String get wsFavouritesSubtitle;

  /// No description provided for @wsFavouritesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No favourites yet'**
  String get wsFavouritesEmpty;

  /// No description provided for @wsFavouritesEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Open a customer\'s chat and choose \"Add to favourites\" from the menu.'**
  String get wsFavouritesEmptyBody;

  /// No description provided for @wsAddFavourite.
  ///
  /// In en, this message translates to:
  /// **'Add to favourites'**
  String get wsAddFavourite;

  /// No description provided for @wsFavouriteAdded.
  ///
  /// In en, this message translates to:
  /// **'{name} added to favourites'**
  String wsFavouriteAdded(String name);

  /// No description provided for @wsUnfavourite.
  ///
  /// In en, this message translates to:
  /// **'Remove from favourites'**
  String get wsUnfavourite;

  /// No description provided for @wsEditNote.
  ///
  /// In en, this message translates to:
  /// **'Edit note'**
  String get wsEditNote;

  /// No description provided for @wsNoteTitle.
  ///
  /// In en, this message translates to:
  /// **'Note about {name}'**
  String wsNoteTitle(String name);

  /// No description provided for @wsNoteHint.
  ///
  /// In en, this message translates to:
  /// **'Only you see this. For example: career question, follow up after Diwali.'**
  String get wsNoteHint;

  /// No description provided for @wsCommunity.
  ///
  /// In en, this message translates to:
  /// **'My community'**
  String get wsCommunity;

  /// No description provided for @wsCommunitySubtitle.
  ///
  /// In en, this message translates to:
  /// **'People who follow you. They\'re told when you come online or go live.'**
  String get wsCommunitySubtitle;

  /// No description provided for @wsFollowers.
  ///
  /// In en, this message translates to:
  /// **'Followers'**
  String get wsFollowers;

  /// No description provided for @wsNewThisWeek.
  ///
  /// In en, this message translates to:
  /// **'New this week'**
  String get wsNewThisWeek;

  /// No description provided for @wsFollowingSince.
  ///
  /// In en, this message translates to:
  /// **'Joined {time}'**
  String wsFollowingSince(String time);

  /// No description provided for @wsCommunityEmpty.
  ///
  /// In en, this message translates to:
  /// **'No followers yet'**
  String get wsCommunityEmpty;

  /// No description provided for @wsCommunityEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Customers can follow you from your profile or after a session. Going live is the quickest way to be found.'**
  String get wsCommunityEmptyBody;

  /// No description provided for @wsReferral.
  ///
  /// In en, this message translates to:
  /// **'Refer & earn'**
  String get wsReferral;

  /// No description provided for @wsReferralPitch.
  ///
  /// In en, this message translates to:
  /// **'Earn {reward} for every new customer who joins with your code. They get {gift}.'**
  String wsReferralPitch(String reward, String gift);

  /// No description provided for @wsCodeCopied.
  ///
  /// In en, this message translates to:
  /// **'Code copied'**
  String get wsCodeCopied;

  /// No description provided for @wsShareInvite.
  ///
  /// In en, this message translates to:
  /// **'Share invite'**
  String get wsShareInvite;

  /// No description provided for @wsReferralShare.
  ///
  /// In en, this message translates to:
  /// **'Consult me on TalkAcharya. Use my code {code} when you sign up and get {gift} in your wallet. {link}'**
  String wsReferralShare(String code, String gift, String link);

  /// No description provided for @wsReferralJoined.
  ///
  /// In en, this message translates to:
  /// **'Joined with your code'**
  String get wsReferralJoined;

  /// No description provided for @wsReferralEarned.
  ///
  /// In en, this message translates to:
  /// **'Earned'**
  String get wsReferralEarned;

  /// No description provided for @wsReferralHow.
  ///
  /// In en, this message translates to:
  /// **'The reward is added to your payouts once the person you invited completes their first paid consultation.'**
  String get wsReferralHow;

  /// No description provided for @wsReferralPending.
  ///
  /// In en, this message translates to:
  /// **'Joined'**
  String get wsReferralPending;

  /// No description provided for @wsReferralRewarded.
  ///
  /// In en, this message translates to:
  /// **'Rewarded'**
  String get wsReferralRewarded;

  /// No description provided for @wsReferralVoid.
  ///
  /// In en, this message translates to:
  /// **'Not counted'**
  String get wsReferralVoid;

  /// No description provided for @wsGallery.
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get wsGallery;

  /// No description provided for @wsGallerySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Pictures customers see on your profile.'**
  String get wsGallerySubtitle;

  /// No description provided for @wsGalleryCount.
  ///
  /// In en, this message translates to:
  /// **'{count} of {max} photos'**
  String wsGalleryCount(int count, int max);

  /// No description provided for @wsAddPhoto.
  ///
  /// In en, this message translates to:
  /// **'Add photo'**
  String get wsAddPhoto;

  /// No description provided for @wsPhotoRemoveTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove this photo?'**
  String get wsPhotoRemoveTitle;

  /// No description provided for @wsGalleryRules.
  ///
  /// In en, this message translates to:
  /// **'Use your own photos: you at work, your certificates, poojas you\'ve performed. No phone numbers or other contact details in the picture.'**
  String get wsGalleryRules;

  /// No description provided for @wsFeedback.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get wsFeedback;

  /// No description provided for @wsFeedbackSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tell us what\'s broken or what would help. We read every message.'**
  String get wsFeedbackSubtitle;

  /// No description provided for @wsFeedbackBug.
  ///
  /// In en, this message translates to:
  /// **'Something\'s broken'**
  String get wsFeedbackBug;

  /// No description provided for @wsFeedbackSuggestion.
  ///
  /// In en, this message translates to:
  /// **'Suggestion'**
  String get wsFeedbackSuggestion;

  /// No description provided for @wsFeedbackPayments.
  ///
  /// In en, this message translates to:
  /// **'Payments'**
  String get wsFeedbackPayments;

  /// No description provided for @wsFeedbackCustomers.
  ///
  /// In en, this message translates to:
  /// **'Customers'**
  String get wsFeedbackCustomers;

  /// No description provided for @wsFeedbackOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get wsFeedbackOther;

  /// No description provided for @wsFeedbackHint.
  ///
  /// In en, this message translates to:
  /// **'What happened, and what did you expect?'**
  String get wsFeedbackHint;

  /// No description provided for @wsFeedbackSend.
  ///
  /// In en, this message translates to:
  /// **'Send feedback'**
  String get wsFeedbackSend;

  /// No description provided for @wsFeedbackTooShort.
  ///
  /// In en, this message translates to:
  /// **'Please write a little more so we can help.'**
  String get wsFeedbackTooShort;

  /// No description provided for @wsFeedbackSent.
  ///
  /// In en, this message translates to:
  /// **'Thank you — sent'**
  String get wsFeedbackSent;

  /// No description provided for @wsFeedbackEarlier.
  ///
  /// In en, this message translates to:
  /// **'What you\'ve sent'**
  String get wsFeedbackEarlier;

  /// No description provided for @wsFeedbackReply.
  ///
  /// In en, this message translates to:
  /// **'TalkAcharya replied'**
  String get wsFeedbackReply;

  /// No description provided for @wsReplies.
  ///
  /// In en, this message translates to:
  /// **'Quick replies'**
  String get wsReplies;

  /// No description provided for @wsRepliesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Messages you send often, one tap away in every chat. The ones you use most rise to the top.'**
  String get wsRepliesSubtitle;

  /// No description provided for @wsRepliesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No quick replies yet'**
  String get wsRepliesEmpty;

  /// No description provided for @wsReplyNew.
  ///
  /// In en, this message translates to:
  /// **'New quick reply'**
  String get wsReplyNew;

  /// No description provided for @wsReplyHint.
  ///
  /// In en, this message translates to:
  /// **'Namaste! Please share your date, time and place of birth.'**
  String get wsReplyHint;

  /// No description provided for @wsReplyUsed.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Used once} other{Used {count} times}}'**
  String wsReplyUsed(int count);

  /// No description provided for @wsCalendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get wsCalendar;

  /// No description provided for @wsCalendarSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your working hours and scheduled lives for the next two weeks.'**
  String get wsCalendarSubtitle;

  /// No description provided for @wsCalendarWorking.
  ///
  /// In en, this message translates to:
  /// **'Working hours'**
  String get wsCalendarWorking;

  /// No description provided for @wsCalendarLiveAt.
  ///
  /// In en, this message translates to:
  /// **'Live stream at {time}'**
  String wsCalendarLiveAt(String time);

  /// No description provided for @wsCalendarDayOff.
  ///
  /// In en, this message translates to:
  /// **'Day off'**
  String get wsCalendarDayOff;

  /// No description provided for @wsCalendarDayOffBody.
  ///
  /// In en, this message translates to:
  /// **'No working hours set for this day.'**
  String get wsCalendarDayOffBody;

  /// No description provided for @wsCalendarNoHours.
  ///
  /// In en, this message translates to:
  /// **'No fixed hours'**
  String get wsCalendarNoHours;

  /// No description provided for @wsCalendarNoHoursBody.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t set working hours, so customers can reach you whenever you\'re online.'**
  String get wsCalendarNoHoursBody;

  /// No description provided for @wsCalendarEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit working hours'**
  String get wsCalendarEdit;

  /// No description provided for @wsCalendarNote.
  ///
  /// In en, this message translates to:
  /// **'Outside your working hours you show as away, even with the app open.'**
  String get wsCalendarNote;

  /// No description provided for @wsHelpline.
  ///
  /// In en, this message translates to:
  /// **'Helpline'**
  String get wsHelpline;

  /// No description provided for @wsHelpWhatsapp.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp us'**
  String get wsHelpWhatsapp;

  /// No description provided for @wsHelpEmail.
  ///
  /// In en, this message translates to:
  /// **'Email us'**
  String get wsHelpEmail;

  /// No description provided for @wsHelpCentre.
  ///
  /// In en, this message translates to:
  /// **'Help centre'**
  String get wsHelpCentre;

  /// No description provided for @wsHelpCentreSub.
  ///
  /// In en, this message translates to:
  /// **'Answers to common questions'**
  String get wsHelpCentreSub;

  /// No description provided for @wsHelpNone.
  ///
  /// In en, this message translates to:
  /// **'Support contact details aren\'t available right now.'**
  String get wsHelpNone;

  /// No description provided for @wsPhotoPending.
  ///
  /// In en, this message translates to:
  /// **'In review'**
  String get wsPhotoPending;

  /// No description provided for @wsPhotoRejected.
  ///
  /// In en, this message translates to:
  /// **'Not approved\nTap for why'**
  String get wsPhotoRejected;

  /// No description provided for @wsGalleryReviewed.
  ///
  /// In en, this message translates to:
  /// **'New photos are reviewed before customers see them. This usually takes a day.'**
  String get wsGalleryReviewed;

  /// No description provided for @ccTool.
  ///
  /// In en, this message translates to:
  /// **'Kundli'**
  String get ccTool;

  /// No description provided for @ccTitle.
  ///
  /// In en, this message translates to:
  /// **'Kundli'**
  String get ccTitle;

  /// No description provided for @ccSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Charts you cast yourself — a walk-in, a phone client, family. Only you see them.'**
  String get ccSubtitle;

  /// No description provided for @ccNew.
  ///
  /// In en, this message translates to:
  /// **'New chart'**
  String get ccNew;

  /// No description provided for @ccEmpty.
  ///
  /// In en, this message translates to:
  /// **'No charts yet'**
  String get ccEmpty;

  /// No description provided for @ccEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Add someone\'s birth details to see their full kundali: charts, dasha, yogas, doshas and more.'**
  String get ccEmptyBody;

  /// No description provided for @ccMoonSign.
  ///
  /// In en, this message translates to:
  /// **'Moon in {sign}'**
  String ccMoonSign(String sign);

  /// No description provided for @ccDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove {name}?'**
  String ccDeleteTitle(String name);

  /// No description provided for @ccDeleteBody.
  ///
  /// In en, this message translates to:
  /// **'Their chart is removed from your list. Matches you ran with it go too.'**
  String get ccDeleteBody;

  /// No description provided for @ccName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get ccName;

  /// No description provided for @ccMale.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get ccMale;

  /// No description provided for @ccFemale.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get ccFemale;

  /// No description provided for @ccOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get ccOther;

  /// No description provided for @ccBirthDate.
  ///
  /// In en, this message translates to:
  /// **'Date of birth'**
  String get ccBirthDate;

  /// No description provided for @ccBirthTime.
  ///
  /// In en, this message translates to:
  /// **'Time of birth'**
  String get ccBirthTime;

  /// No description provided for @ccTimeUnknown.
  ///
  /// In en, this message translates to:
  /// **'Time of birth not known'**
  String get ccTimeUnknown;

  /// No description provided for @ccTimeUnknownHint.
  ///
  /// In en, this message translates to:
  /// **'The lagna and houses can\'t be trusted without it; planets and the Moon sign still can.'**
  String get ccTimeUnknownHint;

  /// No description provided for @ccBirthPlace.
  ///
  /// In en, this message translates to:
  /// **'Place of birth'**
  String get ccBirthPlace;

  /// No description provided for @ccSave.
  ///
  /// In en, this message translates to:
  /// **'Cast chart'**
  String get ccSave;

  /// No description provided for @mmTitle.
  ///
  /// In en, this message translates to:
  /// **'Matchmaking'**
  String get mmTitle;

  /// No description provided for @mmSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Guna Milan between two of your saved charts.'**
  String get mmSubtitle;

  /// No description provided for @mmBoy.
  ///
  /// In en, this message translates to:
  /// **'Boy'**
  String get mmBoy;

  /// No description provided for @mmGirl.
  ///
  /// In en, this message translates to:
  /// **'Girl'**
  String get mmGirl;

  /// No description provided for @mmRun.
  ///
  /// In en, this message translates to:
  /// **'Match kundlis'**
  String get mmRun;

  /// No description provided for @mmRecent.
  ///
  /// In en, this message translates to:
  /// **'Recent matches'**
  String get mmRecent;

  /// No description provided for @mmNeedTwo.
  ///
  /// In en, this message translates to:
  /// **'Add two charts first'**
  String get mmNeedTwo;

  /// No description provided for @mmNeedTwoBody.
  ///
  /// In en, this message translates to:
  /// **'Matchmaking compares two saved charts. Add the boy\'s and the girl\'s birth details to begin.'**
  String get mmNeedTwoBody;

  /// No description provided for @remediesTabStore.
  ///
  /// In en, this message translates to:
  /// **'From the store'**
  String get remediesTabStore;

  /// No description provided for @remediesTabFree.
  ///
  /// In en, this message translates to:
  /// **'Free advice'**
  String get remediesTabFree;

  /// No description provided for @adviceTitle.
  ///
  /// In en, this message translates to:
  /// **'Advise a free remedy'**
  String get adviceTitle;

  /// No description provided for @adviceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A mantra, a fast, a charity — something that costs them nothing to follow.'**
  String get adviceSubtitle;

  /// No description provided for @adviceListSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Remedies you\'ve advised that cost nothing to follow. Each one went to the customer in their chat.'**
  String get adviceListSubtitle;

  /// No description provided for @adviceEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No free advice yet'**
  String get adviceEmptyTitle;

  /// No description provided for @adviceEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Advise a mantra, a fast or a charity after a reading. It reaches the customer as a message they can keep.'**
  String get adviceEmptyBody;

  /// No description provided for @adviceStepLibrary.
  ///
  /// In en, this message translates to:
  /// **'Pick from the library'**
  String get adviceStepLibrary;

  /// No description provided for @adviceStepWrite.
  ///
  /// In en, this message translates to:
  /// **'Or write your own'**
  String get adviceStepWrite;

  /// No description provided for @adviceLibraryEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing in the library for this yet — write your own below.'**
  String get adviceLibraryEmpty;

  /// No description provided for @adviceFieldTitle.
  ///
  /// In en, this message translates to:
  /// **'Remedy'**
  String get adviceFieldTitle;

  /// No description provided for @adviceFieldBody.
  ///
  /// In en, this message translates to:
  /// **'How to do it'**
  String get adviceFieldBody;

  /// No description provided for @adviceHowSent.
  ///
  /// In en, this message translates to:
  /// **'This is sent to the customer as a message in your chat, so the chat has to be open: during a session, or in the follow-up window after it.'**
  String get adviceHowSent;

  /// No description provided for @adviceSend.
  ///
  /// In en, this message translates to:
  /// **'Send advice'**
  String get adviceSend;

  /// No description provided for @adviceSent.
  ///
  /// In en, this message translates to:
  /// **'Advice sent'**
  String get adviceSent;

  /// No description provided for @adviceCatMantra.
  ///
  /// In en, this message translates to:
  /// **'Mantra'**
  String get adviceCatMantra;

  /// No description provided for @adviceCatStotra.
  ///
  /// In en, this message translates to:
  /// **'Stotra'**
  String get adviceCatStotra;

  /// No description provided for @adviceCatDaan.
  ///
  /// In en, this message translates to:
  /// **'Daan'**
  String get adviceCatDaan;

  /// No description provided for @adviceCatVrat.
  ///
  /// In en, this message translates to:
  /// **'Vrat'**
  String get adviceCatVrat;

  /// No description provided for @adviceCatPuja.
  ///
  /// In en, this message translates to:
  /// **'Puja'**
  String get adviceCatPuja;

  /// No description provided for @adviceCatLifestyle.
  ///
  /// In en, this message translates to:
  /// **'Lifestyle'**
  String get adviceCatLifestyle;

  /// No description provided for @poojaTool.
  ///
  /// In en, this message translates to:
  /// **'Mandir puja'**
  String get poojaTool;

  /// No description provided for @poojaBookingsTool.
  ///
  /// In en, this message translates to:
  /// **'My bookings'**
  String get poojaBookingsTool;

  /// No description provided for @poojaCalendarTitle.
  ///
  /// In en, this message translates to:
  /// **'Mandir puja'**
  String get poojaCalendarTitle;

  /// No description provided for @poojaCalendarSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Poojas open for booking, soonest first. Suggest one to a customer — you earn a commission when they book.'**
  String get poojaCalendarSubtitle;

  /// No description provided for @poojaCalendarEmpty.
  ///
  /// In en, this message translates to:
  /// **'No poojas scheduled'**
  String get poojaCalendarEmpty;

  /// No description provided for @poojaCalendarEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'When partner temples open dates for booking, they\'ll appear here.'**
  String get poojaCalendarEmptyBody;

  /// No description provided for @poojaFrom.
  ///
  /// In en, this message translates to:
  /// **'From {price}'**
  String poojaFrom(String price);

  /// No description provided for @poojaSeatsLeft.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 place left} other{{count} places left}}'**
  String poojaSeatsLeft(int count);

  /// No description provided for @poojaSuggest.
  ///
  /// In en, this message translates to:
  /// **'Suggest to a customer'**
  String get poojaSuggest;

  /// No description provided for @poojaBookingsTitle.
  ///
  /// In en, this message translates to:
  /// **'My bookings'**
  String get poojaBookingsTitle;

  /// No description provided for @poojaBookingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Poojas your customers booked on your suggestion, and where each one stands.'**
  String get poojaBookingsSubtitle;

  /// No description provided for @poojaBookingsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No bookings yet'**
  String get poojaBookingsEmpty;

  /// No description provided for @poojaBookingsEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'When a customer books a pooja you suggested, it shows up here.'**
  String get poojaBookingsEmptyBody;

  /// No description provided for @poojaStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Payment pending'**
  String get poojaStatusPending;

  /// No description provided for @poojaStatusConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Booked'**
  String get poojaStatusConfirmed;

  /// No description provided for @poojaStatusPerformed.
  ///
  /// In en, this message translates to:
  /// **'Performed'**
  String get poojaStatusPerformed;

  /// No description provided for @poojaStatusDone.
  ///
  /// In en, this message translates to:
  /// **'Video shared'**
  String get poojaStatusDone;

  /// No description provided for @poojaStatusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get poojaStatusCancelled;

  /// No description provided for @poojaNextDate.
  ///
  /// In en, this message translates to:
  /// **'Next available date'**
  String get poojaNextDate;

  /// No description provided for @offerTitle.
  ///
  /// In en, this message translates to:
  /// **'Offers'**
  String get offerTitle;

  /// No description provided for @offerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Put a discount on your rates for a while to bring customers in.'**
  String get offerSubtitle;

  /// No description provided for @offerPickPercent.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get offerPickPercent;

  /// No description provided for @offerPickDuration.
  ///
  /// In en, this message translates to:
  /// **'Runs for'**
  String get offerPickDuration;

  /// No description provided for @offerPickAudience.
  ///
  /// In en, this message translates to:
  /// **'Who gets it'**
  String get offerPickAudience;

  /// No description provided for @offerPickChannels.
  ///
  /// In en, this message translates to:
  /// **'On which sessions'**
  String get offerPickChannels;

  /// No description provided for @offerChannelsHint.
  ///
  /// In en, this message translates to:
  /// **'Pick none to cover chat, voice and video.'**
  String get offerChannelsHint;

  /// No description provided for @offerPercentOff.
  ///
  /// In en, this message translates to:
  /// **'{percent}% off'**
  String offerPercentOff(int percent);

  /// No description provided for @offerHours.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 hour} other{{count} hours}}'**
  String offerHours(int count);

  /// No description provided for @offerDays.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day} other{{count} days}}'**
  String offerDays(int count);

  /// No description provided for @offerAudienceAll.
  ///
  /// In en, this message translates to:
  /// **'Everyone'**
  String get offerAudienceAll;

  /// No description provided for @offerAudienceNew.
  ///
  /// In en, this message translates to:
  /// **'New customers'**
  String get offerAudienceNew;

  /// No description provided for @offerAllChannels.
  ///
  /// In en, this message translates to:
  /// **'All sessions'**
  String get offerAllChannels;

  /// No description provided for @offerChannelChat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get offerChannelChat;

  /// No description provided for @offerChannelVoice.
  ///
  /// In en, this message translates to:
  /// **'Voice'**
  String get offerChannelVoice;

  /// No description provided for @offerChannelVideo.
  ///
  /// In en, this message translates to:
  /// **'Video'**
  String get offerChannelVideo;

  /// No description provided for @offerWhoPays.
  ///
  /// In en, this message translates to:
  /// **'The discount comes out of your rate: while the offer runs, sessions are billed at the lower price and your earnings follow it. Customers see the offer on your profile.'**
  String get offerWhoPays;

  /// No description provided for @offerStart.
  ///
  /// In en, this message translates to:
  /// **'Start offer'**
  String get offerStart;

  /// No description provided for @offerStarted.
  ///
  /// In en, this message translates to:
  /// **'Your offer is live'**
  String get offerStarted;

  /// No description provided for @offerLiveBadge.
  ///
  /// In en, this message translates to:
  /// **'LIVE NOW'**
  String get offerLiveBadge;

  /// No description provided for @offerEndsAt.
  ///
  /// In en, this message translates to:
  /// **'Ends {when}'**
  String offerEndsAt(String when);

  /// No description provided for @offerSessions.
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get offerSessions;

  /// No description provided for @offerEarned.
  ///
  /// In en, this message translates to:
  /// **'Earned'**
  String get offerEarned;

  /// No description provided for @offerSessionCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 session} other{{count} sessions}}'**
  String offerSessionCount(int count);

  /// No description provided for @offerEnd.
  ///
  /// In en, this message translates to:
  /// **'End offer'**
  String get offerEnd;

  /// No description provided for @offerEndTitle.
  ///
  /// In en, this message translates to:
  /// **'End this offer now?'**
  String get offerEndTitle;

  /// No description provided for @offerEndBody.
  ///
  /// In en, this message translates to:
  /// **'New sessions go back to your normal rates. Sessions already booked keep the offer price.'**
  String get offerEndBody;

  /// No description provided for @offerEarlier.
  ///
  /// In en, this message translates to:
  /// **'Earlier offers'**
  String get offerEarlier;

  /// No description provided for @offerOffTitle.
  ///
  /// In en, this message translates to:
  /// **'Offers are paused'**
  String get offerOffTitle;

  /// No description provided for @offerOffBody.
  ///
  /// In en, this message translates to:
  /// **'Offers are switched off for now. Check back later.'**
  String get offerOffBody;

  /// No description provided for @perfPromoTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome-offer customers'**
  String get perfPromoTitle;

  /// No description provided for @perfPromoBody.
  ///
  /// In en, this message translates to:
  /// **'New customers on the platform\'s welcome offer. You are paid your full rate for these sessions.'**
  String get perfPromoBody;

  /// No description provided for @perfPromoSessions.
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get perfPromoSessions;

  /// No description provided for @perfPromoRating.
  ///
  /// In en, this message translates to:
  /// **'Their rating'**
  String get perfPromoRating;

  /// No description provided for @perfPromoRepeat.
  ///
  /// In en, this message translates to:
  /// **'Came back ({returned} of {customers})'**
  String perfPromoRepeat(int returned, int customers);

  /// No description provided for @callSetupTitle.
  ///
  /// In en, this message translates to:
  /// **'Ring on a locked phone'**
  String get callSetupTitle;

  /// No description provided for @callSetupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Make sure consultation calls ring this phone even with the screen off.'**
  String get callSetupSubtitle;

  /// No description provided for @callSetupMenuSub.
  ///
  /// In en, this message translates to:
  /// **'Check that calls reach you with the screen off'**
  String get callSetupMenuSub;

  /// No description provided for @callSetupReady.
  ///
  /// In en, this message translates to:
  /// **'This phone is set to ring for consultations, even locked.'**
  String get callSetupReady;

  /// No description provided for @callSetupNotReady.
  ///
  /// In en, this message translates to:
  /// **'Calls may not ring this phone with the screen off. Fix the items below.'**
  String get callSetupNotReady;

  /// No description provided for @callSetupNotAndroid.
  ///
  /// In en, this message translates to:
  /// **'Nothing to set up on this phone.'**
  String get callSetupNotAndroid;

  /// No description provided for @callSetupNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get callSetupNotifications;

  /// No description provided for @callSetupNotificationsHelp.
  ///
  /// In en, this message translates to:
  /// **'Allow notifications for TalkAcharya.'**
  String get callSetupNotificationsHelp;

  /// No description provided for @callSetupCallChannel.
  ///
  /// In en, this message translates to:
  /// **'Call ringing'**
  String get callSetupCallChannel;

  /// No description provided for @callSetupCallChannelHelp.
  ///
  /// In en, this message translates to:
  /// **'The \"Incoming consultations\" category must stay on, with sound.'**
  String get callSetupCallChannelHelp;

  /// No description provided for @callSetupFullScreen.
  ///
  /// In en, this message translates to:
  /// **'Show calls over the lock screen'**
  String get callSetupFullScreen;

  /// No description provided for @callSetupFullScreenHelp.
  ///
  /// In en, this message translates to:
  /// **'Lets a call fill the screen and wake the phone, like a phone call.'**
  String get callSetupFullScreenHelp;

  /// No description provided for @callSetupBattery.
  ///
  /// In en, this message translates to:
  /// **'Battery optimisation'**
  String get callSetupBattery;

  /// No description provided for @callSetupBatteryHelp.
  ///
  /// In en, this message translates to:
  /// **'Set TalkAcharya to \"Don\'t optimise\" / \"Unrestricted\" so a call can wake the app.'**
  String get callSetupBatteryHelp;

  /// No description provided for @callSetupAutostart.
  ///
  /// In en, this message translates to:
  /// **'Autostart (phone maker\'s setting)'**
  String get callSetupAutostart;

  /// No description provided for @callSetupAutostartHelp.
  ///
  /// In en, this message translates to:
  /// **'Your phone has its own switch that stops apps waking up. Turn it on for TalkAcharya.'**
  String get callSetupAutostartHelp;

  /// No description provided for @callSetupLockScreen.
  ///
  /// In en, this message translates to:
  /// **'Show on lock screen (Xiaomi)'**
  String get callSetupLockScreen;

  /// No description provided for @callSetupLockScreenHelp.
  ///
  /// In en, this message translates to:
  /// **'Under Other permissions, allow \"Show on lock screen\" and \"Display pop-up windows\".'**
  String get callSetupLockScreenHelp;

  /// No description provided for @callSetupFix.
  ///
  /// In en, this message translates to:
  /// **'Fix'**
  String get callSetupFix;

  /// No description provided for @callSetupCheck.
  ///
  /// In en, this message translates to:
  /// **'Check'**
  String get callSetupCheck;

  /// No description provided for @callSetupTestTitle.
  ///
  /// In en, this message translates to:
  /// **'Test it'**
  String get callSetupTestTitle;

  /// No description provided for @callSetupTestBody.
  ///
  /// In en, this message translates to:
  /// **'Tap the button, lock the phone and wait — it should ring like a call within about 10 seconds.'**
  String get callSetupTestBody;

  /// No description provided for @callSetupTestButton.
  ///
  /// In en, this message translates to:
  /// **'Send me a test call'**
  String get callSetupTestButton;

  /// No description provided for @callSetupTestSent.
  ///
  /// In en, this message translates to:
  /// **'Test call coming in {seconds} seconds — lock your phone now.'**
  String callSetupTestSent(int seconds);

  /// No description provided for @callSetupTestNoPhone.
  ///
  /// In en, this message translates to:
  /// **'This phone is not registered for calls yet. Open the app once with internet on, then try again.'**
  String get callSetupTestNoPhone;

  /// No description provided for @callSetupTestWorked.
  ///
  /// In en, this message translates to:
  /// **'The test call reached you. Calls will ring this phone.'**
  String get callSetupTestWorked;

  /// No description provided for @callSetupHomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Calls may not ring when your phone is locked'**
  String get callSetupHomeTitle;

  /// No description provided for @callSetupHomeBody.
  ///
  /// In en, this message translates to:
  /// **'Tap to fix a phone setting.'**
  String get callSetupHomeBody;

  /// No description provided for @authSessionReplaced.
  ///
  /// In en, this message translates to:
  /// **'You were signed out because your account was signed in on another phone.'**
  String get authSessionReplaced;

  /// No description provided for @appUpdateAvailable.
  ///
  /// In en, this message translates to:
  /// **'A new version of the app is available.'**
  String get appUpdateAvailable;

  /// No description provided for @appUpdateAction.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get appUpdateAction;

  /// No description provided for @appUpdateReady.
  ///
  /// In en, this message translates to:
  /// **'The update is downloaded. Restart to finish.'**
  String get appUpdateReady;

  /// No description provided for @appUpdateRestart.
  ///
  /// In en, this message translates to:
  /// **'Restart'**
  String get appUpdateRestart;

  /// No description provided for @nextOnlineSet.
  ///
  /// In en, this message translates to:
  /// **'Set next online'**
  String get nextOnlineSet;

  /// No description provided for @nextOnlineBack.
  ///
  /// In en, this message translates to:
  /// **'Back {when} · Change'**
  String nextOnlineBack(String when);

  /// No description provided for @nextOnlineSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'When will you take {channel} again?'**
  String nextOnlineSheetTitle(String channel);

  /// No description provided for @nextOnlineInfo.
  ///
  /// In en, this message translates to:
  /// **'{channel} stays off until then and comes back on by itself. Customers see when you will be back.'**
  String nextOnlineInfo(String channel);

  /// No description provided for @nextOnlineDay.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get nextOnlineDay;

  /// No description provided for @nextOnlineTime.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get nextOnlineTime;

  /// No description provided for @nextOnlineToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get nextOnlineToday;

  /// No description provided for @nextOnlineTomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get nextOnlineTomorrow;

  /// No description provided for @nextOnlineWhen.
  ///
  /// In en, this message translates to:
  /// **'{day}, {time}'**
  String nextOnlineWhen(String day, String time);

  /// No description provided for @nextOnlinePickDate.
  ///
  /// In en, this message translates to:
  /// **'Pick a date'**
  String get nextOnlinePickDate;

  /// No description provided for @nextOnlineCustomTime.
  ///
  /// In en, this message translates to:
  /// **'Other time'**
  String get nextOnlineCustomTime;

  /// No description provided for @nextOnlineConfirm.
  ///
  /// In en, this message translates to:
  /// **'Set next online'**
  String get nextOnlineConfirm;

  /// No description provided for @nextOnlineConfirmAt.
  ///
  /// In en, this message translates to:
  /// **'Back {when}'**
  String nextOnlineConfirmAt(String when);

  /// No description provided for @nextOnlineTurnOn.
  ///
  /// In en, this message translates to:
  /// **'Turn {channel} on now'**
  String nextOnlineTurnOn(String channel);

  /// No description provided for @nextOnlinePast.
  ///
  /// In en, this message translates to:
  /// **'Pick a time that is still ahead'**
  String get nextOnlinePast;

  /// No description provided for @nextOnlineDone.
  ///
  /// In en, this message translates to:
  /// **'{channel} is off until {when}'**
  String nextOnlineDone(String channel, String when);

  /// No description provided for @nextOnlineCleared.
  ///
  /// In en, this message translates to:
  /// **'{channel} is on again'**
  String nextOnlineCleared(String channel);

  /// No description provided for @incomingCallKind.
  ///
  /// In en, this message translates to:
  /// **'Incoming {channel} request'**
  String incomingCallKind(String channel);

  /// No description provided for @incomingCallCustomer.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get incomingCallCustomer;

  /// No description provided for @incomingCallHint.
  ///
  /// In en, this message translates to:
  /// **'A customer is waiting for you'**
  String get incomingCallHint;

  /// No description provided for @incomingCallTest.
  ///
  /// In en, this message translates to:
  /// **'Test call'**
  String get incomingCallTest;

  /// No description provided for @incomingCallTestHint.
  ///
  /// In en, this message translates to:
  /// **'This is how a consultation rings your phone'**
  String get incomingCallTestHint;

  /// No description provided for @incomingCallAccept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get incomingCallAccept;

  /// No description provided for @incomingCallDecline.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get incomingCallDecline;

  /// No description provided for @pubTitle.
  ///
  /// In en, this message translates to:
  /// **'Public profile'**
  String get pubTitle;

  /// No description provided for @pubMenuSub.
  ///
  /// In en, this message translates to:
  /// **'See your profile the way customers do'**
  String get pubMenuSub;

  /// No description provided for @pubNote.
  ///
  /// In en, this message translates to:
  /// **'This is how customers see your profile.'**
  String get pubNote;

  /// No description provided for @pubHidden.
  ///
  /// In en, this message translates to:
  /// **'Your profile is hidden from customers right now.'**
  String get pubHidden;

  /// No description provided for @pubEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get pubEdit;

  /// No description provided for @pubOnline.
  ///
  /// In en, this message translates to:
  /// **'Online now'**
  String get pubOnline;

  /// No description provided for @pubOffline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get pubOffline;

  /// No description provided for @pubPhotos.
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get pubPhotos;

  /// No description provided for @pubPhotosWaiting.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 more is waiting for review} other{{count} more are waiting for review}}'**
  String pubPhotosWaiting(int count);

  /// No description provided for @pubPhotosCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 photo} other{{count} photos}}'**
  String pubPhotosCount(int count);

  /// No description provided for @pubPhotoOf.
  ///
  /// In en, this message translates to:
  /// **'{index} of {total}'**
  String pubPhotoOf(int index, int total);

  /// No description provided for @pubPhotosEmpty.
  ///
  /// In en, this message translates to:
  /// **'No photos on your profile yet. Customers trust a profile they can see.'**
  String get pubPhotosEmpty;

  /// No description provided for @pubAddPhotos.
  ///
  /// In en, this message translates to:
  /// **'Add photos'**
  String get pubAddPhotos;

  /// No description provided for @pubManage.
  ///
  /// In en, this message translates to:
  /// **'Manage photos'**
  String get pubManage;

  /// No description provided for @pubSeeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get pubSeeAll;

  /// No description provided for @pubPerMinute.
  ///
  /// In en, this message translates to:
  /// **'{price}/min'**
  String pubPerMinute(String price);

  /// No description provided for @pubRatesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No rates set yet.'**
  String get pubRatesEmpty;

  /// No description provided for @pubExpertise.
  ///
  /// In en, this message translates to:
  /// **'Expertise'**
  String get pubExpertise;

  /// No description provided for @pubLanguages.
  ///
  /// In en, this message translates to:
  /// **'Languages'**
  String get pubLanguages;

  /// No description provided for @pubNothingYet.
  ///
  /// In en, this message translates to:
  /// **'Nothing added yet.'**
  String get pubNothingYet;

  /// No description provided for @pubAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get pubAbout;

  /// No description provided for @pubAboutEmpty.
  ///
  /// In en, this message translates to:
  /// **'Write a few lines about yourself, so customers know who they are talking to.'**
  String get pubAboutEmpty;

  /// No description provided for @pubReadMore.
  ///
  /// In en, this message translates to:
  /// **'Read more'**
  String get pubReadMore;

  /// No description provided for @pubReadLess.
  ///
  /// In en, this message translates to:
  /// **'Show less'**
  String get pubReadLess;

  /// No description provided for @pubReviews.
  ///
  /// In en, this message translates to:
  /// **'What clients say'**
  String get pubReviews;

  /// No description provided for @pubReviewsEmpty.
  ///
  /// In en, this message translates to:
  /// **'Your well-rated, written reviews will show here.'**
  String get pubReviewsEmpty;

  /// No description provided for @kycAadhaar.
  ///
  /// In en, this message translates to:
  /// **'Aadhaar card'**
  String get kycAadhaar;

  /// No description provided for @kycBankProof.
  ///
  /// In en, this message translates to:
  /// **'Bank proof'**
  String get kycBankProof;

  /// No description provided for @kycOtherDocument.
  ///
  /// In en, this message translates to:
  /// **'A required document'**
  String get kycOtherDocument;

  /// No description provided for @kycAadhaarInvalid.
  ///
  /// In en, this message translates to:
  /// **'Aadhaar has 12 digits'**
  String get kycAadhaarInvalid;

  /// No description provided for @kycNumberNeeded.
  ///
  /// In en, this message translates to:
  /// **'Enter the document number first'**
  String get kycNumberNeeded;

  /// No description provided for @kycDocVerified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get kycDocVerified;

  /// No description provided for @kycDocSentBack.
  ///
  /// In en, this message translates to:
  /// **'Sent back: please upload it again'**
  String get kycDocSentBack;

  /// No description provided for @kycDocNeeded.
  ///
  /// In en, this message translates to:
  /// **'Needed'**
  String get kycDocNeeded;

  /// No description provided for @kycDocOptional.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get kycDocOptional;

  /// No description provided for @kycDocWaiting.
  ///
  /// In en, this message translates to:
  /// **'Waiting for review'**
  String get kycDocWaiting;

  /// No description provided for @kycDocEndsIn.
  ///
  /// In en, this message translates to:
  /// **'ends in {digits}'**
  String kycDocEndsIn(String digits);

  /// No description provided for @kycDocReplace.
  ///
  /// In en, this message translates to:
  /// **'Replace'**
  String get kycDocReplace;

  /// No description provided for @kycDocNumber.
  ///
  /// In en, this message translates to:
  /// **'{document} number'**
  String kycDocNumber(String document);

  /// No description provided for @kycDocNumberKeep.
  ///
  /// In en, this message translates to:
  /// **'Leave empty to keep the one ending in {digits}'**
  String kycDocNumberKeep(String digits);

  /// No description provided for @kycDocAddPhoto.
  ///
  /// In en, this message translates to:
  /// **'Add a photo of it'**
  String get kycDocAddPhoto;

  /// No description provided for @kycDocReplacePhoto.
  ///
  /// In en, this message translates to:
  /// **'Upload a new photo'**
  String get kycDocReplacePhoto;

  /// No description provided for @wizDocsRequired.
  ///
  /// In en, this message translates to:
  /// **'Add every document marked as needed'**
  String get wizDocsRequired;

  /// No description provided for @obStageDocuments.
  ///
  /// In en, this message translates to:
  /// **'Documents being checked'**
  String get obStageDocuments;

  /// No description provided for @obStageInterview.
  ///
  /// In en, this message translates to:
  /// **'Interview'**
  String get obStageInterview;

  /// No description provided for @obStageDecision.
  ///
  /// In en, this message translates to:
  /// **'Final decision'**
  String get obStageDecision;

  /// No description provided for @obFixTitle.
  ///
  /// In en, this message translates to:
  /// **'Something needs your attention'**
  String get obFixTitle;

  /// No description provided for @obFixBody.
  ///
  /// In en, this message translates to:
  /// **'Our reviewer sent the items below back. Correct them and your application moves on.'**
  String get obFixBody;

  /// No description provided for @obBankFixTitle.
  ///
  /// In en, this message translates to:
  /// **'Your bank details need a correction'**
  String get obBankFixTitle;

  /// No description provided for @obBankFix.
  ///
  /// In en, this message translates to:
  /// **'Correct bank details'**
  String get obBankFix;

  /// No description provided for @obInterviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Your interview'**
  String get obInterviewTitle;

  /// No description provided for @obInterviewWhen.
  ///
  /// In en, this message translates to:
  /// **'{when}'**
  String obInterviewWhen(String when);

  /// No description provided for @obInterviewPhone.
  ///
  /// In en, this message translates to:
  /// **'We will call you on your registered number.'**
  String get obInterviewPhone;

  /// No description provided for @obInterviewWhatsapp.
  ///
  /// In en, this message translates to:
  /// **'We will call you on WhatsApp on your registered number.'**
  String get obInterviewWhatsapp;

  /// No description provided for @obInterviewLink.
  ///
  /// In en, this message translates to:
  /// **'Join with the meeting link below at that time.'**
  String get obInterviewLink;

  /// No description provided for @obInterviewJoin.
  ///
  /// In en, this message translates to:
  /// **'Open meeting link'**
  String get obInterviewJoin;

  /// No description provided for @obInterviewWaiting.
  ///
  /// In en, this message translates to:
  /// **'Your documents are in order. We will set a time for your interview and tell you.'**
  String get obInterviewWaiting;

  /// No description provided for @obInterviewMissed.
  ///
  /// In en, this message translates to:
  /// **'We missed you at your interview. We will set a new time and tell you.'**
  String get obInterviewMissed;

  /// No description provided for @obInterviewToday.
  ///
  /// In en, this message translates to:
  /// **'Today, {time}'**
  String obInterviewToday(String time);

  /// No description provided for @obInterviewTomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow, {time}'**
  String obInterviewTomorrow(String time);

  /// No description provided for @obInterviewOn.
  ///
  /// In en, this message translates to:
  /// **'{date}, {time}'**
  String obInterviewOn(String date, String time);

  /// No description provided for @reportsTitle.
  ///
  /// In en, this message translates to:
  /// **'Session reports'**
  String get reportsTitle;

  /// No description provided for @reportsMenuSub.
  ///
  /// In en, this message translates to:
  /// **'What customers reported, and your side of it'**
  String get reportsMenuSub;

  /// No description provided for @reportsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'When a customer reports a session, you see it here and can give your side before our team decides.'**
  String get reportsSubtitle;

  /// No description provided for @reportsDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get reportsDetailTitle;

  /// No description provided for @reportsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No reports'**
  String get reportsEmptyTitle;

  /// No description provided for @reportsEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'No customer has reported any of your sessions.'**
  String get reportsEmptyBody;

  /// No description provided for @reportsACustomer.
  ///
  /// In en, this message translates to:
  /// **'A customer'**
  String get reportsACustomer;

  /// No description provided for @reportsReplyNeeded.
  ///
  /// In en, this message translates to:
  /// **'Your reply is needed'**
  String get reportsReplyNeeded;

  /// No description provided for @reportsUnderReview.
  ///
  /// In en, this message translates to:
  /// **'Under review'**
  String get reportsUnderReview;

  /// No description provided for @reportsCleared.
  ///
  /// In en, this message translates to:
  /// **'No action taken'**
  String get reportsCleared;

  /// No description provided for @reportsDecided.
  ///
  /// In en, this message translates to:
  /// **'Decided'**
  String get reportsDecided;

  /// No description provided for @reportsWaitingTitle.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 report needs your reply} other{{count} reports need your reply}}'**
  String reportsWaitingTitle(int count);

  /// No description provided for @reportsWaitingBody.
  ///
  /// In en, this message translates to:
  /// **'Our team decides after hearing from you, or when the time runs out.'**
  String get reportsWaitingBody;

  /// No description provided for @reportsReplyBy.
  ///
  /// In en, this message translates to:
  /// **'Reply by {when}'**
  String reportsReplyBy(String when);

  /// No description provided for @reportsTypeBilling.
  ///
  /// In en, this message translates to:
  /// **'About the charge'**
  String get reportsTypeBilling;

  /// No description provided for @reportsTypeConduct.
  ///
  /// In en, this message translates to:
  /// **'About conduct'**
  String get reportsTypeConduct;

  /// No description provided for @reportsTypeQuality.
  ///
  /// In en, this message translates to:
  /// **'About the quality of the session'**
  String get reportsTypeQuality;

  /// No description provided for @reportsTypeNoShow.
  ///
  /// In en, this message translates to:
  /// **'Did not get the session'**
  String get reportsTypeNoShow;

  /// No description provided for @reportsTypeTechnical.
  ///
  /// In en, this message translates to:
  /// **'A technical problem'**
  String get reportsTypeTechnical;

  /// No description provided for @reportsTypeOther.
  ///
  /// In en, this message translates to:
  /// **'A report'**
  String get reportsTypeOther;

  /// No description provided for @reportsHeroReplyBody.
  ///
  /// In en, this message translates to:
  /// **'Tell us what happened in this session. Our team reads both sides before deciding.'**
  String get reportsHeroReplyBody;

  /// No description provided for @reportsHeroReplyBy.
  ///
  /// In en, this message translates to:
  /// **'Tell us what happened in this session by {when}. Our team reads both sides before deciding.'**
  String reportsHeroReplyBy(String when);

  /// No description provided for @reportsHeroReviewBody.
  ///
  /// In en, this message translates to:
  /// **'Our team is looking into it. You will be told as soon as it is decided.'**
  String get reportsHeroReviewBody;

  /// No description provided for @reportsHeroClearedBody.
  ///
  /// In en, this message translates to:
  /// **'Our team looked into it and took no action against you.'**
  String get reportsHeroClearedBody;

  /// No description provided for @reportsHeroDecidedBody.
  ///
  /// In en, this message translates to:
  /// **'Our team has decided this report. The outcome is below.'**
  String get reportsHeroDecidedBody;

  /// No description provided for @reportsSaidTitle.
  ///
  /// In en, this message translates to:
  /// **'What {name} said'**
  String reportsSaidTitle(String name);

  /// No description provided for @reportsFactSession.
  ///
  /// In en, this message translates to:
  /// **'Session'**
  String get reportsFactSession;

  /// No description provided for @reportsFactLength.
  ///
  /// In en, this message translates to:
  /// **'Length'**
  String get reportsFactLength;

  /// No description provided for @reportsFactBilled.
  ///
  /// In en, this message translates to:
  /// **'Billed'**
  String get reportsFactBilled;

  /// No description provided for @reportsMinutes.
  ///
  /// In en, this message translates to:
  /// **'{count} min'**
  String reportsMinutes(int count);

  /// No description provided for @reportsMySideTitle.
  ///
  /// In en, this message translates to:
  /// **'Your side'**
  String get reportsMySideTitle;

  /// No description provided for @reportsMySideHint.
  ///
  /// In en, this message translates to:
  /// **'Say what happened, in your own words.'**
  String get reportsMySideHint;

  /// No description provided for @reportsReplyHint.
  ///
  /// In en, this message translates to:
  /// **'For example: how long the session ran, what you covered, what went wrong and why.'**
  String get reportsReplyHint;

  /// No description provided for @reportsReplyNote.
  ///
  /// In en, this message translates to:
  /// **'This goes to our review team, not to the customer. You can reply once, so say everything you want considered.'**
  String get reportsReplyNote;

  /// No description provided for @reportsReplySend.
  ///
  /// In en, this message translates to:
  /// **'Send my reply'**
  String get reportsReplySend;

  /// No description provided for @reportsReplyTooShort.
  ///
  /// In en, this message translates to:
  /// **'Write at least a sentence about what happened'**
  String get reportsReplyTooShort;

  /// No description provided for @reportsReplySent.
  ///
  /// In en, this message translates to:
  /// **'Your reply has been sent to our team'**
  String get reportsReplySent;

  /// No description provided for @reportsSentAt.
  ///
  /// In en, this message translates to:
  /// **'Sent {when}'**
  String reportsSentAt(String when);

  /// No description provided for @reportsNoReply.
  ///
  /// In en, this message translates to:
  /// **'No reply was given before this was decided.'**
  String get reportsNoReply;

  /// No description provided for @reportsOutcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'What was decided'**
  String get reportsOutcomeTitle;

  /// No description provided for @reportsOutcomeNone.
  ///
  /// In en, this message translates to:
  /// **'No action was taken against you.'**
  String get reportsOutcomeNone;

  /// No description provided for @reportsOutcomeRefund.
  ///
  /// In en, this message translates to:
  /// **'The customer was refunded. Your earning for this session is unchanged.'**
  String get reportsOutcomeRefund;

  /// No description provided for @reportsOutcomePenalty.
  ///
  /// In en, this message translates to:
  /// **'The customer was refunded, and {amount} was deducted from your earnings.'**
  String reportsOutcomePenalty(String amount);

  /// No description provided for @reportsOutcomeNote.
  ///
  /// In en, this message translates to:
  /// **'Note from our team'**
  String get reportsOutcomeNote;
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
