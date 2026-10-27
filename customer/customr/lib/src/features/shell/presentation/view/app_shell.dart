import 'dart:async';

import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:talkacharya_call/talkacharya_call.dart';
import 'package:talkacharya_sounds/talkacharya_sounds.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/notifications/chat_delivery.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/network/connectivity_service.dart';
import '../../../../core/permissions/permissions_primer.dart';
import '../../../../core/realtime/realtime_client.dart';
import '../../../../core/realtime/realtime_event.dart';
import '../../../../core/router/routes.dart';
import '../../../consultations/presentation/cubit/chats_list_cubit.dart';
import '../../../notifications/presentation/bloc/notifications_cubit.dart';
import '../../../consultations/presentation/room_presence.dart';
import '../../../consultations/presentation/view/waitlist_sheets.dart';

import 'package:talkacharya_ui/talkacharya_ui.dart';

/// The signed-in container: an [IndexedStack] of the 3 tab navigators driven by
/// go_router's [StatefulNavigationShell], a floating rounded bottom nav, an
/// offline banner, and realtime toast handling. Horizontal swipes between tabs.
/// Chats ("Orders") is reached from the Profile page, not a tab; Live is pushed
/// full screen from the bar.
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
    // Everything a consultation needs, asked for once and up front.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) unawaited(maybeShowPermissionsPrimer(context));
    });
  }

  @override
  void dispose() {
    _realtimeSub?.cancel();
    super.dispose();
  }

  /// The call this phone holds for a consultation that has just ended, whether
  /// or not its room is open: a request minimized while waiting has no room to
  /// hear that it was declined or ran out, and would ring back on its own.
  void _settleCall(String kind, String? consultationId) {
    final hub = getIt<CallHub>();
    if (consultationId == null || !hub.isFor(consultationId)) return;
    if (kind == 'ended') {
      unawaited(hub.controller?.onConsultationEnded());
    } else if (const {
      'rejected',
      'expired',
      'cancelled',
      'no_show',
    }.contains(kind)) {
      unawaited(hub.release());
    }
  }

  void _onRealtime(RealtimeEvent event) {
    if (!mounted) return;
    switch (event) {
      case InboxPing():
        context.read<NotificationsCubit>().bump();
      case ConsultationEvent(:final kind, :final consultationId):
        context.read<NotificationsCubit>().bump();
        _settleCall(kind, consultationId);
      case NewChatMessage(:final consultationId, :final preview, :final seq):
        // The room is pushed on the root navigator, above this shell, so the
        // shell's own location never names it — asking the router here always
        // said "not in the room" and interrupted people mid-conversation with a
        // toast (and a second tone) for the message already on their screen.
        final here = getIt<RoomPresence>().isOpen(consultationId);
        if (!here) {
          // On this phone, outside the room: the sender's second tick.
          unawaited(reportChatDelivered(getIt<Dio>(), consultationId, seq));
          // A toast, no tone: in-app chat is silent (the tray rings only when
          // the app is not in front).
          _toast(
            preview.isEmpty ? 'New message' : preview,
            actionLabel: 'View',
            onAction: () => context.push('/consultations/$consultationId'),
          );
        }
      case QueueOffer(
        :final astrologerId,
        :final astrologerName,
        :final channel,
        :final offerExpiresAt,
      ):
        context.read<NotificationsCubit>().bump();
        final l = context.l10n;
        AppSounds.notify();
        if (astrologerId == null) {
          _toast(
            l.waitlistOfferToast(astrologerName ?? l.waitlistAnAstrologer),
          );
        } else {
          // A turn lasts two minutes: it gets the screen, not a toast.
          unawaited(
            showWaitlistTurnSheet(
              context,
              astrologerId: astrologerId,
              astrologerName: astrologerName ?? l.waitlistAnAstrologer,
              channel: channel ?? 'chat',
              expiresAt: DateTime.tryParse(offerExpiresAt ?? '')?.toLocal(),
            ),
          );
        }
      case QueueRemoved(:final astrologerName):
        final l = context.l10n;
        _toast(
          l.waitlistRemovedToast(astrologerName ?? l.waitlistAnAstrologer),
        );
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
      // An assistant reply: the room on screen shows it, the push says it
      // anywhere else.
      case AssistantFrame():
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

  // The bar shows five buttons; Live isn't a tab but a full-screen page pushed
  // above the shell, so the bar's positions and the shell's branches differ.
  static const _liveSlot = 3;

  int get _selectedSlot {
    final branch = widget.navigationShell.currentIndex;
    return branch >= _liveSlot ? branch + 1 : branch;
  }

  void _onNavTap(int slot) {
    if (slot == _liveSlot) {
      context.push(Routes.live);
      return;
    }
    _goBranch(slot > _liveSlot ? slot - 1 : slot);
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
    final brand = context.brand;
    return Scaffold(
      extendBody: false,
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
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              brand.cosmicStart,
              brand.cosmicEnd,
              const Color(0xFF3B0F5C),
            ],
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedSlot,
          onTap: _onNavTap,
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
            BottomNavigationBarItem(
              icon: const Icon(Icons.home_outlined),
              activeIcon: const Icon(Icons.home_rounded),
              label: l.navHome,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.groups_outlined),
              activeIcon: const Icon(Icons.groups_rounded),
              label: l.navAstrologers,
            ),
            BottomNavigationBarItem(
              // Folded hands 🙏 — Material has no such icon, so it is ours.
              icon: const _PrayIcon(),
              activeIcon: const _PrayIcon(filled: true),
              label: l.remediesTitle,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.live_tv_outlined),
              activeIcon: const Icon(Icons.live_tv_rounded),
              label: l.navLive,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.person_outline_rounded),
              activeIcon: const Icon(Icons.person_rounded),
              label: l.navProfile,
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

/// Folded hands for the Remedies tab, tinted like the bar's other icons
/// (it reads the selected / unselected colour and size from [IconTheme]).
class _PrayIcon extends StatelessWidget {
  const _PrayIcon({this.filled = false});

  final bool filled;

  @override
  Widget build(BuildContext context) {
    final theme = IconTheme.of(context);
    final size = theme.size ?? 24;
    return SvgPicture.asset(
      filled
          ? 'assets/svg/pray_outline.svg'
          : 'assets/svg/pray_outline.svg',
      width: size,
      height: size,
      colorFilter: ColorFilter.mode(
        theme.color ?? Theme.of(context).colorScheme.onSurface,
        BlendMode.srcIn,
      ),
    );
  }
}
