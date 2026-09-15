import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/articles_repository.dart';
import '../../data/models/article.dart';

enum ArticlesStatus { loading, ready, failed }

/// The "Read & learn" list: a category filter + cursor-paged results.
class ArticlesCubit extends Cubit<ArticlesState> {
  ArticlesCubit(this._repo, {ArticleCategory? initialCategory})
    : super(ArticlesState(category: initialCategory));

  final ArticlesRepository _repo;

  /// Bumped per [load]; a slow page for an old filter is dropped on arrival.
  int _generation = 0;

  Future<void> load() => _fetch(state.category);

  Future<void> setCategory(ArticleCategory? category) {
    if (category == state.category && state.status != ArticlesStatus.failed) {
      return Future.value();
    }
    return _fetch(category);
  }

  Future<void> _fetch(ArticleCategory? category) async {
    final gen = ++_generation;
    emit(
      ArticlesState(
        category: category,
        status: ArticlesStatus.loading,
        // keep the current list visible while a refresh of the same filter runs
        items: category == state.category ? state.items : const [],
      ),
    );
    try {
      final page = await _repo.list(category: category);
      if (gen != _generation) return;
      emit(
        ArticlesState(
          category: category,
          status: ArticlesStatus.ready,
          items: page.items,
          nextCursor: page.nextCursor,
        ),
      );
    } catch (e) {
      if (gen != _generation) return;
      emit(state.copyWith(status: ArticlesStatus.failed, error: e));
    }
  }

  Future<void> loadMore() async {
    final cursor = state.nextCursor;
    if (cursor == null || state.loadingMore) return;
    final gen = _generation;
    emit(state.copyWith(loadingMore: true));
    try {
      final page = await _repo.list(category: state.category, cursor: cursor);
      if (gen != _generation) return;
      emit(
        ArticlesState(
          category: state.category,
          status: ArticlesStatus.ready,
          items: [...state.items, ...page.items],
          nextCursor: page.nextCursor,
        ),
      );
    } catch (_) {
      if (gen != _generation) return;
      // Keep what we have; the next scroll to the end retries.
      emit(state.copyWith(loadingMore: false));
    }
  }
}

class ArticlesState extends Equatable {
  const ArticlesState({
    this.category,
    this.status = ArticlesStatus.loading,
    this.items = const [],
    this.nextCursor,
    this.loadingMore = false,
    this.error,
  });

  /// `null` = all categories.
  final ArticleCategory? category;
  final ArticlesStatus status;
  final List<ArticleSummary> items;
  final String? nextCursor;
  final bool loadingMore;
  final Object? error;

  bool get hasMore => nextCursor != null;

  ArticlesState copyWith({
    ArticlesStatus? status,
    bool? loadingMore,
    Object? error,
  }) => ArticlesState(
    category: category,
    status: status ?? this.status,
    items: items,
    nextCursor: nextCursor,
    loadingMore: loadingMore ?? this.loadingMore,
    error: error ?? this.error,
  );

  @override
  List<Object?> get props => [
    category,
    status,
    items,
    nextCursor,
    loadingMore,
    error,
  ];
}
