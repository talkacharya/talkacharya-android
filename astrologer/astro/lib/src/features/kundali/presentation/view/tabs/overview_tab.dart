part of '../consultation_kundali_page.dart';

class _OverviewTab extends StatefulWidget {
  const _OverviewTab();
  @override
  State<_OverviewTab> createState() => _OverviewTabState();
}

class _OverviewTabState extends State<_OverviewTab> {
  @override
  void initState() {
    super.initState();
    context.read<KundaliCubit>().loadInsights();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<KundaliCubit, KundaliState>(
      builder: (context, state) => _Slice<OverviewReport>(
        slice: state.insights,
        onRetry: () => context.read<KundaliCubit>().loadInsights(),
        builder: (report) {
          final ordered = [
            for (final area in KundaliInsights.areaOrder) ?report.byArea(area),
          ];
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 28),
            children: [
              Text(
                KT.of(context).overviewIntro,
                style: TextStyle(
                  fontSize: 11.5,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12),
              for (final s in ordered) _OverviewSectionRow(section: s),
              if (report.disclaimer.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  report.disclaimer,
                  style: TextStyle(
                    fontSize: 10.5,
                    height: 1.35,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _OverviewSectionRow extends StatelessWidget {
  const _OverviewSectionRow({required this.section});
  final OverviewSection section;

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    final kt = KT.of(context);
    final chipText = kt.toneWord(section.tone);
    final chipColor = switch (section.tone) {
      'supportive' => const Color(0xFF1E7A3C),
      'challenging' => const Color(0xFFB0691F),
      'mixed' => const Color(0xFF3F4E86),
      _ => muted,
    };
    final factors = section.readingFactors
        .map(kt.factorText)
        .where((t) => t.isNotEmpty)
        .toList();

    return KundaliCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(KundaliInsights.icon(section.area), size: 15, color: muted),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  kt.areaTitle(section.area),
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13.5,
                  ),
                ),
              ),
              Text(
                '${section.strength}/3',
                style: TextStyle(fontSize: 10.5, color: muted),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: chipColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  chipText,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: chipColor,
                  ),
                ),
              ),
            ],
          ),
          if (section.summary.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              section.summary,
              style: const TextStyle(fontSize: 12, height: 1.4),
            ),
          ],
          if (factors.isNotEmpty) ...[
            const SizedBox(height: 6),
            for (final line in factors)
              Text(
                '· $line',
                style: TextStyle(fontSize: 11, height: 1.35, color: muted),
              ),
          ],
        ],
      ),
    );
  }
}
