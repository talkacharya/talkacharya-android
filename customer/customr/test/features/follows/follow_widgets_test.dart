// Follow controls at a small phone size in English and Hindi: the discovery
// card heart + "Notify me", the post-session prompt, and the Following page.
// Taps must go through the repository and any overflow fails the test.
import 'package:customr/src/core/config/config_repository.dart';
import 'package:customr/src/core/di/service_locator.dart';
import 'package:customr/src/core/l10n/l10n.dart';
import 'package:customr/src/core/theme/brand_colors.dart';
import 'package:customr/src/features/astrologers/data/astrologers_api.dart';
import 'package:customr/src/features/astrologers/data/models/astrologer.dart';
import 'package:customr/src/features/astrologers/presentation/view/widgets/astrologer_list_tile.dart';
import 'package:customr/src/features/follows/data/follows_api.dart';
import 'package:customr/src/features/follows/data/follows_repository.dart';
import 'package:customr/src/features/follows/presentation/cubit/follow_cubit.dart';
import 'package:customr/src/features/follows/presentation/cubit/following_list_cubit.dart';
import 'package:customr/src/features/follows/presentation/view/following_page.dart';
import 'package:customr/src/features/follows/presentation/widgets/follow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockConfig extends Mock implements ConfigRepository {}

class _MockRepo extends Mock implements FollowsRepository {}

const _online = Astrologer(
  id: 'a1',
  name: 'Acharya Vishwanath Shastri',
  isAvailable: true,
  ratingAvg: 4.8,
  ratingCount: 1250,
  yearsExperience: 12,
  followersCount: 1200,
  languages: [
    AstrologerLanguage(code: 'hi'),
    AstrologerLanguage(code: 'en'),
    AstrologerLanguage(code: 'sa'),
  ],
  rates: [AstrologerRate(channel: 'chat', perMinuteAmount: '25')],
);

const _offline = Astrologer(
  id: 'a2',
  name: 'Pandit Raghunandan Mishra',
  ratingAvg: 4.6,
  ratingCount: 88,
  rates: [AstrologerRate(channel: 'chat', perMinuteAmount: '120')],
);

void main() {
  late _MockRepo repo;
  late FollowCubit follow;

  setUpAll(() {
    final config = _MockConfig();
    when(() => config.hapticEnabled).thenReturn(false);
    if (!getIt.isRegistered<ConfigRepository>()) {
      getIt.registerSingleton<ConfigRepository>(config);
    }
    registerFallbackValue(FollowSource.profile);
  });

  setUp(() {
    repo = _MockRepo();
    follow = FollowCubit(repo);
    when(
      () => repo.setFollowing(
        any(),
        follow: any(named: 'follow'),
        source: any(named: 'source'),
      ),
    ).thenAnswer(
      (inv) async => FollowStatus(
        following: inv.namedArguments[#follow] as bool,
        followersCount: 1,
      ),
    );
  });

  Widget app(
    Widget home,
    Locale locale, {
    List<BlocProvider> extra = const [],
  }) => MultiBlocProvider(
    providers: [
      BlocProvider<FollowCubit>.value(value: follow),
      ...extra,
    ],
    child: MaterialApp(
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFFEA6A1E),
        extensions: const [BrandColors.light],
      ),
      home: home,
    ),
  );

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

      testWidgets('list cards: heart follows, offline "Notify me" follows', (
        tester,
      ) async {
        await tester.pumpWidget(
          app(
            Scaffold(
              body: ListView(
                padding: const EdgeInsets.all(16),
                children: const [
                  AstrologerListTile(astrologer: _online),
                  SizedBox(height: 10),
                  AstrologerListTile(astrologer: _offline),
                ],
              ),
            ),
            locale,
          ),
        );
        expect(tester.takeException(), isNull);

        await tester.tap(find.byIcon(Icons.favorite_border_rounded).first);
        await tester.pumpAndSettle();
        verify(
          () =>
              repo.setFollowing('a1', follow: true, source: FollowSource.card),
        ).called(1);
        expect(follow.state.of('a1')?.following, isTrue);
        expect(find.byIcon(Icons.favorite_rounded), findsOneWidget);

        await tester.tap(find.byIcon(Icons.notifications_none_rounded));
        await tester.pumpAndSettle();
        verify(
          () =>
              repo.setFollowing('a2', follow: true, source: FollowSource.card),
        ).called(1);
        expect(find.byIcon(Icons.notifications_active_rounded), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('post-session prompt: follow → thank-you face', (
        tester,
      ) async {
        when(() => repo.status('a2')).thenAnswer(
          (_) async => const FollowStatus(following: false, followersCount: 3),
        );
        await tester.pumpWidget(
          app(
            const Scaffold(
              body: Padding(
                padding: EdgeInsets.all(16),
                child: FollowPromptCard(
                  astrologerId: 'a2',
                  astrologerName: 'Pandit Raghunandan Mishra',
                ),
              ),
            ),
            locale,
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);

        await tester.tap(find.byType(FilledButton));
        await tester.pumpAndSettle();
        verify(
          () => repo.setFollowing(
            'a2',
            follow: true,
            source: FollowSource.postSession,
          ),
        ).called(1);
        expect(find.byType(FilledButton), findsNothing);
        expect(find.byIcon(Icons.notifications_active_rounded), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('post-session prompt hides for an existing follower', (
        tester,
      ) async {
        when(() => repo.status('a1')).thenAnswer(
          (_) async => const FollowStatus(following: true, followersCount: 3),
        );
        await tester.pumpWidget(
          app(
            const Scaffold(
              body: FollowPromptCard(astrologerId: 'a1', astrologerName: 'A'),
            ),
            locale,
          ),
        );
        await tester.pumpAndSettle();
        expect(find.byType(FilledButton), findsNothing);
      });

      testWidgets('Following page: list, and empty state', (tester) async {
        when(() => repo.following(cursor: any(named: 'cursor'))).thenAnswer(
          (_) async => const AstrologerPage(
            items: [
              Astrologer(
                id: 'a1',
                name: 'Acharya Vishwanath Shastri',
                isFollowing: true,
                isAvailable: true,
              ),
              Astrologer(id: 'a2', name: 'Pandit Mishra', isFollowing: true),
            ],
          ),
        );
        await tester.pumpWidget(
          app(
            const FollowingPage(),
            locale,
            extra: [
              BlocProvider<FollowingListCubit>(
                create: (_) => FollowingListCubit(repo, follow)..load(),
              ),
            ],
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        expect(find.byType(AstrologerListTile), findsNWidgets(2));
        expect(follow.state.of('a2')?.following, isTrue); // seeded

        when(
          () => repo.following(cursor: any(named: 'cursor')),
        ).thenAnswer((_) async => const AstrologerPage(items: []));
        await tester.pumpWidget(const SizedBox()); // drop the old providers
        await tester.pumpWidget(
          app(
            const FollowingPage(),
            locale,
            extra: [
              BlocProvider<FollowingListCubit>(
                create: (_) => FollowingListCubit(repo, follow)..load(),
              ),
            ],
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        expect(find.byType(FilledButton), findsOneWidget); // "Find astrologers"
      });
    });
  }
}
