import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/astro_palette.dart';
import '../../../../core/theme/brand_colors.dart';
import '../../../../shared/widgets/app_bottom_sheet.dart';
import '../../../../shared/widgets/cosmic.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../../../shared/widgets/fade_slide_in.dart';
import '../../../../shared/widgets/hue_widgets.dart';
import '../../data/astrologers_api.dart';
import '../cubit/discovery_cubit.dart';
import 'widgets/astrologer_list_tile.dart';

const _channelKeys = <String>['', 'chat', 'voice', 'video'];
const _sortKeys = <String>[
  'recommended',
  'rating',
  'experience',
  'consultations',
  'newest',
];

const double _searchBarHeight = 68;

/// The discovery tab. Seeded from the URL query (`?skill=`, `?channel=`, `?q=`,
/// `?sort=`) so every home rail / concern chip / CTA lands on a real filtered
/// list. Cursor-paginated with infinite scroll.
class AstrologersPage extends StatelessWidget {
  const AstrologersPage({required this.initialQuery, super.key});

  final AstrologerQuery initialQuery;

  /// Builds the seed query from a GoRouter query string.
  factory AstrologersPage.fromParams(Map<String, String> p, {Key? key}) {
    return AstrologersPage(
      key: key,
      initialQuery: AstrologerQuery(
        skill: p['skill'],
        channel: p['channel'],
        search: p['q'],
        sort: p['sort'] ?? 'recommended',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<DiscoveryCubit>(),
      child: _DiscoveryView(initialQuery: initialQuery),
    );
  }
}

class _DiscoveryView extends StatefulWidget {
  const _DiscoveryView({required this.initialQuery});

  final AstrologerQuery initialQuery;

  @override
  State<_DiscoveryView> createState() => _DiscoveryViewState();
}

class _DiscoveryViewState extends State<_DiscoveryView> {
  final _scroll = ScrollController();
  late final _searchController = TextEditingController(
    text: widget.initialQuery.search ?? '',
  );
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
    // The cubit is a fresh instance from the BlocProvider above; kick off the
    // first fetch as soon as it's mounted.
    context.read<DiscoveryCubit>().applyQuery(widget.initialQuery);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _scroll.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scroll.hasClients) return;
    if (_scroll.position.pixels >= _scroll.position.maxScrollExtent - 600) {
      context.read<DiscoveryCubit>().loadMore();
    }
  }

  void _onSearchChanged(String value) {
    setState(() {}); // toggles the clear button
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      if (mounted) context.read<DiscoveryCubit>().search(value);
    });
  }

  void _clearSearch() {
    _debounce?.cancel();
    _searchController.clear();
    context.read<DiscoveryCubit>().search(null);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    final cubit = context.read<DiscoveryCubit>();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: brand.canvas,
        body: BlocConsumer<DiscoveryCubit, DiscoveryState>(
          // Only after a filter/search change — not after an infinite-scroll page.
          listenWhen: (a, b) =>
              b.status == DiscoveryStatus.ready &&
              !b.isEmpty &&
              (a.status == DiscoveryStatus.refiltering ||
                  a.status == DiscoveryStatus.loading),
          listener: (_, _) {
            // Jump back to the list top when a new filter's results land.
            if (_scroll.hasClients && _scroll.offset > 400) {
              _scroll.jumpTo(0);
            }
          },
          builder: (context, state) => RefreshIndicator(
            onRefresh: cubit.refresh,
            color: AstroPalette.romance[1],
            edgeOffset: 200,
            child: CustomScrollView(
              controller: _scroll,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                _Header(
                  state: state,
                  search: _SearchField(
                    controller: _searchController,
                    onChanged: _onSearchChanged,
                    onSubmitted: cubit.search,
                    onClear: _clearSearch,
                  ),
                ),
                const SliverPersistentHeader(
                  pinned: true,
                  delegate: _FilterHeaderDelegate(),
                ),
                ..._results(context, state, l, cubit),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _results(
    BuildContext context,
    DiscoveryState state,
    AppLocalizations l,
    DiscoveryCubit cubit,
  ) {
    if (state.showFullSkeleton) {
      return const [_ResultsSkeleton()];
    }
    if (state.status == DiscoveryStatus.error && state.items.isEmpty) {
      return [
        SliverFillRemaining(
          hasScrollBody: false,
          child: ErrorView(message: l.astroCouldntLoad, onRetry: cubit.refresh),
        ),
      ];
    }
    if (state.isEmpty) {
      return [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 120),
            child: EmptyState(
              icon: Icons.search_off_rounded,
              title: l.astroNoneFound,
              message: l.astroNoneFoundHint,
            ),
          ),
        ),
      ];
    }
    return [
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
        sliver: SliverList.separated(
          itemCount: state.items.length,
          separatorBuilder: (_, _) => const SizedBox(height: 10),
          itemBuilder: (context, i) {
            final tile = AstrologerListTile(
              astrologer: state.items[i],
              channel: state.query.channel,
            );
            // Stagger only the first screenful; later pages just append.
            return i < 6
                ? FadeSlideIn(
                    key: ValueKey('${state.query.hashCode}-$i'),
                    delay: Duration(milliseconds: 35 * i),
                    child: tile,
                  )
                : tile;
          },
        ),
      ),
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 140),
          child: _Footer(state: state, onRetry: cubit.retryLoadMore),
        ),
      ),
    ];
  }
}

