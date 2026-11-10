import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:talkacharya_ui/talkacharya_ui.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/profile/active_profile_store.dart';
import '../../../../core/router/routes.dart';
import '../../../home/presentation/view/widgets/home_shared.dart';
import '../../data/models/catalog.dart';
import '../../data/store_repository.dart';
import 'store_ui.dart';

/// Home's "Remedies for you": a light row of small collection cards — the ones
/// the active profile's chart calls for (each says why), then the ones in
/// season, then the team's picks. Follows the profile switcher; hides itself
/// when there is nothing to show or the store cannot be reached.
class RemediesForYouRail extends StatefulWidget {
  const RemediesForYouRail({super.key});

  static const double _cardWidth = 168;
  static const double _height = 128;

  @override
  State<RemediesForYouRail> createState() => _RemediesForYouRailState();
}

class _RemediesForYouRailState extends State<RemediesForYouRail> {
  final _profiles = getIt<ActiveProfileStore>();
  late String? _profile = _profiles.activeProfileId;
  late Future<List<StoreCollection>> _future = _load();

  Future<List<StoreCollection>> _load() =>
      getIt<StoreRepository>().collectionsForMe(profileId: _profile);

  @override
  void initState() {
    super.initState();
    _profiles.addListener(_onProfile);
  }

  @override
  void dispose() {
    _profiles.removeListener(_onProfile);
    super.dispose();
  }

  void _onProfile() {
    final id = _profiles.activeProfileId;
    if (id == _profile || !mounted) return;
    setState(() {
      _profile = id;
      _future = _load();
    });
  }

  @override
  void didUpdateWidget(RemediesForYouRail oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Pull-to-refresh on Home rebuilds the sections.
    _future = _load();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return FutureBuilder<List<StoreCollection>>(
      future: _future,
      builder: (context, snap) {
        if (snap.hasError) return const SizedBox.shrink();
        final items = snap.data;
        if (items != null && items.isEmpty) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(
              title: l.remediesForYouTitle,
              subtitle: l.remediesForYouSub,
              hue: AstroPalette.money,
              seeAllLabel: l.storeSeeAll,
              onSeeAll: () => context.go(Routes.store),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: RemediesForYouRail._height,
              child: items == null
                  ? ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: 3,
                      separatorBuilder: (_, _) => const SizedBox(width: 10),
                      itemBuilder: (_, _) => const AppShimmer(
                        child: SkeletonBox(
                          width: RemediesForYouRail._cardWidth,
                          height: RemediesForYouRail._height,
                          radius: 16,
                        ),
                      ),
                    )
                  : ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: items.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 10),
                      itemBuilder: (_, i) =>
                          _CollectionTile(collection: items[i], index: i),
                    ),
            ),
          ],
        );
      },
    );
  }
}

class _CollectionTile extends StatelessWidget {
  const _CollectionTile({required this.collection, required this.index});

  final StoreCollection collection;
  final int index;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final c = collection;
    final hue = AstroPalette.at(index);
    // Why it is here, else how much is in it.
    final line = c.reason.isNotEmpty
        ? c.reason
        : (c.items == null ? '' : l.collectionItems(c.items!));
    return SizedBox(
      width: RemediesForYouRail._cardWidth,
      child: Pressable(
        child: Material(
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: InkWell(
            onTap: () => context.push(Routes.storeCollection(c.slug)),
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (c.card != null)
                  StoreImage(url: c.card, slug: c.slug, radius: 0)
                else
                  DecoratedBox(
                    decoration: BoxDecoration(gradient: hue.linear()),
                  ),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0x00000000), Color(0xC0000000)],
                      stops: [0.25, 1],
                    ),
                  ),
                ),
                if (c.personal)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.35),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.auto_awesome_rounded,
                        size: 12,
                        color: Color(0xFFFFD27A),
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 8, 10, 9),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        c.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          height: 1.15,
                        ),
                      ),
                      if (line.isNotEmpty)
                        Text(
                          line,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.labelSmall?.copyWith(
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
