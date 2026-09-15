import 'package:flutter/material.dart';

import '../../features/notifications/presentation/view/notification_bell.dart';

/// Standard chrome for a bottom-nav tab: an [AppBar] with the tab title, a
/// notifications bell, and any extra [actions]. Body is [child].
class AppScaffold extends StatelessWidget {
  const AppScaffold({
    required this.title,
    required this.child,
    this.titleWidget,
    this.actions = const [],
    this.showBell = true,
    this.floatingActionButton,
    super.key,
  });

  final String title;

  /// Overrides the plain [title] text in the app bar when provided.
  final Widget? titleWidget;
  final Widget child;
  final List<Widget> actions;
  final bool showBell;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: titleWidget != null ? 8 : null,
        title: titleWidget ?? Text(title),
        actions: [...actions, if (showBell) const NotificationBell()],
      ),
      floatingActionButton: floatingActionButton,
      body: child,
    );
  }
}
