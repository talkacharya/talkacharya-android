// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get navHome => 'Home';

  @override
  String get navRequests => 'Requests';

  @override
  String get navEarnings => 'Earnings';

  @override
  String get navChats => 'Chats';

  @override
  String get navProfile => 'Profile';

  @override
  String get commonOffline => 'You are offline';

  @override
  String get commonRetry => 'Retry';

  @override
  String get commonSeeAll => 'See all';

  @override
  String get commonNotifications => 'Notifications';

  @override
  String get dashGreeting => 'Namaste,';

  @override
  String get presenceOnline => 'You\'re online';

  @override
  String get presenceBusy => 'You\'re in a session';

  @override
  String get presenceAway => 'You\'re away';

  @override
  String get presenceOffline => 'You\'re offline';

  @override
  String get presenceOnlineHint => 'Customers can reach you now';

  @override
  String get presenceOfflineHint => 'Go online to start receiving requests';

  @override
  String presenceFollowersHint(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count followers are notified when you go online',
      one: '1 follower is notified when you go online',
    );
    return '$_temp0';
  }

  @override
  String get presenceGoOnline => 'Go online';

  @override
  String get presenceGoOffline => 'Go offline';

  @override
  String dashRequestsWaiting(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count requests waiting',
      one: '1 request waiting',
    );
    return '$_temp0';
  }

  @override
  String get dashRequestsHint => 'Respond quickly — requests expire';

  @override
  String get dashReview => 'Review';

  @override
  String get channelChat => 'Chat';

  @override
  String get channelCall => 'Voice call';

  @override
  String get channelVideo => 'Video call';

  @override
  String get dashActiveTitle => 'Ongoing sessions';

  @override
  String get dashResume => 'Resume';

  @override
  String get dashEarningsTitle => 'Net earnings';

  @override
  String dashLastDays(int days) {
    return 'Last $days days';
  }

  @override
  String dashPeriodChip(int days) {
    return '${days}D';
  }

  @override
  String dashGross(String amount) {
    return 'Gross $amount';
  }

  @override
  String dashFee(String amount) {
    return 'Platform fee $amount';
  }

  @override
  String get dashAvailable => 'Available to pay out';

  @override
  String dashPending(String amount) {
    return '$amount clearing';
  }

  @override
  String get dashNoTrend =>
      'Your earnings chart appears after your first sessions';

  @override
  String get dashPerformance => 'Performance';

  @override
  String get dashStatSessions => 'Sessions';

  @override
  String dashStatSessionsSub(int count) {
    return '$count requested';
  }

  @override
  String get dashStatMinutes => 'Minutes';

  @override
  String get dashStatMinutesSub => 'Billed talk time';

  @override
  String get dashStatAcceptance => 'Acceptance';

  @override
  String get dashStatAcceptanceSub => 'Requests answered';

  @override
  String get dashStatRating => 'Rating';

  @override
  String dashStatRatingSub(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count reviews',
      one: '1 review',
    );
    return '$_temp0';
  }

  @override
  String get dashStatRepeat => 'Repeat clients';

  @override
  String get dashStatRepeatSub => 'Came back for more';

  @override
  String get dashStatFollowers => 'Followers';

  @override
  String get dashStatFollowersSub => 'Notified when you\'re live';

  @override
  String get dashQuickActions => 'Quick actions';

  @override
  String get dashActionGoLive => 'Go live';

  @override
  String get dashActionPredictions => 'Predictions';

  @override
  String get dashActionRates => 'My rates';

  @override
  String get dashActionHours => 'Working hours';

  @override
  String get dashActionReviews => 'Reviews';

  @override
  String get dashActionPayouts => 'Payouts';

  @override
  String get dashProfileTitle => 'Profile strength';

  @override
  String get dashProfileHint => 'Complete profiles get more consultations';

  @override
  String get dashTipHeadline => 'Add a headline';

  @override
  String get dashTipBio => 'Write a detailed bio';

  @override
  String get dashTipBanner => 'Add a cover image';

  @override
  String get dashTipRates => 'Set your per-minute rates';

  @override
  String get dashTipLanguages => 'Add the languages you speak';

  @override
  String get dashTipSkills => 'Add at least 3 skills';

  @override
  String get dashLoadFailed => 'Couldn\'t load this section';

  @override
  String dashPerMin(String amount) {
    return '$amount/min';
  }

  @override
  String get requestsSubtitle => 'Respond before a request expires';

  @override
  String get requestsTabIncoming => 'Incoming';

  @override
  String get requestsTabActive => 'Active';

  @override
  String get requestsTabHistory => 'History';

  @override
  String get requestsAccept => 'Accept';

  @override
  String get requestsDecline => 'Decline';

  @override
  String requestsExpiresIn(int seconds) {
    return 'Expires in ${seconds}s';
  }

  @override
  String get requestsExpired => 'Expired';

  @override
  String get requestsEmptyOnlineTitle => 'Waiting for requests';

  @override
  String get requestsEmptyOnlineBody =>
      'You\'re online. New requests will appear here and pop up on your screen.';

  @override
  String get requestsActiveEmptyTitle => 'No live sessions';

  @override
  String get requestsActiveEmptyBody =>
      'Accepted requests stay here until the session ends.';

  @override
  String get requestsHistoryEmptyTitle => 'No completed sessions yet';

  @override
  String get requestsHistoryEmptyBody =>
      'Finished consultations and what you earned will show up here.';

  @override
  String requestsEarned(String amount) {
    return 'Earned $amount';
  }

  @override
  String requestsMinutes(int count) {
    return '$count min';
  }

  @override
  String get requestsLiveNow => 'Live now';

  @override
  String get requestsDeclineTitle => 'Why are you declining?';

  @override
  String get requestsDeclineBusy => 'Busy right now';

  @override
  String get requestsDeclineUnavailable => 'Not available';

  @override
  String get requestsDeclineExpertise => 'Outside my expertise';

  @override
  String get requestsActionFailed =>
      'Couldn\'t complete that. Please try again.';

  @override
  String requestsNewTitle(String channel) {
    return 'New $channel request';
  }

  @override
  String get requestsCustomerFallback => 'A customer';

  @override
  String get requestsLoadError => 'Couldn\'t load your requests';

  @override
  String get timeJustNow => 'Just now';

  @override
  String timeMinutesAgo(int n) {
    return '${n}m ago';
  }

  @override
  String timeHoursAgo(int n) {
    return '${n}h ago';
  }

  @override
  String get timeToday => 'Today';

  @override
  String get timeYesterday => 'Yesterday';

  @override
  String get statusRequested => 'Waiting';

  @override
  String get statusAccepted => 'Connecting';

  @override
  String get statusActive => 'Live';

  @override
  String get statusEnded => 'Completed';

  @override
  String get statusRejected => 'Declined';

  @override
  String get statusCancelled => 'Cancelled';

  @override
  String get statusExpired => 'Missed';

  @override
  String get statusNoShow => 'No-show';

  @override
  String get statusFailed => 'Failed';

  @override
  String get detailTitle => 'Consultation';

  @override
  String get detailLoadError => 'Couldn\'t load this consultation.';

  @override
  String get detailQuestion => 'Their question';

  @override
  String get detailSession => 'Session';

  @override
  String get detailRequestedAt => 'Requested';

  @override
  String get detailDuration => 'Billed time';

  @override
  String get detailRate => 'Your rate';

  @override
  String get detailCustomerPaid => 'Customer paid';

  @override
  String get detailYouEarned => 'You earned';

  @override
  String get detailRating => 'Customer rating';

  @override
  String get detailKundali => 'Customer\'s kundali';

  @override
  String get detailOpenChat => 'Open conversation';

  @override
  String get chatsSearch => 'Search by name';

  @override
  String chatsSubtitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count unread messages',
      one: '1 unread message',
      zero: 'No unread messages',
    );
    return '$_temp0';
  }

  @override
  String get chatsRecent => 'Recent';

  @override
  String get chatsEmptyTitle => 'No conversations yet';

  @override
  String get chatsEmptyBody =>
      'Chats with your customers appear here once you accept a request.';

  @override
  String chatsNoMatch(String query) {
    return 'No chats match “$query”';
  }

  @override
  String get chatsLoadError => 'Couldn\'t load your chats';

  @override
  String get earnClearing => 'Clearing';

  @override
  String get earnLifetime => 'Lifetime';

  @override
  String earnCycle(int days, String fee) {
    return 'Paid every $days days · $fee% platform fee';
  }

  @override
  String get earnTabLedger => 'Ledger';

  @override
  String get earnTabPayouts => 'Payouts';

  @override
  String get earnTabDocuments => 'Documents';

  @override
  String get earnKindAll => 'All';

  @override
  String get earnKindConsultation => 'Consultations';

  @override
  String get earnKindGift => 'Gifts';

  @override
  String get earnKindPrediction => 'Predictions';

  @override
  String get earnKindStore => 'Store sales';

  @override
  String get earnKindAffiliate => 'Referral commission';

  @override
  String get earnKindBonus => 'Bonus';

  @override
  String get earnKindAdjustment => 'Adjustment';

  @override
  String earnEntryFee(String percent, String amount) {
    return '$percent% fee on $amount';
  }

  @override
  String earnEntryClears(String date) {
    return 'Clears $date';
  }

  @override
  String get earnEntryReady => 'Ready for payout';

  @override
  String get earnEntryPaid => 'Paid out';

  @override
  String get earnLedgerEmptyTitle => 'No earnings yet';

  @override
  String get earnLedgerEmptyBody =>
      'Every consultation, gift and prediction you complete is recorded here.';

  @override
  String get earnLedgerFilteredEmpty => 'Nothing in this category yet';

  @override
  String get earnPayoutsEmptyTitle => 'No payouts yet';

  @override
  String get earnPayoutsEmptyBody =>
      'Cleared earnings are sent to your bank account every payout cycle.';

  @override
  String get earnDocsEmptyTitle => 'No documents yet';

  @override
  String get earnDocsEmptyBody =>
      'Earnings statements and TDS certificates appear here after your payouts.';

  @override
  String get earnLoadError => 'Couldn\'t load this list';

  @override
  String get payoutStatusPending => 'Scheduled';

  @override
  String get payoutStatusProcessing => 'Processing';

  @override
  String get payoutStatusPaid => 'Paid';

  @override
  String get payoutStatusFailed => 'Failed';

  @override
  String get payoutStatusOnHold => 'On hold';

  @override
  String get payoutStatusCancelled => 'Cancelled';

  @override
  String payoutEntries(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count earnings',
      one: '1 earning',
    );
    return '$_temp0';
  }

  @override
  String payoutPaidOn(String date) {
    return 'Paid $date';
  }

  @override
  String get docKindCustomerInvoice => 'Customer invoice';

  @override
  String get docKindAstrologerInvoice => 'Earnings statement';

  @override
  String get docKindTds => 'TDS certificate';

  @override
  String get docKindGst => 'GST invoice';

  @override
  String get docKindCreditNote => 'Credit note';

  @override
  String get docKindStore => 'Store tax invoice';

  @override
  String docTax(String amount) {
    return 'Tax $amount';
  }

  @override
  String get docDownloadFailed => 'Couldn\'t download this document';

  @override
  String get payoutTitle => 'Payout';

  @override
  String get payoutLoadError => 'Couldn\'t load this payout.';

  @override
  String get payoutBreakdown => 'Breakdown';

  @override
  String get payoutGross => 'Your earnings';

  @override
  String get payoutTds => 'TDS deducted';

  @override
  String get payoutOther => 'Other deductions';

  @override
  String get payoutNet => 'Sent to your bank';

  @override
  String get payoutTimeline => 'Status';

  @override
  String get payoutStepScheduled => 'Payout scheduled';

  @override
  String get payoutStepInitiated => 'Bank transfer started';

  @override
  String get payoutStepPaid => 'Credited to your bank';

  @override
  String get payoutStepFailed => 'Transfer failed';

  @override
  String get payoutStepOnHold => 'On hold — our team is reviewing it';

  @override
  String get payoutStepCancelled => 'Payout cancelled';

  @override
  String get payoutUtr => 'Bank reference (UTR)';

  @override
  String get payoutCopied => 'Copied';

  @override
  String get payoutIncluded => 'Included earnings';

  @override
  String get payoutCopy => 'Copy';

  @override
  String get commonSave => 'Save';

  @override
  String get commonSaved => 'Saved';

  @override
  String get commonSaveFailed => 'Couldn\'t save. Please try again.';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonRequired => 'Required';

  @override
  String get commonLoadFailed => 'Couldn\'t load this page';

  @override
  String get verifUnverified => 'Not verified';

  @override
  String get verifSubmitted => 'Under review';

  @override
  String get verifVerified => 'Verified';

  @override
  String get verifFeatured => 'Featured';

  @override
  String get verifUnverifiedHint =>
      'Submit your documents to earn the verified badge.';

  @override
  String get verifSubmittedHint =>
      'Our team is reviewing your documents. This usually takes 1–2 days.';

  @override
  String get verifVerifiedHint =>
      'Your identity is verified. Customers see a verified badge on your profile.';

  @override
  String get profileStatYears => 'Years';

  @override
  String get profileChangePhoto => 'Change photo';

  @override
  String get profilePhotoUpdated => 'Photo updated';

  @override
  String get profilePhotoFailed => 'Couldn\'t update your photo';

  @override
  String get profileGroupPractice => 'Your practice';

  @override
  String get profileGroupGrowth => 'Grow';

  @override
  String get profileGroupAccount => 'Account';

  @override
  String get profileGroupSupport => 'Help & legal';

  @override
  String get profileEdit => 'Edit profile';

  @override
  String get profileEditSub => 'Cover, bio, expertise and languages';

  @override
  String get profileRates => 'Rates';

  @override
  String get profileRatesSub => 'What customers pay per minute';

  @override
  String get profileHours => 'Availability & hours';

  @override
  String get profileHoursSub => 'Consultation types and weekly schedule';

  @override
  String get profileGoLiveSub => 'Broadcast to your followers';

  @override
  String get profilePredictionsSub => 'Write the forecasts customers ordered';

  @override
  String get profileFeatured => 'Featured slots';

  @override
  String get profileFeaturedSub => 'Get promoted in the customer app';

  @override
  String get profileKyc => 'KYC & bank';

  @override
  String get profileKycSub => 'Verification documents and payout account';

  @override
  String get profileLanguage => 'App language';

  @override
  String get profileHelp => 'Help centre';

  @override
  String get profileContact => 'Contact support';

  @override
  String get profileTerms => 'Terms of service';

  @override
  String get profilePrivacy => 'Privacy policy';

  @override
  String get profileLogout => 'Log out';

  @override
  String get profileLogoutTitle => 'Log out?';

  @override
  String get profileLogoutBody =>
      'You\'ll need to sign in again with your phone number.';

  @override
  String profileVersion(String version) {
    return 'Version $version';
  }

  @override
  String get editCover => 'Profile cover';

  @override
  String get editCoverHint =>
      'Shown behind your photo on your public profile. Wide images (about 3:1) work best.';

  @override
  String get editCoverChange => 'Change cover';

  @override
  String get editCoverRemove => 'Remove';

  @override
  String get editCoverFailed =>
      'Couldn\'t upload the cover. Use a JPG or PNG under 5 MB.';

  @override
  String get editAbout => 'About you';

  @override
  String get editDisplayName => 'Display name';

  @override
  String get editHeadline => 'Headline';

  @override
  String get editHeadlineHint => 'e.g. Vedic astrologer · Career & marriage';

  @override
  String get editBio => 'Bio';

  @override
  String get editBioHint => 'Tell customers about your approach and experience';

  @override
  String editBioShort(int count) {
    return '$count more characters for a strong bio';
  }

  @override
  String get editYears => 'Years of experience';

  @override
  String get editExpertise => 'Expertise';

  @override
  String get editExpertiseHint =>
      'Tap to select. Long-press a selected skill to make it primary.';

  @override
  String get editPrimary => 'Primary';

  @override
  String get editLanguages => 'Languages you speak';

  @override
  String get editDiscardTitle => 'Discard changes?';

  @override
  String get editDiscard => 'Discard';

  @override
  String get editKeepEditing => 'Keep editing';

  @override
  String get ratesSubtitle =>
      'What customers pay per minute. Changes apply to new sessions.';

  @override
  String ratesAllowed(String min, String max) {
    return 'Allowed $min – $max';
  }

  @override
  String ratesYouEarn(String amount, String fee) {
    return 'You earn about $amount/min after the $fee% platform fee';
  }

  @override
  String ratesSuggested(String amount) {
    return 'Suggested $amount';
  }

  @override
  String get ratesNotOffered => 'Not offered on the platform yet';

  @override
  String ratesSaveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Save $count changes',
      one: 'Save 1 change',
    );
    return '$_temp0';
  }

  @override
  String get ratesUpdated => 'Rates updated';

  @override
  String get hoursChannels => 'Consultation types';

  @override
  String get hoursChannelsHint =>
      'Customers can only request the types you accept.';

  @override
  String get hoursNeedChannel => 'Keep at least one consultation type on';

  @override
  String get hoursConcurrent => 'Chats at the same time';

  @override
  String get hoursConcurrentHint =>
      'How many chat sessions you can handle at once';

  @override
  String get hoursSchedule => 'Weekly schedule';

  @override
  String get hoursScheduleHint =>
      'Shown to customers as your usual hours. You still go online yourself.';

  @override
  String get hoursOff => 'Off';

  @override
  String get hoursCopyToAll => 'Copy to all days';

  @override
  String get hoursInvalid => 'End time must be after start time';

  @override
  String reviewsBasedOn(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Based on $count reviews',
      one: 'Based on 1 review',
    );
    return '$_temp0';
  }

  @override
  String get reviewsFilterUnreplied => 'Needs reply';

  @override
  String get reviewsFilterLow => '3★ and below';

  @override
  String get reviewsFilterTop => '5★';

  @override
  String get reviewsReply => 'Reply';

  @override
  String get reviewsYourReply => 'Your reply';

  @override
  String get reviewsReplyHint =>
      'Thank them or respond to their feedback. Replies are public.';

  @override
  String get reviewsPost => 'Post reply';

  @override
  String get reviewsReplyFailed => 'Couldn\'t post your reply';

  @override
  String get reviewsPending => 'Awaiting moderation';

  @override
  String get reviewsHidden => 'Hidden';

  @override
  String get reviewsAnonymous => 'Customer';

  @override
  String get reviewsEmptyTitle => 'No reviews yet';

  @override
  String get reviewsEmptyBody =>
      'Customers can rate you after each consultation.';

  @override
  String get reviewsNoMatch => 'No reviews match this filter';

  @override
  String reviewsHelpful(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count people found this helpful',
      one: '1 person found this helpful',
    );
    return '$_temp0';
  }

  @override
  String get kycStatus => 'Verification';

  @override
  String get kycPan => 'PAN card';

  @override
  String get kycPanHint => 'Re-submit if your PAN changed or was flagged.';

  @override
  String get kycPanLabel => 'PAN number';

  @override
  String get kycPanInvalid => 'Enter a valid PAN, e.g. ABCDE1234F';

  @override
  String get kycSubmit => 'Submit';

  @override
  String get kycSubmitted => 'Submitted for verification';

  @override
  String get kycPhoto => 'Identity photo';

  @override
  String get kycPhotoHint => 'A clear, recent photo of your face.';

  @override
  String get kycUploadPhoto => 'Upload photo';

  @override
  String get kycCertificate => 'Certificates';

  @override
  String get kycCertificateHint =>
      'Astrology qualifications build trust and help you get featured.';

  @override
  String get kycUploadCertificate => 'Upload certificate';

  @override
  String get kycBank => 'Payout bank account';

  @override
  String get kycBankHint =>
      'Your earnings are paid to this account. Changes are verified before your next payout.';

  @override
  String get kycHolder => 'Account holder name';

  @override
  String get kycAccount => 'Account number';

  @override
  String get kycAccountConfirm => 'Re-enter account number';

  @override
  String get kycAccountMismatch => 'Account numbers don\'t match';

  @override
  String get kycIfsc => 'IFSC code';

  @override
  String get kycIfscInvalid => 'Enter a valid IFSC, e.g. HDFC0001234';

  @override
  String get kycBankName => 'Bank name (optional)';

  @override
  String get kycBankSave => 'Update bank account';

  @override
  String get kycBankSaved => 'Bank account updated';

  @override
  String get featIntro =>
      'Appear in prime spots of the customer app. Our team reviews each request; the fee is deducted from your earnings once it\'s approved.';

  @override
  String get featHomeHero => 'Home spotlight';

  @override
  String get featHomeHeroSub => 'Top of the customer home screen';

  @override
  String get featCategoryTop => 'Top of a category';

  @override
  String get featCategoryTopSub => 'First in one expertise\'s list';

  @override
  String get featSearchBoost => 'Search boost';

  @override
  String get featSearchBoostSub => 'Higher in search and astrologer lists';

  @override
  String featPerDay(String amount) {
    return '$amount/day';
  }

  @override
  String get featRequest => 'Request a slot';

  @override
  String get featDates => 'Dates';

  @override
  String get featPickDates => 'Choose dates';

  @override
  String featMaxDays(int days) {
    return 'Up to $days days per slot';
  }

  @override
  String get featCategory => 'Category';

  @override
  String featTotal(String amount, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days',
      one: '1 day',
    );
    return '$amount for $_temp0';
  }

  @override
  String get featSend => 'Send request';

  @override
  String get featSent => 'Request sent. We\'ll notify you once it\'s reviewed.';

  @override
  String get featMine => 'Your slots';

  @override
  String get featEmpty => 'You haven\'t requested any slots yet';

  @override
  String get featStatusRequested => 'Under review';

  @override
  String get featStatusScheduled => 'Scheduled';

  @override
  String get featStatusExpired => 'Ended';

  @override
  String get notifMarkAll => 'Mark all read';

  @override
  String get notifMarkRead => 'Mark read';

  @override
  String get notifFilterUnread => 'Unread';

  @override
  String get notifEmptyTitle => 'You\'re all caught up';

  @override
  String get notifEmptyBody =>
      'Requests, payouts and reviews will show up here.';

  @override
  String get notifUnreadEmpty => 'No unread notifications';

  @override
  String get notifLoadError => 'Couldn\'t load notifications';

  @override
  String get obTitle => 'Become a TalkAcharya astrologer';

  @override
  String obWelcome(String name) {
    return 'Welcome, $name';
  }

  @override
  String get obWelcomeBody =>
      'Complete these steps and submit your profile. Most astrologers finish in about 10 minutes.';

  @override
  String get obStepProfile => 'Your profile';

  @override
  String get obStepProfileSub => 'Headline, bio and experience';

  @override
  String get obStepExpertise => 'Expertise & languages';

  @override
  String get obStepExpertiseSub => 'What you practise and speak';

  @override
  String get obStepIdentity => 'Identity verification';

  @override
  String get obStepIdentitySub => 'PAN and a clear photo';

  @override
  String get obStepBank => 'Payout account';

  @override
  String get obStepBankSub => 'Where we send your earnings';

  @override
  String get obStepReview => 'Review & submit';

  @override
  String get obStepReviewSub => 'Send your profile to our team';

  @override
  String obProgress(int done, int total) {
    return '$done of $total done';
  }

  @override
  String get obStart => 'Get started';

  @override
  String get obContinue => 'Continue';

  @override
  String get obRejectedTitle => 'Your application needs changes';

  @override
  String get obRejectedHint => 'Update your profile and submit again.';

  @override
  String get obReviewTitle => 'Application under review';

  @override
  String get obReviewBody =>
      'Our team is verifying your profile and documents. You\'ll get a notification as soon as it\'s approved — usually within 1–2 business days.';

  @override
  String get obReviewSubmitted => 'Application submitted';

  @override
  String get obReviewChecking => 'Profile & document check';

  @override
  String get obReviewLive => 'Start consulting on TalkAcharya';

  @override
  String get obCheckStatus => 'Check status';

  @override
  String get obSuspendedTitle => 'Account suspended';

  @override
  String get obSuspendedBody =>
      'Your astrologer account is suspended. Contact support to understand why and how to reinstate it.';

  @override
  String get obNotAstroTitle => 'Not an astrologer account';

  @override
  String get obNotAstroBody =>
      'This phone number isn\'t registered as an astrologer. If you think this is a mistake, contact support.';

  @override
  String get wizTitle => 'Set up your profile';

  @override
  String wizStepOf(int step, int total) {
    return 'Step $step of $total';
  }

  @override
  String get wizNext => 'Save & continue';

  @override
  String get wizBack => 'Back';

  @override
  String get wizProfileIntro =>
      'This is what customers read before they consult you.';

  @override
  String get wizBioRequired => 'Tell customers a little about yourself';

  @override
  String get wizExpertiseIntro =>
      'Pick the areas you consult on and the languages you speak.';

  @override
  String get wizPickSkill => 'Choose at least one expertise';

  @override
  String get wizPickLanguage => 'Choose at least one language';

  @override
  String get wizIdentityIntro =>
      'We verify every astrologer to keep customers safe. Your documents are never shown publicly.';

  @override
  String get wizPanDone => 'PAN submitted';

  @override
  String get wizPhotoDone => 'Photo submitted';

  @override
  String get wizReplace => 'Replace';

  @override
  String get wizPhotoRequired => 'Upload a photo to continue';

  @override
  String get wizBankIntro =>
      'Your earnings are paid to this account after each payout cycle.';

  @override
  String get wizBankDone => 'Bank account added';

  @override
  String get wizBankUpdate => 'Update details';

  @override
  String get wizReviewIntro =>
      'Check that everything is complete, then submit. Our team usually reviews within 1–2 business days.';

  @override
  String get wizSubmit => 'Submit for review';

  @override
  String get wizGapBank => 'Bank account';

  @override
  String get wizStillMissing => 'Complete the highlighted items first';

  @override
  String get wizFix => 'Fix';

  @override
  String get wizSubmitted => 'Profile submitted!';

  @override
  String roomWaiting(String name) {
    return 'Waiting for $name to join…';
  }

  @override
  String get roomEnd => 'End';

  @override
  String get roomEndTitle => 'End this consultation?';

  @override
  String get roomEndBody =>
      'The customer stops being billed and the chat closes.';

  @override
  String get roomCallEndBody =>
      'The customer stops being billed when the call ends.';

  @override
  String get roomEndFailed => 'Couldn\'t end the consultation';

  @override
  String get roomLowBalance => 'Customer\'s balance is low — wrap up soon';

  @override
  String roomRunway(int minutes) {
    return '≈$minutes min left';
  }

  @override
  String get roomTranslate => 'Auto-translate';

  @override
  String get roomComposerHint => 'Type your reply';

  @override
  String get roomLoadError => 'Couldn\'t open this consultation';

  @override
  String get roomEndedTitle => 'Consultation complete';

  @override
  String roomEndedBody(String name) {
    return 'Thank you for guiding $name.';
  }

  @override
  String get roomNotHeldBody =>
      'This consultation didn\'t take place, so nothing was billed.';

  @override
  String get roomBackToRequests => 'Back to requests';

  @override
  String get sharedTitle => 'Shared by the customer';

  @override
  String get sharedNone => 'No birth details shared';

  @override
  String get sharedNoneHint =>
      'Ask the customer to share their birth details to read the chart.';

  @override
  String get sharedTimeUnknown => 'Birth time not known';

  @override
  String get sharedViewMatch => 'View match report';

  @override
  String get sharedMatchTitle => 'Kundali match';

  @override
  String sharedPoints(String points, String max) {
    return '$points of $max guna';
  }

  @override
  String get sharedNew => 'The customer shared new details';

  @override
  String get sharedAvailable => 'Birth details shared';

  @override
  String get matchReportTitle => 'Match report';

  @override
  String get matchKootas => 'Guna table';

  @override
  String get matchDoshas => 'Doshas';

  @override
  String get matchDoshaNadi => 'Nadi dosha';

  @override
  String get matchDoshaBhakoot => 'Bhakoot dosha';

  @override
  String get matchDoshaGana => 'Gana dosha';

  @override
  String get matchNoDoshas => 'No major doshas';

  @override
  String get matchLoadError => 'Couldn\'t load the match report';

  @override
  String sessionLiveBanner(String name) {
    return 'Live with $name';
  }

  @override
  String get sessionReturn => 'Return';

  @override
  String get liveSendPhoto => 'Send a photo';

  @override
  String get livePhotoFailed => 'Couldn\'t send the photo';

  @override
  String get livePhotoLabel => 'Photo';

  @override
  String get errGeneric => 'Something went wrong. Please try again.';

  @override
  String get errNetwork => 'Could not reach the server. Check your connection.';

  @override
  String get errTimeout => 'The server took too long to respond.';

  @override
  String get errSession => 'Your session expired. Please sign in again.';

  @override
  String get errForbidden => 'You don\'t have access to this.';

  @override
  String get errNotFound =>
      'We couldn\'t find this — it may have been removed.';

  @override
  String get errServer =>
      'Our server ran into a problem. Please try again shortly.';

  @override
  String get errRateLimited =>
      'Too many attempts. Please wait a little and try again.';

  @override
  String get errOtpInvalid => 'The code is incorrect or has expired.';

  @override
  String get errOtpMaxAttempts =>
      'Too many wrong attempts. Request a new code.';

  @override
  String get errAuthWrongApp =>
      'This number is registered for the other TalkAcharya app.';

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
  String get profileHapticFeedback => 'Vibration';

  @override
  String get profileHapticFeedbackDesc => 'Vibrate on buttons and alerts';

  @override
  String get profileSoundVibration => 'Sound & vibration';

  @override
  String get profileSoundVibrationSub => 'Ringtone, tones and vibration';

  @override
  String get roomViewSummary => 'Summary';

  @override
  String get callVideoPausedWeak => 'Video paused — weak connection';

  @override
  String get roomFollowUpOpen => 'Free follow-up — replies are not charged';

  @override
  String roomFollowUpHours(int hours) {
    return 'Free follow-up open for ${hours}h more';
  }

  @override
  String roomFollowUpMinutes(int minutes) {
    return 'Free follow-up open for $minutes min more';
  }

  @override
  String get roomFollowUpHint => 'Reply (free follow-up)';

  @override
  String get chatsFollowUpOpen => 'Free follow-up open';

  @override
  String chatsYouPrefix(String body) {
    return 'You: $body';
  }

  @override
  String get quickReplies => 'Quick replies';

  @override
  String get quickRepliesHint => 'Tap to put one in the box';

  @override
  String get quickRepliesAdd => 'New quick reply';

  @override
  String get quickRepliesNewHint => 'Something you type often';

  @override
  String get quickRepliesDelete => 'Delete';

  @override
  String get quickRepliesSaveFailed => 'Could not save that reply.';

  @override
  String get commonClose => 'Close';

  @override
  String get roomCustomerToppingUp =>
      'Customer is adding money — session held, not billing';

  @override
  String liveWaitingCount(int count) {
    return '$count waiting';
  }

  @override
  String get liveWaitingTooltip =>
      'Viewers who want a private reading — they\'re in your queue';

  @override
  String get callPoorConnection => 'Weak connection';

  @override
  String get callPeerPoorConnection => 'Customer\'s connection is weak';

  @override
  String get callBothPoorConnection => 'Weak connection on both sides';

  @override
  String get callShowChart => 'Chart';

  @override
  String get callHideChart => 'Hide chart';

  @override
  String get roomSearch => 'Search';

  @override
  String get roomSearchHint => 'Search this conversation';

  @override
  String get roomSearchEmpty => 'Nothing found';

  @override
  String get earnTabGifts => 'Gifts';

  @override
  String get earnGiftsEmptyTitle => 'No gifts yet';

  @override
  String get earnGiftsEmptyBody =>
      'Gifts sent during your live streams and consultations show up here.';

  @override
  String get earnGiftFromLive => 'Live stream';

  @override
  String get earnGiftFromConsultation => 'Consultation';

  @override
  String get roomDownloadTranscript => 'Save this conversation';

  @override
  String get predQueueTitle => 'Prediction queue';

  @override
  String get predQueueSubtitle => 'Forecasts waiting to be written';

  @override
  String get predQueueEmptyTitle => 'Nothing waiting';

  @override
  String get predQueueEmptyBody => 'New prediction requests will show up here.';

  @override
  String get predWorkTitle => 'Write forecast';

  @override
  String get predWorkTitleField => 'Title';

  @override
  String get predWorkBodyField => 'Forecast';

  @override
  String predWorkWords(int count) {
    return '$count words';
  }

  @override
  String get predWorkSaving => 'Saving…';

  @override
  String get predWorkSaved => 'Saved';

  @override
  String get predWorkClaim => 'Claim';

  @override
  String get predWorkRelease => 'Release';

  @override
  String get predWorkDelivered => 'Delivered';

  @override
  String get predWorkDeliver => 'Deliver forecast';

  @override
  String get goLiveTitle => 'Go live';

  @override
  String get goLiveSubtitle => 'Broadcast to anyone browsing the Live tab';

  @override
  String get goLiveStillLive => 'Still live — rejoin to keep broadcasting';

  @override
  String get goLiveScheduled => 'Scheduled — start when you are ready';

  @override
  String get goLiveRejoin => 'Rejoin';

  @override
  String get goLiveStart => 'Start';

  @override
  String get goLiveNewSession => 'Start a new session';

  @override
  String get goLiveTitleField => 'What is this session about?';

  @override
  String get goLiveTitleHint => 'e.g. Evening Q&A — career questions';

  @override
  String get goLiveHelp =>
      'Viewers see this title in the app. Your camera and microphone turn on as soon as you go live.';

  @override
  String get goLiveStarting => 'Starting…';

  @override
  String get goLivePast => 'Past sessions';

  @override
  String goLivePeak(int count) {
    return '$count peak';
  }

  @override
  String goLiveJoined(int count) {
    return '$count joined';
  }

  @override
  String goLiveGifts(String currency, String amount) {
    return '$currency $amount in gifts';
  }

  @override
  String get kundaliTitle => 'Kundali';

  @override
  String kundaliTitleFor(String name) {
    return '$name\'s kundali';
  }

  @override
  String get kundaliTabCharts => 'Charts';

  @override
  String get kundaliTabPlanets => 'Planets';

  @override
  String get kundaliTabDasha => 'Dasha';

  @override
  String get kundaliTabYogas => 'Yogas';

  @override
  String get kundaliTabDoshas => 'Doshas';

  @override
  String get kundaliTabOverview => 'Overview';

  @override
  String get kundaliTabRemedies => 'Remedies';

  @override
  String get kundaliTabBhava => 'Bhava';

  @override
  String get kundaliTabGochar => 'Gochar';

  @override
  String get kundaliTabNumbers => 'Numbers';

  @override
  String get kundaliTabAdvanced => 'Advanced';

  @override
  String get hostEndTitle => 'End the session?';

  @override
  String get hostStayLive => 'Stay live';

  @override
  String get hostEndSession => 'End session';

  @override
  String get hostEnd => 'End';

  @override
  String get hostChatHint => 'Answer your viewers…';

  @override
  String get hostSlowMode => 'Slow mode';

  @override
  String get hostSlowModeBody => 'How long a viewer must wait between messages';

  @override
  String get hostPin => 'Pin this message';

  @override
  String get hostHide => 'Hide this message';

  @override
  String get hostRemove => 'Remove this viewer';

  @override
  String get hostRemoveBody => 'They cannot rejoin or chat on this stream';

  @override
  String get otpResend => 'Resend code';

  @override
  String get kundaliAllCharts => 'All charts — D1 to D60';

  @override
  String get kundaliNoYogas => 'No notable yogas found.';

  @override
  String get kundaliNoData => 'No data';

  @override
  String predWorkTooShort(int min, int count) {
    return 'Needs at least $min words ($count so far).';
  }

  @override
  String get authTitle => 'Welcome, Acharya';

  @override
  String get authSubtitle =>
      'Sign in with your mobile number to reach the people waiting for your guidance.';

  @override
  String get authPhoneLabel => 'MOBILE NUMBER';

  @override
  String get authPhoneHint => '10-digit number';

  @override
  String get authContinue => 'Continue';

  @override
  String get authLegalBefore => 'I agree to the ';

  @override
  String get authLegalTerms => 'Terms of Service';

  @override
  String get authLegalBetween => ' and the ';

  @override
  String get authLegalPrivacy => 'Privacy Policy';

  @override
  String get authLegalAfter => '.';

  @override
  String get authLegalUnavailable => 'Could not open that page right now.';

  @override
  String get otpTitle => 'Enter the code';

  @override
  String otpSentTo(String phone) {
    return 'Sent to $phone';
  }

  @override
  String get otpChangeNumber => 'Change';

  @override
  String get otpVerify => 'Verify';

  @override
  String otpResendIn(int seconds) {
    return 'Resend in ${seconds}s';
  }

  @override
  String otpDevMode(String code) {
    return 'Dev mode — the code is $code';
  }

  @override
  String get callAudio => 'Audio';

  @override
  String get callEarpiece => 'Phone';

  @override
  String get callWiredHeadset => 'Headset';

  @override
  String get callBluetooth => 'Bluetooth';

  @override
  String get chatMute => 'Mute notifications';

  @override
  String get chatUnmute => 'Unmute notifications';

  @override
  String get chatArchive => 'Archive chat';

  @override
  String get chatUnarchive => 'Move out of archive';

  @override
  String get chatArchivedTitle => 'Archived';

  @override
  String chatArchivedRow(int count) {
    return 'Archived ($count)';
  }

  @override
  String chatBlock(String name) {
    return 'Block $name';
  }

  @override
  String chatUnblock(String name) {
    return 'Unblock $name';
  }

  @override
  String chatBlockConfirmTitle(String name) {
    return 'Block $name?';
  }

  @override
  String get chatBlockConfirmYes => 'Block';

  @override
  String chatBlockedByMe(String name) {
    return 'You blocked $name.';
  }

  @override
  String get chatBlockedByThem =>
      'Messages are turned off in this conversation.';

  @override
  String get chatMoreOptions => 'More options';

  @override
  String chatBlockConfirmBody(String name) {
    return 'Neither of you will be able to send messages here, and $name won\'t be able to book you until you unblock them.';
  }

  @override
  String get sessionChat => 'Chat';

  @override
  String get sessionVoice => 'Voice call';

  @override
  String get sessionVideo => 'Video call';

  @override
  String roomLiveNow(String session) {
    return '$session in progress';
  }

  @override
  String astroEarnedSoFar(String amount) {
    return '$amount earned so far';
  }

  @override
  String astroEndedEarned(String amount, int minutes) {
    return 'You earned $amount · $minutes min';
  }

  @override
  String astroCustomerRated(String name, int rating) {
    return '$name rated this session $rating/5';
  }

  @override
  String get astroNotRatedYet => 'Not rated yet';

  @override
  String astroRequestInRoom(String name, String session) {
    return '$name is asking for a $session';
  }

  @override
  String astroThreadClosed(String name) {
    return 'Consultation ended. $name can start a new one any time.';
  }

  @override
  String sysRequested(String session) {
    return '$session requested';
  }

  @override
  String get sysAccepted => 'You picked up · connecting';

  @override
  String sysStarted(String session) {
    return '$session started';
  }

  @override
  String sysEnded(String session, int minutes) {
    return '$session ended · $minutes min';
  }

  @override
  String sysEndedPlain(String session) {
    return '$session ended';
  }

  @override
  String get sysRejected => 'You declined the request';

  @override
  String sysCancelled(String name) {
    return '$name cancelled the request';
  }

  @override
  String get sysExpired => 'Request not answered in time';

  @override
  String sysNoShow(String session) {
    return '$session didn\'t connect';
  }

  @override
  String sysEndingSoon(String name) {
    return '$name\'s balance is running low';
  }

  @override
  String get presenceOnBreak => 'On a break';

  @override
  String get presenceOnBreakHint =>
      'You\'ll be back online by yourself when it ends';

  @override
  String clubTitle(String club) {
    return 'You\'re in the $club club';
  }

  @override
  String get clubTitleNone => 'Your first club is within reach';

  @override
  String clubProjection(String amount) {
    return 'On pace for $amount this month';
  }

  @override
  String clubNeedToday(String amount, String club) {
    return 'Earn $amount more today to stay on pace for the $club club.';
  }

  @override
  String clubOnTrack(String club) {
    return 'Today\'s target is met — the $club club is next. Keep going.';
  }

  @override
  String get clubTop => 'You\'re in the top club. Outstanding work.';

  @override
  String get todayTitle => 'Today\'s earnings';

  @override
  String get todaySub => 'After platform fee';

  @override
  String get todayHide => 'Hide amounts';

  @override
  String get todayShow => 'Show amounts';

  @override
  String get todayViewEarnings => 'View earnings';

  @override
  String get todaySessions => 'Sessions';

  @override
  String get todayTalkTime => 'Talk time';

  @override
  String get todayOnline => 'Online';

  @override
  String scoreTitle(int days) {
    return 'Last $days days';
  }

  @override
  String scoreUpdated(String time) {
    return 'Updated $time';
  }

  @override
  String get scoreOpen => 'Open performance dashboard';

  @override
  String get perfOnlineShort => 'Online\nper day';

  @override
  String get perfSessionShort => 'Average\nsession';

  @override
  String get perfFirstRepeatShort => 'First-time\nrepeat';

  @override
  String get perfLoyalShort => 'Loyal\ncustomers';

  @override
  String perfHoursMinutes(int h, int m) {
    return '${h}h ${m}m';
  }

  @override
  String perfMinutesSeconds(int m, int s) {
    return '${m}m ${s}s';
  }

  @override
  String perfSeconds(int s) {
    return '${s}s';
  }

  @override
  String perfHours(int h) {
    return '${h}h';
  }

  @override
  String perfMinutes(int m) {
    return '${m}m';
  }

  @override
  String get breakTitle => 'Take a break';

  @override
  String breakLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count breaks left today',
      one: '1 break left today',
    );
    return '$_temp0';
  }

  @override
  String get breakNoneLeft => 'No breaks left today';

  @override
  String get breakButton => 'Take a break';

  @override
  String get breakSheetTitle => 'How long do you need?';

  @override
  String get breakInfo =>
      'Customers won\'t be able to reach you during the break. You come back online by yourself when it ends — no need to switch anything on.';

  @override
  String breakMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String get breakStart => 'Start break';

  @override
  String get breakOnTitle => 'On a break';

  @override
  String breakBackIn(String time) {
    return 'Back online in $time';
  }

  @override
  String get breakResume => 'I\'m back';

  @override
  String get loyalTitle => 'Loyal customers';

  @override
  String loyalBody(int days, int minutes) {
    return 'Customers who came back in the last $days days and spent $minutes+ minutes with you.';
  }

  @override
  String get loyalWinBack => 'See who\'s gone quiet';

  @override
  String get dashTools => 'Tools';

  @override
  String get dashActionPerformance => 'Performance';

  @override
  String get dashActionWinBack => 'Win back';

  @override
  String get dashActionChats => 'Chat history';

  @override
  String get dashActionRequests => 'Requests';

  @override
  String get dashActionBoost => 'Boost profile';

  @override
  String get dashActionAlerts => 'Notifications';

  @override
  String get perfTitle => 'Performance';

  @override
  String perfSubtitle(int days) {
    return 'Last $days days, compared with the $days before.';
  }

  @override
  String get perfFocusTitle => 'Where to focus';

  @override
  String get perfLegendLow => 'Needs work';

  @override
  String get perfLegendMid => 'Moderate';

  @override
  String get perfLegendGood => 'Good';

  @override
  String get perfVerdictLow => 'Needs work';

  @override
  String get perfVerdictMid => 'Almost there';

  @override
  String get perfVerdictGood => 'Doing well';

  @override
  String get perfVerdictNone => 'Not enough data yet';

  @override
  String get perfFirstRepeat => 'First-time repeat';

  @override
  String get perfTotalRepeat => 'Total repeat';

  @override
  String get perfAvgSession => 'Average session';

  @override
  String get perfOnlineTime => 'Average online time';

  @override
  String get perfMissed => 'Missed requests';

  @override
  String get perfFirstRepeatAbout =>
      'Of the customers who consulted you for the first time in this period, the share who came back for another session.\n\nExample: 10 new customers, 4 of them returned — that is 40%.';

  @override
  String get perfTotalRepeatAbout =>
      'Of everyone you consulted in this period, new or not, the share who have consulted you more than once.\n\nExample: 20 customers, 9 of them have been with you before or came back — that is 45%.';

  @override
  String get perfAvgSessionAbout =>
      'Total billed time in this period divided by the number of sessions. Longer sessions usually mean the customer felt heard.\n\nExample: 120 minutes across 10 sessions — 12 minutes each.';

  @override
  String get perfOnlineTimeAbout =>
      'How long you were reachable each day on average — online or in a session. Breaks and time offline are not counted. We recommend at least six hours a day: customers return to astrologers they can find.';

  @override
  String get perfMissedAbout =>
      'Requests that timed out before you answered, plus the ones you declined. Requests the customer cancelled are not counted. If you need to step away, take a break instead of leaving requests to ring out.';

  @override
  String get perfHowCalculated => 'How it\'s calculated';

  @override
  String get perfShowLess => 'Show less';

  @override
  String get perfNoChange => 'Same as the period before';

  @override
  String perfDeltaUp(String amount) {
    return 'Up $amount on the period before';
  }

  @override
  String perfDeltaDown(String amount) {
    return 'Down $amount on the period before';
  }

  @override
  String get perfOnlineChart => 'Hours online, day by day';

  @override
  String perfGoalLine(int hours) {
    return '${hours}h goal';
  }

  @override
  String perfMissedUnanswered(int count) {
    return 'Timed out · $count';
  }

  @override
  String perfMissedDeclined(int count) {
    return 'Declined · $count';
  }

  @override
  String get perfRatings => 'Ratings';

  @override
  String get perfRatingsAbout =>
      'Lifetime average of published ratings from customers you\'ve consulted.';

  @override
  String get perfRatingOverall => 'Overall';

  @override
  String perfRatingCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ratings',
      one: '1 rating',
    );
    return '$_temp0';
  }

  @override
  String get perfNoRatings => 'No ratings yet';

  @override
  String get perfTipOnline =>
      'More hours online is your quickest win — customers can only return to someone they can find.';

  @override
  String get perfTipSession =>
      'Aim for longer sessions: ask a follow-up question before you wrap up.';

  @override
  String get perfTipFirstRepeat =>
      'Give first-time customers a reason to return — tell them what to look at next time.';

  @override
  String get perfTipTotalRepeat =>
      'Your regulars are slipping away. See who\'s gone quiet and be online when they usually come.';

  @override
  String get perfTipMissed =>
      'Too many requests are getting away. Answer before they time out, or take a break when you step away.';

  @override
  String get winBackTitle => 'Win back';

  @override
  String winBackSubtitle(int days) {
    return 'Returning customers you haven\'t spoken to in $days+ days. Open a thread to see where you left off.';
  }

  @override
  String winBackTile(int sessions, int minutes) {
    return '$sessions sessions · $minutes min together';
  }

  @override
  String winBackLast(String time) {
    return 'Last session $time';
  }

  @override
  String get winBackCustomer => 'Customer';

  @override
  String get winBackEmptyTitle => 'No one\'s gone quiet';

  @override
  String get winBackEmptyBody =>
      'Returning customers who stop coming back will show up here.';

  @override
  String get dashActionWaitlist => 'Waitlist';

  @override
  String get dashActionCalls => 'Call history';

  @override
  String get dashActionRemedies => 'Remedies';

  @override
  String get dashActionSounds => 'Sounds';

  @override
  String get waitlistTitle => 'Waitlist';

  @override
  String get waitlistSubtitle =>
      'Customers waiting for you, longest first. When a session ends the next person is told it\'s their turn — or call someone in yourself.';

  @override
  String get waitlistEmptyTitle => 'No one is waiting';

  @override
  String get waitlistEmptyBody =>
      'Customers who try to reach you while you\'re in a session can join your waitlist. They\'ll show up here.';

  @override
  String get waitlistInvite => 'Call in';

  @override
  String waitlistInvited(String name) {
    return '$name has been told it\'s their turn';
  }

  @override
  String waitlistInvitedLeft(String time) {
    return 'Invited · $time to join';
  }

  @override
  String waitlistWaiting(String time) {
    return 'Waiting $time';
  }

  @override
  String get waitlistNew => 'New customer';

  @override
  String waitlistRegular(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sessions with you',
      one: '1 session with you',
    );
    return '$_temp0';
  }

  @override
  String get waitlistRemove => 'Remove from waitlist';

  @override
  String waitlistRemoveTitle(String name) {
    return 'Remove $name?';
  }

  @override
  String get waitlistRemoveBody =>
      'They lose their place in line and are told you can\'t take them right now.';

  @override
  String get callsTitle => 'Call history';

  @override
  String get callsFilterAll => 'All';

  @override
  String get callsFilterCompleted => 'Completed';

  @override
  String get callsFilterMissed => 'Missed';

  @override
  String get callsStatCompleted => 'Completed';

  @override
  String get callsStatTalkTime => 'Talk time';

  @override
  String get callsStatMissed => 'Missed';

  @override
  String get callsEmptyTitle => 'No calls yet';

  @override
  String get callsEmptyBody =>
      'Voice and video calls with your customers will be listed here.';

  @override
  String get callsEmptyFilter => 'Nothing here';

  @override
  String get remediesTitle => 'Remedies';

  @override
  String get remediesSubtitle =>
      'Gemstones, rudraksha, poojas and more from the store that you\'ve suggested to your customers.';

  @override
  String get remediesSuggest => 'Suggest a remedy';

  @override
  String remediesSummary(int sent, int bought) {
    return '$sent suggested · $bought bought';
  }

  @override
  String remediesCommission(String percent) {
    return 'You earn $percent when a customer buys what you suggested.';
  }

  @override
  String get remediesEmptyTitle => 'No remedies suggested yet';

  @override
  String get remediesEmptyBody =>
      'Suggest a product from the store after a reading. The customer gets it in their app, and you earn a commission if they buy.';

  @override
  String get remedyStatusSent => 'Sent';

  @override
  String get remedyStatusViewed => 'Seen';

  @override
  String get remedyStatusPurchased => 'Bought';

  @override
  String get remedyStatusExpired => 'Expired';

  @override
  String remedyFor(String name, String time) {
    return 'For $name · $time';
  }

  @override
  String get remedySuggestTitle => 'Suggest a remedy';

  @override
  String remedySuggestFor(String name) {
    return 'For $name';
  }

  @override
  String get remedyStepCustomer => 'Who is it for?';

  @override
  String get remedyStepProduct => 'Choose the remedy';

  @override
  String get remedyStepNote => 'How should they use it?';

  @override
  String get remedySearchHint => 'Search gemstones, rudraksha, poojas…';

  @override
  String get remedyNoteHint =>
      'For example: wear it on the ring finger on a Saturday morning.';

  @override
  String get remedyNoProducts => 'No products match that search.';

  @override
  String get remedyNoCustomers =>
      'You can suggest remedies to customers you\'ve consulted. None yet.';

  @override
  String get remedySend => 'Send suggestion';

  @override
  String get remedySent => 'Suggestion sent';

  @override
  String get remedyDisclosure =>
      'The customer sees this as your recommendation and decides for themselves. Suggest only what the chart calls for.';

  @override
  String get toolsTitle => 'All tools';

  @override
  String get toolsGroupWork => 'Your work';

  @override
  String get toolsGroupCustomers => 'Your customers';

  @override
  String get toolsGroupGrow => 'Grow';

  @override
  String get toolsGroupSchedule => 'Schedule & money';

  @override
  String get toolsGroupHelp => 'Updates & help';

  @override
  String get wsCantOpen => 'Couldn\'t open that on this phone';

  @override
  String get wsRemove => 'Remove';

  @override
  String get wsNew => 'NEW';

  @override
  String get wsReadMore => 'Read more';

  @override
  String get wsAnnouncements => 'Announcements';

  @override
  String get wsAnnouncementsEmpty => 'Nothing new right now';

  @override
  String get wsAnnouncementsEmptyBody =>
      'Policy changes, festival timings and new features from TalkAcharya will show up here.';

  @override
  String get wsTraining => 'Training';

  @override
  String get wsTrainingSubtitle =>
      'Short videos on getting more from the app. They open in your video app.';

  @override
  String get wsTrainingEmpty => 'No videos yet';

  @override
  String get wsTrainingEmptyBody =>
      'Training videos will appear here as they are added.';

  @override
  String get wsFavourites => 'Favourites';

  @override
  String get wsFavouritesSubtitle =>
      'Customers you\'ve marked, with notes only you can see.';

  @override
  String get wsFavouritesEmpty => 'No favourites yet';

  @override
  String get wsFavouritesEmptyBody =>
      'Open a customer\'s chat and choose \"Add to favourites\" from the menu.';

  @override
  String get wsAddFavourite => 'Add to favourites';

  @override
  String wsFavouriteAdded(String name) {
    return '$name added to favourites';
  }

  @override
  String get wsUnfavourite => 'Remove from favourites';

  @override
  String get wsEditNote => 'Edit note';

  @override
  String wsNoteTitle(String name) {
    return 'Note about $name';
  }

  @override
  String get wsNoteHint =>
      'Only you see this. For example: career question, follow up after Diwali.';

  @override
  String get wsCommunity => 'My community';

  @override
  String get wsCommunitySubtitle =>
      'People who follow you. They\'re told when you come online or go live.';

  @override
  String get wsFollowers => 'Followers';

  @override
  String get wsNewThisWeek => 'New this week';

  @override
  String wsFollowingSince(String time) {
    return 'Joined $time';
  }

  @override
  String get wsCommunityEmpty => 'No followers yet';

  @override
  String get wsCommunityEmptyBody =>
      'Customers can follow you from your profile or after a session. Going live is the quickest way to be found.';

  @override
  String get wsReferral => 'Refer & earn';

  @override
  String wsReferralPitch(String reward, String gift) {
    return 'Earn $reward for every new customer who joins with your code. They get $gift.';
  }

  @override
  String get wsCodeCopied => 'Code copied';

  @override
  String get wsShareInvite => 'Share invite';

  @override
  String wsReferralShare(String code, String gift, String link) {
    return 'Consult me on TalkAcharya. Use my code $code when you sign up and get $gift in your wallet. $link';
  }

  @override
  String get wsReferralJoined => 'Joined with your code';

  @override
  String get wsReferralEarned => 'Earned';

  @override
  String get wsReferralHow =>
      'The reward is added to your payouts once the person you invited completes their first paid consultation.';

  @override
  String get wsReferralPending => 'Joined';

  @override
  String get wsReferralRewarded => 'Rewarded';

  @override
  String get wsReferralVoid => 'Not counted';

  @override
  String get wsGallery => 'Photos';

  @override
  String get wsGallerySubtitle => 'Pictures customers see on your profile.';

  @override
  String wsGalleryCount(int count, int max) {
    return '$count of $max photos';
  }

  @override
  String get wsAddPhoto => 'Add photo';

  @override
  String get wsPhotoRemoveTitle => 'Remove this photo?';

  @override
  String get wsGalleryRules =>
      'Use your own photos: you at work, your certificates, poojas you\'ve performed. No phone numbers or other contact details in the picture.';

  @override
  String get wsFeedback => 'Feedback';

  @override
  String get wsFeedbackSubtitle =>
      'Tell us what\'s broken or what would help. We read every message.';

  @override
  String get wsFeedbackBug => 'Something\'s broken';

  @override
  String get wsFeedbackSuggestion => 'Suggestion';

  @override
  String get wsFeedbackPayments => 'Payments';

  @override
  String get wsFeedbackCustomers => 'Customers';

  @override
  String get wsFeedbackOther => 'Other';

  @override
  String get wsFeedbackHint => 'What happened, and what did you expect?';

  @override
  String get wsFeedbackSend => 'Send feedback';

  @override
  String get wsFeedbackTooShort => 'Please write a little more so we can help.';

  @override
  String get wsFeedbackSent => 'Thank you — sent';

  @override
  String get wsFeedbackEarlier => 'What you\'ve sent';

  @override
  String get wsFeedbackReply => 'TalkAcharya replied';

  @override
  String get wsReplies => 'Quick replies';

  @override
  String get wsRepliesSubtitle =>
      'Messages you send often, one tap away in every chat. The ones you use most rise to the top.';

  @override
  String get wsRepliesEmpty => 'No quick replies yet';

  @override
  String get wsReplyNew => 'New quick reply';

  @override
  String get wsReplyHint =>
      'Namaste! Please share your date, time and place of birth.';

  @override
  String wsReplyUsed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Used $count times',
      one: 'Used once',
    );
    return '$_temp0';
  }

  @override
  String get wsCalendar => 'Calendar';

  @override
  String get wsCalendarSubtitle =>
      'Your working hours and scheduled lives for the next two weeks.';

  @override
  String get wsCalendarWorking => 'Working hours';

  @override
  String wsCalendarLiveAt(String time) {
    return 'Live stream at $time';
  }

  @override
  String get wsCalendarDayOff => 'Day off';

  @override
  String get wsCalendarDayOffBody => 'No working hours set for this day.';

  @override
  String get wsCalendarNoHours => 'No fixed hours';

  @override
  String get wsCalendarNoHoursBody =>
      'You haven\'t set working hours, so customers can reach you whenever you\'re online.';

  @override
  String get wsCalendarEdit => 'Edit working hours';

  @override
  String get wsCalendarNote =>
      'Outside your working hours you show as away, even with the app open.';

  @override
  String get wsHelpline => 'Helpline';

  @override
  String get wsHelpWhatsapp => 'WhatsApp us';

  @override
  String get wsHelpEmail => 'Email us';

  @override
  String get wsHelpCentre => 'Help centre';

  @override
  String get wsHelpCentreSub => 'Answers to common questions';

  @override
  String get wsHelpNone =>
      'Support contact details aren\'t available right now.';

  @override
  String get wsPhotoPending => 'In review';

  @override
  String get wsPhotoRejected => 'Not approved\nTap for why';

  @override
  String get wsGalleryReviewed =>
      'New photos are reviewed before customers see them. This usually takes a day.';

  @override
  String get ccTool => 'Kundli';

  @override
  String get ccTitle => 'Kundli';

  @override
  String get ccSubtitle =>
      'Charts you cast yourself — a walk-in, a phone client, family. Only you see them.';

  @override
  String get ccNew => 'New chart';

  @override
  String get ccEmpty => 'No charts yet';

  @override
  String get ccEmptyBody =>
      'Add someone\'s birth details to see their full kundali: charts, dasha, yogas, doshas and more.';

  @override
  String ccMoonSign(String sign) {
    return 'Moon in $sign';
  }

  @override
  String ccDeleteTitle(String name) {
    return 'Remove $name?';
  }

  @override
  String get ccDeleteBody =>
      'Their chart is removed from your list. Matches you ran with it go too.';

  @override
  String get ccName => 'Name';

  @override
  String get ccMale => 'Male';

  @override
  String get ccFemale => 'Female';

  @override
  String get ccOther => 'Other';

  @override
  String get ccBirthDate => 'Date of birth';

  @override
  String get ccBirthTime => 'Time of birth';

  @override
  String get ccTimeUnknown => 'Time of birth not known';

  @override
  String get ccTimeUnknownHint =>
      'The lagna and houses can\'t be trusted without it; planets and the Moon sign still can.';

  @override
  String get ccBirthPlace => 'Place of birth';

  @override
  String get ccSave => 'Cast chart';

  @override
  String get mmTitle => 'Matchmaking';

  @override
  String get mmSubtitle => 'Guna Milan between two of your saved charts.';

  @override
  String get mmBoy => 'Boy';

  @override
  String get mmGirl => 'Girl';

  @override
  String get mmRun => 'Match kundlis';

  @override
  String get mmRecent => 'Recent matches';

  @override
  String get mmNeedTwo => 'Add two charts first';

  @override
  String get mmNeedTwoBody =>
      'Matchmaking compares two saved charts. Add the boy\'s and the girl\'s birth details to begin.';

  @override
  String get remediesTabStore => 'From the store';

  @override
  String get remediesTabFree => 'Free advice';

  @override
  String get adviceTitle => 'Advise a free remedy';

  @override
  String get adviceSubtitle =>
      'A mantra, a fast, a charity — something that costs them nothing to follow.';

  @override
  String get adviceListSubtitle =>
      'Remedies you\'ve advised that cost nothing to follow. Each one went to the customer in their chat.';

  @override
  String get adviceEmptyTitle => 'No free advice yet';

  @override
  String get adviceEmptyBody =>
      'Advise a mantra, a fast or a charity after a reading. It reaches the customer as a message they can keep.';

  @override
  String get adviceStepLibrary => 'Pick from the library';

  @override
  String get adviceStepWrite => 'Or write your own';

  @override
  String get adviceLibraryEmpty =>
      'Nothing in the library for this yet — write your own below.';

  @override
  String get adviceFieldTitle => 'Remedy';

  @override
  String get adviceFieldBody => 'How to do it';

  @override
  String get adviceHowSent =>
      'This is sent to the customer as a message in your chat, so the chat has to be open: during a session, or in the follow-up window after it.';

  @override
  String get adviceSend => 'Send advice';

  @override
  String get adviceSent => 'Advice sent';

  @override
  String get adviceCatMantra => 'Mantra';

  @override
  String get adviceCatStotra => 'Stotra';

  @override
  String get adviceCatDaan => 'Daan';

  @override
  String get adviceCatVrat => 'Vrat';

  @override
  String get adviceCatPuja => 'Puja';

  @override
  String get adviceCatLifestyle => 'Lifestyle';

  @override
  String get poojaTool => 'Mandir puja';

  @override
  String get poojaBookingsTool => 'My bookings';

  @override
  String get poojaCalendarTitle => 'Mandir puja';

  @override
  String get poojaCalendarSubtitle =>
      'Poojas open for booking, soonest first. Suggest one to a customer — you earn a commission when they book.';

  @override
  String get poojaCalendarEmpty => 'No poojas scheduled';

  @override
  String get poojaCalendarEmptyBody =>
      'When partner temples open dates for booking, they\'ll appear here.';

  @override
  String poojaFrom(String price) {
    return 'From $price';
  }

  @override
  String poojaSeatsLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count places left',
      one: '1 place left',
    );
    return '$_temp0';
  }

  @override
  String get poojaSuggest => 'Suggest to a customer';

  @override
  String get poojaBookingsTitle => 'My bookings';

  @override
  String get poojaBookingsSubtitle =>
      'Poojas your customers booked on your suggestion, and where each one stands.';

  @override
  String get poojaBookingsEmpty => 'No bookings yet';

  @override
  String get poojaBookingsEmptyBody =>
      'When a customer books a pooja you suggested, it shows up here.';

  @override
  String get poojaStatusPending => 'Payment pending';

  @override
  String get poojaStatusConfirmed => 'Booked';

  @override
  String get poojaStatusPerformed => 'Performed';

  @override
  String get poojaStatusDone => 'Video shared';

  @override
  String get poojaStatusCancelled => 'Cancelled';

  @override
  String get poojaNextDate => 'Next available date';

  @override
  String get offerTitle => 'Offers';

  @override
  String get offerSubtitle =>
      'Put a discount on your rates for a while to bring customers in.';

  @override
  String get offerPickPercent => 'Discount';

  @override
  String get offerPickDuration => 'Runs for';

  @override
  String get offerPickAudience => 'Who gets it';

  @override
  String get offerPickChannels => 'On which sessions';

  @override
  String get offerChannelsHint => 'Pick none to cover chat, voice and video.';

  @override
  String offerPercentOff(int percent) {
    return '$percent% off';
  }

  @override
  String offerHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hours',
      one: '1 hour',
    );
    return '$_temp0';
  }

  @override
  String offerDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '1 day',
    );
    return '$_temp0';
  }

  @override
  String get offerAudienceAll => 'Everyone';

  @override
  String get offerAudienceNew => 'New customers';

  @override
  String get offerAllChannels => 'All sessions';

  @override
  String get offerChannelChat => 'Chat';

  @override
  String get offerChannelVoice => 'Voice';

  @override
  String get offerChannelVideo => 'Video';

  @override
  String get offerWhoPays =>
      'The discount comes out of your rate: while the offer runs, sessions are billed at the lower price and your earnings follow it. Customers see the offer on your profile.';

  @override
  String get offerStart => 'Start offer';

  @override
  String get offerStarted => 'Your offer is live';

  @override
  String get offerLiveBadge => 'LIVE NOW';

  @override
  String offerEndsAt(String when) {
    return 'Ends $when';
  }

  @override
  String get offerSessions => 'Sessions';

  @override
  String get offerEarned => 'Earned';

  @override
  String offerSessionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sessions',
      one: '1 session',
    );
    return '$_temp0';
  }

  @override
  String get offerEnd => 'End offer';

  @override
  String get offerEndTitle => 'End this offer now?';

  @override
  String get offerEndBody =>
      'New sessions go back to your normal rates. Sessions already booked keep the offer price.';

  @override
  String get offerEarlier => 'Earlier offers';

  @override
  String get offerOffTitle => 'Offers are paused';

  @override
  String get offerOffBody =>
      'Offers are switched off for now. Check back later.';

  @override
  String get perfPromoTitle => 'Welcome-offer customers';

  @override
  String get perfPromoBody =>
      'New customers on the platform\'s welcome offer. You are paid your full rate for these sessions.';

  @override
  String get perfPromoSessions => 'Sessions';

  @override
  String get perfPromoRating => 'Their rating';

  @override
  String perfPromoRepeat(int returned, int customers) {
    return 'Came back ($returned of $customers)';
  }

  @override
  String get callSetupTitle => 'Ring on a locked phone';

  @override
  String get callSetupSubtitle =>
      'Make sure consultation calls ring this phone even with the screen off.';

  @override
  String get callSetupMenuSub =>
      'Check that calls reach you with the screen off';

  @override
  String get callSetupReady =>
      'This phone is set to ring for consultations, even locked.';

  @override
  String get callSetupNotReady =>
      'Calls may not ring this phone with the screen off. Fix the items below.';

  @override
  String get callSetupNotAndroid => 'Nothing to set up on this phone.';

  @override
  String get callSetupNotifications => 'Notifications';

  @override
  String get callSetupNotificationsHelp =>
      'Allow notifications for TalkAcharya.';

  @override
  String get callSetupCallChannel => 'Call ringing';

  @override
  String get callSetupCallChannelHelp =>
      'The \"Incoming consultations\" category must stay on, with sound.';

  @override
  String get callSetupFullScreen => 'Show calls over the lock screen';

  @override
  String get callSetupFullScreenHelp =>
      'Lets a call fill the screen and wake the phone, like a phone call.';

  @override
  String get callSetupBattery => 'Battery optimisation';

  @override
  String get callSetupBatteryHelp =>
      'Set TalkAcharya to \"Don\'t optimise\" / \"Unrestricted\" so a call can wake the app.';

  @override
  String get callSetupAutostart => 'Autostart (phone maker\'s setting)';

  @override
  String get callSetupAutostartHelp =>
      'Your phone has its own switch that stops apps waking up. Turn it on for TalkAcharya.';

  @override
  String get callSetupLockScreen => 'Show on lock screen (Xiaomi)';

  @override
  String get callSetupLockScreenHelp =>
      'Under Other permissions, allow \"Show on lock screen\" and \"Display pop-up windows\".';

  @override
  String get callSetupFix => 'Fix';

  @override
  String get callSetupCheck => 'Check';

  @override
  String get callSetupTestTitle => 'Test it';

  @override
  String get callSetupTestBody =>
      'Tap the button, lock the phone and wait — it should ring like a call within about 10 seconds.';

  @override
  String get callSetupTestButton => 'Send me a test call';

  @override
  String callSetupTestSent(int seconds) {
    return 'Test call coming in $seconds seconds — lock your phone now.';
  }

  @override
  String get callSetupTestNoPhone =>
      'This phone is not registered for calls yet. Open the app once with internet on, then try again.';

  @override
  String get callSetupTestWorked =>
      'The test call reached you. Calls will ring this phone.';

  @override
  String get callSetupHomeTitle =>
      'Calls may not ring when your phone is locked';

  @override
  String get callSetupHomeBody => 'Tap to fix a phone setting.';

  @override
  String get authSessionReplaced =>
      'You were signed out because your account was signed in on another phone.';
}
