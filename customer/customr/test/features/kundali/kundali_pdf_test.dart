// Kundali PDF: the API asks for the right report and maps 503, and the sheet
// lays out at a small phone size in en/hi and passes the choices through.
import 'package:customr/src/core/config/config_repository.dart';
import 'package:customr/src/core/di/service_locator.dart';
import 'package:customr/src/core/l10n/l10n.dart';
import 'package:customr/src/core/theme/brand_colors.dart';
import 'package:customr/src/features/kundali/data/kundali_api.dart';
import 'package:customr/src/features/kundali/data/kundali_repository.dart';
import 'package:customr/src/features/kundali/presentation/widgets/kundali_pdf_sheet.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockConfig extends Mock implements ConfigRepository {}

class _MockRepo extends Mock implements KundaliRepository {}

/// Dio adapter that records the request and answers with a fixed status.
class _Adapter implements HttpClientAdapter {
  _Adapter(this.status);
  final int status;
  RequestOptions? last;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    last = options;
    return ResponseBody.fromBytes(
      status == 200
          ? '%PDF-1.4'.codeUnits
          : '{"code":"astrology.pdf_unavailable"}'.codeUnits,
      status,
      headers: {
        Headers.contentTypeHeader: [
          status == 200 ? 'application/pdf' : 'application/json',
        ],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  late _MockRepo repo;

  setUpAll(() {
    final config = _MockConfig();
    when(() => config.hapticEnabled).thenReturn(false);
    getIt.registerSingleton<ConfigRepository>(config);
  });

  setUp(() {
    repo = _MockRepo();
    if (getIt.isRegistered<KundaliRepository>()) {
      getIt.unregister<KundaliRepository>();
    }
    getIt.registerSingleton<KundaliRepository>(repo);
  });

  group('KundaliApi.pdf', () {
    test('requests the chosen report + style as bytes', () async {
      final adapter = _Adapter(200);
      final dio = Dio()..httpClientAdapter = adapter;
      final bytes = await KundaliApi(
        dio,
      ).pdf('p1', style: 'south', full: false);
      expect(String.fromCharCodes(bytes), startsWith('%PDF'));
      expect(adapter.last!.path, '/app/birth-profiles/p1/kundli.pdf');
      expect(adapter.last!.queryParameters, {
        'style': 'south',
        'report': 'basic',
      });
    });

    test('503 becomes KundaliPdfUnavailable', () async {
      final dio = Dio()..httpClientAdapter = _Adapter(503);
      expect(
        () => KundaliApi(dio).pdf('p1'),
        throwsA(isA<KundaliPdfUnavailable>()),
      );
    });
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

      testWidgets('sheet lays out and reports a server-side failure', (
        tester,
      ) async {
        when(
          () => repo.pdf(
            any(),
            style: any(named: 'style'),
            full: any(named: 'full'),
          ),
        ).thenThrow(const KundaliPdfUnavailable());
        await tester.pumpWidget(
          MaterialApp(
            locale: locale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            theme: ThemeData(
              useMaterial3: true,
              colorSchemeSeed: const Color(0xFFEA6A1E),
              extensions: const [BrandColors.light],
            ),
            home: Scaffold(
              body: Builder(
                builder: (context) => TextButton(
                  onPressed: () => showKundaliPdfSheet(
                    context,
                    profileId: 'p1',
                    name: 'Acharya Vishwanath Shastri',
                  ),
                  child: const Text('open'),
                ),
              ),
            ),
          ),
        );
        await tester.tap(find.text('open'));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);

        await tester.tap(find.byIcon(Icons.description_rounded));
        await tester.tap(find.byType(ChoiceChip).at(1));
        await tester.pumpAndSettle();
        await tester.tap(find.byIcon(Icons.ios_share_rounded));
        await tester.pumpAndSettle();

        verify(() => repo.pdf('p1', style: 'south', full: false)).called(1);
        final l = await AppLocalizations.delegate.load(locale);
        expect(find.text(l.kPdfUnavailable), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    });
  }
}
