import 'dart:async';

import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:talkacharya_call/talkacharya_call.dart';
import 'package:talkacharya_sounds/talkacharya_sounds.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/notifications/chat_delivery.dart';
import '../../../../core/notifications/local_notifications.dart';
import '../../../../core/notifications/push_service.dart';
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

  /// The call this phone holds for a consultation that is over, room open or
  /// not: minimized, nobody else would end it, and it would sit under the mini
  /// bar "connecting" to a session that is gone.
  void _settleCall(String consultationId, {required bool ended}) {
    final hub = getIt<CallHub>();
    if (!hub.isFor(consultationId)) return;
    if (ended) {
      unawaited(hub.controller?.onConsultationEnded());
    } else {
      unawaited(hub.release());
    }
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
      case NewChatMessage(:final consultationId, :final seq):
        // The room sits on the root navigator, above this shell, so the shell's
        // own location never names it: the router check always said "elsewhere"
        // and played a notification tone over the open conversation.
        final here = getIt<RoomPresence>().isOpen(consultationId);
        if (!here) {
          // On this phone, outside the room: the sender's second tick.
          unawaited(reportChatDelivered(getIt<Dio>(), consultationId, seq));
          AppSounds.notify();
        }
      case RequestRemoved(:final consultationId):
        // Withdrawn, timed out or a no-show: the tray, the lock-screen ringing
        // page and Android's ringing call all stop (the sheet closes itself).
        unawaited(stopRingFor(getIt<LocalNotifications>(), consultationId));
        _settleCall(consultationId, ended: false);
      case InboxPing():
        context.read<NotificationsCubit>().bump();
      case ConsultationEvent(:final kind, :final consultationId):
        context.read<NotificationsCubit>().bump();
        if (consultationId != null && (kind == 'ended' || kind == 'rejected')) {
          _settleCall(consultationId, ended: kind == 'ended');
        }
        // Answered or declined — here or on the astrologer's other phone.
        if ((kind == 'accepted' || kind == 'rejected') &&
            consultationId != null) {
          unawaited(
            stopRingFor(
              getIt<LocalNotifications>(),
              consultationId,
              reason: kind,
            ),
          );
        }
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

/// The bottom bar — the customer app's own: a full-width cosmic strip, icon
/// over label, the selected tab in gold. Counts sit on the icons.
class _FloatingNavBar extends StatelessWidget {
  const _FloatingNavBar({
    required this.currentIndex,
    required this.onTap,
    required this.destinations,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<_NavDest> destinations;

  Widget _icon(IconData icon, int badge) => Badge.count(
    count: badge,
    isLabelVisible: badge > 0,
    backgroundColor: const Color(0xFFE5484D),
    child: Icon(icon),
  );

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [brand.cosmicStart, brand.cosmicEnd, const Color(0xFF3B0F5C)],
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: const Color(0xFFFFB02E),
        unselectedItemColor: Colors.white.withValues(alpha: 0.62),
        selectedFontSize: 11,
        unselectedFontSize: 11,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w800),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        items: [
          for (final d in destinations)
            BottomNavigationBarItem(
              icon: _icon(d.icon, d.badge),
              activeIcon: _icon(d.selectedIcon, d.badge),
              label: d.label,
              tooltip: d.badge > 0 ? '${d.label}, ${d.badge}' : d.label,
            ),
        ],
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
