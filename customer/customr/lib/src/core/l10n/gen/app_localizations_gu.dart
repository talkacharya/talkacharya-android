// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Gujarati (`gu`).
class AppLocalizationsGu extends AppLocalizations {
  AppLocalizationsGu([String locale = 'gu']) : super(locale);

  @override
  String get appName => 'TalkAcharya';

  @override
  String get commonOk => 'બરાબર';

  @override
  String get commonCancel => 'રદ કરો';

  @override
  String get commonDone => 'થઈ ગયું';

  @override
  String get commonNext => 'આગળ';

  @override
  String get commonBack => 'પાછળ';

  @override
  String get commonRetry => 'ફરી પ્રયાસ કરો';

  @override
  String get commonSave => 'સાચવો';

  @override
  String get commonEdit => 'ફેરફાર કરો';

  @override
  String get commonDelete => 'કાઢી નાખો';

  @override
  String get commonClose => 'બંધ કરો';

  @override
  String get commonContinue => 'ચાલુ રાખો';

  @override
  String get commonConfirm => 'પુષ્ટિ કરો';

  @override
  String get commonSeeAll => 'બધા જુઓ';

  @override
  String get commonViewAll => 'બધા જુઓ';

  @override
  String get commonShare => 'શેર કરો';

  @override
  String get commonCopy => 'કોપી કરો';

  @override
  String get commonCopied => 'કોપી થઈ ગયું';

  @override
  String get commonApply => 'લાગુ કરો';

  @override
  String get commonSearch => 'શોધો';

  @override
  String get commonYes => 'હા';

  @override
  String get commonNo => 'ના';

  @override
  String get commonLoading => 'લોડ થઈ રહ્યું છે…';

  @override
  String get commonSomethingWentWrong => 'કાંઈક ખોટું થયું છે';

  @override
  String get commonCheckConnection =>
      'તમારું ઇન્ટરનેટ કનેક્શન તપાસો અને ફરી પ્રયાસ કરો';

  @override
  String get commonComingSoon => 'ટૂંક સમયમાં આવી રહ્યું છે';

  @override
  String get commonToday => 'આજે';

  @override
  String get commonYesterday => 'ગઈકાલે';

  @override
  String commonMinutesShort(int count) {
    return '$count મિનિટ';
  }

  @override
  String get commonOffline => 'તમે ઓફલાઇન છો';

  @override
  String get navHome => 'હોમ';

  @override
  String get navAstrologers => 'જ્યોતિષીઓ';

  @override
  String get navLive => 'લાઇવ';

  @override
  String get navWallet => 'વોલેટ';

  @override
  String get navProfile => 'પ્રોફાઇલ';

  @override
  String get authWelcomeTitle => 'વિશ્વાસપાત્ર જ્યોતિષીઓ સાથે વાત કરો';

  @override
  String get authWelcomeSubtitle =>
      'પ્રેમ, કારકિર્દી, પૈસા અને વધુ પર માર્ગદર્શન માટે ચેટ અથવા કોલ કરો';

  @override
  String get authPhoneTitle => 'તમારો મોબાઈલ નંબર લખો';

  @override
  String get authPhoneSubtitle =>
      'તમારો મોબાઈલ નંબર લખો અને અમે તમને એક વન-ટાઇમ કોડ મોકલીશું.';

  @override
  String authOtpSubtitle(String phone) {
    return 'અમે $phone પર 6-અંકનો કોડ મોકલ્યો છે.';
  }

  @override
  String authTestModeCode(String code) {
    return 'ટેસ્ટ મોડ — તમારો કોડ $code છે';
  }

  @override
  String get authPhoneHint => 'મોબાઈલ નંબર';

  @override
  String get authPhoneHelper => 'અમે SMS દ્વારા વન-ટાઇમ કોડ મોકલીશું';

  @override
  String get authGetOtp => 'OTP મેળવો';

  @override
  String get authOtpTitle => '6-અંકનો કોડ લખો';

  @override
  String authOtpSentTo(String phone) {
    return '$phone પર મોકલવામાં આવ્યો';
  }

  @override
  String get authOtpResend => 'કોડ ફરીથી મોકલો';

  @override
  String authOtpResendIn(int seconds) {
    return '$seconds સેકન્ડમાં ફરીથી મોકલો';
  }

  @override
  String get authVerify => 'ચકાસો';

  @override
  String get authChangeNumber => 'નંબર બદલો';

  @override
  String get authInvalidPhone => 'માન્ય મોબાઈલ નંબર લખો';

  @override
  String get authInvalidOtp => '6-અંકનો કોડ લખો';

  @override
  String get authWrongApp => 'આ નંબર જ્યોતિષી એપ માટે નોંધાયેલ છે';

  @override
  String authDevCode(String code) {
    return 'દેવ કોડ: $code';
  }

  @override
  String get authTermsNotice =>
      'આગળ વધીને તમે અમારી શરતો અને ગોપનીયતા નીતિ સાથે સંમત થાઓ છો';

  @override
  String get authLogout => 'લોગ આઉટ';

  @override
  String get authLogoutConfirm =>
      'TalkAcharya માંથી લોગ આઉટ કરવું છે? તમારે ફરીથી સાઇન ઇન કરવું પડશે.';

  @override
  String homeGreeting(String name) {
    return 'નમસ્તે, $name';
  }

  @override
  String get homeGuidanceTagline => 'માર્ગદર્શન, જ્યારે પણ તમને જરૂર હોય';

  @override
  String get homeGreetingFallbackName => 'ત્યાં';

  @override
  String get walletAddShort => 'ઉમેરો';

  @override
  String get homeChatNow => 'અત્યારે ચેટ કરો';

  @override
  String get homeCallNow => 'અત્યારે કોલ કરો';

  @override
  String homeFromPerMin(String price) {
    return '$price/મિનિટ થી';
  }

  @override
  String homeOnlineCount(int count) {
    return '$count ઓનલાઇન';
  }

  @override
  String get homeOnlineNow => 'હમણાં ઑનલાઇન';

  @override
  String get homeTalkToAstrologer => 'જ્યોતિષી સાથે વાત કરો';

  @override
  String get homeLiveNow => 'અત્યારે લાઇવ';

  @override
  String get homeWhatsOnYourMind => 'તમારા મનમાં શું છે?';

  @override
  String get homeTodaysHoroscope => 'આજનું રાશિફળ';

  @override
  String get homeChooseYourSign => 'તમારી રાશિ પસંદ કરો';

  @override
  String get homeReadMore => 'વધુ વાંચો';

  @override
  String get homeShowLess => 'ઓછું બતાવો';

  @override
  String homeLuckToday(String rating) {
    return 'આજનું ભાગ્ય · $rating';
  }

  @override
  String get homeTodaysPanchang => 'આજનું પંચાંગ';

  @override
  String get homePanchangAddProfile =>
      'તમારા સ્થાન મુજબ પંચાંગ મેળવવા માટે જન્મ વિગતો ઉમેરો';

  @override
  String get homeFreeTools => 'મફત સાધનો';

  @override
  String get homeTalkAgain => 'ફરીથી વાત કરો';

  @override
  String get homeAddMoneyGetBonus => 'પૈસા ઉમેરો, બોનસ મેળવો';

  @override
  String get homeReferAFriend => 'મિત્રને રિફર કરો, બંને કમાઓ';

  @override
  String get homeReferShort =>
      'તમારો કોડ શેર કરો — તમને બંનેને વોલેટ ક્રેડિટ મળશે';

  @override
  String homeReferYourCode(String code) {
    return 'તમારો કોડ: $code';
  }

  @override
  String get homeInvite => 'આમંત્રિત કરો';

  @override
  String homeResumeInProgress(String channel) {
    return '$channel · પ્રગતિમાં છે';
  }

  @override
  String homeResumePaused(String channel) {
    return '$channel · અટકેલ છે';
  }

  @override
  String get homeResume => 'ફરી શરૂ કરો';

  @override
  String get homeTrustVerified =>
      'દરેક જ્યોતિષી લાઇવ થાય તે પહેલાં આઈડી-વેરિફાઇડ હોય છે';

  @override
  String get homeTrustPrivate => '100% ખાનગી અને ગુપ્ત પરામર્શ';

  @override
  String get homeTrustVolume => 'દર અઠવાડિયે હજારો પરામર્શ';

  @override
  String get homeCouldntLoadAstrologers => 'જ્યોતિષીઓ લોડ કરી શકાયા નથી';

  @override
  String get homeCouldntLoadReading => 'આજનું રીડિંગ મેળવી શકાયું નથી';

  @override
  String get homeCouldntLoadPanchang => 'પંચાંગ લોડ કરી શકાયું નથી';

  @override
  String get homeNoAstrologersFilter =>
      'અત્યારે આ ફિલ્ટર સાથે કોઈ જ્યોતિષી મળ્યા નથી';

  @override
  String get concernLove => 'પ્રેમ';

  @override
  String get concernMarriage => 'લગ્ન';

  @override
  String get concernCareer => 'કારકિર્દી';

  @override
  String get concernFinance => 'નાણા';

  @override
  String get concernHealth => 'સ્વાસ્થ્ય';

  @override
  String get concernEducation => 'શિક્ષણ';

  @override
  String get concernBusiness => 'વ્યવસાય';

  @override
  String get concernLegal => 'કાનૂની';

  @override
  String get channelChat => 'ચેટ';

  @override
  String get channelCall => 'કોલ';

  @override
  String get channelVoice => 'વોઈસ કોલ';

  @override
  String get channelVideo => 'વીડિયો કોલ';

  @override
  String get channelAll => 'બધા';

  @override
  String get astroFilterAll => 'બધા';

  @override
  String get astroSortRecommended => 'ભલામણ કરેલ';

  @override
  String get astroSortTopRated => 'ટોપ રેટેડ';

  @override
  String get astroSortExperienced => 'સૌથી અનુભવી';

  @override
  String get astroSortConsulted => 'સૌથી વધુ સંપર્ક કરેલ';

  @override
  String get astroSortNew => 'અહીં નવા';

  @override
  String get astroOnline => 'ઓનલાઇન';

  @override
  String get astroBusy => 'વ્યસ્ત';

  @override
  String get astroNotifyMe => 'મને જણાવો';

  @override
  String astroWaitMinutes(int count) {
    return '~$count મિનિટ રાહ જુઓ';
  }

  @override
  String astroPerMinute(String price) {
    return '$price/મિનિટ';
  }

  @override
  String astroYearsExp(int count) {
    return '$count વર્ષનો અનુભવ';
  }

  @override
  String get astroRatingNew => 'નવું';

  @override
  String astroSessionsCount(String count) {
    return '$count સત્રો';
  }

  @override
  String get astroSearchHint => 'નામ, કૌશલ્ય અથવા ભાષા દ્વારા શોધો';

  @override
  String get astroNoneFound => 'કોઈ જ્યોતિષી મળ્યા નથી';

  @override
  String get astroNoneFoundHint => 'ફિલ્ટર દૂર કરો અથવા કંઈક બીજું શોધો';

  @override
  String get astroThatsEveryone => 'અત્યારે આટલા જ છે';

  @override
  String get astroRateOnRequest => 'વિનંતી પર રેટ';

  @override
  String get astroCouldntLoad => 'જ્યોતિષીઓ લોડ કરી શકાયા નથી.';

  @override
  String get astroSortBy => 'સૉર્ટ કરો';

  @override
  String get astroLoadMoreFailed => 'વધુ લોડ કરી શકાયું નથી';

  @override
  String get astroDefaultSkill => 'વૈદિક જ્યોતિષ';

  @override
  String astroYears(int count) {
    return '$count વર્ષ';
  }

  @override
  String astroSessions(String count) {
    return '$count સત્રો';
  }

  @override
  String get astroChat => 'ચેટ';

  @override
  String get astroCall => 'કૉલ કરો';

  @override
  String get astroVideo => 'વિડિઓ';

  @override
  String get astroProfileTitle => 'જ્યોતિષી';

  @override
  String get astroExpertiseTitle => 'Expertise';

  @override
  String get astroAboutTitle => 'વિશે';

  @override
  String get astroRatesTitle => 'પરામર્શ દરો';

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
  String get astroStatRating => 'રેટિંગ';

  @override
  String get astroStatExperience => 'અનુભવ';

  @override
  String get astroStatSessions => 'સત્રો';

  @override
  String get astroStatRepeatClients => 'રિપીટ ક્લાયન્ટ્સ';

  @override
  String astroSpeaks(String languages) {
    return '$languages બોલે છે';
  }

