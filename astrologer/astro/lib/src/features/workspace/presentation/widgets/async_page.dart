import 'package:flutter/material.dart';
import 'package:talkacharya_ui/talkacharya_ui.dart';

import '../../../../core/network/friendly_error.dart';
import '../../../../shared/widgets/settings_widgets.dart';

/// A sub-page that loads one thing and shows it: skeleton while it loads, an
/// error with Retry if it fails, pull to refresh once it is there. The pages
/// in this feature differ only in what they fetch and how they draw it.
class AsyncPage<T> extends StatefulWidget {
  const AsyncPage({
    required this.title,
    required this.load,
    required this.builder,
    this.subtitle,
    this.bottomBar,
    this.actions = const [],
    super.key,
  });

  final String title;
  final String? subtitle;
  final Future<T> Function() load;

  /// Children for the loaded value. [set] replaces it without a refetch (an
  /// edit that returned the new state); [reload] fetches again.
  final List<Widget> Function(
    BuildContext context,
    T value,
    void Function(T) set,
    Future<void> Function() reload,
  )
  builder;

  final Widget Function(BuildContext context, Future<void> Function() reload)?
  bottomBar;
  final List<Widget> actions;

  @override
  State<AsyncPage<T>> createState() => _AsyncPageState<T>();
}

class _AsyncPageState<T> extends State<AsyncPage<T>> {
  T? _value;
  bool _loaded = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final v = await widget.load();
      if (!mounted) return;
      setState(() {
        _value = v;
        _loaded = true;
        _error = null;
      });
    } catch (e) {
      if (mounted) setState(() => _error = friendlyError(e));
    }
  }

  void _set(T v) => setState(() => _value = v);

  @override
  Widget build(BuildContext context) {
    final List<Widget> children;
    if (_loaded) {
      children = widget.builder(context, _value as T, _set, _load);
    } else if (_error != null) {
      children = [
        Padding(
          padding: const EdgeInsets.only(top: 48),
          child: ErrorView(message: _error!, onRetry: _load),
        ),
      ];
    } else {
      children = const [
        AppShimmer(
          child: Column(
            children: [
              SkeletonBox(height: 84, radius: 16),
              SizedBox(height: 10),
              SkeletonBox(height: 84, radius: 16),
              SizedBox(height: 10),
              SkeletonBox(height: 84, radius: 16),
            ],
          ),
        ),
      ];
    }
    return SubPageScaffold(
      title: widget.title,
      subtitle: widget.subtitle,
      actions: widget.actions,
      onRefresh: _load,
      bottomBar: widget.bottomBar?.call(context, _load),
      children: children,
    );
  }
}

/// The bordered surface card every row in these pages sits on.
class WsCard extends StatelessWidget {
  const WsCard({required this.child, this.onTap, this.padding, super.key});

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final card = Material(
      color: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: context.brand.hairline),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: padding ?? const EdgeInsets.all(14),
          child: child,
        ),
      ),
    );
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: onTap == null ? card : Pressable(child: card),
    );
  }
}

/// A centred empty state with room above it, as the pages' "nothing yet".
class WsEmpty extends StatelessWidget {
  const WsEmpty({
    required this.icon,
    required this.title,
    required this.message,
    this.hue = AstroPalette.career,
    super.key,
  });

  final IconData icon;
  final String title;
  final String message;
  final AstroHue hue;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 40),
    child: EmptyState(icon: icon, hue: hue, title: title, message: message),
  );
}