// --- header -------------------------------------------------------------------------

/// Cosmic collapsing header: big title + live count, with the search field pinned
/// as its bottom so it's always one tap away.
class _Header extends StatelessWidget {
  const _Header({required this.state, required this.search});

  final DiscoveryState state;
  final Widget search;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final brand = context.brand;
    final online = state.items.where((a) => a.isAvailable).length;

    return SliverAppBar(
      pinned: true,
      stretch: true,
      automaticallyImplyLeading: false,
      expandedHeight: 196,
      toolbarHeight: 60,
      backgroundColor: brand.cosmicStart,
      surfaceTintColor: Colors.transparent,
      foregroundColor: Colors.white,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      title: Text(
        l.navAstrologers,
        style: theme.textTheme.titleLarge?.copyWith(color: Colors.white),
      ),
      // The nebula sits outside the FlexibleSpaceBar so it stays visible behind
      // the collapsed bar instead of fading to a flat colour.
      flexibleSpace: Stack(
        fit: StackFit.expand,
        children: [
          const CosmicBackdrop(),
          FlexibleSpaceBar(
            collapseMode: CollapseMode.parallax,
            background: Stack(
              fit: StackFit.expand,
              children: [
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      20,
                      56,
                      20,
                      _searchBarHeight + 8,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            const LiveDot(),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                online > 0
                                    ? l.homeOnlineCount(online)
                                    : l.homeTalkToAstrologer,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.titleSmall?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l.homeGuidanceTagline,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withValues(alpha: 0.72),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(_searchBarHeight),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 14),
          child: search,
        ),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.controller,
    required this.onChanged,
    required this.onSubmitted,
    required this.onClear,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final brand = context.brand;
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
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
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              onSubmitted: onSubmitted,
              textInputAction: TextInputAction.search,
              style: theme.textTheme.bodyLarge,
              decoration: InputDecoration(
                hintText: l.astroSearchHint,
                hintStyle: theme.textTheme.bodyMedium?.copyWith(
                  color: brand.inkMuted,
                ),
                isDense: true,
                filled: false,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              ),
            ),
          ),
          if (controller.text.isNotEmpty)
            IconButton(
              tooltip: MaterialLocalizations.of(context).deleteButtonTooltip,
              icon: Icon(Icons.close_rounded, color: brand.inkMuted),
              onPressed: onClear,
            ),
          const SizedBox(width: 4),
        ],
      ),
    );
  }
}

