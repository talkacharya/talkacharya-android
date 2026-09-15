import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/astro_palette.dart';
import '../../../../core/theme/brand_colors.dart';
import '../../../../core/util/money.dart';
import '../../../../shared/widgets/hue_widgets.dart';
import '../../../../shared/widgets/pressable.dart';
import '../../../../shared/widgets/skeleton.dart';
import '../../../auth/presentation/bloc/auth/auth_bloc.dart';
import '../../data/models/product.dart';
import '../cubit/cart_cubit.dart';

/// The customer's store currency (their preferred wallet currency).
String storeCurrency(BuildContext context) =>
    (context.read<AuthBloc>().state.user?.preferredCurrency ?? 'INR')
        .toUpperCase();

String storeMoney(BuildContext context, num amount, [String? currency]) =>
    Money.format(
      amount,
      currency ?? storeCurrency(context),
      locale: Localizations.localeOf(context).toLanguageTag(),
    );

String storeDate(BuildContext context, DateTime? d, {bool withTime = false}) {
  if (d == null) return '';
  final locale = Localizations.localeOf(context).toLanguageTag();
  return (withTime
          ? DateFormat('EEE, d MMM · h:mm a', locale)
          : DateFormat('d MMM y', locale))
      .format(d);
}

/// Colour family for a product type / category slug, so a rudraksha always wears
/// the same hue across tiles, heroes and chips.
AstroHue storeHue(String slug) => switch (slug) {
  'rudraksha' || 'malas-bracelets' || 'mala' => AstroPalette.earth,
  'gemstone' || 'gemstones' => AstroPalette.career,
  'gemstone_ring' || 'rings-pendants' => AstroPalette.love,
  'yantra' || 'yantras' => AstroPalette.money,
  'pooja' || 'poojas' || 'chadhava' => AstroPalette.fire,
  'samagri' || 'pooja-samagri' => AstroPalette.health,
  'digital' || 'reports' => AstroPalette.air,
  _ => AstroPalette.forId(slug),
};

IconData storeIcon(String slug) => switch (slug) {
  'rudraksha' || 'malas-bracelets' || 'mala' => Icons.blur_circular_rounded,
  'gemstone' || 'gemstones' => Icons.diamond_rounded,
  'gemstone_ring' || 'rings-pendants' => Icons.diamond_outlined,
  'yantra' || 'yantras' => Icons.change_history_rounded,
  'pooja' || 'poojas' => Icons.temple_hindu_rounded,
  'chadhava' => Icons.volunteer_activism_rounded,
  'samagri' || 'pooja-samagri' => Icons.local_florist_rounded,
  'digital' || 'reports' => Icons.description_rounded,
  _ => Icons.auto_awesome_rounded,
};

/// Network image with a hue-gradient placeholder (never a grey box).
class StoreImage extends StatelessWidget {
  const StoreImage({
    required this.url,
    required this.slug,
    this.radius = 16,
    this.iconSize = 36,
    super.key,
  });

  final String? url;

  /// Type / category slug for the placeholder colour + icon.
  final String slug;
  final double radius;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final hue = storeHue(slug);
    final placeholder = DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [hue.tint(0.28), hue.tint(0.08)],
        ),
      ),
      child: Center(
        child: Icon(storeIcon(slug), size: iconSize, color: hue.end),
      ),
    );
    final u = url;
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: (u == null || u.isEmpty)
          ? placeholder
          : CachedNetworkImage(
              imageUrl: u,
              fit: BoxFit.cover,
              placeholder: (_, _) => placeholder,
              errorWidget: (_, _, _) => placeholder,
            ),
    );
  }
}

/// "₹499  ~~₹999~~  50% off".
class PriceTag extends StatelessWidget {
  const PriceTag({
    required this.price,
    this.compareAt,
    this.currency,
    this.large = false,
    this.fromPrefix = false,
    super.key,
  });

