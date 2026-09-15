import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/astro_palette.dart';
import '../../../../core/theme/brand_colors.dart';
import '../../../../core/util/async_value.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../../../shared/widgets/hue_widgets.dart';
import 'k_kit.dart';

export 'k_kit.dart';

/// Surface card used across the kundali screens: surface fill, hairline, soft
/// radius (see [KSurface]). [tint] gives the warm "reading" wash instead.
class KCard extends StatelessWidget {
  const KCard({
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.tint = false,
    super.key,
  });

  final Widget child;
  final EdgeInsets padding;
  final bool tint;

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: KSurface(
        padding: padding,
        radius: 18,
        color: tint ? brand.tint : null,
        borderColor: tint ? brand.glowAccent.withValues(alpha: 0.25) : null,
        child: child,
      ),
    );
  }
}

/// Small upper-case section label.
class KLabel extends StatelessWidget {
  const KLabel(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
        color: context.brand.inkMuted,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.0,
      ),
    );
  }
}

/// The warm "what this means for you" card.
class ReadingCard extends StatelessWidget {
  const ReadingCard({
    required this.body,
    this.title,
    this.hue = AstroPalette.money,
    super.key,
  });
  final String? title;
  final String body;
  final AstroHue hue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: KHueCard(
        hue: hue,
        radius: 18,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HueIcon(
              hue: hue,
              icon: Icons.auto_awesome_rounded,
              size: 32,
              iconSize: 17,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title ?? context.l10n.kReadingCardTitle,
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: hue.end,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    body,
                    style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MetaChip extends StatelessWidget {
  const MetaChip(this.label, {this.color, super.key});
  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: brand.sectionBg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: brand.hairline),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: color ?? brand.ink,
        ),
      ),
    );
  }
}

/// Renders an [AsyncValue] slice — a [skeleton] (default: shimmer blocks)
/// while first loading, a friendly [ErrorView] on failure with no cached value,
/// otherwise the data (kept visible while a refresh runs).
class SliceBuilder<T> extends StatelessWidget {
  const SliceBuilder({
    required this.slice,
    required this.onRetry,
    required this.builder,
    this.skeleton,
    super.key,
  });

  final AsyncValue<T> slice;
  final VoidCallback onRetry;
  final Widget Function(BuildContext, T) builder;

  /// Shown while the slice loads for the first time.
  final Widget? skeleton;

  @override
  Widget build(BuildContext context) {
    Widget loading() =>
        skeleton ??
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: KBodySkeleton(),
        );
    return slice.when(
      idle: loading,
      loading: loading,
      error: (message) => ErrorView(message: message, onRetry: onRetry),
      data: (value) => builder(context, value),
    );
  }
}

/// Bottom "Ask an astrologer" CTA used on most kundali screens.
class AskAstrologerBar extends StatelessWidget {
  const AskAstrologerBar({this.label, this.onTap, super.key});
  final String? label;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => KAskCta(title: label, onTap: onTap);
}
