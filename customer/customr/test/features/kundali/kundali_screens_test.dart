// Every redesigned kundali screen at a small phone size in English and Hindi:
// no overflow / build exception from the hero to the bottom of the page.
import 'package:customr/src/core/util/async_value.dart';
import 'package:customr/src/features/kundali/presentation/cubit/kundali_cubit.dart';
import 'package:astro_kundali/astro_kundali.dart';
import 'package:customr/src/features/kundali/presentation/view/bhava_page.dart';
import 'package:customr/src/features/kundali/presentation/view/chart_detail_page.dart';
import 'package:customr/src/features/kundali/presentation/view/dasha_page.dart';
import 'package:customr/src/features/kundali/presentation/view/full_chart_page.dart';
import 'package:customr/src/features/kundali/presentation/view/kundali_overview_page.dart';
import 'package:customr/src/features/kundali/presentation/view/planets_page.dart';
import 'package:customr/src/features/kundali/presentation/view/sade_sati_page.dart';
import 'package:customr/src/features/kundali/presentation/view/transits_page.dart';
import 'package:customr/src/features/kundali/presentation/view/yogas_doshas_page.dart';
import 'package:customr/src/features/kundali/presentation/widgets/k_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'kundali_fixtures.dart';

void main() {
  setUpAll(registerKundaliTestDi);

  final full = KundaliState(
    overview: AsyncValue.data(kKundali),
    navamsa: AsyncValue.data(kHouses),
    dasha: AsyncValue.data(kDasha()),
    allDashas: AsyncValue.data(kAllDashas()),
    dashaNarrative: const AsyncValue.data(kDashaNarrative),
    transits: const AsyncValue.data(kTransitsFull),
    avTransit: const AsyncValue.data(kAvTransit),
    sadeSati: const AsyncValue.data(kSadeSati),
    bhava: AsyncValue.data(kBhava),
    doshas: const AsyncValue.data(kDoshas),
    yogas: const AsyncValue.data(kYogas),
    chartTypes: const AsyncValue.data(kChartMenu),
    charts: {
      for (final t in [...FullChartPage.essentials, 'd7'])
        t: AsyncValue.data(kVarga(t)),
    },
  );

  for (final locale in const [Locale('en'), Locale('hi')]) {
    group('small phone · ${locale.languageCode}', () {
      usePhoneViewport();

      testWidgets('overview — loaded', (tester) async {
        await pumpKundaliPage(
          tester,
          const KundaliOverviewPage(profileId: 'p1'),
          state: full,
          locale: locale,
        );
        expect(tester.takeException(), isNull);
        await scrollThrough(tester);
      });

      testWidgets('full chart — every essential page', (tester) async {
        await pumpKundaliPage(
          tester,
          const FullChartPage(profileId: 'p1'),
          state: full,
          locale: locale,
        );
        expect(tester.takeException(), isNull);
        for (var i = 1; i < FullChartPage.essentials.length; i++) {
          await tester.drag(find.byType(PageView), const Offset(-400, 0));
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
        }
        await scrollThrough(tester);
        // open the all-charts menu
        final menu = find.byIcon(Icons.grid_view_rounded).first;
        await tester.ensureVisible(menu);
        await tester.pumpAndSettle();
        await tester.tap(menu);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });

      for (final type in ['d1', 'd7', 'bhava_chalit', 'transit']) {
        testWidgets('chart detail — $type (+ house sheet)', (tester) async {
          await pumpKundaliPage(
            tester,
            ChartDetailPage(profileId: 'p1', type: type),
            state: full,
            locale: locale,
          );
          expect(tester.takeException(), isNull);
          await scrollThrough(tester);
          if (type == 'd1') {
            final tile = find.text('10').last;
            await tester.ensureVisible(tile);
            await tester.tap(tile);
            await tester.pumpAndSettle();
            expect(tester.takeException(), isNull);
            await scrollThrough(tester, steps: 3);
          }
        });
      }

      testWidgets('planets', (tester) async {
        await pumpKundaliPage(
          tester,
          const PlanetsPage(profileId: 'p1'),
          state: full,
          locale: locale,
        );
        expect(tester.takeException(), isNull);
        await scrollThrough(tester);
      });

      for (final system in [0, 1]) {
        testWidgets('dasha — system $system', (tester) async {
          await pumpKundaliPage(
            tester,
            const DashaPage(profileId: 'p1'),
            state: full,
            locale: locale,
          );
          expect(tester.takeException(), isNull);
          if (system > 0) await _tapSegment(tester, system);
          await scrollThrough(tester);
        });
      }

      testWidgets('bhava', (tester) async {
        await pumpKundaliPage(
          tester,
          const BhavaPage(profileId: 'p1'),
          state: full,
          locale: locale,
        );
        expect(tester.takeException(), isNull);
        await scrollThrough(tester);
      });

      for (final tab in [0, 1]) {
        testWidgets('yogas & doshas — tab $tab', (tester) async {
          await pumpKundaliPage(
            tester,
            const YogasDoshasPage(profileId: 'p1'),
            state: full,
            locale: locale,
          );
          expect(tester.takeException(), isNull);
          if (tab > 0) await _tapSegment(tester, tab);
          await scrollThrough(tester);
        });
      }

      testWidgets('transits (sade sati active)', (tester) async {
        await pumpKundaliPage(
          tester,
          const TransitsPage(profileId: 'p1'),
          state: full,
          locale: locale,
        );
        expect(tester.takeException(), isNull);
        await scrollThrough(tester);
      });

      testWidgets('transits (panoti, then quiet sky)', (tester) async {
        await pumpKundaliPage(
          tester,
          const TransitsPage(profileId: 'p1'),
          state: full.copyWith(
            transits: AsyncValue.data(
              kTransitsFull.copyWith(
                sadeSatiActive: false,
                smallPanotiActive: true,
                smallPanotiType: 'Ashtama',
              ),
            ),
          ),
          locale: locale,
        );
        expect(tester.takeException(), isNull);
        await scrollThrough(tester);
        await pumpKundaliPage(
          tester,
          const TransitsPage(profileId: 'p1'),
          state: full.copyWith(
            transits: AsyncValue.data(
              kTransitsFull.copyWith(sadeSatiActive: false),
            ),
          ),
          locale: locale,
        );
        expect(tester.takeException(), isNull);
      });

      testWidgets('sade sati calendar — running and clear', (tester) async {
        await pumpKundaliPage(
          tester,
          const SadeSatiPage(profileId: 'p1'),
          state: full,
          locale: locale,
        );
        expect(tester.takeException(), isNull);
        await scrollThrough(tester);
        await pumpKundaliPage(
          tester,
          const SadeSatiPage(profileId: 'p1'),
          state: full.copyWith(
            sadeSati: const AsyncValue.data(
              SadeSatiCalendar(
                natalMoonSign: 'Leo',
                summary: 'No Sade Sati now.',
              ),
            ),
          ),
          locale: locale,
        );
        expect(tester.takeException(), isNull);
      });

      testWidgets('phase D pages — loading', (tester) async {
        for (final page in const [
          PlanetsPage(profileId: 'p1'),
          DashaPage(profileId: 'p1'),
          BhavaPage(profileId: 'p1'),
          YogasDoshasPage(profileId: 'p1'),
          TransitsPage(profileId: 'p1'),
          SadeSatiPage(profileId: 'p1'),
        ]) {
          await pumpKundaliPage(
            tester,
            page,
            state: const KundaliState(
              overview: AsyncValue.loading(),
              dasha: AsyncValue.loading(),
              bhava: AsyncValue.loading(),
              doshas: AsyncValue.loading(),
              yogas: AsyncValue.loading(),
              transits: AsyncValue.loading(),
              sadeSati: AsyncValue.loading(),
            ),
            locale: locale,
          );
          expect(tester.takeException(), isNull, reason: '$page');
        }
      });

      testWidgets('overview — loading and error', (tester) async {
        await pumpKundaliPage(
          tester,
          const KundaliOverviewPage(profileId: 'p1'),
          state: const KundaliState(overview: AsyncValue.loading()),
          locale: locale,
        );
        expect(tester.takeException(), isNull);
        await pumpKundaliPage(
          tester,
          const KundaliOverviewPage(profileId: 'p1'),
          state: const KundaliState(overview: AsyncValue.error('boom')),
          locale: locale,
        );
        expect(tester.takeException(), isNull);
      });
    });
  }
}

/// Taps option [index] of the hero's dark segmented control.
Future<void> _tapSegment(WidgetTester tester, int index) async {
  final option = find
      .descendant(of: find.byType(KDarkSegment), matching: find.byType(Text))
      .at(index);
  await expectNoLayoutError(tester, () async {
    await tester.tap(option);
    await tester.pumpAndSettle();
  });
}
