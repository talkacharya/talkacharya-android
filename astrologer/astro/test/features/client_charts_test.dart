import 'package:astro/src/core/constants/api_paths.dart';
import 'package:astro/src/core/l10n/l10n.dart';
import 'package:astro/src/features/client_charts/data/client_charts_api.dart';
import 'package:astro/src/features/client_charts/presentation/view/client_charts_pages.dart';
import 'package:astro/src/features/consultations/data/models/consultation_share.dart';
import 'package:astro/src/features/kundali/data/kundali_api.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:talkacharya_ui/talkacharya_ui.dart';

class _MockApi extends Mock implements ClientChartsApi {}

class _MockDio extends Mock implements Dio {}

Widget _app(Widget home) => MaterialApp(
  theme: ThemeData(extensions: const [BrandColors.light]),
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: home,
);

ClientChart _chart(String id, String name) => ClientChart.fromJson({
  'id': id,
  'label': name,
  'full_name': name,
  'gender': 'male',
  'birth_date': '1990-05-14',
  'birth_time': '06:30:00',
  'birth_place_name': 'Varanasi, Uttar Pradesh',
  'signs': {'moon_sign': 'Taurus'},
});

void main() {
  group('KundaliApi', () {
    late _MockDio dio;

    setUp(() {
      dio = _MockDio();
      when(
        () => dio.get<Map<String, dynamic>>(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer(
        (i) async => Response<Map<String, dynamic>>(
          requestOptions: RequestOptions(
            path: i.positionalArguments.first as String,
          ),
          data: const {},
          statusCode: 200,
        ),
      );
    });

    String calledPath() =>
        verify(
              () => dio.get<Map<String, dynamic>>(
                captureAny(),
                queryParameters: any(named: 'queryParameters'),
              ),
            ).captured.single
            as String;

    test('a consultation reads through the consultation', () async {
      await KundaliApi(dio).dasha('c1');
      expect(calledPath(), ApiPaths.astroConsultationKundali('c1', 'dasha'));
    });

    test('a saved chart reads the astrologer\'s own birth profile', () async {
      await KundaliApi(dio).forOwnCharts().dasha('p1');
      expect(calledPath(), '/app/birth-profiles/p1/dasha');
    });

    test('chart types for a saved chart come from the shared list', () async {
      await KundaliApi(dio).forOwnCharts().chartTypes('p1');
      expect(calledPath(), ApiPaths.chartTypes);
    });
  });

  test('a chart falls back to its label and reads the Moon sign', () {
    final c = ClientChart.fromJson({
      'id': 'p1',
      'label': 'Ravi',
      'full_name': '',
      'birth_date': '1990-05-14',
      'signs': {'moon_sign': 'Taurus'},
    });
    expect(c.name, 'Ravi');
    expect(c.moonSign, 'Taurus');
    expect(c.birthTime, isNull);
  });

  group('screens', () {
    late _MockApi api;

    setUp(() {
      api = _MockApi();
      GetIt.I.registerSingleton<ClientChartsApi>(api);
    });

    tearDown(GetIt.I.reset);

    testWidgets('saved charts show birth details and the Moon sign', (
      tester,
    ) async {
      when(() => api.list()).thenAnswer((_) async => [_chart('p1', 'Ravi')]);
      await tester.pumpWidget(_app(const ClientChartsPage()));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('Ravi'), findsOneWidget);
      expect(find.textContaining('06:30'), findsOneWidget);
      expect(find.textContaining('Varanasi'), findsOneWidget);
      expect(find.text('Moon in Taurus'), findsOneWidget);
      expect(find.text('New chart'), findsOneWidget);
    });

    testWidgets('matchmaking asks for two charts before anything else', (
      tester,
    ) async {
      when(() => api.list()).thenAnswer((_) async => [_chart('p1', 'Ravi')]);
      when(() => api.matches()).thenAnswer((_) async => []);
      await tester.pumpWidget(_app(const MatchmakingPage()));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('Add two charts first'), findsOneWidget);
      expect(find.text('Match kundlis'), findsNothing);
    });

    testWidgets('with two charts the match can be set up; history is listed', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 3000);
      tester.view.devicePixelRatio = 2;
      addTearDown(tester.view.reset);
      when(
        () => api.list(),
      ).thenAnswer((_) async => [_chart('p1', 'Ravi'), _chart('p2', 'Meera')]);
      when(() => api.matches()).thenAnswer(
        (_) async => [
          MatchRow(
            summary: SharedMatch.fromJson({
              'id': 'm1',
              'total_points': '28.5',
              'max_points': '36',
              'verdict': 'Good',
              'boy': {'id': 'p1', 'name': 'Ravi'},
              'girl': {'id': 'p2', 'name': 'Meera'},
            })!,
            createdAt: DateTime.now(),
          ),
        ],
      );
      await tester.pumpWidget(_app(const MatchmakingPage()));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('Boy'), findsOneWidget);
      expect(find.text('Girl'), findsOneWidget);
      expect(find.text('Match kundlis'), findsOneWidget);
      expect(find.text('Ravi · Meera'), findsOneWidget);
      expect(find.text('28.5 / 36'), findsOneWidget);
    });
  });
}
