import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/config/config_repository.dart';
import '../../../../core/config/remote_config.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/astro_palette.dart';
import '../../../../core/theme/brand_colors.dart';
import '../../../../core/util/money.dart';
import '../../../../shared/widgets/app_bottom_sheet.dart';
import '../../../../shared/widgets/cosmic.dart';
import '../../../../shared/widgets/pressable.dart';
import '../../../auth/data/models/auth_user.dart';
import '../../../auth/presentation/bloc/auth/auth_bloc.dart';
import '../../../birthprofiles/presentation/bloc/birth_profiles_cubit.dart';
import '../../../consultations/presentation/cubit/chats_list_cubit.dart';
import '../../../home/presentation/view/widgets/home_shared.dart' show PullUp;
import '../../../wallet/presentation/cubit/wallet_cubit.dart';
import '../../data/profile_api.dart';

/// How far the stats card tucks up into the header.
const double _kStatsOverlap = 34;

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    final user = context.select((AuthBloc b) => b.state.user);
    final config = getIt<ConfigRepository>().value;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: brand.canvas,
        body: CustomScrollView(
          slivers: [
            // Status-bar scrim so content scrolling under it stays legible.
            SliverAppBar(
              pinned: true,
              toolbarHeight: 0,
              automaticallyImplyLeading: false,
              backgroundColor: brand.cosmicStart,
              surfaceTintColor: Colors.transparent,
              elevation: 0,
              scrolledUnderElevation: 0,
              systemOverlayStyle: SystemUiOverlayStyle.light,
            ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  _Header(user: user),
                  if (user != null)
                    PullUp(
                      by: _kStatsOverlap,
                      child: _StatsCard(currency: user.preferredCurrency),
                    )
                  else
                    const SizedBox(height: 16),
                ],
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
              sliver: SliverList.list(
                children: [
                  _CompletenessHint(user: user),
                  _Group(l.profileGroupAccount, [
                    _MenuRow(
                      icon: Icons.person_outline_rounded,
                      hue: AstroPalette.career,
                      label: l.profileEditProfile,
                      onTap: () => context.push(Routes.editProfile),
                    ),
                    _MenuRow(
                      icon: Icons.notifications_none_rounded,
                      hue: AstroPalette.money,
                      label: l.profileNotificationPrefs,
                      onTap: () => context.push(Routes.notificationPrefs),
                    ),
                    _MenuRow(
                      icon: Icons.favorite_border_rounded,
                      hue: AstroPalette.love,
                      label: l.followingTitle,
                      onTap: () => context.push(Routes.following),
                    ),
                  ]),
                  _Group(l.profileGroupMoney, [
                    _MenuRow(
                      icon: Icons.account_balance_wallet_outlined,
                      hue: AstroPalette.health,
                      label: l.profileWalletAndTransactions,
                      onTap: () => context.push(Routes.wallet),
                    ),
                    if (config.features.store) ...[
                      _MenuRow(
                        icon: Icons.shopping_bag_outlined,
                        hue: AstroPalette.money,
                        label: l.storeProfileOrders,
                        onTap: () => context.push(Routes.storeOrders),
                      ),
                      _MenuRow(
                        icon: Icons.forum_outlined,
                        hue: AstroPalette.career,
                        label: l.storeAdviceTitle,
                        onTap: () => context.push(Routes.storeConsults),
                      ),
                      _MenuRow(
                        icon: Icons.location_on_outlined,
                        hue: AstroPalette.earth,
                        label: l.storeAddressesTitle,
                        onTap: () => context.push(Routes.storeAddresses),
                      ),
                    ],
                    if (config.features.referrals)
                      _MenuRow(
                        icon: Icons.card_giftcard_rounded,
                        hue: AstroPalette.love,
                        label: l.profileReferAndEarn,
                        onTap: () => context.push(Routes.referrals),
                      ),
                  ]),
                  _Group(l.profileGroupPreferences, [
                    _MenuRow(
                      icon: Icons.translate_rounded,
                      hue: AstroPalette.air,
                      label: l.profileLanguage,
                      value: _languageName(config, user?.preferredLanguage),
                      onTap: () => _pickLanguage(
                        context,
                        config,
                        user?.preferredLanguage,
                      ),
                    ),
                    _MenuRow(
                      icon: Icons.payments_outlined,
                      hue: AstroPalette.earth,
                      label: l.profileCurrency,
                      value: user?.preferredCurrency ?? 'INR',
                      onTap: () => _pickCurrency(
                        context,
                        config,
                        user?.preferredCurrency,
                      ),
                    ),
                  ]),
                  _Group(l.profileGroupSupport, [
                    _MenuRow(
                      icon: Icons.support_agent_rounded,
                      hue: AstroPalette.water,
                      label: l.helpTitle,
                      onTap: () => context.push(Routes.help),
                    ),
                    if (config.support.whatsapp.isNotEmpty)
                      _MenuRow(
                        icon: Icons.chat_outlined,
                        hue: AstroPalette.health,
                        label: l.profileContactWhatsapp,
                        onTap: () => _open(
                          'https://wa.me/${config.support.whatsapp.replaceAll(RegExp(r'[^0-9]'), '')}',
                        ),
                      ),
                    _MenuRow(
                      icon: Icons.star_border_rounded,
                      hue: AstroPalette.money,
                      label: l.profileRateApp,
                      onTap: _rateApp,
                    ),
                    _MenuRow(
                      icon: Icons.ios_share_rounded,
                      hue: AstroPalette.career,
                      label: l.profileShareApp,
                      onTap: () => _shareApp(context),
                    ),
                  ]),
                  _Group(l.profileGroupLegal, [
                    if (config.support.termsUrl.isNotEmpty)
                      _MenuRow(
                        icon: Icons.description_outlined,
                        label: l.profileTerms,
                        onTap: () => _open(config.support.termsUrl),
                      ),
                    if (config.support.privacyUrl.isNotEmpty)
                      _MenuRow(
                        icon: Icons.privacy_tip_outlined,
                        label: l.profilePrivacy,
                        onTap: () => _open(config.support.privacyUrl),
                      ),
                    _MenuRow(
                      icon: Icons.article_outlined,
                      label: l.profileLicenses,
                      onTap: () => showLicensePage(context: context),
                    ),
                  ]),
                  _Group(null, [
                    _MenuRow(
                      icon: Icons.logout_rounded,
                      label: l.authLogout,
                      onTap: () => _confirmLogout(context),
                      isDanger: true,
                      showChevron: false,
                    ),
                    _MenuRow(
                      icon: Icons.delete_outline_rounded,
                      label: l.profileDeleteAccount,
                      onTap: () => context.push(Routes.deleteAccount),
                      isDanger: true,
                      showChevron: false,
                    ),
                  ]),
                  const SizedBox(height: 20),
                  const _AppVersion(),
                  const SizedBox(height: 140),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- preferences ---------------------------------------------------------

  static String _languageName(RemoteConfig config, String? code) {
    final c = code ?? 'en';
    if (kLanguageNativeNames.containsKey(c)) return kLanguageNativeNames[c]!;
    for (final lang in config.languages) {
      if (lang.code == c) return lang.name;
    }
    return 'English';
  }

  Future<void> _pickLanguage(
    BuildContext context,
    RemoteConfig config,
    String? current,
  ) async {
    final l = context.l10n;
    final codes = config.languages.isNotEmpty
        ? config.languages.map((e) => e.code).toList()
        : kSupportedLocales.map((e) => e.languageCode).toList();
    final picked = await showAppSheet<String>(
      context: context,
      title: l.chooseLanguage,
      builder: (context) => ListView(
        shrinkWrap: true,
        children: [
          for (final code in codes)
            _ChoiceTile(
              label: kLanguageNativeNames[code] ?? code,
              sublabel: kLanguageEnglishNames[code],
              selected: code == (current ?? 'en'),
              onTap: () => Navigator.pop(context, code),
            ),
        ],
      ),
    );
    if (picked != null && picked != current && context.mounted) {
      await _save(context, language: picked);
    }
  }

  Future<void> _pickCurrency(
    BuildContext context,
    RemoteConfig config,
    String? current,
  ) async {
    final l = context.l10n;
    final picked = await showAppSheet<String>(
      context: context,
      title: l.chooseCurrency,
      builder: (context) => ListView(
        shrinkWrap: true,
        children: [
          for (final c in config.currencies)
            _ChoiceTile(
              label: '${Money.symbol(c)}  $c',
              selected: c == (current ?? 'INR'),
              onTap: () => Navigator.pop(context, c),
            ),
        ],
      ),
    );
    if (picked != null && picked != current && context.mounted) {
      await _save(context, currency: picked);
    }
  }

  Future<void> _save(
    BuildContext context, {
    String? language,
    String? currency,
  }) async {
    final messenger = ScaffoldMessenger.of(context);
    final authBloc = context.read<AuthBloc>();
    final l = context.l10n;
    try {
      final user = await getIt<ProfileApi>().updatePreferences(
        language: language,
        currency: currency,
      );
      authBloc.add(AuthLoggedIn(user));
      if (currency != null) await getIt<WalletCubit>().refresh();
    } catch (_) {
      messenger.showSnackBar(SnackBar(content: Text(l.editProfileSaveError)));
    }
  }

  // --- support ------------------------------------------------------------

  Future<void> _open(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<void> _rateApp() async {
    const pkg = 'com.talkacharya.customer';
    if (!await launchUrl(
      Uri.parse('market://details?id=$pkg'),
      mode: LaunchMode.externalApplication,
    )) {
      await launchUrl(
        Uri.parse('https://play.google.com/store/apps/details?id=$pkg'),
        mode: LaunchMode.externalApplication,
      );
    }
  }

  Future<void> _shareApp(BuildContext context) async {
    const link =
        'https://play.google.com/store/apps/details?id=com.talkacharya.customer';
    await Share.share(context.l10n.profileShareMessage(link));
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final l = context.l10n;
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l.authLogout),
        content: Text(l.authLogoutConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l.authLogout),
          ),
        ],
      ),
    );
    if ((ok ?? false) && context.mounted) {
      context.read<AuthBloc>().add(const AuthLogoutRequested());
    }
  }
}

