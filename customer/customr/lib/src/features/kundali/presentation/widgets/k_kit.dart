import 'package:astro_kundali/astro_kundali.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/astro_palette.dart';
import '../../../../core/theme/brand_colors.dart';
import '../../../../shared/widgets/cosmic.dart';
import '../../../../shared/widgets/fade_slide_in.dart';
import '../../../../shared/widgets/hue_widgets.dart';
import '../../../../shared/widgets/pressable.dart';
import '../../../../shared/widgets/skeleton.dart';

/// The kundali section's visual kit — the same language as Home, Horoscope and
/// Panchang: a cosmic hero, hue-tinted tiles, gradient-bar section headers,
/// staggered entrances and shimmer skeletons. Pages compose these; none of
/// them own data.

// --- colour helpers ------------------------------------------------------------

const _signs = [
  'Aries',
  'Taurus',
  'Gemini',
  'Cancer',
  'Leo',
  'Virgo',
  'Libra',
  'Scorpio',
  'Sagittarius',
  'Capricorn',
  'Aquarius',
  'Pisces',
];

/// 0 (Aries) … 11 (Pisces), or -1.
int kSignIndex(String sign) => _signs.indexOf(sign.trim());

/// Element colour for a sign name (fire / earth / air / water).
AstroHue kSignHue(String sign) {
  final i = kSignIndex(sign);
  return i < 0 ? AstroPalette.career : AstroPalette.element(i);
}

/// A two-stop hue built from a graha's fixed colour — matches the chart,
/// planet rows and dasha rails.
AstroHue kPlanetHue(String planet) {
  final c = planetColor(planet);
  return AstroHue(Color.lerp(c, Colors.white, 0.18)!, c);
}

// --- hero scaffold ------------------------------------------------------------

/// Cosmic collapsing hero + staggered body. Every kundali screen uses this so
/// the section feels like one place.
class KundaliScaffold extends StatelessWidget {
  const KundaliScaffold({
    required this.title,
    required this.children,
    this.eyebrow,
    this.headline,
    this.subheadline,
    this.heroChips = const [],
    this.heroTrailing,
    this.heroBottom,
    this.actions = const [],
    this.hue = AstroPalette.career,
    this.onRefresh,
    this.expandedHeight,
    this.bodyPadding = const EdgeInsets.fromLTRB(16, 16, 16, 40),
    this.animate = true,
    super.key,
  });

  /// Collapsed toolbar title.
  final String title;

  /// Small caps line above the headline.
  final String? eyebrow;

  /// Large serif line in the hero (defaults to [title]).
  final String? headline;
  final String? subheadline;
  final List<Widget> heroChips;

  /// Right-hand glyph / avatar in the hero.
  final Widget? heroTrailing;

  /// Full-width row pinned to the hero's bottom (e.g. a tab strip).
  final Widget? heroBottom;
  final List<Widget> actions;
  final AstroHue hue;
  final Future<void> Function()? onRefresh;
  final double? expandedHeight;
  final EdgeInsets bodyPadding;

  /// Stagger the body in on first build.
  final bool animate;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    final scroll = CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        KHeroAppBar(
          title: title,
          eyebrow: eyebrow,
          headline: headline ?? title,
          subheadline: subheadline,
          chips: heroChips,
          trailing: heroTrailing,
          bottom: heroBottom,
          actions: actions,
          hue: hue,
          expandedHeight: expandedHeight,
        ),
        SliverPadding(
          padding: bodyPadding,
          sliver: SliverList.list(
            children: animate ? FadeSlideIn.list(children) : children,
          ),
        ),
      ],
    );
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: brand.canvas,
        body: onRefresh == null
            ? scroll
            : RefreshIndicator(
                color: hue.end,
                edgeOffset: 110,
                onRefresh: onRefresh!,
                child: scroll,
              ),
      ),
    );
  }
}

class KHeroAppBar extends StatelessWidget {
  const KHeroAppBar({
    required this.title,
    required this.headline,
    this.eyebrow,
    this.subheadline,
    this.chips = const [],
    this.trailing,
    this.bottom,
    this.actions = const [],
    this.hue = AstroPalette.career,
    this.expandedHeight,
    super.key,
  });

