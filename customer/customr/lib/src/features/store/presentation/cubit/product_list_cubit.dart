import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/network/friendly_error.dart';
import '../../../../core/util/async_value.dart';
import '../../data/models/catalog.dart';
import '../../data/models/product.dart';
import '../../data/store_repository.dart';

enum ListStatus { loading, refiltering, ready, error }

/// A filterable, offset-paged product grid. The seed query comes from the route
/// (deep links / category taps); every change re-queries from offset 0 and a
/// generation counter drops pages that land after a newer query started.
class ProductListCubit extends Cubit<ProductListState> {
  ProductListCubit(this._repo, {ProductQuery initial = const ProductQuery()})
    : super(ProductListState(query: initial));

  final StoreRepository _repo;
  static const pageSize = 20;
  int _generation = 0;
  bool _pageInFlight = false;

  Future<void> init() => Future.wait([_fetch(reset: true), _loadFacets()]);

  Future<void> setQuery(ProductQuery q) async {
    if (q == state.query) return;
    final typeChanged = q.type != state.query.type;
    emit(state.copyWith(query: q));
    await _fetch(reset: true);
    if (typeChanged) await _loadFacets();
  }

  Future<void> search(String text) =>
      setQuery(state.query.copyWith(search: text));

  Future<void> retry() => _fetch(reset: true);

  Future<void> loadMore() async {
    if (!state.hasMore || _pageInFlight || state.status != ListStatus.ready) {
      return;
    }
    await _fetch(reset: false);
  }

  Future<void> _fetch({required bool reset}) async {
    final gen = reset ? ++_generation : _generation;
    final offset = reset ? 0 : state.items.length;
    _pageInFlight = true;
    emit(
      state.copyWith(
        status: reset
            ? (state.items.isEmpty
                  ? ListStatus.loading
                  : ListStatus.refiltering)
            : state.status,
        loadMoreError: false,
      ),
    );
    try {
      final page = await _repo.products(
        state.query,
        offset: offset,
        limit: pageSize,
      );
      if (gen != _generation) return;
      final merged = reset ? page.items : [...state.items, ...page.items];
      final seen = <String>{};
      emit(
        state.copyWith(
          status: ListStatus.ready,
          items: [
            for (final p in merged)
              if (seen.add(p.id)) p,
          ],
          count: page.count,
          hasMore: page.hasMore,
        ),
      );
    } catch (e) {
      if (gen != _generation) return;
      emit(
        reset
            ? state.copyWith(status: ListStatus.error, error: friendlyError(e))
            : state.copyWith(loadMoreError: true),
      );
    } finally {
      if (gen == _generation) _pageInFlight = false;
    }
  }

  Future<void> _loadFacets() async {
    try {
      final facets = await _repo.filters(type: state.query.type);
      emit(state.copyWith(facets: AsyncValue.data(facets)));
    } catch (e) {
      emit(state.copyWith(facets: AsyncValue.error(friendlyError(e))));
    }
  }
}

class ProductListState extends Equatable {
  const ProductListState({
    required this.query,
    this.status = ListStatus.loading,
    this.items = const [],
    this.count = 0,
    this.hasMore = false,
    this.loadMoreError = false,
    this.error,
    this.facets = const AsyncValue.idle(),
  });

  final ProductQuery query;
  final ListStatus status;
  final List<ProductCard> items;
  final int count;
  final bool hasMore;
  final bool loadMoreError;
  final String? error;
  final AsyncValue<List<FilterFacet>> facets;

  ProductListState copyWith({
    ProductQuery? query,
    ListStatus? status,
    List<ProductCard>? items,
    int? count,
    bool? hasMore,
    bool? loadMoreError,
    String? error,
    AsyncValue<List<FilterFacet>>? facets,
  }) => ProductListState(
    query: query ?? this.query,
    status: status ?? this.status,
    items: items ?? this.items,
    count: count ?? this.count,
    hasMore: hasMore ?? this.hasMore,
    loadMoreError: loadMoreError ?? this.loadMoreError,
    error: error ?? this.error,
    facets: facets ?? this.facets,
  );

  @override
  List<Object?> get props => [
    query,
    status,
    items,
    count,
    hasMore,
    loadMoreError,
    error,
    facets,
  ];
}
