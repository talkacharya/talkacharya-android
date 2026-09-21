// AppSnack.show(context, 'Profile updated', type: SnackType.success);
//
// AppSnack.show(
// context,
// 'Astrologer removed from favourites',
// title: 'Removed',
// style: SnackStyle.dark,
// actionLabel: 'Undo',
// onAction: () => undo(),
// showProgress: true, // thin countdown line along the bottom edge
// );
//
// AppSnack.showTop(
// context,
// 'Acharya Ji is now online',
// style: SnackStyle.glass,
// type: SnackType.info,
// );

import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

enum SnackType { success, error, warning, info }

enum SnackStyle { soft, dark, gradient, glass }

extension SnackTypeX on SnackType {
  // swap these for your brand tokens if you like (e.g. brand.online)
  Color get color => switch (this) {
    SnackType.success => const Color(0xFF16A34A),
    SnackType.error => const Color(0xFFE5484D),
    SnackType.warning => const Color(0xFFF59E0B),
    SnackType.info => const Color(0xFF3B82F6),
  };

  IconData get icon => switch (this) {
    SnackType.success => Icons.check_circle_rounded,
    SnackType.error => Icons.error_rounded,
    SnackType.warning => Icons.warning_amber_rounded,
    SnackType.info => Icons.info_rounded,
  };
}

/// Usage:
///   AppSnack.show(context, 'Profile updated', type: SnackType.success);
///   AppSnack.show(context, 'Removed', style: SnackStyle.dark,
///       actionLabel: 'Undo', onAction: () {});
///   AppSnack.showTop(context, 'Back online', type: SnackType.success);
class AppSnack {
  AppSnack._();

  /// Bottom floating snackbar from a BuildContext.
  static void show(
    BuildContext context,
    String message, {
    String? title,
    SnackType type = SnackType.info,
    SnackStyle style = SnackStyle.soft,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 4),
    bool showProgress = false,
  }) {
    showOn(
      ScaffoldMessenger.of(context),
      message,
      title: title,
      type: type,
      style: style,
      actionLabel: actionLabel,
      onAction: onAction,
      duration: duration,
      showProgress: showProgress,
    );
  }

  /// Same, but from a messenger captured earlier. Use this after an `await`.
  static void showOn(
    ScaffoldMessengerState messenger,
    String message, {
    String? title,
    SnackType type = SnackType.info,
    SnackStyle style = SnackStyle.soft,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 4),
    bool showProgress = false,
  }) {
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
          padding: EdgeInsets.zero,
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          duration: duration,
          dismissDirection: DismissDirection.horizontal,
          content: _SnackCard(
            message: message,
            title: title,
            type: type,
            style: style,
            actionLabel: actionLabel,
            onAction: onAction,
            onClose: messenger.hideCurrentSnackBar,
            progressDuration: showProgress ? duration : null,
          ),
        ),
      );
  }
}

class _Look {
  const _Look({
    required this.fg,
    required this.sub,
    required this.iconBg,
    required this.iconFg,
    required this.action,
    this.bg,
    this.gradient,
    this.border,
  });

  final Color fg;
  final Color sub;
  final Color iconBg;
  final Color iconFg;
  final Color action;
  final Color? bg;
  final Gradient? gradient;
  final Color? border;
}

class _SnackCard extends StatelessWidget {
  const _SnackCard({
    required this.message,
    required this.type,
    required this.style,
    required this.onClose,
    this.title,
    this.actionLabel,
    this.onAction,
    this.progressDuration,
  });

  final String message;
  final String? title;
  final SnackType type;
  final SnackStyle style;
  final String? actionLabel;
  final VoidCallback? onAction;
  final VoidCallback onClose;
  final Duration? progressDuration;

  static const _radius = 18.0;

