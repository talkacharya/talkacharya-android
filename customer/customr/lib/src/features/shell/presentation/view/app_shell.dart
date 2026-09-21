import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:talkacharya_sounds/talkacharya_sounds.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/network/connectivity_service.dart';
import '../../../../core/realtime/realtime_client.dart';
import '../../../../core/realtime/realtime_event.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/brand_colors.dart';
import '../../../consultations/presentation/cubit/chats_list_cubit.dart';
import '../../../notifications/presentation/bloc/notifications_cubit.dart';
import '../../../consultations/presentation/room_presence.dart';

/// The signed-in container: an [IndexedStack] of the 4 tab navigators driven by
/// go_router's [StatefulNavigationShell], a floating rounded bottom nav, an
/// offline banner, and realtime toast handling. Horizontal swipes between tabs.
/// Chats ("Orders") is reached from the Profile page, not a tab.
class AppShell extends StatefulWidget {
  const AppShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  StreamSubscription<RealtimeEvent>? _realtimeSub;

  @override
  void initState() {
    super.initState();
    context.read<NotificationsCubit>().load();
    context.read<ChatsListCubit>().load();
    _realtimeSub = getIt<RealtimeClient>().events.listen(_onRealtime);
  }

  @override
  void dispose() {
    _realtimeSub?.cancel();
    super.dispose();
  }

  void _onRealtime(RealtimeEvent event) {
    if (!mounted) return;
    switch (event) {
      case InboxPing():
      case ConsultationEvent():
        context.read<NotificationsCubit>().bump();
      case NewChatMessage(:final consultationId, :final preview):
        // The room is pushed on the root navigator, above this shell, so the
        // shell's own location never names it — asking the router here always
        // said "not in the room" and interrupted people mid-conversation with a
        // toast (and a second tone) for the message already on their screen.
        final here = getIt<RoomPresence>().openId == consultationId;
        if (!here) {
          AppSounds.notify();
          _toast(
            preview.isEmpty ? 'New message' : preview,
            actionLabel: 'View',
            onAction: () => context.push('/consultations/$consultationId'),
          );
        }
      case QueueOffer(:final astrologerName):
        context.read<NotificationsCubit>().bump();
        _toast('${astrologerName ?? 'An astrologer'} is available now');
      case LowBalance(:final runwaySeconds):
        _toast(
          'Low balance — about ${(runwaySeconds / 60).ceil()} min left',
          actionLabel: 'Recharge',
          onAction: () => context.push(Routes.wallet),
        );
      case StoreConsultVerdict(:final consultId):
        context.read<NotificationsCubit>().bump();
        final l = context.l10n;
        _toast(
          l.storeVerdictToast,
          actionLabel: l.storeView,
          onAction: () => context.push(Routes.storeConsult(consultId)),
        );
      case StoreOrderUpdated():
        context.read<NotificationsCubit>().bump();
      case WalletUpdated():
      case ReconnectHint():
        break;
    }
  }

