import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/l10n/l10n.dart';
import '../../../../../core/router/routes.dart';
import '../../../../../core/theme/astro_palette.dart';
import '../../../../../core/theme/brand_colors.dart';
import '../../../../../core/util/money.dart';
import '../../../../../shared/widgets/pressable.dart';
import '../../../../follows/data/follows_api.dart';
import '../../../../follows/presentation/widgets/follow_widgets.dart';
import '../../../data/models/astrologer.dart';

/// Discovery row: rounded-rect photo with a bottom scrim carrying rating and
/// price, name + follow heart on the right, and an icon-only CTA.
class AstrologerListTile extends StatelessWidget {
  const AstrologerListTile({required this.astrologer, this.channel, super.key});

  final Astrologer astrologer;
  final String? channel;

  static const double _photoW = 100;
  static const double _photoH = 100;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final brand = context.brand;
    final a = astrologer;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final rate =
        (channel != null ? a.rateFor(channel!) : null) ?? a.cheapestRate;
    final available = a.isAvailable;
    final langs = a.languages
        .take(3)
        .map(
          (lang) => (lang.code.isEmpty ? lang.name : lang.code).toUpperCase(),
        )
        .join(', ');
    final muted = theme.textTheme.labelMedium?.copyWith(color: brand.inkMuted);
    void open() => context.go(Routes.astrologer(a.id));

