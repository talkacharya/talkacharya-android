import 'package:cached_network_image/cached_network_image.dart';
import 'package:customr/src/features/astrologers/presentation/view/widgets/detail_skeleton_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/util/money.dart';
import '../../../../shared/widgets/app_snack.dart';
import '../../../auth/presentation/bloc/auth/auth_bloc.dart';
import '../../../consultations/presentation/view/book_consultation_sheet.dart';
import '../../../follows/presentation/cubit/follow_cubit.dart';
import '../../../follows/presentation/widgets/follow_widgets.dart';
import '../../../gifting/data/models/gift.dart';
import '../../../gifting/presentation/view/gift_sheet.dart';
import '../../data/astrologers_repository.dart';
import '../../data/models/astrologer.dart';
import '../next_online_label.dart';
import 'widgets/astrologer_gallery.dart';
import 'widgets/astrologer_reviews.dart';
import 'widgets/waitlist_banner.dart';

import 'package:talkacharya_ui/talkacharya_ui.dart';

class AstrologerDetailPage extends StatefulWidget {
  const AstrologerDetailPage({required this.astrologerId, super.key});

  final String astrologerId;

  @override
  State<AstrologerDetailPage> createState() => _AstrologerDetailPageState();
}

class _AstrologerDetailPageState extends State<AstrologerDetailPage> {
  late Future<Astrologer> _future = _load();

  Future<Astrologer> _load() async {
    final a = await GetIt.I<AstrologersRepository>().detail(
      widget.astrologerId,
    );
    // fresh server truth for every follow control showing this astrologer
    if (GetIt.I.isRegistered<FollowCubit>()) GetIt.I<FollowCubit>().seed([a]);
    return a;
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: context.brand.canvas,
        body: FutureBuilder<Astrologer>(
          future: _future,
          builder: (context, snap) {
            if (snap.connectionState != ConnectionState.done) {
              return _ChromeOnly(
                title: l.astroProfileTitle,
                child: const Center(child: AstrologerProfileSkeleton()),
              );
            }
            if (snap.hasError || !snap.hasData) {
              return _ChromeOnly(
                title: l.astroProfileTitle,
                child: ErrorView(
                  message: l.astroCouldntLoadOne,
                  onRetry: () => setState(() => _future = _load()),
                ),
              );
            }
            return _ProfileView(a: snap.data!);
          },
        ),
      ),
    );
  }
}

// --------------------------------------------------------------------------

class _ProfileView extends StatelessWidget {
  const _ProfileView({required this.a});

  final Astrologer a;

