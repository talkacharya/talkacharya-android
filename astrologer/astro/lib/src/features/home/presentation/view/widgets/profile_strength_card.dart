import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/astro/models/astro_profile.dart';
import '../../../../../core/astro/onboarding_store.dart';
import '../../../../../core/di/service_locator.dart';
import '../../../../../core/l10n/l10n.dart';
import '../../../../../core/router/routes.dart';
import '../../../../../core/theme/app_theme.dart';
import 'dash_shared.dart';

import 'package:talkacharya_ui/talkacharya_ui.dart';

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

/// "Profile strength" in one row: a ring, how many things are left, and a tap
/// to the first of them. Removes itself once every check passes.
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
        final theme = Theme.of(context);
        final brand = context.brand;
        const hue = AstroPalette.career;
        final ratio = done / tips.length;
        final left = tips.length - done;
        final first = tips.firstWhere((t) => !t.done);

        return Padding(
          padding: const EdgeInsets.only(bottom: DashGaps.section),
          child: Padding(
            padding: DashGaps.sidePad,
            child: Material(
              color: theme.colorScheme.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Radii.lg),
                side: BorderSide(color: brand.hairline),
              ),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () => context.go(first.route),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 8, 10),
                  child: Row(
                    children: [
                      SizedBox.square(
                        dimension: 34,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            TweenAnimationBuilder<double>(
                              tween: Tween(end: ratio),
                              duration: const Duration(milliseconds: 700),
                              curve: Curves.easeOutCubic,
                              builder: (_, v, _) => CircularProgressIndicator(
                                value: v,
                                strokeWidth: 3,
                                strokeCap: StrokeCap.round,
                                color: hue.end,
                                backgroundColor: hue.tint(0.18),
                              ),
                            ),
                            Text(
                              '${(ratio * 100).round()}',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: hue.end,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l.dashProfileTitle,
                              style: theme.textTheme.labelLarge?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              l.dashProfileLeft(left),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: brand.inkMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.chevron_right_rounded, color: brand.inkMuted),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