  final String title;
  final String headline;
  final String? eyebrow;
  final String? subheadline;
  final List<Widget> chips;
  final Widget? trailing;
  final Widget? bottom;
  final List<Widget> actions;
  final AstroHue hue;
  final double? expandedHeight;

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    final theme = Theme.of(context);
    final height =
        expandedHeight ??
        (180 +
            (subheadline == null ? 0 : 22) +
            (chips.isEmpty ? 0 : 44) +
            (bottom == null ? 0 : 58));
    return SliverAppBar(
      pinned: true,
      stretch: true,
      expandedHeight: height,
      backgroundColor: brand.cosmicStart,
      foregroundColor: brand.onCosmic,
      surfaceTintColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      actions: actions,
      flexibleSpace: LayoutBuilder(
        builder: (context, box) {
          final top = MediaQuery.paddingOf(context).top;
          final collapsed = box.maxHeight <= top + kToolbarHeight + 16;
          return FlexibleSpaceBar(
            collapseMode: CollapseMode.parallax,
            stretchModes: const [StretchMode.zoomBackground],
            titlePadding: const EdgeInsetsDirectional.only(
              start: 56,
              end: 96,
              bottom: 16,
            ),
            // Hidden while expanded — and must not swallow taps meant for the
            // hero controls it sits over.
            title: IgnorePointer(
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 160),
                opacity: collapsed ? 1 : 0,
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: brand.onCosmic,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            background: Stack(
              fit: StackFit.expand,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [brand.cosmicStart, brand.cosmicEnd],
                    ),
                  ),
                ),
                _Glow(center: const Alignment(0.8, -0.4), color: hue.start),
                _Glow(
                  center: const Alignment(-0.95, 0.95),
                  color: hue.end,
                  alpha: 0.28,
                ),
                const CustomPaint(painter: StarfieldPainter()),
                SafeArea(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      20,
                      kToolbarHeight,
                      20,
                      bottom == null ? 18 : 10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (eyebrow != null)
                                    Text(
                                      eyebrow!.toUpperCase(),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: theme.textTheme.labelMedium
                                          ?.copyWith(
                                            color: brand.onCosmicMuted,
                                            letterSpacing: 1.2,
                                            fontWeight: FontWeight.w700,
                                          ),
                                    ),
                                  const SizedBox(height: 4),
                                  Text(
                                    headline,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: theme.textTheme.headlineMedium
                                        ?.copyWith(
                                          color: brand.onCosmic,
                                          fontWeight: FontWeight.w700,
                                          height: 1.15,
                                        ),
                                  ),
                                  if (subheadline != null) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      subheadline!,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                            color: brand.onCosmicMuted,
                                          ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            if (trailing != null) ...[
                              const SizedBox(width: 12),
                              trailing!,
                            ],
                          ],
                        ),
                        if (chips.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 32,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: chips.length,
                              separatorBuilder: (_, _) =>
                                  const SizedBox(width: 8),
                              itemBuilder: (_, i) => chips[i],
                            ),
                          ),
                        ],
                        if (bottom != null) ...[
                          const SizedBox(height: 12),
                          bottom!,
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _Glow extends StatelessWidget {
  const _Glow({required this.center, required this.color, this.alpha = 0.4});
  final Alignment center;
  final Color color;
  final double alpha;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      gradient: RadialGradient(
        center: center,
        radius: 0.95,
        colors: [
          color.withValues(alpha: alpha),
          color.withValues(alpha: 0),
        ],
      ),
    ),
  );
}

/// Frosted pill on the cosmic hero.
class KHeroChip extends StatelessWidget {
  const KHeroChip({
    required this.label,
    this.icon,
    this.color,
    this.onTap,
    super.key,
  });

  final String label;
  final IconData? icon;
  final Color? color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    final child = Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: color ?? brand.glowAccent),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: brand.onCosmic,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (onTap != null) ...[
            const SizedBox(width: 2),
            Icon(
              Icons.expand_more_rounded,
              size: 16,
              color: brand.onCosmicMuted,
            ),
          ],
        ],
      ),
    );
    if (onTap == null) return child;
    return Pressable(
      child: GestureDetector(onTap: onTap, child: child),
    );
  }
}

/// A glowing circular glyph for the hero's trailing slot.
class KHeroGlyph extends StatelessWidget {
  const KHeroGlyph({
    required this.hue,
    this.icon,
    this.text,
    this.size = 76,
    super.key,
  });

