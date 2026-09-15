import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/astro_palette.dart';
import '../../../../core/theme/brand_colors.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../../../shared/widgets/fade_slide_in.dart';
import '../../../../shared/widgets/skeleton.dart';
import '../../data/models/cart.dart';
import '../../data/models/product.dart';
import '../cubit/cart_cubit.dart';
import '../widgets/order_widgets.dart';
import '../widgets/store_ui.dart';

/// `/store/cart` — items grouped by seller, quantity steppers, proceed to checkout.
class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();
    context.read<CartCubit>().load();
  }

  Future<void> _checkout() async {
    final router = GoRouter.of(context);
    final orderId = await router.push<String>(Routes.storeCheckout);
    if (orderId != null && mounted) {
      unawaited(
        router.pushReplacement(Routes.storeOrder(orderId, placed: true)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      backgroundColor: context.brand.canvas,
      appBar: AppBar(
        title: Text(l.storeCartTitle),
        actions: [
          IconButton(
            tooltip: l.storeOrdersTitle,
            onPressed: () => context.push(Routes.storeOrders),
            icon: const Icon(Icons.receipt_long_outlined),
          ),
        ],
      ),
      body: BlocConsumer<CartCubit, CartState>(
        listenWhen: (a, b) => b.error != null && a.error != b.error,
        listener: (context, state) => storeToast(context, state.error!),
        builder: (context, state) {
          final cubit = context.read<CartCubit>();
          final cart = state.cart.value;
          if (state.cart.isError && cart == null) {
            return ErrorView(
              message: state.cart.error ?? '',
              onRetry: cubit.load,
            );
          }
          if (cart == null) return const _CartSkeleton();
          if (cart.isEmpty) {
            return EmptyState(
              icon: Icons.shopping_bag_outlined,
              title: l.storeCartEmptyTitle,
              message: l.storeCartEmptyBody,
              action: FilledButton.tonal(
                onPressed: () =>
                    context.canPop() ? context.pop() : context.go(Routes.store),
                child: Text(l.storeExplore),
              ),
            );
          }
          final groups = cart.bySeller;
          return RefreshIndicator(
            onRefresh: cubit.load,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: FadeSlideIn.list([
                for (final entry in groups.entries) ...[
                  _SellerHeader(seller: entry.key),
                  for (final item in entry.value)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _CartItemCard(
                        item: item,
                        currency: cart.currency,
                        busy: state.busy.contains(item.id),
                      ),
                    ),
                  const SizedBox(height: 6),
                ],
                StoreNotice(
                  icon: Icons.local_shipping_outlined,
                  tone: 'info',
                  message: l.storeCartTaxNote,
                ),
              ]),
            ),
          );
        },
      ),
      bottomNavigationBar: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          final cart = state.cart.value;
          if (cart == null || cart.isEmpty) return const SizedBox.shrink();
          return StoreActionBar(
            child: Row(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l.storeItemsCount(cart.count),
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: context.brand.inkMuted,
                      ),
                    ),
                    Text(
                      storeMoney(context, cart.subtotal, cart.currency),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: GoldButton(
                    icon: Icons.lock_outline_rounded,
                    label: l.storeCheckout,
                    onPressed: state.busy.isEmpty ? _checkout : null,
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

class _SellerHeader extends StatelessWidget {
  const _SellerHeader({required this.seller});
  final SellerRef seller;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(2, 6, 2, 8),
    child: Row(
      children: [
        Icon(Icons.storefront_rounded, size: 18, color: AstroPalette.money.end),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            context.l10n.storeSoldBy(seller.name),
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
        ),
      ],
    ),
  );
}

class _CartItemCard extends StatelessWidget {
  const _CartItemCard({
    required this.item,
    required this.currency,
    required this.busy,
  });

  final CartItem item;
  final String currency;
  final bool busy;

  static const _maxQty = 20;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final brand = context.brand;
    final cubit = context.read<CartCubit>();
    final p = item.product;
    final event = item.event;
    return StoreCard(
      padding: const EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => context.push(Routes.storeProduct(p.slug)),
            child: SizedBox(
              width: 76,
              height: 76,
              child: StoreImage(url: p.image, slug: p.type, radius: 14),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  p.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if (item.variantName.isNotEmpty)
                  Text(
                    item.variantName,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: brand.inkMuted,
                    ),
                  ),
                if (event != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Row(
                      children: [
                        Icon(
                          Icons.event_rounded,
                          size: 14,
                          color: AstroPalette.fire.end,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            [
                              event.title,
                              storeDate(
                                context,
                                event.startsAt,
                                withTime: true,
                              ),
                            ].where((s) => s.isNotEmpty).join(' · '),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.labelSmall,
                          ),
                        ),
                      ],
                    ),
                  ),
                if (item.recommendationId != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: StoreBadge(
                      label: l.storeRecommendedForYou,
                      hue: AstroPalette.career,
                      icon: Icons.verified_rounded,
                    ),
                  ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: PriceTag(
                        price: item.lineTotal,
                        currency: currency,
                      ),
                    ),
                    if (busy)
                      const Padding(
                        padding: EdgeInsets.all(8),
                        child: SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    else if (p.isService)
                      TextButton(
                        onPressed: () => cubit.remove(item),
                        child: Text(l.storeRemove),
                      )
                    else
                      _Stepper(
                        quantity: item.quantity,
                        onMinus: () => item.quantity <= 1
                            ? cubit.remove(item)
                            : cubit.setQuantity(item, item.quantity - 1),
                        onPlus: item.quantity >= _maxQty
                            ? null
                            : () => cubit.setQuantity(item, item.quantity + 1),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Stepper extends StatelessWidget {
  const _Stepper({
    required this.quantity,
    required this.onMinus,
    required this.onPlus,
  });

  final int quantity;
  final VoidCallback onMinus;
  final VoidCallback? onPlus;

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: brand.hairline),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: onMinus,
            icon: Icon(
              quantity <= 1
                  ? Icons.delete_outline_rounded
                  : Icons.remove_rounded,
              size: 18,
            ),
          ),
          Text(
            '$quantity',
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: onPlus,
            icon: const Icon(Icons.add_rounded, size: 18),
          ),
        ],
      ),
    );
  }
}

class _CartSkeleton extends StatelessWidget {
  const _CartSkeleton();

  @override
  Widget build(BuildContext context) => AppShimmer(
    child: ListView(
      padding: const EdgeInsets.all(16),
      children: [
        for (var i = 0; i < 3; i++)
          const Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: SkeletonBox(height: 100, radius: 18),
          ),
      ],
    ),
  );
}
