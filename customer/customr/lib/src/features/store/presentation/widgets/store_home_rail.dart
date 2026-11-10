import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/routes.dart';
import '../../../home/presentation/view/widgets/home_shared.dart';
import '../../data/models/catalog.dart';
import '../../data/models/product.dart';
import '../../data/store_repository.dart';
import 'store_ui.dart';

import 'package:talkacharya_ui/talkacharya_ui.dart';

/// Home feed section: featured remedies and poojas from the store home payload.
/// Owns its data (the repository caches `/store/home` for a few minutes) and hides
/// itself when the catalogue is empty or unreachable — never an empty rail.
class StoreHomeRail extends StatefulWidget {
  const StoreHomeRail({super.key});

  /// The store's compact tile: a square picture, two lines of title, rating
  /// and price — about two-thirds the height of the full grid tile.
  static const double _cardWidth = 128;

  /// Picture + text, the text growing with the phone's font size.
  static double _height(BuildContext context) =>
      _cardWidth + MediaQuery.textScalerOf(context).scale(86) + 8;

  @override
  State<StoreHomeRail> createState() => _StoreHomeRailState();
}

class _StoreHomeRailState extends State<StoreHomeRail> {
  late Future<StoreHome> _future = getIt<StoreRepository>().home();

  @override
  void didUpdateWidget(StoreHomeRail oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Pull-to-refresh on home rebuilds sections; the repository cache keeps this cheap.
    _future = getIt<StoreRepository>().home();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return FutureBuilder<StoreHome>(
      future: _future,
      builder: (context, snap) {
        if (snap.hasError) return const SizedBox.shrink();
        final home = snap.data;
        final items = home == null
            ? const <ProductCard>[]
            : _mix(home.featured, home.poojas);
        if (home != null && items.isEmpty) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(
              title: l.storeHomeRailTitle,
              subtitle: l.storeHomeRailSub,
              hue: AstroPalette.money,
              seeAllLabel: l.storeSeeAll,
              onSeeAll: () => context.go(Routes.store),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: StoreHomeRail._height(context),
              child: home == null
                  ? AppShimmer(
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(
                          HomeGaps.side,
                          0,
                          HomeGaps.side,
                          8,
                        ),
                        itemCount: 3,
                        separatorBuilder: (_, _) => const SizedBox(width: 10),
                        itemBuilder: (_, _) => const SkeletonBox(
                          width: StoreHomeRail._cardWidth,
                          height: double.infinity,
                          radius: 14,
                        ),
                      ),
                    )
                  : ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.fromLTRB(
                        HomeGaps.side,
                        0,
                        HomeGaps.side,
                        8,
                      ),
                      itemCount: items.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 10),
                      itemBuilder: (_, i) => SizedBox(
                        width: StoreHomeRail._cardWidth,
                        child: CompactProductTile(product: items[i]),
                      ),
                    ),
            ),
          ],
        );
      },
    );
  }

  /// Featured goods interleaved with poojas, at most 10.
  static List<ProductCard> _mix(List<ProductCard> a, List<ProductCard> b) {
    final out = <ProductCard>[];
    final seen = <String>{};
    for (var i = 0; out.length < 10 && (i < a.length || i < b.length); i++) {
      for (final p in [if (i < a.length) a[i], if (i < b.length) b[i]]) {
        if (seen.add(p.id) && out.length < 10) out.add(p);
      }
    }
    return out;
  }
}
