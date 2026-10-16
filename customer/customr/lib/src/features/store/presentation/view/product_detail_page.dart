import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/routes.dart';
import '../../data/models/catalog.dart';
import '../../data/models/consult.dart';
import '../../data/models/product.dart';
import '../../data/store_repository.dart';
import '../cubit/product_detail_cubit.dart';
import '../widgets/consult_widgets.dart';
import '../widgets/product_inputs_form.dart';
import '../widgets/store_ui.dart';

import 'package:talkacharya_ui/talkacharya_ui.dart';

/// `/store/products/:slug` — everything needed to decide and buy.
class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductDetailCubit, ProductDetailState>(
      builder: (context, state) {
        final p = state.product.value;
        if (p == null) {
          if (state.product.isError) {
            return Scaffold(
              appBar: AppBar(),
              body: ErrorView(
                message: state.product.error ?? '',
                onRetry: () => context.read<ProductDetailCubit>().load(),
              ),
            );
          }
          return const _DetailSkeleton();
        }
        return Scaffold(
          backgroundColor: context.brand.canvas,
          body: RefreshIndicator(
            onRefresh: () =>
                context.read<ProductDetailCubit>().load(silent: true),
            child: CustomScrollView(
              slivers: [
                _Toolbar(product: p),
                SliverToBoxAdapter(child: _Gallery(product: p)),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  sliver: SliverList.list(
                    children: _sections(context, state, p),
                  ),
                ),
                SliverToBoxAdapter(child: _SimilarProducts(product: p)),
                const SliverToBoxAdapter(child: SizedBox(height: 24)),
              ],
            ),
          ),
          bottomNavigationBar: _BuyBar(state: state, product: p),
        );
      },
    );
  }

  List<Widget> _sections(
    BuildContext context,
    ProductDetailState state,
    ProductDetail p,
  ) {
    final l = context.l10n;
    final cubit = context.read<ProductDetailCubit>();
    final variant = state.variant;
    return FadeSlideIn.list([
      _Header(product: p, state: state),
      if (p.consult.enabled) ...[
        const SizedBox(height: 16),
        _ConsultBlock(product: p),
      ],
      if (p.variants.length > 1) ...[
        const SizedBox(height: 20),
        StoreSectionTitle(
          p.isService ? l.storeChoosePackage : l.storeChooseOption,
        ),
        _VariantChips(product: p, selectedId: state.variantId),
      ],
      if (p.isService && (p.events.isNotEmpty || p.serviceEventRequired)) ...[
        const SizedBox(height: 20),
        StoreSectionTitle(l.storePickDate, hue: AstroPalette.fire),
        _EventPicker(
          events: p.events,
          selectedId: state.eventId,
          error: state.errors[kEventErrorKey],
          onPick: cubit.selectEvent,
        ),
      ],
      if (p.inputSchema.isNotEmpty) ...[
        const SizedBox(height: 20),
        StoreSectionTitle(
          p.isService ? l.storeSankalpDetails : l.storeYourDetails,
          hue: AstroPalette.love,
        ),
        if (p.isService)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              l.storeSankalpHint,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: context.brand.inkMuted),
            ),
          ),
        StoreCard(
          child: ProductInputsForm(
            key: ValueKey('inputs-${variant?.participants ?? 1}'),
            schema: p.inputSchema,
            values: state.inputs,
            errors: state.errors,
            participants: variant?.participants ?? 1,
            onChanged: cubit.setInput,
          ),
        ),
      ],
      if (variant != null && variant.certificates.isNotEmpty) ...[
        const SizedBox(height: 20),
        StoreSectionTitle(l.storeCertificate, hue: AstroPalette.health),
        for (final c in variant.certificates) _CertificateCard(certificate: c),
      ],
      if (p.attributes.isNotEmpty ||
          (variant?.attributes.isNotEmpty ?? false)) ...[
        const SizedBox(height: 20),
        StoreSectionTitle(l.storeHighlights, hue: AstroPalette.career),
        _AttributesGrid(values: [...p.attributes, ...?variant?.attributes]),
      ],
      if (p.description.isNotEmpty) ...[
        const SizedBox(height: 20),
        StoreSectionTitle(l.storeAbout),
        _ExpandableText(p.description),
      ],
      if (p.benefits.isNotEmpty) ...[
        const SizedBox(height: 20),
        StoreSectionTitle(l.storeSignificance, hue: AstroPalette.money),
        _ExpandableText(p.benefits),
      ],
      if (p.howToUse.isNotEmpty) ...[
        const SizedBox(height: 20),
        StoreSectionTitle(
          p.isService ? l.storeHowItWorks : l.storeHowToUse,
          hue: AstroPalette.air,
        ),
        _ExpandableText(p.howToUse),
      ],
      const SizedBox(height: 20),
      _PolicyCard(product: p),
      const SizedBox(height: 20),
      _SellerCard(product: p),
      if (p.disclaimer.isNotEmpty) ...[
        const SizedBox(height: 16),
        Text(
          p.disclaimer,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: context.brand.inkMuted,
            height: 1.4,
          ),
        ),
      ],
    ]);
  }
}

