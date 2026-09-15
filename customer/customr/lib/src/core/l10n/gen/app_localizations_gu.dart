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
  String get astroExpertiseTitle => 'નિપુણતા';

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
  String get profileOrders => 'ઓર્ડર';

  @override
  String profileOrdersUnread(int count) {
    return '$count નવું';
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
  String get editGenderUndisclosed => 'ન કહેવાનું પસંદ કરે છે';

  @override
  String get editNameInvalid => 'તમારું નામ દાખલ કરો (ઓછામાં ઓછા 2 અક્ષરો)';

  @override
  String get editEmailInvalid => 'માન્ય ઇમેઇલ સરનામું દાખલ કરો';

  @override
  String get editPhone => 'મોબાઈલ નંબર';

  @override
  String get editPhoneLocked => 'તમારો લૉગિન નંબર બદલી શકાતો નથી';

  @override
  String get editSectionPersonal => 'વ્યક્તિગત વિગતો';

  @override
  String get editSectionContact => 'સંપર્ક કરો';

  @override
  String get editDobPlaceholder => 'તમારી જન્મ તારીખ ઉમેરો';

  @override
  String get editPhotoUpdated => 'ફોટો અપડેટ કર્યો';

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
  String get kPlanetNameSun => 'સૂર્ય';

  @override
  String get kPlanetNameMoon => 'ચંદ્ર';

  @override
  String get kPlanetNameMars => 'મંગળ';

  @override
  String get kPlanetNameMercury => 'બુધ';

  @override
  String get kPlanetNameJupiter => 'ગુરુ';

  @override
  String get kPlanetNameVenus => 'શુક્ર';

  @override
  String get kPlanetNameSaturn => 'શનિ';

  @override
  String get kPlanetNameRahu => 'રાહુ';

  @override
  String get kPlanetNameKetu => 'કેતુ';

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
  String get muhurtaTitle => 'આજનો સમય';

  @override
  String get muhurtaIntro =>
      'આજે માટે ચોઘડિયા અને હોરા, તમારા જન્મ શહેર માટે કામ કર્યું અને તમારા ચાર્ટના મદદરૂપ ગ્રહો માટે વ્યક્તિગત કર્યું. વસ્તુઓ શરૂ કરવા માટે વધુ સારી અને નબળી વિન્ડો માટે માર્ગદર્શિકા — નિયમ નહીં.';

  @override
  String muhurtaSunTimes(
    String sunrise,
    String sunset,
    String weekday,
    String lord,
  ) {
    return '$sunrise સૂર્યોદય · $sunset સૂર્યાસ્ત · $weekday ( $lord )';
  }

  @override
  String get muhurtaBestWindows => 'આજે તમારા માટે શ્રેષ્ઠ વિન્ડો';

  @override
  String get muhurtaNoBest =>
      'આજે કોઈ સ્ટૅન્ડ-આઉટ વિન્ડો નથી — નીચે એક સારા ચોઘડિયા પસંદ કરો.';

  @override
  String get muhurtaDayChoghadiya => 'ડે ચોઘડિયા';

  @override
  String get muhurtaNightChoghadiya => 'રાત્રિ ચોઘડિયા';

  @override
  String get muhurtaHora => 'ગ્રહોની હોરા';

  @override
  String get muhurtaNow => 'હવે';

  @override
  String get muhurtaChoGood => 'સારું';

  @override
  String get muhurtaChoBad => 'ટાળો';

  @override
  String get muhurtaChoNeutral => 'તટસ્થ';

  @override
  String get muhurtaHoraFavourable => 'તમારા માટે સારું';

  @override
  String get muhurtaHoraCaution => 'પ્રકાશ રાખો';

  @override
  String get upayaTitle => 'રત્ન અને ઉપાયા';

  @override
  String upayaIntro(String sign) {
    return 'તમારા ચડતા ( $sign ) માટે શાસ્ત્રીય ઉપાય કોષ્ટક — અનુકૂળ રંગો, દિવસો, દેવતાઓ, મંત્રો અને ધર્માદા તમે મુક્તપણે અપનાવી શકો છો, ઉપરાંત દરેક ગ્રહ માટે પરંપરાગત રત્ન અને રુદ્રાક્ષ.';
  }

  @override
  String get upayaLagnaFavourable => 'તમારા આરોહણ માટે અનુકૂળ';

  @override
  String get upayaColours => 'રંગો';

  @override
  String get upayaDirection => 'દિશા';

  @override
  String get upayaDay => 'દિવસ';

  @override
  String get upayaDeity => 'દેવતા';

  @override
  String get upayaStrengthen => 'આધાર';

  @override
  String get upayaPacify => 'શાંત કરો';

  @override
  String get upayaMixed => 'મિશ્ર';

  @override
  String get upayaNeutral => 'તટસ્થ';

  @override
  String get upayaFreeMeasures => 'મફત પગલાં';

  @override
  String get upayaMantra => 'મંત્ર';

  @override
  String get upayaCharity => 'દાન (દાન)';

  @override
  String get upayaGemstone => 'રત્ન';

  @override
  String get upayaRudraksha => 'રૂદ્રાક્ષ';

  @override
  String get upayaGatedCta => 'પહેલા કોઈ જ્યોતિષ સાથે પુષ્ટિ કરો';

  @override
  String get upayaPriority => 'પ્રાથમિકતા';

  @override
  String get lalKitabTitle => 'લાલ કિતાબ - દેવા અને ઉપાયો';

  @override
  String get lalKitabIntro =>
      'લાલ કિતાબ તમારા ચાર્ટમાંથી કેટલાક વારસાગત દેવા (રિન) વાંચે છે અને દરેકને સરળ, મફત ઘરગથ્થુ કાર્યો (ટોટકે) સાથે સાફ કરે છે. કોઈ રત્ન નથી, કોઈ કિંમત નથી.';

  @override
  String get lalKitabActiveDebts => 'સક્રિય દેવાં';

  @override
  String get lalKitabNoDebts =>
      'કોઈ મજબૂત રીતે સક્રિય રિન નથી — રોજિંદા ફરજો રાખો અને કંઈપણ નિર્માણ થતું નથી.';

  @override
  String get lalKitabWhyFlagged => 'શા માટે તે ધ્વજાંકિત છે';

  @override
  String get lalKitabRemedy => 'ઉપાય (ટોટકા)';

  @override
  String get lalKitabWeakPlanets => 'નબળા ગ્રહ પ્લેસમેન્ટ';

  @override
  String get lalKitabAllRemedies => 'તમારા ઉપાયો';

  @override
  String lalKitabPakkaGhar(String planet, String house) {
    return '$planet નું ઘરનું ઘર $house છે';
  }

  @override
  String get varshphalTitle => 'વર્ષફલ — આ વર્ષનો ચાર્ટ';

  @override
  String varshphalIntro(String age) {
    return 'તમારા $age -વર્ષ માટેનો તાજિકા વાર્ષિક ચાર્ટ, સૂર્ય તેની જન્મસ્થિતિ પર પાછો ફરે તે ક્ષણ માટે કાસ્ટ કરો. કામ કરવા માટેની થીમ્સ - નિશ્ચિત ઇવેન્ટ્સ નથી.';
  }

  @override
  String varshphalWindow(String start, String end) {
    return '$start → $end';
  }

  @override
  String get varshphalLagna => 'વર્ષા લગન';

  @override
  String get varshphalMuntha => 'મુંથા';

  @override
  String get varshphalYearLord => 'વર્ષના સ્વામી (વર્ષેશ્વર)';

  @override
  String get varshphalTajika => 'તાજિકા પાસા';

  @override
  String varshphalMunthaLine(String house, String theme) {
    return '$house ઘરમાં મુંથા — $theme';
  }

  @override
  String get varshphalChart => 'વાર્ષિક ચાર્ટ ગ્રહો';

  @override
  String get prefsTransitAlerts => 'પરિવહન ચેતવણીઓ';

  @override
  String get prefsTransitAlertsDesc =>
      'જ્યારે ધીમો ગ્રહ (ગુરુ, શનિ) તમારા ચાર્ટમાં નવા મકાનમાં સાઇન બદલવાનો હોય ત્યારે હેડ-અપ.';

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
  String get kSignNameAries => 'મેષ';

  @override
  String get kSignNameTaurus => 'વૃષભ';

  @override
  String get kSignNameGemini => 'મિથુન';

  @override
  String get kSignNameCancer => 'કેન્સર';

  @override
  String get kSignNameLeo => 'સિંહ';

  @override
  String get kSignNameVirgo => 'કન્યા રાશિ';

  @override
  String get kSignNameLibra => 'તુલા';

  @override
  String get kSignNameScorpio => 'વૃશ્ચિક';

  @override
  String get kSignNameSagittarius => 'ધનુરાશિ';

  @override
  String get kSignNameCapricorn => 'મકર';

  @override
  String get kSignNameAquarius => 'કુંભ';

  @override
  String get kSignNamePisces => 'મીન';

  @override
  String get kNakNameAshwini => 'અશ્વિની';

  @override
  String get kNakNameBharani => 'ભરણી';

  @override
  String get kNakNameKrittika => 'કૃતિકા';

  @override
  String get kNakNameRohini => 'રોહિણી';

  @override
  String get kNakNameMrigashira => 'મૃગશિરા';

  @override
  String get kNakNameArdra => 'આર્દ્રા';

  @override
  String get kNakNamePunarvasu => 'પુનર્વસુ';

  @override
  String get kNakNamePushya => 'પુષ્ય';

  @override
  String get kNakNameAshlesha => 'આશ્લેષા';

  @override
  String get kNakNameMagha => 'માગા';

  @override
  String get kNakNamePurvaPhalguni => 'પૂર્વા ફાલ્ગુની';

  @override
  String get kNakNameUttaraPhalguni => 'ઉત્તરા ફાલ્ગુની';

  @override
  String get kNakNameHasta => 'હસ્તા';

  @override
  String get kNakNameChitra => 'ચિત્રા';

  @override
  String get kNakNameSwati => 'સ્વાતિ';

  @override
  String get kNakNameVishakha => 'વિશાખા';

  @override
  String get kNakNameAnuradha => 'અનુરાધા';

  @override
  String get kNakNameJyeshtha => 'જ્યેષ્ઠા';

  @override
  String get kNakNameMula => 'મુલા';

  @override
  String get kNakNamePurvaAshadha => 'પૂર્વા અષાઢ';

  @override
  String get kNakNameUttaraAshadha => 'ઉત્તરા અષાઢ';

  @override
  String get kNakNameShravana => 'શ્રાવણ';

  @override
  String get kNakNameDhanishta => 'ધનિષ્ઠા';

  @override
  String get kNakNameShatabhisha => 'શતભિષા';

  @override
  String get kNakNamePurvaBhadrapada => 'પૂર્વા ભાદ્રપદ';

  @override
  String get kNakNameUttaraBhadrapada => 'ઉત્તરા ભાદ્રપદ';

  @override
  String get kNakNameRevati => 'રેવતી';

  @override
  String get kChartNameD1 => 'રાશી';

  @override
  String get kChartSigD1 => 'ભૌતિક શરીર, એકંદર જીવન, બધું';

  @override
  String get kChartNameD2 => 'હોરા';

  @override
  String get kChartSigD2 => 'સંપત્તિ, નાણાકીય સમૃદ્ધિ';

  @override
  String get kChartNameD3 => 'ડ્રેક્કાના';

  @override
  String get kChartSigD3 => 'ભાઈ-બહેન, હિંમત, પહેલ';

  @override
  String get kChartNameD4 => 'ચતુર્થમશા';

  @override
  String get kChartSigD4 => 'નસીબ, મિલકત, સ્થિર સંપત્તિ, ઘર';

  @override
  String get kChartNameD5 => 'પંચમશા';

  @override
  String get kChartSigD5 => 'ખ્યાતિ, સત્તા, આધ્યાત્મિક યોગ્યતા (પુણ્ય)';

  @override
  String get kChartNameD6 => 'શષ્ટમશા';

  @override
  String get kChartSigD6 => 'આરોગ્ય, રોગ, દેવાં, દુશ્મનો';

  @override
  String get kChartNameD7 => 'સપ્તમશા';

  @override
  String get kChartSigD7 => 'બાળકો, સંતાન, સર્જનાત્મકતા';

  @override
  String get kChartNameD8 => 'અષ્ટમશા';

  @override
  String get kChartSigD8 => 'આકસ્મિક ઘટનાઓ, આયુષ્યની મુશ્કેલીઓ, અવરોધો';

  @override
  String get kChartNameD9 => 'નવમશા';

  @override
  String get kChartSigD9 => 'જીવનસાથી, ધર્મ, આંતરિક સ્વ — પ્રાથમિક આધાર ચાર્ટ';

  @override
  String get kChartNameD10 => 'દશમશા';

  @override
  String get kChartSigD10 => 'કારકિર્દી, વ્યવસાય, સ્થિતિ, સિદ્ધિ';

  @override
  String get kChartNameD11 => 'રૂદ્રમશા';

  @override
  String get kChartSigD11 => 'મૃત્યુ, વિનાશ, પ્રતિકૂળતામાંથી લાભ (લાભા)';

  @override
  String get kChartNameD12 => 'દ્વાદશમ્';

  @override
  String get kChartSigD12 => 'માતાપિતા, વંશ, વારસાગત કર્મ';

  @override
  String get kChartNameD16 => 'ષોડશંશા';

  @override
  String get kChartSigD16 => 'વાહન, સુખ-સુવિધા, વિલાસ, સુખ';

  @override
  String get kChartNameD20 => 'વિમશાં';

  @override
  String get kChartSigD20 => 'આધ્યાત્મિક અભ્યાસ, ઉપાસના, ભક્તિ';

  @override
  String get kChartNameD24 => 'ચતુર્વિંશમશા';

  @override
  String get kChartSigD24 => 'શિક્ષણ, શિક્ષણ, જ્ઞાન';

  @override
  String get kChartNameD27 => 'સપ્તવિમંશા';

  @override
  String get kChartSigD27 => 'શક્તિ અને નબળાઈ, સહનશક્તિ';

  @override
  String get kChartNameD30 => 'ત્રિમશાંશા';

  @override
  String get kChartSigD30 => 'કમનસીબી, દુષ્ટતા, નૈતિક પાત્ર';

  @override
  String get kChartNameD40 => 'ચત્વારિમશામશા';

  @override
  String get kChartSigD40 => 'માતાનો વારસો, શુભ/અશુભ અસરો';

  @override
  String get kChartNameD45 => 'અક્ષવેદમશા';

  @override
  String get kChartSigD45 => 'પૈતૃક વારસો, એકંદર પાત્ર અને આચરણ';

  @override
  String get kChartNameD60 => 'શાષ્ટીયમશા';

  @override
  String get kChartSigD60 => 'ભૂતકાળના જીવનના કર્મ, શ્રેષ્ઠ સ્તર - એકંદરે';

  @override
  String get kChartNameMoon => 'ચંદ્ર ચાર્ટ (ચંદ્ર)';

  @override
  String get kChartSigMoon => 'મન અને લાગણીઓ - ચંદ્ર પરથી વાંચેલી રાસી ચાર્ટ';

  @override
  String get kChartNameChalit => 'ભાવ ચલિત';

  @override
  String get kChartSigChalit =>
      'વાસ્તવિક ભવ કુપ્સ (શ્રીપતિ) દ્વારા ઘરના પરિણામો, સંપૂર્ણ સંકેત નથી';

  @override
  String get kChartNameTransit => 'પરિવહન (ગોચર)';

  @override
  String get kChartSigTransit => 'પ્રસૂતિ ગૃહો ઉપર વર્તમાન ગ્રહો';

  @override
  String get kChartShortMoon => 'ચંદ્ર';

  @override
  String get kChartShortChalit => 'ચલિત';

  @override
  String get kChartShortTransit => 'પરિવહન';

  @override
  String get kChAscendant => 'ચડતી';

  @override
  String get kChLagnaVargottama => 'લગના વર્ગોત્તમા';

  @override
  String kChAsOf(Object when) {
    return '$when મુજબ';
  }

  @override
  String get kChUnverified =>
      'આ વિભાગ હજુ સુધી દ્રિકપંચંગ સામે ચકાસાયેલ નથી — પ્લેસમેન્ટને પ્રાયોગિક ગણો.';

  @override
  String kChChalitShiftedOne(Object planets) {
    return '$planets આખા-સાઇન હાઉસ કરતાં અલગ ભવમાં બેસે છે.';
  }

  @override
  String kChChalitShiftedMany(Object planets) {
    return '$planets આખા-સાઇન હાઉસ કરતાં અલગ ભવમાં બેસો.';
  }

  @override
  String get kChColPlanet => 'ગ્રહ';

  @override
  String get kChColSign => 'સાઇન કરો';

  @override
  String get kChColDegree => 'ડીઇજી';

  @override
  String get kChColHouse => 'ઘર';

  @override
  String get kChColBhava => 'ભવા';

  @override
  String get kChColFromMoon => 'ચંદ્ર';

  @override
  String get kChLegend => 'દંતકથા';

  @override
  String get kChLegendNote =>
      '℞ પૂર્વવર્તી ⬦ વર્ગોત્તમ ← ખસેડાયેલ ભવ (ચલિત)\nઉત્તર: કોષ નંબર = રાશી (1 મેષ … 12 મીન), પહેલું ઘર ટોચનું કેન્દ્ર છે.';

  @override
  String get kChNorthIndian => 'ઉત્તર ભારતીય';

  @override
  String get kChSouthIndian => 'દક્ષિણ ભારતીય';

  @override
  String get kChPickerCharts => 'ચાર્ટ્સ';

  @override
  String get kChPickerDivisional => 'વિભાગીય ચાર્ટ (વર્ગ)';

  @override
  String get kOvTitle => 'કુંડળી';

  @override
  String kOvTitleNamed(Object name) {
    return '$name ની કુંડળી';
  }

  @override
  String get kOvDownloadPdf => 'PDF ડાઉનલોડ કરો';

  @override
  String get kOvShare => 'શેર કરો';

  @override
  String get kOvMoonSignLabel => 'ચંદ્ર ચિહ્ન · રાશિ';

  @override
  String kOvLagnaChip(Object sign) {
    return 'લગના · $sign';
  }

  @override
  String kOvNakshatraChip(Object name) {
    return 'નક્ષત્ર · $name';
  }

  @override
  String get kOvTimeApprox => 'અંદાજિત જન્મ સમય';

  @override
  String get kOvEdit => 'સંપાદિત કરો';

  @override
  String get kOvLagnaChart => 'લગના ચાર્ટ';

  @override
  String get kOvD1Rasi => 'D1 રાસી';

  @override
  String get kOvOpenFullChart => 'સંપૂર્ણ ચાર્ટ ખોલો';

  @override
  String get kOvDashaUnavailable => 'દશા અત્યારે ઉપલબ્ધ નથી.';

  @override
  String get kOvDashaRunning => 'તમે હાલમાં ચાલી રહ્યા છો';

  @override
  String kOvMahadasha(Object planet) {
    return '$planet મહાદશા';
  }

  @override
  String kOvSubPeriods(Object antar, Object pratyantar) {
    return '$antar પેટા-કાળ · $pratyantar પ્રત્યન્તર';
  }

  @override
  String kOvDashaProgress(Object end, Object percent, Object start) {
    return '$start → $end · $percent % થી';
  }

  @override
  String get kOvSeeTimeline => 'સંપૂર્ણ સમયરેખા જુઓ';

  @override
  String get kOvAtAGlance => 'એક નજરમાં';

  @override
  String get kOvMangalDosha => 'મંગલ દોષ';

  @override
  String get kOvManglik => 'માંગલિક';

  @override
  String get kOvNotManglik => 'માંગલિક નહિ';

  @override
  String kOvMangalFrom(Object refs) {
    return '$refs થી';
  }

  @override
  String get kOvMarsClear => 'મંગળ સ્પષ્ટ છે';

  @override
  String get kOvMangalCancelled =>
      'પ્રસ્તુત કરો, પરંતુ તમારા ચાર્ટમાં રદ કર્યું';

  @override
  String kOvMangalLevelFrom(Object level, Object refs) {
    return '$level · $refs થી';
  }

  @override
  String get kOvRefLagna => 'લગના';

  @override
  String get kOvYogas => 'યોગાસન';

  @override
  String kOvYogasFound(Object count) {
    return '$count મળ્યું';
  }

  @override
  String get kOvNakshatra => 'નક્ષત્ર';

  @override
  String get kOvLagnaLord => 'લગના સ્વામી';

  @override
  String get kOvExInsights => 'વ્યક્તિત્વ અને જીવન ઝાંખી';

  @override
  String get kOvExInsightsSub =>
      'તમારા ચાર્ટનું મફત વાંચન — પ્રકૃતિ, કાર્ય, લગ્ન અને વધુ';

  @override
  String get kOvExForecast => 'લેખિત આગાહી';

  @override
  String get kOvExForecastSub =>
      'જીવનના એક ક્ષેત્ર માટે ચૂકવેલ આગાહી, જ્યોતિષ દ્વારા લખાયેલ';

  @override
  String get kOvExPlanets => 'ગ્રહો અને સ્થિતિ';

  @override
  String get kOvExPlanetsSub => 'દરેક ગ્રહ ક્યાં બેસે છે અને શું કરે છે';

  @override
  String get kOvExDasha => 'દશાનો સમયગાળો';

  @override
  String get kOvExDashaSub => 'તમારી જીવન સમયરેખા - વિમશોત્તરી';

  @override
  String get kOvExVarshphal => 'વર્ષફલ (વાર્ષિક ચાર્ટ)';

  @override
  String get kOvExVarshphalSub =>
      'આ સૌર-વળતરનું વર્ષ — મુન્થા, વર્ષનો સ્વામી અને તાજિકા પાસા';

  @override
  String get kOvExYogas => 'યોગ અને દોષ';

  @override
  String get kOvExYogasSub => 'તમારા ચાર્ટમાં વિશિષ્ટ સંયોજનો';

  @override
  String get kOvExRemedies => 'ઉપાયો';

  @override
  String get kOvExRemediesSub =>
      'તમારા ચાર્ટ માટે પરંપરાગત મંત્રો, દાન અને પ્રથાઓ';

  @override
  String get kOvExUpaya => 'રત્ન અને ઉપાયા';

  @override
  String get kOvExUpayaSub =>
      'પ્રતિ-ગ્રહ રત્ન, રંગ, દિવસ અને મંત્ર - રત્ન દ્વારવાળા';

  @override
  String get kOvExLalKitab => 'લાલ કિતાબ';

  @override
  String get kOvExLalKitabSub =>
      'વારસાગત દેવું (રિન) અને તેમના સરળ, મફત ટોટકા ઉપાયો';

  @override
  String get kOvExTransits => 'સંક્રમણ અને સાદે સતી';

  @override
  String get kOvExTransitsSub => 'આકાશ અત્યારે શું કરી રહ્યો છે';

  @override
  String get kOvExSadeSati => 'સાદે સતી અને ધૈયા કેલેન્ડર';

  @override
  String get kOvExSadeSatiSub => 'તમારા જીવનની દરેક શનિ વિંડો, તારીખો સાથે';

  @override
  String get kOvExMuhurta => 'આજનો સમય';

  @override
  String get kOvExMuhurtaSub =>
      'ચોઘડિયા અને હોરા, તમારી શ્રેષ્ઠ વિન્ડો ચિહ્નિત સાથે';

  @override
  String get kOvExHouses => 'ઘરો (ભાવ)';

  @override
  String get kOvExHousesSub => '12 ઘરોમાંના દરેક માટે વાંચન';

  @override
  String get kOvExNumerology => 'અંકશાસ્ત્ર અને લો શુ ગ્રીડ';

  @override
  String get kOvExNumerologySub =>
      'જન્મ તારીખથી તમારા નંબરો — દિવસો, રંગો, જન્મ ગ્રીડ';

  @override
  String get kOvExAdvanced => 'અદ્યતન અહેવાલો';

  @override
  String get kOvExAdvancedSub => 'અષ્ટકવર્ગ, શદબાલા, કેપી, જૈમિની';

  @override
  String get kOvAskAstrologer => 'કોઈ જ્યોતિષને તમારી કુંડળી વિશે પૂછો';

  @override
  String get kReadingCardTitle => 'આનો અર્થ શું છે';

  @override
  String kSsTitle(Object phase) {
    return 'સાદે સતી · $phase તબક્કો';
  }

  @override
  String get kSsPhaseRising => 'વધતો (3 માંથી 1)';

  @override
  String get kSsPhasePeak => 'ટોચ (3 માંથી 2)';

  @override
  String get kSsPhaseSetting => 'સેટિંગ (3 માંથી 3)';

  @override
  String get kSsRising => 'રાઇઝિંગ';

  @override
  String get kSsPeak => 'પીક';

  @override
  String get kSsSetting => 'સેટિંગ';

  @override
  String get kSsNotCurse =>
      'સાદે સતી એ સખત મહેનત અને પરિપક્વતાનો સમયગાળો છે - શ્રાપ નથી. સ્થિર, પ્રામાણિક પ્રયાસને વળતર મળે છે.';

  @override
  String get kSsWhatForMe => 'મારા માટે આનો અર્થ શું છે';

  @override
  String kSsPanotiTitle(Object type) {
    return 'નાની પનોતી — $type';
  }

  @override
  String get kSsPanotiBody =>
      'શનિનો ટૂંકો તબક્કો (લગભગ 2½ વર્ષ) જે આરોગ્ય, પ્રયત્નો અને દૈનિક અવરોધો સાથે ધીરજ રાખવા માટે પૂછે છે.';

  @override
  String get kSsSeeTransits => 'ટ્રાન્ઝિટ જુઓ';

  @override
  String get kSsSkyNow => 'અત્યારે આકાશમાં';

  @override
  String get kSsJupiterGood =>
      'ગુરુ તમારા માટે સાનુકૂળ રીતે સંક્રમણ કરી રહ્યો છે - વૃદ્ધિ, શિક્ષણ અને પૈસા માટે સહાયક વિંડો.';

  @override
  String get kSsJupiterNeutral =>
      'કોઈ સાદે સતી અથવા મુખ્ય શનિ તબક્કો સક્રિય નથી. ગુરુનું સંક્રમણ અત્યારે તમારા માટે તટસ્થ છે.';

  @override
  String get kSsSeeAllTransits => 'બધા પરિવહન જુઓ';

  @override
  String get kFcTitle => 'જન્મ ચાર્ટ';

  @override
  String get kFcTransitingGrahas => 'સંક્રમણ ગ્રહો';

  @override
  String get kFcPlanets => 'ગ્રહો';

  @override
  String get kFcAllHouses => 'બધા 12 ઘરો અને વાંચન';

  @override
  String get kFcAllCharts => 'બધા ચાર્ટ્સ — D1 થી D60';

  @override
  String get kFcAllChartsTooltip => 'બધા ચાર્ટ';

  @override
  String get kFcLoadError => 'આ ચાર્ટ લોડ કરી શકાયો નથી';

  @override
  String get kFcTwelveHouses => 'આ 12 ઘરો';

  @override
  String get kFcNoPlanets => 'કોઈ ગ્રહો નથી';

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
  String get horoTitle => 'જન્માક્ષર';

  @override
  String get horoReadFull => 'સંપૂર્ણ જન્માક્ષર વાંચો';

  @override
  String get horoSpanYesterday => 'ગઈકાલે';

  @override
  String get horoSpanToday => 'આજે';

  @override
  String get horoSpanTomorrow => 'કાલે';

  @override
  String get horoSpanWeek => 'આ અઠવાડિયે';

  @override
  String get horoSpanMonth => 'આ મહિને';

  @override
  String get horoAreaLove => 'પ્રેમ';

  @override
  String get horoAreaCareer => 'કારકિર્દી';

  @override
  String get horoAreaMoney => 'પૈસા';

  @override
  String get horoAreaHealth => 'આરોગ્ય';

  @override
  String get horoOverall => 'એકંદરે';

  @override
  String get horoOutOfFive => '5 માંથી';

  @override
  String get horoToneSupportive => 'સહાયક';

  @override
  String get horoToneBalanced => 'સંતુલિત';

  @override
  String get horoToneChallenging => 'કાળજીની જરૂર છે';

  @override
  String get horoLuckyColour => 'લકી કલર';

  @override
  String get horoLuckyNumber => 'નસીબદાર નંબર';

  @override
  String get horoLuckyPlanet => 'સૌથી મજબૂત ગ્રહ';

  @override
  String get horoBestDays => 'તમારા શ્રેષ્ઠ દિવસો';

  @override
  String get horoTipTitle => 'ઉપાય અને ટીપ';

  @override
  String horoTipFor(String planet) {
    return '$planet માટે ઉપાય';
  }

  @override
  String get horoWhyTitle => 'તારાઓ આવું કેમ કહે છે';

  @override
  String get horoWhyBody =>
      'વૈદિક જન્માક્ષર વાંચવામાં આવે છે જ્યાંથી દરેક ગ્રહ સંક્રમણ કરી રહ્યા છે, તમારા ચંદ્ર ચિહ્નમાંથી ગણવામાં આવે છે. એરો બતાવે છે કે પ્લેસમેન્ટ તમને સપોર્ટ કરે છે અથવા કાળજી માટે પૂછે છે.';

  @override
  String horoMoonLine(String sign, String nakshatra, String house) {
    return '$sign · $nakshatra · ઘર $house માં ચંદ્ર';
  }

  @override
  String horoHouseN(String n) {
    return 'ઘર $n';
  }

  @override
  String horoAboutSign(String sign) {
    return 'લગભગ $sign';
  }

  @override
  String get horoElement => 'તત્વ';

  @override
  String get horoRuler => 'શાસક ગ્રહ';

  @override
  String get horoQuality => 'કુદરત';

  @override
  String get horoElementFire => 'આગ';

  @override
  String get horoElementEarth => 'પૃથ્વી';

  @override
  String get horoElementAir => 'હવા';

  @override
  String get horoElementWater => 'પાણી';

  @override
  String get horoQualityMovable => 'જંગમ';

  @override
  String get horoQualityFixed => 'સ્થિર';

  @override
  String get horoQualityDual => 'ડ્યુઅલ';

  @override
  String get horoChangeSign => 'ચિહ્ન બદલો';

  @override
  String get horoChooseSign => 'તમારી નિશાની પસંદ કરો';

  @override
  String get horoWhichSignTitle => 'મારે કયું ચિહ્ન પસંદ કરવું જોઈએ?';

  @override
  String get horoWhichSignBody =>
      'વૈદિક જન્માક્ષર તમારા ચંદ્ર ચિન્હ (રાશિ) પરથી વાંચવામાં આવે છે - જ્યારે તમે જન્મ્યા હતા ત્યારે ચંદ્રની નિશાની હતી. તે ઘણીવાર તમારા પશ્ચિમી સૂર્ય ચિહ્નથી અલગ હોય છે. તમારી કુંડળી તમારી ચંદ્ર ચિહ્ન દર્શાવે છે; સૌથી સચોટ વાંચન માટે તેને અહીં પસંદ કરો.';

  @override
  String get horoOpenKundali => 'કુંડળીમાં મારી ચંદ્ર રાશિ જુઓ';

  @override
  String get horoCtaTitle => 'ફક્ત તમારા માટે જ વાંચન જોઈએ છે?';

  @override
  String horoCtaBody(String sign) {
    return 'આ આગાહી $sign હેઠળ જન્મેલા દરેક માટે છે. જ્યોતિષી તમારો વ્યક્તિગત ચાર્ટ વાંચી શકે છે.';
  }

  @override
  String get horoCtaButton => 'જ્યોતિષ સાથે વાત કરો';

  @override
  String get horoShare => 'શેર કરો';

  @override
  String get horoEditorialBadge => 'અમારા જ્યોતિષીઓ દ્વારા લખાયેલ';

  @override
  String get horoError => 'અમે જન્માક્ષર લોડ કરી શક્યા નથી';

  @override
  String get horoSourceNote =>
      'તમારા ચંદ્ર ચિહ્નથી જીવંત ગ્રહોના સંક્રમણોના આધારે. માર્ગદર્શન માટે, નિશ્ચિતતા માટે નહીં.';

  @override
  String get matchTitle => 'કુંડળી મિલન';

  @override
  String get matchHeroTitle => 'બે કુંડળીનો મેળ કરો';

  @override
  String get matchHeroBody => 'ગુણ મિલન, માંગલિક અને દોષ સેકન્ડમાં તપાસો.';

  @override
  String get matchBoy => 'છોકરો';

  @override
  String get matchGirl => 'છોકરી';

  @override
  String get matchSwap => 'સ્વેપ';

  @override
  String get matchChoosePerson => 'વ્યક્તિ પસંદ કરો';

  @override
  String get matchTapToSelect => 'પસંદ કરવા માટે ટેપ કરો';

  @override
  String get matchRunCta => 'સુસંગતતા તપાસો';

  @override
  String get matchPickBothHint =>
      'તમારો મેચ સ્કોર જોવા માટે બંને લોકોને ચૂંટો.';

  @override
  String get matchPickBoyTitle => 'છોકરાના જન્મની વિગતો પસંદ કરો';

  @override
  String get matchPickGirlTitle => 'છોકરીના જન્મની વિગતો પસંદ કરો';

  @override
  String get matchAddPerson => 'નવી વ્યક્તિ ઉમેરો';

  @override
  String get matchAddPersonHint => 'જન્મ તારીખ, સમય અને સ્થળ';

  @override
  String get matchNoProfiles =>
      'હજી સુધી કોઈ સાચવેલ જન્મ વિગતો નથી. પ્રારંભ કરવા માટે એક વ્યક્તિ ઉમેરો.';

  @override
  String get matchHowTitle => 'તે કેવી રીતે કામ કરે છે';

  @override
  String get matchStep1Title => 'બે લોકોને પસંદ કરો';

  @override
  String get matchStep1Body =>
      'સાચવેલી જન્મ વિગતોનો ઉપયોગ કરો અથવા નવી ઉમેરો — સમય અને સ્થળ તેને સચોટ બનાવે છે.';

  @override
  String get matchStep2Title => 'અમે બંને ચંદ્ર ચાર્ટની તુલના કરીએ છીએ';

  @override
  String get matchStep2Body =>
      'આઠ કૂટ - સ્વભાવથી લઈને સ્વાસ્થ્ય સુધી - પરંપરાગત અષ્ટકૂટની રીતે બનાવવામાં આવે છે.';

  @override
  String get matchStep3Title => 'તમારો સ્કોર અને દોષ તપાસો';

  @override
  String get matchStep3Body =>
      '36 માંથી સ્કોર, માંગલિક સુસંગતતા અને દરેક ભાગનો અર્થ શું છે.';

  @override
  String get matchHistoryTitle => 'તમારા મેળ';

  @override
  String get matchHistoryEmpty =>
      'તમારી મેચો અહીં દેખાશે જેથી તમે કોઈપણ સમયે તેમની ફરી મુલાકાત લઈ શકો.';

  @override
  String get matchRetry => 'ફરી પ્રયાસ કરો';

  @override
  String matchPairNames(String boy, String girl) {
    return '$boy અને $girl';
  }

  @override
  String get matchResultTitle => 'મેચ પરિણામ';

  @override
  String get matchOutOf36 => '36 માંથી';

  @override
  String matchShareScore(String score, String verdict) {
    return 'ગુના મિલાન: $score /36 · $verdict';
  }

  @override
  String get matchVerdictExcellent => 'ઉત્તમ મેચ';

  @override
  String get matchVerdictGood => 'સારી મેચ';

  @override
  String get matchVerdictAverage => 'સરેરાશ મેચ';

  @override
  String get matchVerdictLow => 'નજીકથી જોવાની જરૂર છે';

  @override
  String get matchVerdictExcellentBody =>
      'મોટાભાગના કૂટા સંરેખિત કરે છે - પરંપરાગત રીતે સુમેળભર્યા, સહાયક લગ્નની નિશાની છે.';

  @override
  String get matchVerdictGoodBody =>
      '18 કે તેથી વધુ ગુણ લગ્ન માટે યોગ્ય માનવામાં આવે છે. નીચે લો-સ્કોરિંગ કૂટા તપાસો.';

  @override
  String get matchVerdictAverageBody =>
      '18 ગુણોની નીચે, જ્યોતિષીઓ સામાન્ય રીતે નિર્ણય લેતા પહેલા સંપૂર્ણ ચાર્ટ સમીક્ષા સૂચવે છે.';

  @override
  String get matchVerdictLowBody =>
      'એકલા આ સ્કોર પર નિર્ણય કરશો નહીં — કુંડળીની સંપૂર્ણ સમીક્ષા ઘણીવાર ચિત્રને બદલી નાખે છે.';

  @override
  String get matchManglikShort => 'માંગલિક';

  @override
  String get matchManglikTitle => 'માંગલિક (મંગલ દોષ) તપાસો';

  @override
  String get matchManglikNone =>
      'તમારામાંથી કોઈ માંગલિક નથી - કોઈ મંગલ દોષની ચિંતા નથી.';

  @override
  String get matchManglikBoth =>
      'તમે બંને માંગલિક છો - પરંપરાગત રીતે દોષ રદ થાય છે.';

  @override
  String get matchManglikCancelled =>
      'મંગલ દોષ હાજર છે પરંતુ ચાર્ટમાં અન્ય પ્લેસમેન્ટ દ્વારા રદ કરવામાં આવ્યો છે.';

  @override
  String get matchManglikMismatch =>
      'તમારામાંથી એક જ માંગલિક છે. ઉપાયો અને સંપૂર્ણ ચાર્ટ સમીક્ષા વિશે જ્યોતિષ સાથે વાત કરો.';

  @override
  String get matchIsManglik => 'માંગલિક';

  @override
  String get matchNotManglik => 'માંગલિક નહિ';

  @override
  String get matchManglikCancelledShort => 'માંગલિક (રદ કરેલ)';

  @override
  String matchCheckClear(String name) {
    return '$name : સ્પષ્ટ';
  }

  @override
  String matchCheckPresent(String name) {
    return '$name : હાજર';
  }

  @override
  String get matchDoshaNadi => 'નાડી દોષ';

  @override
  String get matchDoshaBhakoot => 'ભકૂટ દોષ';

  @override
  String get matchDoshaGana => 'ગણ દોષ';

  @override
  String get matchDoshaTag => 'દોષા';

  @override
  String get matchBreakdownTitle => 'ગુના ભંગાણ';

  @override
  String get matchBreakdownSub =>
      'તેનો અર્થ શું છે તે જોવા માટે કોઈપણ કૂટાને ટેપ કરો.';

  @override
  String get matchKootaVarna => 'વર્ણા';

  @override
  String get matchKootaVashya => 'વશ્ય';

  @override
  String get matchKootaTara => 'તારા';

  @override
  String get matchKootaYoni => 'યોની';

  @override
  String get matchKootaMaitri => 'ગ્રહ મૈત્રી';

  @override
  String get matchKootaGana => 'ગણ';

  @override
  String get matchKootaBhakoot => 'ભકૂટ';

  @override
  String get matchKootaNadi => 'નાડી';

  @override
  String get matchKootaVarnaMeaning => 'મૂલ્યો અને અહંકાર';

  @override
  String get matchKootaVashyaMeaning => 'પરસ્પર આકર્ષણ';

  @override
  String get matchKootaTaraMeaning => 'નિયતિ અને સુખાકારી';

  @override
  String get matchKootaYoniMeaning => 'શારીરિક સંવાદિતા';

  @override
  String get matchKootaMaitriMeaning => 'માનસિક તરંગલંબાઇ';

  @override
  String get matchKootaGanaMeaning => 'સ્વભાવ';

  @override
  String get matchKootaBhakootMeaning => 'પ્રેમ, કુટુંબ અને નાણાકીય';

  @override
  String get matchKootaNadiMeaning => 'આરોગ્ય અને બાળકો';

  @override
  String get matchKootaVarnaDetail =>
      'બંને ચંદ્ર ચિહ્નોના આધ્યાત્મિક સ્વભાવની તુલના કરે છે - તમારા મૂલ્યો અને ફરજની ભાવના કેટલી સ્વાભાવિક રીતે છે. 1 પોઈન્ટ વર્થ.';

  @override
  String get matchKootaVashyaDetail =>
      'ભાગીદારો વચ્ચે કુદરતી ખેંચાણ અને પ્રભાવ દર્શાવે છે - કોણ દોરી જાય છે, કોણ અનુકૂલન કરે છે અને તમે કેટલી સરળતાથી સંમત થાઓ છો. 2 પોઈન્ટ વર્થ.';

  @override
  String get matchKootaTaraDetail =>
      'નસીબ, આરોગ્ય અને બોન્ડની આયુષ્યનો નિર્ણય કરવા માટે તમારી વચ્ચેના નક્ષત્રોની ગણતરી કરે છે. 3 પોઈન્ટ વર્થ.';

  @override
  String get matchKootaYoniDetail =>
      'દરેક નક્ષત્રમાં પ્રાણી સ્વભાવ હોય છે; આ કૂટા આત્મીયતા અને શારીરિક સુસંગતતા માટે તેમની તુલના કરે છે. 4 પોઈન્ટ વર્થ.';

  @override
  String get matchKootaMaitriDetail =>
      'તમારા ચંદ્ર ચિહ્નોના સ્વામીઓની તુલના કરો - તેમની વચ્ચે મિત્રતાનો અર્થ એ છે કે તમે એકસરખું વિચારો છો અને સમસ્યાઓ સરળતાથી ઉકેલી શકો છો. 5 પોઈન્ટ વર્થ.';

  @override
  String get matchKootaGanaDetail =>
      'નક્ષત્રોને દેવ, મનુષ્ય અને રક્ષા સ્વભાવમાં જૂથબદ્ધ કરે છે. મિસમેચનો અર્થ વારંવાર ઘર્ષણ થઈ શકે છે. 6 પોઈન્ટ વર્થ.';

  @override
  String get matchKootaBhakootDetail =>
      'તમારા ચંદ્ર ચિહ્નો વચ્ચેનું અંતર જુએ છે, જે પરંપરાગત રીતે પ્રેમ, કૌટુંબિક વૃદ્ધિ અને વહેંચાયેલ નાણાકીય બાબતોને અસર કરે છે. 7 પોઈન્ટ વર્થ.';

  @override
  String get matchKootaNadiDetail =>
      'સૌથી વધુ વજનવાળા કૂટા. સમાન નાડી (0 પોઈન્ટ) પરંપરાગત રીતે આરોગ્ય અને સંતાનની ચિંતાઓ સાથે જોડાયેલી છે અને તેમાં જાણીતા અપવાદો છે. 8 પોઈન્ટ વર્થ.';

  @override
  String get matchChartsTitle => 'જન્મ ચાર્ટ વિગતો';

  @override
  String get matchRowRasi => 'ચંદ્ર ચિહ્ન';

  @override
  String get matchRowNakshatra => 'નક્ષત્ર';

  @override
  String get matchRowGana => 'ગણ';

  @override
  String get matchRowYoni => 'યોની';

  @override
  String get matchAskTitle => 'કોઈ જ્યોતિષ સાથે વાત કરો';

  @override
  String get matchAskBody =>
      'દોષોમાં વારંવાર રદબાતલ અને ઉપાયો હોય છે. બંને ચાર્ટનું સંપૂર્ણ વાંચન મેળવો.';

  @override
  String get matchDisclaimer =>
      'ગુણ મિલન એ પરંપરાગત માર્ગદર્શિકા છે, ગેરંટી નથી. સંપૂર્ણ ચાર્ટ અને તમારા પોતાના નિર્ણયને ધ્યાનમાં લો.';

  @override
  String get matchRelSelf => 'મારી જાત';

  @override
  String get matchRelPartner => 'જીવનસાથી';

  @override
  String get matchRelChild => 'બાળક';

  @override
  String get matchRelParent => 'પિતૃ';

  @override
  String get matchRelSibling => 'બહેન';

  @override
  String get matchRelFriend => 'મિત્ર';

  @override
  String get kAdvTitle => 'અદ્યતન અહેવાલો';

  @override
  String get kAdvIntro =>
      'તકનીકી સ્તરો જ્યોતિષીઓ ઊંડાઈ અને સમય માટે વાપરે છે. રસ માટે તેમને સ્કિમ કરો, અથવા પરામર્શ દરમિયાન એક ખોલો.';

  @override
  String get kAdvAshtakavarga => 'અષ્ટકવર્ગ';

  @override
  String get kAdvAshtakavargaSub =>
      'દરેક ચિહ્નની બિંદુ-શક્તિ. ઉચ્ચ = આકાશ ત્યાં પરિવહનને સમર્થન આપે છે.';

  @override
  String get kAdvShadbala => 'શાદબાલા';

  @override
  String get kAdvShadbalaSub =>
      'દરેક ગ્રહની છ-ગણી તાકાત, તેની જરૂરિયાત સામે માપવામાં આવે છે.';

  @override
  String get kAdvKp => 'કેપી સિસ્ટમ';

  @override
  String get kAdvKpSub =>
      'કૃષ્ણમૂર્તિ પધ્ધતિ - સમય માટે કુશળ ઉપ-સ્વામી અને શાસક ગ્રહો.';

  @override
  String get kAdvJaimini => 'જૈમિની';

  @override
  String get kAdvJaiminiSub =>
      'ચારા કરકસ, અરુધા લગ્ન અને ચાર્ટ વાંચવાની જૈમિની રીત.';

  @override
  String get kAdvDownloadPdf => 'સંપૂર્ણ પીડીએફ રિપોર્ટ ડાઉનલોડ કરો';

  @override
  String get kAdvFooter =>
      'આ તકનીકી છે. સાદા શબ્દોમાં વાંચવા માટે, જ્યોતિષ સાથે વાત કરો.';

  @override
  String get kAdvReport => 'જાણ કરો';

  @override
  String get kAdvLoadError => 'આ રિપોર્ટ લોડ કરી શકાયો નથી.';

  @override
  String get kAdvKpIntro =>
      'KP રાશિચક્રને 249 પેટા ભાગોમાં વિભાજિત કરે છે. હાઉસ કુપ્સનો ઉપ-સ્વામી નક્કી કરે છે કે જીવનનું તે ક્ષેત્ર વિતરિત કરે છે કે કેમ; શાસક ગ્રહોનો ઉપયોગ સ્થળ પરના સમય માટે થાય છે.';

  @override
  String get kAdvJaiminiIntro =>
      'જૈમિની ચારા કરાક (પક્ષીય દ્વારા ક્રમાંકિત ગ્રહો, દરેક જીવન વિસ્તાર દર્શાવે છે) અને અરુધા પદો દ્વારા ચાર્ટ વાંચે છે — વસ્તુઓ વિશ્વમાં કેવી રીતે દેખાય છે.';

  @override
  String get kAdvAvIntro =>
      'સર્વાષ્ટકવર્ગ દરેક ઘરમાં દરેક ગ્રહનું યોગદાન ઉમેરે છે — કુલ હંમેશા 337 છે. 28+ સ્કોર કરતું ઘર તેમાંથી પસાર થતા ગ્રહોને સમર્થન આપે છે; 25 ની નીચે એક નબળો પેચ છે.';

  @override
  String kAdvHouseN(Object n) {
    return 'ઘર $n';
  }

  @override
  String get kAdvBhinnaTotals => 'ગ્રહ દીઠ કુલ (ભિન્નષ્ટકવર્ગ)';

  @override
  String get kAdvShadbalaIntro =>
      'શાદબાલા દરેક ગ્રહની તાકાતને તેની જરૂરિયાતની ન્યૂનતમ સામે રૂપામાં સ્કોર કરે છે. 1.0 થી ઉપરનો ગુણોત્તર એટલે કે ગ્રહ તેના પરિણામો વિશ્વસનીય રીતે આપી શકે છે.';

  @override
  String kAdvStrongest(Object planet) {
    return 'સૌથી મજબૂત: $planet';
  }

  @override
  String kAdvWeakest(Object planet) {
    return 'સૌથી નબળું: $planet';
  }

  @override
  String get kAdvReadWithAstrologer => 'આ અહેવાલ જ્યોતિષ પાસે વાંચવાનો છે.';

  @override
  String get kAdvSecCuspalSublords => 'કુસ્પલ સબ-લોર્ડ્સ';

  @override
  String get kAdvSecRulingPlanets => 'શાસક ગ્રહો';

  @override
  String get kAdvSecHouseSignificators => 'ઘરના અર્થકર્તાઓ';

  @override
  String get kAdvSecCharaKarakas => 'ચરા કરકસ';

  @override
  String get kAdvSecArudhaPadas => 'અરુધા પાડો';

  @override
  String get kAdvSecKarakamsa => 'કરકંસા';

  @override
  String get kAdvSecCharaDasha => 'ચરા દશા';

  @override
  String get kBhavaTitle => 'ઘરો · ભાવ';

  @override
  String get kBhavaIntro =>
      '12 ઘરોમાંથી દરેક, તેના કુદરતી સંકેતો અને તેના સ્વામી અને રહેવાસીઓ તેને કેવી રીતે આકાર આપે છે.';

  @override
  String get kBhavaMoreBenefic => 'હાનિકારક પ્રભાવ કરતાં વધુ ફાયદાકારક';

  @override
  String get kBhavaMoreMalefic => 'ફાયદાકારક પ્રભાવ કરતાં વધુ નુકસાનકારક';

  @override
  String kBhavaOccupiedBy(Object planets) {
    return '$planets દ્વારા કબજો';
  }

  @override
  String kBhavaAspectedBy(Object planets) {
    return '$planets દ્વારા આસ્પેક્ટેડ';
  }

  @override
  String kBhavaBeneficCount(Object count) {
    return '$count ફાયદાકારક';
  }

  @override
  String kBhavaMaleficCount(Object count) {
    return '$count નુકસાનકારક';
  }

  @override
  String get kBhavaNeedsTime => 'ઘરના વિશ્લેષણ માટે જન્મ સમયની જરૂર છે';

  @override
  String get kBhavaNeedsTimeBody =>
      'દરેક ઘરનો આકાર કેવો છે તે જોવા માટે આ પ્રોફાઇલમાં જન્મનો ચોક્કસ સમય ઉમેરો.';

  @override
  String get kDashaIntroVimshottari =>
      'વિમશોત્તરી એ ગ્રહોના સમયગાળાનું 120-વર્ષનું ચક્ર છે, જ્યાંથી તમારા જન્મ સમયે ચંદ્ર બેઠો હતો.';

  @override
  String get kDashaIntroYogini =>
      'યોગિની એ ચંદ્રના નક્ષત્રથી આઠ યોગિનીઓનું 36 વર્ષનું ચક્ર છે.';

  @override
  String get kDashaIntroAshtottari =>
      'અષ્ટોત્તરી એ 108 વર્ષનું ચક્ર છે જે આર્દ્રામાંથી ગણવામાં આવે છે.';

  @override
  String kDashaBalance(Object lord, Object years) {
    return 'જન્મ સમયે $lord દશાનું સંતુલન: $years વર્ષ';
  }

  @override
  String get kDashaVimshottari => 'વિમશોત્તરી';

  @override
  String get kDashaYogini => 'યોગિની';

  @override
  String get kDashaAshtottari => 'અષ્ટોત્તરી';

  @override
  String get kDashaNowRunning => 'હવે ચાલી રહ્યું છે';

  @override
  String get kDashaNow => 'હવે';

  @override
  String kDashaYears(Object count) {
    return '$count વર્ષ';
  }

  @override
  String get kPlanetsIntro =>
      'દરેક ગ્રહ ક્યાં બેસે છે, તે કેટલો મજબૂત છે અને તે શું લાવે છે. વધુ વાંચવા માટે ટૅપ કરો. પોઝિશન્સ સાઈડરીયલ (લહેરી) છે.';

  @override
  String get kTrTitle => 'પરિવહન';

  @override
  String get kTrSadeSatiCalendar =>
      'સંપૂર્ણ સાદે સતી કેલેન્ડર જુઓ (તારીખ સાથે)';

  @override
  String get kTrSkyNow => 'અત્યારે આકાશ - તમારા ચાર્ટની સામે';

  @override
  String get kTrSadeSati => 'સાદે સતી';

  @override
  String kTrPhaseOf(Object n) {
    return '3 માંથી $n તબક્કો';
  }

  @override
  String get kTrPhaseHintRising => '12માં શનિ';

  @override
  String get kTrPhaseHintPeak => 'ચંદ્ર ઉપર';

  @override
  String get kTrPhaseHintSetting => '2જીમાં શનિ';

  @override
  String get kTrHowToWork => 'તેની સાથે કેવી રીતે કામ કરવું';

  @override
  String get kTrTip1 =>
      'જે કામ કરતું નથી તેને કાપો - શનિ તેના વિશે પ્રમાણિકતાને પુરસ્કાર આપે છે';

  @override
  String get kTrTip2 => 'દિનચર્યાઓ બનાવો અને તમે જે શરૂ કરો તે પૂર્ણ કરો';

  @override
  String get kTrTip3 => 'તમારી ઊંઘ, ઘૂંટણ, દાંત અને વૃદ્ધ સંબંધીઓની સંભાળ રાખો';

  @override
  String get kTrTip4 =>
      'તે પુનઃનિર્માણ છે, સજા નથી. તે સમાપ્ત થયા પછી પરિણામો દર્શાવે છે.';

  @override
  String get kTrPanotiBody =>
      'ટૂંકા (~2½ વર્ષ) શનિનો તબક્કો. સ્વાસ્થ્ય, રોજિંદા પ્રયત્નો અને અવરોધો સાથે ઘર્ષણની અપેક્ષા રાખો - તેને ધીરજ અને દિનચર્યા સાથે મળો.';

  @override
  String kTrPlanetInSign(Object planet, Object sign) {
    return '$sign માં $planet';
  }

  @override
  String get kTrJupiterGood =>
      'ગુરુનું સંક્રમણ સાનુકૂળ છે - અત્યારે વૃદ્ધિ, ભણતર, પૈસા અને કુટુંબ માટે સહાયક છે.';

  @override
  String get kTrJupiterNeutral =>
      'ગુરુનું સંક્રમણ અત્યારે તમારા માટે તટસ્થ છે.';

  @override
  String get kTrCloseContacts => 'હવે સંપર્કો બંધ કરો';

  @override
  String kTrCloseContactLine(Object natal, Object planet) {
    return '$planet સંક્રમણ તમારા જન્મના $natal ના 3°ની અંદર છે — જીવનનું તે ક્ષેત્ર આ અઠવાડિયે સક્રિય છે.';
  }

  @override
  String kMuChoghadiya(String key, Object raw) {
    String _temp0 = intl.Intl.selectLogic(key, {'other': '$raw'});
    return '$_temp0';
  }

  @override
  String kUpOr(Object name) {
    return 'અથવા $name';
  }

  @override
  String kUpFinger(Object finger) {
    return '$finger આંગળી';
  }

  @override
  String get kYdPartial => 'આંશિક';

  @override
  String get moodTitle => 'આજનો મૂડ';

  @override
  String get moodMeter => 'મૂડ મીટર';

  @override
  String get moodWhyTitle => 'આજે કેમ આવું લાગે છે';

  @override
  String get moodTipTitle => 'આજની એક નાની વાત';

  @override
  String get moodLockedTitle => 'તમારા જ્યોતિષી તમને કહી શકે છે';

  @override
  String get moodLockedSub =>
      'સંપૂર્ણ ચિત્રને તમારા આખા ચાર્ટની જરૂર છે, માત્ર ચંદ્રની જ નહીં.';

  @override
  String get moodTalkCta => 'હવે કોઈ જ્યોતિષ સાથે વાત કરો';

  @override
  String moodNextChange(Object when) {
    return 'તમારો મૂડ $when ના રોજ બદલાશે';
  }

  @override
  String get kOvExMood => 'આજનો મૂડ';

  @override
  String get kOvExMoodSub => 'ચંદ્ર આજે તમારા મનને કેવી રીતે આકાર આપી રહ્યો છે';

  @override
  String get prefsMoodAlerts => 'દૈનિક મૂડ ચેતવણીઓ';

  @override
  String get prefsMoodAlertsDesc =>
      'અઠવાડિયામાં લગભગ ત્રણ સવારે, જ્યારે ચંદ્ર તમારા ચાર્ટમાં સાઇન બદલાય છે.';

  @override
  String get callCalling => 'કૉલ કરી રહ્યાં છીએ…';

  @override
  String get callRinging => 'રિંગિંગ…';

  @override
  String get callConnecting => 'કનેક્ટ કરી રહ્યું છે...';

  @override
  String get callReconnecting => 'ફરીથી કનેક્ટ કરી રહ્યું છે...';

  @override
  String get callEnded => 'કૉલ સમાપ્ત થયો';

  @override
  String get callPoorConnection => 'નબળું જોડાણ';

  @override
  String get callMute => 'મ્યૂટ કરો';

  @override
  String get callSpeaker => 'વક્તા';

  @override
  String get callEnd => 'અંત';

  @override
  String get callEncrypted => 'એન્ક્રિપ્ટેડ કૉલ';

  @override
  String get callMicTitle => 'માઇક્રોફોન જરૂરી છે';

  @override
  String get callMicBody =>
      'માઇક્રોફોનને ઍક્સેસ કરવાની મંજૂરી આપો જેથી જ્યોતિષી તમને સાંભળી શકે.';

  @override
  String get callMicBlockedBody =>
      'TalkAcharya માટે માઇક્રોફોન ઍક્સેસ બંધ છે. તેને સેટિંગ્સમાં ચાલુ કરો.';

  @override
  String get callOpenSettings => 'સેટિંગ્સ ખોલો';

  @override
  String get callTryAgain => 'ફરી પ્રયાસ કરો';

  @override
  String get callFailedTitle => 'કૉલ શરૂ કરી શકાયો નથી';

  @override
  String get callEndConfirmTitle => 'આ કૉલ સમાપ્ત કરીએ?';

  @override
  String get callEndConfirmBody =>
      'કૉલ સમાપ્ત થતાંની સાથે જ બિલિંગ બંધ થઈ જાય છે.';

  @override
  String get callEndConfirmYes => 'કૉલ સમાપ્ત કરો';

  @override
  String get callEndConfirmNo => 'બોલતા રહો';

  @override
  String callWaitingAccept(String name) {
    return '$name સ્વીકારવાની રાહ જોઈ રહ્યાં છીએ...';
  }

  @override
  String callBookTitle(String name) {
    return '$name પર કૉલ કરો';
  }

  @override
  String get callBookBilling =>
      'વૉઇસ કૉલ · એકવાર કનેક્ટ થયા પછી પ્રતિ મિનિટ બિલ';

  @override
  String callBookCta(String price) {
    return 'કૉલ શરૂ કરો · $price /મિનિટ';
  }

  @override
  String get callUnavailable => 'આ જ્યોતિષી અત્યારે ફોન નથી લઈ રહ્યા.';

  @override
  String get giftAction => 'ભેટ મોકલો';

  @override
  String giftSheetTitle(String name) {
    return '$name ને ભેટ મોકલો';
  }

  @override
  String get giftSheetSubtitle =>
      'કૃતજ્ઞતાનું એક નાનું પ્રતીક - તેઓ તેને તરત જ જુએ છે.';

  @override
  String get giftQuantity => 'જથ્થો';

  @override
  String get giftAddNote => 'એક નોંધ ઉમેરો';

  @override
  String get giftNoteHint => 'ટૂંકો સંદેશ લખો (વૈકલ્પિક)';

  @override
  String get giftChoose => 'ભેટ પસંદ કરો';

  @override
  String giftSendCta(String gift, String price) {
    return '$gift · $price મોકલો';
  }

  @override
  String giftWalletBalance(String amount) {
    return 'બેલેન્સ $amount';
  }

  @override
  String get giftAddMoney => 'પૈસા ઉમેરો';

  @override
  String get giftLowBalanceTitle => 'પર્યાપ્ત સંતુલન નથી';

  @override
  String get giftLowBalanceBody =>
      'આ ભેટ મોકલવા માટે તમારા વૉલેટમાં પૈસા ઉમેરો.';

  @override
  String giftSentTitle(String gift, String name) {
    return '$name ને $gift મોકલ્યો';
  }

  @override
  String get giftSentBody => 'તેઓ તેને તરત જ જોશે. તમારી દયા બદલ આભાર!';

  @override
  String get giftSendAnother => 'બીજું મોકલો';

  @override
  String get giftLoadError => 'ભેટ લોડ કરી શકાઈ નથી';

  @override
  String get giftThankYouTitle => 'ભેટ સાથે આભાર કહો';

  @override
  String giftThankYouBody(String name) {
    return 'સત્ર ગમ્યું? $name ને કૃતજ્ઞતાનું નાનું પ્રતીક મોકલો.';
  }

  @override
  String get giftThankYouSentTitle => 'તમારી ભેટ બદલ આભાર';

  @override
  String get helpTitle => 'મદદ અને સમર્થન';

  @override
  String get helpHeroTitle => 'અમે કેવી રીતે મદદ કરી શકીએ?';

  @override
  String get helpHeroBody =>
      'સત્રમાં સમસ્યાની જાણ કરો, તમારા અહેવાલોને ટ્રૅક કરો અથવા અમારી ટીમ સુધી પહોંચો.';

  @override
  String get helpReportSection => 'સત્રમાં સમસ્યાની જાણ કરો';

  @override
  String get helpReportEmpty => 'તમારા પૂર્ણ થયેલા સત્રો અહીં દેખાશે.';

  @override
  String get helpReportAction => 'જાણ કરો';

  @override
  String get helpYourReports => 'તમારા અહેવાલો';

  @override
  String get helpContactSection => 'અમારો સંપર્ક કરો';

  @override
  String get helpWhatsapp => 'વોટ્સએપ પર ચેટ કરો';

  @override
  String get helpEmailUs => 'અમને ઇમેઇલ કરો';

  @override
  String get helpCentre => 'મદદ કેન્દ્ર';

  @override
  String get helpFaqSection => 'વારંવાર પૂછાતા પ્રશ્નો';

  @override
  String get helpLoadError => 'તમારા સત્રો લોડ કરી શકાયા નથી.';

  @override
  String get helpFaqChargesQ =>
      'પરામર્શ માટે મારી પાસેથી કેવી રીતે શુલ્ક લેવામાં આવે છે?';

  @override
  String get helpFaqChargesA =>
      'સત્ર લાઇવ હોય ત્યારે જ તમે પ્રતિ મિનિટ ચૂકવણી કરો છો. જ્યારે જ્યોતિષી જોડાય છે ત્યારે બિલિંગ શરૂ થાય છે અને તમારામાંથી કોઈ એક તેને સમાપ્ત કરે તે ક્ષણ બંધ થાય છે.';

  @override
  String get helpFaqNoResponseQ => 'જો જ્યોતિષી જવાબ ન આપે તો શું?';

  @override
  String get helpFaqNoResponseA =>
      'જો તમારી વિનંતી સ્વીકારવામાં ન આવે, તો તમારી પાસેથી શુલ્ક લેવામાં આવશે નહીં — સત્ર માટે રાખવામાં આવેલી કોઈપણ રકમ તમારા વૉલેટમાં પાછી જાય છે.';

  @override
  String get helpFaqRefundQ => 'શું હું રિફંડ મેળવી શકું?';

  @override
  String get helpFaqRefundA =>
      'જો કંઈક ખોટું થયું હોય - ખોટા શુલ્ક, તકનીકી સમસ્યા અથવા બિનસહાયક સત્ર - તે સત્રમાંથી તેની જાણ કરો. અમારી ટીમ દરેક રિપોર્ટની સમીક્ષા કરે છે અને જ્યારે તેની ખાતરી હોય ત્યારે તમારા વૉલેટમાં રિફંડ કરવામાં આવે છે.';

  @override
  String get helpFaqBalanceQ =>
      'સત્ર દરમિયાન મારું સંતુલન સમાપ્ત થઈ ગયું. હવે શું?';

  @override
  String get helpFaqBalanceA =>
      'જ્યારે તમારું બેલેન્સ સમાપ્ત થાય છે ત્યારે સત્ર આપમેળે સમાપ્ત થાય છે. તમારું વૉલેટ રિચાર્જ કરો અને સત્રના સારાંશમાંથી એ જ જ્યોતિષ સાથે ફરી શરૂ કરો.';

  @override
  String get helpFaqPrivacyQ => 'શું મારી વાતચીત ખાનગી છે?';

  @override
  String get helpFaqPrivacyA =>
      'તમારી પરામર્શ તમારી અને તમારા જ્યોતિષી વચ્ચે છે. અમારી સપોર્ટ ટીમ માત્ર રિપોર્ટને ઉકેલવા અથવા પ્લેટફોર્મને સુરક્ષિત રાખવા માટે સત્રને જુએ છે.';

  @override
  String get helpFaqLanguageQ => 'હું એપ્લિકેશનની ભાષા કેવી રીતે બદલી શકું?';

  @override
  String get helpFaqLanguageA =>
      'પ્રોફાઇલ → ભાષા પર જાઓ અને તમને સૌથી વધુ અનુકૂળ હોય તેવી ભાષા પસંદ કરો.';

  @override
  String get reportTitle => 'સમસ્યાની જાણ કરો';

  @override
  String reportSessionWith(String name) {
    return '$name સાથે સત્ર';
  }

  @override
  String get reportWhatHappened => 'શું ખોટું થયું?';

  @override
  String get reportTypeBilling => 'ખોટા આરોપો';

  @override
  String get reportTypeBillingHint => 'મારાથી વધુ ચાર્જ લેવામાં આવ્યો હતો';

  @override
  String get reportTypeQuality => 'બિનઉપયોગી સત્ર';

  @override
  String get reportTypeQualityHint =>
      'માર્ગદર્શન એ ન હતું જેનું વચન આપવામાં આવ્યું હતું';

  @override
  String get reportTypeConduct => 'અયોગ્ય વર્તન';

  @override
  String get reportTypeConductHint =>
      'જ્યોતિષી અસંસ્કારી અથવા બિનવ્યાવસાયિક હતો';

  @override
  String get reportTypeNoShow => 'જ્યોતિષીએ જવાબ ન આપ્યો';

  @override
  String get reportTypeNoShowHint =>
      'તેઓએ સ્વીકાર્યું પરંતુ ખરેખર ક્યારેય જોડાયા નહીં';

  @override
  String get reportTypeTechnical => 'ટેકનિકલ સમસ્યા';

  @override
  String get reportTypeTechnicalHint => 'ચેટ કે કોલ ફેલ થતો રહ્યો';

  @override
  String get reportDescribe => 'અમને વધુ કહો';

  @override
  String get reportDescribeHint =>
      'શું થયું તે શેર કરો — જેટલી વધુ વિગત, તેટલી ઝડપથી અમે મદદ કરી શકીએ.';

  @override
  String reportMinChars(String count) {
    return 'ઓછામાં ઓછા $count અક્ષરો';
  }

  @override
  String get reportPrivacyNote =>
      'તમારી રિપોર્ટ જોવા માટે, અમારી સપોર્ટ ટીમ આ સત્રની સમીક્ષા કરશે.';

  @override
  String get reportSubmit => 'રિપોર્ટ સબમિટ કરો';

  @override
  String get reportSubmittedTitle => 'રિપોર્ટ સબમિટ કર્યો';

  @override
  String get reportSubmittedBody =>
      'અમે તેની તપાસ કરીશું અને અપડેટ આવતાં જ તમને સૂચિત કરીશું.';

  @override
  String get reportAlreadyTitle => 'તમે પહેલાથી જ આ સત્રની જાણ કરી છે';

  @override
  String get reportAlreadyBody =>
      'અમારી ટીમ તેની તપાસ કરી રહી છે. જ્યારે અપડેટ આવશે ત્યારે તમને સૂચિત કરવામાં આવશે.';

  @override
  String get reportViewStatus => 'રિપોર્ટની સ્થિતિ જુઓ';

  @override
  String get disputeTitle => 'વિગતોની જાણ કરો';

  @override
  String get disputeStatusOpen => 'પ્રાપ્ત';

  @override
  String get disputeStatusInvestigating => 'સમીક્ષા હેઠળ';

  @override
  String get disputeStatusResolved => 'ઉકેલાઈ';

  @override
  String get disputeStatusRejected => 'બંધ';

  @override
  String get disputeHeadlineOpen => 'અમને તમારો રિપોર્ટ મળ્યો છે';

  @override
  String get disputeHeadlineInvestigating =>
      'અમારી ટીમ તમારા રિપોર્ટની સમીક્ષા કરી રહી છે';

  @override
  String get disputeHeadlineResolved => 'તમારો રિપોર્ટ ઉકેલાઈ ગયો છે';

  @override
  String get disputeHeadlineRejected => 'અમે તમારી રિપોર્ટની સમીક્ષા કરી છે';

  @override
  String get disputeOpenBody => 'અપડેટ આવતાં જ અમે તમને સૂચિત કરીશું.';

  @override
  String disputeReportedOn(String date) {
    return '$date પર જાણ કરી';
  }

  @override
  String disputeRefundedTitle(String amount) {
    return 'તમારા વૉલેટમાં $amount રિફંડ';
  }

  @override
  String get disputeOpenWallet => 'વૉલેટ';

  @override
  String get disputeOutcome => 'પરિણામ';

  @override
  String get disputeOutcomeNoRefund =>
      'આ સત્ર માટે કોઈ રિફંડ જારી કરવામાં આવ્યું નથી.';

  @override
  String get disputeTimeline => 'પ્રગતિ';

  @override
  String get disputeStepRaised => 'રિપોર્ટ સબમિટ કર્યો';

  @override
  String get disputeStepReviewing => 'સમીક્ષા હેઠળ';

  @override
  String get disputeStepResolved => 'ઉકેલાઈ';

  @override
  String get disputeStepRejected => 'બંધ';

  @override
  String get disputeYourReport => 'તમારો રિપોર્ટ';

  @override
  String get roomReportProblem => 'સમસ્યાની જાણ કરો';

  @override
  String get articlesTitle => 'વાંચો અને શીખો';

  @override
  String get articlesRailSubtitle => 'માર્ગદર્શિકાઓ, ઉપાયો અને ઉત્સવો';

  @override
  String get articlesAll => 'બધા';

  @override
  String get articlesEmptyTitle => 'હજુ સુધી અહીં વાંચવા માટે કંઈ નથી';

  @override
  String get articlesEmptyBody =>
      'નવા લેખો તેમના માર્ગ પર છે — ટૂંક સમયમાં પાછા તપાસો.';

  @override
  String get articleCatAstrology => 'જ્યોતિષશાસ્ત્ર';

  @override
  String get articleCatHoroscope => 'જન્માક્ષર';

  @override
  String get articleCatFestivals => 'તહેવારો';

  @override
  String get articleCatRemedies => 'ઉપાયો';

  @override
  String get articleCatGuides => 'માર્ગદર્શિકાઓ';

  @override
  String get articleCatNews => 'સમાચાર';

  @override
  String articleMinRead(int minutes) {
    return '$minutes મિનિટ વાંચ્યું';
  }

  @override
  String get articleShare => 'શેર કરો';

  @override
  String get articleMoreToRead => 'વધુ વાંચવા માટે';

  @override
  String get articleAskTitle => 'તમારા પોતાના ચાર્ટ માટે માર્ગદર્શન જોઈએ છે?';

  @override
  String get articleAskBody => 'ચકાસાયેલ જ્યોતિષ સાથે મિનિટોમાં વાત કરો.';

  @override
  String get articleAskCta => 'હવે પૂછો';

  @override
  String get panchangTitle => 'પંચાંગ';

  @override
  String get panchangToday => 'આજે';

  @override
  String get panchangPickDate => 'તારીખ ચૂંટો';

  @override
  String panchangMoonIn(String sign) {
    return '$sign માં ચંદ્ર';
  }

  @override
  String panchangTill(String time) {
    return '$time સુધી';
  }

  @override
  String get panchangRightNow => 'અત્યારે';

  @override
  String panchangNowChoghadiya(String name, String time) {
    return '$name ચોઘડિયા $time સુધી';
  }

  @override
  String panchangRahuNow(String time) {
    return 'રાહુ કાલ $time સુધી ચાલુ છે — નવી શરૂઆત માટે રોકો.';
  }

  @override
  String get panchangLimbs => 'આજનો પંચાંગ';

  @override
  String get panchangAuspicious => 'શુભ સમય';

  @override
  String get panchangInauspicious => 'નવું કામ શરૂ કરવાનું ટાળો';

  @override
  String get panchangBrahma => 'બ્રહ્મ મુહૂર્ત';

  @override
  String get panchangAbhijit => 'અભિજિત મુહૂર્ત';

  @override
  String get panchangNoAbhijit => 'બુધવારે અભિજિત મુહૂર્ત મનાવવામાં આવતું નથી.';

  @override
  String get panchangRahuKaal => 'રાહુ કાલ';

  @override
  String get panchangYamaganda => 'યમાગંડા';

  @override
  String get panchangGulika => 'ગુલિકા કાલ';

  @override
  String get panchangChoghadiya => 'ચોઘડિયા';

  @override
  String get panchangDay => 'દિવસ';

  @override
  String get panchangNight => 'રાત્રિ';

  @override
  String get panchangNotes => 'અમારા જ્યોતિષીઓ તરફથી નોંધો';

  @override
  String get panchangPersonalTitle => 'તમારા ચાર્ટ માટે સમય';

  @override
  String get panchangPersonalBody =>
      'તમારી કુંડળીમાંથી વર્કઆઉટ કરેલા કલાકો જુઓ જે તમને શ્રેષ્ઠ અનુરૂપ છે.';

  @override
  String panchangFooter(String place, String timezone) {
    return 'સ્થાનિક સૂર્યોદયથી $place · $timezone · માટે ગણતરી';
  }

  @override
  String get panchangChoosePlaceTitle => 'તમારું શહેર પસંદ કરો';

  @override
  String get panchangChoosePlaceBody =>
      'પંચાંગનો સમય તમે ક્યાં છો તેના પર આધાર રાખે છે — તમે જે શહેર માટે ઇચ્છો છો તે પસંદ કરો.';

  @override
  String get panchangChoosePlaceCta => 'શહેર પસંદ કરો';

  @override
  String panchangUsePlace(String place) {
    return '$place નો ઉપયોગ કરો';
  }

  @override
  String get panchangCity => 'શહેર';

  @override
  String get panchangCityHint => 'શહેર અથવા નગર શોધો';

  @override
  String get kPdfTitle => 'કુંડળી રિપોર્ટ (PDF)';

  @override
  String get kPdfFull => 'સંપૂર્ણ અહેવાલ';

  @override
  String get kPdfFullSub => 'ચાર્ટ, ગ્રહો, અવકાહદ, દશા સમયરેખા, યોગ અને દોષ';

  @override
  String get kPdfBasic => 'એક-પૃષ્ઠનો સારાંશ';

  @override
  String get kPdfBasicSub => 'ગ્રહ સ્થિતિ સાથે લગ્ન અને નવમસા ચાર્ટ';

  @override
  String get kPdfChartStyle => 'ચાર્ટ શૈલી';

  @override
  String get kPdfEastIndian => 'પૂર્વ ભારતીય';

  @override
  String get kPdfShareCta => 'ડાઉનલોડ કરો અને શેર કરો';

  @override
  String get kPdfPreparing => 'તમારી PDF તૈયાર કરી રહ્યાં છીએ...';

  @override
  String get kPdfNote =>
      'પીડીએફ અંગ્રેજીમાં છે. તેને તમારા ફોનમાં સેવ કરો અથવા WhatsApp પર મોકલો.';

  @override
  String get kPdfUnavailable =>
      'PDF રિપોર્ટ અત્યારે ઉપલબ્ધ નથી. કૃપા કરીને પછીથી ફરી પ્રયાસ કરો.';

  @override
  String get kOvEyebrow => 'જન્મ કુંડળી';

  @override
  String kOvMoonChip(String sign) {
    return 'ચંદ્ર · $sign';
  }

  @override
  String get kOvTapHouseHint =>
      'કોઈપણ ઘર તમારા વિશે શું કહે છે તે વાંચવા માટે તેને ટૅપ કરો';

  @override
  String get kOvBirthDetailsSub => 'અવકાહડા, જન્મ સમયે પંચાંગ અને વધુ';

  @override
  String get kOvGroupCharts => 'ચાર્ટ અને ગ્રહો';

  @override
  String get kOvGroupTiming => 'સમય અને સમયગાળો';

  @override
  String get kOvGroupGuidance => 'માર્ગદર્શન અને ઉપાયો';

  @override
  String get kOvLoadError => 'અમે આ કુંડળી ખોલી શક્યા નથી';

  @override
  String get kKitAskTitle => 'તમારા ચાર્ટ વિશે કોઈ પ્રશ્ન છે?';

  @override
  String get kKitAskBody =>
      'એક ચકાસાયેલ જ્યોતિષી તેને તમારી સાથે વાંચી શકે છે — વ્યક્તિગત રીતે, મિનિટોમાં.';

  @override
  String get kFcExploreMore => 'ઊંડા જાઓ';

  @override
  String get kFcAllHousesSub =>
      'તમારા લગના ચાર્ટના તમામ બાર ઘરો, દરેકમાં એક ટૅપ કરો';

  @override
  String get kFcAllChartsSub => 'D1 થી D60 સુધીનો દરેક વિભાગીય ચાર્ટ';

  @override
  String get kPlanetsHeroSub =>
      'નવ ગ્રહો, તેઓ ક્યાં બેસે છે અને કેટલા મજબૂત છે. તેને વાંચવા માટે કોઈપણ ગ્રહને ટેપ કરો.';

  @override
  String kPlanetsStrongCount(int count) {
    return '$count મજબૂત';
  }

  @override
  String kPlanetsRetroCount(int count) {
    return '$count રેટ્રોગ્રેડ';
  }

  @override
  String get kPlanetRetrograde => 'પૂર્વવર્તી';

  @override
  String get kPlanetCombust => 'કમ્બસ્ટ';

  @override
  String get kDashaTimelineTitle => 'તમારી જીવન સમયરેખા';

  @override
  String kDashaProgressPct(String pct) {
    return '$pct % પૂર્ણ';
  }

  @override
  String get kBhavaHeroSub =>
      'બાર ઘરો, જીવનના બાર ક્ષેત્રો - દરેકને શું ટેકો આપે છે અને શું તાણ કરે છે.';

  @override
  String kBhavaSupportedCount(int count) {
    return '$count સપોર્ટેડ';
  }

  @override
  String kBhavaStrainedCount(int count) {
    return '$count તાણ હેઠળ';
  }

  @override
  String get kYdDoshaHeroSub =>
      'તમારા ચાર્ટમાં પરંપરાગત દોષો તપાસવામાં આવ્યા છે, જેમાં દરેક ખરેખર કેટલો મજબૂત છે.';

  @override
  String get kYdYogaHeroSub =>
      'ગ્રહોના સંયોજનો જે તમારી ભેટો અને તકોને આકાર આપે છે.';

  @override
  String kYdDoshaCount(int count) {
    return '$count હાજર';
  }

  @override
  String kYdYogaCount(int count) {
    return '$count યોગાસનો';
  }

  @override
  String get kYdClear => 'સાફ કરો';

  @override
  String get kYdRemediesSub => 'તમારા ચાર્ટને અનુરૂપ સૌમ્ય, પરંપરાગત ઉપાયો';

  @override
  String get kSsLifetimeTitle => 'તમારા જીવનકાળ દરમ્યાન';

  @override
  String get kSsNotRunning => 'અત્યારે નથી ચાલી';

  @override
  String kTrHeroSub(String sign) {
    return 'આજના ગ્રહો તમારા ચંદ્ર પરથી $sign માં વાંચે છે';
  }

  @override
  String kTrJupiterChip(String house) {
    return 'ચંદ્ર પરથી ગુરુ $house';
  }

  @override
  String get kTrSadeSatiCalendarSub =>
      'શનિના ચક્રનો દરેક તબક્કો, ભૂતકાળ અને આગામી';

  @override
  String get kSsEyebrow => 'શનિનું ચક્ર';

  @override
  String get kAdvHeroSub => 'ટેકનિકલ સ્તર જ્યોતિષીઓ પાસેથી વાંચો';

  @override
  String kAdvReportCount(int count) {
    return '$count અહેવાલો';
  }

  @override
  String get kAdvPdfChip => 'પીડીએફ ડાઉનલોડ';

  @override
  String get kAdvReportsTitle => 'તકનીકી અહેવાલો';

  @override
  String get kAdvAvHousesTitle => 'ઘર દ્વારા પોઈન્ટ';

  @override
  String kAdvSarvaTotal(int total) {
    return 'બધામાં $total પોઈન્ટ';
  }

  @override
  String get kInHeroSub =>
      'તમારા જન્મના ચાર્ટમાંથી બનાવેલ પાત્ર અને જીવન સ્કેચ';

  @override
  String kInSupportiveCount(int count) {
    return '$count સહાયક';
  }

  @override
  String kInChallengingCount(int count) {
    return '$count ને કાળજીની જરૂર છે';
  }

  @override
  String get kInGlanceTitle => 'એક નજરમાં';

  @override
  String get kInAreasTitle => 'વિસ્તાર દ્વારા વિસ્તાર';

  @override
  String get kLkHeroSub =>
      'તમારા ચાર્ટમાં વારસાગત દેવું અને તેમના સરળ ઘરગથ્થુ ઉપાયો';

  @override
  String kLkDebtCount(int count) {
    return '$count સક્રિય દેવાં';
  }

  @override
  String kLkWeakCount(int count) {
    return '$count નબળા ગ્રહો';
  }

  @override
  String get kMuHeroSub => 'આજના સારા કલાકો, તમારા ચાર્ટ માટે વાંચો';

  @override
  String get kMuTimingsTitle => 'આજના સમય';

  @override
  String get kMuTabDay => 'દિવસ';

  @override
  String get kMuTabNight => 'રાત્રિ';

  @override
  String kMuHoraOf(String planet) {
    return '$planet હોરા';
  }

  @override
  String get kMuAbhijit => 'અભિજિત મુહૂર્ત';

  @override
  String get kNumHeroSub => 'તમારા મુખ્ય નંબરો અને લો શુ જન્મ ગ્રીડ';

  @override
  String get kNumYourNumbers => 'તમારા નંબરો';

  @override
  String get kNumMissing => 'ખૂટતી સંખ્યાઓ';

  @override
  String get kNumRepeated => 'પુનરાવર્તિત સંખ્યાઓ';

  @override
  String get kRmHeroSub => 'તમારા ચાર્ટ સાથે મેળ ખાતી સૌમ્ય, પરંપરાગત પ્રથાઓ';

  @override
  String kRmCount(int count) {
    return '$count ઉપાયો';
  }

  @override
  String get kRmGatedChip => 'કેટલાકને જ્યોતિષની જરૂર હોય છે';

  @override
  String get kRmCaution => 'ધ્યાનમાં રાખો';

  @override
  String get kUpHeroSub => 'દરેક ગ્રહ માટે રંગો, દિવસો, મંત્રો અને દાન';

  @override
  String kUpStrengthenCount(int count) {
    return '$count મજબૂત કરવા';
  }

  @override
  String kUpPacifyCount(int count) {
    return '$count શાંત કરવા માટે';
  }

  @override
  String get kUpGateTitle => 'પહેલા કોઈ જ્યોતિષ સાથે પુષ્ટિ કરો';

  @override
  String get kUpPlanetsTitle => 'ગ્રહ દ્વારા ગ્રહ';

  @override
  String kVpHeadline(String year) {
    return 'તમારું વર્ષ $year';
  }

  @override
  String get kVpMarkersTitle => 'વર્ષના મુખ્ય માર્કર્સ';

  @override
  String get kVpTajikaTitle => 'તાજિકા પાસા';

  @override
  String get kVpIthasala => 'ઇથશાલા · અરજી કરવી';

  @override
  String get kVpIshrafa => 'ઈશરફા · અલગ થઈ રહ્યું છે';

  @override
  String get followFollow => 'અનુસરો';

  @override
  String get followFollowing => 'અનુસરે છે';

  @override
  String get followNotifying => 'સૂચના આપી રહી છે';

  @override
  String get followNotifyingWhenOnline => 'ઓનલાઈન થવા પર અમે તમને સૂચિત કરીશું';

  @override
  String followedToast(String name) {
    return '__PH_0___ ને અનુસરી રહ્યાં છે — જ્યારે તેઓ ઑનલાઇન અથવા લાઇવ હશે ત્યારે અમે તમને જણાવીશું';
  }

  @override
  String unfollowedToast(String name) {
    return '$name ને અનુસરવાનું બંધ કર્યું';
  }

  @override
  String get followFailed =>
      'ફોલો અપડેટ કરી શકાયું નથી. કૃપા કરીને ફરી પ્રયાસ કરો.';

  @override
  String followPromptTitle(String name) {
    return '$name ને અનુસરો?';
  }

  @override
  String get followPromptBody =>
      'જ્યારે તેઓ ઑનલાઇન હોય અથવા લાઇવ થાય ત્યારે સૂચના મેળવો.';

  @override
  String get followPromptDoneTitle => 'તમે અનુસરી રહ્યાં છો';

  @override
  String followPromptDoneBody(String name) {
    return 'અમે તમને જણાવીશું કે $name ક્યારે ઓનલાઇન અથવા લાઇવ હશે.';
  }

  @override
  String get followingTitle => 'અનુસરે છે';

  @override
  String get followingHint =>
      'જ્યારે આ જ્યોતિષીઓ ઓનલાઈન આવશે અથવા લાઈવ થશે ત્યારે તમને એક સૂચના મળશે. અનફૉલો કરવા માટે હૃદયને ટૅપ કરો.';

  @override
  String get followingEmptyTitle => 'હજુ સુધી કોઈને અનુસરતા નથી';

  @override
  String get followingEmptyBody =>
      'જ્યોતિષીઓને ફૉલો કરો જ્યારે તેઓ ઑનલાઇન હોય અથવા લાઇવ હોય ત્યારે તમે જાણવા માગો છો.';

  @override
  String get followingExplore => 'જ્યોતિષીઓ શોધો';

  @override
  String get followingLoadError =>
      'તમે ફૉલો કરો છો તે જ્યોતિષીઓને લોડ કરી શક્યાં નથી.';

  @override
  String get followingFilter => 'અનુસરે છે';

  @override
  String get followingFilterEmpty =>
      'તેમને અનુસરવા માટે જ્યોતિષી પર હૃદયને ટેપ કરો — તેઓ અહીં દેખાશે.';

  @override
  String get astroStatFollowers => 'અનુયાયીઓ';

  @override
  String get prefsFollowAlerts => 'જ્યોતિષીઓને તમે અનુસરો છો';

  @override
  String get prefsFollowAlertsDesc =>
      'જ્યારે તેઓ ઑનલાઇન આવે છે અથવા લાઇવ જાય છે';

  @override
  String get storeTitle => 'ઉપાય સ્ટોર';

  @override
  String get storeHeroSubtitle =>
      'અધિકૃત રુદ્રાક્ષ, રત્ન, યંત્રો અને પૂજા - જ્યોતિષીઓ દ્વારા માર્ગદર્શન';

  @override
  String get storeSearchHint => 'રુદ્રાક્ષ, રત્ન, પૂજા શોધો…';

  @override
  String get storeVerdictToast => 'એક જ્યોતિષીએ તમારા ઉત્પાદન વિશે સલાહ આપી';

  @override
  String get storeView => 'જુઓ';

  @override
  String get storeUnavailable => 'અનુપલબ્ધ';

  @override
  String storePriceFrom(String price) {
    return '$price થી';
  }

  @override
  String storeOff(int percent) {
    return '$percent % છૂટ';
  }

  @override
  String get storeBadgePooja => 'પૂજા';

  @override
  String get storeBadgeAskAstrologer => 'જ્યોતિષીને પૂછો';

  @override
  String get storeCartTitle => 'કાર્ટ';

  @override
  String get storeTrustCertified => 'લેબ પ્રમાણિત';

  @override
  String get storeTrustGuided => 'જ્યોતિષે માર્ગદર્શન આપ્યું';

  @override
  String get storeTrustSecure => 'સુરક્ષિત ચૂકવણી';

  @override
  String get storeCategories => 'શ્રેણી દ્વારા ખરીદી કરો';

  @override
  String get storeFeatured => 'હાથથી પસંદ કરેલા ઉપાયો';

  @override
  String get storeFeaturedSub => 'અમારા જ્યોતિષીઓ દ્વારા પસંદ કરાયેલ';

  @override
  String get storeCollections => 'ઉપાય સંગ્રહ';

  @override
  String get storePoojas => 'પૂજા બુક કરો';

  @override
  String get storePoojasSub => 'પવિત્ર મંદિરોમાં તમારા નામ પર પ્રદર્શન કર્યું';

  @override
  String get storeConsultBannerTitle => 'ખાતરી નથી કે તમને શું અનુકૂળ છે?';

  @override
  String get storeConsultBannerBody =>
      'તમે ખરીદો તે પહેલાં કોઈ જ્યોતિષીને વિડિયો કૉલ કરો — તેઓ તમારો ચાર્ટ તપાસે છે અને યોગ્ય ઉપાયની ભલામણ કરે છે.';

  @override
  String get storeConsultBannerCta => 'જ્યોતિષ સાથે વાત કરો';

  @override
  String get storeMyAdvice => 'તમારા જ્યોતિષીઓ પાસેથી સલાહ';

  @override
  String get storeDisclaimerFooter =>
      'ઉપાય એ પરંપરાગત પ્રથા છે. પરિણામોની ખાતરી આપવામાં આવતી નથી અને તેઓ તબીબી, કાનૂની અથવા નાણાકીય સલાહને બદલતા નથી.';

  @override
  String get storeEmptyTitle => 'સ્ટોર તૈયાર થઈ રહ્યો છે';

  @override
  String get storeEmptyBody => 'અહીં જલ્દી જ ઉપાયો અને પૂજાઓ દેખાશે.';

  @override
  String get storeLoadError => 'સ્ટોર લોડ કરી શકાયો નથી';

  @override
  String get storeMyOrders => 'મારા ઓર્ડર';

  @override
  String get storeVerdictSuitable => 'યોગ્ય - આગળ વધો';

  @override
  String get storeVerdictNotSuitable => 'તમારા માટે યોગ્ય નથી';

  @override
  String get storeVerdictAlternative => 'બીજું કંઈક સૂચવે છે';

  @override
  String get storeConsultCancelled => 'કૉલ ન થયો';

  @override
  String get storeConsultExpired => 'કોઈ સલાહ શેર કરવામાં આવી ન હતી';

  @override
  String get storeConsultCallLive => 'તમારો કૉલ ચાલુ છે';

  @override
  String get storeConsultAwaiting => 'જ્યોતિષની સલાહની રાહ જોવી';

  @override
  String storeConsultWith(String name) {
    return '$name સાથે';
  }

  @override
  String storeVerdictFrom(String name) {
    return '$name ની સલાહ';
  }

  @override
  String get storeBuyRecommended => 'ભલામણ કરેલ વિકલ્પ ખરીદો';

  @override
  String get storeSuggestedInstead => 'તેના બદલે સૂચવ્યું';

  @override
  String get storeConsultPromptTitle => 'ખાતરી નથી કે તે તમને અનુકૂળ છે?';

  @override
  String get storeConsultPromptBody =>
      'જ્યોતિષીને વીડિયો કૉલ કરો — તમે ખરીદો તે પહેલાં તેઓ તમારો ચાર્ટ તપાસશે.';

  @override
  String get storeConsultRequiredTitle => 'પહેલા જ્યોતિષની સલાહ લો';

  @override
  String get storeConsultRequiredBody =>
      'કોઈ જ્યોતિષી પુષ્ટિ કરે કે તે તમારા ચાર્ટને અનુરૂપ છે તે પછી જ આ ઉપાય વેચવામાં આવે છે.';

  @override
  String get storeNoResults => 'કંઈ મેળ ખાતું નથી';

  @override
  String get storeNoResultsBody =>
      'બીજો શબ્દ અજમાવો અથવા કેટલાક ફિલ્ટર્સ સાફ કરો.';

  @override
  String get storeClearFilters => 'ફિલ્ટર્સ સાફ કરો';

  @override
  String storeResultCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count આઇટમ્સ',
      one: '1 આઇટમ',
    );
    return '$_temp0';
  }

  @override
  String get storeFilters => 'ફિલ્ટર્સ';

  @override
  String get storeNoFilters => 'આ પસંદગી માટે હજુ સુધી કોઈ ફિલ્ટર્સ નથી.';

  @override
  String get storeSortBy => 'દ્વારા સૉર્ટ કરો';

  @override
  String get storeSortRecommended => 'ભલામણ કરેલ';

  @override
  String get storeSortPopular => 'સૌથી વધુ લોકપ્રિય';

  @override
  String get storeSortNew => 'નવીનતમ';

  @override
  String get storeSortRating => 'ટોચના રેટેડ';

  @override
  String get storeKindProducts => 'ઉત્પાદનો';

  @override
  String get storeKindPoojas => 'પૂજા';

  @override
  String get storeKindDigital => 'અહેવાલો';

  @override
  String storeRemedyFor(String key) {
    return 'ઉપાય: $key';
  }

  @override
  String get storeChoosePackage => 'એક પેકેજ પસંદ કરો';

  @override
  String get storeChooseOption => 'એક વિકલ્પ પસંદ કરો';

  @override
  String get storePickDate => 'તારીખ ચૂંટો';

  @override
  String get storeSankalpDetails => 'સંકલ્પ વિગતો';

  @override
  String get storeYourDetails => 'તમારી વિગતો';

  @override
  String get storeSankalpHint => 'પૂજા દરમિયાન પૂજારી આ નામોનો સંકલ્પ લે છે.';

  @override
  String get storeCertificate => 'અધિકૃતતા પ્રમાણપત્ર';

  @override
  String storeCertificateNo(String number) {
    return 'પ્રમાણપત્ર નં.  $number';
  }

  @override
  String get storeVerify => 'ચકાસો';

  @override
  String get storeHighlights => 'હાઇલાઇટ્સ';

  @override
  String get storeAbout => 'વિશે';

  @override
  String get storeSignificance => 'પરંપરાગત મહત્વ';

  @override
  String get storeHowToUse => 'કેવી રીતે પહેરવું/ઉપયોગ કરવો';

  @override
  String get storeHowItWorks => 'તે કેવી રીતે કામ કરે છે';

  @override
  String get storeReadMore => 'વધુ વાંચો';

  @override
  String get storeReadLess => 'ઓછું બતાવો';

  @override
  String get storeRecommendedForYou => 'તમારા માટે ભલામણ કરેલ';

  @override
  String get storeTaxInclusive => 'તમામ કર સહિત';

  @override
  String get storeOutOfStock => 'સ્ટોક નથી';

  @override
  String storeOnlyLeft(int count) {
    return 'માત્ર $count બાકી';
  }

  @override
  String get storeAskAnother => 'બીજા જ્યોતિષીને પૂછો';

  @override
  String get storeNoDates => 'તારીખો ટૂંક સમયમાં જાહેર કરવામાં આવશે.';

  @override
  String get storeOpenForBooking => 'બુકિંગ માટે ખોલો';

  @override
  String storeSeatsLeft(int count) {
    return '$count સ્લોટ બાકી';
  }

  @override
  String storeReturnableDays(int days) {
    return 'ડિલિવરીના $days દિવસમાં સરળ વળતર';
  }

  @override
  String get storeNotReturnable =>
      'એકવાર વિતરિત કરવામાં આવે તે પરત કરી શકાતું નથી';

  @override
  String get storeCancellable => 'તે મોકલવામાં આવે તે પહેલાં મફત રદ કરો';

  @override
  String get storeNotCancellable => 'એકવાર ઓર્ડર કર્યા પછી રદ કરી શકાતો નથી';

  @override
  String storeMadeToOrder(int days) {
    return 'ઓર્ડર કરવા માટે બનાવેલ · લગભગ $days દિવસમાં તૈયાર';
  }

  @override
  String get storeShipsIndia => 'સમગ્ર ભારતમાં વીમાકૃત શિપિંગ';

  @override
  String get storeVideoProof => 'પૂજાનો વીડિયો તમારી સાથે શેર કર્યો છે';

  @override
  String get storeInstantDownload => 'ચુકવણી પછી તરત જ ડાઉનલોડ કરો';

  @override
  String storeSoldBy(String name) {
    return '$name દ્વારા વેચાયેલ';
  }

  @override
  String get storeSellerInfo => 'વિક્રેતા અને ફરિયાદ વિગતો';

  @override
  String storeCountryOfOrigin(String country) {
    return 'મૂળ દેશ: $country';
  }

  @override
  String get storeGrievanceOfficer => 'ફરિયાદ અધિકારી';

  @override
  String storeFieldRequired(String label) {
    return '$label જરૂરી છે';
  }

  @override
  String storeFieldParticipants(String label, int count) {
    return '$count $label દાખલ કરો';
  }

  @override
  String get storePickDateError => 'પૂજા માટે તારીખ પસંદ કરો';

  @override
  String get storeAddedToCart => 'કાર્ટમાં ઉમેર્યું';

  @override
  String get storeViewCart => 'કાર્ટ જુઓ';

  @override
  String get storeFixDetails => 'કૃપા કરીને પ્રકાશિત વિગતો તપાસો';

  @override
  String get storeAddToCart => 'કાર્ટમાં ઉમેરો';

  @override
  String get storeBuyNow => 'હવે ખરીદો';

  @override
  String get storeBookPooja => 'બુક પૂજા';

  @override
  String get storeConsultFirst => 'પહેલા સલાહ લો';

  @override
  String storePersonN(int n) {
    return 'વ્યક્તિ $n';
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
}
