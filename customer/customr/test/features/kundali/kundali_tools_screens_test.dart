// The kundali tool screens (insights, mood, remedies, upaya, lal kitab,
// numerology, varshphal, muhurta, advanced + reports, birth details) at a
// small phone size in English and Hindi: no overflow / build exception.
import 'package:customr/src/core/di/service_locator.dart';
import 'package:customr/src/core/util/async_value.dart';
import 'package:customr/src/features/kundali/data/kundali_repository.dart';
import 'package:customr/src/features/kundali/data/models/daily_mood.dart';
import 'package:customr/src/features/kundali/presentation/cubit/kundali_cubit.dart';
import 'package:customr/src/features/kundali/presentation/view/advanced_page.dart';
import 'package:customr/src/features/kundali/presentation/view/advanced_report_page.dart';
import 'package:customr/src/features/kundali/presentation/view/insights_page.dart';
import 'package:customr/src/features/kundali/presentation/view/jyotish_upaya_page.dart';
import 'package:customr/src/features/kundali/presentation/view/lal_kitab_page.dart';
import 'package:customr/src/features/kundali/presentation/view/mood_page.dart';
import 'package:customr/src/features/kundali/presentation/view/muhurta_page.dart';
import 'package:customr/src/features/kundali/presentation/view/numerology_page.dart';
import 'package:customr/src/features/kundali/presentation/view/remedies_page.dart';
import 'package:customr/src/features/kundali/presentation/view/varshphal_page.dart';
import 'package:customr/src/features/kundali/presentation/view/widgets/birth_details_sheet.dart';
import 'package:customr/src/features/kundali/presentation/widgets/k_kit.dart';
import 'package:astro_kundali/astro_kundali.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'kundali_fixtures.dart';

class _MockRepo extends Mock implements KundaliRepository {}

final _mood = DailyMood(
  date: '2026-09-15',
  mood: 'thoughtful',
  tone: 'tender',
  level: 2,
  houseFromMoon: 8,
  chandrashtama: true,
  headline: 'A quieter, more inward day — go gently with plans',
  why: 'The Moon passes the 8th from your birth Moon today.',
  tip: 'Keep the calendar light and finish one small thing.',
  locked: const [
    'Why this happens in your chart',
    'A remedy for today',
    'How your dasha colours it',
  ],
  moonSignLabel: 'Moon in Virgo',
  moonHouseLabel: '8th from your birth Moon',
  disclaimer: 'Moods are tendencies.',
  nextChangeAt: DateTime(2026, 9, 17, 14, 30),
);