  @override
  String astroRepliesIn(String time) {
    return '~ $time માં જવાબો';
  }

  @override
  String get astroOnlineNow => 'હમણાં ઑનલાઇન';

  @override
  String get astroOfflineTitle => 'હાલમાં ઑફલાઇન છે';

  @override
  String get astroNotifyWhenOnline => 'જ્યારે ઓનલાઈન હોઉં ત્યારે મને જાણ કરો';

  @override
  String get astroReadMore => 'વધુ વાંચો';

  @override
  String get astroReadLess => 'ઓછું બતાવો';

  @override
  String get astroCouldntLoadOne => 'આ જ્યોતિષી લોડ કરી શકાયો નથી.';

  @override
  String get astroCallsComingSoon =>
      'વૉઇસ અને વિડિઓ કૉલ્સ ટૂંક સમયમાં આવી રહ્યા છે';

  @override
  String get astroTrustLine =>
      'ID-ચકાસાયેલ · ખાનગી અને ગોપનીય · મિનિટ દીઠ ચુકવણી કરો';

  @override
  String get walletTitle => 'વોલેટ';

  @override
  String get walletAvailableBalance => 'ઉપલબ્ધ બેલેન્સ';

  @override
  String walletOnHold(String amount) {
    return '$amount હોલ્ડ પર છે';
  }

  @override
  String walletOnHoldReason(String amount) {
    return '$amount હોલ્ડ પર છે · કોલ ચાલુ છે';
  }

  @override
  String get walletAddMoney => 'પૈસા ઉમેરો';

  @override
  String get walletRecentActivity => 'તાજેતરની પ્રવૃત્તિ';

  @override
  String get walletTransactions => 'વ્યવહારો';

  @override
  String get walletHowItWorksTitle => 'વોલેટ કેવી રીતે કામ કરે છે';

  @override
  String get walletHowItWorksBody =>
      'વોલેટ બેલેન્સનો ઉપયોગ ફક્ત પરામર્શ માટે થાય છે અને તે ક્યારેય સમાપ્ત થતું નથી. ન વપરાયેલ બેલેન્સ રિફંડપાત્ર છે — અમારી રિફંડ નીતિ જુઓ.';

  @override
  String get walletRefundPolicy => 'રિફંડ નીતિ';

  @override
  String get walletHaveCoupon => 'કૂપન કોડ છે?';

  @override
  String get walletCouponHint => 'કોડ લખો';

  @override
  String walletCouponApplied(String amount) {
    return 'તમારા વોલેટમાં $amount ઉમેરવામાં આવ્યા';
  }

  @override
  String get walletSecuredBy =>
      'Razorpay · UPI · કાર્ડ્સ · નેટબેંકિંગ દ્વારા સુરક્ષિત';

  @override
  String get walletGstInvoices => 'GST ઇન્વોઇસ';

  @override
  String get walletInvoicesSubtitle => 'તમારા રિચાર્જ માટે ઇન્વોઇસ અને રસીદો';

  @override
  String get walletNoTransactions => 'હજી સુધી કોઈ વ્યવહાર નથી';

  @override
  String get walletNoTransactionsHint =>
      'શરૂ કરવા માટે તમારા વોલેટમાં પૈસા ઉમેરો';

  @override
  String walletBalanceAfter(String amount) {
    return 'બેલેન્સ $amount';
  }

  @override
  String get walletFilterAll => 'બધા';

  @override
  String get walletFilterRecharge => 'ઉમેરેલ';

  @override
  String get walletFilterConsultation => 'પરામર્શ';

  @override
  String get walletFilterRefund => 'રિફંડ';

  @override
  String get walletFilterBonus => 'બોનસ';

  @override
  String get kindRecharge => 'પૈસા ઉમેર્યા';

  @override
  String get kindConsultationCharge => 'પરામર્શ';

  @override
  String get kindConsultationRefund => 'રિફંડ';

  @override
  String get kindPromoCredit => 'પ્રોમો ક્રેડિટ';

  @override
  String get kindCouponDiscount => 'કૂપન ડિસ્કાઉન્ટ';

  @override
  String get kindSignupBonus => 'સાઇનઅપ બોનસ';

  @override
  String get kindReferralBonus => 'રિફરલ બોનસ';

  @override
  String get kindAdjustment => 'એડજસ્ટમેન્ટ';

  @override
  String get kindGiftSpend => 'ભેટ મોકલી';

  @override
  String get kindHold => 'કોલ માટે આરક્ષિત';

  @override
  String get kindChargeback => 'ચાર્જબેક';

  @override
  String get rechargeChooseAmount => 'વોલેટમાં પૈસા ઉમેરો';

  @override
  String get rechargeAmountLabel => 'રકમ';

  @override
  String rechargePayAmount(String amount) {
    return '$amount ચૂકવો';
  }

  @override
  String get rechargeAddCoupon => 'કૂપન કોડ ઉમેરો';

  @override
  String rechargeBonusBadge(String amount) {
    return '+$amount';
  }

  @override
  String get rechargeStarterPack => 'સ્ટાર્ટર';

  @override
  String rechargeMinAmount(String amount) {
    return 'લઘુત્તમ $amount';
  }

  @override
  String rechargeMaxAmount(String amount) {
    return 'મહત્તમ $amount';
  }

  @override
  String get rechargeOpeningCheckout => 'સુરક્ષિત ચેકઆઉટ ખોલી રહ્યા છીએ…';

  @override
  String get rechargeConfirming =>
      'પેમેન્ટ મળી ગયું છે — તમારું બેલેન્સ અપડેટ કરી રહ્યા છીએ…';

  @override
  String rechargeSuccessTitle(String amount) {
    return '$amount ઉમેર્યા';
  }

  @override
  String rechargeNewBalance(String amount) {
    return 'નવું બેલેન્સ $amount';
  }

  @override
  String get rechargeViewTransaction => 'વ્યવહાર જુઓ';

  @override
  String get rechargeFailedTitle => 'પેમેન્ટ સફળ થયું નથી';

  @override
  String get rechargeNotCharged => 'તમારી પાસેથી કોઈ ચાર્જ લેવામાં આવ્યો નથી.';

  @override
  String get rechargeAutoRefund =>
      'જો કોઈ રકમ ડેબિટ થઈ હોય, તો તે 3-5 કામકાજના દિવસોમાં રિફંડ કરવામાં આવશે.';

  @override
  String get rechargeTryAgain => 'ફરી પ્રયાસ કરો';

  @override
  String get rechargeChangeAmount => 'રકમ બદલો';

  @override
  String get rechargeCreditedSoon =>
      'પેમેન્ટ મળી ગયું છે. અમે થોડી વારમાં તમારા વોલેટમાં જમા કરીશું.';

  @override
  String rechargeOfferAutoApplied(String amount, String bonus) {
    return '$amount ઉમેરો, $bonus વધારાનું મેળવો — ઓટો-એપ્લાઇડ';
  }

  @override
  String get profileTitle => 'પ્રોફાઇલ';

  @override
  String get profileEditProfile => 'પ્રોફાઇલ એડિટ કરો';

  @override
  String profilePhoneMasked(String last4) {
    return '+91 ●●●●● $last4';
  }

  @override
  String get profileCompleteAddEmail =>
      'તમારી પ્રોફાઇલ પૂર્ણ કરવા માટે ઇમેઇલ ઉમેરો';

  @override
  String get profileCompleteAddBirth =>
      'વ્યક્તિગત રીડિંગ્સ માટે તમારી જન્મ વિગતો ઉમેરો';

  @override
  String get profileRoleCustomer => 'ગ્રાહક';

  @override
  String get profileWallet => 'વોલેટ';

  @override
  String get profileBirthProfiles => 'જન્મ પ્રોફાઇલ્સ';

  @override
  String profileBirthProfilesCount(int count) {
    return '$count ચાર્ટ્સ';
  }

  @override
  String get profileGroupAccount => 'એકાઉન્ટ';

  @override
  String get profileGroupMoney => 'પૈસા';

  @override
  String get profileGroupPreferences => 'પસંદગીઓ';

  @override
  String get profileGroupSupport => 'સપોર્ટ';

  @override
  String get profileGroupLegal => 'કાનૂની';

  @override
  String get profileNotifications => 'સૂચનાઓ';

  @override
  String get profileNotificationPrefs => 'સૂચના પસંદગીઓ';

  @override
  String get profileHapticFeedback => 'હેપ્ટિક પ્રતિસાદ';

  @override
  String get profileHapticFeedbackDesc =>
      'બટનો અને ક્રિયાપ્રતિક્રિયાઓ પર વાઇબ્રેટ કરો';

  @override
  String get profileWalletAndTransactions => 'વોલેટ અને વ્યવહારો';

  @override
  String get profileOrders => 'Orders';

  @override
  String profileOrdersUnread(int count) {
    return '$count new';
  }

  @override
  String get profileReferAndEarn => 'રિફર કરો અને કમાઓ';

  @override
  String get profileLanguage => 'ભાષા';

  @override
  String get profileCurrency => 'ચલણ';

  @override
  String get profileHelpCentre => 'હેલ્પ સેન્ટર';

  @override
  String get profileContactWhatsapp => 'અમારો WhatsApp પર સંપર્ક કરો';

  @override
  String get profileRateApp => 'TalkAcharya ને રેટ કરો';

  @override
  String get profileShareApp => 'એપ શેર કરો';

  @override
  String profileShareMessage(String link) {
    return 'હું જ્યોતિષીઓ સાથે વાત કરવા માટે TalkAcharya નો ઉપયોગ કરી રહ્યો છું. તમે પણ ટ્રાય કરો: $link';
  }

  @override
  String get profileTerms => 'સેવાની શરતો';

  @override
  String get profilePrivacy => 'ગોપનીયતા નીતિ';

  @override
  String get profileLicenses => 'ઓપન સોર્સ લાયસન્સ';

  @override
  String get profileDeleteAccount => 'એકાઉન્ટ કાઢી નાખો';

  @override
  String profileVersion(String version, String build) {
    return 'TalkAcharya · v$version ($build)';
  }

  @override
  String get editFullName => 'પૂરું નામ';

  @override
  String get editDisplayName => 'ડિસ્પ્લે નામ';

  @override
  String get editDateOfBirth => 'જન્મ તારીખ';

  @override
  String get editGender => 'જાતિ';

  @override
  String get editGenderMale => 'પુરુષ';

  @override
  String get editGenderFemale => 'સ્ત્રી';

  @override
  String get editGenderOther => 'અન્ય';

  @override
  String get editEmail => 'ઇમેઇલ';

  @override
  String get editEmailUnverified => 'ચકાસાયેલ નથી';

  @override
  String get editChangePhoto => 'ફોટો બદલો';

  @override
  String get editProfileSaved => 'પ્રોફાઇલ અપડેટ થઈ ગઈ';

  @override
  String get editProfileSaveError => 'તમારા ફેરફારો સાચવી શકાયા નથી';

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
  String get editCountry => 'દેશ';

  @override
  String get chooseLanguage => 'ભાષા પસંદ કરો';

  @override
  String get chooseCurrency => 'ચલણ પસંદ કરો';

  @override
  String get deleteAccountTitle => 'તમારું એકાઉન્ટ કાઢી નાખો';

  @override
  String get deleteAccountBody =>
      'આ તમારા પ્રોફાઇલ, જન્મ ચાર્ટ્સ અને ચેટ હિસ્ટ્રીને કાયમી ધોરણે દૂર કરશે. જો વોલેટ બેલેન્સ હશે તો તે મૂળ પેમેન્ટ પદ્ધતિમાં રિફંડ કરવામાં આવશે. કાયદા મુજબ પરામર્શના રેકોર્ડ રાખવામાં આવે છે.';

  @override
  String get deleteAccountHold =>
      'તમારું એકાઉન્ટ તરત જ નિષ્ક્રિય થઈ જાય છે અને 30 દિવસ પછી સંપૂર્ણપણે કાઢી નાખવામાં આવે છે. રદ કરવા માટે 30 દિવસની અંદર ફરી સાઇન ઇન કરો.';

  @override
  String get deleteAccountConfirm => 'હા, મારું એકાઉન્ટ કાઢી નાખો';

  @override
  String get deleteAccountRequested =>
      'એકાઉન્ટ કાઢી નાખવાની વિનંતી કરવામાં આવી છે';

  @override
  String get referTitle => 'રિફર કરો અને કમાઓ';

  @override
  String referHeroTitle(String friendAmount, String youAmount) {
    return '$friendAmount આપો, $youAmount મેળવો';
  }

