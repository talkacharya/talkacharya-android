import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:talkacharya_ui/talkacharya_ui.dart';

import '../../../../core/astro/models/astro_profile.dart';
import '../../../../core/availability/availability_coordinator.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/settings_widgets.dart';
import '../../../auth/presentation/bloc/auth/auth_bloc.dart';
import '../../../consultations/presentation/widgets/consultation_style.dart';
import '../../../workspace/data/workspace_api.dart';
import '../../data/profile_api.dart';
import '../../data/profile_models.dart';
import '../widgets/verification_badge.dart';

/// Everything the page shows, fetched together.
class _PublicProfile {
  const _PublicProfile({
    required this.profile,
    required this.photos,
    required this.waitingPhotos,
    required this.reviews,
    required this.skillNames,
    required this.languageNames,
  });

  final AstroProfile profile;

  /// The photos customers see: the approved ones.
  final List<GalleryPhoto> photos;

  /// Uploaded but not yet through review, so not on the profile.
  final int waitingPhotos;

  /// The reviews a customer is shown: published, well rated, with words.
  final List<Review> reviews;
  final Map<String, String> skillNames;
  final Map<String, String> languageNames;
}

/// The astrologer's own profile, laid out the way a customer meets it: cover
/// and name, photos, numbers, rates, what they practise, their words about
/// themselves and what clients said. Each part links to where it is changed,
/// so this is both the mirror and the way to fix what it shows.
class PublicProfilePage extends StatefulWidget {
  const PublicProfilePage({super.key});

  @override
  State<PublicProfilePage> createState() => _PublicProfilePageState();
}

class _PublicProfilePageState extends State<PublicProfilePage> {
  late Future<_PublicProfile> _future = _load();

  Future<_PublicProfile> _load() async {
    final api = getIt<ProfileApi>();
    final results = await Future.wait<Object>([
      api.profile(),
      getIt<WorkspaceApi>().gallery(),
      api.reviews(),
      api.skillOptions(),
      api.languageOptions(),
    ]);
    final gallery = results[1] as Gallery;
    final reviews = results[2] as List<Review>;
    return _PublicProfile(
      profile: results[0] as AstroProfile,
      photos: [
        for (final p in gallery.photos)
          if (!p.pending && !p.rejected) p,
      ],
      waitingPhotos: gallery.photos.where((p) => p.pending).length,
      reviews: [
        for (final r in reviews)
          if (r.isPublished && r.rating >= 4 && r.text.trim().isNotEmpty) r,
      ].take(3).toList(),
      skillNames: {
        for (final o in results[3] as List<RefOption>) o.code: o.name,
      },
      languageNames: {
        for (final o in results[4] as List<RefOption>) o.code: o.name,
      },
    );
  }

  Future<void> _reload() async {
    final next = _load();
    setState(() => _future = next);
    await next.catchError((_) => _future);
  }

