import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/l10n/l10n.dart';
import '../../../../../core/router/routes.dart';
import '../../../../../core/theme/astro_palette.dart';
import '../../../../../core/theme/brand_colors.dart';
import '../../../../../shared/widgets/pressable.dart';
import '../../../../astrologers/data/models/astrologer.dart';
import 'home_shared.dart';

/// Height of [AstrologerCard] — rails size themselves from it.
const double kAstrologerCardHeight = 236;

/// Discovery card for the "Talk to an astrologer" rail: a gradient cover in the
/// astrologer's own colour, the face floating over it, then the essentials and a
/// matching CTA.
class AstrologerCard extends StatelessWidget {
  const AstrologerCard({required this.astrologer, this.width = 184, super.key});

  final Astrologer astrologer;
  final double width;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brand = context.brand;
    final l = context.l10n;
    final a = astrologer;
    final hue = HomeHues.forId(a.id);
    final rate = a.cheapestRate;
    final available = a.isAvailable;
    final surface = theme.colorScheme.surface;
    void open() => context.go(Routes.astrologer(a.id));

    return Pressable(
      child: Container(
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: hue.start.withValues(alpha: 0.16),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Material(
          color: surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: BorderSide(color: brand.hairline),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: open,
            child: Stack(
              children: [
                // Cover: the astrologer's banner, or their colour gradient.
                SizedBox(
                  height: 66,
                  width: double.infinity,
                  child: DecoratedBox(
                    decoration: BoxDecoration(gradient: hue.linear()),
                    child: (a.banner?.isNotEmpty ?? false)
                        ? Stack(
                            fit: StackFit.expand,
                            children: [
                              CachedNetworkImage(
                                imageUrl: a.banner!,
                                fit: BoxFit.cover,
                                fadeInDuration: const Duration(
                                  milliseconds: 200,
                                ),
                                errorWidget: (_, _, _) => const CustomPaint(
                                  painter: _SparklePainter(),
                                ),
                              ),
                              // Keeps the presence badge legible on bright photos.
                              const DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Color(0x59000000),
                                      Color(0x00000000),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                        : const CustomPaint(painter: _SparklePainter()),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: _PresenceBadge(available: available),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 30, 14, 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: surface,
                        ),
                        child: HueAvatar(
                          name: a.name,
                          url: a.avatar,
                          hue: hue,
                          size: 54,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              a.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          if (a.isVerified) ...[
                            const SizedBox(width: 4),
                            Icon(
                              Icons.verified_rounded,
                              size: 15,
                              color: AstroPalette.air.end,
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        a.skillsLabel.isEmpty
                            ? 'Vedic astrology'
                            : a.skillsLabel,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: brand.inkMuted,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _MetaChip(
                            icon: Icons.star_rounded,
                            iconColor: brand.gold,
                            label: a.ratingAvg > 0
                                ? a.ratingAvg.toStringAsFixed(1)
                                : 'New',
                          ),
                          if (a.yearsExperience > 0) ...[
                            const SizedBox(width: 6),
                            _MetaChip(
                              icon: Icons.workspace_premium_rounded,
                              iconColor: hue.end,
                              label: '${a.yearsExperience}y',
                            ),
                          ],
                          const Spacer(),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: rate == null
                                      ? '—'
                                      : '₹${_fmt(rate.perMinute)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                TextSpan(
                                  text: rate == null ? '' : '/min',
                                  style: TextStyle(
                                    color: brand.inkMuted,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                            style: theme.textTheme.titleSmall,
                          ),
                        ],
                      ),
                      const Spacer(),
                      _CardCta(
                        hue: hue,
                        available: available,
                        label: available ? 'Chat' : l.homeNotifyMeBtn,
                        onTap: open,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static String _fmt(double v) =>
      v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toStringAsFixed(2);
}

class _PresenceBadge extends StatelessWidget {
  const _PresenceBadge({required this.available});
  final bool available;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(7, 3, 9, 3),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: available
                  ? const Color(0xFF4ADE80)
                  : Colors.white.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(width: 5),
          Text(
            available ? 'Online' : 'Busy',
            style: theme.textTheme.labelSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({
    required this.icon,
    required this.iconColor,
    required this.label,
  });

  final IconData icon;
  final Color iconColor;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(5, 2, 7, 2),
      decoration: BoxDecoration(
        color: iconColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: iconColor),
          const SizedBox(width: 3),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _CardCta extends StatelessWidget {
  const _CardCta({
    required this.hue,
    required this.available,
    required this.label,
    required this.onTap,
  });

  final AstroHue hue;
  final bool available;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fg = available ? Colors.white : hue.end;
    return Material(
      borderRadius: BorderRadius.circular(14),
      clipBehavior: Clip.antiAlias,
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          gradient: available ? hue.linear() : null,
          color: available ? null : hue.tint(0.1),
          borderRadius: BorderRadius.circular(14),
        ),
        child: InkWell(
          onTap: onTap,
          child: SizedBox(
            height: 40,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  available
                      ? Icons.chat_bubble_rounded
                      : Icons.notifications_active_outlined,
                  size: 16,
                  color: fg,
                ),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: fg,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A few white sparkles and dots on the card cover.
class _SparklePainter extends CustomPainter {
  const _SparklePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final rnd = math.Random(5);
    final p = Paint();
    for (var i = 0; i < 14; i++) {
      p.color = Colors.white.withValues(alpha: 0.15 + rnd.nextDouble() * 0.35);
      canvas.drawCircle(
        Offset(rnd.nextDouble() * size.width, rnd.nextDouble() * size.height),
        rnd.nextDouble() * 1.4 + 0.4,
        p,
      );
    }
    canvas.drawCircle(
      Offset(size.width * 0.78, size.height * 1.05),
      size.height * 0.9,
      Paint()..color = Colors.white.withValues(alpha: 0.10),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
