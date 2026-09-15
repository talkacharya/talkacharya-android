import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/brand_colors.dart';
import '../../../../core/util/async_value.dart';
import '../../../../shared/widgets/cosmic.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../data/models/catalog.dart';
import '../cubit/order_cubits.dart';
import '../widgets/store_ui.dart';

/// `/store/collections/:slug` — a curated set ("For Saturn", "Wealth & career").
class CollectionPage extends StatelessWidget {
  const CollectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    return Scaffold(
      backgroundColor: brand.canvas,
      body: BlocBuilder<CollectionCubit, AsyncValue<StoreCollection>>(
        builder: (context, state) {
          final cubit = context.read<CollectionCubit>();
          final c = state.value;
          if (state.isError && c == null) {
            return Scaffold(
              appBar: AppBar(),
              body: ErrorView(message: state.error ?? '', onRetry: cubit.load),
            );
          }
          return RefreshIndicator(
            onRefresh: cubit.load,
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  pinned: true,
                  expandedHeight: 180,
                  foregroundColor: brand.onCosmic,
                  backgroundColor: brand.cosmicStart,
                  actions: [CartButton(color: brand.onCosmic)],
                  flexibleSpace: FlexibleSpaceBar(
                    titlePadding: const EdgeInsetsDirectional.only(
                      start: 56,
                      bottom: 14,
                      end: 56,
                    ),
                    title: Text(
                      c?.title ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: brand.onCosmic,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        const CosmicBackdrop(),
                        if (c?.image != null)
                          Opacity(
                            opacity: 0.35,
                            child: StoreImage(
                              url: c!.image,
                              slug: c.slug,
                              radius: 0,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                if (c == null)
                  const SliverPadding(
                    padding: EdgeInsets.all(16),
                    sliver: SliverToBoxAdapter(
                      child: ProductGridSkeleton(count: 6),
                    ),
                  )
                else ...[
                  if (c.description.isNotEmpty)
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                      sliver: SliverToBoxAdapter(
                        child: Text(
                          c.description,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: brand.inkMuted, height: 1.45),
                        ),
                      ),
                    ),
                  if (c.products.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: EmptyState(
                        icon: Icons.inventory_2_outlined,
                        title: context.l10n.storeNoProducts,
                      ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                      sliver: SliverGrid.builder(
                        gridDelegate: kProductGrid,
                        itemCount: c.products.length,
                        itemBuilder: (_, i) =>
                            ProductTile(product: c.products[i]),
                      ),
                    ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
