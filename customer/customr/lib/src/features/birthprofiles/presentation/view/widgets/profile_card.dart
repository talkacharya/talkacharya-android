import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../../../../../core/l10n/l10n.dart';
import '../../../../../core/theme/astro_palette.dart';
import '../../../../../core/theme/brand_colors.dart';
import '../../../../../shared/widgets/pressable.dart';
import '../../../../home/data/models/zodiac.dart';
import '../../../../kundali/presentation/kundali_terms.dart';
import '../../../../matchmaking/presentation/view/widgets/match_widgets.dart'
    show relationLabel;
import '../../../data/models/birth_profile.dart';

/// Colour family + icon per relation.
(AstroHue, IconData) relationStyle(String relation) => switch (relation) {
  'self' => (AstroPalette.money, Icons.person_rounded),
  'spouse' => (AstroPalette.love, Icons.favorite_rounded),
  'child' => (AstroPalette.health, Icons.child_care_rounded),
  'parent' => (AstroPalette.career, Icons.elderly_rounded),
  'sibling' => (AstroPalette.air, Icons.group_rounded),
  'friend' => (AstroPalette.fire, Icons.people_alt_rounded),
  _ => (AstroPalette.water, Icons.person_outline_rounded),
};

/// Compact, professional birth-profile row: relation-tinted avatar, name, birth
/// details, and the **chandra rasi** computed by the engine (not a date guess).
class ProfileCard extends StatelessWidget {
  const ProfileCard({
    required this.profile,
    required this.onTap,
    this.selected = false,
    this.onLongPress,
    this.trailing,
    super.key,
  });

  final BirthProfile profile;
  final VoidCallback onTap;
  final bool selected;
  final VoidCallback? onLongPress;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final brand = context.brand;
    final p = profile;
    final (hue, icon) = relationStyle(p.relation);
    final relation = relationLabel(l, p.relation);
    final muted = theme.textTheme.labelMedium?.copyWith(color: brand.inkMuted);
    final details = [
      if (relation.isNotEmpty) relation,
      _date(context, p.birthDate),
      if (!p.timeAssumed && (p.birthTime?.isNotEmpty ?? false))
        _time(context, p.birthTime!),
    ].join(' · ');
    const activeHue = AstroPalette.health;

    return Pressable(
      child: Material(
        color: theme.colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: selected ? activeHue.end : brand.hairline,
            width: selected ? 1.4 : 1,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                _Avatar(name: p.displayName, hue: hue, icon: icon),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              p.displayName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          if (p.isPrimary) ...[
                            const SizedBox(width: 6),
                            Icon(
                              Icons.star_rounded,
                              size: 16,
                              color: AstroPalette.money.start,
                            ),
                          ],
                          if (selected) ...[
                            const SizedBox(width: 6),
                            const _ActiveChip(hue: activeHue),
                          ],
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        details,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: muted,
                      ),
                      if (p.birthPlaceName.isNotEmpty) ...[
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 13,
                              color: brand.inkMuted,
                            ),
                            const SizedBox(width: 3),
                            Expanded(
                              child: Text(
                                p.birthPlaceName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: muted,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                trailing ?? _RasiBadge(signs: p.signs),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static String _date(BuildContext context, String iso) {
    final d = DateTime.tryParse(iso);
    if (d == null) return iso;
    return DateFormat.yMMMd(
      Localizations.localeOf(context).toLanguageTag(),
    ).format(d);
  }

  static String _time(BuildContext context, String hms) {
    final parts = hms.split(':');
    if (parts.length < 2) return hms;
    final h = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    if (h == null || m == null) return hms;
    return DateFormat.jm(
      Localizations.localeOf(context).toLanguageTag(),
    ).format(DateTime(2000, 1, 1, h, m));
  }
}

/// The chandra rasi: sign glyph in its element colour, the sign name, "Moon sign".
class _RasiBadge extends StatelessWidget {
  const _RasiBadge({required this.signs});
  final ProfileSigns? signs;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final brand = context.brand;
    final sign = ZodiacSign.forProfileSign(signs?.moonSign);
    if (sign == null) {
      // Engine couldn't compute it — say nothing rather than guess from the date.
      return const SizedBox(width: 4);
    }
    final hue = AstroPalette.element(sign.index);
    return SizedBox(
      width: 64,
      child: Column(
        children: [
          Container(
            width: 38,
            height: 38,
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: hue.tint(0.14),
              shape: BoxShape.circle,
              border: Border.all(color: hue.tint(0.3)),
            ),
            child: SvgPicture.asset(sign.svgPath),
          ),
          const SizedBox(height: 4),
          Text(
            KTerms.signName(l, sign.label),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: hue.end,
            ),
          ),
          Text(
            l.birthDetailsMoonSign,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelSmall?.copyWith(
              color: brand.inkMuted,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.name, required this.hue, required this.icon});

  final String name;
  final AstroHue hue;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final surface = Theme.of(context).colorScheme.surface;
    final trimmed = name.trim();
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: hue.tint(0.14),
            border: Border.all(color: hue.tint(0.28)),
          ),
          alignment: Alignment.center,
          child: Text(
            trimmed.isEmpty ? '?' : trimmed.characters.first.toUpperCase(),
            style: TextStyle(
              color: hue.end,
              fontWeight: FontWeight.w800,
              fontSize: 19,
            ),
          ),
        ),
        Positioned(
          right: -2,
          bottom: -2,
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: hue.linear(),
              border: Border.all(color: surface, width: 2),
            ),
            child: Icon(icon, size: 10, color: Colors.white),
          ),
        ),
      ],
    );
  }
}

class _ActiveChip extends StatelessWidget {
  const _ActiveChip({required this.hue});
  final AstroHue hue;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(5, 1, 7, 1),
      decoration: BoxDecoration(
        color: hue.tint(0.14),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle_rounded, size: 11, color: hue.end),
          const SizedBox(width: 3),
          Text(
            'Active',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: hue.end,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