// --- header -------------------------------------------------------------------------

/// Cosmic header with a clean identity row: avatar, name, masked phone, edit.
class _Header extends StatelessWidget {
  const _Header({required this.user});

  final AuthUser? user;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final avatar = user?.avatar;
    final phone = user?.phone ?? '';
    final last4 = phone.length >= 4 ? phone.substring(phone.length - 4) : phone;
    final name = (user?.shortName.isNotEmpty ?? false) ? user!.shortName : '—';

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
      child: Stack(
        children: [
          const Positioned.fill(child: CosmicBackdrop()),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, _kStatsOverlap + 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.profileTitle,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(2.5),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: SweepGradient(
                          colors: [
                            Color(0xFFFFB02E),
                            Color(0xFFFF5C8A),
                            Color(0xFF7B3FE4),
                            Color(0xFF5EC8FF),
                            Color(0xFFFFB02E),
                          ],
                        ),
                      ),
                      child: Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AstroPalette.career.end,
                          border: Border.all(
                            color: context.brand.cosmicStart,
                            width: 2,
                          ),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: (avatar != null && avatar.isNotEmpty)
                            ? Image.network(
                                avatar,
                                fit: BoxFit.cover,
                                errorBuilder: (_, _, _) => _initial(name),
                              )
                            : _initial(name),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              height: 1.15,
                            ),
                          ),
                          if (last4.isNotEmpty) ...[
                            const SizedBox(height: 3),
                            Text(
                              l.profilePhoneMasked(last4),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.white.withValues(alpha: 0.7),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton.icon(
                      onPressed: () => context.push(Routes.editProfile),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.white.withValues(alpha: 0.08),
                        side: BorderSide(
                          color: Colors.white.withValues(alpha: 0.35),
                        ),
                        minimumSize: const Size(0, 34),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        visualDensity: VisualDensity.compact,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      icon: const Icon(Icons.edit_outlined, size: 15),
                      label: Text(l.commonEdit),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _initial(String name) => Center(
    child: Text(
      name == '—' || name.isEmpty ? '?' : name.characters.first.toUpperCase(),
      style: const TextStyle(
        color: Colors.white,
        fontSize: 24,
        fontWeight: FontWeight.w800,
      ),
    ),
  );
}

/// Three compact stats in one surface card: wallet, charts, orders.
class _StatsCard extends StatelessWidget {
  const _StatsCard({required this.currency});

  final String currency;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final brand = context.brand;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final balance = context.select(
      (WalletCubit c) => c.state.primaryFor(currency)?.spendable,
    );
    final bpCount = context.select(
      (BirthProfilesCubit c) => c.state.profiles.length,
    );
    final unread = context.select((ChatsListCubit c) => c.state.totalUnread);

    Widget divider() => Container(width: 1, height: 36, color: brand.hairline);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: brand.hairline),
          boxShadow: [
            BoxShadow(
              color: brand.cosmicStart.withValues(alpha: 0.12),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: _Stat(
                icon: Icons.account_balance_wallet_rounded,
                hue: AstroPalette.health,
                value: balance == null
                    ? '—'
                    : Money.format(balance, currency, locale: locale),
                label: l.profileWallet,
                onTap: () => context.push(Routes.wallet),
              ),
            ),
            divider(),
            Expanded(
              child: _Stat(
                icon: Icons.auto_graph_rounded,
                hue: AstroPalette.career,
                value: '$bpCount',
                label: l.profileBirthProfiles,
                onTap: () => context.push(Routes.birthProfiles),
              ),
            ),
            divider(),
            Expanded(
              child: _Stat(
                icon: Icons.forum_rounded,
                hue: AstroPalette.love,
                value: unread > 0
                    ? l.profileOrdersUnread(unread)
                    : l.commonViewAll,
                label: l.profileOrders,
                badge: unread > 0,
                onTap: () => context.push(Routes.chats),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({
    required this.icon,
    required this.hue,
    required this.value,
    required this.label,
    required this.onTap,
    this.badge = false,
  });

  final IconData icon;
  final AstroHue hue;
  final String value;
  final String label;
  final VoidCallback onTap;
  final bool badge;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brand = context.brand;
    return Pressable(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
          child: Column(
            children: [
              Badge(
                isLabelVisible: badge,
                smallSize: 8,
                backgroundColor: brand.live,
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: hue.tint(0.13),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, size: 18, color: hue.end),
                ),
              ),
              const SizedBox(height: 7),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: brand.inkMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CompletenessHint extends StatelessWidget {
  const _CompletenessHint({required this.user});

  final AuthUser? user;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final email = user?.email ?? '';
    final bpCount = context.select(
      (BirthProfilesCubit c) => c.state.profiles.length,
    );

    String? message;
    VoidCallback? onTap;
    if (email.isEmpty) {
      message = l.profileCompleteAddEmail;
      onTap = () => context.push(Routes.editProfile);
    } else if (bpCount == 0) {
      message = l.profileCompleteAddBirth;
      onTap = () => context.push(Routes.birthProfileNew);
    }
    if (message == null) return const SizedBox.shrink();

    const hue = AstroPalette.money;
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Material(
        color: hue.tint(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: hue.tint(0.3)),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 8, 10),
            child: Row(
              children: [
                Icon(Icons.auto_awesome_rounded, size: 18, color: hue.end),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    message,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Icon(Icons.chevron_right_rounded, size: 20, color: hue.end),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// --- menu ---------------------------------------------------------------------------

class _Group extends StatelessWidget {
  const _Group(this.title, this.rows);

  final String? title;
  final List<Widget> rows;

  @override
  Widget build(BuildContext context) {
    if (rows.isEmpty) return const SizedBox.shrink();
    final theme = Theme.of(context);
    final brand = context.brand;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(4, title == null ? 18 : 20, 4, 8),
          child: title == null
              ? null
              : Text(
                  title!.toUpperCase(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: brand.inkMuted,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.1,
                  ),
                ),
        ),
        Material(
          color: theme.colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: brand.hairline),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              for (var i = 0; i < rows.length; i++) ...[
                if (i > 0)
                  Divider(height: 1, indent: 60, color: brand.hairline),
                rows[i],
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _MenuRow extends StatelessWidget {
  const _MenuRow({
    required this.icon,
    required this.label,
    required this.onTap,
    this.hue,
    this.value,
    this.isDanger = false,
    this.showChevron = true,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  /// Icon colour family; null = neutral grey (legal / low-emphasis rows).
  final AstroHue? hue;
  final String? value;
  final bool isDanger;
  final bool showChevron;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brand = context.brand;
    final iconColor = isDanger
        ? theme.colorScheme.error
        : hue?.end ?? brand.inkMuted;
    final iconBg = isDanger
        ? theme.colorScheme.error.withValues(alpha: 0.08)
        : hue?.tint(0.12) ?? brand.hairline.withValues(alpha: 0.6);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 10, 10),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 18, color: iconColor),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isDanger ? theme.colorScheme.error : null,
                ),
              ),
            ),
            if (value != null) ...[
              const SizedBox(width: 8),
              Text(
                value!,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: brand.inkMuted,
                ),
              ),
            ],
            if (showChevron) ...[
              const SizedBox(width: 2),
              Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: brand.inkMuted.withValues(alpha: 0.7),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ChoiceTile extends StatelessWidget {
  const _ChoiceTile({
    required this.label,
    required this.selected,
    required this.onTap,
    this.sublabel,
  });

  final String label;
  final String? sublabel;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ListTile(
      title: Text(label),
      subtitle: sublabel != null ? Text(sublabel!) : null,
      trailing: selected
          ? Icon(Icons.check_rounded, color: scheme.primary)
          : null,
      selected: selected,
      onTap: onTap,
    );
  }
}

class _AppVersion extends StatelessWidget {
  const _AppVersion();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (context, snap) {
        final v = snap.data;
        if (v == null) return const SizedBox(height: 16);
        return Center(
          child: Text(
            context.l10n.profileVersion(v.version, v.buildNumber),
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(color: context.brand.inkMuted),
          ),
        );
      },
    );
  }
}
