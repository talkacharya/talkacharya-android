import 'package:flutter/material.dart';
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
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/language_quick_button.dart';
import '../../../../shared/widgets/settings_widgets.dart';
import '../../../auth/presentation/bloc/auth/auth_bloc.dart';
import '../../../home/presentation/view/widgets/profile_strength_card.dart';
import '../../../notifications/presentation/view/notification_bell.dart';
import '../../data/profile_api.dart';
import '../widgets/verification_badge.dart';

import 'package:talkacharya_ui/talkacharya_ui.dart';

/// Profile tab under a plain app bar: a compact identity card (photo, name,
/// verification, stats), profile strength, and grouped settings.
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _store = getIt<OnboardingStore>();

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
    final theme = Theme.of(context);
    final ink = theme.colorScheme.onSurface;
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          l.navProfile,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          LanguageQuickButton(color: ink),
          NotificationBell(color: ink),
          const SizedBox(width: 4),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _store.refresh,
        child: ListenableBuilder(
          listenable: _store,
          builder: (context, _) {
            final p = _store.profile;
            return CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(child: _IdentityCard(profile: p)),
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

/// Who they are, in one light card: photo (tap to change), name, headline,
/// verification, and four numbers under a hairline.
class _IdentityCard extends StatefulWidget {
  const _IdentityCard({required this.profile});

  final AstroProfile? profile;

  @override
  State<_IdentityCard> createState() => _IdentityCardState();
}

class _IdentityCardState extends State<_IdentityCard> {
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
    final brand = context.brand;
    final theme = Theme.of(context);
    final user = context.select((AuthBloc b) => b.state.user);
    final p = widget.profile;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(Radii.lg),
          border: Border.all(color: brand.hairline),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                _AvatarButton(
                  name: user?.shortName ?? '',
                  url: user?.avatar,
                  busy: _uploading,
                  onTap: _uploading ? null : _changePhoto,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user?.shortName ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      if ((p?.headline ?? '').isNotEmpty)
                        Text(
                          p!.headline,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: brand.inkMuted,
                          ),
                        ),
                      if (p != null) ...[
                        const SizedBox(height: 6),
                        VerificationBadge(level: p.verificationLevel),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Divider(height: 1, color: brand.hairline),
            const SizedBox(height: 10),
            _StatStrip(profile: p),
          ],
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

  static const _size = 60.0;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    return Semantics(
      button: true,
      label: l.profileChangePhoto,
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                HueAvatar(
                  name: name,
                  url: url,
                  hue: AstroPalette.career,
                  size: _size,
                ),
                if (busy)
                  const SizedBox.square(
                    dimension: _size,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0x88000000),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(18),
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            Positioned(
              right: -2,
              bottom: -2,
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: scheme.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: scheme.surface, width: 2),
                ),
                child: Icon(
                  Icons.photo_camera_rounded,
                  size: 12,
                  color: scheme.onPrimary,
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
    final theme = Theme.of(context);
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
    return Row(
      children: [
        for (var i = 0; i < cells.length; i++) ...[
          if (i > 0) Container(width: 1, height: 26, color: brand.hairline),
          Expanded(
            child: Column(
              children: [
                Text(
                  cells[i].$1,
                  maxLines: 1,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  cells[i].$2,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: brand.inkMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
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
