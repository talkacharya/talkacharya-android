import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:talkacharya_ui/talkacharya_ui.dart';

import '../../../../../core/l10n/l10n.dart';
import '../../../../../core/router/routes.dart';
import '../../../../chats/presentation/cubit/chats_cubit.dart';
import '../../../../notifications/presentation/bloc/notifications_cubit.dart';
import '../../../../requests/presentation/cubit/requests_cubit.dart';
import '../../../../waitlist/presentation/cubit/waitlist_cubit.dart';
import '../../../../workspace/presentation/view/calendar_page.dart';
import '../../cubit/tool_counts_cubit.dart';

/// One tile: where it goes, and how many things are waiting there.
class ToolAction {
  const ToolAction(
    this.hue,
    this.icon,
    this.label,
    this.onTap, {
    this.badge = 0,
  });

  final AstroHue hue;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  /// A count on the tile's corner; hidden at zero.
  final int badge;
}

class ToolGroup {
  const ToolGroup(this.title, this.actions);

  final String title;
  final List<ToolAction> actions;
}

/// Every tool the astrologer has, in the groups the All tools page shows. The
/// first eight of the first group are the ones Home keeps on its grid.
///
/// Watches the cubits that hold the counts, so the caller rebuilds when one
/// changes. Root-level routes are pushed; routes inside another tab are
/// `go`ne so the right branch is selected.
List<ToolGroup> buildToolGroups(BuildContext context) {
  final l = context.l10n;
  final waiting = context.select((WaitlistCubit c) => c.state.count);
  final requests = context.select((RequestsCubit c) => c.state.incoming.length);
  final unread = context.select((ChatsCubit c) => c.state.totalUnread);
  final alerts = context.select((NotificationsCubit c) => c.state.unreadCount);
  final counts = context.watch<ToolCountsCubit>().state;

  return [
    ToolGroup(l.toolsGroupWork, [
      ToolAction(
        AstroPalette.love,
        Icons.videocam_rounded,
        l.dashActionGoLive,
        () => context.push(Routes.goLive),
      ),
      ToolAction(
        AstroPalette.fire,
        Icons.notifications_active_rounded,
        l.dashActionRequests,
        () => context.go(Routes.requests),
        badge: requests,
      ),
      ToolAction(
        AstroPalette.air,
        Icons.groups_rounded,
        l.dashActionWaitlist,
        () => context.push(Routes.waitlist),
        badge: waiting,
      ),
      ToolAction(
        AstroPalette.health,
        Icons.call_rounded,
        l.dashActionCalls,
        () => context.push(Routes.callHistory),
        badge: counts.missedCalls,
      ),
      ToolAction(
        AstroPalette.career,
        Icons.forum_rounded,
        l.dashActionChats,
        () => context.go(Routes.chats),
        badge: unread,
      ),
      ToolAction(
        AstroPalette.career,
        Icons.insights_rounded,
        l.dashActionPredictions,
        () => context.push(Routes.predictions),
        badge: counts.predictions,
      ),
      ToolAction(
        AstroPalette.earth,
        Icons.spa_rounded,
        l.dashActionRemedies,
        () => context.push(Routes.remedies),
      ),
      // Among the eight Home keeps: which types are on, next-online times
      // and the weekly hours are changed many times a day.
      ToolAction(
        AstroPalette.air,
        Icons.schedule_rounded,
        l.dashActionHours,
        () => context.go(Routes.profileWorkingHours),
      ),
      // Home's third row: the tools opened mid-consultation.
      ToolAction(
        AstroPalette.career,
        Icons.auto_awesome_rounded,
        l.ccTool,
        () => context.push(Routes.clientCharts),
      ),
      ToolAction(
        AstroPalette.love,
        Icons.favorite_border_rounded,
        l.mmTitle,
        () => context.push(Routes.matchmaking),
      ),
      ToolAction(
        AstroPalette.fire,
        Icons.temple_hindu_rounded,
        l.poojaTool,
        () => context.push(Routes.poojaCalendar),
      ),
      ToolAction(
        AstroPalette.air,
        Icons.quickreply_rounded,
        l.wsReplies,
        () => context.push(Routes.quickReplies),
      ),
      ToolAction(
        AstroPalette.health,
        Icons.speed_rounded,
        l.dashActionPerformance,
        () => context.push(Routes.performance),
      ),
      ToolAction(
        AstroPalette.health,
        Icons.event_available_rounded,
        l.poojaBookingsTool,
        () => context.push(Routes.poojaBookings),
      ),
    ]),
    ToolGroup(l.toolsGroupCustomers, [
      ToolAction(
        AstroPalette.love,
        Icons.favorite_rounded,
        l.wsFavourites,
        () => context.push(Routes.favourites),
      ),
      ToolAction(
        AstroPalette.fire,
        Icons.volunteer_activism_rounded,
        l.dashActionWinBack,
        () => context.push(Routes.winBack),
      ),
      ToolAction(
        AstroPalette.career,
        Icons.diversity_3_rounded,
        l.wsCommunity,
        () => context.push(Routes.community),
      ),
      ToolAction(
        AstroPalette.money,
        Icons.reviews_rounded,
        l.dashActionReviews,
        () => context.go(Routes.profileReviews),
      ),
    ]),
    ToolGroup(l.toolsGroupGrow, [
      ToolAction(
        AstroPalette.career,
        Icons.rocket_launch_rounded,
        l.dashActionBoost,
        () => context.go(Routes.profileFeatured),
      ),
      ToolAction(
        AstroPalette.fire,
        Icons.local_offer_rounded,
        l.offerTitle,
        () => context.push(Routes.offers),
      ),
      ToolAction(
        AstroPalette.money,
        Icons.card_giftcard_rounded,
        l.wsReferral,
        () => context.push(Routes.referral),
      ),
      ToolAction(
        AstroPalette.water,
        Icons.add_a_photo_rounded,
        l.wsGallery,
        () => context.push(Routes.gallery),
      ),
      ToolAction(
        AstroPalette.fire,
        Icons.play_circle_rounded,
        l.wsTraining,
        () => context.push(Routes.training),
      ),
    ]),
    ToolGroup(l.toolsGroupSchedule, [
      ToolAction(
        AstroPalette.health,
        Icons.calendar_month_rounded,
        l.wsCalendar,
        () => context.push(Routes.calendar),
      ),
      ToolAction(
        AstroPalette.money,
        Icons.currency_rupee_rounded,
        l.dashActionRates,
        () => context.go(Routes.profileRates),
      ),
      ToolAction(
        AstroPalette.health,
        Icons.account_balance_rounded,
        l.dashActionPayouts,
        () => context.go(Routes.earnings),
      ),
    ]),
    ToolGroup(l.toolsGroupHelp, [
      ToolAction(
        AstroPalette.fire,
        Icons.flag_rounded,
        l.reportsTitle,
        () => context.push(Routes.reports),
      ),
      ToolAction(
        AstroPalette.money,
        Icons.campaign_rounded,
        l.wsAnnouncements,
        () => context.push(Routes.announcements),
        badge: counts.announcements,
      ),
      ToolAction(
        AstroPalette.water,
        Icons.notifications_rounded,
        l.dashActionAlerts,
        () => context.push(Routes.notifications),
        badge: alerts,
      ),
      ToolAction(
        AstroPalette.career,
        Icons.rate_review_rounded,
        l.wsFeedback,
        () => context.push(Routes.feedback),
      ),
      ToolAction(
        AstroPalette.health,
        Icons.support_agent_rounded,
        l.wsHelpline,
        () => showHelplineSheet(context),
      ),
      ToolAction(
        AstroPalette.money,
        Icons.volume_up_rounded,
        l.dashActionSounds,
        () => context.go(Routes.profileSound),
      ),
    ]),
  ];
}

/// A four-across grid of tool tiles.
class ToolGrid extends StatelessWidget {
  const ToolGrid({required this.actions, super.key});

  final List<ToolAction> actions;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 0.74,
      children: [for (final a in actions) _Tile(action: a)],
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({required this.action});

  final ToolAction action;

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