// --- filters ------------------------------------------------------------------------

class _FilterHeaderDelegate extends SliverPersistentHeaderDelegate {
  const _FilterHeaderDelegate();

  static const double _height = 64;

  @override
  double get minExtent => _height;
  @override
  double get maxExtent => _height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlaps) {
    final brand = context.brand;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: brand.canvas,
        boxShadow: overlaps
            ? [
                BoxShadow(
                  color: brand.cosmicStart.withValues(alpha: 0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: const Column(
        children: [
          Expanded(child: _FilterBar()),
          _RefilterBar(),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _FilterHeaderDelegate oldDelegate) => false;
}

/// Thin gradient progress line shown while re-filtering with results on screen.
class _RefilterBar extends StatelessWidget {
  const _RefilterBar();

  @override
  Widget build(BuildContext context) {
    final refiltering = context.select(
      (DiscoveryCubit c) => c.state.status == DiscoveryStatus.refiltering,
    );
    return SizedBox(
      height: 2,
      child: refiltering
          ? LinearProgressIndicator(
              minHeight: 2,
              backgroundColor: Colors.transparent,
              color: AstroPalette.romance[1],
            )
          : null,
    );
  }
}

class _FilterBar extends StatelessWidget {
  const _FilterBar();

  static AstroHue _channelHue(String key) => switch (key) {
    'chat' => AstroPalette.career,
    'voice' => AstroPalette.health,
    'video' => AstroPalette.love,
    _ => AstroPalette.money,
  };

  static IconData _channelIcon(String key) => switch (key) {
    'chat' => Icons.chat_bubble_rounded,
    'voice' => Icons.phone_in_talk_rounded,
    'video' => Icons.videocam_rounded,
    _ => Icons.auto_awesome_rounded,
  };

  static String _channelLabel(AppLocalizations l, String key) => switch (key) {
    'chat' => l.channelChat,
    'voice' => l.channelCall,
    'video' => l.channelVideo,
    _ => l.channelAll,
  };

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final cubit = context.read<DiscoveryCubit>();
    final query = context.select((DiscoveryCubit c) => c.state.query);
    final channel = query.channel ?? '';
    final sort = query.sort ?? 'recommended';

    return ListView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
      children: [
        for (final key in _channelKeys) ...[
          _HueChip(
            label: _channelLabel(l, key),
            icon: _channelIcon(key),
            hue: _channelHue(key),
            selected: key == channel,
            onTap: () => cubit.setChannel(key.isEmpty ? null : key),
          ),
          const SizedBox(width: 8),
        ],
        _HueChip(
          label: _sortLabel(l, sort),
          icon: Icons.swap_vert_rounded,
          hue: AstroPalette.air,
          selected: false,
          trailing: Icons.expand_more_rounded,
          onTap: () => _pickSort(context, cubit, sort),
        ),
        if (query.skill != null) ...[
          const SizedBox(width: 8),
          _HueChip(
            label: _titleCase(query.skill!),
            icon: Icons.local_offer_rounded,
            hue: AstroPalette.fire,
            selected: true,
            trailing: Icons.close_rounded,
            onTap: () => cubit.applyQuery(query.copyWith(skill: null)),
          ),
        ],
      ],
    );
  }

  Future<void> _pickSort(
    BuildContext context,
    DiscoveryCubit cubit,
    String current,
  ) async {
    final l = context.l10n;
    final picked = await showAppSheet<String>(
      context: context,
      title: l.astroSortBy,
      builder: (sheet) => ListView(
        shrinkWrap: true,
        children: [
          for (final key in _sortKeys)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _SortOption(
                label: _sortLabel(l, key),
                icon: _sortIcon(key),
                hue: _sortHue(key),
                selected: key == current,
                onTap: () => Navigator.pop(sheet, key),
              ),
            ),
        ],
      ),
    );
    if (picked != null && picked != current) {
      unawaited(cubit.setSort(picked));
    }
  }

  static String _sortLabel(AppLocalizations l, String key) => switch (key) {
    'rating' => l.astroSortTopRated,
    'experience' => l.astroSortExperienced,
    'consultations' => l.astroSortConsulted,
    'newest' => l.astroSortNew,
    _ => l.astroSortRecommended,
  };

  static IconData _sortIcon(String key) => switch (key) {
    'rating' => Icons.star_rounded,
    'experience' => Icons.workspace_premium_rounded,
    'consultations' => Icons.groups_rounded,
    'newest' => Icons.fiber_new_rounded,
    _ => Icons.auto_awesome_rounded,
  };

  static AstroHue _sortHue(String key) => switch (key) {
    'rating' => AstroPalette.money,
    'experience' => AstroPalette.health,
    'consultations' => AstroPalette.love,
    'newest' => AstroPalette.air,
    _ => AstroPalette.career,
  };

  static String _titleCase(String slug) => slug
      .split(RegExp(r'[-_ ]'))
      .where((w) => w.isNotEmpty)
      .map((w) => w[0].toUpperCase() + w.substring(1))
      .join(' ');
}

class _HueChip extends StatelessWidget {
  const _HueChip({
    required this.label,
    required this.icon,
    required this.hue,
    required this.selected,
    required this.onTap,
    this.trailing,
  });

  final String label;
  final IconData icon;
  final AstroHue hue;
  final bool selected;
  final VoidCallback onTap;
  final IconData? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fg = selected ? Colors.white : hue.end;
    return Semantics(
      button: true,
      selected: selected,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            gradient: selected ? hue.linear() : null,
            color: selected ? null : hue.tint(0.09),
            border: Border.all(
              color: selected ? Colors.transparent : hue.tint(0.28),
            ),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: hue.start.withValues(alpha: 0.35),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 15, color: fg),
              const SizedBox(width: 6),
              Text(
                label,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: selected ? Colors.white : null,
                  fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: 2),
                Icon(trailing, size: 16, color: fg),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _SortOption extends StatelessWidget {
  const _SortOption({
    required this.label,
    required this.icon,
    required this.hue,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final AstroHue hue;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: selected ? hue.tint(0.12) : theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: selected ? hue.end : context.brand.hairline,
          width: selected ? 1.4 : 1,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              HueIcon(hue: hue, icon: icon, size: 38, iconSize: 19),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (selected) Icon(Icons.check_circle_rounded, color: hue.end),
            ],
          ),
        ),
      ),
    );
  }
}

