import 'package:bloc/bloc.dart';

import '../../../../core/util/async_value.dart';
import '../../data/articles_repository.dart';
import '../../data/models/article.dart';
import '../../../../core/network/friendly_error.dart';

/// One article. Renders instantly from the session cache when it was read
/// before, and refreshes behind it.
class ArticleCubit extends Cubit<AsyncValue<Article>> {
  ArticleCubit({required ArticlesRepository repo, required String slug})
    : _repo = repo,
      _slug = slug,
      super(_initial(repo.cached(slug)));

  final ArticlesRepository _repo;
  final String _slug;

  static AsyncValue<Article> _initial(Article? cached) =>
      cached == null ? const AsyncValue.idle() : AsyncValue.loading(cached);

  Future<void> load() async {
    emit(AsyncValue.loading(state.value));
    try {
      emit(AsyncValue.data(await _repo.detail(_slug)));
    } catch (e) {
      emit(AsyncValue.error(friendlyError(e), state.value));
    }
  }
}