  final double? price;
  final double? compareAt;
  final String? currency;
  final bool large;
  final bool fromPrefix;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brand = context.brand;
    final p = price;
    if (p == null) {
      return Text(
        context.l10n.storeUnavailable,
        style: theme.textTheme.labelLarge?.copyWith(color: brand.inkMuted),
      );
    }
    final discount = discountOf(p, compareAt);
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 6,
      runSpacing: 2,
      children: [
        Text(
          fromPrefix
              ? context.l10n.storePriceFrom(storeMoney(context, p, currency))
              : storeMoney(context, p, currency),
          style:
              (large
                      ? theme.textTheme.headlineSmall
                      : theme.textTheme.titleMedium)
                  ?.copyWith(fontWeight: FontWeight.w800, color: brand.ink),
        ),
        if (discount != null) ...[
          Text(
            storeMoney(context, compareAt!, currency),
            style: theme.textTheme.bodySmall?.copyWith(
              color: brand.inkMuted,
              decoration: TextDecoration.lineThrough,
            ),
          ),
          DiscountPill(percent: discount),
        ],
      ],
    );
  }
}

class DiscountPill extends StatelessWidget {
  const DiscountPill({required this.percent, super.key});
  final int percent;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
    decoration: BoxDecoration(
      color: context.brand.online.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(999),
    ),
    child: Text(
      context.l10n.storeOff(percent),
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
        color: context.brand.online,
        fontWeight: FontWeight.w800,
      ),
    ),
  );
}

/// Small rounded label on a hue tint ("Needs astrologer", "Pooja", "Certified").
class StoreBadge extends StatelessWidget {
  const StoreBadge({
    required this.label,
    required this.hue,
    this.icon,
    super.key,
  });

  final String label;
  final AstroHue hue;
  final IconData? icon;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(
      color: hue.tint(0.14),
      borderRadius: BorderRadius.circular(999),
      border: Border.all(color: hue.tint(0.28)),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 12, color: hue.end),
          const SizedBox(width: 4),
        ],
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: hue.end,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    ),
  );
}

/// Rating stars + count, compact.
class RatingLine extends StatelessWidget {
  const RatingLine({required this.avg, required this.count, super.key});
  final double avg;
  final int count;

  @override
  Widget build(BuildContext context) {
    if (count <= 0) return const SizedBox.shrink();
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.star_rounded, size: 15, color: context.brand.gold),
        const SizedBox(width: 2),
        Text(
          '${avg.toStringAsFixed(1)} (${NumberFormat.compact().format(count)})',
          style: theme.textTheme.labelSmall?.copyWith(
            color: context.brand.inkMuted,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

/// Grid tile for listings.
class ProductTile extends StatelessWidget {
  const ProductTile({required this.product, this.onTap, super.key});

  final ProductCard product;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brand = context.brand;
    final l = context.l10n;
    final p = product;
    return Pressable(
      child: Material(
        color: theme.colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: brand.hairline),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap ?? () => context.push(Routes.storeProduct(p.slug)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    StoreImage(url: p.image, slug: p.type, radius: 0),
                    Positioned(
                      left: 8,
                      top: 8,
                      right: 8,
                      child: Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: [
                          if (p.isService)
                            StoreBadge(
                              label: l.storeBadgePooja,
                              hue: AstroPalette.fire,
                              icon: Icons.temple_hindu_rounded,
                            ),
                          if (p.needsAstrologer)
                            StoreBadge(
                              label: l.storeBadgeAskAstrologer,
                              hue: AstroPalette.career,
                              icon: Icons.videocam_rounded,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 9, 10, 11),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      p.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    RatingLine(avg: p.ratingAvg, count: p.ratingCount),
                    const SizedBox(height: 4),
                    PriceTag(price: p.priceFrom, compareAt: p.compareAt),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Compact card for horizontal rails.
class ProductRailCard extends StatelessWidget {
  const ProductRailCard({required this.product, this.width = 156, super.key});

  final ProductCard product;
  final double width;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: width,
    child: ProductTile(product: product),
  );
}

class ProductGridSkeleton extends StatelessWidget {
  const ProductGridSkeleton({this.count = 4, super.key});
  final int count;

  @override
  Widget build(BuildContext context) => AppShimmer(
    child: GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      gridDelegate: kProductGrid,
      itemCount: count,
      itemBuilder: (_, _) => const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(aspectRatio: 1, child: SkeletonBox(radius: 18)),
          SizedBox(height: 10),
          SkeletonBox(width: 120),
          SizedBox(height: 6),
          SkeletonBox(width: 70),
        ],
      ),
    ),
  );
}

const kProductGrid = SliverGridDelegateWithFixedCrossAxisCount(
  crossAxisCount: 2,
  mainAxisSpacing: 12,
  crossAxisSpacing: 12,
  childAspectRatio: 0.62,
);

/// A plain surface card with the app's hairline border.
class StoreCard extends StatelessWidget {
  const StoreCard({
    required this.child,
    this.padding = const EdgeInsets.all(14),
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: padding,
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: context.brand.hairline),
    ),
    child: child,
  );
}

/// Title row inside a detail page (accent bar + Fraunces title).
class StoreSectionTitle extends StatelessWidget {
  const StoreSectionTitle(
    this.title, {
    this.hue = AstroPalette.money,
    this.trailing,
    super.key,
  });

  final String title;
  final AstroHue hue;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 10, top: 4),
    child: Row(
      children: [
        Container(
          width: 4,
          height: 20,
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
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontSize: 19,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        ?trailing,
      ],
    ),
  );
}

/// Cart icon with a live count badge; opens the cart.
class CartButton extends StatelessWidget {
  const CartButton({this.color, super.key});
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<CartCubit>(),
      child: BlocBuilder<CartCubit, CartState>(
        buildWhen: (a, b) => a.count != b.count,
        builder: (context, state) => IconButton(
          tooltip: context.l10n.storeCartTitle,
          onPressed: () => context.push(Routes.storeCart),
          icon: Badge(
            isLabelVisible: state.count > 0,
            label: Text('${state.count}'),
            backgroundColor: AstroPalette.romance[1],
            child: Icon(Icons.shopping_bag_outlined, color: color),
          ),
        ),
      ),
    );
  }
}

