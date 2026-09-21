import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/deeplink/deep_link_parser.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/astro_palette.dart';
import '../../../../core/theme/brand_colors.dart';
import '../../../../core/util/time_format.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../../../shared/widgets/hue_widgets.dart';
import '../../../../shared/widgets/pressable.dart';
import '../../../../shared/widgets/settings_widgets.dart';
import '../../data/models/app_notification.dart';
import '../bloc/notifications_cubit.dart';

/// Icon + hue for a notification, inferred from where it links to (the inbox
/// payload carries no type).
({IconData icon, AstroHue hue}) notificationStyle(String deeplink) {
  final d = deeplink.toLowerCase();
  bool has(String s) => d.contains(s);
  if (has('request') || has('consultation') || has('chat')) {
    return (icon: Icons.forum_rounded, hue: AstroPalette.career);
  }
  if (has('payout') || has('earning') || has('tax')) {
    return (
      icon: Icons.account_balance_wallet_rounded,
      hue: AstroPalette.money,
    );
  }
  if (has('review')) return (icon: Icons.star_rounded, hue: AstroPalette.fire);
  if (has('live') || has('stream') || has('gift')) {
    return (icon: Icons.videocam_rounded, hue: AstroPalette.love);
  }
  if (has('prediction')) {
    return (icon: Icons.insights_rounded, hue: AstroPalette.air);
  }
  if (has('kyc') || has('onboarding') || has('featured')) {
    return (icon: Icons.verified_user_rounded, hue: AstroPalette.health);
  }
  return (icon: Icons.notifications_rounded, hue: AstroPalette.water);
}

/// The inbox: day-grouped, unread highlighted, swipe to mark read, tap to open.
class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final _scroll = ScrollController();
  bool _unreadOnly = false;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<NotificationsCubit>();
    cubit.load(refresh: true);
    _scroll.addListener(() {
      if (_scroll.position.extentAfter < 300) cubit.loadMore();
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  void _open(AppNotification n) {
    context.read<NotificationsCubit>().markRead(n.id);
    final loc = locationForRaw(n.deeplink);
    if (loc == null) return;
    // Tab roots switch tabs; anything deeper stacks on top of the inbox.
    Routes.branchRoots.contains(loc) ? context.go(loc) : context.push(loc);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    return BlocBuilder<NotificationsCubit, NotificationsState>(
      builder: (context, state) {
        final cubit = context.read<NotificationsCubit>();
        final items = _unreadOnly
            ? state.items.where((n) => !n.isRead).toList()
            : state.items;

        final groups = <String, List<AppNotification>>{};
        for (final n in items) {
          final key = n.createdAt == null
              ? ''
              : TimeFormat.day(l, n.createdAt!);
          groups.putIfAbsent(key, () => []).add(n);
        }

        Widget? placeholder;
        if (state.items.isEmpty) {
          placeholder = switch (state.status) {
            NotifStatus.initial || NotifStatus.loading => const Center(
              child: CircularProgressIndicator(),
            ),
            NotifStatus.error => ErrorView(
              message: l.notifLoadError,
              onRetry: () => cubit.load(refresh: true),
            ),
            _ => EmptyState(
              icon: Icons.notifications_active_rounded,
              hue: AstroPalette.health,
              title: l.notifEmptyTitle,
              message: l.notifEmptyBody,
            ),
          };
        } else if (items.isEmpty) {
          placeholder = EmptyState(
            icon: Icons.mark_email_read_rounded,
            title: l.notifUnreadEmpty,
          );
        }

        return Scaffold(
          body: RefreshIndicator(
            edgeOffset: 120,
            onRefresh: () => cubit.load(refresh: true),
            child: CustomScrollView(
              controller: _scroll,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverAppBar.large(
                  backgroundColor: brand.canvas,
                  surfaceTintColor: Colors.transparent,
                  title: Text(l.commonNotifications),
                  actions: [
                    if (state.unreadCount > 0)
                      TextButton.icon(
                        onPressed: cubit.markAllRead,
                        icon: const Icon(Icons.done_all_rounded, size: 18),
                        label: Text(l.notifMarkAll),
                      ),
                    const SizedBox(width: 8),
                  ],
                ),
                if (state.items.isNotEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                      child: Wrap(
                        spacing: 8,
                        children: [
                          _FilterChip(
                            label: l.earnKindAll,
                            selected: !_unreadOnly,
                            onTap: () => setState(() => _unreadOnly = false),
                          ),
                          _FilterChip(
                            label: state.unreadCount > 0
                                ? '${l.notifFilterUnread} · ${state.unreadCount}'
                                : l.notifFilterUnread,
                            selected: _unreadOnly,
                            onTap: () => setState(() => _unreadOnly = true),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (placeholder != null)
                  SliverFillRemaining(hasScrollBody: false, child: placeholder)
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    sliver: SliverList.list(
                      children: [
                        for (final MapEntry(key: day, value: list)
                            in groups.entries) ...[
                          if (day.isNotEmpty) GroupLabel(day),
                          for (final n in list)
                            _NotificationTile(
                              key: ValueKey(n.id),
                              notification: n,
                              onTap: () => _open(n),
                              onMarkRead: () => cubit.markRead(n.id),
                            ),
                        ],
                        if (state.status == NotifStatus.loadingMore)
                          const Padding(
                            padding: EdgeInsets.all(16),
                            child: Center(child: CircularProgressIndicator()),
                          ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ChoiceChip(
      selected: selected,
      showCheckmark: false,
      label: Text(label),
      labelStyle: TextStyle(
        fontWeight: FontWeight.w700,
        color: selected ? scheme.onPrimary : null,
      ),
      selectedColor: scheme.primary,
      onSelected: (_) => onTap(),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({
    required this.notification,
    required this.onTap,
    required this.onMarkRead,
    super.key,
  });

  final AppNotification notification;
  final VoidCallback onTap;
  final VoidCallback onMarkRead;

  @override
  Widget build(BuildContext context) {
    final n = notification;
    final l = context.l10n;
    final brand = context.brand;
    final theme = Theme.of(context);
    final s = notificationStyle(n.deeplink);
    final unread = !n.isRead;

    final tile = Pressable(
      child: Material(
        color: unread ? s.hue.tint(0.08) : theme.colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Radii.md),
          side: BorderSide(color: unread ? s.hue.tint(0.3) : brand.hairline),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HueIcon(hue: s.hue, icon: s.icon, size: 40, iconSize: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              n.title,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: unread
                                    ? FontWeight.w800
                                    : FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            TimeFormat.relative(l, n.createdAt),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: unread ? s.hue.end : brand.inkMuted,
                              fontWeight: unread ? FontWeight.w700 : null,
                            ),
                          ),
                        ],
                      ),
                      if (n.body.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          n.body,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: brand.inkMuted,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (unread) ...[
                  const SizedBox(width: 8),
                  Container(
                    margin: const EdgeInsets.only(top: 6),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: s.hue.end,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: unread
          ? Dismissible(
              key: ValueKey('dismiss-${n.id}'),
              direction: DismissDirection.startToEnd,
              // Swiping only marks it read; the row stays.
              confirmDismiss: (_) async {
                onMarkRead();
                return false;
              },
              background: Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 20),
                decoration: BoxDecoration(
                  color: brand.online.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(Radii.md),
                ),
                child: Row(
                  children: [
                    Icon(Icons.mark_email_read_rounded, color: brand.online),
                    const SizedBox(width: 8),
                    Text(
                      l.notifMarkRead,
                      style: TextStyle(
                        color: brand.online,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              child: tile,
            )
          : tile,
    );
  }
}
