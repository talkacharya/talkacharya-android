import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'package:animations/animations.dart';

import '../../../../../core/l10n/l10n.dart';
import '../../../../../core/util/money.dart';
import '../../../../follows/presentation/widgets/follow_widgets.dart';
import '../../../data/models/astrologer.dart';
import '../../channel_availability.dart';
import '../astrologer_detail_page.dart';

import 'package:talkacharya_ui/talkacharya_ui.dart';

/// Discovery row: rounded-rect photo with a bottom scrim carrying rating and
/// price, name + follow heart on the right. The whole card opens the profile.
class AstrologerListTile extends StatelessWidget {
  const AstrologerListTile({required this.astrologer, this.channel, super.key});

  final Astrologer astrologer;
  final String? channel;

  static const double _photoW = 84;
  static const double _photoH = 92;

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
    // Online, but not taking the kind of consultation this list is for.
    final wanted = channel ?? 'chat';
    final closedLine = available ? channelClosedLine(context, a, wanted) : null;
    final langs = a.languages
        .take(3)
        .map(
          (lang) => (lang.code.isEmpty ? lang.name : lang.code).toUpperCase(),
        )
        .join(', ');
    final muted = theme.textTheme.labelMedium?.copyWith(color: brand.inkMuted);

    // compact "₹16/m" so it fits beside the rating on the photo
    final priceText = rate == null
        ? '—'
        : '${Money.format(a.priceFor(rate), rate.currency, locale: locale)}/m';
    return Pressable(
      child: OpenContainer(
        useRootNavigator: true,
        transitionType: ContainerTransitionType.fade,
        closedElevation: 0,
        openElevation: 0,
        closedColor: theme.colorScheme.surface,
        openColor: brand.canvas,
        middleColor: brand.cosmicStart,
        closedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: brand.hairline),
        ),
        openBuilder: (context, _) => AstrologerDetailPage(astrologerId: a.id),
        closedBuilder: (context, openContainer) {
          return InkWell(
            onTap: openContainer,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Hero(
                      tag: 'astrologer_photo_${a.id}',
                      child: _PhotoBox(
                        astrologer: a,
                        width: _photoW,
                        height: _photoH,
                        ratingText: a.ratingAvg > 0
                            ? a.ratingAvg.toStringAsFixed(1)
                            : l.astroRatingNew,
                        priceText: priceText,
                      ),
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
                                                child: Shimmer.fromColors(
                                                  baseColor:
                                                      AstroPalette.air.end,
                                                  highlightColor: Colors.white,
                                                  period: const Duration(
                                                    milliseconds: 2500,
                                                  ),
                                                  child: Icon(
                                                    Icons.verified_rounded,
                                                    size: 16,
                                                    color: AstroPalette.air.end,
                                                  ),
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
                              if (closedLine != null)
                                Row(
                                  children: [
                                    Icon(
                                      a.stateOf(wanted) ==
                                              ChannelState.backLater
                                          ? Icons.schedule_rounded
                                          : Icons.do_not_disturb_on_rounded,
                                      size: 13,
                                      color: AstroPalette.fire.end,
                                    ),
                                    const SizedBox(width: 4),
                                    Flexible(
                                      child: Text(
                                        closedLine,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: muted?.copyWith(
                                          color: AstroPalette.fire.end,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              else
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
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
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
                  ? CachedNetworkImage(
                      imageUrl: url,
                      fit: BoxFit.cover,
                      placeholder: (_, _) => initial,
                      errorWidget: (_, _, _) => initial,
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
                  color: !a.isAvailable
                      ? brand.hairline
                      : a.isBusy
                      ? const Color(0xFFFBBF24)
                      : brand.online,
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