  /// Opens an editor and, back from it, shows what it changed.
  Future<void> _edit(String route) async {
    await context.push<void>(route);
    if (mounted) await _reload();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      body: FutureBuilder<_PublicProfile>(
        future: _future,
        builder: (context, snap) {
          final data = snap.data;
          if (data == null) {
            return Column(
              children: [
                _Hero(profile: null, onEdit: null),
                Expanded(
                  child: snap.hasError
                      ? ErrorView(message: l.commonLoadFailed, onRetry: _reload)
                      : const Center(child: CircularProgressIndicator()),
                ),
              ],
            );
          }
          final p = data.profile;
          return RefreshIndicator(
            edgeOffset: 120,
            onRefresh: _reload,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: _Hero(
                    profile: p,
                    onEdit: () => _edit(Routes.profileEdit),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                  sliver: SliverList.list(
                    children: [
                      _Note(
                        icon: p.isAvailable
                            ? Icons.visibility_rounded
                            : Icons.visibility_off_rounded,
                        text: p.isAvailable ? l.pubNote : l.pubHidden,
                      ),
                      _PhotosCard(
                        photos: data.photos,
                        waiting: data.waitingPhotos,
                        onManage: () => _edit(Routes.gallery),
                      ),
                      _StatsCard(profile: p),
                      _RatesCard(
                        profile: p,
                        onEdit: () => _edit(Routes.profileRates),
                      ),
                      _ChipsCard(
                        title: l.pubExpertise,
                        icon: Icons.auto_awesome_rounded,
                        hue: AstroPalette.career,
                        // The one they lead with comes first, as it does for
                        // a customer.
                        labels: [
                          for (final s in [
                            ...p.skills.where((s) => s.isPrimary),
                            ...p.skills.where((s) => !s.isPrimary),
                          ])
                            data.skillNames[s.slug] ?? s.slug,
                        ],
                        onEdit: () => _edit(Routes.profileEdit),
                      ),
                      _ChipsCard(
                        title: l.pubLanguages,
                        icon: Icons.translate_rounded,
                        hue: AstroPalette.air,
                        labels: [
                          for (final c in p.languages)
                            data.languageNames[c] ?? c.toUpperCase(),
                        ],
                        onEdit: () => _edit(Routes.profileEdit),
                      ),
                      _AboutCard(
                        bio: p.bio,
                        onEdit: () => _edit(Routes.profileEdit),
                      ),
                      _ReviewsCard(
                        profile: p,
                        reviews: data.reviews,
                        onSeeAll: () => _edit(Routes.profileReviews),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// --- hero -----------------------------------------------------------------

class _Hero extends StatelessWidget {
  const _Hero({required this.profile, required this.onEdit});

  final AstroProfile? profile;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    final theme = Theme.of(context);
    final user = context.select((AuthBloc b) => b.state.user);
    final coord = getIt<AvailabilityCoordinator>();
    final p = profile;
    final banner = p?.banner;
    const radius = BorderRadius.vertical(bottom: Radius.circular(28));

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
              if (banner != null)
                Positioned.fill(
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
              SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(4, 0, 8, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          BackButton(color: brand.onCosmic),
                          Expanded(
                            child: Text(
                              l.pubTitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.titleLarge?.copyWith(
                                color: brand.onCosmic,
                              ),
                            ),
                          ),
                          if (onEdit != null)
                            TextButton.icon(
                              onPressed: onEdit,
                              style: TextButton.styleFrom(
                                foregroundColor: brand.gold,
                              ),
                              icon: const Icon(Icons.edit_rounded, size: 18),
                              label: Text(l.pubEdit),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Padding(
                        padding: const EdgeInsets.only(left: 16, right: 12),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(3),
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
                                size: 84,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user?.shortName ?? '',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: theme.textTheme.headlineSmall
                                        ?.copyWith(color: brand.onCosmic),
                                  ),
                                  if ((p?.headline ?? '').isNotEmpty)
                                    Text(
                                      p!.headline,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(
                                            color: brand.onCosmicMuted,
                                          ),
                                    ),
                                  if (p != null) ...[
                                    const SizedBox(height: 8),
                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 6,
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      children: [
                                        VerificationBadge(
                                          level: p.verificationLevel,
                                          onDark: true,
                                        ),
                                        ListenableBuilder(
                                          listenable: coord,
                                          builder: (context, _) =>
                                              _PresencePill(
                                                online:
                                                    coord.enabled &&
                                                    !coord.onBreak &&
                                                    coord.presence != 'offline',
                                              ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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

/// "Online now" / "Offline", as the dot on the customer's side reads.
class _PresencePill extends StatelessWidget {
  const _PresencePill({required this.online});

  final bool online;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: online ? brand.online : brand.onCosmicMuted,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            online ? l.pubOnline : l.pubOffline,
            style: TextStyle(
              color: brand.onCosmic,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

// --- sections -------------------------------------------------------------

class _Note extends StatelessWidget {
  const _Note({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 0, 4, 14),
      child: Row(
        children: [
          Icon(icon, size: 16, color: brand.inkMuted),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: brand.inkMuted),
            ),
          ),
        ],
      ),
    );
  }
}

/// The small "Edit" / "See all" at the head of a card.
class _CardAction extends StatelessWidget {
  const _CardAction({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => TextButton(
    onPressed: onTap,
    style: TextButton.styleFrom(
      minimumSize: const Size(0, 36),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      visualDensity: VisualDensity.compact,
    ),
    child: Text(label),
  );
}

class _PhotosCard extends StatefulWidget {
  const _PhotosCard({
    required this.photos,
    required this.waiting,
    required this.onManage,
  });

  final List<GalleryPhoto> photos;
  final int waiting;
  final VoidCallback onManage;

  @override
  State<_PhotosCard> createState() => _PhotosCardState();
}

class _PhotosCardState extends State<_PhotosCard> {
  final _pages = PageController(viewportFraction: 0.9);
  int _index = 0;

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  void _openAll() => Navigator.of(context, rootNavigator: true).push(
    MaterialPageRoute<void>(
      builder: (_) => _AllPhotosPage(photos: widget.photos),
    ),
  );

  void _openOne(int index) => Navigator.of(context, rootNavigator: true).push(
    MaterialPageRoute<void>(
      fullscreenDialog: true,
      builder: (_) => _PhotoViewer(photos: widget.photos, initial: index),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    final theme = Theme.of(context);
    final photos = widget.photos;
    return SettingsCard(
      title: l.pubPhotos,
      subtitle: widget.waiting > 0 ? l.pubPhotosWaiting(widget.waiting) : null,
      icon: Icons.photo_library_rounded,
      hue: AstroPalette.water,
      trailing: photos.isEmpty
          ? null
          : _CardAction(label: l.pubSeeAll, onTap: _openAll),
      padding: const EdgeInsets.only(bottom: 14),
      child: photos.isEmpty
          ? Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l.pubPhotosEmpty,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: brand.inkMuted,
                    ),
                  ),
                  const SizedBox(height: 10),
                  FilledButton.tonalIcon(
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(0, 44),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    onPressed: widget.onManage,
                    icon: const Icon(Icons.add_a_photo_rounded, size: 18),
                    label: Text(l.pubAddPhotos),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 10,
                  child: PageView.builder(
                    controller: _pages,
                    itemCount: photos.length,
                    onPageChanged: (i) => setState(() => _index = i),
                    itemBuilder: (_, i) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: _Photo(
                        photo: photos[i],
                        radius: Radii.md,
                        onTap: () => _openOne(i),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Wrap(
                          spacing: 5,
                          children: [
                            for (var i = 0; i < photos.length; i++)
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 180),
                                width: i == _index ? 16 : 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: i == _index
                                      ? theme.colorScheme.primary
                                      : brand.hairline,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                          ],
                        ),
                      ),
                      _CardAction(label: l.pubManage, onTap: widget.onManage),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

/// One profile photo, cropped to fill its box, with its caption over the foot.
class _Photo extends StatelessWidget {
  const _Photo({required this.photo, required this.onTap, this.radius = 12});

  final GalleryPhoto photo;
  final VoidCallback onTap;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Material(
        color: brand.tint,
        child: InkWell(
          onTap: onTap,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                photo.image,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Center(
                  child: Icon(
                    Icons.broken_image_rounded,
                    color: brand.inkMuted,
                  ),
                ),
              ),
              if (photo.caption.isNotEmpty)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(10, 18, 10, 8),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0x00000000), Color(0xB3000000)],
                      ),
                    ),
                    child: Text(
                      photo.caption,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
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

class _StatsCard extends StatelessWidget {
  const _StatsCard({required this.profile});

  final AstroProfile profile;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    final theme = Theme.of(context);
    final p = profile;
    final cells = [
      (
        p.ratingCount == 0 ? '—' : p.ratingAvg.toStringAsFixed(1),
        l.dashStatRating,
      ),
      ('${p.consultationsCount}', l.dashStatSessions),
      ('${p.followersCount}', l.dashStatFollowers),
      ('${p.yearsExperience}', l.profileStatYears),
    ];
    return SettingsCard(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          for (final (value, label) in cells)
            Expanded(
              child: Column(
                children: [
                  Text(
                    value,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: brand.inkMuted,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _RatesCard extends StatelessWidget {
  const _RatesCard({required this.profile, required this.onEdit});

  final AstroProfile profile;
  final VoidCallback onEdit;

  static String _money(String amount) {
    final v = double.tryParse(amount) ?? 0;
    return '₹${v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    final theme = Theme.of(context);
    final rates = {
      for (final r in profile.rates)
        if (r.currency == 'INR' ||
            profile.rates.every((x) => x.currency != 'INR'))
          r.channel: r,
    };
    return SettingsCard(
      title: l.profileRates,
      icon: Icons.currency_rupee_rounded,
      hue: AstroPalette.money,
      trailing: _CardAction(label: l.pubEdit, onTap: onEdit),
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
      child: rates.isEmpty
          ? Text(
              l.pubRatesEmpty,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: brand.inkMuted,
              ),
            )
          : Row(
              children: [
                for (final channel in kChannels)
                  if (rates[channel] case final rate?)
                    Expanded(
                      child: Builder(
                        builder: (context) {
                          final ch = channelStyle(context, channel);
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: ch.hue.tint(0.10),
                              borderRadius: BorderRadius.circular(Radii.sm),
                            ),
                            child: Column(
                              children: [
                                Icon(ch.icon, size: 20, color: ch.hue.end),
                                const SizedBox(height: 6),
                                Text(
                                  l.pubPerMinute(_money(rate.perMinute)),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                Text(
                                  ch.label,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: brand.inkMuted,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
              ],
            ),
    );
  }
}

class _ChipsCard extends StatelessWidget {
  const _ChipsCard({
    required this.title,
    required this.icon,
    required this.hue,
    required this.labels,
    required this.onEdit,
  });

  final String title;
  final IconData icon;
  final AstroHue hue;
  final List<String> labels;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    final theme = Theme.of(context);
    return SettingsCard(
      title: title,
      icon: icon,
      hue: hue,
      trailing: _CardAction(label: l.pubEdit, onTap: onEdit),
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: labels.isEmpty
          ? Text(
              l.pubNothingYet,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: brand.inkMuted,
              ),
            )
          : Align(
              alignment: AlignmentDirectional.centerStart,
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final label in labels)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: hue.tint(0.10),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        label,
                        style: theme.textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}

class _AboutCard extends StatefulWidget {
  const _AboutCard({required this.bio, required this.onEdit});

  final String bio;
  final VoidCallback onEdit;

  @override
  State<_AboutCard> createState() => _AboutCardState();
}

class _AboutCardState extends State<_AboutCard> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    final theme = Theme.of(context);
    final bio = widget.bio.trim();
    final long = bio.length > 240;
    return SettingsCard(
      title: l.pubAbout,
      icon: Icons.person_rounded,
      hue: AstroPalette.love,
      trailing: _CardAction(label: l.pubEdit, onTap: widget.onEdit),
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            bio.isEmpty ? l.pubAboutEmpty : bio,
            maxLines: long && !_open ? 5 : null,
            overflow: long && !_open ? TextOverflow.ellipsis : null,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: bio.isEmpty ? brand.inkMuted : null,
              height: 1.45,
            ),
          ),
          if (long)
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: TextButton(
                style: TextButton.styleFrom(
                  minimumSize: const Size(0, 36),
                  padding: EdgeInsets.zero,
                ),
                onPressed: () => setState(() => _open = !_open),
                child: Text(_open ? l.pubReadLess : l.pubReadMore),
              ),
            ),
        ],
      ),
    );
  }
}

class _ReviewsCard extends StatelessWidget {
  const _ReviewsCard({
    required this.profile,
    required this.reviews,
    required this.onSeeAll,
  });

  final AstroProfile profile;
  final List<Review> reviews;
  final VoidCallback onSeeAll;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    final theme = Theme.of(context);
    return SettingsCard(
      title: l.pubReviews,
      subtitle: profile.ratingCount > 0
          ? l.reviewsBasedOn(profile.ratingCount)
          : null,
      icon: Icons.reviews_rounded,
      hue: AstroPalette.fire,
      trailing: _CardAction(label: l.pubSeeAll, onTap: onSeeAll),
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
      child: reviews.isEmpty
          ? Text(
              l.pubReviewsEmpty,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: brand.inkMuted,
              ),
            )
          : Column(
              children: [
                for (final (i, r) in reviews.indexed) ...[
                  if (i > 0) Divider(height: 22, color: brand.hairline),
                  _ReviewRow(review: r),
                ],
              ],
            ),
    );
  }
}

class _ReviewRow extends StatelessWidget {
  const _ReviewRow({required this.review});

  final Review review;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    final theme = Theme.of(context);
    final name = review.customerName.trim();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                name.isEmpty ? l.reviewsAnonymous : name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            for (var i = 0; i < 5; i++)
              Icon(
                Icons.star_rounded,
                size: 16,
                color: i < review.rating ? brand.gold : brand.hairline,
              ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          review.text.trim(),
          style: theme.textTheme.bodyMedium?.copyWith(height: 1.4),
        ),
        if (review.hasReply) ...[
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: brand.tint,
              borderRadius: BorderRadius.circular(Radii.sm),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.reviewsYourReply,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: brand.inkMuted,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(review.reply.trim(), style: theme.textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

// --- all photos + viewer --------------------------------------------------

/// Every photo on the profile, as a grid; a tap opens it full screen.
class _AllPhotosPage extends StatelessWidget {
  const _AllPhotosPage({required this.photos});

  final List<GalleryPhoto> photos;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return SubPageScaffold(
      title: l.pubPhotos,
      subtitle: l.pubPhotosCount(photos.length),
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
          ),
          itemCount: photos.length,
          itemBuilder: (context, i) => _Photo(
            photo: photos[i],
            radius: Radii.md,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                fullscreenDialog: true,
                builder: (_) => _PhotoViewer(photos: photos, initial: i),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// One photo at a time on black; swipe for the next, pinch to look closer.
class _PhotoViewer extends StatefulWidget {
  const _PhotoViewer({required this.photos, required this.initial});

  final List<GalleryPhoto> photos;
  final int initial;

  @override
  State<_PhotoViewer> createState() => _PhotoViewerState();
}

class _PhotoViewerState extends State<_PhotoViewer> {
  late final _pages = PageController(initialPage: widget.initial);
  late int _index = widget.initial;

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final caption = widget.photos[_index].caption;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          title: Text(
            l.pubPhotoOf(_index + 1, widget.photos.length),
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pages,
                itemCount: widget.photos.length,
                onPageChanged: (i) => setState(() => _index = i),
                itemBuilder: (_, i) => InteractiveViewer(
                  maxScale: 4,
                  child: Center(
                    child: Image.network(
                      widget.photos[i].image,
                      fit: BoxFit.contain,
                      errorBuilder: (_, _, _) => const Icon(
                        Icons.broken_image_rounded,
                        color: Colors.white54,
                        size: 40,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (caption.isNotEmpty)
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                  child: Text(
                    caption,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
