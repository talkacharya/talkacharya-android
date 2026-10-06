part of '../consultation_kundali_page.dart';

class _PlanetsTab extends StatefulWidget {
  const _PlanetsTab();
  @override
  State<_PlanetsTab> createState() => _PlanetsTabState();
}

class _PlanetsTabState extends State<_PlanetsTab> {
  @override
  void initState() {
    super.initState();
    context.read<KundaliCubit>().loadOverview();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<KundaliCubit, KundaliState>(
      builder: (context, state) => _Slice<Kundali>(
        slice: state.overview,
        onRetry: () => context.read<KundaliCubit>().loadOverview(),
        builder: (k) {
          final scheme = Theme.of(context).colorScheme;
          final kt = KT.of(context);
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 28),
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: [
                  KundaliChip('${kt.lagna} · ${kt.term(k.lagnaSign)}'),
                  KundaliChip('${kt.moon} · ${kt.term(k.moonSign)}'),
                  KundaliChip('${kt.sun} · ${kt.term(k.sunSign)}'),
                  if (k.nakshatra.isNotEmpty)
                    KundaliChip(
                      '${kt.nakshatra} · ${kt.term(k.nakshatra)}',
                    ),
                ],
              ),
              const SizedBox(height: 14),
              KundaliCard(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                child: Column(
                  children: [
                    for (final p in k.planets) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 9),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 78,
                              child: Row(
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: planetColor(p.name),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    kt.term(p.name),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12.5,
                                    ),
                                  ),
                                  if (p.retrograde)
                                    const Text(
                                      ' ℞',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Text(
                                '${kt.term(p.sign)}  '
                                '${p.degree.toStringAsFixed(1)}°',
                                style: const TextStyle(fontSize: 12.5),
                              ),
                            ),
                            SizedBox(
                              width: 42,
                              child: Text(
                                kt.h(p.house),
                                textAlign: TextAlign.end,
                                style: const TextStyle(fontSize: 12.5),
                              ),
                            ),
                            SizedBox(
                              width: 74,
                              child: Text(
                                kt.term(p.dignity),
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                  fontSize: 11,
                                  color:
                                      p.dignity == 'exalted' ||
                                          p.dignity == 'own' ||
                                          p.dignity == 'moolatrikona'
                                      ? scheme.primary
                                      : p.dignity == 'debilitated'
                                      ? scheme.error
                                      : scheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (p != k.planets.last)
                        Divider(height: 1, color: scheme.outlineVariant),
                    ],
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
