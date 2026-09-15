import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/brand_colors.dart';
import '../../../../core/util/async_value.dart';
import '../../../../shared/widgets/error_view.dart';

/// A plain themed card with padding (the app's [CardTheme] gives the border +
/// radius; this just adds inset).
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
    final card = Card(
      color: tint ? context.brand.tint : null,
      child: Padding(padding: padding, child: child),
    );
    return card;
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
        color: Theme.of(context).colorScheme.onSurfaceVariant,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.7,
      ),
    );
  }
}

/// The warm "what this means for you" card.
class ReadingCard extends StatelessWidget {
  const ReadingCard({required this.body, this.title, super.key});
  final String? title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    return KCard(
      tint: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title ?? context.l10n.kReadingCardTitle,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 12.5,
              color: brand.onTint,
            ),
          ),
          const SizedBox(height: 5),
          Text(body, style: const TextStyle(fontSize: 13.5, height: 1.45)),
        ],
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
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color ?? scheme.onSurface,
        ),
      ),
    );
  }
}

/// Renders an [AsyncValue] slice — a [skeleton] (or spinner) while first
/// loading, a friendly [ErrorView] on failure with no cached value, otherwise
/// the data (kept visible while a refresh runs).
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

  /// Shown while the slice loads for the first time. Falls back to a centred
  /// spinner when not supplied.
  final Widget? skeleton;

  @override
  Widget build(BuildContext context) {
    Widget loading() =>
        skeleton ??
        const Center(
          child: Padding(
            padding: EdgeInsets.all(48),
            child: CircularProgressIndicator(),
          ),
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
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: onTap,
      icon: const Icon(Icons.chat_bubble_outline_rounded, size: 18),
      label: Text(
        label ?? context.l10n.kOvAskAstrologer,
        textAlign: TextAlign.center,
      ),
      style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(50)),
    );
  }
}