    // compact "₹16/m" so it fits beside the rating on the photo
    final priceText = rate == null
        ? '—'
        : '${Money.format(rate.perMinute, rate.currency, locale: locale)}/m';
    return Pressable(
      child: Material(
        color: theme.colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: brand.hairline),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: open,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _PhotoBox(
                    astrologer: a,
                    width: _photoW,
                    height: _photoH,
                    ratingText: a.ratingAvg > 0
                        ? a.ratingAvg.toStringAsFixed(1)
                        : l.astroRatingNew,
                    priceText: priceText,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text.rich(
                                    TextSpan(
                                      text: a.name,
                                      children: [
                                        if (a.isVerified)
                                          WidgetSpan(
                                            alignment:
                                                PlaceholderAlignment.middle,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                left: 4,
                                              ),
                                              child: Icon(
                                                Icons.verified_rounded,
                                                size: 16,
                                                color: AstroPalette.air.end,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.w700,
                                          height: 1.2,
                                        ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                FollowIconToggle(
                                  astrologerId: a.id,
                                  astrologerName: a.name,
                                  fallback: followEntryOf(a),
                                  size: 26,
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              a.skillsLabel.isEmpty
                                  ? l.astroDefaultSkill
                                  : a.skillsLabel,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: muted,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              [
                                if (a.yearsExperience > 0)
                                  '${a.yearsExperience} yrs',
                                if (langs.isNotEmpty) langs,
                              ].join('  ·  '),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: muted,
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: available
                              ? _Cta(
                                  available: true,
                                  icon: _ctaIcon(),
                                  tooltip: _ctaLabel(l),
                                  onTap: open,
                                )
                              : _NotifyCta(astrologer: a),
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
    );
  }

  IconData _ctaIcon() => switch (channel) {
    'voice' => Icons.call_rounded,
    'video' => Icons.videocam_rounded,
    _ => Icons.chat_bubble_outline_rounded,
  };

  String _ctaLabel(AppLocalizations l) => switch (channel) {
    'voice' => l.channelCall,
    'video' => l.channelVideo,
    _ => l.channelChat,
  };
}

/// Rounded-rect photo (or tinted initial fallback) with a bottom gradient mask
/// that carries the rating and price, plus the online dot at top-left.
/// Rounded-rect photo (or tinted initial fallback) with a bottom gradient mask
/// carrying rating and price on a single row, plus the online dot at top-left.
class _PhotoBox extends StatelessWidget {
  const _PhotoBox({
    required this.astrologer,
    required this.width,
    required this.height,
    required this.ratingText,
    required this.priceText,
  });

  final Astrologer astrologer;
  final double width;
  final double height;
  final String ratingText;
  final String priceText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brand = context.brand;
    final surface = theme.colorScheme.surface;
    final a = astrologer;
    final hue = AstroPalette.forId(a.id);
    final url = a.avatar;
    final name = a.name.trim();

    final initial = Center(
      child: Text(
        name.isEmpty ? '★' : name.characters.first.toUpperCase(),
        style: TextStyle(
          color: hue.end,
          fontWeight: FontWeight.w800,
          fontSize: 34,
        ),
      ),
    );

    const onImage = Colors.white;
    final smallStyle = theme.textTheme.labelSmall?.copyWith(
      color: onImage,
      fontSize: 11,
      fontWeight: FontWeight.w700,
      height: 1.1,
    );

    return SizedBox(
      width: width,
      height: height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // photo / fallback
            DecoratedBox(
              decoration: BoxDecoration(
                color: hue.tint(0.14),
                border: Border.all(color: hue.tint(0.25)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: (url != null && url.isNotEmpty)
                  ? Image.network(
                      url,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => initial,
                    )
                  : initial,
            ),
            // bottom mask
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: height * 0.4,
              child: const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0x00000000), Color(0xCC000000)],
                  ),
                ),
              ),
            ),
            // rating + price on one row over the mask
            Positioned(
              left: 8,
              right: 8,
              bottom: 6,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star_rounded, size: 12, color: brand.gold),
                    const SizedBox(width: 2),
                    Text(ratingText, style: smallStyle),
                    const SizedBox(width: 8),
                    Text(
                      priceText,
                      maxLines: 1,
                      style: smallStyle?.copyWith(fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
              ),
            ),
            // online dot
            Positioned(
              left: 6,
              top: 6,
              child: Container(
                width: 13,
                height: 13,
                decoration: BoxDecoration(
                  color: a.isAvailable ? brand.online : brand.hairline,
                  shape: BoxShape.circle,
                  border: Border.all(color: surface, width: 2),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Offline astrologer: bell icon follows them (online pushes); active bell
/// once followed — tapping again unfollows.
class _NotifyCta extends StatelessWidget {
  const _NotifyCta({required this.astrologer});

  final Astrologer astrologer;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final a = astrologer;
    final following =
        watchFollow(context, a.id, followEntryOf(a))?.following ?? false;
    final pending = watchFollowPending(context, a.id);
    return _Cta(
      available: false,
      highlighted: following,
      icon: following
          ? Icons.notifications_active_rounded
          : Icons.notifications_none_rounded,
      tooltip: following ? l.followNotifying : l.homeNotifyMeBtn,
      onTap: pending
          ? null
          : () => toggleFollow(
              context,
              astrologerId: a.id,
              astrologerName: a.name,
              source: FollowSource.card,
              fallback: followEntryOf(a),
            ),
    );
  }
}

/// Outlined, icon-only CTA — green when the astrologer can take a session now.
class _Cta extends StatelessWidget {
  const _Cta({
    required this.available,
    required this.icon,
    required this.tooltip,
    required this.onTap,
    this.highlighted = false,
  });

  final bool available;
  final IconData icon;
  final String tooltip; // also the accessibility label
  final VoidCallback? onTap;

  /// Offline but followed — tinted so the bell reads as switched on.
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    final color = available
        ? brand.online
        : highlighted
        ? AstroPalette.love.end
        : brand.inkMuted;
    return Tooltip(
      message: tooltip,
      child: SizedBox(
        width: 40,
        height: 36,
        child: OutlinedButton(
          onPressed: onTap,
          style: OutlinedButton.styleFrom(
            foregroundColor: color,
            backgroundColor: available
                ? brand.online.withValues(alpha: 0.06)
                : null,
            side: BorderSide(
              color: color.withValues(
                alpha: available || highlighted ? 0.9 : 0.4,
              ),
            ),
            padding: EdgeInsets.zero,
            minimumSize: const Size(40, 36),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Icon(icon, size: 18),
        ),
      ),
    );
  }
}
