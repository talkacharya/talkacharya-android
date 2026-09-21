import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/l10n/l10n.dart';
import '../../../../../core/router/routes.dart';
import '../../../../../core/theme/astro_palette.dart';
import '../../../../../shared/widgets/pressable.dart';
import 'dash_shared.dart';

/// Shortcut tiles to the astrologer's most-used tools.
class QuickActionsGrid extends StatelessWidget {
  const QuickActionsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    // Root-level routes are pushed; routes inside another tab are `go`ne so
    // the right branch is selected.
    final actions = [
      (
        AstroPalette.love,
        Icons.videocam_rounded,
        l.dashActionGoLive,
        () => context.push(Routes.goLive),
      ),
      (
        AstroPalette.career,
        Icons.insights_rounded,
        l.dashActionPredictions,
        () => context.push(Routes.predictions),
      ),
      (
        AstroPalette.money,
        Icons.currency_rupee_rounded,
        l.dashActionRates,
        () => context.go(Routes.profileRates),
      ),
      (
        AstroPalette.air,
        Icons.schedule_rounded,
        l.dashActionHours,
        () => context.go(Routes.profileWorkingHours),
      ),
      (
        AstroPalette.fire,
        Icons.reviews_rounded,
        l.dashActionReviews,
        () => context.go(Routes.profileReviews),
      ),
      (
        AstroPalette.health,
        Icons.account_balance_rounded,
        l.dashActionPayouts,
        () => context.go(Routes.earnings),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(title: l.dashQuickActions, hue: AstroPalette.money),
        const SizedBox(height: 12),
        Padding(
          padding: DashGaps.sidePad,
          child: GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.85,
            children: [
              for (final (hue, icon, label, onTap) in actions)
                Pressable(
                  child: HueTile(
                    hue: hue,
                    onTap: onTap,
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        HueIcon(hue: hue, icon: icon),
                        const SizedBox(height: 4),
                        Text(
                          label,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(fontWeight: FontWeight.w500),
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
