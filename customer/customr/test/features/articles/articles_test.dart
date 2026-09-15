// Articles: models, the list cubit (filters, paging, stale responses), the
// markdown renderer, and the list + reader at a small phone size in en/hi.
import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:customr/src/core/config/config_repository.dart';
import 'package:customr/src/core/util/async_value.dart';
import 'package:customr/src/core/di/service_locator.dart';
import 'package:customr/src/core/l10n/l10n.dart';
import 'package:customr/src/core/theme/brand_colors.dart';
import 'package:customr/src/features/articles/data/articles_api.dart';
import 'package:customr/src/features/articles/data/articles_repository.dart';
import 'package:customr/src/features/articles/data/models/article.dart';
import 'package:customr/src/features/articles/presentation/cubit/article_cubit.dart';
import 'package:customr/src/features/articles/presentation/cubit/articles_cubit.dart';
import 'package:customr/src/features/articles/presentation/view/article_page.dart';
import 'package:customr/src/features/articles/presentation/view/articles_page.dart';
import 'package:customr/src/features/articles/presentation/widgets/markdown_view.dart';
import 'package:customr/src/features/home/presentation/cubit/home_cubit.dart';
import 'package:customr/src/features/home/presentation/view/widgets/articles_rail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepo extends Mock implements ArticlesRepository {}

class _MockConfig extends Mock implements ConfigRepository {}

class _MockHome extends MockCubit<HomeState> implements HomeCubit {}

ArticleSummary _summary(String slug, {ArticleCategory? category}) =>
    ArticleSummary(
      slug: slug,
      title: 'Mercury retrograde: what it really means for your week ahead',
      category: category ?? ArticleCategory.astrology,
      readingMinutes: 4,
      publishedAt: DateTime(2026, 9, 10),
      authorName: 'Editorial team',
      excerpt: 'Retrogrades get a bad name. Here is a calmer way to read them.',
    );

const _body = '''
# Understanding retrogrades

A **retrograde** is an *apparent* backward motion. Read our [guide](talkacharya://articles/basics) or visit [the site](https://example.com).

## What to do

- Slow down on contracts
- Re-check travel plans
  with a second line

1. Reflect
2. Revise

> Patience is its own remedy.

| Planet | Days |
|---|---|
| Mercury | 21 |

---

Use `code` sparingly.
''';

