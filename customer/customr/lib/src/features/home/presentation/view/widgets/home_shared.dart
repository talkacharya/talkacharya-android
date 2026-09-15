import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../core/theme/astro_palette.dart';
import '../../../../../core/theme/brand_colors.dart';
import 'package:customr/src/core/l10n/l10n.dart';

export '../../../../../shared/widgets/hue_widgets.dart';

/// Layout constants shared across home sections.
class HomeGaps {
  const HomeGaps._();

  /// Horizontal inset for section content.
  static const double side = 20;

  /// Vertical space between sections.
  static const double section = 18;

  static const EdgeInsets sidePad = EdgeInsets.symmetric(horizontal: side);
}

/// Rotating colour families so neighbouring cards / sections never share a hue.
class HomeHues {
  const HomeHues._();

  static AstroHue at(int i) => AstroPalette.at(i);

  /// Stable hue for an id (same astrologer → same colour everywhere).
  static AstroHue forId(String id) => AstroPalette.forId(id);
}

/// Section title with a gradient accent bar and an optional tinted "See all" pill.
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    required this.title,
    this.subtitle,
    this.onSeeAll,
    this.seeAllLabel,
    this.trailing,
    this.hue = AstroPalette.money,
    super.key,
  });

  final String title;
  final String? subtitle;
  final VoidCallback? onSeeAll;
  final String? seeAllLabel;

  /// Custom trailing widget (e.g. the sign picker). Ignored when [onSeeAll] is set.
  final Widget? trailing;
  final AstroHue hue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brand = context.brand;
    return Padding(
      padding: HomeGaps.sidePad,
      child: Row(
        children: [
          Container(
            width: 4,
            height: subtitle == null ? 22 : 36,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              gradient: hue.linear(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    height: 1.15,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: brand.inkMuted,
                    ),
                  ),
              ],
            ),
          ),
          if (onSeeAll != null)
            _SeeAllPill(
              label: seeAllLabel ?? context.l10n.commonSeeAll,
              hue: hue,
              onTap: onSeeAll!,
            )
          else
            ?trailing,
        ],
      ),
    );
  }
}

class _SeeAllPill extends StatelessWidget {
  const _SeeAllPill({
    required this.label,
    required this.hue,
    required this.onTap,
  });

  final String label;
  final AstroHue hue;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Semantics(
      button: true,
      label: label,
      child: Material(
        color: hue.tint(0.12),
        shape: const StadiumBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 34, minWidth: 44),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 6, 6, 6),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: hue.end,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Icon(Icons.chevron_right_rounded, size: 18, color: hue.end),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Cross-fades between a section's states (skeleton → content → error) so data
/// landing never "pops". Each branch must be a distinct widget type or carry a
/// [Key] for the switch to trigger. Respects "reduce motion".
class SectionSwitcher extends StatelessWidget {
  const SectionSwitcher({
    required this.child,
    this.duration = const Duration(milliseconds: 320),
    super.key,
  });

  final Widget child;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.maybeDisableAnimationsOf(context) ?? false) return child;
    return AnimatedSwitcher(
      duration: duration,
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeIn,
      // Keep the outgoing child from forcing extra height while it fades.
      layoutBuilder: (currentChild, previousChildren) => Stack(
        alignment: Alignment.topLeft,
        children: [
          ...previousChildren.map(
            (c) => Positioned(left: 0, right: 0, child: c),
          ),
          ?currentChild,
        ],
      ),
      transitionBuilder: (child, animation) =>
          FadeTransition(opacity: animation, child: child),
      child: child,
    );
  }
}

/// A rounded placeholder block; wrap a tree of these in [HomeShimmer].
class SkeletonBox extends StatelessWidget {
  const SkeletonBox({this.width, this.height = 12, this.radius = 6, super.key});

  final double? width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

/// Shimmer tuned to the warm palette.
class HomeShimmer extends StatelessWidget {
  const HomeShimmer({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    return Shimmer.fromColors(
      baseColor: brand.shimmerBase,
      highlightColor: brand.shimmerHighlight,
      child: child,
    );
  }
}

/// A quiet inline "couldn't load · retry" strip for a section that failed.
class SectionError extends StatelessWidget {
  const SectionError({required this.onRetry, this.label, super.key});

  final VoidCallback onRetry;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: HomeGaps.sidePad,
      child: Row(
        children: [
          Icon(
            Icons.cloud_off_rounded,
            size: 18,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label ?? "Couldn't load this section",
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          TextButton(
            onPressed: onRetry,
            child: Text(context.l10n.homeRetryBtn),
          ),
        ],
      ),
    );
  }
}

/// A star + rating + count chip.
class RatingLabel extends StatelessWidget {
  const RatingLabel({
    required this.rating,
    this.count,
    this.dense = false,
    super.key,
  });

