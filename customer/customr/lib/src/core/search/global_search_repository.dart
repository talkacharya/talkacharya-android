import 'dart:async';

import 'package:flutter/material.dart';

import '../../features/articles/data/articles_repository.dart';
import '../../features/articles/data/models/article.dart';
import '../../features/astrologers/data/astrologers_api.dart';
import '../../features/astrologers/data/astrologers_repository.dart';
import '../../features/astrologers/data/models/astrologer.dart';
import '../../features/birthprofiles/data/birth_profiles_repository.dart';
import '../../features/birthprofiles/data/models/birth_profile.dart';
import 'app_feature_registry.dart';

class GlobalSearchResult {
  const GlobalSearchResult({
    this.features = const [],
    this.astrologers = const [],
    this.profiles = const [],
    this.articles = const [],
  });

  final List<AppFeatureItem> features;
  final List<Astrologer> astrologers;
  final List<BirthProfile> profiles;
  final List<ArticleSummary> articles;

  bool get isEmpty =>
      features.isEmpty &&
      astrologers.isEmpty &&
      profiles.isEmpty &&
      articles.isEmpty;

  bool get isNotEmpty => !isEmpty;
}

class GlobalSearchRepository {
  GlobalSearchRepository({
    required AstrologersRepository astrologersRepo,
    required BirthProfilesRepository profilesRepo,
    required ArticlesRepository articlesRepo,
  })  : _astrologersRepo = astrologersRepo,
        _profilesRepo = profilesRepo,
        _articlesRepo = articlesRepo;

  final AstrologersRepository _astrologersRepo;
  final BirthProfilesRepository _profilesRepo;
  final ArticlesRepository _articlesRepo;

  /// Fast local search across all registered app features, astrologers, and profiles.
  GlobalSearchResult searchLocal(BuildContext context, String term) {
    final q = term.trim();
    if (q.isEmpty) return const GlobalSearchResult();

    // 1. Search Features
    final features = AppFeatureRegistry.getFeatures(context)
        .where((f) => f.matches(q))
        .toList();

    // 2. Search Astrologers from local store
    final query = AstrologerQuery(search: q);
    final astrologers = _astrologersRepo.searchLocal(query).take(5).toList();

    // 3. Search Birth Profiles from local store
    final profiles = _profilesRepo.localStore.profiles.where((p) {
      final nameMatch = p.displayName.toLowerCase().contains(q.toLowerCase());
      final placeMatch = p.birthPlaceName.toLowerCase().contains(q.toLowerCase());
      final relMatch = p.relation.toLowerCase().contains(q.toLowerCase());
      return nameMatch || placeMatch || relMatch;
    }).take(4).toList();

    return GlobalSearchResult(
      features: features,
      astrologers: astrologers,
      profiles: profiles,
    );
  }

  /// Full async search incorporating server results for astrologers & articles.
  Future<GlobalSearchResult> searchServer(BuildContext context, String term) async {
    final localResult = searchLocal(context, term);
    final q = term.trim();
    if (q.isEmpty) return const GlobalSearchResult();

    List<Astrologer> serverAstrologers = localResult.astrologers;
    List<ArticleSummary> serverArticles = const [];

    try {
      final astroPage = await _astrologersRepo.list(query: AstrologerQuery(search: q));
      serverAstrologers = [
        ...localResult.astrologers,
        ...astroPage.items.where((a) => !localResult.astrologers.any((l) => l.id == a.id)),
      ].take(6).toList();
    } catch (_) {}

    try {
      final allArticles = await _articlesRepo.latest();
      serverArticles = allArticles.where((a) {
        final titleMatch = a.title.toLowerCase().contains(q.toLowerCase());
        final subMatch = a.category.name.toLowerCase().contains(q.toLowerCase());
        return titleMatch || subMatch;
      }).take(4).toList();
    } catch (_) {}

    return GlobalSearchResult(
      features: localResult.features,
      astrologers: serverAstrologers,
      profiles: localResult.profiles,
      articles: serverArticles,
    );
  }
}
