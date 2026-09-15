import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/router/routes.dart';
import '../../../../../core/theme/astro_palette.dart';
import '../../../../../shared/widgets/pressable.dart';
import 'home_shared.dart';
import 'package:customr/src/core/l10n/l10n.dart';

/// Intent routing: tap a life area, land in discovery searched for it. Backend
/// skills are disciplines (Vedic, Tarot…), so concerns route via the `q=` text
/// search which matches astrologer headlines/bios.
class ConcernChips extends StatelessWidget {
  const ConcernChips({super.key});

  static const _concerns = <(String, IconData, AstroHue)>[
    ('Love', Icons.favorite_rounded, AstroPalette.love),
    (
      'Marriage',
      Icons.diversity_1_rounded,
      AstroHue(Color(0xFFF472B6), Color(0xFFA21CAF)),
    ),
    ('Career', Icons.work_rounded, AstroPalette.career),
    ('Finance', Icons.savings_rounded, AstroPalette.money),
    ('Health', Icons.health_and_safety_rounded, AstroPalette.health),
    ('Education', Icons.school_rounded, AstroPalette.water),
    ('Business', Icons.storefront_rounded, AstroPalette.fire),
    (
      'Legal',
      Icons.gavel_rounded,
      AstroHue(Color(0xFFA78BFA), Color(0xFF6D28D9)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: context.l10n.homeWhatsOnYourMind,
          hue: AstroPalette.love,
        ),
        const SizedBox(height: 14),
        Padding(
          padding: HomeGaps.sidePad,
          child: GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 10,
            childAspectRatio: 0.76,
            padding: EdgeInsets.zero,
            children: [
              for (final (label, icon, hue) in _concerns)
                Pressable(
                  child: HueTile(
                    hue: hue,
                    radius: 20,
                    padding: const EdgeInsets.fromLTRB(2, 8, 2, 6),
                    onTap: () => context.go(
                      Routes.astrologersWith(query: label.toLowerCase()),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        HueIcon(hue: hue, icon: icon, size: 38, iconSize: 19),
                        const SizedBox(height: 7),
                        Text(
                          label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