  final AstroHue hue;
  final IconData? icon;
  final String? text;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            hue.start.withValues(alpha: 0.95),
            hue.end.withValues(alpha: 0.75),
          ],
        ),
        border: Border.all(color: Colors.white.withValues(alpha: 0.35)),
        boxShadow: [
          BoxShadow(
            color: hue.start.withValues(alpha: 0.55),
            blurRadius: size * 0.45,
          ),
        ],
      ),
      alignment: Alignment.center,
      child: text != null
          ? Text(
              text!,
              maxLines: 1,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: size * 0.36,
              ),
            )
          : Icon(icon, color: Colors.white, size: size * 0.46),
    );
  }
}

// --- sections + surfaces -------------------------------------------------

/// Section: gradient accent bar + title (+ optional subtitle / trailing) and
/// its content.
class KSection extends StatelessWidget {
  const KSection({
    required this.title,
    required this.child,
    this.subtitle,
    this.hue = AstroPalette.career,
    this.trailing,
    this.padTop = 22,
    super.key,
  });

  final String title;
  final String? subtitle;
  final AstroHue hue;
  final Widget? trailing;
  final Widget child;
  final double padTop;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.only(top: padTop),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: subtitle == null ? 20 : 34,
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
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                    if (subtitle != null)
                      Text(
                        subtitle!,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: context.brand.inkMuted,
                        ),
                      ),
                  ],
                ),
              ),
              ?trailing,
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

/// Plain surface card: surface fill, hairline border, soft radius.
class KSurface extends StatelessWidget {
  const KSurface({
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
    this.color,
    this.borderColor,
    this.radius = 20,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Color? color;
  final Color? borderColor;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radius),
      side: BorderSide(color: borderColor ?? context.brand.hairline),
    );
    final material = Material(
      color: color ?? Theme.of(context).colorScheme.surface,
      shape: shape,
      clipBehavior: Clip.antiAlias,
      child: onTap == null
          ? Padding(padding: padding, child: child)
          : InkWell(
              onTap: onTap,
              child: Padding(padding: padding, child: child),
            ),
    );
    return onTap == null ? material : Pressable(child: material);
  }
}

/// A hue-tinted surface (gradient wash + hue hairline).
class KHueCard extends StatelessWidget {
  const KHueCard({
    required this.hue,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
    this.radius = 20,
    super.key,
  });

  final AstroHue hue;
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final card = HueTile(
      hue: hue,
      radius: radius,
      padding: padding,
      onTap: onTap,
      child: child,
    );
    return onTap == null ? card : Pressable(child: card);
  }
}

/// Dark cosmic panel for charts and hero-like cards inside the body.
class KCosmicPanel extends StatelessWidget {
  const KCosmicPanel({
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.hue = AstroPalette.career,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final AstroHue hue;

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [brand.cosmicEnd, brand.cosmicStart],
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: _Glow(
                center: const Alignment(0.9, -0.9),
                color: hue.start,
                alpha: 0.3,
              ),
            ),
            const Positioned.fill(
              child: CustomPaint(painter: StarfieldPainter()),
            ),
            Padding(padding: padding, child: child),
          ],
        ),
      ),
    );
  }
}

// --- atoms -----------------------------------------------------------------

/// A graha as a coloured disc with its short token (Su, Mo, …).
class PlanetBadge extends StatelessWidget {
  const PlanetBadge(this.planet, {this.size = 40, this.label, super.key});

  final String planet;
  final double size;

  /// Override the token (localised short name).
  final String? label;

  @override
  Widget build(BuildContext context) {
    final hue = kPlanetHue(planet);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: hue.linear(),
        boxShadow: [
          BoxShadow(
            color: hue.end.withValues(alpha: 0.3),
            blurRadius: size * 0.25,
            offset: Offset(0, size * 0.08),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        label ?? KundaliStrings.of(context).planetToken(planet),
        maxLines: 1,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: size * 0.36,
        ),
      ),
    );
  }
}

/// Rounded tinted icon square.
class KIconBox extends StatelessWidget {
  const KIconBox({
    required this.icon,
    required this.hue,
    this.size = 38,
    super.key,
  });

  final IconData icon;
  final AstroHue hue;
  final double size;

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: hue.tint(0.14),
      borderRadius: BorderRadius.circular(size * 0.32),
    ),
    child: Icon(icon, size: size * 0.52, color: hue.end),
  );
}

enum KTone { good, neutral, caution, bad }

AstroHue kToneHue(KTone tone) => switch (tone) {
  KTone.good => AstroPalette.health,
  KTone.neutral => AstroPalette.air,
  KTone.caution => AstroPalette.money,
  KTone.bad => AstroPalette.fire,
};