  @override
  Widget build(BuildContext context) {
    final sections = <Widget>[
      _StatsCard(a: a),
      if (a.skills.isNotEmpty) _SkillsCard(skills: a.skills),
      if (a.bio.isNotEmpty) _AboutSection(bio: a.bio, languages: a.languages),
      if (a.gallery.isNotEmpty) AstrologerGallery(photos: a.gallery),
      if (a.topReviews.isNotEmpty) AstrologerReviewsCard(astrologer: a),
      if (a.rates.isNotEmpty) _RatesCard(rates: a.rates, astrologer: a),
      const _TrustRow(),
    ];

    return Scaffold(
      backgroundColor: Colors.transparent,
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: context.brand.cosmicStart,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: _HeaderCtas(a: a),
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          _Header(a: a),
          SliverToBoxAdapter(
            child: WaitlistBanner(
              astrologerId: a.id,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              onStart: (channel) => switch (channel) {
                'voice' => _startVoice(context, a),
                'video' => _startVideo(context, a),
                _ => _startChat(context, a),
              },
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            sliver: SliverList.separated(
              itemCount: sections.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, i) => FadeSlideIn(
                delay: Duration(milliseconds: 40 * i),
                child: sections[i],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- header ------------------------------------------------------------------

class _Header extends StatelessWidget {
  const _Header({required this.a});

  final Astrologer a;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brand = context.brand;
    final l = context.l10n;
    final hue = AstroPalette.forId(a.id);
    final replies = a.responseMinutes;

    return SliverAppBar(
      pinned: true,
      expandedHeight: 260,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      foregroundColor: Colors.white,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      flexibleSpace: LayoutBuilder(
        builder: (context, box) {
          final top = MediaQuery.paddingOf(context).top;
          final toolbarHeight = top + kToolbarHeight;
          final collapsed = box.maxHeight <= toolbarHeight + 24;
          final bgHeight = (box.maxHeight - 42) > toolbarHeight
              ? (box.maxHeight - 42)
              : toolbarHeight;

          return Stack(
            fit: StackFit.expand,
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: bgHeight,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(color: brand.cosmicStart),
                    const CosmicBackdrop(),
                    if (a.banner?.isNotEmpty ?? false)
                      _BannerBackdrop(url: a.banner!),
                  ],
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: bgHeight,
                child: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  background: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 56, 20, 54),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Text(
                                  a.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              if (a.isVerified) ...[
                                const SizedBox(width: 6),
                                Shimmer.fromColors(
                                  baseColor: AstroPalette.air.start,
                                  highlightColor: Colors.white,
                                  period: const Duration(milliseconds: 2500),
                                  child: Icon(
                                    Icons.verified_rounded,
                                    size: 20,
                                    color: AstroPalette.air.start,
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            a.headline.isNotEmpty
                                ? a.headline
                                : a.skillsLabel.isNotEmpty
                                ? a.skillsLabel
                                : l.astroDefaultSkill,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.white.withValues(alpha: 0.75),
                              height: 1.35,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Padding(
                            padding: const EdgeInsets.only(left: 84),
                            child: Wrap(
                              alignment: WrapAlignment.center,
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                _GlassPill(
                                  dot: a.isAvailable
                                      ? const Color(0xFF4ADE80)
                                      : Colors.white.withValues(alpha: 0.5),
                                  label: a.isAvailable
                                      ? l.astroOnlineNow
                                      : l.astroBusy,
                                ),
                                if (replies != null)
                                  _GlassPill(
                                    icon: Icons.bolt_rounded,
                                    label: l.astroRepliesIn(
                                      l.commonMinutesShort(replies),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 16,
                child: IgnorePointer(
                  ignoring: collapsed,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 180),
                    opacity: collapsed ? 0 : 1,
                    child: Hero(
                      tag: 'astrologer_photo_${a.id}',
                      child: _Avatar(
                        name: a.name,
                        url: a.avatar,
                        online: a.isAvailable,
                        hue: hue,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: top + 8,
                right: 12,
                child: IgnorePointer(
                  ignoring: collapsed,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 180),
                    opacity: collapsed ? 0 : 1,
                    child: FollowGlassButton(
                      astrologerId: a.id,
                      astrologerName: a.name,
                      fallback: followEntryOf(a),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: top,
                left: 56,
                right: 8,
                height: kToolbarHeight,
                child: IgnorePointer(
                  ignoring: !collapsed,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 180),
                    opacity: collapsed ? 1 : 0,
                    child: Row(
                      children: [
                        if (a.avatar != null && a.avatar!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: CircleAvatar(
                              radius: 16,
                              backgroundImage: CachedNetworkImageProvider(
                                a.avatar!,
                              ),
                            ),
                          ),
                        Expanded(
                          child: Text(
                            a.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        FollowGlassButton(
                          astrologerId: a.id,
                          astrologerName: a.name,
                          fallback: followEntryOf(a),
                          compact: true,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// The astrologer's cover photo behind the header, with a cosmic-tinted scrim so
/// the white name, pills and CTAs stay readable on any image.
class _BannerBackdrop extends StatelessWidget {
  const _BannerBackdrop({required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    return Stack(
      fit: StackFit.expand,
      children: [
        CachedNetworkImage(
          imageUrl: url,
          fit: BoxFit.cover,
          fadeInDuration: const Duration(milliseconds: 250),
          errorWidget: (_, _, _) => const SizedBox.shrink(),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                brand.cosmicStart.withValues(alpha: 0.55),
                brand.cosmicStart.withValues(alpha: 0.35),
                brand.cosmicStart.withValues(alpha: 0.9),
              ],
              stops: const [0, 0.35, 1],
            ),
          ),
        ),
      ],
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({
    required this.name,
    required this.url,
    required this.online,
    required this.hue,
  });

  final String name;
  final String? url;
  final bool online;
  final AstroHue hue;

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    final u = url;
    final trimmed = name.trim();
    final initial = Center(
      child: Text(
        trimmed.isEmpty ? '★' : trimmed.characters.first.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 32,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: SweepGradient(colors: [hue.start, hue.end, hue.start]),
          ),
          child: Container(
            width: 84,
            height: 84,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: hue.linear(),
              border: Border.all(color: brand.canvas, width: 3.5),
            ),
            clipBehavior: Clip.antiAlias,
            child: (u != null && u.isNotEmpty)
                ? CachedNetworkImage(
                    imageUrl: u,
                    fit: BoxFit.cover,
                    placeholder: (_, _) => initial,
                    errorWidget: (_, _, _) => initial,
                  )
                : initial,
          ),
        ),
        if (online)
          Positioned(
            right: 4,
            bottom: 4,
            child: Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: const Color(0xFF4ADE80),
                shape: BoxShape.circle,
                border: Border.all(color: brand.canvas, width: 3),
              ),
            ),
          ),
      ],
    );
  }
}

class _GlassPill extends StatelessWidget {
  const _GlassPill({
    required this.label,
    this.icon,
    this.dot,
    this.darkText = false,
  });

  final String label;
  final IconData? icon;
  final Color? dot;
  final bool darkText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 5, 12, 5),
      decoration: BoxDecoration(
        color: darkText
            ? theme.colorScheme.surfaceContainerHigh
            : Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: darkText
              ? theme.colorScheme.outlineVariant
              : Colors.white.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (dot != null)
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: dot, shape: BoxShape.circle),
            )
          else if (icon != null)
            Icon(icon, size: 14, color: AstroPalette.money.start),
          const SizedBox(width: 6),
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: darkText ? theme.colorScheme.onSurface : Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

// --- stats ------------------------------------------------------------------

class _StatsCard extends StatelessWidget {
  const _StatsCard({required this.a});

  final Astrologer a;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    final followers =
        watchFollow(context, a.id, followEntryOf(a))?.followersCount ?? 0;

    final all = <(IconData, AstroHue, String, String)>[
      (
        Icons.star_rounded,
        AstroPalette.money,
        a.ratingAvg > 0 ? a.ratingAvg.toStringAsFixed(1) : '—',
        a.ratingCount > 0
            ? l.astroReviewsCount(a.ratingCount)
            : l.astroStatRating,
      ),
      if (followers > 0)
        (
          Icons.people_alt_rounded,
          AstroPalette.love,
          compactFollowers(followers),
          l.astroStatFollowers,
        ),
      if (a.yearsExperience > 0)
        (
          Icons.workspace_premium_rounded,
          AstroPalette.career,
          '${a.yearsExperience} yrs',
          l.astroStatExperience,
        ),
      if (a.consultationsCount > 0)
        (
          Icons.forum_rounded,
          AstroPalette.love,
          _compact(a.consultationsCount),
          l.astroStatSessions,
        ),
      if ((a.repeatClientRate ?? 0) > 0)
        (
          Icons.favorite_rounded,
          AstroPalette.health,
          '${((a.repeatClientRate ?? 0) * 100).round()}%',
          l.astroStatRepeatClients,
        ),
    ];
    // four cells is the most a small phone fits legibly
    final items = all.take(4).toList();

    return _Card(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
      child: Row(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            if (i > 0) Container(width: 1, height: 40, color: brand.hairline),
            Expanded(
              child: _StatCell(
                icon: items[i].$1,
                hue: items[i].$2,
                value: items[i].$3,
                label: items[i].$4,
              ),
            ),
          ],
        ],
      ),
    );
  }

  static String _compact(int n) {
    if (n >= 100000) return '${(n / 100000).toStringAsFixed(1)}L';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}k';
    return '$n';
  }
}

class _StatCell extends StatelessWidget {
  const _StatCell({
    required this.icon,
    required this.hue,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final AstroHue hue;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: hue.tint(0.13),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 17, color: hue.end),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          maxLines: 1,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            label,
            maxLines: 1,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelSmall?.copyWith(
              color: context.brand.inkMuted,
            ),
          ),
        ),
      ],
    );
  }
}

// --- skills ------------------------------------------------------------------

class _SkillsCard extends StatelessWidget {
  const _SkillsCard({required this.skills});

  final List<AstrologerSkill> skills;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(context.l10n.astroExpertiseTitle),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (var i = 0; i < skills.length && i < 8; i++)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AstroPalette.at(i).tint(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AstroPalette.at(i).tint(0.25)),
                  ),
                  child: Text(
                    skills[i].name,
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AstroPalette.at(i).end,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

// --- about ------------------------------------------------------------------

class _AboutSection extends StatefulWidget {
  const _AboutSection({required this.bio, required this.languages});

  final String bio;
  final List<AstrologerLanguage> languages;

  @override
  State<_AboutSection> createState() => _AboutSectionState();
}

class _AboutSectionState extends State<_AboutSection> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brand = context.brand;
    final l = context.l10n;
    final long = widget.bio.length > 180;
    final langs = widget.languages
        .map((e) => e.name)
        .where((e) => e.isNotEmpty)
        .toList();

    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(l.astroAboutTitle),
          const SizedBox(height: 8),
          AnimatedSize(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            alignment: Alignment.topCenter,
            child: Text(
              widget.bio,
              maxLines: (!long || _expanded) ? null : 4,
              overflow: (!long || _expanded)
                  ? TextOverflow.clip
                  : TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
            ),
          ),
          if (long)
            TextButton(
              onPressed: () => setState(() => _expanded = !_expanded),
              style: TextButton.styleFrom(
                foregroundColor: AstroPalette.career.end,
                padding: EdgeInsets.zero,
                minimumSize: const Size(0, 32),
                visualDensity: VisualDensity.compact,
              ),
              child: Text(
                _expanded ? l.astroReadLess : l.astroReadMore,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          if (langs.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(height: 1, color: brand.hairline),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.translate_rounded, size: 16, color: brand.inkMuted),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l.astroSpeaks(langs.join(', ')),
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: brand.inkMuted,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

// --- rates ------------------------------------------------------------------

class _RatesCard extends StatelessWidget {
  const _RatesCard({required this.rates, required this.astrologer});

  final List<AstrologerRate> rates;
  final Astrologer astrologer;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final brand = context.brand;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final cheapest = rates
        .map((r) => r.perMinute)
        .reduce((a, b) => a < b ? a : b);
    final ordered = _ordered(rates);

    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(l.astroRatesTitle),
          if (astrologer.offer case final offer?) ...[
            const SizedBox(height: 8),
            _OfferPill(offer: offer),
          ],
          const SizedBox(height: 4),
          for (var i = 0; i < ordered.length; i++) ...[
            if (i > 0) Container(height: 1, color: brand.hairline),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: _hue(ordered[i].channel).tint(0.13),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      _channelIcon(ordered[i].channel),
                      size: 18,
                      color: _hue(ordered[i].channel).end,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _channelLabel(l, ordered[i].channel),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (ordered[i].perMinute == cheapest && rates.length > 1)
                    Flexible(
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AstroPalette.health.tint(0.13),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          l.astroSortRecommended,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: AstroPalette.health.end,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (astrologer.offerPercentFor(ordered[i].channel) > 0)
                        Text(
                          Money.format(
                            ordered[i].perMinute,
                            ordered[i].currency,
                            locale: locale,
                          ),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: brand.inkMuted,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      Text(
                        l.astroPerMinute(
                          Money.format(
                            astrologer.priceFor(ordered[i]),
                            ordered[i].currency,
                            locale: locale,
                          ),
                        ),
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  static List<AstrologerRate> _ordered(List<AstrologerRate> rates) {
    const order = {'chat': 0, 'voice': 1, 'video': 2};
    return [
      ...rates,
    ]..sort((a, b) => (order[a.channel] ?? 9).compareTo(order[b.channel] ?? 9));
  }

  static AstroHue _hue(String c) => switch (c) {
    'chat' => AstroPalette.career,
    'voice' => AstroPalette.health,
    'video' => AstroPalette.love,
    _ => AstroPalette.money,
  };

  static IconData _channelIcon(String c) => switch (c) {
    'chat' => Icons.chat_bubble_rounded,
    'voice' => Icons.phone_in_talk_rounded,
    'video' => Icons.videocam_rounded,
    _ => Icons.bolt_rounded,
  };

  static String _channelLabel(AppLocalizations l, String c) => switch (c) {
    'chat' => l.channelChat,
    'voice' => l.channelVoice,
    'video' => l.channelVideo,
    _ => c,
  };
}

// --- trust + shared -------------------------------------------------------

/// The astrologer's running offer, above their rates: how much off, for
/// whom, and until when.
class _OfferPill extends StatelessWidget {
  const _OfferPill({required this.offer});

  final AstrologerOffer offer;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final ends = offer.endsAt;
    final details = [
      if (offer.audience == 'new') l.astroOfferNew,
      if (ends != null)
        l.astroOfferEnds(
          MaterialLocalizations.of(context).formatShortDate(ends.toLocal()),
          TimeOfDay.fromDateTime(ends.toLocal()).format(context),
        ),
    ].join(' · ');
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AstroPalette.fire.tint(0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            Icons.local_offer_rounded,
            size: 18,
            color: AstroPalette.fire.end,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.astroOfferBadge(offer.percentOff),
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: AstroPalette.fire.end,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if (details.isNotEmpty)
                  Text(details, style: theme.textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TrustRow extends StatelessWidget {
  const _TrustRow();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          Icon(
            Icons.verified_user_rounded,
            size: 16,
            color: AstroPalette.health.end,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              context.l10n.astroTrustLine,
              style: theme.textTheme.labelSmall?.copyWith(
                color: context.brand.inkMuted,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.brand.hairline),
      ),
      child: child,
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(
        context,
      ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
    );
  }
}

// --- actions -------------------------------------------------------------

/// Says when [channel] is back and returns true, if the astrologer has it
/// switched off until a time they gave.
bool _toldWhenBack(BuildContext context, Astrologer a, String channel) {
  final back = a.nextOnlineFor(channel);
  if (back == null) return false;
  final l = context.l10n;
  final label = switch (channel) {
    'voice' => l.channelVoice,
    'video' => l.channelVideo,
    _ => l.channelChat,
  };
  AppSnack.showTop(
    context,
    l.astroChannelBack(label, nextOnlineWhen(context, back)),
    type: SnackType.info,
  );
  return true;
}

void _startChat(BuildContext context, Astrologer a) {
  final chat = a.rateFor('chat');
  if (chat == null || !a.isAvailable) {
    AppSnack.showTop(
      context,
      context.l10n.astroNotifyWhenOnline,
      type: SnackType.info,
    );
    return;
  }
  if (_toldWhenBack(context, a, 'chat')) return;
  showBookConsultationSheet(
    context,
    astrologerId: a.id,
    astrologerName: a.name,
    ratePerMinute: a.priceFor(chat),
    offerPercent: a.offerPercentFor('chat'),
    currency: chat.currency,
  );
}

void _startVoice(BuildContext context, Astrologer a) {
  final voice = a.rateFor('voice');
  if (voice == null || !a.isAvailable) {
    AppSnack.showTop(
      context,
      context.l10n.callUnavailable,
      type: SnackType.info,
    );
    return;
  }
  if (_toldWhenBack(context, a, 'voice')) return;
  showBookConsultationSheet(
    context,
    astrologerId: a.id,
    astrologerName: a.name,
    ratePerMinute: a.priceFor(voice),
    offerPercent: a.offerPercentFor('voice'),
    currency: voice.currency,
    channel: 'voice',
  );
}

void _startVideo(BuildContext context, Astrologer a) {
  final video = a.rateFor('video');
  if (video == null || !a.isAvailable) {
    AppSnack.showTop(
      context,
      context.l10n.callVideoUnavailable,
      type: SnackType.info,
    );
    return;
  }
  if (_toldWhenBack(context, a, 'video')) return;
  showBookConsultationSheet(
    context,
    astrologerId: a.id,
    astrologerName: a.name,
    ratePerMinute: a.priceFor(video),
    offerPercent: a.offerPercentFor('video'),
    currency: video.currency,
    channel: 'video',
  );
}

void _sendGift(BuildContext context, Astrologer a) {
  showGiftSheet(
    context,
    target: ProfileGiftTarget(
      astrologerId: a.id,
      astrologerName: a.name,
      currency: context.read<AuthBloc>().state.user?.preferredCurrency ?? 'INR',
    ),
  );
}

/// Chat (primary, gold) + call / video (glass) inside the expanded header.
class _HeaderCtas extends StatelessWidget {
  const _HeaderCtas({required this.a});

  final Astrologer a;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final lead = a.leadRate;
    // Online, but with chat switched off until a time they gave.
    final chatBack = a.isAvailable ? a.nextOnlineFor('chat') : null;
    final canChat =
        a.rateFor('chat') != null && a.isAvailable && chatBack == null;
    final priceLabel = lead == null
        ? null
        : Money.format(lead.perMinute, lead.currency, locale: locale);
    final following =
        watchFollow(context, a.id, followEntryOf(a))?.following ?? false;
    final chatLabel = !a.isAvailable
        ? (following ? l.followNotifyingWhenOnline : l.astroNotifyWhenOnline)
        : chatBack != null
        ? l.astroChannelBack(l.channelChat, nextOnlineWhen(context, chatBack))
        : priceLabel != null
        ? '${l.astroChat} · ${l.astroPerMinute(priceLabel)}'
        : l.astroChat;

    return Row(
      children: [
        Expanded(
          child: _PrimaryCta(
            label: chatLabel,
            icon: chatBack != null
                ? Icons.schedule_rounded
                : a.isAvailable
                ? Icons.chat_bubble_rounded
                : following
                ? Icons.notifications_active_rounded
                : Icons.notifications_none_rounded,
            enabled: canChat,
            // offline: "Notify me when online" = follow (online pushes)
            onTap: canChat || chatBack != null
                ? () => _startChat(context, a)
                : !a.isAvailable
                ? () => toggleFollow(
                    context,
                    astrologerId: a.id,
                    astrologerName: a.name,
                    fallback: followEntryOf(a),
                  )
                : null,
          ),
        ),
        const SizedBox(width: 10),
        _GlassAction(
          icon: Icons.phone_in_talk_rounded,
          color: AstroPalette.health.start,
          tooltip: l.channelVoice,
          onTap: () => _startVoice(context, a),
        ),
        if (a.rateFor('video') != null) ...[
          const SizedBox(width: 8),
          _GlassAction(
            icon: Icons.videocam_rounded,
            color: AstroPalette.love.start,
            tooltip: l.channelVideo,
            onTap: () => _startVideo(context, a),
          ),
        ],
        const SizedBox(width: 8),
        _GlassAction(
          icon: Icons.card_giftcard_rounded,
          color: BrandColors.goldGradient[1],
          tooltip: l.giftAction,
          onTap: () => _sendGift(context, a),
        ),
      ],
    );
  }
}

class _PrimaryCta extends StatelessWidget {
  const _PrimaryCta({
    required this.label,
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool enabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const dark = Color(0xFF3A1703);
    final fg = enabled ? dark : Colors.white.withValues(alpha: 0.85);
    return Pressable(
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          boxShadow: enabled
              ? [
                  BoxShadow(
                    color: BrandColors.goldGradient.last.withValues(
                      alpha: 0.45,
                    ),
                    blurRadius: 16,
                    offset: const Offset(0, 5),
                  ),
                ]
              : null,
        ),
        child: Material(
          borderRadius: BorderRadius.circular(14),
          clipBehavior: Clip.antiAlias,
          color: Colors.transparent,
          child: Ink(
            height: 48,
            decoration: BoxDecoration(
              gradient: enabled
                  ? const LinearGradient(colors: BrandColors.goldGradient)
                  : null,
              color: enabled ? null : Colors.white.withValues(alpha: 0.12),
              border: enabled
                  ? null
                  : Border.all(color: Colors.white.withValues(alpha: 0.3)),
              borderRadius: BorderRadius.circular(14),
            ),
            child: InkWell(
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, size: 19, color: fg),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: fg,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Square glass button for the dark header.
class _GlassAction extends StatelessWidget {
  const _GlassAction({
    required this.icon,
    required this.color,
    required this.tooltip,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Pressable(
        child: Material(
          color: Colors.white.withValues(alpha: 0.12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: BorderSide(color: Colors.white.withValues(alpha: 0.28)),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: SizedBox(
              width: 48,
              height: 48,
              child: Icon(icon, color: color, size: 22),
            ),
          ),
        ),
      ),
    );
  }
}

/// Compact icon action in the collapsed toolbar.
class _BarAction extends StatelessWidget {
  const _BarAction({
    required this.icon,
    required this.tooltip,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String tooltip;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      onPressed: onTap,
      icon: Icon(icon, size: 21, color: color),
      style: IconButton.styleFrom(
        backgroundColor: Colors.white.withValues(alpha: 0.1),
        minimumSize: const Size(38, 38),
        padding: EdgeInsets.zero,
      ),
    );
  }
}

// --- loading / error chrome --------------------------------------------

/// Cosmic app bar + body, used while the profile loads or when it failed.
class _ChromeOnly extends StatelessWidget {
  const _ChromeOnly({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          backgroundColor: brand.cosmicStart,
          foregroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          systemOverlayStyle: SystemUiOverlayStyle.light,
          flexibleSpace: const CosmicBackdrop(),
          title: Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: Colors.white),
          ),
        ),
        SliverFillRemaining(hasScrollBody: false, child: child),
      ],
    );
  }
}