  @override
  String referHeroBody(String friendAmount, String youAmount) {
    return 'તમારા મિત્રને તેમના પ્રથમ પરામર્શ પર $friendAmount ની છૂટ મળે છે. જ્યારે તેઓ પરામર્શ લે ત્યારે તમને તમારા વોલેટમાં $youAmount મળે છે.';
  }

  @override
  String get referYourCode => 'તમારો રિફરલ કોડ';

  @override
  String get referShareLink => 'આમંત્રણ લિંક શેર કરો';

  @override
  String get referInvited => 'આમંત્રિત';

  @override
  String get referJoined => 'જોડાયા';

  @override
  String get referEarned => 'કમાયા';

  @override
  String get referHowItWorks => 'તે કેવી રીતે કામ કરે છે';

  @override
  String get referStep1 =>
      'તમારો કોડ અથવા લિંક શેર કરો. તમારા મિત્ર સાઇન અપ કરતી વખતે તે દાખલ કરશે.';

  @override
  String referStep2(String amount) {
    return 'તેમને તેમના પ્રથમ પેઇડ પરામર્શ પર $amount ની છૂટ મળે છે.';
  }

  @override
  String referStep3(String amount) {
    return 'પરામર્શનું બિલ બનતાની સાથે જ $amount તમારા વોલેટમાં આવશે.';
  }

  @override
  String get referYourReferrals => 'તમારા રિફરલ્સ';

  @override
  String get referStatusPending => 'બાકી';

  @override
  String get referStatusJoined => 'જોડાયા';

  @override
  String get referStatusRewarded => 'પુરસ્કૃત';

  @override
  String referJoinedOn(String date) {
    return '$date ના રોજ જોડાયા';
  }

  @override
  String get referFirstCallDone => 'પ્રથમ કોલ પૂર્ણ';

  @override
  String referShareText(String code, String amount, String link) {
    return 'TalkAcharya પર મારો કોડ $code વાપરો અને તમારા પ્રથમ જ્યોતિષ પરામર્શ પર $amount ની છૂટ મેળવો. $link';
  }

  @override
  String get kundaliYogasDoshasTitle => 'યોગ અને દોષો';

  @override
  String get kundaliTabDoshas => 'દોષો';

  @override
  String get kundaliTabYogas => 'યોગ';

  @override
  String get doshaIntro =>
      'દોષો ચાર્ટમાં સંવેદનશીલ બિંદુઓ છે. મોટાભાગના સમય સાથે નરમ પડે છે, સહાયક દશા, અથવા શાસ્ત્રીય ઉપાય - એક જ્યોતિષી પુષ્ટિ કરે છે કે તમારા માટે ખરેખર શું મહત્વનું છે.';

  @override
  String get doshaDisclaimer =>
      'માત્ર માળખાકીય સંકેતો, આગાહીઓ નહીં. રત્ન પહેરતા પહેલા અથવા કોઈ ગંભીર ઉપાય શરૂ કરતા પહેલા જ્યોતિષી સાથે વાત કરો.';

  @override
  String get doshaPresent => 'હાજર';

  @override
  String get doshaNotPresent => 'હાજર નથી';

  @override
  String get doshaCancelled => 'અસરકારક રીતે રદ કર્યું';

  @override
  String get doshaSeverityClear => 'ચોખ્ખું';

  @override
  String get doshaSeverityMild => 'હળવું';

  @override
  String get doshaSeverityModerate => 'મધ્યમ';

  @override
  String get doshaSeverityStrong => 'મજબૂત';

  @override
  String get doshaWhy => 'તેને શા માટે ચિહ્નિત કરવામાં આવ્યું છે';

  @override
  String get doshaWhatReduces => 'શું ઘટાડે છે?';

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
  String get doshaClearSectionTitle => 'સાફ — તમારા ચાર્ટમાં નથી';

  @override
  String get doshaAllClear => 'તમારા ચાર્ટમાં કોઈ પણ સામાન્ય દોષો હાજર નથી.';

  @override
  String get doshaAskCta =>
      'કોઈ જ્યોતિષીને પૂછો કે આનો તમારા માટે શું અર્થ થાય છે.';

  @override
  String get insightsTitle => 'વ્યક્તિત્વ અને જીવનનો ઝાંખી';

  @override
  String get insightsIntro =>
      'તમારા જન્મ ચાર્ટ (D1) નું મફત વાંચન - જીવનના મુખ્ય ક્ષેત્રોમાં તે કઈ વૃત્તિઓ તરફ ઝુકે છે. તે સ્વ-ચિંતન માટેનું એક સ્કેચ છે, ઘટનાઓ અથવા તારીખોની આગાહી નહીં.';

  @override
  String get insightsDisclaimer =>
      'તમારા ચાર્ટમાંથી સામાન્ય માર્ગદર્શન મેળવો, આગાહી નહીં. તેમાં કોઈ તારીખો નથી અને સ્વાસ્થ્ય, આયુષ્ય કે સંબંધો વિશે કોઈ દાવા નથી. કોઈ ચોક્કસ બાબત માટે, કોઈ જ્યોતિષી સાથે વાત કરો.';

  @override
  String get insightsAskCta => 'તમારી કુંડળી વિશે કોઈ જ્યોતિષીને પૂછો.';

  @override
  String get insightsWhatItReadsFrom => 'આ શું વાંચે છે';

  @override
  String get insightsToneSupportive => 'સહાયક';

  @override
  String get insightsToneBalanced => 'સંતુલિત';

  @override
  String get insightsToneChallenging => 'કાળજીની જરૂર છે';

  @override
  String get insightsToneMixed => 'મિશ્ર';

  @override
  String get insightsAreaPersonality => 'વ્યક્તિત્વ અને સ્વભાવ';

  @override
  String get insightsAreaAppearance => 'શારીરિક દેખાવ';

  @override
  String get insightsAreaMind => 'મન અને લાગણીઓ';

  @override
  String get insightsAreaCareer => 'કારકિર્દી અને વ્યવસાય';

  @override
  String get insightsAreaWealth => 'સંપત્તિ અને નાણાકીય બાબતો';

  @override
  String get insightsAreaEducation => 'શિક્ષણ અને બુદ્ધિ';

  @override
  String get insightsAreaMarriage => 'લગ્ન અને જીવનસાથી';

  @override
  String get insightsAreaFamily => 'કુટુંબ અને સંબંધો';

  @override
  String get insightsAreaHealth => 'આરોગ્ય અને જીવનશક્તિ';

  @override
  String get insightsAreaFortune => 'ભાગ્ય અને ધર્મ';

  @override
  String get insightsAreaStrengths => 'શક્તિઓ અને પડકારો';

  @override
  String get predTitle => 'આગાહીઓ';

  @override
  String get predReadingTitle => 'તમારી આગાહી';

  @override
  String get predRequestTitle => 'આગાહીની વિનંતી કરો';

  @override
  String get predHeroTitle => 'તમારા માટે લખાયેલ આગાહી';

  @override
  String get predHeroBody =>
      'એક જ્યોતિષી તમારી જન્મકુંડળી, દશા અને વર્તમાન ગોચર વાંચે છે અને જીવનના એક ક્ષેત્ર માટે આગાહી લખે છે. તમારી ભાષામાં, સામાન્ય રીતે 3 દિવસની અંદર પહોંચાડવામાં આવે છે.';

  @override
  String get predChooseArea => 'કોઈ વિસ્તાર પસંદ કરો';

  @override
  String get predMyReadings => 'તમારા અનુમાન';

  @override
  String get predNoReadings =>
      'હજુ સુધી કોઈ આગાહી નથી. વિનંતી કરવા માટે ઉપરનો કોઈ વિસ્તાર પસંદ કરો.';

  @override
  String get predSeePacks => 'પેક જુઓ';

  @override
  String get predSubscribed => 'સબ્સ્ક્રાઇબ કર્યું';

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
  String get predBuyTitle => 'આગાહી ક્રેડિટ્સ';

  @override
  String get predBuyBody =>
      'એક ક્રેડિટ = એક લેખિત આગાહી. એક પેકેટ ખરીદો અને જ્યારે પણ તમે વાંચવા માંગો ત્યારે તે તૈયાર છે.';

