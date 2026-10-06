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
                'Descriptive D1 read — the free "at a glance" the client also '
                'sees. Tendencies, not a forecast.',
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
    final (chipText, chipColor) = switch (section.tone) {
      'supportive' => ('supportive', const Color(0xFF1E7A3C)),
      'challenging' => ('needs care', const Color(0xFFB0691F)),
      'mixed' => ('mixed', const Color(0xFF3F4E86)),
      _ => ('balanced', muted),
    };
    final factors = section.readingFactors
        .map(KundaliInsights.factorText)
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
                  KundaliInsights.title(section.area),
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
