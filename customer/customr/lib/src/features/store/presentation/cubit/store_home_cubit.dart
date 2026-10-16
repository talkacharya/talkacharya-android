import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/network/friendly_error.dart';
import '../../../../core/util/async_value.dart';
import '../../data/models/catalog.dart';
import '../../data/models/consult.dart';
import '../../data/store_repository.dart';

/// Store landing: the catalog home, the customer's recent astrologer advice,
/// and the category picked in the side rail with its products. Slices load and
/// fail independently; a category's products are fetched once and kept while
/// the page is open, so switching back and forth in the rail is instant.
class StoreHomeCubit extends Cubit<StoreHomeState> {
  StoreHomeCubit(this._repo, {String? initialCategory})
    : super(StoreHomeState(selected: initialCategory));

  final StoreRepository _repo;

  /// How many products a category shows before "View all".
  static const pageSize = 20;

  Future<void> load({bool force = false}) async {
    await Future.wait([_loadHome(force), _loadConsults()]);
    final selected = state.selected;
    if (selected != null) await _loadCategory(selected, force: force);
  }

  /// Picks [slug] in the side rail; `null` is "Top picks".
  Future<void> select(String? slug) async {
    if (slug == state.selected) return;
    emit(state.copyWith(selected: slug, clearSelected: slug == null));
    if (slug != null) await _loadCategory(slug);
  }

  Future<void> retryCategory() async {
    final slug = state.selected;
    if (slug != null) await _loadCategory(slug, force: true);
  }

  Future<void> _loadCategory(String slug, {bool force = false}) async {
    final current = state.products[slug];
    if (!force && current != null && (current.hasValue || current.isLoading)) {
      return;
    }
    _setProducts(slug, AsyncValue.loading(current?.value));
    try {
      final page = await _repo.products(
        ProductQuery(category: slug),
        limit: pageSize,
      );
      _setProducts(slug, AsyncValue.data(page));
    } catch (e) {
      _setProducts(slug, AsyncValue.error(friendlyError(e), current?.value));
    }
  }

  void _setProducts(String slug, AsyncValue<ProductPage> value) {
    if (isClosed) return;
    emit(state.copyWith(products: {...state.products, slug: value}));
  }

  Future<void> _loadHome(bool force) async {
    emit(state.copyWith(home: AsyncValue.loading(state.home.value)));
    try {
      final home = await _repo.home(force: force);
      emit(state.copyWith(home: AsyncValue.data(home)));
    } catch (e) {
      emit(
        state.copyWith(
          home: AsyncValue.error(friendlyError(e), state.home.value),
        ),
      );
    }
  }

  Future<void> _loadConsults() async {
    try {
      final list = await _repo.consults();
      emit(state.copyWith(consults: AsyncValue.data(list)));
    } catch (_) {
      // advice is a bonus section — hide it on failure
      emit(state.copyWith(consults: const AsyncValue.data([])));
    }
  }
}

class StoreHomeState extends Equatable {
  const StoreHomeState({
    this.home = const AsyncValue.idle(),
    this.consults = const AsyncValue.idle(),
    this.selected,
    this.products = const {},
  });

  final AsyncValue<StoreHome> home;
  final AsyncValue<List<StoreConsult>> consults;

  /// The category open in the side rail; `null` is "Top picks".
  final String? selected;

  /// Products per category slug, as far as they have loaded.
  final Map<String, AsyncValue<ProductPage>> products;

  /// The most recent consult that has an answer (or is waiting on one).
  StoreConsult? get latestAdvice {
    final list = consults.value ?? const <StoreConsult>[];
    for (final c in list) {
      if (c.status == ConsultStatus.verdictGiven ||
          c.status == ConsultStatus.awaitingVerdict) {
        return c;
      }
    }
    return null;
  }

  StoreHomeState copyWith({
    AsyncValue<StoreHome>? home,
    AsyncValue<List<StoreConsult>>? consults,
    String? selected,
    bool clearSelected = false,
    Map<String, AsyncValue<ProductPage>>? products,
  }) => StoreHomeState(
    home: home ?? this.home,
    consults: consults ?? this.consults,
    selected: clearSelected ? null : (selected ?? this.selected),
    products: products ?? this.products,
  );

  @override
  List<Object?> get props => [home, consults, selected, products];
}
