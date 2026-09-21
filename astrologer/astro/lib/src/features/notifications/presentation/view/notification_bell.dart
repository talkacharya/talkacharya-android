import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/routes.dart';
import '../bloc/notifications_cubit.dart';

/// App-bar action: bell icon with an unread badge, opens the inbox.
class NotificationBell extends StatelessWidget {
  const NotificationBell({this.color, super.key});

  /// Icon colour override (e.g. white on the dashboard's cosmic header).
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final count = context.select<NotificationsCubit, int>(
      (c) => c.state.unreadCount,
    );
    return IconButton(
      tooltip: context.l10n.commonNotifications,
      color: color,
      onPressed: () => context.push(Routes.notifications),
      icon: Badge(
        isLabelVisible: count > 0,
        label: Text(count > 99 ? '99+' : '$count'),
        child: const Icon(Icons.notifications_none_rounded),
      ),
    );
  }
}