void main() {
  late _MockRepo repo;

  setUpAll(() {
    final config = _MockConfig();
    when(() => config.hapticEnabled).thenReturn(false);
    getIt.registerSingleton<ConfigRepository>(config);
  });

  setUp(() => repo = _MockRepo());

  group('models', () {
    test('Article.fromJson parses summary, body and related', () {
      final a = Article.fromJson({
        'id': 'x',
        'slug': 'diwali',
        'title': 'Diwali puja timings',
        'category': 'festivals',
        'hero_image': 'https://cdn/x.jpg',
        'published_at': '2026-10-20T04:00:00Z',
        'reading_minutes': 6,
        'author_name': 'Pt. Sharma',
        'body': '# Hi',
        'related': [
          {'slug': 'holi', 'title': 'Holi', 'category': 'unknown'},
        ],
      });
      expect(a.summary.category, ArticleCategory.festivals);
      expect(a.summary.hasImage, isTrue);
      expect(a.summary.readingMinutes, 6);
      expect(a.related.single.category, ArticleCategory.guides);
    });
  });

  group('ArticlesCubit', () {
    test('load, then page on', () async {
      when(() => repo.list()).thenAnswer(
        (_) async => ArticlesResult(items: [_summary('a')], nextCursor: 'c2'),
      );
      when(
        () => repo.list(cursor: 'c2'),
      ).thenAnswer((_) async => ArticlesResult(items: [_summary('b')]));
      final cubit = ArticlesCubit(repo);
      await cubit.load();
      expect(cubit.state.items.map((e) => e.slug), ['a']);
      expect(cubit.state.hasMore, isTrue);
      await cubit.loadMore();
      expect(cubit.state.items.map((e) => e.slug), ['a', 'b']);
      expect(cubit.state.hasMore, isFalse);
    });

    test('a slow response for an old category is dropped', () async {
      final slow = Completer<ArticlesResult>();
      when(() => repo.list()).thenAnswer((_) => slow.future);
      when(() => repo.list(category: ArticleCategory.remedies)).thenAnswer(
        (_) async => ArticlesResult(
          items: [_summary('r', category: ArticleCategory.remedies)],
        ),
      );
      final cubit = ArticlesCubit(repo);
      final first = cubit.load();
      await cubit.setCategory(ArticleCategory.remedies);
      slow.complete(ArticlesResult(items: [_summary('stale')]));
      await first;
      expect(cubit.state.category, ArticleCategory.remedies);
      expect(cubit.state.items.map((e) => e.slug), ['r']);
    });

    test('failure keeps the error for the view', () async {
      when(() => repo.list()).thenThrow(Exception('offline'));
      final cubit = ArticlesCubit(repo);
      await cubit.load();
      expect(cubit.state.status, ArticlesStatus.failed);
      expect(cubit.state.items, isEmpty);
    });
  });

  test('ArticleCubit starts from the session cache', () async {
    final cached = Article(summary: _summary('a'), body: 'old');
    when(() => repo.cached('a')).thenReturn(cached);
    when(
      () => repo.detail('a'),
    ).thenAnswer((_) async => Article(summary: _summary('a'), body: 'new'));
    final cubit = ArticleCubit(repo: repo, slug: 'a');
    expect(cubit.state.value?.body, 'old');
    await cubit.load();
    expect(cubit.state.value?.body, 'new');
  });

  // --- rendering ------------------------------------------------------------

  Widget app(Widget child, {Locale locale = const Locale('en')}) => MaterialApp(
    locale: locale,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    theme: ThemeData(
      useMaterial3: true,
      colorSchemeSeed: const Color(0xFFEA6A1E),
      extensions: const [BrandColors.light],
    ),
    home: child,
  );

  testWidgets('MarkdownView renders every block type', (tester) async {
    await tester.pumpWidget(
      app(
        const Scaffold(
          body: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: MarkdownView(data: _body),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.text('Understanding retrogrades'), findsOneWidget);
    expect(find.text('What to do'), findsOneWidget);
    expect(find.textContaining('Slow down on contracts'), findsOneWidget);
    expect(find.text('1.'), findsOneWidget);
    expect(find.textContaining('Patience is its own remedy.'), findsOneWidget);
    expect(find.byType(Table), findsOneWidget);
    expect(find.byType(Divider), findsOneWidget);
    expect(find.textContaining('guide', findRichText: true), findsWidgets);
  });

  for (final locale in const [Locale('en'), Locale('hi')]) {
    group('small phone · ${locale.languageCode}', () {
      setUp(() {
        TestWidgetsFlutterBinding.ensureInitialized()
            .platformDispatcher
            .views
            .first
          ..physicalSize = const Size(360, 740) * 3
          ..devicePixelRatio = 3;
      });
      tearDown(() {
        TestWidgetsFlutterBinding.instance.platformDispatcher.views.first
          ..resetPhysicalSize()
          ..resetDevicePixelRatio();
      });

      testWidgets('list lays out (featured + rows + category bar)', (
        tester,
      ) async {
        when(() => repo.list()).thenAnswer(
          (_) async => ArticlesResult(
            items: [
              _summary('a'),
              _summary('b', category: ArticleCategory.festivals),
              _summary('c', category: ArticleCategory.remedies),
            ],
          ),
        );
        await tester.pumpWidget(
          app(
            BlocProvider(
              create: (_) => ArticlesCubit(repo)..load(),
              child: const ArticlesPage(),
            ),
            locale: locale,
          ),
        );
        await tester.pumpAndSettle(const Duration(seconds: 1));
        expect(tester.takeException(), isNull);
        expect(find.byType(ArticleRowTile), findsNWidgets(2));
      });

      testWidgets('home rail lays out (loading → cards)', (tester) async {
        final home = _MockHome();
        whenListen(
          home,
          Stream.value(
            HomeState(
              articles: AsyncValue.data([
                _summary('a'),
                _summary('b', category: ArticleCategory.festivals),
              ]),
            ),
          ),
          initialState: const HomeState(articles: AsyncValue.loading()),
        );
        await tester.pumpWidget(
          app(
            BlocProvider<HomeCubit>.value(
              value: home,
              child: const Scaffold(
                body: SingleChildScrollView(child: ArticlesRail()),
              ),
            ),
            locale: locale,
          ),
        );
        await tester.pumpAndSettle(const Duration(seconds: 1));
        expect(tester.takeException(), isNull);
        expect(find.textContaining('Mercury retrograde'), findsWidgets);
      });

      testWidgets('reader lays out with body, CTA and related', (tester) async {
        when(() => repo.cached('a')).thenReturn(null);
        when(() => repo.detail('a')).thenAnswer(
          (_) async => Article(
            summary: _summary('a'),
            body: _body,
            related: [
              _summary('b', category: ArticleCategory.guides),
              _summary('c', category: ArticleCategory.news),
            ],
          ),
        );
        await tester.pumpWidget(
          app(
            BlocProvider(
              create: (_) => ArticleCubit(repo: repo, slug: 'a')..load(),
              child: ArticlePage(preview: _summary('a')),
            ),
            locale: locale,
          ),
        );
        await tester.pumpAndSettle(const Duration(seconds: 1));
        expect(tester.takeException(), isNull);
        await tester.drag(
          find.byType(CustomScrollView),
          const Offset(0, -4000),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        expect(find.byType(ArticleRowTile), findsNWidgets(2));
      });
    });
  }
}
