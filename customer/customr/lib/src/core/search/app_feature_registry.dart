import 'package:flutter/material.dart';

import '../l10n/l10n.dart';
import '../router/routes.dart';

/// Represents an in-app feature or setting shortcut for global search.
class AppFeatureItem {
  const AppFeatureItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.route,
    required this.icon,
    required this.keywords,
  });

  final String id;
  final String title;
  final String subtitle;
  final String route;
  final IconData icon;
  final List<String> keywords;

  bool matches(String term) {
    if (term.trim().isEmpty) return false;
    final q = term.trim().toLowerCase();
    if (title.toLowerCase().contains(q)) return true;
    if (subtitle.toLowerCase().contains(q)) return true;
    return keywords.any((k) => k.toLowerCase().contains(q));
  }
}

/// Registry of all searchable app features, settings, and pages.
class AppFeatureRegistry {
  const AppFeatureRegistry._();

  static List<AppFeatureItem> getFeatures(BuildContext context) {
    final l = context.l10n;
    return [
      AppFeatureItem(
        id: 'astrologers',
        title: l.navAstrologers,
        subtitle: l.homeGuidanceTagline,
        route: Routes.astrologers,
        icon: Icons.groups_rounded,
        keywords: ['astrologer', 'chat', 'call', 'video', 'talk', 'consult', 'expert', 'jyotishi', 'guru'],
      ),
      AppFeatureItem(
        id: 'matchmaking',
        title: l.matchTitle,
        subtitle: l.matchHeroBody,
        route: Routes.matchmaking,
        icon: Icons.favorite_rounded,
        keywords: ['matchmaking', 'guna', 'milan', 'marriage', 'shadi', 'compatibility', 'kundali milan', 'manglik'],
      ),
      AppFeatureItem(
        id: 'horoscope',
        title: l.homeHoroscopeAction,
        subtitle: l.horoWhyTitle,
        route: Routes.horoscope,
        icon: Icons.stars_rounded,
        keywords: ['horoscope', 'rashifal', 'rashi', 'today', 'daily', 'weekly', 'sun sign', 'moon sign'],
      ),
      AppFeatureItem(
        id: 'panchang',
        title: l.panchangTitle,
        subtitle: l.panchangLimbs,
        route: Routes.panchang,
        icon: Icons.calendar_today_rounded,
        keywords: ['panchang', 'choghadiya', 'muhurta', 'rahu kaal', 'tithi', 'nakshatra', 'today panchang'],
      ),
      AppFeatureItem(
        id: 'wallet',
        title: l.walletAutoRechargeTitle,
        subtitle: l.walletHeldExplainerTitle,
        route: Routes.wallet,
        icon: Icons.account_balance_wallet_rounded,
        keywords: ['wallet', 'balance', 'recharge', 'money', 'add money', 'payment', 'cash', 'offers'],
      ),
      AppFeatureItem(
        id: 'store',
        title: l.storeTitle,
        subtitle: l.storeHeroSubtitle,
        route: Routes.store,
        icon: Icons.storefront_rounded,
        keywords: ['store', 'remedy', 'rudraksha', 'gemstone', 'pooja', 'yantra', 'crystal', 'buying'],
      ),
      AppFeatureItem(
        id: 'orders',
        title: l.storeMyOrders,
        subtitle: l.storeProfileOrdersSub,
        route: '${Routes.store}/orders',
        icon: Icons.shopping_bag_rounded,
        keywords: ['orders', 'my orders', 'pooja booking', 'purchases', 'tracking', 'history'],
      ),
      AppFeatureItem(
        id: 'support',
        title: l.helpTitle,
        subtitle: l.helpHeroTitle,
        route: Routes.help,
        icon: Icons.help_outline_rounded,
        keywords: ['help', 'support', 'report', 'issue', 'refund', 'contact', 'customer care', 'faq'],
      ),
      AppFeatureItem(
        id: 'articles',
        title: l.articlesTitle,
        subtitle: l.articlesRailSubtitle,
        route: Routes.articles,
        icon: Icons.menu_book_rounded,
        keywords: ['articles', 'read', 'learn', 'blogs', 'guide', 'remedies', 'sade sati', 'festivals'],
      ),
      const AppFeatureItem(
        id: 'prashna',
        title: 'Prashna Kundali (Horary)',
        subtitle: 'Instant answer to your immediate question',
        route: '/prashna',
        icon: Icons.question_answer_rounded,
        keywords: ['prashna', 'horary', 'question', 'instant', 'reading'],
      ),
      const AppFeatureItem(
        id: 'predictions',
        title: 'Detailed Written Predictions',
        subtitle: 'Personalized life & career report from astrologers',
        route: '/predictions',
        icon: Icons.psychology_rounded,
        keywords: ['predictions', 'report', 'career', 'life report', 'written'],
      ),
      const AppFeatureItem(
        id: 'referrals',
        title: 'Refer & Earn',
        subtitle: 'Invite friends and earn bonus wallet cash',
        route: Routes.referrals,
        icon: Icons.card_giftcard_rounded,
        keywords: ['refer', 'earn', 'referral', 'invite', 'bonus', 'free cash'],
      ),
    ];
  }
}
