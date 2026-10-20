import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/util/async_value.dart';
import '../../data/models/catalog.dart';
import '../../data/models/product.dart';
import '../cubit/cart_cubit.dart';
import '../cubit/store_home_cubit.dart';
import '../widgets/consult_widgets.dart';
import '../widgets/store_ui.dart';

import 'package:talkacharya_ui/talkacharya_ui.dart';

/// `/store` — the remedies shop, laid out like the big shopping apps: the
/// categories in a rail down the left, what is in the picked one on the right.
/// "Top picks" (the first rail item) is the storefront: every category as a
/// tile, handpicked remedies, collections and poojas.
class StoreHomePage extends StatefulWidget {
  const StoreHomePage({super.key});

  @override
  State<StoreHomePage> createState() => _StoreHomePageState();
}

class _StoreHomePageState extends State<StoreHomePage> {
  @override
  void initState() {
    super.initState();
    getIt<CartCubit>().load();
  }

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: brand.canvas,
        body: Column(
          children: [
            const _StoreHeader(),
            Expanded(
              child: BlocBuilder<StoreHomeCubit, StoreHomeState>(
                builder: (context, state) => _body(context, state),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _body(BuildContext context, StoreHomeState state) {
    final l = context.l10n;
    final home = state.home;
    if (home.isError && !home.hasValue) {
      return ErrorView(
        title: l.storeLoadError,
        message: home.error ?? '',
        onRetry: () => context.read<StoreHomeCubit>().load(force: true),
      );
    }
    final data = home.value;
    if (data == null) return const _SplitSkeleton();
    if (data.isEmpty) {
      return EmptyState(
        icon: Icons.storefront_rounded,
        title: l.storeEmptyTitle,
        message: l.storeEmptyBody,
      );
    }
    final top = data.categories.where((c) => c.parent == null).toList();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _CategoryRail(categories: top, selected: state.selected),
        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            switchInCurve: Curves.easeOut,
            child: KeyedSubtree(
              key: ValueKey(state.selected ?? '_top'),
              child: state.selected == null
                  ? _TopPicksPane(home: data, state: state)
                  : _CategoryPane(
                      category: data.categories.firstWhere(
                        (c) => c.slug == state.selected,
                        orElse: () => StoreCategory(
                          slug: state.selected!,
                          name: state.selected!,
                        ),
                      ),
                      children: data.categories
                          .where((c) => c.parent == state.selected)
                          .toList(),
                      products:
                          state.products[state.selected] ??
                          const AsyncValue.loading(),
                    ),
            ),
          ),
        ),
      ],
    );
  }
}

// --- header ---------------------------------------------------------------------------

