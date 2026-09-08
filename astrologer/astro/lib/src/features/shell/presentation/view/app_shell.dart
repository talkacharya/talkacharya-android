import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/network/connectivity_service.dart';
import '../../../../core/realtime/realtime_client.dart';
import '../../../../core/realtime/realtime_event.dart';
import '../../../notifications/presentation/bloc/notifications_cubit.dart';
import '../../../requests/presentation/view/widgets/incoming_request_sheet.dart';

/// Signed-in container: an IndexedStack of the 5 tab navigators, a Material 3
/// NavigationBar, an offline banner, and realtime handling (incoming requests).
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
    _sub = getIt<RealtimeClient>().events.listen(_onRealtime);
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  void _onRealtime(RealtimeEvent event) {
    if (!mounted) return;
    switch (event) {
      case ConsultationRequested(:final consultationId, :final channel, :final question):
        showIncomingRequestSheet(
          context,
          consultationId: consultationId,
          channel: channel,
          question: question,
        );
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
    return Scaffold(
      body: Column(
        children: [
          const _OfflineBanner(),
          Expanded(child: widget.navigationShell),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: widget.navigationShell.currentIndex,
        onDestinationSelected: _goBranch,
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: _RequestsIcon(context.select(
              (NotificationsCubit c) => 0, // badge wired in Phase 5
            )),
            label: 'Requests',
          ),
          const NavigationDestination(
            icon: Icon(Icons.payments_outlined),
            selectedIcon: Icon(Icons.payments_rounded),
            label: 'Earnings',
          ),
          const NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline_rounded),
            selectedIcon: Icon(Icons.chat_bubble_rounded),
            label: 'Chats',
          ),
          const NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class _RequestsIcon extends StatelessWidget {
  const _RequestsIcon(this.count);
  final int count;
  @override
  Widget build(BuildContext context) {
    const icon = Icon(Icons.inbox_outlined);
    if (count == 0) return icon;
    return Badge(label: Text('$count'), child: icon);
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
          crossFadeState:
              online ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          firstChild: const SizedBox(width: double.infinity),
          secondChild: Material(
            color: scheme.errorContainer,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.wifi_off_rounded,
                        size: 16, color: scheme.onErrorContainer),
                    const SizedBox(width: 8),
                    Text('You are offline',
                        style: TextStyle(color: scheme.onErrorContainer)),
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
