import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/theme/astro_palette.dart';
import '../../core/theme/brand_colors.dart';
import 'hue_widgets.dart';
import 'pressable.dart';

/// Chrome for a pushed settings / editor page: a large collapsing title,
/// optional subtitle, scrolling [children], and an optional sticky
/// [bottomBar] (see [StickyActionBar]).
class SubPageScaffold extends StatelessWidget {
  const SubPageScaffold({
    required this.title,
    required this.children,
    this.subtitle,
    this.actions = const [],
    this.bottomBar,
    this.onRefresh,
    this.canPop = true,
    this.onPopBlocked,
    super.key,
  });

  final String title;
  final String? subtitle;
  final List<Widget> children;
  final List<Widget> actions;
  final Widget? bottomBar;
  final Future<void> Function()? onRefresh;

  /// When false, back is intercepted and [onPopBlocked] runs instead (unsaved
  /// changes).
  final bool canPop;
  final VoidCallback? onPopBlocked;

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    final theme = Theme.of(context);
    Widget scroll = CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverAppBar.large(
          backgroundColor: brand.canvas,
          surfaceTintColor: Colors.transparent,
          actions: actions,
          title: Text(title),
        ),
        if (subtitle != null)
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
            sliver: SliverToBoxAdapter(
              child: Text(
                subtitle!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: brand.inkMuted,
                ),
              ),
            ),
          ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
          sliver: SliverList.list(children: children),
        ),
      ],
    );
    if (onRefresh != null) {
      scroll = RefreshIndicator(onRefresh: onRefresh!, child: scroll);
    }
    return PopScope(
      canPop: canPop,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) onPopBlocked?.call();
      },
      child: Scaffold(body: scroll, bottomNavigationBar: bottomBar),
    );
  }
}

/// A titled card section for settings / editor pages.
class SettingsCard extends StatelessWidget {
  const SettingsCard({
    required this.child,
    this.title,
    this.subtitle,
    this.icon,
    this.hue = AstroPalette.career,
    this.trailing,
    this.padding = const EdgeInsets.fromLTRB(16, 4, 16, 16),
    super.key,
  });

  final String? title;
  final String? subtitle;
  final IconData? icon;
  final AstroHue hue;
  final Widget? trailing;
  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (title != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 12, 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (icon != null) ...[
                      HueIcon(hue: hue, icon: icon, size: 36, iconSize: 18),
                      const SizedBox(width: 12),
                    ],
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title!,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          if (subtitle != null)
                            Text(
                              subtitle!,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: brand.inkMuted,
                              ),
                            ),
                        ],
                      ),
                    ),
                    ?trailing,
                  ],
                ),
              ),
            Padding(padding: padding, child: child),
          ],
        ),
      ),
    );
  }
}

/// Small uppercase label above a group of rows.
class GroupLabel extends StatelessWidget {
  const GroupLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
    child: Text(
      text.toUpperCase(),
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
        color: context.brand.inkMuted,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.8,
      ),
    ),
  );
}

/// Tappable settings row: hue icon, title + subtitle, optional value, chevron.
class MenuRow extends StatelessWidget {
  const MenuRow({
    required this.icon,
    required this.title,
    this.subtitle,
    this.value,
    this.hue = AstroPalette.career,
    this.onTap,
    this.destructive = false,
    this.trailing,
    super.key,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final String? value;
  final AstroHue hue;
  final VoidCallback? onTap;
  final bool destructive;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    final theme = Theme.of(context);
    final color = destructive ? brand.live : null;
    return Pressable(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          child: Row(
            children: [
              if (destructive)
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: brand.live.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, size: 18, color: brand.live),
                )
              else
                HueIcon(hue: hue, icon: icon, size: 36, iconSize: 18),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: color,
                      ),
                    ),
                    if (subtitle != null)
                      Text(
                        subtitle!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: brand.inkMuted,
                        ),
                      ),
                  ],
                ),
              ),
              if (value != null) ...[
                const SizedBox(width: 8),
                Text(
                  value!,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: brand.inkMuted,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
              if (trailing != null)
                trailing!
              else if (!destructive && onTap != null)
                Icon(Icons.chevron_right_rounded, color: brand.inkMuted),
            ],
          ),
        ),
      ),
    );
  }
}

/// A card of [MenuRow]s separated by hairlines.
class MenuGroup extends StatelessWidget {
  const MenuGroup({required this.label, required this.rows, super.key});

  final String label;
  final List<Widget> rows;

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GroupLabel(label),
          Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                for (var i = 0; i < rows.length; i++) ...[
                  if (i > 0)
                    Divider(height: 1, indent: 62, color: brand.hairline),
                  rows[i],
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Bottom bar holding a page's primary action (Save …), above the keyboard.
class StickyActionBar extends StatelessWidget {
  const StickyActionBar({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    return AnimatedPadding(
      duration: const Duration(milliseconds: 150),
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: Border(top: BorderSide(color: brand.hairline)),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// A primary button with an inline spinner while [busy].
class BusyButton extends StatelessWidget {
  const BusyButton({
    required this.label,
    required this.onPressed,
    this.busy = false,
    this.icon,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool busy;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      style: FilledButton.styleFrom(
        // The theme's full-width minimum breaks inside a Row; parents with
        // tight width constraints still stretch the button.
        minimumSize: const Size(0, 52),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Radii.md),
        ),
      ),
      onPressed: busy ? null : onPressed,
      icon: busy
          ? const SizedBox.square(
              dimension: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Icon(icon ?? Icons.check_rounded),
      label: Text(label),
    );
  }
}

/// Floating snackbar helper.
void showToast(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(behavior: SnackBarBehavior.floating, content: Text(message)),
    );
}