  @override
  String get predBuyWalletNote => 'તમારા વોલેટ બેલેન્સમાંથી ચૂકવણી કરી.';

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
    return 'પ્રતિ ક્રેડિટ $price';
  }

  @override
  String predBuySuccess(int count) {
    return 'ઉમેર્યું. તમારી પાસે હવે $count ક્રેડિટ્સ છે.';
  }

  @override
  String get predForProfile => 'કયા જન્મ પ્રોફાઇલ માટે';

  @override
  String get predAddProfile => 'જન્મ પ્રોફાઇલ ઉમેરો';

  @override
  String get predPickProfile => 'પહેલા જન્મ પ્રોફાઇલ પસંદ કરો.';

  @override
  String get predArea => 'જીવન ક્ષેત્ર';

  @override
  String get predPeriod => 'સમયગાળો';

  @override
  String predCostsOne(int count) {
    return 'તમારા $count ક્રેડિટમાંથી 1નો ઉપયોગ કરે છે.';
  }

  @override
  String get predNoCreditYet =>
      'તમારે ક્રેડિટની જરૂર પડશે — અમે આગળ પેક બતાવીશું.';

  @override
  String get predRequestCta => 'આગાહીની વિનંતી કરો';

  @override
  String get predRequestDisclaimer =>
      'જ્યોતિષી તમારી કુંડળી, દશા અને ગોચર પરથી લખે છે. જ્યોતિષ શાસ્ત્ર ચિંતન અને આયોજન માટે માર્ગદર્શન છે, ગેરંટી નહીં.';

  @override
  String get predAreaCareer => 'કારકિર્દી અને કાર્ય';

  @override
  String get predAreaMarriage => 'લગ્ન અને પ્રેમ';

  @override
  String get predAreaFinance => 'નાણાં અને નાણાકીય વ્યવસ્થા';

  @override
  String get predAreaHealth => 'આરોગ્ય અને ઊર્જા';

  @override
  String get predAreaEducation => 'અભ્યાસ અને શિક્ષણ';

  @override
  String get predAreaGeneral => 'જીવન ઝાંખી';

  @override
  String get predPeriodMonth => 'આગામી મહિનો';

  @override
  String get predPeriodQuarter => 'આગામી ૩ મહિના';

  @override
  String get predPeriodYear => 'આગામી વર્ષ';

  @override
  String get predStatusWriting => 'લખાઈ રહ્યું છે';

  @override
  String get predStatusReview => 'સમીક્ષા હેઠળ';

  @override
  String get predStatusReady => 'વાંચવા માટે તૈયાર';

  @override
  String get predStatusUnavailable => 'ઉપલબ્ધ નથી';

  @override
  String get predStatusRefunded => 'રિફંડ કર્યું';

  @override
  String predDeliveredOn(String date) {
    return 'ડિલિવર $date';
  }

  @override
  String predEta(String date) {
    return '$date સુધીમાં અપેક્ષિત';
  }

  @override
  String get predWritingTitle => 'એક જ્યોતિષી આ લખી રહ્યા છે';

  @override
  String get predWritingBody => 'તે તૈયાર થતાં જ અમે તમને સૂચના મોકલીશું.';

  @override
  String predWritingEta(String date) {
    return '$date સુધીમાં અપેક્ષિત. તે તૈયાર થઈ જાય ત્યારે અમે તમને જાણ કરીશું.';
  }

  @override
  String get predRefundedTitle => 'ક્રેડિટ રિફંડ કરી';

  @override
  String get predRefundedBody =>
      'અમે આ સમયસર પહોંચાડી શક્યા નહીં, તેથી તમારું ક્રેડિટ તમારા ખાતામાં પાછું આવી ગયું છે.';

  @override
  String get predDisclaimer =>
      'તમારા જન્મકુંડળી, દશા અને વર્તમાન ગોચર પરથી એક જ્યોતિષીએ તમારા માટે લખ્યું છે. જ્યોતિષ એ ચિંતન અને આયોજન માટે માર્ગદર્શન છે - પસંદગીઓ અને પરિણામ તમારા જ રહે છે.';

  @override
  String get predAskFollowUp => 'અનુગામી પ્રશ્ન પૂછો';

  @override
  String get remediesTitle => 'ઉપાયો';

  @override
  String get remediesIntro =>
      'તમારા ચાર્ટમાં દર્શાવેલ પરંપરાગત ઉપાયો - સક્રિય દોષો, નબળા ગ્રહો, ચાલતી દશા અને તણાવપૂર્ણ ઘરો - સાથે મેળ ખાય છે. તે શિસ્ત અને ભક્તિના કાર્યો છે, જે તમારી શ્રદ્ધા, સ્વાસ્થ્ય અને સાધનને અનુરૂપ પસંદ કરવામાં આવ્યા છે.';

  @override
  String get remediesNone =>
      'તમારા ચાર્ટમાં એવું કંઈ ખાસ દેખાતું નથી જેના માટે હાલમાં કોઈ ચોક્કસ ઉપાયની જરૂર હોય. એક નાનો, સતત દૈનિક અભ્યાસ હંમેશા ફાયદાકારક છે.';

  @override
  String get remediesDisclaimer =>
      'તમારા વિશ્વાસ, સ્વાસ્થ્ય અને સાધન-સંપત્તિને અનુરૂપ હોય તે જ કરો. જો ઉપવાસ તમારા માટે અસુરક્ષિત હોય તો તેને છોડી દો, અને દાન આપવા માટે ક્યારેય ઉધાર ન લો.';

  @override
  String get remediesAskCta => 'તમારા ઉપાયો વિશે કોઈ જ્યોતિષી સાથે વાત કરો.';

  @override
  String get remediesConfirmCta => 'પહેલા કોઈ જ્યોતિષી પાસેથી ખાતરી કરો.';

  @override
  String remediesSource(String source) {
    return 'સ્ત્રોત: $source';
  }

  @override
  String get doshaSeeRemedies => 'તમારા ચાર્ટ માટે ઉપાયો જુઓ';

  @override
  String get remedyCatMantra => 'મંત્ર અને જાપ';

  @override
  String get remedyCatStotra => 'સ્તોત્ર અને પાઠ';

  @override
  String get remedyCatPuja => 'પૂજા અને ધાર્મિક વિધિ';

  @override
  String get remedyCatVrat => 'વ્રત અને ઉપવાસ';

  @override
  String get remedyCatDaan => 'દાન અને દાન';

  @override
  String get remedyCatLifestyle => 'જીવનશૈલી';

  @override
  String get remedyCatYantra => 'યંત્ર';

  @override
  String get remedyCatGemstone => 'રત્ન';

  @override
  String get remedyCatRudraksha => 'રુદ્રાક્ષ';

  @override
  String get prashnaTitle => 'એક પ્રશ્ન પૂછો';

  @override
  String get prashnaHeroTitle => 'અત્યારે હા કે ના';

  @override
  String get prashnaHeroBody =>
      'કેપી હોરારી (પ્રશ્ના) તમે પ્રશ્ન પૂછો છો તે જ ક્ષણે વાંચે છે - હા, ના અથવા મિશ્ર - તર્ક સાથે. એક પરંપરાગત પદ્ધતિનો નિર્દેશક, વચન નહીં.';

  @override
  String get prashnaAbout => 'પ્રશ્ન શેના વિશે છે?';

  @override
  String get prashnaHint => 'દા.ત. શું મને આ નોકરીની ઓફર મળશે?';

  @override
  String prashnaAskCta(String price) {
    return 'પૂછો ( $price )';
  }

  @override
  String get prashnaDisclaimer =>
      'તમે પૂછ્યું તે ક્ષણનું કેપીનું ભયાનક વાંચન. તે એક પરંપરાગત પદ્ધતિનો નિર્દેશક છે - વચન નથી, અને સંપૂર્ણ પરામર્શનો વિકલ્પ નથી.';

  @override
  String get prashnaNeedQuestion =>
      'પહેલા કોઈ વિષય પસંદ કરો અને તમારો પ્રશ્ન લખો.';

  @override
  String get prashnaLowBalance =>
      'તમારા વોલેટ બેલેન્સ ખૂબ ઓછા છે. માંગવા માટે પૈસા ઉમેરો.';

  @override
  String get prashnaHistory => 'તમારા પ્રશ્નો';

  @override
  String get prashnaNoHistory => 'તમે હજુ સુધી કોઈ પ્રશ્ન પૂછ્યો નથી.';

  @override
  String get prashnaAnswerTitle => 'વાંચન';

  @override
  String get prashnaAskAstrologer => 'કોઈ જ્યોતિષી સાથે વાત કરો.';

  @override
  String get prashnaHowRead => 'આ કેવી રીતે વાંચવામાં આવ્યું';

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
  String get prashnaVerdictYes => 'હા તરફ ઝૂકવું';

  @override
  String get prashnaVerdictNo => 'ના તરફ ઝૂકવું';

  @override
  String get prashnaVerdictMixed => 'મિશ્ર સંકેતો';

  @override
  String get prashnaVerdictUnclear => 'નિર્ણાયક નથી';

  @override
  String get prashnaCatMarriage => 'લગ્ન';

  @override
  String get prashnaCatJob => 'નોકરી';

  @override
  String get prashnaCatPromotion => 'પ્રમોશન';

  @override
  String get prashnaCatBusiness => 'વ્યવસાય';

  @override
  String get prashnaCatProperty => 'મિલકત';

  @override
  String get prashnaCatMoney => 'લોન કે પૈસા';

  @override
  String get prashnaCatChild => 'બાળકો';

  @override
  String get prashnaCatTravel => 'વિદેશ યાત્રા';

  @override
  String get prashnaCatLitigation => 'કોર્ટનો મામલો';

  @override
  String get prashnaCatHealth => 'આરોગ્ય અને પુનઃપ્રાપ્તિ';

  @override
  String get prashnaCatLost => 'ખોવાયેલી વસ્તુ';

  @override
  String get prashnaCatReunion => 'પુનઃમિલન';

  @override
  String get prashnaCatGeneral => 'કંઈક બીજું';

  @override
  String get yogaIntro =>
      'યોગ એ વૃત્તિઓ છે, ગેરંટી નથી - જ્યારે ગ્રહો યોગ્ય સ્થાને હોય અને તેમની દશા ચલાવતા હોય ત્યારે તે મજબૂત બને છે.';

  @override
  String get yogaNoneTitle => 'કોઈ શાસ્ત્રીય યોગ મળ્યા નથી.';

  @override
  String get yogaNoneBody =>
      'તે સામાન્ય છે અને ખરાબ સંકેત નથી - ચાર્ટ હજુ પણ તેના ઘરો અને દશામાં વાંચવામાં આવે છે.';

  @override
  String get kundaliTalkToAstrologer => 'કોઈ જ્યોતિષી સાથે વાત કરો.';

  @override
  String get kundaliHowItPlaysOut =>
      'શું તમે જાણવા માંગો છો કે આ તમારા જીવનમાં અને સમયમાં કેવી રીતે કાર્ય કરે છે?';

  @override
  String get yogaGajakesariName => 'ગજકેસરી યોગ';

  @override
  String get yogaGajakesariMeaning =>
      'ચંદ્ર પરથી કેન્દ્રમાં ગુરુ - સંતુલન, સારો નિર્ણય અને વજન ધરાવતું નામ.';

  @override
  String get yogaBudhadityaName => 'બુધાદિત્ય યોગ';

  @override
  String get yogaBudhadityaMeaning =>
      'સૂર્ય અને બુધ એકસાથે - એક તીક્ષ્ણ, અભિવ્યક્ત મન; અભ્યાસ, લેખન અને વિશ્લેષણ માટે મજબૂત.';

  @override
  String get yogaChandraMangalaName => 'ચંદ્ર-મંગલા યોગ';

  @override
  String get yogaChandraMangalaMeaning =>
      'મંગળ સાથે ચંદ્ર - પૈસા અને સાહસની આસપાસ ફરવું; પ્રયત્ન અને પહેલ દ્વારા કમાણી કરવી.';

  @override
  String get yogaRajaName => 'રાજયોગ';

  @override
  String get yogaRajaMeaning =>
      'ત્રિકોણ સ્વામી સાથે બંધાયેલ કેન્દ્ર સ્વામી - જ્યારે સમયગાળો ચાલે છે ત્યારે સ્થિતિ, સત્તા અને તકમાં વધારો.';

  @override
  String get yogaDhanaName => 'ધન યોગ';

  @override
  String get yogaDhanaMeaning =>
      'સંપત્તિ અને લાભ એકબીજા સાથે જોડાયેલા છે - બચત અને સ્થિર નાણાકીય વૃદ્ધિને ટેકો આપે છે.';

  @override
  String get yogaNeechabhangaName => 'નીચભંગ રાજયોગ';

  @override
  String get yogaNeechabhangaMeaning =>
      'એક કમજોર ગ્રહ જેની નબળાઈ રદ થઈ ગઈ છે - એક પ્રારંભિક સંઘર્ષ જે શક્તિમાં ફેરવાય છે.';

  @override
  String get yogaKaalSarpaName => 'કાલ સર્પ યોગ';

  @override
  String get yogaKaalSarpaMeaning =>
      'રાહુ-કેતુ ધરીની એક બાજુ પરના બધા સાત ગ્રહો - સ્પષ્ટ દિશા ન મળે ત્યાં સુધી જીવન ફસાયેલું અનુભવાય છે.';

  @override
  String get yogaAdhiName => 'આધિ યોગ';

  @override
  String get yogaAdhiMeaning =>
      'ચંદ્રથી છઠ્ઠા, સાતમા અને આઠમા ભાવમાં લાભ - રક્ષણ, સક્ષમ સહાયકો અને સ્થિર સ્થિતિ.';

  @override
  String get yogaShakataName => 'શકત યોગ';

  @override
  String get yogaShakataMeaning =>
      'ગુરુ ગ્રહથી છઠ્ઠા, આઠમા કે બારમા ભાવમાં ચંદ્ર - ભાગ્યમાં ઉદય અને અસ્ત થાય છે; જ્યારે ચંદ્ર બળવાન હોય છે ત્યારે તે સ્થિર રહે છે.';

  @override
  String get yogaVishName => 'વિશ યોગ';

  @override
  String get yogaVishMeaning =>
      'શનિ સાથે ચંદ્ર - મન ભાર ધરાવે છે; પરિણામો પરિપક્વતા સાથે મોડેથી આવે છે.';

  @override
  String get yogaKahalaName => 'કહલા યોગ';

  @override
  String get yogaKahalaMeaning =>
      'મજબૂત લગ્ન સ્વામી સાથે પરસ્પર કેન્દ્રમાં ચોથા અને નવમા સ્વામી - બોલ્ડ, સાહસિક, જોખમ લેવા તૈયાર.';

  @override
  String get yogaPushkalaName => 'પુષ્કળ યોગ';

  @override
  String get yogaPushkalaMeaning =>
      'ચંદ્રનો સ્વામી લગ્ન સ્વામી સાથે કેન્દ્રમાં - આદર, સારું નામ અને પ્રેરક વાણી.';

  @override
  String get yogaDaridraName => 'દરિદ્ર યોગ';

  @override
  String get yogaDaridraMeaning =>
      '૧૧મા (લાભ) સ્વામી મુશ્કેલ ઘરમાં પડ્યા - લાભ ધીમે ધીમે આવે છે; એક મજબૂત દશા તેને ફેરવી નાખે છે.';

  @override
  String get yogaAmalaName => 'અમલા યોગ';

  @override
  String get yogaAmalaMeaning =>
      'લગ્ન કે ચંદ્રથી દસમા દિવસે માત્ર એક શુભ કાર્ય - સ્વચ્છ પ્રતિષ્ઠા અને કાયમી શુભકામનાઓ.';

  @override
  String get yogaSaraswatiName => 'સરસ્વતી યોગ';

  @override
  String get yogaSaraswatiMeaning =>
      'બુધ, શુક્ર અને એક મજબૂત ગુરુ સારી સ્થિતિમાં છે - શિક્ષણ, કલા અને વાક્પટુતા.';

  @override
  String get yogaLakshmiName => 'લક્ષ્મી યોગ';

  @override
  String get yogaLakshmiMeaning =>
      'કેન્દ્ર અથવા ત્રિકોણમાં એક મજબૂત 9મો સ્વામી, જેમાં મજબૂત લગ્ન સ્વામી હોય છે - નસીબ, આરામ અને કૃપા.';

  @override
  String get yogaRuchakaName => 'રૂચકા યોગ';

  @override
  String get yogaRuchakaMeaning =>
      'મંગળ ગ્રહ કેન્દ્રમાં મજબૂત છે - હિંમત, શારીરિક શક્તિ અને દબાણ હેઠળ નેતૃત્વ.';

  @override
  String get yogaBhadraName => 'ભદ્ર યોગ';

  @override
  String get yogaBhadraMeaning =>
      'કેન્દ્રમાં બુધ મજબૂત છે - બુદ્ધિ, સ્પષ્ટ વાણી અને વેપાર અને સંદેશાવ્યવહારમાં કુશળતા.';

  @override
  String get yogaHamsaName => 'હમસા યોગ';

  @override
  String get yogaHamsaMeaning =>
      'કેન્દ્રમાં ગુરુ મજબૂત છે - શાણપણ, નીતિશાસ્ત્ર, શિક્ષણ અથવા સલાહકારી સ્વભાવ અને સામાન્ય સૌભાગ્ય.';

  @override
  String get yogaMalavyaName => 'માલવ્ય યોગ';

  @override
  String get yogaMalavyaMeaning =>
      'શુક્ર કેન્દ્રમાં મજબૂત છે - વશીકરણ, આરામ, સુંદરતા પર નજર અને સુખદ ગૃહસ્થ જીવન.';

  @override
  String get yogaSasaName => 'સાસા યોગ';

  @override
  String get yogaSasaMeaning =>
      'શનિ એક કેન્દ્રમાં મજબૂત છે - શિસ્ત, સહનશક્તિ અને સત્તા ધીમે ધીમે બનાવવામાં આવે છે અને જાળવી રાખવામાં આવે છે.';

  @override
  String get yogaUbhayachariName => 'ઉભાચારી યોગ';

  @override
  String get yogaUbhayachariMeaning =>
      'સૂર્યની બંને બાજુએ આવેલા ગ્રહો - સારી રીતે સમર્થિત, દૃશ્યમાન જીવન અને સારી સર્વાંગી સ્થિતિ.';

  @override
  String get yogaVesiName => 'વેસી યોગ';

  @override
  String get yogaVesiMeaning =>
      'સૂર્યથી બીજા ભાવમાં આવેલો ગ્રહ - સ્થિર વાણી, સંતુલિત દૃષ્ટિકોણ અને ન્યાયી નામ.';

  @override
  String get yogaVasiName => 'વાસી યોગ';

  @override
  String get yogaVasiMeaning =>
      'સૂર્યથી ૧૨મા ભાવમાં આવેલો ગ્રહ - ક્ષમતા, પ્રભાવ અને ઉદારતા.';

  @override
  String get yogaShubhaKartariName => 'શુભા કર્તારી યોગ';

  @override
  String get yogaShubhaKartariMeaning =>
      'લગ્નની બંને બાજુના ફાયદા - રક્ષણ, નરમ માર્ગ અને મદદરૂપ પરિસ્થિતિઓ.';

  @override
  String get yogaPapaKartariName => 'પાપા કરતારી યોગ';

  @override
  String get yogaPapaKartariMeaning =>
      'લગ્નની બંને બાજુ ખરાબ અસરો - સ્વ અને સ્વાસ્થ્ય પર દબાણ; તમારી ઉર્જા અને સીમાઓનું રક્ષણ કરો.';

  @override
  String get yogaDurudharaName => 'દુરુધાર યોગ';

  @override
  String get yogaDurudharaMeaning =>
      'બીજા અને બારમા ભાવમાં ચંદ્રની બાજુમાં ગ્રહો છે - તમારી આસપાસ સંસાધનો, આરામ અને સ્થિર ટેકો.';

  @override
  String get yogaSunaphaName => 'સુનાફા યોગ';

  @override
  String get yogaSunaphaMeaning =>
      'ચંદ્રથી બીજા ભાવમાં આવેલો ગ્રહ - સ્વ-નિર્મિત સાધન, બુદ્ધિ અને સારી પ્રતિષ્ઠા.';

  @override
  String get yogaAnaphaName => 'અનાફા યોગ';

  @override
  String get yogaAnaphaMeaning =>
      'ચંદ્રથી બારમા ભાવમાં આવેલો ગ્રહ - સરળ સ્વભાવ, સુખાકારી અને જરૂરિયાતથી મુક્ત.';

  @override
  String get yogaKemadrumaYogaName => 'કેમાદ્રુમ યોગ';

  @override
  String get yogaKemadrumaYogaMeaning =>
      'ચંદ્ર એકલો ઊભો છે, કોઈ ટેકો વગર - એક આંતરિક બેચેની જે ચંદ્ર બળવાન હોય અથવા કોઈ કેન્દ્રમાં કામ કરતી હોય ત્યારે ઓછી થાય છે.';

  @override
  String get yogaVasumatiName => 'વાસુમતી યોગ';

  @override
  String get yogaVasumatiMeaning =>
      'લગ્ન અથવા ચંદ્રના વિકાસ ગૃહોમાં ફાયદા - સંપત્તિનો સંચય અને સંસાધનોમાં વધારો.';

  @override
  String get yogaKalanidhiName => 'કલાનિધિ યોગ';

  @override
  String get yogaKalanidhiMeaning =>
      'બીજા કે પાંચમા ભાવમાં ગુરુ બુધ અથવા શુક્ર સાથે જોડાયેલો છે - શિક્ષણ, કળા, સંસ્કારિતા અને સન્માન.';

  @override
  String get yogaChamaraName => 'ચમારા યોગ';

  @override
  String get yogaChamaraMeaning =>
      'ગુરુ ગ્રહ દ્વારા દૃષ્ટિ પામેલા કેન્દ્રમાં એક ઉચ્ચ લગ્ન સ્વામી - વાક્પટુતા, લાંબુ આયુષ્ય અને આદરણીય પદ.';

  @override
  String get yogaShankhaName => 'શંખ યોગ';

  @override
  String get yogaShankhaMeaning =>
      'પાંચમા અને છઠ્ઠા સ્વામીઓ મજબૂત લગ્ન સ્વામી સાથે જોડાયેલા હતા - સારું જીવન, દયાળુ સ્વભાવ અને પછીના વર્ષોમાં આરામ.';

  @override
  String get yogaParvataName => 'પર્વત યોગ';

  @override
  String get yogaParvataMeaning =>
      'છઠ્ઠા અને આઠમા સ્વચ્છતા સાથે કેન્દ્રોમાં લાભદાયી - નસીબ, ઉદારતા અને એક પ્રખ્યાત નામ.';

  @override
  String get yogaHarshaName => 'હર્ષ યોગ';

  @override
  String get yogaHarshaMeaning =>
      'મુશ્કેલ ઘરમાં છઠ્ઠો સ્વામી - દુશ્મનો, દેવા અને બીમારીઓ તેમની પકડ ગુમાવે છે; સ્પર્ધાત્મક શક્તિ.';

  @override
  String get yogaSaralaName => 'સરલા યોગ';

  @override
  String get yogaSaralaMeaning =>
      'મુશ્કેલ ઘરમાં 8મો સ્વામી - કટોકટી, દીર્ધાયુષ્ય અને નિર્ભયતા દ્વારા સ્થિતિસ્થાપકતા.';

  @override
  String get yogaVimalaName => 'વિમલા યોગ';

  @override
  String get yogaVimalaMeaning =>
      'મુશ્કેલ ઘરમાં ૧૨મો સ્વામી - નિયંત્રિત ખર્ચ, સ્વચ્છ અંતરાત્મા અને સ્વતંત્ર જીવન.';

  @override
  String get yogaMahaParivartanaName => 'મહા પરિવર્તન યોગ';

  @override
  String get yogaMahaParivartanaMeaning =>
      'સારા ઘરોના બે સ્વામીઓ એકબીજાને સંકેતો આપે છે - બંને ઘરોના મામલા સમય જતાં એકબીજાને ઉંચા કરે છે.';

  @override
  String get yogaKhalaParivartanaName => 'ખલા પરિવર્તન યોગ';

  @override
  String get yogaKhalaParivartanaMeaning =>
      'ત્રીજા ઘર સાથે વાતચીત - મિશ્ર પરિણામો, ઉતાર-ચઢાવ, પ્રયત્નો અને હિંમત દ્વારા લાભ.';

  @override
  String get yogaDainyaParivartanaName => 'દૈનિક પરિવર્તન યોગ';

  @override
  String get yogaDainyaParivartanaMeaning =>
      'એક મુશ્કેલ ઘર સાથે જોડાયેલી વાતચીત - એવા અવરોધો જેને ધીરજની જરૂર હોય છે; એક મજબૂત દશા તેને ફેરવે છે.';

  @override
  String get kSignAries => 'બોલ્ડ, સીધું, ઝડપથી શરૂ થતું';

  @override
  String get kSignTaurus => 'સ્થિર, વિષયાસક્ત, આરામ અને સુરક્ષાને મહત્વ આપે છે';

  @override
  String get kSignGemini => 'જિજ્ઞાસુ, મૌખિક, ઝડપી વિચારશીલ';

  @override
  String get kSignCancer => 'સંભાળ રાખનાર, રક્ષણાત્મક, લાગણી દ્વારા સંચાલિત';

  @override
  String get kSignLeo => 'ગર્વિત, ઉષ્માભર્યું, જોવા માંગે છે';

  @override
  String get kSignVirgo => 'ચોક્કસ, ઉપયોગી, સુધારાલક્ષી';

  @override
  String get kSignLibra => 'વાજબી, સંબંધી, સંતુલન શોધે છે';

  @override
  String get kSignScorpio => 'તીવ્ર, ખાનગી, બધું જ અથવા કંઈ જ નહીં';

  @override
  String get kSignSagittarius => 'મુક્ત, વિશ્વાસુ, મોટું ચિત્ર';

  @override
  String get kSignCapricorn => 'શિસ્તબદ્ધ, મહત્વાકાંક્ષી, લાંબી રમત રમે છે';

  @override
  String get kSignAquarius => 'સ્વતંત્ર, પ્રણાલીગત, અપરંપરાગત';

  @override
  String get kSignPisces => 'કલ્પનાશીલ, દયાળુ, સીમા-રહિત';

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
  String get kPlanetSun => 'આત્મા, આત્મવિશ્વાસ, પિતા, સત્તા';

  @override
  String get kPlanetMoon => 'મન, લાગણીઓ, માતા, આરામ';

  @override
  String get kPlanetMars => 'ઉત્સાહ, હિંમત, ગુસ્સો, ભાઈ-બહેનો';

  @override
  String get kPlanetMercury => 'બુદ્ધિ, વાણી, વેપાર, કૌશલ્ય';

  @override
  String get kPlanetJupiter => 'શાણપણ, વિકાસ, નસીબ, શિક્ષકો, બાળકો';

  @override
  String get kPlanetVenus => 'પ્રેમ, સુંદરતા, આરામ, ભાગીદારી, કલા';

  @override
  String get kPlanetSaturn => 'શિસ્ત, સમય, મર્યાદા, મહેનતથી મેળવેલ પુરસ્કાર';

  @override
  String get kPlanetRahu => 'મહત્વાકાંક્ષા, જુસ્સો, વિદેશી અને નવું';

  @override
  String get kPlanetKetu => 'અલગતા, નિપુણતા, છોડી દેવા, આધ્યાત્મિકતા';

  @override
  String get kHouse1 => 'સ્વ, શરીર, જીવનશક્તિ';

  @override
  String get kHouse2 => 'ધન, પરિવાર, વાણી, ખોરાક';

  @override
  String get kHouse3 => 'હિંમત, ભાઈ-બહેનો, પ્રયત્નો, ટૂંકી મુસાફરી';

  @override
  String get kHouse4 => 'ઘર, માતા, ભૂમિ, આંતરિક શાંતિ';

  @override
  String get kHouse5 => 'બાળકો, શિક્ષણ, સર્જનાત્મકતા, રોમાંસ';

  @override
  String get kHouse6 => 'સ્વાસ્થ્ય, દેવું, દુશ્મનો, રોજિંદા કામ';

  @override
  String get kHouse7 => 'લગ્ન, ભાગીદારી, વ્યવસાય';

  @override
  String get kHouse8 => 'દીર્ધાયુષ્ય, અચાનક પરિવર્તન, છુપાયેલ વારસો';

  @override
  String get kHouse9 => 'ભાગ્ય, ધર્મ, પિતા, ઉચ્ચ શિક્ષણ, લાંબી મુસાફરી';

  @override
  String get kHouse10 => 'કારકિર્દી, સ્થિતિ, જાહેર જીવન';

  @override
  String get kHouse11 => 'આવક, નફો, નેટવર્ક, મોટા ભાઈ-બહેન';

  @override
  String get kHouse12 => 'નુકસાન, ખર્ચ, વિદેશી ભૂમિ, ઊંઘ, મુક્તિ';

  @override
  String get kDignityExalted => 'ઉત્કૃષ્ટ — ખૂબ જ મજબૂત';

  @override
  String get kDignityDebilitated => 'કમજોર - અહીં તણાવ હેઠળ';

  @override
  String get kDignityMoolatrikona => 'મૂલાટ્રિકોના — આરામદાયક અને મજબૂત';

  @override
  String get kDignityOwn => 'પોતાનું ચિહ્ન - સ્થિર અને અસરકારક';

  @override
  String get kDignityGreatFriend => 'એક મહાન મિત્રના સંકેતમાં — ટેકો મળ્યો';

  @override
  String get kDignityFriend => 'મિત્રના સંકેતમાં — ટેકો આપ્યો';

  @override
  String get kDignityNeutral => 'તટસ્થ ચિહ્ન';

  @override
  String get kDignityEnemy => 'દુશ્મનની નિશાનીમાં - વધુ મહેનત કરે છે';

  @override
  String get kDignityGreatEnemy => 'એક મહાન દુશ્મનના સંકેતમાં - દબાણ હેઠળ';

  @override
  String get kDashaSun =>
      'ઓળખ, અધિકાર અને ઓળખનો સમયગાળો. આંખો/હૃદયના અહંકાર અને સ્વાસ્થ્ય પર ધ્યાન કેન્દ્રિત કરવામાં આવે છે.';

  @override
  String get kDashaMoon =>
      'એક નરમ, વધુ ભાવનાત્મક પ્રકરણ - ઘર, માતા, મૂડ અને જાહેર જીવન.';

  @override
  String get kDashaMars =>
      'ઉર્જા, સ્પર્ધા અને પહેલ વધે છે. ગુસ્સો, અકસ્માતો અને મિલકતના મામલાઓ પર નજર રાખો.';

  @override
  String get kDashaMercury =>
      'શીખવું, વેપાર કરવો, લેખન કરવું અને વાતચીત કરવી. અભ્યાસ અને વ્યવસાય માટે સારું, શાંતિ માટે બેચેન.';

  @override
  String get kDashaJupiter =>
      'વિકાસ, શિક્ષકો, પરિવાર, અર્થ. ઘણીવાર એક ભાગ્યશાળી, વિસ્તૃત તબક્કો.';

  @override
  String get kDashaVenus =>
      'સંબંધો, આરામ, કલા, પૈસા અને આનંદ. સામાન્ય રીતે આ સમયગાળો સૌથી સરળ હોય છે.';

  @override
  String get kDashaSaturn =>
      'સખત મહેનત, જવાબદારી અને ધીમા, સ્થાયી પરિણામો. ધીરજને પુરસ્કાર આપે છે; ટૂંકા ગાળાની સજા આપે છે.';

  @override
  String get kDashaRahu =>
      'મર્યાદા વિનાની મહત્વાકાંક્ષા - વિદેશી ભૂમિ, ટેકનોલોજી, અચાનક ઉદય અને મૂંઝવણ.';

  @override
  String get kDashaKetu =>
      'અલગતા, અંત અને આધ્યાત્મિક આંતરિક વળાંક. ભૌતિક વસ્તુઓ પોકળ લાગે છે; કૌશલ્ય વધુ ઊંડું થાય છે.';

  @override
  String get kNakAshwini => 'ઝડપી, અગ્રણી, ઉપચાર';

  @override
  String get kNakBharani => 'તીવ્ર, પરિવર્તન માટે જગ્યા ધરાવે છે, શિસ્તબદ્ધ';

  @override
  String get kNakKrittika => 'તીક્ષ્ણ, કાપનાર, રક્ષણાત્મક';

  @override
  String get kNakRohini => 'સર્જનાત્મક, વિષયાસક્ત, પોષણ આપનાર, ચુંબકીય';

  @override
  String get kNakMrigashira => 'શોધક, જિજ્ઞાસુ, સૌમ્ય';

  @override
  String get kNakArdra => 'તોફાની, પરિવર્તનશીલ, દબાણ હેઠળ તેજસ્વી';

  @override
  String get kNakPunarvasu => 'નવીકરણ કરનાર, ઉદાર, સલામતીમાં પાછા ફરનાર';

  @override
  String get kNakPushya => 'પોષણ આપનાર, કર્તવ્યનિષ્ઠ, ઊંડાણપૂર્વક સહાયક';

  @override
  String get kNakAshlesha => 'સમજદાર, વ્યૂહાત્મક, કૃત્રિમ ઊંઘની';

  @override
  String get kNakMagha => 'રાજવી, પરંપરાથી બંધાયેલ, પૂર્વજોનું';

  @override
  String get kNakPurvaPhalguni => 'રમતિયાળ, રોમેન્ટિક, ફુરસદને મહત્વ આપે છે';

  @override
  String get kNakUttaraPhalguni => 'વિશ્વસનીય, કરારબદ્ધ, મદદરૂપ';

  @override
  String get kNakHasta => 'હાથોમાં કુશળ, હોશિયાર, ઉપચાર કરનાર';

  @override
  String get kNakChitra => 'કલાત્મક, આકર્ષક, સુંદર વસ્તુઓ બનાવે છે';

  @override
  String get kNakSwati => 'સ્વતંત્ર, અનુકૂલનશીલ, સ્વતંત્રતા-પ્રેમાળ';

  @override
  String get kNakVishakha => 'ધ્યેય-સંચાલિત, દૃઢનિશ્ચયી, દ્વિ-સ્વભાવ ધરાવતું';

  @override
  String get kNakAnuradha => 'સમર્પિત, મૈત્રીપૂર્ણ, વિદેશમાં સમૃદ્ધ';

  @override
  String get kNakJyeshtha => 'વરિષ્ઠ, જવાબદાર, બોજ વહન કરે છે';

  @override
  String get kNakMula => 'મૂળ શોધનાર, આમૂલ, મૂળ સુધી પહોંચે છે';

  @override
  String get kNakPurvaAshadha => 'અજેય ભાવના, સમજાવટભરી';

  @override
  String get kNakUttaraAshadha => 'સિદ્ધાંતવાદી, સ્થાયી, પછીની સફળતા';

  @override
  String get kNakShravana => 'સાંભળવું, શીખવું, લોકોને જોડવા';

  @override
  String get kNakDhanishta => 'લયબદ્ધ, સમૃદ્ધ, સંગીતમય, અનુકૂલનશીલ';

  @override
  String get kNakShatabhisha => 'ખાનગી, ઉપચારાત્મક, પ્રણાલીગત';

  @override
  String get kNakPurvaBhadrapada => 'આદર્શવાદી, તીવ્ર, પરિવર્તનશીલ';

  @override
  String get kNakUttaraBhadrapada => 'ઊંડી, શાંત, શાણી સલાહ';

  @override
  String get kNakRevati => 'દયાળુ, મુસાફરોનું રક્ષણ કરનાર, કલ્પનાશીલ';

  @override
  String get kSadeSatiRising =>
      'ઉદય તબક્કો — શનિ તમારા ચંદ્રથી ૧૨મા રાશિમાં છે. અંત, થાક અને વસ્તુઓ બંધ થવાની લાગણી. જે હવે કામ કરતું નથી તેને સાફ કરવાનું શરૂ કરો.';

  @override
  String get kSadeSatiPeak =>
      'ટોચ તબક્કો — શનિ તમારી ચંદ્ર રાશિ ઉપર છે. સૌથી ભારે તાણ: જવાબદારી, દબાણ અને ધીમી પ્રગતિ. દિનચર્યાઓ રાખો, તમારા સ્વાસ્થ્યનું રક્ષણ કરો.';

  @override
  String get kSadeSatiSetting =>
      'અસ્તનો તબક્કો — શનિ તમારા ચંદ્રથી બીજા રાશિમાં છે. વજન વધે છે. પૈસા અને પરિવાર સ્થિર થાય છે; છેલ્લા વર્ષોના પાઠ ફળ આપવા લાગે છે.';

  @override
  String get kSadeSatiGeneric =>
      'શનિ તમારા ચંદ્રની આસપાસ રાશિઓનું ગોચર કરી રહ્યો છે.';

  @override
  String kPlanetInSignHouse(
    Object planet,
    Object sign,
    Object signTrait,
    Object house,
    Object houseTheme,
  ) {
    return '$sign માં તમારો $planet તમને $signTrait બનાવે છે. $house ઘરમાં તે $houseTheme સ્પર્શે છે.';
  }

  @override
  String kPlanetInSign(Object planet, Object sign, Object signTrait) {
    return 'Your $planet in $sign makes you $signTrait.';
  }

  @override
  String get kHouseSans1 => 'તનુ ભાવ';

  @override
  String get kHouseSans2 => 'ધન ભાવ';

  @override
  String get kHouseSans3 => 'સહજ ભાવ';

  @override
  String get kHouseSans4 => 'સુખા ભવ';

  @override
  String get kHouseSans5 => 'પુત્ર ભવ';

  @override
  String get kHouseSans6 => 'રિપુ ભવ';

  @override
  String get kHouseSans7 => 'યુવતી ભવ';

  @override
  String get kHouseSans8 => 'આયુ / રાંધ્ર ભાવ';

  @override
  String get kHouseSans9 => 'ધર્મભાવ';

  @override
  String get kHouseSans10 => 'કર્મભાવ';

  @override
  String get kHouseSans11 => 'લાભ ભાવ';

  @override
  String get kHouseSans12 => 'વ્યાયા ભાવ';

  @override
  String kHouseTitleWithSign(Object sign, Object theme) {
    return '$sign · $theme';
  }

  @override
  String kHouseSheetTitle(Object ordinal, Object sign) {
    return '$ordinal ઘર · $sign';
  }

  @override
  String kHouseSheetSubtitle(Object sanskrit, Object theme) {
    return '$sanskrit — $theme';
  }

  @override
  String kHouseChipLord(Object lord) {
    return 'ઘરનો સ્વામી · $lord';
  }

  @override
  String kHouseChipLordIn(Object nthHouse) {
    return '$nthHouse માં ભગવાન';
  }

  @override
  String kHouseNoPlanets(Object lord, Object lordWhere) {
    return 'આ ઘરમાં કોઈ ગ્રહો નથી. તેની વાર્તા મુખ્યત્વે તેના સ્વામી, $lord $lordWhere દ્વારા કહેવામાં આવે છે.';
  }

  @override
  String kHouseLordWhere(Object nthHouse) {
    return ', હવે $nthHouse માં';
  }

  @override
  String get kHousePlanetsHeader => 'આ ઘરમાં ગ્રહો';

  @override
  String kHouseAskCta(Object ordinal) {
    return 'તમારા $ordinal ઘર વિશે કોઈ જ્યોતિષીને પૂછો.';
  }

  @override
  String kHouseReadingLord(
    Object ordinal,
    Object lord,
    Object nthHouse,
    Object theme,
    Object lordTheme,
  ) {
    return 'તમારા $ordinal -હાઉસ લોર્ડ $lord $nthHouse માં બેસે છે, તેથી $theme $lordTheme સાથે જોડાય છે.';
  }

  @override
  String kHouseReadingOccupant(
    Object planet,
    Object planetTheme,
    Object theme,
  ) {
    return '$planet અહીં તેની થીમ્સ - $planetTheme - ને $theme માં લાવે છે.';
  }

  @override
  String get kHouseReadingEmpty =>
      'આ ઘર તેના સ્વામી અને તેના દ્રષ્ટિકોણવાળા ગ્રહો દ્વારા વાંચવામાં આવે છે. કોઈ જ્યોતિષી તમને આ વિશે માર્ગદર્શન આપી શકે છે.';

  @override
  String kBhavaSubheadKaraka(Object karaka) {
    return 'કરક $karaka';
  }

  @override
  String kBhavaSubheadLord(Object lord, Object nthHouse) {
    return 'સ્વામી $lord , $nthHouse';
  }

  @override
  String kBhavaSubheadLordOnly(Object lord) {
    return 'સ્વામી $lord';
  }

  @override
  String kBhavaReadingGoverns(Object theme) {
    return 'આ ઘર $theme ને સંચાલિત કરે છે.';
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
    return 'તેનો સ્વામી $lord $nthHouse માં છે, તેથી $theme $lordTheme સાથે જોડાય છે. $dignity $occupants';
  }

  @override
  String kBhavaReadingDignity(Object dignity) {
    return ' સ્વામી $dignity છે.';
  }

  @override
  String kBhavaReadingOccupants(Object planets, Object themes) {
    return ' $planets અહીં બેસે છે, $themes ઉમેરી રહ્યા છે.';
  }

  @override
  String kTransitHouseLine(Object nthHouse, Object theme) {
    return 'તમારું $nthHouse · $theme';
  }

  @override
  String kPlanetRowMeta(Object sign, Object nthHouse, Object degree) {
    return '$sign · $nthHouse · $degree °';
  }

  @override
  String kLagnaLordIn(Object nthHouse) {
    return '$nthHouse માં';
  }

  @override
  String get kDignityShortExalted => 'ઉન્નત';

  @override
  String get kDignityShortMoolatrikona => 'મૂલાટ્રિકોના';

  @override
  String get kDignityShortOwn => 'પોતાનું';

  @override
  String get kDignityShortDebilitated => 'કમજોર';

  @override
  String get kDignityShortEnemy => 'દુશ્મનનું ચિહ્ન';

  @override
  String get kDignityShortGreatEnemy => 'મહાન શત્રુ';

  @override
  String get kCombustNote =>
      'દહન - સૂર્યની ખૂબ નજીક, તેથી તેનો સ્વતંત્ર અવાજ ઝાંખો પડી જાય છે.';

  @override
  String get kWhatThisMeans => 'આનો તમારા માટે શું અર્થ થાય છે?';

  @override
  String get ovStrengthStrong => 'મજબૂત';

  @override
  String get ovStrengthSteady => 'સ્થિર';

  @override
  String get ovStrengthStrain => 'દબાણ હેઠળ';

  @override
  String get ovStrengthWeak => 'નબળું';

  @override
  String get ovRoleSpouse => 'જીવનસાથીનો અર્થ દર્શાવનાર';

  @override
  String get ovRoleDarakaraka => 'દારકારકા (જૈમિની)';

  @override
  String get ovRoleWealth => 'સંપત્તિનો અર્થ દર્શાવનાર';

  @override
  String get ovRoleIntellect => 'બુદ્ધિ અર્થકર્તા';

  @override
  String get ovRoleWisdom => 'શાણપણનો અર્થ દર્શાવનાર';

  @override
  String get ovRoleFortune => 'ભાગ્ય સૂચક';

  @override
  String get ovRoleFather => 'પિતા અર્થકર્તા';

  @override
  String get ovRoleMother => 'માતાનો અર્થ દર્શાવનાર';

  @override
  String get ovRoleGeneric => 'સિગ્નિફિકેટર';

  @override
  String ovfPada(int pada) {
    return 'પાડા $pada';
  }

  @override
  String ovfLagnaSign(Object sign) {
    return 'ઉદય ચિહ્ન $sign';
  }

  @override
  String ovfLagnaLord(Object planet, Object nthHouse, Object dignity) {
    return '$nthHouse $dignity માં લગ્નનો સ્વામી $planet';
  }

  @override
  String ovfHouseLord(Object ordinal, Object planet, Object nthHouse) {
    return '$nthHouse માં $ordinal -ગ્રહ સ્વામી $planet';
  }

  @override
  String ovfHouseStrength(Object ordinal, Object strength) {
    return '$ordinal ઘર — $strength';
  }

  @override
  String ovfMoonSign(Object sign) {
    return 'ચંદ્ર $sign માં';
  }

  @override
  String ovfMoonHouse(Object nthHouse) {
    return '$nthHouse ચંદ્ર';
  }

  @override
  String ovfMoonNakshatra(Object nakshatra) {
    return 'ચંદ્ર નક્ષત્ર $nakshatra';
  }

  @override
  String ovfMoonDignity(Object dignity) {
    return 'ચંદ્ર $dignity';
  }

  @override
  String ovfSunSign(Object sign) {
    return 'સૂર્ય $sign';
  }

  @override
  String ovfSeventhSign(Object sign) {
    return '$sign માં 7મું ઘર';
  }

  @override
  String ovfPlanetInHouse(Object planet, Object nthHouse) {
    return '$planet in the $nthHouse';
  }

  @override
  String ovfPlanetWithMoon(Object planet) {
    return 'ચંદ્ર સાથે $planet';
  }

  @override
  String ovfAppearanceIn(Object planet) {
    return 'પહેલા ઘરમાં $planet';
  }

  @override
  String ovfAppearanceAspect(Object planet) {
    return 'પહેલા ઘરને જોતો $planet';
  }

  @override
  String ovfMaleficOnLagna(Object planet) {
    return '$planet ચઢાણ પર દબાવવું';
  }

  @override
  String ovfKaraka(Object role, Object planet) {
    return '$role : $planet';
  }

  @override
  String ovfYoga(Object name) {
    return 'યોગ — $name';
  }

  @override
  String ovfDosha(Object name) {
    return 'દોષ — $name';
  }

  @override
  String get doshaMangalName => 'મંગળ દોષ';

  @override
  String get doshaMangalMeaning =>
      'સંવેદનશીલ ઘરમાં મંગળ - પરંપરાગત રીતે લગ્ન પહેલાં તેનું વજન. ઘણીવાર જ્યારે બંને ભાગીદારો માંગલિક હોય અથવા ગુરુ મંગળને પ્રભાવિત કરે ત્યારે સંતુલિત થાય છે.';

  @override
  String get doshaKaalSarpaName => 'કાલ સર્પ દોષ';

  @override
  String get doshaKaalSarpaMeaning =>
      'રાહુ અને કેતુ વચ્ચે રહેલો આખો કુંડ - જ્યાં સુધી સ્પષ્ટ દિશા ન મળે ત્યાં સુધી જીવન બંધાયેલું લાગે છે, પછી ધ્યાન તીવ્ર બને છે.';

  @override
  String get doshaPitraName => 'પિતૃ દોષ';

  @override
  String get doshaPitraMeaning =>
      'સૂર્ય અને નવમું ઘર પૂર્વજોના કર્મનો પડછાયો ધરાવે છે - ઘણીવાર પિતાના નામે શ્રદ્ધા અને દાનથી સંબોધવામાં આવે છે.';

  @override
  String get doshaGandmoolName => 'ગંધમૂળ દોષ';

  @override
  String get doshaGandmoolMeaning =>
      'ચંદ્ર સંગમ નક્ષત્ર પર બેઠો છે. 27મા દિવસે શાંતિ પૂજા એ પરંપરાગત પ્રતિક્રિયા છે.';

  @override
  String get doshaGrahanName => 'ગ્રહણ દોષ';

  @override
  String get doshaGrahanMeaning =>
      'એક પ્રકાશક (સૂર્ય કે ચંદ્ર) એક ગાંઠ સાથે બેસે છે, જેથી તે ગ્રહના મહત્વ પર કામ ન થાય ત્યાં સુધી ઝાંખું રહે છે.';

  @override
  String get doshaShrapitName => 'શ્રપિત દોષ';

  @override
  String get doshaShrapitMeaning =>
      'રાહુ સાથે શનિ - શરૂઆતમાં વિલંબ અને મૂંઝવણ; સતત, ધીરજવાન પ્રયાસ એ જ રસ્તો છે.';

  @override
  String get doshaGuruChandalName => 'ગુરુ ચાંડાલ દોષ';

  @override
  String get doshaGuruChandalMeaning =>
      'ગાંઠવાળો ગુરુ - બિનપરંપરાગત વિચારો સાથે મિશ્રિત શાણપણ; તમારા શિક્ષકો અને માન્યતાઓને કાળજીપૂર્વક પસંદ કરો.';

  @override
  String get doshaAngarakName => 'અંગારક દોષ';

  @override
  String get doshaAngarakMeaning =>
      'ગાંઠવાળો મંગળ - એક આવેગજન્ય ચાર્જ; ગુસ્સો, અકસ્માતો અને મિલકતના વિવાદોને કાળજીની જરૂર છે.';

  @override
  String get doshaKemadrumaName => 'કેમાદ્રુમ દોષ';

  @override
  String get doshaKemadrumaMeaning =>
      'ચંદ્ર કોઈ ટેકો વિના એકલો ઊભો રહે છે - જ્યારે કેન્દ્ર વ્યસ્ત હોય અથવા ચંદ્ર મજબૂત હોય ત્યારે તે શાંત થાય છે.';

  @override
  String get doshaDaridraName => 'દરિદ્ર દોષ';

  @override
  String get doshaDaridraMeaning =>
      'પૈસાના ઘરો ખૂબ જ તણાવપૂર્ણ છે - શિસ્તબદ્ધ બચત અને મજબૂત દશા તેને ફેરવી નાખે છે.';

  @override
  String get birthDetailsCta => 'સંપૂર્ણ જન્મ વિગતો';

  @override
  String get birthDetailsTitle => 'જન્મ વિગતો';

  @override
  String get birthDetailsAyanamsa => 'અયનાંશા';

  @override
  String get birthDetailsPanchangTitle => 'જન્મ સમયે પંચાંગ';

  @override
  String get birthDetailsChakraTitle => 'અવકહાડ ચક્ર';

  @override
  String get birthDetailsWeekday => 'અઠવાડિયાનો દિવસ';

  @override
  String get birthDetailsTithi => 'તિથિ';

  @override
  String get birthDetailsNakshatra => 'નક્ષત્ર';

  @override
  String get birthDetailsYoga => 'યોગ';

  @override
  String get birthDetailsKarana => 'કરણા';

  @override
  String get birthDetailsMoonSign => 'ચંદ્ર રાશિ';

  @override
  String get birthDetailsSunSign => 'સૂર્ય ચિહ્ન';

  @override
  String get birthDetailsSuryaNakshatra => 'સૂર્ય નક્ષત્ર';

  @override
  String get birthDetailsSunrise => 'સૂર્યોદય';

  @override
  String get birthDetailsSunset => 'સૂર્યાસ્ત';

  @override
  String get birthDetailsIshtaKala => 'ઇષ્ટ કલા';

  @override
  String birthDetailsPada(int count) {
    return 'પાડા $count';
  }

  @override
  String birthDetailsGhatiPala(int ghati, int pala, int vipala) {
    return '$ghati ઘાટી $pala પાલા $vipala વિપલા';
  }

  @override
  String get birthDetailsNakshatraLord => 'નક્ષત્ર સ્વામી';

  @override
  String get birthDetailsRashiLord => 'રાશી સ્વામી';

  @override
  String get birthDetailsVarna => 'વર્ણા';

  @override
  String get birthDetailsVashya => 'વાશ્ય';

  @override
  String get birthDetailsYoni => 'યોની';

  @override
  String get birthDetailsGana => 'ગણ';

  @override
  String get birthDetailsNadi => 'નાડી';

  @override
  String get birthDetailsTara => 'તારા';

  @override
  String get birthDetailsTattva => 'તત્વ';

  @override
  String get birthDetailsYunja => 'યુન્જા';

  @override
  String get birthDetailsRashiPaya => 'રાશી પાયા';

  @override
  String get birthDetailsNakshatraPaya => 'નક્ષત્ર પાય';

  @override
  String get birthDetailsDisclaimer =>
      'શાસ્ત્રીય વર્ગીકરણ વિશેષતાઓ - મુખ્યત્વે મુહૂર્ત અને મેચમેકિંગમાં વપરાય છે, આગાહીઓમાં નહીં.';

  @override
  String get vaaraMonday => 'સોમવાર (સોમવાર)';

  @override
  String get vaaraTuesday => 'મંગળવાર (મંગળવાર)';

  @override
  String get vaaraWednesday => 'બુધવારા (બુધવાર)';

  @override
  String get vaaraThursday => 'ગુરુવાર (ગુરુવાર)';

  @override
  String get vaaraFriday => 'શુક્રવાર (શુક્રવાર)';

  @override
  String get vaaraSaturday => 'શનિવારા (શનિવાર)';

  @override
  String get vaaraSunday => 'રવિવારા (રવિવાર)';

  @override
  String get tattvaFire => 'અગ્નિ (અગ્નિ)';

  @override
  String get tattvaEarth => 'પૃથ્વી (પૃથ્વી)';

  @override
  String get tattvaAir => 'વાયુ (હવા)';

  @override
  String get tattvaWater => 'જલા (પાણી)';

  @override
  String get payaGold => 'સોનું';

  @override
  String get payaSilver => 'મની';

  @override
  String get payaCopper => 'કોપર';

  @override
  String get payaIron => 'લોખંડ';

  @override
  String get roomAppBarTitle => 'પરામર્શ';

  @override
  String get roomOpenError => 'અમે આ પરામર્શ ખોલી શક્યા નહીં.';

  @override
  String roomWaitingTitle(String name) {
    return '$name સ્વીકારે તેની રાહ જોઈ રહ્યા છીએ.';
  }

  @override
  String get roomWaitingBody =>
      'સામાન્ય રીતે એક મિનિટથી ઓછો સમય લાગે છે. તેઓ જોડાતાની સાથે જ અમે ચેટ ખોલીશું.';

  @override
  String get roomCancelRequest => 'વિનંતી રદ કરો';

  @override
  String get roomEndConfirmTitle => 'આ પરામર્શ સમાપ્ત કરીએ?';

  @override
  String get roomEndConfirmBody =>
      'સત્ર સમાપ્ત થાય ત્યારે બિલિંગ બંધ થઈ જાય છે.';

  @override
  String get roomKeepTalking => 'બોલતા રહો';

  @override
  String get roomEnd => 'અંત';

  @override
  String get roomAutoTranslateOn => 'સ્વતઃ-અનુવાદ ચાલુ';

  @override
  String get roomAutoTranslateOff => 'સ્વતઃ-અનુવાદ બંધ છે';

  @override
  String get roomEndedTitle => 'પરામર્શ સમાપ્ત થયો';

  @override
  String get roomBalanceOutTitle => 'તમારું બેલેન્સ પૂરું થઈ ગયું છે.';

  @override
  String roomBalanceOutBody(String name) {
    return 'તમારા વોલેટ બેલેન્સ સમાપ્ત થઈ ગયા હોવાથી ચેટ સમાપ્ત થઈ ગઈ. રિચાર્જ કરો અને $name સાથે ચાલુ રાખવા માટે ફરી શરૂ કરો.';
  }

  @override
  String get roomRechargeWallet => 'રિચાર્જ વોલેટ';

  @override
  String roomStartAgain(String name) {
    return '$name થી ફરી શરૂ કરો';
  }

  @override
  String get roomRowAstrologer => 'જ્યોતિષી';

  @override
  String get roomRowDuration => 'સમયગાળો';

  @override
  String get roomRowAmount => 'રકમ';

  @override
  String get roomRowRate => 'દર';

  @override
  String roomMinutes(int minutes) {
    return '$minutes મિનિટ';
  }

  @override
  String roomRatePerMinute(String currency, String amount) {
    return '$currency $amount / મિનિટ';
  }

  @override
  String get roomRateQuestion => 'તમારી સલાહ કેવી રહી?';

  @override
  String get roomSubmitRating => 'રેટિંગ સબમિટ કરો';

  @override
  String get roomRatingThanks => 'પ્રતિભાવ બદલ આભાર!';

  @override
  String get roomBackHome => 'ઘરે પાછા';

  @override
  String get roomStatusRejected => 'જ્યોતિષી આ વિનંતી સ્વીકારી શક્યા નહીં.';

  @override
  String get roomStatusCancelled => 'વિનંતી રદ કરી';

  @override
  String get roomStatusExpired =>
      'વિનંતી સમાપ્ત થઈ ગઈ — સમયસર કોઈ જવાબ મળ્યો નહીં';

  @override
  String get roomStatusNoShow => 'કૉલ કનેક્ટ થયો નહીં.';

  @override
  String get roomStatusClosed => 'પરામર્શ બંધ';

  @override
  String get roomBalanceRunningOut => 'બેલેન્સ ખતમ થઈ રહ્યું છે.';

  @override
  String roomMinLeftRecharge(int minutes) {
    return '~ $minutes મિનિટ બાકી · વાત કરતા રહેવા માટે રિચાર્જ કરો';
  }

  @override
  String roomSpentMinLeft(String currency, String amount, int minutes) {
    return '$currency $amount ખર્ચ કર્યો · ~ $minutes મિનિટ બાકી';
  }

  @override
  String get roomAddMoney => 'પૈસા ઉમેરો';

  @override
  String get roomClientBalanceLow =>
      'ક્લાયન્ટનું બેલેન્સ ઓછું છે — જલ્દી પૂરું કરો.';

  @override
  String get navChats => 'ગપસપો';

  @override
  String get chatsTitle => 'ગપસપો';

  @override
  String get chatsLoadError => 'અમે તમારી ચેટ્સ લોડ કરી શક્યા નથી.';

  @override
  String get chatsEmptyTitle => 'હજુ સુધી કોઈ ચેટ નથી';

  @override
  String get chatsEmptyBody =>
      'કોઈ જ્યોતિષી સાથે પરામર્શ શરૂ કરો અને તે અહીં દેખાશે.';

  @override
  String get chatsSectionActive => 'સક્રિય';

  @override
  String get chatsSectionRecent => 'તાજેતરના';

  @override
  String get chatsAstrologerFallback => 'જ્યોતિષી';

  @override
  String get chatsStatusWaiting => 'જ્યોતિષી સ્વીકારે તેની રાહ જોવી';

  @override
  String get chatsStatusLive => 'હમણાં લાઇવ · ખોલવા માટે ટૅપ કરો';

  @override
  String chatsStatusEnded(int minutes) {
    return '$minutes મિનિટ પરામર્શ';
  }

  @override
  String get chatsStatusCancelled => 'રદ કરેલ';

  @override
  String get chatsStatusRejected => 'સ્વીકાર્ય નથી';

  @override
  String get chatsStatusExpired => 'વિનંતી સમાપ્ત થઈ ગઈ છે';

  @override
  String get chatsStatusGeneric => 'પરામર્શ';

  @override
  String get numerologyTitle => 'અંકશાસ્ત્ર અને લો શુ ગ્રીડ';

  @override
  String get numerologyIntro =>
      'તમારી જન્મ તારીખ (અને નામ) પરથી વાંચવામાં આવતી પરંપરાગત સંખ્યાઓ - દરેક સંખ્યા કઈ તરફ ઝુકે છે, અનુકૂળ દિવસો અને રંગો, અને તમારા લો શુ જન્મ ગ્રીડ. પ્રતિબિંબ માટે, તારીખની આગાહી નહીં.';

  @override
  String get numMoolank => 'મૂલંક · માનસિક સંખ્યા';

  @override
  String get numBhagyank => 'ભાગ્યંક · ભાગ્ય નંબર';

  @override
  String get numNaamank => 'નામાંક · નામ નંબર';

  @override
  String numRuledBy(String planet) {
    return '$planet દ્વારા શાસિત';
  }

  @override
  String get numFriendly => 'મૈત્રીપૂર્ણ';

  @override
  String get numNeutral => 'તટસ્થ';

  @override
  String get numUnfriendly => 'અથડામણ';

  @override
  String get numFavDays => 'અનુકૂળ દિવસો';

  @override
  String get numFavColours => 'અનુકૂળ રંગો';

  @override
  String get numDirection => 'દિશા';

  @override
  String get numDeity => 'દેવતા';

  @override
  String get numGemstone => 'પરંપરાગત રત્ન';

  @override
  String get numLoShuTitle => 'લો શુ જન્મ ગ્રીડ';

  @override
  String numLoShuMissing(String nums) {
    return 'તમારી ગ્રીડમાં નથી: $nums';
  }

  @override
  String numLoShuRepeated(String nums) {
    return 'ભાર મૂક્યો: $nums';
  }

  @override
  String get numArrowStrength => 'પૂર્ણ રેખા';

  @override
  String get numArrowAbsence => 'ગેરહાજર રેખા';

  @override
  String get numAskCta => 'આ વિશે કોઈ જ્યોતિષી સાથે વાત કરો.';

  @override
  String get sadeSatiTitle => 'સાડે સતી અને ધૈયા કેલેન્ડર';

  @override
  String sadeSatiIntro(String sign) {
    return 'તમારા ચંદ્ર $sign પરથી ગણતરી કરીએ તો, તમારા જીવન પર શનિનો દિવસ વિન્ડો કરે છે. સાડે સતી એ ચંદ્રથી ૧૨મા, ૧લા અને ૨મા (~૭½ વર્ષ) સુધીનો શનિ છે; ધૈયા એ ચોથો કે આઠમો (~૨½ વર્ષ) છે.';
  }

  @override
  String get sadeSatiRunningNow => 'હમણાં ચાલી રહ્યું છે';

  @override
  String get sadeSatiPast => 'ભૂતકાળ';

  @override
  String get sadeSatiUpcoming => 'આગામી';

  @override
  String get sadeSatiPhaseRising => 'ઉદય · ૧૨મા ભાવમાં શનિ';

  @override
  String get sadeSatiPhasePeak => 'શિખર · ચંદ્ર ઉપર શનિ';

  @override
  String get sadeSatiPhaseSetting => 'અસ્ત · બીજામાં શનિ';

  @override
  String get sadeSatiPhaseKantaka => 'કંટક · ચોથા ભાવમાં શનિ';

  @override
  String get sadeSatiPhaseAshtama => 'અષ્ટમા · આઠમા ભાવમાં શનિ';

  @override
  String get sadeSatiDhaiyaHeading => 'ધૈયા (નાની પનોતી) કાળ';

  @override
  String sadeSatiRange(String start, String end) {
    return '$start → $end';
  }

  @override
  String get avTransitHeading => 'આજના ગોચરની અષ્ટકવર્ગ શક્તિ';

  @override
  String get avTransitIntro =>
      'તમારા જન્મ બિંદુના સ્કોર પરથી, દરેક ગ્રહનું ગોચર કેટલું મુક્તપણે તેના પરિણામો આપે છે. 8 માંથી 5+ સહાયક છે, 4 મિશ્ર છે, ઓછા નબળા છે.';

  @override
  String avTransitBindus(int bindus) {
    return '$bindus /8 બિંદુ';
  }

  @override
  String get avTransitUpcoming => 'આવી રહ્યું છે';

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
  String get errNetwork =>
      'સર્વર સુધી પહોંચી શકાયું નથી. તમારું કનેક્શન તપાસો.';

  @override
  String get errTimeout => 'સર્વરે જવાબ આપવામાં ઘણો સમય લીધો.';

  @override
  String get errSession =>
      'તમારું સત્ર સમાપ્ત થઈ ગયું છે. કૃપા કરીને ફરી સાઇન ઇન કરો.';

  @override
  String get errWalletInsufficient =>
      'તમારા વોલેટનું બેલેન્સ આ માટે ખૂબ ઓછું છે.';

  @override
  String get errRateLimited =>
      'ઘણા પ્રયત્નો થયા. કૃપા કરીને થોડીવાર રાહ જુઓ અને ફરી પ્રયાસ કરો.';

  @override
  String get errOtpInvalid => 'કોડ ખોટો છે અથવા તેની મુદત પૂરી થઈ ગઈ છે.';

  @override
  String get errOtpMaxAttempts => 'ઘણા ખોટા પ્રયત્નો. નવા કોડ માટે વિનંતી કરો.';

  @override
  String get errPromoNotRedeemable => 'આ કૂપન કોડ વાપરી શકાય તેમ નથી.';

  @override
  String get errRechargeInvalidAmount => 'માન્ય મર્યાદામાં રકમ લખો.';

  @override
  String get errAuthWrongApp => 'આ નંબર અન્ય TalkAcharya એપ માટે નોંધાયેલ છે.';

  @override
  String get errGeneric => 'કાંઈક ખોટું થયું છે. કૃપા કરીને ફરી પ્રયાસ કરો.';

  @override
  String get homePanchangTitle => 'આજનો પંચાંગ';

  @override
  String get homeLiveNowTitle => 'હમણાં જ જીવો';

  @override
  String get homeFreeToolsTitle => 'મફત સાધનો';

  @override
  String get homeResumeBtn => 'ફરી શરૂ કરો';

  @override
  String get homeAddBtn => 'ઉમેરો';

  @override
  String get homeNotifyMeBtn => 'મને સૂચિત કરો';

  @override
  String get homeKundaliAction => 'કુંડળી';

  @override
  String get homeMatchingAction => 'મેચિંગ';

  @override
  String get homeHoroscopeAction => 'જન્માક્ષર';

  @override
  String get homeVastuAction => 'વાસ્તુ';

  @override
  String get homeRetryBtn => 'ફરી પ્રયાસ કરો';

  @override
  String get homeChooseSignTitle => 'તમારી નિશાની પસંદ કરો';

  @override
  String get homeChooseLanguageTitle => 'ભાષા પસંદ કરો';

  @override
  String get homeLanguageTooltip => 'ભાષા';

  @override
  String homeLanguageSwitchError(String error) {
    return 'સ્વિચ કરી શકાયું નથી: $error';
  }

  @override
  String get homeComingSoonSnackbar => 'જલ્દી આવી રહ્યું છે!';

  @override
  String get homeTalkAgainTitle => 'ફરી વાત કરો';

  @override
  String get homeRechargeWalletTitle => 'તમારા વૉલેટને રિચાર્જ કરો';

  @override
  String get homeTalkToAstrologerTitle => 'કોઈ જ્યોતિષી સાથે વાત કરો.';

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
