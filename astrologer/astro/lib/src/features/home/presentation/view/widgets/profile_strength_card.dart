import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/astro/models/astro_profile.dart';
import '../../../../../core/astro/onboarding_store.dart';
import '../../../../../core/di/service_locator.dart';
import '../../../../../core/l10n/l10n.dart';
import '../../../../../core/router/routes.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/theme/astro_palette.dart';
import '../../../../../core/theme/brand_colors.dart';
import 'dash_shared.dart';

/// One profile-completeness check and where to fix it.
typedef ProfileTip = ({bool done, String route});

/// Completeness checks, in the order they're shown. Pure so it's testable.
List<ProfileTip> profileTips(AstroProfile p) => [
  (done: p.headline.trim().isNotEmpty, route: Routes.profileEdit),
  (done: p.bio.trim().length >= 120, route: Routes.profileEdit),
  (done: p.banner != null, route: Routes.profileEdit),
  (done: p.rates.isNotEmpty, route: Routes.profileRates),
  (done: p.languages.isNotEmpty, route: Routes.profileEdit),
  (done: p.skills.length >= 3, route: Routes.profileEdit),
];

/// "Profile strength" meter with the outstanding fixes. Removes itself once
/// every check passes.
class ProfileStrengthCard extends StatelessWidget {
  const ProfileStrengthCard({super.key});

  @override
  Widget build(BuildContext context) {
    final store = getIt<OnboardingStore>();
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final p = store.profile;
        if (p == null) return const SizedBox.shrink();
        final tips = profileTips(p);
        final done = tips.where((t) => t.done).length;
        if (done == tips.length) return const SizedBox.shrink();

        final l = context.l10n;
        final labels = [
          l.dashTipHeadline,
          l.dashTipBio,
          l.dashTipBanner,
          l.dashTipRates,
          l.dashTipLanguages,
          l.dashTipSkills,
        ];
        final theme = Theme.of(context);
        final brand = context.brand;
        const hue = AstroPalette.career;
        final ratio = done / tips.length;

        return Padding(
          padding: const EdgeInsets.only(bottom: DashGaps.section),
          child: Padding(
            padding: DashGaps.sidePad,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Radii.lg),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [hue.tint(0.16), theme.colorScheme.surface],
                ),
                border: Border.all(color: hue.tint(0.25)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const HueIcon(hue: hue, icon: Icons.verified_rounded),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l.dashProfileTitle,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              l.dashProfileHint,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: brand.inkMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '${(ratio * 100).round()}%',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: hue.end,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(end: ratio),
                      duration: const Duration(milliseconds: 700),
                      curve: Curves.easeOutCubic,
                      builder: (_, v, _) => LinearProgressIndicator(
                        value: v,
                        minHeight: 8,
                        backgroundColor: hue.tint(0.15),
                        color: hue.end,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  for (var i = 0; i < tips.length; i++)
                    if (!tips[i].done)
                      InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () => context.go(tips[i].route),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: [
                              Icon(
                                Icons.add_circle_outline_rounded,
                                size: 20,
                                color: hue.end,
                              ),
                              const SizedBox(width: 10),
                              Expanded(child: Text(labels[i])),
                              Icon(
                                Icons.chevron_right_rounded,
                                color: brand.inkMuted,
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
      },
    );
  }
}
