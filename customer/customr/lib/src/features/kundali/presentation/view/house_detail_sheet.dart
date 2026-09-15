import 'package:astro_kundali/astro_kundali.dart';
import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../shared/widgets/app_bottom_sheet.dart';
import '../kundali_terms.dart';
import '../widgets/kundali_ui.dart';

const _signLords = <String, String>{
  'Aries': 'Mars',
  'Taurus': 'Venus',
  'Gemini': 'Mercury',
  'Cancer': 'Moon',
  'Leo': 'Sun',
  'Virgo': 'Mercury',
  'Libra': 'Venus',
  'Scorpio': 'Mars',
  'Sagittarius': 'Jupiter',
  'Capricorn': 'Saturn',
  'Aquarius': 'Saturn',
  'Pisces': 'Jupiter',
};

Future<void> showHouseDetailSheet(
  BuildContext context, {
  required Kundali kundali,
  required int house,
}) {
  final ch = kundali.houses.firstWhere(
    (h) => h.house == house,
    orElse: () => ChartHouse(house: house, sign: ''),
  );
  final lord = _signLords[ch.sign] ?? '';
  final lordPlanet = kundali.planet(lord);
  final occupants = [
    for (final name in ch.planets) kundali.planet(name),
  ].whereType<NatalPlanet>().toList();

  final l = context.l10n;
  return showAppSheet<void>(
    context: context,
    title: l.kHouseSheetTitle(
      KTerms.ordinal(l, house),
      KTerms.signName(l, ch.sign),
    ),
    builder: (context) => SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.kHouseSheetSubtitle(
              KTerms.houseSanskrit(l, house),
              KTerms.house(l, house),
            ),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 7,
            runSpacing: 7,
            children: [
              if (lord.isNotEmpty)
                MetaChip(l.kHouseChipLord(KTerms.planetName(l, lord))),
              if (lordPlanet != null)
                MetaChip(
                  l.kHouseChipLordIn(KTerms.nthHouse(l, lordPlanet.house)),
                ),
              if (ch.sign.isNotEmpty) MetaChip(KTerms.sign(l, ch.sign)),
            ],
          ),
          const SizedBox(height: 14),
          if (occupants.isEmpty)
            KCard(
              child: Text(
                l.kHouseNoPlanets(
                  KTerms.planetName(l, lord),
                  lordPlanet != null
                      ? l.kHouseLordWhere(KTerms.nthHouse(l, lordPlanet.house))
                      : '',
                ),
                style: const TextStyle(fontSize: 13),
              ),
            )
          else
            KCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l.kHousePlanetsHeader,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 12.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  for (final p in occupants)
                    _PlanetRow(planet: p, house: house),
                ],
              ),
            ),
          const SizedBox(height: 12),
          ReadingCard(
            title: l.kWhatThisMeans,
            body: _reading(l, house, lord, lordPlanet, occupants),
          ),
          const SizedBox(height: 14),
          AskAstrologerBar(
            label: l.kHouseAskCta(KTerms.ordinal(l, house)),
            onTap: () {},
          ),
          const SizedBox(height: 8),
        ],
      ),
    ),
  );
}

String _reading(
  AppLocalizations l,
  int house,
  String lord,
  NatalPlanet? lordPlanet,
  List<NatalPlanet> occupants,
) {
  final parts = <String>[];
  final houseTheme = KTerms.house(l, house).toLowerCase();
  if (lordPlanet != null) {
    parts.add(
      l.kHouseReadingLord(
        KTerms.ordinal(l, house),
        KTerms.planetName(l, lord),
        KTerms.nthHouse(l, lordPlanet.house),
        houseTheme,
        KTerms.house(l, lordPlanet.house).toLowerCase(),
      ),
    );
  }
  for (final p in occupants) {
    parts.add(
      l.kHouseReadingOccupant(
        KTerms.planetName(l, p.name),
        KTerms.planet(l, p.name),
        houseTheme,
      ),
    );
  }
  if (parts.isEmpty) parts.add(l.kHouseReadingEmpty);
  return parts.join(' ');
}

class _PlanetRow extends StatelessWidget {
  const _PlanetRow({required this.planet, required this.house});
  final NatalPlanet planet;
  final int house;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final name = KTerms.planetName(l, planet.name);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 26,
            height: 26,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: planetColor(planet.name),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              name.length >= 2 ? name.substring(0, 2) : name,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 10,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$name — ${planet.degree.toStringAsFixed(0)}° '
                  '${KTerms.signName(l, planet.sign)}'
                  '${planet.retrograde ? ' ℞' : ''}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                Text(
                  KTerms.dignity(l, planet.dignity),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