void main() {
  setUpAll(() {
    registerKundaliTestDi();
    final repo = _MockRepo();
    when(
      () => repo.ashtakavarga(any()),
    ).thenAnswer((_) async => kAshtakavarga());
    when(() => repo.shadbala(any())).thenAnswer((_) async => kShadbala);
    when(() => repo.kp(any())).thenAnswer(
      (_) async => {
        'cuspal_sublords': {'1': 'Venus', '2': 'Mars', '10': 'Saturn'},
        'ruling_planets': ['Mars', 'Moon', 'Jupiter'],
        'engine': 'v1',
      },
    );
    when(() => repo.jaimini(any())).thenAnswer(
      (_) async => {
        'chara_karakas': {'atmakaraka': 'Venus', 'amatyakaraka': 'Jupiter'},
        'karakamsa': 'Pisces',
        'chara_dasha': [
          {'sign': 'Libra', 'years': 7.0},
        ],
      },
    );
    if (getIt.isRegistered<KundaliRepository>()) {
      getIt.unregister<KundaliRepository>();
    }
    getIt.registerSingleton<KundaliRepository>(repo);
  });

  final full = KundaliState(
    overview: AsyncValue.data(kKundaliWithBirth),
    insights: const AsyncValue.data(kInsights),
    mood: AsyncValue.data(_mood),
    remedies: const AsyncValue.data(kRemedies),
    jyotishUpaya: const AsyncValue.data(kUpaya),
    lalKitab: const AsyncValue.data(kLalKitab),
    numerology: const AsyncValue.data(kNumerology),
    varshphal: const AsyncValue.data(kVarshphal),
    muhurta: AsyncValue.data(kMuhurta()),
  );

  final pages = <String, Widget>{
    'insights': const InsightsPage(profileId: 'p1'),
    'mood': const MoodPage(profileId: 'p1'),
    'remedies': const RemediesPage(profileId: 'p1'),
    'jyotish upaya': const JyotishUpayaPage(profileId: 'p1'),
    'lal kitab': const LalKitabPage(profileId: 'p1'),
    'numerology': const NumerologyPage(profileId: 'p1'),
    'varshphal': const VarshphalPage(profileId: 'p1'),
    'muhurta': const MuhurtaPage(profileId: 'p1'),
    'advanced': const AdvancedPage(profileId: 'p1'),
  };

  for (final locale in const [Locale('en'), Locale('hi')]) {
    group('small phone · ${locale.languageCode}', () {
      usePhoneViewport();

      for (final e in pages.entries) {
        testWidgets('${e.key} — loaded', (tester) async {
          await pumpKundaliPage(tester, e.value, state: full, locale: locale);
          expect(tester.takeException(), isNull);
          await scrollThrough(tester);
        });
      }

      testWidgets('tool pages — loading', (tester) async {
        for (final page in pages.values) {
          await pumpKundaliPage(
            tester,
            page,
            state: const KundaliState(
              insights: AsyncValue.loading(),
              mood: AsyncValue.loading(),
              remedies: AsyncValue.loading(),
              jyotishUpaya: AsyncValue.loading(),
              lalKitab: AsyncValue.loading(),
              numerology: AsyncValue.loading(),
              varshphal: AsyncValue.loading(),
              muhurta: AsyncValue.loading(),
            ),
            locale: locale,
          );
          expect(tester.takeException(), isNull, reason: '$page');
        }
      });

      testWidgets('empty / unavailable states', (tester) async {
        await pumpKundaliPage(
          tester,
          const RemediesPage(profileId: 'p1'),
          state: full.copyWith(remedies: const AsyncValue.data(RemedyReport())),
          locale: locale,
        );
        expect(tester.takeException(), isNull);
        await pumpKundaliPage(
          tester,
          const LalKitabPage(profileId: 'p1'),
          state: full.copyWith(
            lalKitab: const AsyncValue.data(LalKitabReport(summary: 'Clear.')),
          ),
          locale: locale,
        );
        expect(tester.takeException(), isNull);
        await pumpKundaliPage(
          tester,
          const MuhurtaPage(profileId: 'p1'),
          state: full.copyWith(
            muhurta: AsyncValue.data(kMuhurta(available: false)),
          ),
          locale: locale,
        );
        expect(tester.takeException(), isNull);
      });

      testWidgets('muhurta — night and hora tables', (tester) async {
        await pumpKundaliPage(
          tester,
          const MuhurtaPage(profileId: 'p1'),
          state: full,
          locale: locale,
        );
        await tester.scrollUntilVisible(
          find.byType(KSegment),
          300,
          scrollable: find.byType(Scrollable).first,
        );
        await tester.pumpAndSettle();
        for (final i in [1, 2]) {
          final segment = find
              .descendant(
                of: find.byType(KSegment),
                matching: find.byType(Text),
              )
              .at(i);
          await tester.ensureVisible(segment);
          await tester.pumpAndSettle();
          await expectNoLayoutError(tester, () async {
            await tester.tap(segment);
            await tester.pumpAndSettle();
          });
          await scrollThrough(tester, steps: 4);
        }
      });

      for (final report in ['ashtakavarga', 'shadbala', 'kp', 'jaimini']) {
        testWidgets('advanced report — $report', (tester) async {
          await pumpKundaliPage(
            tester,
            AdvancedReportPage(profileId: 'p1', report: report),
            state: full,
            locale: locale,
          );
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
          await scrollThrough(tester);
        });
      }

      testWidgets('birth details sheet', (tester) async {
        await pumpKundaliPage(
          tester,
          Builder(
            builder: (context) => Scaffold(
              body: Center(
                child: TextButton(
                  onPressed: () => showBirthDetailsSheet(
                    context,
                    kundali: kKundaliWithBirth,
                  ),
                  child: const Text('open'),
                ),
              ),
            ),
          ),
          state: full,
          locale: locale,
        );
        await tester.tap(find.text('open'));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        await scrollThrough(tester, steps: 4);
      });
    });
  }
}
