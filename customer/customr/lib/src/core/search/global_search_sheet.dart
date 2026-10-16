import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:talkacharya_ui/talkacharya_ui.dart';

import '../../features/articles/data/models/article.dart';
import '../../features/astrologers/data/models/astrologer.dart';
import '../../features/birthprofiles/data/models/birth_profile.dart';

import '../di/service_locator.dart';
import '../router/routes.dart';
import 'app_feature_registry.dart';
import 'global_search_cubit.dart';
import 'global_search_repository.dart';

/// Opens the Universal In-App Global Search modal sheet with Cosmic Home theme.
Future<void> showGlobalSearchSheet(BuildContext context, {String initialQuery = ''}) {
  return showAppSheet<void>(
    context: context,
    title: 'Search',
    builder: (context) => BlocProvider(
      create: (_) => GlobalSearchCubit(
        searchRepo: getIt<GlobalSearchRepository>(),
        astrologersRepo: getIt(),
      ),
      child: _GlobalSearchBody(initialQuery: initialQuery),
    ),
  );
}

class _GlobalSearchBody extends StatefulWidget {
  const _GlobalSearchBody({required this.initialQuery});

  final String initialQuery;

  @override
  State<_GlobalSearchBody> createState() => _GlobalSearchBodyState();
}

class _GlobalSearchBodyState extends State<_GlobalSearchBody> {
  late final _controller = TextEditingController(text: widget.initialQuery);
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    if (widget.initialQuery.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.read<GlobalSearchCubit>().search(context, widget.initialQuery);
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brand = context.brand;
    final cubit = context.read<GlobalSearchCubit>();

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.85,
      child: Column(
        children: [
          // --- Cosmic Header with White Search Field ---
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [brand.cosmicStart, brand.cosmicEnd],
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Stack(
              children: [
                const Positioned.fill(child: CosmicBackdrop()),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Search Box
                      Container(
                        height: 52,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: brand.cosmicStart.withValues(alpha: 0.35),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 6),
                            const HueIcon(
                              hue: AstroPalette.career,
                              icon: Icons.search_rounded,
                              size: 36,
                              iconSize: 19,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: TextField(
                                controller: _controller,
                                focusNode: _focusNode,
                                autofocus: true,
                                onChanged: (v) => cubit.search(context, v),
                                onSubmitted: (v) {
                                  cubit.saveSearchTerm(v);
                                },
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF1E1610),
                                ),
                                decoration: InputDecoration(
                                  hintText: 'Search features, astrologers, profiles...',
                                  hintStyle: theme.textTheme.bodyMedium?.copyWith(
                                    color: brand.inkMuted,
                                  ),
                                  isDense: true,
                                  filled: false,
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                                ),
                              ),
                            ),
                            ValueListenableBuilder<TextEditingValue>(
                              valueListenable: _controller,
                              builder: (context, val, _) {
                                if (val.text.isEmpty) return const SizedBox.shrink();
                                return IconButton(
                                  icon: Icon(Icons.close_rounded, color: brand.inkMuted, size: 20),
                                  onPressed: () {
                                    _controller.clear();
                                    cubit.search(context, '');
                                  },
                                );
                              },
                            ),
                            const SizedBox(width: 4),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // --- Search Body ---
          Expanded(
            child: Container(
              color: brand.canvas,
              child: BlocBuilder<GlobalSearchCubit, GlobalSearchState>(
                builder: (context, state) {
                  final query = state.query.trim();

                  if (query.isEmpty) {
                    return _EmptySearchOverview(
                      recents: cubit.recentSearches,
                      onSelect: (term) {
                        _controller.text = term;
                        cubit.search(context, term);
                      },
                      onRemove: cubit.removeRecentSearch,
                      onClearAll: cubit.clearRecentSearches,
                    );
                  }

                  final res = state.result;
                  if (res.isEmpty && !state.loading) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const HueIcon(
                              hue: AstroPalette.career,
                              icon: Icons.search_off_rounded,
                              size: 56,
                              iconSize: 28,
                            ),
                            const SizedBox(height: 14),
                            Text(
                              'No results found for "$query"',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Try searching for astrologers, features like "wallet", "milan", "panchang" or "store"',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: brand.inkMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return ListView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                    children: [
                      if (res.features.isNotEmpty)
                        _CategorySection(
                          title: 'Features & Shortcuts',
                          hue: AstroPalette.career,
                          icon: Icons.bolt_rounded,
                          children: res.features.map((f) => _FeatureTile(item: f)).toList(),
                        ),
                      if (res.astrologers.isNotEmpty)
                        _CategorySection(
                          title: 'Astrologers',
                          hue: AstroPalette.health,
                          icon: Icons.groups_rounded,
                          children: res.astrologers.map((a) => _AstrologerTile(item: a)).toList(),
                        ),
                      if (res.profiles.isNotEmpty)
                        _CategorySection(
                          title: 'Saved Birth Profiles',
                          hue: AstroPalette.love,
                          icon: Icons.person_pin_rounded,
                          children: res.profiles.map((p) => _ProfileTile(item: p)).toList(),
                        ),
                      if (res.articles.isNotEmpty)
                        _CategorySection(
                          title: 'Articles & Guides',
                          hue: AstroPalette.money,
                          icon: Icons.menu_book_rounded,
                          children: res.articles.map((art) => _ArticleTile(item: art)).toList(),
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategorySection extends StatelessWidget {
  const _CategorySection({
    required this.title,
    required this.hue,
    required this.icon,
    required this.children,
  });

  final String title;
  final AstroHue hue;
  final IconData icon;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brand = context.brand;

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: hue.tint(0.14),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 14, color: hue.end),
              ),
              const SizedBox(width: 8),
              Text(
                title.toUpperCase(),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: brand.inkMuted,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: brand.hairline),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                for (var i = 0; i < children.length; i++) ...[
                  if (i > 0) Divider(height: 1, color: brand.hairline),
                  children[i],
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureTile extends StatelessWidget {
  const _FeatureTile({required this.item});

  final AppFeatureItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brand = context.brand;

    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AstroPalette.career.tint(0.12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(item.icon, size: 20, color: AstroPalette.career.end),
      ),
      title: Text(
        item.title,
        style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
      ),
      subtitle: Text(
        item.subtitle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.bodySmall?.copyWith(color: brand.inkMuted),
      ),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
      onTap: () {
        context.read<GlobalSearchCubit>().saveSearchTerm(item.title);
        Navigator.pop(context);
        context.push(item.route);
      },
    );
  }
}

class _AstrologerTile extends StatelessWidget {
  const _AstrologerTile({required this.item});

  final Astrologer item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brand = context.brand;

    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      leading: CircleAvatar(
        radius: 18,
        backgroundColor: AstroPalette.health.tint(0.15),
        foregroundImage: item.avatar != null && item.avatar!.isNotEmpty
            ? NetworkImage(item.avatar!)
            : null,
        child: Text(
          item.name.isEmpty ? 'A' : item.name[0].toUpperCase(),
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              item.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          if (item.isAvailable)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFF16A34A).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(999),
              ),
              child: const Text(
                'Online',
                style: TextStyle(
                  color: Color(0xFF16A34A),
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
        ],
      ),
      subtitle: Text(
        '${item.skills.take(2).map((s) => s.name).join(', ')} · ${item.yearsExperience} yrs exp',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.bodySmall?.copyWith(color: brand.inkMuted),
      ),
      onTap: () {
        context.read<GlobalSearchCubit>().saveSearchTerm(item.name);
        Navigator.pop(context);
        context.push('/astrologers/${item.id}');
      },
    );
  }
}

class _ProfileTile extends StatelessWidget {
  const _ProfileTile({required this.item});

  final BirthProfile item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brand = context.brand;

    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AstroPalette.love.tint(0.12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(Icons.person_rounded, size: 20, color: AstroPalette.love.end),
      ),
      title: Text(
        item.displayName,
        style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
      ),
      subtitle: Text(
        item.subtitle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.bodySmall?.copyWith(color: brand.inkMuted),
      ),
      onTap: () {
        context.read<GlobalSearchCubit>().saveSearchTerm(item.displayName);
        Navigator.pop(context);
        context.push('/kundali/${item.id}');
      },
    );
  }
}

class _ArticleTile extends StatelessWidget {
  const _ArticleTile({required this.item});

  final ArticleSummary item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brand = context.brand;

    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AstroPalette.money.tint(0.12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(Icons.article_rounded, size: 20, color: AstroPalette.money.end),
      ),
      title: Text(
        item.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
      ),
      subtitle: Text(
        item.excerpt.isNotEmpty ? item.excerpt : item.category.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.bodySmall?.copyWith(color: brand.inkMuted),
      ),
      onTap: () {
        context.read<GlobalSearchCubit>().saveSearchTerm(item.title);
        Navigator.pop(context);
        context.push(Routes.article(item.slug));
      },
    );
  }
}

class _EmptySearchOverview extends StatelessWidget {
  const _EmptySearchOverview({
    required this.recents,
    required this.onSelect,
    required this.onRemove,
    required this.onClearAll,
  });

  final List<String> recents;
  final ValueChanged<String> onSelect;
  final ValueChanged<String> onRemove;
  final VoidCallback onClearAll;

  static const _popular = [
    'Kundali Milan',
    'Today\'s Panchang',
    'Horoscope',
    'Wallet',
    'Store',
    'Help & Support',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brand = context.brand;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      children: [
        // --- Popular Shortcuts ---
        Row(
          children: [
            Icon(Icons.auto_awesome_rounded, size: 16, color: AstroPalette.career.end),
            const SizedBox(width: 6),
            Text(
              'POPULAR SHORTCUTS',
              style: theme.textTheme.labelSmall?.copyWith(
                color: brand.inkMuted,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.1,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final tag in _popular)
              ActionChip(
                avatar: Icon(Icons.bolt_rounded, size: 14, color: AstroPalette.career.end),
                label: Text(tag),
                labelStyle: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurface,
                ),
                backgroundColor: theme.colorScheme.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: brand.hairline),
                ),
                onPressed: () => onSelect(tag),
              ),
          ],
        ),

        if (recents.isNotEmpty) ...[
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.history_rounded, size: 16, color: brand.inkMuted),
                  const SizedBox(width: 6),
                  Text(
                    'RECENT SEARCHES',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: brand.inkMuted,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.1,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: onClearAll,
                child: const Text('Clear All', style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: brand.hairline),
            ),
            child: Column(
              children: [
                for (var i = 0; i < recents.length; i++) ...[
                  if (i > 0) Divider(height: 1, color: brand.hairline),
                  ListTile(
                    dense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14),
                    leading: Icon(Icons.history_rounded, color: brand.inkMuted, size: 18),
                    title: Text(
                      recents[i],
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.close_rounded, size: 16, color: brand.inkMuted),
                      onPressed: () => onRemove(recents[i]),
                    ),
                    onTap: () => onSelect(recents[i]),
                  ),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }
}
