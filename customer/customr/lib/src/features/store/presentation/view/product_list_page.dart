import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/astro_palette.dart';
import '../../../../core/theme/brand_colors.dart';
import '../../../../shared/widgets/app_bottom_sheet.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../../../shared/widgets/fade_slide_in.dart';
import '../../data/models/catalog.dart';
import '../cubit/product_list_cubit.dart';
import '../widgets/store_ui.dart';

/// `/store/products?…` — search + filters + a 2-column grid.
class ProductListPage extends StatefulWidget {
  const ProductListPage({this.focusSearch = false, this.title, super.key});

  final bool focusSearch;

  /// Optional heading (collection / category name) instead of the search field.
  final String? title;

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  late final TextEditingController _search = TextEditingController(
    text: context.read<ProductListCubit>().state.query.search,
  );
  final _scroll = ScrollController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(() {
      if (_scroll.position.extentAfter < 600) {
        context.read<ProductListCubit>().loadMore();
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _search.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _onSearch(String text) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      if (mounted) context.read<ProductListCubit>().search(text);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    return Scaffold(
      backgroundColor: brand.canvas,
      appBar: AppBar(
        titleSpacing: 0,
        title: TextField(
          controller: _search,
          autofocus: widget.focusSearch,
          onChanged: _onSearch,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: l.storeSearchHint,
            prefixIcon: const Icon(Icons.search_rounded),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(vertical: 10),
            fillColor: Theme.of(context).colorScheme.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(999),
              borderSide: BorderSide(color: brand.hairline),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(999),
              borderSide: BorderSide(color: brand.hairline),
            ),
          ),
        ),
        actions: const [CartButton(), SizedBox(width: 4)],
      ),
      body: BlocBuilder<ProductListCubit, ProductListState>(
        builder: (context, state) => Column(
          children: [
            _FilterBar(state: state),
            if (state.status == ListStatus.refiltering)
              const LinearProgressIndicator(minHeight: 2),
            Expanded(child: _grid(context, state)),
          ],
        ),
      ),
    );
  }

