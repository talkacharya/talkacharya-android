// The astrologer profile's follow surfaces at a small phone size in English and
// Hindi: header Follow pill, followers stat, and the offline "Notify me when
// online" CTA (which follows). Any overflow or build exception fails the test.
import 'package:customr/src/core/config/config_repository.dart';
import 'package:customr/src/core/di/service_locator.dart';
import 'package:customr/src/core/l10n/l10n.dart';
import 'package:customr/src/core/theme/brand_colors.dart';
import 'package:customr/src/features/astrologers/data/astrologers_repository.dart';
import 'package:customr/src/features/astrologers/data/models/astrologer.dart';
import 'package:customr/src/features/astrologers/presentation/view/astrologer_detail_page.dart';
import 'package:customr/src/features/follows/data/follows_api.dart';
import 'package:customr/src/features/follows/data/follows_repository.dart';
import 'package:customr/src/features/follows/presentation/cubit/follow_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockConfig extends Mock implements ConfigRepository {}

class _MockAstroRepo extends Mock implements AstrologersRepository {}

class _MockFollowRepo extends Mock implements FollowsRepository {}

Astrologer _astro({required bool online}) => Astrologer(
  id: 'a1',
  name: 'Acharya Vishwanath Shastri',
  headline: 'Vedic astrology · Kundli · Marriage',
  isAvailable: online,
  ratingAvg: 4.8,
  ratingCount: 1250,
  yearsExperience: 12,
  consultationsCount: 4200,
  followersCount: 1500,
  repeatClientRate: 0.62,
  bio: 'Twelve years of practice.',
  rates: const [
    AstrologerRate(channel: 'chat', perMinuteAmount: '25'),
    AstrologerRate(channel: 'voice', perMinuteAmount: '30'),
  ],
);

void main() {
  late _MockAstroRepo astroRepo;
  late _MockFollowRepo followRepo;
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
    astroRepo = _MockAstroRepo();
    followRepo = _MockFollowRepo();
    follow = FollowCubit(followRepo);
    if (getIt.isRegistered<AstrologersRepository>()) {
      getIt.unregister<AstrologersRepository>();
    }
    if (getIt.isRegistered<FollowCubit>()) getIt.unregister<FollowCubit>();
    getIt
      ..registerSingleton<AstrologersRepository>(astroRepo)
      ..registerSingleton<FollowCubit>(follow);
    when(
      () => followRepo.setFollowing(
        any(),
        follow: any(named: 'follow'),
        source: any(named: 'source'),
      ),
    ).thenAnswer(
      (_) async => const FollowStatus(following: true, followersCount: 1501),
    );
  });

  Future<void> pump(WidgetTester tester, Locale locale) async {
    await tester.pumpWidget(
      BlocProvider<FollowCubit>.value(
        value: follow,
        child: MaterialApp(
          locale: locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: const Color(0xFFEA6A1E),
            extensions: const [BrandColors.light],
          ),
          home: const AstrologerDetailPage(astrologerId: 'a1'),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
  }

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

      testWidgets('header Follow pill follows and updates the count', (
        tester,
      ) async {
        when(
          () => astroRepo.detail('a1'),
        ).thenAnswer((_) async => _astro(online: true));
        await pump(tester, locale);
        expect(tester.takeException(), isNull);
        expect(find.text('1.5k'), findsOneWidget); // followers stat

        await tester.tap(find.byIcon(Icons.person_add_alt_1_rounded).first);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 600));
        verify(
          () => followRepo.setFollowing(
            'a1',
            follow: true,
            source: FollowSource.profile,
          ),
        ).called(1);
        expect(follow.state.of('a1')?.following, isTrue);
        expect(tester.takeException(), isNull);
      });

      testWidgets('offline "Notify me when online" follows', (tester) async {
        when(
          () => astroRepo.detail('a1'),
        ).thenAnswer((_) async => _astro(online: false));
        await pump(tester, locale);
        expect(tester.takeException(), isNull);

        await tester.tap(find.byIcon(Icons.notifications_none_rounded));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 600));
        verify(
          () => followRepo.setFollowing(
            'a1',
            follow: true,
            source: FollowSource.profile,
          ),
        ).called(1);
        expect(find.byIcon(Icons.notifications_active_rounded), findsWidgets);
        expect(tester.takeException(), isNull);
      });
    });
  }
}
