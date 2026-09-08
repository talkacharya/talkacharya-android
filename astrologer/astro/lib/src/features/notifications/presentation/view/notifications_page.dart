import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/deeplink/deep_link_parser.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/error_view.dart';
import '../bloc/notifications_cubit.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    final cubit = context.read<NotificationsCubit>();
    if (cubit.state.status == NotifStatus.initial) cubit.load();
    _scroll.addListener(() {
      if (_scroll.position.pixels >= _scroll.position.maxScrollExtent - 300) {
        cubit.loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          TextButton(
            onPressed: () => context.read<NotificationsCubit>().markAllRead(),
            child: const Text('Mark all read'),
          ),
        ],
      ),
      body: BlocBuilder<NotificationsCubit, NotificationsState>(
        builder: (context, state) {
          if (state.status == NotifStatus.loading && state.items.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == NotifStatus.error && state.items.isEmpty) {
            return ErrorView(
              message: state.error ?? 'Could not load notifications.',
              onRetry: () => context.read<NotificationsCubit>().load(),
            );
          }
          if (state.items.isEmpty) {
            return const EmptyState(
              icon: Icons.notifications_none_rounded,
              title: 'No notifications yet',
              message: 'Updates about your consultations and wallet show up here.',
            );
          }
          return RefreshIndicator(
            onRefresh: () => context.read<NotificationsCubit>().load(refresh: true),
            child: ListView.separated(
              controller: _scroll,
              itemCount: state.items.length + (state.hasMore ? 1 : 0),
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, i) {
                if (i >= state.items.length) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                final n = state.items[i];
                final scheme = Theme.of(context).colorScheme;
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: n.isRead
                        ? scheme.surfaceContainerHighest
                        : scheme.primaryContainer,
                    child: Icon(
                      Icons.notifications_rounded,
                      size: 20,
                      color: n.isRead
                          ? scheme.onSurfaceVariant
                          : scheme.onPrimaryContainer,
                    ),
                  ),
                  title: Text(
                    n.title,
                    style: TextStyle(
                      fontWeight: n.isRead ? FontWeight.w500 : FontWeight.w700,
                    ),
                  ),
                  subtitle: n.body.isEmpty ? null : Text(n.body),
                  trailing: n.isRead
                      ? null
                      : Icon(Icons.circle, size: 10, color: scheme.primary),
                  onTap: () {
                    context.read<NotificationsCubit>().markRead(n.id);
                    final loc = locationForRaw(n.deeplink);
                    if (loc != null) context.go(loc);
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