  Widget _grid(BuildContext context, ProductListState state) {
    final l = context.l10n;
    final cubit = context.read<ProductListCubit>();
    switch (state.status) {
      case ListStatus.loading:
        return const SingleChildScrollView(
          child: ProductGridSkeleton(count: 6),
        );
      case ListStatus.error:
        return ErrorView(message: state.error ?? '', onRetry: cubit.retry);
      case ListStatus.ready:
      case ListStatus.refiltering:
        if (state.items.isEmpty) {
          return EmptyState(
            icon: Icons.search_off_rounded,
            title: l.storeNoResults,
            message: l.storeNoResultsBody,
            action: state.query.toParams().isEmpty
                ? null
                : OutlinedButton(
                    onPressed: () => cubit.setQuery(const ProductQuery()),
                    child: Text(l.storeClearFilters),
                  ),
          );
        }
        return RefreshIndicator(
          onRefresh: cubit.retry,
          child: CustomScrollView(
            controller: _scroll,
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                sliver: SliverToBoxAdapter(
                  child: Text(
                    l.storeResultCount(state.count),
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: context.brand.inkMuted,
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                sliver: SliverGrid.builder(
                  gridDelegate: kProductGrid,
                  itemCount: state.items.length,
                  itemBuilder: (_, i) => FadeSlideIn(
                    key: ValueKey(state.items[i].id),
                    delay: Duration(milliseconds: 30 * (i % 6)),
                    child: ProductTile(product: state.items[i]),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: Center(
                    child: state.loadMoreError
                        ? TextButton.icon(
                            onPressed: cubit.loadMore,
                            icon: const Icon(Icons.refresh_rounded),
                            label: Text(l.commonRetry),
                          )
                        : state.hasMore
                        ? const Padding(
                            padding: EdgeInsets.all(12),
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const SizedBox.shrink(),
                  ),
                ),
              ),
            ],
          ),
        );
    }
  }
}

class _FilterBar extends StatelessWidget {
  const _FilterBar({required this.state});
  final ProductListState state;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final cubit = context.read<ProductListCubit>();
    final q = state.query;
    final facetNames = {
      for (final f in state.facets.value ?? const <FilterFacet>[]) f.param: f,
    };
    String chipLabel(String param, String value) {
      final f = facetNames[param];
      final option = f?.options.where((o) => o.value == value).firstOrNull;
      return '${f?.name ?? param.replaceFirst('attr.', '')}: ${option?.label ?? value}';
    }

    return SizedBox(
      height: 52,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        children: [
          ActionChip(
            avatar: Badge(
              isLabelVisible: q.activeFilterCount > 0,
              label: Text('${q.activeFilterCount}'),
              child: const Icon(Icons.tune_rounded, size: 18),
            ),
            label: Text(l.storeFilters),
            onPressed: () => _openFilters(context, state),
          ),
          const SizedBox(width: 8),
          ActionChip(
            avatar: const Icon(Icons.swap_vert_rounded, size: 18),
            label: Text(_sortLabel(context, q.sort)),
            onPressed: () => _openSort(context, q),
          ),
          const SizedBox(width: 8),
          for (final kind in const ['physical', 'service', 'digital']) ...[
            FilterChip(
              selected: q.fulfilment == kind,
              label: Text(_fulfilmentLabel(context, kind)),
              onSelected: (on) =>
                  cubit.setQuery(q.copyWith(fulfilment: on ? kind : null)),
            ),
            const SizedBox(width: 8),
          ],
          if (q.category != null) ...[
            InputChip(
              label: Text(q.category!),
              onDeleted: () => cubit.setQuery(q.copyWith(category: null)),
            ),
            const SizedBox(width: 8),
          ],
          if (q.remedy != null) ...[
            InputChip(
              avatar: const Icon(Icons.auto_awesome_rounded, size: 16),
              label: Text(l.storeRemedyFor(q.remedy!)),
              onDeleted: () => cubit.setQuery(q.copyWith(remedy: null)),
            ),
            const SizedBox(width: 8),
          ],
          for (final e in q.attributes.entries) ...[
            InputChip(
              label: Text(chipLabel(e.key, e.value)),
              onDeleted: () => cubit.setQuery(
                q.copyWith(attributes: {...q.attributes}..remove(e.key)),
              ),
            ),
            const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }

  String _sortLabel(BuildContext context, String sort) {
    final l = context.l10n;
    return switch (sort) {
      'popular' => l.storeSortPopular,
      'new' => l.storeSortNew,
      'rating' => l.storeSortRating,
      _ => l.storeSortRecommended,
    };
  }

  Future<void> _openSort(BuildContext context, ProductQuery q) async {
    final cubit = context.read<ProductListCubit>();
    final picked = await showAppSheet<String>(
      context: context,
      title: context.l10n.storeSortBy,
      builder: (sheet) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final s in const ['', 'popular', 'new', 'rating'])
            ListTile(
              title: Text(_sortLabel(sheet, s)),
              trailing: q.sort == s
                  ? Icon(Icons.check_rounded, color: AstroPalette.health.end)
                  : null,
              onTap: () => Navigator.of(sheet).pop(s),
            ),
        ],
      ),
    );
    if (picked != null) await cubit.setQuery(q.copyWith(sort: picked));
  }

  Future<void> _openFilters(
    BuildContext context,
    ProductListState state,
  ) async {
    final cubit = context.read<ProductListCubit>();
    final facets = state.facets.value ?? const <FilterFacet>[];
    final picked = await showAppSheet<Map<String, String>>(
      context: context,
      title: context.l10n.storeFilters,
      builder: (_) =>
          _FilterSheet(facets: facets, selected: state.query.attributes),
    );
    if (picked != null) {
      await cubit.setQuery(state.query.copyWith(attributes: picked));
    }
  }
}

String _fulfilmentLabel(BuildContext context, String kind) {
  final l = context.l10n;
  return switch (kind) {
    'service' => l.storeKindPoojas,
    'digital' => l.storeKindDigital,
    _ => l.storeKindProducts,
  };
}

class _FilterSheet extends StatefulWidget {
  const _FilterSheet({required this.facets, required this.selected});
  final List<FilterFacet> facets;
  final Map<String, String> selected;

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  late final Map<String, String> _picked = {...widget.selected};

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final choice = widget.facets.where((f) => f.isChoice).toList();
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Flexible(
          child: choice.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(l.storeNoFilters, textAlign: TextAlign.center),
                )
              : ListView(
                  shrinkWrap: true,
                  children: [
                    for (final f in choice) ...[
                      Padding(
                        padding: const EdgeInsets.only(top: 12, bottom: 8),
                        child: Text(
                          f.unit.isEmpty ? f.name : '${f.name} (${f.unit})',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final o in f.options)
                            ChoiceChip(
                              label: Text(o.label),
                              selected: _picked[f.param] == o.value,
                              onSelected: (on) => setState(() {
                                if (on) {
                                  _picked[f.param] = o.value;
                                } else {
                                  _picked.remove(f.param);
                                }
                              }),
                            ),
                        ],
                      ),
                    ],
                  ],
                ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.of(context).pop(<String, String>{}),
                child: Text(l.storeClearFilters),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton(
                onPressed: () => Navigator.of(context).pop(_picked),
                child: Text(l.commonApply),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
