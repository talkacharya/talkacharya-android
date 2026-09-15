import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/astro_palette.dart';
import '../../../../core/theme/brand_colors.dart';
import '../../../../shared/widgets/cosmic.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/fade_slide_in.dart';
import '../../../../shared/widgets/hue_widgets.dart';
import '../../../../shared/widgets/pressable.dart';
import '../../../../shared/widgets/skeleton.dart';
import '../../../home/presentation/view/widgets/home_shared.dart'
    show SectionHeader;
import '../../data/models/catalog.dart';
import '../../data/models/product.dart';
import '../cubit/cart_cubit.dart';
import '../cubit/store_home_cubit.dart';
import '../widgets/consult_widgets.dart';
import '../widgets/store_ui.dart';

/// `/store` — the remedies shop landing.
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
        body: BlocBuilder<StoreHomeCubit, StoreHomeState>(
          builder: (context, state) => RefreshIndicator(
            onRefresh: () => context.read<StoreHomeCubit>().load(force: true),
            color: AstroPalette.romance[1],
            edgeOffset: 120,
            child: CustomScrollView(
              slivers: [
                const _Hero(),
                SliverPadding(
                  padding: const EdgeInsets.only(top: 14, bottom: 48),
                  sliver: SliverList.list(children: _body(context, state)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _body(BuildContext context, StoreHomeState state) {
    final l = context.l10n;
    final home = state.home;
    if (home.isError && !home.hasValue) {
      return [
        SizedBox(
          height: 360,
          child: ErrorView(
            title: l.storeLoadError,
            message: home.error ?? '',
            onRetry: () => context.read<StoreHomeCubit>().load(force: true),
          ),
        ),
      ];
    }
    final data = home.value;
    if (data == null) return const [_HomeSkeleton()];
    if (data.isEmpty) {
      return [
        SizedBox(
          height: 360,
          child: EmptyState(
            icon: Icons.storefront_rounded,
            title: l.storeEmptyTitle,
            message: l.storeEmptyBody,
          ),
        ),
      ];
    }
    final advice = state.latestAdvice;
    return FadeSlideIn.list([
      const _TrustStrip(),
      if (advice != null)
        _Section(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SectionHeader(
                title: l.storeMyAdvice,
                hue: AstroPalette.career,
                onSeeAll: () => context.push(Routes.storeConsults),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ConsultSummaryCard(consult: advice),
              ),
            ],
          ),
        ),
      if (data.categories.isNotEmpty)
        _Section(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SectionHeader(title: l.storeCategories),
              const SizedBox(height: 12),
              _CategoryGrid(categories: data.categories),
            ],
          ),
        ),
      const _Section(child: _ConsultBanner()),
      if (data.featured.isNotEmpty)
        _Section(
          child: _ProductRail(
            title: l.storeFeatured,
            subtitle: l.storeFeaturedSub,
            hue: AstroPalette.money,
            products: data.featured,
            onSeeAll: () =>
                context.push(Routes.storeProductsWith({'featured': '1'})),
          ),
        ),
      if (data.collections.isNotEmpty)
        _Section(child: _CollectionsRail(collections: data.collections)),
      if (data.poojas.isNotEmpty)
        _Section(
          child: _ProductRail(
            title: l.storePoojas,
            subtitle: l.storePoojasSub,
            hue: AstroPalette.fire,
            products: data.poojas,
            onSeeAll: () => context.push(
              Routes.storeProductsWith({'fulfilment': 'service'}),
            ),
          ),
        ),
      Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
        child: Text(
          l.storeDisclaimerFooter,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: context.brand.inkMuted,
            height: 1.4,
          ),
        ),
      ),
    ]);
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) =>
      Padding(padding: const EdgeInsets.only(bottom: 22), child: child);
}

// --- hero -------------------------------------------------------------------------