class _StoreHeader extends StatelessWidget {
  const _StoreHeader();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final brand = context.brand;
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
      child: Stack(
        children: [
          const Positioned.fill(child: CosmicBackdrop()),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(4, 4, 6, 14),
              child: Column(
                children: [
                  Row(
                    children: [
                      BackButton(color: brand.onCosmic),
                      Expanded(
                        child: Text(
                          l.storeTitle,
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: brand.onCosmic,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      IconButton(
                        tooltip: l.storeMyOrders,
                        onPressed: () => context.push(Routes.storeOrders),
                        icon: Icon(
                          Icons.receipt_long_rounded,
                          color: brand.onCosmic,
                        ),
                      ),
                      CartButton(color: brand.onCosmic),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(14, 6, 10, 0),
                    child: _SearchPill(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchPill extends StatelessWidget {
  const _SearchPill();

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    return Pressable(
      child: Material(
        color: Colors.white,
        shape: const StadiumBorder(),
        clipBehavior: Clip.antiAlias,
        elevation: 2,
        shadowColor: Colors.black26,
        child: InkWell(
          onTap: () =>
              context.push(Routes.storeProductsWith({'focus': 'search'})),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(Icons.search_rounded, color: brand.inkMuted),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    context.l10n.storeSearchHint,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: brand.inkMuted),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// --- the rail --------------------------------------------------------------------------

/// The left column: "Top picks", then every top-level category. The open one
/// sits on the page colour with a gold bar; the rest on a quieter shade.
class _CategoryRail extends StatelessWidget {
  const _CategoryRail({required this.categories, required this.selected});

  final List<StoreCategory> categories;
  final String? selected;

  static const width = 78.0;

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    return Container(
      width: width,
      color: brand.sectionBg,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _RailItem(
            label: context.l10n.storeTopPicks,
            selected: selected == null,
            onTap: () => context.read<StoreHomeCubit>().select(null),
            leading: const HueIcon(
              hue: AstroPalette.money,
              icon: Icons.auto_awesome_rounded,
              size: 36,
              iconSize: 18,
            ),
          ),
          for (final c in categories)
            _RailItem(
              label: c.name,
              selected: selected == c.slug,
              onTap: () => context.read<StoreHomeCubit>().select(c.slug),
              leading: _CategoryPicture(category: c, size: 36, radius: 10),
            ),
        ],
      ),
    );
  }
}

class _RailItem extends StatelessWidget {
  const _RailItem({
    required this.label,
    required this.selected,
    required this.onTap,
    required this.leading,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Widget leading;

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    final theme = Theme.of(context);
    return Semantics(
      selected: selected,
      button: true,
      child: Material(
        color: selected ? brand.canvas : Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticFeedback.selectionClick();
            onTap();
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: brand.hairline)),
            ),
            child: Stack(
              children: [
                // Full rail width, so the picture and label sit in the middle
                // (a Stack child otherwise shrinks to its content, flush left).
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 10, 5, 9),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: AnimatedScale(
                          scale: selected ? 1.06 : 1,
                          duration: const Duration(milliseconds: 180),
                          child: leading,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        label,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontWeight: selected
                              ? FontWeight.w800
                              : FontWeight.w600,
                          color: selected ? brand.ink : brand.inkMuted,
                          height: 1.15,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: selected ? 4 : 0,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: BrandColors.goldGradient,
                      ),
                      borderRadius: BorderRadius.horizontal(
                        right: Radius.circular(4),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A category's picture (the server's square cut), or its hue and icon when it
/// has none — never an empty box.
class _CategoryPicture extends StatelessWidget {
  const _CategoryPicture({
    required this.category,
    required this.size,
    required this.radius,
    this.large = false,
  });

  final StoreCategory category;
  final double size;
  final double radius;

  /// Use the bigger cut (grid tiles) rather than the rail thumbnail.
  final bool large;

  @override
  Widget build(BuildContext context) {
    final c = category;
    final url = large ? c.image : c.thumb;
    if (url == null) {
      return HueIcon(
        hue: storeHue(c.slug),
        icon: storeIcon(c.slug),
        size: size,
        iconSize: size * 0.5,
      );
    }
    return SizedBox.square(
      dimension: size,
      child: StoreImage(
        url: url,
        slug: c.slug,
        radius: radius,
        iconSize: size * 0.45,
      ),
    );
  }
}

// --- right pane: top picks -------------------------------------------------------------

class _TopPicksPane extends StatelessWidget {
  const _TopPicksPane({required this.home, required this.state});

  final StoreHome home;
  final StoreHomeState state;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final advice = state.latestAdvice;
    final top = home.categories.where((c) => c.parent == null).toList();
    return RefreshIndicator(
      onRefresh: () => context.read<StoreHomeCubit>().load(force: true),
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          const SliverToBoxAdapter(child: _QuickLinks()),
          if (advice != null)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
                child: ConsultSummaryCard(consult: advice),
              ),
            ),
          if (top.isNotEmpty) ...[
            _PaneTitle(l.storeTopCategories),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              sliver: SliverGrid.builder(
                itemCount: top.length,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 92,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                  mainAxisExtent: 94,
                ),
                itemBuilder: (context, i) => _CategoryTile(
                  category: top[i],
                  onTap: () =>
                      context.read<StoreHomeCubit>().select(top[i].slug),
                ),
              ),
            ),
          ],
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(12, 14, 12, 4),
              child: _ConsultBanner(),
            ),
          ),
          if (home.featured.isNotEmpty) ...[
            _PaneTitle(
              l.storeFeatured,
              onSeeAll: () =>
                  context.push(Routes.storeProductsWith({'featured': '1'})),
            ),
            _ProductGrid(products: home.featured),
          ],
          if (home.collections.isNotEmpty) ...[
            _PaneTitle(l.storeCollections),
            SliverList.separated(
              itemCount: home.collections.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, i) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: _CollectionBanner(collection: home.collections[i], i: i),
              ),
            ),
          ],
          if (home.poojas.isNotEmpty) ...[
            _PaneTitle(
              l.storePoojas,
              onSeeAll: () => context.push(
                Routes.storeProductsWith({'fulfilment': 'service'}),
              ),
            ),
            _ProductGrid(products: home.poojas),
          ],
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
              child: Text(
                l.storeDisclaimerFooter,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: context.brand.inkMuted,
                  height: 1.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Orders, pooja bookings and advice, one tap away — like the chips under a
/// shopping app's storefront.
class _QuickLinks extends StatelessWidget {
  const _QuickLinks();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final links = [
      (Icons.receipt_long_rounded, l.storeMyOrders, Routes.storeOrders),
      (Icons.temple_hindu_rounded, l.storeMyPoojas, Routes.storePoojaBookings),
      (Icons.videocam_rounded, l.storeMyAdviceShort, Routes.storeConsults),
    ];
    return SizedBox(
      height: 52,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
        itemCount: links.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final (icon, label, route) = links[i];
          return Pressable(
            child: Material(
              color: Theme.of(context).colorScheme.surface,
              shape: StadiumBorder(
                side: BorderSide(color: context.brand.hairline),
              ),
              child: InkWell(
                customBorder: const StadiumBorder(),
                onTap: () => context.push(route),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      Icon(icon, size: 16, color: context.brand.gold),
                      const SizedBox(width: 6),
                      Text(
                        label,
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// --- right pane: one category ---------------------------------------------------------

class _CategoryPane extends StatelessWidget {
  const _CategoryPane({
    required this.category,
    required this.children,
    required this.products,
  });

  final StoreCategory category;
  final List<StoreCategory> children;
  final AsyncValue<ProductPage> products;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final page = products.value;
    final c = category;
    void viewAll([String? slug]) =>
        context.push(Routes.storeProductsWith({'category': slug ?? c.slug}));
    return RefreshIndicator(
      onRefresh: () => context.read<StoreHomeCubit>().retryCategory(),
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: _CategoryHero(category: c, onViewAll: viewAll),
          ),
          if (children.isNotEmpty) ...[
            _PaneTitle(l.storeShopByType),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              sliver: SliverGrid.builder(
                itemCount: children.length,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 92,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                  mainAxisExtent: 94,
                ),
                itemBuilder: (context, i) => _CategoryTile(
                  category: children[i],
                  onTap: () => viewAll(children[i].slug),
                ),
              ),
            ),
          ],
          _PaneTitle(
            l.storePopularIn(c.name),
            onSeeAll: (page?.count ?? 0) > (page?.items.length ?? 0)
                ? viewAll
                : null,
          ),
          if (page == null && products.isError)
            SliverToBoxAdapter(
              child: ErrorView(
                message: products.error ?? '',
                onRetry: () => context.read<StoreHomeCubit>().retryCategory(),
              ),
            )
          else if (page == null)
            const SliverToBoxAdapter(child: _GridSkeleton())
          else if (page.items.isEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: EmptyState(
                  icon: storeIcon(c.slug),
                  hue: storeHue(c.slug),
                  title: l.storeCategoryEmpty,
                ),
              ),
            )
          else ...[
            _ProductGrid(products: page.items),
            if (page.count > page.items.length)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                  child: OutlinedButton.icon(
                    onPressed: viewAll,
                    icon: const Icon(Icons.grid_view_rounded, size: 18),
                    label: Text(l.storeViewAllCount(page.count)),
                  ),
                ),
              ),
          ],
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }
}

/// The open category: its picture, name and a line about it, on its own hue.
class _CategoryHero extends StatelessWidget {
  const _CategoryHero({required this.category, required this.onViewAll});

  final StoreCategory category;
  final VoidCallback onViewAll;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = category;
    final hue = storeHue(c.slug);
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
      child: Pressable(
        child: Material(
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: InkWell(
            onTap: onViewAll,
            child: Ink(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [hue.tint(0.22), hue.tint(0.06)],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            c.name,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          if (c.description.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              c.description,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: context.brand.inkMuted,
                                height: 1.3,
                              ),
                            ),
                          ],
                          const SizedBox(height: 8),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                context.l10n.storeViewAll,
                                style: theme.textTheme.labelLarge?.copyWith(
                                  color: hue.end,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Icon(
                                Icons.chevron_right_rounded,
                                size: 18,
                                color: hue.end,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    _CategoryPicture(
                      category: c,
                      size: 52,
                      radius: 14,
                      large: true,
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

// --- shared pieces ----------------------------------------------------------------------

class _PaneTitle extends StatelessWidget {
  const _PaneTitle(this.title, {this.onSeeAll});

  final String title;
  final VoidCallback? onSeeAll;

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    final theme = Theme.of(context);
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 18, 6, 8),
        child: Row(
          children: [
            Flexible(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(width: 8),
            // The dashed rule the big storefronts use to close a heading.
            Expanded(
              child: LayoutBuilder(
                builder: (context, box) => Row(
                  children: [
                    for (var i = 0; i < (box.maxWidth / 7).floor(); i++)
                      Container(
                        width: 4,
                        height: 1,
                        margin: const EdgeInsets.only(right: 3),
                        color: brand.hairline,
                      ),
                  ],
                ),
              ),
            ),
            if (onSeeAll != null)
              TextButton(
                onPressed: onSeeAll,
                style: TextButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                ),
                child: Text(context.l10n.storeViewAll),
              ),
          ],
        ),
      ),
    );
  }
}

/// A category as a tile: its square picture and its name under it.
class _CategoryTile extends StatelessWidget {
  const _CategoryTile({required this.category, required this.onTap});

  final StoreCategory category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Column(
            children: [
              // A picture when the category has one, else its hue and icon —
              // a small mark, not a big box.
              _CategoryPicture(
                category: category,
                size: 50,
                radius: 14,
                large: true,
              ),
              const SizedBox(height: 6),
              Text(
                category.name,
                maxLines: 2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  height: 1.15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Two products a row, sized for the pane beside the rail.
class _ProductGrid extends StatelessWidget {
  const _ProductGrid({required this.products});

  final List<ProductCard> products;

  @override
  Widget build(BuildContext context) => SliverPadding(
    padding: const EdgeInsets.symmetric(horizontal: 10),
    sliver: SliverLayoutBuilder(
      builder: (context, constraints) {
        // A square picture as wide as the tile, then two lines of title and
        // the price — no fixed height, so no empty band on narrow phones.
        final tile = (constraints.crossAxisExtent - 10) / 2;
        final scale = MediaQuery.textScalerOf(context).scale(1);
        return SliverGrid.builder(
          itemCount: products.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            mainAxisExtent: tile + 82 * scale,
          ),
          itemBuilder: (_, i) => CompactProductTile(product: products[i]),
        );
      },
    ),
  );
}

class _CollectionBanner extends StatelessWidget {
  const _CollectionBanner({required this.collection, required this.i});

  final StoreCollection collection;
  final int i;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = collection;
    final hue = AstroPalette.at(i);
    return Pressable(
      child: AspectRatio(
        aspectRatio: 2,
        child: Material(
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: InkWell(
            onTap: () => context.push(Routes.storeCollection(c.slug)),
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (c.image != null)
                  StoreImage(url: c.image, slug: c.slug, radius: 0)
                else
                  DecoratedBox(
                    decoration: BoxDecoration(gradient: hue.linear()),
                  ),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Color(0xB3000000)],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        c.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      if (c.description.isNotEmpty)
                        Text(
                          c.description,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.white.withValues(alpha: 0.85),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ConsultBanner extends StatelessWidget {
  const _ConsultBanner();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    return Pressable(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: AstroPalette.romance,
          ),
          boxShadow: [
            BoxShadow(
              color: AstroPalette.romance[1].withValues(alpha: 0.25),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: () => context.go(Routes.astrologersWith(channel: 'video')),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 10, 14),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l.storeConsultBannerTitle,
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l.storeConsultBannerBody,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.white.withValues(alpha: 0.9),
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            l.storeConsultBannerCta,
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: AstroPalette.romance[2],
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.auto_awesome_rounded,
                    size: 40,
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// --- skeletons --------------------------------------------------------------------------

class _SplitSkeleton extends StatelessWidget {
  const _SplitSkeleton();

  @override
  Widget build(BuildContext context) => AppShimmer(
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: _CategoryRail.width,
          color: context.brand.sectionBg,
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Column(
            children: [
              for (var i = 0; i < 6; i++) ...[
                const SkeletonBox(width: 36, height: 36, radius: 10),
                const SizedBox(height: 6),
                const SkeletonBox(width: 56, height: 10),
                const SizedBox(height: 18),
              ],
            ],
          ),
        ),
        const Expanded(child: _GridSkeleton()),
      ],
    ),
  );
}

class _GridSkeleton extends StatelessWidget {
  const _GridSkeleton();

  @override
  Widget build(BuildContext context) => const AppShimmer(
    child: Padding(
      padding: EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkeletonBox(width: 140, height: 16),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: SkeletonBox(height: 220, radius: 16)),
              SizedBox(width: 10),
              Expanded(child: SkeletonBox(height: 220, radius: 16)),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: SkeletonBox(height: 220, radius: 16)),
              SizedBox(width: 10),
              Expanded(child: SkeletonBox(height: 220, radius: 16)),
            ],
          ),
        ],
      ),
    ),
  );
}
