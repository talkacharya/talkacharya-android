import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/l10n.dart';
import '../../data/astrologers_api.dart';
import '../cubit/discovery_cubit.dart';
import 'widgets/astrologer_list_tile.dart';

import 'package:talkacharya_ui/talkacharya_ui.dart';

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
        following: p['following'] == '1',
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
  final _searchFocusNode = FocusNode();
  late final _searchController = TextEditingController(
    text: widget.initialQuery.search ?? '',
  );
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
    context.read<DiscoveryCubit>().applyQuery(widget.initialQuery);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _scroll.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scroll.hasClients) return;
    if (_scroll.position.pixels >= _scroll.position.maxScrollExtent - 600) {
      context.read<DiscoveryCubit>().loadMore();
    }
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      if (mounted) context.read<DiscoveryCubit>().search(value);
    });
  }

  void _clearSearch() {
    _debounce?.cancel();
    _searchController.clear();
    context.read<DiscoveryCubit>().search(null);
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
          listenWhen: (a, b) =>
              b.status == DiscoveryStatus.ready &&
              !b.isEmpty &&
              (a.status == DiscoveryStatus.refiltering ||
                  a.status == DiscoveryStatus.loading),
          listener: (_, _) {
            if (_scroll.hasClients && _scroll.offset > 400) {
              _scroll.jumpTo(0);
            }
          },
          builder: (context, state) => CustomScrollView(
            controller: _scroll,
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              CupertinoSliverRefreshControl(
                onRefresh: () async => cubit.refresh(),
              ),
              _Header(
                state: state,
                search: _SearchField(
                  controller: _searchController,
                  focusNode: _searchFocusNode,
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
            padding: const EdgeInsets.only(bottom: 50),
            child: state.query.following
                ? EmptyState(
                    icon: Icons.favorite_border_rounded,
                    title: l.followingEmptyTitle,
                    message: l.followingFilterEmpty,
                  )
                : EmptyState(
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

class _Header extends StatelessWidget {
  const _Header({required this.state, required this.search});

  final DiscoveryState state;
  final Widget search;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final brand = context.brand;

    return SliverAppBar(
      pinned: true,
      stretch: true,
      automaticallyImplyLeading: false,
      expandedHeight: 155,
      toolbarHeight: 60,
      backgroundColor: brand.cosmicStart,
      surfaceTintColor: Colors.transparent,
      foregroundColor: Colors.white,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      title: Text(
        l.navAstrologers,
        style: theme.textTheme.titleLarge?.copyWith(color: Colors.white),
      ),
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

class _SearchField extends StatefulWidget {
  const _SearchField({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onSubmitted,
    required this.onClear,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onClear;

  @override
  State<_SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<_SearchField> {
  final _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_onFocusChange);
    _removeOverlay();
    super.dispose();
  }

  void _onFocusChange() {
    if (widget.focusNode.hasFocus) {
      _showOverlay();
    } else {
      _removeOverlay();
    }
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _showOverlay() {
    _removeOverlay();
    final cubit = context.read<DiscoveryCubit>();
    final recents = cubit.recentSearches;
    if (recents.isEmpty) return;

    _overlayEntry = OverlayEntry(
      builder: (context) {
        final theme = Theme.of(context);
        final brand = context.brand;
        final list = cubit.recentSearches;
        if (list.isEmpty) return const SizedBox.shrink();

        return Positioned(
          width: MediaQuery.of(context).size.width - 32,
          child: CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            offset: const Offset(0, 54),
            child: Material(
              elevation: 8,
              borderRadius: BorderRadius.circular(16),
              color: theme.colorScheme.surface,
              shadowColor: Colors.black38,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: brand.hairline),
                ),
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 4, 12, 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Recent Searches',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: brand.inkMuted,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              cubit.clearRecentSearches();
                              _removeOverlay();
                            },
                            child: const Text(
                              'Clear All',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 220),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: list.length,
                        itemBuilder: (context, i) {
                          final term = list[i];
                          return ListTile(
                            dense: true,
                            leading: Icon(
                              Icons.history_rounded,
                              size: 18,
                              color: brand.inkMuted,
                            ),
                            title: Text(
                              term,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            trailing: IconButton(
                              icon: Icon(
                                Icons.close_rounded,
                                size: 16,
                                color: brand.inkMuted,
                              ),
                              onPressed: () {
                                cubit.removeRecentSearch(term);
                                _showOverlay();
                              },
                            ),
                            onTap: () {
                              widget.controller.text = term;
                              widget.focusNode.unfocus();
                              widget.onSubmitted(term);
                              _removeOverlay();
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final brand = context.brand;

    return CompositedTransformTarget(
      link: _layerLink,
      child: Container(
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
                focusNode: widget.focusNode,
                controller: widget.controller,
                onChanged: (v) {
                  widget.onChanged(v);
                  if (widget.focusNode.hasFocus && v.isEmpty) {
                    _showOverlay();
                  } else {
                    _removeOverlay();
                  }
                },
                onSubmitted: (v) {
                  widget.onSubmitted(v);
                  widget.focusNode.unfocus();
                  _removeOverlay();
                },
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
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: widget.controller,
              builder: (context, value, _) {
                if (value.text.isEmpty) return const SizedBox.shrink();
                return IconButton(
                  tooltip: MaterialLocalizations.of(
                    context,
                  ).deleteButtonTooltip,
                  icon: Icon(Icons.close_rounded, color: brand.inkMuted),
                  onPressed: () {
                    widget.onClear();
                    _showOverlay();
                  },
                );
              },
            ),
            const SizedBox(width: 4),
          ],
        ),
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
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return const Column(
      children: [
        Expanded(child: _FilterChipRail()),
        Divider(height: 1),
      ],
    );
  }

  @override
  bool shouldRebuild(covariant _FilterHeaderDelegate oldDelegate) => false;
}

class _FilterChipRail extends StatelessWidget {
  const _FilterChipRail();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<DiscoveryCubit>();
    final query = context.select((DiscoveryCubit c) => c.state.query);
    final theme = Theme.of(context);
    final brand = context.brand;

    final channels = [
      (null, 'All', Icons.auto_awesome_rounded),
      ('chat', 'Chat', Icons.chat_bubble_rounded),
      ('voice', 'Call', Icons.phone_in_talk_rounded),
      // VIDEO-OFF: video calls are switched off for now.
      // ('video', 'Video call', Icons.videocam_rounded),
    ];

    return Container(
      color: brand.canvas,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        children: [
          for (final item in channels) ...[
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                showCheckmark: false,
                avatar: Icon(
                  item.$3,
                  size: 16,
                  color: query.channel == item.$1
                      ? Colors.white
                      : theme.colorScheme.onSurfaceVariant,
                ),
                label: Text(item.$2),
                selected: query.channel == item.$1,
                selectedColor: brand.cosmicStart,
                labelStyle: TextStyle(
                  color: query.channel == item.$1
                      ? Colors.white
                      : theme.colorScheme.onSurface,
                  fontWeight: query.channel == item.$1
                      ? FontWeight.w700
                      : FontWeight.w500,
                  fontSize: 13,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                side: BorderSide(
                  color: query.channel == item.$1
                      ? brand.cosmicStart
                      : brand.hairline,
                ),
                onSelected: (_) => cubit.setChannel(item.$1),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// --- footer -------------------------------------------------------------------------

class _Footer extends StatelessWidget {
  const _Footer({required this.state, required this.onRetry});

  final DiscoveryState state;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    if (state.status == DiscoveryStatus.loadingMore) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (state.loadMoreError) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Center(
          child: TextButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded, size: 18),
            label: Text(context.l10n.commonRetry),
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}

// --- skeletons ----------------------------------------------------------------------

class _ResultsSkeleton extends StatelessWidget {
  const _ResultsSkeleton();

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
      sliver: SliverList.builder(
        itemCount: 4,
        itemBuilder: (context, _) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Shimmer.fromColors(
            baseColor: context.brand.shimmerBase,
            highlightColor: context.brand.shimmerHighlight,
            child: Container(
              height: 124,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