class _Hero extends StatelessWidget {
  const _Hero();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final brand = context.brand;
    return SliverAppBar(
      pinned: true,
      expandedHeight: 238,
      backgroundColor: brand.cosmicStart,
      foregroundColor: brand.onCosmic,
      surfaceTintColor: Colors.transparent,
      title: Text(
        l.storeTitle,
        style: theme.textTheme.titleLarge?.copyWith(
          color: brand.onCosmic,
          fontWeight: FontWeight.w700,
        ),
      ),
      actions: [
        IconButton(
          tooltip: l.storeMyOrders,
          onPressed: () => context.push(Routes.storeOrders),
          icon: Icon(Icons.receipt_long_rounded, color: brand.onCosmic),
        ),
        CartButton(color: brand.onCosmic),
        const SizedBox(width: 4),
      ],
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        background: Stack(
          fit: StackFit.expand,
          children: [
            const CosmicBackdrop(),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 60, 20, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      l.storeHeroSubtitle,
                      maxLines: 2,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: brand.onCosmicMuted,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 14),
                    const _SearchPill(),
                  ],
                ),
              ),
            ),
          ],
        ),
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
        color: Colors.white.withValues(alpha: 0.12),
        shape: StadiumBorder(
          side: BorderSide(color: Colors.white.withValues(alpha: 0.22)),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () =>
              context.push(Routes.storeProductsWith({'focus': 'search'})),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
            child: Row(
              children: [
                Icon(Icons.search_rounded, color: brand.onCosmic),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    context.l10n.storeSearchHint,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: brand.onCosmicMuted,
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

class _TrustStrip extends StatelessWidget {
  const _TrustStrip();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final items = [
      (Icons.verified_rounded, l.storeTrustCertified, AstroPalette.health),
      (Icons.videocam_rounded, l.storeTrustGuided, AstroPalette.career),
      (Icons.lock_rounded, l.storeTrustSecure, AstroPalette.money),
    ];
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 22),
      child: Row(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            if (i > 0) const SizedBox(width: 8),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: items[i].$3.tint(0.10),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: [
                    Icon(items[i].$1, size: 20, color: items[i].$3.end),
                    const SizedBox(height: 4),
                    Text(
                      items[i].$2,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// --- categories ---------------------------------------------------------------------

class _CategoryGrid extends StatelessWidget {
  const _CategoryGrid({required this.categories});
  final List<StoreCategory> categories;

  @override
  Widget build(BuildContext context) {
    final top = categories.where((c) => c.parent == null).toList();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: top.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 0.78,
        ),
        itemBuilder: (context, i) {
          final c = top[i];
          final hue = storeHue(c.slug);
          return Pressable(
            child: InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () =>
                  context.push(Routes.storeProductsWith({'category': c.slug})),
              child: Column(
                children: [
                  if (c.image != null)
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: StoreImage(
                        url: c.image,
                        slug: c.slug,
                        radius: 20,
                        iconSize: 26,
                      ),
                    )
                  else
                    HueIcon(
                      hue: hue,
                      icon: storeIcon(c.slug),
                      size: 60,
                      iconSize: 28,
                    ),
                  const SizedBox(height: 7),
                  Text(
                    c.name,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      height: 1.15,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// --- consult banner ------------------------------------------------------------------

class _ConsultBanner extends StatelessWidget {
  const _ConsultBanner();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Pressable(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: AstroPalette.romance,
            ),
            boxShadow: [
              BoxShadow(
                color: AstroPalette.romance[1].withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(22),
              onTap: () => context.go(Routes.astrologersWith(channel: 'video')),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 16, 14, 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l.storeConsultBannerTitle,
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            l.storeConsultBannerBody,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.white.withValues(alpha: 0.9),
                              height: 1.35,
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
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.videocam_rounded,
                                  size: 18,
                                  color: AstroPalette.romance[1],
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  l.storeConsultBannerCta,
                                  style: theme.textTheme.labelLarge?.copyWith(
                                    color: AstroPalette.romance[2],
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Icon(
                      Icons.auto_awesome_rounded,
                      size: 54,
                      color: Colors.white.withValues(alpha: 0.85),
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

// --- rails ---------------------------------------------------------------------------

class _ProductRail extends StatelessWidget {
  const _ProductRail({
    required this.title,
    required this.products,
    required this.hue,
    this.subtitle,
    this.onSeeAll,
  });

  final String title;
  final String? subtitle;
  final AstroHue hue;
  final List<ProductCard> products;
  final VoidCallback? onSeeAll;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      SectionHeader(
        title: title,
        subtitle: subtitle,
        hue: hue,
        onSeeAll: onSeeAll,
      ),
      const SizedBox(height: 12),
      SizedBox(
        height: 290,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: products.length,
          separatorBuilder: (_, _) => const SizedBox(width: 12),
          itemBuilder: (_, i) => ProductRailCard(product: products[i]),
        ),
      ),
    ],
  );
}

class _CollectionsRail extends StatelessWidget {
  const _CollectionsRail({required this.collections});
  final List<StoreCollection> collections;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(
          title: context.l10n.storeCollections,
          hue: AstroPalette.love,
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 132,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: collections.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, i) {
              final c = collections[i];
              final hue = AstroPalette.at(i);
              return Pressable(
                child: SizedBox(
                  width: 220,
                  child: Material(
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
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
                            padding: const EdgeInsets.all(14),
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
                                      color: Colors.white.withValues(
                                        alpha: 0.85,
                                      ),
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
            },
          ),
        ),
      ],
    );
  }
}

class _HomeSkeleton extends StatelessWidget {
  const _HomeSkeleton();

  @override
  Widget build(BuildContext context) => AppShimmer(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Expanded(child: SkeletonBox(height: 60, radius: 14)),
              SizedBox(width: 8),
              Expanded(child: SkeletonBox(height: 60, radius: 14)),
              SizedBox(width: 8),
              Expanded(child: SkeletonBox(height: 60, radius: 14)),
            ],
          ),
          const SizedBox(height: 24),
          const SkeletonBox(width: 180, height: 20),
          const SizedBox(height: 14),
          Row(
            children: [
              for (var i = 0; i < 4; i++) ...[
                if (i > 0) const SizedBox(width: 10),
                const Expanded(child: SkeletonBox(height: 72, radius: 20)),
              ],
            ],
          ),
          const SizedBox(height: 24),
          const SkeletonBox(height: 130, radius: 22),
          const SizedBox(height: 24),
          const SkeletonBox(width: 200, height: 20),
          const SizedBox(height: 14),
          const Row(
            children: [
              Expanded(child: SkeletonBox(height: 220, radius: 18)),
              SizedBox(width: 12),
              Expanded(child: SkeletonBox(height: 220, radius: 18)),
            ],
          ),
        ],
      ),
    ),
  );
}