// --- gallery ------------------------------------------------------------------------

class _Toolbar extends StatelessWidget {
  const _Toolbar({required this.product});
  final ProductDetail product;

  @override
  Widget build(BuildContext context) {
    final p = product;
    return SliverAppBar(
      pinned: true,
      backgroundColor: context.brand.canvas,
      surfaceTintColor: Colors.transparent,
      title: Text(
        p.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
      ),
      actions: [
        IconButton(
          tooltip: context.l10n.commonShare,
          icon: const Icon(Icons.share_rounded),
          onPressed: () => Share.share(
            '${p.title}\nhttps://talkacharya.com/store/products/${p.slug}',
          ),
        ),
        const CartButton(),
        const SizedBox(width: 4),
      ],
    );
  }
}

/// The pictures: a square, on white, the whole product in frame (the server
/// pads every photo to the same square), a counter, and a strip of thumbnails
/// under it. Tapping opens them full screen with pinch-zoom on the original.
class _Gallery extends StatefulWidget {
  const _Gallery({required this.product});
  final ProductDetail product;

  @override
  State<_Gallery> createState() => _GalleryState();
}

class _GalleryState extends State<_Gallery> {
  final _pages = PageController();
  int _page = 0;

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  void _go(int i) => _pages.animateToPage(
    i,
    duration: const Duration(milliseconds: 260),
    curve: Curves.easeOutCubic,
  );

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    final images = p.images;
    final brand = context.brand;
    final theme = Theme.of(context);
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: ColoredBox(
            color: Colors.white,
            child: images.isEmpty
                ? StoreImage(
                    url: null,
                    slug: p.card.type,
                    radius: 0,
                    iconSize: 72,
                  )
                : Stack(
                    fit: StackFit.expand,
                    children: [
                      PageView.builder(
                        controller: _pages,
                        itemCount: images.length,
                        onPageChanged: (i) => setState(() => _page = i),
                        itemBuilder: (context, i) => GestureDetector(
                          onTap: () => _openViewer(context, images, i),
                          child: Hero(
                            tag: 'store-media-${p.slug}-$i',
                            child: CachedNetworkImage(
                              imageUrl: images[i].url,
                              fit: BoxFit.contain,
                              placeholder: (_, _) => const Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                              errorWidget: (_, _, _) => StoreImage(
                                url: null,
                                slug: p.card.type,
                                radius: 0,
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (images.length > 1)
                        Positioned(
                          right: 12,
                          top: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 9,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.55),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              '${_page + 1}/${images.length}',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      Positioned(
                        right: 12,
                        bottom: 12,
                        child: Icon(
                          Icons.zoom_out_map_rounded,
                          size: 20,
                          color: Colors.black.withValues(alpha: 0.35),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
        if (images.length > 1)
          SizedBox(
            height: 72,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
              itemCount: images.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final on = i == _page;
                return GestureDetector(
                  onTap: () => _go(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: 56,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: on ? brand.gold : brand.hairline,
                        width: on ? 2 : 1,
                      ),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: CachedNetworkImage(
                      imageUrl: images[i].thumbUrl,
                      fit: BoxFit.cover,
                      errorWidget: (_, _, _) => const SizedBox.shrink(),
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Future<void> _openViewer(
    BuildContext context,
    List<ProductMedia> images,
    int start,
  ) async {
    final slug = widget.product.slug;
    final at = await Navigator.of(context).push<int>(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black,
        pageBuilder: (_, _, _) => _ZoomViewer(
          images: images,
          start: start,
          heroPrefix: 'store-media-$slug',
        ),
        transitionsBuilder: (_, anim, _, child) =>
            FadeTransition(opacity: anim, child: child),
      ),
    );
    if (at != null && at != _page && mounted) _pages.jumpToPage(at);
  }
}

/// Full screen, black, pinch to zoom the original upload; swipe between
/// pictures; returns the one it closed on so the gallery follows.
class _ZoomViewer extends StatefulWidget {
  const _ZoomViewer({
    required this.images,
    required this.start,
    required this.heroPrefix,
  });

  final List<ProductMedia> images;
  final int start;
  final String heroPrefix;

  @override
  State<_ZoomViewer> createState() => _ZoomViewerState();
}

class _ZoomViewerState extends State<_ZoomViewer> {
  late final _pages = PageController(initialPage: widget.start);
  late int _page = widget.start;
  bool _zoomed = false;

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final images = widget.images;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pages,
            physics: _zoomed
                ? const NeverScrollableScrollPhysics()
                : const PageScrollPhysics(),
            itemCount: images.length,
            onPageChanged: (i) => setState(() => _page = i),
            itemBuilder: (context, i) => _ZoomPage(
              url: images[i].zoomUrl,
              fallback: images[i].url,
              hero: '${widget.heroPrefix}-$i',
              onZoom: (z) {
                if (z != _zoomed) setState(() => _zoomed = z);
              },
            ),
          ),
          SafeArea(
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(_page),
                ),
                const Spacer(),
                if (images.length > 1)
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Text(
                      '${_page + 1}/${images.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (images.length > 1)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: SafeArea(
                child: SizedBox(
                  height: 64,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    itemCount: images.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 8),
                    itemBuilder: (context, i) => GestureDetector(
                      onTap: () => _pages.jumpToPage(i),
                      child: Container(
                        width: 52,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: i == _page ? Colors.white : Colors.white24,
                            width: i == _page ? 2 : 1,
                          ),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: CachedNetworkImage(
                          imageUrl: images[i].thumbUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
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

class _ZoomPage extends StatefulWidget {
  const _ZoomPage({
    required this.url,
    required this.fallback,
    required this.hero,
    required this.onZoom,
  });

  final String url;
  final String fallback;
  final String hero;
  final ValueChanged<bool> onZoom;

  @override
  State<_ZoomPage> createState() => _ZoomPageState();
}

class _ZoomPageState extends State<_ZoomPage> {
  final _transform = TransformationController();

  @override
  void dispose() {
    _transform.dispose();
    super.dispose();
  }

  void _toggle(TapDownDetails d) {
    final zoomed = _transform.value.getMaxScaleOnAxis() > 1.01;
    if (zoomed) {
      _transform.value = Matrix4.identity();
    } else {
      final p = d.localPosition;
      _transform.value = Matrix4.identity()
        ..translateByDouble(-p.dx * 1.5, -p.dy * 1.5, 0, 1)
        ..scaleByDouble(2.5, 2.5, 1, 1);
    }
    widget.onZoom(!zoomed);
  }

  @override
  Widget build(BuildContext context) {
    TapDownDetails? last;
    return GestureDetector(
      onDoubleTapDown: (d) => last = d,
      onDoubleTap: () {
        if (last != null) _toggle(last!);
      },
      child: InteractiveViewer(
        transformationController: _transform,
        minScale: 1,
        maxScale: 5,
        onInteractionEnd: (_) =>
            widget.onZoom(_transform.value.getMaxScaleOnAxis() > 1.01),
        child: Center(
          child: Hero(
            tag: widget.hero,
            child: CachedNetworkImage(
              imageUrl: widget.url,
              fit: BoxFit.contain,
              placeholder: (_, _) => CachedNetworkImage(
                imageUrl: widget.fallback,
                fit: BoxFit.contain,
              ),
              errorWidget: (_, _, _) => CachedNetworkImage(
                imageUrl: widget.fallback,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// --- header --------------------------------------------------------------------------

class _Header extends StatelessWidget {
  const _Header({required this.product, required this.state});
  final ProductDetail product;
  final ProductDetailState state;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final brand = context.brand;
    final p = product;
    final v = state.variant;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            StoreBadge(
              label: p.seller.displayName.isEmpty
                  ? l.storeTitle
                  : p.seller.displayName,
              hue: storeHue(p.card.type),
              icon: p.seller.kind == 'temple'
                  ? Icons.temple_hindu_rounded
                  : Icons.storefront_rounded,
            ),
            if (p.needsAstrologerBadge)
              StoreBadge(
                label: l.storeBadgeAskAstrologer,
                hue: AstroPalette.career,
                icon: Icons.videocam_rounded,
              ),
            if (state.recommendationId != null)
              StoreBadge(
                label: l.storeRecommendedForYou,
                hue: AstroPalette.health,
                icon: Icons.recommend_rounded,
              ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          p.title,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        if (p.card.subtitle.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            p.card.subtitle,
            style: theme.textTheme.bodyMedium?.copyWith(color: brand.inkMuted),
          ),
        ],
        const SizedBox(height: 8),
        RatingLine(avg: p.card.ratingAvg, count: p.card.ratingCount),
        const SizedBox(height: 12),
        _PriceBlock(
          price: state.price,
          compareAt: v?.compareAt ?? p.card.compareAt,
        ),
        if (v != null && !v.inStock) ...[
          const SizedBox(height: 8),
          StoreStatusChip(label: l.storeOutOfStock, tone: 'bad'),
        ] else if (v?.stockLeft != null) ...[
          const SizedBox(height: 8),
          StoreStatusChip(label: l.storeOnlyLeft(v!.stockLeft!), tone: 'warn'),
        ],
      ],
    );
  }
}

/// "-23%  ₹499" in big type, "M.R.P.: ₹649" struck through and what is
/// saved under it, then "Inclusive of all taxes".
class _PriceBlock extends StatelessWidget {
  const _PriceBlock({required this.price, required this.compareAt});

  final double? price;
  final double? compareAt;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final brand = context.brand;
    final p = price;
    if (p == null) {
      return Text(
        l.storeUnavailable,
        style: theme.textTheme.titleMedium?.copyWith(color: brand.inkMuted),
      );
    }
    final off = discountOf(p, compareAt);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (off != null) ...[
              Text(
                '-$off%',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: const Color(0xFFCC0C39),
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(width: 10),
            ],
            Text(
              storeMoney(context, p),
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: brand.ink,
              ),
            ),
          ],
        ),
        if (off != null) ...[
          const SizedBox(height: 2),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(text: '${l.storeMrp}: '),
                TextSpan(
                  text: storeMoney(context, compareAt!),
                  style: const TextStyle(
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ],
            ),
            style: theme.textTheme.bodySmall?.copyWith(color: brand.inkMuted),
          ),
          const SizedBox(height: 2),
          Text(
            l.storeYouSave(storeMoney(context, compareAt! - p)),
            style: theme.textTheme.labelMedium?.copyWith(
              color: brand.online,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
        const SizedBox(height: 2),
        Text(
          l.storeTaxInclusive,
          style: theme.textTheme.labelSmall?.copyWith(color: brand.inkMuted),
        ),
      ],
    );
  }
}

/// More from the same category, at the end of the page — the next thing to
/// look at instead of a dead end. Hidden when there is nothing else.
class _SimilarProducts extends StatefulWidget {
  const _SimilarProducts({required this.product});
  final ProductDetail product;

  @override
  State<_SimilarProducts> createState() => _SimilarProductsState();
}

class _SimilarProductsState extends State<_SimilarProducts> {
  List<ProductCard> _items = const [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final p = widget.product;
    if (p.card.category.isEmpty) return;
    try {
      final page = await getIt<StoreRepository>().products(
        ProductQuery(category: p.card.category),
        limit: 12,
      );
      if (!mounted) return;
      setState(
        () => _items = page.items.where((c) => c.slug != p.slug).toList(),
      );
    } catch (_) {
      // A bonus row: nothing shown if it cannot load.
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_items.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: StoreSectionTitle(context.l10n.storeSimilar),
          ),
          SizedBox(
            // 140 wide: the square picture plus title and price.
            height: 226,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _items.length,
              separatorBuilder: (_, _) => const SizedBox(width: 10),
              itemBuilder: (_, i) => SizedBox(
                width: 140,
                child: CompactProductTile(product: _items[i]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

extension on ProductDetail {
  bool get needsAstrologerBadge => card.needsAstrologer;
}

// --- consult ---------------------------------------------------------------------------

class _ConsultBlock extends StatelessWidget {
  const _ConsultBlock({required this.product});
  final ProductDetail product;

  @override
  Widget build(BuildContext context) {
    final latest = product.consult.latest;
    final cubit = context.read<ProductDetailCubit>();
    void openConsult() => context
        .push(Routes.storeProductConsult(product.slug), extra: product)
        .whenComplete(() => cubit.load(silent: true));

    if (latest != null && latest.verdict != null) {
      final v = latest.verdict!;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          VerdictCard(
            consult: latest,
            onBuyRecommended: v.kind == VerdictKind.suitable
                ? () {
                    final id = v.recommendedVariantId;
                    if (id != null) cubit.selectVariant(id);
                  }
                : null,
            onOpenAlternative: (alt) => context.push(
              Routes.storeProduct(
                alt.slug,
                recommendationId: v.recommendationId,
              ),
            ),
          ),
          if (!v.kind.positive || product.consult.enabled)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: openConsult,
                icon: const Icon(Icons.videocam_outlined, size: 18),
                label: Text(context.l10n.storeAskAnother),
              ),
            ),
        ],
      );
    }
    final waiting =
        latest != null && latest.status == ConsultStatus.awaitingVerdict
        ? latest
        : null;
    return ConsultPrompt(
      required: product.consult.required,
      waiting: waiting,
      onConsult: openConsult,
    );
  }
}

// --- variants & events ---------------------------------------------------------------

class _VariantChips extends StatelessWidget {
  const _VariantChips({required this.product, required this.selectedId});
  final ProductDetail product;
  final String? selectedId;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProductDetailCubit>();
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final v in product.variants)
          ChoiceChip(
            selected: v.id == selectedId,
            onSelected: v.inStock ? (_) => cubit.selectVariant(v.id) : null,
            label: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  v.name.isEmpty ? v.sku : v.name,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                if (v.price != null)
                  Text(
                    storeMoney(context, v.price!),
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

class _EventPicker extends StatelessWidget {
  const _EventPicker({
    required this.events,
    required this.selectedId,
    required this.onPick,
    this.error,
  });

  final List<ServiceEvent> events;
  final String? selectedId;
  final ValueChanged<String> onPick;
  final String? error;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final brand = context.brand;
    if (events.isEmpty) {
      return StoreCard(
        child: Row(
          children: [
            Icon(Icons.event_busy_rounded, color: brand.inkMuted),
            const SizedBox(width: 10),
            Expanded(
              child: Text(l.storeNoDates, style: theme.textTheme.bodyMedium),
            ),
          ],
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 104,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: events.length,
            separatorBuilder: (_, _) => const SizedBox(width: 10),
            itemBuilder: (context, i) {
              final e = events[i];
              final selected = e.id == selectedId;
              const hue = AstroPalette.fire;
              return Opacity(
                opacity: e.isOpen ? 1 : 0.45,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: e.isOpen ? () => onPick(e.id) : null,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: 132,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: selected
                          ? hue.tint(0.16)
                          : theme.colorScheme.surface,
                      border: Border.all(
                        color: selected ? hue.end : brand.hairline,
                        width: selected ? 1.6 : 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          storeDate(context, e.startsAt),
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          storeDate(
                            context,
                            e.startsAt,
                            withTime: true,
                          ).split('·').last.trim(),
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: brand.inkMuted,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          e.remaining == null
                              ? (e.venue.isEmpty
                                    ? l.storeOpenForBooking
                                    : e.venue)
                              : l.storeSeatsLeft(e.remaining!),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: hue.end,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              error!,
              style: TextStyle(color: theme.colorScheme.error, fontSize: 12),
            ),
          ),
      ],
    );
  }
}

// --- details ------------------------------------------------------------------------------

class _CertificateCard extends StatelessWidget {
  const _CertificateCard({required this.certificate});
  final Certificate certificate;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final url = certificate.verifyUrl ?? certificate.file;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: StoreCard(
        child: Row(
          children: [
            Icon(
              Icons.workspace_premium_rounded,
              color: AstroPalette.health.end,
              size: 30,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    certificate.lab,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    l.storeCertificateNo(certificate.number),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: context.brand.inkMuted,
                    ),
                  ),
                ],
              ),
            ),
            if (url != null)
              TextButton(
                onPressed: () async {
                  final uri = Uri.tryParse(url);
                  if (uri != null) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  }
                },
                child: Text(l.storeVerify),
              ),
          ],
        ),
      ),
    );
  }
}

class _AttributesGrid extends StatelessWidget {
  const _AttributesGrid({required this.values});
  final List<AttributeValue> values;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brand = context.brand;
    return StoreCard(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 14),
      child: Column(
        children: [
          for (var i = 0; i < values.length; i++) ...[
            if (i > 0) Divider(height: 1, color: brand.hairline),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      values[i].name,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: brand.inkMuted,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Text(
                      values[i].text,
                      textAlign: TextAlign.end,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ExpandableText extends StatefulWidget {
  const _ExpandableText(this.text);
  final String text;

  @override
  State<_ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<_ExpandableText> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final long = widget.text.length > 280;
    return AnimatedSize(
      duration: const Duration(milliseconds: 220),
      alignment: Alignment.topCenter,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.text,
            maxLines: _open || !long ? null : 5,
            overflow: _open || !long ? null : TextOverflow.fade,
            style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
          ),
          if (long)
            TextButton(
              style: TextButton.styleFrom(padding: EdgeInsets.zero),
              onPressed: () => setState(() => _open = !_open),
              child: Text(
                _open ? context.l10n.storeReadLess : context.l10n.storeReadMore,
              ),
            ),
        ],
      ),
    );
  }
}

class _PolicyCard extends StatelessWidget {
  const _PolicyCard({required this.product});
  final ProductDetail product;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final policy = product.policy;
    final rows = <(IconData, String, AstroHue)>[
      if (product.fulfilment == Fulfilment.physical)
        (
          Icons.assignment_return_rounded,
          policy.returnable
              ? l.storeReturnableDays(policy.returnWindowDays)
              : l.storeNotReturnable,
          AstroPalette.health,
        ),
      (
        Icons.cancel_schedule_send_rounded,
        policy.cancellable ? l.storeCancellable : l.storeNotCancellable,
        AstroPalette.money,
      ),
      if (policy.madeToOrder)
        (
          Icons.handyman_rounded,
          l.storeMadeToOrder(policy.leadTimeDays),
          AstroPalette.love,
        ),
      if (product.fulfilment == Fulfilment.physical)
        (Icons.local_shipping_rounded, l.storeShipsIndia, AstroPalette.career),
      if (product.isService)
        (Icons.ondemand_video_rounded, l.storeVideoProof, AstroPalette.fire),
      if (product.fulfilment == Fulfilment.digital)
        (Icons.download_rounded, l.storeInstantDownload, AstroPalette.air),
    ];
    return StoreCard(
      child: Column(
        children: [
          for (final r in rows)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  Icon(r.$1, color: r.$3.end, size: 22),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      r.$2,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _SellerCard extends StatelessWidget {
  const _SellerCard({required this.product});
  final ProductDetail product;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final brand = context.brand;
    final s = product.seller;
    final g = s.grievanceOfficer;
    final muted = theme.textTheme.bodySmall?.copyWith(
      color: brand.inkMuted,
      height: 1.45,
    );
    return StoreCard(
      child: Theme(
        data: theme.copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: EdgeInsets.zero,
          childrenPadding: EdgeInsets.zero,
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          title: Text(
            l.storeSoldBy(s.displayName),
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          subtitle: Text(l.storeSellerInfo, style: muted),
          children: [
            if (s.astrologerId != null)
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: TextButton.icon(
                  style: TextButton.styleFrom(padding: EdgeInsets.zero),
                  onPressed: () =>
                      context.push(Routes.astrologer(s.astrologerId!)),
                  icon: const Icon(Icons.person_rounded, size: 18),
                  label: Text(l.storeSellerAstrologerProfile),
                ),
              ),
            if (s.legalName.isNotEmpty)
              Text(s.legalName, style: theme.textTheme.bodyMedium),
            if (s.addressLine.isNotEmpty) Text(s.addressLine, style: muted),
            if (product.countryOfOrigin.isNotEmpty)
              Text(
                l.storeCountryOfOrigin(product.countryOfOrigin),
                style: muted,
              ),
            if (s.supportEmail.isNotEmpty || s.supportPhone.isNotEmpty)
              Text(
                [
                  s.supportEmail,
                  s.supportPhone,
                ].where((e) => e.isNotEmpty).join(' · '),
                style: muted,
              ),
            if (g.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                l.storeGrievanceOfficer,
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                [
                  g['name'],
                  g['email'],
                  g['phone'],
                ].where((e) => e != null && '$e'.isNotEmpty).join(' · '),
                style: muted,
              ),
            ],
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

// --- buy bar ----------------------------------------------------------------------------

class _BuyBar extends StatelessWidget {
  const _BuyBar({required this.state, required this.product});
  final ProductDetailState state;
  final ProductDetail product;

  Future<void> _add(BuildContext context, {required bool buyNow}) async {
    final l = context.l10n;
    final cubit = context.read<ProductDetailCubit>();
    final messenger = ScaffoldMessenger.of(context);
    final router = GoRouter.of(context);
    final local = cubit.validate(
      requiredMsg: l.storeFieldRequired,
      participantsMsg: l.storeFieldParticipants,
      pickDateMsg: l.storePickDateError,
    );
    final outcome = await cubit.addToCart(local);
    switch (outcome) {
      case AddedToCart():
        if (buyNow) {
          await router.push(Routes.storeCart);
        } else {
          messenger
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                behavior: SnackBarBehavior.floating,
                content: Text(l.storeAddedToCart),
                action: SnackBarAction(
                  label: l.storeViewCart,
                  onPressed: () => router.push(Routes.storeCart),
                ),
              ),
            );
        }
      case AddInvalid():
        messenger
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text(l.storeFixDetails),
            ),
          );
      case AddNeedsConsult():
        await router.push(
          Routes.storeProductConsult(product.slug),
          extra: product,
        );
        await cubit.load(silent: true);
      case AddFailed(:final message):
        if (message.isNotEmpty) {
          messenger
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                behavior: SnackBarBehavior.floating,
                content: Text(message),
              ),
            );
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final v = state.variant;
    final blocked = product.consult.blocksPurchase;
    final soldOut = v != null && !v.inStock;
    return StoreActionBar(
      child: Row(
        children: [
          if (!product.isService && !blocked && !soldOut) ...[
            _QtyStepper(
              value: state.quantity,
              max: v?.maxQuantity(ProductDetailCubit.maxLineQuantity) ?? 1,
              onChanged: context.read<ProductDetailCubit>().setQuantity,
            ),
            const SizedBox(width: 10),
          ],
          if (!blocked && !soldOut && !product.isService) ...[
            // Add to cart as a cart icon: "Add" alone didn't say to what.
            Tooltip(
              message: l.storeAddToCart,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(52, 52),
                  fixedSize: const Size(56, 52),
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: state.adding
                    ? null
                    : () => _add(context, buyNow: false),
                child: Semantics(
                  label: l.storeAddToCart,
                  child: const Icon(Icons.add_shopping_cart_rounded, size: 24),
                ),
              ),
            ),
            const SizedBox(width: 10),
          ],
          Expanded(
            flex: 2,
            child: GoldButton(
              busy: state.adding,
              icon: blocked
                  ? Icons.videocam_rounded
                  : (product.isService
                        ? Icons.temple_hindu_rounded
                        : Icons.flash_on_rounded),
              label: soldOut
                  ? l.storeOutOfStock
                  : blocked
                  ? l.storeConsultFirst
                  : product.isService
                  ? l.storeBookPooja
                  : l.storeBuyNow,
              onPressed: soldOut
                  ? null
                  : blocked
                  ? () {
                      final cubit = context.read<ProductDetailCubit>();
                      context
                          .push(
                            Routes.storeProductConsult(product.slug),
                            extra: product,
                          )
                          .whenComplete(() => cubit.load(silent: true));
                    }
                  : () => _add(context, buyNow: true),
            ),
          ),
        ],
      ),
    );
  }
}

class _QtyStepper extends StatelessWidget {
  const _QtyStepper({
    required this.value,
    required this.max,
    required this.onChanged,
  });
  final int value;
  final int max;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.brand.hairline),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: value > 1 ? () => onChanged(value - 1) : null,
            icon: const Icon(Icons.remove_rounded, size: 18),
          ),
          Text(
            '$value',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: value < max ? () => onChanged(value + 1) : null,
            icon: const Icon(Icons.add_rounded, size: 18),
          ),
        ],
      ),
    );
  }
}

class _DetailSkeleton extends StatelessWidget {
  const _DetailSkeleton();

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(),
    body: AppShimmer(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          SkeletonBox(height: 280, radius: 20),
          SizedBox(height: 18),
          SkeletonBox(width: 120),
          SizedBox(height: 10),
          SkeletonBox(height: 26, width: 260),
          SizedBox(height: 10),
          SkeletonBox(height: 22, width: 120),
          SizedBox(height: 24),
          SkeletonBox(height: 90, radius: 18),
          SizedBox(height: 18),
          SkeletonBox(height: 140, radius: 18),
        ],
      ),
    ),
  );
}
