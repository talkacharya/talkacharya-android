import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/l10n/l10n.dart';
import '../../../../../core/router/routes.dart';
import '../../../../waitlist/presentation/cubit/waitlist_cubit.dart';
import 'dash_shared.dart';

import 'package:talkacharya_ui/talkacharya_ui.dart';

/// Shortcut tiles to everything the astrologer works with, four to a row.
class QuickActionsGrid extends StatelessWidget {
  const QuickActionsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final waiting = context.select((WaitlistCubit c) => c.state.count);
    // Root-level routes are pushed; routes inside another tab are `go`ne so
    // the right branch is selected.
    final actions = <_Action>[
      _Action(
        AstroPalette.love,
        Icons.videocam_rounded,
        l.dashActionGoLive,
        () => context.push(Routes.goLive),
      ),
      _Action(
        AstroPalette.air,
        Icons.groups_rounded,
        l.dashActionWaitlist,
        () => context.push(Routes.waitlist),
        badge: waiting,
      ),
      _Action(
        AstroPalette.health,
        Icons.call_rounded,
        l.dashActionCalls,
        () => context.push(Routes.callHistory),
      ),
      _Action(
        AstroPalette.career,
        Icons.forum_rounded,
        l.dashActionChats,
        () => context.go(Routes.chats),
      ),
      _Action(
        AstroPalette.earth,
        Icons.spa_rounded,
        l.dashActionRemedies,
        () => context.push(Routes.remedies),
      ),
      _Action(
        AstroPalette.career,
        Icons.insights_rounded,
        l.dashActionPredictions,
        () => context.push(Routes.predictions),
      ),
      _Action(
        AstroPalette.health,
        Icons.speed_rounded,
        l.dashActionPerformance,
        () => context.push(Routes.performance),
      ),
      _Action(
        AstroPalette.love,
        Icons.favorite_rounded,
        l.dashActionWinBack,
        () => context.push(Routes.winBack),
      ),
      _Action(
        AstroPalette.fire,
        Icons.notifications_active_rounded,
        l.dashActionRequests,
        () => context.go(Routes.requests),
      ),
      _Action(
        AstroPalette.fire,
        Icons.reviews_rounded,
        l.dashActionReviews,
        () => context.go(Routes.profileReviews),
      ),
      _Action(
        AstroPalette.money,
        Icons.currency_rupee_rounded,
        l.dashActionRates,
        () => context.go(Routes.profileRates),
      ),
      _Action(
        AstroPalette.air,
        Icons.schedule_rounded,
        l.dashActionHours,
        () => context.go(Routes.profileWorkingHours),
      ),
      _Action(
        AstroPalette.health,
        Icons.account_balance_rounded,
        l.dashActionPayouts,
        () => context.go(Routes.earnings),
      ),
      _Action(
        AstroPalette.career,
        Icons.rocket_launch_rounded,
        l.dashActionBoost,
        () => context.go(Routes.profileFeatured),
      ),
      _Action(
        AstroPalette.water,
        Icons.notifications_rounded,
        l.dashActionAlerts,
        () => context.push(Routes.notifications),
      ),
      _Action(
        AstroPalette.money,
        Icons.volume_up_rounded,
        l.dashActionSounds,
        () => context.go(Routes.profileSound),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(title: l.dashTools, hue: AstroPalette.money),
        const SizedBox(height: 12),
        Padding(
          padding: DashGaps.sidePad,
          child: GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 0.74,
            children: [for (final a in actions) _Tile(action: a)],
          ),
        ),
      ],
    );
  }
}

class _Action {
  const _Action(this.hue, this.icon, this.label, this.onTap, {this.badge = 0});

  final AstroHue hue;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  /// A count on the tile's corner; hidden at zero.
  final int badge;
}

class _Tile extends StatelessWidget {
  const _Tile({required this.action});

  final _Action action;

  @override
  Widget build(BuildContext context) {
    final a = action;
    return Pressable(
      child: HueTile(
        hue: a.hue,
        onTap: a.onTap,
        padding: const EdgeInsets.fromLTRB(4, 10, 4, 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Badge.count(
              count: a.badge,
              isLabelVisible: a.badge > 0,
              child: HueIcon(hue: a.hue, icon: a.icon, size: 40, iconSize: 20),
            ),
            const SizedBox(height: 6),
            Text(
              a.label,
              maxLines: 2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w600,
                height: 1.15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
