import 'package:astro_kundali/astro_kundali.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/l10n/l10n.dart';
import '../cubit/kundali_cubit.dart';
import '../kundali_terms.dart';
import '../widgets/kundali_ui.dart';

class PlanetsPage extends StatefulWidget {
  const PlanetsPage({required this.profileId, super.key});
  final String profileId;

  @override
  State<PlanetsPage> createState() => _PlanetsPageState();
}

class _PlanetsPageState extends State<PlanetsPage> {
  final _expanded = <String>{'Moon'};

  @override
  void initState() {
    super.initState();
    context.read<KundaliCubit>().loadOverview();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.kFcPlanets)),
      body: BlocBuilder<KundaliCubit, KundaliState>(
        builder: (context, state) => SliceBuilder<Kundali>(
          slice: state.overview,
          onRetry: () => context.read<KundaliCubit>().loadOverview(force: true),
          builder: (context, k) {
            final byName = {for (final p in k.planets) p.name: p};
            final ordered = [
              for (final name in planetOrder)
                if (byName[name] != null) byName[name]!,
            ];
            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
              children: [
                Text(
                  context.l10n.kPlanetsIntro,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 12),
                for (final p in ordered) ...[
                  _PlanetCard(
                    planet: p,
                    house: k.houseForSign(p.sign) ?? p.house,
                    expanded: _expanded.contains(p.name),
                    onToggle: () => setState(() {
                      _expanded.contains(p.name)
                          ? _expanded.remove(p.name)
                          : _expanded.add(p.name);
                    }),
                  ),
                  const SizedBox(height: 10),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

class _PlanetCard extends StatelessWidget {
  const _PlanetCard({
    required this.planet,
    required this.house,
    required this.expanded,
    required this.onToggle,
  });

  final NatalPlanet planet;
  final int house;
  final bool expanded;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l = context.l10n;
    final name = KTerms.planetName(l, planet.name);
    return KCard(
      padding: EdgeInsets.zero,
      child: InkWell(
        onTap: onToggle,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: planetColor(planet.name),
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: Text(
                      name.length >= 2 ? name.substring(0, 2) : name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                '· ${KTerms.planet(context.l10n, planet.name).split(',').first}',
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: scheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          l.kPlanetRowMeta(
                                KTerms.signName(l, planet.sign),
                                KTerms.nthHouse(l, house),
                                planet.degree.toStringAsFixed(0),
                              ) +
                              (planet.nakshatra.isNotEmpty
                                  ? ' · ${KTerms.nakshatraName(l, planet.nakshatra)}'
                                  : ''),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _DignityBadge(dignity: planet.dignity),
                  if (planet.retrograde) ...[
                    const SizedBox(width: 4),
                    const _Pill('℞'),
                  ],
                  const SizedBox(width: 4),
                  Icon(
                    expanded
                        ? Icons.expand_less_rounded
                        : Icons.expand_more_rounded,
                    color: scheme.onSurfaceVariant,
                    size: 20,
                  ),
                ],
              ),
              if (expanded) ...[
                const SizedBox(height: 12),
                Text(
                  KTerms.dignity(context.l10n, planet.dignity),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12.5,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  KTerms.planetInSignHouse(
                    context.l10n,
                    planet.name,
                    planet.sign,
                    house,
                  ),
                  style: const TextStyle(fontSize: 13.5, height: 1.45),
                ),
                if (planet.combust) ...[
                  const SizedBox(height: 6),
                  Text(
                    context.l10n.kCombustNote,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _DignityBadge extends StatelessWidget {
  const _DignityBadge({required this.dignity});
  final String dignity;

  @override
  Widget build(BuildContext context) {
    final (fg, bg) = switch (dignity) {
      'exalted' ||
      'moolatrikona' ||
      'own' => (const Color(0xFF1E7A3C), const Color(0xFFE4F3E8)),
      'debilitated' => (const Color(0xFFB5302A), const Color(0xFFFBE3E1)),
      'enemy_sign' ||
      'great_enemy_sign' => (const Color(0xFFB0691F), const Color(0xFFFBEEDD)),
      _ => (Colors.transparent, Colors.transparent),
    };
    final label = KTerms.dignityShort(context.l10n, dignity);
    if (label.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
          color: fg,
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill(this.text);
  final String text;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFFEDE7F7),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
          color: Color(0xFF5B34B0),
        ),
      ),
    );
  }
}