// --- footer / skeleton ---------------------------------------------------------------

class _Footer extends StatelessWidget {
  const _Footer({required this.state, required this.onRetry});

  final DiscoveryState state;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);

    if (state.loadMoreError) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Center(
          child: TextButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded, size: 18),
            label: Text(l.astroLoadMoreFailed),
          ),
        ),
      );
    }
    if (state.status == DiscoveryStatus.loadingMore) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2.4,
              color: AstroPalette.romance[1],
            ),
          ),
        ),
      );
    }
    if (state.hasMore) return const SizedBox(height: 24);
    if (state.items.length <= 3) return const SizedBox(height: 8);
    return Padding(
      padding: const EdgeInsets.only(top: 22),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.auto_awesome_rounded,
            size: 14,
            color: AstroPalette.money.start,
          ),
          const SizedBox(width: 6),
          Text(
            l.astroThatsEveryone,
            style: theme.textTheme.bodySmall?.copyWith(
              color: context.brand.inkMuted,
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultsSkeleton extends StatelessWidget {
  const _ResultsSkeleton();

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 140),
      sliver: SliverList.separated(
        itemCount: 5,
        separatorBuilder: (_, _) => const SizedBox(height: 10),
        itemBuilder: (_, i) => Shimmer.fromColors(
          baseColor: brand.shimmerBase,
          highlightColor: brand.shimmerHighlight,
          child: Container(
            height: 96,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),
    );
  }
}