/// Status pill for orders / sub-orders / bookings.
class StoreStatusChip extends StatelessWidget {
  const StoreStatusChip({required this.label, required this.tone, super.key});

  final String label;

  /// good | warn | bad | info | neutral
  final String tone;

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    final color = switch (tone) {
      'good' => brand.online,
      'warn' => AstroPalette.money.end,
      'bad' => brand.live,
      'info' => AstroPalette.career.end,
      _ => brand.inkMuted,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

/// Sticky bottom bar used by product detail, cart and checkout.
class StoreActionBar extends StatelessWidget {
  const StoreActionBar({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(top: BorderSide(color: context.brand.hairline)),
        boxShadow: [
          BoxShadow(
            color: context.brand.cosmicStart.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
          child: child,
        ),
      ),
    );
  }
}

/// The one gold-gradient primary CTA per screen.
class GoldButton extends StatelessWidget {
  const GoldButton({
    required this.label,
    required this.onPressed,
    this.icon,
    this.busy = false,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null && !busy;
    return Opacity(
      opacity: enabled || busy ? 1 : 0.5,
      child: Pressable(
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: const LinearGradient(colors: BrandColors.goldGradient),
            boxShadow: context.brand.shadowWarm,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: enabled ? onPressed : null,
              child: SizedBox(
                height: 52,
                child: Center(
                  child: busy
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.4,
                            color: Color(0xFF3A1A00),
                          ),
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (icon != null) ...[
                              Icon(
                                icon,
                                color: const Color(0xFF3A1A00),
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                            ],
                            Flexible(
                              child: Text(
                                label,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(
                                      color: const Color(0xFF3A1A00),
                                      fontWeight: FontWeight.w800,
                                    ),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Avatar with a presence dot, for astrologer rows.
class PresenceAvatar extends StatelessWidget {
  const PresenceAvatar({
    required this.id,
    required this.name,
    this.url,
    this.presence = 'offline',
    this.size = 52,
    super.key,
  });

  final String id;
  final String name;
  final String? url;
  final String presence;
  final double size;

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    final dot = switch (presence) {
      'online' => brand.online,
      'busy' => AstroPalette.money.end,
      _ => brand.inkMuted,
    };
    return Stack(
      clipBehavior: Clip.none,
      children: [
        HueAvatar(
          name: name,
          url: url,
          hue: AstroPalette.forId(id),
          size: size,
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: Container(
            width: size * 0.26,
            height: size * 0.26,
            decoration: BoxDecoration(
              color: dot,
              shape: BoxShape.circle,
              border: Border.all(
                color: Theme.of(context).colorScheme.surface,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
