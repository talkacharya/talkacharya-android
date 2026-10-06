part of '../consultation_kundali_page.dart';


class _RemediesTab extends StatefulWidget {
  const _RemediesTab();
  @override
  State<_RemediesTab> createState() => _RemediesTabState();
}

class _RemediesTabState extends State<_RemediesTab> {
  @override
  void initState() {
    super.initState();
    context.read<KundaliCubit>()
      ..loadRemedies()
      ..loadJyotishUpaya()
      ..loadLalKitab();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<KundaliCubit, KundaliState>(
      builder: (context, state) => _Slice<RemedyReport>(
        slice: state.remedies,
        onRetry: () => context.read<KundaliCubit>().loadRemedies(),
        builder: (report) => ListView(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 28),
          children: [
            Text(
              '${report.count} remedies matched to this chart\'s doshas, weak '
              'planets, dasha and afflicted houses. Gemstone / yantra / rudraksha '
              'entries are flagged — confirm before advising them.',
              style: TextStyle(
                fontSize: 11.5,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            for (final group in report.groups) ...[
              Text(
                RemedyCategoryInfo.label(group.category).toUpperCase(),
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 6),
              for (final r in group.items) _RemedyRow(remedy: r),
              const SizedBox(height: 10),
            ],
            const _UpayaBlock(),
            const _LalKitabBlock(),
          ],
        ),
      ),
    );
  }
}

class _LalKitabBlock extends StatelessWidget {
  const _LalKitabBlock();

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    return BlocBuilder<KundaliCubit, KundaliState>(
      buildWhen: (a, b) => a.lalKitab != b.lalKitab,
      builder: (context, state) {
        final r = state.lalKitab.value;
        if (r == null) return const SizedBox.shrink();
        return KundaliCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Lal Kitab — rin & totke',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
              ),
              if (r.summary.isNotEmpty) ...[
                const SizedBox(height: 3),
                Text(
                  r.summary,
                  style: TextStyle(fontSize: 10.5, height: 1.35, color: muted),
                ),
              ],
              const SizedBox(height: 5),
              for (final rin in r.activeRins)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    '· ${rin.name}\n  ${rin.remedy}',
                    style: const TextStyle(fontSize: 10.5, height: 1.4),
                  ),
                ),
              for (final m in r.mandaPlanets)
                Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Text(
                    '· ${m.summary} — ${m.remedy}',
                    style: TextStyle(
                      fontSize: 10.5,
                      height: 1.35,
                      color: muted,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _UpayaBlock extends StatelessWidget {
  const _UpayaBlock();

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    return BlocBuilder<KundaliCubit, KundaliState>(
      buildWhen: (a, b) => a.jyotishUpaya != b.jyotishUpaya,
      builder: (context, state) {
        final r = state.jyotishUpaya.value;
        if (r == null) return const SizedBox.shrink();
        return KundaliCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Upaya table — ${r.lagnaSign} lagna (${r.lagnaLord})',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Support: ${r.strengthen.join(", ")} · Pacify: ${r.pacify.join(", ")}'
                '${r.priorityPlanets.isNotEmpty ? " · Priority: ${r.priorityPlanets.join(", ")}" : ""}',
                style: TextStyle(fontSize: 10.5, height: 1.35, color: muted),
              ),
              const SizedBox(height: 6),
              for (final p in r.planets)
                Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Text(
                    '· ${p.planet} (${p.role}) — ${p.mantra}; gem ${p.gemstone} '
                    '(gated), rudraksha ${p.rudrakshaMukhi} (gated)',
                    style: TextStyle(
                      fontSize: 10.5,
                      height: 1.35,
                      color: muted,
                    ),
                  ),
                ),
              const SizedBox(height: 4),
              Text(
                r.gateNotice,
                style: const TextStyle(
                  fontSize: 10,
                  height: 1.35,
                  color: Color(0xFFB0691F),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _RemedyRow extends StatelessWidget {
  const _RemedyRow({required this.remedy});
  final Remedy remedy;

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    return KundaliCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  remedy.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
              if (remedy.gated)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFB0691F).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Text(
                    'confirm first',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFFB0691F),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(remedy.body, style: const TextStyle(fontSize: 12, height: 1.4)),
          if (remedy.caution.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              '⚠ ${remedy.caution}',
              style: const TextStyle(
                fontSize: 11,
                height: 1.35,
                color: Color(0xFFB0691F),
              ),
            ),
          ],
          const SizedBox(height: 2),
          Text(
            '${remedy.triggerType}:${remedy.triggerValue} · ${remedy.source}',
            style: TextStyle(fontSize: 10, color: muted),
          ),
        ],
      ),
    );
  }
}
