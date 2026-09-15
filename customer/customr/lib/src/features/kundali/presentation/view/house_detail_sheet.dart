import 'package:astro_kundali/astro_kundali.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/astro_palette.dart';
import '../../../../core/theme/brand_colors.dart';
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

/// One house of the birth chart: its sign and lord, who sits in it, and a
/// plain-language reading.
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

  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    backgroundColor: Theme.of(context).colorScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (sheet) {
      final l = sheet.l10n;
      final theme = Theme.of(sheet);
      final hue = kSignHue(ch.sign);
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.72,
        maxChildSize: 0.94,
        builder: (sheet, controller) => ListView(
          controller: controller,
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
          children: [
            Row(
              children: [
                Container(
                  width: 58,
                  height: 58,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    gradient: hue.linear(),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: hue.start.withValues(alpha: 0.35),
                        blurRadius: 14,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Text(
                    '$house',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l.kHouseSheetTitle(
                          KTerms.ordinal(l, house),
                          KTerms.signName(l, ch.sign),
                        ),
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        l.kHouseSheetSubtitle(
                          KTerms.houseSanskrit(l, house),
                          KTerms.house(l, house),
                        ),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: sheet.brand.inkMuted,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                if (lord.isNotEmpty)
                  Expanded(
                    child: _Fact(
                      hue: kPlanetHue(lord),
                      leading: PlanetBadge(lord, size: 30),
                      label: l.kHouseChipLord(KTerms.planetName(l, lord)),
                      value: lordPlanet == null
                          ? ''
                          : l.kHouseChipLordIn(
                              KTerms.nthHouse(l, lordPlanet.house),
                            ),
                    ),
                  ),
                if (lord.isNotEmpty && ch.sign.isNotEmpty)
                  const SizedBox(width: 8),
                if (ch.sign.isNotEmpty)
                  Expanded(
                    child: _Fact(
                      hue: hue,
                      leading: KIconBox(
                        icon: Icons.auto_awesome_rounded,
                        hue: hue,
                        size: 30,
                      ),
                      label: KTerms.signName(l, ch.sign),
                      value: KTerms.sign(l, ch.sign),
                    ),
                  ),
              ],
            ),
            KSection(
              title: l.kHousePlanetsHeader,
              hue: AstroPalette.money,
              padTop: 18,
              child: occupants.isEmpty
                  ? KSurface(
                      child: Text(
                        l.kHouseNoPlanets(
                          KTerms.planetName(l, lord),
                          lordPlanet != null
                              ? l.kHouseLordWhere(
                                  KTerms.nthHouse(l, lordPlanet.house),
                                )
                              : '',
                        ),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          height: 1.45,
                        ),
                      ),
                    )
                  : KSurface(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 4,
                      ),
                      child: Column(
                        children: [
                          for (var i = 0; i < occupants.length; i++) ...[
                            if (i > 0)
                              Divider(height: 1, color: sheet.brand.hairline),
                            _PlanetRow(planet: occupants[i]),
                          ],
                        ],
                      ),
                    ),
            ),
            const SizedBox(height: 12),
            ReadingCard(
              title: l.kWhatThisMeans,
              hue: hue,
              body: _reading(l, house, lord, lordPlanet, occupants),
            ),
            KAskCta(
              title: l.kHouseAskCta(KTerms.ordinal(l, house)),
              onTap: () {
                final router = GoRouter.of(context);
                Navigator.of(sheet).pop();
                router.go(Routes.astrologers);
              },
            ),
          ],
        ),
      );
    },
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

class _Fact extends StatelessWidget {
  const _Fact({
    required this.hue,
    required this.leading,
    required this.label,
    required this.value,
  });

  final AstroHue hue;
  final Widget leading;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return KHueCard(
      hue: hue,
      radius: 16,
      padding: const EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          leading,
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if (value.isNotEmpty)
                  Text(
                    value,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: context.brand.inkMuted,
                      height: 1.3,
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

class _PlanetRow extends StatelessWidget {
  const _PlanetRow({required this.planet});
  final NatalPlanet planet;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        children: [
          PlanetBadge(planet.name, size: 36),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${KTerms.planetName(l, planet.name)}'
                  '${planet.retrograde ? ' ℞' : ''}',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  '${planet.degree.toStringAsFixed(0)}° '
                  '${KTerms.signName(l, planet.sign)}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: context.brand.inkMuted,
                  ),
                ),
              ],
            ),
          ),
          KToneChip(
            KTerms.dignity(l, planet.dignity),
            tone: switch (planet.dignity) {
              'exalted' || 'own' || 'moolatrikona' => KTone.good,
              'debilitated' || 'enemy' || 'great_enemy' => KTone.bad,
              _ => KTone.neutral,
            },
          ),
        ],
      ),
    );
  }
}
