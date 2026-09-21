import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/brand_colors.dart';
import 'cosmic.dart';

/// Deep-space header for a bottom-nav tab: large title, optional subtitle,
/// trailing [actions] (render them in [BrandColors.onCosmic]), and an optional
/// [bottom] slot (search field, [PillTabBar], …). Same visual language as the
/// dashboard header.
class CosmicTabHeader extends StatelessWidget {
  const CosmicTabHeader({
    required this.title,
    this.subtitle,
    this.actions = const [],
    this.bottom,
    super.key,
  });

  final String title;
  final String? subtitle;
  final List<Widget> actions;
  final Widget? bottom;

  static const _radius = BorderRadius.vertical(bottom: Radius.circular(28));

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    final theme = Theme.of(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: _radius,
          boxShadow: brand.shadowCosmic,
        ),
        child: ClipRRect(
          borderRadius: _radius,
          child: Stack(
            children: [
              const Positioned.fill(child: CosmicBackdrop()),
              SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 8, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style: theme.textTheme.headlineMedium
                                      ?.copyWith(color: brand.onCosmic),
                                ),
                                if (subtitle != null)
                                  Text(
                                    subtitle!,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: brand.onCosmicMuted,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          ...actions,
                        ],
                      ),
                      if (bottom != null) ...[
                        const SizedBox(height: 14),
                        Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: bottom,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Frosted segmented tabs for a cosmic surface, driven by a [TabController]
/// (so swiping the [TabBarView] moves the gold pill too). [counts] shows a
/// small badge per tab when > 0.
class PillTabBar extends StatelessWidget {
  const PillTabBar({
    required this.controller,
    required this.labels,
    this.counts = const [],
    super.key,
  });

  final TabController controller;
  final List<String> labels;
  final List<int> counts;

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    return Container(
      height: 44,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: AnimatedBuilder(
        animation: controller.animation!,
        builder: (context, _) {
          final pos = controller.animation!.value;
          return Row(
            children: [
              for (var i = 0; i < labels.length; i++)
                Expanded(
                  child: _Pill(
                    label: labels[i],
                    count: i < counts.length ? counts[i] : 0,
                    // 1 when centred on this tab, fading to 0 one tab away.
                    t: (1 - (pos - i).abs()).clamp(0.0, 1.0),
                    idle: brand.onCosmicMuted,
                    onTap: () => controller.animateTo(i),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({
    required this.label,
    required this.count,
    required this.t,
    required this.idle,
    required this.onTap,
  });

  final String label;
  final int count;
  final double t;
  final Color idle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const selectedFg = Color(0xFF3A1703);
    final fg = Color.lerp(idle, selectedFg, t)!;
    return Semantics(
      button: true,
      selected: t > 0.5,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            gradient: t > 0
                ? LinearGradient(
                    colors: [
                      for (final c in BrandColors.goldGradient)
                        c.withValues(alpha: t),
                    ],
                  )
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: fg,
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                ),
              ),
              if (count > 0) ...[
                const SizedBox(width: 6),
                Container(
                  constraints: const BoxConstraints(minWidth: 20),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 1,
                  ),
                  decoration: BoxDecoration(
                    color: Color.lerp(context.brand.live, selectedFg, t),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    count > 99 ? '99+' : '$count',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Search field styled for a cosmic surface.
class CosmicSearchField extends StatelessWidget {
  const CosmicSearchField({
    required this.hint,
    required this.onChanged,
    this.controller,
    super.key,
  });

  final String hint;
  final ValueChanged<String> onChanged;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    return TextField(
      controller: controller,
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      style: TextStyle(color: brand.onCosmic),
      cursorColor: brand.glowAccent,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: brand.onCosmicMuted),
        prefixIcon: Icon(Icons.search_rounded, color: brand.onCosmicMuted),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.08),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.12)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.12)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999),
          borderSide: BorderSide(color: brand.glowAccent),
        ),
      ),
    );
  }
}