/// Small tone pill ("Strong", "Clear", "Present", …).
class KToneChip extends StatelessWidget {
  const KToneChip(this.label, {this.tone = KTone.neutral, this.hue, super.key});
  final String label;
  final KTone tone;
  final AstroHue? hue;

  @override
  Widget build(BuildContext context) {
    final h = hue ?? kToneHue(tone);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(
        color: h.tint(0.14),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: h.end,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

/// Icon + label + value tile for stat grids.
class KStatTile extends StatelessWidget {
  const KStatTile({
    required this.icon,
    required this.hue,
    required this.label,
    required this.value,
    this.sub,
    this.onTap,
    super.key,
  });

  final IconData icon;
  final AstroHue hue;
  final String label;
  final String value;
  final String? sub;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return KHueCard(
      hue: hue,
      radius: 18,
      padding: const EdgeInsets.all(12),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              HueIcon(hue: hue, icon: icon, size: 30, iconSize: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: context.brand.inkMuted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          if (sub != null && sub!.isNotEmpty)
            Text(
              sub!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
                color: context.brand.inkMuted,
                height: 1.3,
              ),
            ),
        ],
      ),
    );
  }
}

/// Label ↔ value row with an optional leading icon, for detail cards.
class KInfoRow extends StatelessWidget {
  const KInfoRow({
    required this.label,
    required this.value,
    this.icon,
    this.hue,
    this.trailing,
    super.key,
  });

  final String label;
  final String value;
  final IconData? icon;
  final AstroHue? hue;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          if (icon != null) ...[
            KIconBox(icon: icon!, hue: hue ?? AstroPalette.career, size: 32),
            const SizedBox(width: 10),
          ],
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: context.brand.inkMuted,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          if (trailing != null) ...[const SizedBox(width: 8), trailing!],
        ],
      ),
    );
  }
}

/// A navigation tile for hub grids: tinted icon, title, one-line subtitle.
class KNavTile extends StatelessWidget {
  const KNavTile({
    required this.icon,
    required this.hue,
    required this.title,
    required this.subtitle,
    required this.onTap,
    super.key,
  });

  final IconData icon;
  final AstroHue hue;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return KHueCard(
      hue: hue,
      radius: 18,
      padding: const EdgeInsets.all(12),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HueIcon(hue: hue, icon: icon, size: 36, iconSize: 19),
          const Spacer(),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
              color: context.brand.inkMuted,
              height: 1.25,
            ),
          ),
        ],
      ),
    );
  }
}

/// A full-width row variant of [KNavTile] for lists.
class KNavRow extends StatelessWidget {
  const KNavRow({
    required this.icon,
    required this.hue,
    required this.title,
    required this.onTap,
    this.subtitle,
    this.trailing,
    super.key,
  });

  final IconData icon;
  final AstroHue hue;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return KSurface(
      onTap: onTap,
      radius: 18,
      padding: const EdgeInsets.fromLTRB(12, 12, 10, 12),
      child: Row(
        children: [
          HueIcon(hue: hue, icon: icon, size: 40, iconSize: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: context.brand.inkMuted,
                    ),
                  ),
              ],
            ),
          ),
          trailing ??
              Icon(Icons.chevron_right_rounded, color: context.brand.inkMuted),
        ],
      ),
    );
  }
}

/// Gradient "Talk to an astrologer" call-to-action closing most screens.
class KAskCta extends StatelessWidget {
  const KAskCta({this.title, this.body, this.onTap, super.key});
  final String? title;
  final String? body;