  void _toast(String message, {String? actionLabel, VoidCallback? onAction}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          action: (actionLabel != null && onAction != null)
              ? SnackBarAction(label: actionLabel, onPressed: onAction)
              : null,
        ),
      );
  }

  void _goBranch(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    // Basic swipe detection logic
    final double velocity = details.primaryVelocity ?? 0;
    if (velocity.abs() < 400) return; // Ignore slow swipes

    final int currentIndex = widget.navigationShell.currentIndex;
    final int branchCount = widget.navigationShell.route.branches.length;

    if (velocity < 0 && currentIndex < branchCount - 1) {
      // Swipe Left -> Next Tab
      _goBranch(currentIndex + 1);
    } else if (velocity > 0 && currentIndex > 0) {
      // Swipe Right -> Previous Tab
      _goBranch(currentIndex - 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      extendBody: true,
      body: Column(
        children: [
          const _OfflineBanner(),
          Expanded(
            child: GestureDetector(
              onHorizontalDragEnd: _onHorizontalDragEnd,
              // Use behavior opaque to catch swipes even if children are
              // transparent, but let scrollables (like carousels) win
              // the gesture arena if they are horizontal.
              behavior: HitTestBehavior.translucent,
              child: widget.navigationShell,
            ),
          ),
        ],
      ),
      bottomNavigationBar: _FloatingNavBar(
        currentIndex: widget.navigationShell.currentIndex,
        onTap: _goBranch,
        destinations: [
          _NavDest(Icons.home_outlined, Icons.home_rounded, l.navHome),
          _NavDest(
            Icons.groups_outlined,
            Icons.groups_rounded,
            l.navAstrologers,
          ),
          _NavDest(Icons.live_tv_outlined, Icons.live_tv_rounded, l.navLive),
          _NavDest(
            Icons.person_outline_rounded,
            Icons.person_rounded,
            l.navProfile,
          ),
        ],
      ),
    );
  }
}

class _NavDest {
  const _NavDest(this.icon, this.selectedIcon, this.label);
  final IconData icon;
  final IconData selectedIcon;
  final String label;
}

/// Floating cosmic pill — the same deep-space gradient as the page headers. Every
/// tab shows icon over label; the selected one sits in a gold pill.
class _FloatingNavBar extends StatelessWidget {
  const _FloatingNavBar({
    required this.currentIndex,
    required this.onTap,
    required this.destinations,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<_NavDest> destinations;

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),
            boxShadow: [
              BoxShadow(
                color: brand.cosmicStart.withValues(alpha: 0.35),
                blurRadius: 22,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(26),
            child: Container(
              height: 66,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(26),
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    brand.cosmicStart,
                    brand.cosmicEnd,
                    const Color(0xFF3B0F5C),
                  ],
                ),
                border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
              ),
              child: Material(
                type: MaterialType.transparency,
                child: Row(
                  children: [
                    for (var i = 0; i < destinations.length; i++)
                      Expanded(
                        child: _NavCell(
                          dest: destinations[i],
                          selected: i == currentIndex,
                          onTap: () => onTap(i),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavCell extends StatelessWidget {
  const _NavCell({
    required this.dest,
    required this.selected,
    required this.onTap,
  });

  final _NavDest dest;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const selectedFg = Color(0xFF3A1703);
    final idle = Colors.white.withValues(alpha: 0.62);
    return Semantics(
      button: true,
      selected: selected,
      label: dest.label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        splashColor: Colors.white.withValues(alpha: 0.08),
        highlightColor: Colors.white.withValues(alpha: 0.04),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              width: selected ? 52 : 40,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                gradient: selected
                    ? const LinearGradient(colors: BrandColors.goldGradient)
                    : null,
                boxShadow: selected
                    ? [
                        BoxShadow(
                          color: BrandColors.goldGradient.last.withValues(
                            alpha: 0.45,
                          ),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ]
                    : null,
              ),
              child: Icon(
                selected ? dest.selectedIcon : dest.icon,
                size: 21,
                color: selected ? selectedFg : idle,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              dest.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelSmall?.copyWith(
                color: selected ? Colors.white : idle,
                fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                fontSize: 11,
                height: 1.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OfflineBanner extends StatelessWidget {
  const _OfflineBanner();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ValueListenableBuilder<bool>(
      valueListenable: getIt<ConnectivityService>(),
      builder: (context, online, _) {
        return AnimatedCrossFade(
          duration: const Duration(milliseconds: 200),
          crossFadeState: online
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
          firstChild: const SizedBox(width: double.infinity),
          secondChild: Material(
            color: scheme.errorContainer,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 6,
                  horizontal: 16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.wifi_off_rounded,
                      size: 16,
                      color: scheme.onErrorContainer,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'You are offline',
                      style: TextStyle(color: scheme.onErrorContainer),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
