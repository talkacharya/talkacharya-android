import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/router/routes.dart';
import '../../../../../core/theme/astro_palette.dart';
import '../../../../../core/theme/brand_colors.dart';
import '../../../../birthprofiles/presentation/bloc/birth_profiles_cubit.dart';
import '../../../data/models/panchang.dart';
import '../../cubit/home_cubit.dart';
import 'home_shared.dart';
import 'package:customr/src/core/l10n/l10n.dart';

/// Today's panchang. Needs a birth profile (for the location); prompts to add
/// one when there is none.
/// Redesigned with warm gradient cards and golden accents.
class PanchangStrip extends StatelessWidget {
  const PanchangStrip({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HomeCubit>();
    final panchang = context.select((HomeCubit c) => c.state.panchang);
    // The user has genuinely no birth profile (as opposed to just none picked —
    // in that case the home cubit falls back to the primary chart).
    final noProfileAtAll = context.select(
      (BirthProfilesCubit c) =>
          c.state.status == BpStatus.ready && c.state.profiles.isEmpty,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: context.l10n.homePanchangTitle,
          hue: AstroPalette.money,
          onSeeAll: () => context.push(Routes.panchang),
        ),
        const SizedBox(height: 14),
        SectionSwitcher(
          child: panchang.when(
            idle: () => const _PanchangSkeleton(),
            loading: () => const _PanchangSkeleton(),
            error: (msg) => Padding(
              padding: HomeGaps.sidePad,
              child: (msg == 'no-profile')
                  ? (noProfileAtAll
                        ? _AddProfilePrompt()
                        // profiles exist but none resolved yet — still settling
                        : const _PanchangSkeleton())
                  : SectionError(
                      onRetry: cubit.retryPanchang,
                      label: "Couldn't load the panchang",
                    ),
            ),
            data: (p) =>
                p.isEmpty ? const SizedBox.shrink() : _PanchangRow(panchang: p),
          ),
        ),
      ],
    );
  }
}

/// Panchang limb → icon + colour family.
const _limbs = <String, (IconData, AstroHue)>{
  'Tithi': (Icons.dark_mode_rounded, AstroPalette.air),
  'Nakshatra': (Icons.auto_awesome_rounded, AstroPalette.career),
  'Yoga': (Icons.self_improvement_rounded, AstroPalette.health),
  'Sunrise': (Icons.wb_sunny_rounded, AstroPalette.money),
  'Sunset': (Icons.wb_twilight_rounded, AstroPalette.fire),
};

class _PanchangRow extends StatelessWidget {
  const _PanchangRow({required this.panchang});
  final Panchang panchang;

  @override
  Widget build(BuildContext context) {
    final p = panchang;
    final items = <(String, String, bool)>[
      if (p.tithi != null) ('Tithi', p.tithi!, false),
      if (p.nakshatra != null) ('Nakshatra', p.nakshatra!, false),
      if (p.yoga != null) ('Yoga', p.yoga!, false),
      if (p.sunrise != null) ('Sunrise', p.sunrise!, false),
      if (p.sunset != null) ('Sunset', p.sunset!, false),
    ];

    return SizedBox(
      height: 96,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(HomeGaps.side, 0, HomeGaps.side, 8),
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, i) {
          final (label, value, warn) = items[i];
          final theme = Theme.of(context);
          final (icon, hue) =
              _limbs[label] ?? (Icons.circle, AstroPalette.money);
          return ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 118),
            child: HueTile(
              hue: hue,
              radius: 18,
              padding: const EdgeInsets.fromLTRB(12, 10, 16, 10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  HueIcon(hue: hue, icon: icon, size: 36, iconSize: 18),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        label.toUpperCase(),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: hue.end,
                          letterSpacing: 0.8,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        value,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: warn ? context.brand.live : null,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _AddProfilePrompt extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brand = context.brand;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [brand.tint, brand.glowAccent.withValues(alpha: 0.06)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(Icons.wb_twilight_rounded, color: brand.glowAccent),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Add your birth details for a panchang tuned to your place.',
              style: theme.textTheme.bodySmall,
            ),
          ),
          TextButton(
            onPressed: () => context.push(Routes.birthProfileNew),
            child: Text(context.l10n.homeAddBtn),
          ),
        ],
      ),
    );
  }
}

class _PanchangSkeleton extends StatelessWidget {
  const _PanchangSkeleton();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 96,
      child: HomeShimmer(
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: HomeGaps.sidePad,
          itemCount: 4,
          separatorBuilder: (_, _) => const SizedBox(width: 10),
          itemBuilder: (_, _) => Container(
            width: 132,
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
          ),
        ),
      ),
    );
  }
}