  _Look _look(ThemeData theme) {
    final accent = type.color;
    final scheme = theme.colorScheme;
    return switch (style) {
      SnackStyle.soft => _Look(
        bg: scheme.surface,
        fg: scheme.onSurface,
        sub: scheme.onSurface.withValues(alpha: 0.65),
        border: accent.withValues(alpha: 0.28),
        iconBg: accent.withValues(alpha: 0.12),
        iconFg: accent,
        action: accent,
      ),
      SnackStyle.dark => _Look(
        bg: const Color(0xFF1B1A20),
        fg: Colors.white,
        sub: Colors.white.withValues(alpha: 0.7),
        border: Colors.white.withValues(alpha: 0.06),
        iconBg: accent.withValues(alpha: 0.2),
        iconFg: accent,
        action: accent,
      ),
      SnackStyle.gradient => _Look(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [accent, Color.lerp(accent, Colors.black, 0.28)!],
        ),
        fg: Colors.white,
        sub: Colors.white.withValues(alpha: 0.88),
        iconBg: Colors.white.withValues(alpha: 0.2),
        iconFg: Colors.white,
        action: Colors.white,
      ),
      SnackStyle.glass => _Look(
        bg: Colors.black.withValues(alpha: 0.45),
        fg: Colors.white,
        sub: Colors.white.withValues(alpha: 0.75),
        border: Colors.white.withValues(alpha: 0.18),
        iconBg: accent.withValues(alpha: 0.35),
        iconFg: Colors.white,
        action: Colors.white,
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final look = _look(theme);
    final accent = type.color;
    final radius = BorderRadius.circular(_radius);

    Widget content = Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: look.iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(type.icon, size: 22, color: look.iconFg),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null)
                  Text(
                    title!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: look.fg,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                Text(
                  message,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: title != null ? look.sub : look.fg,
                    fontWeight: title != null
                        ? FontWeight.w400
                        : FontWeight.w600,
                    height: 1.25,
                  ),
                ),
              ],
            ),
          ),
          if (actionLabel != null) ...[
            const SizedBox(width: 8),
            TextButton(
              onPressed: () {
                onAction?.call();
                onClose();
              },
              style: TextButton.styleFrom(
                foregroundColor: look.action,
                backgroundColor: style == SnackStyle.gradient
                    ? Colors.white.withValues(alpha: 0.18)
                    : look.action.withValues(alpha: 0.1),
                padding: const EdgeInsets.symmetric(horizontal: 14),
                minimumSize: const Size(0, 34),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                textStyle: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              child: Text(actionLabel!),
            ),
          ],
        ],
      ),
    );

    // optional countdown line along the bottom edge
    if (progressDuration != null) {
      content = Stack(
        children: [
          content,
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 1, end: 0),
              duration: progressDuration!,
              builder: (_, v, _) => LinearProgressIndicator(
                value: v,
                minHeight: 3,
                backgroundColor: Colors.transparent,
                color: style == SnackStyle.gradient
                    ? Colors.white.withValues(alpha: 0.6)
                    : accent.withValues(alpha: 0.7),
              ),
            ),
          ),
        ],
      );
    }

    Widget card = DecoratedBox(
      decoration: BoxDecoration(
        color: look.bg,
        gradient: look.gradient,
        borderRadius: radius,
        border: look.border == null ? null : Border.all(color: look.border!),
        boxShadow: [
          BoxShadow(
            color: (style == SnackStyle.gradient ? accent : Colors.black)
                .withValues(alpha: style == SnackStyle.soft ? 0.10 : 0.28),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(borderRadius: radius, child: content),
    );

    if (style == SnackStyle.glass) {
      card = ClipRRect(
        borderRadius: radius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: card,
        ),
      );
    }
    return card;
  }
}

class _TopToast extends StatefulWidget {
  const _TopToast({
    required this.duration,
    required this.onDone,
    required this.builder,
  });

  final Duration duration;
  final VoidCallback onDone;
  final Widget Function(VoidCallback close) builder;

  @override
  State<_TopToast> createState() => _TopToastState();
}

class _TopToastState extends State<_TopToast>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 340),
    reverseDuration: const Duration(milliseconds: 220),
  );
  late final Animation<double> _curve = CurvedAnimation(
    parent: _c,
    curve: Curves.easeOutCubic,
    reverseCurve: Curves.easeInCubic,
  );
  bool _closing = false;

  @override
  void initState() {
    super.initState();
    _c.forward();
    Future.delayed(widget.duration, _close);
  }

  Future<void> _close() async {
    if (_closing || !mounted) return;
    _closing = true;
    await _c.reverse();
    widget.onDone();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, -1.3),
              end: Offset.zero,
            ).animate(_curve),
            child: FadeTransition(
              opacity: _curve,
              child: GestureDetector(
                onVerticalDragEnd: (d) {
                  if ((d.primaryVelocity ?? 0) < -150) _close();
                },
                child: Material(
                  type: MaterialType.transparency,
                  child: widget.builder(_close),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
