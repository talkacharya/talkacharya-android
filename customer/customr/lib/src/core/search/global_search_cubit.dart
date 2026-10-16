import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../features/astrologers/data/astrologers_repository.dart';
import 'global_search_repository.dart';

class GlobalSearchState extends Equatable {
  const GlobalSearchState({
    this.query = '',
    this.result = const GlobalSearchResult(),
    this.loading = false,
  });

  final String query;
  final GlobalSearchResult result;
  final bool loading;

  GlobalSearchState copyWith({
    String? query,
    GlobalSearchResult? result,
    bool? loading,
  }) {
    return GlobalSearchState(
      query: query ?? this.query,
      result: result ?? this.result,
      loading: loading ?? this.loading,
    );
  }

  @override
  List<Object?> get props => [query, result, loading];
}

class GlobalSearchCubit extends Cubit<GlobalSearchState> {
  GlobalSearchCubit({
    required GlobalSearchRepository searchRepo,
    required AstrologersRepository astrologersRepo,
  })  : _searchRepo = searchRepo,
        _astrologersRepo = astrologersRepo,
        super(const GlobalSearchState());

  final GlobalSearchRepository _searchRepo;
  final AstrologersRepository _astrologersRepo;

  Timer? _debounce;

  List<String> get recentSearches => _astrologersRepo.recentSearches;

  void search(BuildContext context, String term) {
    _debounce?.cancel();
    final q = term.trim();
    if (q.isEmpty) {
      if (isClosed) return;
      emit(const GlobalSearchState());
      return;
    }

    // Instant 0ms local search
    final localResult = _searchRepo.searchLocal(context, q);
    if (isClosed) return;
    emit(state.copyWith(query: q, result: localResult, loading: true));

    _debounce = Timer(const Duration(milliseconds: 250), () async {
      try {
        final serverResult = await _searchRepo.searchServer(context, q);
        if (isClosed || state.query != q) return;
        emit(state.copyWith(result: serverResult, loading: false));
      } catch (_) {
        if (isClosed || state.query != q) return;
        emit(state.copyWith(loading: false));
      }
    });
  }

  void saveSearchTerm(String term) {
    if (term.trim().isNotEmpty) {
      unawaited(_astrologersRepo.saveRecentSearch(term.trim()));
    }
  }

  void removeRecentSearch(String term) {
    unawaited(_astrologersRepo.removeRecentSearch(term));
    emit(state.copyWith());
  }

  void clearRecentSearches() {
    unawaited(_astrologersRepo.clearRecentSearches());
    emit(state.copyWith());
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
