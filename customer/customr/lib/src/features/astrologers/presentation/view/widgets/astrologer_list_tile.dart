import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/l10n/l10n.dart';
import '../../../../../core/router/routes.dart';
import '../../../../../core/theme/astro_palette.dart';
import '../../../../../core/theme/brand_colors.dart';
import '../../../../../core/util/money.dart';
import '../../../../../shared/widgets/pressable.dart';
import '../../../data/models/astrologer.dart';

/// Compact, professional discovery row: plain surface, hairline border, a small
/// avatar, one line each for skills and trust signals, price + CTA on the right.
class AstrologerListTile extends StatelessWidget {
  const AstrologerListTile({required this.astrologer, this.channel, super.key});

  final Astrologer astrologer;
  final String? channel;

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
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Avatar(astrologer: a),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              a.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w700,
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
                      const SizedBox(height: 1),
                      Text(
                        a.skillsLabel.isEmpty
                            ? l.astroDefaultSkill
                            : a.skillsLabel,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: muted,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.star_rounded, size: 14, color: brand.gold),
                          const SizedBox(width: 2),
                          Text(
                            a.ratingAvg > 0
                                ? a.ratingAvg.toStringAsFixed(1)
                                : l.astroRatingNew,
                            style: theme.textTheme.labelMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          if (a.ratingCount > 0)
                            Text(' (${_compact(a.ratingCount)})', style: muted),
                          if (a.yearsExperience > 0) ...[
                            _Dot(color: brand.inkMuted),
                            Text('${a.yearsExperience} yrs', style: muted),
                          ],
                          if (langs.isNotEmpty) ...[
                            _Dot(color: brand.inkMuted),
                            Flexible(
                              child: Text(
                                langs,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: muted,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      rate == null
                          ? '—'
                          : l.astroPerMinute(
                              Money.format(
                                rate.perMinute,
                                rate.currency,
                                locale: locale,
                              ),
                            ),
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _Cta(
                      available: available,
                      icon: available
                          ? _ctaIcon()
                          : Icons.notifications_none_rounded,
                      label: available ? _ctaLabel(l) : l.homeNotifyMeBtn,
                      onTap: open,
                    ),
                  ],
                ),
              ],
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

  static String _compact(int n) {
    if (n >= 100000) return '${(n / 100000).toStringAsFixed(1)}L';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}k';
    return '$n';
  }
}

/// Photo, or a soft tinted circle with the initial in the astrologer's colour.
class _Avatar extends StatelessWidget {
  const _Avatar({required this.astrologer});
  final Astrologer astrologer;

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    final surface = Theme.of(context).colorScheme.surface;
    final a = astrologer;
    final hue = AstroPalette.forId(a.id);
    final url = a.avatar;
    final name = a.name.trim();
    const size = 52.0;

    final initial = Center(
      child: Text(
        name.isEmpty ? '★' : name.characters.first.toUpperCase(),
        style: TextStyle(
          color: hue.end,
          fontWeight: FontWeight.w800,
          fontSize: 20,
        ),
      ),
    );

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: hue.tint(0.14),
            border: Border.all(color: hue.tint(0.25)),
          ),
          clipBehavior: Clip.antiAlias,
          child: (url != null && url.isNotEmpty)
              ? Image.network(
                  url,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => initial,
                )
              : initial,
        ),
        Positioned(
          right: 0,
          bottom: 0,
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
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 5),
    child: Container(
      width: 3,
      height: 3,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.6),
        shape: BoxShape.circle,
      ),
    ),
  );
}

/// Outlined, compact CTA — green when the astrologer can take a session now.
class _Cta extends StatelessWidget {
  const _Cta({
    required this.available,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final bool available;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brand = context.brand;
    final color = available ? brand.online : brand.inkMuted;
    return SizedBox(
      height: 32,
      child: OutlinedButton.icon(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          foregroundColor: color,
          backgroundColor: available
              ? brand.online.withValues(alpha: 0.06)
              : null,
          side: BorderSide(
            color: color.withValues(alpha: available ? 0.9 : 0.4),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          minimumSize: const Size(0, 32),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: theme.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        icon: Icon(icon, size: 15),
        label: Text(label),
      ),
    );
  }
}