  /// Defaults to opening astrologer discovery.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final brand = context.brand;
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Pressable(
        child: Material(
          borderRadius: BorderRadius.circular(22),
          clipBehavior: Clip.antiAlias,
          child: Ink(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFFF8A3D),
                  Color(0xFFE8364F),
                  Color(0xFF8B3FE4),
                ],
              ),
            ),
            child: InkWell(
              onTap: onTap ?? () => context.go(Routes.astrologers),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title ?? l.kKitAskTitle,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            body ?? l.kKitAskBody,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.white.withValues(alpha: 0.9),
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              l.kOvAskAstrologer,
                              style: theme.textTheme.labelLarge?.copyWith(
                                color: brand.primaryPressed,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.support_agent_rounded,
                      color: Colors.white,
                      size: 50,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Muted footnote / disclaimer with an info glyph.
class KFootnote extends StatelessWidget {
  const KFootnote(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 15,
            color: context.brand.inkMuted,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodySmall?.copyWith(
                color: context.brand.inkMuted,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Generic body skeleton: a hero-ish block then a few cards.
class KBodySkeleton extends StatelessWidget {
  const KBodySkeleton({this.blocks = const [150, 110, 180], super.key});
  final List<double> blocks;

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: Column(
        children: [
          for (final h in blocks) ...[
            SkeletonBox(height: h, radius: 20),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

/// Segmented control for light surfaces: equal-width options, the selected one
/// raised on the surface with a hue label.
class KSegment extends StatelessWidget {
  const KSegment({
    required this.labels,
    required this.selected,
    required this.onSelect,
    this.hue = AstroPalette.career,
    super.key,
  });

  final List<String> labels;
  final int selected;
  final ValueChanged<int> onSelect;
  final AstroHue hue;

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: brand.sectionBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: brand.hairline),
      ),
      child: Row(
        children: [
          for (var i = 0; i < labels.length; i++)
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onSelect(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(
                    vertical: 9,
                    horizontal: 4,
                  ),
                  decoration: BoxDecoration(
                    color: i == selected
                        ? theme.colorScheme.surface
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: i == selected
                        ? [
                            BoxShadow(
                              color: hue.start.withValues(alpha: 0.16),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Text(
                    labels[i],
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: i == selected ? hue.end : brand.inkMuted,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Collapsible surface card: header row always visible, body revealed on tap.
class KExpandable extends StatefulWidget {
  const KExpandable({
    required this.header,
    required this.body,
    this.initiallyOpen = false,
    this.hue,
    super.key,
  });

  final Widget header;
  final Widget body;
  final bool initiallyOpen;

  /// Tints the card when given (e.g. the running period).
  final AstroHue? hue;

  @override
  State<KExpandable> createState() => _KExpandableState();
}

class _KExpandableState extends State<KExpandable> {
  late bool _open = widget.initiallyOpen;

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    final hue = widget.hue;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: hue == null
            ? Theme.of(context).colorScheme.surface
            : Color.alphaBlend(
                hue.tint(0.07),
                Theme.of(context).colorScheme.surface,
              ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(
            color: hue == null ? brand.hairline : hue.tint(0.35),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => setState(() => _open = !_open),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(child: widget.header),
                    AnimatedRotation(
                      turns: _open ? 0.5 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        Icons.expand_more_rounded,
                        color: brand.inkMuted,
                      ),
                    ),
                  ],
                ),
                AnimatedSize(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutCubic,
                  alignment: Alignment.topCenter,
                  child: _open
                      ? Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: widget.body,
                        )
                      : const SizedBox(width: double.infinity),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Planet dignity → tone, shared by planet / chart / annual-chart rows.
KTone kDignityTone(String dignity) => switch (dignity) {
  'exalted' || 'moolatrikona' || 'own' => KTone.good,
  'debilitated' => KTone.bad,
  'enemy_sign' || 'great_enemy_sign' => KTone.caution,
  _ => KTone.neutral,
};

/// Small tinted capsule (house number, count, short tag).
class KPill extends StatelessWidget {
  const KPill(this.label, {this.hue = AstroPalette.career, super.key});
  final String label;
  final AstroHue hue;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: hue.tint(0.13),
      borderRadius: BorderRadius.circular(999),
    ),
    child: Text(
      label,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
        color: hue.end,
        fontWeight: FontWeight.w800,
      ),
    ),
  );
}

/// Inset note inside a card: small caps title with an icon, then either
/// bullet [lines] or a free [child].
class KNoteBox extends StatelessWidget {
  const KNoteBox({
    required this.title,
    required this.icon,
    this.hue = AstroPalette.career,
    this.lines = const [],
    this.child,
    this.margin = const EdgeInsets.only(top: 12),
    super.key,
  });

  final String title;
  final IconData icon;
  final AstroHue hue;
  final List<String> lines;
  final Widget? child;
  final EdgeInsetsGeometry margin;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      margin: margin,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color.alphaBlend(hue.tint(0.08), theme.colorScheme.surface),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: hue.tint(0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 15, color: hue.end),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title.toUpperCase(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: hue.end,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.6,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          for (final line in lines)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 7, right: 8),
                    child: Container(
                      width: 5,
                      height: 5,
                      decoration: BoxDecoration(
                        color: hue.end,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      line,
                      style: theme.textTheme.bodySmall?.copyWith(height: 1.45),
                    ),
                  ),
                ],
              ),
            ),
          ?child,
        ],
      ),
    );
  }
}
