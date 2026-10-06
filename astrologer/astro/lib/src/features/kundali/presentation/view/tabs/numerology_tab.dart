part of '../consultation_kundali_page.dart';

class _NumerologyTab extends StatefulWidget {
  const _NumerologyTab();
  @override
  State<_NumerologyTab> createState() => _NumerologyTabState();
}

class _NumerologyTabState extends State<_NumerologyTab> {
  @override
  void initState() {
    super.initState();
    context.read<KundaliCubit>().loadNumerology();
  }

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    final kt = KT.of(context);
    return BlocBuilder<KundaliCubit, KundaliState>(
      builder: (context, state) => _Slice<NumerologyReport>(
        slice: state.numerology,
        onRetry: () => context.read<KundaliCubit>().loadNumerology(),
        builder: (report) => ListView(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 28),
          children: [
            Text(
              kt.numerologyIntro,
              style: TextStyle(fontSize: 11.5, color: muted),
            ),
            const SizedBox(height: 12),
            for (final n in report.numbers)
              KundaliCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${kt.term(n.kind)} · ${n.value}  '
                      '(${kt.term(n.planet)})',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                    if (n.summary.isNotEmpty) ...[
                      const SizedBox(height: 5),
                      Text(
                        n.summary,
                        style: const TextStyle(fontSize: 12, height: 1.4),
                      ),
                    ],
                    const SizedBox(height: 5),
                    Text(
                      '${kt.friendly} ${n.friendly.join(", ")} · '
                      '${kt.clashing} ${n.unfriendly.join(", ")} · '
                      '${kt.days} ${kt.terms(n.days)} · '
                      '${kt.colours} ${kt.terms(n.colours)}',
                      style: TextStyle(
                        fontSize: 10.5,
                        height: 1.35,
                        color: muted,
                      ),
                    ),
                    if (n.gemstone.isNotEmpty)
                      Text(
                        '${kt.gemstoneGated}: ${kt.term(n.gemstone)} — '
                        '${n.gemstoneNote}',
                        style: const TextStyle(
                          fontSize: 10.5,
                          height: 1.35,
                          color: Color(0xFFB0691F),
                        ),
                      ),
                  ],
                ),
              ),
            if (report.combination.isNotEmpty)
              KundaliCard(
                child: Text(
                  report.combination,
                  style: const TextStyle(fontSize: 12, height: 1.4),
                ),
              ),
            KundaliCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    kt.loShu,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      for (final line in report.loShu.lines.where(
                        (x) => x.status != 'partial',
                      ))
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color:
                                (line.status == 'strength'
                                        ? const Color(0xFF1E7A3C)
                                        : const Color(0xFFB0691F))
                                    .withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            '${line.status == "strength" ? "✓" : "–"} '
                            '${kt.term(line.name)}',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: line.status == 'strength'
                                  ? const Color(0xFF1E7A3C)
                                  : const Color(0xFFB0691F),
                            ),
                          ),
                        ),
                    ],
                  ),
                  if (report.loShu.summary.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      report.loShu.summary,
                      style: TextStyle(fontSize: 11, height: 1.4, color: muted),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
