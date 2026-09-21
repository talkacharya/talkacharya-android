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
}
