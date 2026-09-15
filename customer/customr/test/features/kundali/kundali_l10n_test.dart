import 'package:astro_kundali/astro_kundali.dart';
import 'package:customr/src/core/l10n/gen/app_localizations.dart';
import 'package:customr/src/features/kundali/presentation/kundali_terms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _pump(WidgetTester tester, Locale locale, Widget child) {
  return tester.pumpWidget(
    MaterialApp(
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: KundaliL10nScope(
        child: Scaffold(body: SingleChildScrollView(child: child)),
      ),
    ),
  );
}

const _chart = VargaChart(
  chartType: 'd9',
  name: 'Navamsha',
  signifies: 'Spouse, dharma, inner self — the primary support chart',
  ascendantSign: 'Libra',
  planets: [
    ChartPlacement(name: 'Sun', sign: 'Aries', house: 7),
    ChartPlacement(name: 'Moon', sign: 'Libra', house: 1),
  ],
);

void main() {
  testWidgets('chart widgets render Hindi names and labels', (tester) async {
    await _pump(
      tester,
      const Locale('hi'),
      Column(
        children: [
          ChartStyleToggle(style: ChartStyle.north, onChanged: (_) {}),
          const ChartDetails(vc: _chart, fallbackTitle: 'D9'),
          const PlanetTable(vc: _chart),
          const ChartLegend(),
        ],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('उत्तर भारतीय'), findsOneWidget);
    expect(find.text('नवमांश'), findsOneWidget);
    expect(find.textContaining('लग्न · तुला'), findsOneWidget);
    expect(find.text('ग्रह'), findsOneWidget);
    expect(find.text('सूर्य'), findsOneWidget);
    expect(find.text('मेष'), findsOneWidget);
    expect(find.text('संकेत'), findsOneWidget);
    expect(find.text('सू · सूर्य'), findsOneWidget);
    expect(find.textContaining('North'), findsNothing);
    expect(find.textContaining('Navamsha'), findsNothing);
  });

  testWidgets('chart widgets stay English in English', (tester) async {
    await _pump(
      tester,
      const Locale('en'),
      Column(
        children: [
          ChartStyleToggle(style: ChartStyle.north, onChanged: (_) {}),
          const ChartDetails(vc: _chart, fallbackTitle: 'D9'),
          const PlanetTable(vc: _chart),
        ],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('North Indian'), findsOneWidget);
    expect(find.text('Navamsha'), findsOneWidget);
    expect(find.text('PLANET'), findsOneWidget);
    expect(find.text('Sun'), findsOneWidget);
  });

  test('name lookups fall back to the payload text for unknown keys', () {
    final hi = lookupAppLocalizations(const Locale('hi'));
    expect(KTerms.signName(hi, 'Scorpio'), 'वृश्चिक');
    expect(KTerms.nakshatraName(hi, 'Purva Phalguni'), 'पूर्व फाल्गुनी');
    expect(KTerms.planetName(hi, 'Jupiter'), 'गुरु');
    expect(KTerms.chartName(hi, 'bhava_chalit', 'x'), 'भाव चलित');
    expect(KTerms.chartName(hi, 'd99', 'Custom'), 'Custom');
    expect(KTerms.signName(hi, 'Ophiuchus'), 'Ophiuchus');
    expect(hi.kBdTara('AtiMitra', 'Ati Mitra'), 'अति मित्र');
    expect(hi.kBdTithi('Unknown', 'Unknown'), 'Unknown');
  });
}
