part of '../consultation_kundali_page.dart';

class _DashaTab extends StatefulWidget {
  const _DashaTab();
  @override
  State<_DashaTab> createState() => _DashaTabState();
}

class _DashaTabState extends State<_DashaTab> {
  @override
  void initState() {
    super.initState();
    context.read<KundaliCubit>()
      ..loadDasha()
      ..loadDashaNarrative();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<KundaliCubit, KundaliState>(
      builder: (context, state) => _Slice<DashaTimeline>(
        slice: state.dasha,
        onRetry: () => context.read<KundaliCubit>().loadDasha(),
        builder: (d) {
          final now = DateTime.now();
          final narrative = state.dashaNarrative.value;
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 28),
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: [
                  KundaliChip('Running · ${d.currentMaha} / ${d.currentAntar}'),
                  if (d.balanceLord.isNotEmpty)
                    KundaliChip(
                      'Balance · ${d.balanceLord} '
                      '${d.balanceYears.toStringAsFixed(1)}y',
                    ),
                ],
              ),
              const SizedBox(height: 12),
              for (final maha in d.periods)
                KundaliCard(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  child: ExpansionTile(
                    tilePadding: EdgeInsets.zero,
                    childrenPadding: const EdgeInsets.only(bottom: 8),
                    initiallyExpanded: maha.contains(now),
                    title: Text(
                      '${maha.lord}  ·  ${_y(maha.start)}–${_y(maha.end)}',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13.5,
                        color: maha.contains(now)
                            ? Theme.of(context).colorScheme.primary
                            : null,
                      ),
                    ),
                    children: [
                      if ((narrative?.mahaFor(maha.lord)?.summary ?? '')
                          .isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Text(
                            narrative!.mahaFor(maha.lord)!.summary,
                            style: const TextStyle(fontSize: 11.5, height: 1.4),
                          ),
                        ),
                      for (final antar in maha.children)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  antar.lord,
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: antar.contains(now)
                                        ? FontWeight.w700
                                        : FontWeight.w400,
                                  ),
                                ),
                              ),
                              Text(
                                '${_d(antar.start)} – ${_d(antar.end)}',
                                style: const TextStyle(fontSize: 11.5),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  String _y(DateTime d) => '${d.year}';
  String _d(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
}
