import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/astro/models/astro_profile.dart';
import '../../../../core/astro/onboarding_store.dart';
import '../../../../core/config/config_repository.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/routes.dart';
import '../../../../shared/widgets/language_quick_button.dart';
import '../../../../shared/widgets/report_height.dart';
import '../../../../shared/widgets/settings_widgets.dart';
import '../../../auth/presentation/bloc/auth/auth_bloc.dart';
import '../../../home/presentation/view/widgets/profile_strength_card.dart';
import '../../../notifications/presentation/view/notification_bell.dart';
import '../../data/profile_api.dart';
import '../widgets/verification_badge.dart';

import 'package:talkacharya_ui/talkacharya_ui.dart';

/// Profile tab: identity hero (photo, name, verification, stats), profile
/// strength, and grouped settings.
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _store = getIt<OnboardingStore>();

  // The header's expanded height, as it last measured itself.
  double _headerBody = _ProfileHeaderDelegate.initialBodyHeight;

  @override
  void initState() {
    super.initState();
    _store.refresh();
  }

  Future<void> _changeLanguage() async {
    final l = context.l10n;
    final current = context.read<AuthBloc>().state.user?.preferredLanguage;
    final picked = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: RadioGroup<String>(
          groupValue: current,
          onChanged: (v) => Navigator.pop(context, v),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    l.profileLanguage,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ),
              for (final MapEntry(key: code, value: name)
                  in kLanguageNativeNames.entries)
                RadioListTile<String>(value: code, title: Text(name)),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
    if (picked == null || picked == current || !mounted) return;
    final bloc = context.read<AuthBloc>();
    try {
      final user = await getIt<ProfileApi>().updateAccount(language: picked);
      bloc.add(AuthUserUpdated(user));
    } catch (_) {
      if (mounted) showToast(context, l.commonSaveFailed);
    }
  }

  Future<void> _logout() async {
    final l = context.l10n;
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l.profileLogoutTitle),
        content: Text(l.profileLogoutBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l.commonCancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: context.brand.live,
              minimumSize: const Size(0, 44),
            ),
            onPressed: () => Navigator.pop(context, true),
            child: Text(l.profileLogout),
          ),
        ],
      ),
    );
    if ((ok ?? false) && mounted) {
      context.read<AuthBloc>().add(const AuthLogoutRequested());
    }
  }

  void _open(String url) {
    if (url.isEmpty) return;
    launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final user = context.select((AuthBloc b) => b.state.user);
    final support = getIt<ConfigRepository>().value.support;
    return Scaffold(
      body: RefreshIndicator(
        edgeOffset: 120,
        onRefresh: _store.refresh,
        child: ListenableBuilder(
          listenable: _store,
          builder: (context, _) {
            final p = _store.profile;
            return CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                // Pinned: it folds into a bar (photo, name, rating, bell) as
                // the page scrolls, the way Home's header does.
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _ProfileHeaderDelegate(
                    profile: p,
                    topPad: MediaQuery.paddingOf(context).top,
                    bodyHeight: _headerBody,
                    onBodyMeasured: (h) {
                      if (mounted && (h - _headerBody).abs() > 0.5) {
                        setState(() => _headerBody = h);
                      }
                    },
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 18)),
                const SliverToBoxAdapter(child: ProfileStrengthCard()),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  sliver: SliverList.list(
                    children: [
                      MenuGroup(
                        label: l.profileGroupPractice,
                        rows: [
                          MenuRow(
                            icon: Icons.visibility_rounded,
                            hue: AstroPalette.water,
                            title: l.pubTitle,
                            subtitle: l.pubMenuSub,
                            onTap: () => context.push(Routes.profilePublic),
                          ),
                          MenuRow(
                            icon: Icons.edit_rounded,
                            title: l.profileEdit,
                            subtitle: l.profileEditSub,
                            onTap: () => context.push(Routes.profileEdit),
                          ),
                          MenuRow(
                            icon: Icons.currency_rupee_rounded,
                            hue: AstroPalette.money,
                            title: l.profileRates,
                            subtitle: l.profileRatesSub,
                            value: _rateRange(p),
                            onTap: () => context.push(Routes.profileRates),
                          ),
                          MenuRow(
                            icon: Icons.schedule_rounded,
                            hue: AstroPalette.air,
                            title: l.profileHours,
                            subtitle: l.profileHoursSub,
                            onTap: () =>
                                context.push(Routes.profileWorkingHours),
                          ),
                          MenuRow(
                            icon: Icons.reviews_rounded,
                            hue: AstroPalette.fire,
                            title: l.dashActionReviews,
                            subtitle: p == null
                                ? null
                                : l.dashStatRatingSub(p.ratingCount),
                            value: (p?.ratingCount ?? 0) > 0
                                ? '${p!.ratingAvg.toStringAsFixed(1)} ★'
                                : null,
                            onTap: () => context.push(Routes.profileReviews),
                          ),
                        ],
                      ),
                      MenuGroup(
                        label: l.profileGroupGrowth,
                        rows: [
                          MenuRow(
                            icon: Icons.phone_locked_rounded,
                            hue: AstroPalette.fire,
                            title: l.callSetupTitle,
                            subtitle: l.callSetupMenuSub,
                            onTap: () => context.push(Routes.callSetup),
                          ),
                          MenuRow(
                            icon: Icons.volume_up_rounded,
                            hue: AstroPalette.love,
                            title: l.profileSoundVibration,
                            subtitle: l.profileSoundVibrationSub,
                            onTap: () => context.push(Routes.profileSound),
                          ),
                          MenuRow(
                            icon: Icons.videocam_rounded,
                            hue: AstroPalette.love,
                            title: l.dashActionGoLive,
                            subtitle: l.profileGoLiveSub,
                            onTap: () => context.push(Routes.goLive),
                          ),
                          MenuRow(
                            icon: Icons.insights_rounded,
                            hue: AstroPalette.water,
                            title: l.dashActionPredictions,
                            subtitle: l.profilePredictionsSub,
                            onTap: () => context.push(Routes.predictions),
                          ),
                          MenuRow(
                            icon: Icons.workspace_premium_rounded,
                            hue: AstroPalette.money,
                            title: l.profileFeatured,
                            subtitle: l.profileFeaturedSub,
                            onTap: () => context.push(Routes.profileFeatured),
                          ),
                        ],
                      ),
                      MenuGroup(
                        label: l.profileGroupAccount,
                        rows: [
                          MenuRow(
                            icon: Icons.verified_user_rounded,
                            hue: AstroPalette.health,
                            title: l.profileKyc,
                            subtitle: l.profileKycSub,
                            value: p == null
                                ? null
                                : verificationLabel(l, p.verificationLevel),
                            onTap: () => context.push(Routes.profileKyc),
                          ),
                          MenuRow(
                            icon: Icons.notifications_rounded,
                            hue: AstroPalette.career,
                            title: l.commonNotifications,
                            onTap: () => context.push(Routes.notifications),
                          ),
                          MenuRow(
                            icon: Icons.translate_rounded,
                            hue: AstroPalette.air,
                            title: l.profileLanguage,
                            value:
                                kLanguageNativeNames[user?.preferredLanguage] ??
                                kLanguageNativeNames['en'],
                            onTap: _changeLanguage,
                          ),
                        ],
                      ),
                      MenuGroup(
                        label: l.profileGroupSupport,
                        rows: [
                          MenuRow(
                            icon: Icons.flag_rounded,
                            hue: AstroPalette.fire,
                            title: l.reportsTitle,
                            subtitle: l.reportsMenuSub,
                            onTap: () => context.push(Routes.reports),
                          ),
                          if (support.helpUrl.isNotEmpty)
                            MenuRow(
                              icon: Icons.help_rounded,
                              hue: AstroPalette.career,
                              title: l.profileHelp,
                              onTap: () => _open(support.helpUrl),
                            ),
                          if (support.email.isNotEmpty ||
                              support.whatsapp.isNotEmpty)
                            MenuRow(
                              icon: Icons.support_agent_rounded,
                              hue: AstroPalette.health,
                              title: l.profileContact,
                              subtitle: support.email.isNotEmpty
                                  ? support.email
                                  : support.whatsapp,
                              onTap: () => _open(
                                support.email.isNotEmpty
                                    ? 'mailto:${support.email}'
                                    : 'https://wa.me/${support.whatsapp.replaceAll(RegExp(r'\D'), '')}',
                              ),
                            ),
                          if (support.termsUrl.isNotEmpty)
                            MenuRow(
                              icon: Icons.description_rounded,
                              hue: AstroPalette.air,
                              title: l.profileTerms,
                              onTap: () => _open(support.termsUrl),
                            ),
                          if (support.privacyUrl.isNotEmpty)
                            MenuRow(
                              icon: Icons.privacy_tip_rounded,
                              hue: AstroPalette.air,
                              title: l.profilePrivacy,
                              onTap: () => _open(support.privacyUrl),
                            ),
                          MenuRow(
                            icon: Icons.logout_rounded,
                            title: l.profileLogout,
                            destructive: true,
                            onTap: _logout,
                          ),
                          MenuRow(
                            icon: Icons.person_remove_rounded,
                            hue: AstroPalette.love,
                            title: l.delAccMenu,
                            subtitle: l.delAccMenuSub,
                            onTap: () =>
                                context.push(Routes.profileDeleteAccount),
                          ),
                        ],
                      ),
                      const _AppVersion(),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  /// "₹20–₹45" (per minute) across the channels that have a rate.
  String? _rateRange(AstroProfile? p) {
    final amounts = (p?.rates ?? const <AstroRate>[])
        .map((r) => double.tryParse(r.perMinute) ?? 0)
        .where((v) => v > 0)
        .toList();
    if (amounts.isEmpty) return null;
    amounts.sort();
    String f(double v) =>
        '₹${v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toStringAsFixed(1)}';
    return amounts.first == amounts.last
        ? f(amounts.first)
        : '${f(amounts.first)}–${f(amounts.last)}';
  }
}

/// The profile's identity hero as a pinned, collapsing header. The expanded
/// height is not hard-coded: the content reports its real height after layout
/// and the page feeds it back as [bodyHeight].
class _ProfileHeaderDelegate extends SliverPersistentHeaderDelegate {
  _ProfileHeaderDelegate({
    required this.profile,
    required this.topPad,
    required this.bodyHeight,
    required this.onBodyMeasured,
  });

  final AstroProfile? profile;
  final double topPad;

  /// Expanded content height below [topPad], as last measured.
  final double bodyHeight;
  final ValueChanged<double> onBodyMeasured;

  /// First-frame estimate, replaced by the measured height right after.
  static const initialBodyHeight = 230.0;

  static const _bar = 60.0; // collapsed content height

  @override
  double get minExtent => topPad + _bar;

  @override
  double get maxExtent => topPad + (bodyHeight > _bar ? bodyHeight : _bar);

  @override
  bool shouldRebuild(covariant _ProfileHeaderDelegate old) =>
      old.profile != profile ||
      old.topPad != topPad ||
      old.bodyHeight != bodyHeight;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlaps) {
    final range = maxExtent - minExtent;
    final t = range <= 0 ? 1.0 : (shrinkOffset / range).clamp(0.0, 1.0);
    return _ProfileHero(
      profile: profile,
      t: t,
      topPad: topPad,
      height: maxExtent,
      onBodyMeasured: onBodyMeasured,
    );
  }
}

class _ProfileHero extends StatefulWidget {
  const _ProfileHero({
    required this.profile,
    required this.t,
    required this.topPad,
    required this.height,
    required this.onBodyMeasured,
  });

  final AstroProfile? profile;

  /// 0 = expanded, 1 = collapsed.
  final double t;
  final double topPad;

  /// Fully expanded height, including [topPad].
  final double height;
  final ValueChanged<double> onBodyMeasured;

  @override
  State<_ProfileHero> createState() => _ProfileHeroState();
}

class _ProfileHeroState extends State<_ProfileHero> {
  bool _uploading = false;

  Future<void> _changePhoto() async {
    final l = context.l10n;
    final bloc = context.read<AuthBloc>();
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      imageQuality: 85,
    );
    if (picked == null || !mounted) return;
    setState(() => _uploading = true);
    try {
      final user = await getIt<ProfileApi>().uploadAvatar(picked.path);
      bloc.add(AuthUserUpdated(user));
      if (mounted) showToast(context, l.profilePhotoUpdated);
    } catch (_) {
      if (mounted) showToast(context, l.profilePhotoFailed);
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    final theme = Theme.of(context);
    final user = context.select((AuthBloc b) => b.state.user);
    final p = widget.profile;
    final banner = p?.banner;
    final t = widget.t;
    final topPad = widget.topPad;

    final expandedOpacity = (1 - t * 1.8).clamp(0.0, 1.0);
    final collapsedOpacity = ((t - 0.55) / 0.45).clamp(0.0, 1.0);
    final radius = BorderRadius.vertical(bottom: Radius.circular(28 - 8 * t));
    final rated = p != null && p.ratingCount > 0;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: radius,
          boxShadow: brand.shadowCosmic,
        ),
        child: ClipRRect(
          borderRadius: radius,
          child: Stack(
            children: [
              const Positioned.fill(child: CosmicBackdrop()),
              // The cover fades out as the header folds: at bar height it is
              // only a smear behind the name.
              if (banner != null)
                Positioned.fill(
                  child: Opacity(
                    opacity: expandedOpacity,
                    child: ShaderMask(
                      blendMode: BlendMode.dstIn,
                      shaderCallback: (r) => LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white.withValues(alpha: 0.55),
                          Colors.white.withValues(alpha: 0),
                        ],
                        stops: const [0, 0.7],
                      ).createShader(r),
                      child: Image.network(
                        banner,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => const SizedBox.shrink(),
                      ),
                    ),
                  ),
                ),

              // Expanded content: fades out and drifts up. Laid out at full
              // height and clipped as the header shrinks, so it never reflows.
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: widget.height,
                child: IgnorePointer(
                  ignoring: t > 0.5,
                  child: Opacity(
                    opacity: expandedOpacity,
                    child: Transform.translate(
                      offset: Offset(0, -24 * t),
                      child: OverflowBox(
                        alignment: Alignment.topCenter,
                        minHeight: 0,
                        maxHeight: double.infinity,
                        child: ReportHeight(
                          onChanged: (h) => widget.onBodyMeasured(h - topPad),
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(20, topPad + 4, 8, 20),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      l.navProfile,
                                      style: theme.textTheme.titleLarge
                                          ?.copyWith(color: brand.onCosmic),
                                    ),
                                    const Spacer(),
                                    NotificationBell(color: brand.onCosmic),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    _AvatarButton(
                                      name: user?.shortName ?? '',
                                      url: user?.avatar,
                                      busy: _uploading,
                                      onTap: _uploading ? null : _changePhoto,
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            user?.shortName ?? '',
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: theme.textTheme.headlineSmall
                                                ?.copyWith(
                                                  color: brand.onCosmic,
                                                ),
                                          ),
                                          if ((p?.headline ?? '').isNotEmpty)
                                            Text(
                                              p!.headline,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: theme.textTheme.bodySmall
                                                  ?.copyWith(
                                                    color: brand.onCosmicMuted,
                                                  ),
                                            ),
                                          if (p != null) ...[
                                            const SizedBox(height: 6),
                                            VerificationBadge(
                                              level: p.verificationLevel,
                                              onDark: true,
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Padding(
                                  padding: const EdgeInsets.only(right: 12),
                                  child: _StatStrip(profile: p),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Collapsed bar: fades in near the end of the collapse.
              Positioned(
                top: topPad,
                left: 0,
                right: 0,
                height: _ProfileHeaderDelegate._bar,
                child: IgnorePointer(
                  ignoring: t < 0.5,
                  child: Opacity(
                    opacity: collapsedOpacity,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 8, 0),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(2.5),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: BrandColors.goldGradient,
                              ),
                            ),
                            child: HueAvatar(
                              name: user?.shortName ?? '',
                              url: user?.avatar,
                              hue: AstroPalette.career,
                              size: 34,
                            ),
                          ),
                          const SizedBox(width: 10),
                          // The bar is a fixed 60 tall: at very large text
                          // sizes the name and rating shrink to fit.
                          Expanded(
                            child: LayoutBuilder(
                              builder: (context, box) => FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.centerLeft,
                                child: SizedBox(
                                  width: box.maxWidth,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        user?.shortName ?? '',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: theme.textTheme.titleMedium
                                            ?.copyWith(
                                              color: brand.onCosmic,
                                              fontWeight: FontWeight.w800,
                                            ),
                                      ),
                                      Row(
                                        children: [
                                          if (rated) ...[
                                            Icon(
                                              Icons.star_rounded,
                                              size: 14,
                                              color: brand.gold,
                                            ),
                                            const SizedBox(width: 3),
                                            Text(
                                              p.ratingAvg.toStringAsFixed(1),
                                              style: theme.textTheme.bodySmall
                                                  ?.copyWith(
                                                    color: brand.onCosmic,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                            ),
                                            const SizedBox(width: 8),
                                          ],
                                          if (p != null)
                                            Flexible(
                                              child: Text(
                                                verificationLabel(
                                                  l,
                                                  p.verificationLevel,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: theme.textTheme.bodySmall
                                                    ?.copyWith(
                                                      color:
                                                          brand.onCosmicMuted,
                                                    ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          LanguageQuickButton(color: brand.onCosmic),
                          NotificationBell(color: brand.onCosmic),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AvatarButton extends StatelessWidget {
  const _AvatarButton({
    required this.name,
    required this.url,
    required this.busy,
    required this.onTap,
  });

  final String name;
  final String? url;
  final bool busy;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    return Semantics(
      button: true,
      label: l.profileChangePhoto,
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(3),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(colors: BrandColors.goldGradient),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  HueAvatar(
                    name: name,
                    url: url,
                    hue: AstroPalette.career,
                    size: 78,
                  ),
                  if (busy)
                    const SizedBox.square(
                      dimension: 78,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0x88000000),
                        ),
                        child: Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: brand.glowAccent,
                  shape: BoxShape.circle,
                  border: Border.all(color: brand.cosmicStart, width: 2),
                ),
                child: const Icon(
                  Icons.photo_camera_rounded,
                  size: 14,
                  color: Color(0xFF3A1703),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatStrip extends StatelessWidget {
  const _StatStrip({required this.profile});

  final AstroProfile? profile;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    final p = profile;
    final cells = [
      (
        p == null || p.ratingCount == 0 ? '—' : p.ratingAvg.toStringAsFixed(1),
        l.dashStatRating,
      ),
      ('${p?.consultationsCount ?? 0}', l.dashStatSessions),
      ('${p?.followersCount ?? 0}', l.dashStatFollowers),
      ('${p?.yearsExperience ?? 0}', l.profileStatYears),
    ];
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
      ),
      child: Row(
        children: [
          for (var i = 0; i < cells.length; i++) ...[
            if (i > 0)
              Container(
                width: 1,
                height: 28,
                color: Colors.white.withValues(alpha: 0.12),
              ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    cells[i].$1,
                    style: TextStyle(
                      color: brand.onCosmic,
                      fontWeight: FontWeight.w800,
                      fontSize: 17,
                    ),
                  ),
                  Text(
                    cells[i].$2,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: brand.onCosmicMuted, fontSize: 11),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _AppVersion extends StatelessWidget {
  const _AppVersion();

  @override
  Widget build(BuildContext context) => FutureBuilder<PackageInfo>(
    future: PackageInfo.fromPlatform(),
    builder: (context, snap) => Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Center(
        child: Text(
          snap.data == null
              ? ''
              : context.l10n.profileVersion(
                  '${snap.data!.version} (${snap.data!.buildNumber})',
                ),
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: context.brand.inkMuted),
        ),
      ),
    ),
  );
}