  final double rating;
  final int? count;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brand = context.brand;
    final style =
        (dense ? theme.textTheme.labelSmall : theme.textTheme.bodySmall)
            ?.copyWith(color: theme.colorScheme.onSurfaceVariant);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.star_rounded, size: dense ? 13 : 15, color: brand.gold),
        const SizedBox(width: 3),
        Text(
          rating > 0 ? rating.toStringAsFixed(1) : 'New',
          style: style?.copyWith(fontWeight: FontWeight.w600),
        ),
        if (count != null && count! > 0) ...[
          const SizedBox(width: 4),
          Text('(${_compact(count!)})', style: style),
        ],
      ],
    );
  }

  static String _compact(int n) {
    if (n >= 100000) return '${(n / 100000).toStringAsFixed(1)}L';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}k';
    return '$n';
  }
}

/// Circular avatar with a network image + initial fallback and optional
/// gradient ring for a premium feel.
class HomeAvatar extends StatelessWidget {
  const HomeAvatar({
    required this.name,
    this.url,
    this.radius = 22,
    this.showRing = false,
    this.ringColors,
    super.key,
  });

  final String name;
  final String? url;
  final double radius;
  final bool showRing;
  final List<Color>? ringColors;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final brand = context.brand;
    final hasUrl = url != null && url!.isNotEmpty;

    final avatar = CircleAvatar(
      radius: radius,
      backgroundColor: scheme.primaryContainer,
      foregroundImage: hasUrl ? NetworkImage(url!) : null,
      child: hasUrl
          ? null
          : Text(
              _initial(name),
              style: TextStyle(
                color: scheme.onPrimaryContainer,
                fontWeight: FontWeight.w700,
                fontSize: radius * 0.8,
              ),
            ),
    );

    if (!showRing) return avatar;

    final colors =
        ringColors ?? [brand.glowAccent, scheme.primary, brand.glowAccent];
    return Container(
      padding: const EdgeInsets.all(2.5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(1.5),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: scheme.surface,
        ),
        child: avatar,
      ),
    );
  }

  static String _initial(String name) {
    final t = name.trim();
    return t.isEmpty ? '★' : t.characters.first.toUpperCase();
  }
}

/// Reusable gradient icon badge used across concern chips, free tools, and
/// quick actions. Each icon sits on a circular gradient with a soft glow.
class GradientIconBadge extends StatelessWidget {
  const GradientIconBadge({
    required this.icon,
    required this.gradientColors,
    this.size = 38,
    this.iconSize = 19,
    this.glowOpacity = 0.25,
    super.key,
  });

  final IconData icon;
  final List<Color> gradientColors;
  final double size;
  final double iconSize;
  final double glowOpacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
        boxShadow: [
          BoxShadow(
            color: gradientColors.first.withValues(alpha: glowOpacity),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Icon(icon, size: iconSize, color: Colors.white),
    );
  }
}

/// Lays [child] out normally but shifts it up by [by] and reports [by] less
/// height — a "negative top margin" so a card can overlap the widget above it.
/// Hit-testing covers the overlapped strip too.
class PullUp extends SingleChildRenderObjectWidget {
  const PullUp({required this.by, super.child, super.key});

  final double by;

  @override
  RenderObject createRenderObject(BuildContext context) => RenderPullUp(by);

  @override
  void updateRenderObject(BuildContext context, RenderPullUp renderObject) {
    renderObject.by = by;
  }
}

class RenderPullUp extends RenderShiftedBox {
  RenderPullUp(this._by) : super(null);

  double _by;
  set by(double v) {
    if (v == _by) return;
    _by = v;
    markNeedsLayout();
  }

  @override
  void performLayout() {
    final c = child;
    if (c == null) {
      size = constraints.smallest;
      return;
    }
    c.layout(constraints.loosen(), parentUsesSize: true);
    (c.parentData! as BoxParentData).offset = Offset(0, -_by);
    size = constraints.constrain(
      Size(c.size.width, (c.size.height - _by).clamp(0, double.infinity)),
    );
  }

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    final c = child;
    if (c == null) return false;
    final offset = (c.parentData! as BoxParentData).offset;
    return result.addWithPaintOffset(
      offset: offset,
      position: position,
      hitTest: (result, transformed) =>
          c.hitTest(result, position: transformed),
    );
  }
}
