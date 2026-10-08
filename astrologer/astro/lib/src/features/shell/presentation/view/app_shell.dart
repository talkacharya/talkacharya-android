import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:talkacharya_sounds/talkacharya_sounds.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/network/connectivity_service.dart';
import '../../../../core/permissions/permissions_primer.dart';
import '../../../../core/realtime/realtime_client.dart';
import '../../../../core/realtime/realtime_event.dart';
import '../../../../core/router/transitions.dart';
import '../../../chats/presentation/cubit/chats_cubit.dart';
import '../../../home/presentation/cubit/tool_counts_cubit.dart';
import '../../../notifications/presentation/bloc/notifications_cubit.dart';
import '../../../requests/presentation/cubit/requests_cubit.dart';
import '../../../waitlist/presentation/cubit/waitlist_cubit.dart';
import '../../../requests/presentation/view/incoming_call_page.dart';
import '../../../requests/presentation/view/widgets/incoming_request_sheet.dart';
import '../../../consultations/presentation/room_presence.dart';

import 'package:talkacharya_ui/talkacharya_ui.dart';

/// Signed-in container: the 5 tab navigators (cross-faded, see
/// [AnimatedBranchContainer]), a floating cosmic bottom nav, an offline banner,
/// and realtime handling (incoming requests).
class AppShell extends StatefulWidget {
  const AppShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  StreamSubscription<RealtimeEvent>? _sub;

  @override
  void initState() {
    super.initState();
    context.read<NotificationsCubit>().load();
    context.read<RequestsCubit>().load();
    context.read<ChatsCubit>().load();
    context.read<WaitlistCubit>().load();
    context.read<ToolCountsCubit>().load();
    _sub = getIt<RealtimeClient>().events.listen(_onRealtime);
    // Everything a consultation needs, asked for once and up front: a
    // microphone prompt in the middle of a customer's first call costs it.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) unawaited(maybeShowPermissionsPrimer(context));
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  void _onRealtime(RealtimeEvent event) {
    if (!mounted) return;
    switch (event) {
      case ConsultationRequested(
        :final consultationId,
        :final conversationId,
        :final channel,
        :final question,
      ):
        // Already in this customer's room: the request shows there, as an
        // Accept in the conversation, with a short tone and a buzz — not a
        // sheet over the chat they are reading, and not the full ringtone.
        if (conversationId.isNotEmpty &&
            getIt<RoomPresence>().isOpen(conversationId)) {
          AppSounds.notify();
          unawaited(HapticFeedback.heavyImpact());
          return;
        }
        // Already up as the full ringing screen (the phone was locked).
        if (IncomingCallPage.showingFor == consultationId) return;
        showIncomingRequestSheet(
          context,
          consultationId: consultationId,
          channel: channel,
          question: question,
        );
      case NewChatMessage(:final consultationId):
        // The room sits on the root navigator, above this shell, so the shell's
        // own location never names it: the router check always said "elsewhere"
        // and played a notification tone over the open conversation.
        final here = getIt<RoomPresence>().isOpen(consultationId);
        if (!here) AppSounds.notify();
      case InboxPing():
      case ConsultationEvent():
        context.read<NotificationsCubit>().bump();
      default:
        break;
    }
  }

  void _goBranch(int i) => widget.navigationShell.goBranch(
    i,
    initialLocation: i == widget.navigationShell.currentIndex,
  );

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final waiting = context.select(
      (RequestsCubit c) => c.state.incoming.length,
    );
    final unread = context.select((ChatsCubit c) => c.state.totalUnread);
    return Scaffold(
      body: Column(
        children: [
          const _OfflineBanner(),
          Expanded(child: widget.navigationShell),
        ],
      ),
      bottomNavigationBar: _FloatingNavBar(
        currentIndex: widget.navigationShell.currentIndex,
        onTap: _goBranch,
        destinations: [
          _NavDest(
            Icons.dashboard_outlined,
            Icons.dashboard_rounded,
            l.navHome,
          ),
          _NavDest(
            Icons.inbox_outlined,
            Icons.inbox_rounded,
            l.navRequests,
            badge: waiting,
          ),
          _NavDest(
            Icons.payments_outlined,
            Icons.payments_rounded,
            l.navEarnings,
          ),
          _NavDest(
            Icons.chat_bubble_outline_rounded,
            Icons.chat_bubble_rounded,
            l.navChats,
            badge: unread,
          ),
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
  const _NavDest(this.icon, this.selectedIcon, this.label, {this.badge = 0});

  final IconData icon;
  final IconData selectedIcon;
  final String label;

  /// Red count on the icon (waiting requests / unread messages).
  final int badge;
}

/// Floating cosmic pill — same as the customer app's nav. Every tab shows icon
/// over label; the selected one sits in a gold pill.
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
    final radius = BorderRadius.circular(26);
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: radius,
            boxShadow: [
              BoxShadow(
                color: brand.cosmicStart.withValues(alpha: 0.35),
                blurRadius: 22,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: radius,
            child: Container(
              height: 66,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                borderRadius: radius,
                gradient: LinearGradient(
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
    const selectedFg = Color(0xFF3A1703);
    final idle = Colors.white.withValues(alpha: 0.62);
    return Semantics(
      button: true,
      selected: selected,
      label: dest.badge > 0 ? '${dest.label}, ${dest.badge}' : dest.label,
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
              child: Center(
                child: Badge(
                  isLabelVisible: dest.badge > 0,
                  label: Text(dest.badge > 99 ? '99+' : '${dest.badge}'),
                  backgroundColor: context.brand.live,
                  offset: const Offset(4, -4),
                  child: Icon(
                    selected ? dest.selectedIcon : dest.icon,
                    size: 21,
                    color: selected ? selectedFg : idle,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 3),
            Text(
              dest.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
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
                      context.l10n.commonOffline,
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
